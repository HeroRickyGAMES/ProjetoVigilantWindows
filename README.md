# Vigilant


Esse projeto vai ser de monitoramento com CFTV, acionamento de reles remotos, voz por VOIP (voz por transmissão desejavel via api web ou algo assim) e o cadastros com o banco de dados geral Firebase!

Requisitos minimos para rodar o Sparta Monitoramento:
6GB de RAM.
Quadcore Core Processador (3.00 GHz)
GPU com 1GB de VRAM
500MB de espaço sobrando no disco
Internet estavel

Requisitos recomendados:
8GB de RAM
Exacore processador (3.6 GHz >)
GPU com 2GB de VRAM
500MB de espaço sobrando no disco
Internet estavel

Requisitos recomendados para Servidor:
Quadcore Core Processador (3.00 GHz)
16GB de RAM
1TB de SSD
Placa mãe com BIOS UEFI.
Caso não ache uma placa mãe com UEFI use uma LGA 1155 ou 1156 ou semelhante que atenda a configuração de cima para evitar alto tempo de carregamento do OS desejado.

O que cada arquivo dart da pasta /lib fazem no projeto?

/lib/main.dart : Arquivo main raiz do projeto, e também um bootloader para o app e questões de login, senha.

/lib/homeApp.dart : Layout da tela principal com diversos comandos para o funcionamento e gerenciamento do app!

/lib/checkUser.dart : Arquivo para verificar o usuario do Windows. Exemplo: HeroRicky_Games para jogar na main.dart

/lib/firebase_options.dart : Arquivo onde contem algumas rotas para o banco de dados!

/lib/getIDs.dart : Arquivo que contem os codigo de id do usuario logado.

/lib/acionamento_de_portas/acionamento_de_portas.dart : Acionamento de reles via API com o HTTP.

/lib/cadastro/cadastro.dart : Uma tela não usada que servia para fazer testes de cadastro no inicio da aplicação (O porque esse arquivo ainda permanece? Re: É um grande misterio)

/lib/intRamdom/intRamdom.dart : Arquivo de criação de numeros aleatorios usados em algumas partes do codigo!

/lib/login/login.dart : Layout / Codigo de autenticação com login do usuario!

/lib/pushPessoas/pushPessoas.dart : Arquivo feito para puxar os cadastros do equipamento para o servidor!

/lib/pushPessoas/cadastroDeUsuariosNoEquipamento.dart : Arquivo feito para cadastrar um usuario que foi criado na aplicação no equipamento!

/lib/videoStream/videoStream.dart : Arquivo principal para exibição do CFTV com controle de resolução, qualidade e canais do CFTV.

/lib/videoStream/VideoStreamAlert.dart : Arquivo feito para visualizar um CFTV em widget cheio!

/lib/videoStream/videoStreamWidget.dart : Arquivo de organização geral dos CFTVs, aqui ele consulta com o banco de dados a ordem do CFTV e como ela será exibida na tela.

/lib/voip/voipAPI.dart : API do VOIP, ainda está em testes, porém em alguns lugares que é compativel com o SIP é capaz fazer uma comunicação.