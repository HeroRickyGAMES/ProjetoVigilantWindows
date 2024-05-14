import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sparta_monitoramento/getIds.dart';
import 'package:sparta_monitoramento/videoStream/VideoStreamAlert.dart';
import 'package:sparta_monitoramento/videoStream/videoStream.dart';
import 'package:sparta_monitoramento/voip/voipAPI.dart';
import 'package:uuid/uuid.dart';

//Desenvolvido por HeroRickyGames

String ip = '';
String user = "";
String pass = "";
int? porta;
bool pesquisando = false;

String idCondominio = "";

String pesquisa = '';

bool pesquisando2 = false;
String pesquisa2 = '';

class homeApp extends StatefulWidget {
  const homeApp({super.key});

  @override
  State<homeApp> createState() => _homeAppState();
}

class _homeAppState extends State<homeApp>{
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains){
      double wid = constrains.maxWidth;
      double heig = constrains.maxHeight;

      return Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: heig / 2,
                  child: Row(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            //UI começa aqui!
                            Column(
                              children: [
                                AppBar(
                                  backgroundColor: Colors.deepPurpleAccent,
                                  centerTitle: true,
                                  title: const Text('Condominios'),
                                ),
                                Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: TextField(
                                      keyboardType: TextInputType.name,
                                      enableSuggestions: true,
                                      autocorrect: true,
                                      onChanged: (value){
                                        setState(() {
                                          pesquisa = value;
                                        });

                                        if(value == ""){
                                          setState(() {
                                            pesquisando = false;
                                          });
                                        }else{
                                          setState(() {
                                            pesquisando = true;
                                          });
                                        }
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 3, color: Colors.grey), //<-- SEE HERE
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 3,
                                              color: Colors.black
                                          ),
                                        ),
                                        hintText: 'Pesquisar',

                                      ),
                                    ),
                                  ),
                                ),
                                StreamBuilder(
                                  stream: pesquisando == false ? FirebaseFirestore.instance
                                      .collection("Condominios")
                                      .where("IDEmpresaPertence", isEqualTo: UID)
                                      .snapshots():
                                  FirebaseFirestore.instance
                                      .collection("Condominios")
                                      .where("IDEmpresaPertence", isEqualTo: UID)
                                      .where("Nome", isGreaterThanOrEqualTo: pesquisa)
                                      .where("Nome", isLessThan: "${pesquisa}z")
                                      .snapshots(),
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    return Container(
                                      width: double.infinity,
                                      height: heig / 3.3,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1.0,
                                        ),
                                        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                      ),
                                      child: ListView(
                                        children: snapshot.data!.docs.map((documents){
                                          return InkWell(
                                            onTap: (){
                                                setState(() {
                                                  ip = documents["IpCamera"];
                                                  user = documents["UserAccess"];
                                                  pass = documents["PassAccess"];
                                                  porta = documents["PortaCameras"];
                                                  idCondominio = documents["idCondominio"];
                                                });
                                                if(documents["Aviso"] != ""){
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return Center(
                                                        child: SingleChildScrollView(
                                                          child: AlertDialog(
                                                            title: const Text('Aviso!'),
                                                            actions: [
                                                              Center(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Text(documents["Aviso"]),
                                                                    Container(
                                                                      padding: const EdgeInsets.all(16),
                                                                      child: ElevatedButton(onPressed: (){
                                                                        Navigator.pop(context);
                                                                      },
                                                                          child: const Text('Fechar')
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(16),
                                              child: SizedBox(
                                                width: double.infinity,
                                                height: 50,
                                                child: Text(documents['Nome']),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              padding: const EdgeInsets.all(16),
                              child: FloatingActionButton(onPressed: (){
                                String NomeCondominio = "";
                                String IPCameras = "";
                                int? PortaCameras;
                                String UserAccess = "";
                                String PassAccess = "";
                                String Aviso = "";

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                                      return SingleChildScrollView(
                                        child: AlertDialog(
                                          title: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text('Crie um novo condominio!'),
                                                IconButton(onPressed: (){
                                                  Navigator.pop(context);
                                                }, icon: const Icon(Icons.close)
                                                )
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            Center(
                                              child: Container(
                                                padding: const EdgeInsets.all(16),
                                                child: TextField(
                                                  keyboardType: TextInputType.emailAddress,
                                                  enableSuggestions: false,
                                                  autocorrect: false,
                                                  onChanged: (value){
                                                    setState(() {
                                                      NomeCondominio = value;
                                                    });
                                                  },
                                                  decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(width: 3, color: Colors.grey), //<-- SEE HERE
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 3,
                                                          color: Colors.black
                                                      ),
                                                    ),
                                                    labelText: 'Nome do Condominio',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                padding: const EdgeInsets.all(16),
                                                child: TextField(
                                                  keyboardType: TextInputType.emailAddress,
                                                  enableSuggestions: false,
                                                  autocorrect: false,
                                                  onChanged: (value){
                                                    setState(() {
                                                      IPCameras = value;
                                                    });
                                                  },
                                                  decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(width: 3, color: Colors.grey), //<-- SEE HERE
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 3,
                                                          color: Colors.black
                                                      ),
                                                    ),
                                                    labelText: 'URL das Cameras',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                padding: const EdgeInsets.all(16),
                                                child: TextField(
                                                  keyboardType: TextInputType.emailAddress,
                                                  enableSuggestions: false,
                                                  autocorrect: false,
                                                  onChanged: (value){
                                                    setState(() {
                                                      PortaCameras = int.parse(value);
                                                    });
                                                  },
                                                  decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(width: 3, color: Colors.grey), //<-- SEE HERE
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 3,
                                                          color: Colors.black
                                                      ),
                                                    ),
                                                    labelText: 'Porta RTSP das Cameras (Normalmente é 554)',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                padding: const EdgeInsets.all(16),
                                                child: TextField(
                                                  keyboardType: TextInputType.emailAddress,
                                                  enableSuggestions: false,
                                                  autocorrect: false,
                                                  onChanged: (value){
                                                    setState(() {
                                                      UserAccess = value;
                                                    });
                                                  },
                                                  decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(width: 3, color: Colors.grey), //<-- SEE HERE
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 3,
                                                          color: Colors.black
                                                      ),
                                                    ),
                                                    labelText: 'Usuario para acesso das cameras',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                padding: const EdgeInsets.all(16),
                                                child: TextField(
                                                  keyboardType: TextInputType.emailAddress,
                                                  enableSuggestions: false,
                                                  autocorrect: false,
                                                  onChanged: (value){
                                                    setState(() {
                                                      PassAccess = value;
                                                    });
                                                  },
                                                  decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(width: 3, color: Colors.grey), //<-- SEE HERE
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 3,
                                                          color: Colors.black
                                                      ),
                                                    ),
                                                    labelText: 'Senha para acesso das cameras',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                padding: const EdgeInsets.all(16),
                                                child: TextField(
                                                  keyboardType: TextInputType.emailAddress,
                                                  enableSuggestions: false,
                                                  autocorrect: false,
                                                  onChanged: (value){
                                                    setState(() {
                                                      UserAccess = value;
                                                    });
                                                  },
                                                  decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(width: 3, color: Colors.grey), //<-- SEE HERE
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 3,
                                                          color: Colors.black
                                                      ),
                                                    ),
                                                    labelText: 'Usuario para acesso das cameras',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                padding: const EdgeInsets.all(16),
                                                child: TextField(
                                                  keyboardType: TextInputType.emailAddress,
                                                  enableSuggestions: false,
                                                  autocorrect: false,
                                                  onChanged: (value){
                                                    setState(() {
                                                      Aviso = value;
                                                    });
                                                  },
                                                  decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(width: 3, color: Colors.grey), //<-- SEE HERE
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 3,
                                                          color: Colors.black
                                                      ),
                                                    ),
                                                    labelText: 'Aviso',
                                                  ),
                                                ),
                                              ),
                                            ),
                                              ElevatedButton(onPressed: (){
                                                  if(NomeCondominio == ""){
                                                    showToast("O nome do Condominio está vazio!",context:context);
                                                  }else{
                                                    if(IPCameras == ""){
                                                      showToast("A URL das Cameras está vazia!",context:context);
                                                    }else{
                                                      if(PortaCameras == null){
                                                        showToast("A Porta em RTSP das Cameras está vazia!",context:context);
                                                      }else{
                                                        if(UserAccess == ""){
                                                          showToast("O Usuario para acesso das cameras está vazio!",context:context);
                                                        }else{
                                                          if(PassAccess == ""){
                                                            showToast("A Senha para acesso das cameras está vazia!",context:context);
                                                          }else{
                                                            Uuid uuid = const Uuid();
                                                            String UUID = uuid.v4();
                                                            FirebaseFirestore.instance.collection('Condominios').doc(UUID).set({
                                                                "idCondominio": UUID,
                                                                "IDEmpresaPertence": UID,
                                                                "Nome": NomeCondominio,
                                                                "IpCamera": IPCameras,
                                                                "PortaCameras": PortaCameras,
                                                                "UserAccess": UserAccess,
                                                                "PassAccess": PassAccess,
                                                                "Aviso": Aviso
                                                            }).whenComplete(() {
                                                                Navigator.pop(context);
                                                            });
                                                          }
                                                        }
                                                      }
                                                    }
                                                  }
                                              },child: const Text('Registrar novo Condominio')
                                            )
                                          ],
                                        ),
                                      );
                                    },);
                                  },
                                );
                              },
                                child: const Icon(Icons.add),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ip != "" ? Stack(
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: (){
                                  setState(() {
                                    ip = '';
                                    user = "";
                                    pass = "";
                                    porta = null;
                                  });
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppBar(
                                  backgroundColor: Colors.deepPurpleAccent,
                                  centerTitle: true,
                                  title: const Text('IP Cameras'),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                          onTap: (){
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Center(
                                                  child: SingleChildScrollView(
                                                    child: AlertDialog(
                                                      title: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          const Text('Visualização'),
                                                          IconButton(onPressed: (){
                                                            Navigator.pop(context);
                                                          },
                                                              icon: const Icon(Icons.close)
                                                          )
                                                        ],
                                                      ),
                                                      actions: [
                                                        Center(
                                                          child: SizedBox(
                                                              width: 900,
                                                              height: 600,
                                                              child: videoStreamAlert(user, pass, ip, porta!, 1)
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                            child: videoStream(user, pass, ip, porta!, 1)
                                        )
                                        ),
                                        Expanded(
                                            child: InkWell(
                                            onTap: (){
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return Center(
                                                    child: SingleChildScrollView(
                                                      child: AlertDialog(
                                                        title: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            const Text('Visualização'),
                                                            IconButton(onPressed: (){
                                                              Navigator.pop(context);
                                                            },
                                                                icon: const Icon(Icons.close)
                                                            )
                                                          ],
                                                        ),
                                                        actions: [
                                                          Center(
                                                            child: SizedBox(
                                                                width: 900,
                                                                height: 600,
                                                                child: videoStreamAlert(user, pass, ip, porta!, 2)
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: videoStream(user, pass, ip, porta!, 2)
                                        )
                                        ),
                                        Expanded(
                                            child: InkWell(
                                            onTap: (){
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return Center(
                                                    child: SingleChildScrollView(
                                                      child: AlertDialog(
                                                        title: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            const Text('Visualização'),
                                                            IconButton(onPressed: (){
                                                              Navigator.pop(context);
                                                            },
                                                                icon: const Icon(Icons.close)
                                                            )
                                                          ],
                                                        ),
                                                        actions: [
                                                          Center(
                                                            child: SizedBox(
                                                                width: 900,
                                                                height: 600,
                                                                child: videoStreamAlert(user, pass, ip, porta!, 3)
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: videoStream(user, pass, ip, porta!, 3)
                                        )
                                        ),
                                        Expanded(
                                            child: InkWell(
                                            onTap: (){
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return Center(
                                                    child: SingleChildScrollView(
                                                      child: AlertDialog(
                                                        title: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            const Text('Visualização'),
                                                            IconButton(onPressed: (){
                                                              Navigator.pop(context);
                                                            },
                                                                icon: const Icon(Icons.close)
                                                            )
                                                          ],
                                                        ),
                                                        actions: [
                                                          Center(
                                                            child: SizedBox(
                                                                width: 900,
                                                                height: 600,
                                                                child: videoStreamAlert(user, pass, ip, porta!, 4)
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: videoStream(user, pass, ip, porta!, 4)
                                        )
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: InkWell(
                                            onTap: (){
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return Center(
                                                    child: SingleChildScrollView(
                                                      child: AlertDialog(
                                                        title: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            const Text('Visualização'),
                                                            IconButton(onPressed: (){
                                                              Navigator.pop(context);
                                                            },
                                                                icon: const Icon(Icons.close)
                                                            )
                                                          ],
                                                        ),
                                                        actions: [
                                                          Center(
                                                            child: SizedBox(
                                                                width: 900,
                                                                height: 600,
                                                                child: videoStreamAlert(user, pass, ip, porta!, 5)
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: videoStream(user, pass, ip, porta!, 5)
                                        )
                                        ),
                                        Expanded(
                                            child: InkWell(
                                            onTap: (){
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return Center(
                                                    child: SingleChildScrollView(
                                                      child: AlertDialog(
                                                        title: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            const Text('Visualização'),
                                                            IconButton(onPressed: (){
                                                              Navigator.pop(context);
                                                            },
                                                                icon: const Icon(Icons.close)
                                                            )
                                                          ],
                                                        ),
                                                        actions: [
                                                          Center(
                                                            child: SizedBox(
                                                                width: 900,
                                                                height: 600,
                                                                child: videoStreamAlert(user, pass, ip, porta!, 6)
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: videoStream(user, pass, ip, porta!, 6)
                                        )
                                        ),
                                        Expanded(
                                            child: InkWell(
                                            onTap: (){
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return Center(
                                                    child: SingleChildScrollView(
                                                      child: AlertDialog(
                                                        title: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            const Text('Visualização'),
                                                            IconButton(onPressed: (){
                                                              Navigator.pop(context);
                                                            },
                                                                icon: const Icon(Icons.close)
                                                            )
                                                          ],
                                                        ),
                                                        actions: [
                                                          Center(
                                                            child: SizedBox(
                                                                width: 900,
                                                                height: 600,
                                                                child: videoStreamAlert(user, pass, ip, porta!, 7)
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: videoStream(user, pass, ip, porta!, 7)
                                        )
                                        ),
                                        Expanded(
                                            child: InkWell(
                                            onTap: (){
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return Center(
                                                    child: SingleChildScrollView(
                                                      child: AlertDialog(
                                                        title: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            const Text('Visualização'),
                                                            IconButton(onPressed: (){
                                                              Navigator.pop(context);
                                                            },
                                                                icon: const Icon(Icons.close)
                                                            )
                                                          ],
                                                        ),
                                                        actions: [
                                                          Center(
                                                            child: SizedBox(
                                                                width: 900,
                                                                height: 600,
                                                                child: videoStreamAlert(user, pass, ip, porta!, 8)
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: videoStream(user, pass, ip, porta!, 8)
                                        )
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ]
                        ): Container(
                            alignment: Alignment.center,
                            child: const Text('Abra algum condominio para exibir as cameras!')
                        )
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: heig / 2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Stack(
                            children: [
                              //UI começa aqui!
                              idCondominio != "" ? Column(
                                children: [
                                  AppBar(
                                    backgroundColor: Colors.deepPurpleAccent,
                                    centerTitle: true,
                                    title: const Text('Visitantes e Moradores'),
                                  ),
                                  Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: TextField(
                                        keyboardType: TextInputType.name,
                                        enableSuggestions: true,
                                        autocorrect: true,
                                        onChanged: (value){
                                          setState(() {
                                            pesquisa = value;
                                          });

                                          if(value == ""){
                                            setState(() {
                                              pesquisando2 = false;
                                            });
                                          }else{
                                            setState(() {
                                              pesquisando2 = true;
                                            });
                                          }
                                        },
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(width: 3, color: Colors.grey), //<-- SEE HERE
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 3,
                                                color: Colors.black
                                            ),
                                          ),
                                          hintText: 'Pesquisar (CPF)',
                                        ),
                                      ),
                                    ),
                                  ),
                                  StreamBuilder(
                                    stream: pesquisando == false ? FirebaseFirestore.instance
                                        .collection("Pessoas")
                                        .where("idCondominio", isEqualTo: idCondominio)
                                        .snapshots():
                                    FirebaseFirestore.instance
                                        .collection("Pessoas")
                                        .where("idCondominio", isEqualTo: idCondominio)
                                        .where("CPF", isGreaterThanOrEqualTo: pesquisa2)
                                        .where("CPF", isLessThan: "${pesquisa2}z")
                                        .snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

                                      if (!snapshot.hasData) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      return Container(
                                        width: double.infinity,
                                        height: heig / 3.3,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 1.0,
                                          ),
                                          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                        ),
                                        child: ListView(
                                          children: snapshot.data!.docs.map((documents){
                                            return InkWell(
                                              onTap: (){
                                                String anotacao = documents["anotacao"];

                                                TextEditingController controller = TextEditingController(text: anotacao);

                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                                                      return Center(
                                                        child: SingleChildScrollView(
                                                          child: AlertDialog(
                                                            title: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                const Text('Detalhes'),
                                                                IconButton(onPressed: (){
                                                                  Navigator.pop(context);
                                                                }, icon: const Icon(Icons.close)
                                                                )
                                                              ],
                                                            ),
                                                            actions: [
                                                              Center(
                                                                child: Column(
                                                                  children: [
                                                                    Center(
                                                                      child: Container(
                                                                        padding: const EdgeInsets.all(16),
                                                                        child: Column(
                                                                          children: [
                                                                            Container(
                                                                                padding: const EdgeInsets.all(8),
                                                                                child: Image.network(documents["imageURI"])
                                                                            ),
                                                                            Container(
                                                                                padding: const EdgeInsets.all(8),
                                                                                child: Text("Nome: ${documents["Nome"]}")
                                                                            ),
                                                                            Container(
                                                                                padding: const EdgeInsets.all(8),
                                                                                child: Text("CPF: ${documents["CPF"]}")
                                                                            ),
                                                                            TextField(
                                                                              controller: controller,
                                                                              keyboardType: TextInputType.emailAddress,
                                                                              enableSuggestions: false,
                                                                              autocorrect: false,
                                                                              onChanged: (value){
                                                                                setState(() {
                                                                                  anotacao = value;
                                                                                });
                                                                              },
                                                                              decoration: const InputDecoration(
                                                                                border: OutlineInputBorder(),
                                                                                enabledBorder: OutlineInputBorder(
                                                                                  borderSide: BorderSide(width: 3, color: Colors.grey), //<-- SEE HERE
                                                                                ),
                                                                                focusedBorder: OutlineInputBorder(
                                                                                  borderSide: BorderSide(
                                                                                      width: 3,
                                                                                      color: Colors.black
                                                                                  ),
                                                                                ),
                                                                                labelText: 'Anotação',
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        TextButton(
                                                                            onPressed: (){
                                                                              Navigator.of(context).pop();
                                                                            }, child: const Text('Fechar')
                                                                        ),
                                                                        TextButton(
                                                                            onPressed: (){
                                                                              FirebaseFirestore.instance.collection('Pessoas').doc(documents['id']).update({
                                                                                "anotacao": anotacao
                                                                              }).whenComplete(() {
                                                                                Navigator.of(context).pop();
                                                                              });
                                                                            }, child: const Text('Salvar')
                                                                        )
                                                                      ],
                                                                    ),

                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },);
                                                  },
                                                );
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(16),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  height: 50,
                                                  child: Column(
                                                    children: [
                                                      Text("Nome: ${documents['Nome']}"),
                                                      Text("Tipo: ${documents['tipoDeUser']}"),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ):  Center(
                                child: Column(
                                  children: [
                                    AppBar(
                                      backgroundColor: Colors.deepPurpleAccent,
                                      centerTitle: true,
                                      title: const Text('Visitantes e Moradores'),
                                    ),
                                    const Center(
                                        child: Text('Selecione o condominio')
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.bottomRight,
                                padding: const EdgeInsets.all(16),
                                child: FloatingActionButton(onPressed: (){
                                  String NomeV = "";
                                  String CPFV = "";
                                  String RGV = "";
                                  DateTime selectedDate = DateTime.now();
                                  String dropdownValue = 'Morador';
                                  File? _imageFile;
                                  final picker = ImagePicker();

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                                        return Center(
                                          child: SingleChildScrollView(
                                            child: AlertDialog(
                                              title: Center(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text('Cadastre-se um morador ou visitante'),
                                                    IconButton(onPressed: (){
                                                      Navigator.pop(context);
                                                    }, icon: const Icon(Icons.close)
                                                    )
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                Center(
                                                  child: Container(
                                                    padding: const EdgeInsets.all(16),
                                                    child: TextField(
                                                      keyboardType: TextInputType.emailAddress,
                                                      enableSuggestions: false,
                                                      autocorrect: false,
                                                      onChanged: (value){
                                                        setState(() {
                                                          NomeV = value;
                                                        });
                                                      },
                                                      decoration: const InputDecoration(
                                                        border: OutlineInputBorder(),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(width: 3, color: Colors.grey), //<-- SEE HERE
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              width: 3,
                                                              color: Colors.black
                                                          ),
                                                        ),
                                                        labelText: 'Nome',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Center(
                                                  child: Container(
                                                    padding: const EdgeInsets.all(16),
                                                    child: TextField(
                                                      keyboardType: TextInputType.emailAddress,
                                                      enableSuggestions: false,
                                                      autocorrect: false,
                                                      onChanged: (value){
                                                        setState(() {
                                                          CPFV = value;
                                                        });
                                                      },
                                                      decoration: const InputDecoration(
                                                        border: OutlineInputBorder(),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(width: 3, color: Colors.grey), //<-- SEE HERE
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              width: 3,
                                                              color: Colors.black
                                                          ),
                                                        ),
                                                        labelText: 'CPF',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Center(
                                                  child: Container(
                                                    padding: const EdgeInsets.all(16),
                                                    child: TextField(
                                                      keyboardType: TextInputType.emailAddress,
                                                      enableSuggestions: false,
                                                      autocorrect: false,
                                                      onChanged: (value){
                                                        setState(() {
                                                          RGV = value;
                                                        });
                                                      },
                                                      decoration: const InputDecoration(
                                                        border: OutlineInputBorder(),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(width: 3, color: Colors.grey), //<-- SEE HERE
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              width: 3,
                                                              color: Colors.black
                                                          ),
                                                        ),
                                                        labelText: 'RG',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Center(
                                                  child: Container(
                                                      padding: const EdgeInsets.all(16),
                                                      child: Text(selectedDate == null ? 'Selecione a data de nascimento' :
                                                      "Data de nacimento ${selectedDate.year}/${selectedDate.month}/${selectedDate.day}")
                                                  ),
                                                ),
                                                Center(
                                                  child: Container(
                                                      padding: const EdgeInsets.all(16),
                                                      child: const Text('Selecione se é Morador ou Visitante')
                                                  ),
                                                ),
                                                Center(
                                                  child: DropdownButton<String>(
                                                    value: dropdownValue,
                                                    onChanged: (String? newValue) {
                                                      setState(() {
                                                        dropdownValue = newValue!;
                                                      });
                                                    },
                                                    items: <String>['Morador', 'Visitante']
                                                        .map<DropdownMenuItem<String>>((String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                                Center(
                                                  child: Container(
                                                      padding: const EdgeInsets.all(16),
                                                      child: ElevatedButton(
                                                        onPressed: () async {
                                                          final DateTime? picked = await showDatePicker(
                                                            context: context,
                                                            initialDate: selectedDate,
                                                            firstDate: DateTime(1800, 8),
                                                            lastDate: DateTime(2101),
                                                          );
                                                          if (picked != null && picked != selectedDate) {
                                                            setState(() {
                                                              selectedDate = picked;
                                                            });
                                                          }
                                                        },
                                                        child: const Text('Selecione uma data'),
                                                      )
                                                  ),
                                                ),
                                                _imageFile != null ? Center(
                                                  child: SizedBox(
                                                    width: 300,
                                                    height: 300,
                                                    child: Image.file(_imageFile!),
                                                  ),
                                                ): Container(),
                                                Center(
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

                                                      setState(() {
                                                        if (pickedFile != null) {
                                                          _imageFile = File(pickedFile.path);
                                                        } else {
                                                          showToast("Imagem não selecionada!",context:context);
                                                        }
                                                      });
                                                    },
                                                    child: const Text('Selecione uma Imagem de perfil'),
                                                  ),
                                                ),
                                                ElevatedButton(onPressed: () async {
                                                  if(NomeV == ""){
                                                    showToast("O nome está vazio!",context:context);
                                                  }else{
                                                    if(CPFV == ""){
                                                      showToast("O CPF está vazio!",context:context);
                                                    }else{
                                                      if(RGV == ""){
                                                        showToast("O RG está vazio!",context:context);
                                                      }else{
                                                        if(selectedDate == null){
                                                          showToast("A data está vazia!",context:context);
                                                        }else{
                                                          if(dropdownValue == ""){
                                                            showToast("Selecione se é morador ou visitante",context:context);
                                                          }else{
                                                            if(_imageFile == null){
                                                              showToast("Selecione uma foto!",context:context);
                                                            }else{
                                                              showDialog(
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return const AlertDialog(
                                                                    title: Text('Aguarde!'),
                                                                    actions: [
                                                                      Center(
                                                                        child: CircularProgressIndicator(),
                                                                      )
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                              Uuid uuid = const Uuid();
                                                              String UUID = uuid.v4();

                                                              FirebaseStorage storage = FirebaseStorage.instance;
                                                              Reference ref = storage.ref().child('images/$idCondominio/$UUID');
                                                              await ref.putFile(_imageFile!).whenComplete(() {
                                                                showToast("Imagem carregada!",context:context);
                                                              }).catchError((e){
                                                                showToast("Houve uma falha no carregamento! codigo do erro: $e",context:context);
                                                                showToast("Repasse esse erro para o desenvolvedor!",context:context);
                                                              });


                                                              FirebaseFirestore.instance.collection('Pessoas').doc(UUID).set({
                                                                "id": UUID,
                                                                "idCondominio": idCondominio,
                                                                "Nome": NomeV,
                                                                "CPF": CPFV,
                                                                "RG": RGV,
                                                                "DataNascimento": "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}",
                                                                "tipoDeUser": dropdownValue,
                                                                "imageURI": await ref.getDownloadURL(),
                                                                "anotacao": "",
                                                              }).whenComplete(() {
                                                                Navigator.pop(context);
                                                                Navigator.pop(context);
                                                              });
                                                            }
                                                          }
                                                        }
                                                      }
                                                    }
                                                  }
                                                },child: const Text('Registrar novo Condominio')
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },);
                                    },
                                  );
                                },
                                  child: const Icon(Icons.add),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: (){
                                    setState(() {
                                      idCondominio = "";
                                    });
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                              ),
                            ],
                          )
                      ),
                      Expanded(
                        child: SizedBox(
                            child: Center(
                                  child: audioStream("admin", "", "sip2.vtcall.com.br", 554, 0)
                            )
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
