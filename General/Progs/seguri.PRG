Public lRestri_
lRestri_ = .f.
CreaArchi()
if Averigua() = 27
   Return
Endif
Afecta()   
return

*----------------
Function Averigua
*----------------
Local cTex 

cTex = "El sistema a detectado anomalias, favor llamar" + chr(13) + ;
       "al desarollador del sistema, Gracias" 

Use c:\windows\Segui in 0
Select Segui
If Segui.lVigilar
   If Segui.nVeces > 0
      If Segui.nVeces = Segui.nRestri
         Replace Segui.nReinten with Segui.nReinten + 1
         Replace Segui.dReinten with dateTime()
         Messagebox(cTex,(0+48+0),"Mensaje")
         Use In Segui
         m.lRestri_ = .t.
         Return 27 
      Endif   
      if Date() = Segui.dRestri
         Replace Segui.nReinten with Segui.nReinten + 1
         Replace Segui.dReinten with dateTime()
         Messagebox(cTex,(0+48+0),"Mensaje")
         m.lRestri_ = .t.
         return 27
      Endif    
   endif
Endif   
Return 0

*------------
Function CreaArchi
*------------
If !file("c:\windows\segui.dbf")
   Create Table c:\windows\segui (dFecIni t, nVeces n(14), dFecUlt t, nRestri n(14), ;
                                dRestri d, lVigilar l, nReinten n(14), dReinten t) 
   Append Blank
   Replace Segui.lVigilar with .t.
   Replace segui.dRestri  with ctod("06/05/2000")
   Replace Segui.nRestri  with 15
   Use in segui
endif
Return

*--------------
Function Afecta
*--------------
if Empty(Segui.dFecIni)
   Replace segui.dFecIni with DateTime()
endif
Replace Segui.nVeces with Segui.nVeces + 1
Replace Segui.dFecUlt with datetime()
Use in Segui      