import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:vigilant/acionamento_de_portas/acionamento_de_portas.dart';
import 'package:vigilant/homeApp.dart';
import 'package:vigilant/informacoesLogais/getIds.dart';
import 'package:vigilant/informacoesLogais/getUserInformations.dart';
//Programado por HeroRickyGames

usarFacial(var context, String ip, int porta,String usuario, String senha, String userID) async {
  final url = Uri.parse('http://$ip:$porta/cgi-bin/accessControl.cgi?action=captureCmd&type=1&UserID=$userID&heartbeat=5&timeout=10');
  print(url);

  Map<String, String> headers = {
    'Accept': '*/*',
    'Accept-Encoding': 'gzip, deflate, br',
    'Connection': 'keep-alive',
    "Content-Type": "application/json"
  };

  final client = http_auth.DigestAuthClient(usuario, senha);

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
      print(response.body);

    } else {
      showToast("Erro com a comunicação, status: ${response.statusCode}",context:context);
    }
  } catch (e) {
    showToast("Erro ao executar a requisição: $e",context:context);
  }
}