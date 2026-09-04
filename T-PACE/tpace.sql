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
    id_filial INTEGER, quantidade_minima DECIMAL(10,3) DEFAULT 10, foto text, codigo_geral int(13),
    FOREIGN KEY(id_filial) REFERENCES tb_filiais(id)
);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(1,'123456789','produtos',25,50,'2202.10.00',' 17.044.00',3,34,39,'Un',0,'45678',NULL,1,10,'https://pub-https://c5ee40d961c6c73a7181839dec953784.r2.cloudflarestorage.com/tpace.r2.dev/1788289076569_Logofundo.jpg',NULL);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(2,'987654321','BigMichi',560,780,'1101.10.00','65.022.00',3,44,56,'Un',0,'56770','',1,10,'https://pub-https://c5ee40d961c6c73a7181839dec953784.r2.cloudflarestorage.com/tpace.r2.dev/1788285309260_Logofundo.jpg',NULL);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(3,'7891114158656','garrafa tramontina cinza da larissa',5,99,'3923.30.90','',1,56,12,'Un',1,'1234','',1,10,NULL,NULL);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(6,'7891360677215','garrafa preta owala','',150,'','','',93,100,'Un',0,'','',1,1,NULL,NULL);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(7,'7503002942550','canetão rojo puta da lari','',15,'','','',8450,10,'Un',1,'','2026-08-25',1,1,NULL,NULL);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(9,'7898994271727','Água com gás hortênsias',1,1.99,'','','',48,0.99,'Un',0,'','',1,20,NULL,NULL);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(11,'234567890123','Casquinha de morango',3,7,'2202.10.00',' 17.044.00',60,40,5,'Un',0,'45678','2026-09-02',1,30,'https://pub-c5ee40d961c6c73a7181839dec953784.r2.cloudflarestorage.com/tpace.r2.dev/1788284496164_casquinhaMorango.jpg',NULL);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(12,'345678987634','produto',457,4657,'2202.10.00',' 17.044.00',46,45,4573,'Kg',1,'45678','2026-09-03',1,45,'https://pub-https://c5ee40d961c6c73a7181839dec953784.r2.cloudflarestorage.com/tpace.r2.dev/1788286564138_promocao.jpg',NULL);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(13,'1234567890123','Casquinha de creme',3,7,'2202.10.00',' 17.044.00',50,40,NULL,'Un',0,'45678','2026-09-25',1,30,'https://pub-https://c5ee40d961c6c73a7181839dec953784.r2.cloudflarestorage.com/tpace.r2.dev/1788290515432_foto_camera.jpg',NULL);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(14,'123456789064','Vaca',60,79,'2202.10.00',' 17.044.00',467,67,68,'L',1,'45679','2026-09-25',1,58,'https://pub-3c9f79138dbf4db3a3162daf6775e244.r2.dev/1788287282387_BonecaFooterIcone.jpg',NULL);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(23,'1324567890976','Viado Agressivo',0.05,10,'12325345','435625',4567,50,4,'Mt',1,'45646','2026-09-26',1,5,'https://pub-c5ee40d961c6c73a7181839dec953784.r2.cloudflarestorage.com/tpace.r2.dev/1788393733260_17883937047982746544384959964947.jpg',NULL);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(24,'7898119104770','werty',13,15,NULL,NULL,NULL,8,10,'Un',0,NULL,'2012-12-12',1,3,NULL,7139905004540);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(25,'7898119104695','werty',13,15,NULL,NULL,NULL,8,10,'Un',0,NULL,'2012-12-12',1,3,NULL,7139905004540);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(26,'7896303620068','werty',13,15,NULL,NULL,NULL,8,10,'Un',0,NULL,'2012-12-12',1,3,NULL,7139905004540);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(27,'6934220122294','werty',13,15,NULL,NULL,NULL,8,10,'Un',0,NULL,'2012-12-12',1,3,NULL,7139905004540);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(28,'7897256220015','werty',13,15,NULL,NULL,NULL,8,10,'Un',0,NULL,'2012-12-12',1,3,NULL,7139905004540);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(29,'7908631415060','werty',13,15,NULL,NULL,NULL,8,10,'Un',0,NULL,'2012-12-12',1,3,NULL,7139905004540);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(30,'7898119104671','werty',13,15,NULL,NULL,NULL,8,10,'Un',0,NULL,'2012-12-12',1,3,NULL,7139905004540);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(31,'8802017201386','werty',13,15,NULL,NULL,NULL,8,10,'Un',0,NULL,'2012-12-12',1,3,NULL,7139905004540);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(32,'7899150752814','werty',13,15,NULL,NULL,NULL,8,10,'Un',0,NULL,'2012-12-12',1,3,NULL,7139905004540);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(34,'1234567890','dfert',3,6,NULL,NULL,NULL,5,3,'Un',0,'1356','2000-03-12',1,10,NULL,5334424674118);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(36,'70612','joias',12,40,NULL,NULL,NULL,7,25,'Un',0,'23456','2012-12-12',1,2,NULL,1768619703506);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(37,'75639','joias',12,40,NULL,NULL,NULL,7,25,'Un',0,'23456','2012-12-12',1,2,NULL,1768619703506);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(38,'34653','joias',12,40,NULL,NULL,NULL,7,25,'Un',0,'23456','2012-12-12',1,2,NULL,1768619703506);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(39,'82347','joias',12,40,NULL,NULL,NULL,7,25,'Un',0,'23456','2012-12-12',1,2,NULL,1768619703506);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(40,'01253','joias',12,40,NULL,NULL,NULL,7,25,'Un',0,'23456','2012-12-12',1,2,NULL,1768619703506);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(41,'40564','joias',12,40,NULL,NULL,NULL,7,25,'Un',0,'23456','2012-12-12',1,2,NULL,1768619703506);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(42,'52636','joias',12,40,NULL,NULL,NULL,7,25,'Un',0,'23456','2012-12-12',1,2,NULL,1768619703506);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(43,'71745','joias',12,40,NULL,NULL,NULL,7,25,'Un',0,'23456','2012-12-12',1,2,NULL,1768619703506);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(44,'77555','joias',12,40,NULL,NULL,NULL,7,25,'Un',0,'23456','2012-12-12',1,2,NULL,1768619703506);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(45,'76602','joias',12,40,NULL,NULL,NULL,7,25,'Un',0,'23456','2012-12-12',1,2,NULL,1768619703506);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(46,'79482','joias',12,40,NULL,NULL,NULL,7,25,'Un',0,'23456','2012-12-12',1,2,NULL,1768619703506);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(47,'51816','joias',12,40,NULL,NULL,NULL,7,25,'Un',0,'23456','2012-12-12',1,2,NULL,1768619703506);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(48,'83794','joias',12,40,NULL,NULL,NULL,7,25,'Un',0,'23456','2012-12-12',1,2,NULL,1768619703506);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(49,'48452','joisas',2,550,NULL,NULL,NULL,11,300,'Un',1,'876543','2012-12-11',1,5,NULL,6230115524705);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(50,'89181','joisas',2,550,NULL,NULL,NULL,11,300,'Un',1,'876543','2012-12-11',1,5,NULL,6230115524705);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(51,'06036','joisas',2,550,NULL,NULL,NULL,11,300,'Un',1,'876543','2012-12-11',1,5,NULL,6230115524705);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(52,'32879','joisas',2,550,NULL,NULL,NULL,11,300,'Un',1,'876543','2012-12-11',1,5,NULL,6230115524705);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(53,'05652','joisas',2,550,NULL,NULL,NULL,11,300,'Un',1,'876543','2012-12-11',1,5,NULL,6230115524705);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(54,'30146','joisas',2,550,NULL,NULL,NULL,11,300,'Un',1,'876543','2012-12-11',1,5,NULL,6230115524705);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(55,'71655','joisas',2,550,NULL,NULL,NULL,11,300,'Un',1,'876543','2012-12-11',1,5,NULL,6230115524705);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(56,'10130','joisas',2,550,NULL,NULL,NULL,11,300,'Un',1,'876543','2012-12-11',1,5,NULL,6230115524705);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(57,'06024','joisas',2,550,NULL,NULL,NULL,11,300,'Un',1,'876543','2012-12-11',1,5,NULL,6230115524705);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(58,'08235','joisas',2,550,NULL,NULL,NULL,11,300,'Un',1,'876543','2012-12-11',1,5,NULL,6230115524705);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(59,'61740','joisas',2,550,NULL,NULL,NULL,11,300,'Un',1,'876543','2012-12-11',1,5,NULL,6230115524705);
INSERT INTO "tb_produtos" ("id","codigo_barras","nome","custo","preco_venda","ncm","cest","aliquotas_imposto","quantidade","valor_promocional","unidade_venda","em_promocao","lote","validade","id_filial","quantidade_minima","foto","codigo_geral") VALUES(60,'93057','joisas',2,550,NULL,NULL,NULL,11,300,'Un',1,'876543','2012-12-11',1,5,NULL,6230115524705);
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
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(1,1,2,'2026-08-25 08:00:00',100,'2026-08-30 01:12:03.3747744',0,50);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(2,1,1,'2026-08-25 19:55:05',0,'2026-08-30 00:49:13',0,500);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(3,1,1,'2026-08-25 20:00:09',0,'2026-08-30 00:58:02',0,26268161);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(4,1,1,'2026-08-25 20:08:08',0,'2026-08-30 01:07:22',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(5,1,1,'2026-08-25 20:09:59',0,'2026-08-30 01:02:41',0,100);
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
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(76,1,1,'2026-08-27 16:54:26',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(77,1,1,'2026-08-27 17:07:08',0,'2026-08-27 17:07:13',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(78,1,1,'2026-08-27 22:18:28',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(79,1,1,'2026-08-27 22:26:19',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(80,1,1,'2026-08-27 22:39:11',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(81,1,1,'2026-08-27 22:43:22',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(82,1,1,'2026-08-27 22:43:55',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(83,1,1,'2026-08-27 22:46:45',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(84,1,1,'2026-08-27 22:51:59',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(85,1,1,'2026-08-27 22:53:42',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(86,1,1,'2026-08-27 22:58:18',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(87,1,1,'2026-08-27 23:01:11',0,'2026-08-27 23:02:05',0,50);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(88,1,4,'2026-08-30 01:16:09',0,'2026-08-30 01:16:15',0,5767);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(89,1,1,'2026-08-31 10:38:50',1000,'2026-08-31 10:39:33',0,1830);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(90,1,1,'2026-08-31 18:19:05',50,'2026-08-31 18:24:44',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(91,1,1,'2026-08-31 18:33:58',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(92,1,1,'2026-08-31 18:34:17',0,'2026-08-31 18:34:26',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(93,1,1,'2026-08-31 20:38:02',0,'2026-08-31 20:39:27',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(94,1,1,'2026-09-01 14:04:47',0,'2026-09-01 14:04:53',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(95,1,4,'2026-09-01 14:10:43',0,'2026-09-01 14:15:26',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(96,1,1,'2026-09-01 16:02:20',0,'2026-09-01 16:05:12',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(97,1,1,'2026-09-02 14:26:45',0,'2026-09-02 14:26:57',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(98,1,1,'2026-09-02 14:27:10',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(99,1,1,'2026-09-02 16:31:11',0,'2026-09-02 16:31:44',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(100,1,1,'2026-09-02 16:32:08',0,'2026-09-02 16:32:49',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(101,1,1,'2026-09-02 16:37:21',0,'2026-09-02 16:38:32',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(102,1,1,'2026-09-02 16:46:12',0,'2026-09-02 16:46:24',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(103,1,1,'2026-09-02 17:03:40',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(104,1,1,'2026-09-02 21:04:49',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(105,1,1,'2026-09-02 21:23:16',0,'2026-09-02 21:23:32',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(106,1,1,'2026-09-03 13:27:43',500,'2026-09-03 13:29:54',0,550);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(107,1,1,'2026-09-03 13:29:12',0,'2026-09-03 13:31:27',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(108,1,1,'2026-09-03 14:03:30',0,'2026-09-03 14:04:46',0,500);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(109,1,1,'2026-09-03 14:28:43',0,'2026-09-03 14:36:27',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(110,1,1,'2026-09-03 14:41:38',500,'2026-09-03 14:55:59',0,550);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(111,1,1,'2026-09-03 14:50:42',0,'2026-09-03 14:50:57',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(112,1,1,'2026-09-03 14:54:53',0,'2026-09-03 14:55:20',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(113,1,1,'2026-09-03 14:56:20',0,'2026-09-03 15:21:00',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(114,1,1,'2026-09-03 15:21:38',0,'2026-09-03 15:22:30',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(115,1,1,'2026-09-03 15:28:20',0,'2026-09-03 15:29:16',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(116,1,1,'2026-09-03 15:30:23',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(117,1,1,'2026-09-03 15:35:20',0,'2026-09-03 15:37:43',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(118,1,1,'2026-08-26 15:19:08',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(119,1,1,'2026-08-26 16:04:16',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(120,1,1,'2026-08-27 13:32:31',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(121,1,1,'2026-08-27 13:35:56',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(122,1,1,'2026-08-27 13:42:24',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(123,1,1,'2026-08-27 13:48:52',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(124,1,1,'2026-08-27 13:55:28',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(125,1,1,'2026-08-27 13:57:59',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(126,1,1,'2026-08-27 13:59:54',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(127,1,1,'2026-08-27 14:02:43',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(128,1,1,'2026-09-03 15:55:12',300,'2026-09-03 16:00:14',0,550);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(129,1,1,'2026-09-03 15:57:43',0,'2026-09-03 15:58:23',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(130,1,1,'2026-09-03 16:01:34',0,'2026-09-03 16:02:56',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(131,1,1,'2026-09-03 16:06:38',0,'2026-09-03 16:06:45',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(132,1,1,'2026-09-03 16:08:03',0,'2026-09-03 16:08:12',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(133,1,1,'2026-09-03 16:10:52',30,'2026-09-03 16:11:22',0,50);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(134,1,1,'2026-09-03 16:17:26',30,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(135,1,1,'2026-09-03 16:24:47',30,'2026-09-03 16:25:26',0,30);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(136,1,1,'2026-09-03 16:28:53',30,'2026-09-03 16:31:49',0,30);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(137,1,1,'2026-09-03 16:37:27',30,'2026-09-03 16:38:23',0,30);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(138,1,1,'2026-09-03 16:42:41',30,'2026-09-03 16:44:10',0,30);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(139,1,1,'2026-09-03 16:47:50',30,'2026-09-03 16:49:56',0,30);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(140,1,1,'2026-09-03 16:50:36',30,'2026-09-03 16:50:56',0,30);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(141,1,1,'2026-09-03 16:56:11',30,'2026-09-03 16:57:02',0,3);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(142,1,1,'2026-09-03 17:01:10',30,'2026-09-03 17:01:51',0,30);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(143,1,1,'2026-09-04 13:36:36',0,NULL,1,NULL);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(144,1,1,'2026-09-04 13:38:16',0,'2026-09-04 13:39:06',0,0);
INSERT INTO "tb_sessao_caixa" ("id","id_caixa","id_usuario","data_abertura","valor_fundo_troco","data_fechamento","status","valor_fechamento") VALUES(145,1,1,'2026-09-04 13:39:10',30,'2026-09-04 13:41:44',0,3000);
CREATE TABLE tb_vendas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_sessao_caixa INTEGER,
    id_cliente INTEGER,
    data_hora DATETIME,
    subtotal DECIMAL(10,2),
    desconto DECIMAL(10,2),
    total DECIMAL(10,2),
    status VARCHAR(15) CHECK(status IN ('pago', 'cancelado', 'pendente')),
    chave_nfe VARCHAR(44), id_cupom varchar (25),
    FOREIGN KEY(id_sessao_caixa) REFERENCES tb_sessao_caixa(id),
    FOREIGN KEY(id_cliente) REFERENCES tb_clientes(id)
);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(1,1,1,'2026-08-25 10:00:00',149,0,149,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(2,1,NULL,'2026-08-25 10:15:00',780,0,780,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(3,1,2,'2026-08-25 11:30:00',54,0,54,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(4,1,NULL,'2026-08-25 22:01:36',50,15,35,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(5,1,NULL,'2026-08-25 22:04:01',50,15,35,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(6,1,NULL,'2026-08-25 22:11:16',300,0,300,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(7,1,NULL,'2026-08-25 22:17:51',150,0,150,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(8,1,NULL,'2026-08-25 22:19:05',150,0,150,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(9,1,NULL,'2026-08-25 22:22:41',1130,267.25,862.75,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(10,1,NULL,'2026-08-25 22:27:58',150,50,100,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(11,1,NULL,'2026-08-25 22:28:20',50,15,35,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(12,1,NULL,'2026-08-25 22:46:18',50,15,35,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(13,1,NULL,'2026-08-25 22:46:56',880,30,850,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(14,1,NULL,'2026-08-25 22:47:11',99,0,99,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(15,1,NULL,'2026-08-25 22:47:33',50,15,35,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(16,1,NULL,'2026-08-25 22:52:16',50,15,35,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(17,1,NULL,'2026-08-25 22:53:08',50,15,35,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(18,1,NULL,'2026-08-26 13:20:55',249,149.5,99.5,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(19,1,NULL,'2026-08-26 13:29:13',300,0,300,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(20,1,NULL,'2026-08-26 13:34:11',15,0,15,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(21,1,NULL,'2026-08-26 13:34:17',150,50,100,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(22,1,NULL,'2026-08-26 13:34:25',99,0,99,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(23,1,NULL,'2026-08-26 13:35:22',15,0,15,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(24,1,NULL,'2026-08-26 13:36:08',15,0,15,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(25,NULL,NULL,'2026-08-27 14:03:24',150,50,100,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(26,NULL,NULL,'2026-08-27 14:03:28',150,50,100,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(27,NULL,NULL,'2026-08-27 14:03:28',150,50,100,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(28,NULL,NULL,'2026-08-27 14:03:29',150,50,100,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(29,NULL,NULL,'2026-08-27 14:03:29',150,50,100,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(30,NULL,NULL,'2026-08-27 14:03:29',150,50,100,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(31,NULL,NULL,'2026-08-27 14:03:29',150,50,100,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(32,NULL,NULL,'2026-08-27 14:03:30',150,50,100,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(33,NULL,NULL,'2026-08-27 14:03:30',150,50,100,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(34,NULL,NULL,'2026-08-27 14:03:30',150,50,100,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(35,NULL,NULL,'2026-08-27 14:03:31',150,50,100,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(36,NULL,NULL,'2026-08-27 14:03:32',150,50,100,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(37,NULL,NULL,'2026-08-27 14:03:33',150,50,100,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(38,NULL,NULL,'2026-08-27 14:03:35',150,50,100,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(39,NULL,NULL,'2026-08-27 14:03:36',150,50,100,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(40,NULL,NULL,'2026-08-27 14:03:37',150,50,100,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(41,NULL,NULL,'2026-08-27 14:04:23',50,15,35,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(42,NULL,NULL,'2026-08-27 14:12:45',50,15,35,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(43,NULL,NULL,'2026-08-27 14:13:44',50,15,35,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(44,NULL,NULL,'2026-08-27 14:14:40',1610,1463,147,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(45,NULL,NULL,'2026-08-27 14:17:29',50,15,35,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(46,NULL,NULL,'2026-08-27 14:17:50',50,15,35,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(47,NULL,NULL,'2026-08-27 14:19:05',50,15,35,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(48,NULL,NULL,'2026-08-27 14:21:19',150,45,105,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(49,NULL,NULL,'2026-08-27 14:23:41',50,15,35,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(50,NULL,NULL,'2026-08-27 14:23:51',50,15,35,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(51,NULL,NULL,'2026-08-27 14:29:56',50,15,35,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(52,NULL,NULL,'2026-08-27 14:30:14',780,724,56,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(53,NULL,NULL,'2026-08-27 14:31:24',50,15,35,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(54,NULL,NULL,'2026-08-27 14:50:07',50,15,35,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(55,NULL,NULL,'2026-08-27 14:51:58',50,15,35,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(56,NULL,NULL,'2026-08-27 15:13:59',50,15,35,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(57,NULL,NULL,'2026-08-27 15:14:23',780,724,56,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(58,NULL,NULL,'2026-08-27 15:18:09',50,15,35,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(59,NULL,NULL,'2026-08-27 15:20:01',1304,839,465,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(60,NULL,NULL,'2026-08-27 15:24:12',50,0,50,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(61,NULL,NULL,'2026-08-27 15:26:33',50,0,50,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(62,NULL,NULL,'2026-08-27 15:27:42',50,0,50,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(63,NULL,NULL,'2026-08-27 15:28:21',50,0,50,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(64,NULL,NULL,'2026-08-27 15:28:52',50,0,50,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(65,NULL,NULL,'2026-08-27 15:29:18',50,0,50,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(66,NULL,NULL,'2026-08-27 15:31:11',50,0,50,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(67,NULL,NULL,'2026-08-27 15:55:37',2480,0,2480,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(68,NULL,NULL,'2026-08-27 15:56:05',2390,90,2300,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(69,NULL,NULL,'2026-08-27 15:56:23',1610,0,1610,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(70,NULL,NULL,'2026-08-27 15:59:11',1130,0,1130,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(71,NULL,NULL,'2026-08-27 16:07:10',2525,65,2460,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(72,NULL,NULL,'2026-08-27 16:26:20',50,0,50,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(73,NULL,NULL,'2026-08-27 16:27:30',50,0,50,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(74,73,NULL,'2026-08-27 16:35:02',750,0,750,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(75,74,NULL,'2026-08-27 16:41:34',75,25,50,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(76,75,NULL,'2026-08-27 16:42:13',60,20,40,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(77,75,NULL,'2026-08-27 16:42:26',150,50,100,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(78,76,NULL,'2026-08-27 16:54:30',50,0,50,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(79,78,NULL,'2026-08-27 22:18:42',300,0,300,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(80,78,NULL,'2026-08-27 22:21:53',150,0,150,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(81,79,NULL,'2026-08-27 22:26:30',59.7,0,59.7,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(82,79,NULL,'2026-08-27 22:27:58',50,0,50,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(83,80,NULL,'2026-08-27 22:39:20',1.99,0,1.99,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(84,81,NULL,'2026-08-27 22:43:31',50,0,50,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(85,82,NULL,'2026-08-27 22:44:26',1079,87,992,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(86,83,NULL,'2026-08-27 22:51:08',1310.99,97,1213.99,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(87,84,NULL,'2026-08-27 22:52:12',944,92,852,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(88,85,NULL,'2026-08-27 22:53:56',929,87,842,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(89,86,NULL,'2026-08-27 22:58:23',830,0,830,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(90,87,NULL,'2026-08-27 23:01:18',100.99,87,13.99,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(91,1,NULL,'2026-08-30 00:17:33',830,0,830,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(92,1,NULL,'2026-08-30 00:18:03',1610,0,1610,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(93,1,NULL,'2026-08-30 00:18:54',50,2.5,47.5,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(94,2,NULL,'2026-08-30 00:49:08',830,0,830,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(95,3,NULL,'2026-08-30 00:57:57',830,0,830,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(96,4,NULL,'2026-08-30 00:59:04',50,0,50,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(97,5,NULL,'2026-08-30 01:02:36',50,0,50,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(98,1,NULL,'2026-08-28 14:32:38',1329.99,174,1155.99,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(99,2,NULL,'2026-08-28 16:41:09',1095.99,142.1995,953.7905,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(100,3,NULL,'2026-08-30 00:22:18',830,0,830,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(101,1,NULL,'2026-08-30 01:11:59',50,0,50,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(102,2,NULL,'2026-08-30 01:16:12',50,0,50,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(103,3,NULL,'2026-08-31 10:39:27',830,0,830,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(104,5,NULL,'2026-08-31 18:22:21',250.99,95.1995,155.7905,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(105,3,NULL,'2026-08-31 20:38:58',2730.99,117,2613.99,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(106,4,NULL,'2026-09-01 14:04:50',50,0,50,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(107,1,NULL,'2026-09-01 14:13:53',830,500,330,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(108,5,NULL,'2026-09-01 16:03:03',830,30,800,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(109,6,NULL,'2026-09-02 14:26:53',50,0,50,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(110,2,NULL,'2026-09-02 16:32:45',15,0,15,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(111,2,NULL,'2026-09-03 14:04:36',550,250,300,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(112,1,NULL,'2026-09-03 14:28:50',50,0,50,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(113,2,NULL,'2026-09-03 14:43:26',99,87,12,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(114,3,NULL,'2026-09-03 14:54:58',50,0,50,'pago',NULL,'03092026145458467');
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(115,4,NULL,'2026-09-03 14:56:23',50,0,50,'pago',NULL,'03092026145623735');
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(116,5,NULL,'2026-09-03 15:21:44',50,0,50,'pago',NULL,'03092026152144514');
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(117,6,NULL,'2026-09-03 15:28:28',50,0,50,'pago',NULL,'2906908038');
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(118,7,NULL,'2026-09-03 15:30:27',50,0,50,'pago',NULL,'4');
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(119,8,NULL,'2026-09-03 15:35:25',50,0,50,'pago',NULL,'4017256');
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(120,8,NULL,'2026-09-03 15:37:19',50,0,50,'pago',NULL,'4018398');
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(121,9,NULL,'2026-09-03 15:57:54',50,0,50,'pago',NULL,'4030740');
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(122,10,NULL,'2026-09-03 16:01:39',780,0,780,'pago',NULL,'03092026160139513');
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(123,11,NULL,'2026-09-03 16:06:42',780,0,780,'pago',NULL,'260903160642');
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(124,11,NULL,'2026-09-03 16:06:42',780,0,780,'pago',NULL,'260903160642');
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(125,12,NULL,'2026-09-03 16:08:07',780,0,780,'pago',NULL,'26090316080791');
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(126,2,NULL,'2026-08-26 16:07:59',99,0,99,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(127,2,NULL,'2026-08-26 16:08:26',99,0,99,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(128,15,NULL,'2026-09-03 16:31:40',4756,951,3805,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(129,16,NULL,'2026-09-03 16:38:15',99,867,0,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(130,17,NULL,'2026-09-03 16:44:04',1683,2259,0,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(131,18,NULL,'2026-09-03 16:49:48',891,1563,0,'pago',NULL,NULL);
INSERT INTO "tb_vendas" ("id","id_sessao_caixa","id_cliente","data_hora","subtotal","desconto","total","status","chave_nfe","id_cupom") VALUES(132,13,NULL,'2026-09-04 13:36:41',50,0,50,'pago',NULL,'26090413364187');
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
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(78,78,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(79,79,'pix',300,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(80,80,'dinheiro',150,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(81,81,'cartão de crédito',59.7,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(82,82,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(83,83,'pix',1.99,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(84,84,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(85,85,'dinheiro',992,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(86,86,'dinheiro',1213.99,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(87,87,'dinheiro',852,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(88,88,'dinheiro',842,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(89,89,'dinheiro',830,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(90,90,'dinheiro',13.99,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(91,91,'dinheiro',830,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(92,92,'dinheiro',1610,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(93,93,'dinheiro',47.5,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(94,94,'dinheiro',830,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(95,95,'dinheiro',830,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(96,96,'pix',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(97,97,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(98,98,'dinheiro',1155.99,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(99,99,'cartão de débito',953.7905,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(100,100,'dinheiro',830,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(101,101,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(102,102,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(103,103,'dinheiro',830,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(104,104,'dinheiro',155.7905,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(105,105,'pix',2613.99,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(106,106,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(107,107,'pix',330,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(108,108,'dinheiro',800,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(109,109,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(110,110,'dinheiro',15,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(111,111,'pix',300,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(112,112,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(113,113,'dinheiro',12,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(114,114,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(115,115,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(116,116,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(117,117,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(118,118,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(119,119,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(120,120,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(121,121,'dinheiro',50,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(122,122,'dinheiro',780,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(123,123,'dinheiro',780,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(124,124,'dinheiro',780,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(125,125,'dinheiro',780,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(126,126,'pix',99,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(127,127,'dinheiro',99,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(128,128,'dinheiro',3805,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(129,129,'dinheiro',0,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(130,130,'dinheiro',0,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(131,131,'dinheiro',0,NULL);
INSERT INTO "tb_pagamentos" ("id","id_venda","metodo","valor","cod_autorizacao_tef") VALUES(132,132,'dinheiro',50,NULL);
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
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(97,78,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(98,79,6,2,150,300);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(99,80,6,1,150,150);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(100,81,9,30,1.99,59.7);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(101,82,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(102,83,9,1,1.99,1.99);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(103,84,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(104,85,2,1,780,780);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(105,85,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(106,85,3,1,99,12);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(107,85,6,1,150,150);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(108,86,1,2,50,100);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(109,86,3,1,99,12);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(110,86,6,2,150,300);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(111,86,7,2,15,20);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(112,86,9,1,1.99,1.99);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(113,86,2,1,780,780);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(114,87,7,1,15,10);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(115,87,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(116,87,2,1,780,780);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(117,87,3,1,99,12);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(118,88,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(119,88,3,1,99,12);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(120,88,2,1,780,780);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(121,89,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(122,89,2,1,780,780);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(123,90,3,1,99,12);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(124,90,9,1,1.99,1.99);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(125,91,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(126,91,2,1,780,780);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(127,92,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(128,92,2,2,780,1560);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(129,93,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(130,94,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(131,94,2,1,780,780);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(132,95,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(133,95,2,1,780,780);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(134,96,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(135,97,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(136,98,3,2,99,24);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(137,98,9,1,1.99,1.99);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(138,98,6,2,150,300);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(139,98,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(140,98,2,1,780,780);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(141,99,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(142,99,3,1,99,12);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(143,99,6,1,150,150);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(144,99,9,1,1.99,1.99);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(145,99,7,1,15,10);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(146,99,2,1,780,780);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(147,100,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(148,100,2,1,780,780);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(149,101,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(150,102,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(151,103,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(152,103,2,1,780,780);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(153,104,3,1,99,12);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(154,104,9,1,1.99,1.99);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(155,104,6,1,150,150);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(156,105,2,3,780,2340);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(157,105,9,1,1.99,1.99);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(158,105,7,6,15,60);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(159,105,6,1,150,150);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(160,105,3,1,99,12);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(161,105,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(162,106,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(163,107,2,1,780,780);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(164,107,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(165,108,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(166,108,2,1,780,780);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(167,109,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(168,110,26,1,15,15);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(169,111,57,1,550,300);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(170,112,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(171,113,3,1,99,12);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(172,114,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(173,115,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(174,116,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(175,117,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(176,118,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(177,119,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(178,120,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(179,121,1,1,50,50);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(180,122,2,1,780,780);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(181,123,2,1,780,780);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(182,124,2,1,780,780);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(183,125,2,1,780,780);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(184,126,3,1,99,99);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(185,127,3,1,99,99);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(186,128,3,1,99,12);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(187,128,12,1,4657,4573);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(188,129,3,1,99,12);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(189,130,3,17,99,204);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(190,131,3,9,99,108);
INSERT INTO "tb_itens_venda" ("id","id_venda","id_produto","quantidade","preco_unitario","subtotal") VALUES(191,132,1,1,50,50);
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
INSERT INTO "tb_funcionarios" ("id","id_usuario","nome_completo","data_nascimento","genero","raca","estado_civil","nacionalidade","naturalidade","cpf","orgao_emissor","email","telefone","contato_emergencia","pcd","escolaridade","formacao_academica","logradouro","numero","bairro","cidade","cep","complemento","status") VALUES(1,NULL,'Sarah Artuso','2009-11-29',2,1,2,'Brasileira','Carlos Barbosa','12345678901','SSP/RS','larissagazoli45@gmail.com','54999999999','54988888888',1,3,'Administração de Empresas','Rua Buarque de Macedo',100,'Centro','Carlos Barbosa','95123000','Apto 101',1);
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
INSERT INTO "tb_funcionarios_complemento" ("id","id_funcionario","data_admissao","tipo","cargo","nivel_senioridade","setor","gestor","tempo_empregado","modelo_trabalho","escala_trabalho","salario_base","tipo_remuneracao","banco","agencia","chave_pix","centro_custo","data_demissao","tipo_demissao","motivo_demissao") VALUES(NULL,NULL,'2026-09-01',1,'Diretor Geral',1,'Diretoria',NULL,'3 anos',1,3,50,1,'Itaú',1234,'12345678901','CC-01','2026-09-02',2,'Porque eu quis');
INSERT INTO "tb_funcionarios_complemento" ("id","id_funcionario","data_admissao","tipo","cargo","nivel_senioridade","setor","gestor","tempo_empregado","modelo_trabalho","escala_trabalho","salario_base","tipo_remuneracao","banco","agencia","chave_pix","centro_custo","data_demissao","tipo_demissao","motivo_demissao") VALUES(NULL,NULL,'2026-09-01',1,'Diretor Geral',1,'Diretoria',NULL,'3 anos',1,3,50,1,'Itaú',1234,'12345678901','CC-01','2026-09-02',2,'Porque eu quis');
INSERT INTO "tb_funcionarios_complemento" ("id","id_funcionario","data_admissao","tipo","cargo","nivel_senioridade","setor","gestor","tempo_empregado","modelo_trabalho","escala_trabalho","salario_base","tipo_remuneracao","banco","agencia","chave_pix","centro_custo","data_demissao","tipo_demissao","motivo_demissao") VALUES(NULL,1,'2026-09-01',1,'Diretor Geral',1,'Diretoria',NULL,'3 anos',1,1,5000,1,'Itaú',1234,'12345678901','CC-01','2026-09-02',2,'Porque eu quis');
CREATE TABLE tb_versao (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    versao VARCHAR(20),
    link_download VARCHAR(255),
    data_lancamento DATETIME DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO "tb_versao" ("id","versao","link_download","data_lancamento") VALUES(1,'0.8.0','https://drive.google.com/uc?export=download&id=1uGEIReJgsNaODo7F7xOS0cM-XN05WAam','2026-08-28 02:23:48');
INSERT INTO "tb_versao" ("id","versao","link_download","data_lancamento") VALUES(2,'0.9.0','https://drive.google.com/uc?export=download&id=1CKrjpB4Gzr-cr6lmphm8ZDPUhpkVZQao','2026-08-28 02:36:58');
INSERT INTO "tb_versao" ("id","versao","link_download","data_lancamento") VALUES(3,'0.9.1','https://drive.google.com/uc?export=download&id=1cU8vmyiUPfjRGjVi2tCC4LfietLU5Nsc','2026-08-28 03:04:19');
INSERT INTO "tb_versao" ("id","versao","link_download","data_lancamento") VALUES(4,'0.9.5','https://drive.google.com/uc?export=download&id=12LEtArBu15sU1vwkjgQthuNn4ixZoLQ_','2026-08-28 03:29:01');
INSERT INTO "tb_versao" ("id","versao","link_download","data_lancamento") VALUES(5,'0.9.7','https://drive.google.com/uc?export=download&id=1TiWs6Z_AcjFlv4vCZnIL2HYE3gxXGOWV','2026-08-30 03:21:49');
INSERT INTO "tb_versao" ("id","versao","link_download","data_lancamento") VALUES(6,'0.9.8','https://drive.google.com/uc?export=download&id=1nhynF-KjpIjTmOJUaPAJCScRYD2GTTFS','2026-08-30 04:19:40');
INSERT INTO "tb_versao" ("id","versao","link_download","data_lancamento") VALUES(7,'1.0.0','https://drive.google.com/uc?export=download&id=1bpPdsXQfH9jRYdQ5gCDy_zmAMvxOP28c','2026-08-31 13:46:41');
INSERT INTO "tb_versao" ("id","versao","link_download","data_lancamento") VALUES(8,'1.0.1','https://drive.google.com/uc?export=download&id=1F9fZ1WfMOMdLU3sTYI4CiLjkK7vQy726','2026-08-31 21:13:34');
INSERT INTO "tb_versao" ("id","versao","link_download","data_lancamento") VALUES(9,'1.0.3','https://drive.google.com/uc?export=download&id=1x-Lt1EJInjnOQHUoERqpqvQsYHSzDyuf','2026-09-02 20:10:46');
INSERT INTO "tb_versao" ("id","versao","link_download","data_lancamento") VALUES(10,'1.1','https://drive.google.com/uc?export=download&id=1JwXnziDAdDnMd1y7KuCBsOA6nAowmZ23','2026-09-03 00:31:07');
CREATE TABLE tb_trocas (
    id_troca INTEGER PRIMARY KEY AUTOINCREMENT,
    tipo_troca VARCHAR(15) CHECK(tipo_troca IN ('troca', 'devolucao')),
    data_troca DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_vendedor INTEGER,
    produto_retornado VARCHAR(20),
    quantidade DECIMAL(10,3),
    FOREIGN KEY(produto_retornado) REFERENCES tb_produtos(codigo_barras) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(id_vendedor) REFERENCES tb_usuarios(id)
);
INSERT INTO "tb_trocas" ("id_troca","tipo_troca","data_troca","id_vendedor","produto_retornado","quantidade") VALUES(1,'troca','2026-09-03 19:42:59',1,'987654321',1);
INSERT INTO "tb_trocas" ("id_troca","tipo_troca","data_troca","id_vendedor","produto_retornado","quantidade") VALUES(2,'troca','2026-09-03 19:48:00',1,'987654321',1);
INSERT INTO "tb_trocas" ("id_troca","tipo_troca","data_troca","id_vendedor","produto_retornado","quantidade") VALUES(3,'troca','2026-09-03 19:56:21',1,'987654321',1);
INSERT INTO "tb_trocas" ("id_troca","tipo_troca","data_troca","id_vendedor","produto_retornado","quantidade") VALUES(4,'troca','2026-09-03 20:01:21',1,'987654321',1);
DELETE FROM sqlite_sequence;
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_filiais',1);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_usuarios',6);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_clientes',2);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_fornecedores',1);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_caixa',1);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_produtos',60);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_sessao_caixa',145);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_vendas',132);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_itens_venda',191);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_pagamentos',132);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_versao',10);
INSERT INTO "sqlite_sequence" ("name","seq") VALUES('tb_trocas',4);
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
