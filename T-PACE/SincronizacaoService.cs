using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;
using System.Windows;
using Microsoft.Data.Sqlite;
using Dapper;

namespace T_PACE
{
    public static class SincronizacaoService
    {
        // Cole a URL do seu Cloudflare Worker aqui
        private static readonly string apiUrl = "https://tpace-api.whyguiih.workers.dev/";

        public static async Task SincronizarProdutosAsync()
        {
            using (var client = new HttpClient())
            {
                try
                {
                    // 1. Puxa o JSON do Cloudflare
                    var response = await client.GetStringAsync(apiUrl);

                    // 2. Converte o JSON
                    var produtosCloudflare = JsonSerializer.Deserialize<List<Produto>>(response);

                    if (produtosCloudflare != null && produtosCloudflare.Count > 0)
                    {
                        using (var connection = new SqliteConnection(DatabaseConfig.ConnectionString))
                        {
                            connection.Open();

                            foreach (var p in produtosCloudflare)
                            {
                                // O comando UPSERT do SQLite
                                string sql = @"
                                    INSERT INTO tb_produtos (id, codigo_barras, nome, custo, preco_venda, ncm, cest, aliquotas_imposto, quantidade, valor_promocional, unidade_venda, em_promocao, lote, validade, id_filial) 
                                    VALUES (@id, @codigo_barras, @nome, @custo, @preco_venda, @ncm, @cest, @aliquotas_imposto, @quantidade, @valor_promocional, @unidade_venda, @em_promocao, @lote, @validade, @id_filial)
                                    ON CONFLICT(id) DO UPDATE SET 
                                        codigo_barras = excluded.codigo_barras,
                                        nome = excluded.nome,
                                        custo = excluded.custo,
                                        preco_venda = excluded.preco_venda,
                                        ncm = excluded.ncm,
                                        cest = excluded.cest,
                                        aliquotas_imposto = excluded.aliquotas_imposto,
                                        quantidade = excluded.quantidade,
                                        valor_promocional = excluded.valor_promocional,
                                        unidade_venda = excluded.unidade_venda,
                                        em_promocao = excluded.em_promocao,
                                        lote = excluded.lote,
                                        validade = excluded.validade,
                                        id_filial = excluded.id_filial;
                                ";

                                connection.Execute(sql, p);
                            }
                        }
                    }
                }
                catch (HttpRequestException)
                {
                    // Erro de internet ou API fora do ar. Deixamos passar em branco para o caixa funcionar offline.
                }
                catch (Exception ex)
                {
                    // Agora se for um erro de código ou banco de dados, o sistema vai te avisar!
                    Application.Current.Dispatcher.Invoke(() =>
                    {
                        MessageBox.Show($"Erro interno na sincronização do banco: {ex.Message}", "Erro de Sincronização", MessageBoxButton.OK, MessageBoxImage.Error);
                    });
                }
            }
        }
    }
}