<?php
if($_GET['cDoc'] != '' || $_GET['cPed'] != '') {
    require_once 'conn.php';

    $sql = "
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
    AND C5_NUM = '".$_GET['cPed']."'
    ";


    $stmt = $conn->query($sql)->fetch(PDO::FETCH_ASSOC);
    $status = $conn->query($sql)->fetchColumn(0);
    if($stmt){
        echo "{\"status\":\"<i class='far fa-check-square'> </i> <div class='status-ok'> &nbsp; $status</div> \"}";
    }
    else
    {
        echo "{\"status\":\"<i class='far fa-window-close'> </i> <div class='status_erro'> &nbsp; Aguardando aprovação financeira</div> \"}";
    }


}
?>