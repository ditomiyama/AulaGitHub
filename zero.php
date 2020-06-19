<?php
if($_GET['cDoc'] != '' || $_GET['cPed'] != '') {
    require_once 'conn.php';

    $sql = "
    select c9_pedido,D_E_L_E_T_, C9_BLCRED,C9_NFISCAL from SC9010 c9 
    WHERE C9.D_E_L_E_T_ != '*' or C9.D_E_L_E_T_ is null
    AND (C9.C9_BLCRED = '' or C9.C9_BLCRED is not null)
    AND (C9.C9_NFISCAL = '' OR C9.C9_NFISCAL IS NULL)
    and c9_pedido = '".$_GET['cPed']."'
    ";

    $stmt = $conn->query($sql)->fetch(PDO::FETCH_ASSOC);
    $count = $conn->query($sql)->fetchColumn(0);
    //var_dump($stmt);
    //var_dump($count);
    if($stmt){
        echo "{\"status\":\"<i class='far fa-check-square'> </i> <div class='status-ok'> &nbsp; Pedido Cadastrado</div>  \"}";
    }
    else
    {
        echo "{\"status\":\"<i class='far fa-check-square'> </i> <div class='status-ok'> &nbsp; Cadastrando Pedido</div> \"}";
    }
    /*
    if($stmt->fetch(PDO::FETCH_ASSOC) !== 'false'){
        var_dump($stmt->fetch(PDO::FETCH_ASSOC));
    }
    var_dump($stmt->fetch(PDO::FETCH_ASSOC));
    */
    //echo json_encode($stmt->fetch(PDO::FETCH_ASSOC));
}
?>

