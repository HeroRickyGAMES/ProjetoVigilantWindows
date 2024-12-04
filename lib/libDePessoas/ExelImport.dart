import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:vigilant/homeApp.dart';
import 'package:vigilant/intRamdom/intRamdom.dart';

//Programado por HeroRickyGAMES com a ajuda de Deus

void ImportarExel(var context) async {
  showToast("O tipo de arquivo suportado é apenas xlsx!",context:context);
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xlsx'],
  );
  if (result != null) {
    File file = File(result.files.single.path!);
    var bytes = file.readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table];
      if (sheet != null) {
        for (var i = 1; i < sheet.rows.length; i++) {
          var row = sheet.rows[i];
          Map<String, dynamic> userMap = {
            for (int j = 0; j < row.length; j++) 'coluna_$j': row[j]?.value,
          };

          Map<String, dynamic> tratado = {
            'Nome': "${userMap['coluna_2']}",
            'Celular': "${userMap['coluna_5']}",
            'email': "${userMap['coluna_8']}",
            'CPF': "${userMap['coluna_7']}",
            'tipo': "${userMap['coluna_9']}".replaceAll(" ", "").replaceAll("-", "").replaceAll("0", "").replaceAll("1", "").replaceAll("2", "").replaceAll("3", "").replaceAll("4", "").replaceAll("5", "").replaceAll("6", "").replaceAll("7", "").replaceAll("8", "").replaceAll("9", ""),
            'anotacao': "",
            'Bloco': "",
            'id': "${gerarNumero()}$idCondominio",
            'idCondominio': idCondominio,
            'imageURI': "",
            'placa': "",
            'Qualificacao': "",
            'RG': "${userMap['coluna_7']}",
            'Telefone': "",
            'Unidade': "",
          };

          FirebaseFirestore.instance.collection("Pessoas").doc(tratado['id']).set(
              tratado
          ).whenComplete((){
            showToast("Importado para o banco de dados!", context: context);
          });


        }
      }
    }
  } else {
    showToast("Nenhum arquivo selecionado.", context: context);
  }
}
