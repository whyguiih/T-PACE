using Dapper;
using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Input;

namespace T_PACE
{
    public partial class MainWindow : Window
    {
        private ProdutoRepository _repositorio;
        public ObservableCollection<ItemCupom> Carrinho { get; set; }

        private decimal _descontoManualVenda = 0m;

        public MainWindow()
        {
            InitializeComponent();
            btnFinalizar.Click += (s, e) => AbrirTelaPagamento();
            txtBusca.KeyDown += TxtBusca_KeyDown;

            Task.Run(async () => {
                await SincronizacaoService.SincronizarProdutosAsync();
                await SincronizacaoService.SincronizarVendasPendentesAsync(); // NOVO: Roda a fila ao abrir o PDV
            });

            // ATUALIZANDO O PERFIL VISUAL
            if (!string.IsNullOrEmpty(Session.CurrentUserName))
            {
                txtNomeUsuario.Text = Session.CurrentUserName;
                txtIniciaisUsuario.Text = Session.CurrentUserName.Length > 1
                    ? Session.CurrentUserName.Substring(0, 2).ToUpper()
                    : Session.CurrentUserName.ToUpper();
            }

            try
            {
                DatabaseConfig.InicializarBanco();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Erro ao criar banco local: {ex.Message}");
            }

            _repositorio = new ProdutoRepository();
            Carrinho = new ObservableCollection<ItemCupom>();

            listaCupom.ItemsSource = Carrinho;
            txtBusca.KeyDown += TxtBusca_KeyDown;

            Task.Run(async () => await SincronizacaoService.SincronizarProdutosAsync());
        }

        // Adicionamos a palavra 'async' aqui na assinatura do método
        private async void TxtBusca_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                string codigo = txtBusca.Text.Trim();
                if (!string.IsNullOrEmpty(codigo))
                {
                    BiparProduto(codigo);
                }
            }
            else if (e.Key == Key.F3)
            {
                AbrirTelaCancelamento();
            }
            else if (e.Key == Key.F4)
            {
                AbrirTelaBusca();
            }
            else if (e.Key == Key.F5)
            {
                AbrirTelaDesconto();
            }
            else if (e.Key == Key.F2)
            {
                AbrirTelaPagamento();
            }
            // NOVO: Atalho F9 (Sair do Caixa e Sincronizar)
            else if (e.Key == Key.F9)
            {
                await SairDoCaixa();
            }
        }

        private void BiparProduto(string codigo)
        {
            try
            {
                var produto = _repositorio.BuscarPorCodigoDeBarras(codigo);

                if (produto != null)
                {
                    decimal precoCheio = produto.preco_venda;
                    decimal descontoDoItem = 0m;

                    if (produto.em_promocao && produto.valor_promocional.HasValue)
                    {
                        decimal valorPromo = Convert.ToDecimal(produto.valor_promocional.Value);
                        if (valorPromo > 0 && valorPromo < precoCheio)
                        {
                            descontoDoItem = precoCheio - valorPromo;
                        }
                    }

                    decimal precoCobrado = precoCheio - descontoDoItem;

                    var itemExistente = Carrinho.FirstOrDefault(c => c.Codigo == produto.codigo_barras);

                    if (itemExistente != null)
                    {
                        itemExistente.Quantidade += 1;
                        itemExistente.Total = itemExistente.Quantidade * precoCobrado;
                    }
                    else
                    {
                        Carrinho.Add(new ItemCupom
                        {
                            IdProduto = produto.id,
                            Codigo = produto.codigo_barras,
                            Descricao = produto.nome,
                            Quantidade = 1,
                            PrecoUnitario = precoCheio,
                            DescontoUnitario = descontoDoItem,
                            Total = precoCobrado
                        });
                    }

                    txtUltimoNome.Text = produto.nome;
                    txtUltimoDetalhes.Text = $"Cód: {produto.codigo_barras}  |  Qtd: 1 un";
                    txtUltimoPreco.Text = $"R$ {precoCobrado:N2}";

                    AtualizarTotais();
                    txtBusca.Clear();
                }
                else
                {
                    MessageBox.Show("Produto não cadastrado!", "Aviso", MessageBoxButton.OK, MessageBoxImage.Warning);
                    txtBusca.SelectAll();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Erro na busca: {ex.Message}", "Erro Crítico", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        // ==========================================
        // LÓGICA DE CANCELAMENTO (F3)
        // ==========================================
        private void AbrirTelaCancelamento()
        {
            if (Carrinho.Count == 0)
            {
                MessageBox.Show("Não há itens no cupom para cancelar.", "Aviso", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            OverlayCancelamento.Visibility = Visibility.Visible;
            txtBuscaCancelamento.Clear();
            txtBuscaCancelamento.Focus();

            txtBuscaCancelamento.KeyDown -= TxtBuscaCancelamento_KeyDown;
            txtBuscaCancelamento.KeyDown += TxtBuscaCancelamento_KeyDown;
        }

        private void TxtBuscaCancelamento_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                string codigo = txtBuscaCancelamento.Text.Trim();
                if (!string.IsNullOrEmpty(codigo))
                {
                    CancelarProduto(codigo);
                }
            }
            else if (e.Key == Key.Escape)
            {
                FecharTelaCancelamento();
            }
        }

        private void FecharTelaCancelamento()
        {
            OverlayCancelamento.Visibility = Visibility.Collapsed;
            txtBusca.Focus();
        }

        private void CancelarProduto(string codigo)
        {
            var itemExistente = Carrinho.FirstOrDefault(c => c.Codigo == codigo);

            if (itemExistente != null)
            {
                itemExistente.Quantidade -= 1;

                if (itemExistente.Quantidade <= 0)
                {
                    Carrinho.Remove(itemExistente);
                }
                else
                {
                    itemExistente.Total = itemExistente.Quantidade * (itemExistente.PrecoUnitario - itemExistente.DescontoUnitario);
                }

                txtUltimoNome.Text = "ITEM CANCELADO";
                txtUltimoDetalhes.Text = $"Cód: {codigo} removido";
                txtUltimoPreco.Text = $"- R$ {itemExistente.PrecoUnitario - itemExistente.DescontoUnitario:N2}";

                AtualizarTotais();
                FecharTelaCancelamento();
            }
            else
            {
                MessageBox.Show("Este item não está no cupom atual!", "Erro", MessageBoxButton.OK, MessageBoxImage.Warning);
                txtBuscaCancelamento.SelectAll();
            }
        }

        // ==========================================
        // LÓGICA DE BUSCA POR NOME (F4)
        // ==========================================
        private void AbrirTelaBusca()
        {
            OverlayBusca.Visibility = Visibility.Visible;
            txtBuscaNome.Clear();
            listaResultadosBusca.ItemsSource = null;
            txtBuscaNome.Focus();
        }

        private void FecharTelaBusca()
        {
            OverlayBusca.Visibility = Visibility.Collapsed;
            txtBusca.Focus(); // Devolve o foco para o leitor de código de barras
        }

        // Pesquisa no banco enquanto o usuário digita
        private void txtBuscaNome_TextChanged(object sender, System.Windows.Controls.TextChangedEventArgs e)
        {
            string termo = txtBuscaNome.Text.Trim();

            // Só pesquisa a partir de 2 letras, para evitar sobrecarregar o banco
            if (termo.Length >= 2)
            {
                var resultados = _repositorio.BuscarPorNome(termo);
                listaResultadosBusca.ItemsSource = resultados;
            }
            else
            {
                listaResultadosBusca.ItemsSource = null;
            }
        }

        // Controle do teclado no campo de texto
        private void txtBuscaNome_PreviewKeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Escape)
            {
                FecharTelaBusca();
                e.Handled = true;
            }
            else if (e.Key == Key.Down && listaResultadosBusca.Items.Count > 0)
            {
                // Impede que o TextBox continue processando a seta
                e.Handled = true;

                // Move o foco para a lista e seleciona o primeiro item
                listaResultadosBusca.Focus();
                listaResultadosBusca.SelectedIndex = 0;

                // Força o "foco físico" no primeiro item da lista para as setas continuarem funcionando
                var item = (System.Windows.Controls.ListBoxItem)listaResultadosBusca.ItemContainerGenerator.ContainerFromIndex(0);
                item?.Focus();
            }
            else if (e.Key == Key.Enter && listaResultadosBusca.Items.Count > 0)
            {
                listaResultadosBusca.SelectedIndex = 0;
                SelecionarProdutoBusca();
                e.Handled = true;
            }
        }

        // Controle do teclado navegando dentro da lista
        private void listaResultadosBusca_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                SelecionarProdutoBusca();
            }
            else if (e.Key == Key.Escape)
            {
                txtBuscaNome.Focus(); // Aperta Esc, devolve o foco pra digitar de novo
            }
        }

        // Para quem prefere usar o mouse (2 cliques)
        private void listaResultadosBusca_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            SelecionarProdutoBusca();
        }

        private void SelecionarProdutoBusca()
        {
            if (listaResultadosBusca.SelectedItem is Produto produtoSelecionado)
            {
                FecharTelaBusca();

                // MAGIA: Reaproveita a mesma função de ler o código de barras!
                BiparProduto(produtoSelecionado.codigo_barras);
            }
        }

        // ==========================================
        // LÓGICA DE DESCONTO GLOBAL (F5)
        // ==========================================
        private void AbrirTelaDesconto()
        {
            if (Carrinho.Count == 0)
            {
                MessageBox.Show("Adicione itens ao cupom antes de aplicar um desconto.", "Aviso", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            OverlayDesconto.Visibility = Visibility.Visible;

            // Se já houver um desconto aplicado antes, mostra ele. Se não, limpa.
            txtValorDesconto.Text = _descontoManualVenda > 0 ? _descontoManualVenda.ToString("N2") : "";
            txtValorDesconto.SelectAll(); // Seleciona tudo para o operador sobrescrever fácil
            txtValorDesconto.Focus();
        }

        private void FecharTelaDesconto()
        {
            OverlayDesconto.Visibility = Visibility.Collapsed;
            txtBusca.Focus();
        }

        private void txtValorDesconto_PreviewKeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Escape)
            {
                FecharTelaDesconto();
                e.Handled = true;
            }
            else if (e.Key == Key.Enter)
            {
                AplicarDescontoManual();
                e.Handled = true;
            }
        }

        private void AplicarDescontoManual()
        {
            string entrada = txtValorDesconto.Text.Trim();

            // Se o operador limpou o campo e deu Enter, removemos o desconto
            if (string.IsNullOrEmpty(entrada))
            {
                _descontoManualVenda = 0m;
                AtualizarTotais();
                FecharTelaDesconto();
                return;
            }

            // Descobre se o operador digitou o símbolo de %
            bool isPorcentagem = entrada.Contains("%");

            // Limpa a string para pegar só o número puro (tira R$, %, espaços e arruma a vírgula)
            entrada = entrada.Replace("R$", "").Replace("%", "").Replace(" ", "").Replace(",", ".");

            if (decimal.TryParse(entrada, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out decimal valorDigitado))
            {
                // Descobre quanto a venda está custando agora (já abatendo os descontos de promoção)
                decimal subtotalBruto = Carrinho.Sum(i => i.PrecoUnitario * i.Quantidade);
                decimal descontosDePromocoes = Carrinho.Sum(i => i.DescontoUnitario * i.Quantidade);
                decimal totalAtualVenda = subtotalBruto - descontosDePromocoes;

                decimal valorDescontoFinal = 0m;

                if (isPorcentagem)
                {
                    // Regra de 3 básica: (Valor Total * Porcentagem) / 100
                    valorDescontoFinal = totalAtualVenda * (valorDigitado / 100m);
                }
                else
                {
                    // Se não tem %, é desconto em Reais direto
                    valorDescontoFinal = valorDigitado;
                }

                // Trava de segurança: O desconto não pode ser maior que a venda nem negativo
                if (valorDescontoFinal > totalAtualVenda || valorDescontoFinal < 0)
                {
                    MessageBox.Show("O desconto não pode ser negativo ou ultrapassar o valor total da venda!", "Aviso", MessageBoxButton.OK, MessageBoxImage.Warning);
                    txtValorDesconto.SelectAll();
                    return;
                }

                // Aplica na variável global e atualiza a tela
                _descontoManualVenda = valorDescontoFinal;
                AtualizarTotais();
                FecharTelaDesconto();
            }
            else
            {
                MessageBox.Show("Valor inválido. Digite um número (ex: 10,50) ou uma porcentagem (ex: 15%).", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
                txtValorDesconto.SelectAll();
            }
        }

        private void AtualizarTotais()
        {
            decimal subtotalBruto = Carrinho.Sum(i => i.PrecoUnitario * i.Quantidade);
            decimal descontosDePromocoes = Carrinho.Sum(i => i.DescontoUnitario * i.Quantidade);
            decimal descontosTotais = descontosDePromocoes + _descontoManualVenda;
            decimal totalAPagar = subtotalBruto - descontosTotais;

            txtSubtotal.Text = $"R$ {subtotalBruto:N2}";
            txtDesconto.Text = $"- R$ {descontosTotais:N2}";
            txtTotal.Text = $"R$ {totalAPagar:N2}";
        }

        private void txtBusca_TextChanged(object sender, System.Windows.Controls.TextChangedEventArgs e)
        {

        }

        // ==========================================
        // LÓGICA DE PAGAMENTO E FINALIZAÇÃO (F2)
        // ==========================================
        private void AbrirTelaPagamento()
        {
            if (Carrinho.Count == 0)
            {
                MessageBox.Show("Adicione itens ao cupom antes de finalizar a venda.", "Aviso", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            decimal subtotalBruto = Carrinho.Sum(i => i.PrecoUnitario * i.Quantidade);
            decimal descontosDePromocoes = Carrinho.Sum(i => i.DescontoUnitario * i.Quantidade);
            decimal totalAPagar = subtotalBruto - (descontosDePromocoes + _descontoManualVenda);

            txtPagamentoTotal.Text = $"R$ {totalAPagar:N2}";
            txtValorRecebido.Text = totalAPagar.ToString("N2"); // Sugere o valor exato inicialmente
            txtTroco.Text = "R$ 0,00";

            OverlayPagamento.Visibility = Visibility.Visible;
            cmbMetodoPagamento.SelectedIndex = 0; // Reseta pro Dinheiro
            txtValorRecebido.SelectAll();
            txtValorRecebido.Focus();
        }

        private void FecharTelaPagamento()
        {
            OverlayPagamento.Visibility = Visibility.Collapsed;
            txtBusca.Focus();
        }

        private void txtValorRecebido_TextChanged(object sender, System.Windows.Controls.TextChangedEventArgs e)
        {
            decimal subtotalBruto = Carrinho.Sum(i => i.PrecoUnitario * i.Quantidade);
            decimal descontosDePromocoes = Carrinho.Sum(i => i.DescontoUnitario * i.Quantidade);
            decimal totalAPagar = subtotalBruto - (descontosDePromocoes + _descontoManualVenda);

            string entrada = txtValorRecebido.Text.Trim().Replace("R$", "").Replace(" ", "").Replace(",", ".");

            if (decimal.TryParse(entrada, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out decimal valorRecebido))
            {
                decimal troco = valorRecebido - totalAPagar;
                txtTroco.Text = troco < 0 ? "R$ 0,00" : $"R$ {troco:N2}";
            }
            else
            {
                txtTroco.Text = "R$ 0,00";
            }
        }

        private void txtValorRecebido_PreviewKeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Escape)
            {
                FecharTelaPagamento();
                e.Handled = true;
            }
            else if (e.Key == Key.Enter)
            {
                ProcessarVenda();
                e.Handled = true;
            }
            // NOVO: Setas para cima e para baixo trocam a forma de pagamento
            else if (e.Key == Key.Up)
            {
                // Se não estiver no primeiro item, sobe um. Se estiver, vai pro último.
                if (cmbMetodoPagamento.SelectedIndex > 0)
                    cmbMetodoPagamento.SelectedIndex--;
                else
                    cmbMetodoPagamento.SelectedIndex = cmbMetodoPagamento.Items.Count - 1;

                e.Handled = true;
            }
            else if (e.Key == Key.Down)
            {
                // Se não estiver no último item, desce um. Se estiver, vai pro primeiro.
                if (cmbMetodoPagamento.SelectedIndex < cmbMetodoPagamento.Items.Count - 1)
                    cmbMetodoPagamento.SelectedIndex++;
                else
                    cmbMetodoPagamento.SelectedIndex = 0;

                e.Handled = true;
            }
        }

        private void ProcessarVenda()
        {
            decimal subtotalBruto = Carrinho.Sum(i => i.PrecoUnitario * i.Quantidade);
            decimal descontosDePromocoes = Carrinho.Sum(i => i.DescontoUnitario * i.Quantidade);
            decimal descontoTotal = descontosDePromocoes + _descontoManualVenda;
            decimal totalAPagar = subtotalBruto - descontoTotal;

            string entrada = txtValorRecebido.Text.Trim().Replace("R$", "").Replace(" ", "").Replace(",", ".");
            decimal.TryParse(entrada, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out decimal valorRecebido);

            if (valorRecebido < totalAPagar)
            {
                MessageBox.Show("O valor recebido é menor que o total da venda!", "Aviso", MessageBoxButton.OK, MessageBoxImage.Warning);
                txtValorRecebido.SelectAll();
                return;
            }

            // Se por acaso vir nulo, assume "dinheiro" como padrão
            string metodoSelecionado = ((System.Windows.Controls.ComboBoxItem)cmbMetodoPagamento.SelectedItem)?.Content?.ToString() ?? "dinheiro";

            try
            {
                using (var connection = new Microsoft.Data.Sqlite.SqliteConnection(DatabaseConfig.ConnectionString))
                {
                    connection.Open();
                    // O BeginTransaction garante que as tabelas sejam salvas em lote (ou tudo funciona ou tudo cancela)
                    using (var transaction = connection.BeginTransaction())
                    {
                        try
                        {
                            // 1. Grava a Venda
                            var sqlVenda = @"INSERT INTO tb_vendas (id_sessao_caixa, id_cliente, data_hora, subtotal, desconto, total, status)
                                             VALUES (@Sessao, NULL, @DataHora, @Subtotal, @Desconto, @Total, 'pago');
                                             SELECT last_insert_rowid();";

                            long idVenda = connection.ExecuteScalar<long>(sqlVenda, new
                            {
                                Sessao = Session.CurrentSessaoCaixaId,
                                DataHora = DateTime.Now,
                                Subtotal = subtotalBruto,
                                Desconto = descontoTotal,
                                Total = totalAPagar
                            }, transaction);

                            // 2. Grava os Itens e DÁ BAIXA NO ESTOQUE (quantidade - @Quantidade)
                            foreach (var item in Carrinho)
                            {
                                var sqlItem = @"INSERT INTO tb_itens_venda (id_venda, id_produto, quantidade, preco_unitario, subtotal)
                                                VALUES (@IdVenda, @IdProduto, @Quantidade, @PrecoUnitario, @Subtotal);
                                                
                                                UPDATE tb_produtos SET quantidade = quantidade - @Quantidade WHERE id = @IdProduto;";

                                connection.Execute(sqlItem, new
                                {
                                    IdVenda = idVenda,
                                    IdProduto = item.IdProduto,
                                    Quantidade = item.Quantidade,
                                    PrecoUnitario = item.PrecoUnitario,
                                    Subtotal = item.Total
                                }, transaction);
                            }

                            // 3. Grava o Pagamento

                            var sqlPagamento = @"INSERT INTO tb_pagamentos (id_venda, metodo, valor)
                                                 VALUES (@IdVenda, @Metodo, @Valor);";
                            
                            connection.Execute(sqlPagamento, new
                            {
                                IdVenda = idVenda,
                                Metodo = metodoSelecionado,
                                Valor = totalAPagar
                            }, transaction);


                            transaction.Commit(); // Se chegou aqui, joga tudo pro arquivo do banco de vez!

                            // ==========================================
                            // 4. CHAMA O SINCRONIZADOR DE FILA
                            // ==========================================
                            Task.Run(async () => await SincronizacaoService.SincronizarVendasPendentesAsync());
                        }

                        catch (Exception) // <-- Tiramos o 'ex' daqui pois não vamos usá-lo nesta linha
                        {
                            transaction.Rollback(); // Deu erro? Cancela tudo pra não quebrar o banco
                            throw; // <-- Alterado de 'throw ex;' para apenas 'throw;'
                        }
                    }
                }

                // Finalizou com sucesso! Limpa a tela pro próximo cliente
                Carrinho.Clear();
                _descontoManualVenda = 0m;
                txtUltimoNome.Text = "Caixa Livre";
                txtUltimoDetalhes.Text = " ";
                txtUltimoPreco.Text = "R$ 0,00";
                AtualizarTotais();
                FecharTelaPagamento();

                // Em um PDV real, aqui iria um comando pra imprimir o cupom na térmica
                MessageBox.Show("Imprimindo cupom fiscal em KNUP KP-IM602...", "Venda finalizada", MessageBoxButton.OK, MessageBoxImage.Information);
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Erro ao concluir venda.", "Erro Crítico", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        // ==========================================
        // LÓGICA DE SAIR DO CAIXA (F19)
        // ==========================================
        private async Task SairDoCaixa()
        {
            // Pergunta para evitar acidentes
            if (MessageBox.Show("Tem certeza que deseja fechar o caixa e sair do sistema?", "Sair do Caixa", MessageBoxButton.YesNo, MessageBoxImage.Question) == MessageBoxResult.Yes)
            {
                // 1. Bloqueia a tela e avisa o operador
                this.IsEnabled = false;
                txtUltimoNome.Text = "Sincronizando com a nuvem...";
                txtUltimoDetalhes.Text = "Aguarde enquanto as vendas pendentes são salvas.";
                txtUltimoPreco.Text = "";

                // 2. Força o envio de qualquer venda feita sem internet que tenha ficado para trás
                await SincronizacaoService.SincronizarVendasPendentesAsync();

                // 3. Limpa a Sessão de quem estava logado
                Session.CurrentUserId = 0;
                Session.CurrentUserName = string.Empty;
                Session.CurrentSessaoCaixaId = 0;

                // 4. Avisa o Windows que não é para fechar o aplicativo quando essa tela sumir
                Application.Current.ShutdownMode = ShutdownMode.OnExplicitShutdown;

                // Esconde a tela do PDV
                this.Hide();

                // 5. Chama a tela de Login novamente
                var login = new LoginWindow();
                bool? ok = login.ShowDialog();

                if (ok == true)
                {
                    // Se logou com sucesso de novo (mesmo operador ou outro), cria um PDV novinho
                    var novaMain = new MainWindow();
                    Application.Current.MainWindow = novaMain;
                    Application.Current.ShutdownMode = ShutdownMode.OnMainWindowClose;
                    novaMain.Show();
                }
                else
                {
                    // Se fechou a tela de login (apertou no X ou em Sair), desliga o app inteiro
                    Application.Current.Shutdown();
                }

                // Remove o PDV velho da memória
                this.Close();
            }
        }
    }

    public class ItemCupom : INotifyPropertyChanged
    {
        public int IdProduto { get; set; } // <--- ADICIONE ESTA LINHA AQUI

        private int _quantidade;
        private decimal _total;

        public string Codigo { get; set; } = string.Empty;
        public string Descricao { get; set; } = string.Empty;
        public decimal PrecoUnitario { get; set; }
        public decimal DescontoUnitario { get; set; }

        public int Quantidade
        {
            get => _quantidade;
            set
            {
                _quantidade = value;
                OnPropertyChanged(nameof(Quantidade));
            }
        }

        public decimal Total
        {
            get => _total;
            set
            {
                _total = value;
                OnPropertyChanged(nameof(Total));
            }
        }

        public event PropertyChangedEventHandler? PropertyChanged;

        protected void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}