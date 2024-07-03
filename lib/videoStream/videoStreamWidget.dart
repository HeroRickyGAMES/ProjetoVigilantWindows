import 'package:flutter/material.dart';
import 'package:vigilant/videoStream/VideoStreamAlert.dart';
import 'package:vigilant/videoStream/videoStream.dart';

//Desenvolvido por HeroRickyGames

class VideoStreamWidget extends StatefulWidget {
  String ip = "";
  int porta = 00;
  String user = "";
  String pass = "";
  Color corDasBarras;
  double wid;
  double heig;
  VideoStreamWidget(this.ip, this.porta, this.user, this.pass, this.corDasBarras, this.wid, this.heig, {super.key});

  @override
  State<VideoStreamWidget> createState() => _VideoStreamWidgetState();
}

//Inteiros
int colunasIPCamera = 3;
int CFTV = 0;
int camera1 = 1;
int camera2 = 2;
int camera3 = 3;
int camera4 = 4;
int camera5 = 5;
int camera6 = 6;
int camera7 = 7;
int camera8 = 8;
int camera9 = 9;

//Booleanos
bool umAtivo = true;
bool doisAtivo = false;
bool tresAtivo = false;
bool quatroAtivo = false;

class _VideoStreamWidgetState extends State<VideoStreamWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrain){
      return SizedBox(
        width: widget.wid / 2,
        height: widget.heig / 1.8,
        child: widget.ip != "" ? Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: widget.corDasBarras,
                  centerTitle: true,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                          "assets/camera.png",
                          scale: 10
                      ),
                      Row(
                        children: [
                          TextButton(onPressed: (){
                            setState(() {
                              umAtivo = true;
                              doisAtivo = false;
                              tresAtivo = false;
                              quatroAtivo = false;
                              camera1 = 1;
                              camera2 = 2;
                              camera3 = 3;
                              camera4 = 4;
                              camera5 = 5;
                              camera6 = 6;
                              camera7 = 7;
                              camera8 = 8;
                              camera9 = 9;
                            });
                          },
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  umAtivo == true ?
                                  Image.asset(
                                      "assets/grade 3.png",
                                      scale: 10
                                  ):
                                  Image.asset(
                                      "assets/grade 2.png",
                                      scale: 10
                                  ),
                                  const Text('1',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )
                          ),
                          TextButton(onPressed: (){
                            setState(() {
                              umAtivo = false;
                              doisAtivo = true;
                              tresAtivo = false;
                              quatroAtivo = false;
                              camera1 = 10;
                              camera2 = 11;
                              camera3 = 12;
                              camera4 = 13;
                              camera5 = 14;
                              camera6 = 15;
                              camera7 = 16;
                              camera8 = 17;
                              camera9 = 18;
                            });
                          },
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  doisAtivo == true ?
                                  Image.asset(
                                      "assets/grade 3.png",
                                      scale: 10
                                  ):
                                  Image.asset(
                                      "assets/grade 2.png",
                                      scale: 10
                                  ),
                                  const Text('2',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )
                          ),
                          TextButton(onPressed: (){
                            setState(() {
                              umAtivo = false;
                              doisAtivo = false;
                              tresAtivo = true;
                              quatroAtivo = false;
                              camera1 = 19;
                              camera2 = 20;
                              camera3 = 21;
                              camera4 = 22;
                              camera5 = 23;
                              camera6 = 24;
                              camera7 = 25;
                              camera8 = 26;
                              camera9 = 27;
                            });
                          },
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  tresAtivo == true ?
                                  Image.asset(
                                      "assets/grade 3.png",
                                      scale: 10
                                  ):
                                  Image.asset(
                                      "assets/grade 2.png",
                                      scale: 10
                                  ),
                                  const Text('3',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )
                          ),
                          TextButton(onPressed: (){
                            setState(() {
                              umAtivo = false;
                              doisAtivo = false;
                              tresAtivo = false;
                              quatroAtivo = true;
                              camera1 = 28;
                              camera2 = 29;
                              camera3 = 30;
                              camera4 = 31;
                              camera5 = 33;
                              camera6 = 34;
                              camera7 = 35;
                              camera8 = 36;
                              camera9 = 37;
                            });
                          },
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  quatroAtivo == true ?
                                  Image.asset(
                                      "assets/grade 3.png",
                                      scale: 10
                                  ):
                                  Image.asset(
                                      "assets/grade 2.png",
                                      scale: 10
                                  ),
                                  const Text('4',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: widget.wid / 2,
                              height: 500,
                              child: GridView.count(
                                childAspectRatio: 1.8,
                                crossAxisCount: colunasIPCamera,
                                children: [
                                  InkWell(
                                      onTap: (){
                                        setState(() {
                                          CFTV = 1;
                                        });
                                      },
                                      child: videoStream(widget.user, widget.pass, widget.ip, widget.porta, camera1)
                                  ),
                                  InkWell(
                                      onTap: (){
                                        setState(() {
                                          CFTV = 2;
                                        });
                                      },
                                      child: videoStream(widget.user, widget.pass, widget.ip, widget.porta, camera2)
                                  ),
                                  InkWell(
                                      onTap: (){
                                        setState(() {
                                          CFTV = 3;
                                        });
                                      },
                                      child: videoStream(widget.user, widget.pass, widget.ip, widget.porta, camera3)
                                  ),
                                  InkWell(
                                      onTap: (){
                                        setState(() {
                                          CFTV = 4;
                                        });
                                      },
                                      child: videoStream(widget.user, widget.pass, widget.ip, widget.porta, camera4)
                                  ),
                                  InkWell(
                                      onTap: (){
                                        setState(() {
                                          CFTV = 5;
                                        });
                                      },
                                      child: videoStream(widget.user, widget.pass, widget.ip, widget.porta, camera5)
                                  ),
                                  InkWell(
                                      onTap: (){
                                        setState(() {
                                          CFTV = 6;
                                        });
                                      },
                                      child: videoStream(widget.user, widget.pass, widget.ip, widget.porta, camera6)
                                  ),
                                  InkWell(
                                      onTap: (){
                                        setState(() {
                                          CFTV = 7;
                                        });
                                      },
                                      child: videoStream(widget.user, widget.pass, widget.ip, widget.porta, camera7)
                                  ),
                                  InkWell(
                                      onTap: (){
                                        setState(() {
                                          CFTV = 8;
                                        });
                                      },
                                      child: videoStream(widget.user, widget.pass, widget.ip, widget.porta, camera8)
                                  ),
                                  InkWell(
                                      onTap: (){
                                        setState(() {
                                          CFTV = 9;
                                        });
                                      },
                                      child: videoStream(widget.user, widget.pass, widget.ip, widget.porta, camera9)
                                  ),
                                ],
                              )
                          ),
                        ],
                      ),
                      CFTV == 0 ?
                      Container():
                      SizedBox(
                          width: widget.wid / 2,
                          height: widget.heig / 2.1,
                          child: Stack(
                              children: [
                                videoStreamAlert(widget.user, widget.pass, widget.ip, widget.porta, CFTV),
                                Container(
                                  alignment: Alignment.topRight,
                                  padding: const EdgeInsets.all(16),
                                  child: IconButton(onPressed: (){
                                    setState(() {
                                      CFTV = 0;
                                    });
                                  },
                                      icon: const Icon(Icons.close)
                                  ),
                                ),
                              ]
                          )
                      ),
                    ]
                ),
              ],
            ),
          ),
        ): Column(
          children: [
            AppBar(
              backgroundColor: widget.corDasBarras,
              centerTitle: true,
              title: Image.asset(
                  "assets/camera.png",
                  scale: 10
              ),
            ),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                child: const Text('Selecione algum cliente para exibir as cameras!')
            ),
          ],
        ),
      );
    });
  }
}
