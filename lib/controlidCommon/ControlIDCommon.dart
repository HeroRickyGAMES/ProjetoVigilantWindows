import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

//Programado por HeroRickyGAMES

mandarRequisicaoParaDigital(var context, String ip, int porta, String usuario, String Senha, String userid) async {

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Use a digital no aparelho!'),
        actions: [
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                    child: const Icon(Icons.fingerprint)
                ),
                const LinearProgressIndicator(),
              ],
            ),
          )
        ],
      );
    },
  );
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

      final url = Uri.parse('http://$ip:$porta/remote_enroll.fcgi?session=${responseData["session"]}');

      Map<String, String> headers = {
        "Content-Type": "application/json"
      };

      Map<String, dynamic> body = {
        "type": "biometry",
        "user_id": int.parse(userid),
        "save": true,
        "sync": true,
        "panic_finger": 0
      };

      final responsee = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if(responsee.statusCode == 200){
        Map<String, dynamic> resposta = jsonDecode(responsee.body);
        if(resposta['success'] == true){
          Navigator.pop(context);
          showToast("Pronto!", context: context);
        }

      }else{
        showToast("Erro com a comunicação, status: ${responsee.statusCode}", context: context);
      }
    }else{
      showToast("Erro com a comunicação, status: ${response.statusCode}", context: context);
    }
  }catch(e){
    showToast("Erro ao executar a requisição: $e", context: context);
  }
}