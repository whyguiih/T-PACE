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

            // ATUALIZANDO O PERFIL VISUAL
            if (!string.IsNullOrEmpty(Session.CurrentUserName))
            {
                txtNomeUsuario.Text = Session.CurrentUserName;
                // Pega as duas primeiras letras do nome para a bolinha (ex: Admin -> AD)
                txtIniciaisUsuario.Text = Session.CurrentUserName.Length > 1
                    ? Session.CurrentUserName.Substring(0, 2).ToUpper()
                    : Session.CurrentUserName.ToUpper();
            }

            try
            // ... restante do código original continua
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
                            Codigo = produto.codigo_barras,
                            Descricao = produto.nome,
                            Quantidade = 1,
                            PrecoUnitario = precoCheio,
                            DescontoUnitario = descontoDoItem,
                            Total = precoCobrado
                        });
                    }

                    // Atualiza os detalhes visuais de forma limpa, sem o texto "(Promoção)"
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
    }

    public class ItemCupom : INotifyPropertyChanged
    {
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