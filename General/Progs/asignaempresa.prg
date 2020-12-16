Parameters nCodEmp_,nTipoSer_
*--------------------------
*Empresas:
*1 = Imisa
*2 = Arenas
*3 = Canteras
*6 = Topacio
*Servidores:
*1 = Datos 17
*2 = Datos 18
*3 = Local

*--------------------------

Set Talk Off
Set Console Off
Set Safety Off

Desconectarbases()

ovar.nCodigoEmpresa   = nCodEmp_  && 1 = Imisa, 2 = Arenas
nTipoServidor         = nTipoSer_ &&(1 = Servidor de datos, 2 = Local)
*--
Do Case
Case nTipoServidor = 1 && Servidor de Bases de Datos (192.168.40.17)
	IpServer = "192.168.40.17"
	ovar.cServidor = "Datos 17"
Case nTipoServidor = 2 && Servidor de Bases de Datos (192.168.40.18)
	IpServer = "192.168.40.18"
	ovar.cServidor = "Datos 18"
Case nTipoServidor = 3 && Servidor Local en equipo
	IpServer = "127.0.0.1"
	ovar.cServidor = "Local"
Case nTipoServidor = 4 && Servidor PC 192.168.30.106
	IpServer = "192.168.30.106"
	ovar.cServidor = "PC4"

Endcase

Do Case
Case ovar.nCodigoEmpresa = 1 && Imisa
	ovar.cCadenaConexiontesoreria = "DSN=tesoreria;SERVER=" + IpServer + ";UID=tesoreria;PWD=gr!cA@rv&vPQM67T%9RF;DATABASE=tesoreria1;PORT=3306" &&conexion tesoreria
	ovar.cCadenaConexiongeneral = "DSN=General;SERVER=" + IpServer + ";UID=general;PWD=@X%Q!HQCrSv7j9aD8jYU;DATABASE=general1;PORT=3306" &&conexion general
	ovar.cCadenaConexionfacturacion = "DSN=facturacion;SERVER=" + IpServer + ";UID=facturacion;PWD=$n2BJb@Huv^x8dZMR^zY;DATABASE=facturacion2;PORT=3306" &&conexion facturacion
	ovar.cCadenaConexiongeneraluni="DSN=General;SERVER=" + IpServer + ";UID=general;PWD=@X%Q!HQCrSv7j9aD8jYU;DATABASE=general;PORT=3306" &&conexion general unificado"
	cCaminoLogo          = ".\logoi\logo-empresa.png"


Case ovar.nCodigoEmpresa = 2 && Arenas
	ovar.cCadenaConexiontesoreria = "DSN=tesoreria;SERVER=" + IpServer + ";UID=tesoreria;PWD=gr!cA@rv&vPQM67T%9RF;DATABASE=tesoreria2;PORT=3306" &&conexion tesoreria
	ovar.cCadenaConexiongeneraluni="DSN=General;SERVER=" + IpServer + ";UID=general;PWD=@X%Q!HQCrSv7j9aD8jYU;DATABASE=general;PORT=3306" &&conexion general unificado"
	
	ovar.cCadenaConexiongeneral = "DSN=General;SERVER=" + IpServer + ";UID=general;PWD=@X%Q!HQCrSv7j9aD8jYU;DATABASE=general2;PORT=3306" &&conexion general
	ovar.cCadenaConexionfacturacion = "DSN=facturacion;SERVER=" + IpServer + ";UID=facturacion;PWD=$n2BJb@Huv^x8dZMR^zY;DATABASE=facturacion2;PORT=3306" &&conexion facturacion
	cCaminoLogo          = ".\logoa\logo-empresa.png"


Case ovar.nCodigoEmpresa = 3 && Canteras
	ovar.cCadenaConexiontesoreria = "DSN=tesoreria;SERVER=" + IpServer + ";UID=tesoreria;PWD=gr!cA@rv&vPQM67T%9RF;DATABASE=tesoreria31;PORT=3306" &&conexion tesoreria
	ovar.cCadenaConexiongeneral = "DSN=General;SERVER=" + IpServer + ";UID=general;PWD=@X%Q!HQCrSv7j9aD8jYU;DATABASE=general3;PORT=3306" &&conexion general
	ovar.cCadenaConexiongeneraluni="DSN=General;SERVER=" + IpServer + ";UID=general;PWD=@X%Q!HQCrSv7j9aD8jYU;DATABASE=general;PORT=3306" &&conexion general unificado"
	ovar.cCadenaConexionfacturacion = "DSN=facturacion;SERVER=" + IpServer + ";UID=facturacion;PWD=$n2BJb@Huv^x8dZMR^zY;DATABASE=facturacion31;PORT=3306" &&conexion facturacion
	cCaminoLogo          = ".\logoc\logo-empresa.png"


Case ovar.nCodigoEmpresa = 4 && Calizas
	ovar.cCadenaConexiontesoreria = "DSN=tesoreria;SERVER=" + IpServer + ";UID=tesoreria;PWD=gr!cA@rv&vPQM67T%9RF;DATABASE=tesoreria4;PORT=3306" &&conexion tesoreria
	ovar.cCadenaConexiongeneral = "DSN=General;SERVER=" + IpServer + ";UID=general;PWD=@X%Q!HQCrSv7j9aD8jYU;DATABASE=general4;PORT=3306" &&conexion general
	ovar.cCadenaConexiongeneraluni="DSN=General;SERVER=" + IpServer + ";UID=general;PWD=@X%Q!HQCrSv7j9aD8jYU;DATABASE=general;PORT=3306" &&conexion general unificado"
	ovar.cCadenaConexionfacturacion = "DSN=facturacion;SERVER=" + IpServer + ";UID=facturacion;PWD=$n2BJb@Huv^x8dZMR^zY;DATABASE=facturacion4;PORT=3306" &&conexion facturacion
	cCaminoLogo          = ".\logoca\logo-empresa.png"

Case ovar.nCodigoEmpresa = 5 && HOTEL
	ovar.cCadenaConexiontesoreria = "DSN=tesoreria;SERVER=" + IpServer + ";UID=tesoreria;PWD=gr!cA@rv&vPQM67T%9RF;DATABASE=tesoreria5;PORT=3306" &&conexion tesoreria
	ovar.cCadenaConexiongeneral = "DSN=General;SERVER=" + IpServer + ";UID=general;PWD=@X%Q!HQCrSv7j9aD8jYU;DATABASE=general5;PORT=3306" &&conexion general
	ovar.cCadenaConexiongeneraluni="DSN=General;SERVER=" + IpServer + ";UID=general;PWD=@X%Q!HQCrSv7j9aD8jYU;DATABASE=general;PORT=3306" &&conexion general unificado"
	ovar.cCadenaConexionfacturacion = "DSN=facturacion;SERVER=" + IpServer + ";UID=facturacion;PWD=$n2BJb@Huv^x8dZMR^zY;DATABASE=facturacion5;PORT=3306" &&conexion facturacion
	cCaminoLogo          = ".\logoh\logo-empresa.png"


Case ovar.nCodigoEmpresa = 6 && Topacio
	ovar.cCadenaConexiontesoreria = "DSN=tesoreria;SERVER=" + IpServer + ";UID=tesoreria;PWD=gr!cA@rv&vPQM67T%9RF;DATABASE=tesoreria6;PORT=3306" &&conexion tesoreria
	ovar.cCadenaConexiongeneral = "DSN=General;SERVER=" + IpServer + ";UID=general;PWD=@X%Q!HQCrSv7j9aD8jYU;DATABASE=general6;PORT=3306" &&conexion general
	ovar.cCadenaConexiongeneraluni="DSN=General;SERVER=" + IpServer + ";UID=general;PWD=@X%Q!HQCrSv7j9aD8jYU;DATABASE=general;PORT=3306" &&conexion general unificado"
	ovar.cCadenaConexionfacturacion = "DSN=facturacion;SERVER=" + IpServer + ";UID=facturacion;PWD=$n2BJb@Huv^x8dZMR^zY;DATABASE=facturacion2;PORT=3306" &&conexion facturacion
	cCaminoLogo          = ".\logot\logo-empresa.png"

Case ovar.nCodigoEmpresa = 7 && OROSI
	ovar.cCadenaConexiontesoreria = "DSN=tesoreria;SERVER=" + IpServer + ";UID=tesoreria;PWD=gr!cA@rv&vPQM67T%9RF;DATABASE=tesoreria7;PORT=3306" &&conexion tesoreria
	ovar.cCadenaConexiongeneral = "DSN=General;SERVER=" + IpServer + ";UID=general;PWD=@X%Q!HQCrSv7j9aD8jYU;DATABASE=general7;PORT=3306" &&conexion general
	ovar.cCadenaConexiongeneraluni="DSN=General;SERVER=" + IpServer + ";UID=general;PWD=@X%Q!HQCrSv7j9aD8jYU;DATABASE=general;PORT=3306" &&conexion general unificado"
	ovar.cCadenaConexionfacturacion = "DSN=facturacion;SERVER=" + IpServer + ";UID=facturacion;PWD=$n2BJb@Huv^x8dZMR^zY;DATABASE=facturacion7;PORT=3306" &&conexion facturacion
	cCaminoLogo          = ".\logoO\logo-empresa.png"
	
Endcase

conectarbases()


SQLExec(ovar.Conecgeneral,"select * from logos where nempresa = ?ovar.nCodigoEmpresa","Logos")


If File(cCaminoLogo)
	Delete File cCaminoLogo
Endif

Strtofile(Logos.clogo,cCaminoLogo)


*---------------------
DatosIndicadora()  && Actualiza la información procedente de la Indicadora
*---------------------------

Function DatosIndicadora
*---------------------------
CurInd= Newobject('CursorAdapter')
TEXT TO cSchema
	 DPERIODOAL D,
 	 DPERIODODE D,
  	 NMESPROC I,
  	 NYEARPROC I,
   	 NCONTADOR I
ENDTEXT

TEXT TO cUpdata
	 DPERIODOAL,
	 DPERIODODE,
	 NMESPROC,
	 NYEARPROC,
	 NCONTADOR
ENDTEXT

TEXT TO cUpdatename
	 DPERIODOAL indicadora.DPERIODOAL
	 DPERIODODE indicadora.DPERIODODE
	 NMESPROC indicadora.NMESPROC
	 NYEARPROC indicadora.NYEARPROC
	 NCONTADOR indicadora.ncontador
ENDTEXT

With CurInd
	.DataSourceType ="ODBC"
	.Datasource = ovar.Conecfacturacion
	.Alias = "indicadora"
	.Tables = "indicadora"
	.KeyFieldList= "ncontador"
	.SelectCmd = [select * from indicadora]
	.CursorSchema = cSchema
	.BufferModeOverride = 5
	.UpdatableFieldList = cUpdata
	.UpdateNameList = cUpdatename
	.SendUpdates = .T.
Endwith

CurInd.CursorFill()  &&Relleno
*
ovar.dperiodoal=indicadora.dperiodoal
ovar.dperiodode=indicadora.dperiodode
ovar.nmesproc=indicadora.nmesproc
ovar.nyearproc=indicadora.nyearproc
ovar.cusuario= ""

Return .T.
