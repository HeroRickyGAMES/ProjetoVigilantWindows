import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:xml/xml.dart';

//Programado por HeroRickyGAMES com a ajuda de Deus

XmlExport(Map mapXml, var context) async {
  var builder = XmlBuilder();
  builder.processing('xml', 'version="1.0" encoding="UTF-8"');
  builder.element('root', nest: () {
    mapXml.forEach((key, value) {
      builder.element(key, nest: value);
    });
  });
  final document = builder.buildDocument();
  var documento = document.toXmlString(pretty: true, indent: '  ');

  String? directoryPath = await FilePicker.platform.getDirectoryPath();

  if (directoryPath != null) {
    // Cria o caminho completo para o arquivo XML
    final file = File('$directoryPath/${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().hour}${DateTime.now().second}.xml');

    // Escreve o XML no arquivo escolhido
    await file.writeAsString(documento);
    print('XML salvo em: ${file.path}');
    showToast("XML salvo em: ${file.path}", context: context);
  } else {
    print('Nenhum diretório escolhido');
  }
}