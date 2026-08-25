using System;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Windows;
using Dapper;
using Microsoft.Data.Sqlite;

namespace T_PACE
{
    public partial class LoginWindow : Window
    {
        // URL da rota POST do seu Cloudflare Worker que faz a autenticação
        private static readonly string apiLoginUrl = "https://tpace-api.whyguiih.workers.dev/api/web/login";

        public LoginWindow()
        {
            InitializeComponent();
            Loaded += LoginWindow_Loaded;
            txtUsuario.TextChanged += (s, e) => txtMensagem.Text = string.Empty;
            txtSenha.PasswordChanged += (s, e) => txtMensagem.Text = string.Empty;
        }

        private void LoginWindow_Loaded(object sender, RoutedEventArgs e)
        {
            txtUsuario.Focus();
            txtUsuario.SelectAll();
        }

        private void BtnCancelar_Click(object sender, RoutedEventArgs e)
        {
            DialogResult = false;
        }

        private async void BtnOk_Click(object sender, RoutedEventArgs e)
        {
            string usuario = txtUsuario.Text?.Trim() ?? string.Empty;
            string senha = txtSenha.Password ?? string.Empty;

            if (string.IsNullOrEmpty(usuario) || string.IsNullOrEmpty(senha))
            {
                txtMensagem.Text = "Preencha o usuário e a senha.";
                return;
            }

            // Desativa o botão enquanto a API do Cloudflare responde
            btnOk.IsEnabled = false;
            txtMensagem.Text = "Autenticando na nuvem...";

            try
            {
                using (var client = new HttpClient())
                {
                    var jsonRequest = JsonSerializer.Serialize(new { nome = usuario, senha = senha });
                    var content = new StringContent(jsonRequest, Encoding.UTF8, "application/json");

                    var response = await client.PostAsync(apiLoginUrl, content);
                    var responseString = await response.Content.ReadAsStringAsync();

                    if (response.IsSuccessStatusCode)
                    {
                        var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
                        var resultado = JsonSerializer.Deserialize<LoginResponse>(responseString, options);

                        if (resultado != null && resultado.sucesso)
                        {
                            using (var conn = new SqliteConnection(DatabaseConfig.ConnectionString))
                            {
                                conn.Open();

                                // 1. NOVO: Sincroniza o usuário que veio da nuvem com o banco local
                                // Assim o banco local sempre reconhece o ID do usuário (evita erro de Foreign Key)
                                conn.Execute(@"
                                    INSERT INTO tb_usuarios (id, nome, nivel_acesso) 
                                    VALUES (@Id, @Nome, @NivelAcesso)
                                    ON CONFLICT(id) DO UPDATE SET 
                                        nome = excluded.nome,
                                        nivel_acesso = excluded.nivel_acesso;",
                                    new
                                    {
                                        Id = resultado.usuario.id,
                                        Nome = resultado.usuario.nome,
                                        NivelAcesso = resultado.usuario.nivel_acesso
                                    });

                                // 2. Registra os dados da sessão
                                Session.CurrentUserId = resultado.usuario.id;
                                Session.CurrentUserName = resultado.usuario.nome;

                                var now = DateTime.Now;
                                long sessaoId = conn.ExecuteScalar<long>(
                                    @"INSERT INTO tb_sessao_caixa (id_caixa, id_usuario, data_abertura, valor_fundo_troco, status)
                                       VALUES (@IdCaixa, @IdUsuario, @DataAbertura, @ValorFundoTroco, @Status);
                                       SELECT last_insert_rowid();",
                                    new { IdCaixa = 1, IdUsuario = Session.CurrentUserId, DataAbertura = now, ValorFundoTroco = 0m, Status = 1 });

                                Session.CurrentSessaoCaixaId = Convert.ToInt32(sessaoId);
                            }

                            DialogResult = true;
                        }
                        else
                        {
                            txtMensagem.Text = "Erro ao processar login remoto.";
                            btnOk.IsEnabled = true;
                        }
                    }
                    else
                    {
                        txtMensagem.Text = "Usuário ou senha incorretos.";
                        btnOk.IsEnabled = true;
                    }
                }
            }
            catch (Exception ex)
            {
                // NOVO: Mostra o erro exato na tela (seja de banco ou de rede)
                txtMensagem.Text = $"Erro: {ex.Message}";
                btnOk.IsEnabled = true;
            }
        }
    }

    // Classes moldes para o C# conseguir ler as informações devolvidas pela sua API do Cloudflare[cite: 12]
    public class LoginResponse
    {
        public bool sucesso { get; set; }
        public UsuarioLogin usuario { get; set; } = new UsuarioLogin();
    }

    public class UsuarioLogin
    {
        public int id { get; set; }
        public string nome { get; set; } = string.Empty;
        public int nivel_acesso { get; set; }
    }

    public static class Session
    {
        public static int CurrentUserId { get; set; } = 0;
        public static string CurrentUserName { get; set; } = string.Empty; // NOVO
        public static int CurrentSessaoCaixaId { get; set; } = 0;
    }
}