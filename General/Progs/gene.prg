Clear
Close Database All
*--
Public cTipoUser,cEmpresa,cPathInicial,cSistema,;
       cPeriodo,cDesMes,cReporte,cBasedeDatos, ;
       cUsuario,cTipoMensaje,cDesmes,cPeriodo, ;
       lSonido_Inicio,lSonido_Agente,cBasedeDatos


m.cTipoMensaje   = "P"
m.cTipoUser      = "O"
m.cEmpresa       = "DESARROLLO DE SISTEMAS"
m.cPathInicial   = "c:\arenas\general\"
m.cSistema       = "SISTEMA GENERAL"
m.cReporte       = "Reporte de Prueba"
*m.cBasedeDatos   = "GENERAL"
m.cUsuario       = "SERGIO"
m.lSonido_Inicio = .t.
m.lSonido_Agente = .t.
*m.cBasedeDatos   = ".\data\GENERAL"

Store ctod(" / / ") to m.dFeci,m.dFecf
cd (m.cPathInicial)
Set Default to &cPathInicial
Set Path to DATA;INCLUDE;FORMS;GRAPHICS;HELP;LIBS;MENUS;PROGS;REPORTS;LABELS
Set Procedure to .\progs\utility.prg
Set Procedure to .\progs\Thermo.prg Additive
Set clock Status
Set status Bar on
Set Talk OFF
Set Date British
Set Century on
Set Deleted on
Set Safety off
Set Color to w+/bg
Set Nulldisplay to ""
SET MULTILOCKS ON

do CargaVar
oVar.cUsuario = "PROBANDO"
FOR i = 1 TO Numopc
    aseguri(i,1) = 0
    aseguri(i,2) = 0
    aseguri(i,3) = 0    
ENDFOR

clear
Modify Projec general.pjx in screen nowait save