import 'package:native_context_menu_ng/native_menu.dart';
import 'package:vigilant/homeApp.dart';

//Programado por HeroRickyGames com ajuda de Deus!

Future<NativeMenu> initMenuCondominio() async {
  NativeMenuItem? itemNew;
  NativeMenu menu = NativeMenu();
  if(AdicionarCondominios == true){
    menu.addItem(NativeMenuItem.simple(title: "Editar informações do cliente", action: "editCondominio"));
    itemNew = NativeMenuItem.simple(title: "Deletar cliente", action: "remover_condominio");
    menu.addItem(itemNew);
  }else{
    menu.addItem(NativeMenuItem.simple(title: "", action: ""));
  }
  return menu;
}

Future<NativeMenu> initMenuAcionamentos() async {
  NativeMenuItem? itemNew;
  NativeMenu menu = NativeMenu();
  if(AdicionarAcionamentos == true){
    itemNew = NativeMenuItem.simple(title: "Editar infos. do acionamento", action: "editar_acionamento");
    menu.addItem(itemNew);
    menu.addItem(NativeMenuItem.simple(title: "Deletar acionamento", action: "delAcionamento"));
  }else{
    menu.addItem(NativeMenuItem.simple(title: "", action: ""));
  }
  return menu;
}

Future<NativeMenu> initMenuMoradores() async {
  NativeMenuItem? itemNew;
  NativeMenu menu = NativeMenu();
  if(AdicionarAcionamentos == true){
    itemNew = NativeMenuItem.simple(title: "Editar infos. de morador", action: "editar_morador");
    menu.addItem(itemNew);
    menu.addItem(NativeMenuItem.simple(title: "Deletar morador", action: "delMorador"));
  }else{
    menu.addItem(NativeMenuItem.simple(title: "", action: ""));
  }
  return menu;
}