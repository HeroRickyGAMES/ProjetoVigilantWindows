import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';
import 'package:vigilant/informacoesLogais/getIds.dart';
import 'package:vigilant/informacoesLogais/getUserInformations.dart';
import 'package:vigilant/moduloGuarita/guarita_call_nativo.dart';
import 'package:vigilant/homeApp.dart';

//Programado por HeroRickyGames com ajuda de Deus!

Uuid uuid = const Uuid();
String UUID = uuid.v4();

originalParameter(String id){
  FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
    "prontoParaAtivar" : false,
    "deuErro": false
  });
}

acionarPorta(var context, String ip, int porta, String modelo, int canal, String usuario, String senha, String id, String Receptor, String can, String nomeAc, bool secbox, String tagVeicular) async {

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
          FirebaseFirestore.instance.collection("logs").doc(UUID).set({
            "text" : 'Acionamento concluido com sucesso!',
            "codigoDeResposta" : response.statusCode,
            'acionamentoID': id,
            'acionamentoNome': nomeAc,
            'Condominio': idCondominio,
            "id": UUID,
            'QuemFez': await getUserName(),
            "idAcionou": UID,
            "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
          });
        }
      } else {
        showToast("Erro com a comunicação, status: ${response.statusCode}",context:context);
        if(id != ""){
          FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
            "prontoParaAtivar" : false,
            "deuErro": true
          });
          FirebaseFirestore.instance.collection("logs").doc(UUID).set({
            "text" : 'Acionamento falhou!',
            "codigoDeResposta" : response.statusCode,
            'acionamentoID': id,
            'acionamentoNome': nomeAc,
            'Condominio': idCondominio,
            "id": UUID,
            'QuemFez': await getUserName(),
            "idAcionou": UID,
            "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
          });
        }
      }
    } catch (e) {
      showToast("Erro ao executar a requisição: $e",context:context);
    }
  }

  //Control iD
  if(modelo == "Control iD"){
    if(secbox == true){
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

          print(url);

          // Corpo da requisição
          final body = jsonEncode({
            "actions": [
              {
                "action": "sec_box",
                "user_id": "10",
                "parameters": "id=65793, reason=$tagVeicular"
              }
            ],
          });

          // Configurar cabeçalhos
          final headers = {
            'Content-Type': 'application/json',
          };

          try {
            // Fazer requisição POST
            final response = await http.post(
              url,
              headers: headers,
              body: body,
            );

            // Verificar resposta
            if (response.statusCode == 200) {
              showToast("Porta aberta!", context: context);
              if(id != ""){
                FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
                  "prontoParaAtivar" : false,
                  "deuErro": false
                });

                FirebaseFirestore.instance.collection("logs").doc(UUID).set({
                  "text" : 'Acionamento concluido com sucesso!',
                  "codigoDeResposta" : response.statusCode,
                  'acionamentoID': id,
                  'acionamentoNome': nomeAc,
                  'Condominio': idCondominio,
                  "id": UUID,
                  'QuemFez': await getUserName(),
                  "idAcionou": UID,
                  "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
                });
              }
            } else {
              showToast("Erro ao executar a requisição", context: context);
              if(id != ""){
                FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
                  "prontoParaAtivar" : false,
                  "deuErro": true
                });
              }
              FirebaseFirestore.instance.collection("logs").doc(UUID).set({
                "text" : 'Acionamento falhou!',
                "codigoDeResposta" : 600,
                'acionamentoID': id,
                'acionamentoNome': nomeAc,
                'Condominio': idCondominio,
                "id": UUID,
                'QuemFez': await getUserName(),
                "idAcionou": UID,
                "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
              });
            }
          } catch (e) {
            showToast("Erro ao executar a requisição: $e", context: context);
            if(id != ""){
              FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
                "prontoParaAtivar" : false,
                "deuErro": true
              });
            }
            FirebaseFirestore.instance.collection("logs").doc(UUID).set({
              "text" : 'Acionamento falhou!',
              "codigoDeResposta" : 600,
              'acionamentoID': id,
              'acionamentoNome': nomeAc,
              'Condominio': idCondominio,
              "id": UUID,
              'QuemFez': await getUserName(),
              "idAcionou": UID,
              "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
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
          FirebaseFirestore.instance.collection("logs").doc(UUID).set({
            "text" : 'Acionamento falhou!',
            "codigoDeResposta" : response.statusCode,
            'acionamentoID': id,
            'acionamentoNome': nomeAc,
            'Condominio': idCondominio,
            "id": UUID,
            'QuemFez': await getUserName(),
            "idAcionou": UID,
            "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
          });
        }
      } catch (e) {
        showToast("Erro ao executar a requisição: $e", context: context);
        if(id != ""){
          FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
            "prontoParaAtivar" : false,
            "deuErro": true
          });
        }
        FirebaseFirestore.instance.collection("logs").doc(UUID).set({
          "text" : 'Acionamento falhou!',
          "codigoDeResposta" : 600,
          'acionamentoID': id,
          'acionamentoNome': nomeAc,
          'Condominio': idCondominio,
          "id": UUID,
          'QuemFez': await getUserName(),
          "idAcionou": UID,
          "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
        });
      }

    }else{
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
                "action": "door",
                "parameters": "door=$canal"
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
                FirebaseFirestore.instance.collection("logs").doc(UUID).set({
                  "text" : 'Acionamento concluido com sucesso!',
                  "codigoDeResposta" : response.statusCode,
                  'acionamentoID': id,
                  'acionamentoNome': nomeAc,
                  'Condominio': idCondominio,
                  "id": UUID,
                  'QuemFez': await getUserName(),
                  "idAcionou": UID,
                  "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
                });
              }
            } else {
              showToast("Erro com a comunicação, status: ${response.statusCode}", context: context);
              if(id != ""){
                FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
                  "prontoParaAtivar" : false,
                  "deuErro": true
                });
                FirebaseFirestore.instance.collection("logs").doc(UUID).set({
                  "text" : 'Acionamento falhou!',
                  "codigoDeResposta" : response.statusCode,
                  'acionamentoID': id,
                  'acionamentoNome': nomeAc,
                  'Condominio': idCondominio,
                  "id": UUID,
                  'QuemFez': await getUserName(),
                  "idAcionou": UID,
                  "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
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
              FirebaseFirestore.instance.collection("logs").doc(UUID).set({
                "text" : 'Acionamento falhou!',
                "codigoDeResposta" : response.statusCode,
                'acionamentoID': id,
                'acionamentoNome': nomeAc,
                'Condominio': idCondominio,
                "id": UUID,
                'QuemFez': await getUserName(),
                "idAcionou": UID,
                "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
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
          FirebaseFirestore.instance.collection("logs").doc(UUID).set({
            "text" : 'Acionamento falhou!',
            "codigoDeResposta" : response.statusCode,
            'acionamentoID': id,
            'acionamentoNome': nomeAc,
            'Condominio': idCondominio,
            "id": UUID,
            'QuemFez': await getUserName(),
            "idAcionou": UID,
            "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
          });
        }
      } catch (e) {
        showToast("Erro ao executar a requisição: $e", context: context);
        if(id != ""){
          FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
            "prontoParaAtivar" : false,
            "deuErro": true
          });
        }
        FirebaseFirestore.instance.collection("logs").doc(UUID).set({
          "text" : 'Acionamento falhou!',
          "codigoDeResposta" : 600,
          'acionamentoID': id,
          'acionamentoNome': nomeAc,
          'Condominio': idCondominio,
          "id": UUID,
          'QuemFez': await getUserName(),
          "idAcionou": UID,
          "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
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
        final authValue = 'Digest username="$usuario", realm="$realm", nonce="$nonce", uri="$uri", qop=$qop, nc=$nc, cnonce="$cnonce", response="$responseDigest"';

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
            FirebaseFirestore.instance.collection("logs").doc(UUID).set({
              "text" : 'Acionamento concluido com sucesso!',
              "codigoDeResposta" : response2.statusCode,
              'acionamentoID': id,
              'acionamentoNome': nomeAc,
              'Condominio': idCondominio,
              "id": UUID,
              'QuemFez': await getUserName(),
              "idAcionou": UID,
              "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
            });
          }
        } else {
          showToast('Erro ao enviar comando: ${response2.statusCode}', context: context);
          if(id != ""){
            FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
              "prontoParaAtivar" : false,
              "deuErro": true
            });
            FirebaseFirestore.instance.collection("logs").doc(UUID).set({
              "text" : 'Acionamento falhou: Erro ao enviar comando!',
              "codigoDeResposta" : response2.statusCode,
              'acionamentoID': id,
              'acionamentoNome': nomeAc,
              'Condominio': idCondominio,
              "id": UUID,
              'QuemFez': await getUserName(),
              "idAcionou": UID,
              "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
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
          FirebaseFirestore.instance.collection("logs").doc(UUID).set({
            "text" : 'Acionamento falhou: Cabeçalho WWW-Authenticate não encontrado! Possivelmente o login ou senha está incorreto!',
            "codigoDeResposta" : response1.statusCode,
            'acionamentoID': id,
            'acionamentoNome': nomeAc,
            'Condominio': idCondominio,
            "id": UUID,
            'QuemFez': await getUserName(),
            "idAcionou": UID,
            "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
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
        FirebaseFirestore.instance.collection("logs").doc(UUID).set({
          "text" : 'Acionamento falhou: Falha ao obter nonce!',
          "codigoDeResposta" : response1.statusCode,
          'acionamentoID': id,
          'acionamentoNome': nomeAc,
          'Condominio': idCondominio,
          "id": UUID,
          'QuemFez': await getUserName(),
          "idAcionou": UID,
          "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
        });
      }
    }
  }

  //Modulo Guarita (Nice)
  if(modelo == "Modulo Guarita (Nice)"){
    if(ip.contains('ddns.net')){
      List<InternetAddress> addresses = await InternetAddress.lookup(ip);

      chamarSDK(context, id, '${addresses[0]}'.replaceAll('InternetAddress(', '').replaceAll(", IPv4)", '').replaceAll("'", ''), porta, Receptor, can, "$canal", nomeAc);
    }else{
      chamarSDK(context, id, ip, porta, Receptor, can, "$canal", nomeAc);
    }
  }
}