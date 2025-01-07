import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;
import 'package:vigilant/logs/identificacao.dart';
import 'package:http_auth/http_auth.dart' as http_auth;

//Programado por HeroRickyGames com a ajuda de Deus!

int searchNumbrs = 24;

Map<String, String> _parseDigestHeader(String header) {
  final Map<String, String> authData = {};
  final regExp = RegExp(r'(\w+)=["]?([^",]+)["]?');
  regExp.allMatches(header).forEach((match) {
    authData[match.group(1)!] = match.group(2)!;
  });
  return authData;
}

String _generateDigestAuth(Map<String, String> authData, String username, String password, String method, String uri) {
  final ha1 = md5.convert(utf8.encode('$username:${authData["realm"]}:$password')).toString();
  final ha2 = md5.convert(utf8.encode('$method:$uri')).toString();
  final response = md5.convert(utf8.encode('$ha1:${authData["nonce"]}:$ha2')).toString();

  return 'Digest username="$username", realm="${authData["realm"]}", nonce="${authData["nonce"]}", uri="$uri", response="$response"';
}


List<Map<String, dynamic>> intelbrasToMap(String response) {
  Map<String, dynamic> result = {};
  List<String> lines = response.split('\n'); // Quebrar a string em linhas

  for (String line in lines) {
    if (line.trim().isEmpty) continue; // Ignorar linhas vazias
    List<String> parts = line.split('='); // Separar chave e valor
    String key = parts[0].trim(); // Chave
    String value = parts.length > 1 ? parts[1].trim() : ''; // Valor (ou vazio)

    // Tentar converter o valor para tipos apropriados
    if (value == 'true') {
      result[key] = true;
    } else if (value == 'false') {
      result[key] = false;
    } else if (int.tryParse(value) != null) {
      result[key] = int.parse(value);
    } else if (double.tryParse(value) != null) {
      result[key] = double.parse(value);
    } else {
      result[key] = value; // Manter como string
    }
  }

  List<Map<String, dynamic>> restructureRecords(Map<String, dynamic> map) {
    Map<int, Map<String, dynamic>> groupedRecords = {};

    map.forEach((key, value) {
      if (key.startsWith('records[')) {
        // Extrai o índice e o campo
        final match = RegExp(r'records\[(\d+)\]\.(.+)').firstMatch(key);
        if (match != null) {
          int index = int.parse(match.group(1)!);
          String field = match.group(2)!;

          // Adiciona ao Map agrupado
          groupedRecords.putIfAbsent(index, () => {});
          groupedRecords[index]![field] = value;
        }
      }
    });

    // Converte para uma lista
    return groupedRecords.values.toList();
  }

  // Chama a função
  List<Map<String, dynamic>> recordsList = restructureRecords(result);

  return recordsList;
}

LogsDosEquipamentos(var context, String ip, int porta, String usuario, String Senha, String modelo, double wid, double heig) async {
  
  showDialog(
    barrierDismissible: false,
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
  
  if(modelo == "Control iD"){
    final ipog = Uri.parse('http://$ip:$porta/login.fcgi');

    Map<String, String> headerslog = {
      "Content-Type": "application/json"
    };

    Map<String, dynamic> bodylog = {
      "login": usuario,
      "password": Senha
    };
    try{
      final response = await http.post(
        ipog,
        headers: headerslog,
        body: jsonEncode(bodylog),
      );
      if(response.statusCode == 200){
        Map<String, dynamic> responseData = jsonDecode(response.body);

        final url = Uri.parse('http://$ip:$porta/load_objects.fcgi?session=${responseData["session"]}');

        Map<String, dynamic> body = {
          "object": "access_logs"
        };

        Map<String, String> headers = {
          "Content-Type": "application/json"
        };

        final responsee = await http.post(
          url,
          headers: headers,
          body: jsonEncode(body),
        );
        if (responsee.statusCode == 200) {

          Map<String, dynamic> jsonMap = jsonDecode(responsee.body);
          final List<dynamic> lista = jsonMap['access_logs'];

          final idsUnicos = lista.map((item) => item['id']).toSet().toList().reversed.toList();
          final listaFiltrada = lista.where((item) => idsUnicos.contains(item['id'])).toList().reversed.toList();

          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                return AlertDialog(
                  title: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Relatorio de eventos'),
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: TextButton(onPressed: (){
                                  Navigator.pop(context);
                                },
                                    child:const Center(
                                      child: Icon(
                                        Icons.close,
                                        size: 30,
                                      ),
                                    )
                                ),
                              )
                            ],
                          )
                      ),
                        SizedBox(
                          width: wid / 2,
                          height: heig / 2,
                            child: ListView.builder(
                              itemCount: listaFiltrada.length,
                              itemBuilder: (context, index) {
                                final item = listaFiltrada[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  child: ListTile(
                                    title: Text('Identificação (Logs de Acesso): ${identificacao(item['identifier_id'])}'),
                                    subtitle: Text('ID: ${item['id']}'),
                                    trailing: Text('Hora: ${DateTime.fromMillisecondsSinceEpoch(item['time'] * 1000)}'),
                                  ),
                                );
                              },
                            )
                        )
                    ],
                  ),
                  scrollable: true,
                );
              },
              );
            },
          );

        } else {
          print(responsee.statusCode);
        }
      }else{
        showToast("Erro com a comunicação, status: ${response.statusCode}", context: context);
      }
    }catch(e){
      showToast("Erro ao executar a requisição: $e", context: context);
    }
  }

  if(modelo == "Intelbras"){
    final url = Uri.parse('http://$ip:$porta/cgi-bin/recordFinder.cgi?action=find&name=AccessControlCardRec');

    Map<String, String> headers = {
      'Accept': '*/*',
      'Accept-Encoding': 'gzip, deflate, br',
      'Connection': 'keep-alive',
      "Content-Type": "application/json"
    };

    final client = http_auth.DigestAuthClient(usuario, Senha);

    try {
      final response = await client.get(url, headers: headers);

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> listadeUsuarios = intelbrasToMap(response.body);
        final List<dynamic> lista = listadeUsuarios;

        final idsUnicos = lista.map((item) => item['id']).toSet().toList().reversed.toList();
        final listaFiltrada = lista.where((item) => idsUnicos.contains(item['id'])).toList().reversed.toList();


        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
              return AlertDialog(
                title: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Relatorio de eventos'),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: TextButton(onPressed: (){
                                Navigator.pop(context);
                              },
                                  child:const Center(
                                    child: Icon(
                                      Icons.close,
                                      size: 30,
                                    ),
                                  )
                              ),
                            )
                          ],
                        )
                    ),
                    SizedBox(
                        width: wid / 2,
                        height: heig / 2,
                        child: ListView.builder(
                          itemCount: listaFiltrada.length,
                          itemBuilder: (context, index) {
                            final item = listaFiltrada[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              child: ListTile(
                                title: Text('Acessado por: ${item['CardName'] == ''? "Liberado via API":  item['CardName']}'),
                                trailing: Text('Hora: ${DateTime.fromMillisecondsSinceEpoch(item['CreateTime'] * 1000)}'),
                              ),
                            );
                          },
                        )
                    )
                  ],
                ),
                scrollable: true,
              );
            },
            );
          },
        );

      } else {
        showToast("Erro com a comunicação, status: ${response.statusCode}",context:context);
      }
    } catch (e) {
      showToast("Erro ao executar a requisição: $e",context:context);
    }
  }

  if(modelo == "Hikvision"){

    int maxNumbers = 00;
    double multiplicador = 00;
    List lista = [];

    // URL do endpoint
    String url = 'http://$ip:$porta/ISAPI/AccessControl/AcsEvent?format=json&devIndex=0';

    // Credenciais
    String username = usuario;
    String password = Senha;

    // Realiza a primeira requisição para obter os dados do Digest Auth
    var response = await http.post(Uri.parse(url));
    if (response.statusCode == 401 && response.headers['www-authenticate'] != null) {
      final authHeader = response.headers['www-authenticate'];

      // Extrai os valores do header de autenticação
      final authData = _parseDigestHeader(authHeader!);
      final digestAuth = _generateDigestAuth(authData, username, password, 'POST', url);

      // Cabeçalhos com autenticação Digest
      final headers = {
        'Authorization': digestAuth,
        'Content-Type': 'application/json',
      };

      //print(searchNumbrs);
      Map<String, dynamic> body = {
        "AcsEventCond": {
          "searchID": "1",
          "searchResultPosition": searchNumbrs,
          "maxResults": 1000,
          "major": 0,
          "minor": 0,
          "startTime": "2023-01-01T01:00:00-07:00",
          "endTime": "2030-08-29T23:59:59-07:00"
        }
      };

      // Requisição POST com a autenticação Digest
      response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body)
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = jsonDecode(response.body);
        maxNumbers = jsonMap['AcsEvent']['totalMatches'];
        multiplicador = maxNumbers / 24;
        int arredondarUp = multiplicador.ceil();

        for(int i = 0; i < arredondarUp; i++){
          lista.add(i);
        }

        print(searchNumbrs);
        print(maxNumbers);
        final List<dynamic> listaFiltrada = jsonMap['AcsEvent']['InfoList'];

        Navigator.pop(context);
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
              return AlertDialog(
                scrollable: true,
                title: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Relatorio de eventos'),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: TextButton(onPressed: (){
                                Navigator.pop(context);
                                
                                setState((){
                                  searchNumbrs = 24;
                                });
                              },
                                  child:const Center(
                                    child: Icon(
                                      Icons.close,
                                      size: 30,
                                    ),
                                  )
                              ),
                            )
                          ],
                        )
                    ),
                    SizedBox(
                        width: wid / 2,
                        height: heig / 2,
                        child: ListView.builder(
                          itemCount: listaFiltrada.length,
                          itemBuilder: (context, index) {
                            final item = listaFiltrada[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              child: ListTile(
                                title: Text('type: ${item['type']}'),
                                subtitle: Text('serialNo: ${item['serialNo']}'),
                                trailing: Text('Hora: ${item['time']}'),
                              ),
                            );
                          },
                        )
                    ),
                    SizedBox(
                      width: wid / 2,
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(onPressed:
                          searchNumbrs == 24 ? null : (){
                            setState((){
                              searchNumbrs = searchNumbrs - 24;
                              Navigator.pop(context);
                              LogsDosEquipamentos(context, ip, porta, usuario, Senha, modelo, wid, heig);
                            });
                          },
                              child: const Icon(Icons.navigate_before)
                          ),
                          ElevatedButton(onPressed: searchNumbrs > maxNumbers - 12?
                          null:
                              (){
                            setState((){
                              searchNumbrs = searchNumbrs + 24;
                              Navigator.pop(context);
                              LogsDosEquipamentos(context, ip, porta, usuario, Senha, modelo, wid, heig);
                            });
                          },
                              child: const Icon(Icons.navigate_next)
                          )
                        ]
                      ),
                    )
                  ],
                ),
              );
            },
            );
          },
        );
      } else {
        print('Erro na requisição: ${response.statusCode}');
        throw Exception('Erro na requisição: ${response.statusCode}');
      }
    } else {
      print('Falha ao obter o header WWW-Authenticate');
      throw Exception('Falha ao obter o header WWW-Authenticate');
    }
  }

  if(modelo == "Modulo Guarita (Nice)"){
    Navigator.pop(context);
    showToast("Guarita não suporta log!", context: context);
  }
}