
//Programado por HeroRickyGAMES com a ajuda de Deus!

String log = "";

identificacao(int logId) {
  print(logId);
  if(logId == 0){
    log = "Liberado via API";
    return log;
  }
  if(logId == 1651076864){
    log = "Liberação via biometria";
    return log;
  }
  if(logId == 1919314176){
    log = "Outro";
    return log;
  }
  if(logId == 1735747840){
    print(log);
    log = "Acesso negado";
    return log;
  }

  return "";
}