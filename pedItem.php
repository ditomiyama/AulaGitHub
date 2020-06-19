<?php
if($_GET['cDoc'] != '' || $_GET['cPed'] != '') {
    require_once 'conn.php';

    $sql = "
    SELECT C9_PRODUTO produto, sum(convert(int,convert(float,C9_QTDLIB))) quantidade
    FROM SC9010 (NOLOCK)
    INNER JOIN SB1010 (NOLOCK)
    ON SC9010.D_E_L_E_T_ <> '*' or SC9010.D_E_L_E_T_ is null
    AND SB1010.D_E_L_E_T_ <> '*' or SB1010.D_E_L_E_T_ is null
    AND SUBSTRING(C9_FILIAL, 1, 2) = SUBSTRING(B1_FILIAL, 1, 2)
    AND C9_PRODUTO = B1_COD
    WHERE C9_PEDIDO = '".$_GET['cPed']."'
    group by C9_PRODUTO
    ";

    $rs = $conn->query($sql);    
    //var_dump($rs->fetch(PDO::FETCH_ASSOC));
    $_json = "[";
    foreach ($conn->query($sql) as $row) {
        $_json .= '{"produto":"'.$row['produto'].'","quantidade":"'. $row['quantidade']. '"},';
    }
    $_json = substr($_json,0,strlen($_json)-1);
    echo $_json .= "]";
    
    //echo json_encode($rs->fetch(PDO::FETCH_ASSOC));
}
?>