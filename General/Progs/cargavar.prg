Local lIndica, lpPrueba
PUBLIC cCaminoAsis,Conec
PUBLIC cCaminoLogo
Public NumOpc
PUBLIC nIDPesajememoria as Number
m.nIdPesajememoria = 0
*------
m.NumOPc = 60
*------
PUBLIC aSeguri(m.NumOpc,3) &&Arreglo para captar valores asignados
Public nTipoServidor
FOR i = 1 TO m.NumOPc
	STORE 0 TO aSeguri(i,1), aSeguri(i,2), aSeguri(i,3)	
ENDFOR

*------
m.lPrueba = .f.

lIndica = .f.
RELEASE oVar
If Type("oVar") <> "O"
   Public oVar
   oVar = CreateObject("Custom")
   oVar.Addproperty("cDesMes","")
   oVar.Addproperty("cPeriodo","")
   oVar.Addproperty("cTextoReporte","")
   oVar.Addproperty("cEmpresa","")
   oVar.Addproperty("cSistema","")   
   oVar.Addproperty("cReporte","")   
   oVar.Addproperty("cUsuario","")      
   oVar.Addproperty("cMenuSistema","")      
   oVar.Addproperty("cBasedeDatos","")      
   oVar.Addproperty("cTipoMensaje","")         
   oVar.Addproperty("cTipouser","")         
   oVar.Addproperty("cPathInicial","")         
   oVar.Addproperty("cDeskTop","")            
   oVar.Addproperty("nDesktop",0)            
   oVar.Addproperty("cMenu","")   
   oVar.Addproperty("nPerfil",0)   
   oVar.Addproperty("cCaminoFotos","")
   *
   oVar.Addproperty("Conecterminado","")         
   oVar.Addproperty("cCadenaConexionterminado","")      
   *--Segunda Conexion Facturacion
   oVar.Addproperty("Conecfacturacion","")         
   oVar.Addproperty("cCadenaConexionfacturacion","") 
   *-- Tercera Conexion Tesoreria
   oVar.Addproperty("Conectesoreria","")  
   oVar.Addproperty("cCadenaConexiontesoreria","")       
   *-- cuarta Conexion general
    oVar.Addproperty("Conecgeneral","")  
    oVar.Addproperty("cCadenaConexiongeneral","")  
    *-- conexion general unificado
    oVar.Addproperty("Conecgeneraluni","")         
   oVar.Addproperty("cCadenaConexiongeneraluni","")     
   *--indicadora
   oVar.Addproperty("nmesproc","")  
   oVar.Addproperty("nyearproc","")
   oVar.Addproperty("dperiodode","")
   oVar.Addproperty("dperiodoal","")
   oVar.Addproperty("cusuario","") 
    *--
   oVar.Addproperty("cServidor",0)  
   oVar.Addproperty("nServidor",0)
   oVar.Addproperty("nCodigoEmpresa",0)
   oVar.Addproperty("cCaminoPrevie","")
 
endif

oVar.cPathInicial  = SYS(2003)

oVar.cDeskTop        = "graficos\Bitmaps\fondo1.jpg"  
oVar.cTextoReporte   = ""
oVar.cEmpresa        = "ARENAS NACIONALES, S.A."
oVar.cSistema        = "SISTEMA DE GENERAL"   
oVar.cusuario        = "" 
oVar.cMenuSistema    = "menus\sistema.mpr"
oVar.cTipoMensaje    = "P"
oVar.cTipoUser       = "O"
*-

ovar.cCaminoPrevie   = ".\general\FOXYPREVIEWER.APP"

DO LOCFILE(ovar.cCaminoPrevie)


*--------------------------
*Empresas:
*1 = Imisa
*2 = Arenas
*3 = Canteras
*4 = Calizas
*5 = Hotel
*6 = Topacio

*- servidor 2: 192.168.40.18
*-*- servidor 1: 192.168.40.17
*-*- servidor 3: 127.0.0.1
*-*- servidor 4: 192.168.30.106

oVar.nServidor = 3
DO AsignaEmpresa WITH 2,oVar.nServidor
*---------------------------
IF DIRECTORY("fotos",1) = .f.
   MD fotos
endif   

IF DIRECTORY("Memoria",1) = .f.
   MD Memoria
ENDIF

IF DIRECTORY("logoi",1) = .f.
   MD logoi
endif  

IF DIRECTORY("logoa",1) = .f.
   MD logoa
endif  

IF DIRECTORY("logoc",1) = .f.
   MD logoc
endif  

IF DIRECTORY("logoca",1) = .f.
   MD logoca
ENDIF

IF DIRECTORY("logot",1) = .f.
   MD logot
endif    
IF DIRECTORY("logoh",1) = .f.
   MD logoh
ENDIF

IF DIRECTORY("logoO",1) = .f.
   MD logoO
endif
RETURN
