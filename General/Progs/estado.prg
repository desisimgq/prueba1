*-------------
* Programa   : Estado.prg
* Objetivo   : Emitir reporte de estado de cuentas
* Fecha      : Miercoles 8/10/14
* Llamado por: P_Estado
*-------------
PARAMETERS nClie, dFi, dFf

InicioEstado()

Afecto_Facturas(nclie)
Afecto_RecibosdePago(nClie)
Afecto_NotasCreAplicadas(nClie)
Afecto_NotasdeCredito(nClie)
Afecto_NotasdeDebito(nClie)
CalculaSaldo(nClie,dFi,dFf)
Resumen()

SELECT TempoEstado
SELECT * FROM TempoEstado ORDER BY nCliente asc, cGrupo asc, ;
              nFactura asc, nClasi ASC INTO CURSOR c1
               
RETURN 

*-----------------------
FUNCTION Afecto_Facturas(nClie)
*-----------------------
LOCAL cTexSql

cTexSql = "Select * from Faccar where ncliente = ?nClie"
SQLEXEC(oVar.Conec,cTexSql,"Tempo")

SELECT Tempo
GO Top
DO WHILE !EOF()
	cKey_ = STR(Tempo.nCliente,5) + "FAC" + STR(Tempo.nFactura,7)	
    IF !SEEK(m.cKey_,"TempoEstado","cKey")
    	SELECT TempoEstado
    	APPEND BLANK
    	Replace TempoEstado.nCliente    WITH Tempo.nCliente
    	Replace TempoEstado.cTipoDoc    WITH "FAC"
    	Replace TempoEstado.nClasi      WITH 1
    	Replace TempoEstado.nDoc        WITH Tempo.nFactura
		Replace TempoEstado.dFecha      WITH Tempo.dFecFac
		Replace TempoEstado.nFactura    WITH Tempo.nFactura
		Replace TempoEstado.cGrupo      WITH "A"
		Replace TempoEstado.cKey        WITH cKey_
        *
        	
        IF Tempo.nEstado = 3 && Anulada
           m.nDm = 0
           Replace TempoEstado.nFalta WITH 0
        ELSE
           IF DATE() > Tempo.dFecVenci
              m.nDm = DATE() - Tempo.dFecVenci   
		   ELSE
              m.nDm = 0     
           endif
        ENDIF
        *
        IF Tempo.nSaldo > 0
           DO case
              CASE Tempo.nEstado = 3 && Anulada
                   Replace TempoEstado.dFecVen    WITH CTOD(" / / ")
              OTHERWISE
                   Replace TempoEstado.dFecVen    WITH IIF(ISNULL(Tempo.dFecVenci),CTOD(" / / "),Tempo.dFecVenci)
           ENDCASE
           Replace TempoEstado.nDiasMora  WITH IIF(m.nDm > 0, m.nDm, 0)
           Replace TempoEstado.cCancelado WITH "S"
        ELSE
           Replace TempoEstado.cCancelado WITH "N"
        ENDIF
        	   
    Endif

    IF Tempo.nEstado = 3 && Anulada
    	Replace TempoEstado.nDebito  WITH 0
    	Replace TempoEstado.nCredito WITH 0
    	Replace TempoEstado.cDescri  WITH "FACTURA ANULADA"
    ELSE
    	IF Tempo.nTipoFac = 1 && Factura de Contado
    		Replace TempoEstado.cDescri  WITH "FACTURA CONTADO"
    		Replace TempoEstado.nDebito  WITH Tempo.nTotal
    		Replace TempoEstado.nCredito WITH Tempo.nTotal
    		Replace TempoEstado.nSaldo   WITH 0.00
    	ELSE
    		Replace TempoEstado.cDescri  WITH "FACTURA CREDITO"
    		Replace TempoEstado.nDebito  WITH Tempo.nTotal
    		Replace TempoEstado.nSaldo   WITH Tempo.nTotal
    	endif
    ENDIF

	SELECT Tempo
	Skip
ENDDO
RETURN .t.


*----------------------------
FUNCTION Afecto_RecibosdePago(nClie)
*----------------------------
* ReciFac_Det.cTipo = F (Facturas)
*                     N (Nota de debito)
*-----
LOCAL cTexSql
cTexSql = "Select a.*, b.nNumdoc, b.dfecfac, b.ndiascre, b.dFecVenci, b.nMonto, " + ;
          "b.nAbono, b.nSaldo, b.ctipo from ReciFac_Enc a Left Join ReciFac_Det b " + ;
          "on a.nrecibo = b.nrecibo where a.ncliente = ?nclie" 

SQLEXEC(oVar.Conec,cTexSql,"Tempo")
SELECT Tempo
GO top
DO WHILE !EOF()
    IF Tempo.cTipo = "F"
	   cKey_ = STR(Tempo.ncliente,5) + "RPG" + STR(Tempo.nRecibo,5) + STR(Tempo.nNumdoc,7) 
    ELSE
	   cKey_ = STR(Tempo.ncliente,5) + "RDB" + STR(Tempo.nRecibo,5) + STR(Tempo.nNumDoc,7) 
    endif 

	SELECT TempoEstado
	IF !SEEK(m.cKey_,"TempoEstado","cKey")
		APPEND BLANK
   		Replace TempoEstado.nCliente    WITH Tempo.nCliente
    	Replace TempoEstado.nDoc        WITH Tempo.nRecibo
		Replace TempoEstado.dFecha      WITH Tempo.dFecReci
		Replace TempoEstado.nRecibo     WITH Tempo.nRecibo
		Replace TempoEstado.cKey        WITH cKey_
 	ENDIF

    IF Tempo.nEstado = 3 && Anulada
    	Replace TempoEstado.nDebito  WITH 0
    	Replace TempoEstado.nCredito WITH 0
    	Replace TempoEstado.cDescri  WITH "RECIBO ANULADO"
    ELSE
        IF Tempo.cTipo = "F"  && Factura
			Replace TempoEstado.nFactura    WITH Tempo.nNumdoc
    		Replace TempoEstado.cTipoDoc    WITH "RPG"
			Replace TempoEstado.cDescri     WITH "RECIBO FACTURA"
    	    Replace TempoEstado.nClasi      WITH 2
  		    Replace TempoEstado.cGrupo      WITH "A"
		ELSE && Nota de Debito
			Replace TempoEstado.nNotaDeb    WITH Tempo.nNumDoc
    		Replace TempoEstado.cTipoDoc    WITH "RDB"
			Replace TempoEstado.cDescri     WITH "RECIBO NOTADEB"
    	    Replace TempoEstado.nClasi      WITH 5
  		    Replace TempoEstado.cGrupo      WITH "B"
		Endif
        Replace TempoEstado.nCredito     WITH  Tempo.nAbono
        Replace TempoEstado.nSaldo       WITH  Tempo.nAbono
    ENDIF

   	
	SELECT Tempo
	Skip
ENDDO

RETURN .t.



*----------------------------
FUNCTION Afecto_NotasCreAplicadas(nClie)
*----------------------------
* NCAplicadas.cTipo = F (Facturas)
*                     N (Nota de debito)
*-----
LOCAL nRetVal 

cTex = "Select a.*, b.nNumDoc, b.dFecDoc, b.nDiasCre, b.dFecVenci, " +  ;
       "b.nMonto, b.nAbono, b.nSaldo, b.cTipo, b.nContador " + ;
       "from NotasCreA_Enc a Left Join NotasCreA_Det b " + ;
       "on a.nDocAplica = b.nDocAplica where a.ncliente = ?nclie"
                     
nRetVal = SQLEXEC(oVar.Conec,cTex,"Tempo")

IF nretVal < 0
   Errordis("Error en el acceso a Notas de Credito Aplicadas")
   RETURN .t.		
ENDIF

SELECT Tempo
GO top
DO WHILE !EOF()
    cKey_ = STR(Tempo.ncliente,5) + "NCA" + STR(Tempo.nDocAplica,5) + STR(Tempo.nNumDoc,7) 
    
	SELECT TempoEstado
	IF !SEEK(m.cKey_,"TempoEstado","cKey")
		APPEND BLANK
   		Replace TempoEstado.nCliente    WITH Tempo.nCliente
    	Replace TempoEstado.cTipoDoc    WITH "NCA"
    	Replace TempoEstado.nDoc        WITH Tempo.nDocAplica
		Replace TempoEstado.dFecha      WITH Tempo.dfecha
		Replace TempoEstado.nDocAplica  WITH Tempo.nDocAplica
		Replace TempoEstado.cKey        WITH cKey_
	ENDIF
	IF Tempo.nEstado = 3 && NotaCre Anulada
    	Replace TempoEstado.nDebito  WITH 0
    	Replace TempoEstado.nCredito WITH 0
        Replace TempoEstado.nClasi   WITH 7
		Replace TempoEstado.cGrupo   WITH "C"
    	Replace TempoEstado.cDescri  WITH "NCA ANULADA"
    ELSE
        DO case
        	CASE Tempo.cTipo = "F"  && Facturas
      			 Replace TempoEstado.nFactura    WITH Tempo.nNumDoc
      			 Replace TempoEstado.nNotaCre    WITH Tempo.nNotaCre
     	         Replace TempoEstado.nClasi      WITH 3
		         Replace TempoEstado.cGrupo      WITH "A"
		         Replace TempoEstado.cDescri     WITH "NCR A FACTURA"
        	CASE Tempo.cTipo = "N"  && Nota de Debito 
				 Replace TempoEstado.nNotaDeb    WITH Tempo.nNumDoc
      			 Replace TempoEstado.nNotaCre    WITH Tempo.nNotaCre
     	         Replace TempoEstado.nClasi      WITH 6
		         Replace TempoEstado.cGrupo      WITH "B"
		         Replace TempoEstado.cDescri     WITH "NCR A NOTADEB"
        ENDCASE
        Replace TempoEstado.nCredito     WITH  Tempo.nAbono
        Replace TempoEstado.nSaldo       WITH  Tempo.nAbono
 	ENDIF
    	
	SELECT Tempo
	Skip
ENDDO

RETURN .t.



*----------------------------
FUNCTION Afecto_NotasdeCredito(nClie,dFi,dFF)
*----------------------------
LOCAL cTexSql 

cTexSql = "Select * from NotasCre where nCliente = ?nclie"
                    
SQLEXEC(oVar.Conec,cTexSql,"Tempo")
SELECT Tempo
GO top
DO WHILE !EOF()
	cKey_ = STR(Tempo.ncliente,5) + "NCR" + STR(Tempo.nNotaCre,5)  
	SELECT TempoEstado
	IF !SEEK(m.cKey_,"TempoEstado","cKey")
		APPEND BLANK
   		Replace TempoEstado.nCliente    WITH Tempo.nCliente
    	Replace TempoEstado.cTipoDoc    WITH "NCR"
    	Replace TempoEstado.nClasi      WITH 7
    	Replace TempoEstado.nDoc        WITH Tempo.nNotaCre
		Replace TempoEstado.cDescri     WITH "NOTAS CREDITO"
		Replace TempoEstado.dFecha      WITH Tempo.dfecnc
		Replace TempoEstado.nNotaCre    WITH Tempo.nNotaCre
		Replace TempoEstado.cGrupo      WITH "C"
		Replace TempoEstado.cKey        WITH cKey_
 	ENDIF
    Replace TempoEstado.nCredito     WITH  Tempo.nSalNc
    Replace TempoEstado.nSaldo       WITH  Tempo.nSalNc
    	
	SELECT Tempo
	Skip
ENDDO

RETURN .t.

*----------------------------
FUNCTION Afecto_NotasdeDebito(nClie)
*----------------------------
LOCAL cTexSql 

cTexSql = "Select * from NotasDeb where nCliente = ?nclie"
                    
SQLEXEC(oVar.Conec,cTexSql,"Tempo")
SELECT Tempo
GO top
DO WHILE !EOF()
	cKey_ = STR(Tempo.ncliente,5) + "NDB" + STR(Tempo.nNotaDeb,5)  
	SELECT TempoEstado
	IF !SEEK(m.cKey_,"TempoEstado","cKey")
		APPEND BLANK
   		Replace TempoEstado.nCliente    WITH Tempo.nCliente
    	Replace TempoEstado.cTipoDoc    WITH "NDB"
    	Replace TempoEstado.nClasi      WITH 4
    	Replace TempoEstado.nDoc        WITH Tempo.nNotaDeb
		Replace TempoEstado.cDescri     WITH "NOTAS DEBITO"
		Replace TempoEstado.dFecha      WITH Tempo.dfecnd
		Replace TempoEstado.nNotaDeb    WITH Tempo.nNotaDeb
		Replace TempoEstado.cGrupo      WITH "B"
		Replace TempoEstado.cKey        WITH cKey_
 	ENDIF
    Replace TempoEstado.nDebito      WITH  Tempo.nSalnd
    Replace TempoEstado.nSaldo       WITH  Tempo.nSalnd
    	
	SELECT Tempo
	Skip
ENDDO

RETURN .t.


*--------------------
Function CalculaSaldo( nClie, dFi,dFf)
*--------------------
Local nCal,nVar,cTex,nNinicial, nSaldoFin
m.nSaldoFin = 0.00
m.nCal = 0
m.nVar = 0
*--
Averigua(dFi,dFf)  && Averigua el Saldo Inicial
*--
ctex = "PERIODO DEL " + dtoc(dfi) + " AL " + dtoc(dff)

SELECT TempoEstado
Replace ALL cperiodo WITH cTex

DELETE ALL FOR !((TempoEstado.dFecha >= m.dfi .and. TempoEstado.dFecha <= m.dff) .or. ;
                Empty(TempoEstado.dFecha) )

IF SqlSeek("Select * from Clientes where ncliente = ?varsql_",nclie)
   cNomClie_ = Resul.cNomClie
ELSE
   cNomClie_ = ""
ENDIF

SELECT TempoEstado
Replace ALL cNomClie   WITH cNomClie_ 

Select TempoEstado
SORT TO c2 on ncliente/a, cgrupo/a, nfactura/a, nClasi/a   

Select TempoEstado
zap
APPEND FROM c2
DELETE FILE c2.dbf
GO top
Do While !eof()
   m.nCal = m.nVar + TempoEstado.nDebito - TempoEstado.nCredito
   Replace TempoEstado.nSaldo with m.nCal 
   m.nVar = TempoEstado.nSaldo
   
   Select TempoEstado
   Skip
Enddo

Select TempoEstado
Go Bottom
If !eof()
   m.nSaldoFin = TempoEstado.nSaldo
   Replace all nSaldofin with m.nSaldoFin
endif   
Return .t.

*--------------------
Function Averigua( dFi,dFf) && Averigua el saldo inicial
*--------------------
Local nCal,nVar,cTex, nInicial
m.nCal = 0
m.nVar = 0

Select TempoEstado
SET FILTER TO dFecha < m.dfi
GO TOP
DO WHILE !EOF()
    m.nCal = m.nVar + TempoEstado.nDebito - TempoEstado.nCredito
    m.nVar = m.nCal
    SELECT tempoestado
    skip
ENDDO
m.nInicial = m.nCal
SELECT TempoEstado
SET FILTER TO 

If m.nInicial <> 0
	Select TempoEstado
	If m.nInicial > 0
	  Insert into TempoEstado (nCliente, cGrupo, nDebito,nCredito,nsaldo, cDescri,cTipoDoc) ;
	              value (m.nClie, "A", m.nInicial,0,m.nInicial,"SALDO INICIAL","IDE" )
	else
	  Insert into TempoEstado (nCliente, cGrupo, nDebito,ncredito,nSaldo,cDescri,cTipoDoc) ;
	              value (m.nClie, "A", 0,m.nInicial, m.nInicial,"SALDO INICIAL","ICR")  
	endif
endif	
Return .T.



*---------------
FUNCTION Resumen
*---------------
LOCAL x1,x2,x3,x4,x5,x6, y1,y2,y3,y4,y5,y6,y7,y8,nDeb_, nCre_, nSaldo_

SELECT Tempoestado

CALCULATE CNT(), SUM(ndebito)  FOR ctipodoc = "FAC" TO x1,y1
CALCULATE CNT(), SUM(ndebito)  FOR ctipodoc = "NDB" TO x2,y2
CALCULATE CNT(), SUM(ncredito) FOR ctipodoc = "RPG" TO x3,y3
CALCULATE CNT(), SUM(ncredito) FOR ctipodoc = "NCA" TO x4,y4
CALCULATE CNT(), SUM(ncredito) FOR ctipodoc = "NCR" TO x5,y5
CALCULATE CNT(), SUM(ncredito) FOR ctipodoc = "FAC" TO x6,y6
CALCULATE        SUM(ndebito)  FOR ctipodoc = "IDE" TO y7
CALCULATE        SUM(ncredito) FOR ctipodoc = "ICR" TO y8


m.nDeb_ = y1 + y2 + y7
m.nCre_ = y3 + y4 + y5 + y6 + y8
nSaldo_ = nDeb_ - nCre_

Replace ALL  ;
nFac1 WITH x1, nFac2 WITH y1,;
nNdb1 WITH x2, nNdb2 WITH y2,;
nRpg1 WITH x3, nRpg2 WITH y3,;
nNca1 WITH x4, nNca2 WITH y4,;
nNcr1 WITH x5, nNcr2 WITH y5,;
nFac3 WITH x6, nFac4 WITH y6,;
nIdeb WITH y7, Nicre WITH y8,;
nTotDeb  WITH nDeb_,;
nTotcre  with nCre_,;
nSaldoRe with nSaldo_

RETURN .t.


*--------------------
FUNCTION InicioEstado
*--------------------
CREATE CURSOR TempoEstado (nCliente n(5,0), cTipoDoc c(3), nDoc n(8), nClasi n(1,0), cGrupo c(1), ;
                           nFactura n(7), nRecibo n(5,0), nNotaDeb n(5,0),nDocAplica n(5,0), nNotaCre n(5,0), cDescri c(15), dFecha d, nDebito n(12,2), nCredito n(12,2), ;
                           nSaldo n(12,2), dFecVen d, nDiasMora n(4,0), nFalta n(12,2) , ;
                           cCancelado c(1), cKey c(23) unique, cPeriodo c(40), cNomClie c(40), nSaldoFin n(12,2), ;
                           nIdeb n(12,2), nIcre n(12,2), ;
						   nFac1 n(6,0), nFac2 n(10,2), ;
						   nNdb1 n(6,0), nNdb2 n(10,2), ;
						   nRpg1 n(6,0), nRpg2 n(10,2), ;
						   nNca1 n(6,0), nNca2 n(10,2), ;
						   nNcr1 n(6,0), nNcr2 n(10,2), ;
						   nFac3 n(6,0), nFac4 n(10,2), ;
						   nTotDeb n(10,2), nTotcre n(10,2), ;
						   nSaldoRe n(10,2))

RETURN .t.
