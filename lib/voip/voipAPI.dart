import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:record/record.dart';
import 'package:sip_ua/sip_ua.dart';

//Programado por HeroRickyGames

//Inteiros
int minutos = 00;
int segundos = 00;

//StopWatch
var stopwatch = Stopwatch();

//Booleanos
bool voiceOnly = false;

//Holper
final SIPUAHelper helper = SIPUAHelper();

//Estado
late RegistrationState registerState;

//Microfone
final record = AudioRecorder();

//Nesse trexo ele conecta ao VoIP.
ConnectVoIP(var context) async {

  String displayName = "Flutter SIP UA";
  String authUser = "2206";
  String Porta = "5060";
  String SIPUrl = "$authUser@sip2.vtcall.com.br";
  String authSenha = "w0VxAqSG4e23";

  registerState = helper.registerState;

  UaSettings settings = UaSettings();

  settings.port = Porta;
  settings.webSocketSettings.extraHeaders = {
  };
  settings.webSocketSettings.allowBadCertificate = true;
  settings.tcpSocketSettings.allowBadCertificate = true;
  settings.transportType = TransportType.TCP;
  settings.uri = SIPUrl;
  settings.webSocketUrl = SIPUrl;
  settings.host = SIPUrl.split('@')[1];
  settings.authorizationUser = authUser;
  settings.password = authSenha;
  settings.displayName = displayName;
  settings.userAgent = 'Dart SIP Client v1.0.0';
  settings.dtmfMode = DtmfMode.RFC2833;
  settings.contact_uri = 'sip:$SIPUrl';


  helper.start(settings).whenComplete((){
    showToast("Conectado ao VoIP!",context:context);
  });
}

startCall(var context, String ramal) async {
  ConnectVoIP(context);

  var stream;

  final mediaConstraints = <String, dynamic>{
    'audio': true,
    'video': {
      'width': '1280',
      'height': '720',
      'facingMode': 'user',
    }
  };

  mediaConstraints['video'] = false;
  MediaStream userStream =
  await navigator.mediaDevices.getUserMedia(mediaConstraints);

  if (await record.hasPermission()) {
  stream = await record.startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
  }
  await helper.call(ramal, voiceonly: true, mediaStream: userStream);


  showDialog(
    context: context,
    builder: (BuildContext context) {
      stopwatch.start();
      return StatefulBuilder(builder: (BuildContext context, StateSetter setState){

        setarMineSecs() async {
          setState((){
            minutos = stopwatch.elapsed.inSeconds ~/ 60;
            segundos = stopwatch.elapsed.inSeconds % 60;

          });
          await Future.delayed(const Duration(seconds: 1));
          setarMineSecs();
        }

        setarMineSecs();
        if(helper.connected == false){
          showToast("Houve algum problema na chamada!\nTente ver se o ramal está digitado corretamente!",context:context);
          showToast("Se o problema continuar contate o desenvolvedor!",context:context);
          stopTransmission(context);
        }

        return AlertDialog(
          title: const Text('Chamada'),
          actions: [
            Center(
              child: Column(
                children: [
                  Text(ramal),
                  Text("$minutos:$segundos"),
                  IconButton(onPressed: (){
                    stopTransmission(context);
                  },
                      icon: const Icon(Icons.call_end)
                  )
                ],
              ),
            )
          ],
        );
      },);
    },
  );

}

stopTransmission(var context){
  minutos = 00;
  segundos = 00;
  helper.stop();
  record.stop();
  stopwatch.reset();
  Navigator.pop(context);
}