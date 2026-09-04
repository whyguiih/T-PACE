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
        private decimal _creditoTroca = 0m;

        public MainWindow()
        {
            InitializeComponent();
            btnFinalizar.Click += (s, e) => AbrirTelaPagamento();
            txtBusca.KeyDown += TxtBusca_KeyDown;

            Task.Run(async () =>
            {
                await SincronizacaoService.SincronizarProdutosAsync();
                await SincronizacaoService.SincronizarVendasPendentesAsync();
            });

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
        }

        private async void TxtBusca_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                string entradaCompleta = txtBusca.Text.Trim();
                if (!string.IsNullOrEmpty(entradaCompleta))
                {
                    BiparProduto(entradaCompleta);
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
            else if (e.Key == Key.F6)
            {
                AbrirTelaTroca();
            }
            else if (e.Key == Key.F9)
            {
                AbrirTelaFechamento();
            }
        }

        private void BiparProduto(string entradaCodigo)
        {
            try
            {
                int quantidadeDesejada = 1;
                string codigoFinal = entradaCodigo;

                if (entradaCodigo.Contains("x") || entradaCodigo.Contains("X"))
                {
                    string[] partes = entradaCodigo.Split(new char[] { 'x', 'X' }, 2);
                    if (int.TryParse(partes[0].Trim(), out int qtd) && qtd > 0)
                    {
                        quantidadeDesejada = qtd;
                        codigoFinal = partes[1].Trim();
                    }
                }

                var produto = _repositorio.BuscarPorCodigoDeBarras(codigoFinal);

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
                        itemExistente.Quantidade += quantidadeDesejada;
                        itemExistente.Total = itemExistente.Quantidade * precoCobrado;
                    }
                    else
                    {
                        Carrinho.Add(new ItemCupom
                        {
                            IdProduto = produto.id,
                            Codigo = produto.codigo_barras,
                            Descricao = produto.nome,
                            Quantidade = quantidadeDesejada,
                            PrecoUnitario = precoCheio,
                            DescontoUnitario = descontoDoItem,
                            Total = quantidadeDesejada * precoCobrado
                        });
                    }

                    txtUltimoNome.Text = produto.nome;
                    txtUltimoDetalhes.Text = $"Cód: {produto.codigo_barras}  |  Qtd: {quantidadeDesejada} un";
                    txtUltimoPreco.Text = $"R$ {(quantidadeDesejada * precoCobrado):N2}";

                    AtualizarTotais();
                    txtBusca.Clear();

                    if (!string.IsNullOrEmpty(produto.foto))
                    {
                        string nomeArquivo = produto.foto.Substring(produto.foto.LastIndexOf('/') + 1);
                        string caminhoLocal = System.IO.Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory, "Imagens", nomeArquivo);

                        if (System.IO.File.Exists(caminhoLocal))
                        {
                            try
                            {
                                var bitmap = new System.Windows.Media.Imaging.BitmapImage();
                                bitmap.BeginInit();
                                bitmap.CacheOption = System.Windows.Media.Imaging.BitmapCacheOption.OnLoad;
                                bitmap.UriSource = new Uri(caminhoLocal, UriKind.Absolute);
                                bitmap.EndInit();
                                bitmap.Freeze();
                                imgProdutoFoto.Source = bitmap;
                                imgProdutoFoto.Visibility = Visibility.Visible;
                                txtFotoPlaceholder.Visibility = Visibility.Collapsed;
                            }
                            catch
                            {
                                imgProdutoFoto.Visibility = Visibility.Collapsed;
                                txtFotoPlaceholder.Text = "ERRO NA FOTO";
                                txtFotoPlaceholder.Visibility = Visibility.Visible;
                            }
                        }
                        else
                        {
                            imgProdutoFoto.Visibility = Visibility.Collapsed;
                            txtFotoPlaceholder.Text = "FOTO NÃO BAIXADA";
                            txtFotoPlaceholder.Visibility = Visibility.Visible;
                        }
                    }
                    else
                    {
                        imgProdutoFoto.Visibility = Visibility.Collapsed;
                        txtFotoPlaceholder.Text = "SEM FOTO";
                        txtFotoPlaceholder.Visibility = Visibility.Visible;
                    }
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
            txtBusca.Focus();
        }

        private void txtBuscaNome_TextChanged(object sender, System.Windows.Controls.TextChangedEventArgs e)
        {
            string termo = txtBuscaNome.Text.Trim();
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

        private void txtBuscaNome_PreviewKeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Escape)
            {
                FecharTelaBusca();
                e.Handled = true;
            }
            else if (e.Key == Key.Down && listaResultadosBusca.Items.Count > 0)
            {
                e.Handled = true;
                listaResultadosBusca.Focus();
                listaResultadosBusca.SelectedIndex = 0;
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

        private void listaResultadosBusca_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                SelecionarProdutoBusca();
            }
            else if (e.Key == Key.Escape)
            {
                txtBuscaNome.Focus();
            }
        }

        private void listaResultadosBusca_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            SelecionarProdutoBusca();
        }

        private void SelecionarProdutoBusca()
        {
            if (listaResultadosBusca.SelectedItem is Produto produtoSelecionado)
            {
                FecharTelaBusca();
                BiparProduto(produtoSelecionado.codigo_barras);
            }
        }

        private void AbrirTelaDesconto()
        {
            if (Carrinho.Count == 0)
            {
                MessageBox.Show("Adicione itens ao cupom antes de aplicar um desconto.", "Aviso", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }
            OverlayDesconto.Visibility = Visibility.Visible;
            txtValorDesconto.Text = _descontoManualVenda > 0 ? _descontoManualVenda.ToString("N2") : "";
            txtValorDesconto.SelectAll();
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

            if (string.IsNullOrEmpty(entrada))
            {
                _descontoManualVenda = 0m;
                AtualizarTotais();
                FecharTelaDesconto();
                return;
            }

            bool isPorcentagem = entrada.Contains("%");
            entrada = entrada.Replace("R$", "").Replace("%", "").Replace(" ", "").Replace(",", ".");

            if (decimal.TryParse(entrada, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out decimal valorDigitado))
            {
                decimal subtotalBruto = Carrinho.Sum(i => i.PrecoUnitario * i.Quantidade);
                decimal descontosDePromocoes = Carrinho.Sum(i => i.DescontoUnitario * i.Quantidade);
                decimal totalAtualVenda = subtotalBruto - descontosDePromocoes;
                decimal valorDescontoFinal = 0m;

                if (isPorcentagem)
                {
                    valorDescontoFinal = totalAtualVenda * (valorDigitado / 100m);
                }
                else
                {
                    valorDescontoFinal = valorDigitado;
                }

                if (valorDescontoFinal > totalAtualVenda || valorDescontoFinal < 0)
                {
                    MessageBox.Show("O desconto não pode ser negativo ou ultrapassar o valor total da venda!", "Aviso", MessageBoxButton.OK, MessageBoxImage.Warning);
                    txtValorDesconto.SelectAll();
                    return;
                }

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

        // MATEMÁTICA CORRIGIDA E BLINDADA
        private void AtualizarTotais()
        {
            decimal subtotalBruto = Carrinho.Sum(i => i.PrecoUnitario * i.Quantidade);
            decimal descontosDePromocoes = Carrinho.Sum(i => i.DescontoUnitario * i.Quantidade);

            decimal descontosTotais = descontosDePromocoes + _descontoManualVenda + _creditoTroca;

            // TRAVA: O desconto e o crédito não podem ultrapassar o valor da compra
            if (descontosTotais > subtotalBruto && subtotalBruto > 0)
                descontosTotais = subtotalBruto;

            decimal totalAPagar = subtotalBruto - descontosTotais;
            if (totalAPagar < 0) totalAPagar = 0;

            txtSubtotal.Text = $"R$ {subtotalBruto:N2}";
            txtDesconto.Text = $"- R$ {descontosTotais:N2}";
            txtTotal.Text = $"R$ {totalAPagar:N2}";
        }

        private void txtBusca_TextChanged(object sender, System.Windows.Controls.TextChangedEventArgs e)
        {
        }

        private void AbrirTelaPagamento()
        {
            if (Carrinho.Count == 0)
            {
                MessageBox.Show("Adicione itens ao cupom antes de finalizar a venda.", "Aviso", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            decimal subtotalBruto = Carrinho.Sum(i => i.PrecoUnitario * i.Quantidade);
            decimal descontosDePromocoes = Carrinho.Sum(i => i.DescontoUnitario * i.Quantidade);

            decimal descontoTotal = descontosDePromocoes + _descontoManualVenda + _creditoTroca;
            if (descontoTotal > subtotalBruto) descontoTotal = subtotalBruto; // Trava de segurança

            decimal totalAPagar = subtotalBruto - descontoTotal;
            if (totalAPagar < 0) totalAPagar = 0;

            txtPagamentoTotal.Text = $"R$ {totalAPagar:N2}";
            txtValorRecebido.Text = totalAPagar.ToString("N2");
            txtTroco.Text = "R$ 0,00";

            OverlayPagamento.Visibility = Visibility.Visible;
            cmbMetodoPagamento.SelectedIndex = 0;
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

            decimal descontoTotal = descontosDePromocoes + _descontoManualVenda + _creditoTroca;
            if (descontoTotal > subtotalBruto) descontoTotal = subtotalBruto; // Trava

            decimal totalAPagar = subtotalBruto - descontoTotal;
            if (totalAPagar < 0) totalAPagar = 0;

            string entrada = txtValorRecebido.Text.Trim().Replace("R$", "").Replace(" ", "").Replace(".", "").Replace(",", ".");
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
            else if (e.Key == Key.Up)
            {
                if (cmbMetodoPagamento.SelectedIndex > 0)
                    cmbMetodoPagamento.SelectedIndex--;
                else
                    cmbMetodoPagamento.SelectedIndex = cmbMetodoPagamento.Items.Count - 1;
                e.Handled = true;
            }
            else if (e.Key == Key.Down)
            {
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

            decimal descontoTotal = descontosDePromocoes + _descontoManualVenda + _creditoTroca;
            if (descontoTotal > subtotalBruto)
                descontoTotal = subtotalBruto; // Protege o banco de dados contra totais negativos!

            decimal totalAPagar = subtotalBruto - descontoTotal;
            if (totalAPagar < 0) totalAPagar = 0;

            string entrada = txtValorRecebido.Text.Trim().Replace("R$", "").Replace(" ", "").Replace(".", "").Replace(",", ".");
            decimal.TryParse(entrada, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out decimal valorRecebido);

            // Garante que o operador cobrou a diferença corretamente
            if (valorRecebido < totalAPagar)
            {
                MessageBox.Show("O valor recebido é menor que o total a pagar!", "Aviso", MessageBoxButton.OK, MessageBoxImage.Warning);
                txtValorRecebido.SelectAll();
                return;
            }

            decimal trocoFinal = valorRecebido - totalAPagar;
            // Se por acaso vir nulo, assume "dinheiro" como padrão
            string metodoSelecionado = ((System.Windows.Controls.ComboBoxItem)cmbMetodoPagamento.SelectedItem)?.Content?.ToString() ?? "dinheiro";

            // GERA CÓDIGO PAR DE 12 DÍGITOS (AnoMesDiaHoraMinutoSegundo)
            // Fica estreito na bobina, não precisa de zero extra (pois é par) e não se repete.
            string codigoUnicoCupom = DateTime.Now.ToString("yyMMddHHmmssff");

            try
            {
                using (var connection = new Microsoft.Data.Sqlite.SqliteConnection(DatabaseConfig.ConnectionString))
                {
                    connection.Open();
                    using (var transaction = connection.BeginTransaction())
                    {
                        try
                            var sqlVenda = @"INSERT INTO tb_vendas (id_sessao_caixa, id_cliente, data_hora, subtotal, desconto, total, status) 
                                             VALUES (@Sessao, NULL, @DataHora, @Subtotal, @Desconto, @Total, 'pago');
                                             VALUES (@Sessao, NULL, @DataHora, @Subtotal, @Desconto, @Total, 'pago');
                                             SELECT last_insert_rowid();";

                            long idVenda = connection.ExecuteScalar<long>(sqlVenda, new
                            {
                                Sessao = Session.CurrentSessaoCaixaId,
                                DataHora = DateTime.Now,
                                Subtotal = subtotalBruto,
                                Desconto = descontoTotal,
                                Total = totalAPagar,
                                IdCupom = codigoUnicoCupom // SALVANDO NO BANCO LOCAL
                            }, transaction);

                            foreach (var item in Carrinho)
                            {
                                var sqlItem = @"INSERT INTO tb_itens_venda (id_venda, id_produto, quantidade, preco_unitario, subtotal) 
                                                VALUES (@IdVenda, @IdProduto, @Quantidade, @PrecoUnitario, @Subtotal);
                                                
                                                UPDATE tb_produtos 
                                                SET quantidade = quantidade - @Quantidade 
                                                WHERE (codigo_geral IS NOT NULL AND codigo_geral = (SELECT codigo_geral FROM tb_produtos WHERE id = @IdProduto))
                                                   OR (codigo_geral IS NULL AND id = @IdProduto);";

                                connection.Execute(sqlItem, new
                                {
                                    IdVenda = idVenda,
                                    IdProduto = item.IdProduto,
                                    Quantidade = item.Quantidade,
                                    PrecoUnitario = item.PrecoUnitario,
                                    Subtotal = item.Total
                                }, transaction);
                            }

                            var sqlPagamento = @"INSERT INTO tb_pagamentos (id_venda, metodo, valor) 
                                                 VALUES (@IdVenda, @Metodo, @Valor);";

                            connection.Execute(sqlPagamento, new
                            {
                                IdVenda = idVenda,
                                Metodo = metodoSelecionado,
                                Valor = totalAPagar
                            }, transaction);

                            transaction.Commit();
                            ImprimirRecibo(idVenda, Carrinho.ToList(), subtotalBruto, descontoTotal, totalAPagar, metodoSelecionado, valorRecebido, trocoFinal);
                            ImprimirRecibo(idVenda, Carrinho.ToList(), subtotalBruto, descontoTotal, totalAPagar, metodoSelecionado, valorRecebido, trocoFinal);

                            Task.Run(async () => await SincronizacaoService.SincronizarVendasPendentesAsync());
                        }
                        catch (Exception)
                        {
                            transaction.Rollback();
                            throw;
                        }
                    }
                }

                Carrinho.Clear();
                _descontoManualVenda = 0m;
                _creditoTroca = 0m; // Limpa o crédito para o próximo cliente!

                txtUltimoNome.Text = "Caixa Livre";
                txtUltimoDetalhes.Text = " ";
                txtUltimoPreco.Text = "R$ 0,00";
                imgProdutoFoto.Visibility = Visibility.Collapsed;
                txtFotoPlaceholder.Visibility = Visibility.Visible;

                AtualizarTotais();
                FecharTelaPagamento();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Erro ao concluir venda. Detalhe: {ex.Message}", "Erro Crítico", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void AbrirTelaFechamento()
        {
            OverlayFechamento.Visibility = Visibility.Visible;
            txtValorFechamento.Text = "0,00";
            txtValorFechamento.SelectAll();
            txtValorFechamento.Focus();
        }

        private void FecharTelaFechamento()
        {
            OverlayFechamento.Visibility = Visibility.Collapsed;
            txtBusca.Focus();
        }

        private async void txtValorFechamento_PreviewKeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Escape)
            {
                FecharTelaFechamento();
                e.Handled = true;
            }
            else if (e.Key == Key.Enter)
            {
                e.Handled = true;
                string entrada = txtValorFechamento.Text.Trim().Replace("R$", "").Replace(" ", "").Replace(".", "").Replace(",", ".");
                decimal.TryParse(entrada, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out decimal valorFechamento);

                using (var conn = new Microsoft.Data.Sqlite.SqliteConnection(DatabaseConfig.ConnectionString))
                {
                    conn.Open();
                    conn.Execute("UPDATE tb_sessao_caixa SET data_fechamento = @Data, status = 0, valor_fechamento = @Valor, sincronizado = 0 WHERE id = @Id",
                        new { Data = DateTime.Now, Valor = valorFechamento, Id = Session.CurrentSessaoCaixaId });
                }

                FecharTelaFechamento();
                await SairDoCaixa();
            }
        }

        private async Task SairDoCaixa()
        {
            this.IsEnabled = false;
            txtUltimoNome.Text = "Encerrando Turno...";
            txtUltimoDetalhes.Text = "Aguarde enquanto os dados são salvos na nuvem.";
            txtUltimoPreco.Text = "";

            await SincronizacaoService.SincronizarVendasPendentesAsync();
            await SincronizacaoService.SincronizarSessoesCaixaAsync();

            Session.CurrentUserId = 0;
            Session.CurrentUserName = string.Empty;
            Session.CurrentSessaoCaixaId = 0;

            Application.Current.ShutdownMode = ShutdownMode.OnExplicitShutdown;
            this.Hide();

            var login = new LoginWindow();
            bool? ok = login.ShowDialog();

            if (ok == true)
            {
                var novaMain = new MainWindow();
                Application.Current.MainWindow = novaMain;
                Application.Current.ShutdownMode = ShutdownMode.OnMainWindowClose;
                novaMain.Show();
            }
            else
            {
                Application.Current.Shutdown();
            }

            this.Close();
        }

        // ==========================================
        // LÓGICA DE TROCA E DEVOLUÇÃO

        private void AbrirTelaTroca()
        {
            OverlayTroca.Visibility = Visibility.Visible;
            txtIdNotinha.Clear();
            txtQtdRetorno.Text = "1";
            listaProdutosNotinha.ItemsSource = null;
            txtIdNotinha.Focus();
        }

        private void BtnFecharTroca_Click(object sender, RoutedEventArgs e)
        {
            OverlayTroca.Visibility = Visibility.Collapsed;
            txtBusca.Focus();
        }

        private async void txtIdNotinha_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                try
                {
                    string idCupom = txtIdNotinha.Text.Trim().Replace("*", "");

                    if (string.IsNullOrEmpty(idCupom))
                    {
                        MessageBox.Show("Código da nota inválido. Bipe ou digite novamente.", "Atenção");
                        return;
                    }

                    txtIdNotinha.IsEnabled = false;
                    listaProdutosNotinha.ItemsSource = null;

                    using (var client = new System.Net.Http.HttpClient())
                    {
                        string urlBusca = $"https://tpace-api.whyguiih.workers.dev/api/app/vendas/cupom/{idCupom}";
                        var response = await client.GetAsync(urlBusca);

                        if (response.IsSuccessStatusCode)
                        {
                            var jsonString = await response.Content.ReadAsStringAsync();
                            var opcoesJson = new System.Text.Json.JsonSerializerOptions { PropertyNameCaseInsensitive = true };

                            var itens = System.Text.Json.JsonSerializer.Deserialize<System.Collections.Generic.List<ItemCupom>>(jsonString, opcoesJson);

                            if (itens == null || itens.Count == 0)
                            {
                                MessageBox.Show("Nenhum produto encontrado para este cupom na nuvem. Verifique se o ID está correto.", "Aviso");
                            }

                            listaProdutosNotinha.ItemsSource = itens;
                        }
                        else
                        {
                            MessageBox.Show("Cupom não encontrado no servidor ou sem conexão com a internet.", "Erro 404");
                        }
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Erro de conexão com a API: {ex.Message}", "Erro");
                }
                finally
                {
                    txtIdNotinha.IsEnabled = true;
                    txtIdNotinha.Focus();
                }
            }
        }

        private async Task EnviarTrocaParaApi(string tipo, string codigo, decimal quantidade)
        {
            try
            {
                var payload = new
                {
                    tipo_troca = tipo,
                    id_vendedor = Session.CurrentUserId,
                    produto_retornado = codigo,
                    quantidade = quantidade
                };

                using (var client = new System.Net.Http.HttpClient())
                {
                    var content = new System.Net.Http.StringContent(System.Text.Json.JsonSerializer.Serialize(payload), System.Text.Encoding.UTF8, "application/json");
                    await client.PostAsync("https://tpace-api.whyguiih.workers.dev/api/app/trocas", content);
                }
            }
            catch { /* Falha silenciosa offline */ }
        }

        private async void BtnDevolucao_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var itensLista = listaProdutosNotinha.ItemsSource as System.Collections.Generic.IEnumerable<ItemCupom>;
                if (itensLista == null) return;

                var itensSelecionados = itensLista.Where(x => x.Selecionado).ToList();

                if (itensSelecionados.Count == 0)
                {
                    MessageBox.Show("Marque a caixinha de pelo menos um produto para devolver.", "Atenção");
                    return;
                }

                if (!decimal.TryParse(txtQtdRetorno.Text, out decimal qtd) || qtd <= 0)
                {
                    MessageBox.Show("Digite uma quantidade válida para devolução.", "Atenção");
                    return;
                }

                decimal valorEstornoTotal = 0m;

                using (var conn = new Microsoft.Data.Sqlite.SqliteConnection(DatabaseConfig.ConnectionString))
                {
                    conn.Execute(@"
                        CREATE TABLE IF NOT EXISTS tb_trocas (
                            id_troca INTEGER PRIMARY KEY AUTOINCREMENT,
                            tipo_troca VARCHAR(15), data_troca DATETIME DEFAULT CURRENT_TIMESTAMP,
                            id_vendedor INTEGER, produto_retornado VARCHAR(20), quantidade DECIMAL(10,3)
                        );
                    ");

                    foreach (var item in itensSelecionados)
                    {
                        decimal qtdReal = qtd > item.Quantidade ? item.Quantidade : qtd;
                        valorEstornoTotal += item.PrecoUnitario * qtdReal;

                        conn.Execute(@"
                            INSERT INTO tb_trocas (tipo_troca, id_vendedor, produto_retornado, quantidade) VALUES ('devolucao', @User, @Cod, @Qtd);
                            UPDATE tb_produtos SET quantidade = quantidade + @Qtd WHERE codigo_barras = @Cod;
                        ", new { User = Session.CurrentUserId, Cod = item.Codigo, Qtd = qtdReal });

                        await EnviarTrocaParaApi("devolucao", item.Codigo, qtdReal);
                    }

                    conn.Execute("UPDATE tb_sessao_caixa SET valor_fechamento = valor_fechamento - @Valor WHERE id = @Sessao;",
                                 new { Valor = valorEstornoTotal, Sessao = Session.CurrentSessaoCaixaId });
                }

                MessageBox.Show($"Devolução concluída!\n\nRetire R$ {valorEstornoTotal:N2} do caixa e devolva ao cliente.", "Sucesso");
                OverlayTroca.Visibility = Visibility.Collapsed;
                txtBusca.Focus();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Erro ao processar devolução: {ex.Message}", "Erro Crítico");
            }
        }

        private async void BtnTroca_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var itensLista = listaProdutosNotinha.ItemsSource as System.Collections.Generic.IEnumerable<ItemCupom>;
                if (itensLista == null) return;

                var itensSelecionados = itensLista.Where(x => x.Selecionado).ToList();

                if (itensSelecionados.Count == 0)
                {
                    MessageBox.Show("Marque a caixinha de pelo menos um produto para trocar.", "Atenção");
                    return;
                }

                if (!decimal.TryParse(txtQtdRetorno.Text, out decimal qtd) || qtd <= 0)
                {
                    MessageBox.Show("Digite uma quantidade válida para troca.", "Atenção");
                    return;
                }

                using (var conn = new Microsoft.Data.Sqlite.SqliteConnection(DatabaseConfig.ConnectionString))
                {
                    conn.Execute(@"
                        CREATE TABLE IF NOT EXISTS tb_trocas (
                            id_troca INTEGER PRIMARY KEY AUTOINCREMENT,
                            tipo_troca VARCHAR(15), data_troca DATETIME DEFAULT CURRENT_TIMESTAMP,
                            id_vendedor INTEGER, produto_retornado VARCHAR(20), quantidade DECIMAL(10,3)
                        );
                    ");

                    foreach (var item in itensSelecionados)
                    {
                        decimal qtdReal = qtd > item.Quantidade ? item.Quantidade : qtd;

                        // O Crédito ACUMULA agora. Se ele fizer 3 trocas seguidas, o crédito vai somando!
                        _creditoTroca += item.PrecoUnitario * qtdReal;

                        conn.Execute(@"
                            INSERT INTO tb_trocas (tipo_troca, id_vendedor, produto_retornado, quantidade) VALUES ('troca', @User, @Cod, @Qtd);
                            UPDATE tb_produtos SET quantidade = quantidade + @Qtd WHERE codigo_barras = @Cod;
                        ", new { User = Session.CurrentUserId, Cod = item.Codigo, Qtd = qtdReal });

                        await EnviarTrocaParaApi("troca", item.Codigo, qtdReal);
                    }
                }

                AtualizarTotais();

                MessageBox.Show($"Troca iniciada!\n\nO cliente tem R$ {_creditoTroca:N2} de crédito.\nBipe os novos produtos na tela principal.", "Sucesso");
                OverlayTroca.Visibility = Visibility.Collapsed;
                txtBusca.Focus();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Erro ao processar troca: {ex.Message}", "Erro Crítico");
            }
        }

        private void ImprimirRecibo(long idVenda, System.Collections.Generic.List<ItemCupom> itens, decimal subtotal, decimal desconto, decimal total, string metodoPagamento, decimal valorRecebido, decimal troco)
        private void ImprimirRecibo(long idVenda, System.Collections.Generic.List<ItemCupom> itens, decimal subtotal, decimal desconto, decimal total, string metodoPagamento, decimal valorRecebido, decimal troco)
        {
            try
            {
                var printDialog = new System.Windows.Controls.PrintDialog();
                var doc = new System.Windows.Documents.FlowDocument();

                doc.PageWidth = 275;
                doc.PagePadding = new System.Windows.Thickness(0, 10, 0, 20);
                doc.FontFamily = new System.Windows.Media.FontFamily("Courier New");
                doc.Foreground = System.Windows.Media.Brushes.Black;
                doc.FontWeight = FontWeights.Bold;

                System.Windows.Media.TextOptions.SetTextFormattingMode(doc, System.Windows.Media.TextFormattingMode.Display);
                System.Windows.Media.TextOptions.SetTextRenderingMode(doc, System.Windows.Media.TextRenderingMode.Aliased);

                int colunas = 36;

                try
                {
                    var uri = new Uri("pack://application:,,,/nota.png", UriKind.Absolute);
                    var bitmap = new System.Windows.Media.Imaging.BitmapImage(uri);
                    var img = new System.Windows.Controls.Image
                    {
                        Source = bitmap,
                        Width = 140,
                        HorizontalAlignment = HorizontalAlignment.Center,
                        Margin = new System.Windows.Thickness(0, 0, 0, 10)
                    };
                    System.Windows.Media.RenderOptions.SetBitmapScalingMode(img, System.Windows.Media.BitmapScalingMode.HighQuality);
                    doc.Blocks.Add(new System.Windows.Documents.BlockUIContainer(img));
                }
                catch { }

                var pCabecalho = new System.Windows.Documents.Paragraph();
                pCabecalho.TextAlignment = TextAlignment.Center;
                pCabecalho.LineHeight = 16;
                pCabecalho.Margin = new Thickness(0, 0, 0, 10);
                pCabecalho.Inlines.Add(new System.Windows.Documents.Run("CNPJ: 00.000.000/0000-00\nCNPJ: 00.000.000/0000-00\nCNPJ: 00.000.000/0000-00\n") { FontSize = 11 });
                pCabecalho.Inlines.Add(new System.Windows.Documents.Run("Rua Buarque de Macedo, 3158,\nCentro, Garibaldi-RS\n") { FontSize = 11 });
                pCabecalho.Inlines.Add(new System.Windows.Documents.Run(new string('-', colunas) + "\n") { FontSize = 11 });
                pCabecalho.Inlines.Add(new System.Windows.Documents.Run("DOCUMENTO AUXILIAR DA NOTA FISCAL\nDE CONSUMIDOR ELETRONICA\n") { FontWeight = FontWeights.Black, FontSize = 11 });
                pCabecalho.Inlines.Add(new System.Windows.Documents.Run(new string('-', colunas)) { FontSize = 11 });
                doc.Blocks.Add(pCabecalho);

                var sb = new System.Text.StringBuilder();
                sb.AppendLine("DESCRIÇÃO                   TOTAL(R$)");
                foreach (var item in itens)
                {
                    sb.AppendLine();
                    string desc = item.Descricao.Length > colunas ? item.Descricao.Substring(0, colunas) : item.Descricao;
                    sb.AppendLine(desc);

                    string qtd = item.Quantidade.ToString("0.###");
                    string un = "UN";
                    string vlUn = item.PrecoUnitario.ToString("N2");
                    string tot = item.Total.ToString("N2");

                    string linhaValores = $"{qtd} {un} X {vlUn}";
                    sb.AppendLine(AlinharLinha(linhaValores, tot, colunas));
                }
                sb.AppendLine(new string('-', colunas));

                decimal qtdeTotalItens = itens.Sum(i => i.Quantidade);
                sb.AppendLine(AlinharLinha("Qtde. Total de Itens", qtdeTotalItens.ToString("0.###"), colunas));
                sb.AppendLine(AlinharLinha("Subtotal R$", subtotal.ToString("N2"), colunas));

                if (desconto > 0)
                    sb.AppendLine(AlinharLinha("Descontos R$", desconto.ToString("N2"), colunas));

                doc.Blocks.Add(new System.Windows.Documents.Paragraph(new System.Windows.Documents.Run(sb.ToString())) { FontSize = 11, Margin = new Thickness(0), LineHeight = 16 });

                var pTotal = new System.Windows.Documents.Paragraph();
                pTotal.Margin = new Thickness(0, 2, 0, 10);
                pTotal.TextAlignment = TextAlignment.Left;
                pTotal.Inlines.Add(new System.Windows.Documents.Run("VALOR TOTAL  R$ ") { FontSize = 11 });
                pTotal.Inlines.Add(new System.Windows.Documents.Run(total.ToString("N2") + "\n") { FontWeight = FontWeights.Black, FontSize = 16 });
                doc.Blocks.Add(pTotal);

                var sbPagamento = new System.Text.StringBuilder();
                sbPagamento.AppendLine(AlinharLinha("FORMA PAGAMENTO", "VALOR PAGO R$", colunas));
                sbPagamento.AppendLine(AlinharLinha(metodoPagamento.ToUpper(), valorRecebido.ToString("N2"), colunas));
                sbPagamento.AppendLine(AlinharLinha("Troco R$", troco.ToString("N2"), colunas));
                sbPagamento.AppendLine(new string('-', colunas));
                doc.Blocks.Add(new System.Windows.Documents.Paragraph(new System.Windows.Documents.Run(sbPagamento.ToString())) { FontSize = 11, Margin = new Thickness(0), LineHeight = 16 });

                try
                {
                    // Gera o código de barras com a string recebida do momento exato da venda
                    var imgBarcode = GerarCodigoBarrasITF(codigoUnicoCupom);
                    doc.Blocks.Add(new System.Windows.Documents.BlockUIContainer(imgBarcode));

                    var pRodape = new System.Windows.Documents.Paragraph();
                    pRodape.Margin = new Thickness(0, 0, 0, 10);
                    pRodape.Inlines.Add(new System.Windows.Documents.Run(idVenda.ToString("D6") + "\n") { FontSize = 12, FontWeight = FontWeights.Black });

                    pRodape.Inlines.Add(new System.Windows.Documents.Run($"\nData: {DateTime.Now:dd/MM/yyyy HH:mm:ss}\n") { FontSize = 11 });
                    pRodape.Inlines.Add(new System.Windows.Documents.Run("OBRIGADO PELA PREFERENCIA!") { FontWeight = FontWeights.Black, FontSize = 11 });
                    doc.Blocks.Add(pRodape);
                }
                catch { }

                printDialog.PrintDocument(((System.Windows.Documents.IDocumentPaginatorSource)doc).DocumentPaginator, $"Recibo T-PACE {idVenda}");
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Não foi possível imprimir o cupom.\n\nDetalhe: {ex.Message}", "Erro de Impressão", MessageBoxButton.OK, MessageBoxImage.Warning);
            }
        }

        private string AlinharLinha(string esquerda, string direita, int totalColunas)
        {
            if (esquerda.Length + direita.Length >= totalColunas)
                esquerda = esquerda.Substring(0, totalColunas - direita.Length - 1);

            return esquerda + direita.PadLeft(totalColunas - esquerda.Length);
        }
        // ==========================================
        // GERADOR NATIVO DE CÓDIGO DE BARRAS (CODE 39)
        // ==========================================
        // NOVO GERADOR DE BARRAS: Interleaved 2 of 5 (Metade da largura, linhas nítidas e fortes)
        private System.Windows.Controls.Image GerarCodigoBarrasITF(string texto)
        private System.Windows.Controls.Image GerarCodigoBarrasCode39(string texto)
            // O padrão ITF exige um número par de dígitos. Se for ímpar, adicionamos um zero.
            if (texto.Length % 2 != 0) texto = "0" + texto;
            string asterisco = "bWbwBwBwb"; // Caractere Start/Stop (Obrigatório em todo leitor)
            string[] padroes = { "NNWWN", "WNNNW", "NWNNW", "WWNNN", "NNWNW", "WNWNN", "NWWNN", "NNNWW", "WNNWN", "NWNWN" };
            int larguraTotal = 0;
            int barraMagra = 2; // Grosso o suficiente para a cabeça térmica não borrar
            int barraLarga = 5;
            int altura = 70;

            // Calcula a largura total da imagem com antecedência
            int larguraTotal = (barraMagra * 4) + (barraLarga + barraMagra * 2);
            foreach (char c in texto)
            foreach (char c in dados)
                string p = padroes[c - '0'];
                foreach (char peso in p) larguraTotal += peso == 'W' ? barraLarga : barraMagra;
                larguraTotal += barraMagra;
                    larguraTotal += (p == 'B' || p == 'W') ? barraLarga : barraMagra;
                larguraTotal += barraMagra; // Espaço em branco separador
            }

            var visual = new System.Windows.Media.DrawingVisual();
            using (var context = visual.RenderOpen())
            {
                context.DrawRectangle(System.Windows.Media.Brushes.White, null, new Rect(0, 0, larguraTotal, altura));
                // Padrão de Início (Start: 4 linhas finas intercaladas)
                context.DrawRectangle(System.Windows.Media.Brushes.Black, null, new Rect(x, 0, barraMagra, altura)); x += barraMagra * 2;
                context.DrawRectangle(System.Windows.Media.Brushes.Black, null, new Rect(x, 0, barraMagra, altura)); x += barraMagra * 2;

                // A mágica: desenha os pares de números (um na barra preta, um no espaço em branco)
                for (int i = 0; i < texto.Length; i += 2)
                foreach (char c in dados)
                // Desenha a sequência de barras
                foreach (char c in dados)
                {
                    string p1 = padroes[texto[i] - '0'];     // Número 1 vira as barras pretas
                    string p2 = padroes[texto[i + 1] - '0']; // Número 2 vira os espaços brancos

                    for (int j = 0; j < 5; j++)
                    {
                        int wBar = p1[j] == 'W' ? barraLarga : barraMagra;
                        context.DrawRectangle(System.Windows.Media.Brushes.Black, null, new Rect(x, 0, wBar, altura));
                        x += wBar;

                        int wSpc = p2[j] == 'W' ? barraLarga : barraMagra;
                        x += wSpc;
                    }
                }

                // Padrão de Fim (Stop: Larga preta, Fina branca, Fina preta)
                context.DrawRectangle(System.Windows.Media.Brushes.Black, null, new Rect(x, 0, barraLarga, altura)); x += barraLarga + barraMagra;
                context.DrawRectangle(System.Windows.Media.Brushes.Black, null, new Rect(x, 0, barraMagra, altura)); x += barraMagra;
            }

            var rtb = new System.Windows.Media.Imaging.RenderTargetBitmap(larguraTotal, altura, 96, 96, System.Windows.Media.PixelFormats.Pbgra32);
            rtb.Render(visual);

            var img = new System.Windows.Controls.Image
            {
                Source = rtb,
                Width = larguraTotal,
                Height = altura,
                Margin = new Thickness(0, 15, 0, 5),

            };

            // Renderização especial para manter o contraste das barras térmicas
            System.Windows.Media.RenderOptions.SetBitmapScalingMode(img, System.Windows.Media.BitmapScalingMode.NearestNeighbor);
            return img;
        }

        private void Rodape_F2_Click(object sender, MouseButtonEventArgs e) => AbrirTelaPagamento();
        private void Rodape_F3_Click(object sender, MouseButtonEventArgs e) => AbrirTelaCancelamento();
        private void Rodape_F4_Click(object sender, MouseButtonEventArgs e) => AbrirTelaBusca();
        private void Rodape_F5_Click(object sender, MouseButtonEventArgs e) => AbrirTelaDesconto();
        private void Rodape_F6_Click(object sender, MouseButtonEventArgs e) => AbrirTelaTroca();
        private void Rodape_F9_Click(object sender, MouseButtonEventArgs e) => AbrirTelaFechamento();

        public class ItemCupom : INotifyPropertyChanged
        {
            public int IdProduto { get; set; }
            private int _quantidade;
            private decimal _total;
            private bool _selecionado;

            public bool Selecionado
            {
                get => _selecionado;
                set
                {
                    _selecionado = value;
                    OnPropertyChanged(nameof(Selecionado));
                }
            }

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

            public event PropertyChangedEventHandler PropertyChanged;

            protected void OnPropertyChanged(string propertyName)
            {
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
            }
        }
    }
}