import 'package:device_info_plus/device_info_plus.dart';

//Programado por HeroRickyGames com ajuda de Deus!

//Aqui ele pega o username do PC.

final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
Map<String, dynamic> _deviceData = <String, dynamic>{};


Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
  return <String, dynamic>{
    'userName': data.userName,
  };
}

Future<String> getUsername() async {
  return _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo)["userName"];
}