*----------
* Programa: RevisaCatalogo.prg
* Objetivo: Validar Catalogo de Cuentas
*----------
* (A,B) A = Empresa, B = Servidor
* 1=17, 2=18, 3=Local
PARAMETERS nEmp_, nSer_ 
InicioRevisaCatalogo(nEmp_,nSer_)

RevisoNiveles3() && Reviso si tiene asignado nivel si es >= 1 y <= 5, Reviso si el tipo de cuenta es mayor o detalle, 
                  * Reviso si la naturaleza de la cuenta tiene informacion, * Reviso si la moneda es correcta
RevisoNiveles1() && Reviso si los niveles estan bien asignados segun los campos llenados
RevisoNiveles2() && Reviso si existe un nivel superior

IF ncontaerror > 0
   cTex = "Revision finalizada" + CHR(13) + ;
          "Se detectaron " + ALLTRIM(STR(nContaerror,3)) + " errores"
   messagebox(cTex,16,"Revision de Catalogo") 
ELSE
   cTex = "Revision finalizada exitosamente sin errores"                   
   messagebox(cTex,64,"Revision de Catalogo") 
ENDIF

DesconectarBases()
RETURN 


*---------------------
FUNCTION RevisoNiveles1
*---------------------
* Reviso los niveles si estan bien asignados
LOCAL lBandera 

SELECT Revisar
GO top
DO WHILE !EOF()
   m.lBandera = .f.
   DO case
      CASE Revisar.nnivel = 1
           Var1 = SUBSTR(Revisar.ccuenta,5,10)
           IF val(var1) > 0
              lBandera = .t.
           endif   
      CASE Revisar.nnivel = 2
           Var1 = SUBSTR(Revisar.ccuenta,7,8)
           IF val(var1) > 0
              lBandera = .t.
           endif   
      CASE Revisar.nnivel = 3
           Var1 = SUBSTR(Revisar.ccuenta,9,6)
           IF val(var1) > 0
              lBandera = .t.
           endif   
      CASE Revisar.nnivel = 4
           Var1 = SUBSTR(Revisar.ccuenta,13,2)
           IF val(var1) > 0
              lBandera = .t.
           endif   
      CASE Revisar.nnivel = 5
           Var1 = LEN(ALLTRIM(Revisar.ccuenta))
           IF var1 <> 14
              lBandera = .t.
           endif   
   ENDCASE
   
   IF m.lBandera
      cTex = "Error en cuenta, nivel incorrectamente asignado" + CHR(13) + ; 
             "Cuenta: " + TRANSFORM(Revisar.ccuenta,"@R 9999-99-99-9999-99") + CHR(13) + ;
             "Descripción: " + ALLTRIM(Revisar.cDescuenta)
             messagebox(cTex,48,"Revision de Catalogo") 
      nContaError = nContaError + 1       
   endif   

   SELECT Revisar
   Skip
ENDDO
RETURN .t.

*----------------------
FUNCTION REVISONIVELES2
*----------------------
* Reviso si existe un nivel superior
LOCAL lBandera

SELECT Revisar
GO top
DO WHILE !eof()
   m.lBandera = .f.
   DO CASE 
      CASE Revisar.nNivel = 2
           var1 = SUBSTR(Revisar.ccuenta,1,4) 
           var2 = PADR(var1,14,"0")
           var3 = TRANSFORM(var2,"@R 9999-99-99-9999-99")
           IF !SEEK(var2,"Tabcuentas","tabcuentas")
              lbandera = .t.
           endif
      CASE Revisar.nNivel = 3
           var1 = SUBSTR(Revisar.ccuenta,1,6) 
           var2 = PADR(var1,14,"0")
           var3 = TRANSFORM(var2,"@R 9999-99-99-9999-99")
           IF !SEEK(var2,"Tabcuentas","tabcuentas")
              lbandera = .t.
           endif
      CASE Revisar.nNivel = 4
           var1 = SUBSTR(Revisar.ccuenta,1,8) 
           var2 = PADR(var1,14,"0")
           var3 = TRANSFORM(var2,"@R 9999-99-99-9999-99")
           IF !SEEK(var2,"Tabcuentas","tabcuentas")
              lbandera = .t.
           endif
      CASE Revisar.nNivel = 5
           var1 = SUBSTR(Revisar.ccuenta,1,12) 
           var2 = PADR(var1,14,"0")
           var3 = TRANSFORM(var2,"@R 9999-99-99-9999-99")
           IF !SEEK(var2,"Tabcuentas","tabcuentas")
              lbandera = .t.
           endif
   ENDCASE
   
   IF lBandera
      ctex = "No existe el nivel " + STR((Revisar.nnivel - 1),1) + CHR(13) + ;
             "Cuenta: " + var3
      messagebox(cTex,48,"Revision de Catalogo") 
      nContaError = nContaError + 1       
   ENDIF
   
   SELECT Revisar
   SKIP
  
ENDDO
RETURN .t.

*---------------------
FUNCTION RevisoNiveles3
*---------------------
* Reviso si tiene asignado nivel
* Reviso si el tipo de cuenta es mayor o detalle
* Reviso si la naturaleza de la cuenta tiene informacion
* Reviso si la moneda es correcta
SELECT Revisar
GO top
DO WHILE !EOF()
   * Reviso si la cuenta tiene 14 digitos
   IF LEN(ALLTRIM(STRTRAN(Revisar.ccuenta," ",""))) <> 14
      cTex = "Cuenta contable incompleta, menor a 14 digitos o con espacios en blanco"  + CHR(13) + ; 
             TRANSFORM(Revisar.ccuenta,"@R 9999-99-99-9999-99") + CHR(13) + ;
             Revisar.cDescuenta
      messagebox(cTex,48,"Revision de Catalogo") 
      nContaError = nContaError + 1       
   endif   

   * Reviso si tiene nivel asignado
   IF Revisar.nnivel <= 0 .or. Revisar.nnivel >= 6
      cTex = "No tiene asignado nivel correcto: "  + CHR(13) + ; 
             TRANSFORM(Revisar.ccuenta,"@R 9999-99-99-9999-99") + CHR(13) + ;
             Revisar.cDescuenta + CHR(13) + ;
             "Nivel: " + STR(Revisar.nnivel,1)
      messagebox(cTex,48,"Revision de Catalogo") 
      nContaError = nContaError + 1       
   endif   

   * Reviso si el tipo de cuenta es mayor o detalle
   IF !INLIST(Revisar.cTipoCuen,"M","D") 
      cTex = "Cuenta no es Mayor ni Detalle: "  + CHR(13) + ; 
             TRANSFORM(Revisar.ccuenta,"@R 9999-99-99-9999-99")
      messagebox(cTex,48,"Revision de Catalogo") 
      nContaError = nContaError + 1       
   endif

   * Reviso si la naturaleza de la cuenta tiene informacion
   IF !INLIST(Revisar.cnatura,"A","D","C") 
      cTex = "Naturaleza de la cuenta es incorrecta: "  + CHR(13) + ; 
             TRANSFORM(Revisar.ccuenta,"@R 9999-99-99-9999-99")
      messagebox(cTex,48,"Revision de Catalogo") 
      nContaError = nContaError + 1       
   endif

   * Reviso si la moneda es correcta
   IF !INLIST(Revisar.cmoneda,"D","C") 
      cTex = "Tipo de moneda incorrecto en la cuenta: "  + CHR(13) + ; 
             TRANSFORM(Revisar.ccuenta,"@R 9999-99-99-9999-99")
      messagebox(cTex,48,"Revision de Catalogo") 
      nContaError = nContaError + 1       
   endif

   SELECT Revisar
   Skip
ENDDO
RETURN .t.

*--------------
FUNCTION InicioRevisaCatalogo(nCodEmp_, nTipoSer_)
*--------------
CLOSE DATABASES all
PUBLIC nCodigoEmpresa,nTipoServidor
PUBLIC cCadenaConexionGeneral, cConecGeneral, IpServer_, nContaError


nCodigoEmpresa        = nCodEmp_  && 1 = Imisa, 2 = Arenas, 3 = Canteras, 4 = Calizas, 5 = Hotel
nTipoServidor         = nTipoSer_ &&(1 = Servidor de datos, 2 = Local)
nContaError           = 0
DO case
   CASE nTipoServidor = 1 && Servidor de Bases de Datos (192.168.40.17)
        IpServer_ = "192.168.40.17"
   CASE nTipoServidor = 2 && Servidor de Bases de Datos (192.168.40.18)
        IpServer_ = "192.168.40.18"
   CASE nTipoServidor = 3 && Servidor Local en equipo
		IpServer_ = "127.0.0.1"
ENDCASE


DO case
      CASE nCodigoEmpresa = 1 && Imisa
           cCadenaConexionGeneral      = "DSN=General;SERVER      = " + ipserver_ + ";UID=general;PWD=@X%Q!HQCrSv7j9aD8jYU;DATABASE=General1;PORT=3306"
      CASE nCodigoEmpresa = 2 && Arenas                                                       
           cCadenaConexionGeneral      = "DSN=General;SERVER      = " + ipserver_ + ";UID=general;PWD=@X%Q!HQCrSv7j9aD8jYU;DATABASE=General2;PORT=3306"
      CASE nCodigoEmpresa = 3 && Canteras                                                       
           cCadenaConexionGeneral      = "DSN=General;SERVER      = " + ipserver_ + ";UID=general;PWD=@X%Q!HQCrSv7j9aD8jYU;DATABASE=General3;PORT=3306"
      CASE nCodigoEmpresa = 4 && Calizas                                                      
           cCadenaConexionGeneral      = "DSN=General;SERVER      = " + ipserver_ + ";UID=general;PWD=@X%Q!HQCrSv7j9aD8jYU;DATABASE=General4;PORT=3306"
      CASE nCodigoEmpresa = 5 && Hotel                                                      
           cCadenaConexionGeneral      = "DSN=General;SERVER      = " + ipserver_ + ";UID=general;PWD=@X%Q!HQCrSv7j9aD8jYU;DATABASE=General5;PORT=3306"
ENDCASE
ConectarGeneral()
ok1 = SQLEXEC(cConecGeneral,"Select * from Tabcuentas","Revisar")
ok2 = SQLEXEC(cConecGeneral,"Select * from Tabcuentas","Tabcuentas")
SELECT Tabcuentas
INDEX on ccuenta TO Tabcuentas
RETURN .t.

*----------------------
FUNCTION ConectarGeneral
*----------------------
* Objetivo: Realizar conexion con base de datos de Sistema General
*--
cconecGeneral = Sqlstringconnect(cCadenaConexiongeneral,.T.)
If cconecGeneral <=0
   Messagebox("No hay conexion con la Base de datos General, Comunicarse con el Area de Desarrollo." + Message(), ;
			   16, "No hay conexion")
   Quit
Endif
RETURN .t.

*------------------------
FUNCTION DesconectarBases
*------------------------
* Objetivo: Realizar desconexion de las bases de datos de Nomina y General
*--
If  SQLIdleDisconnect(cconecGeneral) >= 1  && Desconecto General
	=SQLDisconnect(cconecGeneral)
ENDIF
RETURN .t.