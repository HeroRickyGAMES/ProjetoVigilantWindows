import 'dart:convert';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;

//Programado por HeroRickyGames com a ajuda de Deus!

LogsDosEquipamentos(var context, String ip, int porta, String usuario, String Senha, String modelo) async {

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

        final url = Uri.parse('http://$ip:$porta/load_objects.fcgi?session=${responseData["session"]}');

        Map<String, dynamic> body = {
          "object": "access_logs"
        };

        Map<String, String> headers = {
          "Content-Type": "application/json"
        };

        final responsee = await http.post(
          url,
          headers: headers,
          body: jsonEncode(body),
        );
        if (responsee.statusCode == 200) {

          Map<String, dynamic> jsonMap = jsonDecode(responsee.body);

          print(jsonMap['access_logs'].length);
          print(jsonMap['access_logs'][73]);
          print(jsonMap['access_logs'][73]['time']);
          print(jsonMap['access_logs'][73]['user_id']);

          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(jsonMap['access_logs'][73]['time'] * 1000);

          // Exibe a data e hora no formato padrão
          print("Data e hora: $dateTime");

          // Formata a data e hora (opcional)
          String formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
          print("Data formatada: $formattedDate");

        } else {
          print(responsee.statusCode);
        }
      }else{
        showToast("Erro com a comunicação, status: ${response.statusCode}", context: context);
      }
    }catch(e){
      showToast("Erro ao executar a requisição: $e", context: context);
    }
  }
}