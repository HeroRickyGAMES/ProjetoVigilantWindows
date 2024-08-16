import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Programado por HeroRickyGames

String host = "192.168.1.101";
int Dbport = 8080;
int Authport = 9099;


initDB(){
  FirebaseFirestore.instance.settings = Settings(
    host: '$host:$Dbport',
    sslEnabled: false,
    persistenceEnabled: false,
  );
}

initAuth(){
  FirebaseAuth.instance.useAuthEmulator(host, Authport);
}