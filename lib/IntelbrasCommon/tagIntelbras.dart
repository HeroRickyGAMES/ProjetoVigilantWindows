import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:vigilant/acionamento_de_portas/acionamento_de_portas.dart';
import 'package:vigilant/homeApp.dart';
import 'package:http_auth/http_auth.dart';

//Programado por HeroRickyGAMES com a ajuda de Deus!

String ip = "";
String port = "";

intelbrasTagAlert(var context, String host, int porta, String user, String senha, int userID){

  String CardNo = "";

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
        return Center(
          child: AlertDialog(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Cadastro de TAG Intelbras'),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      enableSuggestions: false,
                      autocorrect: false,
                      onChanged: (value){
                        setState(() {
                          CardNo = value;
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
                        labelText: 'Numero da TAG',
                      ),
                      style: TextStyle(
                          color: textAlertDialogColor
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      if(CardNo == ""){
                        showToast("O campo da TAG estpa vazia!",context:context);
                      }else{

                        String? hexadecimalConverter = int.tryParse(CardNo)?.toRadixString(16);

                        Map<String, String> headers = {
                          'Accept': '*/*',
                          'Accept-Encoding': 'gzip, deflate, br',
                          'Connection': 'keep-alive',
                        };

                        var body = {
                          "CardList": [
                            {
                              "UserID": "$userID",
                              "CardNo": hexadecimalConverter,
                              "CardType": 0,
                              "CardStatus": 0,
                            }
                          ]
                        };
                        final client = DigestAuthClient(user, senha);

                        try {
                          final response = await client.post(
                            Uri.parse("http://$host:$porta/cgi-bin/AccessCard.cgi?action=insertMulti"),
                            headers: headers,
                            body: jsonEncode(body),
                          );

                          if (response.statusCode == 200) {
                            FirebaseFirestore.instance.collection("TAG").doc(UUID).set({
                              "identificacao": hexadecimalConverter,
                              "modelo": "Intelbras",
                              "tagNumber": CardNo,
                              "UserID": "$userID",
                              "id": UUID,
                              "ipAcionamento": host,
                              "portAcionamento": porta,
                              "userAcionamento": user,
                              "passAcionamento": senha,
                            });

                            showToast("Cadastrado!",context:context);
                            Navigator.pop(context);
                            print('Response: ${response.body}');
                          } else {
                            showToast("Ocorreu um erro! ${response.statusCode}",context:context);
                          }
                        } catch (e) {
                          print('Error: $e');
                        }
                      }
                    },
                    child: const Text('Salvar')
                )
              ],
            ),
            scrollable: true,
          ),
        );
      },
      );
    },
  );
}