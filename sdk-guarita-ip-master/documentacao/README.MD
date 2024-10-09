# Protocolo de Comunicação

Versão Mínima do Guarita IP: _VrA.113k_

Última Revisão: _09/04/2019_

## Revisão 6

* Adicionada opção "Utilizar Rotas" no Byte 1 <cfg1> do "Frame de Guarita AVANÇADO"
* Adicionada configuração do "Botão Emergência" nos Bytes 181 a 184 do "Frame de Guarita AVANÇADO"
* Adicionada opção "Enviar TX não cadastrado" no Byte 122 do "Frame Multifunção 4A"
* Revisão do Comando PC 46 (Dispositivo não cadastrado - Receptor)
* Adicionado Comando PC 100 (QR Code não cadastrado)
* Adicionado Comando PC 102 (Evento da Interface DTMF)
* Adicionada nova <flagsEvt1> para evento "Acionamento de saídas pelo Guarita"
* Adicionado Comando PC 106 (Forçar desconexão Porta TCP Server)
* Adicionado Comando PC 107 (Escrever, Ler e Enviar Rotas por Leitoras)
* Adicionado Comando PC 108 (Ler Rotas em PACOTES)
* Adicionado Comando PC 109 (Gravar Rotas em PACOTES)
* Revisão do Comando PC 45 (Ler arquivos do SD Card Interno)
* Adicionada opção "Rotas" no Byte 11 do "Frame de dispositivo"
* Revisão do "Frame de Biometria"
* Adicionada opção "Evento Canal Inibido" no Byte 122 do "Frame Multifunção 4A"
* Adicionada nova <flagsEvt1> para evento "Canal Inibido"

## Revisão 5

* Adicionadas novas <flagsEvt1> para evento "Mudança da programação pelo usuário"
* Adicionada habilitação de alerta "porta violada" em "Frame de Guarita AVANÇADO"
* Novos Receptores compatíveis com Comando PC 92 (Acionar saída AVANÇADO)
* Alterado Comando PC 99 (Programação do Receptor Multifunção 4A)
