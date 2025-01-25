import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:vigilant/acionamento_de_portas/acionamento_de_portas.dart';
import 'package:vigilant/homeApp.dart';
import 'package:vigilant/informacoesLogais/getIds.dart';
import 'package:vigilant/informacoesLogais/getUserInformations.dart';

//Programado por HeroRickyGames com ajuda de Deus!

Future<Map<String, dynamic>> cadastronoEquipamento(var context, String ip, int porta, String usuario, String Senha, String modelo, String Nome, int id) async {
  if(modelo == "Control iD"){
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
          "object": "users",
          "values": [
            {
              "name": Nome,
              "registration": "",
              "password": "",
              "salt": ""
            }
          ]
        };

        final responsee = await http.post(
          url,
          headers: headers,
          body: jsonEncode(body),
        );
        if (responsee.statusCode == 200) {
          FirebaseFirestore.instance.collection("logs").doc(UUID).set({
            "text" : 'Dados do acionamento foi recolhidos',
            "codigoDeResposta" : response.statusCode,
            'acionamentoID': id,
            'acionamentoNome': ip,
            'Condominio': idCondominio,
            "id": UUID,
            'QuemFez': await getUserName(),
            "idAcionou": UID,
            "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}",
          });

          Map<String, dynamic> userID = jsonDecode(responsee.body);
          showToast("Cadastrado no equipamento!", context: context);
          return userID;
        } else {
          showToast("Erro com a comunicação, status: ${responsee.statusCode}", context: context);
        }


      }else{
        showToast("Erro com a comunicação, status: ${response.statusCode}", context: context);
      }
    }catch(e){
      showToast("Erro ao executar a requisição: $e", context: context);
    }
  }

  //Hikvision
  // Função para gerar um valor aleatório de cnonce
  // Função para extrair dados do header WWW-Authenticate
  Map<String, String> parseDigestHeader(String header) {
    final Map<String, String> authData = {};
    final regExp = RegExp(r'(\w+)=["]?([^",]+)["]?');
    regExp.allMatches(header).forEach((match) {
      authData[match.group(1)!] = match.group(2)!;
    });
    return authData;
  }

  String generateDigestAuth(Map<String, String> authData, String username, String password, String method, String uri) {
    final ha1 = md5.convert(utf8.encode('$username:${authData["realm"]}:$password')).toString();
    final ha2 = md5.convert(utf8.encode('$method:$uri')).toString();
    final response = md5.convert(utf8.encode('$ha1:${authData["nonce"]}:$ha2')).toString();

    return 'Digest username="$username", realm="${authData["realm"]}", nonce="${authData["nonce"]}", uri="$uri", response="$response"';
  }

  if(modelo == "Hikvision"){

    print('$ip:$porta\n"employeeNo": "$id"\n"name": $Nome,\n"beginTime": "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}T${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().microsecond}"');
    // URL do endpoint
    String url = 'http://$ip:$porta/ISAPI/AccessControl/UserInfo/Record?format=json&devIndex=0';

    // Credenciais
    String username = usuario;
    String password = Senha;

    // Corpo da requisição
    final Map<String, dynamic> requestBody = {
      "UserInfo": {
        "employeeNo": "$id",
        "name": Nome,
        "userType": "normal",
        "Valid": {
          "enable": true,
          "beginTime": "2017-01-01T00:00:00",
          "endTime": "2025-08-01T17:30:08"
        }
      }
    };

    // Realiza a primeira requisição para obter os dados do Digest Auth
    var response = await http.post(Uri.parse(url));
    if (response.statusCode == 401 && response.headers['www-authenticate'] != null) {
      final authHeader = response.headers['www-authenticate'];

      // Extrai os valores do header de autenticação
      final authData = parseDigestHeader(authHeader!);
      final digestAuth = generateDigestAuth(authData, username, password, 'POST', url);

      // Cabeçalhos com autenticação Digest
      final headers = {
        'Authorization': digestAuth,
        'Content-Type': 'application/json',
      };

      // Requisição POST com a autenticação Digest e corpo JSON
      response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(requestBody), // Converte o corpo para JSON
      );

      if (response.statusCode == 200) {
        showToast("Cadastrado no equipamento!", context: context);
        FirebaseFirestore.instance.collection("logs").doc(UUID).set({
          "text" : 'Dados do acionamento foi recolhidos',
          "codigoDeResposta" : response.statusCode,
          'acionamentoID': id,
          'acionamentoNome': ip,
          'Condominio': idCondominio,
          "id": UUID,
          'QuemFez': await getUserName(),
          "idAcionou": UID,
          "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
        });
      } else {
        showToast("Erro ao criar usuário: ${response.statusCode}\nResposta: ${response.body}", context: context);
        if(response.body.contains('employeeNoAlreadyExist')){
          showToast("O numero do ID do usuario já está cadastrado no equipamento!", context: context);
        }
      }
    } else {
      showToast('Falha ao obter o header WWW-Authenticate', context: context);
      throw Exception('Falha ao obter o header WWW-Authenticate');
    }
  }
  return {};
}