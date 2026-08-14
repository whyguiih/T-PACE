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

        // Controle de desconto manual da venda atual (para o atalho F5 no futuro)
        private decimal _descontoManualVenda = 0m;

        public MainWindow()
        {
            InitializeComponent();

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

            // Sincroniza em segundo plano
            Task.Run(async () => await SincronizacaoService.SincronizarProdutosAsync());
        }

        private void TxtBusca_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                string codigo = txtBusca.Text.Trim();
                if (!string.IsNullOrEmpty(codigo))
                {
                    BiparProduto(codigo);
                }
            }
        }

        private void BiparProduto(string codigo)
        {
            try
            {
                var produto = _repositorio.BuscarPorCodigoDeBarras(codigo);

                if (produto != null)
                {
                    // Lógica de cálculo de Promoção
                    decimal precoCheio = produto.preco_venda;
                    decimal descontoDoItem = 0m;

                    // Se o produto estiver em promoção e o valor promocional for menor que o valor original
                    if (produto.em_promocao && produto.valor_promocional.HasValue && produto.valor_promocional.Value > 0 && produto.valor_promocional.Value < precoCheio)
                    {
                        descontoDoItem = precoCheio - produto.valor_promocional.Value;
                    }

                    decimal precoCobrado = precoCheio - descontoDoItem;

                    // Verifica se já bipou esse produto antes
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
                            Codigo = produto.codigo_barras,
                            Descricao = produto.nome,
                            Quantidade = 1,
                            PrecoUnitario = precoCheio, // A lista sempre mostra o preço "tabela" unitário
                            DescontoUnitario = descontoDoItem, // Memoriza o desconto para somar lá embaixo
                            Total = precoCobrado // O total cobrado já vai para a lista com o desconto
                        });
                    }

                    // Atualiza os detalhes visuais do último produto passado
                    txtUltimoNome.Text = produto.nome;
                    txtUltimoDetalhes.Text = $"Cód: {produto.codigo_barras}  |  Qtd: 1 un";

                    // Se teve desconto, avisa na tela do lado direito
                    if (descontoDoItem > 0)
                    {
                        txtUltimoPreco.Text = $"R$ {precoCobrado:N2}  (Promoção)";
                    }
                    else
                    {
                        txtUltimoPreco.Text = $"R$ {precoCobrado:N2}";
                    }

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

        private void AtualizarTotais()
        {
            // O Subtotal é a soma de todos os produtos multiplicados pelo preço CHEIO
            decimal subtotalBruto = Carrinho.Sum(i => i.PrecoUnitario * i.Quantidade);

            // Os Descontos somam as promoções de cada item multiplicadas pela quantidade
            decimal descontosDePromocoes = Carrinho.Sum(i => i.DescontoUnitario * i.Quantidade);

            // Soma as promoções automáticas + qualquer desconto manual que o caixa der
            decimal descontosTotais = descontosDePromocoes + _descontoManualVenda;

            // O Total que o cliente realmente vai pagar
            decimal totalAPagar = subtotalBruto - descontosTotais;

            // Atualiza os textos na interface
            txtSubtotal.Text = $"R$ {subtotalBruto:N2}";
            txtDesconto.Text = $"- R$ {descontosTotais:N2}";
            txtTotal.Text = $"R$ {totalAPagar:N2}";
        }
    }

    public class ItemCupom : INotifyPropertyChanged
    {
        private int _quantidade;
        private decimal _total;

        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public decimal PrecoUnitario { get; set; }
        public decimal DescontoUnitario { get; set; } // Nova propriedade guardando a diferença

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