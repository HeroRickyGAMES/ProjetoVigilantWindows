import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vigilant/FirebaseHost.dart';
import 'package:vigilant/infosdoPc/checkUser.dart';
import 'package:vigilant/firebase_options.dart';
import 'package:vigilant/homeApp.dart';
import 'package:vigilant/infosdoPc/getCPUGHZ.dart';
import 'package:vigilant/login/login.dart';
import 'package:window_manager/window_manager.dart';

//Desenvolvido por HeroRickyGames com ajuda de Deus!

String loaderAviso = "";
bool delayOcorred = false;
bool iniciadoPrimeiro = false;
bool iniciado = false;

main(){
  runApp(
      GetMaterialApp(
        initialRoute: '/',
        theme: ThemeData(
          brightness: Brightness.dark,
          textSelectionTheme: const TextSelectionThemeData(
              selectionColor: Colors.blue
          ),
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

  initWindow() async {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(1280, 740),
      center: true,
      backgroundColor: Colors.transparent,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  maximizar() async {
    if(iniciado == false){
      await WindowManager.instance.maximize();
    }
  }

  @override
  void initState() {
    initWindow();
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
      maximizar();
      iniciado = true;
      Get.to(const login());
    }


    //Vai para a homeApp
    GoToHome(){
      maximizar();
      iniciado = true;
      Get.to(const homeApp());
    }

    initDB() async {
      Socket.connect(host, Dbport, timeout: const Duration(seconds: 5)).then((socket){
        setState(() {
          loaderAviso = "Conectado...";
        });

        //Server offline ou Server out para configurar lá!
        initFirestore();
        initAuth();

        //Se o usuario estiver logado ele vai jogar na main
        FirebaseAuth.instance.idTokenChanges().listen((User? user) async {

          await Future.delayed(const Duration(seconds: 2));

          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? Email = prefs.getString('email');
          String? Senha = prefs.getString('senha');

          if(Email == null || Senha == null || Email == "" || Senha == ""){
            //Se for nulo ou vazio, ele joga para a login screen
            GoToLoginScreen();
          }else{
            FirebaseAuth.instance.signInWithEmailAndPassword(email: Email, password: Senha).whenComplete((){
              GoToHome();
            });
          }
        }).onError((e){
          GoToLoginScreen();
        });
      }).catchError((error) async {
        if(delayOcorred == false){
          setState(() {
            loaderAviso = "Desculpe! Estamos tentando localizar o servidor! Isso pode demorar alguns minutos dependendo da qualidade da conexão de sua rede!";
            delayOcorred = true;
          });
        }
        initDB();
      });
      GetCPUGHz();
    }

    runFirebase() async {
      setState(() {
        iniciadoPrimeiro = true;
      });
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
      initDB();
    }

    if(iniciadoPrimeiro == false){
      runFirebase();
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            Container(
                padding: const EdgeInsets.all(16),
                child: Text(loaderAviso)
            )
          ],
        ),
      ),
    );
  }
}