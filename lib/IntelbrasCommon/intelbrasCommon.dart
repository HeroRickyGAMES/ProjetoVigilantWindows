import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:vigilant/acionamento_de_portas/acionamento_de_portas.dart';
import 'package:vigilant/homeApp.dart';
import 'package:vigilant/informacoesLogais/getIds.dart';
import 'package:vigilant/informacoesLogais/getUserInformations.dart';
import 'package:vigilant/infosdoPc/checkUser.dart';

//Programado por HeroRickyGames

List<Map<String, dynamic>> intelbrasFacial(String response) {
  Map<String, dynamic> result = {};
  List<String> lines = response.split('\n'); // Quebrar a string em linhas

  for (String line in lines) {
    if (line.trim().isEmpty) continue; // Ignorar linhas vazias
    List<String> parts = line.split('[0]='); // Separar chave e valor
    String key = parts[0].trim(); // Chave
    String value = parts.length > 1 ? parts[1].trim() : ''; // Valor (ou vazio)

    // Tentar converter o valor para tipos apropriados
    if (value == 'true') {
      result[key] = true;
    } else if (value == 'false') {
      result[key] = false;
    } else if (int.tryParse(value) != null) {
      result[key] = int.parse(value);
    } else if (double.tryParse(value) != null) {
      result[key] = double.parse(value);
    } else {
      result[key] = value; // Manter como string
    }
  }

  List<Map<String, dynamic>> restructureRecords(Map<String, dynamic> map) {
    Map<int, Map<String, dynamic>> groupedRecords = {};

    map.forEach((key, value) {
      if (key.startsWith('FaceDataList[')) {
        // Extrai o índice e o campo
        final match = RegExp(r'FaceDataList\[(\d+)\]\.(.+)').firstMatch(key);
        if (match != null) {
          int index = int.parse(match.group(1)!);
          String field = match.group(2)!;

          // Adiciona ao Map agrupado
          groupedRecords.putIfAbsent(index, () => {});
          groupedRecords[index]![field] = value;
        }
      }
    });

    // Converte para uma lista
    return groupedRecords.values.toList();
  }

  // Chama a função
  List<Map<String, dynamic>> recordsList = restructureRecords(result);

  return recordsList;
}

usarFacial(var context, String ip, int porta,String usuario, String senha, int userID) async {
  final url = Uri.parse('http://$ip:$porta/cgi-bin/accessControl.cgi?action=captureCmd&type=1&UserID=$userID&heartbeat=5&timeout=10');

  Map<String, String> headers = {
    'Accept': '*/*',
    'Accept-Encoding': 'gzip, deflate, br',
    'Connection': 'keep-alive',
    "Content-Type": "application/json"
  };

  final client = http_auth.DigestAuthClient(usuario, senha);

  try {
    final response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      FirebaseFirestore.instance.collection("logs").doc(UUID).set({
        "text" : 'Facial obtida!',
        "codigoDeResposta" : response.statusCode,
        'acionamentoID': '',
        'acionamentoNome': ip,
        'Condominio': idCondominio,
        "id": UUID,
        'QuemFez': await getUserName(),
        "idAcionou": UID,
        "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
      });
      showToast("Comando enviado ao aparelho!",context:context);
      Navigator.pop(context);

    } else {
      showToast("Erro com a comunicação, status: ${response.statusCode}",context:context);
    }
  } catch (e) {
    showToast("Erro ao executar a requisição: $e",context:context);
  }
}

deletarFacial(var context, String ip, int porta,String usuario, String senha, int userID) async {
  print(userID);
  final url = Uri.parse('http://$ip:$porta/cgi-bin/FaceInfoManager.cgi?action=remove&UserID=$userID');
  print(url);

  Map<String, String> headers = {
    'Accept': '*/*',
    'Accept-Encoding': 'gzip, deflate, br',
    'Connection': 'keep-alive',
    "Content-Type": "application/json"
  };

  final client = http_auth.DigestAuthClient(usuario, senha);

  try {
    final response = await client.get(
        url, headers: headers);

    if (response.statusCode == 200) {
      FirebaseFirestore.instance.collection("logs").doc(UUID).set({
        "text" : 'Facial deletada!',
        "codigoDeResposta" : response.statusCode,
        'acionamentoID': '',
        'acionamentoNome': ip,
        'Condominio': idCondominio,
        "id": UUID,
        'QuemFez': await getUserName(),
        "idAcionou": UID,
        "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
      });
      Navigator.pop(context);
      print(response.body);

    } else {
      Navigator.pop(context);
      showToast("Erro com a comunicação, status: ${response.statusCode}",context:context);
    }
  } catch (e) {
    Navigator.pop(context);
    showToast("Erro ao executar a requisição: $e",context:context);
  }
}

Future<File> FacialFotoIntelbras(var context, String ip, int porta,String usuario, String senha, int userID) async {
  final url = Uri.parse('http://$ip:$porta/cgi-bin/AccessFace.cgi?action=list&UserIDList[0]=$userID');
  print(url);

  Map<String, String> headers = {
    'Accept': '*/*',
    'Accept-Encoding': 'gzip, deflate, br',
    'Connection': 'keep-alive',
    "Content-Type": "application/json"
  };

  final client = http_auth.DigestAuthClient(usuario, senha);

  try {
    final response = await client.get(
        url, headers: headers
    );

    if (response.statusCode == 200) {
      String RespostaDoCorpo = response.body.replaceAll("FaceDataList[0].UserID=$userID", "");

      String resposta = intelbrasFacial(RespostaDoCorpo)[0]['PhotoData'];
      print('rsp : ${intelbrasFacial(RespostaDoCorpo)}');
      Uint8List imageBytes = base64Decode(resposta);
      File file = File('C:\\Users\\${await getUsername()}\\AppData\\Local\\Temp\\$userID.jpg');

      // Escreve os bytes da resposta (imagem) no arquivo
      await file.writeAsBytes(imageBytes);

      return file;
    } else {
      File file = File('C:\\Users\\${await getUsername()}\\AppData\\Local\\Temp\\jailsonTester.jpg');
      return file;
    }
  } catch (e) {
    File file = File('C:\\Users\\${await getUsername()}\\AppData\\Local\\Temp\\jailsonTester.jpg');
    print(e);
    return file;
  }
}

String removeMetadata(String base64String) {
  if (base64String.contains(',')) {
    return base64String.split(',').last;
  }
  return base64String;
}