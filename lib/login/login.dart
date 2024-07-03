import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vigilant/cadastro/cadastro.dart';
import 'package:vigilant/homeApp.dart';

//Desenvolvido por HeroRickyGames

//Strings
String Email = "";
String Senha = "";

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {

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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
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
              child: ElevatedButton(onPressed: () async {

                if(Email == ''){

                  showToast("Preencha seu email!",context:context);

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
                    FirebaseAuth.instance.signInWithEmailAndPassword(email: Email, password: Senha).catchError((e){
                      onError = true;
                      Navigator.pop(context);
                      showToast("Ocorreu um erro: $e",context:context);

                    }).whenComplete(() async {
                      if(onError == false){
                        final SharedPreferences prefs = await SharedPreferences.getInstance();

                        await prefs.setString('email', Email);
                        await prefs.setString('senha', Senha);

                        irParaTelaMain();
                      }
                    });
                  }
                }
              },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: colorBtn
                  ),
                  child: Text(
                    'Logar',
                    style: TextStyle(
                        color: textColor
                    ),
                  )
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Você ainda não tem uma conta? '),
                  TextButton(onPressed: (){
                    Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context){
                            return const Cadastrese();
                          }
                        )
                    );
                  }, child: const Text('Crie uma agora!')
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
