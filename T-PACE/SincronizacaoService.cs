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
    // NOVO: Conversor universal de Decimais (Resolve o erro do Custo/Preço_Venda)
    public class DecimalConverter : JsonConverter<decimal>
    {
        public override decimal Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
        {
            if (reader.TokenType == JsonTokenType.String)
            {
                string valor = reader.GetString();
                if (string.IsNullOrWhiteSpace(valor)) return 0m;
                if (decimal.TryParse(valor, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out decimal result))
                    return result;
                return 0m;
            }
            if (reader.TokenType == JsonTokenType.Number) return reader.GetDecimal();
            return 0m;
        }

        public override void Write(Utf8JsonWriter writer, decimal value, JsonSerializerOptions options)
        {
            writer.WriteNumberValue(value);
        }
    }

    public class DoubleNullConverter : JsonConverter<double?>
    {
        public override double? Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
        {
            if (reader.TokenType == JsonTokenType.String)
            {
                string valor = reader.GetString();
                if (string.IsNullOrWhiteSpace(valor)) return null;
                if (double.TryParse(valor, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out double result))
                    return result;
                return null;
            }
            if (reader.TokenType == JsonTokenType.Number) return reader.GetDouble();
            return null;
        }

        public override void Write(Utf8JsonWriter writer, double? value, JsonSerializerOptions options)
        {
            if (value.HasValue) writer.WriteNumberValue(value.Value);
            else writer.WriteNullValue();
        }
    }

    public class IntBoolConverter : JsonConverter<int>
    {
        public override int Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
        {
            if (reader.TokenType == JsonTokenType.True) return 1;
            if (reader.TokenType == JsonTokenType.False) return 0;
            if (reader.TokenType == JsonTokenType.Number) return reader.GetInt32();
            if (reader.TokenType == JsonTokenType.String)
            {
                string valor = reader.GetString();
                if (valor == "1" || valor?.ToLower() == "true") return 1;
                return 0;
            }
            return 0;
        }

        public override void Write(Utf8JsonWriter writer, int value, JsonSerializerOptions options)
        {
            writer.WriteNumberValue(value);
        }
    }

    public static class SincronizacaoService
    {
        private static readonly string apiUrl = "https://tpace-api.whyguiih.workers.dev/api/app/produtos";

        public static async Task SincronizarProdutosAsync()
        {
            using (var client = new HttpClient())
            {
                try
                {
                    var response = await client.GetStringAsync(apiUrl);

                    var opcoesJson = new JsonSerializerOptions();
                    opcoesJson.Converters.Add(new DecimalConverter()); // Adicionado
                    opcoesJson.Converters.Add(new DoubleNullConverter());
                    opcoesJson.Converters.Add(new IntBoolConverter());

                    var produtosCloudflare = JsonSerializer.Deserialize<List<Produto>>(response, opcoesJson);

                    if (produtosCloudflare != null && produtosCloudflare.Count > 0)
                    {
                        using (var connection = new SqliteConnection(DatabaseConfig.ConnectionString))
                        {
                            connection.Open();

                            foreach (var p in produtosCloudflare)
                            {
                                string sql = @"
                                    INSERT INTO tb_produtos (id, codigo_barras, nome, custo, preco_venda, ncm, cest, aliquotas_imposto, quantidade, valor_promocional, unidade_venda, em_promocao, lote, validade, id_filial, quantidade_minima) 
                                    VALUES (@id, @codigo_barras, @nome, @custo, @preco_venda, @ncm, @cest, @aliquotas_imposto, @quantidade, @valor_promocional, @unidade_venda, @em_promocao, @lote, @validade, @id_filial, @quantidade_minima)
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
                                        id_filial = excluded.id_filial,
                                        quantidade_minima = excluded.quantidade_minima;
                                ";

                                connection.Execute(sql, p);
                            }
                        }
                    }
                }
                catch (HttpRequestException) { }
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