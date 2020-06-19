<?php
if($_GET['cDoc'] != '' || $_GET['cPed'] != '') {
    require_once 'conn.php';

    $sql = "
    SELECT C9_NFISCAL, C9.D_E_L_E_T_, C5_NUM PEDIDO, C5_FILIAL, C9_NFISCAL,C9_BLCRED,C9_BLEST 
    FROM SC5010 C5 (NOLOCK) 
    INNER JOIN SC9010 C9 ON C9_PEDIDO = C5_NUM
    WHERE (C9.D_E_L_E_T_ <> '*' or C9.D_E_L_E_T_ is null)
    AND C9.C9_BLCRED = '10'
    AND C9.C9_BLEST = '10'
    AND (C9.C9_NFISCAL != '' OR C9.C9_NFISCAL IS NOT NULL )
    AND C5.C5_NUM = '".$_GET['cPed']."'
    ";

    $stmt = $conn->query($sql)->fetch(PDO::FETCH_ASSOC);
    $status = $conn->query($sql)->fetchColumn(0);
    if($stmt){
        echo "{\"status\":\"<i class='far fa-check-square'> NF-e GERADA - $status</i> \"}";
    }
    else
    {

        $sql = "
        SELECT 'Aguardando geração da NF-e' status, C9.D_E_L_E_T_, C5_NUM PEDIDO, C5_FILIAL, C9_NFISCAL,C9_BLCRED,C9_BLEST, C9_NFISCAL
        FROM SC5010 C5 (NOLOCK) 
        INNER JOIN SC9010 C9 ON C9_PEDIDO = C5_NUM
        WHERE (C9.D_E_L_E_T_ <> '*' or C9.D_E_L_E_T_ is null)
        AND C9.C9_BLCRED = '' or C9.C9_BLCRED is null
        AND C9.C9_BLEST = '' or C9.C9_BLEST is null 
        AND (C9.C9_NFISCAL = '' OR C9.C9_NFISCAL IS NULL )
        AND C5.C5_NUM = '".$_GET['cPed']."'
        ";

        $stmt = $conn->query($sql)->fetch(PDO::FETCH_ASSOC);
        $status = $conn->query($sql)->fetchColumn(0);
        if($stmt){
            echo "{\"status\":\"<i class='far fa-check-square'> </i><div class='status-ok'> &nbsp; $status</div> \"}";
        }
        else
        {
            echo "{\"status\":\"<i class='far fa-window-close'> </i><div class='status-erro'> &nbsp; Aguardando geração da NF-e</div> \"}";
        }
    }    
}
?>