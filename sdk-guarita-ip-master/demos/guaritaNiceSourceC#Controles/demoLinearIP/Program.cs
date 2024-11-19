using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Windows.Forms;

//Programado por HeroRickyGAMES
//É gambiarra? É mais funciona!

namespace demoLinearIP
{
    static class Program
    {
        /// <summary>
        /// Ponto de entrada principal para o aplicativo.
        /// </summary>
        ///
        /// 
        ///Todo port do programa para cmd
        ///
        [STAThread]
         static void Main(string[] args) {
            String ip = "";
            String porta = "";

            //Check users
            String checkusers = "";

            //Criar usuario
            String createuser = "";
            String tipo = "";
            String serial = "";
            String contador = "";
            String unidade = "";
            String bloco = "";
            String identificacao = "";
            String grupo = "";
            String marca = "";
            String cor = "";
            String placa = "";
            String receptor1 = "";
            String receptor2 = "";
            String receptor3 = "";
            String receptor4 = "";
            String receptor5 = "";
            String receptor6 = "";
            String receptor7 = "";
            String receptor8 = "";

            //DeleteUser
            String deleteUser = "";
            String idGuarita = "";

            //EditarUsuario
            String editUser = "";

            if (args.Length > 0) {
                foreach (var arg in args) {
                    if (arg.Contains("--ip") ||
                        args.Contains("--porta") || args.Contains("--checkusers") ||
                        args.Contains("--createuser") || args.Contains("--deleteuser")
                        || args.Contains("--idguarita")) {

                        for (int i = 0; i < args.Length; i++) {
                            if (i + 1 < arg.Length) {
                                ip = args[i + 1];
                                porta = args[i + 3];

                                if (args.Contains("--checkusers")) {
                                    checkusers = args[i + 4];
                                }
                                if (args.Contains("--createuser") || args.Contains("--tipo") ||
                                    args.Contains("--serial") || args.Contains("--contador") ||
                                    args.Contains("--unidade") || args.Contains("--bloco") ||
                                    args.Contains("--identificacao") || args.Contains("--grupo") ||
                                    args.Contains("--marca") || args.Contains("--cor") ||
                                    args.Contains("--placa") || args.Contains("--receptor1")) {
                                    createuser = args[i + 4];
                                    tipo = args[i + 6];
                                    serial = args[i + 8];
                                    contador = args[i + 10];
                                    unidade = args[i + 12];
                                    bloco = args[i + 14];
                                    identificacao = args[i + 16];
                                    grupo = args[i + 18];
                                    marca = args[i + 20];
                                    cor = args[i + 22];
                                    placa = args[i + 24];
                                    receptor1 = args[i + 26];
                                    receptor2 = args[i + 28];
                                    receptor3 = args[i + 30];
                                    receptor4 = args[i + 32];
                                    receptor5 = args[i + 34];
                                    receptor6 = args[i + 36];
                                    receptor7 = args[i + 38];
                                    receptor8 = args[i + 40];
                                }
                                if (args.Contains("--deleteuser") || args.Contains("--idguarita")) {
                                    deleteUser = args[i + 4];
                                    idGuarita = args[i + 6];
                                    Console.WriteLine(idGuarita);
                                }

                                iniciarApp(args, ip, porta, checkusers,
                                    createuser, tipo, serial,
                                    contador, unidade, bloco,
                                    identificacao, grupo,
                                    marca, cor, placa,
                                    receptor1, receptor2,
                                    receptor3, receptor4,
                                    receptor5, receptor6,
                                    receptor7, receptor8,
                                    deleteUser, idGuarita);
                                return;
                            }
                        }
                    }
                }
            }
            else {
                iniciarApp(args, ip, porta, checkusers,
                    createuser, tipo, serial,
                    contador, unidade, bloco,
                    identificacao, grupo, marca,
                    cor, placa, receptor1, receptor2,
                    receptor3, receptor4, receptor5,
                    receptor6, receptor7, receptor8,
                    deleteUser, idGuarita);
            }
        }
        static void iniciarApp(string[] argumentos, String ip, String porta, String checkUsers, String createuser, String tipo, String serial, String contador , String unidade, String bloco, String identificacao, String grupo, String marca, String cor, String placa, String receptor1, String receptor2, String receptor3, String receptor4, String receptor5, String receptor6, String receptor7, String receptor8, String deleteUser, String idGuarita) {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new fprincipal(ip, porta, checkUsers,
                createuser, tipo, serial, contador, unidade,
                bloco, identificacao, grupo,
                marca, cor, placa, receptor1,
                receptor2, receptor3, receptor4,
                receptor5, receptor6, receptor7,
                receptor8, deleteUser, idGuarita));
        }
    }
}
