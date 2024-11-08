using System;

namespace demoLinearIP
{
    partial class fprincipal
    {
        /// <summary>
        /// Variável de designer necessária.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Limpar os recursos que estão sendo usados.
        /// </summary>
        /// <param name="disposing">true se for necessário descartar os recursos gerenciados; caso contrário, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Código gerado pelo Windows Form Designer

        /// <summary>
        /// Método necessário para suporte ao Designer - não modifique 
        /// o conteúdo deste método com o editor de código.
        /// </summary>
        private void InitializeComponent(string ip, string porta, string createuser, string tipo, string serial, string contador, string unidade, string bloco, string identificacao, string grupo, string marca, string cor, string placa, string receptor1, string receptor2, string receptor3, string receptor4, string receptor5, string receptor6, string receptor7, string receptor8) {

            this.components = new System.ComponentModel.Container();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.lbPort = new System.Windows.Forms.Label();
            this.lbIp = new System.Windows.Forms.Label();
            this.tbPort = new System.Windows.Forms.TextBox();
            this.tbIp = new System.Windows.Forms.TextBox();
            this.rbTcp = new System.Windows.Forms.RadioButton();
            this.btConectar = new System.Windows.Forms.Button();
            this.tGuias = new System.Windows.Forms.TabControl();
            this.tabPage2 = new System.Windows.Forms.TabPage();
            this.btApagarDisp = new System.Windows.Forms.Button();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.lbGrupoD = new System.Windows.Forms.Label();
            this.lbMarcaD = new System.Windows.Forms.Label();
            this.lbBatD = new System.Windows.Forms.Label();
            this.lbAcionD = new System.Windows.Forms.Label();
            this.lbLabelD = new System.Windows.Forms.Label();
            this.lbHabD = new System.Windows.Forms.Label();
            this.lbBlocoD = new System.Windows.Forms.Label();
            this.lbUnidD = new System.Windows.Forms.Label();
            this.lbContaD = new System.Windows.Forms.Label();
            this.lbSerialD = new System.Windows.Forms.Label();
            this.lbTipoD = new System.Windows.Forms.Label();
            this.label23 = new System.Windows.Forms.Label();
            this.label22 = new System.Windows.Forms.Label();
            this.label21 = new System.Windows.Forms.Label();
            this.label20 = new System.Windows.Forms.Label();
            this.label19 = new System.Windows.Forms.Label();
            this.label18 = new System.Windows.Forms.Label();
            this.label17 = new System.Windows.Forms.Label();
            this.label16 = new System.Windows.Forms.Label();
            this.label15 = new System.Windows.Forms.Label();
            this.label14 = new System.Windows.Forms.Label();
            this.label13 = new System.Windows.Forms.Label();
            this.label12 = new System.Windows.Forms.Label();
            this.lsDisp = new System.Windows.Forms.ListBox();
            this.lbQuantDisp = new System.Windows.Forms.Label();
            this.label10 = new System.Windows.Forms.Label();
            this.btLerDisp = new System.Windows.Forms.Button();
            this.tabPage3 = new System.Windows.Forms.TabPage();
            this.lblMsgDigital = new System.Windows.Forms.Label();
            this.btVincularDigital = new System.Windows.Forms.Button();
            this.tbWie2 = new System.Windows.Forms.TextBox();
            this.tbWie1 = new System.Windows.Forms.TextBox();
            this.label33 = new System.Windows.Forms.Label();
            this.btConvWie = new System.Windows.Forms.Button();
            this.btAtualizar = new System.Windows.Forms.Button();
            this.btCadastrar = new System.Windows.Forms.Button();
            this.groupBox7 = new System.Windows.Forms.GroupBox();
            this.clRecs = new System.Windows.Forms.CheckedListBox();
            this.groupBox6 = new System.Windows.Forms.GroupBox();
            this.tbPlacaV = new System.Windows.Forms.TextBox();
            this.cbCorV = new System.Windows.Forms.ComboBox();
            this.cbMarcaV = new System.Windows.Forms.ComboBox();
            this.label32 = new System.Windows.Forms.Label();
            this.label31 = new System.Windows.Forms.Label();
            this.label30 = new System.Windows.Forms.Label();
            this.groupBox5 = new System.Windows.Forms.GroupBox();
            this.label36 = new System.Windows.Forms.Label();
            this.cbGrupo = new System.Windows.Forms.ComboBox();
            this.tbIdentificacao = new System.Windows.Forms.TextBox();
            this.cbBloco = new System.Windows.Forms.ComboBox();
            this.cbUnidade = new System.Windows.Forms.ComboBox();
            this.label29 = new System.Windows.Forms.Label();
            this.label28 = new System.Windows.Forms.Label();
            this.label27 = new System.Windows.Forms.Label();
            this.groupBox4 = new System.Windows.Forms.GroupBox();
            this.btIdVago = new System.Windows.Forms.Button();
            this.tbContador = new System.Windows.Forms.TextBox();
            this.tbSerial = new System.Windows.Forms.TextBox();
            this.cbDisp2 = new System.Windows.Forms.ComboBox();
            this.lblContador = new System.Windows.Forms.Label();
            this.lblSerial = new System.Windows.Forms.Label();
            this.label11 = new System.Windows.Forms.Label();
            this.spCOM = new System.IO.Ports.SerialPort(this.components);
            this.groupBox1.SuspendLayout();
            this.tGuias.SuspendLayout();
            this.tabPage2.SuspendLayout();
            this.groupBox3.SuspendLayout();
            this.tabPage3.SuspendLayout();
            this.groupBox7.SuspendLayout();
            this.groupBox6.SuspendLayout();
            this.groupBox5.SuspendLayout();
            this.groupBox4.SuspendLayout();
            this.SuspendLayout();
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.lbPort);
            this.groupBox1.Controls.Add(this.lbIp);
            this.groupBox1.Controls.Add(this.tbPort);
            this.groupBox1.Controls.Add(this.tbIp);
            this.groupBox1.Controls.Add(this.rbTcp);
            this.groupBox1.Location = new System.Drawing.Point(87, 12);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(517, 122);
            this.groupBox1.TabIndex = 0;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Conexão";
            // 
            // lbPort
            // 
            this.lbPort.AutoSize = true;
            this.lbPort.Enabled = false;
            this.lbPort.Location = new System.Drawing.Point(290, 65);
            this.lbPort.Name = "lbPort";
            this.lbPort.Size = new System.Drawing.Size(59, 13);
            this.lbPort.TabIndex = 9;
            this.lbPort.Text = "Porta TCP:";
            // 
            // lbIp
            // 
            this.lbIp.AutoSize = true;
            this.lbIp.Enabled = false;
            this.lbIp.Location = new System.Drawing.Point(172, 64);
            this.lbIp.Name = "lbIp";
            this.lbIp.Size = new System.Drawing.Size(69, 13);
            this.lbIp.TabIndex = 8;
            this.lbIp.Text = "Endereço IP:";
            // 
            // tbPort
            // 
            this.tbPort.Enabled = false;
            this.tbPort.Location = new System.Drawing.Point(293, 81);
            this.tbPort.MaxLength = 5;
            this.tbPort.Name = "tbPort";
            this.tbPort.Size = new System.Drawing.Size(56, 20);
            this.tbPort.TabIndex = 7;
            this.tbPort.Text = porta;
            this.tbPort.WordWrap = false;
            this.tbPort.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.tbPort_KeyPress);
            // 
            // tbIp
            // 
            this.tbIp.Enabled = false;
            this.tbIp.Location = new System.Drawing.Point(175, 80);
            this.tbIp.MaxLength = 15;
            this.tbIp.Name = "tbIp";
            this.tbIp.Size = new System.Drawing.Size(100, 20);
            this.tbIp.TabIndex = 6;
            this.tbIp.Text = ip;
            this.tbIp.WordWrap = false;
            // 
            // rbTcp
            // 
            this.rbTcp.AutoSize = true;
            this.rbTcp.Location = new System.Drawing.Point(175, 29);
            this.rbTcp.Name = "rbTcp";
            this.rbTcp.Size = new System.Drawing.Size(204, 17);
            this.rbTcp.TabIndex = 1;
            this.rbTcp.TabStop = true;
            this.rbTcp.Text = "TCP/IP (Guarita/Conversor SERVER)";
            this.rbTcp.UseVisualStyleBackColor = true;
            this.rbTcp.CheckedChanged += new System.EventHandler(this.rbTcp_CheckedChanged);
            // 
            // btConectar
            // 
            this.btConectar.Location = new System.Drawing.Point(280, 140);
            this.btConectar.Name = "btConectar";
            this.btConectar.Size = new System.Drawing.Size(131, 23);
            this.btConectar.TabIndex = 1;
            this.btConectar.Text = "Conectar";
            this.btConectar.UseVisualStyleBackColor = true;
            this.btConectar.Click += new System.EventHandler(this.btConectar_Click);
            // 
            // tGuias
            // 
            if (createuser == "--createuser") {
                this.tGuias.Controls.Add(this.tabPage3);
                this.tGuias.Controls.Add(this.tabPage2);
            }
            else {
                this.tGuias.Controls.Add(this.tabPage2);
                this.tGuias.Controls.Add(this.tabPage3);
            }
            this.tGuias.Location = new System.Drawing.Point(27, 179);
            this.tGuias.Name = "tGuias";
            this.tGuias.SelectedIndex = 0;
            this.tGuias.Size = new System.Drawing.Size(636, 417);
            this.tGuias.TabIndex = 2;
            this.tGuias.Visible = false;
            // 
            // tabPage2
            //
            this.tabPage2.Controls.Add(this.btApagarDisp);
            this.tabPage2.Controls.Add(this.groupBox3);
            this.tabPage2.Controls.Add(this.lsDisp);
            this.tabPage2.Controls.Add(this.lbQuantDisp);
            this.tabPage2.Controls.Add(this.label10);
            this.tabPage2.Controls.Add(this.btLerDisp);
            this.tabPage2.Location = new System.Drawing.Point(4, 22);
            this.tabPage2.Name = "tabPage2";
            this.tabPage2.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage2.Size = new System.Drawing.Size(628, 391);
            this.tabPage2.TabIndex = 1;
            this.tabPage2.Text = "Dispositivos";
            this.tabPage2.UseVisualStyleBackColor = true;

            // 
            // btApagarDisp
            // 
            this.btApagarDisp.Location = new System.Drawing.Point(493, 34);
            this.btApagarDisp.Name = "btApagarDisp";
            this.btApagarDisp.Size = new System.Drawing.Size(119, 23);
            this.btApagarDisp.TabIndex = 5;
            this.btApagarDisp.Text = "Apagar Dispositivo";
            this.btApagarDisp.UseVisualStyleBackColor = true;
            this.btApagarDisp.Click += new System.EventHandler(this.btApagarDisp_Click);
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this.lbGrupoD);
            this.groupBox3.Controls.Add(this.lbMarcaD);
            this.groupBox3.Controls.Add(this.lbBatD);
            this.groupBox3.Controls.Add(this.lbAcionD);
            this.groupBox3.Controls.Add(this.lbLabelD);
            this.groupBox3.Controls.Add(this.lbHabD);
            this.groupBox3.Controls.Add(this.lbBlocoD);
            this.groupBox3.Controls.Add(this.lbUnidD);
            this.groupBox3.Controls.Add(this.lbContaD);
            this.groupBox3.Controls.Add(this.lbSerialD);
            this.groupBox3.Controls.Add(this.lbTipoD);
            this.groupBox3.Controls.Add(this.label23);
            this.groupBox3.Controls.Add(this.label22);
            this.groupBox3.Controls.Add(this.label21);
            this.groupBox3.Controls.Add(this.label20);
            this.groupBox3.Controls.Add(this.label19);
            this.groupBox3.Controls.Add(this.label18);
            this.groupBox3.Controls.Add(this.label17);
            this.groupBox3.Controls.Add(this.label16);
            this.groupBox3.Controls.Add(this.label15);
            this.groupBox3.Controls.Add(this.label14);
            this.groupBox3.Controls.Add(this.label13);
            this.groupBox3.Controls.Add(this.label12);
            this.groupBox3.Location = new System.Drawing.Point(74, 154);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Size = new System.Drawing.Size(488, 214);
            this.groupBox3.TabIndex = 4;
            this.groupBox3.TabStop = false;
            this.groupBox3.Text = "Dispositivos";
            // 
            // lbGrupoD
            // 
            this.lbGrupoD.AutoSize = true;
            this.lbGrupoD.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbGrupoD.Location = new System.Drawing.Point(62, 184);
            this.lbGrupoD.Name = "lbGrupoD";
            this.lbGrupoD.Size = new System.Drawing.Size(35, 13);
            this.lbGrupoD.TabIndex = 23;
            this.lbGrupoD.Text = "- - - -";
            // 
            // lbMarcaD
            // 
            this.lbMarcaD.AutoSize = true;
            this.lbMarcaD.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbMarcaD.Location = new System.Drawing.Point(251, 157);
            this.lbMarcaD.Name = "lbMarcaD";
            this.lbMarcaD.Size = new System.Drawing.Size(35, 13);
            this.lbMarcaD.TabIndex = 22;
            this.lbMarcaD.Text = "- - - -";
            // 
            // lbBatD
            // 
            this.lbBatD.AutoSize = true;
            this.lbBatD.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbBatD.Location = new System.Drawing.Point(251, 129);
            this.lbBatD.Name = "lbBatD";
            this.lbBatD.Size = new System.Drawing.Size(35, 13);
            this.lbBatD.TabIndex = 21;
            this.lbBatD.Text = "- - - -";
            // 
            // lbAcionD
            // 
            this.lbAcionD.AutoSize = true;
            this.lbAcionD.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbAcionD.Location = new System.Drawing.Point(312, 104);
            this.lbAcionD.Name = "lbAcionD";
            this.lbAcionD.Size = new System.Drawing.Size(35, 13);
            this.lbAcionD.TabIndex = 20;
            this.lbAcionD.Text = "- - - -";
            // 
            // lbLabelD
            // 
            this.lbLabelD.AutoSize = true;
            this.lbLabelD.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbLabelD.Location = new System.Drawing.Point(279, 81);
            this.lbLabelD.Name = "lbLabelD";
            this.lbLabelD.Size = new System.Drawing.Size(35, 13);
            this.lbLabelD.TabIndex = 19;
            this.lbLabelD.Text = "- - - -";
            // 
            // lbHabD
            // 
            this.lbHabD.AutoSize = true;
            this.lbHabD.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbHabD.Location = new System.Drawing.Point(283, 58);
            this.lbHabD.Name = "lbHabD";
            this.lbHabD.Size = new System.Drawing.Size(35, 13);
            this.lbHabD.TabIndex = 18;
            this.lbHabD.Text = "- - - -";
            // 
            // lbBlocoD
            // 
            this.lbBlocoD.AutoSize = true;
            this.lbBlocoD.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbBlocoD.Location = new System.Drawing.Point(53, 160);
            this.lbBlocoD.Name = "lbBlocoD";
            this.lbBlocoD.Size = new System.Drawing.Size(35, 13);
            this.lbBlocoD.TabIndex = 17;
            this.lbBlocoD.Text = "- - - -";
            // 
            // lbUnidD
            // 
            this.lbUnidD.AutoSize = true;
            this.lbUnidD.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbUnidD.Location = new System.Drawing.Point(65, 134);
            this.lbUnidD.Name = "lbUnidD";
            this.lbUnidD.Size = new System.Drawing.Size(35, 13);
            this.lbUnidD.TabIndex = 16;
            this.lbUnidD.Text = "- - - -";
            // 
            // lbContaD
            // 
            this.lbContaD.AutoSize = true;
            this.lbContaD.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbContaD.Location = new System.Drawing.Point(83, 106);
            this.lbContaD.Name = "lbContaD";
            this.lbContaD.Size = new System.Drawing.Size(35, 13);
            this.lbContaD.TabIndex = 15;
            this.lbContaD.Text = "- - - -";
            // 
            // lbSerialD
            // 
            this.lbSerialD.AutoSize = true;
            this.lbSerialD.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbSerialD.Location = new System.Drawing.Point(88, 81);
            this.lbSerialD.Name = "lbSerialD";
            this.lbSerialD.Size = new System.Drawing.Size(35, 13);
            this.lbSerialD.TabIndex = 14;
            this.lbSerialD.Text = "- - - -";
            // 
            // lbTipoD
            // 
            this.lbTipoD.AutoSize = true;
            this.lbTipoD.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbTipoD.Location = new System.Drawing.Point(48, 58);
            this.lbTipoD.Name = "lbTipoD";
            this.lbTipoD.Size = new System.Drawing.Size(35, 13);
            this.lbTipoD.TabIndex = 13;
            this.lbTipoD.Text = "- - - -";
            // 
            // label23
            // 
            this.label23.AutoSize = true;
            this.label23.Location = new System.Drawing.Point(17, 184);
            this.label23.Name = "label23";
            this.label23.Size = new System.Drawing.Size(39, 13);
            this.label23.TabIndex = 11;
            this.label23.Text = "Grupo:";
            // 
            // label22
            // 
            this.label22.AutoSize = true;
            this.label22.Location = new System.Drawing.Point(207, 157);
            this.label22.Name = "label22";
            this.label22.Size = new System.Drawing.Size(47, 13);
            this.label22.TabIndex = 10;
            this.label22.Text = "Veículo:";
            // 
            // label21
            // 
            this.label21.AutoSize = true;
            this.label21.Location = new System.Drawing.Point(207, 129);
            this.label21.Name = "label21";
            this.label21.Size = new System.Drawing.Size(43, 13);
            this.label21.TabIndex = 9;
            this.label21.Text = "Bateria:";
            // 
            // label20
            // 
            this.label20.AutoSize = true;
            this.label20.Location = new System.Drawing.Point(207, 104);
            this.label20.Name = "label20";
            this.label20.Size = new System.Drawing.Size(104, 13);
            this.label20.TabIndex = 8;
            this.label20.Text = "Último Acionamento:";
            // 
            // label19
            // 
            this.label19.AutoSize = true;
            this.label19.Location = new System.Drawing.Point(207, 81);
            this.label19.Name = "label19";
            this.label19.Size = new System.Drawing.Size(71, 13);
            this.label19.TabIndex = 7;
            this.label19.Text = "Identificação:";
            // 
            // label18
            // 
            this.label18.AutoSize = true;
            this.label18.Location = new System.Drawing.Point(207, 58);
            this.label18.Name = "label18";
            this.label18.Size = new System.Drawing.Size(76, 13);
            this.label18.TabIndex = 6;
            this.label18.Text = "RECs Destino:";
            // 
            // label17
            // 
            this.label17.AutoSize = true;
            this.label17.Location = new System.Drawing.Point(17, 160);
            this.label17.Name = "label17";
            this.label17.Size = new System.Drawing.Size(37, 13);
            this.label17.TabIndex = 5;
            this.label17.Text = "Bloco:";
            // 
            // label16
            // 
            this.label16.AutoSize = true;
            this.label16.Location = new System.Drawing.Point(17, 134);
            this.label16.Name = "label16";
            this.label16.Size = new System.Drawing.Size(50, 13);
            this.label16.TabIndex = 4;
            this.label16.Text = "Unidade:";
            // 
            // label15
            // 
            this.label15.AutoSize = true;
            this.label15.Location = new System.Drawing.Point(17, 106);
            this.label15.Name = "label15";
            this.label15.Size = new System.Drawing.Size(69, 13);
            this.label15.TabIndex = 3;
            this.label15.Text = "Contador/ID:";
            // 
            // label14
            // 
            this.label14.AutoSize = true;
            this.label14.Location = new System.Drawing.Point(17, 81);
            this.label14.Name = "label14";
            this.label14.Size = new System.Drawing.Size(72, 13);
            this.label14.TabIndex = 2;
            this.label14.Text = "Serial/Senha:";
            // 
            // label13
            // 
            this.label13.AutoSize = true;
            this.label13.Location = new System.Drawing.Point(17, 58);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(31, 13);
            this.label13.TabIndex = 1;
            this.label13.Text = "Tipo:";
            // 
            // label12
            // 
            this.label12.AutoSize = true;
            this.label12.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Underline))), System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label12.ForeColor = System.Drawing.Color.Blue;
            this.label12.Location = new System.Drawing.Point(129, 29);
            this.label12.Name = "label12";
            this.label12.Size = new System.Drawing.Size(233, 13);
            this.label12.TabIndex = 0;
            this.label12.Text = "Selecione um dispositivo na lista acima!";
            // 
            // lsDisp
            // 
            this.lsDisp.Font = new System.Drawing.Font("Lucida Console", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lsDisp.FormattingEnabled = true;
            this.lsDisp.ItemHeight = 12;
            this.lsDisp.Location = new System.Drawing.Point(16, 60);
            this.lsDisp.Name = "lsDisp";
            this.lsDisp.ScrollAlwaysVisible = true;
            this.lsDisp.Size = new System.Drawing.Size(596, 88);
            this.lsDisp.TabIndex = 3;
            this.lsDisp.SelectedIndexChanged += new System.EventHandler(this.lsDisp_SelectedIndexChanged);
            // 
            // lbQuantDisp
            // 
            this.lbQuantDisp.AutoSize = true;
            this.lbQuantDisp.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbQuantDisp.Location = new System.Drawing.Point(194, 39);
            this.lbQuantDisp.Name = "lbQuantDisp";
            this.lbQuantDisp.Size = new System.Drawing.Size(35, 13);
            this.lbQuantDisp.TabIndex = 2;
            this.lbQuantDisp.Text = "- - - -";
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Location = new System.Drawing.Point(127, 39);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(65, 13);
            this.label10.TabIndex = 1;
            this.label10.Text = "Quantidade:";
            // 
            // btLerDisp
            // 
            this.btLerDisp.Location = new System.Drawing.Point(16, 34);
            this.btLerDisp.Name = "btLerDisp";
            this.btLerDisp.Size = new System.Drawing.Size(104, 23);
            this.btLerDisp.TabIndex = 0;
            this.btLerDisp.Text = "Ler Dispositivos";
            this.btLerDisp.UseVisualStyleBackColor = true;
            this.btLerDisp.Click += new System.EventHandler(this.btLerDisp_Click);
            // 
            // tabPage3
            // 
            this.tabPage3.Controls.Add(this.lblMsgDigital);
            this.tabPage3.Controls.Add(this.btVincularDigital);
            this.tabPage3.Controls.Add(this.tbWie2);
            this.tabPage3.Controls.Add(this.tbWie1);
            this.tabPage3.Controls.Add(this.label33);
            this.tabPage3.Controls.Add(this.btConvWie);
            this.tabPage3.Controls.Add(this.btAtualizar);
            this.tabPage3.Controls.Add(this.btCadastrar);
            this.tabPage3.Controls.Add(this.groupBox7);
            this.tabPage3.Controls.Add(this.groupBox6);
            this.tabPage3.Controls.Add(this.groupBox5);
            this.tabPage3.Controls.Add(this.groupBox4);
            this.tabPage3.Location = new System.Drawing.Point(4, 22);
            this.tabPage3.Name = "tabPage3";
            this.tabPage3.Size = new System.Drawing.Size(628, 391);
            this.tabPage3.TabIndex = 2;
            this.tabPage3.Text = "Cadastrar Dispositivo";
            this.tabPage3.UseVisualStyleBackColor = true;
            // 
            // lblMsgDigital
            // 
            this.lblMsgDigital.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblMsgDigital.Location = new System.Drawing.Point(407, 274);
            this.lblMsgDigital.Name = "lblMsgDigital";
            this.lblMsgDigital.Size = new System.Drawing.Size(172, 49);
            this.lblMsgDigital.TabIndex = 10;
            this.lblMsgDigital.Text = "- - - -";
            this.lblMsgDigital.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            // 
            // btVincularDigital
            // 
            this.btVincularDigital.Enabled = false;
            this.btVincularDigital.Location = new System.Drawing.Point(432, 243);
            this.btVincularDigital.Name = "btVincularDigital";
            this.btVincularDigital.Size = new System.Drawing.Size(132, 23);
            this.btVincularDigital.TabIndex = 5;
            this.btVincularDigital.Text = "Vincular Digitais";
            this.btVincularDigital.UseVisualStyleBackColor = true;
            this.btVincularDigital.Click += new System.EventHandler(this.btVincularDigital_Click);
            // 
            // tbWie2
            // 
            this.tbWie2.Location = new System.Drawing.Point(258, 303);
            this.tbWie2.MaxLength = 5;
            this.tbWie2.Name = "tbWie2";
            this.tbWie2.Size = new System.Drawing.Size(43, 20);
            this.tbWie2.TabIndex = 8;
            this.tbWie2.Text = "00000";
            this.tbWie2.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.tbWie2_KeyPress);
            // 
            // tbWie1
            // 
            this.tbWie1.Location = new System.Drawing.Point(219, 303);
            this.tbWie1.MaxLength = 3;
            this.tbWie1.Name = "tbWie1";
            this.tbWie1.Size = new System.Drawing.Size(33, 20);
            this.tbWie1.TabIndex = 7;
            this.tbWie1.Text = "000";
            this.tbWie1.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.tbWie1_KeyPress);
            // 
            // label33
            // 
            this.label33.AutoSize = true;
            this.label33.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label33.Location = new System.Drawing.Point(21, 310);
            this.label33.Name = "label33";
            this.label33.Size = new System.Drawing.Size(197, 13);
            this.label33.TabIndex = 7;
            this.label33.Text = "Código Wiegand (W:) para Serial:";
            // 
            // btConvWie
            // 
            this.btConvWie.Location = new System.Drawing.Point(219, 329);
            this.btConvWie.Name = "btConvWie";
            this.btConvWie.Size = new System.Drawing.Size(82, 23);
            this.btConvWie.TabIndex = 9;
            this.btConvWie.Text = "Converter";
            this.btConvWie.UseVisualStyleBackColor = true;
            this.btConvWie.Click += new System.EventHandler(this.btConvWie_Click);
            // 
            // btAtualizar
            // 
            this.btAtualizar.Location = new System.Drawing.Point(433, 329);
            this.btAtualizar.Name = "btAtualizar";
            this.btAtualizar.Size = new System.Drawing.Size(131, 23);
            this.btAtualizar.TabIndex = 6;
            this.btAtualizar.Text = "Atualizar Receptores";
            this.btAtualizar.UseVisualStyleBackColor = true;
            this.btAtualizar.Click += new System.EventHandler(this.btAtualizar_Click);
            // 
            // btCadastrar
            // 
            this.btCadastrar.Location = new System.Drawing.Point(431, 202);
            this.btCadastrar.Name = "btCadastrar";
            this.btCadastrar.Size = new System.Drawing.Size(132, 23);
            this.btCadastrar.TabIndex = 4;
            this.btCadastrar.Text = "Cadastrar";
            this.btCadastrar.UseVisualStyleBackColor = true;
            this.btCadastrar.Click += new System.EventHandler(this.btCadastrar_Click);
            // 
            // groupBox7
            // 
            this.groupBox7.Controls.Add(this.clRecs);
            this.groupBox7.Location = new System.Drawing.Point(410, 20);
            this.groupBox7.Name = "groupBox7";
            this.groupBox7.Size = new System.Drawing.Size(169, 176);
            this.groupBox7.TabIndex = 3;
            this.groupBox7.TabStop = false;
            this.groupBox7.Text = "Receptores de destino";
            // 
            // clRecs
            // 
            this.clRecs.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.clRecs.FormattingEnabled = true;
            this.clRecs.Items.AddRange(new object[] {
            "Receptor 1",
            "Receptor 2",
            "Receptor 3",
            "Receptor 4",
            "Receptor 5",
            "Receptor 6",
            "Receptor 7",
            "Receptor 8"});
            this.clRecs.Location = new System.Drawing.Point(21, 28);
            this.clRecs.Name = "clRecs";
            this.clRecs.Size = new System.Drawing.Size(120, 120);
            this.clRecs.TabIndex = 0;
            // 
            // groupBox6
            // 
            this.groupBox6.Controls.Add(this.tbPlacaV);
            this.groupBox6.Controls.Add(this.cbCorV);
            this.groupBox6.Controls.Add(this.cbMarcaV);
            this.groupBox6.Controls.Add(this.label32);
            this.groupBox6.Controls.Add(this.label31);
            this.groupBox6.Controls.Add(this.label30);
            this.groupBox6.Location = new System.Drawing.Point(23, 202);
            this.groupBox6.Name = "groupBox6";
            this.groupBox6.Size = new System.Drawing.Size(361, 85);
            this.groupBox6.TabIndex = 2;
            this.groupBox6.TabStop = false;
            this.groupBox6.Text = "Dados do veículo";
            // 
            // tbPlacaV
            // 
            this.tbPlacaV.CharacterCasing = System.Windows.Forms.CharacterCasing.Upper;
            this.tbPlacaV.Location = new System.Drawing.Point(244, 41);
            this.tbPlacaV.MaxLength = 7;
            this.tbPlacaV.Name = "tbPlacaV";
            this.tbPlacaV.Size = new System.Drawing.Size(97, 20);
            this.tbPlacaV.TabIndex = 5;
            // 
            // cbCorV
            // 
            this.cbCorV.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbCorV.FormattingEnabled = true;
            this.cbCorV.IntegralHeight = false;
            this.cbCorV.Location = new System.Drawing.Point(141, 40);
            this.cbCorV.Name = "cbCorV";
            this.cbCorV.Size = new System.Drawing.Size(97, 21);
            this.cbCorV.TabIndex = 4;
            // 
            // cbMarcaV
            // 
            this.cbMarcaV.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbMarcaV.FormattingEnabled = true;
            this.cbMarcaV.IntegralHeight = false;
            this.cbMarcaV.Location = new System.Drawing.Point(21, 40);
            this.cbMarcaV.Name = "cbMarcaV";
            this.cbMarcaV.Size = new System.Drawing.Size(109, 21);
            this.cbMarcaV.TabIndex = 3;
            // 
            // label32
            // 
            this.label32.AutoSize = true;
            this.label32.Location = new System.Drawing.Point(241, 25);
            this.label32.Name = "label32";
            this.label32.Size = new System.Drawing.Size(37, 13);
            this.label32.TabIndex = 2;
            this.label32.Text = "Placa:";
            // 
            // label31
            // 
            this.label31.AutoSize = true;
            this.label31.Location = new System.Drawing.Point(138, 24);
            this.label31.Name = "label31";
            this.label31.Size = new System.Drawing.Size(26, 13);
            this.label31.TabIndex = 1;
            this.label31.Text = "Cor:";
            // 
            // label30
            // 
            this.label30.AutoSize = true;
            this.label30.Location = new System.Drawing.Point(18, 24);
            this.label30.Name = "label30";
            this.label30.Size = new System.Drawing.Size(40, 13);
            this.label30.TabIndex = 0;
            this.label30.Text = "Marca:";
            // 
            // groupBox5
            // 
            this.groupBox5.Controls.Add(this.label36);
            this.groupBox5.Controls.Add(this.cbGrupo);
            this.groupBox5.Controls.Add(this.tbIdentificacao);
            this.groupBox5.Controls.Add(this.cbBloco);
            this.groupBox5.Controls.Add(this.cbUnidade);
            this.groupBox5.Controls.Add(this.label29);
            this.groupBox5.Controls.Add(this.label28);
            this.groupBox5.Controls.Add(this.label27);
            this.groupBox5.Location = new System.Drawing.Point(23, 111);
            this.groupBox5.Name = "groupBox5";
            this.groupBox5.Size = new System.Drawing.Size(361, 85);
            this.groupBox5.TabIndex = 1;
            this.groupBox5.TabStop = false;
            this.groupBox5.Text = "Dados da moradia";
            

            // 
            // label36
            // 
            this.label36.AutoSize = true;
            this.label36.Location = new System.Drawing.Point(283, 24);
            this.label36.Name = "label36";
            this.label36.Size = new System.Drawing.Size(39, 13);
            this.label36.TabIndex = 7;
            this.label36.Text = "Grupo:";
            // 
            // cbGrupo
            // 
            this.cbGrupo.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbGrupo.FormattingEnabled = true;
            this.cbGrupo.IntegralHeight = false;
            this.cbGrupo.Location = new System.Drawing.Point(286, 40);
            this.cbGrupo.Name = "cbGrupo";
            this.cbGrupo.Size = new System.Drawing.Size(55, 21);
            this.cbGrupo.TabIndex = 6;
            // 
            // tbIdentificacao
            // 
            this.tbIdentificacao.CharacterCasing = System.Windows.Forms.CharacterCasing.Upper;
            this.tbIdentificacao.Location = new System.Drawing.Point(159, 41);
            this.tbIdentificacao.MaxLength = 18;
            this.tbIdentificacao.Name = "tbIdentificacao";
            this.tbIdentificacao.Size = new System.Drawing.Size(119, 20);
            this.tbIdentificacao.TabIndex = 5;
            // 
            // cbBloco
            // 
            this.cbBloco.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbBloco.FormattingEnabled = true;
            this.cbBloco.IntegralHeight = false;
            this.cbBloco.Location = new System.Drawing.Point(93, 40);
            this.cbBloco.Name = "cbBloco";
            this.cbBloco.Size = new System.Drawing.Size(55, 21);
            this.cbBloco.TabIndex = 4;
            // 
            // cbUnidade
            // 
            this.cbUnidade.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbUnidade.FormattingEnabled = true;
            this.cbUnidade.IntegralHeight = false;
            this.cbUnidade.Location = new System.Drawing.Point(21, 40);
            this.cbUnidade.Name = "cbUnidade";
            this.cbUnidade.Size = new System.Drawing.Size(61, 21);
            this.cbUnidade.TabIndex = 3;
            // 
            // label29
            // 
            this.label29.AutoSize = true;
            this.label29.Location = new System.Drawing.Point(156, 24);
            this.label29.Name = "label29";
            this.label29.Size = new System.Drawing.Size(71, 13);
            this.label29.TabIndex = 2;
            this.label29.Text = "Identificação:";
            // 
            // label28
            // 
            this.label28.AutoSize = true;
            this.label28.Location = new System.Drawing.Point(90, 24);
            this.label28.Name = "label28";
            this.label28.Size = new System.Drawing.Size(37, 13);
            this.label28.TabIndex = 1;
            this.label28.Text = "Bloco:";
            // 
            // label27
            // 
            this.label27.AutoSize = true;
            this.label27.Location = new System.Drawing.Point(18, 24);
            this.label27.Name = "label27";
            this.label27.Size = new System.Drawing.Size(50, 13);
            this.label27.TabIndex = 0;
            this.label27.Text = "Unidade:";
            // 
            // groupBox4
            // 
            this.groupBox4.Controls.Add(this.btIdVago);
            this.groupBox4.Controls.Add(this.tbContador);
            this.groupBox4.Controls.Add(this.tbSerial);
            this.groupBox4.Controls.Add(this.cbDisp2);
            this.groupBox4.Controls.Add(this.lblContador);
            this.groupBox4.Controls.Add(this.lblSerial);
            this.groupBox4.Controls.Add(this.label11);
            this.groupBox4.Location = new System.Drawing.Point(23, 20);
            this.groupBox4.Name = "groupBox4";
            this.groupBox4.Size = new System.Drawing.Size(361, 85);
            this.groupBox4.TabIndex = 0;
            this.groupBox4.TabStop = false;
            this.groupBox4.Text = "Dados do dispositivo";
            // 
            // btIdVago
            // 
            this.btIdVago.Enabled = false;
            this.btIdVago.Location = new System.Drawing.Point(280, 41);
            this.btIdVago.Name = "btIdVago";
            this.btIdVago.Size = new System.Drawing.Size(61, 23);
            this.btIdVago.TabIndex = 6;
            this.btIdVago.Text = "ID Vago";
            this.btIdVago.UseVisualStyleBackColor = true;
            this.btIdVago.Click += new System.EventHandler(this.btIdVago_Click);
            // 
            // tbContador
            // 
            this.tbContador.CharacterCasing = System.Windows.Forms.CharacterCasing.Upper;
            this.tbContador.Location = new System.Drawing.Point(226, 41);
            this.tbContador.MaxLength = 4;
            this.tbContador.Name = "tbContador";
            this.tbContador.Size = new System.Drawing.Size(43, 20);
            this.tbContador.TabIndex = 5;
            this.tbContador.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.tbContador_KeyPress);
            // 
            // tbSerial
            // 
            this.tbSerial.CharacterCasing = System.Windows.Forms.CharacterCasing.Upper;
            this.tbSerial.Location = new System.Drawing.Point(148, 41);
            this.tbSerial.MaxLength = 7;
            this.tbSerial.Name = "tbSerial";
            this.tbSerial.Size = new System.Drawing.Size(67, 20);
            this.tbSerial.TabIndex = 4;
            this.tbSerial.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.tbSerial_KeyPress);
            // 
            // cbDisp2
            // 
            //Cadastro
            this.cbDisp2.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbDisp2.FormattingEnabled = true;
            this.cbDisp2.IntegralHeight = false;
            this.cbDisp2.Items.AddRange(new object[] {
            "Controle (TX)",
            "TAG Ativo",
            "Cartão/Chaveiro",
            "Biometria (CTWB)",
            "TAG Passivo",
            "Senha (CTW)"});
            this.cbDisp2.Location = new System.Drawing.Point(21, 40);
            this.cbDisp2.Name = "cbDisp2";
            this.cbDisp2.Size = new System.Drawing.Size(112, 21);
            this.cbDisp2.TabIndex = 3;   
            this.cbDisp2.SelectedIndexChanged += new System.EventHandler(this.cbDisp2_SelectedIndexChanged);
            // 
            // lblSerial
            // 
            this.lblSerial.AutoSize = true;
            this.lblSerial.Location = new System.Drawing.Point(145, 24);
            this.lblSerial.Name = "lblSerial";
            this.lblSerial.Size = new System.Drawing.Size(62, 13);
            this.lblSerial.TabIndex = 1;
            this.lblSerial.Text = "Serial (hex):";
            // 
            // lblContador
            // 
            this.lblContador.AutoSize = true;
            this.lblContador.Location = new System.Drawing.Point(223, 24);
            this.lblContador.Name = "lblContador";
            this.lblContador.Size = new System.Drawing.Size(79, 13);
            this.lblContador.TabIndex = 2;
            this.lblContador.Text = "Contador (hex):";
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Location = new System.Drawing.Point(18, 24);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(31, 13);
            this.label11.TabIndex = 0;
            this.label11.Text = "Tipo:";
            // 
            // spCOM
            // 
            this.spCOM.DataReceived += new System.IO.Ports.SerialDataReceivedEventHandler(this.spCOM_DataReceived);
            // 
            // fprincipal
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(691, 608);
            this.Controls.Add(this.tGuias);
            this.Controls.Add(this.btConectar);
            this.Controls.Add(this.groupBox1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.Name = "fprincipal";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Guarita Nice SDK Desenvolvido por HeroRickyGAMES";
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.tGuias.ResumeLayout(false);
            this.tabPage2.ResumeLayout(false);
            this.tabPage2.PerformLayout();
            this.groupBox3.ResumeLayout(false);
            this.groupBox3.PerformLayout();
            this.tabPage3.ResumeLayout(false);
            this.tabPage3.PerformLayout();
            this.groupBox7.ResumeLayout(false);
            this.groupBox6.ResumeLayout(false);
            this.groupBox6.PerformLayout();
            this.groupBox5.ResumeLayout(false);
            this.groupBox5.PerformLayout();
            this.groupBox4.ResumeLayout(false);
            this.groupBox4.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.RadioButton rbTcp;
        private System.Windows.Forms.Label lbPort;
        private System.Windows.Forms.Label lbIp;
        private System.Windows.Forms.TextBox tbPort;
        private System.Windows.Forms.TextBox tbIp;
        private System.Windows.Forms.Button btConectar;
        private System.Windows.Forms.TabControl tGuias;
        private System.Windows.Forms.TabPage tabPage2;
        private System.Windows.Forms.TabPage tabPage3;
        private System.Windows.Forms.ListBox lsDisp;
        private System.Windows.Forms.Label lbQuantDisp;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.Button btLerDisp;
        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.Label lbGrupoD;
        private System.Windows.Forms.Label lbMarcaD;
        private System.Windows.Forms.Label lbBatD;
        private System.Windows.Forms.Label lbAcionD;
        private System.Windows.Forms.Label lbLabelD;
        private System.Windows.Forms.Label lbHabD;
        private System.Windows.Forms.Label lbBlocoD;
        private System.Windows.Forms.Label lbUnidD;
        private System.Windows.Forms.Label lbContaD;
        private System.Windows.Forms.Label lbSerialD;
        private System.Windows.Forms.Label lbTipoD;
        private System.Windows.Forms.Label label23;
        private System.Windows.Forms.Label label22;
        private System.Windows.Forms.Label label21;
        private System.Windows.Forms.Label label20;
        private System.Windows.Forms.Label label19;
        private System.Windows.Forms.Label label18;
        private System.Windows.Forms.Label label17;
        private System.Windows.Forms.Label label16;
        private System.Windows.Forms.Label label15;
        private System.Windows.Forms.Label label14;
        private System.Windows.Forms.Label label13;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.GroupBox groupBox7;
        private System.Windows.Forms.GroupBox groupBox6;
        private System.Windows.Forms.GroupBox groupBox5;
        private System.Windows.Forms.GroupBox groupBox4;
        private System.Windows.Forms.TextBox tbContador;
        private System.Windows.Forms.TextBox tbSerial;
        private System.Windows.Forms.ComboBox cbDisp2;
        private System.Windows.Forms.Label lblContador;
        private System.Windows.Forms.Label lblSerial;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.TextBox tbIdentificacao;
        private System.Windows.Forms.ComboBox cbBloco;
        private System.Windows.Forms.ComboBox cbUnidade;
        private System.Windows.Forms.Label label29;
        private System.Windows.Forms.Label label28;
        private System.Windows.Forms.Label label27;
        private System.Windows.Forms.Label label32;
        private System.Windows.Forms.Label label31;
        private System.Windows.Forms.Label label30;
        private System.Windows.Forms.TextBox tbPlacaV;
        private System.Windows.Forms.ComboBox cbCorV;
        private System.Windows.Forms.ComboBox cbMarcaV;
        private System.Windows.Forms.CheckedListBox clRecs;
        private System.Windows.Forms.TextBox tbWie2;
        private System.Windows.Forms.TextBox tbWie1;
        private System.Windows.Forms.Label label33;
        private System.Windows.Forms.Button btConvWie;
        private System.Windows.Forms.Button btAtualizar;
        private System.Windows.Forms.Button btCadastrar;
        private System.IO.Ports.SerialPort spCOM;
        private System.Windows.Forms.Label label36;
        private System.Windows.Forms.ComboBox cbGrupo;
        private System.Windows.Forms.Button btVincularDigital;
        private System.Windows.Forms.Button btIdVago;
        private System.Windows.Forms.Label lblMsgDigital;
        private System.Windows.Forms.Button btApagarDisp;
    }
}

