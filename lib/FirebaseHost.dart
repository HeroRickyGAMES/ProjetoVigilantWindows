import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

//Programado por HeroRickyGames

String host = "192.168.1.101";
int Dbport = 8080;
int Authport = 9099;
int Storageport = 9199;

initFirestore(){
  FirebaseFirestore.instance.settings = Settings(
    host: '$host:$Dbport',
    sslEnabled: false,
    persistenceEnabled: false,
  );
}

initAuth(){
  FirebaseAuth.instance.useAuthEmulator(host, Authport);
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