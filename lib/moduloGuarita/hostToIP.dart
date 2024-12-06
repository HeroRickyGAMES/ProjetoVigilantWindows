import 'dart:io';

hostToIp(String host) async {
  final ipRegex = RegExp(
    r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$', // Regex simples para IPv4
  );

  if (ipRegex.hasMatch(host)) {
    return host;
  }else{
    List<InternetAddress> addresses = await InternetAddress.lookup(host);
    return addresses[0].address;
  }
}