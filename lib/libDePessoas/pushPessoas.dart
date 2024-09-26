import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;
import 'package:vigilant/checkUser.dart';

//Programado por HeroRickyGames com ajuda de Deus!

ImagemEquipamentoCotroliD(String host, int port, String Season, int id) async {
  var url = Uri.parse('http://$host:$port/user_get_image.fcgi?session=$Season&user_id=$id');
  //var url = Uri.parse('http://sancaguarulhos.ddns.net:8091/user_get_image.fcgi?session=sddaRj00cFGUcSk1IbQ9GLeI&user_id=4');
  var response = await http.post(url);

  if (response.statusCode == 200) {
    var file = File('C:\\Users\\${await getUsername()}\\AppData\\Local\\Temp$id.jpg');

    // Escreve os bytes da resposta (imagem) no arquivo
    await file.writeAsBytes(response.bodyBytes);

    return file;

  } else {
    print('Request failed with status: ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> pushPessoas(var context, String ip, int porta, String usuario, String Senha, String modelo) async {

  //ControlID
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

            return users;
          } else {
            showToast("Erro com a comunicação, status: ${responsee.statusCode}", context: context);
          }
        } catch (e) {
          showToast("Erro ao executar a requisição: $e", context: context);
        }

      } else {
        showToast("Erro com a comunicação, status: ${response.statusCode}", context: context);
      }
    }catch(e){
      showToast("Erro ao executar a requisição: $e", context: context);
    }
  }

  //Intelbras
  if(modelo == "Intelbras"){
    final url = Uri.parse('http://$ip:$porta/cgi-bin/recordFinder.cgi?action=doSeekFind&name=AccessControlCard&count=4300');

    Map<String, String> headers = {
      'Accept': '*/*',
      'Accept-Encoding': 'gzip, deflate, br',
      'Connection': 'keep-alive',
    };

    final client = http_auth.DigestAuthClient(usuario, Senha);

    try {
      final response = await client.get(url, headers: headers);

      if (response.statusCode == 200) {
        print(response.body);
      } else {
        showToast("Erro com a comunicação, status: ${response.statusCode}",context:context);
      }
    } catch (e) {
      showToast("Erro ao executar a requisição: $e",context:context);
    }
  }

  if(modelo == "Hikvision"){

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

    // URL do endpoint
    String url = 'http://$ip:$porta/ISAPI/AccessControl/UserInfo/Search?format=json&devIndex=0';

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

      // Corpo da requisição
      final Map<String, dynamic> requestBody = {
        "UserInfoSearchCond": {
          "searchID": "0",
          "searchResultPosition": 0,
          "maxResults": 30
        }
      };

      // Requisição POST com a autenticação Digest
      response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Converte a resposta JSON para Map
        return jsonDecode(response.body);
      } else {
        throw Exception('Erro na requisição: ${response.statusCode}');
      }
    } else {
      throw Exception('Falha ao obter o header WWW-Authenticate');
    }
  }
  return {};
}