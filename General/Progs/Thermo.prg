*!*****************************************************************************
*!
*!      Procedure: CREATHERMO
*!
*!*****************************************************************************
PROCEDURE creathermo
LPARAMETERS m.text, m.prompt
LOCAL m.prompt

#DEFINE C_DLGFACE		"MS Sans Serif"
#DEFINE C_DLGSIZE		8.000
#DEFINE C_DLGSTYLE		"B"
#DEFINE C_BOXSTRG    ['Ä','Ä','³','³','Ú','¿','À','Ù','Ä','Ä','³','³','Ú','¿','À','Ù']

PUBLIC m.g_thermwidth

IF EMPTY( m.prompt )
  m.prompt = SPACE(55)
ELSE
  m.prompt = PADR(m.prompt,49)
ENDIF

  IF TXTWIDTH(m.prompt, c_dlgface, c_dlgsize, c_dlgstyle) > 49
      DO WHILE TXTWIDTH(m.prompt+"...", c_dlgface, c_dlgsize, c_dlgstyle) > 49
         m.prompt = LEFT(m.prompt, LEN(m.prompt)-1)
      ENDDO
      m.prompt = m.prompt + "..."
   ENDIF

   DEFINE WINDOW thermomete ;
      AT  INT((SROW() - (( 5.615 * ;
      FONTMETRIC(1, c_dlgface, c_dlgsize, c_dlgstyle )) / ;
      FONTMETRIC(1, WFONT(1,""), WFONT( 2,""), WFONT(3,"")))) / 2), ;
      INT((SCOL() - (( 63.833 * ;
      FONTMETRIC(5.615, c_dlgface, c_dlgsize, c_dlgstyle )) / ;
      FONTMETRIC(6, WFONT(1,""), WFONT( 2,""), WFONT(3,"")))) / 2) ;
      SIZE 5.615,63.833 ;
      FONT c_dlgface, c_dlgsize ;
      STYLE c_dlgstyle ;
      NOFLOAT ;
      NOCLOSE ;
      NONE ;
      COLOR RGB(0, 0, 0, 192, 192, 192)
   MOVE WINDOW thermomete CENTER
   ACTIVATE WINDOW thermomete NOSHOW

   @ 0.5,3 SAY m.text FONT c_dlgface, c_dlgsize STYLE c_dlgstyle
   @ 1.5,3 SAY m.prompt FONT c_dlgface, c_dlgsize STYLE c_dlgstyle
   @ 0.000,0.000 TO 0.000,63.833 ;
      COLOR RGB(255, 255, 255, 255, 255, 255)
   @ 0.000,0.000 TO 5.615,0.000 ;
      COLOR RGB(255, 255, 255, 255, 255, 255)
   @ 0.385,0.667 TO 5.231,0.667 ;
      COLOR RGB(128, 128, 128, 128, 128, 128)
   @ 0.308,0.667 TO 0.308,63.167 ;
      COLOR RGB(128, 128, 128, 128, 128, 128)
   @ 0.385,63.000 TO 5.308,63.000 ;
      COLOR RGB(255, 255, 255, 255, 255, 255)
   @ 5.231,0.667 TO 5.231,63.167 ;
      COLOR RGB(255, 255, 255, 255, 255, 255)
   @ 5.538,0.000 TO 5.538,63.833 ;
      COLOR RGB(128, 128, 128, 128, 128, 128)
   @ 0.000,63.667 TO 5.615,63.667 ;
      COLOR RGB(128, 128, 128, 128, 128, 128)
   @ 3.000,3.333 TO 4.231,3.333 ;
      COLOR RGB(128, 128, 128, 128, 128, 128)
   @ 3.000,60.333 TO 4.308,60.333 ;
      COLOR RGB(255, 255, 255, 255, 255, 255)
   @ 3.000,3.333 TO 3.000,60.333 ;
      COLOR RGB(128, 128, 128, 128, 128, 128)
   @ 4.231,3.333 TO 4.231,60.500 ;
      COLOR RGB(255, 255, 255, 255, 255, 255)
   m.g_thermwidth = 56.269

   SHOW WINDOW thermomete TOP
RETURN ""
set step on
*
* UPDTHERM(<percent>) - Update thermometer.
*
*!*****************************************************************************
*!
*!      Procedure: ACTUATHERMO
*!
*!*****************************************************************************
PROCEDURE ActuaThermo
LPARAMETERS lnTotal, lnValor, m.prompt
LOCAL m.nblocks, lnTotal, lnValor, m.percent, m.prompt

m.percent = (lnValor / lnTotal) * 100

IF !WEXIST("thermomete")
  RETURN
ENDIF

ACTIVATE WINDOW thermomete

* Map to the number of platforms we are generating for
m.percent = MIN(m.percent, 100)

IF EMPTY( m.prompt )
  m.prompt = SPACE(55)
ELSE
  m.prompt = PADR(m.prompt,49)
ENDIF

m.nblocks = (m.percent/100) * (m.g_thermwidth)

   IF TXTWIDTH(m.prompt, c_dlgface, c_dlgsize, c_dlgstyle) > 49
      DO WHILE TXTWIDTH(m.prompt+"...", c_dlgface, c_dlgsize, c_dlgstyle) > 49
         m.prompt = LEFT(m.prompt, LEN(m.prompt)-1)
      ENDDO
      m.prompt = m.prompt + "..."
   ENDIF

   @ 1.5,3 SAY m.prompt FONT c_dlgface, c_dlgsize STYLE c_dlgstyle
   @ 3.000,3.333 TO 4.231,m.nblocks + 3.333 ;
      PATTERN 1 COLOR RGB(128, 128, 128, 128, 128, 128)
RETURN ""

*
* DEACTTHERMO - Deactivate and Release thermometer window.
*
*!*****************************************************************************
*!
*!      Procedure: FINTHERMO
*!
*!*****************************************************************************
PROCEDURE FinThermo

RELEASE m.g_thermwidth

IF WEXIST("thermomete")
   RELEASE WINDOW thermomete
ENDIF

RETURN ""