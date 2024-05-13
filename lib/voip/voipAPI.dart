import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

//Desenvolvido por HeroRickyGames

class audioStream extends StatefulWidget {
  String user = "";
  String password = "";
  String ip = "";
  int porta;
  int canal;
  audioStream(this.user, this.password, this.ip, this.porta, this.canal, {super.key});

  @override
  State<audioStream> createState() => _audioStreamState();
}

class _audioStreamState extends State<audioStream> {
  late final player = Player();
  late final controller = VideoController(player);

  @override
  void initState() {
    MediaKit.ensureInitialized();
    super.initState();
  }

  openPlayer() async {
    player.open(Media('rtsp://${widget.user}:${widget.password}@${widget.ip}:${widget.porta}/cam/realmonitor?channel=${widget.canal}&subtype='));
    await player.setAudioTrack(AudioTrack.auto());
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
      return Center(
        child: Stack(
          children: [
            SizedBox(
                height: 150,
                width: constrains.maxWidth,
                child: Video(
                    controller: controller,
                    controls: MaterialVideoControls
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: (){
                  dispose();
                },
                  icon: const Icon(Icons.close),
                )
              ],
            ),
          ],
        ),
      );
    }
    );
  }
}