import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sparta_monitoramento/acionamento_de_portas/acionamento_de_portas.dart';
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

//Cores
Color colorBtnAcionamento1 = Colors.red;

//Controladores
TextEditingController anotacaoControl = TextEditingController(text: anotacaoMorador);

//Booleanos
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
bool moradorselecionado = false;
bool pesquisaNumeros = false;
bool acionamento1clicado = false;

//Inteiros
int? porta;
int colunasIPCamera = 4;

//DropDownValues
var dropValue = ValueNotifier('');

//Cores
MaterialAccentColor corDasBarras = Colors.deepPurpleAccent;

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
                              onPressed: idCondominio == "" ? null : () async {
                                ConnectVoIP(context);
                              },
                              child: const Text("VoIP")
                            ),
                            ElevatedButton(
                                onPressed: idCondominio == "" ? null : () async {

                                  //Visitantes

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
                                                  const Text('Visitantes'),
                                                  IconButton(
                                                    onPressed: (){
                                                      setState((){
                                                        pesquisando7 = false;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    icon: const Icon(Icons.close),
                                                  )
                                                ],
                                              ),
                                              actions: [
                                                Center(
                                                  child: SizedBox(
                                                    width: wid,
                                                    height: heig / 1.3,
                                                    child: Stack(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Center(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Container(
                                                                    width: 300,
                                                                    height: 60,
                                                                    padding: const EdgeInsets.all(10),
                                                                    child: TextField(
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
                                                                        label: Text('Pesquisar (Nome)'),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: 300,
                                                                    height: 60,
                                                                    padding: const EdgeInsets.all(10),
                                                                    child: TextField(
                                                                      keyboardType: TextInputType.name,
                                                                      enableSuggestions: true,
                                                                      autocorrect: true,
                                                                      onChanged: (value){
                                                                        setState(() {
                                                                          pesquisa8 = value;
                                                                        });

                                                                        if(value == ""){
                                                                          setState(() {
                                                                            pesquisando8 = false;
                                                                          });
                                                                        }else{
                                                                          setState(() {
                                                                            pesquisando8 = true;
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
                                                                        label: Text('Pesquisar (CPF)'),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: 300,
                                                                    height: 60,
                                                                    padding: const EdgeInsets.all(10),
                                                                    child: TextField(
                                                                      keyboardType: TextInputType.name,
                                                                      enableSuggestions: true,
                                                                      autocorrect: true,
                                                                      onChanged: (value){
                                                                        setState(() {
                                                                          pesquisa9 = value;
                                                                        });

                                                                        if(value == ""){
                                                                          setState(() {
                                                                            pesquisando9 = false;
                                                                          });
                                                                        }else{
                                                                          setState(() {
                                                                            pesquisando9 = true;
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
                                                                        label: Text('Pesquisar (Unidade)'),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: 300,
                                                                    height: 60,
                                                                    padding: const EdgeInsets.all(10),
                                                                    child: TextField(
                                                                      keyboardType: TextInputType.name,
                                                                      enableSuggestions: true,
                                                                      autocorrect: true,
                                                                      onChanged: (value){
                                                                        setState(() {
                                                                          pesquisa10 = value;
                                                                        });

                                                                        if(value == ""){
                                                                          setState(() {
                                                                            pesquisando10 = false;
                                                                          });
                                                                        }else{
                                                                          setState(() {
                                                                            pesquisando10 = true;
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
                                                                        label: Text('Pesquisar (Placa)'),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
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
                                                                    height: heig / 1.5,
                                                                    decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                        color: Colors.black,
                                                                        width: 1.0,
                                                                      ),
                                                                      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                                                    ),
                                                                    child: ListView(
                                                                      children: snapshot.data!.docs.map((documents){
                                                                        return Container(
                                                                          decoration: BoxDecoration(
                                                                            border: Border.all(
                                                                              color: Colors.black,
                                                                              width: 1.0,
                                                                            ),
                                                                            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                                                          ),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              Container(
                                                                                  padding: const EdgeInsets.all(16),
                                                                                  child: Text("Nome: ${documents["Nome"]}")
                                                                              ),
                                                                              Container(
                                                                                  padding: const EdgeInsets.all(16),
                                                                                  child: Text("CPF: ${documents["CPFVist"]}")
                                                                              ),
                                                                              Container(
                                                                                  padding: const EdgeInsets.all(16),
                                                                                  child: Text("Telefone: ${documents["Telefone"]}")
                                                                              ),
                                                                              Container(
                                                                                  padding: const EdgeInsets.all(16),
                                                                                  child: Text("Empresa: ${documents["Empresa"]}")
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
                                                          alignment: Alignment.bottomRight,
                                                          child: FloatingActionButton(
                                                              onPressed: (){
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
                                                                        child: AlertDialog(
                                                                          title: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              const Text('Cadastrar novo visitante'),
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
                                                                                      child: TextField(
                                                                                        keyboardType: TextInputType.emailAddress,
                                                                                        enableSuggestions: false,
                                                                                        autocorrect: false,
                                                                                        onChanged: (value){
                                                                                          setState(() {
                                                                                            Rua = value;
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
                                                                                          labelText: 'Rua',
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
                                                                                            CPFVist = value;
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
                                                                                            Telefone = value;
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
                                                                                          labelText: 'Telefone',
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
                                                                                          labelText: 'Crachá',
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
                                                                                          labelText: 'Empresa',
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
                                                                                          labelText: 'Veiculo',
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
                                                                                    child: ValueListenableBuilder(valueListenable: dropValue2, builder: (context, String value, _){
                                                                                      return DropdownButton(
                                                                                        hint: const Text(
                                                                                          'Permanência',
                                                                                          style: TextStyle(
                                                                                              color: Colors.white
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
                                                                                            style: const TextStyle(
                                                                                                color: Colors.white
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
                                                                                      child: const Text('Selecione a imagem do documento da pessoa!'),
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
                                                                                        labelText: 'Observações',
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
                                                                                      },
                                                                                      child: const Text("Salvar"),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },);
                                                                  },
                                                                );
                                                              },
                                                              child: const Icon(Icons.add)
                                                          ),
                                                        )
                                                      ],
                                                    ),
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
                                child: const Text("Visitantes")
                            ),
                            ElevatedButton(
                                onPressed: idCondominio == "" ? null : () async{

                                  //Veiculos

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
                                                  const Text('Veiculos'),
                                                  IconButton(
                                                    onPressed: (){
                                                      setState((){
                                                        pesquisando3 = false;
                                                        pesquisando4 = false;
                                                        pesquisando5  = false;
                                                        pesquisando6  = false;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    icon: const Icon(Icons.close),
                                                  )
                                                ],
                                              ),
                                              actions: [
                                                Center(
                                                  child: SizedBox(
                                                    width: wid,
                                                    height: heig / 1.3,
                                                    child: Stack(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Center(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Container(
                                                                    width: 300,
                                                                    height: 60,
                                                                    padding: const EdgeInsets.all(10),
                                                                    child: TextField(
                                                                      keyboardType: TextInputType.name,
                                                                      enableSuggestions: true,
                                                                      autocorrect: true,
                                                                      onChanged: (value){
                                                                        setState(() {
                                                                          pesquisa3 = value;
                                                                        });

                                                                        if(value == ""){
                                                                          setState(() {
                                                                            pesquisando3 = false;
                                                                          });
                                                                        }else{
                                                                          setState(() {
                                                                            pesquisando3 = true;
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
                                                                        label: Text('Pesquisar (Unidade)'),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: 300,
                                                                    height: 60,
                                                                    padding: const EdgeInsets.all(10),
                                                                    child: TextField(
                                                                      keyboardType: TextInputType.name,
                                                                      enableSuggestions: true,
                                                                      autocorrect: true,
                                                                      onChanged: (value){
                                                                        setState(() {
                                                                          pesquisa4 = value;
                                                                        });

                                                                        if(value == ""){
                                                                          setState(() {
                                                                            pesquisando4 = false;
                                                                          });
                                                                        }else{
                                                                          setState(() {
                                                                            pesquisando4 = true;
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
                                                                        label: Text('Pesquisar (Bloco)'),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: 300,
                                                                    height: 60,
                                                                    padding: const EdgeInsets.all(10),
                                                                    child: TextField(
                                                                      keyboardType: TextInputType.name,
                                                                      enableSuggestions: true,
                                                                      autocorrect: true,
                                                                      onChanged: (value){
                                                                        setState(() {
                                                                          pesquisa5 = value;
                                                                        });

                                                                        if(value == ""){
                                                                          setState(() {
                                                                            pesquisando5 = false;
                                                                          });
                                                                        }else{
                                                                          setState(() {
                                                                            pesquisando5 = true;
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
                                                                        label: Text('Pesquisar (Identificação)'),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: 300,
                                                                    height: 60,
                                                                    padding: const EdgeInsets.all(10),
                                                                    child: TextField(
                                                                      keyboardType: TextInputType.name,
                                                                      enableSuggestions: true,
                                                                      autocorrect: true,
                                                                      onChanged: (value){
                                                                        setState(() {
                                                                          pesquisa6 = value;
                                                                        });

                                                                        if(value == ""){
                                                                          setState(() {
                                                                            pesquisando6 = false;
                                                                          });
                                                                        }else{
                                                                          setState(() {
                                                                            pesquisando6 = true;
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
                                                                        label: Text('Pesquisar (Placa)'),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
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
                                                                  height: heig / 1.5,
                                                                  decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                      color: Colors.black,
                                                                      width: 1.0,
                                                                    ),
                                                                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                                                  ),
                                                                  child: ListView(
                                                                    children: snapshot.data!.docs.map((documents){
                                                                      return Container(
                                                                        decoration: BoxDecoration(
                                                                          border: Border.all(
                                                                            color: Colors.black,
                                                                            width: 1.0,
                                                                          ),
                                                                          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                                                        ),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Container(
                                                                                padding: const EdgeInsets.all(16),
                                                                                child: Text("Unidade: ${documents["Unidade"]}")
                                                                            ),
                                                                            Container(
                                                                                padding: const EdgeInsets.all(16),
                                                                                child: Text("Bloco: ${documents["blocoV"]}")
                                                                            ),
                                                                            Container(
                                                                                padding: const EdgeInsets.all(16),
                                                                                child: Text("Identificação: ${documents["IdentificacaoModeloV"]}")
                                                                            ),
                                                                            Container(
                                                                                padding: const EdgeInsets.all(16),
                                                                                child: Text("Cor: ${documents["corV"]}")
                                                                            ),
                                                                            Container(
                                                                                padding: const EdgeInsets.all(16),
                                                                                child: Text("Placa: ${documents["PlacaV"]}")
                                                                            ),
                                                                            Container(
                                                                                padding: const EdgeInsets.all(16),
                                                                                child: Text("Marca: ${documents["MarcaV"]}")
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
                                                          alignment: Alignment.bottomRight,
                                                          child: FloatingActionButton(
                                                              onPressed: (){

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
                                                                                          blocoV = value;
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
                                                                                          borderSide: BorderSide(width: 3, color: Colors.grey), //<-- SEE HERE
                                                                                        ),
                                                                                        focusedBorder: OutlineInputBorder(
                                                                                          borderSide: BorderSide(
                                                                                              width: 3,
                                                                                              color: Colors.black
                                                                                          ),
                                                                                        ),
                                                                                        labelText: 'Identificação ou Modelo',
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
                                                                                          borderSide: BorderSide(width: 3, color: Colors.grey), //<-- SEE HERE
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
                                                                                  child: ValueListenableBuilder(valueListenable: dropValue, builder: (context, String value, _){
                                                                                    return DropdownButton(
                                                                                      hint: const Text(
                                                                                        'Selecione a cor',
                                                                                        style: TextStyle(
                                                                                            color: Colors.white
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
                                                                                          style: const TextStyle(
                                                                                              color: Colors.white
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
                                                                                  child: ElevatedButton(
                                                                                    onPressed: (){
                                                                                      if(Unidade == ""){
                                                                                        showToast("A unidade está vazia!",context:context);
                                                                                      }else{
                                                                                        if(blocoV == ""){
                                                                                          showToast("O Bloco está vazio!",context:context);
                                                                                        }else{
                                                                                          if(IdentificacaoModeloV == ""){
                                                                                            showToast("A Identificação está vazia!",context:context);
                                                                                          }else{
                                                                                            if(MarcaV == ""){
                                                                                              showToast("A Marca está vazia!",context:context);
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
                                                              child: const Icon(Icons.add)
                                                          ),
                                                        )
                                                      ],
                                                    ),
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
                                child: const Text("Veiculos")
                            ),
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () async {

                            },
                            child: const Text("Configurações")
                        ),
                      ],
                    ),
                    backgroundColor: corDasBarras,
                  ),
                  //UI começa aqui!
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
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    AppBar(
                                      backgroundColor: corDasBarras,
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
                                            label: Text('Pesquisar (Codigo de Cadastro ou Nome)'),
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
                                                  //if(documents["Aviso"] != ""){
                                                  //  showDialog(
                                                  //    context: context,
                                                  //    builder: (BuildContext context) {
                                                  //      return Center(
                                                  //        child: SingleChildScrollView(
                                                  //          child: AlertDialog(
                                                  //            title: const Text('Aviso!'),
                                                  //            actions: [
                                                  //              Center(
                                                  //                child: Column(
                                                  //                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  //                  mainAxisAlignment: MainAxisAlignment.center,
                                                  //                  children: [
                                                  //                    Text(documents["Aviso"]),
                                                  //                    Container(
                                                  //                      padding: const EdgeInsets.all(16),
                                                  //                      child: ElevatedButton(onPressed: (){
                                                  //                        Navigator.pop(context);
                                                  //                      },
                                                  //                          child: const Text('Fechar')
                                                  //                      ),
                                                  //                    )
                                                  //                  ],
                                                  //                ),
                                                  //              )
                                                  //            ],
                                                  //          ),
                                                  //        ),
                                                  //      );
                                                  //    },
                                                  //  );
                                                  //}
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
                                height: heig / 1.8,
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
                                      Container(
                                        child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                AppBar(
                                                  backgroundColor: corDasBarras,
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
                                                        height: 500,
                                                        child: GridView.count(
                                                          childAspectRatio: 1.4,
                                                          crossAxisCount: colunasIPCamera,
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
                                                                                    height: 300,
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
                                                                                    height: 300,
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
                                        ),
                                      ),
                                    ]
                                ): Column(
                                  children: [
                                    AppBar(
                                      backgroundColor: corDasBarras,
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
                                          padding: const EdgeInsets.only(left: 130, right: 160),
                                          child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Acionamento'),
                                              Text('Ramais'),
                                            ],
                                          ),
                                        ),
                                        backgroundColor: corDasBarras,
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                                Center(
                                                  child: SizedBox(
                                                    width: wid / 4,
                                                    height: heig / 4,
                                                    child: Stack(
                                                      children: [
                                                        StreamBuilder(
                                                          stream: FirebaseFirestore.instance
                                                              .collection('acionamentos')
                                                              .where("idCondominio", isEqualTo: idCondominio)
                                                              .snapshots(),
                                                          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                            if (snapshot.hasError) {
                                                              return const Center(child: Text('Algo deu errado!'));
                                                            }

                                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                                              return const Center(child: CircularProgressIndicator());
                                                            }

                                                            if (snapshot.hasData) {
                                                              return GridView.count(
                                                                  crossAxisCount: 4,
                                                                  children: snapshot.data!.docs.map((documents) {
                                                                    return Container(
                                                                      padding: const EdgeInsets.all(2),
                                                                      decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                          color: Colors.black,
                                                                          width: 1.0,
                                                                        ),
                                                                        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                                                      ),
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          IconButton(
                                                                              onPressed: (){
                                                                                if(acionamento1clicado == false){
                                                                                  setState(() {
                                                                                    colorBtnAcionamento1 = Colors.green;
                                                                                    acionamento1clicado = true;
                                                                                  });
                                                                                }else{
                                                                                  acionarPorta(context, documents["ip"], documents["porta"], documents["modelo"], documents["canal"], documents["usuario"], documents["senha"]);
                                                                                  setState(() {
                                                                                    acionamento1clicado = false;
                                                                                    colorBtnAcionamento1 = Colors.red;
                                                                                  });
                                                                                }
                                                                              },
                                                                              icon: Icon(
                                                                                  Icons.radio_button_checked,
                                                                                  color: colorBtnAcionamento1
                                                                              )
                                                                          ),
                                                                          Text(documents["nome"]),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }).toList()
                                                              );
                                                            }
                                                            return const Center(
                                                                child: Text('Sem dados!')
                                                            );
                                                          },
                                                        ),
                                                        Container(
                                                          alignment: Alignment.bottomRight,
                                                          child: FloatingActionButton(
                                                              onPressed: idCondominio == "" ? null:
                                                              (){
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

                                                                    List Modelos = [
                                                                      "Intelbras"
                                                                    ];

                                                                    return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                                                                      return AlertDialog(
                                                                        title: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            const Text('Adicionar novo acionamento'),
                                                                            IconButton(onPressed: (){
                                                                              Navigator.pop(context);
                                                                            },
                                                                            icon: const Icon(Icons.close)
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        actions: [
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
                                                                                        label: Text('Nome de identificação'),
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
                                                                                        label: Text('IP'),
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
                                                                                        label: Text('Porta'),
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
                                                                                        label: Text('Canal'),
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
                                                                                        label: Text('Usuario'),
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
                                                                                        label: Text('Senha'),
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
                                                                                hint: const Text(
                                                                                  'Selecione o modelo',
                                                                                  style: TextStyle(
                                                                                      color: Colors.white
                                                                                  ),
                                                                                ),
                                                                                value: (value.isEmpty)? null : value,
                                                                                onChanged: (escolha) async {
                                                                                  dropValue3.value = escolha.toString();
                                                                                  setState(() {
                                                                                    modeloselecionado = escolha.toString();
                                                                                  });
                                                                                },
                                                                                items: Modelos.map((opcao) => DropdownMenuItem(
                                                                                  value: opcao,
                                                                                  child:
                                                                                  Text(
                                                                                    opcao,
                                                                                    style: const TextStyle(
                                                                                        color: Colors.white
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
                                                                                                  FirebaseFirestore.instance.collection("acionamentos").doc().set({
                                                                                                    "nome": nome,
                                                                                                    "ip": ip,
                                                                                                    "porta": int.parse(porta),
                                                                                                    "canal": int.parse(canal),
                                                                                                    "usuario": usuario,
                                                                                                    "senha": senha,
                                                                                                    "modelo": modeloselecionado,
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
                                                                                    }
                                                                                  }
                                                                                }
                                                                              },
                                                                            child: const Text('Criar'),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: const Icon(Icons.add)
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
                                                          return InkWell(
                                                            onTap: (){
                                                              startCall(context, documents['RamalNumber']);
                                                            },
                                                            child: Container(
                                                              padding: const EdgeInsets.all(10),
                                                              width: double.infinity,
                                                              height: 70,
                                                              decoration: BoxDecoration(
                                                                border: Border.all(
                                                                  color: Colors.black,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                                              ),
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
                                                    width: wid / 4.3,
                                                    height: heig / 4,
                                                    alignment: Alignment.bottomRight,
                                                    padding: const EdgeInsets.all(16),
                                                    child: FloatingActionButton(onPressed:
                                                    idCondominio == "" ? null :(){
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          String NomeRamal = "";
                                                          String RamalNumber = "";

                                                          return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                                                            return AlertDialog(
                                                              title: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  const Text('Crie um Ramal!'),
                                                                  IconButton(
                                                                    onPressed: (){
                                                                      Navigator.pop(context);
                                                                    },
                                                                    icon: const Icon(Icons.close)
                                                                  )
                                                                ],
                                                              ),
                                                              actions: [
                                                                Center(
                                                                  child: Column(
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
                                                                              label: Text('Nome do Ramal'),
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
                                                                              label: Text("Numero do Ramal")
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
                                                                          }, child: const Text('Criar')
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
                                                      child: const Icon(Icons.add),
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
                        Column(
                          children: [
                            SizedBox(
                              width: wid / 4,
                              height: heig / 1.64,
                              child: Stack(
                                children: [
                                  idCondominio != "" ?
                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        AppBar(
                                          backgroundColor: corDasBarras,
                                          centerTitle: true,
                                          title: const Text('Moradores'),
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
                                                  pesquisa2 = value;
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
                                                label: Text('Pesquisar (CPF)'),
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
                                                                Text("CPF: ${documents['CPF']}"),
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
                                          backgroundColor: corDasBarras,
                                          centerTitle: true,
                                          title: const Text('Moradores'),
                                        ),
                                        Center(
                                            child: Container(
                                                padding: const EdgeInsets.all(16),
                                                child: const Text('Selecione algum cliente')
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
                              height: heig / 3.5,
                              child: Center(
                                child: SingleChildScrollView(
                                  child: Container(
                                    padding: const EdgeInsets.all(0),
                                    child: Column(
                                      children: [
                                        AppBar(
                                          backgroundColor: corDasBarras,
                                          centerTitle: true,
                                          title: const Text('Anotação'),
                                        ),
                                        Center(
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(16),
                                                child: TextField(
                                                  controller: anotacaoControl,
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
