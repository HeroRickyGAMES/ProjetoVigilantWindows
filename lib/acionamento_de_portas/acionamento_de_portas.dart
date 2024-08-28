import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/bottomsheet/bottomsheet.dart';
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

//Programado por HeroRickyGames com ajuda de Deus!

acionarPorta(var context, String ip, int porta, String modelo, int canal, String usuario, String senha, String id) async {

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
        if(id != ""){
          FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
            "prontoParaAtivar" : false,
            "deuErro": false
          });
        }
      } else {
        showToast("Erro com a comunicação, status: ${response.statusCode}",context:context);
        if(id != ""){
          FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
            "prontoParaAtivar" : false,
            "deuErro": true
          });
        }
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
            if(id != ""){
              FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
                "prontoParaAtivar" : false,
                "deuErro": false
              });
            }
          } else {
            showToast("Erro com a comunicação, status: ${response.statusCode}", context: context);
            if(id != ""){
              FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
                "prontoParaAtivar" : false,
                "deuErro": true
              });
            }
          }
        } catch (e) {
          showToast("Erro ao executar a requisição: $e", context: context);
          if(id != ""){
            FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
              "prontoParaAtivar" : false,
              "deuErro": true
            });
          }
        }

      } else {
        showToast("Erro com a comunicação, status: ${response.statusCode}", context: context);
        if(id != ""){
          FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
            "prontoParaAtivar" : false,
            "deuErro": true
          });
        }
      }
    } catch (e) {
      showToast("Erro ao executar a requisição: $e", context: context);
      if(id != ""){
        FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
          "prontoParaAtivar" : false,
          "deuErro": true
        });
      }
    }
  }

  //Hikvision
  String? getHeaderAttribute(String header, String attribute) {
    final regex = RegExp('$attribute="([^"]*)"');
    final match = regex.firstMatch(header);
    return match?.group(1);
  }

  if(modelo == "Hikvision"){
    String url = "http://$ip:$porta/ISAPI/AccessControl/RemoteControl/door/$canal";

    // Primeira requisição para obter o nonce e outros parâmetros de autenticação
    final response1 = await http.get(Uri.parse(url));
    if (response1.statusCode == 401) {
      final authHeader = response1.headers['www-authenticate'];

      if (authHeader != null) {
        // Extrair informações da autenticação Digest
        final realm = getHeaderAttribute(authHeader, 'realm');
        final nonce = getHeaderAttribute(authHeader, 'nonce');
        final qop = getHeaderAttribute(authHeader, 'qop');
        final uri = Uri.parse(url).path;
        const nc = '00000001';
        const cnonce = "MTIzNDU2Nzg=";

        // Cálculo do HA1, HA2, e da resposta Digest
        final ha1 = md5.convert(utf8.encode('$usuario:$realm:$senha')).toString();
        final ha2 = md5.convert(utf8.encode('PUT:$uri')).toString();
        final responseDigest = md5.convert(utf8.encode('$ha1:$nonce:$nc:$cnonce:$qop:$ha2')).toString();

        // Cabeçalho de autorização Digest
        final authValue =
            'Digest username="$usuario", realm="$realm", nonce="$nonce", uri="$uri", qop=$qop, nc=$nc, cnonce="$cnonce", response="$responseDigest"';

        // Realiza a requisição PUT com autenticação Digest
        final response2 = await http.put(
          Uri.parse(url),
          headers: {
            'Authorization': authValue,
            'Content-Type': 'application/xml',
          },
          body: '<RemoteControlDoor><cmd>open</cmd></RemoteControlDoor>',
        );

        // Verifica a resposta
        if (response2.statusCode == 200) {
          showToast("Porta aberta!", context: context);
          if(id != ""){
            FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
              "prontoParaAtivar" : false,
              "deuErro": false
            });
          }
        } else {
          showToast('Erro ao enviar comando: ${response2.statusCode}', context: context);
          if(id != ""){
            FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
              "prontoParaAtivar" : false,
              "deuErro": true
            });
          }
        }
      } else {
        showToast('Cabeçalho WWW-Authenticate não encontrado! Possivelmente o login ou senha está incorreto!', context: context);
        if(id != ""){
          FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
            "prontoParaAtivar" : false,
            "deuErro": true
          });
        }
      }
    } else {
      showToast('Falha ao obter nonce. Status: ${response1.statusCode}', context: context);
      if(id != ""){
        FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
          "prontoParaAtivar" : false,
          "deuErro": true
        });
      }
    }
  }

  //Modulo Guarita (Nice)
  if(modelo == "Modulo Guarita (Nice)"){
    String enderecoDisp = ip;
    int portaDisp = porta;
    String codigoAcesso = "";
    int timeout = 10;

    List<int> hexStringToByteArray(String s) {
      final length = s.length;
      final data = List<int>.filled(length ~/ 2, 0);
      for (int i = 0; i < length; i += 2) {
        data[i ~/ 2] = int.parse(s.substring(i, i + 2), radix: 16);
      }
      return data;
    }

    String calculaChecksum(String input) {
      var parts = RegExp(r'..').allMatches(input).map((m) => m.group(0)!).toList();
      int cs = 0;
      for (var part in parts) {
        int decimal = int.parse(part, radix: 16);
        cs += decimal;
      }

      if (cs > 255) {
        cs = cs & 0xFF;
      }

      String csHex = cs.toRadixString(16).toUpperCase().padLeft(2, '0');
      return input + csHex;
    }

    Future<bool> acionaRele(int tipoDisp, int numDisp, int rele, int geraEvt) async {
      tipoDisp = tipoDisp.clamp(1, 7);
      numDisp = numDisp.clamp(0, 7);
      rele = rele.clamp(1, 4);
      geraEvt = (geraEvt == 0) ? 0 : 1;
      print("Estagio!");

      try {
        final socket = await Socket.connect(enderecoDisp, portaDisp, timeout: Duration(seconds: timeout));
        print("Estagio 2!");
        if (codigoAcesso.isNotEmpty) {
          socket.add(utf8.encode(codigoAcesso));
          await socket.flush();
          await socket.listen(
                  (data) {
                    print("Dados lidos $data");
                  }
          ).asFuture(Duration(seconds: timeout));
          print("Estagio 3!");
        }

        String message = "000d${tipoDisp.toString().padLeft(2, '0')}${numDisp.toString().padLeft(2, '0')}${rele.toString().padLeft(2, '0')}${geraEvt.toString().padLeft(2, '0')}";
        String checksum = calculaChecksum(message);
        print(checksum);
        print("Estagio 4!");
        var messageBytes = hexStringToByteArray(checksum);
        print(messageBytes);
        print("Estagio 5!");
        await socket.flush();
        await socket.listen((data) {
              print(data);
            }
        ).asFuture(
            Duration(seconds: timeout)
        ).catchError((e){
          print("Erro: $e");
        });

        await socket.close();
        print("Estagio 6! O Socket foi fechado!");
        return true;
      } catch (e) {
        print("Erro! $e");
      }

      return false;
    }

    print("Testando!");
    showToast("Aguarde!", context: context);
    bool handshakeDone = await acionaRele(3, 0, canal, 1);
    print(handshakeDone);

    if(handshakeDone == true){
      showToast("Relê acionado!", context: context);
      if(id != ""){
        FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
          "prontoParaAtivar" : false,
          "deuErro": false
        });
      }
    }else{
      showToast('Ocorreu um erro com a conexão!', context: context);
      if(id != ""){
        FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
          "prontoParaAtivar" : false,
          "deuErro": true
        });
      }
    }
  }
}