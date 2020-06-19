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

 WSMETHOD GET cgOpcon;
 DESCRIPTION EncodeUTF8("ECORI - Serviço consulta OPs");
 WSSYNTAX "/ecoriws/cgOpcon";
 PATH "/cgOpcon";
 PRODUCES 'application/json;charset=utf-8'
 
 WSMETHOD GET cgEquipe;
 DESCRIPTION EncodeUTF8("ECORI - Serviço consulta Equipes");
 WSSYNTAX "/ecoriws/cgEquipe";
 PATH "/cgEquipe";
 PRODUCES 'application/json;charset=utf-8'
 
 WSMETHOD PUT cpAtuOPs;
 DESCRIPTION EncodeUTF8("ECORI - Serviço que Atualiza dados nas OPs");
 WSSYNTAX "/ecoriws/cpAtuOPs";
 PATH "/cpAtuOPs";
 PRODUCES 'application/json;charset=utf-8'

 WSMETHOD GET cgUsuarios;
 DESCRIPTION EncodeUTF8("ECORI - Serviço consulta de usuarios");
 WSSYNTAX "/ecoriws/cgUsuarios";
 PATH "/cgUsuarios";
 PRODUCES 'application/json;charset=utf-8'

 WSMETHOD GET cgPed;
 DESCRIPTION EncodeUTF8("ECORI - Serviço consulta OPs");
 WSSYNTAX "/ecoriws/cgPed";
 PATH "/cgPed";
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

/*/{Protheus.doc} cgOpcon
Serviço de OP's
@author Marcelo Jose
@since 06/03/2020
@version 1.0
@return ${return}, ${return_description}
@example http://ecoriindustria106258.protheus.cloudtotvs.com.br:4050/REST/ecoriws/cgOpSec
@source RESTECORI
@type function
/*/
WSMETHOD GET cgOpcon WSSERVICE ecoriws

   Local cRet      := ""
   Local aCab      := {} //Titulo dos campos
   Local aLin      := {} //Itens
   Local _cEmp     := ""
   Local _cFil     := ""
   Local _cTipo    := ""
   Local _cEquipe  := ""
   Local _cDataDe  := ""
   Local _cDataAte := ""
   Local cSql      := ""
   Local cStatus   := ""

   // define o tipo de retorno do metodo
   ::SetContentType("application/json")
   ::SetHeader('Access-Control-Allow-Credentials' , "true")
   _cEmp     := Self:GetHeader('cEmp')
   _cFil     := Self:GetHeader('cFil')
   _cTipo    := Self:GetHeader('cTipo') // 1=Somente OP's Abertas e/ou parcialmente atendidas;2=totalmente atendidas;3=todos status
   _cEquipe  := Self:GetHeader('cEquipe')
   _cDataDe  := Self:GetHeader('sDataDe')
   _cDataAte := Self:GetHeader('sDataAte')

   RpcSetType(3)  // ABRE O AMBIENTE NO PROTHEUS
   RpcSetEnv(_cEmp, _cFil,,,"PCP")

   aCab := {"Resultado","OP","Status","Emissao","Descricao","Qtde","Equipe","Confe","Conf1","Conf2","Conf3","Dt.Prev Ent","Dt.Real Ent."}
   If _cTipo $ "2/3" .and. Empty(_cDataDe) .and. Empty(_cDataAte)
      AADD(aLin,{"NO","","Para tipos 2 ou 3 um range de datas é obrigatório!","","","","","","","","","",""})
   Else
      cSQL := " SELECT SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_QUJE, SC2.C2_QUANT, SC2.C2_EMISSAO
      cSQL += ", SC2.C2_X_EQUIP, SC2.C2_X_CONFE, SC2.C2_X_CONF1, SC2.C2_X_CONF2, SC2.C2_X_CONF3 "
      cSQL += ", SC2.C2_DATPRF, SC2.C2_DATRF" // Data prevista de entrega - Data real de fim da OP
      cSQL += " , SB1.B1_DESC "
      cSQL += " FROM " + RetSqlName("SC2") + " SC2 "
      cSQL += " INNER JOIN " + RetSqlName("SB1")+ " SB1 ON (SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.B1_COD = SC2.C2_PRODUTO AND SB1.D_E_L_E_T_ = '' )"
      cSQL += " WHERE "
      cSQL += " SC2.C2_FILIAL = '" + xFilial("SC2") + "' "
      cSQL += " AND SC2.D_E_L_E_T_ <> '*' "
      If !Empty(_cTipo)
         If _cTipo == "1" // 1-Somente OP's Abertas e/ou parcialmente atendidas
            cSQL += " AND SC2.C2_QUJE <> SC2.C2_QUANT "
            cSQL += " AND SC2.C2_DATRF = '"+SPACE(TAMSX3("C2_DATRF")[1])+"' "
         Else
            If _cTipo == "2" // 2-Somente as totalmente atendidas
               cSQL += " AND SC2.C2_QUJE = SC2.C2_QUANT "
            EndIf
         EndIf
      EndIf
      If ! Empty(_cDataDe) .or. ! Empty(_cDataAte)
         cSQL += " AND SC2.C2_EMISSAO BETWEEN '"+_cDataDe+"' AND '"+_cDataAte+"' "
      EndIf
      If !Empty(_cEquipe)
         cSQL += " AND SC2.C2_X_EQUIP = '"+_cEquipe+"' "
      EndIf
      cSQL += " AND SC2.C2_SEQUEN = '001' "
      cSQL += " ORDER BY SC2.C2_NUM "
      cSQL :=  ChangeQuery(cSQL)
      TCQUERY cSQL NEW ALIAS "QRYC2"
      DbSelectArea("QRYC2")
      While !Eof()

         If QRYC2->C2_QUANT > QRYC2->C2_QUJE .and. QRYC2->C2_QUJE == 0
            cStatus := "1-Aberta sem apontamento"
         ElseIf QRYC2->C2_QUANT > QRYC2->C2_QUJE .and. QRYC2->C2_QUJE != 0
            cStatus := "2-Aberta Parcialmente atendida"
         Elseif QRYC2->C2_QUANT == QRYC2->C2_QUJE
            cStatus := "3-Atendida"
         Else
            cStatus := "9-Status não definido"
         EndIf

         AADD(aLin,{ "OK", QRYC2->C2_NUM+QRYC2->C2_ITEM, cStatus, QRYC2->C2_EMISSAO, PADR(QRYC2->B1_DESC,50),;
            cValToChar(QRYC2->C2_QUANT),;
            ALLTRIM(QRYC2->C2_X_EQUIP), ALLTRIM(QRYC2->C2_X_CONFE), ALLTRIM(QRYC2->C2_X_CONF1),;
            ALLTRIM(QRYC2->C2_X_CONF2), ALLTRIM(QRYC2->C2_X_CONF3),;
            ALLTRIM(QRYC2->C2_DATPRF), ALLTRIM(QRYC2->C2_DATRF) } )
         DbSelectArea("QRYC2")
         dbSkip()
      End
      If Len(aCab) <= 0
         AADD(aLin,{"NO","","Nao existe OP aberta ou parcialmente antendida.","","","","","","","","","",""})
      EndIf

      DbSelectArea("QRYC2")
      DbCloseArea()
   EndIf
   cRet := U_CGAJSON( { "" , aCab, aLin} )
   ::SetResponse(cRet)

   RpcClearEnv() // FECHA O AMBIENTE DO PROTHEUS

return .T.

/*/{Protheus.doc} cgEquipe
Consulta Equipes
@author Marcelo Jose
@since 10/03/2020
@version 1.0
@return ${return}, ${return_description}
@example http://ecoriindustria106258.protheus.cloudtotvs.com.br:4050/REST/ecoriws/cgEquipe
@source RESTECORI
@type function
/*/
WSMETHOD GET cgEquipe WSSERVICE ecoriws
   Local aCab  := {} //Titulo dos campos
   Local aLin  := {} //Itens
   Local _cEmp := ""
   Local _cFil := ""
   Local cRet  := ""

   // define o tipo de retorno do metodo
   ::SetContentType("application/json")
   ::SetHeader('Access-Control-Allow-Credentials' , "true")
   _cEmp     := Self:GetHeader('cEmp')
   _cFil     := Self:GetHeader('cFil')
   RpcSetType(3)  // ABRE O AMBIENTE NO PROTHEUS
   RpcSetEnv(_cEmp, _cFil,,,"PCP")

   aCab := {"Resultado","Codigo","Descricao"}

   dbSelectArea("SZ6")
   dbSetOrder(1)
   If DbSeek(xFilial("SZ6"))
      While !Eof() .and. SZ6->Z6_FILIAL == xFilial("SZ6")
         AADD(aLin,{"OK",SZ6->Z6_COD,SZ6->Z6_DESCRI})
         dbSkip()
      End
   Else
      AADD(aLin,{"NO","","Não achou Equipes para esta Empresa/Filial: "+cEmpAnt+"/"+cFilAnt})
   EndIf
   cRet := U_CGAJSON( { "" , aCab, aLin} )
   ::SetResponse(cRet)

   RpcClearEnv() // FECHA O AMBIENTE DO PROTHEUS

Return .T.

//{"ATUDATAPOP": [{"EQUIP":"","OPS":[{"OP":"","C2_X_CONFE":"","C2_X_CONF1":"",,"C2_X_CONF2":"",,"C2_X_CONF3":""},{"OP":"","C2_X_CONFE":"","C2_X_CONF1":"",,"C2_X_CONF2":"",,"C2_X_CONF3":""}]}]} 

/*/{Protheus.doc} cpAtuOPs
Atualiza OPs
@author Marcelo Jose
@since 10/03/2020
@version 1.0
@return ${return}, ${return_description}
@example http://ecoriindustria106258.protheus.cloudtotvs.com.br:4050/REST/ecoriws/cpAtuOPs
@source RESTECORI
@type function
/*/
WSMETHOD PUT cpAtuOPs WSSERVICE ecoriws
   Local aCab    := {} //Titulo dos campos
   Local aLin    := {} //Itens
   Local cRet    := ""
   Local _cEmp   := ""
   Local _cFil   := ""
   Local cBody   := ""
   Local nCtaFor := 1
   Local nCtaOps := 1

   Local oObjSon

   Local _cEquipe := ""

   Local cOP       := ""
   Local cC2XCONFE := ""
   Local cC2XCONF1 := ""
   Local cC2XCONF2 := ""
   Local cC2XCONF3 := ""

   // define o tipo de retorno do metodo
   ::SetContentType("application/json")
   ::SetHeader('Access-Control-Allow-Credentials' , "true")
   _cEmp     := Self:GetHeader('cEmp')
   _cFil     := Self:GetHeader('cFil')
   RpcSetType(3)  // ABRE O AMBIENTE NO PROTHEUS
   RpcSetEnv(_cEmp, _cFil,,,"PCP")

   aCab := {"Resultado","Codigo","Descricao"}
   cBody  := ::GetContent()

   If FWJsonDeserialize(cBody,@oObjSon)

      For nCtaFor := 1 To Len(oObjSon:ATUDATAPOP)

         _cEquipe := ALLTRIM( oObjSon:ATUDATAPOP[nCtaFor]:EQUIP )

         For nCtaOps := 1 To Len(oObjSon:ATUDATAPOP[nCtaFor]:OPS)
            cOP         := oObjSon:ATUDATAPOP[nCtaFor]:OPS[nCtaOps]:OP
            cC2XCONFE := oObjSon:ATUDATAPOP[nCtaFor]:OPS[nCtaOps]:C2_X_CONFE
            cC2XCONF1 := oObjSon:ATUDATAPOP[nCtaFor]:OPS[nCtaOps]:C2_X_CONF1
            cC2XCONF2 := oObjSon:ATUDATAPOP[nCtaFor]:OPS[nCtaOps]:C2_X_CONF2
            cC2XCONF3 := oObjSon:ATUDATAPOP[nCtaFor]:OPS[nCtaOps]:C2_X_CONF3
            dbSelectArea("SC2")
            dbSetOrder(1)
            If DbSeek(xFilial("SC2") + cOP + "001" )
               DbSelectArea("SC2")
               RecLock("SC2", .F.)
               SC2->C2_X_EQUIP := _cEquipe
               SC2->C2_X_CONFE := cC2XCONFE
               SC2->C2_X_CONF1 := cC2XCONF1
               SC2->C2_X_CONF2 := cC2XCONF2
               SC2->C2_X_CONF3 := cC2XCONF3
               MsUnlock()
            EndIf
         Next nCtaOps
      Next nCtaFor
      AADD(aLin,{"OK","","OPs atualizada com sucesso!"})
   Else
      AADD(aLin,{"NO","","Problema na deserialização do JSON!"})
   EndIf
   cRet := U_CGAJSON( { "" , aCab, aLin} )
   ::SetResponse(cRet)

   RpcClearEnv() // FECHA O AMBIENTE DO PROTHEUS

Return .T.


/*/{Protheus.doc} cgUsuarios
Consulta Equipes
@author Marcelo Jose
@since 12/03/2020
@version 1.0
@return ${return}, ${return_description}
@example http://ecoriindustria106258.protheus.cloudtotvs.com.br:4050/REST/ecoriws/cgUsuarios
@source RESTECORI
@type function
/*/
WSMETHOD GET cgUsuarios WSSERVICE ecoriws
   Local aCab      := {} //Titulo dos campos
   Local aLin      := {} //Itens
   Local _cEmp     := ""
   Local _cFil     := ""
   Local cRet      := ""

   Local aPswUsers := {}
   Local nCtaFor   := 1

   // define o tipo de retorno do metodo
   ::SetContentType("application/json")
   ::SetHeader('Access-Control-Allow-Credentials' , "true")
   _cEmp     := Self:GetHeader('cEmp')
   _cFil     := Self:GetHeader('cFil')
   RpcSetType(3)  // ABRE O AMBIENTE NO PROTHEUS
   RpcSetEnv(_cEmp, _cFil,,,"PCP")

   aCab := {"Resultado","Codigo","Descricao","Bloqueado"}

   aPswUsers := AllUsers() 
   For nCtaFor := 1 To Len(aPswUsers)
      AADD(aLin,{"OK",aPswUsers[nCtaFor,1,1],aPswUsers[nCtaFor,1,4],IIf(aPswUsers[nCtaFor,1,17]==.f.,"Nao","Sim")})
   Next

   If Len(aLin) <= 0
      AADD(aLin,{"NO","","Não achou Usuários para esta Empresa/Filial: "+cEmpAnt+"/"+cFilAnt,""})
   EndIf

   cRet := U_CGAJSON( { "" , aCab, aLin} )
   ::SetResponse(cRet)

   RpcClearEnv() // FECHA O AMBIENTE DO PROTHEUS

Return .T.



/*/{Protheus.doc} cgPed
Seriviço de Pedidos
@author Marcelo Toscano
@since 26/03/2020
@version 1.0
@return ${return}, ${return_description}
@example http://ecoriindustria106258.protheus.cloudtotvs.com.br:4050/REST/ecoriws/cgPed
@source RESTECORI
@type function
/ */
WSMETHOD GET cgPed WSSERVICE ecoriws

   Local cRet      := ""
   Local aCab      := {} //Titulo dos campos
   Local aLin      := {} //Itens
   Local cSql      := ""
   Local cStatus   := ""

   // define o tipo de retorno do metodo
   ::SetContentType("application/json")
   ::SetHeader('Access-Control-Allow-Credentials' , "true")

   RpcSetType(3)  // ABRE O AMBIENTE NO PROTHEUS
   RpcSetEnv(_cEmp, _cFil,,,"PCP")

cStatus := ""

cSQL := " SELECT C5_NUM PEDIDO, C5_CLIENTE COD_CLIENTE, C5_LOJACLI, C5_TRANSP COD_TRANSP, C5_EMISSAO DATA_EMISSAO, C5_TPFRETE TIPO_FRETE, C5_FECENT DATA_PREV_ENTREGA, C5_X_DTECL DATA_COMB_CLI_ENTREGA, A1_NOME RAZAO_SOCIAL, A1_PESSOA TIPO_PESSOA, A1_CGC CPF_CNPJ "
cSQL += " FROM SC5010 C5  INNER JOIN SA1010 A1 ON C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA AND A1.D_E_L_E_T_ <> '*' "
cSQL += " WHERE C5.D_E_L_E_T_ <> '*' ORDER BY C5_EMISSAO DESC "

      cSQL :=  ChangeQuery(cSQL)
      TCQUERY cSQL NEW ALIAS "QRYC2"
      DbSelectArea("QRYC2")
      While !Eof()
         /*
         If QRYC2->C2_QUANT > QRYC2->C2_QUJE .and. QRYC2->C2_QUJE == 0
            cStatus := "1-Aberta sem apontamento"
         ElseIf QRYC2->C2_QUANT > QRYC2->C2_QUJE .and. QRYC2->C2_QUJE != 0
            cStatus := "2-Aberta Parcialmente atendida"
         Elseif QRYC2->C2_QUANT == QRYC2->C2_QUJE
            cStatus := "3-Atendida"
         Else
            cStatus := "9-Status não definido"
         EndIf

         AADD(aLin,{ "OK", QRYC2->C2_NUM+QRYC2->C2_ITEM, cStatus, QRYC2->C2_EMISSAO, PADR(QRYC2->B1_DESC,50),;
            cValToChar(QRYC2->C2_QUANT),;
            ALLTRIM(QRYC2->C2_X_EQUIP), ALLTRIM(QRYC2->C2_X_CONFE), ALLTRIM(QRYC2->C2_X_CONF1),;
            ALLTRIM(QRYC2->C2_X_CONF2), ALLTRIM(QRYC2->C2_X_CONF3),;
            ALLTRIM(QRYC2->C2_DATPRF), ALLTRIM(QRYC2->C2_DATRF) } )
         */
         DbSelectArea("QRYC2")
         dbSkip()
      End
      If Len(aCab) <= 0
         AADD(aLin,{"NO","","Nao existe OP aberta ou parcialmente antendida.","","","","","","","","","",""})
      EndIf

      DbSelectArea("QRYC2")
      DbCloseArea()
   
   cRet := U_CGAJSON( { "" , aCab, aLin} )
   ::SetResponse(cRet)

   RpcClearEnv() // FECHA O AMBIENTE DO PROTHEUS

return .T.
//###############################################################################################


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
      cJSON += '{"'+cTable+'": ['
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
      cJSON += ']}'
   EndIf

Return( cJSON )
