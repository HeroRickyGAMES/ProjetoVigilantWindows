//Programado por HeroRickyGAMES com a ajuda de Deus!

String logname = "";

logtraduzido(String log){

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