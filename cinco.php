<?php
if($_GET['cDoc'] != '' || $_GET['cPed'] != '') {
    require_once 'conn.php';

    $sql = "
    SELECT distinct C5_NUM PEDIDO, C5_FILIAL, C9_NFISCAL nfiscal, '- NF-e GERADA' status
    FROM SC5010 C5 (NOLOCK) 
    INNER JOIN SC9010 C9 ON C9_PEDIDO = C5_NUM
    WHERE C9.D_E_L_E_T_ <> '*' or C9.D_E_L_E_T_ is null 
    AND C9.C9_BLCRED = '10'
    AND C9.C9_BLEST = '10'
    AND C9.C9_NFISCAL != ''
    AND C5.C5_NUM = '".$_GET['cPed']."'
    ";

    $stmt = $conn->query($sql);
    echo json_encode($stmt->fetch(PDO::FETCH_ASSOC));
    
}
?>