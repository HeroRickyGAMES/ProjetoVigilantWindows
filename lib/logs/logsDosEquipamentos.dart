import 'dart:convert';
import 'package:clipboard/clipboard.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:vigilant/logs/identificacao.dart';
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:vigilant/logs/verificacaoLogHikvision.dart';
import 'package:vigilant/logs/xmlExport.dart';

//Programado por HeroRickyGames com a ajuda de Deus!

int searchNumbrs = 24;
bool primeira = true;
bool primeirapg = false;
bool jarodei = false;

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
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Aguarde... Como alguns equipamentos\nexistem muitos relatorios\nisso pode demorar mais do que o esperado.'),
            SizedBox(
              width: 50,
              height: 50,
              child: TextButton(onPressed: (){
                try{
                  Navigator.pop(context);
                  searchNumbrs = 24;
                  primeira = true;
                  primeirapg = false;
                  throw Exception("Task do script foi encerrada pelo usuario!");
                }catch(e){
                  showToast("$e",duration: const Duration(seconds: 7), context: context);
                }
              },
                  child: const Center(
                    child: Icon(
                      Icons.close,
                      size: 30,
                    ),
                  )
              ),
            )
          ],
        ),
        actions: const [
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      );
    },
  );

  try {
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
            "where": {
              "users": {},
              "groups": {},
              "time_zones": {},
              "access_logs": {
                "time": {
                  "<=": int.parse("${GetTimmeStampNow()}"),
                  ">=": 1722470400,
                },
              },
            },
            "order": ["descending", "time"],
            "object": "access_logs",
            "delimiter": ";",
            "line_break": "\r\n",
            "header": "",
            "file_name": "",
            "join": "LEFT",
            "columns": [
              {"field": "id", "object": "access_logs", "type": "object_field"},
              {"field": "time", "object": "access_logs", "type": "object_field"},
              {"field": "event", "object": "access_logs", "type": "object_field"},
              {"field": "id", "object": "users", "type": "object_field"},
              {"field": "name", "object": "users", "type": "object_field"},
              {"field": "registration", "object": "users", "type": "object_field"},
              {"field": "name", "object": "portals", "type": "object_field"},
              {"field": "name", "object": "time_zones", "type": "object_field"},
            ]
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

            final idsUnicos = lista.map((item) => item['id']).toSet().toList();
            final listaFiltrada = lista.where((item) => idsUnicos.contains(item['id'])).toList();

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
                            child: SmoothListView.builder(
                              itemCount: listaFiltrada.length,
                              cacheExtent: 1,
                              itemBuilder: (context, index) {
                                final item = listaFiltrada[index];
                                // Armazenando resultados de funções pesadas antes da criação do widget
                                final identificacaoValue = identificacao(item['identifier_id']);
                                final idValue = '${item['id']}';
                                final formattedTime = DateFormat('dd/MM/yyyy HH:mm:ss').format(
                                  DateTime.fromMillisecondsSinceEpoch(item['time'] * 1000),
                                );

                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  child: ListTile(
                                    title: Text('Identificação (Logs de Acesso): $identificacaoValue'),
                                    subtitle: Text('ID: $idValue'),
                                    trailing: Text('Hora: $formattedTime'),
                                  ),
                                );
                              }, duration: const Duration(seconds: 1),
                            )
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: ElevatedButton(
                              onPressed: (){
                                Map mapaTratado = {};
                                for (int i = 1; i < listaFiltrada.length; i++) {
                                  mapaTratado.addAll({
                                    "${listaFiltrada[i]['id']}":{
                                      "nome": identificacao(listaFiltrada[i]['identifier_id']),
                                      "data": DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(listaFiltrada[i]['time'] * 1000),),
                                      "id": "${listaFiltrada[i]['id']}"
                                    }
                                  });
                                  }
                                XmlExport(mapaTratado, context);
                              },
                              child: const Text('Exportar para XML')
                          ),
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
      final url = Uri.parse('http://$ip:$porta/cgi-bin/recordFinder.cgi?action=find&name=AccessControlCardRec&StartTime=${GetTimmeStampComMeses()}');

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

          final idsUnicos = lista.map((item) => item['id']).toSet().toList();
          final listaFiltrada = lista.where((item) => idsUnicos.contains(item['id'])).toList();

          print(listaFiltrada.length);


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
                          child: SmoothListView.builder(
                            itemCount: listaFiltrada.length,
                            itemBuilder: (context, index) {
                              listaFiltrada.sort((a, b) {
                                DateTime dateA = DateTime.fromMillisecondsSinceEpoch(a['CreateTime'] * 1000);
                                DateTime dateB = DateTime.fromMillisecondsSinceEpoch(b['CreateTime'] * 1000);
                                return dateB.compareTo(dateA);
                              });

                              final item = listaFiltrada[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                child: ListTile(
                                  title: Text('Acessado por: ${item['CardName'] == ''? "Liberado via API":  item['CardName']}'),
                                  trailing: Text('Hora: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(item['CreateTime'] * 1000))}'),
                                ),
                              );
                            },duration: const Duration(seconds: 1),
                          )
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                            onPressed: (){
                              Map mapaTratado = {};
                              for (int i = 1; i < listaFiltrada.length; i++) {
                                mapaTratado.addAll({
                                  "$i":{
                                    "nome": '${listaFiltrada[i]['CardName'] == ''? "Liberado via API":  listaFiltrada[i]['CardName']}',
                                    "data": DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(listaFiltrada[i]['CreateTime'] * 1000)),
                                    "id": "$i"
                                  }
                                });
                              }
                              XmlExport(mapaTratado, context);
                            },
                            child: const Text('Exportar para XML')
                        ),
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

      // URL do endpoint
      String url = 'http://$ip:$porta/ISAPI/AccessControl/AcsEvent?format=json&devIndex=0';

      // Credenciais
      String username = usuario;
      String password = Senha;

      // Realiza a primeira requisição para obter os dados do Digest Auth
      var response = await http.post(Uri.parse(url));
      var responseeByNumber = await http.post(Uri.parse(url));

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

        DateTime(DateTime.now().year, DateTime.now().month , DateTime.now().day, DateTime.now().hour, DateTime.now().minute, DateTime.now().second);

        Map<String, dynamic> bodynum = {
          "AcsEventCond": {
            "searchID": "1",
            "searchResultPosition": 24,
            "maxResults": 1000,
            "major": 0,
            "minor": 0,
            "startTime": "2023-01-01T01:00:00-07:00",
            "endTime": "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}T01:00:00-07:00"
          }
        };

        responseeByNumber = await http.post(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(bodynum)
        );

        if(responseeByNumber.statusCode == 200){
          Map<String, dynamic> jsonMape = jsonDecode(responseeByNumber.body);

          if(jarodei == false){
            searchNumbrs = 24;
            searchNumbrs = jsonMape['AcsEvent']['totalMatches'];
            jarodei = true;
          }
          print(searchNumbrs);
          Map<String, dynamic> body = {
            "AcsEventCond": {
              "searchID": "1",
              "searchResultPosition": searchNumbrs,
              "maxResults": 24,
              "major": 0,
              "minor": 0,
              "startTime": "2023-01-01T01:00:00-07:00",
              "endTime": "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}T23:59:59-00:00"
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

            final List<dynamic> listaFiltrada = jsonMap['AcsEvent']['InfoList'].reversed.toList();

            if(searchNumbrs < 25){
              print('1');
              Navigator.pop(context);
              Navigator.pop(context);
            }else{
              if(primeirapg == true){
                Navigator.pop(context);
                Navigator.pop(context);
                print('2');
              }else{
                if(primeira == true){
                  Navigator.pop(context);
                  print('3');
                }else{
                  print('4');
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              }
            }

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
                                    setState((){
                                      if(primeira == true){
                                        Navigator.pop(context);
                                        searchNumbrs = 24;
                                        primeira = true;
                                        primeirapg = false;
                                        jarodei = false;
                                      }else{
                                        Navigator.pop(context);
                                        searchNumbrs = 24;
                                        primeira = true;
                                        primeirapg = false;
                                        jarodei = false;
                                      }
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
                            child: SmoothListView.builder(
                              itemCount: listaFiltrada.length,
                              itemBuilder: (context, index) {
                                final item = listaFiltrada[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  child: ListTile(
                                    title: Text('${item['name']}' == "null" ? '${logtraduzido("${item['currentVerifyMode']}")}' : '${item['name']}' == ""? 'Sem nome' : "${item['name']}"),
                                    subtitle: Text('Indíce: ${item['serialNo']}'),
                                    trailing: Text('Hora: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.parse(item['time']))}'),
                                    ),
                                );
                              },duration: const Duration(seconds: 1),
                            )
                        ),
                        SizedBox(
                          width: wid / 2,
                          height: 100,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(onPressed:primeira == true ? null : (){
                                  setState((){
                                    searchNumbrs = searchNumbrs + 24;

                                    if(searchNumbrs > maxNumbers - 12){
                                      primeira = true;
                                      primeirapg = true;
                                    }
                                    LogsDosEquipamentos(context, ip, porta, usuario, Senha, modelo, wid, heig);
                                  });
                                },
                                    child: const Icon(Icons.navigate_before)
                                ),
                                ElevatedButton(onPressed: (){
                                  setState((){
                                    searchNumbrs = searchNumbrs - 24;
                                    primeira = false;
                                    primeirapg = false;
                                    LogsDosEquipamentos(context, ip, porta, usuario, Senha, modelo, wid, heig);
                                  });
                                },
                                    child: const Icon(Icons.navigate_next)
                                )
                              ]
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: ElevatedButton(
                              onPressed: (){
                                Map mapaTratado = {};
                                for (int i = 1; i < listaFiltrada.length; i++) {
                                  mapaTratado.addAll({
                                    "${listaFiltrada[i]['serialNo']}":{
                                      "nome": '${listaFiltrada[i]['name']}' == "null" ? '${logtraduzido("${listaFiltrada[i]['currentVerifyMode']}")}' : '${listaFiltrada[i]['name']}' == ""? 'Sem nome' : "${listaFiltrada[i]['name']}",
                                      "data": DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.parse(listaFiltrada[i]['time'])),
                                      "id": "${listaFiltrada[i]['serialNo']}"
                                    }
                                  });
                                }
                                XmlExport(mapaTratado, context);
                              },
                              child: const Text('Exportar essa pagina para XML')
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
            searchNumbrs = 24;
            primeira = true;
            primeirapg = false;
            jarodei = false;
            print('Erro na requisição: ${response.statusCode}');
            Navigator.pop(context);
            throw Exception('Erro na requisição: ${response.statusCode}');
          }

        }
      } else {
        searchNumbrs = 24;
        primeira = true;
        primeirapg = false;
        jarodei = false;
        print('Falha ao obter o header WWW-Authenticate');
        Navigator.pop(context);
        throw Exception('Falha ao obter o header WWW-Authenticate');
      }
    }

    if(modelo == "Modulo Guarita (Nice)"){
      Navigator.pop(context);
      showToast("Guarita não suporta log!", context: context);
    }

  }catch(e){
    String error = "$e resumindo, erro de comunicação com o equipamento, o relatorio do erro já foi copiado para sua area de transferencia! Mande para o desenvolvedor do app!";

    FlutterClipboard.copy(error);
    searchNumbrs = 24;
    primeira = false;
    showToast(duration: const Duration(seconds: 10), error, context: context);
  }
}

int GetTimmeStampComMeses() {
  // Obtém a data atual
  DateTime now = DateTime.now();

  DateTime sixMonthsAgo = DateTime(now.year, now.month , now.day - 7, now.hour, now.minute, now.second);

  // Converte a data para timestamp Unix (em segundos)
  return sixMonthsAgo.millisecondsSinceEpoch ~/ 1000;
}

int GetTimmeStampNow() {
  // Obtém a data atual
  DateTime now = DateTime.now();

  DateTime sixMonthsAgo = DateTime(now.year, now.month , now.day, now.hour, now.minute, now.second);

  // Converte a data para timestamp Unix (em segundos)
  return sixMonthsAgo.millisecondsSinceEpoch ~/ 1000;
}