_Screen.Visible = .f.

*--
IF F_ActivaWin("SISTEMA GENERAL")
    * El programa ya estaba activo:
    RETURN && Termina el programa
ENDIF

Clear
SET SYSMENU off
Clear All

Public cTipoUser,cEmpresa,cSistema, cPathInicial, ;
       cPeriodo ,cDesMes , cReporte,dFecI,dFecF, ;
       cDesktop,nDesktop , nTipoNom, cUsuario, ;
       cTipoMensaje,lSonido_Agente,conect,cBasedeDatos
       
Set Procedure to &oVar.cPathInicial.\progs\utility, &oVar.cPathInicial.\progs\Thermo

do CargaVar






*-do forms .\forms\Presenta
_Screen.Visible = .f.
*=Inkey(5)

*---

*PUSH MENU _msysmenu
SET CLASSLIB TO libs\sergiolib ADDITIVE

ON SHUTDOWN ShutDown()


*-------------------------------------------------------------
*ON ERROR ErrorHandler(ERROR(),PROGRAM(),LINENO())
ON ERROR DO VerError WITH ;
   ERROR( ), MESSAGE( ), MESSAGE(1), PROGRAM( ), LINENO( )
*-------------------------------------------------------------


_shell="DO Cleanup IN progs\Sistema"
_Screen.Caption=oVar.cSistema


*-- Inicializa la aplicación Objeto
RELEASE goApp
PUBLIC goApp
goApp=CREATEOBJECT("Aplicacion")


*-- Configura la aplicación Objeto
goApp.SetCaption(oVar.cSistema)
goApp.cStartupForm="Forms\Inicio"
goApp.Show
RELEASE goApp
RETURN


*------------------------------------------
FUNCTION ErrorHandler(nError,cMethod,nLine)
*------------------------------------------
LOCAL lcErrorMsg,lcCodeLineMsg
WAIT CLEAR
lcErrorMsg=MESSAGE()+CHR(13)+CHR(13)
lcErrorMsg=lcErrorMsg+"Method:    "+cMethod
lcCodeLineMsg=MESSAGE(1)
IF BETWEEN(nLine,1,10000) AND NOT lcCodeLineMsg="..."
	lcErrorMsg=lcErrorMsg+CHR(13)+"Line:         "+ALLTRIM(STR(nLine))
	IF NOT EMPTY(lcCodeLineMsg)
		lcErrorMsg=lcErrorMsg+CHR(13)+CHR(13)+lcCodeLineMsg
	ENDIF
ENDIF

IF MESSAGEBOX(lcErrorMsg,16,_screen.Caption)#1
*   ON ERROR
*   RETURN .F.
ENDIF
ENDFUNC

*-------------------------------------------------------------
*ON ERROR DO errHandler WITH ;
   ERROR( ), MESSAGE( ), MESSAGE(1), PROGRAM( ), LINENO( )
*USE nodatabase  
*ON ERROR  && Restores system error handler.

*-----------------
PROCEDURE VerError
*-----------------
   PARAMETER merror, mess, mess1, mprog, mlineno
   LOCAL cTex
   
   CLEAR
   cTex =  'Numero de error: ' + LTRIM(STR(merror)) + CHR(13) + ;
           'Mensaje de error: ' + mess + CHR(13) + ;
           'Linea del codigo de error: ' + mess1 + CHR(13) + ;
           'Numero de linea del error : ' + LTRIM(STR(mlineno)) + CHR(13) + ;
           'Procedimiento del error: ' + mprog
   messagebox(cTex,32+0+0,"Error")
   
ENDPROC

*-------------------------------------------------------------

  
*----------------
FUNCTION ShutDown
*----------------
IF TYPE("goApp")=="O" AND NOT ISNULL(goApp)
   RETURN goApp.OnShutDown()
ENDIF
Cleanup()
QUIT
ENDFUNC

*---------------
FUNCTION Cleanup
*---------------
IF CNTBAR("_msysmenu")=7
	RETURN
ENDIF
ON ERROR
ON SHUTDOWN
SET CLASSLIB TO
SET PATH TO
CLEAR ALL
CLOSE ALL
POP MENU _msysmenu
RETURN




* Y ESTA ES LA FUNCION QUE LO HACE TODO:
*-----------------------------
FUNCTION F_ActivaWin(cCaption)
*-----------------------------
LOCAL nHWD
DECLARE INTEGER FindWindow IN WIN32API ;
STRING cNULL, ;
STRING cWinName

DECLARE SetForegroundWindow IN WIN32API ;
INTEGER nHandle

DECLARE SetActiveWindow IN WIN32API ;
INTEGER nHandle

DECLARE ShowWindow IN WIN32API ;
INTEGER nHandle, ;
INTEGER nState

nHWD = FindWindow(0, cCaption)
IF nHWD > 0
    * VENTANA YA ACTIVA
    * LA "LLAMAMOS":
    ShowWindow(nHWD,9)

    * LA PONEMOS ENCIMA
    SetForegroundWindow(nHWD)

    * LA ACTIVAMOS
    SetActiveWindow(nHWD)


    _Screen.WindowState=2  
    _Screen.LockScreen=.F.                     && Activa el redibujado de pantalla
    _Screen.Visible = .t.
    _Screen.refresh
     
    RETURN .T.
ELSE
    * VENTANA NO ACTIVA
    RETURN .F.
ENDIF

