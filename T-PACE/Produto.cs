namespace T_PACE
{
    public class Produto
    {
        public int id { get; set; }
        public string codigo_barras { get; set; }
        public string nome { get; set; }
        public decimal custo { get; set; }
        public decimal preco_venda { get; set; }
        public string ncm { get; set; }
        public string cest { get; set; }
        public decimal aliquotas_imposto { get; set; }
        public decimal quantidade { get; set; }
        public string unidade_venda { get; set; }
        public bool em_promocao { get; set; }
    }
}