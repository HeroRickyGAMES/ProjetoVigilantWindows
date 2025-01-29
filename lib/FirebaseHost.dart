import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

//Programado por HeroRickyGames com ajuda de Deus!

//Produção
String host = "spartaserver.ddns.net";
int Authport = 4001;
int Dbport = 4002;

//Homologação
//String host = "192.168.3.214";
//int Authport = 4001;
//int Dbport = 4002;

initFirestore(){
  FirebaseFirestore.instance.settings = Settings(
    host: '$host:$Dbport',
    sslEnabled: false,
    persistenceEnabled: false,
  );
}

initAuth(){
  FirebaseAuth.instance.useAuthEmulator(host, Authport);
}

//carregarImagemTester(var context, File _imagefile, String ID, String idCondominio){
//
//  String filename =  '$ID$idCondominio${basename(_imagefile.path)}';
//  String urli = 'http://$host:$Storageport/v0/b/sparta-monitoramento.appspot.com/o?name=$filename';
//  var fileBytes = await _imagefile.readAsBytes();
//
//  var uri = Uri.parse(urli);
//
//  // Detectar o tipo MIME do arquivo
//  var mimeType = lookupMimeType(_imagefile.path) ?? 'application/octet-stream';
//
//  var metadata = {
//    'name': filename,
//    'contentType': 'image/jpeg'
//  };
//
//  // Criar o multipart request
//  var request = http.MultipartRequest('POST', uri)
//    ..headers.addAll({
//      'Accept': '*/*',
//      'Connection': 'keep-alive',
//    })
//    ..fields['metadata'] = metadata.toString()  // Enviar metadados
//    ..files.add(http.MultipartFile.fromBytes(
//      'file',
//      fileBytes,
//      filename: filename,
//      contentType: MediaType('image', 'jpeg'),
//    ));
//
//  // Enviar a requisição
//  var response = await request.send();
//
//  // Verificar a resposta
//  if (response.statusCode == 200) {
//    print('Upload bem-sucedido!');
//    String urisAfter = "http://$host:$Storageport/v0/b/sparta-monitoramento.appspot.com/o/images_$filename?alt=media";
//    return urisAfter;
//  } else {
//    print('Falha no upload: ${response.statusCode}');
//    return '';
//  }
//}

carregarImagem(var context, File _imagefile, String ID, String idCondominio) async {
  FirebaseStorage storage = FirebaseStorage.instance;

  //SetServer
  //storage.useStorageEmulator(host, Storageport);

  Reference ref = storage.ref().child('images/$idCondominio/$ID');
  await ref.putFile(_imagefile).whenComplete(() {
    showToast("Imagem carregada!",context:context);
  }).catchError((e){
    showToast("Houve uma falha no carregamento! codigo do erro: $e",context:context);
    showToast("Repasse esse erro para o desenvolvedor!",context:context);
  });
  return ref.getDownloadURL();
}