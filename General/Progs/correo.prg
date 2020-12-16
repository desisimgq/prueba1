EnviarCorreo()

*--------------------
Function EnviarCorreo(Asunto_,Cuerpo_)
*--------------------
LOCAL Smtp_, Puerto_, QuienEnvia_ , ClaveEnvia_, CorreoEnviar_, ConCopia_, CopiaOculta_
*
IF EMPTY(Asunto_)
   Asunto_ = "Prueba de envio desde Sistema de Producto Terminado"
endif
IF EMPTY(Cuerpo_)
   Cuerpo_ = CHR(13) + "Prueba de envio desde Sistema de Producto Terminado"
endif


*----- Parametros de Configuracion
Smtp_       = "smtp.grupoimisa.com.ni"
Puerto_     = 26
QuienEnvia_ = "producto.terminado@grupoimisa.com.ni"
ClaveEnvia_ = "bT9oHRgDZtwW"
*------
*------ Parametros de Correo
CorreoEnviar_ = "sergiorochanic@gmail.com"
ConCopia_     = "Gerencia <gerencia.desarrollo@grupoimisa.com.ni>,sergiorochanic@gmail.com"
CopiaOculta_  = "XXXXXXXXXXXXXXXXXXXX <xxxxx@hotmail.com>"

*------ Configuración
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
	*.Cc = ConCopia_  
	* Se envia de forma oculta
	*.bcc = CopiaOculta_ 
	.Subject = Asunto_
	.TextBody = Cuerpo_
	 *- Notificación de lectura
    .Fields("urn:schemas:mailheader:disposition-notification-to") = .From
    .Fields("urn:schemas:mailheader:return-receipt-to") = .From
    .Fields.Update
	.Send()
Endwith

Endfunc
