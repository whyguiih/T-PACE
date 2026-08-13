using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Threading.Tasks;
using System.Windows;
using Microsoft.Data.Sqlite;
using Dapper;

namespace T_PACE
{
    // Tradutor para valores Decimais vazios ("") vindos do Cloudflare
    public class DecimalNullConverter : JsonConverter<decimal?>
    {
        public override decimal? Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
        {
            if (reader.TokenType == JsonTokenType.String)
            {
                string valor = reader.GetString();
                if (string.IsNullOrWhiteSpace(valor)) return null;

                if (decimal.TryParse(valor, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out decimal result))
                    return result;

                return null;
            }
            if (reader.TokenType == JsonTokenType.Number)
            {
                return reader.GetDecimal();
            }
            return null;
        }

        public override void Write(Utf8JsonWriter writer, decimal? value, JsonSerializerOptions options)
        {
            if (value.HasValue) writer.WriteNumberValue(value.Value);
            else writer.WriteNullValue();
        }
    }

    // NOVO: Tradutor para Booleans (Converte 0/1 do SQLite para false/true do C#)
    public class BooleanConverter : JsonConverter<bool>
    {
        public override bool Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
        {
            if (reader.TokenType == JsonTokenType.True) return true;
            if (reader.TokenType == JsonTokenType.False) return false;

            // Se o Cloudflare mandar como número (ex: 0 ou 1)
            if (reader.TokenType == JsonTokenType.Number)
            {
                return reader.GetInt32() == 1;
            }

            // Se o Cloudflare mandar como texto (ex: "0" ou "1")
            if (reader.TokenType == JsonTokenType.String)
            {
                string valor = reader.GetString();
                if (valor == "1" || valor?.ToLower() == "true") return true;
                if (valor == "0" || valor?.ToLower() == "false" || string.IsNullOrWhiteSpace(valor)) return false;
            }

            return false; // Padrão de segurança
        }

        public override void Write(Utf8JsonWriter writer, bool value, JsonSerializerOptions options)
        {
            writer.WriteBooleanValue(value);
        }
    }

    public static class SincronizacaoService
    {
        // Cole a URL do seu Cloudflare Worker aqui
        private static readonly string apiUrl = "https://tpace-api.whyguiih.workers.dev/api/app/produtos";

        public static async Task SincronizarProdutosAsync()
        {
            using (var client = new HttpClient())
            {
                try
                {
                    // Puxa o JSON do Cloudflare
                    var response = await client.GetStringAsync(apiUrl);

                    // Avisamos o C# para usar os nossos dois tradutores flexíveis
                    var opcoesJson = new JsonSerializerOptions();
                    opcoesJson.Converters.Add(new DecimalNullConverter());
                    opcoesJson.Converters.Add(new BooleanConverter());

                    // Converte o JSON usando as novas regras
                    var produtosCloudflare = JsonSerializer.Deserialize<List<Produto>>(response, opcoesJson);

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
                    // Erro de internet ou API fora do ar. Deixamos passar em branco.
                }
                catch (Exception ex)
                {
                    Application.Current.Dispatcher.Invoke(() =>
                    {
                        MessageBox.Show($"Erro interno na sincronização do banco: {ex.Message}", "Erro de Sincronização", MessageBoxButton.OK, MessageBoxImage.Error);
                    });
                }
            }
        }
    }
}