import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

//Desenvolvido por HeroRickyGames

class videoStream extends StatefulWidget {

  //Strings
  String user = "";
  String password = "";
  String ip = "";
  String Modelo = "";

  //Inteiros
  int porta;
  int? canal;

  videoStream(this.user, this.password, this.ip, this.porta, this.canal, this.Modelo, {super.key});

  @override
  State<videoStream> createState() => _videoStreamState();
}

class _videoStreamState extends State<videoStream> {
  late final player = Player();
  late final controller = VideoController(player);

  @override
  void initState() {
    MediaKit.ensureInitialized();
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    openPlayer() async {
      if(widget.Modelo == "Intelbras"){
        player.open(Media('rtsp://${widget.user}:${widget.password}@${widget.ip}:${widget.porta}/cam/realmonitor?channel=${widget.canal}&subtype=1'));
        player.setVolume(0);
      }
      if(widget.Modelo == "Intelbras UDP"){
        player.open(Media('tcp://${widget.user}:${widget.password}@${widget.ip}:${widget.porta}/cam/realmonitor?channel=${widget.canal}&subtype=1'));
        player.setVolume(0);
      }
    }

    openPlayer();

    return LayoutBuilder(builder: (context, constrains){
      return SizedBox(
          height: constrains.maxHeight,
          width: constrains.maxWidth,
          child: Video(
              controller: controller,
              controls: null,
              fit: BoxFit.fill,
          )
      );
    }
    );
  }
}