import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:uuid/uuid.dart';
import 'package:vigilant/homeApp.dart';
import 'package:vigilant/informacoesLogais/getIds.dart';
import 'package:vigilant/informacoesLogais/getUserInformations.dart';

//Programado por HeroRickyGames com ajuda de Deus

chamarSDK(var context, String id, String ip, int porta, String receptor, String can, String rele, String nomeAc) async {

  Uuid uuid = const Uuid();
  String UUID = uuid.v4();
  String recept = "";

  if (receptor == "TX (RF)") {
    recept = "RF";
  }
  if (receptor == "TAG Ativo (TA)") {
    recept = "TA";
  }
  if (receptor == "Cartão (CT/CTW)") {
    recept = "CT_CTW";
  }
  if (receptor == "TAG Passivo (TP/UHF)") {
    recept = "TP_UHF";
  }

  String command = 'guaritanicesdk/demoLinearIP.exe --ip $ip --porta $porta --receptor $recept --CAN $can --rele $rele';

  ProcessResult result = await Process.run('powershell.exe', ['-c', command]);

  if(result.stdout.toString().contains("Rele acionado")){
    FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
      "prontoParaAtivar" : false,
      "deuErro": false
    });
    FirebaseFirestore.instance.collection("logs").doc(UUID).set({
      "text" : 'Acionamento concluido com sucesso!',
      "codigoDeResposta" : 200,
      'acionamentoID': id,
      'acionamentoNome': nomeAc,
      'Condominio': idCondominio,
      "id": UUID,
      'QuemFez': await getUserName(),
      "idAcionou": UID,
      "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
    });
    showToast("Guarita acionada", context: context);
  }else{
    if(result.stdout.toString().contains('FALHA CONEXAO TCP')){
      FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
        "prontoParaAtivar" : false,
        "deuErro": true
      });
      showToast("FALHA CONEXAO TCP", context: context);
      FirebaseFirestore.instance.collection("logs").doc(UUID).set({
        "text" : 'Acionamento falhou: FALHA CONEXAO TCP: guaritaTCPerror',
        "codigoDeResposta" : 482748282737767,
        'acionamentoID': id,
        'acionamentoNome': nomeAc,
        'Condominio': idCondominio,
        "id": UUID,
        'QuemFez': await getUserName(),
        "idAcionou": UID,
        "data": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}"
      });
    }else{
      FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
        "prontoParaAtivar" : false,
        "deuErro": true
      });
      showToast("A SDK não foi iniciada ou ocorreu qualquer outro erro desconhecido!", context: context);
      FirebaseFirestore.instance.collection("logs").doc(UUID).set({
        "text" : 'Acionamento falhou: A SDK não foi iniciada ou ocorreu qualquer outro erro desconhecido!: SDKUnknownError',
        "codigoDeResposta" : 735865669637767,
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

  print(result.exitCode);
}