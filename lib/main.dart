import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vigilant/checkUser.dart';
import 'package:vigilant/firebase_options.dart';
import 'package:vigilant/homeApp.dart';
import 'package:vigilant/login/login.dart';

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

    //Vai para a tela de login
    GoToLoginScreen(){
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context){
            return const login();
          }
          )
      );
    }


   //Vai para a homeApp
    GoToHome(){
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context){
            return const homeApp();
          }
          )
      );
    }

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

        await Future.delayed(const Duration(seconds: 5));

        if(user == null){
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final String? Email = prefs.getString('email');
          final String? Senha = prefs.getString('senha');

          if(Email == null || Senha == null || Email == "" || Senha == ""){
            //Se for nulo ou vazio, ele joga para a login screen
            GoToLoginScreen();
          }else{
            FirebaseAuth.instance.signInWithEmailAndPassword(email: Email, password: Senha).whenComplete((){
              GoToHome();
            });
          }
        }else{
          GoToHome();
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
