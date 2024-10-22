import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

//Programado por HeroRickyGames com ajuda de Deus

chamarSDK(var context, String id, String ip, int porta, String receptor, String can, String rele) async {

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
  if (receptor == "Cartão (CT/CTW)") {
    recept = "TP_UHF";
  }

  String command = 'guaritanicesdk/demoLinearIP.exe --ip $ip --porta $porta --receptor $recept --CAN $can --rele $rele';

  ProcessResult result = await Process.run('powershell.exe', ['-c', command]);

  print(result.stdout);
  print(result.stderr);

  if(result.stdout.toString().contains("Rele acionado")){
    FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
      "prontoParaAtivar" : false,
      "deuErro": false
    });
    showToast("Guarita acionada", context: context);
  }else{
    if(result.stdout.toString().contains('FALHA CONEXAO TCP"')){
      FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
        "prontoParaAtivar" : false,
        "deuErro": true
      });
      showToast("FALHA CONEXAO TCP", context: context);
    }else{
      FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
        "prontoParaAtivar" : false,
        "deuErro": true
      });
      showToast("A SDK não foi iniciada!", context: context);
    }
  }

  print(result.exitCode);
}