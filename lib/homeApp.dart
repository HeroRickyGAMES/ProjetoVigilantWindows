import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:sparta_monitoramento/getIds.dart';
import 'package:sparta_monitoramento/videoStream/videoStream.dart';
import 'package:uuid/uuid.dart';

//Desenvolvido por HeroRickyGames

String ip = '';
String user = "";
String pass = "";
int? porta;

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
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("Condominios")
                                      .where("IDEmpresaPertence", isEqualTo: UID)
                                      .snapshots(),
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

                                    if(snapshot.data!.docs.isEmpty){
                                      return const Center(child: CircularProgressIndicator());
                                    }

                                    return Container(
                                      width: double.infinity,
                                      height: heig - 439,
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
                                                });
                                                if(documents["Aviso"] != ""){
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
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
                        child: ip != "" ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(child:
                                    videoStream(user, pass, ip, porta!, 1)
                                ),
                                Expanded(child:
                                    videoStream(user, pass, ip, porta!, 2)
                                ),
                                Expanded(child:
                                    videoStream(user, pass, ip, porta!, 3)
                                ),
                                Expanded(child:
                                    videoStream(user, pass, ip, porta!, 4)
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(child:
                                    videoStream(user, pass, ip, porta!, 5)
                                ),
                                Expanded(child:
                                   videoStream(user, pass, ip, porta!, 6)
                                ),
                                Expanded(child:
                                    videoStream(user, pass, ip, porta!, 7)
                                ),
                                Expanded(child:
                                      videoStream(user, pass, ip, porta!, 8)
                                ),
                              ],
                            ),
                          ],
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
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(
                            child: Placeholder()
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                            child: Placeholder()
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
