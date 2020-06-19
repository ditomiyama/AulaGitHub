<?php
if($_GET['cDoc'] != '' || $_GET['cPed'] != '') {
    require_once 'conn.php';

    $sql = "
    SELECT DISTINCT 'Em Industrialização' status, C2_NUM NUMERO_OP
    FROM SC2010 C2 (NOLOCK)
    INNER JOIN SC5010 C5 (NOLOCK)
    ON C2_FILIAL = C5_FILIAL
    AND C2_NUM = C5_NUM
    WHERE C2.D_E_L_E_T_ <> '*' or C2.D_E_L_E_T_ is null
    AND C5.D_E_L_E_T_ <> '*' or C5.D_E_L_E_T_ is null
    AND C2_DATRF = '' OR C2_DATRF IS NULL 
    AND C2_NUM = '".$_GET['cPed']."'    
    ";

    $stmt = $conn->query($sql)->fetch(PDO::FETCH_ASSOC);
    $status = $conn->query($sql)->fetchColumn(0);
    if($stmt){
        echo "{\"status\":\"<i class='far fa-check-square'> </i><div class='status-ok'> &nbsp; $status</div> \"}";
    }
    else
    {
        echo "{\"status\":\"<i class='far fa-window-close'> </i><div class='status-erro'> &nbsp; Em Industrialização</div> \"}";
    }
}
?>