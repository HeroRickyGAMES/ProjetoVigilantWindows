import 'package:device_info_plus/device_info_plus.dart';

//Programado por HeroRickyGAMES com a ajuda de Deus!

GetCPUGHz() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  print("Windowsinfo${await deviceInfoPlugin.windowsInfo}");
}

Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
  //print("Windows info${data.}");
  return <String, dynamic>{
    'userName': data.userName,
  };
}


//Future<String> getWindowsInfo() async {
//  return _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo)["userName"];
//}