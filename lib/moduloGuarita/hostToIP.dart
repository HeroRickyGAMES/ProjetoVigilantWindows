import 'dart:io';

hostToIp(String host) async {
  List<InternetAddress> addresses = await InternetAddress.lookup(host);
  return addresses[0].address;
}