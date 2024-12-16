import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:vigilant/acionamento_de_portas/acionamento_de_portas.dart';
import 'package:vigilant/homeApp.dart';
import 'package:vigilant/informacoesLogais/getIds.dart';
import 'package:vigilant/informacoesLogais/getUserInformations.dart';

//Programado por HeroRickyGAMES com a ajuda de Deus!

Future<Map<String, dynamic>> controlidTags(var context, String ip, int porta, String usuario, String Senha, String modelo) async {
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
            return {};
          }
        } catch (e) {
          showToast("Erro ao executar a requisição: $e", context: context);
          return {};
        }

      } else {
        showToast("Erro com a comunicação, status: ${response.statusCode}", context: context);
        return {};
      }
    }catch(e){
      showToast("Erro ao executar a requisição: $e", context: context);
      return {};
    }
  }
  return {};
}