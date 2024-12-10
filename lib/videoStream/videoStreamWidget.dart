import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:uuid/uuid.dart';
import 'package:vigilant/homeApp.dart';
import 'package:vigilant/videoStream/VideoStreamAlert.dart';
import 'package:vigilant/videoStream/videoStream.dart';

//Desenvolvido por HeroRickyGames com ajuda de Deus!

class VideoStreamWidget extends StatefulWidget {
  Color corDasBarras;
  double wid;
  double heig;
  VideoStreamWidget(this.corDasBarras, this.wid, this.heig, {super.key});

  @override
  State<VideoStreamWidget> createState() => _VideoStreamWidgetState();
}

//Strings
String userSelecionado = "";
String passSelecionado = "";
String ipSelecionado = "";
String ModeloSelecionado = "";

//Double
double aspectRT = 2.2;

Color textCAMS = Colors.white;

//Inteiros
int colunasIPCamera = 3;
int CFTV = 0;
int portaSelecionada = 0;
int canalSelecionado = 0;

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
          child: idCondominio != "" ? Column(
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
                        Container(
                          color: Colors.black,
                          child: StreamBuilder<QuerySnapshot>(
                            stream:
                                 gradeum == true ?
                                 FirebaseFirestore.instance
                                .collection('CFTV')
                                .where("idCondominio", isEqualTo: idCondominio)
                                .where('Ordem', isGreaterThanOrEqualTo: 1)
                                .where('Ordem', isLessThanOrEqualTo: 9)
                                .snapshots():
                                 gradedois == true?
                                 FirebaseFirestore.instance
                                     .collection('CFTV')
                                     .where("idCondominio", isEqualTo: idCondominio)
                                     .where('Ordem', isGreaterThanOrEqualTo: 10)
                                     .where('Ordem', isLessThanOrEqualTo: 18)
                                     .snapshots():
                                 gradetres == true?
                                 FirebaseFirestore.instance
                                     .collection('CFTV')
                                     .where("idCondominio", isEqualTo: idCondominio)
                                     .where('Ordem', isGreaterThanOrEqualTo: 19)
                                     .where('Ordem', isLessThanOrEqualTo: 27)
                                     .snapshots():
                                 gradequatro == true?
                                 FirebaseFirestore.instance
                                     .collection('CFTV')
                                     .where("idCondominio", isEqualTo: idCondominio)
                                     .where('Ordem', isGreaterThanOrEqualTo: 28)
                                     .where('Ordem', isLessThanOrEqualTo: 37)
                                     .snapshots():
                                 FirebaseFirestore.instance
                                     .collection('CFTV')
                                     .where("idCondominio", isEqualTo: idCondominio)
                                     .where('Ordem', isGreaterThanOrEqualTo: 1)
                                     .where('Ordem', isLessThanOrEqualTo: 9)
                                     .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child:CircularProgressIndicator(color: Colors.white,));
                              }

                              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                return const Center(child: Text('Nenhum dado encontrado'));
                              }

                              return GridView.count(
                                crossAxisCount: colunasIPCamera,
                                childAspectRatio: aspectRT,
                                children: snapshot.data!.docs.map((documents){
                                  return Center(
                                  child: Stack(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          setStater((){
                                            userSelecionado = documents['user'];
                                            passSelecionado = documents['pass'];
                                            ipSelecionado = documents['ip'];
                                            portaSelecionada = documents['porta'];
                                            canalSelecionado = documents['canal'];
                                            ModeloSelecionado = documents['modelo'];
                                          });
                                        },
                                        child: videoStream(documents['user'], documents['pass'], documents['ip'], documents['porta'],documents['canal'], documents['modelo']),
                                      ),
                                      EditarCFTV == true ? Container(
                                        alignment: Alignment.topRight,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                                onPressed: (){
                                                  FirebaseFirestore.instance.collection("CFTV").doc(documents['id']).update({
                                                    "ip": '',
                                                    "porta": 00,
                                                    "user": '',
                                                    "pass": '',
                                                    "canal": 00,
                                                  }).whenComplete((){
                                                    showToast("Deletado!",context:context);
                                                  });
                                                },
                                                child: const Icon(Icons.delete)),
                                            TextButton(
                                                onPressed: (){
                                                  String IP = documents['ip'];
                                                  String porta = "${documents['porta']}";
                                                  String user = documents['user'];
                                                  String pass = documents['pass'];
                                                  String canal = "${documents['canal']}";
                                                  String modeloselecionado = "${documents['modelo']}";
                                                  var dropValue2 = ValueNotifier(modeloselecionado);

                                                  TextEditingController IpControl = TextEditingController(text: IP);
                                                  TextEditingController portaControl = TextEditingController(text: porta);
                                                  TextEditingController userControl = TextEditingController(text: user);
                                                  TextEditingController passControl = TextEditingController(text: pass);
                                                  TextEditingController canalControl = TextEditingController(text: canal);

                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return StatefulBuilder(builder: (BuildContext context, StateSetter setStates){
                                                        return AlertDialog(
                                                          title: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  const Text('Editar CFTV'),
                                                                  ElevatedButton(
                                                                      onPressed: (){
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: const Icon(Icons.close))
                                                                ],
                                                              ),
                                                              Center(
                                                                child: Container(
                                                                  padding: const EdgeInsets.all(16),
                                                                  child: TextField(
                                                                    controller: IpControl,
                                                                    keyboardType: TextInputType.emailAddress,
                                                                    enableSuggestions: false,
                                                                    autocorrect: false,
                                                                    onChanged: (value){
                                                                      setStates(() {
                                                                        IP = value;
                                                                      });
                                                                    },
                                                                    decoration: InputDecoration(
                                                                      filled: true,
                                                                      fillColor: Colors.white,
                                                                      labelStyle: TextStyle(
                                                                          color: textAlertDialogColor,
                                                                          backgroundColor: Colors.white
                                                                      ),
                                                                      border: const OutlineInputBorder(),
                                                                      enabledBorder: const OutlineInputBorder(
                                                                        borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                      ),
                                                                      focusedBorder: const OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            width: 3,
                                                                            color: Colors.black
                                                                        ),
                                                                      ),
                                                                      labelText: 'Host',
                                                                    ),
                                                                    style: TextStyle(
                                                                        color: textAlertDialogColor
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Center(
                                                                child: Container(
                                                                  padding: const EdgeInsets.all(16),
                                                                  child: TextField(
                                                                    controller: portaControl,
                                                                    keyboardType: TextInputType.emailAddress,
                                                                    enableSuggestions: false,
                                                                    autocorrect: false,
                                                                    onChanged: (value){
                                                                      setStates(() {
                                                                        IP = value;
                                                                      });
                                                                    },
                                                                    decoration: InputDecoration(
                                                                      filled: true,
                                                                      fillColor: Colors.white,
                                                                      labelStyle: TextStyle(
                                                                          color: textAlertDialogColor,
                                                                          backgroundColor: Colors.white
                                                                      ),
                                                                      border: const OutlineInputBorder(),
                                                                      enabledBorder: const OutlineInputBorder(
                                                                        borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                      ),
                                                                      focusedBorder: const OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            width: 3,
                                                                            color: Colors.black
                                                                        ),
                                                                      ),
                                                                      labelText: 'Porta',
                                                                    ),
                                                                    style: TextStyle(
                                                                        color: textAlertDialogColor
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Center(
                                                                child: Container(
                                                                  padding: const EdgeInsets.all(16),
                                                                  child: TextField(
                                                                    controller: userControl,
                                                                    keyboardType: TextInputType.emailAddress,
                                                                    enableSuggestions: false,
                                                                    autocorrect: false,
                                                                    onChanged: (value){
                                                                      setStates(() {
                                                                        user = value;
                                                                      });
                                                                    },
                                                                    decoration: InputDecoration(
                                                                      filled: true,
                                                                      fillColor: Colors.white,
                                                                      labelStyle: TextStyle(
                                                                          color: textAlertDialogColor,
                                                                          backgroundColor: Colors.white
                                                                      ),
                                                                      border: const OutlineInputBorder(),
                                                                      enabledBorder: const OutlineInputBorder(
                                                                        borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                      ),
                                                                      focusedBorder: const OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            width: 3,
                                                                            color: Colors.black
                                                                        ),
                                                                      ),
                                                                      labelText: 'Usuario',
                                                                    ),
                                                                    style: TextStyle(
                                                                        color: textAlertDialogColor
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Center(
                                                                child: Container(
                                                                  padding: const EdgeInsets.all(16),
                                                                  child: TextField(
                                                                    controller: passControl,
                                                                    keyboardType: TextInputType.emailAddress,
                                                                    enableSuggestions: false,
                                                                    autocorrect: false,
                                                                    onChanged: (value){
                                                                      setStates(() {
                                                                        pass = value;
                                                                      });
                                                                    },
                                                                    decoration: InputDecoration(
                                                                      filled: true,
                                                                      fillColor: Colors.white,
                                                                      labelStyle: TextStyle(
                                                                          color: textAlertDialogColor,
                                                                          backgroundColor: Colors.white
                                                                      ),
                                                                      border: const OutlineInputBorder(),
                                                                      enabledBorder: const OutlineInputBorder(
                                                                        borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                      ),
                                                                      focusedBorder: const OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            width: 3,
                                                                            color: Colors.black
                                                                        ),
                                                                      ),
                                                                      labelText: 'Senha',
                                                                    ),
                                                                    style: TextStyle(
                                                                        color: textAlertDialogColor
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Center(
                                                                child: Container(
                                                                  padding: const EdgeInsets.all(16),
                                                                  child: TextField(
                                                                    controller: canalControl,
                                                                    keyboardType: TextInputType.emailAddress,
                                                                    enableSuggestions: false,
                                                                    autocorrect: false,
                                                                    onChanged: (value){
                                                                      setStates(() {
                                                                        canal = value;
                                                                      });
                                                                    },
                                                                    decoration: InputDecoration(
                                                                      filled: true,
                                                                      fillColor: Colors.white,
                                                                      labelStyle: TextStyle(
                                                                          color: textAlertDialogColor,
                                                                          backgroundColor: Colors.white
                                                                      ),
                                                                      border: const OutlineInputBorder(),
                                                                      enabledBorder: const OutlineInputBorder(
                                                                        borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                      ),
                                                                      focusedBorder: const OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            width: 3,
                                                                            color: Colors.black
                                                                        ),
                                                                      ),
                                                                      labelText: 'Canal',
                                                                    ),
                                                                    style: TextStyle(
                                                                        color: textAlertDialogColor
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Center(
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    const Text(
                                                                        'Modelo do CFTV:',
                                                                    style: TextStyle(
                                                                      fontSize: 16
                                                                    ),),
                                                                    ValueListenableBuilder(valueListenable: dropValue2, builder: (context, String value, _){
                                                                      return DropdownButton(
                                                                        hint: Text(
                                                                          'Selecione o modelo',
                                                                          style: TextStyle(
                                                                              color: textColorDrop
                                                                          ),
                                                                        ),
                                                                        value: (value.isEmpty)? null : value,
                                                                        onChanged: (escolha) async {
                                                                          dropValue2.value = escolha.toString();
                                                                          setStates(() {
                                                                            modeloselecionado = escolha.toString();
                                                                          });
                                                                        },
                                                                        items: ModelosdeCFTV.map((opcao) => DropdownMenuItem(
                                                                          value: opcao,
                                                                          child:
                                                                          Text(
                                                                            opcao,
                                                                            style: TextStyle(
                                                                                color: textColorDrop
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        ).toList(),
                                                                      );
                                                                    }),
                                                                  ],
                                                                ),
                                                              ),
                                                              ElevatedButton(
                                                                  onPressed: (){
                                                                      FirebaseFirestore.instance.collection("CFTV").doc(documents['id']).update({
                                                                        "ip": IP,
                                                                        "porta": int.parse(porta),
                                                                        "user": user,
                                                                        "pass": pass,
                                                                        "canal": int.parse(canal),
                                                                        "modelo": modeloselecionado,
                                                                      }).whenComplete((){
                                                                        Navigator.pop(context);
                                                                      });
                                                                  },
                                                                style: ElevatedButton.styleFrom(
                                                                    backgroundColor: colorBtn
                                                                ),
                                                                  child: const Text(
                                                                      'Salvar',
                                                                  style: TextStyle(
                                                                    color: Colors.white
                                                                  ),),
                                                              )
                                                            ],
                                                          ),
                                                          scrollable: true,
                                                        );
                                                      },
                                                      );
                                                    },
                                                  );
                                                },
                                                child: const Icon(
                                                    Icons.edit,
                                                  color: Colors.red,
                                                )
                                            ),
                                          ],
                                        ),
                                      ): Container()
                                    ],
                                  ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                        canalSelecionado == 0 ?
                        Container():
                        Stack(
                            children: [
                              videoStreamAlert(userSelecionado, passSelecionado, ipSelecionado, portaSelecionada, canalSelecionado, ModeloSelecionado),
                              Container(
                                alignment: Alignment.topRight,
                                padding: const EdgeInsets.all(16),
                                child: IconButton(onPressed: (){
                                  setStater(() {
                                    setStater((){
                                      userSelecionado = '';
                                      passSelecionado = '';
                                      ipSelecionado = '';
                                      portaSelecionada = 0;
                                      canalSelecionado = 0;
                                      ModeloSelecionado = '';
                                    });
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
