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
                const stmt = env.DB.prepare("SELECT id, nome FROM tb_usuarios WHERE nome = ? AND senha = ?");
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
            LEFT JOIN tb_vendas v ON iv.id_venda = v.id AND v.data_hora >= date('now', '-30 days') AND v.status = 'pago'
            GROUP BY p.id ORDER BY volume_mes DESC
        `;
                const res = await env.DB.prepare(query).all();
                return new Response(JSON.stringify(res.results), { headers: corsHeaders });
            } catch (e) { return new Response(JSON.stringify({ erro: e.message }), { status: 500, headers: corsHeaders }); }
        }

        else if (method === "GET" && path === "/relatorios/encalhados") {
            try {
                const query = `
            SELECT p.nome, p.quantidade, MAX(v.data_hora) as ultima_venda
            FROM tb_produtos p
            LEFT JOIN tb_itens_venda iv ON p.id = iv.id_produto
            LEFT JOIN tb_vendas v ON iv.id_venda = v.id AND v.status = 'pago'
            GROUP BY p.id
            HAVING ultima_venda IS NULL OR ultima_venda <= date('now', '-45 days')
        `;
                const res = await env.DB.prepare(query).all();
                return new Response(JSON.stringify(res.results), { headers: corsHeaders });
            } catch (e) { return new Response(JSON.stringify({ erro: e.message }), { status: 500, headers: corsHeaders }); }
        }

        else if (method === "GET" && path === "/relatorios/trocas") {
            try {
                const query = `
            SELECT p.nome, iv.quantidade, v.data_hora, v.status 
            FROM tb_itens_venda iv
            JOIN tb_vendas v ON iv.id_venda = v.id
            JOIN tb_produtos p ON iv.id_produto = p.id
            WHERE v.status = 'cancelado' ORDER BY v.data_hora DESC
        `;
                const res = await env.DB.prepare(query).all();
                return new Response(JSON.stringify(res.results), { headers: corsHeaders });
            } catch (e) { return new Response(JSON.stringify({ erro: e.message }), { status: 500, headers: corsHeaders }); }
        }

        // 🌟 NOVA ROTA: ESTOQUE DESEQUILIBRADO
        else if (method === "GET" && path === "/relatorios/desequilibrados") {
            try {
                const { results } = await env.DB.prepare("SELECT * FROM tb_produtos").all();

                const grupos = {};

                // Agrupa os itens e soma a quantidade
                results.forEach(p => {
                    const nomeBase = (p.nome || '').trim().toLowerCase();
                    if (!grupos[nomeBase]) {
                        grupos[nomeBase] = { total: 0, count: 0, itens: [] };
                    }
                    grupos[nomeBase].total += p.quantidade || 0;
                    grupos[nomeBase].count += 1;
                    grupos[nomeBase].itens.push(p);
                });

                const desequilibrados = [];

                for (const nomeBase in grupos) {
                    const grupo = grupos[nomeBase];
                    const media = grupo.count > 0 ? (grupo.total / grupo.count) : 0;

                    grupo.itens.forEach(item => {
                        const quant = item.quantidade || 0;

                        // 1. PENEIRA CRÍTICA: Se for menor/igual a um terço OU maior/igual ao dobro
                        if (quant <= (media / 3) || quant >= (media * 2)) {
                            desequilibrados.push({
                                nome: item.nome,
                                quantidade: quant,
                                media: Number(media.toFixed(1)),
                                acao: (quant >= (media * 2)) ? 'Promoção (Excesso)' : 'Repor (Escassez)',
                                cor: (quant >= (media * 2)) ? 'alerta' : 'alerta-baixo'
                            });
                        }
                        // (Opcional: O sistema web só precisa dos desequilibrados, então ignoramos o resto)
                    });
                }

                return new Response(JSON.stringify(desequilibrados), { status: 200, headers: corsHeaders });
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