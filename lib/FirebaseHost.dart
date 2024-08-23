import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

//Programado por HeroRickyGames com ajuda de Deus!

String host = "192.168.1.101";
int Dbport = 8081;
int Authport = 9091;
int Storageport = 9199;

//Debugs Ports: Para acessar no i5 daqui de casa, o monstro, a lenda. Que hoje em dia se tornou um servidor!
String hostDebug = "192.168.1.101";
int DbportDebug = 8087;
int AuthportDebug = 9097;

initFirestore(bool isDebugMode){
  if(isDebugMode == false){
    FirebaseFirestore.instance.settings = Settings(
      host: '$host:$Dbport',
      sslEnabled: false,
      persistenceEnabled: false,
    );
  }else{
    FirebaseFirestore.instance.settings = Settings(
      host: '$hostDebug:$DbportDebug',
      sslEnabled: false,
      persistenceEnabled: false,
    );
  }
}

initAuth(bool isDebugMode){
  if(isDebugMode == false){
    FirebaseAuth.instance.useAuthEmulator(host, Authport);
  }else{
    FirebaseAuth.instance.useAuthEmulator(hostDebug, AuthportDebug);
  }
}

carregarImagem(var context, File _imagefile, String ID, String idCondominio) async {
  FirebaseStorage storage = FirebaseStorage.instance;

  //SetServer
  storage.useStorageEmulator(host, Storageport);

  Reference ref = storage.ref().child('images/$idCondominio/$ID');
  await ref.putFile(_imagefile).whenComplete(() {
    showToast("Imagem carregada!",context:context);
  }).catchError((e){
    showToast("Houve uma falha no carregamento! codigo do erro: $e",context:context);
    showToast("Repasse esse erro para o desenvolvedor!",context:context);
  });
  return ref;
}