<?php
if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
    $conn = new PDO('sqlsrv:server=app.ecori.com.br;Database=protheus', 'sa', '!Q@W#Easzxktiont4#@!');
} else {
    $conn = new PDO('dblib:host=app.ecori.com.br;dbname=protheus', 'sa', '!Q@W#Easzxktiont4#@!');
}
?>