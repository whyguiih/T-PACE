using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Windows;
using System.Windows.Input;

namespace T_PACE
{
    public partial class MainWindow : Window
    {
        private ProdutoRepository _repositorio;
        public ObservableCollection<ItemCupom> Carrinho { get; set; }

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

            // ========================================================
            // CHAMA A SINCRONIZAÇÃO EM SEGUNDO PLANO SEM TRAVAR A TELA
            // ========================================================
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
                    var itemExistente = Carrinho.FirstOrDefault(c => c.Codigo == produto.codigo_barras);

                    if (itemExistente != null)
                    {
                        itemExistente.Quantidade += 1;
                        itemExistente.Total = itemExistente.Quantidade * itemExistente.PrecoUnitario;
                    }
                    else
                    {
                        Carrinho.Add(new ItemCupom
                        {
                            Codigo = produto.codigo_barras,
                            Descricao = produto.nome,
                            Quantidade = 1,
                            PrecoUnitario = produto.preco_venda,
                            Total = produto.preco_venda
                        });
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
                MessageBox.Show($"Produto inexistente", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void AtualizarTotais()
        {
            decimal subtotal = Carrinho.Sum(i => i.Total);
            txtTotal.Text = $"R$ {subtotal:N2}";
        }
    }

    // CORREÇÃO: Implementado INotifyPropertyChanged para atualizar a UI ao somar itens
    public class ItemCupom : INotifyPropertyChanged
    {
        private int _quantidade;
        private decimal _total;

        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public decimal PrecoUnitario { get; set; }

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