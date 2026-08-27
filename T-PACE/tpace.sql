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
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima") VALUES(1,'123456789','produto',25,50,'2202.10.00',' 17.044.00',3,50,35,'Un',1,'45678','',1,10);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima") VALUES(2,'987654321','BigMichi',560,780,'1101.10.00','65.022.00',3,28,56,'Un',1,'56770','',1,10);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima") VALUES(3,'7891114158656','garrafa tramontina cinza da larissa',5,99,'3923.30.90','',1,97,12,'Un',0,'1234','',1,10);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima") VALUES(6,'7891360677215','garrafa preta owala','',150,'','','',48,100,'Un',1,'','',1,1);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima") VALUES(7,'7503002942550','canetão rojo puta da lari',0,15,'','','',8497,'','Un',0,'','2026-08-25',1,1);
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
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(4,NULL,NULL,'2026-08-25 22:01:36',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(5,NULL,NULL,'2026-08-25 22:04:01',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(6,NULL,NULL,'2026-08-25 22:11:16',300,0,300,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(7,NULL,NULL,'2026-08-25 22:17:51',150,0,150,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(8,NULL,NULL,'2026-08-25 22:19:05',150,0,150,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(9,NULL,NULL,'2026-08-25 22:22:41',1130,267.25,862.75,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(10,NULL,NULL,'2026-08-25 22:27:58',150,50,100,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(11,NULL,NULL,'2026-08-25 22:28:20',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(12,NULL,NULL,'2026-08-25 22:46:18',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(13,NULL,NULL,'2026-08-25 22:46:56',880,30,850,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(14,NULL,NULL,'2026-08-25 22:47:11',99,0,99,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(15,NULL,NULL,'2026-08-25 22:47:33',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(16,NULL,NULL,'2026-08-25 22:52:16',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(17,NULL,NULL,'2026-08-25 22:53:08',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(18,NULL,NULL,'2026-08-26 13:20:55',249,149.5,99.5,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(19,NULL,NULL,'2026-08-26 13:29:13',300,0,300,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(20,NULL,NULL,'2026-08-26 13:34:11',15,0,15,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(21,NULL,NULL,'2026-08-26 13:34:17',150,50,100,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(22,NULL,NULL,'2026-08-26 13:34:25',99,0,99,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(23,NULL,NULL,'2026-08-26 13:35:22',15,0,15,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(24,NULL,NULL,'2026-08-26 13:36:08',15,0,15,'pago',NULL);
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
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(4,8,'pix',150,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(5,9,'cartão de débito',862.75,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(6,11,'dinheiro',35,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(7,4,'dinheiro',35,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(8,5,'cartão de crédito',35,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(9,6,'pix',300,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(10,7,'dinheiro',150,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(11,10,'pix',100,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(12,12,'cartão de crédito',35,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(13,13,'cartão de crédito',850,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(14,14,'dinheiro',99,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(15,15,'cartão de débito',35,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(16,16,'dinheiro',35,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(17,17,'dinheiro',35,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(18,18,'dinheiro',99.5,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(19,19,'cartão de crédito',300,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(20,20,'dinheiro',15,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(21,21,'dinheiro',100,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(22,22,'dinheiro',99,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(23,23,'dinheiro',15,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(24,24,'dinheiro',15,NULL);
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
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(5,8,6,1,150,150);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(6,9,6,2,150,200);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(7,9,1,1,50,35);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(8,9,2,1,780,780);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(9,11,1,1,50,35);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(10,4,1,1,50,35);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(11,5,1,1,50,35);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(12,6,6,2,150,300);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(13,7,6,1,150,150);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(14,10,6,1,150,100);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(15,12,1,1,50,35);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(16,13,1,2,50,70);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(17,13,2,1,780,780);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(18,14,3,1,99,99);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(19,15,1,1,50,35);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(20,16,1,1,50,35);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(21,17,1,1,50,35);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(22,18,6,1,150,100);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(23,18,3,1,99,99);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(24,19,7,20,15,300);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(25,20,7,1,15,15);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(26,21,6,1,150,100);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(27,22,3,1,99,99);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(28,23,7,1,15,15);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(29,24,7,1,15,15);
DELETE FROM sqlite_sequence;
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_filiais',1);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_usuarios',6);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_clientes',2);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_fornecedores',1);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_caixa',1);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_produtos',7);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_sessao_caixa',1);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_vendas',24);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_itens_venda',29);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_pagamentos',24);
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
