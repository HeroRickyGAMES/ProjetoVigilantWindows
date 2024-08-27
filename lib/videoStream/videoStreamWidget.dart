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

Color textCAMS = Colors.black;

//Inteiros
int colunasIPCamera = 3;
int CFTV = 0;

//DropDownValues
var dropValue1 = ValueNotifier('');
var dropValue2 = ValueNotifier('');
var dropValue3 = ValueNotifier('');
var dropValue4 = ValueNotifier('');
var dropValue5 = ValueNotifier('');
var dropValue6 = ValueNotifier('');
var dropValue7 = ValueNotifier('');
var dropValue8 = ValueNotifier('');
var dropValue9 = ValueNotifier('');
var dropValue10 = ValueNotifier('');
var dropValue11 = ValueNotifier('');
var dropValue12 = ValueNotifier('');
var dropValue13 = ValueNotifier('');
var dropValue14 = ValueNotifier('');
var dropValue15 = ValueNotifier('');
var dropValue16 = ValueNotifier('');
var dropValue17 = ValueNotifier('');
var dropValue18 = ValueNotifier('');
var dropValue19 = ValueNotifier('');
var dropValue20 = ValueNotifier('');
var dropValue21 = ValueNotifier('');
var dropValue22 = ValueNotifier('');
var dropValue23 = ValueNotifier('');
var dropValue24 = ValueNotifier('');
var dropValue25 = ValueNotifier('');
var dropValue26 = ValueNotifier('');
var dropValue27 = ValueNotifier('');
var dropValue28 = ValueNotifier('');
var dropValue29 = ValueNotifier('');
var dropValue30 = ValueNotifier('');
var dropValue31 = ValueNotifier('');
var dropValue32 = ValueNotifier('');
var dropValue33 = ValueNotifier('');
var dropValue34 = ValueNotifier('');
var dropValue35 = ValueNotifier('');
var dropValue36 = ValueNotifier('');

//Booleanos
bool umAtivo = true;
bool doisAtivo = false;
bool tresAtivo = false;
bool quatroAtivo = false;
bool isStarted = false;

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

  getIpCameraFromSettings(int numeroCameraSelect1, int numeroCameraSelect2, int numeroCameraSelect3,
  int numeroCameraSelect4, int numeroCameraSelect5, int numeroCameraSelect6, int numeroCameraSelect7,
      int numeroCameraSelect8, int numeroCameraSelect9) async {
    if(idCondominio == ""){
    getIpCameraFromSettings(numeroCameraSelect1, numeroCameraSelect2, numeroCameraSelect3, numeroCameraSelect4, numeroCameraSelect5, numeroCameraSelect6, numeroCameraSelect7, numeroCameraSelect8, numeroCameraSelect9);
    }else{
      await Future.delayed(const Duration(seconds: 1));
      var getIpCameraSettings = await FirebaseFirestore.instance
          .collection("Condominios")
          .doc(idCondominio).get();
      setState(() {
        widget.camera1 = getIpCameraSettings["ipCamera$numeroCameraSelect1"];
        widget.camera2 = getIpCameraSettings["ipCamera$numeroCameraSelect2"];
        widget.camera3 = getIpCameraSettings["ipCamera$numeroCameraSelect3"];
        widget.camera4 = getIpCameraSettings["ipCamera$numeroCameraSelect4"];
        widget.camera5 = getIpCameraSettings["ipCamera$numeroCameraSelect5"];
        widget.camera6 = getIpCameraSettings["ipCamera$numeroCameraSelect6"];
        widget.camera7 = getIpCameraSettings["ipCamera$numeroCameraSelect7"];
        widget.camera8 = getIpCameraSettings["ipCamera$numeroCameraSelect8"];
        widget.camera9 = getIpCameraSettings["ipCamera$numeroCameraSelect9"];
      });
    }

  }

  getIpCameraCond() async {
    var getIpCameraSettings = await FirebaseFirestore.instance
        .collection("Condominios")
        .doc(idCondominio).get();

    setState(() {
      dropValue1 = ValueNotifier(getIpCameraSettings["ipCamera1"].toString());
      dropValue2 = ValueNotifier(getIpCameraSettings["ipCamera2"].toString());
      dropValue3 = ValueNotifier(getIpCameraSettings["ipCamera3"].toString());
      dropValue4 = ValueNotifier(getIpCameraSettings["ipCamera4"].toString());
      dropValue5 = ValueNotifier(getIpCameraSettings["ipCamera5"].toString());
      dropValue6 = ValueNotifier(getIpCameraSettings["ipCamera6"].toString());
      dropValue7 = ValueNotifier(getIpCameraSettings["ipCamera7"].toString());
      dropValue8 = ValueNotifier(getIpCameraSettings["ipCamera8"].toString());
      dropValue9 = ValueNotifier(getIpCameraSettings["ipCamera9"].toString());
      dropValue10 = ValueNotifier(getIpCameraSettings["ipCamera10"].toString());
      dropValue11 = ValueNotifier(getIpCameraSettings["ipCamera11"].toString());
      dropValue12 = ValueNotifier(getIpCameraSettings["ipCamera12"].toString());
      dropValue13 = ValueNotifier(getIpCameraSettings["ipCamera13"].toString());
      dropValue14 = ValueNotifier(getIpCameraSettings["ipCamera14"].toString());
      dropValue15 = ValueNotifier(getIpCameraSettings["ipCamera15"].toString());
      dropValue16 = ValueNotifier(getIpCameraSettings["ipCamera16"].toString());
      dropValue17 = ValueNotifier(getIpCameraSettings["ipCamera17"].toString());
      dropValue18 = ValueNotifier(getIpCameraSettings["ipCamera18"].toString());
      dropValue19 = ValueNotifier(getIpCameraSettings["ipCamera19"].toString());
      dropValue20 = ValueNotifier(getIpCameraSettings["ipCamera20"].toString());
      dropValue21 = ValueNotifier(getIpCameraSettings["ipCamera21"].toString());
      dropValue22 = ValueNotifier(getIpCameraSettings["ipCamera22"].toString());
      dropValue23 = ValueNotifier(getIpCameraSettings["ipCamera23"].toString());
      dropValue24 = ValueNotifier(getIpCameraSettings["ipCamera24"].toString());
      dropValue25 = ValueNotifier(getIpCameraSettings["ipCamera25"].toString());
      dropValue26 = ValueNotifier(getIpCameraSettings["ipCamera26"].toString());
      dropValue27 = ValueNotifier(getIpCameraSettings["ipCamera27"].toString());
      dropValue28 = ValueNotifier(getIpCameraSettings["ipCamera28"].toString());
      dropValue29 = ValueNotifier(getIpCameraSettings["ipCamera29"].toString());
      dropValue30 = ValueNotifier(getIpCameraSettings["ipCamera30"].toString());
      dropValue31 = ValueNotifier(getIpCameraSettings["ipCamera31"].toString());
      dropValue32 = ValueNotifier(getIpCameraSettings["ipCamera32"].toString());
      dropValue33 = ValueNotifier(getIpCameraSettings["ipCamera33"].toString());
      dropValue34 = ValueNotifier(getIpCameraSettings["ipCamera34"].toString());
      dropValue35 = ValueNotifier(getIpCameraSettings["ipCamera35"].toString());
      dropValue36 = ValueNotifier(getIpCameraSettings["ipCamera36"].toString());
    });
  }

  start() async {
    if(isStarted == false){
      getIpCameraFromSettings(1, 2, 3, 4, 5, 6, 7, 8, 9);
    }
  }

  @override
  Widget build(BuildContext context) {

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

    print(widget.heig);

    if(widget.heig >= 1000.0){
      setState(() {
        aspectRT = 1.9;
      });
    }

    if(widget.heig <= 999.0){
      setState(() {
        aspectRT = 1.7;
      });
    }

    if(widget.heig <= 800){
      setState(() {
        aspectRT = 1.93;
      });
    }

    if(widget.heig <= 700){
      setState(() {
        aspectRT = 2.1;
      });
    }

    if(widget.heig <= 600){
      setState(() {
        aspectRT = 2.05;
      });
    }

    if(widget.heig <= 599){
      setState(() {
        aspectRT = 2.3;
      });
    }

    return LayoutBuilder(builder: (context, constrain){
      return SizedBox(
        width: widget.wid / 2,
        height: widget.heig / 1.8,
        child: widget.ip != "" ? SingleChildScrollView(
          child: Column(
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
                          scale: 12
                      ),
                      Row(
                        children: [
                          TextButton(onPressed: (){
                            setState(() {
                              umAtivo = true;
                              doisAtivo = false;
                              tresAtivo = false;
                              quatroAtivo = false;
                              widget.camera1 = 1;
                              widget.camera2 = 2;
                              widget.camera3 = 3;
                              widget.camera4 = 4;
                              widget.camera5 = 5;
                              widget.camera6 = 6;
                              widget.camera7 = 7;
                              widget.camera8 = 8;
                              widget.camera9 = 9;
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
                            setState(() {
                              umAtivo = false;
                              doisAtivo = true;
                              tresAtivo = false;
                              quatroAtivo = false;
                              getIpCameraFromSettings(10, 11, 12, 13, 14, 15, 16, 17, 18);
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
                            setState(() {
                              umAtivo = false;
                              doisAtivo = false;
                              tresAtivo = true;
                              quatroAtivo = false;
                              getIpCameraFromSettings(19, 20, 21, 22, 23, 24, 25, 26, 27);
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
                            setState(() {
                              umAtivo = false;
                              doisAtivo = false;
                              tresAtivo = false;
                              quatroAtivo = true;
                              getIpCameraFromSettings(28, 29, 30, 31, 32, 33, 34, 35, 36);
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
                      TextButton(
                          onPressed: () async {
                            getIpCameraCond();
                            await Future.delayed(const Duration(seconds: 1));

                            //Strings
                            String camera01Selecionada = dropValue1 .value;
                            String camera02Selecionada = dropValue2 .value;
                            String camera03Selecionada = dropValue3 .value;
                            String camera04Selecionada = dropValue4 .value;
                            String camera05Selecionada = dropValue5 .value;
                            String camera06Selecionada = dropValue6 .value;
                            String camera07Selecionada = dropValue7 .value;
                            String camera08Selecionada = dropValue8 .value;
                            String camera09Selecionada = dropValue9 .value;
                            String camera10Selecionada = dropValue10.value;
                            String camera11Selecionada = dropValue11.value;
                            String camera12Selecionada = dropValue12.value;
                            String camera13Selecionada = dropValue13.value;
                            String camera14Selecionada = dropValue14.value;
                            String camera15Selecionada = dropValue15.value;
                            String camera16Selecionada = dropValue16.value;
                            String camera17Selecionada = dropValue17.value;
                            String camera18Selecionada = dropValue18.value;
                            String camera19Selecionada = dropValue19.value;
                            String camera20Selecionada = dropValue20.value;
                            String camera21Selecionada = dropValue21.value;
                            String camera22Selecionada = dropValue22.value;
                            String camera23Selecionada = dropValue23.value;
                            String camera24Selecionada = dropValue24.value;
                            String camera25Selecionada = dropValue25.value;
                            String camera26Selecionada = dropValue26.value;
                            String camera27Selecionada = dropValue27.value;
                            String camera28Selecionada = dropValue28.value;
                            String camera29Selecionada = dropValue29.value;
                            String camera30Selecionada = dropValue30.value;
                            String camera31Selecionada = dropValue31.value;
                            String camera32Selecionada = dropValue32.value;
                            String camera33Selecionada = dropValue33.value;
                            String camera34Selecionada = dropValue34.value;
                            String camera35Selecionada = dropValue35.value;
                            String camera36Selecionada = dropValue36.value;

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                                  return AlertDialog(
                                    title: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text("Editar cameras"),
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Image.asset(
                                                "assets/grade 3.png",
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
                                        ),
                                        SizedBox(
                                          width: 600,
                                          height: 600,
                                          child: GridView.count(
                                            crossAxisCount: 3,
                                            children: [
                                              Center(
                                                child: ValueListenableBuilder(valueListenable: dropValue1, builder: (context, String value, _){
                                                  return DropdownButton(
                                                    hint: Text(
                                                      'Camera 01',
                                                      style: TextStyle(
                                                          color: textColorDrop
                                                      ),
                                                    ),
                                                    value: (value.isEmpty)? null : value,
                                                    onChanged: (escolha) async {
                                                      dropValue1.value = escolha.toString();
                                                      setState(() {
                                                        camera01Selecionada = escolha.toString();
                                                      });
                                                    },
                                                    items: ipcamerasDisp.map((opcao) => DropdownMenuItem(
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
                                              ),
                                              Center(
                                                child: ValueListenableBuilder(valueListenable: dropValue2, builder: (context, String value, _){
                                                  return DropdownButton(
                                                    hint: Text(
                                                      'Camera 02',
                                                      style: TextStyle(
                                                          color: textColorDrop
                                                      ),
                                                    ),
                                                    value: (value.isEmpty)? null : value,
                                                    onChanged: (escolha) async {
                                                      dropValue2.value = escolha.toString();
                                                      setState(() {
                                                        camera02Selecionada = escolha.toString();
                                                      });
                                                    },
                                                    items: ipcamerasDisp.map((opcao) => DropdownMenuItem(
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
                                              ),
                                              Center(
                                                child: ValueListenableBuilder(valueListenable: dropValue3, builder: (context, String value, _){
                                                  return DropdownButton(
                                                    hint: Text(
                                                      'Camera 03',
                                                      style: TextStyle(
                                                          color: textColorDrop
                                                      ),
                                                    ),
                                                    value: (value.isEmpty)? null : value,
                                                    onChanged: (escolha) async {
                                                      dropValue3.value = escolha.toString();
                                                      setState(() {
                                                        camera03Selecionada = escolha.toString();
                                                      });
                                                    },
                                                    items: ipcamerasDisp.map((opcao) => DropdownMenuItem(
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
                                              ),
                                              Center(
                                                child: ValueListenableBuilder(valueListenable: dropValue4, builder: (context, String value, _){
                                                  return DropdownButton(
                                                    hint: Text(
                                                      'Camera 04',
                                                      style: TextStyle(
                                                          color: textColorDrop
                                                      ),
                                                    ),
                                                    value: (value.isEmpty)? null : value,
                                                    onChanged: (escolha) async {
                                                      dropValue4.value = escolha.toString();
                                                      setState(() {
                                                        camera04Selecionada = escolha.toString();
                                                      });
                                                    },
                                                    items: ipcamerasDisp.map((opcao) => DropdownMenuItem(
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
                                              ),
                                              Center(
                                                child: ValueListenableBuilder(valueListenable: dropValue5, builder: (context, String value, _){
                                                  return DropdownButton(
                                                    hint: Text(
                                                      'Camera 05',
                                                      style: TextStyle(
                                                          color: textColorDrop
                                                      ),
                                                    ),
                                                    value: (value.isEmpty)? null : value,
                                                    onChanged: (escolha) async {
                                                      dropValue5.value = escolha.toString();
                                                      setState(() {
                                                        camera05Selecionada = escolha.toString();
                                                      });
                                                    },
                                                    items: ipcamerasDisp.map((opcao) => DropdownMenuItem(
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
                                              ),
                                              Center(
                                                child: ValueListenableBuilder(valueListenable: dropValue6, builder: (context, String value, _){
                                                  return DropdownButton(
                                                    hint: Text(
                                                      'Camera 06',
                                                      style: TextStyle(
                                                          color: textColorDrop
                                                      ),
                                                    ),
                                                    value: (value.isEmpty)? null : value,
                                                    onChanged: (escolha) async {
                                                      dropValue6.value = escolha.toString();
                                                      setState(() {
                                                        camera06Selecionada = escolha.toString();
                                                      });
                                                    },
                                                    items: ipcamerasDisp.map((opcao) => DropdownMenuItem(
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
                                              ),
                                              Center(
                                                child: ValueListenableBuilder(valueListenable: dropValue7, builder: (context, String value, _){
                                                  return DropdownButton(
                                                    hint: Text(
                                                      'Camera 07',
                                                      style: TextStyle(
                                                          color: textColorDrop
                                                      ),
                                                    ),
                                                    value: (value.isEmpty)? null : value,
                                                    onChanged: (escolha) async {
                                                      dropValue7.value = escolha.toString();
                                                      setState(() {
                                                        camera07Selecionada = escolha.toString();
                                                      });
                                                    },
                                                    items: ipcamerasDisp.map((opcao) => DropdownMenuItem(
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
                                              ),
                                              Center(
                                                child: ValueListenableBuilder(valueListenable: dropValue8, builder: (context, String value, _){
                                                  return DropdownButton(
                                                    hint: Text(
                                                      'Camera 08',
                                                      style: TextStyle(
                                                          color: textColorDrop
                                                      ),
                                                    ),
                                                    value: (value.isEmpty)? null : value,
                                                    onChanged: (escolha) async {
                                                      dropValue8.value = escolha.toString();
                                                      setState(() {
                                                        camera08Selecionada = escolha.toString();
                                                      });
                                                    },
                                                    items: ipcamerasDisp.map((opcao) => DropdownMenuItem(
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
                                              ),
                                              Center(
                                                child: ValueListenableBuilder(valueListenable: dropValue9, builder: (context, String value, _){
                                                  return DropdownButton(
                                                    hint: Text(
                                                      'Camera 09',
                                                      style: TextStyle(
                                                          color: textColorDrop
                                                      ),
                                                    ),
                                                    value: (value.isEmpty)? null : value,
                                                    onChanged: (escolha) async {
                                                      dropValue9.value = escolha.toString();
                                                      setState(() {
                                                        camera09Selecionada = escolha.toString();
                                                      });
                                                    },
                                                    items: ipcamerasDisp.map((opcao) => DropdownMenuItem(
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
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(onPressed: (){
                                          FirebaseFirestore.instance.collection('Condominios').doc(idCondominio).update({
                                            "ipCamera1": int.parse(camera01Selecionada),
                                            "ipCamera2": int.parse(camera02Selecionada),
                                            "ipCamera3": int.parse(camera03Selecionada),
                                            "ipCamera4": int.parse(camera04Selecionada),
                                            "ipCamera5": int.parse(camera05Selecionada),
                                            "ipCamera6": int.parse(camera06Selecionada),
                                            "ipCamera7": int.parse(camera07Selecionada),
                                            "ipCamera8": int.parse(camera08Selecionada),
                                            "ipCamera9": int.parse(camera09Selecionada),
                                            "ipCamera10": int.parse(camera10Selecionada),
                                            "ipCamera11": int.parse(camera11Selecionada),
                                            "ipCamera12": int.parse(camera12Selecionada),
                                            "ipCamera13": int.parse(camera13Selecionada),
                                            "ipCamera14": int.parse(camera14Selecionada),
                                            "ipCamera15": int.parse(camera15Selecionada),
                                            "ipCamera16": int.parse(camera16Selecionada),
                                            "ipCamera17": int.parse(camera17Selecionada),
                                            "ipCamera18": int.parse(camera18Selecionada),
                                            "ipCamera19": int.parse(camera19Selecionada),
                                            "ipCamera20": int.parse(camera20Selecionada),
                                            "ipCamera21": int.parse(camera21Selecionada),
                                            "ipCamera22": int.parse(camera22Selecionada),
                                            "ipCamera23": int.parse(camera23Selecionada),
                                            "ipCamera24": int.parse(camera24Selecionada),
                                            "ipCamera25": int.parse(camera25Selecionada),
                                            "ipCamera26": int.parse(camera26Selecionada),
                                            "ipCamera27": int.parse(camera27Selecionada),
                                            "ipCamera28": int.parse(camera28Selecionada),
                                            "ipCamera29": int.parse(camera29Selecionada),
                                            "ipCamera30": int.parse(camera30Selecionada),
                                            "ipCamera31": int.parse(camera31Selecionada),
                                            "ipCamera32": int.parse(camera32Selecionada),
                                            "ipCamera33": int.parse(camera33Selecionada),
                                            "ipCamera34": int.parse(camera34Selecionada),
                                            "ipCamera35": int.parse(camera35Selecionada),
                                            "ipCamera36": int.parse(camera36Selecionada),
                                          }).whenComplete(() async {
                                            //Quando salvo ele recarrega por completo estado!
                                            await Future.delayed(const Duration(seconds: 1));
                                            var getIpCameraSettings = await FirebaseFirestore.instance
                                                .collection("Condominios")
                                                .doc(idCondominio).get();
                                            setState((){
                                              camera1 = getIpCameraSettings["ipCamera1"];
                                              camera2 = getIpCameraSettings["ipCamera2"];
                                              camera3 = getIpCameraSettings["ipCamera3"];
                                              camera4 = getIpCameraSettings["ipCamera4"];
                                              camera5 = getIpCameraSettings["ipCamera5"];
                                              camera6 = getIpCameraSettings["ipCamera6"];
                                              camera7 = getIpCameraSettings["ipCamera7"];
                                              camera8 = getIpCameraSettings["ipCamera8"];
                                              camera9 = getIpCameraSettings["ipCamera9"];
                                              widget.camera1 = getIpCameraSettings["ipCamera1"];
                                              widget.camera2 = getIpCameraSettings["ipCamera2"];
                                              widget.camera3 = getIpCameraSettings["ipCamera3"];
                                              widget.camera4 = getIpCameraSettings["ipCamera4"];
                                              widget.camera5 = getIpCameraSettings["ipCamera5"];
                                              widget.camera6 = getIpCameraSettings["ipCamera6"];
                                              widget.camera7 = getIpCameraSettings["ipCamera7"];
                                              widget.camera8 = getIpCameraSettings["ipCamera8"];
                                              widget.camera9 = getIpCameraSettings["ipCamera9"];
                                            });
                                            if(umAtivo == true){
                                              getIpCameraFromSettings(1, 2, 3, 4, 5, 6, 7, 8, 9);
                                            }
                                            if(doisAtivo == true){
                                              getIpCameraFromSettings(10, 11, 12, 13, 14, 15, 16, 17, 18);
                                            }

                                            if(tresAtivo == true){
                                              getIpCameraFromSettings(19, 20, 21, 22, 23, 24, 25, 26, 27);
                                            }

                                            if(quatroAtivo == true){
                                              getIpCameraFromSettings(28, 29, 30, 31, 32, 33, 34, 35, 36);
                                            }

                                            Navigator.pop(context);
                                          });
                                        },
                                            icon: const Icon(Icons.save)
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
                          child: Image.asset(
                              "assets/Setting-icon.png",
                              scale: 12
                          )
                      )
                    ],
                  ),
                ),
              ),
              Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: SizedBox(
                              width: widget.wid / 2,
                              height: widget.heig / 2,
                              child: GridView.count(
                                childAspectRatio: aspectRT,
                                crossAxisCount: colunasIPCamera,
                                children: [
                                  InkWell(
                                      onTap: (){
                                        setState(() {
                                          CFTV = 1;
                                        });
                                      },
                                      child: videoStream(widget.user, widget.pass, widget.ip, widget.porta, widget.camera1, widget.Modelo)
                                  ),
                                  InkWell(
                                      onTap: (){
                                        setState(() {
                                          CFTV = 2;
                                        });
                                      },
                                      child: videoStream(widget.user, widget.pass, widget.ip, widget.porta, widget.camera2, widget.Modelo)
                                  ),
                                  InkWell(
                                      onTap: (){
                                        setState(() {
                                          CFTV = 3;
                                        });
                                      },
                                      child: videoStream(widget.user, widget.pass, widget.ip, widget.porta, widget.camera3, widget.Modelo)
                                  ),
                                  InkWell(
                                      onTap: (){
                                        setState(() {
                                          CFTV = 4;
                                        });
                                      },
                                      child: videoStream(widget.user, widget.pass, widget.ip, widget.porta, widget.camera4, widget.Modelo)
                                  ),
                                  InkWell(
                                      onTap: (){
                                        setState(() {
                                          CFTV = 5;
                                        });
                                      },
                                      child: videoStream(widget.user, widget.pass, widget.ip, widget.porta, widget.camera5, widget.Modelo)
                                  ),
                                  InkWell(
                                      onTap: (){
                                        setState(() {
                                          CFTV = 6;
                                        });
                                      },
                                      child: videoStream(widget.user, widget.pass, widget.ip, widget.porta, widget.camera6, widget.Modelo)
                                  ),
                                  InkWell(
                                      onTap: (){
                                        setState(() {
                                          CFTV = 7;
                                        });
                                      },
                                      child: videoStream(widget.user, widget.pass, widget.ip, widget.porta, widget.camera7, widget.Modelo)
                                  ),
                                  InkWell(
                                      onTap: (){
                                        setState(() {
                                          CFTV = 8;
                                        });
                                      },
                                      child: videoStream(widget.user, widget.pass, widget.ip, widget.porta, widget.camera8, widget.Modelo)
                                  ),
                                  InkWell(
                                      onTap: (){
                                        setState(() {
                                          CFTV = 9;
                                        });
                                      },
                                      child: videoStream(widget.user, widget.pass, widget.ip, widget.porta, widget.camera9, widget.Modelo)
                                  ),
                                ],
                              )
                          ),
                        ),
                      ],
                    ),
                    CFTV == 0 ?
                    Container():
                    SizedBox(
                        width: widget.wid / 2,
                        height: widget.heig / 2.2,
                        child: Stack(
                            children: [
                              videoStreamAlert(widget.user, widget.pass, widget.ip, widget.porta, CFTV, widget.Modelo),
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
        ): Column(
          children: [
            AppBar(
              backgroundColor: widget.corDasBarras,
              centerTitle: true,
              title: Image.asset(
                  "assets/camera.png",
                  scale: 12
              ),
            ),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                child: Text(
                    'Selecione algum cliente para exibir as cameras!',
                  style: TextStyle(
                    color: textCAMS,
                  ),
                )
            ),
          ],
        ),
      );
    });
  }
}
