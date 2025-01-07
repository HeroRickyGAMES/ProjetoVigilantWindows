
//Programado por HeroRickyGAMES com a ajuda de Deus!

String log = "";

identificacao(int logId) {

  if(logId == 0){
    log = "Liberado via API";
    print(log);
    return log;
  }
  if(logId == 1651076864){
    print(log);
    log = "Liberação via biometria";
    return log;
  }
  if(logId == 1735747840){
    print(log);
    log = "Acesso negado";
    return log;
  }

  return "";
}