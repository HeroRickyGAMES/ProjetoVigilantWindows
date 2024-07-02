import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

//Desenvolvido por HeroRickyGames

class videoStreamAlert extends StatefulWidget {

  //Strings
  String user = "";
  String password = "";
  String ip = "";

  //Inteiros
  int porta;
  int canal;
  videoStreamAlert(this.user, this.password, this.ip, this.porta, this.canal, {super.key});

  @override
  State<videoStreamAlert> createState() => _videoStreamAlertState();
}

class _videoStreamAlertState extends State<videoStreamAlert> {
  late final player = Player();
  late final controller = VideoController(player);

  @override
  void initState() {
    MediaKit.ensureInitialized();
    super.initState();
  }

  openPlayer(){
    player.open(Media('rtsp://${widget.user}:${widget.password}@${widget.ip}:${widget.porta}/cam/realmonitor?channel=${widget.canal}&subtype=1'));
    player.setVolume(0);
  }


  @override
  void dispose() {
    player.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    openPlayer();

    return LayoutBuilder(builder: (context, constrains){
      return SizedBox(
        height: constrains.maxHeight,
        width: constrains.maxWidth,
        child: Video(
            filterQuality: FilterQuality.high,
            controller: controller,
            fit: BoxFit.fill,
            controls: null
        ),
      );
    }
    );
  }
}