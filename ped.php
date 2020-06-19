<?php
if($_GET['cDoc'] != '' || $_GET['cPed'] != '') {
require_once 'conn.php';

$sql = "
SELECT 
C5_NUM pedido
, C5_CLIENTE cod_cliente
, C5_LOJACLI lojacli
, C5_TRANSP cod_transp
, convert(varchar,convert(date, C5_EMISSAO),103) data_emissao
, case
when C5_TPFRETE in ('C') then 'CIF' 
when C5_TPFRETE in ('FOB') then 'FOB'
when C5_TPFRETE in ('T') then 'Por conta teceiros'
when C5_TPFRETE in ('R') then 'Por conta remetente'
when C5_TPFRETE in ('D') then 'Por conta destinatário'
when C5_TPFRETE in ('S') then 'Sem Frete'
else  ''
end tipo_frete
, convert(varchar,convert(date, C5_FECENT),103) data_prev_entrega
, convert(varchar,convert(date, C5_X_DTECL),103) data_comb_cli_entrega
, A1_NOME razao_social
, A1_PESSOA tipo_pessoa
, A1_CGC cpf_cnpj
FROM SC5010 C5 (NOLOCK)
INNER JOIN SA1010 A1 (NOLOCK) ON C5_CLIENTE = A1_COD
WHERE
a1_cgc = '".$_GET['cDoc']."'
and C5_NUM = '".$_GET['cPed']."'
order by C5_EMISSAO desc 
";

$stmt = $conn->query($sql);
echo json_encode($stmt->fetch(PDO::FETCH_ASSOC));
}
?>