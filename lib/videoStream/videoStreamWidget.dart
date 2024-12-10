import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:vigilant/homeApp.dart';
import 'package:vigilant/videoStream/VideoStreamAlert.dart';
import 'package:vigilant/videoStream/videoStream.dart';

//Desenvolvido por HeroRickyGames com ajuda de Deus!

class VideoStreamWidget extends StatefulWidget {
  String ip = "";
  int porta = 00;
  String user = "";
  String pass = "";
  Color corDasBarras;
  double wid;
  double heig;
  int? camera1;
  int? camera2;
  int? camera3;
  int? camera4;
  int? camera5;
  int? camera6;
  int? camera7;
  int? camera8;
  int? camera9;
  String Modelo = "";
  VideoStreamWidget(this.ip, this.porta, this.user, this.pass, this.corDasBarras, this.wid, this.heig, this.camera1, this.camera2, this.camera3, this.camera4, this.camera5,
      this.camera6, this.camera7, this.camera8, this.camera9, this.Modelo,  {super.key});

  @override
  State<VideoStreamWidget> createState() => _VideoStreamWidgetState();
}

//Double
double aspectRT = 2.2;

Color textCAMS = Colors.white;

//Inteiros
int colunasIPCamera = 3;
int CFTV = 0;

var dropValue36 = ValueNotifier('');

//Booleanos
bool gradeum = true;
bool gradedois = false;
bool gradetres = false;
bool gradequatro = false;

//Listas
List ipcamerasDisp = [
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "10",
  "11",
  "12",
  "13",
  "14",
  "15",
  "16",
  "17",
  "18",
  "19",
  "20",
  "21",
  "22",
  "23",
  "24",
  "25",
  "26",
  "27",
  "28",
  "29",
  "30",
  "31",
  "32",
  "33",
  "34",
  "35",
  "36",
];

class _VideoStreamWidgetState extends State<VideoStreamWidget> {
  @override
  Widget build(BuildContext context) {
    //doubles
    double blackContainerSize = widget.heig / 2.05;

    getScreenSize(){
      Uuid uuid = const Uuid();
      String UUID = uuid.v4();
      FirebaseFirestore.instance.collection("Logers").doc(UUID).set({
        "id": "UUID",
        "Wid": widget.wid,
        "Heig": widget.heig,
      });
    }

    getScreenSize();

    return StatefulBuilder(builder: (BuildContext context, StateSetter setStater){
      if(widget.heig >= 1000.0){
        setStater(() {
          aspectRT = 1.9;
          blackContainerSize = widget.heig / 2.05;
        });
      }


      if(widget.heig <= 999.0){
        setStater(() {
          aspectRT = 1.7;
          blackContainerSize = widget.heig / 2.05;
        });
      }

      if(widget.heig <= 950.0){
        setStater(() {
          aspectRT = 1.7;
          blackContainerSize = widget.heig / 2.1;
        });
      }

      if(widget.heig <= 850){
        setStater(() {
          aspectRT = 1.93;
          blackContainerSize = widget.heig / 2.17;
        });
      }

      if(widget.heig <= 800){
        setStater(() {
          aspectRT = 1.93;
          blackContainerSize = widget.heig / 2.17;
        });
      }

      if(widget.heig <= 700){
        setStater(() {
          aspectRT = 2.07;
          blackContainerSize = widget.heig / 2.19;
        });
      }

      if(widget.heig <= 600){
        setStater(() {
          aspectRT = 2.1;
          blackContainerSize = widget.heig / 2.26;
        });
      }

      if(widget.heig <= 599){
        setStater(() {
          aspectRT = 2.2;
          blackContainerSize = widget.heig / 2.35;
        });
      }
      return Flexible(
        child: Expanded(
          child: widget.ip != "" ? Column(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 5, top: 5),
                child: AppBar(
                  backgroundColor: widget.corDasBarras,
                  centerTitle: true,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                          "assets/camera.png",
                          scale: 15
                      ),
                      Row(
                        children: [
                          TextButton(onPressed: (){
                            setStater(() {
                              gradeum = true;
                              gradedois = false;
                              gradetres = false;
                              gradequatro = false;
                            });
                          },
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  gradeum == true?
                                  Image.asset(
                                      "assets/grade 3.png",
                                      scale: 12
                                  ):
                                  Image.asset(
                                      "assets/grade 2.png",
                                      scale: 12
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
                            setStater(() {
                              gradeum = false;
                              gradedois = true;
                              gradetres = false;
                              gradequatro = false;
                            });
                          },
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  gradedois == true?
                                  Image.asset(
                                      "assets/grade 3.png",
                                      scale: 12
                                  ):
                                  Image.asset(
                                      "assets/grade 2.png",
                                      scale: 12
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
                            setStater(() {
                              gradeum = false;
                              gradedois = false;
                              gradetres = true;
                              gradequatro = false;
                            });
                          },
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  gradetres == true?
                                  Image.asset(
                                      "assets/grade 3.png",
                                      scale: 12
                                  ):
                                  Image.asset(
                                      "assets/grade 2.png",
                                      scale: 12
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
                            setStater((){
                              gradeum = false;
                              gradedois = false;
                              gradetres = false;
                              gradequatro = true;
                            });
                          },
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  gradequatro == true?
                                  Image.asset(
                                      "assets/grade 3.png",
                                      scale: 12
                                  ):
                                  Image.asset(
                                      "assets/grade 2.png",
                                      scale: 12
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
              ),
              Flexible(
                child: Expanded(
                  child: Stack(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('CFTV')
                              .where('canal', isGreaterThanOrEqualTo: 1)
                              .where('canal', isLessThanOrEqualTo: 36)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return const Center(child: Text('Nenhum dado encontrado'));
                            }

                            return GridView.count(
                              crossAxisCount: colunasIPCamera,
                              childAspectRatio: aspectRT,
                              children: snapshot.data!.docs.map((documents){
                                return Center(
                                  child: videoStream(documents['user'], documents['pass'], documents['ip'], documents['porta'],documents['canal'], documents['modelo']),
                                );
                              }).toList(),
                            );
                          },
                        ),
                        CFTV == 0 ?
                        Container():
                        Stack(
                            children: [
                              videoStreamAlert(widget.user, widget.pass, widget.ip, widget.porta, CFTV, widget.Modelo),
                              Container(
                                alignment: Alignment.topRight,
                                padding: const EdgeInsets.all(16),
                                child: IconButton(onPressed: (){
                                  setStater(() {
                                    CFTV = 0;
                                  });
                                },
                                    icon: const Icon(Icons.close)
                                ),
                              ),
                            ]
                        ),
                      ]
                  ),
                ),
              ),
            ],
          ): Column(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 5, top: 5),
                child: AppBar(
                  backgroundColor: widget.corDasBarras,
                  centerTitle: true,
                  title: Image.asset(
                      "assets/camera.png",
                      scale: 12
                  ),
                ),
              ),
              Center(
                child: Container(
                    color: Colors.black,
                    width: widget.wid / 2,
                    height: blackContainerSize,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Selecione algum cliente para exibir as cameras!',
                      style: TextStyle(
                        color: textCAMS,
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
