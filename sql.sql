SELECT 
C5_NUM
, C5_CLIENTE
, C5_LOJACLI
, C5_TRANSP
, convert(varchar, C5_EMISSAO, 101)

, case
when C5_TPFRETE in ('C') then 'CIF' 
when C5_TPFRETE in ('FOB') then 'FOB'
when C5_TPFRETE in ('T') then 'Por conta teceiros'
when C5_TPFRETE in ('R') then 'Por conta remetente'
when C5_TPFRETE in ('D') then 'Por conta destinatário'
when C5_TPFRETE in ('S') then 'Sem Frete'
else  ''
end C5_TPFRETE
, C5_FECENT
, C5_X_DTECL
, A1_NOME
, A1_PESSOA
, A1_CGC

FROM SC5010 C5 (NOLOCK)
INNER JOIN SA1010 A1 (NOLOCK) ON C5_CLIENTE = A1_COD
AND C5_LOJACLI = A1_LOJA
AND A1.D_E_L_E_T_ <> '*'
WHERE C5.D_E_L_E_T_ <> '*'
and a1_cgc = '19949140846'
and c5_num = 'TP0039'
order by C5_EMISSAO desc 




SELECT
case
when C5_X_FORM1 in ('BOL') then 'Aguardando gera��o do boleto' 
when C5_X_FORM1 in ('FI','FSA','FBV','FNB','FCO','CO','FBN') then 'Aguardando aprova��o financiamento'
else  ' Aguardando aprova��o financeira'
end status
FROM SC5010 C5 (NOLOCK)
WHERE C5.D_E_L_E_T_ <> '*'
AND EXISTS (SELECT 1 FROM SC9010 C9 (NOLOCK)
         WHERE C9.D_E_L_E_T_ <> '*'
         AND C9_FILIAL = C5_FILIAL
         AND C9_PEDIDO = C9_PEDIDO)
and C5_NUM = '004939'


SELECT 'Aguardando industrializa��o' status
FROM SC5010 C5 (NOLOCK)
WHERE C5.D_E_L_E_T_ <> '*'
AND  EXISTS (SELECT 1 FROM SC9010 C9 (NOLOCK)
WHERE C9.D_E_L_E_T_ <> '*'
AND C9_FILIAL = C5_FILIAL
AND C9_PEDIDO = C9_PEDIDO
AND C9_BLCRED = ''
AND C9_BLEST <> '')
and C5_NUM = '004939'








SELECT DISTINCT C2_NUM NUMERO_OP, 'Em Industrializa��o' status
FROM SC2010 C2 (NOLOCK)
INNER JOIN SC5010 C5 (NOLOCK)
ON C2_FILIAL = C5_FILIAL
AND C2_NUM = C5_NUM
WHERE C2.D_E_L_E_T_ <> '*'
AND C5.D_E_L_E_T_ <> '*'
AND C2_DATRF = ''
AND C2_NUM = '006643'


--//busca os itens do pedido
SELECT *,  C2_NUM NUMERO_OP, 'Em Industrializa��o' status
FROM SC2010 C2 (NOLOCK)
INNER JOIN SC5010 C5 (NOLOCK)
ON C2_FILIAL = C5_FILIAL
AND C2_PEDIDO = C5_NUM
WHERE C2.D_E_L_E_T_ <> '*'
AND C5.D_E_L_E_T_ <> '*'
AND C2_DATRF = ''
and c2_num = '004939'
order by c2_item

  


SELECT C5_NUM PEDIDO, C5_FILIAL, 'Aguardando gera��o da NF-e' status
FROM SC5010 C5 (NOLOCK) 
WHERE C5.D_E_L_E_T_ <> '*'
AND  EXISTS (SELECT 1 FROM SC9010 C9 (NOLOCK)
WHERE C9.D_E_L_E_T_ <> '*'
AND C9_FILIAL = C5_FILIAL
AND C9_PEDIDO = C9_PEDIDO
AND C9_BLCRED = ''
AND C9_BLEST = ''
AND C9_NFISCAL = '')
AND C5_NUM = '004939'

SELECT C5_NUM PEDIDO, C5_FILIAL, 'NF-e GERADA' status
FROM SC5010 C5 (NOLOCK) 
WHERE C5.D_E_L_E_T_ <> '*'
AND  EXISTS (SELECT 1 FROM SC9010 C9 (NOLOCK)
WHERE C9.D_E_L_E_T_ <> '*'
AND C9_BLCRED = '10'
AND C9_BLEST = '10'
AND C9_NFISCAL != '')
AND C5_NUM = '004939'



----------------

SELECT C5_NUM PEDIDO, C5_FILIAL, C9_NFISCAL, 'NF-e GERADA' status
FROM SC5010 C5 (NOLOCK) 
INNER JOIN SC9010 C9 ON C9_FILIAL = C5_FILIAL
AND C9_PEDIDO = C5_NUM
WHERE C9.D_E_L_E_T_ <> '*'
AND C9.C9_BLCRED = '10'
AND C9.C9_BLEST = '10'
AND C9.C9_NFISCAL != ''
AND C5.C5_NUM = '006637'


//financiamento
C5_CLIENTE = 706557
A1_CGC = 27252123000176
C5_NUM = 006637
NFISCAL

F06880
22341676987   
select * from  SC5010 C5 order by c5_emissao desc 
SELECT * FROM SC5010 C5 WHERE C5_NUM = 'TP0039'




//nao tem nota fiscal emitida
//boleto
and a1_cgc = '19949140846'
and c5_num = 'TP0039'


01390072000155
006450



SELECT C9_PRODUTO COD_PRODUTO, B1_DESC DESCRICAO_PRODUTO, C9_QTDLIB QUANTIDADE
FROM SC9010 (NOLOCK)
INNER JOIN SB1010 (NOLOCK)
ON SC9010.D_E_L_E_T_ <> '*'
AND SB1010.D_E_L_E_T_ <> '*'
AND SUBSTRING(C9_FILIAL, 1, 2) = SUBSTRING(B1_FILIAL, 1, 2)
AND C9_PRODUTO = B1_COD
WHERE C9_PEDIDO = 'F06880'

select * FROM SC9010 (NOLOCK) where c9_pedido = 'F06880'