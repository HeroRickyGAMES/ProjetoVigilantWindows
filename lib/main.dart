import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sparta_monitoramento/checkUser.dart';
import 'package:sparta_monitoramento/firebase_options.dart';
import 'package:sparta_monitoramento/homeApp.dart';
import 'package:sparta_monitoramento/login/login.dart';

//Desenvolvido por HeroRickyGames

main(){
  runApp(
    MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark
      ),
      home: const mainApp(),
    )
  );
}

class mainApp extends StatefulWidget {
  const mainApp({super.key});

  @override
  State<mainApp> createState() => _mainAppState();
}


class _mainAppState extends State<mainApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    runFirebase() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.windows,
      );

      try{
        String UserName = await getUsername();
        final dir = Directory('C:\\Users\\$UserName\\AppData\\Local\\firestore\\[DEFAULT]\\sparta-monitoramento');
        if(await dir.exists()){
          dir.deleteSync(recursive: true);
        }
      }catch(e){
        //showToast("Error $e",context:context);
      }

      //Se o usuario estiver logado ele vai jogar na main
      FirebaseAuth.instance.idTokenChanges().listen((User? user) async {

        await Future.delayed(const Duration(seconds: 3));

        if(user == null){
          Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context){
                  return const login();
                }
              )
          );
        }else{
          Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context){
                  return const homeApp();
                }
              )
          );
        }
      });
    }

    runFirebase();

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
