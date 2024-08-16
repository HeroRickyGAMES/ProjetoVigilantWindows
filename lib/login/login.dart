import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vigilant/getIds.dart';
import 'package:vigilant/homeApp.dart';

//Desenvolvido por HeroRickyGames

//Strings
String Username = "";
String Senha = "";

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {

  irParaTelaMain(){
    setState(() {
      UID = FirebaseAuth.instance.currentUser?.uid;
      deslogando = false;
    });
    Get.to(const homeApp());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/metalbg.png'),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/VigilantLogoLogin.png"),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 500,
                          padding: const EdgeInsets.only(left: 10, right: 100),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(bottom: 7, left: 7),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Login",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextField(
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.emailAddress,
                                enableSuggestions: false,
                                autocorrect: false,
                                onChanged: (value){
                                  setState(() {
                                    Username = value;
                                  });
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                    filled: true,
                                    fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 3, color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Colors.black
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 500,
                          padding: const EdgeInsets.only(left: 100, right: 10, top: 20),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(bottom: 7, left: 7),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Senha",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextField(
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.visiblePassword,
                                enableSuggestions: false,
                                autocorrect: false,
                                obscureText: true,
                                onChanged: (value){
                                  setState(() {
                                    Senha = value;
                                  });
                                },
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 3, color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                    color: Colors.black
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 15, top: 20),
                            child: TextButton(onPressed: () async {
                              if(Username == ''){
                                showToast("Preencha seu Login!",context:context);
                                var ReadTest = await FirebaseFirestore.instance
                                    .collection("test")
                                    .doc("test").get();

                                print(ReadTest["test"]);
                              }else{
                                if(Senha == ''){

                                  showToast("Preencha sua senha!",context:context);

                                }else{
                                  showDialog(
                                    barrierDismissible: true,
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
                                  bool onError = false;

                                  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("Users").where("username", isEqualTo: Username).get();

                                  if(snapshot.docs.isEmpty){
                                    showToast("Não foi encontrado nenhum usuario com esse Login!",context:context);
                                    Navigator.pop(context);
                                  }else{
                                    String email = snapshot.docs[0].get("Email");
                                    String pass = snapshot.docs[0].get("Senha");

                                    if(Senha == pass){
                                      FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: Senha).catchError((e){
                                        onError = true;
                                        Navigator.pop(context);
                                        showToast("Ocorreu um erro: $e",context:context);

                                      }).whenComplete(() async {
                                        if(onError == false){
                                          final SharedPreferences prefs = await SharedPreferences.getInstance();

                                          await prefs.setString('email', email);
                                          await prefs.setString('senha', Senha);

                                          irParaTelaMain();
                                        }
                                      });
                                    }else{
                                      showToast("A senha está incorreta!",context:context);
                                      Navigator.pop(context);
                                    }
                                  }
                                }
                              }
                            },
                                child: Image.asset(
                                    "assets/botton 9.png",
                                  scale: 5,
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
