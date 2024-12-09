import 'package:device_info_plus/device_info_plus.dart';

//Programado por HeroRickyGAMES com a ajuda de Deus!

final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
  return <String, dynamic>{
    'cores': data.numberOfCores,
  };
}

//Essa classe é determinada para setar o desempenho do aplicativo em relação aos Delays.
Future<int> GetCores() async {
  return _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo)["cores"];
}