import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:vigilant/getIds.dart';
import 'package:vigilant/homeApp.dart';

//Desenvolvido por HeroRickyGames com ajuda de Deus!

//Strings
String Email = "";
String Senha = "";
String CNPJ = "";
String nomeEmpresa = "";

class Cadastrese extends StatefulWidget {
  const Cadastrese({super.key});

  @override
  State<Cadastrese> createState() => _CadastreseState();
}

class _CadastreseState extends State<Cadastrese>{

  irParaTelaMain(){
    Navigator.pop(context);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context){
          return const homeApp();
        })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  enableSuggestions: false,
                  autocorrect: false,
                  onChanged: (value){
                    setState(() {
                      Email = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.grey), //<-- SEE HERE
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3,
                          color: Colors.black
                      ),
                    ),
                    labelText: 'Email',
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: TextField(
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
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.grey), //<-- SEE HERE
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3,
                          color: Colors.black
                      ),
                    ),
                    labelText: 'Senha',
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  enableSuggestions: false,
                  autocorrect: false,
                  onChanged: (value){
                    setState(() {
                      nomeEmpresa = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.grey), //<-- SEE HERE
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3,
                          color: Colors.black
                      ),
                    ),
                    labelText: 'Nome da Empresa',
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  enableSuggestions: false,
                  autocorrect: false,
                  onChanged: (value){
                    setState(() {
                      CNPJ = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.grey), //<-- SEE HERE
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3,
                          color: Colors.black
                      ),
                    ),
                    labelText: 'CNPJ',
                  ),
                ),
              ),
            ),
            ElevatedButton(onPressed:(){
              if(Email == ""){
                showToast("Preencha o email!",context:context);
              }else{
                if(Senha == ""){
                  showToast("Preencha a Senha!",context:context);
                }else{
                  if(CNPJ == ""){
                    showToast("Preencha o CNPJ",context:context);
                  }else{
                    if(nomeEmpresa == ""){
                      showToast("Preencha o Nome da Empresa!",context:context);
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
                      FirebaseAuth.instance.createUserWithEmailAndPassword(email: Email, password: Senha).whenComplete(() {
                        FirebaseFirestore.instance.collection('Users').doc(UID).set({
                          "Email": Email,
                          "CNPJ": CNPJ,
                          "nomeEmpresa": nomeEmpresa,
                          "UID": UID
                        }).whenComplete(() {
                           irParaTelaMain();
                        });
                      });
                    }
                  }
                }
              }
            },style: ElevatedButton.styleFrom(
                backgroundColor: colorBtn
            ),
                child: Text(
                    'Cadastrar-se',
                  style: TextStyle(
                    color: textColor
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
