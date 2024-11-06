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
        private void InitializeComponent(string ip, string porta, string receptor, string can)
        {
            this.components = new System.ComponentModel.Container();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.lbPort = new System.Windows.Forms.Label();
            this.lbIp = new System.Windows.Forms.Label();
            this.tbPort = new System.Windows.Forms.TextBox();
            this.tbIp = new System.Windows.Forms.TextBox();
            this.rbTcp = new System.Windows.Forms.RadioButton();
            this.btConectar = new System.Windows.Forms.Button();
            this.spCOM = new System.IO.Ports.SerialPort(this.components);
            this.tabPage4 = new System.Windows.Forms.TabPage();
            this.groupBox9 = new System.Windows.Forms.GroupBox();
            this.btModoRemoto = new System.Windows.Forms.Button();
            this.label24 = new System.Windows.Forms.Label();
            this.groupBox8 = new System.Windows.Forms.GroupBox();
            this.btR4 = new System.Windows.Forms.Button();
            this.btR3 = new System.Windows.Forms.Button();
            this.btR2 = new System.Windows.Forms.Button();
            this.btR1 = new System.Windows.Forms.Button();
            this.cxEVT = new System.Windows.Forms.CheckBox();
            this.cbCAN = new System.Windows.Forms.ComboBox();
            this.label35 = new System.Windows.Forms.Label();
            this.label34 = new System.Windows.Forms.Label();
            this.tGuias = new System.Windows.Forms.TabControl();
            this.cbDisp = new System.Windows.Forms.ComboBox();
            this.groupBox1.SuspendLayout();
            this.tabPage4.SuspendLayout();
            this.groupBox9.SuspendLayout();
            this.groupBox8.SuspendLayout();
            this.tGuias.SuspendLayout();
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
            this.lbPort.Location = new System.Drawing.Point(298, 64);
            this.lbPort.Name = "lbPort";
            this.lbPort.Size = new System.Drawing.Size(59, 13);
            this.lbPort.TabIndex = 9;
            this.lbPort.Text = "Porta TCP:";
            // 
            // lbIp
            // 
            this.lbIp.AutoSize = true;
            this.lbIp.Enabled = false;
            this.lbIp.Location = new System.Drawing.Point(120, 64);
            this.lbIp.Name = "lbIp";
            this.lbIp.Size = new System.Drawing.Size(69, 13);
            this.lbIp.TabIndex = 8;
            this.lbIp.Text = "Endereço IP:";
            // 
            // tbPort
            // 
            this.tbPort.Location = new System.Drawing.Point(301, 80);
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
            this.tbIp.Location = new System.Drawing.Point(123, 80);
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
            this.rbTcp.Checked = true;
            this.rbTcp.Location = new System.Drawing.Point(138, 34);
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
            // spCOM
            // 
            this.spCOM.DataReceived += new System.IO.Ports.SerialDataReceivedEventHandler(this.spCOM_DataReceived);
            // 
            // tabPage4
            // 
            this.tabPage4.Controls.Add(this.groupBox9);
            this.tabPage4.Controls.Add(this.groupBox8);
            this.tabPage4.Location = new System.Drawing.Point(4, 22);
            this.tabPage4.Name = "tabPage4";
            this.tabPage4.Size = new System.Drawing.Size(628, 391);
            this.tabPage4.TabIndex = 3;
            this.tabPage4.Text = "Acionar Saídas";
            this.tabPage4.UseVisualStyleBackColor = true;
            // 
            // groupBox9
            // 
            this.groupBox9.Controls.Add(this.btModoRemoto);
            this.groupBox9.Controls.Add(this.label24);
            this.groupBox9.Location = new System.Drawing.Point(133, 253);
            this.groupBox9.Name = "groupBox9";
            this.groupBox9.Size = new System.Drawing.Size(355, 108);
            this.groupBox9.TabIndex = 1;
            this.groupBox9.TabStop = false;
            this.groupBox9.Text = "Modo Remoto (Receptores - Comando 35)";
            // 
            // btModoRemoto
            // 
            this.btModoRemoto.Location = new System.Drawing.Point(141, 67);
            this.btModoRemoto.Name = "btModoRemoto";
            this.btModoRemoto.Size = new System.Drawing.Size(75, 23);
            this.btModoRemoto.TabIndex = 1;
            this.btModoRemoto.Text = "Ativar";
            this.btModoRemoto.UseVisualStyleBackColor = true;
            this.btModoRemoto.Click += new System.EventHandler(this.btModoRemoto_Click);
            // 
            // label24
            // 
            this.label24.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label24.Location = new System.Drawing.Point(18, 26);
            this.label24.Name = "label24";
            this.label24.Size = new System.Drawing.Size(318, 33);
            this.label24.TabIndex = 0;
            this.label24.Text = "Relés de TODOS os Receptores serão acionados somente pelo PC (por 90 segundos)";
            this.label24.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // groupBox8
            // 
            this.groupBox8.Controls.Add(this.btR4);
            this.groupBox8.Controls.Add(this.btR3);
            this.groupBox8.Controls.Add(this.btR2);
            this.groupBox8.Controls.Add(this.btR1);
            this.groupBox8.Controls.Add(this.cxEVT);
            this.groupBox8.Controls.Add(this.cbCAN);
            this.groupBox8.Controls.Add(this.cbDisp);
            this.groupBox8.Controls.Add(this.label35);
            this.groupBox8.Controls.Add(this.label34);
            this.groupBox8.Location = new System.Drawing.Point(0, 3);
            this.groupBox8.Name = "groupBox8";
            this.groupBox8.Size = new System.Drawing.Size(625, 215);
            this.groupBox8.TabIndex = 0;
            this.groupBox8.TabStop = false;
            this.groupBox8.Text = "Acionar relés (Receptores - Comando 13)";
            // 
            // btR4
            // 
            this.btR4.Location = new System.Drawing.Point(525, 117);
            this.btR4.Name = "btR4";
            this.btR4.Size = new System.Drawing.Size(93, 45);
            this.btR4.TabIndex = 8;
            this.btR4.Text = "Relé 4";
            this.btR4.UseVisualStyleBackColor = true;
            this.btR4.Click += new System.EventHandler(this.btR4_Click);
            // 
            // btR3
            // 
            this.btR3.Location = new System.Drawing.Point(378, 121);
            this.btR3.Name = "btR3";
            this.btR3.Size = new System.Drawing.Size(84, 37);
            this.btR3.TabIndex = 7;
            this.btR3.Text = "Relé 3";
            this.btR3.UseVisualStyleBackColor = true;
            this.btR3.Click += new System.EventHandler(this.btR3_Click);
            // 
            // btR2
            // 
            this.btR2.Location = new System.Drawing.Point(194, 121);
            this.btR2.Name = "btR2";
            this.btR2.Size = new System.Drawing.Size(107, 37);
            this.btR2.TabIndex = 6;
            this.btR2.Text = "Relé 2";
            this.btR2.UseVisualStyleBackColor = true;
            this.btR2.Click += new System.EventHandler(this.btR2_Click);
            // 
            // btR1
            // 
            this.btR1.Location = new System.Drawing.Point(41, 121);
            this.btR1.Name = "btR1";
            this.btR1.Size = new System.Drawing.Size(94, 36);
            this.btR1.TabIndex = 5;
            this.btR1.Text = "Relé 1";
            this.btR1.UseVisualStyleBackColor = true;
            this.btR1.Click += new System.EventHandler(this.btR1_Click);
            // 
            // cxEVT
            // 
            this.cxEVT.AutoSize = true;
            this.cxEVT.Checked = true;
            this.cxEVT.CheckState = System.Windows.Forms.CheckState.Checked;
            this.cxEVT.Location = new System.Drawing.Point(525, 76);
            this.cxEVT.Name = "cxEVT";
            this.cxEVT.Size = new System.Drawing.Size(94, 17);
            this.cxEVT.TabIndex = 4;
            this.cxEVT.Text = "Gerar evento?";
            this.cxEVT.UseVisualStyleBackColor = true;
            // 
            // cbCAN
            // 
            this.cbCAN.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbCAN.FormattingEnabled = true;
            this.cbCAN.IntegralHeight = false;
            this.cbCAN.Items.AddRange(new object[] {
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8"});
            this.cbCAN.Location = new System.Drawing.Point(397, 72);
            this.cbCAN.Name = "cbCAN";
            this.cbCAN.Size = new System.Drawing.Size(54, 21);
            this.cbCAN.TabIndex = 3;
            if (can == "1") {
                this.cbCAN.SelectedIndex = 0;
            }
            if (can == "2") {
                this.cbCAN.SelectedIndex = 1;
            }
            if (can == "3") {
                this.cbCAN.SelectedIndex = 2;
            }
            if (can == "4") {
                this.cbCAN.SelectedIndex = 3;
            }

            if (can == "5") {
                this.cbCAN.SelectedIndex = 4;
            }
            if (can == "6") {
                this.cbCAN.SelectedIndex = 5;
            }
            if (can == "7") {
                this.cbCAN.SelectedIndex = 6;
            }
            if (can == "8") {
                this.cbCAN.SelectedIndex = 7;
            }

            // 
            // label35
            // 
            this.label35.AutoSize = true;
            this.label35.Location = new System.Drawing.Point(394, 41);
            this.label35.Name = "label35";
            this.label35.Size = new System.Drawing.Size(57, 13);
            this.label35.TabIndex = 1;
            this.label35.Text = "End. CAN:";
            // 
            // label34
            // 
            this.label34.AutoSize = true;
            this.label34.Location = new System.Drawing.Point(208, 25);
            this.label34.Name = "label34";
            this.label34.Size = new System.Drawing.Size(54, 13);
            this.label34.TabIndex = 0;
            this.label34.Text = "Receptor:";
            // 
            // tGuias
            // 
            this.tGuias.Controls.Add(this.tabPage4);
            this.tGuias.Location = new System.Drawing.Point(27, 179);
            this.tGuias.Name = "tGuias";
            this.tGuias.SelectedIndex = 0;
            this.tGuias.Size = new System.Drawing.Size(636, 417);
            this.tGuias.TabIndex = 2;
            this.tGuias.Visible = false;
            // 
            // cbDisp
            // 
            this.cbDisp.DisplayMember = "TX (RF)";
            this.cbDisp.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbDisp.FormattingEnabled = true;
            this.cbDisp.IntegralHeight = false;
            this.cbDisp.Items.AddRange(new object[] {
            "TX (RF)",
            "TAG Ativo (TA)",
            "Cartão (CT/CTW)",
            "TAG Passivo (TP/UHF)"});
            this.cbDisp.Location = new System.Drawing.Point(211, 53);
            this.cbDisp.Name = "cbDisp";
            this.cbDisp.Size = new System.Drawing.Size(142, 21);
            this.cbDisp.TabIndex = 2;
            this.cbDisp.ValueMember = "TX (RF)";
            if (receptor == "RF") {
                this.cbDisp.SelectedIndex = 0;
            }
            else {
                this.cbDisp.SelectedIndex = 1;
            }
            if (receptor == "TA") {
                this.cbDisp.SelectedIndex = 1;
            }
            if (receptor == "CT_CTW") {
                this.cbDisp.SelectedIndex = 2;
            }
            if (receptor == "TP_UHF") {
                this.cbDisp.SelectedIndex = 3;
            }

            this.cbDisp.SelectedIndexChanged += new System.EventHandler(this.cbDisp_SelectedIndexChanged);

            // 
            // fprincipal
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(691, 608);
            this.Controls.Add(this.btConectar);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.tGuias);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.Name = "fprincipal";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Exemplo Guarita IP - v2";
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.tabPage4.ResumeLayout(false);
            this.groupBox9.ResumeLayout(false);
            this.groupBox8.ResumeLayout(false);
            this.groupBox8.PerformLayout();
            this.tGuias.ResumeLayout(false);
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
        private System.IO.Ports.SerialPort spCOM;
        private System.Windows.Forms.TabPage tabPage4;
        private System.Windows.Forms.GroupBox groupBox9;
        private System.Windows.Forms.Button btModoRemoto;
        private System.Windows.Forms.Label label24;
        private System.Windows.Forms.GroupBox groupBox8;
        private System.Windows.Forms.Button btR4;
        private System.Windows.Forms.Button btR3;
        private System.Windows.Forms.Button btR2;
        private System.Windows.Forms.Button btR1;
        private System.Windows.Forms.CheckBox cxEVT;
        private System.Windows.Forms.ComboBox cbCAN;
        private System.Windows.Forms.Label label35;
        private System.Windows.Forms.Label label34;
        private System.Windows.Forms.TabControl tGuias;
        private System.Windows.Forms.ComboBox cbDisp;
    }
}

