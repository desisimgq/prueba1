*
* Cierre Mensual de inventario
*

*do Backup_HD

*BEGIN TRANSACTION
	
	set cursor off
	CreaThermo('Realizando Cierre Mensual..')
	cierre()
	indica()

	FOR i_ = 1 to 6
		Actuathermo(6,I_,"Espere un momento por Favor..")
		wait '' time 0.25
    	Do Case
	       Case i_ = 1
	            cierremensual.Pinv.value= 1
    	    	Inventar()
	       Case i_ = 2
	       		cierremensual.Pent.value= 1
				Entradas()
	       Case i_ = 3
	       		cierremensual.Psal.value= 1
				Salidas()
	       Case i_ = 4
	       		cierremensual.Pdev.value= 1
				Devoluciones()
	       Case i_ = 5
	       		cierremensual.Pajus.value= 1
				AjusteF()
		   Case i_ = 6
				AjusteM()
	    Endcase
	ENDFOR
	Finthermo()
	set cursor on

	    *   
*END TRANSACTION

MessageBox("El cierre mensual se realizo satisfactoriamente!",(0 + 64 + 0),"Cierre Mensual")

RETURN

*-----------------
FUNCTION cierre
*-----------------
LOCAL cKey_

cKey_ = PADL(Alltrim(Str(ovar.nMesProc,2)),2,"0") + PADL(alltrim(Str(oVar.nYearProc,4)),4,"0")

SELECT cierres
	Append Blank 
	Replace cierres.cKey         with cKey_
	Replace cierres.nMesProc     with oVar.nMesProc
	Replace cierres.nYearProc    with oVar.nYearProc
	Replace cierres.dPeriodoDe  with oVar.dPeriodoDe
	Replace cierres.dPeriodoAl   with oVar.dPeriodoAl
	Replace cierres.cUsuario     with oVar.cUsuario
	Replace cierres.dfechaHora   with dateTime()
	TABLEUPDATE(.t.,.f.,"cierres")
ENDFUNC 

*-----------------
FUNCTION indica()
*-----------------
	Select indicadora
	nMes_ = indicadora.nMesProc + 1
	nYear_= indicadora.nYearProc
	If nMes_ > 12
	   nYear_ = nYear_ + 1
	   nMes_  = 1  
	endif
	dPeriDe_ = ctod("01/" + Str(nMes_,2) + "/" + Str(nYear_,4))
	nD_ = Gomonth(dPeriDe_,1)
	dPeriAl_  = nD_ - day(nD_)
	        
	Replace indicadora.nMesProc    with m.nMes_
	Replace indicadora.nYearProc   with m.nYear_
	Replace indicadora.dPeriodoDe with m.dPeriDe_
	Replace indicadora.dPeriodoAl  with m.dPeriAl_    

	oVar.nMesproc    = indicadora.nMesProc 
	oVar.nYearProc   = indicadora.nYearProc
	oVar.dPeriodoDe = indicadora.dPeriodoDe
	oVar.dPeriodoAl  = indicadora.dPeriodoAl
	oVar.cDesmes     = "Mes de " + _cMeses(indicadora.nMesProc,"L") + ;
	                   " del " + Str(indicadora.nYearProc,4) 
	TABLEUPDATE(.t.,.f.,"indicadora")
ENDFUNC 

*----------------
Function Inventar
*----------------
Select inventar

Go Top
Scan
   Replace inventar.nIni_Ing   With inventar.nSaldo_Fis
   Replace inventar.nIni_Deb	With inventar.nSaldo_Cor
   *--
   *-- Igresos Fisicos 
   
   Replace inventar.nEntra_Ing with 0
   Replace inventar.nDevo_Ing  with 0
   Replace inventar.nAjus_Ing  with 0
   Replace inventar.nTot_Ing   with 0 
   *
   *-- Egresos Fisicos
   Replace inventar.nVenta_Egr with 0 
   Replace inventar.nRequi_Egr with 0    
   Replace inventar.nAjus_Egr  with 0 
   Replace inventar.nTot_Egr   with 0       
   *
   *-- Ingresos Financieros
   Replace inventar.nEntra_Deb with 0
   Replace inventar.nDevo_Deb  with 0
   Replace inventar.nAjus_Deb  with 0
   Replace inventar.nTot_Deb   with 0               
   *
   *-- Egresos Financieros
   Replace inventar.nVenta_Cre with 0
   Replace inventar.nrequi_Cre with 0
   Replace inventar.najus_Cre  with 0     
   Replace inventar.nTot_Cre   with 0            
   Suma_Saldos()
   
   TABLEUPDATE(.t.,.f.,"inventar")
EndScan
Return 1



*----------------
Function Entradas
*----------------
Select entradas_enc
Do While !eof()
   if (entradas_enc.nMesProc = oVar.nMesproc) .and. ;
      (entradas_enc.nYearProc = oVar.nYearProc)
      Replace entradas_enc.naplicado With 1
       TABLEUPDATE(.t.,.f.,"entradas_enc")
   endif   
   Skip
Enddo
return 1


*----------------
Function Salidas
*----------------
Select salidas_enc
Do While !eof()
   if (salidas_enc.nMesProc = oVar.nMesproc) .and. ;
      (salidas_enc.nYearProc = oVar.nYearProc)
      Replace salidas_enc.naplicado With 1
      TABLEUPDATE(.t.,.f.,"salidas_enc")
   endif   
   Skip
Enddo
return 1



*----------------
Function Devoluciones
*----------------
Select devolu_enc
Do While !eof()
   if (devolu_enc.nMesProc = oVar.nMesproc) .and. ;
      (devolu_enc.nYearProc = oVar.nYearProc)
      Replace devolu_enc.naplicado With 1
      TABLEUPDATE(.t.,.f.,"devolu_enc")
   endif   
   Skip
Enddo
return 1


*---------------
Function AjusteF
*---------------
Select ajuste_fis
Do While !eof()
   if (ajuste_fis.nMesProc = oVar.nMesproc) .and. ;
      (ajuste_fis.nYearProc = oVar.nYearProc)
      Replace ajuste_fis.naplicado With 1
      TABLEUPDATE(.t.,.f.,"ajuste_fis")
   endif   
   Skip
Enddo
return 1

*---------------
Function AjusteM
*---------------
Select ajuste_mon
Do While !eof()
   if (ajuste_mon.nMesProc = oVar.nMesproc) .and. ;
      (ajuste_mon.nYearProc = oVar.nYearProc)
      Replace ajuste_mon.naplicado With 1
      TABLEUPDATE(.t.,.f.,"ajuste_mon")
   endif   
   Skip
Enddo
return 1
*------------------
Function Suma_Saldos
*------------------

Local nIng, nEgr, nDeb, nCre

Select inventar
*-- 
m.nIng = inventar.nIni_Ing   +  ;
         inventar.nEntra_Ing + inventar.nDevo_Ing + ;
         inventar.nAjus_Ing 
*--
m.nEgr = inventar.nVenta_Egr + ;
         inventar.nRequi_Egr + ;
         inventar.nAjus_Egr 
*--
m.nDeb = inventar.nIni_Deb   + ;
         inventar.nEntra_Deb + inventar.nDevo_Deb  + ;
         inventar.nAjus_Deb  
*--
m.nCre = inventar.nVenta_Cre + ;
         inventar.nRequi_Cre + ;
         inventar.nAjus_Cre
*--
Replace inventar.nTot_Ing   with m.nIng
Replace inventar.nTot_Egr   with m.nEgr
Replace inventar.nTot_Deb   with m.nDeb
Replace inventar.nTot_Cre   with m.nCre 
*--
Replace inventar.nSaldo_Fis with m.nIng - m.nEgr
Replace inventar.nSaldo_Cor with m.nDeb - m.nCre
*--
Replace inventar.nCosto     with inventar.nSaldo_Cor / ;
                                 Iif(inventar.nSaldo_Fis <> 0, inventar.nSaldo_Fis,1)
                                 
TABLEUPDATE(.t.,.f.,"inventar")
Return 1
