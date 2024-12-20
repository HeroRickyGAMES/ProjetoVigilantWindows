import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:vigilant/Tradutor.dart';
import 'package:vigilant/acionamento_de_portas/acionamento_de_portas.dart';
import 'package:vigilant/homeApp.dart';
import 'package:vigilant/informacoesLogais/getIds.dart';
import 'package:vigilant/informacoesLogais/getUserInformations.dart';

//Programado por HeroRickyGAMES com a ajuda de Deus!

// Função para gerar o header de autenticação Digest Auth
String _generateDigestAuth(Map<String, String> authData, String username, String password, String method, String uri) {
  final ha1 = md5.convert(utf8.encode('$username:${authData["realm"]}:$password')).toString();
  final ha2 = md5.convert(utf8.encode('$method:$uri')).toString();
  final response = md5.convert(utf8.encode('$ha1:${authData["nonce"]}:$ha2')).toString();

  return 'Digest username="$username", realm="${authData["realm"]}", nonce="${authData["nonce"]}", uri="$uri", response="$response"';
}

// Função para extrair dados do header WWW-Authenticate
Map<String, String> _parseDigestHeader(String header) {
  final Map<String, String> authData = {};
  final regExp = RegExp(r'(\w+)=["]?([^",]+)["]?');
  regExp.allMatches(header).forEach((match) {
    authData[match.group(1)!] = match.group(2)!;
  });
  return authData;
}

pegarImagem(var context, String ip, int porta, String usuario, String Senha, String userID, String ImageURL) async {

  // URL do endpoint
  String url = 'http://$ip:$porta/ISAPI/Intelligent/FDLib/FaceDataRecord?format=json&devIndex=0';

  // Credenciais
  String username = usuario;
  String password = Senha;

  // Realiza a primeira requisição para obter os dados do Digest Auth
  var response = await http.post(Uri.parse(url));
  if (response.statusCode == 401 && response.headers['www-authenticate'] != null) {
    final authHeader = response.headers['www-authenticate'];

    // Extrai os valores do header de autenticação
    final authData = _parseDigestHeader(authHeader!);
    final digestAuth = _generateDigestAuth(authData, username, password, 'POST', url);

    // Cabeçalhos com autenticação Digest
    final headers = {
      'Authorization': digestAuth,
      'Content-Type': 'application/json',
    };


    print(ImageURL);
    // Corpo da requisição
    final Map<String, dynamic> requestBody = {
      "faceURL": ImageURL,
      "faceLibType": "blackFD",
      "FDID": userID,
      "FPID": userID
    };

    // Requisição POST com a autenticação Digest
    response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(requestBody),
    );

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
      showToast("Pronto!",context:context);

    } else {
      Map resposta = jsonDecode(response.body);
      String traduzido =
      await TradutorClass(
          resposta['subStatusCode'].replaceAllMapped(
           RegExp(r'(?<=[a-z])(?=[A-Z])'),
                (match) => ' ',
           )
      );
      showToast(traduzido,context:context);
      return null;
    }
  } else {
    throw Exception('Falha ao obter o header WWW-Authenticate');
  }
}

deletarImagem(var context, String ip, int porta, String usuario, String Senha, String userID, String veiode) async {
  // URL do endpoint
  String url = 'http://$ip:$porta/ISAPI/Intelligent/FDLib/FDSetUp?format=json';

  // Credenciais
  String username = usuario;
  String password = Senha;

  // Realiza a primeira requisição para obter os dados do Digest Auth
  var response = await http.post(Uri.parse(url));
  if (response.statusCode == 401 && response.headers['www-authenticate'] != null) {
    final authHeader = response.headers['www-authenticate'];

    // Extrai os valores do header de autenticação
    final authData = _parseDigestHeader(authHeader!);
    final digestAuth = _generateDigestAuth(authData, username, password, 'PUT', url);

    // Cabeçalhos com autenticação Digest
    final headers = {
      'Authorization': digestAuth,
      'Content-Type': 'application/json',
    };

    // Corpo da requisição
    final Map<String, dynamic> requestBody = {
      "faceLibType":"blackFD",
      "FDID":"1",
      "FPID":"1",
      "deleteFP":true
    };

    // Requisição POST com a autenticação Digest
    response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(requestBody),
    );

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

      if(veiode == "deletarImagem"){
        showToast("Facial Deletada!",context:context);
        Navigator.pop(context);
        Navigator.pop(context);
      }

    } else {
      Map resposta = jsonDecode(response.body);
      String traduzido =
          await TradutorClass(
          resposta['subStatusCode'].replaceAllMapped(
            RegExp(r'(?<=[a-z])(?=[A-Z])'),
                (match) => ' ',
          )
      );
      showToast(traduzido,context:context);
      return null;
    }
  } else {
    throw Exception('Falha ao obter o header WWW-Authenticate');
  }
}