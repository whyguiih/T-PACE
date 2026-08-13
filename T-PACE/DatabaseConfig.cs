using Microsoft.Data.Sqlite;
using System.IO;

namespace T_PACE
{
    public static class DatabaseConfig
    {
        // O banco será salvo na mesma pasta onde o .exe estiver rodando
        private static string dbPath = Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory, "tpace_pdv.sqlite");

        // String de conexão padrão do SQLite
        public static string ConnectionString => $"Data Source={dbPath};";

        // Método para testar/criar o banco na primeira vez que o app abrir
        public static void InicializarBanco()
        {
            if (!File.Exists(dbPath))
            {
                using (var connection = new SqliteConnection(ConnectionString))
                {
                    connection.Open();
                    // Aqui depois colocaremos o comando para rodar aquele seu script SQL de criação das tabelas
                }
            }
        }
    }
}