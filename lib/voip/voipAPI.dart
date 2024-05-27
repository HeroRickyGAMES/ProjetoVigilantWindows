import 'dart:io';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sip_ua/sip_ua.dart';

//Programado por HeroRickyGames

bool voiceOnly = false;

//Nesse trexo ele conecta ao VoIP.
ConnectVoIP(){
  String displayName = "Flutter SIP UA";
  String authUser = "2206";
  String Porta = "5060";
  String SIPUrl = "$authUser@sip2.vtcall.com.br";
  String authSenha = "w0VxAqSG4e23";

  final SIPUAHelper helper = SIPUAHelper();
  late RegistrationState registerState;
  registerState = helper.registerState;
  //helper.addSipUaHelperListener(context);

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
  settings.contact_uri = 'sip:${SIPUrl}';


  helper.start(settings);
}

useVoIP() async {

  ConnectVoIP();
  if(Platform.isWindows){
    await Permission.microphone.request();
  }
  final mediaConstraints = <String, dynamic>{
    'audio': true,
    'video': {
      'width': '1280',
      'height': '720',
      'facingMode': 'user',
    }
  };

  MediaStream mediaStream;

  if(!voiceOnly){
    //mediaStream =
    //await navigator.mediaDevices.getDisplayMedia(mediaConstraints);
    MediaStream userStream =
    await navigator.mediaDevices.getUserMedia(mediaConstraints);
    final audioTracks = userStream.getAudioTracks();
    if (audioTracks.isNotEmpty) {
      //mediaStream.addTrack(audioTracks.first, addToNative: true);
    }
  }


}