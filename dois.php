<?php
if($_GET['cDoc'] != '' || $_GET['cPed'] != '') {
    require_once 'conn.php';
    $sql = "
    SELECT 'Aguardando industrialização' status
    FROM SC5010 C5 (NOLOCK)
    WHERE C5.D_E_L_E_T_ <> '*'
    AND  EXISTS (SELECT 1 FROM SC9010 C9 (NOLOCK)
                    WHERE C9.D_E_L_E_T_ <> '*' or C9.D_E_L_E_T_ is null
                    AND C9_FILIAL = C5_FILIAL
                    AND C9_PEDIDO = C5_NUM
                    AND C9_BLCRED = '' OR C9_BLCRED IS NULL
                    AND C9_BLEST <> '' OR C9_BLEST IS NOT NULL)
    and C5_NUM = '".$_GET['cPed']."'
    
    ";


    $stmt = $conn->query($sql)->fetch(PDO::FETCH_ASSOC);
    $status = $conn->query($sql)->fetchColumn(0);
    if($stmt){
        echo "{\"status\":\"<i class='far fa-check-square'> </i> <div class='status-ok'> &nbsp; $status</div>\"}";
    }
    else
    {
        echo "{\"status\":\"<i class='far fa-window-close'> </i><div class='status-erro'> &nbsp; Aguardando industrialização</div> \"}";
    }
    
}
?>