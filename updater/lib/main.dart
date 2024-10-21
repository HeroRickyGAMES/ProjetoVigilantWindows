import 'dart:io';
import 'package:csharp_rpc/csharp_rpc.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:archive/archive.dart';
import 'package:intl/intl.dart';

//Desenvolvido por HeroRickyGAMES com a ajuda de Deus!

String downloadSpeed = "";

String totalBaixado = "";

String verificandoAtualizacoes = "Verificando se há atualizações";

bool primeiravez = false;

void main(){
  runApp(
    MaterialApp(
      home: const mainApp(),
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark
      ),
    )
  );
}


class mainApp extends StatefulWidget {
  const mainApp({super.key});

  @override
  State<mainApp> createState() => _mainAppState();
}

class _mainAppState extends State<mainApp> {
  @override
  Widget build(BuildContext context) {

    executarVigilant() async {
      String command = 'cd VigilantBinary ; ./vigilant.exe';
      await Process.run('powershell.exe', ["-c", command]);
    }

    executarcomClose() async {
      executarVigilant();
      await Future.delayed(const Duration(seconds: 3));
      exit(0);
    }


    downloadZip(String lastV) async {
      String urle = 'http://spartaserver.ddns.net:4003/vigilant/versions/main/vigilantV$lastV.zip';

      String localZipPath = 'vigilant$lastV.zip';

      try {
        // Baixa o arquivo ZIP
        final response = await http.Client().send(http.Request('GET', Uri.parse(urle)));
        if (response.statusCode == 200) {
          // Salva o arquivo ZIP localmente
          final File zipFile = File(localZipPath);

          int totalBytes = 0;
          final stopwatch = Stopwatch()..start();

          // Cria um sink para escrever os bytes no arquivo
          final fileSink = zipFile.openWrite();

          response.stream.listen((chunk){
            totalBytes += chunk.length;

            fileSink.add(chunk);
            // Calcula a velocidade de download
            double seconds = stopwatch.elapsed.inSeconds.toDouble();
            if (seconds > 0) {
              double speedKbps = (totalBytes * 8) / (10240 * seconds); // Total de bytes para Kbps
              // Converte para Mbps
              double speedMbps = speedKbps / 1024;
              setState(() {
                NumberFormat numberFormat = NumberFormat('###.#'); // Limitar a 1 casas decimais

                verificandoAtualizacoes = "";
                downloadSpeed = 'Velocidade de download: ${speedMbps.toStringAsFixed(2)} MB/s';
                totalBaixado = 'Total de megabytes baixados: ${numberFormat.format(totalBytes / 1048000)} MB';
              });
            }
          }, onDone: () async {
            await fileSink.flush();
            await fileSink.close();
            stopwatch.stop();
            // Lê o arquivo ZIP
            final List<int> bytes = zipFile.readAsBytesSync();
            final Archive archive = ZipDecoder().decodeBytes(bytes);

            // Extrai o conteúdo do ZIP
            for (final ArchiveFile file in archive) {
              final String filename = file.name;
              if (file.isFile) {
                // Cria o arquivo e escreve o conteúdo
                final List<int> data = file.content as List<int>;
                final File outfile = File(filename);
                await outfile.writeAsBytes(data);
              } else {
                // Cria diretórios se necessário
                await Directory(filename).create(recursive: true);
              }
            }
            setState(() {
              verificandoAtualizacoes = 'Versão atualizada para: $lastV';
              downloadSpeed = '';
              totalBaixado = '';
            });
            final file = File('vigilantV$lastV.zip');

            if (await file.exists()) {
              try {
                await file.delete();
                //print("Arquivo deletado com sucesso!");
              } catch (e) {
                //print("Erro ao deletar o arquivo: $e");
              }
            } else {
              //print("O arquivo não existe.");
            }
            executarcomClose();
          });

        } else {
          print('Erro ao baixar o arquivo: ${response.statusCode}');
        }
      } catch (e) {
        print('Erro: $e');
      }
    }

    verificarAtualizacao() async {
      verificandoAtualizacoes = "Verificando se há atualizações";
      String url = 'http://spartaserver.ddns.net:4003/vigilant/versions/main/vigilant/VigilantBinary/version.txt';
      String localFilePath = 'VigilantBinary/version.txt'; // Caminho do arquivo local
      try{
        // Obtém a versão do site
        final response = await http.get(Uri.parse(url));

        if(response.statusCode == 200){
          String latestVersion = response.body.trim();

          // Lê a versão atual do arquivo local
          String currentVersion = '';
          if (await File(localFilePath).exists()) {
            currentVersion = await File(localFilePath).readAsString();

            // Compara as versões
            if (currentVersion != latestVersion) {
              try{
                final dir = Directory('VigilantBinary');
                if(await dir.exists()){
                  dir.deleteSync(recursive: true);
                  downloadZip(latestVersion);
                }

              }catch(e){
                print(e);
              }
            } else {
              setState(() {
                verificandoAtualizacoes = 'A versão já está atual: $currentVersion';
              });
              executarcomClose();
            }
          }else{
            downloadZip(latestVersion);
          }
        }

      }catch(e){
        print(e);
      }
    }

    if(primeiravez == false){
      verificarAtualizacao();
    }

    primeiravez = true;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Verificador de atualizações",
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(verificandoAtualizacoes),
            Text(downloadSpeed),
            Text(totalBaixado),
            Container(
                padding: const EdgeInsets.all(16),
                child: const CircularProgressIndicator())
          ],
        ),
      ),
    );
  }
}
