clear 
close database all
OPEN DATABASE  Data\Sistema
Use Lista1 in 0 EXCLUSIVE
Use Lista2 in 0 EXCLUSIVE
Select Lista2
zap

*---
* Actualizado Dom 3/7/11 2:58pm
* Total Tablas: 4
*---

Imprime("Catalogo")
Imprime("Usuarios")

close database all
do forms forms\impresion2 with "Crealista.frx",""
*report form .\reports\Crealista Preview

return

*-------------
Function Imprime( cBase )
*-------------
Use (cBase) in 0
Select (cBase)
copy stru exten to x
Use in (cBase)

Select lista1
zap
append from x
go top
cVar = Lista1.table_name
replace all Lista1.table_name with upper(cVar)
Select Lista2
Append from lista1
return

