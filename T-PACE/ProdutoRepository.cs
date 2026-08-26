using Dapper;
using Microsoft.Data.Sqlite;
using System.Collections.Generic;
using System.Linq;

namespace T_PACE
{
    public class ProdutoRepository
    {
        public Produto BuscarPorCodigoDeBarras(string codigoBarras)
        {
            using (var connection = new SqliteConnection(DatabaseConfig.ConnectionString))
            {
                string sql = "SELECT * FROM tb_produtos WHERE codigo_barras = @Codigo";
                return connection.QueryFirstOrDefault<Produto>(sql, new { Codigo = codigoBarras });
            }
        }

        // NOVO MÉTODO DE BUSCA POR NOME (F4)
        public List<Produto> BuscarPorNome(string parteNome)
        {
            using (var connection = new SqliteConnection(DatabaseConfig.ConnectionString))
            {
                // Usamos LIKE %termo% para encontrar a palavra em qualquer parte do nome
                // Limitamos a 50 itens para a pesquisa ser extremamente rápida
                string sql = "SELECT * FROM tb_produtos WHERE nome LIKE @Nome LIMIT 50";
                return connection.Query<Produto>(sql, new { Nome = $"%{parteNome}%" }).ToList();
            }
        }
    }
}