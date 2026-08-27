export default {
    async fetch(request, env) {
        const url = new URL(request.url);
        const path = url.pathname; // Adicionado para garantir o funcionamento das rotas abaixo
        const method = request.method;

        // Cabeçalhos de segurança (CORS) obrigatórios para navegadores web
        const corsHeaders = {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
            "Access-Control-Allow-Headers": "Content-Type"
        };

        // Responde ao "preflight" do navegador
        if (method === "OPTIONS") {
            return new Response(null, { headers: corsHeaders });
        }

        // =====================================================================
        // ROTAS DO APP (C# - PDV)
        // =====================================================================
        if (path === "/api/app/produtos") {
            const { results } = await env.DB.prepare("SELECT * FROM tb_produtos").all();
            return new Response(JSON.stringify(results), { headers: corsHeaders });
        }
        if (path === "/api/app/login" && method === "POST") {
            try {
                const body = await request.json();
                const stmt = env.DB.prepare("SELECT id, nome, nivel_acesso FROM tb_usuarios WHERE nome = ? AND senha = ?");
                const { results } = await stmt.bind(body.nome, body.senha).all();

                if (results.length > 0) {
                    return new Response(JSON.stringify({ sucesso: true, usuario: results[0] }), { status: 200, headers: corsHeaders });
                } else {
                    return new Response(JSON.stringify({ sucesso: false, erro: "Usuário ou senha incorretos!" }), { status: 401, headers: corsHeaders });
                }
            } catch (error) {
                return new Response(JSON.stringify({ sucesso: false, erro: "Erro no servidor." }), { status: 500, headers: corsHeaders });
            }
        }
        if (path === "/api/app/vendas" && method === "POST") {
            try {
                const body = await request.json();
                const stmts = [];

                // 1. Grava a Venda (com o MESMO ID que foi gerado no C# local)
                stmts.push(env.DB.prepare(`
                    INSERT INTO tb_vendas (id, id_sessao_caixa, id_cliente, data_hora, subtotal, desconto, total, status)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                `).bind(body.id, body.id_sessao_caixa, body.id_cliente, body.data_hora, body.subtotal, body.desconto, body.total, body.status));

                // 2. Grava os Itens e DÁ BAIXA NO ESTOQUE DA NUVEM
                for (const item of body.itens) {
                    stmts.push(env.DB.prepare(`
                        INSERT INTO tb_itens_venda (id_venda, id_produto, quantidade, preco_unitario, subtotal)
                        VALUES (?, ?, ?, ?, ?)
                    `).bind(body.id, item.id_produto, item.quantidade, item.preco_unitario, item.subtotal));

                    // Abate a quantidade vendida do estoque atual
                    stmts.push(env.DB.prepare(`
                        UPDATE tb_produtos SET quantidade = quantidade - ? WHERE id = ?
                    `).bind(item.quantidade, item.id_produto));
                }

                // 3. Grava o Pagamento
                for (const pag of body.pagamentos) {
                    stmts.push(env.DB.prepare(`
                        INSERT INTO tb_pagamentos (id_venda, metodo, valor)
                        VALUES (?, ?, ?)
                    `).bind(body.id, pag.metodo, pag.valor));
                }

                // Dispara todas as queries de uma vez só no banco do Cloudflare (Transação segura)
                await env.DB.batch(stmts);

                return new Response(JSON.stringify({ sucesso: true }), { status: 201, headers: corsHeaders });
            } catch (error) {
                return new Response(JSON.stringify({ erro: "Erro ao sincronizar venda na nuvem.", detalhe: error.message }), { status: 500, headers: corsHeaders });
            }
        }
        if (path === "/api/app/sessoes" && method === "POST") {
            try {
                const body = await request.json();
                const stmts = [];
                for (const s of body) {
                    stmts.push(env.DB.prepare(`
                        INSERT INTO tb_sessao_caixa (id, id_caixa, id_usuario, data_abertura, valor_fundo_troco, data_fechamento, status, valor_fechamento)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                        ON CONFLICT(id) DO UPDATE SET 
                            data_fechamento = excluded.data_fechamento, 
                            status = excluded.status, 
                            valor_fechamento = excluded.valor_fechamento
                    `).bind(s.id, s.id_caixa, s.id_usuario, s.data_abertura, s.valor_fundo_troco, s.data_fechamento, s.status, s.valor_fechamento));
                }
                await env.DB.batch(stmts);
                return new Response(JSON.stringify({ sucesso: true }), { status: 200, headers: corsHeaders });
            } catch (error) {
                return new Response(JSON.stringify({ erro: "Erro ao sincronizar sessões.", detalhe: error.message }), { status: 500, headers: corsHeaders });
            }
        }

        // =====================================================================
        // ROTAS DA WEB (HTML/CSS/JS - Gerenciamento)
        // =====================================================================

        // Rota: Login
        if (path === "/api/web/login" && method === "POST") {
            try {
                const body = await request.json();
                const stmt = env.DB.prepare("SELECT id, nome, nivel_acesso FROM tb_usuarios WHERE nome = ? AND senha = ?");
                const { results } = await stmt.bind(body.nome, body.senha).all();

                if (results.length > 0) {
                    return new Response(JSON.stringify({ sucesso: true, usuario: results[0] }), { status: 200, headers: corsHeaders });
                } else {
                    return new Response(JSON.stringify({ sucesso: false, erro: "Usuário ou senha incorretos!" }), { status: 401, headers: corsHeaders });
                }
            } catch (error) {
                return new Response(JSON.stringify({ sucesso: false, erro: "Erro no servidor." }), { status: 500, headers: corsHeaders });
            }
        }

        // Rota: Dados e Resumos para o Dashboard
        if (path === "/api/web/dashboard" && method === "GET") {
            try {
                const sqlVendasHoje = `SELECT COALESCE(SUM(total), 0) AS total_vendas, COUNT(id) AS total_atendimentos FROM tb_vendas WHERE status = 'pago' AND DATE(data_hora) = DATE('now')`;
                const { results: resVendas } = await env.DB.prepare(sqlVendasHoje).all();
                const vendas = resVendas[0] || { total_vendas: 0, total_atendimentos: 0 };

                const sqlAlertas = `SELECT COUNT(id) AS total_alertas FROM tb_produtos WHERE quantidade <= quantidade_minima`;
                const { results: resAlertas } = await env.DB.prepare(sqlAlertas).all();
                const alertas = resAlertas[0] || { total_alertas: 0 };

                return new Response(JSON.stringify({ vendasHoje: vendas.total_vendas, atendimentosHoje: vendas.total_atendimentos, alertasEstoque: alertas.total_alertas }), { status: 200, headers: corsHeaders });
            } catch (error) {
                return new Response(JSON.stringify({ erro: "Erro ao consultar métricas do dashboard." }), { status: 500, headers: corsHeaders });
            }
        }

        // Rota: Listar Produtos
        if (path === "/api/web/produtos" && method === "GET") {
            try {
                const { results } = await env.DB.prepare("SELECT * FROM tb_produtos").all();
                return new Response(JSON.stringify(results), { status: 200, headers: corsHeaders });
            } catch (error) {
                return new Response(JSON.stringify({ erro: "Erro ao carregar produtos." }), { status: 500, headers: corsHeaders });
            }
        }

        // Rota: Gráficos do Dashboard
        if (path === "/api/web/graficos" && method === "GET") {
            try {
                const { results: resFat } = await env.DB.prepare(`SELECT DATE(data_hora) as data, SUM(total) as valor FROM tb_vendas WHERE status = 'pago' GROUP BY DATE(data_hora) ORDER BY data DESC LIMIT 7`).all();
                const { results: resPag } = await env.DB.prepare(`SELECT metodo, SUM(valor) as total FROM tb_pagamentos GROUP BY metodo`).all();
                const { results: resProd } = await env.DB.prepare(`SELECT p.nome, SUM(i.quantidade) as qtd FROM tb_itens_venda i JOIN tb_produtos p ON i.id_produto = p.id GROUP BY p.id ORDER BY qtd DESC LIMIT 5`).all();
                const { results: resFilial } = await env.DB.prepare(`SELECT f.nome_fantasia as nome, SUM(v.total) as valor FROM tb_vendas v JOIN tb_sessao_caixa s ON v.id_sessao_caixa = s.id JOIN tb_caixa c ON s.id_caixa = c.id JOIN tb_filiais f ON c.id_filial = f.id WHERE v.status = 'pago' GROUP BY f.id`).all();

                return new Response(JSON.stringify({ faturamento: resFat, pagamentos: resPag, produtos: resProd, filiais: resFilial }), { status: 200, headers: corsHeaders });
            } catch (error) {
                return new Response(JSON.stringify({ erro: "Erro ao gerar gráficos." }), { status: 500, headers: corsHeaders });
            }
        }

        // =====================================================================
        // ROTAS DE RELATÓRIOS (RADAR E GIRO)
        // =====================================================================

        else if (method === "GET" && path === "/relatorios/giro") {
            try {
                const query = `
            SELECT p.id, p.nome, p.unidade_venda, p.quantidade as estoque_atual,
            COALESCE(SUM(iv.quantidade), 0) as volume_mes
            FROM tb_produtos p
            LEFT JOIN tb_itens_venda iv ON p.id = iv.id_produto
            LEFT JOIN tb_vendas v ON iv.id_venda = v.id 
                AND v.data_hora >= datetime('now', '-30 days') 
                AND v.status = 'pago'
            GROUP BY p.id 
            ORDER BY volume_mes DESC
        `;
                const res = await env.DB.prepare(query).all();
                return new Response(JSON.stringify(res.results), { headers: corsHeaders });
            } catch (e) {
                return new Response(JSON.stringify({ erro: e.message }), { status: 500, headers: corsHeaders });
            }
        }

        else if (method === "GET" && path === "/relatorios/encalhados") {
            try {
                const query = `
            SELECT p.nome, p.quantidade, MAX(v.data_hora) as ultima_venda
            FROM tb_produtos p
            LEFT JOIN tb_itens_venda iv ON p.id = iv.id_produto
            LEFT JOIN tb_vendas v ON iv.id_venda = v.id AND v.status = 'pago'
            GROUP BY p.id
            HAVING ultima_venda IS NULL OR ultima_venda <= datetime('now', '-45 days')
        `;
                const res = await env.DB.prepare(query).all();
                return new Response(JSON.stringify(res.results), { headers: corsHeaders });
            } catch (e) {
                return new Response(JSON.stringify({ erro: e.message }), { status: 500, headers: corsHeaders });
            }
        }

        else if (method === "GET" && path === "/relatorios/trocas") {
            try {
                const query = `
            SELECT p.nome, iv.quantidade, v.data_hora, v.status 
            FROM tb_itens_venda iv
            JOIN tb_vendas v ON iv.id_venda = v.id
            JOIN tb_produtos p ON iv.id_produto = p.id
            WHERE v.status = 'cancelado' 
            ORDER BY v.data_hora DESC
        `;
                const res = await env.DB.prepare(query).all();
                return new Response(JSON.stringify(res.results), { headers: corsHeaders });
            } catch (e) {
                return new Response(JSON.stringify({ erro: e.message }), { status: 500, headers: corsHeaders });
            }
        }

        // 🌟 ROTA REFEITA: ESTOQUE DESEQUILIBRADO
        else if (method === "GET" && path === "/relatorios/desequilibrados") {
            try {
                // Agora usamos o campo 'quantidade_minima' que já existe no seu banco de dados
                // Mapeamos para ficar perfeitamente compatível com o seu frontend atual
                const query = `
            SELECT nome, quantidade, quantidade_minima
            FROM tb_produtos
            WHERE quantidade <= (quantidade_minima / 3) 
               OR quantidade >= (quantidade_minima * 2)
        `;
                const { results } = await env.DB.prepare(query).all();

                const desequilibrados = results.map(item => {
                    const quant = item.quantidade || 0;
                    const min = item.quantidade_minima || 10;
                    const isExcesso = quant >= (min * 2);

                    return {
                        nome: item.nome,
                        quantidade: quant,
                        media: min, // Mantivemos a chave "media" para o seu PHP não quebrar
                        acao: isExcesso ? 'Promoção (Excesso)' : 'Repor (Escassez)',
                        cor: isExcesso ? 'alerta' : 'alerta-baixo'
                    };
                });

                return new Response(JSON.stringify(desequilibrados), { status: 200, headers: corsHeaders });
            } catch (e) {
                return new Response(JSON.stringify({ erro: e.message }), { status: 500, headers: corsHeaders });
            }
        }


        // 🌟 NOVA ROTA: DESEMPENHO E VENDAS DETALHADAS (Período ajustável)
        else if (method === "GET" && path.startsWith("/relatorios/desempenho")) {
            try {
                const url = new URL(request.url);

                // Pega as datas da URL. Se não vierem, pega os últimos 30 dias por padrão.
                const hoje = new Date();
                const trintaDiasAtras = new Date(hoje);
                trintaDiasAtras.setDate(hoje.getDate() - 30);

                const inicio = url.searchParams.get("inicio") || trintaDiasAtras.toISOString().split('T')[0];
                const fim = url.searchParams.get("fim") || hoje.toISOString().split('T')[0];

                // 1. Consulta para o Gráfico (Faturamento Agrupado por Dia)
                const queryGrafico = `
            SELECT date(data_hora) as data_venda, SUM(total) as faturamento_diario
            FROM tb_vendas
            WHERE status = 'pago' AND date(data_hora) BETWEEN date(?) AND date(?)
            GROUP BY date(data_hora)
            ORDER BY data_venda ASC
        `;
                const resGrafico = await env.DB.prepare(queryGrafico).bind(inicio, fim).all();

                // 2. Consulta Detalhada (Agrupando todos os produtos da mesma venda em uma única linha)
                const queryDetalhes = `
            SELECT 
                v.id as id_venda,
                v.data_hora,
                v.subtotal as venda_subtotal,
                v.total as venda_total,
                u.nome as vendedor,
                GROUP_CONCAT(CAST(iv.quantidade AS INTEGER) || 'x ' || p.nome, ' | ') as produtos_comprados
            FROM tb_vendas v
            LEFT JOIN tb_sessao_caixa sc ON v.id_sessao_caixa = sc.id
            LEFT JOIN tb_usuarios u ON sc.id_usuario = u.id
            JOIN tb_itens_venda iv ON v.id = iv.id_venda
            JOIN tb_produtos p ON iv.id_produto = p.id
            WHERE v.status = 'pago' AND date(v.data_hora) BETWEEN date(?) AND date(?)
            GROUP BY v.id
            ORDER BY v.data_hora DESC
        `;
                const resDetalhes = await env.DB.prepare(queryDetalhes).bind(inicio, fim).all();

                return new Response(JSON.stringify({
                    grafico: resGrafico.results,
                    detalhes: resDetalhes.results,
                    periodo: { inicio, fim }
                }), { status: 200, headers: corsHeaders });

            } catch (e) {
                return new Response(JSON.stringify({ erro: e.message }), { status: 500, headers: corsHeaders });
            }
        }

        if (request.method === "GET" && path === "/api/nfe/pendentes") {
            try {
                // Busca os IDs das vendas que ainda não tem chave de NFe gerada
                const { results } = await env.DB.prepare(
                    "SELECT id FROM tb_vendas WHERE chave_nfe IS NULL ORDER BY id ASC"
                ).all();
                return new Response(JSON.stringify(results), { headers: corsHeaders });
            } catch (e) {
                return new Response(JSON.stringify({ error: e.message }), { status: 500, headers: corsHeaders });
            }
        }

        // ==========================================
        // ROTA 2: DADOS COMPLETOS DA VENDA (GET)
        // ==========================================
        const matchVenda = path.match(/\/api\/nfe\/venda\/(\d+)/);

        if (request.method === "GET" && matchVenda) {
            const idVenda = matchVenda[1];

            try {
                // 1. Busca os dados da Venda + Cliente
                const queryVenda = `
          SELECT 
            v.id as id_pedido, v.total as total_final, v.subtotal as total_produtos, v.desconto as total_frete,
            c.cpf_cnpj as cpf, c.nome as cliente_nome, c.logradouro, c.numero, c.bairro, c.cidade, c.uf, c.cod_mun_ibge, c.cep
          FROM tb_vendas v
          LEFT JOIN tb_clientes c ON v.id_cliente = c.id
          WHERE v.id = ?
        `;
                const venda = await env.DB.prepare(queryVenda).bind(idVenda).first();

                if (!venda) {
                    return new Response(JSON.stringify({ error: "Venda não encontrada" }), { status: 404, headers: corsHeaders });
                }

                // 2. Busca os dados do Emitente (Filial amarrada a esta venda específica)
                const queryEmitente = `
          SELECT 
            f.cnpj, f.nome_juridico as razao_social, f.inscricao_estadual as ie_emitente, f.crt as regime_tributario
          FROM tb_vendas v
          JOIN tb_sessao_caixa sc ON v.id_sessao_caixa = sc.id
          JOIN tb_caixa cx ON sc.id_caixa = cx.id
          JOIN tb_filiais f ON cx.id_filial = f.id
          WHERE v.id = ?
        `;
                const emitente = await env.DB.prepare(queryEmitente).bind(idVenda).first();

                // 3. Busca os Itens da Venda
                const queryItens = `
          SELECT 
            i.id_produto as produto_id, p.nome as nome_produto, i.quantidade, i.preco_unitario, i.subtotal,
            p.ncm, p.cest
          FROM tb_itens_venda i
          JOIN tb_produtos p ON i.id_produto = p.id
          WHERE i.id_venda = ?
        `;
                const itens = await env.DB.prepare(queryItens).bind(idVenda).all();

                // 4. Monta a resposta mantendo os mesmos nomes que o seu C# já usa
                const resposta = {
                    pedido: venda,
                    emitente: emitente,
                    itens: itens.results
                };

                return new Response(JSON.stringify(resposta), { headers: corsHeaders });

            } catch (e) {
                return new Response(JSON.stringify({ error: e.message }), { status: 500, headers: corsHeaders });
            }
        }



        // ==========================================
        // ROTAS DE MANIPULAÇÃO DE PRODUTOS (POST, PUT, DELETE)
        // ==========================================

        if (path === "/api/web/produtos" && method === "POST") {
            try {
                const body = await request.json();
                const stmt = env.DB.prepare(`
          INSERT INTO tb_produtos (
            nome, codigo_barras, preco_venda, quantidade, quantidade_minima, unidade_venda,
            custo, cest, aliquotas_imposto, ncm, valor_promocional, em_promocao, lote, validade, id_filial
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `);
                await stmt.bind(
                    body.nome, body.codigo_barras, body.preco_venda, body.quantidade, body.quantidade_minima, body.unidade_venda,
                    body.custo, body.cest, body.aliquotas_imposto, body.ncm, body.valor_promocional, body.em_promocao, body.lote, body.validade, 1
                ).run();

                return new Response(JSON.stringify({ sucesso: true }), { status: 201, headers: corsHeaders });
            } catch (error) {
                return new Response(JSON.stringify({ erro: "Erro ao adicionar.", detalhe: error.message }), { status: 500, headers: corsHeaders });
            }
        }

        if (path.startsWith("/api/web/produtos/") && method === "PUT") {
            try {
                const id = path.split('/').pop();
                const body = await request.json();

                const stmt = env.DB.prepare(`
          UPDATE tb_produtos 
          SET nome = ?, codigo_barras = ?, preco_venda = ?, quantidade = ?, quantidade_minima = ?, unidade_venda = ?,
              custo = ?, cest = ?, aliquotas_imposto = ?, ncm = ?, valor_promocional = ?, em_promocao = ?, lote = ?, validade = ?
          WHERE id = ?
        `);
                await stmt.bind(
                    body.nome, body.codigo_barras, body.preco_venda, body.quantidade, body.quantidade_minima, body.unidade_venda,
                    body.custo, body.cest, body.aliquotas_imposto, body.ncm, body.valor_promocional, body.em_promocao, body.lote, body.validade, id
                ).run();

                return new Response(JSON.stringify({ sucesso: true }), { status: 200, headers: corsHeaders });
            } catch (error) {
                return new Response(JSON.stringify({ erro: "Erro ao atualizar." }), { status: 500, headers: corsHeaders });
            }
        }

        if (path.startsWith("/api/web/produtos/") && method === "DELETE") {
            try {
                const id = path.split('/').pop();
                await env.DB.prepare("DELETE FROM tb_produtos WHERE id = ?").bind(id).run();
                return new Response(JSON.stringify({ sucesso: true }), { status: 200, headers: corsHeaders });
            } catch (error) {
                return new Response(JSON.stringify({ erro: "Erro ao excluir." }), { status: 500, headers: corsHeaders });
            }
        }

        // Retorno padrão caso a URL acessada não exista na API
        return new Response("Rota não encontrada", { status: 404, headers: corsHeaders });
    }
};