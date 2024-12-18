﻿using System;
using System.Timers;
using System.Windows.Forms;
using System.Net;
using System.Net.Sockets;
using System.Runtime.InteropServices;


namespace demoLinearIP
{
    public partial class fprincipal : Form
    {
        static Socket csTCP = null;
        static byte[] gl_RecTCPBuff= new byte[2000];  // Buffer de recepção TCP

        // Timers multithread
        static System.Timers.Timer gl_Timer = new System.Timers.Timer();
        static System.Timers.Timer gl_ToutSerialPort = new System.Timers.Timer();
        static System.Timers.Timer gl_ToutComando57 = new System.Timers.Timer();

        static int gl_conta;
        static int gl_qtDisp;

        static int gl_idBio;
        static byte gl_TemplNum;  // 0 = Dedo 1, 1 = Dedo 2/Pânico
        static byte gl_FeatNum;   // 0 = Digital, 1 = Confirmação da Digital        

        // Raw Template (338 bytes) = Feature 1 (169 bytes) + Feature 2 (169 bytes)
        static byte[] gl_RawTemplate0 = new byte[338];
        static byte[] gl_RawTemplate1 = new byte[338];
        static byte[] gl_Feature0 = new byte[256];
        static byte[] gl_Feature1 = new byte[256];

        //*Método da DLL Anviz (LN-BIO - Hamster USB) - AvzScanner.dll
        [DllImport("AvzScanner.dll")]
        public static extern Int32 AvzMatch(byte[] pFeature0, byte[] pFeature1, UInt16 level, UInt16 rotate);

        //Metodo principal
        public fprincipal(String ip, String porta, String receptor, String can, String rele)
        {
            InitializeComponent(ip, porta, receptor, can);

            // Associa evento de "Timer" para Timeout dos comandos
            gl_Timer.Elapsed += OnTimedEvent;
            // Associa evento de "Timer" para Tratamento dos bytes
            //recebidos pela Porta Serial
            gl_ToutSerialPort.Elapsed += OnToutSerialPort;
            // Associa evento de "Timer" para Timeout do Comando PC 57
            gl_ToutComando57.Elapsed += OnToutComando57;

            if (ip == "") {
                messageBox(this, "Inicio normal, caso esteja vendo essa mensagem a SDK foi iniciada manualmente para testes ou qualquer outra finalidade!", "Inicio Normal");
            }
            else {
                try {
                    // Cria o objeto socket
                    csTCP = new Socket(AddressFamily.InterNetwork,
                        SocketType.Stream, ProtocolType.Tcp);

                    // Associa IP e Port do Server
                    IPEndPoint epServer =
                        new IPEndPoint(IPAddress.Parse(tbIp.Text), int.Parse(tbPort.Text));

                    // Tenta conectar ao Server (método non-blocking)
                    csTCP.Blocking = false;
                    AsyncCallback onconnect = new AsyncCallback(OnConnect);
                    var tcpConnected = csTCP.BeginConnect(epServer, onconnect, csTCP);
                    System.Threading.Thread.Sleep(100);
                    //Console.WriteLine(testconnect.IsCompleted);
                    if (tcpConnected.IsCompleted) {
                        if (rele == "1") {
                            byte[] lFrame = new byte[6];

                            lFrame[0] = 0x00;
                            lFrame[1] = 0x0D;

                            //+Dispositivo
                            lFrame[2] = cbDispTotipoDisp(cbDisp.SelectedIndex);
                            //+CAN
                            lFrame[3] = (byte)cbCAN.SelectedIndex;
                            //+Relé (Saída)
                            lFrame[4] = 0x01;
                            //+Gera eventos
                            if (cxEVT.Checked) {
                                lFrame[5] = 0x01;  // Gera evento - Comando 4
                                enviaComando(lFrame);
                                Console.WriteLine("Rele acionado");
                                Close();
                            }
                            else {
                                lFrame[5] = 0x00;  // Não gera evento
                                                   // Sem resposta do Guarita
                                enviaComando(lFrame);
                                Console.WriteLine("FALHA CONEXAO TCP");
                                Close();
                            }
                        }

                        if (rele == "2") {
                            // Acionamento Relé 2 - RECEPTOR
                            // Comando 13 - 0x00 + 0x0D + <tipo_disp> + <num_disp> + <num_saida> + <gera_evt> + <cs>
                            byte[] lFrame = new byte[6];

                            lFrame[0] = 0x00;
                            lFrame[1] = 0x0D;

                            //+Dispositivo
                            lFrame[2] = cbDispTotipoDisp(cbDisp.SelectedIndex);
                            //+CAN
                            lFrame[3] = (byte)cbCAN.SelectedIndex;
                            //+Relé (Saída)
                            lFrame[4] = 0x02;
                            //+Gera eventos
                            if (cxEVT.Checked) {
                                lFrame[5] = 0x01;  // Gera evento - Comando 4
                                enviaComando(lFrame);

                                //System.Threading.Thread.Sleep(100);
                                Console.WriteLine("Rele acionado");
                                Close();
                            }
                            else {
                                lFrame[5] = 0x00;  // Não gera evento
                                enviaComando(lFrame);

                                //System.Threading.Thread.Sleep(100);
                                Console.WriteLine("FALHA CONEXAO TCP");
                                Close();
                            }
                        }

                        if (rele == "3") {
                            // Acionamento Relé 3 - RECEPTOR
                            // Comando 13 - 0x00 + 0x0D + <tipo_disp> + <num_disp> + <num_saida> + <gera_evt> + <cs>
                            byte[] lFrame = new byte[6];

                            lFrame[0] = 0x00;
                            lFrame[1] = 0x0D;

                            //+Dispositivo
                            lFrame[2] = cbDispTotipoDisp(cbDisp.SelectedIndex);
                            //+CAN
                            lFrame[3] = (byte)cbCAN.SelectedIndex;
                            //+Relé (Saída)
                            lFrame[4] = 0x03;
                            //+Gera eventos
                            if (cxEVT.Checked) {
                                lFrame[5] = 0x01;  // Gera evento - Comando 4

                                // Sem resposta do Guarita
                                enviaComando(lFrame);

                                //System.Threading.Thread.Sleep(100);
                                Console.WriteLine("Rele acionado");
                                Close();
                            }
                            else {
                                lFrame[5] = 0x00;  // Não gera evento
                                enviaComando(lFrame);

                                //System.Threading.Thread.Sleep(100);
                                Console.WriteLine("FALHA CONEXAO TCP");
                                Close();
                            }
                        }

                        if (rele == "4") {
                            // Acionamento Relé 4 - RECEPTOR
                            // Comando 13 - 0x00 + 0x0D + <tipo_disp> + <num_disp> + <num_saida> + <gera_evt> + <cs>
                            byte[] lFrame = new byte[6];

                            lFrame[0] = 0x00;
                            lFrame[1] = 0x0D;

                            //+Dispositivo
                            lFrame[2] = cbDispTotipoDisp(cbDisp.SelectedIndex);
                            //+CAN
                            lFrame[3] = (byte)cbCAN.SelectedIndex;
                            //+Relé (Saída)
                            lFrame[4] = 0x04;
                            //+Gera eventos
                            if (cxEVT.Checked) {
                                lFrame[5] = 0x01;  // Gera evento - Comando 4
                                enviaComando(lFrame);

                                //System.Threading.Thread.Sleep(100);
                                Console.WriteLine("Rele acionado");
                                Close();
                            }
                            else {
                                lFrame[5] = 0x00;  // Não gera evento
                                enviaComando(lFrame);

                                //System.Threading.Thread.Sleep(100);
                                Console.WriteLine("FALHA CONEXAO TCP");
                                Close();
                            }
                        }
                    } else {
                        Console.WriteLine("FALHA CONEXAO TCP");
                    }
                }
                catch (Exception ex) {
                    Application.UseWaitCursor = false;
                    Console.WriteLine("FALHA CONEXAO TCP");
                    Close();
                }
            }

        }

        // ***********************************************************
        // INVOKES para troca de informações entre threads

        // CONTROL.TEXT = text;
        delegate void SetTextCallback(Form fr, Control ctrl, string text);

        public static void SetText(Form fr, Control ctrl, string text)
        {
            // InvokeRequired required compares the thread ID of the 
            // calling thread to the thread ID of the creating thread. 
            // If these threads are different, it returns true. 
            if (ctrl.InvokeRequired)
                fr.Invoke(new SetTextCallback(SetText), new object[] { fr, ctrl, text });
            else
                ctrl.Text = text;
        }

        // LISTBOX.ITENS.ADD(text);
        delegate void AddTextCallback(Form fr, ListBox lb, string text);

        public static void AddText(Form fr, ListBox lb, string text)
        {
            if (lb.InvokeRequired)
                fr.Invoke(new AddTextCallback(AddText), new object[] { fr, lb, text });                
            else
                lb.Items.Add(text);
        }

        // COMBOBOX.SELECTEDINDEX = ix;
        delegate void SelIndexCallback(Form fr, ComboBox cb, int ix);

        public static void SelIndex(Form fr, ComboBox cb, int ix)
        {
            if (cb.InvokeRequired)
                fr.Invoke(new SelIndexCallback(SelIndex), new object[] { fr, cb, ix });
            else
                cb.SelectedIndex = ix;
        }

        // GROUPBOX, TABCONTROL, BUTTON (Conexão/Desconexão)
        delegate void ConExtCallback(Form fr, bool status, GroupBox gp, TabControl tc, Button bt);

        //Aqui faz a ação de conexão
        public static void ConexaoExterna(Form fr, bool status, GroupBox gp, TabControl tc, Button bt)
        {
            if (fr.InvokeRequired)
            {
                fr.Invoke(new ConExtCallback(ConexaoExterna), new object[] { fr, status, gp, tc, bt });
            }
            else
            {
                if (status)
                {
                    gp.Enabled = false;
                    tc.Visible = true;
                    bt.Text = "Desconectar";
                }
                else
                {
                    gp.Enabled = true;
                    tc.Visible = false;
                    bt.Text = "Conectar";
                }
            }
        }

        // MESSAGEBOX.SHOW(this, msg, msgHeader)
        delegate void messageBoxCallback(Form fr, string msg, string msgHeader);

        public static void messageBox(Form fr, string msg, string msgHeader)
        {
            if (fr.InvokeRequired)
                fr.Invoke(new messageBoxCallback(messageBox), new object[] { fr, msg, msgHeader });
            else
                MessageBox.Show(fr, msg, msgHeader);
        }
        // ***********************************************************

        // ***********************************************************
        // MÉTODOS AUXILIARES

        // **Converte int (ou byte) para BCD            
        public byte int2bcd(int val)
        {
            return (byte)(((val / 10) << 4) | (val % 10));
        }

        // **Converte BCD para int
        public int bcd2int(byte bcd)
        {
            int digit, ret = 0;

            digit = (bcd >> 4) & 0x0F;
            ret = ret * 10 + digit;

            digit = bcd & 0x0F;
            ret = ret * 10 + digit;

            return ret;
        }

        // **Extrai o range de bits (entre 7 e 0) de um determinado byte
        public int bits2int(byte B, byte msb, byte lsb)
        {
            byte mask = 0, ret;

            if ((msb >= lsb) && (msb < 8) && (lsb < 8))
            {
                for (byte b = lsb; b <= msb; b++)
                    mask |= (byte)(0x01 << b);

                ret = (byte)(B & mask);
                ret >>= lsb;

                return ret;
            }
            else return -1;  // Range inválido!
        }

        // **Retorna a marca do veículo
        public string retorna_marcav(byte valor)
        {
            switch (valor)
            {
                case 0x00: return "AUDI";
                case 0x01: return "BMW";
                case 0x02: return "CHEVROLET";
                case 0x03: return "CHRYSLER";
                case 0x04: return "CITROEN";
                case 0x05: return "FERRARI";
                case 0x06: return "FIAT";
                case 0x07: return "FORD";
                case 0x08: return "GM";
                case 0x09: return "HONDA";
                case 0x0A: return "HYUNDAI";
                case 0x0B: return "IMPORTADO";
                case 0x0C: return "JAGUAR";
                case 0x0D: return "JEEP";
                case 0x0E: return "KIA";
                case 0x0F: return "LAMBORGHINI";
                case 0x10: return "LAND ROVER";
                case 0x11: return "MAZDA";
                case 0x12: return "MERCEDES";
                case 0x13: return "MITSUBISHI";
                case 0x14: return "MOTO";
                case 0x15: return "NISSAN";
                case 0x16: return "VEICULO";
                case 0x17: return "PEUGEOT";
                case 0x18: return "PORSCHE";
                case 0x19: return "RENAULT";
                case 0x1A: return "SUBARU";
                case 0x1B: return "SUZUKI";
                case 0x1C: return "TOYOTA";
                case 0x1D: return "VOLKSWAGEN";
                case 0x1E: return "VOLVO";
                case 0x1F: return "SEM VEICULO";
                default: return "EDITAVEL";
            }
        }

        // **Retorna a cor do veículo
        public string retorna_corv(byte valor)
        {
            switch (valor)
            {
                case 0x00: return "AMARELO";
                case 0x01: return "AZUL";
                case 0x02: return "BEGE";
                case 0x03: return "BRANCO";
                case 0x04: return "CINZA";
                case 0x05: return "DOURADO";
                case 0x06: return "FANTASIA";
                case 0x07: return "GRENA";
                case 0x08: return "LARANJA";
                case 0x09: return "MARROM";
                case 0x0A: return "PRATA";
                case 0x0B: return "PRETO";
                case 0x0C: return "ROSA";
                case 0x0D: return "ROXO";
                case 0x0E: return "VERDE";
                case 0x0F: return "VERMELHO";
                default: return "???";
            }
        }

        // **Retorna (em hexadecimal) o Tipo Disp. correspondente à seleção no ComboBox "cbDisp2"
        public byte cbDispTotipoDisp(int cbValor)
        {
            switch (cbValor)
            {
                default:
                case 0: return 0x01;  // Controle TX (RF)
                case 1: return 0x02;  // TAG Ativo (TA)
                case 2: return 0x03;  // Cartão (CT/CTW)
                case 3: return 0x05;  // Biometria (BM)
                case 4: return 0x06;  // TAG Passivo (TP/UHF)
                case 5: return 0x07;  // Senha (SN)
            }
        }

        // **Habilita/Desabilita rotina para Timeout de comandos
        public void toutComando(bool habilita, int seg)
        {
            gl_Timer.Enabled = false;

            if (habilita)
            {
                gl_Timer.Interval = seg * 1000;
                gl_Timer.Enabled = true;
            }
        }

        // **Método para envio de frame Linear-HCS (com cálculo de checksum), para a interface selecionada

        //Metodo que faz o acionamento do rele.
        //IMPORTANTE! Acionamento de reles é aqui!
        public void enviaComando(byte[] frameHex)
        {
            Console.WriteLine("Algo passa aqui?");
            int tamFrameHex = frameHex.Length;
            byte[] frameEnvioHex = new byte[tamFrameHex + 1];

            // Calcula byte "checksum" (final do frame de envio)
            frameEnvioHex[tamFrameHex] = 0;

            for (int i = 0; i < tamFrameHex; i++)
            {
                frameEnvioHex[i] = frameHex[i];
                frameEnvioHex[tamFrameHex] += frameHex[i];
            }

            // "Checksum" apenas para frames com 2 bytes ou mais!!
            if (tamFrameHex > 1) tamFrameHex++;

            if ((csTCP != null) && (csTCP.Connected))
            {
                csTCP.Send(frameEnvioHex, tamFrameHex, 0);
            }
        }

        // **Método de recepção Serial/TCP
        public void recepcaoResposta(int tam, byte[] frameHex)
        {
            byte[] l_frameHex = new byte[2000];
            byte[] frameEvt = new byte[16];
            string linha, linhaTipo;

            // !! Copia vetor-parâmetro para vetor-local (evita exception nos "if's"
            //caso apenas 1 byte recebido) !!
            Buffer.BlockCopy(frameHex, 0, l_frameHex, 0, tam);

            //**********************************************************
            //4 - Envio automático de evento
            //**********************************************************
            if ((l_frameHex[1] == 0x04) && (tam == 20))
            {
                // Exibe frame no "TextBox"...
                linha = l_frameHex[2].ToString("X2") + " ";  // Contador de atualizações

                for (int i = 0; i < 16; i++)  // <frame de evt. (16 bytes)>
                {
                    linha += l_frameHex[3 + i].ToString("X2");
                    frameEvt[i] = l_frameHex[3 + i];
                }

                // *Interpretação dos bytes*
                byte t_evt = (byte)((frameEvt[0] & 0xF0) >> 4);
                byte t_disp = (byte)((frameEvt[10] & 0xF0) >> 4);

                //+Tipo evento

                switch (t_evt)
                {
                    case 0x00: linhaTipo = "Dispositivo acionado"; break;
                    case 0x01: linhaTipo = "Passagem"; break;
                    case 0x02: linhaTipo = "Equipamento ligado"; break;
                    case 0x03: linhaTipo = "Desperta porteiro"; break;
                    case 0x04: linhaTipo = "Mudança de programação"; break;
                    case 0x05: linhaTipo = "Acionamento portaria"; break;
                    case 0x06: linhaTipo = "Acionamento PC"; break;
                    case 0x07: linhaTipo = "Receptores não atualizados"; break;
                    case 0x08: linhaTipo = "Tentativa de clonagem"; break;
                    case 0x09: linhaTipo = "Pânico"; break;
                    case 0x0A: linhaTipo = "SD Card interno removido"; break;
                    case 0x0B: linhaTipo = "Restore efetuado"; break;
                    case 0x0C: linhaTipo = "Evento de receptor"; break;
                    case 0x0D: linhaTipo = "Backup automático"; break;
                    case 0x0E: linhaTipo = "Backup manual"; break;
                    case 0x0F: linhaTipo = "Porteiro eletrônico"; break;
                    default: linhaTipo = "Desconhecido"; break;
                }


                //+Dispositivo e End. CAN
                switch (t_evt)
                {
                    case 0x00:
                    case 0x01:
                    case 0x05:
                    case 0x06:
                    case 0x08:
                    case 0x09:
                    case 0x0C:
                    case 0x0F:
                        switch (t_disp)
                        {
                            case 1: linha = "Receptor TX"; break;
                            case 2: linha = "Receptor TAG Ativo"; break;
                            case 3: linha = "Receptor CT/CTW"; break;
                            case 6: linha = "Receptor TP/UHF"; break;
                            default: linha = "Desconhecido"; break;
                        }
                        linha += " " + ((frameEvt[10] & 0x0F) + 1).ToString();  // End. CAN
                        break;
                    default:
                        linha = "- - - -";
                        break;
                }
                return;
            }

            //**********************************************************
            //7 - Ler número de dispositivos na memória
            //**********************************************************
            if ( (l_frameHex[1] == 0x07) && (tam == 5) )
            {
                toutComando(false, 1);
                Application.UseWaitCursor = false;

                gl_qtDisp = (l_frameHex[2] << 8) + l_frameHex[3];

                // Apenas faz leitura se realmente houver dispositivos cadastrados
                if (gl_qtDisp > 0)
                {
                    Application.UseWaitCursor = true;
                    gl_conta = 0;

                    // Solicita primeiro dispositivo (Comando 70: 0x00 + 0x46 + <cs>)
                    // Reposta de 42 bytes: 0x00 + 0x46 + <frame de disp. (39 bytes)> + <cs>
                    toutComando(true, 5);                    
                    enviaComando(new byte[] { 0x00, 0x46 });
                }

                return;
            }

            //**********************************************************
            //11 - Escrever data e hora
            //**********************************************************
            if ( (l_frameHex[1] == 0x0B) && (tam == 3) )
            {
                toutComando(false, 1);
                Application.UseWaitCursor = false;

                messageBox(this, "Data e Hora enviadas com sucesso!", "SUCESSO");

                return;
            }

            //**********************************************************
            //12 - Ler data e hora
            //**********************************************************
            if ( (l_frameHex[1] == 0x0C) && (tam == 9) )
            {
                toutComando(false, 1);
                Application.UseWaitCursor = false;
                                
                // Mostra Data e Hora em MessageBox
                linha = string.Format("{0:D2}/{1:D2}/{2:D2} {3:D2}:{4:D2}:{5:D2}",
                    bcd2int(l_frameHex[2]), bcd2int(l_frameHex[3]), bcd2int(l_frameHex[4]),
                    bcd2int(l_frameHex[5]), bcd2int(l_frameHex[6]), bcd2int(l_frameHex[7]));

                messageBox(this, linha, "SUCESSO");                

                return;
            }

            //**********************************************************
            //29 - Atualizar Receptores
            //**********************************************************
            if ( (l_frameHex[1] == 0x1D) && (tam == 4) )
            {
                toutComando(false, 1);
                Application.UseWaitCursor = false;

                if (l_frameHex[2] == 0x00)
                    messageBox(this, "Receptores Atualizados com sucesso!", "SUCESSO");
                else
                    messageBox(this, "Falha na Atualização dos Receptores!", "FALHA");

                return;
            }

            //**********************************************************
            //42 - Dispositivo não cadastrado (Chave Prog.)
            //**********************************************************
            if ( (l_frameHex[1] == 0x2A) && (tam == 11) )
            {
                // ** Comando automático para TX, CT e TA não cadastrados, com Chave Prog. ativada **
                bool vBool = true;

                //+Tipo Disp.
                if (vBool)
                {
                    //+Serial (<serial_3> + <serial_2> + <serial_1> + <serial_0>)
                    if (l_frameHex[2] == 0x01)
                        linha = string.Format("{0:X1}{1:X2}{2:X2}{3:X2}",
                            (l_frameHex[3] & 0x0F), l_frameHex[4], l_frameHex[5], l_frameHex[6]);  // TX: Serial com 7 dígitos
                    else
                        linha = string.Format("{0:X2}{1:X2}{2:X2}",
                            l_frameHex[4], l_frameHex[5], l_frameHex[6]);  // TA e CT: Serial com 6 dígitos

                   
                    //+Flags (bit3 -> Bateria / bits2..0 -> Botão)
                    //l_frameHex[9]
                }

                return;
            }

            //**********************************************************
            //46 - Dispositivo não cadastrado - RECEPTORES (CT, TA e TP)
            //**********************************************************
            if ( (l_frameHex[1] == 0x2E) && (tam == 10) )
            {
                // ** Comando automático para CT, TA e TP não cadastrados, diretamente na Leitora do Receptor **
                bool vBool = true;

                if (vBool)
                {
                    //+Endereço CAN (<num_disp>)
                    //l_frameHex[3]

                    //+Vago (0x00)
                    //l_frameHex[4]

                    //+Serial (<serial_2> + <serial_1> + <serial_0>)
                    linha = string.Format("{0:X2}{1:X2}{2:X2}",
                        l_frameHex[5], l_frameHex[6], l_frameHex[7]);

                   

                    //+Flags (bits2..0 -> Leitora)
                    //l_frameHex[8]
                }
                return;
            }

            //**********************************************************
            //57 - Digital ANVIZ não cadastrada (Guarita)
            //**********************************************************
            if ( (l_frameHex[1] == 0x39) && ((tam == 7) || (tam == 174)) && (gl_ToutComando57.Enabled == true) )
            {
                gl_ToutComando57.Enabled = false;

                // **Digital não cadastrada!
                //if (tam == 174)
                {
                    // Guarda feature de 169 bytes...
                    if (gl_FeatNum == 0)  // Feature 1
                        Buffer.BlockCopy(l_frameHex, 4, gl_Feature0, 0, 169);
                    else //if (gl_FeatNum == 1)  // Feature 2
                        Buffer.BlockCopy(l_frameHex, 4, gl_Feature1, 0, 169);

                    if (gl_TemplNum == 0)  // Digital 1
                    {
                        if (gl_FeatNum == 0)
                        {
                            gl_FeatNum = 1;

                       
                            gl_ToutComando57.Interval = 10 * 1000;  //10s
                            gl_ToutComando57.Enabled = true;

                            enviaComando(new byte[] { 0x00, 0x39 });
                        }
                        else //if (gl_FeatNum == 1)
                        {
                            // #3. Verifica se Digital 1 e Confirmação conferem...
                            //Matching level = 9 (máx.)
                            //Mathing rotation angle = 60 graus (padrão)
                            Int32 matchRet = AvzMatch(gl_Feature0, gl_Feature1, 9, 60);

                            if (matchRet == 0)
                            {
                                // Ok! Digitais compatíveis!
                                Buffer.BlockCopy(gl_Feature0, 0, gl_RawTemplate0, 0, 169);
                                Buffer.BlockCopy(gl_Feature1, 0, gl_RawTemplate0, 169, 169);

                                gl_TemplNum = 1;
                                gl_FeatNum = 0;

                                // #4. Solicita Digital 2 ao usuário
                               

                                gl_ToutComando57.Interval = 10 * 1000;  //10s
                                gl_ToutComando57.Enabled = true;

                                enviaComando(new byte[] { 0x00, 0x39 });
                            }
                            else
                            {
                                // Digitais não compatíveis...
                                Application.UseWaitCursor = false;

                                
                            }
                        }
                    }
                    else //if (gl_TemplNum == 1)  // Digital 2
                    {
                        if (gl_FeatNum == 0)
                        {
                            gl_FeatNum = 1;

                            // #5. Solicita Confirmação da Digital 2 ao usuário
                           

                            gl_ToutComando57.Interval = 10 * 1000;  //10s
                            gl_ToutComando57.Enabled = true;

                            enviaComando(new byte[] { 0x00, 0x39 });
                        }
                        else //if (gl_FeatNum == 1)
                        {
                            // #6. Verifica se Digital 2 e Confirmação conferem...
                            //Matching level = 9 (máx.)
                            //Mathing rotation angle = 60 graus (padrão)
                            Int32 matchRet = AvzMatch(gl_Feature0, gl_Feature1, 9, 60);

                            if (matchRet == 0)
                            {
                                // Ok! Digitais compatíveis!
                                Buffer.BlockCopy(gl_Feature0, 0, gl_RawTemplate1, 0, 169);
                                Buffer.BlockCopy(gl_Feature1, 0, gl_RawTemplate1, 169, 169);

                                // #7. Vincula efetivamente os 2 Templates (Raw - 338 bytes cada) ao ID do usuário...
                                //Comando 74: 0x00 + 0x4A + <idBio_high> + <idBio_low> + <tamanhoTemplate_h> + <tamanhoTemplate_l> + <template> + <cs>
                                //Resposta de 4 bytes: 0x00 + 0x4A + <resposta> + <cs>
                               

                                byte[] lFrame = new byte[682];

                                lFrame[0] = 0x00;
                                lFrame[1] = 0x4A;                                
                                lFrame[2] = (byte)((gl_idBio & 0xFF00) >> 8);   //<idBio_high>
                                lFrame[3] = (byte)(gl_idBio & 0x00FF);          //<idBio_low>
                                lFrame[4] = 0x02;   //<tamanhoTemplate_h>
                                lFrame[5] = 0xA4;   //<tamanhoTemplate_l>

                                Buffer.BlockCopy(gl_RawTemplate0, 0, lFrame, 6, 338);   //<template>
                                Buffer.BlockCopy(gl_RawTemplate1, 0, lFrame, 344, 338); //<template>

                                toutComando(true, 10);
                                enviaComando(lFrame);
                            }
                            else
                            {
                                // Digitais não compatíveis...
                                Application.UseWaitCursor = false;

                              
                            }
                        }
                    }
                }

                return;
            }

            //**********************************************************
            //59 -  Solicitar ID Digital vago
            //**********************************************************
            if ( (l_frameHex[1] == 0x3B) && (tam == 6) )
            {
                toutComando(false, 1);
                Application.UseWaitCursor = false;

                int vInt = (l_frameHex[3] << 8) + l_frameHex[4];

                if ( vInt == 0xFFFF )
                    messageBox(this, "Biometria cheia!", "FALHA");
                else
                  
                return;
            }

            //**********************************************************
            //67/0 - Cadastrar dispositivo
            //**********************************************************
            if ( (l_frameHex[1] == 0x43) && (l_frameHex[2] == 0x00) && (tam == 5) )
            {
                toutComando(false, 1);
                Application.UseWaitCursor = false;

                switch (l_frameHex[3])
                {
                    case 0x00: messageBox(this, "Dispositivo cadastrado com sucesso!", "SUCESSO"); break;
                    case 0x01: messageBox(this, "Memória do Guarita cheia!", "FALHA"); break;
                    case 0x02: messageBox(this, "Dispositivo já existe na memória!", "FALHA"); break;
                    case 0xFE: messageBox(this, "Frame de cadastro inválido!", "FALHA"); break;
                }

                return;
            }

            //**********************************************************
            //67/4 - Apagar dispositivo
            //**********************************************************
            if ((l_frameHex[1] == 0x43) && (l_frameHex[2] == 0x04) && (tam == 5))
            {
                toutComando(false, 1);
                Application.UseWaitCursor = false;

                switch (l_frameHex[3])
                {
                    case 0x00: messageBox(this, "Dispositivo apagado com sucesso!", "SUCESSO"); break;
                    case 0x03: messageBox(this, "Dispositivo não encontrado!", "FALHA"); break;
                    case 0xFE: messageBox(this, "Frame inválido!", "FALHA"); break;
                }

                return;
            }

            //**********************************************************
            //70 - Ler dispositivos (PROGRESSIVO)
            //**********************************************************
            if ( (l_frameHex[1] == 0x46) && (tam == 42) )
            {
                toutComando(false, 1);

                // Copia os 39 bytes do frame...
                linha = "";
                for (int i = 0; i < 39; i++)
                    linha += l_frameHex[i+2].ToString("X2");

                // Adiciona ao "ListBox"
               

                gl_conta++;

                if (gl_conta == gl_qtDisp)
                {
                    // Leitura finalizada!
                    // Cancelando timeout do Guarita (sem resposta)
                    enviaComando(new byte[] { 0x00, 0x2B });

                    Application.UseWaitCursor = false;

                    messageBox(this, "Leitura finalizada!", "SUCESSO");
                }
                else
                {
                    // Solicita próximo frame!
                    // Apenas enviar 0x00 para solicitar o próximo frame
                    toutComando(true, 5);
                    enviaComando(new byte[] { 0x00 });
                }

                return;
            }

            //**********************************************************
            //74 - Vincular Digital ANVIZ (Biometria)
            //**********************************************************
            if ( (l_frameHex[1] == 0x4A) && (tam == 4) )
            {
                toutComando(false, 1);
                Application.UseWaitCursor = false;

                
                switch (l_frameHex[2])
                {
                    case 0x00: messageBox(this, "Digitais vinculadas com sucesso!", "SUCESSO"); break;
                    case 0x03: messageBox(this, "ERRO: ID não encontrado!", "FALHA"); break;
                    case 0x04: messageBox(this, "ERRO: Sem resposta da Bio. Mestre!", "FALHA"); break;
                    case 0x05: messageBox(this, "ERRO: ID inválido!", "FALHA"); break;
                    case 0xFE: messageBox(this, "ERRO: Frame de digital inválido!", "FALHA"); break;
                    case 0xFF: messageBox(this, "ERRO: Tamanho do Frame Digital inválido!", "FALHA"); break;
                }

                return;
            }
        }

        // ** Timeout de Comando Linear-HCS
        private void OnTimedEvent(Object source, ElapsedEventArgs e)
        {
            gl_Timer.Enabled = false;

            Application.UseWaitCursor = false;

            messageBox(this, "SEM RESPOSTA do comando!", "TIMEOUT");
        }
        // ***********************************************************

        // ***********************************************************
        // MÉTODOS "SERIAL PORT"

        private void spCOM_DataReceived(object sender, System.IO.Ports.SerialDataReceivedEventArgs e)
        {
            // SERIAL: Evento de recepção
                       
            if (e.EventType == System.IO.Ports.SerialData.Eof) return;

            // Recarrega timeout da Porta Serial
            //Apenas trata bytes quando timeout ocorrer!
            gl_ToutSerialPort.Stop();
            gl_ToutSerialPort.Interval = 50;  // 50 ms
            gl_ToutSerialPort.Start();
        }

        private void OnToutSerialPort(Object source, ElapsedEventArgs e)
        {
            gl_ToutSerialPort.Stop();

            int t = spCOM.BytesToRead;

            byte[] f = new byte[t];

            spCOM.Read(f, 0, t);  // Frame de bytes

            recepcaoResposta(t, f);
        }
        // ***********************************************************

        // ***********************************************************
        // MÉTODOS "TCP CLIENT SOCKET"

        public void OnConnect(IAsyncResult ar)
        {
            // Socket passado no objeto
            Socket sock = (Socket)ar.AsyncState;

            // Verifica se ocorreu tudo corretamente
            Application.UseWaitCursor = false;

            try
            {
                if (sock.Connected)
                {
                    SetupReceiveCallback(sock);

                    // !! Thread UI !!                    
                    ConexaoExterna(this, true, groupBox1, tGuias, btConectar);
                }
                else
                    messageBox(this, "Impossível conectar ao equipamento!", "FALHA CONEXAO TCP");
            }
            catch (Exception ex)
            {
                messageBox(this, ex.Message, "FALHA FUNC. ONCONNECT");
            }
        }

        public void SetupReceiveCallback(Socket sock)
        {
            try
            {
                AsyncCallback receiveData = new AsyncCallback(OnReceiveData);
                sock.BeginReceive(gl_RecTCPBuff, 0, gl_RecTCPBuff.Length,
                    SocketFlags.None, receiveData, sock);
            }
            catch (Exception ex)
            {
                messageBox(this, ex.Message, "FALHA FUNC. SETUPRECEIVECALLBACK");
            }
        }

        public void OnReceiveData(IAsyncResult ar)
        {
            // Socket passado no objeto
            Socket sock = (Socket)ar.AsyncState;

            if (!sock.Connected) return;

            // Verifica se algum byte foi recebido
            try
            {
                int l_nBytesRecTCP = sock.EndReceive(ar);

                if (l_nBytesRecTCP > 0)
                {
                    // Trata dados recebidos
                    recepcaoResposta(l_nBytesRecTCP, gl_RecTCPBuff);

                    // Reestabelece "callback"
                    SetupReceiveCallback(sock);
                }
                else
                {
                    // Nenhum byte recebido. Provavelmente conexão foi perdida!
                    toutComando(false, 1);
                    Application.UseWaitCursor = false;

                    sock.Shutdown(SocketShutdown.Both);
                    sock.Close();

                    // !! Thread UI !!
                    ConexaoExterna(this, false, groupBox1, tGuias, btConectar);
                }
            }
            catch (Exception ex)
            {
                messageBox(this, ex.Message, "FALHA FUNC. ONRECEIVEDATA");
            }
        }

        // ***********************************************************

        private void tbPort_KeyPress(object sender, KeyPressEventArgs e)
        {
            // Apenas números
            if (!Char.IsDigit(e.KeyChar) && !Char.IsControl(e.KeyChar)) e.Handled = true;
        }

        private void tbWie1_KeyPress(object sender, KeyPressEventArgs e)
        {
            // Apenas números
            if (!Char.IsDigit(e.KeyChar) && !Char.IsControl(e.KeyChar)) e.Handled = true;
        }

        private void tbWie2_KeyPress(object sender, KeyPressEventArgs e)
        {
            // Apenas números
            if (!Char.IsDigit(e.KeyChar) && !Char.IsControl(e.KeyChar)) e.Handled = true;
        }

        private void tbSerial_KeyPress(object sender, KeyPressEventArgs e)
        {
            // Demais Tipo Disp. = Apenas caracteres hexadecimal
            if (!Uri.IsHexDigit(e.KeyChar) && !Char.IsControl(e.KeyChar)) e.Handled = true;
        }

        private void tbContador_KeyPress(object sender, KeyPressEventArgs e)
        {

            // Demais Tipo Disp. = Apenas caracteres hexadecimal
            if (!Uri.IsHexDigit(e.KeyChar) && !Char.IsControl(e.KeyChar)) e.Handled = true;
        }

        private void rbSerial_CheckedChanged(object sender, EventArgs e)
        {
            lbIp.Enabled = true;
            tbIp.Enabled = true;
            lbPort.Enabled = true;
            tbPort.Enabled = true;
        }

        private void rbTcp_CheckedChanged(object sender, EventArgs e)
        {
            // Conexão TCP marcada
            lbIp.Enabled = true;
            tbIp.Enabled = true;
            lbPort.Enabled = true;
            tbPort.Enabled = true;
        }

        private void btConectar_Click(object sender, EventArgs e)
        {
            if (btConectar.Text == "Conectar")
            {
                Application.UseWaitCursor = true;

                try
                {
                    // Cria o objeto socket
                    csTCP = new Socket(AddressFamily.InterNetwork,
                        SocketType.Stream, ProtocolType.Tcp);

                    // Associa IP e Port do Server
                    IPEndPoint epServer =
                        new IPEndPoint(IPAddress.Parse(tbIp.Text), int.Parse(tbPort.Text));

                    // Tenta conectar ao Server (método non-blocking)
                    csTCP.Blocking = false;
                    AsyncCallback onconnect = new AsyncCallback(OnConnect);
                    csTCP.BeginConnect(epServer, onconnect, csTCP);
                }
                catch (Exception ex)
                {
                    Application.UseWaitCursor = false;
                    messageBox(this, ex.Message, "FALHA CONEXAO TCP");
                }
            }
            else //if (btConectar.Text == "Desconectar")
            {
                toutComando(false, 1);
                Application.UseWaitCursor = false;

                if ((csTCP != null) && (csTCP.Connected))
                {
                    csTCP.Shutdown(SocketShutdown.Both);
                    System.Threading.Thread.Sleep(10);
                    csTCP.Close();
                }

                ConexaoExterna(this, false, groupBox1, tGuias, btConectar);
            }
        }

        private void btEnviarRelogio_Click(object sender, EventArgs e)
        {
            // Botão "Enviar Data e Hora"
            // Comando 11: 0x00 + 0x0B + <dia> + <mês> + <ano> + <hora> + <min.> + <seg.> + <cs>
            byte[] lFrame = new byte[8];
            DateTime agora = DateTime.Now;
                        
            Application.UseWaitCursor = true;

            lFrame[0] = 0x00;
            lFrame[1] = 0x0B;

            lFrame[2] = int2bcd(agora.Day);
            lFrame[3] = int2bcd(agora.Month);
            lFrame[4] = int2bcd(agora.Year-2000);

            lFrame[5] = int2bcd(agora.Hour);
            lFrame[6] = int2bcd(agora.Minute);
            lFrame[7] = int2bcd(agora.Second);

            // Resposta de 3 bytes: 0x00 + 0x0B + <cs>
            toutComando(true, 3);
            enviaComando(lFrame);
        }

        private void btLerRelogio_Click(object sender, EventArgs e)
        {
            // Botão "Ler Data e Hora"
            // Comando 12: 0x00 + 0x0C + <cs>
            Application.UseWaitCursor = true;

            // Resposta de 9 bytes: 0x00 + 0x0C + <dia> + <mes> + <ano> + <hora> + <min> + <seg> + <cs>
            toutComando(true, 3);
            enviaComando(new byte[] { 0x00, 0x0C });
        }

        private void btLerDisp_Click(object sender, EventArgs e)
        {
            // Botão "Ler dispositivos"
            // Solicita quantidade (Comando 7: 0x00 + 0x07 + <cs>)
            Application.UseWaitCursor = true;

          
            // Resposta de 5 bytes: 0x00 + 0x07 + <quant. parte alta> + <quant. parte baixa> + <cs>
            toutComando(true, 5);
            enviaComando(new byte[] { 0x00, 0x07 });
        }

        private void lsDisp_SelectedIndexChanged(object sender, EventArgs e)
        {
          
        }

        private void btR1_Click(object sender, EventArgs e)
        {
            // Acionamento Relé 1 - RECEPTOR
            // Comando 13 - 0x00 + 0x0D + <tipo_disp> + <num_disp> + <num_saida> + <gera_evt> + <cs>
            byte[] lFrame = new byte[6];

            lFrame[0] = 0x00;
            lFrame[1] = 0x0D;

            //+Dispositivo
            lFrame[2] = cbDispTotipoDisp(cbDisp.SelectedIndex);
            //+CAN
            lFrame[3] = (byte)cbCAN.SelectedIndex;
            //+Relé (Saída)
            lFrame[4] = 0x01;
            //+Gera eventos
            if (cxEVT.Checked)
                lFrame[5] = 0x01;  // Gera evento - Comando 4
            else
                lFrame[5] = 0x00;  // Não gera evento

            // Sem resposta do Guarita
            enviaComando(lFrame);
        }

        private void btR2_Click(object sender, EventArgs e)
        {
            // Acionamento Relé 2 - RECEPTOR
            // Comando 13 - 0x00 + 0x0D + <tipo_disp> + <num_disp> + <num_saida> + <gera_evt> + <cs>
            byte[] lFrame = new byte[6];

            lFrame[0] = 0x00;
            lFrame[1] = 0x0D;

            //+Dispositivo
            lFrame[2] = cbDispTotipoDisp(cbDisp.SelectedIndex);
            //+CAN
            lFrame[3] = (byte)cbCAN.SelectedIndex;
            //+Relé (Saída)
            lFrame[4] = 0x02;
            //+Gera eventos
            if (cxEVT.Checked)
                lFrame[5] = 0x01;  // Gera evento - Comando 4
            else
                lFrame[5] = 0x00;  // Não gera evento

            // Sem resposta do Guarita
            enviaComando(lFrame);
        }

        private void btR3_Click(object sender, EventArgs e)
        {
            // Acionamento Relé 3 - RECEPTOR
            // Comando 13 - 0x00 + 0x0D + <tipo_disp> + <num_disp> + <num_saida> + <gera_evt> + <cs>
            byte[] lFrame = new byte[6];

            lFrame[0] = 0x00;
            lFrame[1] = 0x0D;

            //+Dispositivo
            lFrame[2] = cbDispTotipoDisp(cbDisp.SelectedIndex);
            //+CAN
            lFrame[3] = (byte)cbCAN.SelectedIndex;
            //+Relé (Saída)
            lFrame[4] = 0x03;
            //+Gera eventos
            if (cxEVT.Checked)
                lFrame[5] = 0x01;  // Gera evento - Comando 4
            else
                lFrame[5] = 0x00;  // Não gera evento

            // Sem resposta do Guarita
            enviaComando(lFrame);
        }

        private void btR4_Click(object sender, EventArgs e)
        {
            // Acionamento Relé 4 - RECEPTOR
            // Comando 13 - 0x00 + 0x0D + <tipo_disp> + <num_disp> + <num_saida> + <gera_evt> + <cs>
            byte[] lFrame = new byte[6];

            lFrame[0] = 0x00;
            lFrame[1] = 0x0D;

            //+Dispositivo
            lFrame[2] = cbDispTotipoDisp(cbDisp.SelectedIndex);
            //+CAN
            lFrame[3] = (byte)cbCAN.SelectedIndex;
            //+Relé (Saída)
            lFrame[4] = 0x04;
            //+Gera eventos
            if (cxEVT.Checked)
                lFrame[5] = 0x01;  // Gera evento - Comando 4
            else
                lFrame[5] = 0x00;  // Não gera evento

            // Sem resposta do Guarita
            enviaComando(lFrame);
        }

        private void btCadastrar_Click(object sender, EventArgs e)
        {
            // Botão "CADASTRAR" (aba "Cadastrar Dispositivo")
            byte[] frameDisp = new byte[39];
            int vSerial, vConta;
            byte t_disp;

            // <tipo_disp>
        }

        private void btAtualizar_Click(object sender, EventArgs e)
        {
            // Botão "ATUALIZAR RECEPTORES" (aba "Cadastrar Dispositivo")
            // Comando 29: 0x00 + 0x1D + <cs>
            Application.UseWaitCursor = true;

            // Resposta de 4 bytes: 0x00 + 0x1D + <resposta> + <cs>
            //Nota: Tempo de resposta depende da quantidade de dispositivos
            //a serem enviados aos Receptores!
            toutComando(true, 180);
            enviaComando(new byte[] { 0x00, 0x1D });
        }

        private void btModoRemoto_Click(object sender, EventArgs e)
        {
            // Botão "ATIVAR (Modo Remoto)" (aba "Acionar Saídas")
            // Comando 35: 0x00 + 0x23 + <tipo_disp> + <num_disp> + <cs>
            byte[] lFrame = new byte[4];

            lFrame[0] = 0x00;
            lFrame[1] = 0x23;

            //+Dispositivo (TODOS)
            lFrame[2] = 0xFF;
            //+CAN (TODOS)
            lFrame[3] = 0xFF;

            // Sem resposta do Guarita
            enviaComando(lFrame);

            messageBox(this, "Comando enviado! Verifique o LED INDICADOR DE STATUS dos Receptores!", "SUCESSO");
        }

        private void btIdVago_Click(object sender, EventArgs e)
        {
            // Botão "ID VAGO" (aba "Cadastrar Dispositivo")
            // Comando 59: 0x00 + 0x3B + 0x00 + 0x00 + <cs>
            Application.UseWaitCursor = true;

            // Resposta de 6 bytes: 0x00 + 0x3B + 0x00 + <idBio_high> + <idBio_low> + <cs>
            toutComando(true, 5);
            enviaComando(new byte[] { 0x00, 0x3B, 0x00, 0x00 });
        }

        private void OnToutComando57(Object source, ElapsedEventArgs e)
        {
            // TIMEOUT de "Vincular Digital" (aba "Cadastrar Dispositivo")
            gl_ToutComando57.Enabled = false;

            Application.UseWaitCursor = false;
        }

        private void btApagarDisp_Click(object sender, EventArgs e)
        {
        }

        private void cbDisp_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
