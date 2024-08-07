import 'dart:io';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_context_menu_ng/native_context_menu_widget.dart';
import 'package:native_context_menu_ng/native_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vigilant/acionamento_de_portas/acionamento_de_portas.dart';
import 'package:vigilant/getIds.dart';
import 'package:vigilant/login/login.dart';
import 'package:vigilant/pushPessoas/cadastroDeUsuariosNoEquipamento.dart';
import 'package:vigilant/pushPessoas/pushPessoas.dart';
import 'package:vigilant/videoStream/videoStreamWidget.dart';
import 'package:vigilant/voip/voipAPI.dart';
import 'package:uuid/uuid.dart';

//Desenvolvido por HeroRickyGames

//Strings
String ip = '';
String user = "";
String pass = "";
String anotacao = "";
String idCondominio = "";
String idCondominioAnt = "";
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
String ModeloDoCFTV = "";

//Strings de Pesquisa
String pesquisa = '';
String pesquisa2 = '';
String pesquisa3 = '';
String pesquisa4 = '';
String pesquisa5 = '';
String pesquisa6 = '';
String pesquisa7 = '';
String pesquisa8 = '';
String pesquisa9 = '';
String pesquisa10 = '';

//Controladores
TextEditingController anotacaoControl = TextEditingController(text: anotacaoMorador);
TextEditingController anotacaoControlCondominio = TextEditingController(text: anotacao);

//Booleanos
bool moradorselecionado = false;
bool pesquisaNumeros = false;
bool acionamento1clicado = false;
bool inicializado = false;
bool pesquisaCPF = false;
bool pesquisando = false;
bool pesquisando2 = false;
bool pesquisando3 = false;
bool pesquisando4 = false;
bool pesquisando5  = false;
bool pesquisando6  = false;
bool pesquisando7  = false;
bool pesquisando8  = false;
bool pesquisando9  = false;
bool pesquisando10  = false;

//Booleanos de controle dos usuarios
bool AdicionarCondominios = false;
bool AdicionarAcionamentos = false;
bool adicionarMoradores = false;
bool adicionarRamal = false;
bool adicionarUsuarios = false;
bool editarAnotacao = false;
bool permissaoCriarUsuarios = false;
bool adicionarVeiculo = false;
bool adicionarVisitante = false;
bool EditarCFTV = false;
bool acessoDevFunc = false;
bool deslogando = false;

//Inteiros
int porta = 00;

int? camera1;
int? camera2;
int? camera3;
int? camera4;
int? camera5;
int? camera6;
int? camera7;
int? camera8;
int? camera9;

//DropDownValues
var dropValue = ValueNotifier('');

//Cores
Color colorBtn = Colors.blue;
Color colorBtnFab = Colors.blue;
Color corDasBarras = Colors.transparent;
Color textColor = Colors.white;
Color textColorWidgets = Colors.black;
Color textColorFab = Colors.white;
Color textColorDrop = Colors.white;
Color textAlertDialogColor = Colors.black;
Color textAlertDialogColorReverse = Colors.white;
Color textColorInitBlue = Colors.white;

//Listas
List ModelosAcionamentos = [
  "Intelbras",
  "Control iD"
];

List ImportarUsuarios = [
  "Control iD"
];

List ModelosdeCFTV = [
  "Intelbras",
];



class homeApp extends StatefulWidget {
  const homeApp({super.key});

  @override
  State<homeApp> createState() => _homeAppState();
}

Future<NativeMenu> initMenuCondominio() async {
  NativeMenuItem? itemNew;
  NativeMenu menu = NativeMenu();
  if(AdicionarCondominios == true){
    itemNew = NativeMenuItem.simple(title: "Editar informações do condominio", action: "editCondominio");
    menu.addItem(NativeMenuItem.simple(title: "Adicionar acesso para outros usuarios", action: "adicionar_usuarios"));
    menu.addItem(NativeMenuItem.simple(title: "Deletar cliente", action: "remover_condominio"));
    menu.addItem(itemNew);
  }else{
    menu.addItem(NativeMenuItem.simple(title: "", action: ""));
  }
  return menu;
}

class _homeAppState extends State<homeApp>{
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    //Pega todas as permissões do usuario
    checkarAsPermissoes() async {
      try{
        await Future.delayed(const Duration(seconds: 3));
        var getUserPermissions = await FirebaseFirestore.instance
            .collection("Users")
            .doc(UID).get();

        setState(() {
          AdicionarCondominios = getUserPermissions['AdicionarCondominios'];
          AdicionarAcionamentos = getUserPermissions['adicionaAcionamentos'];
          adicionarRamal = getUserPermissions['adicionarRamal'];
          adicionarUsuarios = getUserPermissions['adicionarUsuarios'];
          adicionarMoradores = getUserPermissions['adicionarMoradores'];
          editarAnotacao = getUserPermissions['editarAnotacao'];
          permissaoCriarUsuarios = getUserPermissions['permissaoCriarUsuarios'];
          adicionarVeiculo = getUserPermissions['adicionarVeiculo'];
          adicionarVisitante = getUserPermissions['adicionarVisitante'];
          acessoDevFunc = getUserPermissions['acessoDevFunc'];
          EditarCFTV = getUserPermissions['editarCFTV'];

          //Setar a inicialização
          inicializado = true;
        });
      }catch(e){
        checkarAsPermissoes();
      }
    }

    if(deslogando == false){
      if(inicializado == false){
        checkarAsPermissoes();
      }
    }

    return LayoutBuilder(builder: (context, constrains){
      double wid = constrains.maxWidth;
      double heig = constrains.maxHeight;

      return Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: wid,
              height: heig,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/FundoMetalPrata.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  //UI começa aqui!
                  SizedBox(
                    width: wid,
                    height: heig,
                    child: Row(
                      children: [
                        SizedBox(
                          width: wid / 4,
                          height: heig,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  alignment: AlignmentDirectional.centerStart,
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Image.asset(
                                      "assets/vigilantLogo.png",
                                      scale: 3
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/fundoWidgetContainerMain.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: wid / 4,
                                        height: heig / 1.5,
                                        child: Stack(
                                            children: [
                                              Center(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      height: heig / 1.5,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.blue,
                                                          width: 1.0,
                                                        ),
                                                      ),
                                                      child: SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              padding: const EdgeInsets.all(10),
                                                              child: Stack(
                                                                children: [
                                                                  TextField(
                                                                    cursorColor: Colors.black,
                                                                    keyboardType: TextInputType.name,
                                                                    enableSuggestions: true,
                                                                    autocorrect: true,
                                                                    onChanged: (value){
                                                                      pesquisa = value;

                                                                      if(value == ""){
                                                                        setState((){
                                                                          pesquisa = value;
                                                                          pesquisando = false;
                                                                          pesquisaNumeros = false;
                                                                        });
                                                                      }

                                                                    },
                                                                    decoration: const InputDecoration(
                                                                      filled: true,
                                                                      fillColor: Colors.white,
                                                                      border: OutlineInputBorder(),
                                                                      enabledBorder: OutlineInputBorder(
                                                                        borderSide: BorderSide(width: 3, color: Colors.white), //<-- SEE HERE
                                                                      ),
                                                                      focusedBorder: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            width: 3,
                                                                            color: Colors.black
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    style: const TextStyle(
                                                                        color: Colors.black
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    alignment: AlignmentDirectional.centerEnd,
                                                                    child: TextButton(
                                                                      onPressed: (){

                                                                        RegExp numeros = RegExp(r'[0-9]');

                                                                        if(numeros.hasMatch(pesquisa)){
                                                                          setState(() {
                                                                            pesquisaNumeros = true;
                                                                          });
                                                                        }else{
                                                                          setState(() {
                                                                            pesquisaNumeros = false;
                                                                          });
                                                                        }

                                                                        if(pesquisa == ""){
                                                                          setState(() {
                                                                            pesquisando = false;
                                                                          });
                                                                        }else{
                                                                          setState(() {
                                                                            pesquisando = true;
                                                                          });
                                                                        }
                                                                      },
                                                                      child: Image.asset(
                                                                        "assets/search.png",
                                                                        scale: 12,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            StreamBuilder(
                                                              stream: pesquisando == true ?
                                                              pesquisaNumeros == false ? FirebaseFirestore.instance
                                                                  .collection("Condominios")
                                                                  .where("idList", arrayContains: UID)
                                                                  .where("Nome", isGreaterThanOrEqualTo: pesquisa)
                                                                  .where("Nome", isLessThan: "${pesquisa}z")
                                                                  .snapshots()
                                                                  :
                                                              FirebaseFirestore.instance
                                                                  .collection("Condominios")
                                                                  .where("idList", arrayContains: UID)
                                                                  .where("Codigo", isGreaterThanOrEqualTo: pesquisa)
                                                                  .where("Codigo", isLessThan: "${pesquisa}9")
                                                                  .snapshots()
                                                                  :
                                                              FirebaseFirestore.instance
                                                                  .collection("Condominios")
                                                                  .where("idList", arrayContains: UID)
                                                                  .snapshots(),
                                                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                                                                                        
                                                                if (!snapshot.hasData) {
                                                                  return const Center(
                                                                    child: CircularProgressIndicator(),
                                                                  );
                                                                }
                                                                                                        
                                                                return SizedBox(
                                                                  width: double.infinity,
                                                                  height: heig / 1.7,
                                                                  child: ListView(
                                                                    children: snapshot.data!.docs.map((documents){
                                                                      return SizedBox(
                                                                        width: wid / 4,
                                                                        height: 70,

                                                                        child: InkWell(
                                                                          onTap: () async {
                                                                            setState(() {
                                                                              ip = documents["IpCamera"];
                                                                              user = documents["UserAccess"];
                                                                              pass = documents["PassAccess"];
                                                                              porta = documents["PortaCameras"];
                                                                              idCondominio = documents["idCondominio"];
                                                                              anotacao = documents["Aviso"];
                                                                              ModeloDoCFTV = documents['ipCameraModelo'];
                                                                            });
                                                                            await Future.delayed(const Duration(seconds: 1));
                                                                            var getIpCameraSettings = await FirebaseFirestore.instance
                                                                                .collection("Condominios")
                                                                                .doc(idCondominio).get();
                                                                            await Future.delayed(const Duration(seconds: 2));
                                                                            setState(() {
                                                                              camera1 = getIpCameraSettings["ipCamera1"];
                                                                              camera2 = getIpCameraSettings["ipCamera2"];
                                                                              camera3 = getIpCameraSettings["ipCamera3"];
                                                                              camera4 = getIpCameraSettings["ipCamera4"];
                                                                              camera5 = getIpCameraSettings["ipCamera5"];
                                                                              camera6 = getIpCameraSettings["ipCamera6"];
                                                                              camera7 = getIpCameraSettings["ipCamera7"];
                                                                              camera8 = getIpCameraSettings["ipCamera8"];
                                                                              camera9 = getIpCameraSettings["ipCamera9"];
                                                                              isStarted = true;
                                                                            });
                                                                          },
                                                                          child: Stack(
                                                                            children: [
                                                                              FutureBuilder<NativeMenu>(
                                                                                future: initMenuCondominio(),
                                                                                builder: (BuildContext context, AsyncSnapshot<NativeMenu> snapshot){
                                                                                                        
                                                                                  if (!snapshot.hasData) {
                                                                                    return const Center(
                                                                                      child: CircularProgressIndicator(),
                                                                                    );
                                                                                  }

                                                                                  return SizedBox(
                                                                                    width: wid / 4,
                                                                                    child: NativeContextMenuWidget(
                                                                                      actionCallback: (action) {
                                                                                        if(action == "editCondominio"){
                                                                                          //TODO abrir uma janela para edição das informações do condominio!
                                                                                        }
                                                                                        if(action == "adicionar_usuarios"){
                                                                                            //TODO adicionar ou remover usuarios atravez de uma lista interna
                                                                                        }
                                                                                        if(action == "remover_condominio"){
                                                                                          FirebaseFirestore.instance.collection("Condominios").doc(documents["idCondominio"]).delete().whenComplete((){
                                                                                            showToast("Cliente deletado!",context:context);
                                                                                          });
                                                                                        }
                                                                                      },
                                                                                      menu: snapshot.requireData,
                                                                                      otherCallback: (method) {
                                                                                      },
                                                                                      child: const Text(
                                                                                          "abc",
                                                                                        style: TextStyle(
                                                                                          color: Colors.transparent
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              ),
                                                                              Container(
                                                                                padding: const EdgeInsets.all(16),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Stack(
                                                                                      children: [
                                                                                        //Sombra
                                                                                        Text(
                                                                                            "${documents["Codigo"]} ${documents['Nome']}",
                                                                                          style: TextStyle(
                                                                                            fontSize: 16,
                                                                                            foreground: Paint()
                                                                                              ..style = PaintingStyle.stroke
                                                                                              ..strokeWidth = 4
                                                                                              ..color = Colors.blue,
                                                                                          ),
                                                                                        ),
                                                                                        //Texto normal
                                                                                        Text(
                                                                                          "${documents["Codigo"]} ${documents['Nome']}",
                                                                                          style: TextStyle(
                                                                                            fontSize: 16,
                                                                                            color: textColorInitBlue,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    IconButton(onPressed: (){
                                                                                      setState(() {
                                                                                        anotacao = documents["Aviso"];
                                                                                        idCondominioAnt = documents["idCondominio"];
                                                                                        anotacaoControlCondominio.text = anotacao;
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
                                                                            ],
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
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          AdicionarCondominios == true ? Container(
                                            alignment: Alignment.bottomRight,
                                            padding: const EdgeInsets.all(16),
                                            child: TextButton(
                                              onPressed: (){
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
                                              String modeloselecionado = "Intelbras";
                                              var dropValue2 = ValueNotifier('Intelbras');

                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                                                    return SingleChildScrollView(
                                                      child: Dialog(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        child: Stack(
                                                            children: [
                                                              // Imagem de fundo
                                                              Positioned.fill(
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  child: Image.asset(
                                                                      "assets/FundoMetalPreto.jpg",
                                                                    fit: BoxFit.fill,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 700,
                                                                padding: const EdgeInsets.all(30),
                                                                child: Column(
                                                                  children: [
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: [
                                                                        SizedBox(
                                                                          //width: 200,
                                                                          height: 50,
                                                                          child: Center(
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                const Text(
                                                                                    'Crie um novo condominio!',
                                                                                  style: TextStyle(
                                                                                    fontSize: 30,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 100,
                                                                                  height: 100,
                                                                                  child: TextButton(onPressed: (){
                                                                                    Navigator.pop(context);
                                                                                  }, child: const Center(
                                                                                    child: Icon(
                                                                                        Icons.close,
                                                                                      size: 40,
                                                                                    ),
                                                                                  )
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const Padding(
                                                                          padding: EdgeInsets.only(bottom: 16),
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
                                                                                  NomeCondominio = value;
                                                                                });
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                filled: true,
                                                                                fillColor: Colors.white,
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
                                                                                labelStyle: TextStyle(
                                                                                  color: textAlertDialogColor
                                                                                ),
                                                                                labelText: 'Nome do Condominio',
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
                                                                              keyboardType: TextInputType.emailAddress,
                                                                              enableSuggestions: false,
                                                                              autocorrect: false,
                                                                              onChanged: (value){
                                                                                setState(() {
                                                                                  codigo = value;
                                                                                });
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                filled: true,
                                                                                fillColor: Colors.white,
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
                                                                                labelStyle: TextStyle(
                                                                                    color: textAlertDialogColor
                                                                                ),
                                                                                labelText: 'Codigo do Condominio (4 caracteres Ex: 2402)',
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
                                                                              const Text('Modelo do CFTV:'),
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
                                                                                    setState(() {
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
                                                                              decoration: InputDecoration(
                                                                                filled: true,
                                                                                fillColor: Colors.white,
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
                                                                                labelStyle: TextStyle(
                                                                                    color: textAlertDialogColor
                                                                                ),
                                                                                labelText: 'URL do CFTV (RTSP)',
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
                                                                              keyboardType: TextInputType.emailAddress,
                                                                              enableSuggestions: false,
                                                                              autocorrect: false,
                                                                              onChanged: (value){
                                                                                setState(() {
                                                                                  PortaCameras = int.parse(value);
                                                                                });
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                filled: true,
                                                                                fillColor: Colors.white,
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
                                                                                labelStyle: TextStyle(
                                                                                    color: textAlertDialogColor
                                                                                ),
                                                                                labelText: 'Porta do CFTV (RTSP) (Normalmente é 554, mas pode variar dependendo do CFTV)',
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
                                                                              keyboardType: TextInputType.emailAddress,
                                                                              enableSuggestions: false,
                                                                              autocorrect: false,
                                                                              onChanged: (value){
                                                                                setState(() {
                                                                                  UserAccess = value;
                                                                                });
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                filled: true,
                                                                                fillColor: Colors.white,
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
                                                                                labelStyle: TextStyle(
                                                                                    color: textAlertDialogColor
                                                                                ),
                                                                                labelText: 'Usuario para acesso das cameras',
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
                                                                              keyboardType: TextInputType.emailAddress,
                                                                              enableSuggestions: false,
                                                                              autocorrect: false,
                                                                              onChanged: (value){
                                                                                setState(() {
                                                                                  PassAccess = value;
                                                                                });
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                filled: true,
                                                                                fillColor: Colors.white,
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
                                                                                labelStyle: TextStyle(
                                                                                    color: textAlertDialogColor
                                                                                ),
                                                                                labelText: 'Senha para acesso das cameras',
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
                                                                              keyboardType: TextInputType.emailAddress,
                                                                              enableSuggestions: false,
                                                                              autocorrect: false,
                                                                              onChanged: (value){
                                                                                setState(() {
                                                                                  SIPUrl = value;
                                                                                });
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                filled: true,
                                                                                fillColor: Colors.white,
                                                                                labelStyle: TextStyle(
                                                                                    color: textAlertDialogColor
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
                                                                                labelText: 'SIP Url (sip2.chamada.com.br), para ambientes não suportado é recomendado deixar (*) apenas.',
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
                                                                              keyboardType: TextInputType.emailAddress,
                                                                              enableSuggestions: false,
                                                                              autocorrect: false,
                                                                              onChanged: (value){
                                                                                setState(() {
                                                                                  Porta = value;
                                                                                });
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                filled: true,
                                                                                fillColor: Colors.white,
                                                                                labelStyle: TextStyle(
                                                                                    color: textAlertDialogColor
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
                                                                                labelText: 'SIP Porta (5060)',
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
                                                                              keyboardType: TextInputType.emailAddress,
                                                                              enableSuggestions: false,
                                                                              autocorrect: false,
                                                                              onChanged: (value){
                                                                                setState(() {
                                                                                  AuthUser = value;
                                                                                });
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                filled: true,
                                                                                fillColor: Colors.white,
                                                                                labelStyle: TextStyle(
                                                                                    color: textAlertDialogColor
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
                                                                                labelText: 'Usuario de acesso do SIP',
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
                                                                              keyboardType: TextInputType.emailAddress,
                                                                              enableSuggestions: false,
                                                                              autocorrect: false,
                                                                              onChanged: (value){
                                                                                setState(() {
                                                                                  Pass = value;
                                                                                });
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                filled: true,
                                                                                fillColor: Colors.white,
                                                                                labelStyle: TextStyle(
                                                                                    color: textAlertDialogColor
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
                                                                                labelText: 'Senha de acesso do SIP',
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
                                                                              keyboardType: TextInputType.emailAddress,
                                                                              enableSuggestions: false,
                                                                              autocorrect: false,
                                                                              onChanged: (value){
                                                                                setState(() {
                                                                                  Aviso = value;
                                                                                });
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                filled: true,
                                                                                fillColor: Colors.white,
                                                                                labelStyle: TextStyle(
                                                                                    color: textAlertDialogColor
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
                                                                                labelText: 'Aviso',
                                                                              ),
                                                                              style: TextStyle(
                                                                                  color: textAlertDialogColor
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
                                                                                                "Codigo" : codigo,
                                                                                                'idList' : [UID],
                                                                                                "ipCameraModelo": modeloselecionado,
                                                                                                "ipCamera1": 1,
                                                                                                "ipCamera2": 2,
                                                                                                "ipCamera3": 3,
                                                                                                "ipCamera4": 4,
                                                                                                "ipCamera5": 5,
                                                                                                "ipCamera6": 6,
                                                                                                "ipCamera7": 7,
                                                                                                "ipCamera8": 8,
                                                                                                "ipCamera9": 9,
                                                                                                "ipCamera10": 10,
                                                                                                "ipCamera11": 11,
                                                                                                "ipCamera12": 12,
                                                                                                "ipCamera13": 13,
                                                                                                "ipCamera14": 14,
                                                                                                "ipCamera15": 15,
                                                                                                "ipCamera16": 16,
                                                                                                "ipCamera17": 17,
                                                                                                "ipCamera18": 18,
                                                                                                "ipCamera19": 19,
                                                                                                "ipCamera20": 20,
                                                                                                "ipCamera21": 21,
                                                                                                "ipCamera22": 22,
                                                                                                "ipCamera23": 23,
                                                                                                "ipCamera24": 24,
                                                                                                "ipCamera25": 25,
                                                                                                "ipCamera26": 26,
                                                                                                "ipCamera27": 27,
                                                                                                "ipCamera28": 28,
                                                                                                "ipCamera29": 29,
                                                                                                "ipCamera30": 30,
                                                                                                "ipCamera31": 31,
                                                                                                "ipCamera32": 32,
                                                                                                "ipCamera33": 33,
                                                                                                "ipCamera34": 34,
                                                                                                "ipCamera35": 35,
                                                                                                "ipCamera36": 36,
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
                                                                        },
                                                                            style: ElevatedButton.styleFrom(
                                                                                backgroundColor: colorBtn
                                                                            ),
                                                                            child: Text(
                                                                              'Registrar novo Condominio',
                                                                              style: TextStyle(
                                                                                  color: textColor
                                                                              ),
                                                                            )
                                                                        )
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                      ),
                                                    );
                                                  }
                                                  );
                                                },
                                              );
                                            },
                                              child: Image.asset(
                                                  "assets/fab.png",
                                                  scale: 17
                                              )
                                            ),
                                          ):
                                          Container(),
                                        ]
                                        ),
                                      ),
                                      Container(
                                        width: wid / 4,
                                        height: heig / 3.5,
                                        decoration: const BoxDecoration(
                                        ),
                                        child: Center(
                                          child: SingleChildScrollView(
                                            child: Container(
                                              padding: const EdgeInsets.all(0),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.all(16),
                                                      child: TextField(
                                                        controller: anotacaoControlCondominio,
                                                        keyboardType: TextInputType.multiline,
                                                        enableSuggestions: true,
                                                        autocorrect: true,
                                                        minLines: 5,
                                                        maxLines: null,
                                                        onChanged: (value){
                                                          anotacao = value;
                                                        },
                                                          style: const TextStyle(
                                                              color: Colors.black
                                                          ),
                                                        decoration: const InputDecoration(
                                                          filled: true,
                                                          fillColor: Colors.white,
                                                          border: OutlineInputBorder(),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                width: 3,
                                                                color: Colors.black
                                                            ),
                                                          ),
                                                          labelStyle: TextStyle(
                                                              color: Colors.black
                                                          ),
                                                          labelText: "Anotações sobre o condominio",
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets.all(16),
                                                      alignment: Alignment.bottomRight,
                                                      child: editarAnotacao == false ?
                                                      Container():
                                                      FloatingActionButton(
                                                          onPressed:idCondominioAnt == "" ? null : (){
                                                            FirebaseFirestore.instance.collection('Condominios').doc(idCondominioAnt).update({
                                                              "Aviso": anotacao,
                                                            }).whenComplete(() {
                                                              showToast("Anotação salva com sucesso!",context:context);
                                                            });
                                                          },
                                                          backgroundColor: colorBtnFab,
                                                          child: Icon(
                                                              Icons.done,
                                                              color: textColor
                                                          )
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: wid / 2,
                          height: heig,
                          child: Column(
                            children: [
                              //CFTV AQUI!
                              VideoStreamWidget(
                                  ip, porta, user, pass, corDasBarras, wid, heig, camera1, camera2, camera3, camera4, camera5, camera6, camera7, camera8, camera9, ModeloDoCFTV
                              ),
                              SizedBox(
                                width: wid / 2,
                                height: heig / 2.5,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                       Container(
                                         decoration: const BoxDecoration(
                                           image: DecorationImage(
                                             image: AssetImage('assets/fundoWidgetContainerMain.png'),
                                             fit: BoxFit.cover,
                                           ),
                                         ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            idCondominio == ""?
                                            SizedBox(
                                              width: wid / 3,
                                              height: heig / 2.5,
                                            ) :
                                            Center(
                                                  child: SizedBox(
                                                    width: wid / 3,
                                                    height: heig / 2.5,
                                                    child: Stack(
                                                      children: [
                                                        StreamBuilder(
                                                          stream: FirebaseFirestore.instance
                                                              .collection('acionamentos')
                                                              .where("idCondominio", isEqualTo: idCondominio)
                                                              .snapshots(),
                                                          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                            if (snapshot.hasError) {
                                                              return const Center(child:
                                                              Text('Algo deu errado!')
                                                              );
                                                            }

                                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                                              return const Center(child: CircularProgressIndicator());
                                                            }

                                                            if (snapshot.hasData) {
                                                              return GridView.count(
                                                                  crossAxisCount: 3,
                                                                  children: snapshot.data!.docs.map((documents) {
                                                                    return Container(
                                                                      padding: const EdgeInsets.all(16),
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          TextButton(
                                                                              onPressed: (){
                                                                                if(documents["prontoParaAtivar"] == false){
                                                                                  FirebaseFirestore.instance.collection("acionamentos").doc(documents["id"]).update({
                                                                                    "prontoParaAtivar" : true,
                                                                                  });
                                                                                }
                                                                                if(documents["prontoParaAtivar"] == true){
                                                                                  acionarPorta(context, documents["ip"], documents["porta"], documents["modelo"], documents["canal"], documents["usuario"], documents["senha"]);
                                                                                  FirebaseFirestore.instance.collection("acionamentos").doc(documents["id"]).update({
                                                                                    "prontoParaAtivar" : false,
                                                                                  });

                                                                                }
                                                                              },
                                                                              child: Image.asset(
                                                                                  documents["prontoParaAtivar"] == false ?
                                                                                  "assets/btnInactive.png" :
                                                                                  "assets/btnIsAbleToAction.png",
                                                                                scale: 5,
                                                                              )
                                                                          ),
                                                                          Text(
                                                                              documents["nome"],
                                                                            style: TextStyle(
                                                                              color: textColorWidgets
                                                                            )
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }).toList()
                                                              );
                                                            }
                                                            return const Center(
                                                                child: Text('Sem dados!',)
                                                            );
                                                          },
                                                        ),
                                                        AdicionarAcionamentos == false ?
                                                        Container():
                                                        Container(
                                                          padding: const EdgeInsets.all(16),
                                                          alignment: Alignment.bottomRight,
                                                          child: TextButton(
                                                              onPressed: (){
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (BuildContext context) {

                                                                    String nome = "";
                                                                    String ip = "";
                                                                    String modeloselecionado = "Intelbras";
                                                                    String porta = "";
                                                                    String canal = "";
                                                                    String usuario = "";
                                                                    String senha = "";
                                                                    var dropValue3 = ValueNotifier('Intelbras');

                                                                    return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                                                                      return Center(
                                                                        child: SingleChildScrollView(
                                                                          child: Dialog(
                                                                            child: Stack(
                                                                              children: [
                                                                                Positioned.fill(
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    child: Image.asset(
                                                                                      "assets/FundoMetalPreto.jpg",
                                                                                      fit: BoxFit.fill,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  width: 600,
                                                                                  padding: const EdgeInsets.all(20),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Container(
                                                                                            padding: const EdgeInsets.only(bottom: 16),
                                                                                              child: const Text(
                                                                                                  'Adicionar novo acionamento',
                                                                                                style: TextStyle(
                                                                                                  fontSize: 30,
                                                                                                ),
                                                                                              )
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 100,
                                                                                            height: 100,
                                                                                            child: TextButton(onPressed: (){
                                                                                              Navigator.pop(context);
                                                                                              },
                                                                                                child:const Center(
                                                                                                child: Icon(
                                                                                                  Icons.close,
                                                                                                  size: 40,
                                                                                                ),
                                                                                              )
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                      Center(
                                                                                        child: Column(
                                                                                          children: [
                                                                                            Center(
                                                                                              child: Container(
                                                                                                padding: const EdgeInsets.all(10),
                                                                                                child: TextField(
                                                                                                  keyboardType: TextInputType.name,
                                                                                                  enableSuggestions: true,
                                                                                                  autocorrect: true,
                                                                                                  onChanged: (value){
                                                                                                    setState(() {
                                                                                                      nome = value;
                                                                                                    });
                                                                                                  },
                                                                                                  decoration: InputDecoration(
                                                                                                    filled: true,
                                                                                                    fillColor: Colors.white,
                                                                                                    labelStyle: TextStyle(
                                                                                                        color: textAlertDialogColor
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
                                                                                                    label: const Text('Nome de identificação'),
                                                                                                  ),
                                                                                                  style: TextStyle(
                                                                                                      color: textAlertDialogColor
                                                                                                  ),
                                                                                                ),
                                                                                              ),
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
                                                                                                      ip = value;
                                                                                                    });
                                                                                                  },
                                                                                                  decoration: InputDecoration(
                                                                                                    filled: true,
                                                                                                    fillColor: Colors.white,
                                                                                                    labelStyle: TextStyle(
                                                                                                        color: textAlertDialogColor
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
                                                                                                    label: const Text('IP'),
                                                                                                  ),
                                                                                                  style: TextStyle(
                                                                                                      color: textAlertDialogColor
                                                                                                  ),
                                                                                                ),
                                                                                              ),
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
                                                                                                      porta = value;
                                                                                                    });
                                                                                                  },
                                                                                                  decoration: InputDecoration(
                                                                                                    filled: true,
                                                                                                    fillColor: Colors.white,
                                                                                                    labelStyle: TextStyle(
                                                                                                        color: textAlertDialogColor
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
                                                                                                    label: const Text('Porta'),
                                                                                                  ),
                                                                                                  style: TextStyle(
                                                                                                      color: textAlertDialogColor
                                                                                                  ),
                                                                                                ),
                                                                                              ),
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
                                                                                                      canal = value;
                                                                                                    });
                                                                                                  },
                                                                                                  decoration: InputDecoration(
                                                                                                    filled: true,
                                                                                                    fillColor: Colors.white,
                                                                                                    labelStyle: TextStyle(
                                                                                                        color: textAlertDialogColor
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
                                                                                                    label: const Text('Canal'),
                                                                                                  ),
                                                                                                  style: TextStyle(
                                                                                                      color: textAlertDialogColor
                                                                                                  ),
                                                                                                ),
                                                                                              ),
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
                                                                                                      usuario = value;
                                                                                                    });
                                                                                                  },
                                                                                                  decoration: InputDecoration(
                                                                                                    filled: true,
                                                                                                    fillColor: Colors.white,
                                                                                                    labelStyle: TextStyle(
                                                                                                        color: textAlertDialogColor
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
                                                                                                    label: const Text('Usuario'),
                                                                                                  ),
                                                                                                  style: TextStyle(
                                                                                                      color: textAlertDialogColor
                                                                                                  ),
                                                                                                ),
                                                                                              ),
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
                                                                                                      senha = value;
                                                                                                    });
                                                                                                  },
                                                                                                  decoration: InputDecoration(
                                                                                                    filled: true,
                                                                                                    fillColor: Colors.white,
                                                                                                    labelStyle: TextStyle(
                                                                                                        color: textAlertDialogColor
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
                                                                                                    label: const Text('Senha'),
                                                                                                  ),
                                                                                                  style: TextStyle(
                                                                                                      color: textAlertDialogColor
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      const Center(
                                                                                        child: Text('Selecione o modelo'),
                                                                                      ),
                                                                                      Center(
                                                                                        child: ValueListenableBuilder(valueListenable: dropValue3, builder: (context, String value, _){
                                                                                          return DropdownButton(
                                                                                            hint: Text(
                                                                                              'Selecione o modelo',
                                                                                              style: TextStyle(
                                                                                                  color: textColorDrop
                                                                                              ),
                                                                                            ),
                                                                                            value: (value.isEmpty)? null : value,
                                                                                            onChanged: (escolha) async {
                                                                                              dropValue3.value = escolha.toString();
                                                                                              setState(() {
                                                                                                modeloselecionado = escolha.toString();
                                                                                              });
                                                                                            },
                                                                                            items: ModelosAcionamentos.map((opcao) => DropdownMenuItem(
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
                                                                                      ElevatedButton(
                                                                                        onPressed: (){
                                                                                          if(nome == ""){
                                                                                            showToast("O nome não pode ficar vazio!",context:context);
                                                                                          }else{
                                                                                            if(ip == ""){
                                                                                              showToast("O ip não pode estar vazio!",context:context);
                                                                                            }else{
                                                                                              if(porta == ""){
                                                                                                showToast("A porta não pode estar vazia!",context:context);
                                                                                              }else{
                                                                                                final RegExp regex = RegExp(r'^[a-zA-Z\s]+$');

                                                                                                if(regex.hasMatch(porta)){
                                                                                                  showToast("A porta contem letras, e letras não são permitidas!",context:context);
                                                                                                }else{
                                                                                                  if(canal == ""){
                                                                                                    showToast("O canal não pode estar vazia!",context:context);
                                                                                                  }else{
                                                                                                    final RegExp regex = RegExp(r'^[a-zA-Z\s]+$');

                                                                                                    if(regex.hasMatch(canal)){
                                                                                                      showToast("O canal contem letras, e letras não são permitidas!",context:context);
                                                                                                    }else{

                                                                                                      if(usuario == ""){
                                                                                                        showToast("O usuario não pode estar vazio!",context:context);
                                                                                                      }else{
                                                                                                        if(senha == ""){
                                                                                                          showToast("A senha não pode estar vazia!",context:context);
                                                                                                        }else{
                                                                                                          if(modeloselecionado == ""){
                                                                                                            showToast("O modelo precisa ser selecionado!",context:context);
                                                                                                          }else{
                                                                                                            Uuid uuid = const Uuid();
                                                                                                            String UUID = uuid.v4();
                                                                                                            FirebaseFirestore.instance.collection("acionamentos").doc(UUID).set({
                                                                                                              "nome": nome,
                                                                                                              "ip": ip,
                                                                                                              "porta": int.parse(porta),
                                                                                                              "canal": int.parse(canal),
                                                                                                              "usuario": usuario,
                                                                                                              "senha": senha,
                                                                                                              "modelo": modeloselecionado,
                                                                                                              "prontoParaAtivar": false,
                                                                                                              "deuErro": false,
                                                                                                              "idCondominio": idCondominio,
                                                                                                              "id": UUID
                                                                                                            }).whenComplete((){
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
                                                                                          }
                                                                                        },style: ElevatedButton.styleFrom(
                                                                                          backgroundColor: colorBtn
                                                                                      ),
                                                                                        child: Text(
                                                                                            'Criar',
                                                                                          style: TextStyle(
                                                                                              color: textColor
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: Image.asset(
                                                                  "assets/fab.png",
                                                                  scale: 17
                                                              )
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            Stack(
                                                children: [
                                                  StreamBuilder(stream: FirebaseFirestore.instance
                                                      .collection("Ramais")
                                                      .where("idCondominio", isEqualTo: idCondominio)
                                                      .snapshots(), builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                                    if (!snapshot.hasData) {
                                                      return const Center(
                                                        child: CircularProgressIndicator(),
                                                      );
                                                    }
                                                    return Container(
                                                      width: wid / 6,
                                                      height: heig / 2.5,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.blue,
                                                          width: 1.0,
                                                        ),
                                                      ),
                                                      child: ListView(
                                                        children: snapshot.data!.docs.map((documents){
                                                          return InkWell(
                                                            onTap: (){
                                                              startCall(context, documents['RamalNumber']);
                                                            },
                                                            child: Container(
                                                              padding: const EdgeInsets.all(10),
                                                              width: double.infinity,
                                                              height: 70,
                                                              child: Center(
                                                                child: Column(
                                                                  children: [
                                                                    Text(documents['NomeRamal']),
                                                                    Text(documents['RamalNumber']),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    );
                                                   }
                                                  ),
                                                  Container(
                                                    width: wid / 6,
                                                    height: heig / 2.5,
                                                    alignment: Alignment.bottomRight,
                                                    padding: const EdgeInsets.all(16),
                                                    child: adicionarRamal == false ?
                                                    Container():
                                                    TextButton(onPressed:
                                                    idCondominio == "" ? null : (){
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          String NomeRamal = "";
                                                          String RamalNumber = "";

                                                          return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                                                            return Center(
                                                              child: SingleChildScrollView(
                                                                child: Dialog(
                                                                  child: Stack(
                                                                    children: [
                                                                      Positioned.fill(
                                                                        child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                          child: Image.asset(
                                                                            "assets/FundoMetalPreto.jpg",
                                                                            fit: BoxFit.fill,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        width: 600,
                                                                        padding: const EdgeInsets.all(20),
                                                                        child: Column(
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Container(
                                                                                  padding: const EdgeInsets.only(bottom: 16),
                                                                                    child: const Text(
                                                                                        'Crie um Ramal!',
                                                                                      style: TextStyle(
                                                                                        fontSize: 30,
                                                                                      ),
                                                                                    )
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 100,
                                                                                  height: 100,
                                                                                  child: TextButton(onPressed: (){
                                                                                    Navigator.pop(context);
                                                                                  }, child: const Center(
                                                                                    child: Icon(
                                                                                      Icons.close,
                                                                                      size: 40,
                                                                                    ),
                                                                                  )
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Center(
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.all(10),
                                                                                    child: TextField(
                                                                                      keyboardType: TextInputType.name,
                                                                                      enableSuggestions: true,
                                                                                      autocorrect: true,
                                                                                      onChanged: (value){
                                                                                        setState(() {
                                                                                          NomeRamal = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor
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
                                                                                        label: const Text('Nome do Ramal'),
                                                                                      ),
                                                                                      style: TextStyle(
                                                                                          color: textAlertDialogColor
                                                                                      ),
                                                                                    ),
                                                                                  ),
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
                                                                                          RamalNumber = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                          filled: true,
                                                                                          fillColor: Colors.white,
                                                                                          labelStyle: TextStyle(
                                                                                              color: textAlertDialogColor
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
                                                                                          label: const Text("Numero do Ramal")
                                                                                      ),
                                                                                      style: TextStyle(
                                                                                          color: textAlertDialogColor
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                ElevatedButton(
                                                                                    onPressed: (){
                                                                                      if(NomeRamal == ""){
                                                                                        showToast("O nome do ramal está vazio!",context:context);
                                                                                      }else{
                                                                                        if(RamalNumber == ""){
                                                                                          showToast("O numero do ramal está vazio!",context:context);
                                                                                        }else{
                                                                                          RegExp numeros = RegExp(r'[a-zA-Z]');
                                                                                          if(RamalNumber.contains(numeros)){
                                                                                            showToast("O ramal contem letras\nSó é permitido numeros!",context:context);
                                                                                          }else{
                                                                                            Uuid uuid = const Uuid();
                                                                                            String UUID = uuid.v4();
                                                                                            FirebaseFirestore.instance.collection('Ramais').doc(UUID).set({
                                                                                              "NomeRamal": NomeRamal,
                                                                                              "RamalNumber": RamalNumber,
                                                                                              "IDEmpresaPertence": UID,
                                                                                              "idCondominio": idCondominio
                                                                                            }).whenComplete((){
                                                                                              Navigator.pop(context);
                                                                                            });
                                                                                          }
                                                                                        }
                                                                                      }
                                                                                    },
                                                                                    style: ElevatedButton.styleFrom(
                                                                                        backgroundColor: colorBtn
                                                                                    ),
                                                                                    child: Text(
                                                                                      'Criar',
                                                                                      style: TextStyle(
                                                                                          color: textColor
                                                                                      ),
                                                                                    )
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
                                                            );
                                                          },);
                                                        },
                                                      );
                                                    },
                                                      child: Image.asset(
                                                          "assets/fab.png",
                                                          scale: 17
                                                      )
                                                    ),
                                                  ),
                                                ]
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                  padding: const EdgeInsets.only(bottom: 10, top: 10, left: 200),
                                  child: TextButton(
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {

                                            //Strings da API de portas
                                            String IP = "";
                                            String Porta = "";
                                            String Canal = "";
                                            String Usuario = "";
                                            String Senha = "";
                                            String modeloselecionado = "Intelbras";

                                            //Inteiros de gerenciamento de janela
                                            int janela = 1;

                                            //Double do tamanho da janela
                                            double Widet = wid / 3;
                                            double Heigt = wid / 3;

                                            var dropValue4 = ValueNotifier('Intelbras');

                                            return StatefulBuilder(builder: (BuildContext context, StateSetter setStatee){
                                              return Center(
                                                child: SingleChildScrollView(
                                                  child: Dialog(
                                                    child: Stack(
                                                      children: [
                                                        Positioned.fill(
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(10),
                                                            child: Image.asset(
                                                              "assets/FundoMetalPreto.jpg",
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 600,
                                                          padding: const EdgeInsets.all(20),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  const Text(
                                                                      'Configurações Geriais',
                                                                    style: TextStyle(
                                                                      fontSize: 25,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 100,
                                                                    height: 100,
                                                                    child: TextButton(onPressed: (){
                                                                      Navigator.pop(context);
                                                                    }, child: const Center(
                                                                      child: Icon(
                                                                        Icons.close,
                                                                        size: 40,
                                                                      ),
                                                                    )
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              acessoDevFunc == true ? Container(
                                                                padding: const EdgeInsets.all(16),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    permissaoCriarUsuarios == true ?
                                                                    ElevatedButton(
                                                                      onPressed: (){
                                                                        setStatee((){
                                                                          janela = 1;
                                                                        });
                                                                      },
                                                                      style: ElevatedButton.styleFrom(
                                                                          backgroundColor: Colors.blue
                                                                      ),
                                                                      child: Text(
                                                                          "Criação de usuarios",
                                                                        style: TextStyle(
                                                                          color: textAlertDialogColorReverse
                                                                        ),
                                                                      ),
                                                                    ): Container(),
                                                                    ElevatedButton(
                                                                      onPressed: (){
                                                                        setStatee((){
                                                                          janela = 2;
                                                                        });
                                                                      },
                                                                      style: ElevatedButton.styleFrom(
                                                                          backgroundColor: Colors.blue
                                                                      ),
                                                                      child: Text(
                                                                          "APIs de teste",
                                                                        style: TextStyle(
                                                                            color: textAlertDialogColorReverse
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ): Container(),
                                                              permissaoCriarUsuarios == true? Center(
                                                                child: janela == 1 ?
                                                                Stack(
                                                                  children: [
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        const Text(
                                                                            "Criação de usuarios",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 16
                                                                            )
                                                                        ),
                                                                        Container(
                                                                          padding: const EdgeInsets.all(16),
                                                                          child: const Text(
                                                                              "Lista de Usuarios",
                                                                              style: TextStyle(
                                                                                  fontSize: 16
                                                                              )
                                                                          ),
                                                                        ),
                                                                        StreamBuilder(stream: FirebaseFirestore.instance
                                                                            .collection("Users")
                                                                            .snapshots(), builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                                                          if (!snapshot.hasData) {
                                                                            return const Center(
                                                                              child: CircularProgressIndicator(),
                                                                            );
                                                                          }

                                                                          return Container(
                                                                              width: Widet,
                                                                              height: Heigt,
                                                                              child: Center(
                                                                                child: ListView(
                                                                                  children: snapshot.data!.docs.map((documents){
                                                                                    return SizedBox(
                                                                                      width: 100,
                                                                                      height: 50,
                                                                                      child: Text(
                                                                                        "Nome: ${documents['Nome']}\nCPF: ${documents['CPF']}",
                                                                                        style: const TextStyle(
                                                                                            fontSize: 16
                                                                                        ),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    );
                                                                                  }).toList(),
                                                                                ),
                                                                              )
                                                                          );
                                                                        }
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Container(
                                                                      alignment: Alignment.bottomRight,
                                                                      width: Widet,
                                                                      height: Heigt,
                                                                      child: FloatingActionButton(
                                                                        onPressed: (){
                                                                          //Criação do Usuario!

                                                                          //Strings
                                                                          String Nome = "";
                                                                          String CPF = "";
                                                                          String Usrname = "";
                                                                          String Senha = "";

                                                                          //Booleanos
                                                                          bool addCondominios = false;
                                                                          bool editCFTV = false;
                                                                          bool addAcionamentos = false;
                                                                          bool addRamal = false;
                                                                          bool addMoradores = false;
                                                                          bool addVisitante = false;
                                                                          bool addVeiculos = false;
                                                                          bool criarNovosUsuarios = false;
                                                                          bool acessoDevFuc = false;
                                                                          bool editarAnotacao = false;
                                                                          bool adicionarUsuarioss = false;

                                                                          showDialog(
                                                                            context: context,
                                                                            builder: (BuildContext context) {
                                                                              return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                                                                                return Dialog(
                                                                                  child: Stack(
                                                                                    children: [
                                                                                      Positioned.fill(
                                                                                        child: ClipRRect(
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                          child: Image.asset(
                                                                                            "assets/FundoMetalPreto.jpg",
                                                                                            fit: BoxFit.fill,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        width: 600,
                                                                                        padding: const EdgeInsets.all(20),
                                                                                        child: Column(
                                                                                          children: [
                                                                                            Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                              children: [
                                                                                                const Text(
                                                                                                    'Criação de Usuario',
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 30,
                                                                                                  ),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  width: 100,
                                                                                                  height: 100,
                                                                                                    child: TextButton(onPressed: (){
                                                                                                      Navigator.pop(context);
                                                                                                    }, child: const Center(
                                                                                                      child: Icon(
                                                                                                        Icons.close,
                                                                                                        size: 40,
                                                                                                      ),
                                                                                                    )
                                                                                                  ),
                                                                                                )
                                                                                              ],
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
                                                                                                      Nome = value;
                                                                                                    });
                                                                                                  },
                                                                                                  decoration: InputDecoration(
                                                                                                    filled: true,
                                                                                                    fillColor: Colors.white,
                                                                                                    labelStyle: TextStyle(
                                                                                                        color: textAlertDialogColor
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
                                                                                                    labelText: 'Nome',
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
                                                                                                  keyboardType: TextInputType.emailAddress,
                                                                                                  enableSuggestions: false,
                                                                                                  autocorrect: false,
                                                                                                  onChanged: (value){
                                                                                                    setState(() {
                                                                                                      CPF = value;
                                                                                                    });
                                                                                                  },
                                                                                                  decoration: InputDecoration(
                                                                                                    filled: true,
                                                                                                    fillColor: Colors.white,
                                                                                                    labelStyle: TextStyle(
                                                                                                        color: textAlertDialogColor
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
                                                                                                    labelText: 'CPF',
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
                                                                                                  keyboardType: TextInputType.emailAddress,
                                                                                                  enableSuggestions: false,
                                                                                                  autocorrect: false,
                                                                                                  onChanged: (value){
                                                                                                    setState(() {
                                                                                                      Usrname = value;
                                                                                                    });
                                                                                                  },
                                                                                                  decoration: InputDecoration(
                                                                                                    filled: true,
                                                                                                    fillColor: Colors.white,
                                                                                                    labelStyle: TextStyle(
                                                                                                        color: textAlertDialogColor
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
                                                                                                    labelText: 'Login',
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
                                                                                                  keyboardType: TextInputType.emailAddress,
                                                                                                  enableSuggestions: false,
                                                                                                  autocorrect: false,
                                                                                                  onChanged: (value){
                                                                                                    setState(() {
                                                                                                      Senha = value;
                                                                                                    });
                                                                                                  },
                                                                                                  decoration: InputDecoration(
                                                                                                    filled: true,
                                                                                                    fillColor: Colors.white,
                                                                                                    labelStyle: TextStyle(
                                                                                                        color: textAlertDialogColor
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
                                                                                            const Center(
                                                                                                child: Text(
                                                                                                    "Permissões",
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.bold,
                                                                                                        fontSize: 16
                                                                                                    )
                                                                                                )
                                                                                            ),
                                                                                            Center(
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                children: [
                                                                                                  Checkbox(
                                                                                                    value: addCondominios ,
                                                                                                    onChanged: (bool? value){
                                                                                                      setState((){
                                                                                                        addCondominios = value!;
                                                                                                      });
                                                                                                    },
                                                                                                  ),
                                                                                                  const Text(
                                                                                                      'Adicionar novos condominios',
                                                                                                      style: TextStyle(
                                                                                                          fontSize: 16
                                                                                                      )
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            Center(
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                children: [
                                                                                                  Checkbox(
                                                                                                    value: editCFTV  ,
                                                                                                    onChanged: (bool? value){
                                                                                                      setState((){
                                                                                                        editCFTV = value!;
                                                                                                      });
                                                                                                    },
                                                                                                  ),
                                                                                                  const Text(
                                                                                                      'Editar CFTV',
                                                                                                      style: TextStyle(
                                                                                                          fontSize: 16
                                                                                                      )
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            Center(
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                children: [
                                                                                                  Checkbox(
                                                                                                    value: addAcionamentos,
                                                                                                    onChanged: (bool? value){
                                                                                                      setState((){
                                                                                                        addAcionamentos = value!;
                                                                                                      });
                                                                                                    },
                                                                                                  ),
                                                                                                  const Text(
                                                                                                      'Adicionar Acionamentos',
                                                                                                      style: TextStyle(
                                                                                                          fontSize: 16
                                                                                                      )
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            Center(
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                children: [
                                                                                                  Checkbox(
                                                                                                    value: addRamal,
                                                                                                    onChanged: (bool? value){
                                                                                                      setState((){
                                                                                                        addRamal  = value!;
                                                                                                      });
                                                                                                    },
                                                                                                  ),
                                                                                                  const Text(
                                                                                                      'Adicionar Ramal',
                                                                                                      style: TextStyle(
                                                                                                          fontSize: 16
                                                                                                      )
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            Center(
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                children: [
                                                                                                  Checkbox(
                                                                                                    value: addMoradores ,
                                                                                                    onChanged: (bool? value){
                                                                                                      setState((){
                                                                                                        addMoradores = value!;
                                                                                                      });
                                                                                                    },
                                                                                                  ),
                                                                                                  const Text(
                                                                                                      'Adicionar Moradores',
                                                                                                      style: TextStyle(
                                                                                                          fontSize: 16
                                                                                                      )
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            Center(
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                children: [
                                                                                                  Checkbox(
                                                                                                    value: addVisitante  ,
                                                                                                    onChanged: (bool? value){
                                                                                                      setState((){
                                                                                                        addVisitante = value!;
                                                                                                      });
                                                                                                    },
                                                                                                  ),
                                                                                                  const Text(
                                                                                                      'Adicionar Visitantes',
                                                                                                      style: TextStyle(
                                                                                                          fontSize: 16
                                                                                                      )
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            Center(
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                children: [
                                                                                                  Checkbox(
                                                                                                    value: addVeiculos  ,
                                                                                                    onChanged: (bool? value){
                                                                                                      setState((){
                                                                                                        addVeiculos = value!;
                                                                                                      });
                                                                                                    },
                                                                                                  ),
                                                                                                  const Text(
                                                                                                      'Adicionar Veiculos',
                                                                                                      style: TextStyle(
                                                                                                          fontSize: 16
                                                                                                      )
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            Center(
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                children: [
                                                                                                  Checkbox(
                                                                                                    value: criarNovosUsuarios,
                                                                                                    onChanged: (bool? value){
                                                                                                      setState((){
                                                                                                        criarNovosUsuarios  = value!;
                                                                                                      });
                                                                                                    },
                                                                                                  ),
                                                                                                  const Text(
                                                                                                      'Criar novos usuarios',
                                                                                                      style: TextStyle(
                                                                                                          fontSize: 16
                                                                                                      )
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            Center(
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                children: [
                                                                                                  Checkbox(
                                                                                                    value: editarAnotacao,
                                                                                                    onChanged: (bool? value){
                                                                                                      setState((){
                                                                                                        editarAnotacao = value!;
                                                                                                      });
                                                                                                    },
                                                                                                  ),
                                                                                                  const Text(
                                                                                                      'Editar anotação',
                                                                                                      style: TextStyle(
                                                                                                          fontSize: 16
                                                                                                      )
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            Center(
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                children: [
                                                                                                  Checkbox(
                                                                                                    value: acessoDevFuc ,
                                                                                                    onChanged: (bool? value){
                                                                                                      setState((){
                                                                                                        adicionarUsuarioss = value!;
                                                                                                      });
                                                                                                    },
                                                                                                  ),
                                                                                                  const Text(
                                                                                                      'Adicionar usuarios',
                                                                                                      style: TextStyle(
                                                                                                          fontSize: 16
                                                                                                      )
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            Center(
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                children: [
                                                                                                  Checkbox(
                                                                                                    value: acessoDevFuc ,
                                                                                                    onChanged: (bool? value){
                                                                                                      setState((){
                                                                                                        acessoDevFuc = value!;
                                                                                                      });
                                                                                                    },
                                                                                                  ),
                                                                                                  const Text(
                                                                                                      'Acesso as opções de teste e desenvolvimento',
                                                                                                      style: TextStyle(
                                                                                                          fontSize: 16
                                                                                                      )
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            ElevatedButton(onPressed: () async {
                                                                                              if(Nome == ""){
                                                                                                showToast("O nome está vazio!",context:context);
                                                                                              }else{
                                                                                                if(CPF == ""){
                                                                                                  showToast("O CPF está vazio!",context:context);
                                                                                                }else{
                                                                                                  if(Usrname == ""){
                                                                                                    showToast("O Login está vazio!",context:context);
                                                                                                  }else{
                                                                                                    if(Senha == ""){
                                                                                                      showToast("A Senha está vazia!",context:context);
                                                                                                    }else{
                                                                                                      FirebaseApp app = await Firebase.initializeApp(
                                                                                                          name: 'Secondary', options: Firebase.app().options);
                                                                                                      try{
                                                                                                        Uuid uuid = const Uuid();
                                                                                                        String email = "${uuid.v4()}@email.com";
                                                                                        
                                                                                                        UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
                                                                                                            .createUserWithEmailAndPassword(email: email, password: Senha);
                                                                                        
                                                                                                        FirebaseFirestore.instance.collection("Users").doc(userCredential.user?.uid).set({
                                                                                                          "Nome": Nome,
                                                                                                          "username": Usrname.trim(),
                                                                                                          "Email" : email,
                                                                                                          "Senha" : Senha,
                                                                                                          "CPF": CPF,
                                                                                                          "id": userCredential.user?.uid,
                                                                                                          "AdicionarCondominios": addCondominios,
                                                                                                          "acessoDevFunc": acessoDevFuc,
                                                                                                          "adicionaAcionamentos": addAcionamentos,
                                                                                                          "adicionarMoradores": addMoradores,
                                                                                                          "permissaoCriarUsuarios": criarNovosUsuarios,
                                                                                                          "adicionarVeiculo": addVeiculos,
                                                                                                          "adicionarVisitante": addVisitante,
                                                                                                          "editarAnotacao": editarAnotacao,
                                                                                                          "adicionarRamal": adicionarRamal,
                                                                                                          "adicionarUsuarios": adicionarUsuarioss,
                                                                                                          "editarCFTV": editCFTV,
                                                                                                        }).whenComplete((){
                                                                                                          //Vai exibir uma ação para copiar as credenciais!
                                                                                                          Navigator.pop(context);
                                                                                                          showDialog(
                                                                                                            context: context,
                                                                                                            builder: (BuildContext context) {
                                                                                                              return AlertDialog(
                                                                                                                title: const Text('Usuario criado!'),
                                                                                                                actions: [
                                                                                                                  Center(
                                                                                                                    child: Column(
                                                                                                                      children: [
                                                                                                                        Row(
                                                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                          children: [
                                                                                                                            Text("Login: ${Usrname.trim()}"),
                                                                                                                            IconButton(onPressed: (){
                                                                                                                              FlutterClipboard.copy("Login: ${Usrname.trim()}").then(( value ) {
                                                                                                                                showToast("Email copiado com sucesso!",context:context);
                                                                                                                              });
                                                                                                                            },
                                                                                                                                icon: const Icon(Icons.copy)
                                                                                                                            )
                                                                                                                          ],
                                                                                                                        ),
                                                                                                                        Row(
                                                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                          children: [
                                                                                                                            Text("Senha: $Senha"),
                                                                                                                            IconButton(onPressed: (){
                                                                                                                              FlutterClipboard.copy("Senha: $Senha").then(( value ) {
                                                                                                                                showToast("Senha copiada com sucesso!",context:context);
                                                                                                                              });
                                                                                                                            },
                                                                                                                                icon: const Icon(Icons.copy)
                                                                                                                            )
                                                                                                                          ],
                                                                                                                        ),
                                                                                                                        Row(
                                                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                          children: [
                                                                                                                            const Text("Copiar os dois"),
                                                                                                                            IconButton(onPressed: (){
                                                                                                                              FlutterClipboard.copy("Login: ${Usrname.trim()}\nSenha: $Senha").then(( value ) {
                                                                                                                                showToast("Conteúdo copiado com sucesso!",context:context);
                                                                                                                              });
                                                                                                                            },
                                                                                                                                icon: const Icon(Icons.copy)
                                                                                                                            )
                                                                                                                          ],
                                                                                                                        ),
                                                                                                                        ElevatedButton(onPressed: (){
                                                                                                                          Navigator.pop(context);
                                                                                                                        },
                                                                                                                          child: const Text("Fechar!"),)
                                                                                                                      ],
                                                                                                                    ),
                                                                                                                  )
                                                                                                                ],
                                                                                                              );
                                                                                                            },
                                                                                                          );
                                                                                                        });
                                                                                        
                                                                                                      }catch(e){
                                                                                                        showToast("Ocorreu um erro! $e",context:context);
                                                                                                      }
                                                                                                    }
                                                                                                  }
                                                                                                }
                                                                                              }
                                                                                            },
                                                                                                child: const Text("Criar novo usuario!")
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              },
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                        child: const Icon(Icons.add),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ): janela == 2 ?
                                                                acessoDevFunc == false ?
                                                                Container():
                                                                Column(
                                                                  children: [
                                                                    const Center(
                                                                        child: Text(
                                                                            'APIs de Teste',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 16
                                                                            )
                                                                        )
                                                                    ),
                                                                    const Center(
                                                                        child: Text(
                                                                            'Teste de acionamentos',
                                                                            style: TextStyle(
                                                                                fontSize: 16
                                                                            )
                                                                        )
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
                                                                              IP = value;
                                                                            });
                                                                          },
                                                                          decoration: InputDecoration(
                                                                            filled: true,
                                                                            fillColor: Colors.white,
                                                                            labelStyle: TextStyle(
                                                                                color: textAlertDialogColor
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
                                                                            labelText: 'IP',
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
                                                                          keyboardType: TextInputType.emailAddress,
                                                                          enableSuggestions: false,
                                                                          autocorrect: false,
                                                                          onChanged: (value){
                                                                            setState(() {
                                                                              Porta = value;
                                                                            });
                                                                          },
                                                                          decoration: InputDecoration(
                                                                            filled: true,
                                                                            fillColor: Colors.white,
                                                                            labelStyle: TextStyle(
                                                                                color: textAlertDialogColor
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
                                                                          keyboardType: TextInputType.emailAddress,
                                                                          enableSuggestions: false,
                                                                          autocorrect: false,
                                                                          onChanged: (value){
                                                                            setState(() {
                                                                              Canal = value;
                                                                            });
                                                                          },
                                                                          decoration: InputDecoration(
                                                                            filled: true,
                                                                            fillColor: Colors.white,
                                                                            labelStyle: TextStyle(
                                                                                color: textAlertDialogColor
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
                                                                      child: Container(
                                                                        padding: const EdgeInsets.all(16),
                                                                        child: TextField(
                                                                          keyboardType: TextInputType.emailAddress,
                                                                          enableSuggestions: false,
                                                                          autocorrect: false,
                                                                          onChanged: (value){
                                                                            setState(() {
                                                                              Usuario = value;
                                                                            });
                                                                          },
                                                                          decoration: InputDecoration(
                                                                            filled: true,
                                                                            fillColor: Colors.white,
                                                                            labelStyle: TextStyle(
                                                                                color: textAlertDialogColor
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
                                                                          keyboardType: TextInputType.emailAddress,
                                                                          enableSuggestions: false,
                                                                          autocorrect: false,
                                                                          onChanged: (value){
                                                                            setState(() {
                                                                              Senha = value;
                                                                            });
                                                                          },
                                                                          decoration: InputDecoration(
                                                                            filled: true,
                                                                            fillColor: Colors.white,
                                                                            labelStyle: TextStyle(
                                                                                color: textAlertDialogColor
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
                                                                      child: ValueListenableBuilder(valueListenable: dropValue4, builder: (context, String value, _){
                                                                        return DropdownButton(
                                                                          hint: Text(
                                                                            'Selecione o modelo',
                                                                            style: TextStyle(
                                                                                color: textColorDrop
                                                                            ),
                                                                          ),
                                                                          value: (value.isEmpty)? null : value,
                                                                          onChanged: (escolha) async {
                                                                            dropValue4.value = escolha.toString();
                                                                            setState(() {
                                                                              modeloselecionado = escolha.toString();
                                                                            });
                                                                          },
                                                                          items: ModelosAcionamentos.map((opcao) => DropdownMenuItem(
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
                                                                    ElevatedButton(
                                                                        onPressed: (){
                                                                          acionarPorta(context, IP, int.parse(Porta), modeloselecionado, int.parse(Canal), Usuario, Senha);
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor: colorBtn
                                                                        ),
                                                                        child: Text(
                                                                          "Testar!",
                                                                          style: TextStyle(
                                                                              color: textColor
                                                                          ),
                                                                        )
                                                                    ),
                                                                  ],
                                                                ): Container(),
                                                              ): Container(),
                                                              Container(
                                                                alignment: Alignment.bottomRight,
                                                                child: ElevatedButton(
                                                                    onPressed: inicializado == true ? (){
                                                                      FirebaseAuth.instance.signOut().whenComplete(() async {
                                                                        setState((){
                                                                          ip = "";
                                                                          user = "";
                                                                          pass = "";
                                                                          porta = 00;
                                                                          idCondominio = "";
                                                                          anotacao = "";
                                                                          UID = "";
                                                                          deslogando = true;
                                                                          inicializado = false;
                                                                        });
                                                                        final SharedPreferences prefs = await SharedPreferences.getInstance();

                                                                        await prefs.setString('email', "");
                                                                        await prefs.setString('senha', "");

                                                                        Navigator.pop(context);
                                                                        Navigator.pop(context);
                                                                        Navigator.push(context,
                                                                            MaterialPageRoute(builder: (context){
                                                                              return const login();
                                                                            }
                                                                            )
                                                                        );
                                                                      });
                                                                    }: null,
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor: Colors.red
                                                                    ),
                                                                    child: const Icon(
                                                                        Icons.exit_to_app,
                                                                      color: Colors.white
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
                                            },);
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent
                                      ),
                                      child: Image.asset(
                                          "assets/Setting-icon.png",
                                          scale: 10
                                      )
                                  ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/fundoWidgetContainerMain.png'),
                                    fit: BoxFit.cover,
                                  ),
                                  
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: wid / 4,
                                      height: heig / 3.9,
                                      child: Stack(
                                        children: [
                                          idCondominio != "" ?
                                          SingleChildScrollView(
                                            child: StreamBuilder(
                                              stream: pesquisando2 == true ? FirebaseFirestore.instance
                                                  .collection("Pessoas")
                                                  .where("idCondominio", isEqualTo: idCondominio)
                                                  .where("Nome", isGreaterThanOrEqualTo: pesquisa2)
                                                  .where("Nome", isLessThan: "${pesquisa2}z")
                                                  .snapshots():
                                              pesquisaCPF == true ?
                                              FirebaseFirestore.instance
                                                  .collection("Pessoas")
                                                  .where("idCondominio", isEqualTo: idCondominio)
                                                  .where("CPF", isGreaterThanOrEqualTo: pesquisa2)
                                                  .where("CPF", isLessThan: "${pesquisa2}z")
                                                  .snapshots():
                                              FirebaseFirestore.instance
                                                  .collection("Pessoas")
                                                  .where("idCondominio", isEqualTo: idCondominio)
                                                  .snapshots(),
                                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                          
                                                if (!snapshot.hasData) {
                                                  return const Center(
                                                    child: CircularProgressIndicator(),
                                                  );
                                                }
                          
                                                return Column(
                                                  children: [
                                                    SizedBox(
                                                      width: double.infinity,
                                                      height: heig / 3,
                                                      child: SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            Center(
                                                              child: Container(
                                                                padding: const EdgeInsets.all(10),
                                                                child: Stack(
                                                                  children: [
                                                                    TextField(
                                                                      cursorColor: Colors.black,
                                                                      keyboardType: TextInputType.name,
                                                                      enableSuggestions: true,
                                                                      autocorrect: true,
                                                                      onChanged: (value){
                                                                        pesquisa2 = value;

                                                                        if(value == ""){
                                                                          setState(() {
                                                                            pesquisando2 = false;
                                                                            pesquisaCPF = false;
                                                                          });
                                                                        }
                                                                      },
                                                                      decoration: const InputDecoration(
                                                                        filled: true,
                                                                        fillColor: Colors.white,
                                                                        border: OutlineInputBorder(),
                                                                        enabledBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(width: 3, color: Colors.white), //<-- SEE HERE
                                                                        ),
                                                                        focusedBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              width: 3,
                                                                              color: Colors.black
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      style: const TextStyle(
                                                                          color: Colors.black
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      alignment: AlignmentDirectional.centerEnd,
                                                                      child: TextButton(
                                                                        onPressed: () async {

                                                                          //Pesquisa de nomes;
                                                                          QuerySnapshot snapshotNome = await FirebaseFirestore.instance.collection("Pessoas")
                                                                              .where("idCondominio", isEqualTo: idCondominio)
                                                                              .where("Nome", isGreaterThanOrEqualTo: pesquisa2)
                                                                              .where("Nome", isLessThan: "${pesquisa2}z")
                                                                              .get();

                                                                          if(snapshotNome.docs.isNotEmpty){
                                                                            for (var doc in snapshotNome.docs) {
                                                                              //Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                                                              //print("Dados: $data");

                                                                              setState((){
                                                                                pesquisando2 = true;
                                                                              });
                                                                            }
                                                                          }

                                                                          //Pesquisa CPF
                                                                          QuerySnapshot snapshotCPF = await FirebaseFirestore.instance.collection("Pessoas")
                                                                              .where("idCondominio", isEqualTo: idCondominio)
                                                                              .where("CPF", isGreaterThanOrEqualTo: pesquisa2)
                                                                              .where("CPF", isLessThan: "${pesquisa2}z")
                                                                              .get();

                                                                          if(snapshotCPF.docs.isNotEmpty){
                                                                            for (var doc in snapshotCPF.docs) {
                                                                              //Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                                                              //print("Dados: $data");

                                                                              setState((){
                                                                                pesquisaCPF = true;
                                                                              });
                                                                            }
                                                                          }
                                                                        },
                                                                        child: Image.asset(
                                                                          "assets/search.png",
                                                                          scale: 12,
                                                                        ),
                                                                      )
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: double.infinity,
                                                              height: heig / 4,
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
                                                                            Text(
                                                                                "Nome: ${documents['Nome']}",
                                                                              style: TextStyle(
                                                                                  color: textColorInitBlue
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                                "CPF: ${documents['CPF']}",
                                                                              style: TextStyle(
                                                                                  color: textColorInitBlue
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    moradorselecionado == true ?
                                                    Stack(
                                                      children: [
                                                        Container(
                                                          padding: const EdgeInsets.all(16),
                                                          alignment: Alignment.centerRight,
                                                          child: TextButton(
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
                                                            child: const Icon(
                                                              Icons.close,
                                                              size: 40,
                                                            ),
                                                          ),
                                                        ),
                                                        Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                imageURLMorador != ""? Container(
                                                                    padding: const EdgeInsets.all(8),
                                                                    child: Image.network(
                                                                        height: 100,
                                                                        width: 100,
                                                                        imageURLMorador
                                                                    )
                                                                ): Center(
                                                                  child: Container(
                                                                      padding: const EdgeInsets.all(8),
                                                                      child: const Text("Nenhuma imagem encontrada!")
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
                                                                        child: Text("CPF: $CPFMorador",)
                                                                    ),
                                                                    Container(
                                                                        padding: const EdgeInsets.all(8),
                                                                        child: Text("Data de nascimento: $DatadeNascimentoMorador")
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
                                                                    borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
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
                                                                },style: ElevatedButton.styleFrom(
                                                                  backgroundColor: colorBtn
                                                                ),
                                                                  child: Text(
                                                                      "Salvar anotação",
                                                                    style: TextStyle(
                                                                        color: textColor
                                                                    ),
                                                                  )
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
                                          ):  Center(
                                            child: Center(
                                                child: Container(
                                                    width: wid / 4,
                                                    height: heig / 4,
                                                    padding: const EdgeInsets.all(16),
                                                    child: Text(
                                                        'Selecione algum cliente',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: textColorWidgets
                                                        ),
                                                    )
                                                )
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.bottomRight,
                                            padding: const EdgeInsets.all(16),
                                            child: adicionarMoradores == false ?
                                            Container():
                                            TextButton(
                                              onPressed: idCondominio == "" ? null : (){
                                              String NomeV = "";
                                              String CPFV = "";
                                              String RGV = "";
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
                                                        child: Dialog(
                                                          child: Stack(
                                                            children: [
                                                              Positioned.fill(
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  child: Image.asset(
                                                                    "assets/FundoMetalPreto.jpg",
                                                                    fit: BoxFit.fill,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 600,
                                                                padding: const EdgeInsets.all(16),
                                                                child: Column(
                                                                  children: [
                                                                    Center(
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const Text(
                                                                              'Cadastre um morador',
                                                                            style: TextStyle(
                                                                              fontSize: 30,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width: 100,
                                                                            height: 100,
                                                                            child: TextButton(onPressed: (){
                                                                              Navigator.pop(context);
                                                                            }, child: const Center(
                                                                              child: Icon(
                                                                                Icons.close,
                                                                                size: 40,
                                                                              ),
                                                                            )
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Center(
                                                                      child: ElevatedButton(
                                                                          onPressed: (){
                                                                            String ip = "";
                                                                            String portaa = "";
                                                                            String usuario = "";
                                                                            String Senha = "";
                                                                            String modeloPikado = "Control iD";

                                                                            var dropValue2 = ValueNotifier('Control iD');

                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return Center(
                                                                                  child: SingleChildScrollView(
                                                                                    child: Dialog(
                                                                                      child: Stack(
                                                                                        children: [
                                                                                          Positioned.fill(
                                                                                            child: ClipRRect(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                              child: Image.asset(
                                                                                                "assets/FundoMetalPreto.jpg",
                                                                                                fit: BoxFit.fill,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            width: 600,
                                                                                            padding: const EdgeInsets.all(16),
                                                                                            child: Column(
                                                                                              children: [
                                                                                                const Text(
                                                                                                    'Importar usuarios diretamente do equipamento',
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 30,
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
                                                                                                          ip = value;
                                                                                                        });
                                                                                                      },
                                                                                                      decoration: InputDecoration(
                                                                                                        filled: true,
                                                                                                        fillColor: Colors.white,
                                                                                                        labelStyle: TextStyle(
                                                                                                            color: textAlertDialogColor
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
                                                                                                        labelText: 'IP do equipamento',
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
                                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                                      enableSuggestions: false,
                                                                                                      autocorrect: false,
                                                                                                      onChanged: (value){
                                                                                                        setState(() {
                                                                                                          portaa = value;
                                                                                                        });
                                                                                                      },
                                                                                                      decoration: InputDecoration(
                                                                                                        filled: true,
                                                                                                        fillColor: Colors.white,
                                                                                                        labelStyle: TextStyle(
                                                                                                            color: textAlertDialogColor
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
                                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                                      enableSuggestions: false,
                                                                                                      autocorrect: false,
                                                                                                      onChanged: (value){
                                                                                                        setState(() {
                                                                                                          usuario = value;
                                                                                                        });
                                                                                                      },
                                                                                                      decoration: InputDecoration(
                                                                                                        filled: true,
                                                                                                        fillColor: Colors.white,
                                                                                                        labelStyle: TextStyle(
                                                                                                            color: textAlertDialogColor
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
                                                                                                        labelText: 'Login ADM do equipamento',
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
                                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                                      enableSuggestions: false,
                                                                                                      autocorrect: false,
                                                                                                      onChanged: (value){
                                                                                                        setState(() {
                                                                                                          Senha = value;
                                                                                                        });
                                                                                                      },
                                                                                                      decoration: InputDecoration(
                                                                                                        filled: true,
                                                                                                        fillColor: Colors.white,
                                                                                                        labelStyle: TextStyle(
                                                                                                            color: textAlertDialogColor
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
                                                                                                        labelText: 'Senha ADM do equipamento',
                                                                                                      ),
                                                                                                      style: TextStyle(
                                                                                                          color: textAlertDialogColor
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                Center(
                                                                                                  child: ValueListenableBuilder(valueListenable: dropValue2, builder: (context, String value, _){
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
                                                                                                        setState(() {
                                                                                                          modeloPikado = escolha.toString();
                                                                                                        });
                                                                                                      },
                                                                                                      items: ImportarUsuarios.map((opcao) => DropdownMenuItem(
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
                                                                                                  child: ElevatedButton(
                                                                                                      onPressed:() async {
                                                                                                        Map<String, dynamic> usuarios = await pushPessoas(context, ip, int.parse(portaa), usuario, Senha, modeloPikado);

                                                                                                        int lent = usuarios['users'].length - 1;
                                                                                                        for (int i = 0; i < lent; i++) {
                                                                                                          FirebaseFirestore.instance.collection('Pessoas').doc("${usuarios['users'][i]["id"]}").set({
                                                                                                            "id": "${usuarios['users'][i]["id"]}",
                                                                                                            "idCondominio": idCondominio,
                                                                                                            "Nome": usuarios['users'][i]["name"],
                                                                                                            "CPF": "",
                                                                                                            "RG": "",
                                                                                                            "DataNascimento": "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}",
                                                                                                            "imageURI": "",
                                                                                                            "placa": "",
                                                                                                            "Unidade":"",
                                                                                                            "Bloco": "",
                                                                                                            "anotacao": "",
                                                                                                          });
                                                                                                        }
                                                                                                        Navigator.pop(context);
                                                                                                        Navigator.pop(context);
                                                                                                        showToast("Importado com sucesso!", context: context);

                                                                                                      },
                                                                                                      style: ElevatedButton.styleFrom(
                                                                                                          backgroundColor: Colors.blue
                                                                                                      ),
                                                                                                      child: const Text(
                                                                                                          "Importar para o banco de dados",
                                                                                                        style: TextStyle(
                                                                                                          color: Colors.white
                                                                                                        )
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
                                                                              },
                                                                            );
                                                                          },
                                                                          style: ElevatedButton.styleFrom(
                                                                              backgroundColor: Colors.blue
                                                                          ),
                                                                          child: const Text(
                                                                              "Importar",
                                                                            style: TextStyle(
                                                                              color: Colors.white
                                                                            ),
                                                                          )
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
                                                                              NomeV = value;
                                                                            });
                                                                          },
                                                                          decoration: InputDecoration(
                                                                            filled: true,
                                                                            fillColor: Colors.white,
                                                                            labelStyle: TextStyle(
                                                                                color: textAlertDialogColor
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
                                                                            labelText: 'Nome',
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
                                                                          keyboardType: TextInputType.emailAddress,
                                                                          enableSuggestions: false,
                                                                          autocorrect: false,
                                                                          onChanged: (value){
                                                                            setState(() {
                                                                              CPFV = value;
                                                                            });
                                                                          },
                                                                          decoration: InputDecoration(
                                                                            filled: true,
                                                                            fillColor: Colors.white,
                                                                            labelStyle: TextStyle(
                                                                                color: textAlertDialogColor
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
                                                                            labelText: 'CPF',
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
                                                                          keyboardType: TextInputType.emailAddress,
                                                                          enableSuggestions: false,
                                                                          autocorrect: false,
                                                                          onChanged: (value){
                                                                            setState(() {
                                                                              RGV = value;
                                                                            });
                                                                          },
                                                                          decoration: InputDecoration(
                                                                            filled: true,
                                                                            fillColor: Colors.white,
                                                                            labelStyle: TextStyle(
                                                                                color: textAlertDialogColor
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
                                                                            labelText: 'RG',
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
                                                                          keyboardType: TextInputType.emailAddress,
                                                                          enableSuggestions: false,
                                                                          autocorrect: false,
                                                                          onChanged: (value){
                                                                            setState(() {
                                                                              Unidade = value;
                                                                            });
                                                                          },
                                                                          decoration: InputDecoration(
                                                                            filled: true,
                                                                            fillColor: Colors.white,
                                                                            labelStyle: TextStyle(
                                                                                color: textAlertDialogColor
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
                                                                            labelText: 'Unidade',
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
                                                                          keyboardType: TextInputType.emailAddress,
                                                                          enableSuggestions: false,
                                                                          autocorrect: false,
                                                                          onChanged: (value){
                                                                            setState(() {
                                                                              Bloco = value;
                                                                            });
                                                                          },
                                                                          decoration: InputDecoration(
                                                                            filled: true,
                                                                            fillColor: Colors.white,
                                                                            labelStyle: TextStyle(
                                                                                color: textAlertDialogColor
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
                                                                            labelText: 'Bloco',
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
                                                                            style: ElevatedButton.styleFrom(
                                                                                backgroundColor: colorBtn
                                                                            ),
                                                                            child: Text(
                                                                              'Selecione uma data',
                                                                              style: TextStyle(
                                                                                  color: textColor
                                                                              ),
                                                                            ),
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
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor: colorBtn
                                                                        ),
                                                                        child: Text(
                                                                          'Selecione uma Imagem de perfil',
                                                                          style: TextStyle(
                                                                              color: textColor
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      padding: const EdgeInsets.all(10),
                                                                      child: ElevatedButton(onPressed: () async {
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
                                                                                      Map<String, dynamic> id = await cadastronoEquipamento(context, ip, 8081, "admin", "admin", "Control iD", NomeV);
                                                                                      String ID = "${id["ids"][0]}";

                                                                                                                                      //
                                                                                      FirebaseStorage storage = FirebaseStorage.instance;
                                                                                      Reference ref = storage.ref().child('images/$idCondominio/$ID');
                                                                                      await ref.putFile(_imageFile!).whenComplete(() {
                                                                                        showToast("Imagem carregada!",context:context);
                                                                                      }).catchError((e){
                                                                                        showToast("Houve uma falha no carregamento! codigo do erro: $e",context:context);
                                                                                        showToast("Repasse esse erro para o desenvolvedor!",context:context);
                                                                                      });
                                                                                                                                      //
                                                                                      FirebaseFirestore.instance.collection('Pessoas').doc(ID).set({
                                                                                        "id": ID,
                                                                                        "idCondominio": idCondominio,
                                                                                        "Nome": NomeV,
                                                                                        "CPF": CPFV,
                                                                                        "RG": RGV,
                                                                                        "DataNascimento": "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}",
                                                                                        "imageURI": await ref.getDownloadURL(),
                                                                                        "Unidade ":Unidade,
                                                                                        "Bloco":Bloco,
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
                                                                      },style: ElevatedButton.styleFrom(
                                                                          backgroundColor: colorBtn
                                                                      ),
                                                                          child: Text(
                                                                            'Registrar novo cadastro',
                                                                            style: TextStyle(
                                                                                color: textColor
                                                                            ),
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
                                                  },);
                                                },
                                              );
                                            },
                                                child: Image.asset(
                                                    "assets/fab.png",
                                                    scale: 17
                                                )
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: wid / 4,
                                      height: heig / 3,
                                      child: Center(
                                        child: SingleChildScrollView(
                                          child: Stack(
                                            children: [
                                              idCondominio == "" ?
                                                    Center(
                                                        child: Text('Selecione um cliente!',
                                                          style: TextStyle(
                                                              color: textColorWidgets
                                                          ),
                                                        )
                                                    )
                                                  : Column(
                                                children: [
                                                  Center(
                                                    child: Container(
                                                      padding: const EdgeInsets.all(5),
                                                      child: Stack(
                                                        children: [
                                                          TextField(
                                                            cursorColor: Colors.black,
                                                            keyboardType: TextInputType.name,
                                                            enableSuggestions: true,
                                                            autocorrect: true,
                                                            onChanged: (value){
                                                              setState(() {
                                                                pesquisa7 = value;
                                                              });

                                                              if(value == ""){
                                                                setState(() {
                                                                  pesquisando7 = false;
                                                                });
                                                              }else{
                                                                setState(() {
                                                                  pesquisando7 = true;
                                                                });
                                                              }
                                                            },
                                                            decoration: const InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors.white,
                                                              border: OutlineInputBorder(),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: 3,
                                                                    color: Colors.black
                                                                ),
                                                              ),
                                                            ),
                                                            style: const TextStyle(
                                                                color: Colors.black
                                                            ),
                                                          ),
                                                          Container(
                                                            alignment: Alignment.centerRight,
                                                            child: TextButton(
                                                            onPressed: () async {
                                                              //Pesquisa nome
                                                              QuerySnapshot snapshotNome = await FirebaseFirestore.instance
                                                                  .collection("Visitantes")
                                                                  .where("idCondominio", isEqualTo: idCondominio)
                                                                  .where("Nome", isGreaterThanOrEqualTo: pesquisa7)
                                                                  .where("Nome", isLessThan: "${pesquisa7}z")
                                                                  .get();

                                                              if(snapshotNome.docs.isNotEmpty){
                                                                for (var doc in snapshotNome.docs) {
                                                                  //Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                                                  //print("Dados: $data");

                                                                  setState((){
                                                                    pesquisando7 = true;
                                                                  });
                                                                }
                                                              }

                                                              //Pesquisa CPF
                                                              QuerySnapshot snapshotCPF = await FirebaseFirestore.instance
                                                                  .collection("Visitantes")
                                                                  .where("idCondominio", isEqualTo: idCondominio)
                                                                  .where("CPFVist", isGreaterThanOrEqualTo: pesquisa8)
                                                                  .where("CPFVist", isLessThan: "${pesquisa8}9")
                                                                  .get();

                                                              if(snapshotCPF.docs.isNotEmpty){
                                                                for (var doc in snapshotNome.docs) {
                                                                  //Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                                                  //print("Dados: $data");

                                                                  setState((){
                                                                    pesquisando8 = true;
                                                                  });
                                                                }
                                                              }

                                                            },
                                                            child: Image.asset(
                                                              "assets/search.png",
                                                              scale: 12,
                                                            ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  StreamBuilder(
                                                      stream: pesquisando7 == true ?
                                                      FirebaseFirestore.instance
                                                          .collection("Visitantes")
                                                          .where("idCondominio", isEqualTo: idCondominio)
                                                          .where("Nome", isGreaterThanOrEqualTo: pesquisa7)
                                                          .where("Nome", isLessThan: "${pesquisa7}z")
                                                          .snapshots() :
                                                      pesquisando8 == true?
                                                      FirebaseFirestore.instance
                                                          .collection("Visitantes")
                                                          .where("idCondominio", isEqualTo: idCondominio)
                                                          .where("CPFVist", isGreaterThanOrEqualTo: pesquisa8)
                                                          .where("CPFVist", isLessThan: "${pesquisa8}9")
                                                          .snapshots():
                                                      pesquisando9 == true ? FirebaseFirestore.instance
                                                          .collection("Visitantes")
                                                          .where("idCondominio", isEqualTo: idCondominio)
                                                          .where("Unidade", isGreaterThanOrEqualTo: pesquisa9)
                                                          .where("Unidade", isLessThan: "${pesquisa9}9")
                                                          .snapshots():
                                                      pesquisando10 == true ? FirebaseFirestore.instance
                                                          .collection("Visitantes")
                                                          .where("idCondominio", isEqualTo: idCondominio)
                                                          .where("Placa", isGreaterThanOrEqualTo: pesquisa10)
                                                          .where("Placa", isLessThan: "${pesquisa10}z")
                                                          .snapshots():
                                                      FirebaseFirestore.instance
                                                          .collection("Visitantes")
                                                          .where("idCondominio", isEqualTo: idCondominio)
                                                          .snapshots(),
                                                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                          
                                                        if (!snapshot.hasData) {
                                                          return const Center(
                                                            child: CircularProgressIndicator(),
                                                          );
                                                        }
                          
                                                        return Container(
                                                          width: wid,
                                                          height: heig / 3.6,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors.blue,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                          child: ListView(
                                                            children: snapshot.data!.docs.map((documents){
                                                              return Container(
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                    color: Colors.blue,
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Container(
                                                                        padding: const EdgeInsets.all(6),
                                                                        child: Text(
                                                                            "Nome: ${documents["Nome"]}",
                                                                          style: TextStyle(
                                                                              color: textColorWidgets
                                                                          ),
                                                                        )
                                                                    ),
                                                                    Container(
                                                                        padding: const EdgeInsets.all(6),
                                                                        child: Text(
                                                                            "CPF: ${documents["CPFVist"]}",
                                                                          style: TextStyle(
                                                                              color: textColorWidgets
                                                                          ),
                                                                        )
                                                                    ),
                                                                    Container(
                                                                        padding: const EdgeInsets.all(6),
                                                                        child: Text(
                                                                            "Empresa: ${documents["Empresa"]}",
                                                                          style: TextStyle(
                                                                              color: textColorWidgets
                                                                          ),
                                                                        )
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        );
                                                      }
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                width: wid / 4,
                                                height: heig / 3,
                                                padding: const EdgeInsets.all(16),
                                                alignment: Alignment.bottomRight,
                                                child: adicionarVisitante == false ?
                                                Container() :
                                                TextButton(
                                                    onPressed: idCondominio == "" ? null : (){
                                                      var dropValue2 = ValueNotifier('Sem Previsão');
                          
                                                      List Permanencia = [
                                                        'Sem Previsão',
                                                        '5 minutos',
                                                        '7 minutos',
                                                        '15 minutos',
                                                        '30 minutos',
                                                        '1 hora',
                                                        '2 horas',
                                                        '3 horas',
                                                        '4 horas',
                                                        '5 horas',
                                                        '6 horas',
                                                        '7 horas',
                                                        '8 horas',
                                                        '9 horas',
                                                        '10 horas',
                                                        '11 horas',
                                                        '12 horas',
                                                        '24 horas',
                                                      ];
                          
                                                      //Não obrigatórios
                                                      String Unidade = "";
                                                      String Bloco = "";
                                                      String Rua = "";
                                                      String obs = "";
                                                      String Empresa = "";
                                                      String Veiculo = "";
                                                      String Cracha = "";
                                                      String Placa = "";
                                                      String Telefone = "";
                                                      String Previsao = "Sem Previsão";
                          
                                                      //Campos obrigatórios
                                                      String Nome = "";
                                                      String CPFVist = "";
                                                      File? _imageFile;
                          
                          
                                                      final picker = ImagePicker();
                          
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                                                            return SingleChildScrollView(
                                                              child: Dialog(
                                                                child: Stack(
                                                                  children: [
                                                                    Positioned.fill(
                                                                      child: ClipRRect(
                                                                        borderRadius: BorderRadius.circular(10),
                                                                        child: Image.asset(
                                                                          "assets/FundoMetalPreto.jpg",
                                                                          fit: BoxFit.fill,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: 600,
                                                                      padding: const EdgeInsets.all(20),
                                                                      child: Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              const Text(
                                                                                  'Cadastrar novo visitante',
                                                                                style: TextStyle(
                                                                                  fontSize: 30,
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 80,
                                                                                height: 80,
                                                                                child: TextButton(onPressed: (){
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: const Center(
                                                                                    child: Icon(
                                                                                      Icons.close,
                                                                                      size: 35,
                                                                                    ),
                                                                                  )
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          Center(
                                                                            child: Column(
                                                                              children: [
                                                                                Center(
                                                                                  child: Container(
                                                                                      padding: const EdgeInsets.all(16),
                                                                                      child: const Text('Qual será a unidade que será visitada?')
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
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor
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
                                                                                        labelText: 'Unidade',
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
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setState(() {
                                                                                          Bloco = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor
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
                                                                                        labelText: 'Bloco',
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
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setState(() {
                                                                                          Rua = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor
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
                                                                                        labelText: 'Rua',
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
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setState(() {
                                                                                          Nome = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor
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
                                                                                        labelText: 'Nome',
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
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setState(() {
                                                                                          CPFVist = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor
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
                                                                                        labelText: 'CPF',
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
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setState(() {
                                                                                          Telefone = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor
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
                                                                                        labelText: 'Telefone',
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
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setState(() {
                                                                                          Cracha = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor
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
                                                                                        labelText: 'Crachá',
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
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setState(() {
                                                                                          Empresa = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor
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
                                                                                        labelText: 'Empresa',
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
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setState(() {
                                                                                          Veiculo = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor
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
                                                                                        labelText: 'Veiculo',
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
                                                                                      keyboardType: TextInputType.emailAddress,
                                                                                      enableSuggestions: false,
                                                                                      autocorrect: false,
                                                                                      onChanged: (value){
                                                                                        setState(() {
                                                                                          Placa = value;
                                                                                        });
                                                                                      },
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        labelStyle: TextStyle(
                                                                                            color: textAlertDialogColor
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
                                                                                        labelText: 'Placa',
                                                                                      ),
                                                                                      style: TextStyle(
                                                                                          color: textAlertDialogColor
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Center(
                                                                                  child: ValueListenableBuilder(valueListenable: dropValue2, builder: (context, String value, _){
                                                                                    return DropdownButton(
                                                                                      hint: Text(
                                                                                        'Permanência',
                                                                                        style: TextStyle(
                                                                                            color: textColorDrop
                                                                                        ),
                                                                                      ),
                                                                                      value: (value.isEmpty)? null : value,
                                                                                      onChanged: (escolha) async {
                                                                                        dropValue2.value = escolha.toString();
                                                                                        setState(() {
                                                                                          Previsao = escolha.toString();
                                                                                        });
                                                                                      },
                                                                                      items: Permanencia.map((opcao) => DropdownMenuItem(
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
                                                                                _imageFile != null ? Center(
                                                                                  child: SizedBox(
                                                                                    width: 300,
                                                                                    height: 300,
                                                                                    child: Image.file(_imageFile!),
                                                                                  ),
                                                                                ): const Center(
                                                                                  child: Text("Sem imagem selecionada!"),
                                                                                ),
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
                                                                                    style: ElevatedButton.styleFrom(
                                                                                        backgroundColor: colorBtn
                                                                                    ),
                                                                                    child: Text(
                                                                                      'Selecione a imagem do documento da pessoa!',
                                                                                      style: TextStyle(
                                                                                          color: textColor
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  padding: const EdgeInsets.all(16),
                                                                                  child: TextField(
                                                                                    keyboardType: TextInputType.multiline,
                                                                                    enableSuggestions: true,
                                                                                    autocorrect: true,
                                                                                    minLines: 5,
                                                                                    maxLines: null,
                                                                                    onChanged: (value){
                                                                                      setState(() {
                                                                                        obs = value;
                                                                                      });
                                                                                    },
                                                                                    decoration: InputDecoration(
                                                                                      filled: true,
                                                                                      fillColor: Colors.white,
                                                                                      labelStyle: TextStyle(
                                                                                          color: textAlertDialogColor
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
                                                                                      labelText: 'Observações',
                                                                                    ),
                                                                                    style: TextStyle(
                                                                                        color: textAlertDialogColor
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Center(
                                                                                  child: ElevatedButton(
                                                                                    onPressed: () async {
                                                                                      if(Nome == ""){
                                                                                        showToast("O campo de nome está vazio!",context:context);
                                                                                      }else{
                                                                                        if(CPFVist == ""){
                                                                                          showToast("O campo de CPF está vazio!",context:context);
                                                                                        }else{
                                                                                          if(_imageFile == null){
                                                                                            showToast("O documento não foi passado!",context:context);
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
                                                                                            Reference ref = storage.ref().child('images/visitantes/$idCondominio/$UUID');
                                                                                            await ref.putFile(_imageFile!).whenComplete(() {
                                                                                              showToast("Imagem carregada!",context:context);
                                                                                            }).catchError((e){
                                                                                              showToast("Houve uma falha no carregamento! codigo do erro: $e",context:context);
                                                                                              showToast("Repasse esse erro para o desenvolvedor!",context:context);
                                                                                            });
                                                                                            FirebaseFirestore.instance.collection('Visitantes').doc(UUID).set({
                                                                                              "Unidade": Unidade,
                                                                                              "Bloco": Bloco,
                                                                                              "Rua": Rua,
                                                                                              "obs": obs,
                                                                                              "Empresa": Empresa,
                                                                                              "Veiculo": Veiculo,
                                                                                              "Cracha": Cracha,
                                                                                              "Placa": Placa,
                                                                                              "Telefone": Telefone,
                                                                                              "Previsao": Previsao,
                                                                                              "Nome": Nome,
                                                                                              "CPFVist": CPFVist,
                                                                                              "idCondominio": idCondominio,
                                                                                              "imageURI": await ref.getDownloadURL(),
                                                                                            }).whenComplete((){
                                                                                              Navigator.pop(context);
                                                                                              Navigator.pop(context);
                                                                                            });
                                                                                          }
                                                                                        }
                                                                                      }
                                                                                    },style: ElevatedButton.styleFrom(
                                                                                      backgroundColor: colorBtn
                                                                                  ),
                                                                                    child: Text(
                                                                                      "Salvar",
                                                                                      style: TextStyle(
                                                                                          color: textColor
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },);
                                                        },
                                                      );
                                                    },
                                                    child: Image.asset(
                                                        "assets/fab.png",
                                                         scale: 17
                                                    )
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ),
                                    SizedBox(
                                        width: wid / 4,
                                        height: heig / 3,
                                        child: Center(
                                          child: Center(
                                            child: SizedBox(
                                              width: wid / 4,
                                              height: heig / 3,
                                              child: SingleChildScrollView(
                                                child: Stack(
                                                  children: [
                                                    if (idCondominio == "") Center(child:
                                                            Text('Selecione um cliente!',
                                                                  style: TextStyle(
                                                                      color: textColorWidgets
                                                                  ),
                                                                )
                                                          ) else Column(
                                                      children: [
                                                        Center(
                                                          child: Container(
                                                            padding: const EdgeInsets.all(6),
                                                            child: Stack(
                                                              children: [
                                                                TextField(
                                                                  cursorColor: Colors.black,
                                                                  keyboardType: TextInputType.name,
                                                                  enableSuggestions: true,
                                                                  autocorrect: true,
                                                                  onChanged: (value){
                                                                    pesquisa3 = value;

                                                                    if(value == ""){
                                                                      setState(() {
                                                                        pesquisando3 = false;
                                                                      });
                                                                    }
                                                                  },
                                                                  decoration: const InputDecoration(
                                                                    filled: true,
                                                                    fillColor: Colors.white,
                                                                    border: OutlineInputBorder(),
                                                                    focusedBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          width: 3,
                                                                          color: Colors.black
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  style: const TextStyle(
                                                                      color: Colors.black
                                                                  ),
                                                                ),
                                                                Container(
                                                                  alignment: Alignment.centerRight,
                                                                  child: TextButton(
                                                                    onPressed: () async {
                                                                      //Pesquisa de nomes;
                                                                      QuerySnapshot snapshotNome = await FirebaseFirestore.instance
                                                                          .collection("Veiculos")
                                                                          .where("idCondominio", isEqualTo: idCondominio)
                                                                          .where("PlacaV", isGreaterThanOrEqualTo: pesquisa6)
                                                                          .where("PlacaV", isLessThan: "${pesquisa6}z")
                                                                          .get();

                                                                      if(snapshotNome.docs.isNotEmpty){
                                                                        for (var doc in snapshotNome.docs) {
                                                                          //Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                                                          //print("Dados: $data");

                                                                          setState((){
                                                                            pesquisando6 = true;
                                                                          });
                                                                        }
                                                                      }
                                                                    },
                                                                      child: Image.asset(
                                                                        "assets/search.png",
                                                                        scale: 12,
                                                                      )
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        StreamBuilder(
                                                            stream: pesquisando3 == true ?
                                                            FirebaseFirestore.instance
                                                                .collection("Veiculos")
                                                                .where("idCondominio", isEqualTo: idCondominio)
                                                                .where("Unidade", isGreaterThanOrEqualTo: pesquisa3)
                                                                .where("Unidade", isLessThan: "${pesquisa3}9")
                                                                .snapshots() :
                                                            pesquisando4 == true ?
                                                            FirebaseFirestore.instance
                                                                .collection("Veiculos")
                                                                .where("idCondominio", isEqualTo: idCondominio)
                                                                .where("blocoV", isGreaterThanOrEqualTo: pesquisa4)
                                                                .where("blocoV", isLessThan: "${pesquisa4}z")
                                                                .snapshots() :
                                                            pesquisando5 == true ? FirebaseFirestore.instance
                                                                .collection("Veiculos")
                                                                .where("idCondominio", isEqualTo: idCondominio)
                                                                .where("IdentificacaoModeloV", isGreaterThanOrEqualTo: pesquisa5)
                                                                .where("IdentificacaoModeloV", isLessThan: "${pesquisa5}z")
                                                                .snapshots():
                                                            pesquisando6 == true ? FirebaseFirestore.instance
                                                                .collection("Veiculos")
                                                                .where("idCondominio", isEqualTo: idCondominio)
                                                                .where("PlacaV", isGreaterThanOrEqualTo: pesquisa6)
                                                                .where("PlacaV", isLessThan: "${pesquisa6}z")
                                                                .snapshots():
                                                            FirebaseFirestore.instance
                                                                .collection("Veiculos")
                                                                .where("idCondominio", isEqualTo: idCondominio)
                                                                .snapshots(),
                                                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                          
                                                              if (!snapshot.hasData) {
                                                                return const Center(
                                                                  child: CircularProgressIndicator(),
                                                                );
                                                              }
                          
                                                              return Container(
                                                                width: wid,
                                                                height: heig / 3.9,
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                    color: Colors.blue,
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                child: ListView(
                                                                  children: snapshot.data!.docs.map((documents){
                                                                    return Container(
                                                                      decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                          color: Colors.blue,
                                                                          width: 1.0,
                                                                        ),
                                                                      ),
                                                                      child: Center(
                                                                        child: Container(
                                                                            padding: const EdgeInsets.all(6),
                                                                            child: Text(
                                                                                "Placa: ${documents["PlacaV"]}",
                                                                              style: TextStyle(
                                                                                  color: textColorWidgets
                                                                              ),
                                                                            )
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                ),
                                                              );
                                                            }
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      alignment: Alignment.bottomRight,
                                                      child: adicionarVeiculo == false ?
                                                      Container():
                                                      Container(
                                                        padding: const EdgeInsets.all(16),
                                                        alignment: Alignment.bottomRight,
                                                        width: wid / 4,
                                                        height: heig / 3,
                                                        child: TextButton(
                                                            onPressed: idCondominio == "" ? null : (){
                          
                                                              String Unidade = "";
                                                              String blocoV = "";
                                                              String IdentificacaoModeloV = "";
                                                              String MarcaV = "";
                                                              String corV = "";
                                                              String PlacaV = "";
                                                              List Cores = [
                                                                'Preto',
                                                                'Branco',
                                                                'Vermelho',
                                                                'Azul',
                                                                'Prata',
                                                                'Cinza',
                                                                'Verde',
                                                                'Amarelo',
                                                                'Marrom',
                                                                'Laranja'
                                                              ];
                          
                                                              showDialog(
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                                                                    return AlertDialog(
                                                                      title: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const Text('Cadastrar novo veiculo'),
                                                                          IconButton(
                                                                            onPressed: (){
                                                                              Navigator.pop(context);
                                                                            },
                                                                            icon: const Icon(Icons.close),
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
                                                                                        borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
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
                                                                                        blocoV = value;
                                                                                      });
                                                                                    },
                                                                                    decoration: const InputDecoration(
                                                                                      border: OutlineInputBorder(),
                                                                                      enabledBorder: OutlineInputBorder(
                                                                                        borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
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
                                                                                  child: TextField(
                                                                                    keyboardType: TextInputType.emailAddress,
                                                                                    enableSuggestions: false,
                                                                                    autocorrect: false,
                                                                                    onChanged: (value){
                                                                                      setState(() {
                                                                                        MarcaV = value;
                                                                                      });
                                                                                    },
                                                                                    decoration: const InputDecoration(
                                                                                      border: OutlineInputBorder(),
                                                                                      enabledBorder: OutlineInputBorder(
                                                                                        borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                      ),
                                                                                      focusedBorder: OutlineInputBorder(
                                                                                        borderSide: BorderSide(
                                                                                            width: 3,
                                                                                            color: Colors.black
                                                                                        ),
                                                                                      ),
                                                                                      labelText: 'Marca',
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
                                                                                        IdentificacaoModeloV = value;
                                                                                      });
                                                                                    },
                                                                                    decoration: const InputDecoration(
                                                                                      border: OutlineInputBorder(),
                                                                                      enabledBorder: OutlineInputBorder(
                                                                                        borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                                                                                      ),
                                                                                      focusedBorder: OutlineInputBorder(
                                                                                        borderSide: BorderSide(
                                                                                            width: 3,
                                                                                            color: Colors.black
                                                                                        ),
                                                                                      ),
                                                                                      labelText: 'Modelo',
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Center(
                                                                                child: ValueListenableBuilder(valueListenable: dropValue, builder: (context, String value, _){
                                                                                  return DropdownButton(
                                                                                    hint: Text(
                                                                                      'Selecione a cor',
                                                                                      style: TextStyle(
                                                                                          color: textColorDrop
                                                                                      ),
                                                                                    ),
                                                                                    value: (value.isEmpty)? null : value,
                                                                                    onChanged: (escolha) async {
                                                                                      dropValue.value = escolha.toString();
                                                                                      setState(() {
                                                                                        corV = escolha.toString();
                                                                                      });
                                                                                    },
                                                                                    items: Cores.map((opcao) => DropdownMenuItem(
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
                                                                                child: Container(
                                                                                  padding: const EdgeInsets.all(16),
                                                                                  child: TextField(
                                                                                    keyboardType: TextInputType.emailAddress,
                                                                                    enableSuggestions: false,
                                                                                    autocorrect: false,
                                                                                    onChanged: (value){
                                                                                      setState(() {
                                                                                        PlacaV = value;
                                                                                      });
                                                                                    },
                                                                                    decoration: const InputDecoration(
                                                                                      border: OutlineInputBorder(),
                                                                                      enabledBorder: OutlineInputBorder(
                                                                                        borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
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
                                                                                child: ElevatedButton(
                                                                                  onPressed: (){
                                                                                    if(Unidade == ""){
                                                                                      showToast("A unidade está vazia!",context:context);
                                                                                    }else{
                                                                                      if(blocoV == ""){
                                                                                        showToast("O Bloco está vazio!",context:context);
                                                                                      }else{
                                                                                        if(MarcaV == ""){
                                                                                          showToast("A Marca está vazia!",context:context);
                                                                                        }else{
                                                                                          if(IdentificacaoModeloV == ""){
                                                                                            showToast("A Identificação está vazia!",context:context);
                                                                                          }else{
                                                                                            if(corV == ""){
                                                                                              showToast("A Cor não foi definida!",context:context);
                                                                                            }else{
                                                                                              if(PlacaV == ""){
                                                                                                showToast("A Placa está vazia!",context:context);
                                                                                              }else{
                                                                                                Uuid uuid = const Uuid();
                                                                                                String UUID = uuid.v4();
                                                                                                FirebaseFirestore.instance.collection('Veiculos').doc(UUID).set({
                                                                                                  "Unidade": Unidade,
                                                                                                  "blocoV": blocoV,
                                                                                                  "IdentificacaoModeloV": IdentificacaoModeloV,
                                                                                                  "MarcaV": MarcaV,
                                                                                                  "corV": corV,
                                                                                                  "PlacaV": PlacaV,
                                                                                                  "idCondominio": idCondominio
                                                                                                }).whenComplete((){
                                                                                                  Navigator.pop(context);
                                                                                                });
                                                                                              }
                                                                                            }
                                                                                          }
                                                                                        }
                                                                                      }
                                                                                    }
                                                                                  },
                                                                                  style: ElevatedButton.styleFrom(
                                                                                      backgroundColor: colorBtn
                                                                                  ),
                                                                                  child: const Text("Salvar"),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    );
                                                                  },);
                                                                },
                                                              );
                                                            },
                                                            child: Image.asset(
                                                            "assets/fab.png",
                                                            scale: 17
                                                        )
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
