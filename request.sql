select * from SC5010 where c5_num = '002329'
select * from SC5010 where c5_cliente = '708048'
select * from SC5010 where c5_emissao >= '20200101' order by c5_emissao desc 
select a1_cgc, D_E_L_E_T_, * from SA1010 where a1_cod = '708048'
select a1_cgc,* from SA1010 where a1_cgc = '981140102'
select a1_cgc, * from SA1010 where a1_cod like '%007101%'
select * from SB1010
981140102		

SELECT 
C5_NUM
, C5_CLIENTE
, C5_LOJACLI
, C5_TRANSP
, convert(varchar,convert(date, C5_EMISSAO),103) C5_EMISSAO
, case
when C5_TPFRETE in ('C') then 'CIF' 
when C5_TPFRETE in ('FOB') then 'FOB'
when C5_TPFRETE in ('T') then 'Por conta teceiros'
when C5_TPFRETE in ('R') then 'Por conta remetente'
when C5_TPFRETE in ('D') then 'Por conta destinatário'
when C5_TPFRETE in ('S') then 'Sem Frete'
else  ''
end C5_TPFRETE
, convert(varchar,convert(date, C5_FECENT),103) C5_FECENT
, C5_X_DTECL
, A1_NOME
, A1_PESSOA
, A1_CGC
FROM SC5010 C5 (NOLOCK)
INNER JOIN SA1010 A1 (NOLOCK) ON C5_CLIENTE = A1_COD
WHERE
a1_cgc = '20546443826'
and C5_NUM = '006882'
order by C5_EMISSAO desc 

--PEDIDO EM DIGITAÇÃO

SELECT DISTINCT
c5_num,
c5_filial,
'Pedido em digitação' status
FROM SC5010 C5
WHERE C5.D_E_L_E_T_ <> '*' or C5.D_E_L_E_T_ is null
AND c5_num in (select c9_pedido from SC9010 c9 
				WHERE (C9.D_E_L_E_T_ <> '*' or C9.D_E_L_E_T_ is null)
				AND c5.c5_filial = c9.c9_filial
				AND c5.c5_NUM = c9.c9_PEDIDO
				AND C9.C9_BLCRED = '' or C9.C9_BLCRED is null
				AND C9.C9_NFISCAL = '' OR C9.C9_NFISCAL IS NULL
				)
AND C5_NUM = '006882'


select count(c9_pedido) from SC9010 c9 
				WHERE C9.D_E_L_E_T_ != '*' or C9.D_E_L_E_T_ is null
				and c9_pedido = '006882'
				AND (C9.C9_BLCRED = '' or C9.C9_BLCRED is null)
				AND (C9.C9_NFISCAL = '' OR C9.C9_NFISCAL IS NULL)
				group by c9_pedido



SELECT DISTINCT
c5_num,
c5_filial,
c5.D_E_L_E_T_,
case
when C5_X_FORM1 in ('BOL') then 'Aguardando geração do boleto' 
when C5_X_FORM1 in ('FI','FSA','FBV','FNB','FCO','CO','FBN') then 'Aguardando aprovação financiamento'
else  'Aguardando aprovação financeira'
end status
FROM SC5010 C5
WHERE
C5_NUM = '006882'

select c9_pedido, C9.D_E_L_E_T_, C9_BLCRED, C9_NFISCAL,c9_filial, * from SC9010 c9 
				WHERE  C9.D_E_L_E_T_ <> '*' or C9.D_E_L_E_T_ is null  and c9_pedido = '006882'


SELECT DISTINCT
case
when C5_X_FORM1 in ('BOL') then 'Aguardando geração do boleto' 
when C5_X_FORM1 in ('FI','FSA','FBV','FNB','FCO','CO','FBN') then 'Aguardando aprovação financiamento'
else  'Aguardando aprovação financeira'
end status
FROM SC5010 C5
WHERE exists (select 1 from SC9010 c9 
				WHERE C9.D_E_L_E_T_ <> '*' or C9.D_E_L_E_T_ is null 
				AND c5.c5_filial = c9.c9_filial
				AND c5.c5_NUM = c9.c9_PEDIDO
				AND C9.C9_BLCRED <> '' or C9.C9_BLCRED is NOT null
				AND C9.C9_NFISCAL = '' OR C9.C9_NFISCAL IS NULL
				)

AND C5_NUM = '006882'


SELECT 'Aguardando industrialização' status
FROM SC5010 C5 (NOLOCK)
WHERE C5.D_E_L_E_T_ <> '*'
AND  EXISTS (SELECT 1 FROM SC9010 C9 (NOLOCK)
				WHERE C9.D_E_L_E_T_ <> '*' or C9.D_E_L_E_T_ is null
				AND C9_FILIAL = C5_FILIAL
				AND C9_PEDIDO = C5_NUM
				AND C9_BLCRED = '' OR C9_BLCRED IS NULL
				AND C9_BLEST <> '' OR C9_BLEST IS NOT NULL)
and C5_NUM = '006882'

SELECT DISTINCT 'Em Industrialização' status, C2_NUM NUMERO_OP
FROM SC2010 C2 (NOLOCK)
INNER JOIN SC5010 C5 (NOLOCK)
ON C2_FILIAL = C5_FILIAL
AND C2_NUM = C5_NUM
WHERE C2.D_E_L_E_T_ <> '*' or C2.D_E_L_E_T_ is null
AND C5.D_E_L_E_T_ <> '*' or C5.D_E_L_E_T_ is null
AND C2_DATRF = '' OR C2_DATRF IS NULL 
AND C2_NUM = '006882'


SELECT distinct C5_NUM PEDIDO, C5_FILIAL, 'Aguardando geração da NF-e' status
FROM SC5010 C5 (NOLOCK) 
WHERE C5.D_E_L_E_T_ <> '*'
AND  EXISTS (SELECT 1 FROM SC9010 C9 (NOLOCK)
WHERE C9.D_E_L_E_T_ <> '*'
AND C9_BLCRED = '' or C9_BLCRED is null
AND C9_BLEST = '' or C9_BLEST is null 
AND C9_NFISCAL = '' or C9_NFISCAL is null 
)
AND C5_NUM = '006882'

SELECT C9.D_E_L_E_T_, C5_NUM PEDIDO, C5_FILIAL, C9_NFISCAL, 'NF-e GERADA' status
FROM SC5010 C5 (NOLOCK) 
INNER JOIN SC9010 C9 ON C9_PEDIDO = C5_NUM
WHERE C9.D_E_L_E_T_ <> '*'
AND C9.C9_BLCRED = '10'
AND C9.C9_BLEST = '10'
AND C9.C9_NFISCAL != '' OR C9.C9_NFISCAL IS NOT NULL 
AND C5.C5_NUM = '006882'

SELECT C9_PRODUTO produto, sum(convert(float,C9_QTDLIB)) quantidade
FROM SC9010 (NOLOCK)
INNER JOIN SB1010 (NOLOCK)
ON SC9010.D_E_L_E_T_ <> '*' or SC9010.D_E_L_E_T_ is null
AND SB1010.D_E_L_E_T_ <> '*' or SB1010.D_E_L_E_T_ is null
AND SUBSTRING(C9_FILIAL, 1, 2) = SUBSTRING(B1_FILIAL, 1, 2)
AND C9_PRODUTO = B1_COD
WHERE C9_PEDIDO = '002329'
group by C9_PRODUTO





Aguardando geração do boleto
Aguardando aprovação financiamento
Aguardando aprovação financeira
Aguardando aprovação financiamento
Aguardando industrialização.
Em Industrialização
Aguardando geração da NF-e
NF-e GERADA + numero nota