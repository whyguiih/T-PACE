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
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima") VALUES(1,'123456789','produto',25,50,'2202.10.00',' 17.044.00',3,17,35,'Un',0,'45678','',1,10);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima") VALUES(2,'987654321','BigMichi',560,780,'1101.10.00','65.022.00',3,15,56,'Un',0,'56770','',1,10);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima") VALUES(3,'7891114158656','garrafa tramontina cinza da larissa',5,99,'3923.30.90','',1,97,12,'Un',1,'1234','',1,10);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima") VALUES(6,'7891360677215','garrafa preta owala','',150,'','','',2,100,'Un',0,'','',1,1);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima") VALUES(7,'7503002942550','canetão rojo puta da lari','',15,'','','',8460,10,'Un',1,'','2026-08-25',1,1);
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
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(2,1,1,'2026-08-25 19:55:05',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(3,1,1,'2026-08-25 20:00:09',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(4,1,1,'2026-08-25 20:08:08',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(5,1,1,'2026-08-25 20:09:59',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(6,1,1,'2026-08-25 20:15:34',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(7,1,1,'2026-08-25 20:16:31',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(8,1,1,'2026-08-25 20:17:09',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(9,1,1,'2026-08-25 20:26:10',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(10,1,1,'2026-08-25 20:27:40',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(11,1,1,'2026-08-25 20:29:42',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(12,1,1,'2026-08-25 20:36:57',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(13,1,1,'2026-08-25 20:38:32',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(14,1,1,'2026-08-25 20:48:50',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(15,1,2,'2026-08-25 20:49:27',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(16,1,1,'2026-08-25 20:51:59',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(17,1,1,'2026-08-25 21:02:09',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(18,1,1,'2026-08-25 21:06:18',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(19,1,1,'2026-08-25 21:06:42',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(20,1,1,'2026-08-25 21:33:51',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(21,1,1,'2026-08-25 21:40:13',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(22,1,1,'2026-08-25 21:41:37',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(23,1,1,'2026-08-25 21:43:02',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(24,1,1,'2026-08-25 21:54:58',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(25,1,1,'2026-08-25 21:59:19',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(26,1,1,'2026-08-25 22:01:32',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(27,1,1,'2026-08-25 22:03:46',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(28,1,1,'2026-08-25 22:10:53',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(29,1,1,'2026-08-25 22:17:41',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(30,1,1,'2026-08-25 22:18:56',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(31,1,1,'2026-08-25 22:22:14',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(32,1,1,'2026-08-25 22:27:48',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(33,1,1,'2026-08-25 22:46:14',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(34,1,1,'2026-08-25 22:46:44',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(35,1,1,'2026-08-25 22:47:27',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(36,1,1,'2026-08-25 22:52:10',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(37,1,1,'2026-08-25 22:53:03',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(38,1,1,'2026-08-25 23:26:36',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(39,1,1,'2026-08-25 23:29:02',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(40,1,1,'2026-08-25 23:30:23',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(41,1,1,'2026-08-25 23:34:48',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(42,1,1,'2026-08-26 13:17:38',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(43,1,1,'2026-08-26 13:28:34',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(44,1,1,'2026-08-26 13:35:08',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(45,1,1,'2026-08-26 13:35:52',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(46,1,1,'2026-08-27 14:03:11',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(47,1,1,'2026-08-27 14:04:15',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(48,1,1,'2026-08-27 14:12:40',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(49,1,1,'2026-08-27 14:13:32',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(50,1,1,'2026-08-27 14:17:24',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(51,1,1,'2026-08-27 14:19:01',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(52,1,1,'2026-08-27 14:21:04',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(53,1,1,'2026-08-27 14:23:37',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(54,1,1,'2026-08-27 14:29:51',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(55,1,1,'2026-08-27 14:50:03',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(56,1,1,'2026-08-27 14:51:54',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(57,1,1,'2026-08-27 15:13:53',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(58,1,1,'2026-08-27 15:18:04',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(59,1,1,'2026-08-27 15:24:09',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(60,1,1,'2026-08-27 15:26:30',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(61,1,1,'2026-08-27 15:27:38',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(62,1,1,'2026-08-27 15:28:14',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(63,1,1,'2026-08-27 15:28:48',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(64,1,1,'2026-08-27 15:29:14',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(65,1,1,'2026-08-27 15:31:07',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(66,1,1,'2026-08-27 15:53:14',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(67,1,1,'2026-08-27 15:55:07',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(68,1,1,'2026-08-27 15:57:38',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(69,1,1,'2026-08-27 15:58:59',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(70,1,1,'2026-08-27 16:05:54',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(71,1,1,'2026-08-27 16:26:12',0,'2026-08-27 16:26:30',0,50);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(72,1,1,'2026-08-27 16:27:25',0,'2026-08-27 16:28:20',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(73,1,1,'2026-08-27 16:34:49',0,'2026-08-27 16:35:10',0,740);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(74,1,1,'2026-08-27 16:41:25',0,'2026-08-27 16:41:39',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(75,1,1,'2026-08-27 16:42:04',0,'2026-08-27 16:42:29',0,0);
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
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(4,1,NULL,'2026-08-25 22:01:36',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(5,1,NULL,'2026-08-25 22:04:01',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(6,1,NULL,'2026-08-25 22:11:16',300,0,300,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(7,1,NULL,'2026-08-25 22:17:51',150,0,150,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(8,1,NULL,'2026-08-25 22:19:05',150,0,150,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(9,1,NULL,'2026-08-25 22:22:41',1130,267.25,862.75,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(10,1,NULL,'2026-08-25 22:27:58',150,50,100,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(11,1,NULL,'2026-08-25 22:28:20',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(12,1,NULL,'2026-08-25 22:46:18',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(13,1,NULL,'2026-08-25 22:46:56',880,30,850,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(14,1,NULL,'2026-08-25 22:47:11',99,0,99,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(15,1,NULL,'2026-08-25 22:47:33',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(16,1,NULL,'2026-08-25 22:52:16',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(17,1,NULL,'2026-08-25 22:53:08',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(18,1,NULL,'2026-08-26 13:20:55',249,149.5,99.5,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(19,1,NULL,'2026-08-26 13:29:13',300,0,300,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(20,1,NULL,'2026-08-26 13:34:11',15,0,15,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(21,1,NULL,'2026-08-26 13:34:17',150,50,100,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(22,1,NULL,'2026-08-26 13:34:25',99,0,99,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(23,1,NULL,'2026-08-26 13:35:22',15,0,15,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(24,1,NULL,'2026-08-26 13:36:08',15,0,15,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(25,NULL,NULL,'2026-08-27 14:03:24',150,50,100,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(26,NULL,NULL,'2026-08-27 14:03:28',150,50,100,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(27,NULL,NULL,'2026-08-27 14:03:28',150,50,100,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(28,NULL,NULL,'2026-08-27 14:03:29',150,50,100,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(29,NULL,NULL,'2026-08-27 14:03:29',150,50,100,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(30,NULL,NULL,'2026-08-27 14:03:29',150,50,100,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(31,NULL,NULL,'2026-08-27 14:03:29',150,50,100,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(32,NULL,NULL,'2026-08-27 14:03:30',150,50,100,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(33,NULL,NULL,'2026-08-27 14:03:30',150,50,100,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(34,NULL,NULL,'2026-08-27 14:03:30',150,50,100,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(35,NULL,NULL,'2026-08-27 14:03:31',150,50,100,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(36,NULL,NULL,'2026-08-27 14:03:32',150,50,100,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(37,NULL,NULL,'2026-08-27 14:03:33',150,50,100,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(38,NULL,NULL,'2026-08-27 14:03:35',150,50,100,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(39,NULL,NULL,'2026-08-27 14:03:36',150,50,100,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(40,NULL,NULL,'2026-08-27 14:03:37',150,50,100,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(41,NULL,NULL,'2026-08-27 14:04:23',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(42,NULL,NULL,'2026-08-27 14:12:45',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(43,NULL,NULL,'2026-08-27 14:13:44',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(44,NULL,NULL,'2026-08-27 14:14:40',1610,1463,147,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(45,NULL,NULL,'2026-08-27 14:17:29',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(46,NULL,NULL,'2026-08-27 14:17:50',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(47,NULL,NULL,'2026-08-27 14:19:05',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(48,NULL,NULL,'2026-08-27 14:21:19',150,45,105,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(49,NULL,NULL,'2026-08-27 14:23:41',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(50,NULL,NULL,'2026-08-27 14:23:51',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(51,NULL,NULL,'2026-08-27 14:29:56',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(52,NULL,NULL,'2026-08-27 14:30:14',780,724,56,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(53,NULL,NULL,'2026-08-27 14:31:24',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(54,NULL,NULL,'2026-08-27 14:50:07',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(55,NULL,NULL,'2026-08-27 14:51:58',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(56,NULL,NULL,'2026-08-27 15:13:59',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(57,NULL,NULL,'2026-08-27 15:14:23',780,724,56,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(58,NULL,NULL,'2026-08-27 15:18:09',50,15,35,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(59,NULL,NULL,'2026-08-27 15:20:01',1304,839,465,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(60,NULL,NULL,'2026-08-27 15:24:12',50,0,50,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(61,NULL,NULL,'2026-08-27 15:26:33',50,0,50,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(62,NULL,NULL,'2026-08-27 15:27:42',50,0,50,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(63,NULL,NULL,'2026-08-27 15:28:21',50,0,50,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(64,NULL,NULL,'2026-08-27 15:28:52',50,0,50,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(65,NULL,NULL,'2026-08-27 15:29:18',50,0,50,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(66,NULL,NULL,'2026-08-27 15:31:11',50,0,50,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(67,NULL,NULL,'2026-08-27 15:55:37',2480,0,2480,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(68,NULL,NULL,'2026-08-27 15:56:05',2390,90,2300,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(69,NULL,NULL,'2026-08-27 15:56:23',1610,0,1610,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(70,NULL,NULL,'2026-08-27 15:59:11',1130,0,1130,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(71,NULL,NULL,'2026-08-27 16:07:10',2525,65,2460,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(72,NULL,NULL,'2026-08-27 16:26:20',50,0,50,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(73,NULL,NULL,'2026-08-27 16:27:30',50,0,50,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(74,73,NULL,'2026-08-27 16:35:02',750,0,750,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(75,74,NULL,'2026-08-27 16:41:34',75,25,50,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(76,75,NULL,'2026-08-27 16:42:13',60,20,40,'pago',NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe") VALUES(77,75,NULL,'2026-08-27 16:42:26',150,50,100,'pago',NULL);
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
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(25,25,'dinheiro',100,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(26,26,'dinheiro',100,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(27,27,'dinheiro',100,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(28,28,'dinheiro',100,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(29,29,'dinheiro',100,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(30,30,'dinheiro',100,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(31,31,'dinheiro',100,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(32,32,'dinheiro',100,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(33,33,'dinheiro',100,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(34,34,'dinheiro',100,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(35,35,'dinheiro',100,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(36,36,'dinheiro',100,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(37,37,'dinheiro',100,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(38,38,'dinheiro',100,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(39,39,'dinheiro',100,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(40,40,'dinheiro',100,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(41,41,'dinheiro',35,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(42,42,'dinheiro',35,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(43,43,'dinheiro',35,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(44,44,'dinheiro',147,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(45,45,'dinheiro',35,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(46,46,'dinheiro',35,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(47,47,'dinheiro',35,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(48,48,'dinheiro',105,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(49,49,'dinheiro',35,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(50,50,'dinheiro',35,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(51,51,'dinheiro',35,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(52,52,'dinheiro',56,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(53,53,'dinheiro',35,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(54,54,'dinheiro',35,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(55,55,'dinheiro',35,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(56,56,'dinheiro',35,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(57,57,'pix',56,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(58,58,'dinheiro',35,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(59,59,'cartão de crédito',465,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(60,60,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(61,61,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(62,62,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(63,63,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(64,64,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(65,65,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(66,66,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(67,67,'dinheiro',2480,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(68,68,'dinheiro',2300,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(69,69,'dinheiro',1610,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(70,70,'dinheiro',1130,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(71,71,'cartão de débito',2460,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(72,72,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(73,73,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(74,74,'dinheiro',750,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(75,75,'cartão de crédito',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(76,76,'dinheiro',40,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(77,77,'dinheiro',100,NULL);
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
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(30,25,6,1,150,100);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(31,26,6,1,150,100);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(32,27,6,1,150,100);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(33,28,6,1,150,100);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(34,29,6,1,150,100);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(35,30,6,1,150,100);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(36,31,6,1,150,100);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(37,32,6,1,150,100);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(38,33,6,1,150,100);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(39,34,6,1,150,100);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(40,35,6,1,150,100);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(41,36,6,1,150,100);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(42,37,6,1,150,100);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(43,38,6,1,150,100);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(44,39,6,1,150,100);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(45,40,6,1,150,100);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(46,41,1,1,50,35);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(47,42,1,1,50,35);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(48,43,1,1,50,35);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(49,44,2,2,780,112);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(50,44,1,1,50,35);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(51,45,1,1,50,35);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(52,46,1,1,50,35);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(53,47,1,1,50,35);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(54,48,1,3,50,105);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(55,49,1,1,50,35);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(56,50,1,1,50,35);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(57,51,1,1,50,35);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(58,52,2,1,780,56);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(59,53,1,1,50,35);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(60,54,1,1,50,35);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(61,55,1,1,50,35);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(62,56,1,1,50,35);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(63,57,2,1,780,56);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(64,58,1,1,50,35);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(65,59,3,1,99,99);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(66,59,6,2,150,200);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(67,59,1,1,50,35);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(68,59,2,1,780,56);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(69,59,7,5,15,75);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(70,60,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(71,61,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(72,62,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(73,63,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(74,64,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(75,65,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(76,66,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(77,67,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(78,67,2,1,780,780);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(79,67,6,11,150,1650);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(80,68,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(81,68,2,3,780,2340);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(82,69,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(83,69,2,2,780,1560);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(84,70,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(85,70,2,1,780,780);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(86,70,6,2,150,300);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(87,71,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(88,71,2,1,780,780);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(89,71,6,10,150,1500);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(90,71,7,13,15,130);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(91,72,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(92,73,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(93,74,6,5,150,750);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(94,75,7,5,15,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(95,76,7,4,15,40);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(96,77,7,10,15,100);
CREATE TABLE tb_funcionarios (
  id int,
  id_usuario int,
  nome_completo varchar(80) not null,
  data_nascimento date,
  genero tinyint, 
  raca tinyint,
  estado_civil tinyint,
  nacionalidade text(40),
  naturalidade text(40),
  cpf text(11) not null,
  orgao_emissor text(50),
  email text(80),
  telefone text(11),
  contato_emergencia text(11),
  pcd boolean,
  escolaridade tinyint,
  formacao_academica text(40),
  logradouro text(60),
  numero int(4),
  bairro text(40),
  cidade text(60),
  cep text(8),
  complemento text,
  status boolean,
  primary key(id),
  foreign key (id_usuario) references tb_usuarios (id)
);
CREATE TABLE tb_funcionarios_complemento (
  id int,
  id_funcionario int,
  data_admissao date,
  tipo contrato tinyint,
  cargo text,
  nivel_senioridade tinyint,
  setor text,
  gestor int,
  tempo_empregado text,
  modelo_trabalho tinyint,
  escala_trabalho tinyint,
  salario_base real,
  tipo_remuneracao tinyint,
  banco text,
  agencia int,
  chave_pix text,
  centro_custo text,
  data_demissao date,
  tipo_demissao tinyint,
  motivo_demissao text,
  primary key (id),
  foreign key (id_funcionario) references tb_funcionarios (id),
  foreign key (gestor) references tb_funcionarios (id)
);
DELETE FROM sqlite_sequence;
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_filiais',1);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_usuarios',6);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_clientes',2);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_fornecedores',1);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_caixa',1);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_produtos',8);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_sessao_caixa',75);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_vendas',77);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_itens_venda',96);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_pagamentos',77);
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
