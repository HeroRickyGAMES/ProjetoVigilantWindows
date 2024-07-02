import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http_auth/http_auth.dart' as http_auth;

//Programado por HeroRickyGames

acionarPorta(var context, String ip, int porta, String modelo, int canal, String usuario, String senha) async {

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
}