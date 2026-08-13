using Dapper;
using Microsoft.Data.Sqlite;

namespace T_PACE
{
    public class ProdutoRepository
    {
        public Produto BuscarPorCodigoDeBarras(string codigoBarras)
        {
            using (var connection = new SqliteConnection(DatabaseConfig.ConnectionString))
            {
                // A query busca o produto na tb_produtos usando o código de barras fornecido
                string sql = "SELECT * FROM tb_produtos WHERE codigo_barras = @Codigo";

                // O Dapper executa a query e já devolve o objeto Produto preenchido
                return connection.QueryFirstOrDefault<Produto>(sql, new { Codigo = codigoBarras });
            }
        }
    }
}