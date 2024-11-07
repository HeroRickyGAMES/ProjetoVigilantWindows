using System;
using System.Collections.Generic;
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
        static void Main(string[] args)
        {
            String ip = "";
            String porta = "";
            String receptor = "";
            String can = "";
            String rele = "";
            if (args.Length > 0) {
                // Itera sobre os argumentos
                foreach (var arg in args)
                {
                    // Verifica se o argumento é "--help"
                    if (arg.Contains("--ip") || args.Contains("--porta") || arg.Contains("--ip") || arg.Contains("--receptor") || arg.Contains("--CAN") || arg.Contains("--rele"))
                    {
                        for (int i = 0; i < args.Length; i++)
                        {
                            if (i + 1 < arg.Length)
                            {
                                ip = args[i + 1];
                                porta = args[i + 3];
                                receptor = args[i + 5];
                                can = args[i + 7];
                                rele = args[i + 9];
                                iniciarApp(args, ip, porta, receptor, can, rele);
                                return;
                            }
                        }
                    }
                }
            }
            iniciarApp(args, ip, porta, receptor, can, rele);
        }
        static void iniciarApp(string[] argumentos, String ip, String porta, String recept, String cam, String canal)
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new fprincipal(ip , porta, recept, cam, canal));       
        }
    }
}
