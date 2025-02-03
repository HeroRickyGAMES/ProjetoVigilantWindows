import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

//Programado por HeroRickyGAMES com a ajuda de Deus!

Future<File> downloadImage(String imageUrl, String id) async {
  try {
    // Obtém o diretório temporário
    Directory tempDir = await getTemporaryDirectory();
    String filePath = '${tempDir.path}/downloaded_image$id.jpg';

    // Faz o download da imagem
    await Dio().download(imageUrl, filePath);

    // Retorna o arquivo salvo
    return File(filePath);
  } catch (e) {
    print('Erro ao baixar a imagem: $e');
    return Future.error('Erro ao baixar a imagem');
  }
}
