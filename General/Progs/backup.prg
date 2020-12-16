Public cRutaCopia
Public nD_,nM_,nYc_,nYl_
dFec   = Date()
m.nM_  = Month(dfec)
m.nYc_ = Val(Right(Str(Year(dfec),4),2))
m.nYl_ = Year(dfec)
m.nD_  = Day(dFec)
if CopiaDiskette() = 27
   m.nBackup_ok = 27
   Return 27
endif   
Backup_ok = 0
*---
=CreaDirectorio() && Crea los Directorios
=CopiaArchivos()  && Copia los Archivos
*---

cCod = cCodNom()
Use Cierres in 0
Select Cierres

If !Seek(cCod,"Cierres","cCodnom")
   Append Blank
   replace cierres.cCodNom with cCod 
endif
Replace Cierres.dBackup with datetime()
Close dataBase all
Return 0

*---------------------
Function CopiaDiskette
*---------------------
Local nOpc
Close Database all

do While .t.
      nOpc = Messagebox("Ponga el diskette en que se hara el respaldo" + chr(13) + ;
                        "cuando este listo presione el Aceptar", ;
                       (64 + 1 + 0), "Respaldo")
      If nOpc <> 1
         Return 27
      endif     
      If diskspace("A") = -1
         nOpc2 = Messagebox("La Unidad de Diskette no esta lista",(64 + 5 + 0),"Respaldo")
         Do Case 
            Case nOpc2 = 2
                 Return 27
            Case nOpc2 = 4
                 Loop
         Endcase   
      endif   
      exit
Enddo      
    

If nOpc = 1
   cV   = strzero(m.nD_,2) + ;
          strzero(m.nM_,2) + ;
          Strzero(m.nYl_,4) + ".zip" 
   * dbf, cdx, ftp
   * dbc, dct, dcx
   cFil = "A:\" + cV 
   if file(cFil)
      nOpc3 = MessageBox("El archivos de respaldo " + Upper(cfil) + chr(13) + ;
                         "ya existe en el diskette, desea sobreescribir" + chr(13) + ;
                         "sobre este archivo?",(64 + 4 + 256),"Respaldo")

      If nOpc3 = 6  && Si
         Delete file &cFil RECYCLE
      else 
         Return 27            
      Endif
   endif

   cCaminoProg = "c:\Archivos de Programa\Winzip\Winzip32.exe"
   cDireccion  = cFil
   cPath       = "\sisper\king\semanal\data\"
   cCadena = m.cCaminoProg + " -A -R -EX " + m.cDireccion + " " + ;
             m.cPath + "*.d* " + ;
             m.cPath + "*.cdx "   && + ;
*             m.cPath + "*.fpt"
   Run /N1 &cCadena
   Inkey(3)
Else
   Return 27
Endif
Return 0

*---------------------
Function CopiaArchivos
*---------------------
Use data\Indica in 0

cV   = strzero(m.nYl_,4) + "\" +;
       Strzero(m.nM_,2) + "\" + Str(Indica.nSemana,1)
Use In Indica       
Close Database All
copy file data\Semanal.dbc to &cv
copy file data\Semanal.dct to &cv
copy file data\*.dbf to &cV
copy file data\*.cdx to &cV
*copy file data\*.fpt to &cV
Return


*----------------------
Function CreaDirectorio
*----------------------
Local cRuta
Use data\Indica in 0

cRuta = m.cPathInicial + "\Progs\Utility"
set procedure to (cRuta)
ON ERROR DO errBackup WITH 	ERROR( ), MESSAGE( ), MESSAGE(1), PROGRAM( ), LINENO( )
cV1 = strzero(m.nyL_,4)
cV2 = strzero(m.nM_,2)
cV3 = Str(Indica.nSemana,1)
Use in Indica

cd (m.cPathInicial)
Md (cV1)
cd (cv1)
Md (cV2)
cd (cv2)
Md (cv3)
cd (m.cPathInicial)
ON ERROR  && Restaurar el controlador de errores del sistema
Return

*----------------
PROCEDURE errBackup
*----------------
PARAMETER merror, mess, mess1, mprog, mlineno
do Case
   Case str(merror,4) = "1961"
*        cd (m.cPathInicial)
endcase   

*CLEAR
*? 'Número de error: ' + LTRIM(STR(merror))
*? 'Mensaje de error: ' + mess
*? 'Línea de código con error: ' + mess1
*? 'Número de línea del error: ' + LTRIM(STR(mlineno))
*? 'Programa con error: ' + mprog
Return