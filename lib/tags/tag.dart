import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:vigilant/FirebaseHost.dart';
import 'package:vigilant/acionamento_de_portas/acionamento_de_portas.dart';
import 'package:vigilant/controlidCommon/ControlIDCommon.dart';
import 'package:vigilant/homeApp.dart';
import 'package:vigilant/informacoesLogais/getIds.dart';
import 'package:vigilant/informacoesLogais/getUserInformations.dart';
import 'package:vigilant/libDePessoas/pushPessoas.dart';

//Programado por HeroRickyGAMES com a ajuda de Deus!

String ip = "";
int porta = 00;

//Aqui eu coloquei todo o controle de tags, como nome, geração de tags e tals!
controledeTags(var context, var wid , var heig){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (BuildContext context, StateSetter setStater){
        return AlertDialog(
          title: const Text('Selecione uma Secbox'),
          actions: [
            Center(
              child: Column(
                children: [
                  Center(
                    child: SizedBox(
                      width: 600,
                      height: 300,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('acionamentos')
                            .where("idCondominio", isEqualTo: idCondominio)
                            .where("modelo", isEqualTo: "Control iD")
                            .where("secbox", isEqualTo: true)
                            .snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Center(child:
                            Text('Algo deu errado!')
                            );
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator(color: Colors.white,));
                          }

                          if (snapshot.hasData) {
                            return GridView.count(
                                childAspectRatio: 1.2,
                                crossAxisCount: 3,
                                children: snapshot.data!.docs.map((documents) {
                                  double tamanhotext = 14;
                                  bool isBolded = false;

                                  if(documents["nome"].length >= 16){
                                    tamanhotext = 12;
                                  }

                                  if(documents["nome"].length >= 20){
                                    tamanhotext = 9;
                                    isBolded = true;
                                  }

                                  return Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 40,
                                              child: InkWell(
                                                onTap: (){

                                                  String ip = documents["ip"];
                                                  int porta = documents["porta"];
                                                  String modelo = documents["modelo"];
                                                  int canal = documents["canal"];
                                                  String usuario = documents["usuario"];
                                                  String senha = documents["senha"];
                                                  String id = documents["id"];
                                                  String acionamentoID = id;
                                                  String receptor = documents["receptor"];
                                                  String can = documents["can"];
                                                  String nome = documents["nome"];
                                                  bool secbox = documents["secbox"];

                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return StatefulBuilder(builder: (BuildContext context, StateSetter setStates){
                                                        return AlertDialog(
                                                          title: Center(
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets.all(16),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      const Text(
                                                                        'Tags',
                                                                        style: TextStyle(
                                                                            fontSize: 25,
                                                                            fontWeight: FontWeight.bold
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width: 50,
                                                                        height: 50,
                                                                        child: TextButton(onPressed: (){
                                                                          Navigator.pop(context);
                                                                        },
                                                                            child:const Center(
                                                                              child: Icon(
                                                                                Icons.close,
                                                                                size: 30,
                                                                              ),
                                                                            )
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                Stack(
                                                                  children: [
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      crossAxisAlignment: CrossAxisAlignment.center ,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.center ,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: wid / 3,
                                                                              height: 50,
                                                                              child: TextField(
                                                                                cursorColor: Colors.black,
                                                                                keyboardType: TextInputType.name,
                                                                                enableSuggestions: true,
                                                                                autocorrect: true,
                                                                                onChanged: (value){
                                                                                  pesquisavalue = value.toUpperCase();

                                                                                  if(value == ""){
                                                                                    setStates(() {
                                                                                      pesquisando55 = false;
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
                                                                            ),
                                                                            Container(
                                                                                alignment: AlignmentDirectional.centerEnd,
                                                                                child: TextButton(
                                                                                  onPressed: () async {
                                                                                    if(pesquisavalue == ""){
                                                                                      setStates(() {
                                                                                        pesquisando55 = false;
                                                                                      });
                                                                                    }else{
                                                                                      final RegExp regExp = RegExp(r'^\d+$');

                                                                                      if(regExp.hasMatch(pesquisavalue)){
                                                                                        QuerySnapshot snapshotNome = await FirebaseFirestore.instance.collection("tags")
                                                                                            .where("acionamentoID", isEqualTo: id)
                                                                                            .where("idCondominio", isEqualTo: idCondominio)
                                                                                            .where("tagID", isGreaterThanOrEqualTo: pesquisavalue)
                                                                                            .where("tagID", isLessThan: "${pesquisavalue}z")
                                                                                            .get();

                                                                                        if(snapshotNome.docs.isNotEmpty){
                                                                                          for (var doc in snapshotNome.docs) {
                                                                                            //Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                                                                            //print("Dados: $data");

                                                                                            setStates((){
                                                                                              pesquisando56 = true;
                                                                                              pesquisando55 = false;
                                                                                            });
                                                                                          }
                                                                                        }else{
                                                                                          showToast("Nada foi encontrado!", context: context);
                                                                                          setStates((){
                                                                                            pesquisando56 = false;
                                                                                          });
                                                                                        }
                                                                                      }else{
                                                                                        //Pesquisa de nomes;
                                                                                        QuerySnapshot snapshotNome = await FirebaseFirestore.instance.collection("tags")
                                                                                            .where("acionamentoID", isEqualTo: id)
                                                                                            .where("idCondominio", isEqualTo: idCondominio)
                                                                                            .where("Nome", isGreaterThanOrEqualTo: pesquisavalue)
                                                                                            .where("Nome", isLessThan: "${pesquisavalue}z")
                                                                                            .get();

                                                                                        if(snapshotNome.docs.isNotEmpty){
                                                                                          for (var doc in snapshotNome.docs) {
                                                                                            //Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                                                                            //print("Dados: $data");

                                                                                            setStates((){
                                                                                              pesquisando55 = true;
                                                                                              pesquisando56 = false;
                                                                                            });
                                                                                          }
                                                                                        }else{
                                                                                          showToast("Nada foi encontrado!", context: context);
                                                                                          setStates((){
                                                                                            pesquisando55 = false;
                                                                                          });
                                                                                        }
                                                                                      }
                                                                                    }
                                                                                  },
                                                                                  child: Image.asset(
                                                                                      "assets/search.png",
                                                                                      scale: 14
                                                                                  ),
                                                                                )
                                                                            ),
                                                                            ElevatedButton(
                                                                                onPressed: () async {
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

                                                                                  CollectionReference collectionRef = FirebaseFirestore.instance.collection("tags");
                                                                                  QuerySnapshot querySnapshot = await collectionRef.where("idCondominio", isEqualTo: idCondominio).get();

                                                                                  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
                                                                                    await doc.reference.delete();
                                                                                  }

                                                                                  Map<String, dynamic> usuarios = await controlidTags(context, ip, porta, usuario, senha);

                                                                                  print(usuarios);

                                                                                  String ImageURL = "";
                                                                                  int lent = 0;

                                                                                  if(usuarios['users'].length == 0){
                                                                                    lent = 0;
                                                                                    showToast("O acionamento não tem usuarios cadastrados!", context: context);
                                                                                  }else{
                                                                                    lent = usuarios['users'].length;
                                                                                  }

                                                                                  print(usuarios['users'].length);

                                                                                  for (int i = 0; i < lent; i++) {
                                                                                    cadastrarPs(){
                                                                                      FirebaseFirestore.instance.collection('tags').doc("${usuarios['users'][i]["id"]}$idCondominio").set({
                                                                                        "id": "${usuarios['users'][i]["id"]}$idCondominio",
                                                                                        "tagID": "${usuarios['users'][i]["id"]}",
                                                                                        "idCondominio": idCondominio,
                                                                                        "Nome": usuarios['users'][i]["name"],
                                                                                        "acionamentoID": id,
                                                                                        "CPF": "",
                                                                                        "RG": "",
                                                                                        "imageURI": ImageURL,
                                                                                        "placa": "",
                                                                                        "Unidade":"",
                                                                                        "Bloco": "",
                                                                                        "Celular": "",
                                                                                        "anotacao": "",
                                                                                        "Telefone": '',
                                                                                        "Qualificacao": '',
                                                                                      });
                                                                                    }

                                                                                    cadastrarSemFoto(){

                                                                                      FirebaseFirestore.instance.collection('tags').doc("${usuarios['users'][i]["id"]}$idCondominio").set({
                                                                                        "id": "${usuarios['users'][i]["id"]}$idCondominio",
                                                                                        "idCondominio": idCondominio,
                                                                                        "Nome": usuarios['users'][i]["name"],
                                                                                        "tagID": "${usuarios['users'][i]["id"]}",
                                                                                        "acionamentoID": id,
                                                                                        "CPF": "",
                                                                                        "RG": "",
                                                                                        "imageURI": '',
                                                                                        "placa": "",
                                                                                        "Unidade":"",
                                                                                        "Bloco": "",
                                                                                        "Telefone": "",
                                                                                        "Celular": "",
                                                                                        "anotacao": "",
                                                                                        "Qualificacao": '',
                                                                                      });
                                                                                    }

                                                                                    File image;

                                                                                    if(await ImagemEquipamentoCotroliD(ip, porta, usuarios['Season'], usuarios['users'][i]["id"]) == null){
                                                                                      cadastrarSemFoto();
                                                                                    }else{
                                                                                      print('passei por aqui');
                                                                                      image = await ImagemEquipamentoCotroliD(ip, porta, usuarios['Season'], usuarios['users'][i]["id"]);

                                                                                      ImageURL = await carregarImagem(context, image, "$i", idCondominio);
                                                                                      cadastrarPs();
                                                                                    }
                                                                                  }
                                                                                  Navigator.pop(context);
                                                                                  showToast("Importado com sucesso!", context: context);
                                                                                },
                                                                                style: ElevatedButton.styleFrom(
                                                                                    backgroundColor: Colors.blue
                                                                                ),
                                                                                child: const Text(
                                                                                  'Importar usuarios do equipamento',
                                                                                  style: TextStyle(
                                                                                      color: Colors.white
                                                                                  ),
                                                                                )
                                                                            )
                                                                          ],
                                                                        ),
                                                                        Container(
                                                                          padding: const EdgeInsets.only(top:16,),
                                                                          child: ElevatedButton(
                                                                              onPressed: (){
                                                                                String nome = "";
                                                                                String TAG = "";

                                                                                showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                                                                                      return AlertDialog(
                                                                                        title: Column(
                                                                                          children: [
                                                                                            const Text('Cadastro da TAG'),
                                                                                            Center(
                                                                                              child: Container(
                                                                                                padding: const EdgeInsets.all(16),
                                                                                                child: TextField(
                                                                                                  keyboardType: TextInputType.emailAddress,
                                                                                                  enableSuggestions: false,
                                                                                                  autocorrect: false,
                                                                                                  onChanged: (value){
                                                                                                    setStater(() {
                                                                                                      nome = value;
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
                                                                                                    setStater(() {
                                                                                                      TAG = value;
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
                                                                                                    labelText: 'TAG ID',
                                                                                                  ),
                                                                                                  style: TextStyle(
                                                                                                      color: textAlertDialogColor
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            ElevatedButton(
                                                                                                onPressed: (){
                                                                                                  if(nome == ""){
                                                                                                    showToast("O campo nome está vazio!", context: context);
                                                                                                  }else{
                                                                                                    if(TAG == ""){
                                                                                                      showToast("O campo TAG está vazio!", context: context);
                                                                                                    }else{
                                                                                                      final regex = RegExp(r'[a-zA-Z]');
                                                                                                      if(TAG.contains(regex)){
                                                                                                        showToast("A ID das Tags apenas permitem o uso de numeros!", context: context);
                                                                                                      }else{
                                                                                                        tagCadastro(context,ip, porta, usuario, senha, acionamentoID, nome, TAG);
                                                                                                      }
                                                                                                    }
                                                                                                  }
                                                                                                },
                                                                                                child: const Text("Cadastrar TAG no aparelho")
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
                                                                              style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: Colors.blue
                                                                              ),
                                                                              child: const Text(
                                                                                  'Cadastrar nova tag',
                                                                                style: TextStyle(
                                                                                    color: Colors.white
                                                                                ),
                                                                              )
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          padding: const EdgeInsets.all(16),
                                                                          child: const Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text("Nome"),
                                                                              Text("Tag")
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          padding: const EdgeInsets.all(16),
                                                                          child: StreamBuilder(stream:
                                                                          pesquisando55 == true ?
                                                                          FirebaseFirestore.instance
                                                                              .collection("tags")
                                                                              .where("Nome", isGreaterThanOrEqualTo: pesquisavalue)
                                                                              .where("Nome", isLessThan: "${pesquisavalue}z")
                                                                              .snapshots():
                                                                          pesquisando56 == true ?
                                                                          FirebaseFirestore.instance
                                                                              .collection("tags")
                                                                              .where("acionamentoID", isEqualTo: id)
                                                                              .where("idCondominio", isEqualTo: idCondominio)
                                                                              .where("tagID", isGreaterThanOrEqualTo: pesquisavalue)
                                                                              .where("tagID", isLessThan: "${pesquisavalue}z")
                                                                              .snapshots():
                                                                          FirebaseFirestore.instance
                                                                              .collection("tags")
                                                                              .where("acionamentoID", isEqualTo: id)
                                                                              .where("idCondominio", isEqualTo: idCondominio)
                                                                              .snapshots(), builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                                                            if (!snapshot.hasData) {
                                                                              return const Center(
                                                                                child: CircularProgressIndicator(color: Colors.white,),
                                                                              );
                                                                            }
                                                                            return SizedBox(
                                                                              width: wid / 2,
                                                                              height: heig / 2,
                                                                              child: ListView(
                                                                                children: snapshot.data!.docs.map((documents){
                                                                                  return Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Container(
                                                                                        padding: const EdgeInsets.all(5),
                                                                                        child: Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text(
                                                                                              documents['Nome'],
                                                                                              textAlign: TextAlign.start,
                                                                                              style: const TextStyle(
                                                                                                  fontSize: 18,
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              documents['tagID'],
                                                                                              textAlign: TextAlign.start,
                                                                                              style: const TextStyle(
                                                                                                  fontSize: 18
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Row(
                                                                                        children: [
                                                                                          ElevatedButton(
                                                                                              onPressed: () {
                                                                                                mandarRequisicaoParaDigital(context, ip, porta, usuario, senha, int.parse(documents['tagID']), "tags");
                                                                                              },
                                                                                              style: ElevatedButton.styleFrom(
                                                                                                  backgroundColor: Colors.blue
                                                                                              ),
                                                                                              child: const Icon(
                                                                                                  Icons.fingerprint,
                                                                                                  color: Colors.white
                                                                                              )
                                                                                          ),
                                                                                          ElevatedButton(
                                                                                              onPressed: (){
                                                                                                String nome = documents['Nome'];
                                                                                                String TAG = documents['tagID'];
                                                                                                String originaltag = documents['tagID'];

                                                                                                TextEditingController nomeControl = TextEditingController(text: nome);
                                                                                                TextEditingController tagControl = TextEditingController(text: TAG);

                                                                                                showDialog(
                                                                                                  context: context,
                                                                                                  builder: (BuildContext context) {
                                                                                                    return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                                                                                                      return AlertDialog(
                                                                                                        title: Column(
                                                                                                          children: [
                                                                                                            const Text('Edição da TAG'),
                                                                                                            Center(
                                                                                                              child: Container(
                                                                                                                padding: const EdgeInsets.all(16),
                                                                                                                child: TextField(
                                                                                                                  controller: nomeControl,
                                                                                                                  keyboardType: TextInputType.emailAddress,
                                                                                                                  enableSuggestions: false,
                                                                                                                  autocorrect: false,
                                                                                                                  onChanged: (value){
                                                                                                                    setStater(() {
                                                                                                                      nome = value;
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
                                                                                                                  controller: tagControl,
                                                                                                                  keyboardType: TextInputType.emailAddress,
                                                                                                                  enableSuggestions: false,
                                                                                                                  autocorrect: false,
                                                                                                                  onChanged: (value){
                                                                                                                    setStater(() {
                                                                                                                      TAG = value;
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
                                                                                                                    labelText: 'TAG ID',
                                                                                                                  ),
                                                                                                                  style: TextStyle(
                                                                                                                      color: textAlertDialogColor
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                            ElevatedButton(
                                                                                                                onPressed: (){
                                                                                                                  if(nome == ""){
                                                                                                                    showToast("O campo nome está vazio!", context: context);
                                                                                                                  }else{
                                                                                                                    if(TAG == ""){
                                                                                                                      showToast("O campo TAG está vazio!", context: context);
                                                                                                                    }else{
                                                                                                                      tagEdicao(context,ip, porta, usuario, senha, acionamentoID, nome, TAG, documents['id'], originaltag);
                                                                                                                    }
                                                                                                                  }
                                                                                                                },
                                                                                                                child: const Text("Editar TAG no aparelho")
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
                                                                                              style: ElevatedButton.styleFrom(
                                                                                                  backgroundColor: Colors.blue
                                                                                              ),
                                                                                              child: const Icon(
                                                                                                  Icons.edit,
                                                                                                  color: Colors.white
                                                                                              )
                                                                                          ),
                                                                                          ElevatedButton(
                                                                                              onPressed: (){
                                                                                                showDialog(
                                                                                                  context: context,
                                                                                                  builder: (BuildContext context) {
                                                                                                    return AlertDialog(
                                                                                                      title: const Text('Deseja deletar essa tag?'),
                                                                                                      actions: [
                                                                                                        Row(
                                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                          children: [
                                                                                                            TextButton(
                                                                                                                onPressed: (){
                                                                                                                  Navigator.pop(context);
                                                                                                                },
                                                                                                                child: const Text('Não')
                                                                                                            ),
                                                                                                            TextButton(
                                                                                                                onPressed: (){
                                                                                                                  deleteUsers(context, ip, porta, usuario, senha, documents['tagID'], documents['id']);
                                                                                                                },
                                                                                                                child: const Text('Sim')
                                                                                                            ),
                                                                                                          ],
                                                                                                        )
                                                                                                      ],
                                                                                                    );
                                                                                                  },
                                                                                                );
                                                                                              },
                                                                                              style: ElevatedButton.styleFrom(
                                                                                                  backgroundColor: Colors.red[400]
                                                                                              ),
                                                                                              child: Icon(
                                                                                                  Icons.delete,
                                                                                                  color: Colors.red[900]
                                                                                              )
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                                }).toList(),
                                                                              ),
                                                                            );
                                                                          }
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },);
                                                    },
                                                  );
                                                },
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Image.asset(
                                                      documents["deuErro"] == true ?
                                                      "assets/btnIsNotAbleToConnect.png":
                                                      documents["prontoParaAtivar"] == false ?
                                                      "assets/btnInactive.png" :
                                                      "assets/btnIsAbleToAction.png",
                                                      scale: 5,
                                                    ),
                                                    Image.asset(
                                                        documents["iconeSeleciondo"],
                                                        scale: 45
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Text(
                                              documents["nome"],
                                              style: isBolded == true?
                                              TextStyle(
                                                  color: textAlertDialogColorReverse,
                                                  fontSize: tamanhotext,
                                                  fontWeight: FontWeight.bold
                                              )
                                                  :
                                              TextStyle(
                                                color: textAlertDialogColorReverse,
                                                fontSize: tamanhotext,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList().reversed.toList()
                            );
                          }
                          return const Center(
                              child: Text('Sem dados!',)
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
      );
    },
  );
}

//Import de usuarios da Controlid tags
Future<Map<String, dynamic>> controlidTags(var context, String ip, int porta, String usuario, String Senha) async {

  final ipog = Uri.parse('http://$ip:$porta/login.fcgi');

  Map<String, String> headerslog = {
    "Content-Type": "application/json"
  };

  Map<String, dynamic> bodylog = {
    "login": usuario,
    "password": Senha
  };
  try{
    final response = await http.post(
      ipog,
      headers: headerslog,
      body: jsonEncode(bodylog),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      final url = Uri.parse('http://$ip:$porta/load_objects.fcgi?session=${responseData["session"]}');

      Map<String, String> headers = {
        "Content-Type": "application/json"
      };

      Map<String, dynamic> body = {
        "object": "users"
      };

      try {
        final responsee = await http.post(
          url,
          headers: headers,
          body: jsonEncode(body),
        );

        if (responsee.statusCode == 200) {
          Map<String, dynamic> users = jsonDecode(responsee.body);

          users.addAll({"Season": responseData["session"]});
          FirebaseFirestore.instance.collection("logs").doc(UUID).set({
            "text" : 'Dados do acionamento foi recolhidos',
            "codigoDeResposta" : response.statusCode,
            'acionamentoID': '',
            'acionamentoNome': ip,
            'Condominio': idCondominio,
            "id": UUID,
            'QuemFez': await getUserName(),
            "idAcionou": UID,
            "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
          });

          return users;
        } else {
          print("Erro com a comunicação, status: ${response.statusCode} 1");
          showToast("Erro com a comunicação, status: ${responsee.statusCode}", context: context);
          return {};
        }
      } catch (e) {
        showToast("Erro ao executar a requisição: $e", context: context);
        return {};
      }

    } else {
      showToast("Erro com a comunicação, status: ${response.statusCode}", context: context);
      print("Erro com a comunicação, status: ${response.statusCode} 2");
      return {};
    }
  }catch(e){
    showToast("Erro ao executar a requisição: $e", context: context);
    print("Erro ao executar a requisição: $e");
    return {};
  }
}

tagCadastro(var context, String ip, int porta, String usuario, String Senha, String acionamentoID, String Nome, String tag) async {
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
  final ipog = Uri.parse('http://$ip:$porta/login.fcgi');

  Map<String, String> headerslog = {
    "Content-Type": "application/json"
  };

  Map<String, dynamic> bodylog = {
    "login": usuario,
    "password": Senha
  };
  try{
    final response = await http.post(
      ipog,
      headers: headerslog,
      body: jsonEncode(bodylog),
    );
    if(response.statusCode == 200){
      Map<String, dynamic> responseData = jsonDecode(response.body);

      final url = Uri.parse('http://$ip:$porta/create_objects.fcgi?session=${responseData["session"]}');

      Map<String, String> headers = {
        "Content-Type": "application/json"
      };

      Map<String, dynamic> body = {
        "join": "LEFT",
        "object": "users",
        "fields": ["id", "name", "registration", "password", "salt", "begin_time", "end_time", "user_type_id"],
        "where": [],
        "order": ["name"],
        "values": [
          {
            "id": int.parse(tag),
            "name": Nome,
            "registration": "",
            "password": "",
            "salt": "",
            "begin_time": 0,
            "end_time": 0,
            "user_type_id": null
          }
        ]
      };

      final responsee = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      if (responsee.statusCode == 200) {
        FirebaseFirestore.instance.collection('tags').doc("$tag$idCondominio").set({
          "id": "$tag$idCondominio",
          "tagID": tag,
          "idCondominio": idCondominio,
          "Nome": Nome,
          "acionamentoID": acionamentoID,
          "CPF": "",
          "RG": "",
          "imageURI": "",
          "placa": "",
          "Unidade":"",
          "Bloco": "",
          "Celular": "",
          "anotacao": "",
          "Telefone": '',
          "Qualificacao": '',
        });

        FirebaseFirestore.instance.collection("logs").doc(UUID).set({
          "text" : 'Dados do acionamento foi recolhidos',
          "codigoDeResposta" : response.statusCode,
          'acionamentoID': acionamentoID,
          'acionamentoNome': ip,
          'Condominio': idCondominio,
          "id": UUID,
          'QuemFez': await getUserName(),
          "idAcionou": UID,
          "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}",
        });

        showToast("Cadastrado no equipamento!", context: context);
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        showToast("Erro com a comunicação, status: ${responsee.statusCode}", context: context);
        Navigator.pop(context);
        Navigator.pop(context);
      }


    }else{
      showToast("Erro com a comunicação, status: ${response.statusCode}", context: context);
    }
  }catch(e){
    showToast("Erro ao executar a requisição: $e", context: context);
  }
}

tagEdicao(var context, String ip, int porta, String usuario, String Senha, String acionamentoID, String Nome, String tag, String docID, String originalTag) async {

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
  final ipog = Uri.parse('http://$ip:$porta/login.fcgi');

  Map<String, String> headerslog = {
    "Content-Type": "application/json"
  };

  Map<String, dynamic> bodylog = {
    "login": usuario,
    "password": Senha
  };
  try{
    final response = await http.post(
      ipog,
      headers: headerslog,
      body: jsonEncode(bodylog),
    );
    if(response.statusCode == 200){
      Map<String, dynamic> responseData = jsonDecode(response.body);

      final url = Uri.parse('http://$ip:$porta/modify_objects.fcgi?session=${responseData["session"]}');

      print(url);

      Map<String, String> headers = {
        "Content-Type": "application/json"
      };

      Map<String, dynamic> body = {
        "join": "LEFT",
        "object": "users",
        "fields": [
          "id",
          "name",
          "registration",
          "password",
          "salt",
          "begin_time",
          "end_time",
          "user_type_id"
        ],
        "where": [
          {
            "object": "users",
            "field": "id",
            "value": int.parse(originalTag)
          }
        ],
        "order": ["name"],
        "values": {
          "name": Nome,
          "id": int.parse(tag)
        }
      };

      final responsee = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      if (responsee.statusCode == 200) {
        FirebaseFirestore.instance.collection('tags').doc(docID).update({
          "tagID": tag,
          "idCondominio": idCondominio,
          "Nome": Nome,
          "acionamentoID": acionamentoID,
        });

        FirebaseFirestore.instance.collection("logs").doc(UUID).set({
          "text" : 'Dados do acionamento foi recolhidos',
          "codigoDeResposta" : response.statusCode,
          'acionamentoID': acionamentoID,
          'acionamentoNome': ip,
          'Condominio': idCondominio,
          "id": UUID,
          'QuemFez': await getUserName(),
          "idAcionou": UID,
          "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}",
        });

        showToast("Cadastrado no equipamento!", context: context);
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        showToast("Erro com a comunicação, status: ${responsee.statusCode}", context: context);
        Navigator.pop(context);
        Navigator.pop(context);
      }


    }else{
      showToast("Erro com a comunicação, status: ${response.statusCode}", context: context);
    }
  }catch(e){
    showToast("Erro ao executar a requisição: $e", context: context);
  }
}

deleteUsers(var context, String ip, int porta, String usuario, String Senha, String tag, String id) async {
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
  final ipog = Uri.parse('http://$ip:$porta/login.fcgi');

  Map<String, String> headerslog = {
    "Content-Type": "application/json"
  };

  Map<String, dynamic> bodylog = {
    "login": usuario,
    "password": Senha
  };
  try{
    final response = await http.post(
      ipog,
      headers: headerslog,
      body: jsonEncode(bodylog),
    );
    if(response.statusCode == 200){
      Map<String, dynamic> responseData = jsonDecode(response.body);

      final url = Uri.parse('http://$ip:$porta/destroy_objects.fcgi?session=${responseData["session"]}');

      Map<String, String> headers = {
        "Content-Type": "application/json"
      };

      Map<String, dynamic> body = {
        "object": "users",
        "where": {
          "users": {
            "id": [int.parse(tag)]
          }
        }
      };

      final responsee = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      if(responsee.statusCode == 200){
        FirebaseFirestore.instance.collection("tags").doc(id).delete().whenComplete((){
          showToast("Deletado com sucesso!", context: context);
          Navigator.pop(context);
          Navigator.pop(context);
        });

      }else{
        showToast("Erro com a comunicação, status: ${responsee.statusCode}", context: context);
      }
    }else{
      showToast("Erro com a comunicação, status: ${response.statusCode}", context: context);
    }
  }catch(e){
    showToast("Erro ao executar a requisição: $e", context: context);
  }
}