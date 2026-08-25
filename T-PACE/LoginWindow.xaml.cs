using System;
using System.Linq;
using System.Windows;
using Dapper;
using Microsoft.Data.Sqlite;

namespace T_PACE
{
    public partial class LoginWindow : Window
    {
        public LoginWindow()
        {
            InitializeComponent();
            Loaded += LoginWindow_Loaded;

            txtEmail.TextChanged += (s, e) => txtMensagem.Text = string.Empty;
            txtSenha.PasswordChanged += (s, e) => txtMensagem.Text = string.Empty;
        }

        private void LoginWindow_Loaded(object? sender, RoutedEventArgs e)
        {
            // Focar no e-mail ao abrir
            txtEmail.Focus();
            txtEmail.SelectAll();
        }

        private void BtnCancelar_Click(object sender, RoutedEventArgs e)
        {
            DialogResult = false;
            Close();
        }

        private void BtnOk_Click(object sender, RoutedEventArgs e)
        {
            string email = txtEmail.Text?.Trim() ?? string.Empty;
            string senha = txtSenha.Password ?? string.Empty;

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(senha))
            {
                txtMensagem.Text = "Preencha e-mail e senha.";
                return;
            }

            try
            {
                using (var conn = new SqliteConnection(DatabaseConfig.ConnectionString))
                {
                    conn.Open();
                    var usuario = conn.QuerySingleOrDefault<dynamic>("SELECT id, nome, email, senha, nivel_acesso FROM tb_usuarios WHERE email = @Email AND senha = @Senha", new { Email = email, Senha = senha });

                    if (usuario != null)
                    {
                        // Armazenar usuário na sessão
                        Session.CurrentUserId = (int)usuario.id;

                        // Abrir sessão de caixa (inserir tb_sessao_caixa)
                        var now = DateTime.Now;
                        long sessaoId = conn.ExecuteScalar<long>(@"INSERT INTO tb_sessao_caixa (id_caixa, id_usuario, data_abertura, valor_fundo_troco, status) VALUES (@IdCaixa, @IdUsuario, @DataAbertura, @ValorFundoTroco, @Status); SELECT last_insert_rowid();",
                            new { IdCaixa = 1, IdUsuario = (int)usuario.id, DataAbertura = now, ValorFundoTroco = 0m, Status = 1 });

                        Session.CurrentSessaoCaixaId = (int)sessaoId;

                        DialogResult = true;
                        Close();
                        return;
                    }
                    else
                    {
                        txtMensagem.Text = "Usuário ou senha inválidos.";
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Erro ao validar usuário: {ex.Message}", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
    }

    public static class Session
    {
        public static int CurrentUserId { get; set; } = 0;
        public static int CurrentSessaoCaixaId { get; set; } = 0;
    }
}
