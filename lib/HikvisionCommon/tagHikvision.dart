import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;
import 'package:vigilant/HikvisionCommon/HikvisionCommon.dart';
import 'package:vigilant/acionamento_de_portas/acionamento_de_portas.dart';

int CardNumber = 0;
Map loglist = {};

Future<void> fetchAllPages(ip, porta, usuario, senha , userID, context) async {
  String baseUrl = 'http://$ip:$porta/ISAPI/AccessControl/AcsEvent';
  String username = usuario;
  String password = senha;
  String deviceUuid = "0";
  int pageSize = 24;

  int currentPage = 0;
  bool hasMoreData = true;

  String _generateDigestAuthHeader(String method, String uri, String realm, String nonce) {
    final ha1 = md5.convert(utf8.encode('$username:$realm:$password')).toString();
    final ha2 = md5.convert(utf8.encode('$method:$uri')).toString();
    final response = md5.convert(utf8.encode('$ha1:$nonce:$ha2')).toString();

    return 'Digest username="$username", realm="$realm", nonce="$nonce", uri="$uri", response="$response", algorithm=MD5';
  }

  while (hasMoreData) {
    final body = {
      "AcsEventCond": {
        "searchID": "1",
        "searchResultPosition": currentPage * pageSize,
        "maxResults": pageSize,
        "major": 0,
        "minor": 0,
        "startTime": "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}T01:00:00-07:00",
        "endTime": "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}T23:59:59-03:00"
      }
    };

    try {
      final uri = Uri.parse('$baseUrl?format=json&devIndex=$deviceUuid');
      final initialResponse = await http.post(uri);

      if (initialResponse.statusCode == 401) {
        final authHeader = initialResponse.headers['www-authenticate'];
        if (authHeader != null && authHeader.contains('Digest')) {
          final realm = RegExp(r'realm="([^"]+)"').firstMatch(authHeader)?.group(1) ?? '';
          final nonce = RegExp(r'nonce="([^"]+)"').firstMatch(authHeader)?.group(1) ?? '';
          final auth = _generateDigestAuthHeader('POST', uri.path, realm, nonce);

          final response = await http.post(
            uri,
            headers: {
              'Authorization': auth,
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          );

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            if (data['AcsEvent'] != null && data['AcsEvent'].isNotEmpty) {
              //print('Page $currentPage: ${data['AcsEvent']}');
              currentPage++;
              loglist = data['AcsEvent'];

            } else {
              hasMoreData = false;
            }
          } else {
            print('Error: Status code ${response.statusCode}');
            print('Response: ${response.body}');

            //CardNumber = ;
            hasMoreData = false;
          }
        } else {
          print('Error: No Digest header found');
          hasMoreData = false;
        }
      } else {
        print('Unexpected status code: ${initialResponse.statusCode}');
        hasMoreData = false;
      }
    } catch (e) {
      print('Request failed: $e');
      hasMoreData = false;
    }
  }
  print("pronto?");
  print(loglist['InfoList'][1]);

  for (int i = 1; i < loglist['InfoList'].length; i++){
    if(loglist['InfoList'][i]['cardNo'] != null){
      CardNumber = int.parse(loglist['InfoList'][i]['cardNo']);
    }
  }
  print("For finalizado!");


  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const AlertDialog(
        title: Text('Aguarde...'),
        actions: [
          Center(
            child: CircularProgressIndicator(),
          )
        ],
      );
    },
  );
  await Future.delayed(const Duration(seconds: 3));
  showToast("Cartão encontrado! Cadastrando...",duration: const Duration(seconds: 7), context: context);

  // URL do endpoint
  String url = 'http://$ip:$porta/ISAPI/AccessControl/CardInfo/Record?format=json&devIndex=0';

  // Realiza a primeira requisição para obter os dados do Digest Auth
  var response = await http.post(Uri.parse(url));
  var responseeByNumber = await http.post(Uri.parse(url));

  if (response.statusCode == 401 && response.headers['www-authenticate'] != null) {
    final authHeader = response.headers['www-authenticate'];

    // Extrai os valores do header de autenticação
    final authData = parseDigestHeader(authHeader!);
    print(username);
    print(password);
    final digestAuth = generateDigestAuth(authData, username, password, 'POST', url);

    // Cabeçalhos com autenticação Digest
    final headers = {
      'Authorization': digestAuth,
      'Content-Type': 'application/json',
    };

    DateTime(DateTime.now().year, DateTime.now().month , DateTime.now().day, DateTime.now().hour, DateTime.now().minute, DateTime.now().second);
    Map<String, dynamic> bodynum = {
      "CardInfo": {
        "employeeNo": "$userID",
        "cardNo": "$CardNumber",
        "cardType": "normalCard"
      }
    };

    responseeByNumber = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(bodynum)
    );
    if(responseeByNumber.statusCode == 200){
      FirebaseFirestore.instance.collection("TAG").doc(UUID).set({
        "identificacao": CardNumber,
        "modelo": "Hikvision",
        "veiculos": false,
        "tagNumber": CardNumber,
        "UserID": CardNumber,
        "id": UUID,
        "ipAcionamento": ip,
        "portAcionamento": porta,
        "userAcionamento": usuario,
        "passAcionamento": senha,
      }).whenComplete((){
        showToast("Cadastrado!", context: context);
        Navigator.pop(context);
      });
    }else{
      print(responseeByNumber.body);
      showToast("Erro ${response.statusCode}! Essa tag possivelmente já foi cadastrada! Ou algum outro erro relacionado a permissão!", context: context);
      Navigator.pop(context);
    }
  } else {
    showToast("Falha ao obter o header WWW-Authenticate", context: context);
    print('Falha ao obter o header WWW-Authenticate');
    //Navigator.pop(context);
    throw Exception('Falha ao obter o header WWW-Authenticate');
  }
}

Future<void> tagHikvision(
    var context, String ip, int porta, String usuario, String senha, int userID) async {
  await fetchAllPages(ip, porta, usuario, senha , userID, context);

}
