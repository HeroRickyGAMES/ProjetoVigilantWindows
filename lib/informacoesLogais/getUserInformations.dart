import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vigilant/informacoesLogais/getIds.dart';

//Programado por HeroRickyGAMES com a ajuda de Deus

getUserName() async {
  var getUserPermissions = await FirebaseFirestore.instance
      .collection("Users")
      .doc(UID).get();

  return getUserPermissions['Nome'];
}