import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:vigilant/homeApp.dart';
import 'package:vigilant/tags/tag.dart';

//Programado por HeroRickyGAMES

tagAlertControlid(var context, String ip, int porta, String usuario, String Senha, int userID){
  String nome = "";
  String TAG = "";
  String WG = "";

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
        return AlertDialog(
          title: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Cadastro da TAG Control iD'),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      enableSuggestions: false,
                      autocorrect: false,
                      onChanged: (value){
                        setState(() {
                          nome = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(
                            color: textAlertDialogColor,
                            backgroundColor: Colors.white
                        ),
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3,
                              color: Colors.black
                          ),
                        ),
                        labelText: 'Nome',
                      ),
                      style: TextStyle(
                          color: textAlertDialogColor
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
                          TAG = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(
                            color: textAlertDialogColor,
                            backgroundColor: Colors.white
                        ),
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3,
                              color: Colors.black
                          ),
                        ),
                        labelText: 'TAG HEX',
                      ),
                      style: TextStyle(
                          color: textAlertDialogColor
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
                          WG = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(
                            color: textAlertDialogColor,
                            backgroundColor: Colors.white
                        ),
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.black), //<-- SEE HERE
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3,
                              color: Colors.black
                          ),
                        ),
                        labelText: 'TAG WG',
                      ),
                      style: TextStyle(
                          color: textAlertDialogColor
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: (){
                      if(TAG == ""){
                        showToast("O campo da TAG está vazio!", context: context);
                      }else{
                        if(WG == ""){
                          showToast("O campo da WG está vazio!", context: context);
                        }else{
                          showDialog(
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
                          criarCard(context, ip, porta, usuario, Senha, userID, WG, false, nome);
                        }
                      }
                    },
                    child: const Text('Cadastro da TAG')
                )
              ],
            ),
          ),
          scrollable: true,
        );
      },
      );
    },
  );
}