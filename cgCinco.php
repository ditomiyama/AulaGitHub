<?php
if($_GET['cDoc'] != '' || $_GET['cPed'] != '') {
    //The url you wish to send the POST request to
    //$url = "http://ecoriindustria106258.protheus.cloudtotvs.com.br:4050/rest/ecoriws/cgAuth";
    $url = "http://ecoriindustria106258.protheus.cloudtotvs.com.br:4050/rest/ecoriws/cgCinco";

    //The data you want to send via POST
    $fields = [
        'cUser' => 'webservice',
        'cPass' => 'ecori2020'
    ];

    $campos = array();
    $campos [] = 'cUser:webservice';
    $campos [] = 'cPass:ecori2020';
    $campos [] = 'cEmp:01';
    $campos [] = 'cFil:0101';
    $campos [] = "cDoc:".$_GET['cDoc'];
    $campos [] = "cPed:".$_GET['cPed'];
    //url-ify the data for the POST
    $fields_string = http_build_query($fields);

    //open connection
    $ch = curl_init();

    //set the url, number of POST vars, POST data
    curl_setopt($ch,CURLOPT_URL, $url);
    //curl_setopt($ch,CURLOPT_POST, true);
    //curl_setopt($ch,CURLOPT_POSTFIELDS, $fields_string);
    curl_setopt($ch,CURLOPT_HTTPHEADER,$campos);

    //So that curl_exec returns the contents of the cURL; rather than echoing it
    //curl_setopt($ch,CURLOPT_RETURNTRANSFER, true); 

    //execute post
    $result = curl_exec($ch);
    //echo $result;
}
?>