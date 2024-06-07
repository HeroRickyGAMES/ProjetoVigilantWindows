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

//Strings
String ip = '';
String user = "";
String pass = "";
String anotacao = "";
String idCondominio = "";
String idCondominioAnt = "";
String pesquisa2 = '';
String pesquisa = '';
String imageURL = "";
String imageURLMorador = "";
String NomeMorador = "";
String RGMorador = "";
String CPFMorador = "";
String DatadeNascimentoMorador = "";
String PlacaMorador = "";
String anotacaoMorador = "";
String MoradorId = "";
String UnidadeMorador = "";
String BlocoMorador = "";

//Controladores
TextEditingController anotacaoControl = TextEditingController(text: anotacaoMorador);

//Booleanos
bool pesquisando = false;
bool pesquisando2 = false;
bool moradorselecionado = false;
bool pesquisaNumeros = false;

//Inteiros
int? porta;
int colunasIPCamera = 4;

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
            child: SizedBox(
              width: wid,
              height: heig,
              child: Column(
                children: [
                  AppBar(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Barra de ferramentas"),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                useVoIP();
                              },
                              child: const Text("VoIP")
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  useVoIP();
                                },
                                child: const Text("Visitantes")
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  useVoIP();
                                },
                                child: const Text("Veiculos")
                            ),
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              useVoIP();
                            },
                            child: const Text("Configurações")
                        ),
                      ],
                    ),
                    backgroundColor: Colors.deepPurpleAccent,
                  ),
                  SizedBox(
                    width: wid,
                    height: heig - 57,
                    child: Row(
                      children: [
                        SizedBox(
                          width: wid / 4,
                          height: heig,
                          child: Stack(
                            children: [
                              //UI começa aqui!
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    AppBar(
                                      backgroundColor: Colors.deepPurpleAccent,
                                      centerTitle: true,
                                      title: const Text('Clientes'),
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
                                
                                            RegExp numeros = RegExp(r'[0-9]');
                                
                                            if(numeros.hasMatch(value)){
                                              setState(() {
                                                pesquisaNumeros = true;
                                              });
                                            }else{
                                              setState(() {
                                                pesquisaNumeros = false;
                                              });
                                            }
                                            
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
                                            hintText: 'Pesquisar (Codigo de Cadastro ou Nome)',
                                          ),
                                        ),
                                      ),
                                    ),
                                    StreamBuilder(
                                      stream: pesquisando == true ?
                                      pesquisaNumeros == false ? FirebaseFirestore.instance
                                          .collection("Condominios")
                                          .where("IDEmpresaPertence", isEqualTo: UID)
                                          .where("Nome", isGreaterThanOrEqualTo: pesquisa)
                                          .where("Nome", isLessThan: "${pesquisa}z")
                                          .snapshots()
                                          :
                                      FirebaseFirestore.instance
                                          .collection("Condominios")
                                          .where("IDEmpresaPertence", isEqualTo: UID)
                                          .where("Codigo", isGreaterThanOrEqualTo: pesquisa)
                                          .where("Codigo", isLessThan: "${pesquisa}9")
                                          .snapshots()
                                          :
                                      FirebaseFirestore.instance
                                          .collection("Condominios")
                                          .where("IDEmpresaPertence", isEqualTo: UID)
                                          .snapshots(),
                                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                
                                        if (!snapshot.hasData) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                
                                        return Container(
                                          width: double.infinity,
                                          height: heig / 1.24,
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
                                                    anotacao = documents["Aviso"];
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
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text("${documents["Codigo"]} ${documents['Nome']}"),
                                                        IconButton(onPressed: (){
                                                          setState(() {
                                                            anotacao = documents["Aviso"];
                                                            idCondominioAnt = documents["idCondominio"];
                                                            anotacaoControl.text = anotacao;
                                                          });
                                                        },
                                                            icon: Icon(
                                                                color: documents["Aviso"] == "" ? Colors.red : Colors.green,
                                                                Icons.edit_note
                                                            )
                                                        )
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
                                ),
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
                                  String SIPUrl = "";
                                  String Porta = "";
                                  String AuthUser = "";
                                  String Pass = "";
                                  String codigo = "";

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
                                                        codigo = value;
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
                                                      labelText: 'Codigo do Condominio (4 caracteres Ex: 2402)',
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
                                                        SIPUrl = value;
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
                                                      labelText: 'SIP Url (sip2.chamada.com.br)',
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
                                                        Porta = value;
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
                                                      labelText: 'SIP Porta (5060)',
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
                                                        AuthUser = value;
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
                                                      labelText: 'Usuario de acesso do SIP',
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
                                                        Pass = value;
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
                                                      labelText: 'Senha de acesso do SIP',
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
                                                  if(codigo == ""){
                                                    showToast("O codigo está vazio!",context:context);
                                                  }else{
                                                    if(codigo.length == 4){
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
                                                              if(SIPUrl == ""){
                                                                showToast("A URL do SIP não pode estar vazia!",context:context);
                                                              }else{
                                                                if(Porta == ""){
                                                                  showToast("A porta do SIP não pode estar vazia!",context:context);
                                                                }else{
                                                                  if(AuthUser == ""){
                                                                    showToast("o acesso do usuario do SIP não pode estar vazio!",context:context);
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
                                                                      "Aviso": Aviso,
                                                                      "SIPUrl": SIPUrl,
                                                                      "PortaSIP": Porta,
                                                                      "authUserSIP": AuthUser,
                                                                      "authSenhaSIP": Pass,
                                                                      "Codigo" : codigo
                                                                    }).whenComplete(() {
                                                                      Navigator.pop(context);
                                                                    });
                                                                  }
                                                                }
                                                              }
                                                            }
                                                          }
                                                        }
                                                      }
                                                    }else{
                                                      if(codigo.length > 4){
                                                        showToast("Existem mais caracteres do que o permitido no codigo do condominio!",context:context);
                                                      }
                                                      if(codigo.length < 4){
                                                        showToast("Existem menos caracteres do que o permitido no codigo do condominio!",context:context);
                                                      }
                                                    }
                                                  }
                                                }
                                              },child: const Text('Registrar novo Condominio')
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                      );
                                    },
                                  );
                                },
                                  child: const Icon(Icons.add),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: wid / 2,
                          height: heig,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: wid / 2,
                                height: heig / 2,
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
                                        children: [
                                          AppBar(
                                            backgroundColor: Colors.deepPurpleAccent,
                                            centerTitle: true,
                                            title: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                const Text('CFTV'),
                                                Row(
                                                  children: [
                                                    ElevatedButton(onPressed: (){
                                                        setState(() {
                                                          colunasIPCamera = 1;
                                                        });
                                                    },
                                                        child: const Text('1')
                                                    ),
                                                    ElevatedButton(onPressed: (){
                                                      setState(() {
                                                        colunasIPCamera = 2;
                                                      });
                                                    },
                                                        child: const Text('2')
                                                    ),
                                                    ElevatedButton(onPressed: (){
                                                      setState(() {
                                                        colunasIPCamera = 3;
                                                      });
                                                    },
                                                        child: const Text('3')
                                                    ),
                                                    ElevatedButton(onPressed: (){
                                                      setState(() {
                                                        colunasIPCamera = 4;
                                                      });
                                                    },
                                                        child: const Text('4')
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  width: wid / 2,
                                                  height: heig / 2.3,
                                                  child: GridView.count(crossAxisCount: colunasIPCamera,
                                                    children: [
                                                      InkWell(
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
                                                      ),
                                                      InkWell(
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
                                                      ),
                                                      InkWell(
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
                                                      ),
                                                      InkWell(
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
                                                      ),
                                                      InkWell(
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
                                                      ),
                                                      InkWell(
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
                                                      ),
                                                      InkWell(
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
                                                      ),
                                                      InkWell(
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
                                                      ),
                                                    ],
                                                  )
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ]
                                ): Column(
                                  children: [
                                    AppBar(
                                      backgroundColor: Colors.deepPurpleAccent,
                                      centerTitle: true,
                                      title: const Text('CFTV')
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(16),
                                        child: const Text('Selecione algum cliente para exibir as cameras!')
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: wid / 2,
                                height: heig / 3,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      AppBar(
                                        title: Container(
                                          padding: const EdgeInsets.only(left: 120, right: 170),
                                          child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Acionamento'),
                                              Text('Ramais'),
                                            ],
                                          ),
                                        ),
                                        backgroundColor: Colors.deepPurpleAccent,
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                width: wid / 4,
                                                height: heig / 8,
                                                child: GridView.count(crossAxisCount: 4,
                                                children: [
                                                  Container(
                                                    width: 100,
                                                    height: 100,
                                                    padding: const EdgeInsets.all(16),
                                                    child: IconButton(onPressed: (){
                                  
                                                    },
                                                        icon: const Icon(Icons.toggle_on)
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    height: 100,
                                                    padding: const EdgeInsets.all(16),
                                                    child: IconButton(onPressed: (){
                                  
                                                    },
                                                        icon: const Icon(Icons.toggle_on)
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    height: 100,
                                                    padding: const EdgeInsets.all(16),
                                                    child: IconButton(onPressed: (){
                                  
                                                    },
                                                        icon: const Icon(Icons.toggle_on)
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    height: 100,
                                                    padding: const EdgeInsets.all(16),
                                                    child: IconButton(onPressed: (){
                                  
                                                    },
                                                        icon: const Icon(Icons.toggle_on)
                                                    ),
                                                  ),
                                                ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: wid / 4,
                                                height: heig / 7,
                                                child: GridView.count(crossAxisCount: 4,
                                                  children: [
                                                    Container(
                                                      width: 100,
                                                      height: 100,
                                                      padding: const EdgeInsets.all(16),
                                                      child: IconButton(onPressed: (){
                                  
                                                      },
                                                          icon: const Icon(Icons.toggle_on)
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 100,
                                                      height: 100,
                                                      padding: const EdgeInsets.all(16),
                                                      child: IconButton(onPressed: (){
                                  
                                                      },
                                                          icon: const Icon(Icons.toggle_on)
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 100,
                                                      height: 100,
                                                      padding: const EdgeInsets.all(16),
                                                      child: IconButton(onPressed: (){
                                  
                                                      },
                                                          icon: const Icon(Icons.toggle_on)
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 100,
                                                      height: 100,
                                                      padding: const EdgeInsets.all(16),
                                                      child: IconButton(onPressed: (){
                                  
                                                      },
                                                          icon: const Icon(Icons.toggle_on)
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Stack(
                                            children: [
                                              StreamBuilder(stream: FirebaseFirestore.instance
                                                  .collection("Ramais")
                                                  .where("IDEmpresaPertence", isEqualTo: UID)
                                                  .snapshots(), builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                                if (!snapshot.hasData) {
                                                  return const Center(
                                                    child: CircularProgressIndicator(),
                                                  );
                                                }
                                                return Container(
                                                  width: wid / 4.3,
                                                  height: heig / 4,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.black,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                                  ),
                                                  child: ListView(
                                                    children: snapshot.data!.docs.map((documents){
                                                      return SizedBox(
                                                        width: double.infinity,
                                                        height: 50,
                                                        child: Center(
                                                          child: Text(documents['RamalIp']),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                );
                                              }
                                              ),
                                              Container(
                                                alignment: Alignment.bottomRight,
                                                padding: const EdgeInsets.all(16),
                                                child: FloatingActionButton(onPressed:
                                                idCondominio == "" ? null :(){
                                  
                                                },
                                                  child: const Icon(Icons.add),
                                                ),
                                              ),
                                            ]
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: wid / 4,
                              height: heig / 1.5,
                              child: Stack(
                                children: [
                                  idCondominio != "" ?
                                  SingleChildScrollView(
                                    child: Column(
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
                                          stream: pesquisando2 == false ? FirebaseFirestore.instance
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

                                            return Column(
                                              children: [
                                                Container(
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
                                                            moradorselecionado = true;
                                                            NomeMorador = documents["Nome"];
                                                            RGMorador = documents["RG"];
                                                            CPFMorador = documents["CPF"];
                                                            DatadeNascimentoMorador = documents["DataNascimento"];
                                                            PlacaMorador = documents["placa"];
                                                            imageURLMorador = documents["imageURI"];
                                                            anotacaoMorador = documents["anotacao"];
                                                            anotacaoControl.text = anotacaoMorador;
                                                            MoradorId = documents["id"];
                                                            UnidadeMorador = documents["Unidade"];
                                                            BlocoMorador = documents["Bloco"];
                                                          });
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
                                                ),
                                                moradorselecionado == true ?
                                                Stack(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.all(16),
                                                      alignment: Alignment.centerRight,
                                                      child: IconButton(
                                                        onPressed: (){
                                                          setState(() {
                                                            setState(() {
                                                              moradorselecionado = false;
                                                              NomeMorador = "";
                                                              RGMorador = "";
                                                              CPFMorador = "";
                                                              DatadeNascimentoMorador = "";
                                                              PlacaMorador = "";
                                                              imageURLMorador = "";
                                                              anotacaoMorador = "";
                                                              anotacaoControl.text = "";
                                                              MoradorId = "";
                                                              UnidadeMorador = "";
                                                              BlocoMorador = "";
                                                            });
                                                          });
                                                        },
                                                        icon: const Icon(Icons.close)
                                                      ),
                                                    ),
                                                    Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                                padding: const EdgeInsets.all(8),
                                                                child: Image.network(
                                                                    height: 100,
                                                                    width: 100,
                                                                    imageURLMorador
                                                                )
                                                            ),
                                                            Column(
                                                              children: [
                                                                Container(
                                                                    padding: const EdgeInsets.all(8),
                                                                    child: Text("Nome: $NomeMorador")
                                                                ),
                                                                Container(
                                                                    padding: const EdgeInsets.all(8),
                                                                    child: Text("RG: $RGMorador")
                                                                ),
                                                                Container(
                                                                    padding: const EdgeInsets.all(8),
                                                                    child: Text("CPF: $CPFMorador")
                                                                ),
                                                                Container(
                                                                    padding: const EdgeInsets.all(8),
                                                                    child: Text("Data de nascimento: $DatadeNascimentoMorador")
                                                                ),
                                                                Container(
                                                                    padding: const EdgeInsets.all(8),
                                                                    child: Text("Placa: $PlacaMorador")
                                                                ),
                                                                Container(
                                                                    padding: const EdgeInsets.all(8),
                                                                    child: Text("Unidade: $UnidadeMorador")
                                                                ),
                                                                Container(
                                                                    padding: const EdgeInsets.all(8),
                                                                    child: Text("Bloco: $BlocoMorador")
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          padding: const EdgeInsets.all(16),
                                                          child: TextField(
                                                            keyboardType: TextInputType.multiline,
                                                            enableSuggestions: true,
                                                            autocorrect: true,
                                                            minLines: 5,
                                                            maxLines: null,
                                                            controller: anotacaoControl,
                                                            onChanged: (value){
                                                              setState(() {
                                                                anotacaoMorador = value;
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
                                                        ),
                                                        Container(
                                                          padding: const EdgeInsets.all(16),
                                                          child: ElevatedButton(
                                                            onPressed: (){
                                                              FirebaseFirestore.instance.collection('Pessoas').doc(MoradorId).update({
                                                                "anotacao": anotacaoMorador
                                                              });
                                                            },
                                                              child: const Text("Salvar anotação")
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ): Container(),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ):  Center(
                                    child: Column(
                                      children: [
                                        AppBar(
                                          backgroundColor: Colors.deepPurpleAccent,
                                          centerTitle: true,
                                          title: const Text('Visitantes e Moradores'),
                                        ),
                                        Center(
                                            child: Container(
                                                padding: const EdgeInsets.all(16),
                                                child: const Text('Selecione o condominio')
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomRight,
                                    padding: const EdgeInsets.all(16),
                                    child: FloatingActionButton(onPressed: idCondominio == "" ? null : (){
                                      String NomeV = "";
                                      String CPFV = "";
                                      String RGV = "";
                                      String placa = "";
                                      String Unidade = "";
                                      String Bloco = "";
                                      DateTime selectedDate = DateTime.now();
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
                                                        const Text('Cadastre um morador'),
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
                                                        child: TextField(
                                                          keyboardType: TextInputType.emailAddress,
                                                          enableSuggestions: false,
                                                          autocorrect: false,
                                                          onChanged: (value){
                                                            setState(() {
                                                              placa = value;
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
                                                            labelText: 'Placa',
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
                                                              Unidade = value;
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
                                                            labelText: 'Unidade',
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
                                                              Bloco = value;
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
                                                            labelText: 'Bloco',
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
                                                              if(placa == ""){
                                                                showToast("Digite uma placa",context:context);
                                                              }else{
                                                                if(Unidade == ""){
                                                                  showToast("A unidade está vazia!",context:context);
                                                                }else{
                                                                  if(Bloco  == ""){
                                                                    showToast("O bloco está vazio!!",context:context);
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
                                                                        "imageURI": await ref.getDownloadURL(),
                                                                        "placa": placa,
                                                                        "Unidade ":Unidade,
                                                                        "Bloco ":Bloco,
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
                                                        }
                                                      }
                                                    },child: const Text('Registrar novo cadastro')
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
                                ],
                              ),
                            ),
                            SizedBox(
                              width: wid / 4,
                              height: heig / 3.8,
                              child: Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      AppBar(
                                        backgroundColor: Colors.deepPurpleAccent,
                                        centerTitle: true,
                                        title: const Text('Anotação'),
                                      ),
                                      Center(
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(16),
                                              child: TextField(
                                                keyboardType: TextInputType.multiline,
                                                enableSuggestions: true,
                                                autocorrect: true,
                                                minLines: 5,
                                                maxLines: null,
                                                onChanged: (value){
                                                  anotacao = value;
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
                                                  labelText: "Anotações sobre o condominio",
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.bottomRight,
                                              child: FloatingActionButton(
                                                  onPressed:idCondominioAnt == ""? null : (){
                                                    FirebaseFirestore.instance.collection('Condominios').doc(idCondominioAnt).update({
                                                      "Aviso": anotacao,
                                                    }).whenComplete(() {
                                                      setState(() {

                                                      });
                                                      showToast("Anotação salva com sucesso!",context:context);
                                                    });
                                              },child: const Icon(Icons.done)
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
