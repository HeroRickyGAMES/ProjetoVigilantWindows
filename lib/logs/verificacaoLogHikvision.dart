//Programado por HeroRickyGAMES com a ajuda de Deus!

String logname = "";

logtraduzido(String log){
  print("logger");
  print("logger $log");
  if(log == "invalid"){
    logname = "Invalido (Negado)";
    return logname;
  }

  if(log == "cardOrFaceOrFp"){
    logname = "Facial";
    return logname;
  }

  return "Não reconhecido!";
}