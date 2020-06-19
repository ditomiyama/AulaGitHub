#include "totvs.ch"
#include "restful.ch"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TOPCONN.CH"

#IFNDEF CRLF
   #DEFINE CRLF Chr(13)+Chr(10)
#EndIF

//webservice
//ecori2020

// TESTE
//http://ecoriindustria106258.protheus.cloudtotvs.com.br:4050/REST

// OFICIAL
//http://ecoriindustria106080.protheus.cloudtotvs.com.br:4050/REST01

/*******************************************************************
Web Service : RESTECORI - WS ECORI
Autor ......: Marcelo Jose
Data .......: 06/03/2020
Exemplo ....: 
*******************************************************************/
// https://tdn.totvs.com/pages/viewpage.action?pageId=75269436

User Function RESTECORI()
Return .t.

WSRESTFUL ecoriws DESCRIPTION "ECORI - Web Services personalizados"
 WSDATA cUser	  AS STRING OPTIONAL
 WSDATA cPass 	  AS STRING OPTIONAL
 WSDATA cEmp 	  AS STRING OPTIONAL
 WSDATA cFil 	  AS STRING OPTIONAL
 WSDATA cTipo 	  AS STRING OPTIONAL
 WSDATA cEquipe  AS STRING OPTIONAL
 WSDATA sDataDe  AS STRING OPTIONAL
 WSDATA sDataAte AS STRING OPTIONAL

 WSMETHOD GET cgAuth;
 DESCRIPTION EncodeUTF8("ECORI - Serviço de Autenticação");
 WSSYNTAX "/ecoriws/cgAuth";
 PATH "/cgAuth";
 PRODUCES 'application/json;charset=utf-8'

 WSMETHOD GET cgPed;
 DESCRIPTION EncodeUTF8("ECORI - Pedidos");
 WSSYNTAX "/ecoriws/cgPed";
 PATH "/cgPed";
 PRODUCES 'application/json;charset=utf-8'

 WSMETHOD GET cgUm;
 DESCRIPTION EncodeUTF8("ECORI - Status 1");
 WSSYNTAX "/ecoriws/cgUm";
 PATH "/cgUm";
 PRODUCES 'application/json;charset=utf-8'

 WSMETHOD GET cgDois;
 DESCRIPTION EncodeUTF8("ECORI - Status 2");
 WSSYNTAX "/ecoriws/cgDois";
 PATH "/cgDois";
 PRODUCES 'application/json;charset=utf-8'

 WSMETHOD GET cgTres;
 DESCRIPTION EncodeUTF8("ECORI - Status 3");
 WSSYNTAX "/ecoriws/cgTres";
 PATH "/cgTres";
 PRODUCES 'application/json;charset=utf-8'

 WSMETHOD GET cgQuatro;
 DESCRIPTION EncodeUTF8("ECORI - Status 4");
 WSSYNTAX "/ecoriws/cgQuatro";
 PATH "/cgQuatro";
 PRODUCES 'application/json;charset=utf-8'

 WSMETHOD GET cgCinco;
 DESCRIPTION EncodeUTF8("ECORI - Status 5");
 WSSYNTAX "/ecoriws/cgCinco";
 PATH "/cgCinco";
 PRODUCES 'application/json;charset=utf-8'

 WSMETHOD GET cgPedItem;
 DESCRIPTION EncodeUTF8("ECORI - Status 5");
 WSSYNTAX "/ecoriws/cgPedItem";
 PATH "/cgPedItem";
 PRODUCES 'application/json;charset=utf-8'



END WSRESTFUL
/*/{Protheus.doc} cgAuth
Autenticacao. Consulta usuario/senha para acesso
@author Marcelo Jose
@since 06/03/2020
@version 1.0
@return ${return}, ${return_description}
@example http://ecoriindustria106258.protheus.cloudtotvs.com.br:4050/REST/ecoriws/cgAuth
@source RESTECORI
@type function
/*/
WSMETHOD GET cgAuth WSSERVICE ecoriws
   Local cRet      := ""
   Local aCab      := {} //Titulo dos campos
   Local aLin      := {} //Itens

   Local cUser		 := ""
   Local cPassword := ""

   Local aDadUser  := {}
   Local cIdUser   := ""
   Local cNomeUsr  := ""

   aCab := {"Resultado","Registro","Descricao"}

   RpcSetType(3)  // ABRE O AMBIENTE NO PROTHEUS
   RpcSetEnv("01", "01",,,"PCP")

   // define o tipo de retorno do metodo
   ::SetContentType("application/json")
   ::SetHeader('Access-Control-Allow-Credentials' , "true")
   cUser  := Self:GetHeader('cUser')
   cPassword := Self:GetHeader('cPass')

   conout("cUser: "+cUser)
   conout("cPass: "+cPassword)

   Conout( DTOC(DDATABASE)+" - "+TIME()+" ==> Acesso REST CGAAUTH usuario: "+cUser )

   PswOrder(2)

   If PswSeek(cUser, .T.)
      aDadUser := PswRet(1)
      PswOrder(2) // PswOrder(1)  PswSeek(__cUserId, .T.)
      cIdUser  := AllTrim(aDadUser[1,1])
      cNomeUsr := AllTrim(aDadUser[1,4])
      If PswName(cPassword)
         AADD(aLin,{"OK",cIdUser,cNomeUsr})
         //setRestFault(002,"Usuario Reconhecido!")
      Else
         AADD(aLin,{"NO","","Senha incorreta!"})
         //SetRestFault(400, "Senha incorreta!")
      EndIf
   Else
      AADD(aLin,{"NO","","Usuario nao cadastrado!"})
      //SetRestFault(400, "Usuario nao cadastrado!")
   Endif


   cRet := U_CGAJSON( { "" , aCab, aLin} )
   ::SetResponse(cRet)

   RpcClearEnv() // FECHA O AMBIENTE DO PROTHEUS

return .T.

/*/{Protheus.doc} cgPed
Serviço de Pedidos
@author Marcelo Toscano
@since 16/04/2020
@version 1.0
@return ${return}, ${return_description}
@example http://ecoriindustria106258.protheus.cloudtotvs.com.br:4050/REST/ecoriws/cgPed
@source RESTECORI
@type function
/*/
WSMETHOD GET cgPed WSSERVICE ecoriws

   Local cRet      := ""
   Local aCab      := {} //Titulo dos campos
   Local aLin      := {} //Itens
   Local _cEmp     := ""
   Local _cFil     := ""
   Local cSQL      := ""
   Local _cDoc     := ""
   Local _cPed     := ""

   // define o tipo de retorno do metodo
   ::SetContentType("application/json")
   ::SetHeader('Access-Control-Allow-Credentials' , "true")
   _cEmp     := Self:GetHeader('cEmp')
   _cFil     := Self:GetHeader('cFil')
   _cDoc     := Self:GetHeader('cDoc')
   _cPed     := Self:GetHeader('cPed')

   RpcSetType(3)  // ABRE O AMBIENTE NO PROTHEUS
   RpcSetEnv(_cEmp, _cFil,,,"PCP")

   

   cSQL := "SELECT "
   cSQL += " C5_NUM"
   cSQL += " , C5_CLIENTE"
   cSQL += " , C5_LOJACLI"
   cSQL += " , C5_TRANSP"

   cSQL += " , convert(date, C5_EMISSAO, 103) C5_EMISSAO"

   cSQL += " , case"
   cSQL += " when C5_TPFRETE in ('C') then 'CIF' "
   cSQL += " when C5_TPFRETE in ('FOB') then 'FOB'"
   cSQL += " when C5_TPFRETE in ('T') then 'Por conta teceiros'"
   cSQL += " when C5_TPFRETE in ('R') then 'Por conta remetente'"
   cSQL += " when C5_TPFRETE in ('D') then 'Por conta destinatário'"
   cSQL += " when C5_TPFRETE in ('S') then 'Sem Frete'"
   cSQL += " else  ''"
   cSQL += " end C5_TPFRETE"
   cSQL += " , convert(date, C5_FECENT, 103) C5_FECENT"
   cSQL += " , C5_X_DTECL"
   cSQL += " , A1_NOME"
   cSQL += " , A1_PESSOA"
   cSQL += " , A1_CGC"

   cSQL += " FROM SC5010 C5 (NOLOCK)
   cSQL += " INNER JOIN SA1010 A1 (NOLOCK) ON C5_CLIENTE = A1_COD
   cSQL += " AND C5_LOJACLI = A1_LOJA
   cSQL += " AND A1.D_E_L_E_T_ <> '*'
   cSQL += " WHERE C5.D_E_L_E_T_ <> '*'

   cSQL += " and a1_cgc = '"+_cDoc+"'"
   cSQL += " and c5_num = '"+_cPed+"'"
   cSQL += " order by C5_EMISSAO desc "

   cSQL :=  ChangeQuery(cSQL)
   TCQUERY cSQL NEW ALIAS "QRYC2"
   DbSelectArea("QRYC2")
   While !Eof()
         AADD(aLin,{ QRYC2->C5_NUM, QRYC2->C5_CLIENTE, QRYC2->C5_LOJACLI, QRYC2->C5_TRANSP, QRYC2->C5_EMISSAO , QRYC2->C5_TPFRETE, QRYC2->C5_FECENT, QRYC2->C5_X_DTECL, QRYC2->A1_NOME, QRYC2->A1_PESSOA, QRYC2->A1_CGC,  } )
         DbSelectArea("QRYC2")
         dbSkip()
   End
   If Len(aLin) <= 0
      aCab := {}
      AADD(aLin,{})
      cRet := U_CGAJSON( { "" , aCab, aLin} )
   else
      aCab := { "pedido","cod_cliente","lojacli","cod_transp","data_emissao","tipo_frete","data_prev_entrega","data_comb_cli_entrega","razao_social","tipo_pessoa","cpf_cnpj"}
      cRet := U_CGAJSON( { "" , aCab, aLin} )   
   EndIf

   ::SetResponse(cRet)
   RpcClearEnv() // FECHA O AMBIENTE DO PROTHEUS
return .T.

/*/{Protheus.doc} cgUm
Serviço de Pedidos
@author Marcelo Toscano
@since 16/04/2020
@version 1.0
@return ${return}, ${return_description}
@example http://ecoriindustria106258.protheus.cloudtotvs.com.br:4050/REST/ecoriws/cgUm
@source RESTECORI
@type function
SE TIVER BOLETO E O PEDIDO AINDA NÃO FOI LIBERADO DE NADA
/*/
WSMETHOD GET cgUm WSSERVICE ecoriws

   Local cRet      := ""
   Local aCab      := {} //Titulo dos campos
   Local aLin      := {} //Itens
   Local _cEmp     := ""
   Local _cFil     := ""
   Local cSQL      := ""
   Local _cDoc     := ""
   Local _cPed     := ""
   //Local _total    := 0

   // define o tipo de retorno do metodo
   ::SetContentType("application/json")
   ::SetHeader('Access-Control-Allow-Credentials' , "true")
   _cEmp     := Self:GetHeader('cEmp')
   _cFil     := Self:GetHeader('cFil')
   _cDoc     := Self:GetHeader('cDoc')
   _cPed     := Self:GetHeader('cPed')

   RpcSetType(3)  // ABRE O AMBIENTE NO PROTHEUS
   RpcSetEnv(_cEmp, _cFil,,,"PCP")

   //se tiver boleto e o pedido ainda nao foi liberado de nada 

cSQL := "SELECT DISTINCT "
cSQL += " case"
cSQL += " when C5_X_FORM1 in ('BOL') then 'Aguardando geração do boleto' "
cSQL += " when C5_X_FORM1 in ('FI','FSA','FBV','FNB','FCO','CO','FBN') then 'Aguardando aprovação financiamento'"
cSQL += " else  ' Aguardando aprovação financeira'"
cSQL += " end status"
cSQL += " FROM SC5010 C5 (NOLOCK)"
cSQL += " WHERE C5.D_E_L_E_T_ <> '*'"
cSQL += " AND EXISTS (SELECT 1 FROM SC9010 C9 (NOLOCK)"
         cSQL += " WHERE C9.D_E_L_E_T_ <> '*'"
         cSQL += " AND C9_FILIAL = C5_FILIAL"
         cSQL += " AND C9_PEDIDO = C9_PEDIDO)"
cSQL += " and C5_NUM = '"+_cPed+"'"

   cSQL :=  ChangeQuery(cSQL)
   TCQUERY cSQL NEW ALIAS "QRYC2"
   DbSelectArea("QRYC2")
   While !Eof()
         //_total := _total + 1
         AADD(aLin,{ EncodeUTF8(QRYC2->status, "cp1252") } )
         //AADD(aLin,{ QRYC2->C5_NUM, QRYC2->C5_CLIENTE, QRYC2->C5_LOJACLI, QRYC2->C5_TRANSP, QRYC2->C5_EMISSAO, QRYC2->C5_TPFRETE, QRYC2->C5_FECENT, QRYC2->C5_X_DTECL, QRYC2->A1_NOME, QRYC2->A1_PESSOA, QRYC2->A1_CGC,  } )
         DbSelectArea("QRYC2")
         dbSkip()
   End

   aCab := {'status'}
   //AADD(aLin,{})
   cRet := U_CGAJSON( { "" , aCab, aLin} )

   ::SetResponse(cRet)
   RpcClearEnv() // FECHA O AMBIENTE DO PROTHEUS
return .T.

/*/{Protheus.doc} status2
Serviço de Pedidos
@author Marcelo Toscano
@since 16/04/2020
@version 1.0
@return ${return}, ${return_description}
@example http://ecoriindustria106258.protheus.cloudtotvs.com.br:4050/REST/ecoriws/status2
@source RESTECORI
@type function
SE TIVER BOLETO E O PEDIDO AINDA NÃO FOI LIBERADO DE NADA
/*/
WSMETHOD GET cgDois WSSERVICE ecoriws

   Local cRet      := ""
   Local aCab      := {} //Titulo dos campos
   Local aLin      := {} //Itens
   Local _cEmp     := ""
   Local _cFil     := ""
   Local cSQL      := ""
   Local _cDoc     := ""
   Local _cPed     := ""

   // define o tipo de retorno do metodo
   ::SetContentType("application/json")
   ::SetHeader('Access-Control-Allow-Credentials' , "true")
   _cEmp     := Self:GetHeader('cEmp')
   _cFil     := Self:GetHeader('cFil')
   _cDoc     := Self:GetHeader('cDoc')
   _cPed     := Self:GetHeader('cPed')

   RpcSetType(3)  // ABRE O AMBIENTE NO PROTHEUS
   RpcSetEnv(_cEmp, _cFil,,,"PCP")

   // PEDIDO LIBERADO PARA PASSAR PARA AS APROVAÇÕES, OU SEJA, SAIU DO STATUS DE DIGITAÇÃO e É FINANCIAMENTO

cSQL := "SELECT 'Aguardando industrialização' status"
cSQL += " FROM SC5010 C5 (NOLOCK)"
cSQL += " WHERE C5.D_E_L_E_T_ <> '*'"
cSQL += " AND  EXISTS (SELECT 1 FROM SC9010 C9 (NOLOCK)"
cSQL += " WHERE C9.D_E_L_E_T_ <> '*'"
cSQL += " AND C9_FILIAL = C5_FILIAL"
cSQL += " AND C9_PEDIDO = C9_PEDIDO"
cSQL += " AND C9_BLCRED = ''"
cSQL += " AND C9_BLEST <> '')"
cSQL += " and C5_NUM ='"+_cPed+"'"


   cSQL :=  ChangeQuery(cSQL)
   TCQUERY cSQL NEW ALIAS "QRYC2"
   DbSelectArea("QRYC2")
   While !Eof()
         //_total := _total + 1
         AADD(aLin,{ EncodeUTF8(QRYC2->status, "cp1252") } )
         //AADD(aLin,{ QRYC2->C5_NUM, QRYC2->C5_CLIENTE, QRYC2->C5_LOJACLI, QRYC2->C5_TRANSP, QRYC2->C5_EMISSAO, QRYC2->C5_TPFRETE, QRYC2->C5_FECENT, QRYC2->C5_X_DTECL, QRYC2->A1_NOME, QRYC2->A1_PESSOA, QRYC2->A1_CGC,  } )
         DbSelectArea("QRYC2")
         dbSkip()
   End

   aCab := {'status'}
   //AADD(aLin,{})
   cRet := U_CGAJSON( { "" , aCab, aLin} )

   ::SetResponse(cRet)
   RpcClearEnv() // FECHA O AMBIENTE DO PROTHEUS

return .T.

/*/{Protheus.doc} status3
Serviço de Pedidos
@author Marcelo Toscano
@since 16/04/2020
@version 1.0
@return ${return}, ${return_description}
@example http://ecoriindustria106258.protheus.cloudtotvs.com.br:4050/REST/ecoriws/status3
@source RESTECORI
@type function
SE TIVER BOLETO E O PEDIDO AINDA NÃO FOI LIBERADO DE NADA
/*/
WSMETHOD GET cgTres WSSERVICE ecoriws

   Local cRet      := ""
   Local aCab      := {} //Titulo dos campos
   Local aLin      := {} //Itens
   Local _cEmp     := ""
   Local _cFil     := ""
   Local cSQL      := ""
   Local _cDoc     := ""
   Local _cPed     := ""

   // define o tipo de retorno do metodo
   ::SetContentType("application/json")
   ::SetHeader('Access-Control-Allow-Credentials' , "true")
   _cEmp     := Self:GetHeader('cEmp')
   _cFil     := Self:GetHeader('cFil')
   _cDoc     := Self:GetHeader('cDoc')
   _cPed     := Self:GetHeader('cPed')

   RpcSetType(3)  // ABRE O AMBIENTE NO PROTHEUS
   RpcSetEnv(_cEmp, _cFil,,,"PCP")

   cSQL := "SELECT DISTINCT C2_NUM NUMERO_OP, 'Em Industrialização' status
   cSQL += " FROM SC2010 C2 (NOLOCK)"
   cSQL += " INNER JOIN SC5010 C5 (NOLOCK)"
   cSQL += " ON C2_FILIAL = C5_FILIAL"
   cSQL += " AND C2_NUM = C5_NUM"
   cSQL += " WHERE C2.D_E_L_E_T_ <> '*'"
   cSQL += " AND C5.D_E_L_E_T_ <> '*'"
   //cSQL += " AND C2_DATRF = ''"
   cSQL += " AND C2_NUM ='"+_cPed+"'"


   cSQL :=  ChangeQuery(cSQL)
   TCQUERY cSQL NEW ALIAS "QRYC2"
   DbSelectArea("QRYC2")
   While !Eof()
         //_total := _total + 1
         AADD(aLin,{ EncodeUTF8(QRYC2->status, "cp1252") } )
         //AADD(aLin,{ QRYC2->C5_NUM, QRYC2->C5_CLIENTE, QRYC2->C5_LOJACLI, QRYC2->C5_TRANSP, QRYC2->C5_EMISSAO, QRYC2->C5_TPFRETE, QRYC2->C5_FECENT, QRYC2->C5_X_DTECL, QRYC2->A1_NOME, QRYC2->A1_PESSOA, QRYC2->A1_CGC,  } )
         DbSelectArea("QRYC2")
         dbSkip()
   End

   aCab := {'status'}
   //AADD(aLin,{})
   cRet := U_CGAJSON( { "" , aCab, aLin} )

   ::SetResponse(cRet)
   RpcClearEnv() // FECHA O AMBIENTE DO PROTHEUS

return .T.

/*/{Protheus.doc} status4
Serviço de Pedidos
@author Marcelo Toscano
@since 16/04/2020
@version 1.0
@return ${return}, ${return_description}
@example http://ecoriindustria106258.protheus.cloudtotvs.com.br:4050/REST/ecoriws/status4
@source RESTECORI
@type function
SE TIVER BOLETO E O PEDIDO AINDA NÃO FOI LIBERADO DE NADA
/*/
WSMETHOD GET cgQuatro WSSERVICE ecoriws

   Local cRet      := ""
   Local aCab      := {} //Titulo dos campos
   Local aLin      := {} //Itens
   Local _cEmp     := ""
   Local _cFil     := ""
   Local cSQL      := ""
   Local _cDoc     := ""
   Local _cPed     := ""

   // define o tipo de retorno do metodo
   ::SetContentType("application/json")
   ::SetHeader('Access-Control-Allow-Credentials' , "true")
   _cEmp     := Self:GetHeader('cEmp')
   _cFil     := Self:GetHeader('cFil')
   _cDoc     := Self:GetHeader('cDoc')
   _cPed     := Self:GetHeader('cPed')

   RpcSetType(3)  // ABRE O AMBIENTE NO PROTHEUS
   RpcSetEnv(_cEmp, _cFil,,,"PCP")

cSQL := " SELECT distinct C5_NUM PEDIDO, C5_FILIAL, 'Aguardando geração da NF-e' status"
cSQL += " FROM SC5010 C5 (NOLOCK) "
cSQL += " WHERE C5.D_E_L_E_T_ <> '*'"
cSQL += " AND  EXISTS (SELECT 1 FROM SC9010 C9 (NOLOCK)"
cSQL += " WHERE C9.D_E_L_E_T_ <> '*'"
cSQL += " AND C9_BLCRED = ''"
cSQL += " AND C9_BLEST = ''"
cSQL += " AND C9_NFISCAL = '')"
cSQL += " AND C5_NUM ='"+_cPed+"'"

   cSQL :=  ChangeQuery(cSQL)
   TCQUERY cSQL NEW ALIAS "QRYC2"
   DbSelectArea("QRYC2")
   While !Eof()
         //_total := _total + 1
         AADD(aLin,{ EncodeUTF8(QRYC2->status, "cp1252") } )
         //AADD(aLin,{ QRYC2->C5_NUM, QRYC2->C5_CLIENTE, QRYC2->C5_LOJACLI, QRYC2->C5_TRANSP, QRYC2->C5_EMISSAO, QRYC2->C5_TPFRETE, QRYC2->C5_FECENT, QRYC2->C5_X_DTECL, QRYC2->A1_NOME, QRYC2->A1_PESSOA, QRYC2->A1_CGC,  } )
         DbSelectArea("QRYC2")
         dbSkip()
   End

   aCab := {'status'}
   //AADD(aLin,{})
   cRet := U_CGAJSON( { "" , aCab, aLin} )

   ::SetResponse(cRet)
   RpcClearEnv() // FECHA O AMBIENTE DO PROTHEUS

return .T.

/*/{Protheus.doc} status5
Serviço de Pedidos
@author Marcelo Toscano
@since 16/04/2020
@version 1.0
@return ${return}, ${return_description}
@example http://ecoriindustria106258.protheus.cloudtotvs.com.br:4050/REST/ecoriws/status5
@source RESTECORI
@type function
SE TIVER BOLETO E O PEDIDO AINDA NÃO FOI LIBERADO DE NADA
/*/
WSMETHOD GET cgCinco WSSERVICE ecoriws

   Local cRet      := ""
   Local aCab      := {} //Titulo dos campos
   Local aLin      := {} //Itens
   Local _cEmp     := ""
   Local _cFil     := ""
   Local cSQL      := ""
   Local _cDoc     := ""
   Local _cPed     := ""

   // define o tipo de retorno do metodo
   ::SetContentType("application/json")
   ::SetHeader('Access-Control-Allow-Credentials' , "true")
   _cEmp     := Self:GetHeader('cEmp')
   _cFil     := Self:GetHeader('cFil')
   _cDoc     := Self:GetHeader('cDoc')
   _cPed     := Self:GetHeader('cPed')

   RpcSetType(3)  // ABRE O AMBIENTE NO PROTHEUS
   RpcSetEnv(_cEmp, _cFil,,,"PCP")

   cSQL := " SELECT C5_NUM PEDIDO, C5_FILIAL, C9_NFISCAL, 'NF-e GERADA' status"
   cSQL += " FROM SC5010 C5 (NOLOCK) "
   cSQL += " INNER JOIN SC9010 C9 ON C9_FILIAL = C5_FILIAL"
   cSQL += " AND C9_PEDIDO = C5_NUM"
   cSQL += " WHERE C9.D_E_L_E_T_ <> '*'"
   cSQL += " AND C9.C9_BLCRED = '10'"
   cSQL += " AND C9.C9_BLEST = '10'"
   cSQL += " AND C9.C9_NFISCAL != ''"
   cSQL += " AND C5.C5_NUM = '"+_cPed+"'"

   cSQL :=  ChangeQuery(cSQL)
   TCQUERY cSQL NEW ALIAS "QRYC2"
   DbSelectArea("QRYC2")
   While !Eof()
         //_total := _total + 1
         AADD(aLin,{ EncodeUTF8(QRYC2->status, "cp1252"), QRYC2->C9_NFISCAL } )
         //AADD(aLin,{ QRYC2->C5_NUM, QRYC2->C5_CLIENTE, QRYC2->C5_LOJACLI, QRYC2->C5_TRANSP, QRYC2->C5_EMISSAO, QRYC2->C5_TPFRETE, QRYC2->C5_FECENT, QRYC2->C5_X_DTECL, QRYC2->A1_NOME, QRYC2->A1_PESSOA, QRYC2->A1_CGC,  } )
         DbSelectArea("QRYC2")
         dbSkip()
   End

   aCab := {'status','nfiscal'}
   //AADD(aLin,{})
   cRet := U_CGAJSON( { "" , aCab, aLin} )

   ::SetResponse(cRet)
   RpcClearEnv() // FECHA O AMBIENTE DO PROTHEUS


return .T.


/*/{Protheus.doc} status5
Serviço de Pedidos
@author Marcelo Toscano
@since 16/04/2020
@version 1.0
@return ${return}, ${return_description}
@example http://ecoriindustria106258.protheus.cloudtotvs.com.br:4050/REST/ecoriws/status5
@source RESTECORI
@type function
SE TIVER BOLETO E O PEDIDO AINDA NÃO FOI LIBERADO DE NADA
/*/
WSMETHOD GET cgPedItem WSSERVICE ecoriws

   Local cRet      := ""
   Local aCab      := {} //Titulo dos campos
   Local aLin      := {} //Itens
   Local _cEmp     := ""
   Local _cFil     := ""
   Local cSQL      := ""
   Local _cDoc     := ""
   Local _cPed     := ""

   // define o tipo de retorno do metodo
   ::SetContentType("application/json")
   ::SetHeader('Access-Control-Allow-Credentials' , "true")
   _cEmp     := Self:GetHeader('cEmp')
   _cFil     := Self:GetHeader('cFil')
   _cDoc     := Self:GetHeader('cDoc')
   _cPed     := Self:GetHeader('cPed')

   RpcSetType(3)  // ABRE O AMBIENTE NO PROTHEUS
   RpcSetEnv(_cEmp, _cFil,,,"PCP")

   cSQL := " SELECT *"
   cSQL += " FROM SC9010 (NOLOCK)"
   cSQL += " INNER JOIN SB1010 (NOLOCK)"
   cSQL += " ON SC9010.D_E_L_E_T_ <> '*'"
   cSQL += " AND SB1010.D_E_L_E_T_ <> '*'"
   cSQL += " AND SUBSTRING(C9_FILIAL, 1, 2) = SUBSTRING(B1_FILIAL, 1, 2)"
   cSQL += " AND C9_PRODUTO = B1_COD"
   cSQL += " WHERE C9_PEDIDO = '"+_cPed+"'"

   cSQL :=  ChangeQuery(cSQL)
   TCQUERY cSQL NEW ALIAS "QRYC2"
   DbSelectArea("QRYC2")
   While !Eof()
         //_total := _total + 1
         AADD(aLin,{ QRYC2->C9_PRODUTO, QRYC2->C9_QTDLIB } )
         //AADD(aLin,{ QRYC2->C5_NUM, QRYC2->C5_CLIENTE, QRYC2->C5_LOJACLI, QRYC2->C5_TRANSP, QRYC2->C5_EMISSAO, QRYC2->C5_TPFRETE, QRYC2->C5_FECENT, QRYC2->C5_X_DTECL, QRYC2->A1_NOME, QRYC2->A1_PESSOA, QRYC2->A1_CGC,  } )
         DbSelectArea("QRYC2")
         dbSkip()
   End

   aCab := {'produto','quantidade'}
   //AADD(aLin,{})
   cRet := U_CGAJSON( { "1" , aCab, aLin} )

   ::SetResponse(cRet)
   RpcClearEnv() // FECHA O AMBIENTE DO PROTHEUS


return .T.
//*******************************************************************************************************************
//                                          FUNCIONALIDADES AUXILIARES
//*******************************************************************************************************************
/*/{Protheus.doc} JSON
Gera txt no formato JSON
@author Marcelo Jose
@since 18/01/2017
@version 12
@param aGeraXML, array, descricao
@type function
/*/
User Function CGAJSON(aGeraXML)
   Local cJSON  := ""
   Local cTable := aGeraXML[1]
   Local aCab   := aGeraXML[2]
   Local aLin   := aGeraXML[3]
   Local C,L
   Local cLido  := ""

   If !Empty(cTable)
      cJSON += '['
   EndIf

   FOR L := 1 TO LEN( aLin )

      cJSON += '{'

      for C := 1 to Len( aCab )

         IF     VALTYPE(aLin[L][C]) == "C"
            cLido := AllTrim( aLin[L][C] )
            cLido := StrTran(cLido,CHR(10), "") // LF (NL line feed, new line)
            cLido := StrTran(cLido,CHR(13), "") // CR (carriage return)
            cLido := StrTran(cLido,CHR(8), "") // BS (backspace)
            cLido := StrTran(cLido,CHR(9), "") // TAB (horizontal tab)
            cConteudo := '"'+AllTrim(cLido)+'"'
         ELSEIF VALTYPE(aLin[L][C]) == "N"
            cConteudo := ALLTRIM(STR(aLin[L][C]))
         ELSEIF VALTYPE(aLin[L][C]) == "D"
            cConteudo := '"'+DTOC(aLin[L][C])+'"'
         ELSEIF VALTYPE(aLin[L][C]) == "L"
            cConteudo := IF(aLin[L][C], '"true"' , '"false"')
         ELSE
            cLido := AllTrim( aLin[L][C] )
            cLido := StrTran(cLido,CHR(10), "") // LF (NL line feed, new line)
            cLido := StrTran(cLido,CHR(13), "") // CR (carriage return)
            cLido := StrTran(cLido,CHR(8), "") // BS (backspace)
            cLido := StrTran(cLido,CHR(9), "") // TAB (horizontal tab)
            cConteudo := '"'+AllTrim(cLido)+'"'
         ENDIF

         cJSON += '"'+aCab[C]+'":' + cConteudo

         IF C < LEN(aCab)
            cJSON += ','
         ENDIF

      Next
      cJSON += '}'
      IF L < LEN(aLin)
         cJSON += ','
      ENDIF

   Next

   If !Empty(cTable)
      cJSON += ']'
   EndIf

Return( cJSON )
