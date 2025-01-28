import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;
import 'package:vigilant/acionamento_de_portas/acionamento_de_portas.dart';
import 'package:vigilant/homeApp.dart';
import 'package:vigilant/informacoesLogais/getIds.dart';
import 'package:vigilant/informacoesLogais/getUserInformations.dart';
import 'package:vigilant/infosdoPc/checkUser.dart';
import 'package:vigilant/tags/tag.dart';

//Programado por HeroRickyGames com a ajuda de Deus!

List<Map<String, dynamic>> intelbrasToMap(String response) {
  Map<String, dynamic> result = {};
  List<String> lines = response.split('\n'); // Quebrar a string em linhas

  for (String line in lines) {
    if (line.trim().isEmpty) continue; // Ignorar linhas vazias
    List<String> parts = line.split('='); // Separar chave e valor
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
      if (key.startsWith('records[')) {
        // Extrai o índice e o campo
        final match = RegExp(r'records\[(\d+)\]\.(.+)').firstMatch(key);
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

//Programado por HeroRickyGames com ajuda de Deus!

ImagemEquipamentoCotroliD(String host, int port, String Season, int id) async {
  var url = Uri.parse('http://$host:$port/user_get_image.fcgi?session=$Season&user_id=$id');
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

ImagemEquipamentoHikvision(String host, int port, String usuario, String senha, int id, String FPID, String FDID, var context) async {
  // URL do endpoint
  String url = 'http://$host:$port/ISAPI/Intelligent/FDLib/FDSearch?format=json&devIndex=0';
  // Credenciais
  String username = usuario;
  String password = senha;

  // Realiza a primeira requisição para obter os dados do Digest Auth
  var response = await http.post(Uri.parse(url));
  if (response.statusCode == 401 && response.headers['www-authenticate'] != null) {
    final authHeader = response.headers['www-authenticate'];

    // Extrai os valores do header de autenticação
    final authData = _parseDigestHeader(authHeader!);
    final digestAuth = _generateDigestAuth(authData, username, password, 'POST', url);
    final digestAuthe = _generateDigestAuth(authData, username, password, 'GET', url);

    // Cabeçalhos com autenticação Digest
    final headers = {
      'Authorization': digestAuth,
      'Content-Type': 'application/json',
    };
    // Corpo da requisição
    final Map<String, dynamic> requestBody = {
      "maxResults": 10,
      "searchResultPosition": 0,
      "faceLibType": "blackFD",
      //APENAS IGNORA ISSO
      "FDID": "1",
      //UID DO USUARIO
      "FPID": FPID
    };

    // Requisição POST com a autenticação Digest
    response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final headerse = {
        'Authorization': digestAuthe,
        'Content-Type': 'application/json',
      };
      var file = File('C:\\Users\\${await getUsername()}\\AppData\\Local\\Temp\\$id.jpg');

      // Escreve os bytes da resposta (imagem) no arquivo
      Map js = jsonDecode(response.body);
      Uri https = Uri.parse(js['MatchList'][0]['faceURL']);

      String hoster  = "http://$host:$port${https.path}";

      final responsee = await http.get(
        Uri.parse(hoster),
        headers: headerse,
      );

      if (responsee.statusCode == 200) {
        return await file.writeAsBytes(responsee.bodyBytes);
      } else {
        throw Exception('Falha ao fazer o download do arquivo');
      }

    } else {
      throw Exception('Falha ao fazer o download do arquivo');
    }
  } else {
    showToast("Erro com a comunicação, status: ${response.statusCode}!", context: context);
    return null;
  }
}

Future<Map<String, dynamic>> pushPessoas(var context, String ip, int porta, String usuario, String Senha, String modelo, int hiktotalMatches) async {
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

  if(modelo == "Hikvision"){
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
          "searchResultPosition": hiktotalMatches,
          "maxResults": 1000
        }
      };

      // Requisição POST com a autenticação Digest
      response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
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

intelbrasUsersImport(var context, String ip, int porta, String usuario, String Senha, String modelo) async {
  //Intelbras
  if(modelo == "Intelbras"){
    final url = Uri.parse('http://$ip:$porta/cgi-bin/recordFinder.cgi?action=doSeekFind&name=AccessControlCard&count=4300');

    Map<String, String> headers = {
      'Accept': '*/*',
      'Accept-Encoding': 'gzip, deflate, br',
      'Connection': 'keep-alive',
      "Content-Type": "application/json"
    };

    final client = http_auth.DigestAuthClient(usuario, Senha);

    try {
      final response = await client.get(url, headers: headers);

      if (response.statusCode == 200) {
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
        List<Map<String, dynamic>> listadeUsuarios = intelbrasToMap(response.body);

        return listadeUsuarios;
      } else {
        showToast("Erro com a comunicação, status: ${response.statusCode}",context:context);
      }
    } catch (e) {
      showToast("Erro ao executar a requisição: $e",context:context);
    }
  }
  return {};
}