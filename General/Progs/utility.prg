*
* Function Errordis(1,2,3)     Envia Mensajes de Error
* Function cNombre(1,2,3,4)    Agrupa en un solo campo nombres y apellidos
* Function StrZero(1,2,3)      Crea zeros a la isquierda
* Function _cMeses(1,2)        Convierne de Numero a Texto de Meses en formato corto o largo
* Function ampm(1)             Convierte la hora en formato hh:mm tt
* Function TextoMayMin(1)      Convierte texto de mayusculas a minusculas
* Function Decimales           Corta a dos decimales cantidades numericas
* Function Mensaje_Wait(cTex_) Manda mensajes a traves del Wait al centro
* Function UltDiaMes_(dFecha)  Calcula el ultimo dia del mes de cualquier fecha
* Function Edad_(dNac, dHoy)   Calcula la edad
* Function IfDisket_(cDrive)   Verifica si existe un diskette en la unidad
* Function _nCalcula_Max( cFile,cCampo ) Calcula al hacer un append el registro mas alto
* Function Num2Let(nCanti)     Cambia de Numeros a Letras
* Function Num2LetSimple(nCanti) Pasa de Numero a letra sin decimales y cordobas
* Function Fec2LetContrato(dFecha) Pasa de fecha al formato " ddddddd del mes de mmmmmmmm del aaaaaaaaaaaaa"
* Function Fec2Let(dFecha)     Pasa de fecha a Letras en el formato  "dd de mmmmmm de aaaa"
* Function cCodNom
* Function DiasLetras          Devuelve el dia de date() en Letras en espa�ol
*Function conexion			   Realiza la conexion


*------------------
Function Errordis(cTex1_,Icono_,cTex2_,cTipo_)
*------------------
*Pun = "Punto"
*Int = "interrogacion"
*Exc = "exclamacion"
*Inf = "Informacion"
* cTipo_
* "P" = Peedy
* "M" = MessageBox
Local Retorno
If Pcount()=0
	Return 0
Endif

cTipo_ = "M"

If Empty(cTipo_)
	cTipo_ = m.cTipoMensaje
Endif

If Empty(cTex1_)
	cTex1_ = "Mensaje"
Else
	If !Empty(m.cUsuario)
		cTex1_ = textoMayMin(m.cUsuario) + ", " + cTex1_
	Endif
Endif


If Upper(cTipo_) = "M"
*cTex1_ = m.cUsuario
	If Empty(Icono_)
		Icono_ = "EXC"
	Endif

	Do Case
	Case Upper(Icono_) = "PUN"
		Ico = 16
	Case Upper(Icono_) = "INT"
		Ico = 32
	Case Upper(Icono_) = "EXC"
		Ico = 48
	Case Upper(Icono_) = "INF"
		Ico = 64
	Otherwise
		Ico = 48
	Endcase
	If Empty(cTex2_)
		cTex2_ = "Mensaje"
	Endif
	Retorno = Messagebox(cTex1_,Ico,cTex2_)
	If Lastkey() = 27
		Retorno = 0
	Endif
	Return Retorno
Else
	oAgente.Mostrar
	oAgente.Hablar(cTex1_)
Endif
Return

*---------------
Function cNombre( n1,n2,a1,a2 )
*---------------
Local nCuantosP
nCuantosP = Pcount()
Do Case
Case nCuantosP = 1
	n1 = Alltrim(n1)
	n2 = " "
	a1 = " "
	a2 = " "
Case nCuantosP = 2
	n1 = Alltrim(n1)
	n2 = Alltrim(n2)
	a1 = " "
	a2 = " "
Case nCuantosP = 3
	n1 = Alltrim(n1)
	n2 = Alltrim(n2)
	a1 = Alltrim(a1)
	a2 = " "
Case nCuantosP = 4
	n1 = Alltrim(n1)
	n2 = Alltrim(n2)
	a1 = Alltrim(a1)
	a2 = Alltrim(a2)
Otherwise
	n1 = " "
	n2 = " "
	a1 = " "
	a2 = " "
Endcase
cTex = n1 + Iif(!Empty(n2)," " + n2 + " "," ") + ;
	a1 + Iif(!Empty(a2)," " + a2,"")
Return cTex


*---------------
Function StrZero( v1, v2, v3)
*---------------
* Rellena de ceros por la izquierda ya sean campos numericos
* o de caracteres
Local nC
nC = Parameters()
If Vartype(v1) = "C"
	v1 = Val(v1)
Endif
Do Case
Case nC = 1
	nV = Strtran(Str(v1)," ","0")
Case nC = 2
	nV = Strtran(Str(v1,v2)," ","0")
Case nC = 3
	nV = Strtran(Str(v1,v2,v3)," ","0")
Otherwise
	nV = "0"
Endcase
Return nV

*--------------
Function _cMeses
*--------------
Parameters cM,cT
* cT  C = Corto
*     L = Largo
Do Case
Case cM = 1
	cDesM = "Enero"
Case cM = 2
	cDesM = "Febrero"
Case cM = 3
	cDesM = "Marzo"
Case cM = 4
	cDesM = "Abril"
Case cM = 5
	cDesM = "Mayo"
Case cM = 6
	cDesM = "Junio"
Case cM = 7
	cDesM = "Julio"
Case cM = 8
	cDesM = "Agosto"
Case cM = 9
	cDesM = "Septiembre"
Case cM = 10
	cDesM = "Octubre"
Case cM = 11
	cDesM = "Noviembre"
Case cM = 12
	cDesM = "Diciembre"
Otherwise
	cDesM = "   "
Endcase
Return Iif(cT="C",Left(cDesM,3),cDesM)

*------------
Function ampm(cTim)
*------------
Local cTiempo,cHH,cMM,cMeri,cNew
cTiempo=cTim
cHH = Val(Subst(cTiempo,1,2))
cMM = Val(Subst(cTiempo,4,2))

Do Case
Case cHH = 12
	cMeri = "MM"
Case cHH < 12
	cMeri = "AM"
Case cHH > 12
	cMeri = "PM"
	cHH = cHH - 12
Otherwise
	cMeri = "MM"
Endcase
cNew = Str(cHH,2) + ":" + StrZero(cMM,2) + " " + cMeri
Return  cNew

*-------------------
Function textoMayMin( cT )
*-------------------
Local cRes,cTexto
cRes   = Lower(Alltrim(cT))
L      = Len(cRes)
cTexto = Upper(Left(cRes,1)) + Right(cRes,(L-1))
Return cTexto


*-----------------
Function Decimales
*-----------------
Parameters nVal
cV1    = Str(nVal,14,4)
nResul = Val(Left(cV1,12))
Return nResul


*--------------------
Function Mensaje_Wait(cTex_)
*--------------------
nLong_ = (108 - Len(cTex_)) /2
Wait cTex_ Window At 18,nLong_ Nowait
Return


*------------------------
Function UltDiaMes_(dFecha)
*------------------------
* Calcula el Ultimo dia del mes de Cualquier Fecha
Local ld
ld = Gomonth(dFecha,1)
Day(ld)
Return ld - Day(ld)
Endfunc


*-------------------------
Function Edad_(dNac, dHoy)
*-------------------------
* Calcula la edad pasando como par�metros:
* dNac = Fecha de nacimiento
* dHoy = Fecha a la cual se calcula la edad.
*        Por defecto toma la fecha actual.
Local nAnio
If Empty(dHoy)
	dHoy = Date()
Endif
nAnio = Year(dHoy) - Year(dNac)
If Gomonth(dNac, 12 * nAnio) > dHoy
	nAnio = nAnio - 1
Endif
Return nAnio
Endfunc

*----------------
Function IfDisket_(cDrive)
*----------------
Local lRet
If Empty(cDrive)
	cDrive = "A:"
Endif
ln = Diskspace(cDrive)
If ln > 0
*--- EXISTE UN DISCO EN "A:"
	lRet = .T.
Else
*--- NO EXISTE UN DISCO EN "A:"
	Wait Window "NO EXISTE UN DISCO EN A:"
	lRet = .F.
Endif
Return lRet

*--------------------
Function _nCalcula_Max( cFile,cCampo )
*--------------------
*cFile  = Tabla
*cCampo = Campo de la Tabla a Calcular su Numero Maximo
* Calcula el valor maximo de un campo ya sea numerico o de caracteres
* Devolviento el valor de forma numerica e incrementado + 1
Local nNumero
m.nNumero = 0
Select (cFile)
Calculate Max(&cCampo) To m.nNumero
Do Case
Case Vartype(&cCampo) = "C"
	m.nNumero = Int(Val(m.nNumero)) + 1
Case Vartype(&cCampo) = "N"
	m.nNumero = m.nNumero + 1
Endcase
Return m.nNumero


*--------------------------------
* FUNCTION Num2Let(tnNumero)
*--------------------------------
* La cantidad no se debe de poner con comas, solo el punto de los decimales si los hubieran
* Convierte un n�mero en letras con centavos
* USO: ? Num2Let(115.11) -> "CIENTO QUINCE CON ONCE CENTAVOS"
* PARAMETRO: Importe a convertir
* RETORNA: Caracter
*
*--------------------------------
Function Num2Let(tnNumero)
Local lnEntero, lnFraccion
tnNumero = Round(tnNumero, 2)
lnEntero = Int(tnNumero)
lnFraccion = Int((tnNumero - lnEntero) * 100)
Return Lower(N2L(lnEntero, .F.) + 'CORDOBAS CON '+ ;
	N2L(lnFraccion, .T.) + 'CENTAVOS.')
Endfunc

*--------------------------------
* FUNCTION N2L(tnNro, tlBandera)
*--------------------------------
* Convierte un n�mero entero en letras
* Usada por Let2Num (deben estar ambas)
* USO: ? N2L(1032) -> "MIL TREINTA Y DOS"
* PARAMETROS: lnNro = N�mero a convertir
*           : tlBandera (solo para diferenciar cuando retorna "UNO" o "UN")
* RETORNA: Caracter
* AUTOR: LMG
*--------------------------------
Function N2L(tnNro, tlBandera)
Local lnEntero, lcRetorno, lnTerna, lcMiles, ;
	lcCadena, lnUnidades, lnDecenas, lnCentenas
lnEntero = Int(tnNro)
lcRetorno = ''
lnTerna = 1
Do While lnEntero > 0
	lcCadena = ''
	lnUnidades = Mod(lnEntero, 10)
	lnEntero = Int(lnEntero / 10)
	lnDecenas = Mod(lnEntero, 10)
	lnEntero = Int(lnEntero / 10)
	lnCentenas = Mod(lnEntero, 10)
	lnEntero = Int(lnEntero / 10)

*--- Analizo la terna
	Do Case
	Case lnTerna = 1
		lcMiles = ''
	Case lnTerna = 2 And (lnUnidades+lnDecenas+lnCentenas # 0)
		lcMiles = 'MIL '
	Case lnTerna = 3 And (lnUnidades+lnDecenas+lnCentenas # 0)
		lcMiles = Iif(lnUnidades = 1 And lnDecenas = 0 And ;
			lnCentenas = 0, 'MILLON ', 'MILLONES ')
	Case lnTerna = 4 And (lnUnidades+lnDecenas+lnCentenas # 0)
		lcMiles = 'MIL MILLONES '
	Case lnTerna = 5 And (lnUnidades+lnDecenas+lnCentenas # 0)
		lcMiles = Iif(lnUnidades = 1 And lnDecenas = 0 And ;
			lnCentenas = 0, 'BILLON ', 'BILLONES ')
	Case lnTerna > 5
		lcRetorno = ' ERROR: NUMERO DEMASIADO GRANDE '
		Exit
	Endcase

*--- Analizo las unidades
	Do Case
	Case lnUnidades = 1
		lcCadena = Iif(Mod(lnTerna,2) = 0, '', ;
			IIF(lnTerna = 1 And Not tlBandera, 'UNO ', 'UN '))
	Case lnUnidades = 2
		lcCadena = 'DOS '
	Case lnUnidades = 3
		lcCadena = 'TRES '
	Case lnUnidades = 4
		lcCadena = 'CUATRO '
	Case lnUnidades = 5
		lcCadena = 'CINCO '
	Case lnUnidades = 6
		lcCadena = 'SEIS '
	Case lnUnidades = 7
		lcCadena = 'SIETE '
	Case lnUnidades = 8
		lcCadena = 'OCHO '
	Case lnUnidades = 9
		lcCadena = 'NUEVE '
	Endcase

*--- Analizo las decenas
	Do Case
	Case lnDecenas = 1
		Do Case
		Case lnUnidades = 0
			lcCadena = 'DIEZ '
		Case lnUnidades = 1
			lcCadena = 'ONCE '
		Case lnUnidades = 2
			lcCadena = 'DOCE '
		Case lnUnidades = 3
			lcCadena = 'TRECE '
		Case lnUnidades = 4
			lcCadena = 'CATORCE '
		Case lnUnidades = 5
			lcCadena = 'QUINCE '
		Other
			lcCadena = 'DIECI' + lcCadena
		Endcase
	Case lnDecenas = 2
		lcCadena = Iif(lnUnidades = 0, 'VEINTE ', 'VEINTI') + lcCadena
	Case lnDecenas = 3
		lcCadena = 'TREINTA ' + Iif(lnUnidades = 0, '', 'Y ') + lcCadena
	Case lnDecenas = 4
		lcCadena = 'CUARENTA ' + Iif(lnUnidades = 0, '', 'Y ') + lcCadena
	Case lnDecenas = 5
		lcCadena = 'CINCUENTA ' + Iif(lnUnidades = 0, '', 'Y ') + lcCadena
	Case lnDecenas = 6
		lcCadena = 'SESENTA ' + Iif(lnUnidades = 0, '', 'Y ') + lcCadena
	Case lnDecenas = 7
		lcCadena = 'SETENTA ' + Iif(lnUnidades = 0, '', 'Y ') + lcCadena
	Case lnDecenas = 8
		lcCadena = 'OCHENTA ' + Iif(lnUnidades = 0, '', 'Y ') + lcCadena
	Case lnDecenas = 9
		lcCadena = 'NOVENTA ' + Iif(lnUnidades = 0, '', 'Y ') + lcCadena
	Endcase

*--- Analizo las centenas
	Do Case
	Case lnCentenas = 1
		lcCadena = Iif(lnUnidades = 0 And lnDecenas = 0, ;
			'CIEN ', 'CIENTO ') + lcCadena
	Case lnCentenas = 2
		lcCadena = 'DOSCIENTOS ' + lcCadena
	Case lnCentenas = 3
		lcCadena = 'TRESCIENTOS ' + lcCadena
	Case lnCentenas = 4
		lcCadena = 'CUATROCIENTOS ' + lcCadena
	Case lnCentenas = 5
		lcCadena = 'QUINIENTOS ' + lcCadena
	Case lnCentenas = 6
		lcCadena = 'SEISCIENTOS ' + lcCadena
	Case lnCentenas = 7
		lcCadena = 'SETECIENTOS ' + lcCadena
	Case lnCentenas = 8
		lcCadena = 'OCHOCIENTOS ' + lcCadena
	Case lnCentenas = 9
		lcCadena = 'NOVECIENTOS ' + lcCadena
	Endcase

*--- Armo el retorno terna a terna
	lcRetorno = lcCadena+lcMiles+lcRetorno
	lnTerna = lnTerna + 1
Enddo
If lnTerna = 1
	lcRetorno = 'CERO '
Endif
Return lcRetorno
Endfunc

*--------------------------------


*--------------------------------
* FUNCTION Num2Letsimple(tnNumero)
*--------------------------------
* La cantidad no se debe de poner con comas, solo el punto de los decimales si los hubieran
* Convierte un n�mero en letras con centavos
* USO: ? Num2Letsimple(115.11) -> "CIENTO QUINCE CON ONCE CENTAVOS"
* PARAMETRO: Importe a convertir
* RETORNA: Caracter
*
*--------------------------------
Function Num2Letsimple(tnNumero)
Local lnEntero, lnFraccion
tnNumero = Round(tnNumero, 2)
lnEntero = Int(tnNumero)
lnFraccion = Int((tnNumero - lnEntero) * 100)
Return Lower(N2L2(lnEntero, .F.))
Endfunc

*--------------------------------
* FUNCTION N2L2(tnNro, tlBandera)
*--------------------------------
* Convierte un n�mero entero en letras
* Usada por Let2Num (deben estar ambas)
* USO: ? N2L(1032) -> "MIL TREINTA Y DOS"
* PARAMETROS: lnNro = N�mero a convertir
*           : tlBandera (solo para diferenciar cuando retorna "UNO" o "UN")
* RETORNA: Caracter
* AUTOR: LMG
*--------------------------------
Function N2L2(tnNro, tlBandera)
Local lnEntero, lcRetorno, lnTerna, lcMiles, ;
	lcCadena, lnUnidades, lnDecenas, lnCentenas
lnEntero = Int(tnNro)
lcRetorno = ''
lnTerna = 1
Do While lnEntero > 0
	lcCadena = ''
	lnUnidades = Mod(lnEntero, 10)
	lnEntero = Int(lnEntero / 10)
	lnDecenas = Mod(lnEntero, 10)
	lnEntero = Int(lnEntero / 10)
	lnCentenas = Mod(lnEntero, 10)
	lnEntero = Int(lnEntero / 10)

*--- Analizo la terna
	Do Case
	Case lnTerna = 1
		lcMiles = ''
	Case lnTerna = 2 And (lnUnidades+lnDecenas+lnCentenas # 0)
		lcMiles = 'MIL '
	Case lnTerna = 3 And (lnUnidades+lnDecenas+lnCentenas # 0)
		lcMiles = Iif(lnUnidades = 1 And lnDecenas = 0 And ;
			lnCentenas = 0, 'MILLON ', 'MILLONES ')
	Case lnTerna = 4 And (lnUnidades+lnDecenas+lnCentenas # 0)
		lcMiles = 'MIL MILLONES '
	Case lnTerna = 5 And (lnUnidades+lnDecenas+lnCentenas # 0)
		lcMiles = Iif(lnUnidades = 1 And lnDecenas = 0 And ;
			lnCentenas = 0, 'BILLON ', 'BILLONES ')
	Case lnTerna > 5
		lcRetorno = ' ERROR: NUMERO DEMASIADO GRANDE '
		Exit
	Endcase

*--- Analizo las unidades
	Do Case
	Case lnUnidades = 1
		lcCadena = Iif(Mod(lnTerna,2) = 0, '', ;
			IIF(lnTerna = 1 And Not tlBandera, 'UNO ', 'UN '))
	Case lnUnidades = 2
		lcCadena = 'DOS '
	Case lnUnidades = 3
		lcCadena = 'TRES '
	Case lnUnidades = 4
		lcCadena = 'CUATRO '
	Case lnUnidades = 5
		lcCadena = 'CINCO '
	Case lnUnidades = 6
		lcCadena = 'SEIS '
	Case lnUnidades = 7
		lcCadena = 'SIETE '
	Case lnUnidades = 8
		lcCadena = 'OCHO '
	Case lnUnidades = 9
		lcCadena = 'NUEVE '
	Endcase

*--- Analizo las decenas
	Do Case
	Case lnDecenas = 1
		Do Case
		Case lnUnidades = 0
			lcCadena = 'DIEZ '
		Case lnUnidades = 1
			lcCadena = 'ONCE '
		Case lnUnidades = 2
			lcCadena = 'DOCE '
		Case lnUnidades = 3
			lcCadena = 'TRECE '
		Case lnUnidades = 4
			lcCadena = 'CATORCE '
		Case lnUnidades = 5
			lcCadena = 'QUINCE '
		Other
			lcCadena = 'DIECI' + lcCadena
		Endcase
	Case lnDecenas = 2
		lcCadena = Iif(lnUnidades = 0, 'VEINTE ', 'VEINTI') + lcCadena
	Case lnDecenas = 3
		lcCadena = 'TREINTA ' + Iif(lnUnidades = 0, '', 'Y ') + lcCadena
	Case lnDecenas = 4
		lcCadena = 'CUARENTA ' + Iif(lnUnidades = 0, '', 'Y ') + lcCadena
	Case lnDecenas = 5
		lcCadena = 'CINCUENTA ' + Iif(lnUnidades = 0, '', 'Y ') + lcCadena
	Case lnDecenas = 6
		lcCadena = 'SESENTA ' + Iif(lnUnidades = 0, '', 'Y ') + lcCadena
	Case lnDecenas = 7
		lcCadena = 'SETENTA ' + Iif(lnUnidades = 0, '', 'Y ') + lcCadena
	Case lnDecenas = 8
		lcCadena = 'OCHENTA ' + Iif(lnUnidades = 0, '', 'Y ') + lcCadena
	Case lnDecenas = 9
		lcCadena = 'NOVENTA ' + Iif(lnUnidades = 0, '', 'Y ') + lcCadena
	Endcase

*--- Analizo las centenas
	Do Case
	Case lnCentenas = 1
		lcCadena = Iif(lnUnidades = 0 And lnDecenas = 0, ;
			'CIEN ', 'CIENTO ') + lcCadena
	Case lnCentenas = 2
		lcCadena = 'DOSCIENTOS ' + lcCadena
	Case lnCentenas = 3
		lcCadena = 'TRESCIENTOS ' + lcCadena
	Case lnCentenas = 4
		lcCadena = 'CUATROCIENTOS ' + lcCadena
	Case lnCentenas = 5
		lcCadena = 'QUINIENTOS ' + lcCadena
	Case lnCentenas = 6
		lcCadena = 'SEISCIENTOS ' + lcCadena
	Case lnCentenas = 7
		lcCadena = 'SETECIENTOS ' + lcCadena
	Case lnCentenas = 8
		lcCadena = 'OCHOCIENTOS ' + lcCadena
	Case lnCentenas = 9
		lcCadena = 'NOVECIENTOS ' + lcCadena
	Endcase

*--- Armo el retorno terna a terna
	lcRetorno = lcCadena+lcMiles+lcRetorno
	lnTerna = lnTerna + 1
Enddo
If lnTerna = 1
	lcRetorno = 'CERO '
Endif
Return lcRetorno
Endfunc

*--------------------------------

*-----------------------
Function Fec2LetContrato
*-----------------------
* Pasa de fecha a Letras en el formato
* "a los dd dias del mes de mmmmmmmm del xxxxxxxxx"
Parameters dfec
Local cTex,nAno
Dimension Mes_(12)
Mes_(01) = "Enero"
Mes_(02) = "Febrero"
Mes_(03) = "Marzo"
Mes_(04) = "Abril"
Mes_(05) = "Mayo"
Mes_(06) = "Junio"
Mes_(07) = "Julio"
Mes_(08) = "Agosto"
Mes_(09) = "Septiembre"
Mes_(10) = "Octubre"
Mes_(11) = "Noviembre"
Mes_(12) = "Diciembre"
nAno = Year(dfec)
cTex = Alltrim(Num2Letsimple(Day(dfec))) + ;
	" dias del mes de " + Mes_(Month(dfec)) + ;
	iif(nAno>1999," del "," de ") + Num2Letsimple(nAno)
Return cTex

*---------------
Function Fec2Let
*---------------
* Pasa de fecha a Letras en el formato "dd de mmmmmmmm de aaaa"
Parameters dfec
Local cTex,nAno
Dimension Mes_(12)
Mes_(01) = "Enero"
Mes_(02) = "Febrero"
Mes_(03) = "Marzo"
Mes_(04) = "Abril"
Mes_(05) = "Mayo"
Mes_(06) = "Junio"
Mes_(07) = "Julio"
Mes_(08) = "Agosto"
Mes_(09) = "Septiembre"
Mes_(10) = "Octubre"
Mes_(11) = "Noviembre"
Mes_(12) = "Diciembre"
nAno = Year(dfec)
cTex = Str(Day(dfec),2) + " de " + Mes_(Month(dfec)) + ;
	iif(Year(dfec)> 1999," del ", " de ") + ;
	str(nAno,4)
Return cTex

*---------------
Function cCodNom()
*---------------
Local cCod,lAbiertaDataBase,lAbiertaIndica
If !Dbused(oVar.cBasededatos)
	Open Database (oVar.cBasededatos)
	lAbiertaDataBase = .F.
Else
	lAbiertaDataBase = .T.
Endif
If !Used("Indica")
	Use Indica In 0
	lAbiertaIndica = .F.
Else
	lAbiertaIndica = .T.
Endif
If Indica.nTipoNom = 1 && Proceso Normal de la Nomina
	cCod = StrZero(Indica.nYearProceso,4) + ;
		StrZero(Indica.nMesproceso,2) + ;
		str(Indica.nSemana,1)
Else
	cCod = StrZero(Indica.nYearProceso,4) + "TRE"
Endif

If !lAbiertaIndica
	Use In Indica
Endif
If !lAbiertaDataBase
	Close Database All
Endif
Return cCod

*-----------------
Function AbreBases
*-----------------
If !Dbused("terminado")&& se cambio
	Open Database (oVar.cBasededatos) Shared
Endif
Set Database To terminado &&se cambio: informacion
Return .T.



*-----------------
Function AbreTabla( cTabla, cAlias, cOrder )
*-----------------
Set Multilocks On
*..
AbreBases()
*conexion()
*..
If Used(cTabla)
	Use In (cTabla)
Endif

If !Empty(cAlias)
	If !Empty(cOrder)
		Use (cTabla) In 0 Alias (m.cTabla)Shared Order cOrder
	Else
		Use (cTabla) In 0 Alias (m.cTabla)Shared
	Endif
	lSuccess=CursorSetProp("Buffering", 5, cTabla)
Else
	If !Empty(cOrder)
		Use (cTabla) In 0 Alias (m.cAlias) Shared Order cOrder
	Else
		Use (cTabla) In 0 Alias (m.cAlias) Shared
	Endif
	lSuccess=CursorSetProp("Buffering", 5, cTabla)
Endif
*
If lSuccess = .F.
	=Messagebox("Operacion no Satisfactora!",0,"Estado de la Operaci�n")
Endif
Return .T.

*------------
Function DTOI
*------------
Parameters fecha_
*--
dd = Padl(Alltrim(Str(Day(fecha_),2)),2,"0")
mm = Padl(Alltrim(Str(Month(fecha_),2)),2,"0")
yy = Padl(Alltrim(Str(Year(fecha_),4)),4,"0")
cResul = dd + mm + yy
Return cResul
*---------------
Function AgrupaNombre( n1,n2,a1,a2 )
*---------------
Local nCuantosP
nCuantosP = Pcount()
Do Case
Case nCuantosP = 1
	If Isnull(n1)
		n1 = " "
	Endif
	n1 = Alltrim(n1)
	n2 = " "
	a1 = " "
	a2 = " "
Case nCuantosP = 2
	If Isnull(n1)
		n1 = " "
	Endif
	If Isnull(n2)
		n2 = " "
	Endif
	n1 = Alltrim(n1)
	n2 = Alltrim(n2)
	a1 = " "
	a2 = " "
Case nCuantosP = 3
	If Isnull(n1)
		n1 = " "
	Endif
	If Isnull(n2)
		n2 = " "
	Endif
	If Isnull(a1)
		a1 = " "
	Endif
	n1 = Alltrim(n1)
	n2 = Alltrim(n2)
	a1 = Alltrim(a1)
	a2 = " "
Case nCuantosP = 4
	If Isnull(n1)
		n1 = " "
	Endif
	If Isnull(n2)
		n2 = " "
	Endif
	If Isnull(a1)
		a1 = " "
	Endif
	If Isnull(a2)
		a2 = " "
	Endif
	n1 = Alltrim(n1)
	n2 = Alltrim(n2)
	a1 = Alltrim(a1)
	a2 = Alltrim(a2)
Otherwise
	n1 = " "
	n2 = " "
	a1 = " "
	a2 = " "
Endcase
cTex = n1 + Iif(!Empty(n2)," " + n2 + " "," ") + ;
	a1 + Iif(!Empty(a2)," " + a2,"")
cTex = Padr(cTex,40," ")
Return cTex

*------------------------
Function Conecta( _cFile, _order )
*------------------------
Local nOpciones As Number

If Set("multilocks") <> "ON"
	Set Multilocks On
Endif

m.nOpciones=Parameters()

If Empty(_cFile) .And. Empty(_order)
	If !Dbused('informacion')
		Open Database (oVar.cBasededatos) Shared
	Endif
	Return .T.
Endif

If !Dbused('costos')
	Open Database (oVar.cBasededatos) Shared
Endif

If Used(m._cFile)
	Use In (m._cFile)
Endif

_cf = "costos!" + _cFile
Do Case
Case !Empty(_cFile) .And. !Empty(_order)
	Use (m._cf) In 0 Shared
	Select (m._cFile)
	Set Order To 1
Case !Empty(_cFile) .And. Empty(_order)
	Use (m._cf) In 0 Shared
Endcase

lSuccess=CursorSetProp("Buffering", 5, (m._cFile))
If lSuccess = .F.
	=Messagebox("No se pudo asigar Buffering")
Endif
Return .T.

*------------------------
Function ConectaReloj( _cFile, _order )
*------------------------
Local nOpciones As Number

If Set("multilocks") <> "ON"
	Set Multilocks On
Endif

m.nOpciones=Parameters()

If Empty(_cFile) .And. Empty(_order)
	If !Dbused('reloj')
		Open Database (oVar.cBDreloj) Shared
	Endif
	Return .T.
Endif

If !Dbused('reloj')
	Open Database (oVar.cBDreloj) Shared
Endif

If Used(m._cFile)
	Use In (m._cFile)
Endif

_cf = "reloj!" + _cFile
Do Case
Case !Empty(_cFile) .And. !Empty(_order)
	Use (m._cf) In 0 Shared
	Select (m._cFile)
	Set Order To 1
Case !Empty(_cFile) .And. Empty(_order)
	Use (m._cf) In 0 Shared
Endcase

lSuccess=CursorSetProp("Buffering", 5, (m._cFile))
If lSuccess = .F.
	=Messagebox("No se pudo asigar Buffering")
Endif
Return .T.

*------------------------
Function ConectaAsistencia( _cFile, _order )  && 5/8/06 02:01 am
*------------------------
Local nOpciones As Number

If Set("multilocks") <> "ON"
	Set Multilocks On
Endif

m.nOpciones=Parameters()

If Empty(_cFile) .And. Empty(_order)
	If !Dbused('asistencia')
		Open Database (oVar.cBDasistencia) Shared
	Endif
	Return .T.
Endif

If !Dbused('asistencia')
	Open Database (oVar.cBDasistencia) Shared
Endif

If Used(m._cFile)
	Use In (m._cFile)
Endif

_cf = "asistencia!" + _cFile
Do Case
Case !Empty(_cFile) .And. !Empty(_order)
	Use (m._cf) In 0 Shared
	Select (m._cFile)
	Set Order To 1
Case !Empty(_cFile) .And. Empty(_order)
	Use (m._cf) In 0 Shared
Endcase

lSuccess=CursorSetProp("Buffering", 5, (m._cFile))
If lSuccess = .F.
	=Messagebox("No se pudo asigar Buffering")
Endif
Return .T.

*------------------------
Function ConectaInfor( _cFile, _order )  && 5/8/06 02:01 am
*------------------------
Local nOpciones As Number

If Set("multilocks") <> "ON"
	Set Multilocks On
Endif

m.nOpciones=Parameters()

If Empty(_cFile) .And. Empty(_order)
	If !Dbused('Infor')
		Open Database (oVar.cBDInfor) Shared
	Endif
	Return .T.
Endif

If !Dbused('infor')
	Open Database (oVar.cBDInfor) Shared
Endif

If Used(m._cFile)
	Use In (m._cFile)
Endif

_cf = "infor!" + _cFile
Do Case
Case !Empty(_cFile) .And. !Empty(_order)
	Use (m._cf) In 0 Shared
	Select (m._cFile)
	Set Order To 1
Case !Empty(_cFile) .And. Empty(_order)
	Use (m._cf) In 0 Shared
Endcase

lSuccess=CursorSetProp("Buffering", 5, (m._cFile))
If lSuccess = .F.
	=Messagebox("No se pudo asigar Buffering")
Endif
Return .T.


*------------------------
Function ConectaSemanal( _cFile, _order )  && 6/8/06 02:01 am
*------------------------
Local nOpciones As Number

If Set("multilocks") <> "ON"
	Set Multilocks On
Endif

m.nOpciones=Parameters()

If Empty(_cFile) .And. Empty(_order)
	If !Dbused('informacion')
		Open Database (oVar.cBDsemanal) Shared
	Endif
	Return .T.
Endif

If !Dbused('informacion')
	Open Database (oVar.cBDsemanal) Shared
Endif

If Used(m._cFile)
	Use In (m._cFile)
Endif

_cf = "informacion!" + _cFile
Do Case
Case !Empty(_cFile) .And. !Empty(_order)
	Use (m._cf) In 0 Shared
	Select (m._cFile)
	Set Order To 1
Case !Empty(_cFile) .And. Empty(_order)
	Use (m._cf) In 0 Shared
Endcase

lSuccess=CursorSetProp("Buffering", 5, (m._cFile))
If lSuccess = .F.
	=Messagebox("No se pudo asingar Buffering")
Endif
Return .T.


*----------------------
Function AVERIGUAESTADO
*----------------------
cDate     = Set("DATE")
cCurrency = Set("CURRENCY",1)
cTalk     = Set("TALK")
cDeleted  = Set("DELETED")
cOldPath  = Set("PATH")
cSafety   = Set("SAFETY")
cConsole  = Set("CONSOLE")
cTex_ = "date = " + cDate + Chr(13) + ;
	"Currency = " + cCurrency + Chr(13) + ;
	"Talk = " + cTalk + Chr(13) + ;
	"Deleted = " + cDeleted + Chr(13) + ;
	"OldPath = " + cOldPath + Chr(13) + ;
	"Safety = " + cSafety + Chr(13) + ;
	"Console = " + cConsole

Messagebox(cTex_)
Return .T.

*-------------
Function HHMM( t1,t2, tip)
*------------
*********
* Function: HHMM
* Objetivo: alcular las horas y minutos trascurridos
*           entre dos tiempos de hora.
* Notas   : EL resultado se puede emitir de forma
*           de caracter "0000" o numerico 10.20
*           Para que el resultado de caracter el tercer
*           parametro debe de tener la letra "C" y para que
*           de numerico la letra "N", estas dos letras deben
*           de estar encerradas en apostrofes, de no ponerse
*           nada en el tercer parametro este asume que es "C"
*           Los campos del primer y segundo parametro pueden
*           ser numericos o caracter, cualquiera de los dos,
*           si existiera error en las tiempo que se estan
*           poniendo en los parametros uno y dos el resultado seria
*           "0000" � 0.00

Local error_
error_ = .F.


If Empty(tip)
	tip = "C"
Endif

m.tip = Upper(tip)

If Type("t1") = "N"
	t1 = Stuff(Padl(Alltrim(Str(t1,5,2)),5,"0"),3,1,"")
Endif

If Type("t2") = "N"
	t2 = Stuff(Padl(Alltrim(Str(t2,5,2)),5,"0"),3,1,"")
Endif


h1 = Val(Substr(t1,1,2))
m1 = Val(Substr(t1,3,2))

h2 = Val(Substr(t2,1,2))
m2 = Val(Substr(t2,3,2))

Do Case
Case h2 < h1
	r = "0000"
	error_ = .T.
Case h2 = h1 .And. m2 < m1
	r = "0000"
	error_ = .T.
Case h2 = h1 .And. m2 = m1
	r = "0000"
	error_ = .T.
Endcase
If error_
*cTex = "Entrada....: " + t1 + CHR(13) + ;
"Salida......: " + t2 + CHR(13) + ;
"Resultado..: " + TRANSFORM(r,"9999")
*messagebox(cTex)
	If tip = "C"
		r = r
		cr = r
	Else
		r = Val(Substr(r,1,2) + "." + Substr(r,3,2))
		cr = Str(r,5,2)
	Endif

	Return r
Endif


hh = h2 - h1

Do Case
Case m2 > m1
	mm = m2 - m1
Case m2 = m1
	mm = 0
Case m2 < m1
	mm = (60 - m1) + m2
	hh = hh -1
Endcase

r = StrZero(hh,2) + StrZero(mm,2)
If tip = "C"
	r = r
	cr = r
Else
	r = Val(Substr(r,1,2) + "." + Substr(r,3,2))
	cr = Str(r,5,2)
Endif


*cTex = "Entrada....: " + t1 + CHR(13) + ;
"Salida......: " + t2 + CHR(13) + ;
"Resultado..: " + cr
*messagebox(cTex)
Return r
*-----------------
Function DiaLetras(fecha_)
*-----------------
Local cTexDia, nDay

nDay = Day(fecha_)

Do Case
Case nDay = 1 && Domingo
	cTexDia = "Domingo"
Case nDay = 2 && Lunes
	cTexDia = "Lunes"
Case nDay = 3 && Martes
	cTexDia = "Martes"
Case nDay = 4 && Miercoles
	cTexDia = "Miercoles"
Case nDay = 5 && Jueves
	cTexDia = "Jueves"
Case nDay = 6 && Viernes
	cTexDia = "Viernes"
Case nDay = 7 && Sabado
	cTexDia = "Sabado"
Otherwise
	cTexDia = ""
Endcase

Return cTexDia

*-------------------
Function MarcadaGral( nIni, nFin )
*-------------------
Local nBajo, nAlto, cVar
m.nBajo = nIni
m.nAlto = nFin
cVar = Padl(Alltrim(Str(Int((nAlto - nBajo + 1) * Rand( ) + nBajo),2)),2,"0")
Return cVar


********************************************************************
********************************************************************
*!* FUNCTION Exp2Excel( [cCursor, [cFileSave, [cTitulo]]] )
*!*
*!* Exporta un Cursor de Visual FoxPro a Excel, utilizando la
*!* t�cnica de importaci�n de datos externos en modo texto.
*!*
*!* PARAMETROS OPCIONALES:
*!* - cCursor  Alias del cursor que se va a exportar.
*!*            Si no se informa, utiliza el alias
*!*            en que se encuentra.
*!*
*!* - cFileName  Nombre del archivo que se va a grabar.
*!*              Si no se informa, muestra el libro generado
*!*              una vez conclu�da la exportaci�n.
*!*
*!* - cTitulo  Titulo del informe. Si se informa, este
*!*            ocupar�a la primera file de cada hoja del libro.
********************************************************************
********************************************************************
Function Exp2Excel( cCursor, cFileSave, cTitulo )
Local cWarning
cWarning = "Exportar a EXCEL"
If Empty(cCursor)
	cCursor = Alias()
Endif
If Type('cCursor') # 'C' Or !Used(cCursor)
	Messagebox("Par�metros Inv�lidos",16,cWarning)
	Return .F.
Endif
*********************************
*** Creaci�n del Objeto Excel ***
*********************************
Wait Window 'Abriendo aplicaci�n Excel.' Nowait Noclear
oExcel = Createobject("Excel.Application")
Wait Clear

If Type('oExcel') # 'O'
	Messagebox("No se puede procesar el archivo porque no tiene la aplicaci�n" ;
		+ Chr(13) + "Microsoft Excel instalada en su computador.",16,cWarning)
	Return .F.
Endif

oExcel.workbooks.Add

Local lnRecno, lnPos, lnPag, lnCuantos, lnRowTit, lnRowPos, i, lnHojas, cDefault

cDefault = Addbs(Sys(5)  + Sys(2003))

Select (cCursor)
lnRecno = Recno(cCursor)
Go Top

*************************************************
*** Verifica la cantidad de hojas necesarias  ***
*** en el libro para la cantidad de datos     ***
*************************************************
lnHojas = Round(Reccount(cCursor)/65000,0)
Do While oExcel.Sheets.Count < lnHojas
	oExcel.Sheets.Add
Enddo

lnPos = 0
lnPag = 0

Do While lnPos < Reccount(cCursor)

	lnPag = lnPag + 1 && Hoja que se est� procesando

	Wait Windows 'Exportando cursor '  + Upper(cCursor)  + ' a Microsoft Excel...' ;
		+ Chr(13) + '(Hoja '  + Alltrim(Str(lnPag))  + ' de '  + Alltrim(Str(lnHojas)) ;
		+ ')' Noclear Nowait

	If File(cDefault  + cCursor  + ".txt")
		Delete File (cDefault  + cCursor  + ".txt")
	Endif

*   COPY  NEXT 65000 TO (cDefault  + cCursor  + ".txt") DELIMITED WITH CHARACTER ";"
	Copy  Next 300000 To (cDefault  + cCursor  + ".txt") Delimited With Character ";"

	lnPos = Recno(cCursor)

	oExcel.Sheets(lnPag).Select

	XLSheet = oExcel.ActiveSheet
	XLSheet.Name = cCursor + '_' + Alltrim(Str(lnPag))

	lnCuantos = Afields(aCampos,cCursor)

********************************************************
*** Coloca t�tulo del informe (si este es informado) ***
********************************************************
	If !Empty(cTitulo)
		XLSheet.Cells(1,1).Font.Name = "Arial"
		XLSheet.Cells(1,1).Font.Size = 12
		XLSheet.Cells(1,1).Font.BOLD = .T.
		XLSheet.Cells(1,1).Value = cTitulo
		XLSheet.Range(XLSheet.Cells(1,1),XLSheet.Cells(1,lnCuantos)).MergeCells = .T.
		XLSheet.Range(XLSheet.Cells(1,1),XLSheet.Cells(1,lnCuantos)).Merge
*XLSheet.RANGE(XLSheet.Cells(1,1),XLSheet.Cells(1,lnCuantos)).HorizontalAlignment = 3
		XLSheet.Range(XLSheet.Cells(1,1),XLSheet.Cells(1,lnCuantos)).HorizontalAlignment = 1
		lnRowPos = 3
	Else
		lnRowPos = 2
	Endif

	lnRowTit = lnRowPos - 1
**********************************
*** Coloca t�tulos de Columnas ***
**********************************
	For i = 1 To lnCuantos
		lcName  = aCampos(i,1)
		lcCampo = Alltrim(cCursor) + '.' + aCampos(i,1)
		XLSheet.Cells(lnRowTit,i).Value=lcName
		XLSheet.Cells(lnRowTit,i).Font.BOLD = .T.
		XLSheet.Cells(lnRowTit,i).Interior.ColorIndex = 15
		XLSheet.Cells(lnRowTit,i).Interior.Pattern = 1
		XLSheet.Range(XLSheet.Cells(lnRowTit,i),XLSheet.Cells(lnRowTit,i)).BorderAround(7)
	Next

	XLSheet.Range(XLSheet.Cells(lnRowTit,1),XLSheet.Cells(lnRowTit,lnCuantos)).HorizontalAlignment = 3

*************************
*** Cuerpo de la hoja ***
*************************
	oConnection = XLSheet.QueryTables.Add("TEXT;"  + cDefault  + cCursor  + ".txt", ;
		XLSheet.Range("A"  + Alltrim(Str(lnRowPos))))

	With oConnection
		.Name = cCursor
		.FieldNames = .T.
		.RowNumbers = .F.
		.FillAdjacentFormulas = .F.
		.PreserveFormatting = .T.
		.RefreshOnFileOpen = .F.
		.RefreshStyle = 1 && xlInsertDeleteCells
		.SavePassword = .F.
		.SaveData = .T.
		.AdjustColumnWidth = .T.
		.RefreshPeriod = 0
		.TextFilePromptOnRefresh = .F.
		.TextFilePlatform = 850
		.TextFileStartRow = 1
		.TextFileParseType = 1 && xlDelimited
		.TextFileTextQualifier = 1 && xlTextQualifierDoubleQuote
		.TextFileConsecutiveDelimiter = .F.
		.TextFileTabDelimiter = .F.
		.TextFileSemicolonDelimiter = .T.
		.TextFileCommaDelimiter = .F.
		.TextFileSpaceDelimiter = .F.
		.TextFileTrailingMinusNumbers = .T.
		.Refresh
	Endwith

	XLSheet.Range(XLSheet.Cells(lnRowTit,1),XLSheet.Cells(XLSheet.Rows.Count,lnCuantos)).Font.Name = "Arial"
	XLSheet.Range(XLSheet.Cells(lnRowTit,1),XLSheet.Cells(XLSheet.Rows.Count,lnCuantos)).Font.Size = 8

	XLSheet.Columns.AutoFit
	XLSheet.Cells(lnRowPos,1).Select
	oExcel.ActiveWindow.FreezePanes = .T.

	Wait Clear

Enddo

oExcel.Sheets(1).Select
oExcel.Cells(lnRowPos,1).Select

If !Empty(cFileSave)
	oExcel.DisplayAlerts = .F.
	oExcel.ActiveWorkbook.SaveAs(cFileSave)
	oExcel.Quit
Else
	oExcel.Visible = .T.
Endif

Go lnRecno

Release oExcel,XLSheet,oConnection

If File(cDefault + cCursor + ".txt")
	Delete File (cDefault + cCursor + ".txt")
Endif

Return .T.

Endfunc

***
***
*-------------------------
Function Buscachr13(cCampo_)
*-------------------------
* Su funci�n es eliminar los caracteres chr(13) (Enter)
Local resul_,nuevo_,i_,tam_,cvar_
tam_ = Len(Alltrim(cCampo_))
If At(Chr(13),cCampo_) > 0
	nuevo_ = ""
	For i_ = 1 To tam_
		cvar_ = Substr(cCampo_,i_,1)
		If Empty(cvar_)
			cvar_ = " "
		Endif
		nuevo_ = nuevo_ + cvar_
	Endfor
	resul_ = nuevo_
Else
	resul_ = cCampo_
Endif
Return resul_



*-----------------------------
Function seekuser(conecc_,varsql_)
*-----------------------------
Local var1_
var1_=.F.
SQLExec(&conecc_)
If Reccount() <> 0
	var1_=.T.
Endif
Return var1_


*--------------------
Function EnviarCorreo(Asunto_,Cuerpo_)
*--------------------
Local Smtp_, Puerto_, QuienEnvia_ , ClaveEnvia_, CorreoEnviar_, ConCopia_, CopiaOculta_
*
If Empty(Asunto_)
	Asunto_ = "Prueba de envio desde Sistema de Producto Terminado"
Endif
If Empty(Cuerpo_)
	Cuerpo_ = Chr(13) + "Prueba de envio desde Sistema de Producto Terminado"
Endif

*----- Parametros de Configuracion
Smtp_       = "smtp.grupoimisa.com.ni"
Puerto_     = 26
QuienEnvia_ = "producto.terminado@grupoimisa.com.ni"
ClaveEnvia_ = "bT9oHRgDZtwW"
*------
*------ Parametros de Correo
CorreoEnviar_ = "Sergio Rocha T <sergiorochanic@gmail.com>"
ConCopia_     = "Brenda Mejia <bmejia@grupoimisa.com.ni>"
CopiaOculta_  = "XXXXXXXXXXXXXXXXXXXX <xxxxx@hotmail.com>"

*------ Configuraci�n
loCfg = Createobject("CDO.Configuration")
With loCfg.Fields
	.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver")       = Smtp_
	.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport")   = Puerto_
	.Item("http://schemas.microsoft.com/cdo/configuration/sendusing")        = 2
	.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = .T.
	.Item("http://schemas.microsoft.com/cdo/configuration/sendusername")     = QuienEnvia_
	.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword")     = ClaveEnvia_
	.Update
Endwith

*------- Correo
loMsg = Createobject ("CDO.Message")
With loMsg
	.Configuration = loCfg
	.From = "Sistema de Producto Terminado<producto.terminado@grupoimisa.com.ni>"
	.To = CorreoEnviar_
	.Cc = ConCopia_
* Se envia de forma oculta
*.bcc = CopiaOculta_
	.Subject = Asunto_
	.TextBody = Cuerpo_
*- Notificaci�n de lectura
	.Fields("urn:schemas:mailheader:disposition-notification-to") = .From
	.Fields("urn:schemas:mailheader:return-receipt-to") = .From
	.Fields.Update
	.Send()
Endwith

Endfunc
*-------conexion 2 facturacion
*----------------
Function Conectarfacturacion
*----------------
oVar.Conecfacturacion = Sqlstringconnect(oVar.cCadenaConexionfacturacion,.T.)
If oVar.Conecfacturacion <=0
	Messagebox("No hay conexion con la Base de datos, Comunicarse con el Area de Desarrollo." + Message(), ;
		16, "No hay conexion")
	Quit
Endif
Return .T.


*-------------------
Function Desconectarfacturacion
*-------------------
=SQLDisconnect(oVar.Conecfacturacion)
Return .T.


*-----------------------------
Function SQLSeekfactu(cadena, varsql_)
*-----------------------------
Local var1_
var1_=.F.
SQLExec(oVar.Conecfacturacion,cadena,'Resul')
If Used("Resul") .And. Reccount("Resul") > 0
	var1_=.T.
Endif
Return var1_


*-----------------------------
Function seekmfactu(cadena,varsql_)
*-----------------------------
Local rev_
rev_=.F.
SQLExec(oVar.Conecfacturacion,(cadena),'Resul')
If Reccount("Resul") > 0
	rev_=.T.
Endif
Return rev_

*----tercera conexion


*----------------
Function Conectartesoreria
*----------------
oVar.Conectesoreria = Sqlstringconnect(oVar.cCadenaConexiontesoreria,.T.)
If oVar.Conectesoreria <=0
	Messagebox("No hay conexion con la Base de datos, Comunicarse con el Area de Desarrollo." + Message(), ;
		16, "No hay conexion")
	Quit
Endif
Return .T.


*-------------------
Function Desconectar3
*-------------------
=SQLDisconnect(oVar.Conectesoreria)
Return .T.


*-----------------------------
Function SQLSeektes(cadena, varsql_)
*-----------------------------
Local var1_
var1_=.F.
SQLExec(oVar.Conectesoreria,cadena,'Resul')
If Used("Resul") .And. Reccount("Resul") > 0
	var1_=.T.
Endif
Return var1_


*-----------------------------
Function seekm3(cadena,varsql_)
*-----------------------------
Local rev_
rev_=.F.
SQLExec(oVar.Conectesoreria,(cadena),'Resul')
If Reccount("Resul") > 0
	rev_=.T.
Endif
Return rev_
*-- cuarta conexion General

*----------------
Function Conectargeneral
*----------------
oVar.Conecgeneral = Sqlstringconnect(oVar.cCadenaConexiongeneral,.T.)
If oVar.Conecgeneral <=0
	Messagebox("No hay conexion con la Base de datos, Comunicarse con el Area de Desarrollo." + Message(), ;
		16, "No hay conexion")
	Quit
Endif
Return .T.
*-------------------
Function Desconectargeneral
*-------------------
=SQLDisconnect(oVar.Conecgeneral)
Return .T.

*----------------
Function Conectargeneraluni
*----------------
oVar.Conecgeneraluni = Sqlstringconnect(oVar.cCadenaConexiongeneraluni,.T.)
If oVar.Conecgeneraluni <=0
	Messagebox("No hay conexion con la Base de datos, Comunicarse con el Area de Desarrollo." + Message(), ;
		16, "No hay conexion")
	Quit
Endif
Return .T.

*-------------------
Function Desconectargeneraluni
*-------------------
=SQLDisconnect(oVar.Conecgeneraluni)
Return .T.



*-----------------------------
Function SQLSeekgeneral(cadena, varsql_)
*-----------------------------
Local var1_
var1_=.F.
SQLExec(oVar.Conecgeneral,cadena,'Resul')
If Used("Resul") .And. Reccount("Resul") > 0
	var1_=.T.
Endif
Return var1_

*-----------------------------
Function SQLSeekgeneraluni(cadena, varsql_)
*-----------------------------
Local var1_
var1_=.F.
SQLExec(oVar.Conecgeneraluni,cadena,'Resul')
If Used("Resul") .And. Reccount("Resul") > 0
	var1_=.T.
Endif
Return var1_

Function conectarbases
*----------------

*- facturacion
oVar.Conecfacturacion  = Sqlstringconnect(oVar.cCadenaConexionfacturacion,.T.)
If oVar.Conecfacturacion <=0
	Messagebox("No hay conexion con la Base de datos de Facturaci�n, Comunicarse con el Area de Desarrollo." + Message(), ;
		16, "No hay conexion")
	Quit
Endif
*- general
oVar.Conecgeneral = Sqlstringconnect(oVar.cCadenaConexiongeneral,.T.)
If oVar.Conecgeneral <=0
	Messagebox("No hay conexion con la Base de datos de General, Comunicarse con el Area de Desarrollo." + Message(), ;
		16, "No hay conexion")
	Quit
Endif
*- general oficial
oVar.Conecgeneraluni = Sqlstringconnect(oVar.cCadenaConexiongeneraluni,.T.)
If oVar.Conecgeneraluni <=0
	Messagebox("No hay conexion con la Base de datos de General, Comunicarse con el Area de Desarrollo." + Message(), ;
		16, "No hay conexion")
	Quit
Endif

*-tesoreria
oVar.Conectesoreria = Sqlstringconnect(oVar.cCadenaConexiontesoreria,.T.)
If oVar.Conectesoreria <=0
	Messagebox("No hay conexion con la Base de datos tesoreria, Comunicarse con el Area de Desarrollo." + Message(), ;
		16, "No hay conexion")
	Quit
Endif

Return .T.


Function desconectarbases
*----------------

If  SQLIdleDisconnect(oVar.Conecfacturacion)  >= 1  && Desconecto Facturacion
	=SQLDisconnect(oVar.Conecfacturacion)
Endif


If  SQLIdleDisconnect(oVar.Conecgeneral)  >= 1  && Desconecto general
	=SQLDisconnect(oVar.Conecgeneral)
Endif
If  SQLIdleDisconnect(oVar.Conecgeneraluni)  >= 1  && Desconecto general unificado
	=SQLDisconnect(oVar.Conecgeneraluni)
Endif

If  SQLIdleDisconnect(oVar.Conectesoreria)  >= 1  && Desconecto tesoreria
	=SQLDisconnect(oVar.Conectesoreria)
Endif
Return .T.

*--------------------
Function impresion3(ccodrepor,creporte_)
*-------------------
Local aliasarchi
aliasarchi= Alias()
Select &aliasarchi
Calculate Cnt() To existen_
If existen_ = 0
	Errordis("Lo siento no hay registros para procesar")
	Return 0
Endif
Go Top
m.creporte= creporte_
Report Form &ccodrepor Preview
Return .T.

