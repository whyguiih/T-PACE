using System;
using System.Collections.ObjectModel;
using System.Linq;
using System.Windows;
using System.Windows.Input;

namespace T_PACE
{
    public partial class MainWindow : Window
    {
        // Variáveis que vão controlar o banco e a lista de itens na tela
        private ProdutoRepository _repositorio;
        public ObservableCollection<ItemCupom> Carrinho { get; set; }

        public MainWindow()
        {
            InitializeComponent();

            // Inicializa as ferramentas
            _repositorio = new ProdutoRepository();
            Carrinho = new ObservableCollection<ItemCupom>();

            // Conecta a lista do XAML com a nossa lista do C#
            listaCupom.ItemsSource = Carrinho;

            // "Ouve" as teclas pressionadas no campo de busca
            txtBusca.KeyDown += TxtBusca_KeyDown;
        }

        // Função disparada toda vez que uma tecla é apertada na caixa de texto
        private void TxtBusca_KeyDown(object sender, KeyEventArgs e)
        {
            // Verifica se a tecla foi o "Enter" (gatilho do leitor de código de barras)
            if (e.Key == Key.Enter)
            {
                string codigo = txtBusca.Text.Trim();

                if (!string.IsNullOrEmpty(codigo))
                {
                    BiparProduto(codigo);
                }
            }
        }

        // Função que vai no banco de dados e adiciona à tela
        private void BiparProduto(string codigo)
        {
            // Vai no SQLite buscar o produto
            var produto = _repositorio.BuscarPorCodigoDeBarras(codigo);

            if (produto != null)
            {
                // Verifica se o produto já foi bipado antes para somar a quantidade
                var itemExistente = Carrinho.FirstOrDefault(c => c.Codigo == produto.codigo_barras);

                if (itemExistente != null)
                {
                    itemExistente.Quantidade += 1;
                    itemExistente.Total = itemExistente.Quantidade * itemExistente.PrecoUnitario;

                    // Força a lista visual a se atualizar
                    var index = Carrinho.IndexOf(itemExistente);
                    Carrinho[index] = itemExistente;
                }
                else
                {
                    // Se for a primeira vez, cria uma nova linha no carrinho
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

                // Limpa o campo para o próximo bipe
                txtBusca.Clear();
            }
            else
            {
                MessageBox.Show("Produto não encontrado no banco de dados!", "Aviso", MessageBoxButton.OK, MessageBoxImage.Warning);
                txtBusca.SelectAll(); // Seleciona o texto errado para o usuário apagar rápido
            }
        }

        // Função para recalcular o valor gigante ali de baixo
        private void AtualizarTotais()
        {
            decimal subtotal = Carrinho.Sum(i => i.Total);

            // Atualiza o textblock gigante no canto inferior direito
            txtTotal.Text = $"R$ {subtotal:N2}";
        }
    }

    // Classe molde que representa cada linha visual do nosso Cupom
    public class ItemCupom
    {
        public string Codigo { get; set; }
        public string Descricao { get; set; }
        public int Quantidade { get; set; }
        public decimal PrecoUnitario { get; set; }
        public decimal Total { get; set; }
    }
}