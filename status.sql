--INCLUSÃO DE PEDIDO DE VENDA

SELECT C5_NUM PEDIDO, C5_CLIENTE COD_CLIENTE, C5_LOJACLI, C5_TRANSP COD_TRANSP, C5_EMISSAO DATA_EMISSAO, C5_TPFRETE TIPO_FRETE, C5_FECENT DATA_PREV_ENTREGA, C5_X_DTECL DATA_COMB_CLI_ENTREGA, A1_NOME RAZAO_SOCIAL, A1_PESSOA TIPO_PESSOA,
              A1_CGC CPF_CNPJ
FROM SC5010 C5 (NOLOCK)
          INNER JOIN SA1010 A1 (NOLOCK)
         ON C5_CLIENTE = A1_COD
         AND C5_LOJACLI = A1_LOJA
        AND A1.D_E_L_E_T_ <> '*'
WHERE C5.D_E_L_E_T_ <> '*'

AND A1_CGC = ''
AND C5_NUM = ''



--SE TIVER BOLETO E O PEDIDO AINDA NÃO FOI LIBERADO DE NADA

SELECT C5_NUM PEDIDO, C5_CLIENTE COD_CLIENTE, C5_LOJACLI, C5_TRANSP COD_TRANSP, C5_EMISSAO DATA_EMISSAO, C5_TPFRETE TIPO_FRETE, C5_FECENT DATA_PREV_ENTREGA, C5_X_DTECL DATA_COMB_CLI_ENTREGA, A1_NOME RAZAO_SOCIAL, A1_PESSOA TIPO_PESSOA,
              A1_CGC CPF_CNPJ, c5.*
FROM SC5010 C5 (NOLOCK)
          INNER JOIN SA1010 A1 (NOLOCK)
         ON C5_CLIENTE = A1_COD
         AND C5_LOJACLI = A1_LOJA
        AND A1.D_E_L_E_T_ <> '*'
WHERE C5.D_E_L_E_T_ <> '*'

AND (C5_X_FORM1='BOL' OR C5_X_FORM2='BOL' OR C5_X_FORM3='BOL' OR C5_X_FORM4='BOL')

AND A1_CGC = ''
AND C5_NUM = ''


[9:20 AM, 3/24/2020] camila lopes: ABELA SE1010 É a tabela do contas a receber
[9:20 AM, 3/24/2020] camila lopes: sc9010 é quando o pedido saiu do status de digitação e foi para entrar no fluxo de liberações
[9:21 AM, 3/24/2020] camila lopes: sc5010 tabela do cabeçalho do pedido
[9:21 AM, 3/24/2020] camila lopes: sa1010 cadastro cliente
[9:21 AM, 3/24/2020] camila lopes: todo select que faz, precisa validar o D_E_L_E_T_ <> '*'
[9:21 AM, 3/24/2020] camila lopes: pq o protheus não deleta efetivamente do banco
[9:22 AM, 3/24/2020] camila lopes: ele seta esse campo para *


-- PEDIDO LIBERADO PARA PASSAR PARA AS APROVAÇÕES, OU SEJA, SAIU DO STATUS DE DIGITAÇÃO e É FINANCIAMENTO

SELECT E1_NUM NUM_TITULO, E1_FILIAL FILIAL, E1_EMISSAO DATA_GEROU_FIN, E1_VENCREA DATA_VENCIMENTO, E1_VALOR VALOR_FIN_GERADO, E1_BAIXA DATA_BAIXA, E1_PEDIDO PEDIDO, E1_SALDO SALDO_ABERTO,
             E1_PARCELA PARCELA, E1_X_FORMA FORMA_PAGTO, E1_TIPO TIPO
FROM SC5010 C5 (NOLOCK)
           INNER JOIN SE1010 E1 (NOLOCK)
          ON E1_FILIAL = C5_FILIAL
          AND E1_NUM = C5_NUM
          AND E1.D_E_L_E_T_ <> '*'
         
WHERE C5.D_E_L_E_T_ <> '*'
AND E1_X_FORMA IN ('FI','FSA','FBV','FNB','FCO','CO','FBN')
AND EXISTS (SELECT 1 FROM SC9010 C9 (NOLOCK)
         WHERE C9.D_E_L_E_T_ <> '*'
         AND C9_FILIAL = C5_FILIAL
         AND C9_PEDIDO = C9_PEDIDO)

-- PEDIDO LIBERADO PELO FINANCEIRO

SELECT C5_NUM PEDIDO
FROM SC5010 C5 (NOLOCK)
           
WHERE C5.D_E_L_E_T_ <> '*'
AND  EXISTS (SELECT 1 FROM SC9010 C9 (NOLOCK)
         WHERE C9.D_E_L_E_T_ <> '*'
         AND C9_FILIAL = C5_FILIAL
         AND C9_PEDIDO = C9_PEDIDO
        AND C9_BLCRED = ''
        AND C9_BLEST <> '')         

[9:37 AM, 3/24/2020] camila lopes: Chave primaria das tabelas, sempre sempre sempre começa com a filial, depois as demais
[9:37 AM, 3/24/2020] camila lopes: -- PEDIDO LIBERADO PELO FINANCEIRO E ESTOQUE - ESPERANDO SÓ FATURAR

SELECT C5_NUM PEDIDO, C5_FILIAL
FROM SC5010 C5 (NOLOCK)
           
WHERE C5.D_E_L_E_T_ <> '*'
AND  EXISTS (SELECT 1 FROM SC9010 C9 (NOLOCK)
         WHERE C9.D_E_L_E_T_ <> '*'
         AND C9_FILIAL = C5_FILIAL
         AND C9_PEDIDO = C9_PEDIDO
        AND C9_BLCRED = ''
        AND C9_BLEST = ''
        AND C9_NFISCAL = '')        

--  LEMBRANDO QUE POSSO TER N NOTAS FATURADAS PARA O MESMO PEDIDO
SELECT C6.C6_NOTA NOTA_FISCAL, C6_SERIE SERIE_NF, C6_DATFAT DATA_FATURAMENTO, C6_BLQ ELIMINADO_POR_RESIDUO, C6_NUMOP OP_GERADA, C6_ITEMOP ITEM_OP
FROM SC5010 C5 WITH(NOLOCK)
           INNER JOIN SC6010 C6 (NOLOCK)
           ON C5_FILIAL = C6_FILIAL
           AND C5_NUM = C5_NUM

WHERE C6.D_E_L_E_T_ <> '*'
AND C5.D_E_L_E_T_ <> '*'

-- SC2010 TABELA DE ORDEM DE PRODUÇÃO (OP) ----- SE TIVER DATA FINALIZADA, JÁ FOI INDUSTRIALIZADA E ESTÁ AGUARDANDO NF - TAB SC6010

SELECT C2_NUM NUMERO_OP, C2_EMISSAO DATA_GERADA, C2_DATRF DATA_FINALIZADA
FROM SC2010 C2 (NOLOCK)
         INNER JOIN SC6010 C6 (NOLOCK)
        ON C2_FILIAL = C6_FILIAL
        AND C2_PEDIDO = C6_NUM
        AND C2_ITEMPV = C6_ITEM
       AND C2_PRODUTO = C6_PRODUTO
WHERE C2.D_E_L_E_T_ <> '*'
AND C6.D_E_L_E_T_ <> '*'




