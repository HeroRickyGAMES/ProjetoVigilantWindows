import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:uuid/uuid.dart';
import 'package:vigilant/homeApp.dart';
import 'package:vigilant/intRamdom/intRamdom.dart';

//Desenvolvidor por HeroRickyGAMES com ajuda de Deus!

Consulta(var context) async {
  String host = "189.79.153.218";
  int porta = 9000;

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
  String command = 'guaritaConrole/demoLinearIP.exe --ip $host --porta $porta --checkusers';
  String pwd = 'pwd';

  ProcessResult result = await Process.run('powershell.exe', ['-c', command]);
  ProcessResult pwdresult = await Process.run('powershell.exe', ['-c', pwd]);
  String pwdString = pwdresult.stdout.toString().replaceAll("Test-Path guaritaConrole/", '').replaceAll("Path", "").replaceAll("----", '').trim();
  String comando = result.stdout.toString().replaceAll("System.ArgumentOutOfRangeException: InvalidArgument=Value ", '').replaceAll("não é um valor válido para 'SelectedIndex'.", "").replaceAll("Nome do parâmetro: SelectedIndex", '').replaceAll("   em System.Windows.Forms.ListBox.set_SelectedIndex(Int32 value)", '').replaceAll("em demoLinearIP.fprincipal..ctor(String ip, String porta, String checkUsers, String createuser, String tipo, String serial, String contador, String unidade, String bloco, String identificacao, String grupo, String", '').replaceAll("marca, String cor, String placa, String receptor1, String receptor2, String receptor3, String receptor4, String receptor5, String receptor6, String receptor7, String receptor8) na $pwdString", '').replaceAll("\\sdk-guarita-ip-master\\demos\\guaritaNiceSourceC#Controles\\demoLinearIP\\Form1.cs:linha 141", '').replaceAll("'", '"').trim();
  String tratado = "$comando}";
  print(tratado);
  try{

    Map<String, dynamic> Controles = jsonDecode(tratado.replaceAll("},}", "}}"));

    Controles.forEach((serial, fields) async {
      Uuid uuid = const Uuid();
      String UUID = uuid.v4();
      String id = "$UUID$serial$idCondominio";
      // Usa o serial como ID do documento
      fields['idCondominio'] = idCondominio;
      fields['id'] = id;
      fields['idGuarita'] = serial;
      fields['hostGuarita'] = host;
      fields['portGuarita'] = porta;
      FirebaseFirestore.instance.collection("Controles").doc(id).set(
          fields
      );
    });
    Navigator.pop(context);
    showToast("Importados com sucesso!",context:context);
  }catch(e){
    showToast(e.toString(),context:context);
    Navigator.pop(context);
  }
}

Cadastro(var context, String host, int port, String tipo, String serieal, String contador, int unidade, String bloco, String identificacao, int grupo, String Marca, String cor, String Placa, bool receptor1, bool receptor2, bool receptor3, bool receptor4, bool receptor5, bool receptor6, bool receptor7, bool receptor8) async {
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

  String command = 'guaritaConrole/demoLinearIP.exe --ip $host --porta $port --createuser --tipo $tipo --serial $serieal --contador $contador --unidade $unidade --bloco $bloco --identificacao $identificacao --grupo $grupo --marca $Marca --cor $cor --placa $Placa --receptor1 $receptor1 --receptor2 $receptor2 --receptor3 $receptor3 --receptor4 $receptor4 --receptor5 $receptor5 --receptor6 $receptor6 --receptor7 $receptor7 --receptor8 $receptor8';

  ProcessResult result = await Process.run('powershell.exe', ['-c', command]);
  print("ST ERRORS: ${result.stderr}");
  print("ST OUTS: ${result.stdout}");

  if(result.stdout.toString().contains("Controle já existe na memória!")){
    showToast("Controle já existe na memória!",context:context);
    Navigator.pop(context);
  }else{
    String id = "${gerarNumero()}";

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

    FirebaseFirestore.instance.doc(id).set({
      "Tipo": tipo,
      'Serial': serieal,
      "Controlador/ID": contador,
      "Unidade": unidade,
      'Bloco': bloco,
      "Grupo": grupo,
      "Rec Destino": receptoresAtivo,
      "Identificacao": identificacao,
      "Ultimo Acionamento": "0",
      'Status de bateria': "- - - -",
      "Veiculo/Marca": Marca
    });

    showToast("pronto!",context:context);
    Navigator.pop(context);
    Navigator.pop(context);
  }
}

edicao(var context, String idGuarita, String id, String host, int port, String tipo, String serieal, String contador, int unidade, String bloco, String identificacao, int grupo, String Marca, String cor, String Placa, bool receptor1, bool receptor2, bool receptor3, bool receptor4, bool receptor5, bool receptor6, bool receptor7, bool receptor8){
  //Primeiro ele vai deletar o usuario x
  Deletecao(context, idGuarita, id, host, port);
  //Depois ele vai cadastrar com os dados mandados do proprio vigilant
  Cadastro(context, host, port, tipo, serieal, contador, unidade, bloco, identificacao, grupo, Marca, cor, Placa, receptor1, receptor2, receptor3, receptor4, receptor5, receptor6, receptor7, receptor8);
  //Por ultimo ele consulta usuarios do guarita
}

Deletecao(var context, String idGuarita, String id, String host, int port) async {
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

  FirebaseFirestore.instance.collection("Controles").doc(id).delete();

  String command = 'guaritaConrole/demoLinearIP.exe $host --porta $port --deleteuser --idguarita $idGuarita';

  await Process.run('powershell.exe', ['-c', command]);

  Navigator.pop(context);
  showToast("Deletado com sucesso!",context:context);
}