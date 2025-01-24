import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart';
import 'package:vigilant/acionamento_de_portas/acionamento_de_portas.dart';
import 'package:vigilant/homeApp.dart';

//Programado por HeroRickyGames com a ajuda de Deus!

userImportIntelbras(
    var context, String ip, int porta,
    String usuario, String Senha, String modelo,
    String Nome, int id, String CPF, String RG,
    String Unidade, String Bloco, String Observacoes,
    String Telefone, String Celular, String Qualificacao
    ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Aguarde!'),
          actions: [
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        );
      },
    );

  final Uri url = Uri.parse(
    'http://$ip:$porta/cgi-bin/recordUpdater.cgi?action=insert&name=AccessControlCard&CardNo=$id&CardStatus=0&CardName=$Nome&UserID=$id&Doors[0]=0',
  );

  // Configuração da autenticação Digest
  final DigestAuthClient client = DigestAuthClient(usuario, Senha);

  try {
    // Realizando a requisição GET
    final http.Response response = await client.get(url);

    // Verificando o status da resposta
    if (response.statusCode == 200) {
      String iddoc = uuid.v4();
      String DocID = "${iddoc}$id";

      String DownloadURL = '';

      FirebaseFirestore.instance.collection('Pessoas').doc(DocID).set({
        "id": DocID,
        "idCondominio": idCondominio,
        "Nome": Nome,
        "CPF": CPF,
        "RG": RG,
        "imageURI": DownloadURL,
        "Unidade":Unidade,
        "Bloco": Bloco,
        "anotacao": Observacoes,
        "Telefone": Telefone,
        "Celular": Celular,
        "Qualificacao": Qualificacao,
        "ipAcionamento": ip,
        "portaAcionamento": porta,
        "usuarioAcionamento": usuario,
        "senhaAcionamento": Senha,
        "idEquipamento": id,
        "modeloAcionamento": modelo,
      }).whenComplete((){
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        showToast("Cadastrado no equipamento!", context: context);
      });

    } else {
      print('Erro na requisição: Código de status ${response.statusCode}.');
    }
  } catch (e) {
    print('Erro durante a requisição: $e');
  }
}