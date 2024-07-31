import 'dart:convert';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:http/http.dart' as http;

//Programado por HeroRickyGames

acionarPorta(var context, String ip, int porta, String modelo, int canal, String usuario, String senha) async {

  //Intelbras
  if(modelo == "Intelbras"){
    final url = Uri.parse('http://$ip:$porta/cgi-bin/accessControl.cgi?action=openDoor&channel=$canal');

    Map<String, String> headers = {
      'Accept': '*/*',
      'Accept-Encoding': 'gzip, deflate, br',
      'Connection': 'keep-alive',
    };

    final client = http_auth.DigestAuthClient(usuario, senha);

    try {
      final response = await client.get(url, headers: headers);

      if (response.statusCode == 200) {
        showToast("Porta aberta!",context:context);
      } else {
        showToast("Erro com a comunicação, status: ${response.statusCode}",context:context);
      }
    } catch (e) {
      showToast("Erro ao executar a requisição: $e",context:context);
    }
  }

  //Control iD
  if(modelo == "Control iD"){

    final urlog = Uri.parse('http://$ip:$porta/login.fcgi');

    Map<String, String> headerslog = {
      "Content-Type": "application/json"
    };

    Map<String, dynamic> bodylog = {
      "login": usuario,
      "password": senha
    };

    try {
      final response = await http.post(
        urlog,
        headers: headerslog,
        body: jsonEncode(bodylog),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        final url = Uri.parse('http://$ip:$porta/execute_actions.fcgi?session=${responseData["session"]}');

        Map<String, String> headers = {
          "Content-Type": "application/json"
        };

        Map<String, dynamic> body = {
          "actions": [
            {
              "action": "sec_box",
              "parameters": "id=65793, reason=3"
            }
          ]
        };

        try {
          final response = await http.post(
            url,
            headers: headers,
            body: jsonEncode(body),
          );

          if (response.statusCode == 200) {
            showToast("Porta aberta!", context: context);
          } else {
            showToast("Erro com a comunicação, status: ${response.statusCode}", context: context);
          }
        } catch (e) {
          showToast("Erro ao executar a requisição: $e", context: context);
        }

      } else {
        showToast("Erro com a comunicação, status: ${response.statusCode}", context: context);
      }
    } catch (e) {
      showToast("Erro ao executar a requisição: $e", context: context);
    }
  }
}