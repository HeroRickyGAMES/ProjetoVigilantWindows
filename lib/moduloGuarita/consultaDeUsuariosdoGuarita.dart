import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:uuid/uuid.dart';
import 'package:vigilant/acionamento_de_portas/acionamento_de_portas.dart';
import 'package:vigilant/homeApp.dart';
import 'package:vigilant/informacoesLogais/getIds.dart';
import 'package:vigilant/informacoesLogais/getUserInformations.dart';
import 'package:vigilant/infosdoPc/getCores.dart';
import 'package:vigilant/intRamdom/intRamdom.dart';
import 'package:vigilant/moduloGuarita/hostToIP.dart';
import 'dart:math';

//Desenvolvidor por HeroRickyGAMES com ajuda de Deus!

String generateHex(int length) {
  final random = Random();
  const hexChars = '0123456789ABCDEF';

  return List.generate(length, (index) => hexChars[random.nextInt(16)]).join();
}

Consulta(var context, String host, int port, String veiode) async {
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

  if(veiode == "Scan"){
    CollectionReference collectionRef = FirebaseFirestore.instance.collection("Controles");
    QuerySnapshot querySnapshot = await collectionRef.where("idCondominio", isEqualTo: idCondominio).get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.delete();
    }

    FirebaseFirestore.instance.collection("logs").doc(UUID).set({
      "text" : 'Houve Consulta do Guarita',
      "codigoDeResposta" : 010,
      'acionamentoID': host,
      'acionamentoNome': host,
      'Condominio': idCondominio,
      "id": UUID,
      'QuemFez': await getUserName(),
      "idAcionou": UID,
      "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
    });
  }

  var ip = await hostToIp(host);
  String hostd = ip;

  String command = 'guaritaConrole/demoLinearIP.exe --ip $hostd --porta $port --checkusers';
  String pwd = 'pwd';

  ProcessResult result = await Process.run('powershell.exe', ['-c', command]);
  ProcessResult pwdresult = await Process.run('powershell.exe', ['-c', pwd]);
  String pwdString = pwdresult.stdout.toString().replaceAll("Test-Path guaritaConrole/", '').replaceAll("Path", "").replaceAll("----", '').trim();
  String comando = result.stdout.toString().replaceAll("System.ArgumentOutOfRangeException: InvalidArgument=Value ", '').replaceAll("não é um valor válido para 'SelectedIndex'.", "").replaceAll("Nome do parâmetro: SelectedIndex", '').replaceAll("   em System.Windows.Forms.ListBox.set_SelectedIndex(Int32 value)", '').replaceAll("em demoLinearIP.fprincipal..ctor(String ip, String porta, String checkUsers, String createuser, String tipo, String serial, String contador, String unidade, String bloco, String identificacao, String grupo, String", '').replaceAll("marca, String cor, String placa, String receptor1, String receptor2, String receptor3, String receptor4, String receptor5, String receptor6, String receptor7, String receptor8) na $pwdString", '').replaceAll("\\sdk-guarita-ip-master\\demos\\guaritaNiceSourceC#Controles\\demoLinearIP\\Form1.cs:linha 141", '').replaceAll("'", '"').trim();
  String tratado = "$comando}";
  print(command);
  print(pwdString);
  print(tratado);
  if(result.stdout.toString().contains("FALHA CONEXAO TCP")){
    showToast("FALHA CONEXAO TCP!",context:context);
    Navigator.pop(context);
    Navigator.pop(context);
  }else{
    Map<String, dynamic> Controles = jsonDecode(tratado.replaceAll("},}", "}}"));

    Controles.forEach((serial, fields) async {
      if (fields.containsKey('Controlador/ID')) {
        fields['Controlador_ID'] = fields['Controlador/ID'];
        fields.remove('Controlador/ID');
      }

      if (fields.containsKey('Veiculo/Marca')) {
        fields['Veiculo_Marca'] = fields['Veiculo/Marca'];
        fields.remove('Veiculo/Marca');
      }

      fields.forEach((key, value) {
        // Verifica se o valor é uma String e converte "True"/"False" para bool
        if (value is String) {
          if (value.toLowerCase() == "true") {
            fields[key] = true;
          } else if (value.toLowerCase() == "false") {
            fields[key] = false;
          }
        }
      });

      Uuid uuid = const Uuid();
      String UUID = uuid.v4();
      String id = "$UUID$serial$idCondominio";
      // Usa o serial como ID do documento
      fields['idCondominio'] = idCondominio;
      fields['id'] = id;
      fields['idGuarita'] = "${int.parse(serial)-1}";
      fields['hostGuarita'] = host;
      fields['portGuarita'] = port;
      if(veiode == "Scan"){
        FirebaseFirestore.instance.collection("Controles").doc(id).set(
            fields
        );
        showToast("Importado com sucesso!",context:context);
      }
    });
    Navigator.pop(context);
    Navigator.pop(context);
  }
}

Cadastro(var context, String host, int port, String tipo, String serieal, String contador, String unidade, String bloco, String identificacao, String grupo, String Marca, String cor, String Placa, bool receptor1, bool receptor2, bool receptor3, bool receptor4, bool receptor5, bool receptor6, bool receptor7, bool receptor8, String placa, String ide, String idGuarita) async {
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

  if (tipo == "Controle") {
    tipo = 'TX';
  }

  if (tipo == "TAG") {
    tipo = 'TAG';
  }
  if (tipo == "Cartão") {
    tipo = 'CARD';
  }
  if (tipo == "BIO") {
    tipo = 'BIO';
  }
  if (tipo == "TAGP") {
    tipo = 'TAGP';
  }
  if (tipo == "Senha CTW") {
    tipo = 'Senha CTW';
  }

  String countGuarita = "";

  var ip = await hostToIp(host);
  String hostd = ip;

  if(unidade == ""){
    unidade = "null";
  }

  if(bloco == ""){
    bloco = "null";
  }

  String serial = generateHex(4);
  String contadors = generateHex(4);

  String command = "";

  if(idGuarita == ""){
    FirebaseFirestore.instance.collection("logs").doc(UUID).set({
      "text" : 'Houve uma tentativa de cadastro no Guarita',
      "codigoDeResposta" : 011,
      'acionamentoID': host,
      'acionamentoNome': host,
      'Condominio': idCondominio,
      "id": UUID,
      'QuemFez': await getUserName(),
      "idAcionou": UID,
      "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
    });

    command = 'guaritaConrole/demoLinearIP.exe --ip $hostd --porta $port --createuser --tipo $tipo --serial $serial --contador $contadors --unidade $unidade --bloco $bloco --identificacao ${identificacao.replaceAll(" ", "_")} --grupo $grupo --marca ${Marca.replaceAll(" ", "_")} --cor $cor --placa ${Placa.replaceAll(" ", "_")} --receptor1 $receptor1 --receptor2 $receptor2 --receptor3 $receptor3 --receptor4 $receptor4 --receptor5 $receptor5 --receptor6 $receptor6 --receptor7 $receptor7 --receptor8 $receptor8';
  }else{
    command = 'guaritaConrole/demoLinearIP.exe --ip $hostd --porta $port --createuser --tipo $tipo --serial $serieal --contador $contador --unidade $unidade --bloco $bloco --identificacao ${identificacao.replaceAll(" ", "_")} --grupo $grupo --marca ${Marca.replaceAll(" ", "_")} --cor $cor --placa ${Placa.replaceAll(" ", "_")} --receptor1 $receptor1 --receptor2 $receptor2 --receptor3 $receptor3 --receptor4 $receptor4 --receptor5 $receptor5 --receptor6 $receptor6 --receptor7 $receptor7 --receptor8 $receptor8';
  }

  print(command);

  ProcessResult result = await Process.run('powershell.exe', ['-c', command]);
  print("ST ERRORS: ${result.stderr}");
  print("ST OUTS: ${result.stdout}");

  if(result.stdout.toString().contains("Controle já existe na memória!")){
    showToast("Controle já existe na memória!",context:context);
    Navigator.pop(context);
    Navigator.pop(context);
  }else{
    if(idGuarita == ""){
      var ip = await hostToIp(host);
      String hostd = ip;

      String command = 'guaritaConrole/demoLinearIP.exe --ip $hostd --porta $port --checkusers';
      String pwd = 'pwd';

      ProcessResult result = await Process.run('powershell.exe', ['-c', command]);
      ProcessResult pwdresult = await Process.run('powershell.exe', ['-c', pwd]);
      String pwdString = pwdresult.stdout.toString().replaceAll("Test-Path guaritaConrole/", '').replaceAll("Path", "").replaceAll("----", '').trim();
      String comando = result.stdout.toString().replaceAll("System.ArgumentOutOfRangeException: InvalidArgument=Value ", '').replaceAll("não é um valor válido para 'SelectedIndex'.", "").replaceAll("Nome do parâmetro: SelectedIndex", '').replaceAll("   em System.Windows.Forms.ListBox.set_SelectedIndex(Int32 value)", '').replaceAll("em demoLinearIP.fprincipal..ctor(String ip, String porta, String checkUsers, String createuser, String tipo, String serial, String contador, String unidade, String bloco, String identificacao, String grupo, String", '').replaceAll("marca, String cor, String placa, String receptor1, String receptor2, String receptor3, String receptor4, String receptor5, String receptor6, String receptor7, String receptor8) na $pwdString", '').replaceAll("\\sdk-guarita-ip-master\\demos\\guaritaNiceSourceC#Controles\\demoLinearIP\\Form1.cs:linha 141", '').replaceAll("'", '"').trim();
      String tratado = "$comando}";
      print(command);
      print(pwdString);
      print(tratado);
      try{
        Map<String, dynamic> Controles = jsonDecode(tratado.replaceAll("},}", "}}"));

        Controles.forEach((serial, fields) async {
          if (fields.containsKey('Controlador/ID')) {
            fields['Controlador_ID'] = fields['Controlador/ID'];
            fields.remove('Controlador/ID');
          }

          if (fields.containsKey('Veiculo/Marca')) {
            fields['Veiculo_Marca'] = fields['Veiculo/Marca'];
            fields.remove('Veiculo/Marca');
          }

          fields.forEach((key, value) {
            // Verifica se o valor é uma String e converte "True"/"False" para bool
            if (value is String) {
              if (value.toLowerCase() == "true") {
                fields[key] = true;
              } else if (value.toLowerCase() == "false") {
                fields[key] = false;
              }
            }
          });

          Uuid uuid = const Uuid();
          String UUID = uuid.v4();
          String id = "$UUID$serial$idCondominio";
          // Usa o serial como ID do documento
          fields['idCondominio'] = idCondominio;
          fields['id'] = id;
          fields['idGuarita'] = "${int.parse(serial) - 1}";
          fields['hostGuarita'] = host;
          fields['portGuarita'] = port;

          Controles.forEach((chave, valor) {
          if (valor["Identificacao"] == identificacao) {
            countGuarita = "${int.parse(chave) - 1}";
           }
          });
        });
        Navigator.pop(context);
        Navigator.pop(context);
      }catch(e){
        showToast(e.toString(),context:context);
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }


    String id = "";

    if(ide == ""){
      id = "${gerarNumero()}$idCondominio";
    }else{
      id = ide;
    }

    List<String> receptoresAtivos = [];

    // Verificar cada receptor e adicionar o número correspondente à lista
    if (receptor1) receptoresAtivos.add('1');
    if (receptor2) receptoresAtivos.add('2');
    if (receptor3) receptoresAtivos.add('3');
    if (receptor4) receptoresAtivos.add('4');
    if (receptor5) receptoresAtivos.add('5');
    if (receptor6) receptoresAtivos.add('6');
    if (receptor7) receptoresAtivos.add('7');
    if (receptor8) receptoresAtivos.add('8');

    // Juntar os números dos receptores em uma única String
    String receptoresAtivo = receptoresAtivos.join(' ');

    if(idGuarita == ""){
      FirebaseFirestore.instance.collection("Controles").doc(id).set({
        "Tipo": tipo,
        'Serial': serial,
        'idGuarita': countGuarita,
        "Controlador_ID": contadors,
        "Unidade": unidade,
        'Bloco': bloco,
        "Grupo": grupo,
        "Rec Destino": receptoresAtivo,
        "Identificacao": identificacao,
        "Ultimo Acionamento": "0",
        'Status de bateria': "- - - -",
        "Veiculo_Marca": Marca,
        "hostGuarita": host,
        "portGuarita": port,
        "id": id,
        "idCondominio": idCondominio,
        "Cor": cor,
        "Placa": placa,
        "receptor1": receptor1,
        "receptor2": receptor2,
        "receptor3": receptor3,
        "receptor4": receptor4,
        "receptor5": receptor5,
        "receptor6": receptor6,
        "receptor7": receptor7,
        "receptor8": receptor8,
      });
    }else{
      FirebaseFirestore.instance.collection("Controles").doc(id).set({
        "Tipo": tipo,
        'Serial': serieal,
        'idGuarita': idGuarita,
        "Controlador_ID": contador,
        "Unidade": unidade,
        'Bloco': bloco,
        "Grupo": grupo,
        "Rec Destino": receptoresAtivo,
        "Identificacao": identificacao,
        "Ultimo Acionamento": "0",
        'Status de bateria': "- - - -",
        "Veiculo_Marca": Marca,
        "hostGuarita": host,
        "portGuarita": port,
        "id": id,
        "idCondominio": idCondominio,
        "Cor": cor,
        "Placa": placa,
        "receptor1": receptor1,
        "receptor2": receptor2,
        "receptor3": receptor3,
        "receptor4": receptor4,
        "receptor5": receptor5,
        "receptor6": receptor6,
        "receptor7": receptor7,
        "receptor8": receptor8,
      }).whenComplete((){
        Navigator.pop(context);
      });
    }

    if(result.stdout.toString().contains("Dispositivo Cadastrado com sucesso!")){
      showToast("Pronto!",context:context);
      if(idGuarita != ""){
        Navigator.pop(context);
        Navigator.pop(context);
      }else{
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }else{
      showToast("Ocorreu algum erro!",context:context);
    }
  }
}

edicao(var context, String idGuarita, String id, String host, int port, String tipo, String serieal, String contador, String unidade, String bloco, String identificacao, String grupo, String Marca, String cor, String Placa, bool receptor1, bool receptor2, bool receptor3, bool receptor4, bool receptor5, bool receptor6, bool receptor7, bool receptor8, placa) async {

  FirebaseFirestore.instance.collection("logs").doc(UUID).set({
    "text" : 'Houve uma tentativa de edição no Guarita',
    "codigoDeResposta" : 012,
    'acionamentoID': host,
    'acionamentoNome': host,
    'Condominio': idCondominio,
    "id": UUID,
    'QuemFez': await getUserName(),
    "idAcionou": UID,
    "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
  });

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

  int numCores = await GetCores();

  var ip = await hostToIp(host);
  String hostd = ip;

  //Primeiro ele vai deletar o usuario x
  Deletecao(context, idGuarita, id, hostd, port, "Edicao", numCores);

  if (numCores >= 1 && numCores <= 3) {
    await Future.delayed(const Duration(minutes: 1));
  }

  if (numCores >= 4 && numCores <= 5) {
    await Future.delayed(const Duration(seconds: 50));
  }

  if (numCores >= 6 && numCores <= 7) {
    await Future.delayed(const Duration(seconds: 50));
  }

  if (numCores >= 8 && numCores <= 9) {
    await Future.delayed(const Duration(seconds: 50));
  }

  if (numCores >= 10 && numCores <= 12) {
    //await Future.delayed(const Duration(seconds: 100));
    await Future.delayed(const Duration(seconds: 50));
  }

  if(numCores > 13){
    await Future.delayed(const Duration(seconds: 50));
  }

  //Depois ele vai cadastrar com os dados mandados do proprio vigilant
  print(idGuarita);
  Cadastro(context, hostd, port, tipo, serieal, contador, unidade, bloco, identificacao, grupo, Marca, cor, Placa, receptor1, receptor2, receptor3, receptor4, receptor5, receptor6, receptor7, receptor8, placa, id, idGuarita);
  //Por ultimo ele consulta usuarios do guarita
}

Deletecao(var context, String idGuarita, String id, String host, int port, String veiode, int numberOfCores) async {
  if(veiode == "Deletacao"){
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
  }

  var ip = await hostToIp(host);
  String hostd = ip;

  FirebaseFirestore.instance.collection("Controles").doc(id).delete();

  String command = 'guaritaConrole/demoLinearIP.exe --ip $hostd --porta $port --deleteuser --idguarita $idGuarita --cores $numberOfCores';

  print(command);

  var processoDelete = await Process.run('powershell.exe', ['-c', command]);

  if(veiode == "Deletacao"){
    FirebaseFirestore.instance.collection("logs").doc(UUID).set({
      "text" : 'Houve uma tentativa de deletação de um usuario no Guarita',
      "codigoDeResposta" : 013,
      'acionamentoID': host,
      'acionamentoNome': host,
      'Condominio': idCondominio,
      "id": UUID,
      'QuemFez': await getUserName(),
      "idAcionou": UID,
      "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
    });

    if(processoDelete.stdout.toString().contains("Deletado com sucesso!")){
      Navigator.pop(context);
      Navigator.pop(context);
      showToast("Deletado com sucesso!",context:context);
    }else{
      Navigator.pop(context);
      Navigator.pop(context);
      showToast("Ocorreu algum erro durante a deleteção no aparelho!",context:context);
    }
  }
  if(veiode == 'Edicao'){
    if(!processoDelete.stdout.toString().contains("Deletado com sucesso!")){
      showToast("Ocorreu um erro ao editar, a informação foi pro banco de dados mas não para o guarita!",context:context);
      Navigator.pop(context);
    }
  }
}