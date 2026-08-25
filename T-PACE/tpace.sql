PRAGMA defer_foreign_keys=TRUE;
CREATE TABLE tb_filiais (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cnpj VARCHAR(14) UNIQUE,
    nome_juridico VARCHAR(150),
    nome_fantasia VARCHAR(150),
    status BOOLEAN,
    inscricao_estadual VARCHAR(20),
    inscricao_municipal VARCHAR(20),
    crt TINYINT,
    caminho_certificado VARCHAR(255),
    senha_certificado VARCHAR(255),
    ambiente_nfe TINYINT,
    cep VARCHAR(8),
    logradouro VARCHAR(100),
    numero VARCHAR(10),
    complemento VARCHAR(50),
    bairro VARCHAR(60),
    cidade VARCHAR(100),
    cod_mun_ibge INTEGER,
    uf CHAR(2),
    telefone VARCHAR(15),
    email VARCHAR(100)
);
INSERT INTO "tb_filiais" ("id","cnpj","nome_juridico","nome_fantasia","status","inscricao_estadual","inscricao_municipal","crt","caminho_certificado","senha_certificado","ambiente_nfe","cep","logradouro","numero","complemento","bairro","cidade","cod_mun_ibge","uf","telefone","email") VALUES(1,'00.000.000/0000-00','juridico','fantasia',1,'123/4567890','123456-7',4,'123','123',123,'95720-000','Rua Buarque de Macedo','123','n tem','centro','garibaldi',4308607,'rs','54999999999','mail@mail.co');
CREATE TABLE tb_usuarios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    senha VARCHAR(255),
    pin VARCHAR(255),
    nivel_acesso INTEGER
, id_filial INTEGER REFERENCES tb_filiais(id));
INSERT INTO "tb_usuarios" ("id","nome","email","senha","pin","nivel_acesso","id_filial") VALUES(1,'admin','mail@mail.co','admin','admin',0,NULL);
INSERT INTO "tb_usuarios" ("id","nome","email","senha","pin","nivel_acesso","id_filial") VALUES(2,'gerente','mail2@mail.co','gerente','gerente',1,1);
INSERT INTO "tb_usuarios" ("id","nome","email","senha","pin","nivel_acesso","id_filial") VALUES(3,'financeiro','mail3@mail.co','financeiro','financeiro',2,1);
INSERT INTO "tb_usuarios" ("id","nome","email","senha","pin","nivel_acesso","id_filial") VALUES(4,'rh','mail4@mail.co','rh','rh',3,1);
INSERT INTO "tb_usuarios" ("id","nome","email","senha","pin","nivel_acesso","id_filial") VALUES(5,'gerente_estoque','mail5@mail.co','gerente_estoque','gerente_estoque',4,1);
INSERT INTO "tb_usuarios" ("id","nome","email","senha","pin","nivel_acesso","id_filial") VALUES(6,'repositor','mail6@mail.co','repositor','repositor',5,1);
CREATE TABLE tb_clientes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(100),
    cpf_cnpj VARCHAR(14) UNIQUE,
    email VARCHAR(100),
    telefone VARCHAR(15),
    cep VARCHAR(8),
    logradouro VARCHAR(100),
    numero VARCHAR(10),
    bairro VARCHAR(60),
    cidade VARCHAR(100),
    complemento VARCHAR(60),
    cod_mun_ibge INTEGER,
    uf CHAR(2)
);
INSERT INTO "tb_clientes" ("id","nome","cpf_cnpj","email","telefone","cep","logradouro","numero","bairro","cidade","complemento","cod_mun_ibge","uf") VALUES(1,'cliente','000.000.000-00','mail@mail.co','54999999999','99999-999','Avenida 2','123','pov moro no centro','garibaldi','to não',4308607,'rs');
INSERT INTO "tb_clientes" ("id","nome","cpf_cnpj","email","telefone","cep","logradouro","numero","bairro","cidade","complemento","cod_mun_ibge","uf") VALUES(2,'Empresa Parceira LTDA','12345678000195','contato@empresa.com','54988888888','95123-000','Rua Industrial','1000','Distrito Industrial','Carlos Barbosa','Galpão 3',4304804,'RS');
CREATE TABLE tb_fornecedores (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cnpj VARCHAR(14) UNIQUE,
    nome_juridico VARCHAR(150),
    nome_fantasia VARCHAR(150),
    inscricao_estadual VARCHAR(20),
    cep VARCHAR(8),
    logradouro VARCHAR(100),
    numero VARCHAR(10),
    complemento VARCHAR(60),
    bairro VARCHAR(60),
    cidade VARCHAR(100),
    cod_mun_ibge INTEGER,
    uf CHAR(2),
    telefone VARCHAR(15),
    email VARCHAR(100),
    status BOOLEAN
);
INSERT INTO "tb_fornecedores" ("id","cnpj","nome_juridico","nome_fantasia","inscricao_estadual","cep","logradouro","numero","complemento","bairro","cidade","cod_mun_ibge","uf","telefone","email","status") VALUES(1,'00.000.000/0000-00','juridicof','fantasiaf','123/4567890','12345-000','rua x','123',NULL,'centro','barbosa',4304804,'erriessi','54000000000','mail@mai.co',1);
CREATE TABLE tb_caixa (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_filial INTEGER,
    nome VARCHAR(30),
    status BOOLEAN,
    FOREIGN KEY(id_filial) REFERENCES tb_filiais(id)
);
INSERT INTO "tb_caixa" ("id","id_filial","nome","status") VALUES(1,1,'caixa',1);
CREATE TABLE tb_produtos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    codigo_barras VARCHAR(20) UNIQUE,
    nome VARCHAR(150),
    custo DECIMAL(10,2),
    preco_venda DECIMAL(10,2),
    ncm VARCHAR(8),
    cest VARCHAR(7),
    aliquotas_imposto DECIMAL(5,2),
    quantidade DECIMAL(10,3),
    valor_promocional DECIMAL(10,2),
    unidade_venda VARCHAR(2) CHECK(unidade_venda IN ('Kg', 'Un', 'L', 'G', 'Mt', 'Cx')),
    em_promocao BOOLEAN,
    lote VARCHAR(50),
    validade DATE,
    id_filial INTEGER, quantidade_minima DECIMAL(10,3) DEFAULT 10,
    FOREIGN KEY(id_filial) REFERENCES tb_filiais(id)
);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima") VALUES(1,'123456789','produto',25,50,'2202.10.00',' 17.044.00',3,60,35,'Un',1,'45678','',1,10);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima") VALUES(2,'987654321','BigMichi',560,780,'1101.10.00','65.022.00',3,30,560000,'Un',0,'56770','',1,10);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima") VALUES(3,'7891114158656','garrafa tramontina cinza da larissa',5,99,'3923.30.90','',1,100,12,'Un',1,'1234','',1,10);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima") VALUES(4,'7890001112223','Vela de Aniversário Estrelinha',1.5,4,'3406.00.00',NULL,1,200,NULL,'Un',0,'LOTE99',NULL,1,10);
CREATE TABLE tb_entradas_xml (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    chave_nfe VARCHAR(44) UNIQUE,
    id_fornecedor INTEGER,
    data_entrada DATETIME,
    valor_total DECIMAL(10,2),
    id_filial INTEGER,
    FOREIGN KEY(id_fornecedor) REFERENCES tb_fornecedores(id),
    FOREIGN KEY(id_filial) REFERENCES tb_filiais(id)
);
CREATE TABLE tb_sessao_caixa (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_caixa INTEGER,
    id_usuario INTEGER,
    data_abertura DATETIME,
    valor_fundo_troco DECIMAL(10,2),
    data_fechamento DATETIME,
    status BOOLEAN,
    valor_fechamento DECIMAL(10,2),
    FOREIGN KEY(id_caixa) REFERENCES tb_caixa(id),
    FOREIGN KEY(id_usuario) REFERENCES tb_usuarios(id)
);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(1,1,2,'2026-08-25 08:00:00',100,NULL,1,NULL);
CREATE TABLE tb_vendas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_sessao_caixa INTEGER,
    id_cliente INTEGER,
    data_hora DATETIME,
    subtotal DECIMAL(10,2),
    desconto DECIMAL(10,2),
    total DECIMAL(10,2),
    status VARCHAR(15) CHECK(status IN ('pago', 'cancelado', 'pendente')),
    chave_nfe VARCHAR(44),
    FOREIGN KEY(id_sessao_caixa) REFERENCES tb_sessao_caixa(id),
    FOREIGN KEY(id_cliente) REFERENCES tb_clientes(id)
);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(1,1,1,'2026-08-25 10:00:00',149,0,149,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(2,1,NULL,'2026-08-25 10:15:00',780,0,780,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(3,1,2,'2026-08-25 11:30:00',54,0,54,'pago',NULL);
CREATE TABLE tb_pagamentos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_venda INTEGER,
    metodo VARCHAR(20) CHECK(metodo IN ('pix', 'dinheiro', 'cartão de crédito', 'cartão de débito')),
    valor DECIMAL(10,2),
    cod_autorizacao_tef VARCHAR(50),
    FOREIGN KEY(id_venda) REFERENCES tb_vendas(id)
);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(1,2,'dinheiro',780,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(2,1,'pix',149,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(3,3,'cartão de crédito',54,NULL);
CREATE TABLE tb_itens_venda (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_venda INTEGER,
    id_produto INTEGER,
    quantidade DECIMAL(10,3),
    preco_unitario DECIMAL(10,2),
    subtotal DECIMAL(10,2),
    FOREIGN KEY(id_venda) REFERENCES tb_vendas(id),
    FOREIGN KEY(id_produto) REFERENCES tb_produtos(id)
);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(1,2,2,1,780,780);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(2,1,3,1,99,99);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(3,1,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(4,3,1,1,50,50);
DELETE FROM sqlite_sequence;
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_filiais',1);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_usuarios',6);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_clientes',2);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_fornecedores',1);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_caixa',1);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_produtos',5);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_sessao_caixa',1);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_vendas',3);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_itens_venda',4);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_pagamentos',3);
CREATE INDEX idx_usuarios_nivel_acesso ON tb_usuarios(nivel_acesso);
CREATE INDEX idx_fornecedores_nome_fantasia ON tb_fornecedores(nome_fantasia);
CREATE INDEX idx_caixa_id_filial ON tb_caixa(id_filial);
CREATE INDEX idx_produtos_id_filial ON tb_produtos(id_filial);
CREATE INDEX idx_entradas_xml_id_filial ON tb_entradas_xml(id_filial);
CREATE INDEX idx_sessao_caixa_id_caixa ON tb_sessao_caixa(id_caixa);
CREATE INDEX idx_sessao_caixa_id_usuario ON tb_sessao_caixa(id_usuario);
CREATE INDEX idx_sessao_caixa_data_abertura ON tb_sessao_caixa(data_abertura);
CREATE INDEX idx_sessao_caixa_data_fechamento ON tb_sessao_caixa(data_fechamento);
CREATE INDEX idx_vendas_id_sessao_caixa ON tb_vendas(id_sessao_caixa);
CREATE INDEX idx_vendas_id_cliente ON tb_vendas(id_cliente);
CREATE INDEX idx_vendas_data_hora ON tb_vendas(data_hora);
CREATE INDEX idx_pagamentos_id_venda ON tb_pagamentos(id_venda);
CREATE INDEX idx_itens_venda_id_venda ON tb_itens_venda(id_venda);
CREATE INDEX idx_itens_venda_id_produto ON tb_itens_venda(id_produto);