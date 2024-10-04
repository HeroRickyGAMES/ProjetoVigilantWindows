import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

//Programado por HeroRickyGames com ajuda de Deus

chamarSDK(String id, String ip, int porta) async {
  String command = 'guaritanicesdk/demoLinearIP.exe --ip $ip --porta $porta';
  ProcessResult result = await Process.run('bash', ['-c', command]);

  if(result.exitCode == 0){
    FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
      "prontoParaAtivar" : false,
      "deuErro": false
    });
  }else{
    FirebaseFirestore.instance.collection("acionamentos").doc(id).update({
      "prontoParaAtivar" : false,
      "deuErro": true
    });
  }

  print(result.exitCode);
}