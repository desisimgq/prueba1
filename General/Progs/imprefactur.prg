*!*	*PARAMETERS Carac
*!*	*imptiket()
*!*	*-*************************************************************************************
*!*	*-
*!*	*-
*!*	*-Procedimiento que Imprime un Ticket, mediante programacion  
*!*	*-**************************************************************************************

*!*	*oVar.Conec2 = SQLSTRINGCONNECT(oVar.cCadenaConexion2)
*!*	*-Las siguientes tres líneas de codigo es para abrir la Tabla de Ejemplo 
*!*	*Clos All
*!*	*- ubicacion de la tabla
*!*	*USE D:\DATA\entradas_det In 0 Exclusive
*!*	Sele factura_det 
*!*	SET CONSOLE OFF

*!*	*Se Establece la Configuración de Márgenes y otros valores del Documento
*!*	LNMARGEN_SUP = 0 && MargenSuperior   
*!*	LNMARGEN_INF = 9 && MargenInferior
*!*	LNTAMANO = 8.5
*!*	*- Numero de documento
*!*	LCDOCUMENTO  = "No:"+ALLT(STR(00001))

*!*	*- Valor de columna, ancho del papel
*!*	LN_NCOL		 = 40  &&DOCTOS.COLUMNAS

*!*	LCFECHA 	 = DTOC(DATE())
*!*	LCHORA       = TIME()

*!*	*Se inicializa el codigo de Impresion de Tiket's
*!*	??? CHR(27)+CHR(48)+CHR(27)+CHR(67)+CHR(44)
*!*	???  CHR(18)+CHR(27)+CHR(77)+CHR(15)
*!*	???  CHR(27)+CHR(77)+CHR(20)

*!*	*Código para Abrir la Caja de Dinero.
*!*	??? CHR(27)+'p'+CHR(0)+CHR(40)+CHR(250)	

*!*	*Se imprime el margenSuperior
*!*	FOR I=1 TO 	LNMARGEN_SUP
*!*		??? CHR(10)+CHR(13)
*!*	ENDFOR
*!*		
*!*	*--------------------------------- ENCABEZADO DEL TIKET --------------------------------------
*!*	*-Acuerdense que la Variable LN_NCOL define el ancho del Ticket
*!*	*En Este caso colocaremos Datos estaticos, pero pueden contener campos de tablas donde guarden 
*!*	*-el nombre de la empresa, direccion, etc, etc. como la linea siguiente
*!*	*??? CHR(10)+CHR(13)+PADC(ALLT(Sistema.Empresa)  ,LN_NCOL)

*!*	*-Acontinuación Datos Estaticos.
*!*	??? CHR(10)+CHR(13)+PADC('ARENAS NACIONALES S.A ',LN_NCOL)
*!*	??? CHR(10)+CHR(13)+PADC('Km. 7.5, carretera nueva a Leon',LN_NCOL)
*!*	??? CHR(10)+CHR(13)+PADC('Tels. 2265-0855/2265-0977/2265-0979',LN_NCOL)
*!*	??? CHR(10)+CHR(13)+PADC("Telefax:2265-0975",LN_NCOL)
*!*	??? CHR(10)+CHR(13)+PADC("RUC: J0310000002835",LN_NCOL)
*!*	??? CHR(10)+CHR(13)+PADC("Managua, Nicaragua",LN_NCOL)
*!*	??? CHR(10)+CHR(13)+PADC("ASFC 010027032014-1",LN_NCOL)
*!*	*- Una linea de espacio
*!*	??? CHR(10)+CHR(13)
*!*	*------------------------------ FIN DEL ENCABEZADO DEL TIKET ----------------------------------
*!*		
*!*	??? CHR(10)+CHR(13)+REPLICATE("-",LN_NCOL)
*!*	??? CHR(10)+CHR(13)+PADC("FACTURA CREDITO",LN_NCOL)
*!*	??? CHR(10)+CHR(13)+PADC("FACT"+LCDOCUMENTO,LN_NCOL)
*!*	??? CHR(10)+CHR(13)+REPLICATE("-",LN_NCOL)

*!*	*- Impresion de fecha y hora en la misma linea
*!*	??? CHR(10)+CHR(13)+ PADR(ALLT("Fecha:"+LCFECHA)+'     '+alltrim("Hora:"+LCHORA),LN_NCOL)
*!*	??? CHR(10)+CHR(13)

*!*	??? CHR(10)+CHR(13)+PADR(allt("CLIENTE  : "+ncliente),LN_NCOL)
*!*	*??? CHR(10)+CHR(13)+PADR('CEDULA   : '+'001-250678-00012Y ',LN_NCOL)
*!*	*??? CHR(10)+CHR(13)+PADR('DIRECCION: '+'Zona 10 Casa No.457 ',LN_NCOL)
*!*	*??? CHR(10)+CHR(13)+PADR('TELEFONO : '+'2269-2563 ',LN_NCOL)


*!*	*-------------------------- CUERPO O DETALLE DEL TIKET --------------------------------------
*!*	??? CHR(10)+CHR(13)+REPLICATE("-",LN_NCOL)
*!*	??? CHR(10)+CHR(13)+"Cant   U/m   P/u      Total "
*!*	??? CHR(10)+CHR(13)+REPLICATE("-",LN_NCOL)
*!*	??? CHR(10)+CHR(13)

*!*	SELEC factura_det
*!*	GO TOP
*!*	DO WHILE !EOF()
*!*		*Pasamos los datos a imprimir
*!*			
*!*			lcDes = AllT(STR(factura_det.ncanti,9999999999.99))
*!*			lcImp = TRANS(factura_det.nprecio,'999999999999.99')+'    '+TRANS(factura_det.nimporte,'999999999999.99')+' '+

*!*	   *- Llamado a la funcion imprime varias lineas
*!*		ImpVarLin(lcDes,LN_NCOL,lcImp)

*!*		*-Avanzamos al Siguiente Registro
*!*		SELECT factura_det
*!*		SKIP
*!*	ENDDO

*!*	*-------------------------- FIN DEL CUERPO O DETALLE DEL TIKET --------------------------------------


*!*	*--------------------------------- PIE DEL TIKET --------------------------------------

*!*	*-Calculamos el TotalSinDesc, TotalConDes, Subtotal e Iva
*!*	Wait Window 'Calculando Importes...!' NoWait
*!*	Sele factura_det
*!*	*Calculate Sum(factura_det.niva)All To lnsub	
*!*	*Calculate Sum(factura_det.ndescuento)All To lndes	
*!*	*Calculate Sum(factura_det.niva)All To lniva	
*!*	Calculate Sum(factura_det.nimporte)All To lnNeto

*!*	*Imprimimos una línea a la derecha
*!*	??? CHR(10)+CHR(13)+PADL('----------------',LN_NCOL)  
*!*	??? CHR(10)+CHR(13)+PADL('SUB-TOTAL: '+Allt(Str(lnNeto,12,2)),LN_NCOL)
*!*	??? CHR(10)+CHR(13)+PADL('DESCUENTO: '+Allt(Str(lnNeto,12,2)),LN_NCOL)
*!*	??? CHR(10)+CHR(13)+PADL('IVA: '+Allt(Str(lnNeto,12,2)),LN_NCOL)
*!*	??? CHR(10)+CHR(13)+PADL('TOTAL C$: '+Allt(Str(lnNeto,12,2)),LN_NCOL)


*!*	*--------------------------------- FIN DEL PIE DEL TIKET --------------------------------------
*!*	*Imprimimos una línea a la derecha
*!*	??? CHR(10)+CHR(13)
*!*	??? CHR(10)+CHR(13)
*!*	??? CHR(10)+CHR(13)+REPLICATE("-",LN_NCOL)
*!*	* Prueba de fuente

*!*	??? CHR(10)+CHR(13)+PADC('*Estamos Exentos de Retencion IR e IMI*',LN_NCOL)
*!*	??? CHR(10)+CHR(13)+PADC('*Factura sujeta  a Revalorizacion*',LN_NCOL)
*!*	??? CHR(10)+CHR(13)+PADC('*Precios sujetos a cambios sin previo aviso*',LN_NCOL)
*!*	??? CHR(10)+CHR(13)+REPLICATE("-",LN_NCOL)

*!*	*--------------------------------- FIN DEL PIE DEL TIKET --------------------------------------

*!*	*-Se imprime el margen Inferior, está definido arriba
*!*	FOR I=1 TO LNMARGEN_INF
*!*		??? CHR(10)+CHR(13)
*!*	ENDFOR

*!*	*Terminamos la Impresion
*!*	CLOSE PRINT
*!*	SET CONSOLE ON
*!*	SET PRINTER TO


*!*	*-Funcion que imprime en el número de líneas que sea necesario, lo determina el ancho de columna del ticket
*!*	Function ImpVarLin(mcTexto,mnCol,mcImporte)
*!*		nLen=Len(mcTexto)
*!*		If nLen<=mnCol-20 Then
*!*			??? chr(10)+chr(13)+mcTexto
*!*			???         chr(13)+PadL(mcImporte,mnCol)
*!*		Else
*!*			lcAuxCad = ''
*!*			*-Valores para la Cadena Inicial
*!*			nIni = 1
*!*			nFin = mnCol-1
*!*			Do While !Empty(mcTexto)
*!*				lcCadena = SubStr(mcTexto,nIni,nFin)
*!*				*-Cadena Restante
*!*				lcAuxCad = SubStr(mcTexto,nFin+1,nLen)
*!*				??? chr(10)+chr(13)+lcCadena
*!*				*Ahora mcTexto Vale la Cadena Restante.
*!*				mcTexto = lcAuxCad
*!*				*nLen Vale la Longitud de Cadena Restante.
*!*				nLen=Len(mcTexto)
*!*			EndDo
*!*			nLen = Len(lcCadena)
*!*			If nLen<=mnCol-20  Then
*!*				???         chr(13)+PadL(mcImporte,mnCol-nLen)
*!*			Else
*!*				??? Chr(10)+chr(13)+PadL(mcImporte,mnCol)
*!*			EndIf
*!*		EndIf
*!*	EndFunc 

