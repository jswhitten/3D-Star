DECLARE SUB PalSet ()
DECLARE SUB StarMap ()
DECLARE SUB ViewPort ()
DECLARE SUB Calc ()
DECLARE SUB GetKey ()
DECLARE SUB Menu ()
DECLARE SUB LoadStars ()
DECLARE SUB MakeScreen ()
DECLARE SUB MoveShip (SPEEDX, SPEEDY, SPEEDZ)
DECLARE SUB PlotStars ()
DECLARE FUNCTION DIST (XS, YS, ZS)
COMMON SHARED First%
COMMON SHARED Last%
COMMON SHARED AM()
COMMON SHARED StNum%
COMMON SHARED ThisHop%
COMMON SHARED LastHop%
COMMON SHARED X()
COMMON SHARED Y()
COMMON SHARED Z()
COMMON SHARED M()
COMMON SHARED l()
COMMON SHARED THSCR()
COMMON SHARED PHSCR()
COMMON SHARED t()
COMMON SHARED N$()
COMMON SHARED s$()
COMMON SHARED s()
COMMON SHARED X$
COMMON SHARED Xo!
COMMON SHARED Yo!
COMMON SHARED Zo!
COMMON SHARED SPEED
COMMON SHARED MAG
COMMON SHARED GLngD%
COMMON SHARED GLatD%
COMMON SHARED GLngR
COMMON SHARED GLatR
COMMON SHARED SPEEDX
COMMON SHARED SPEEDY
COMMON SHARED SPEEDZ

DIM N$(75), X(75), Y(75), Z(75), M(75), s$(75), s(75, 3), l(75), PHSCR(75, 2), THSCR(75, 2), t(2), AM(75, 2)
CONST PI = 3.141592653589793#

CALL PalSet
CALL LoadStars
CALL Menu
CALL MakeScreen
DO
  CALL Calc
  CALL PlotStars
  CALL MoveShip(SPEEDX, SPEEDY, SPEEDZ)
  CALL GetKey
LOOP

DATA "O",11,9,8,"B",11,9,8,"A",15,7,8,"F",15,7,8
DATA "G",14,14,8,"K",6,4,8,"M",12,4,8,"0",0,0,0

SUB Calc
  MAGX = 1.7222 * MAG: MAGY = 1.7222 * MAG
  LastHop% = ThisHop%: ThisHop% = ABS(ThisHop% - 1)
  FOR StNum% = First% TO Last%
  XS = (X(StNum%) - Xo!) * COS(GLngR) - (Y(StNum%) - Yo!) * SIN(GLngR)
  YS = (Y(StNum%) - Yo!) * COS(GLngR) * COS(GLatR) + (X(StNum%) - Xo!) * SIN(GLngR) * COS(GLatR) + (Z(StNum%) - Zo!) * SIN(GLatR)
  ZS = (Z(StNum%) - Zo!) * COS(GLatR) - (Y(StNum%) - Yo!) * COS(GLngR) * SIN(GLatR) - (X(StNum%) - Xo!) * SIN(GLngR) * SIN(GLatR)
  AM(StNum%, ThisHop%) = M(StNum%) - 5 + 5 * LOG(DIST(XS, YS, ZS) / 3.26) / LOG(10)
  IF AM(StNum%, ThisHop%) < 2 THEN l(StNum%) = 1 ELSE IF AM(StNum%, ThisHop%) < 4 THEN l(StNum%) = 2 ELSE IF AM(StNum%, ThisHop%) < 7 THEN l(StNum%) = 3
  IF YS = 0 THEN IF XS > 0 THEN THETA = 90 ELSE THETA = -90 ELSE THETA = ATN(XS / YS) * 180 / PI
  IF SQR(XS ^ 2 + YS ^ 2) = 0 THEN IF Z > 0 THEN PHI = 90 ELSE PHI = -90 ELSE PHI = ATN(ZS / SQR(XS ^ 2 + YS ^ 2)) * 180 / PI
  IF YS < 0 THEN THETA = THETA + 180
  IF THETA > 180 THEN THETA = THETA - 360
  THSCR(StNum%, ThisHop%) = 310 + THETA * MAGX
  PHSCR(StNum%, ThisHop%) = 155 - PHI * MAGY
  NEXT StNum%
  SPEEDX = SPEED * COS(GLatR) * SIN(GLngR)
  SPEEDY = SPEED * COS(GLatR) * COS(GLngR)
  SPEEDZ = SPEED * SIN(GLatR)
  t(ThisHop%) = TIMER
  SPD! = SPEED * 31536000 / (t(ThisHop%) - t(LastHop%))
  LOCATE 21, 17: PRINT SPEED; "light-years per jump ("; SPD!; "c)  "
  LOCATE 22, 17: PRINT GLngD%; "mark"; GLatD%; "         "
  LOCATE 23, 17: PRINT Xo!, Yo!, Zo!; "          "
  LOCATE 24, 17: PRINT MAG
  LOCATE 25, 17: PRINT (t(ThisHop%) - t(LastHop%))
END SUB

FUNCTION DIST (XS, YS, ZS)
DIST = SQR(XS ^ 2 + YS ^ 2 + ZS ^ 2)
END FUNCTION

SUB GetKey
  X$ = INKEY$
  IF X$ = "" THEN
    GOTO Skip1
  ELSE
    IF X$ = "2" THEN GLatR = GLatR - 5 * PI / 180
    IF X$ = "8" THEN GLatR = GLatR + 5 * PI / 180
    IF X$ = "4" THEN GLngR = GLngR - 5 * PI / 180
    IF X$ = "6" THEN GLngR = GLngR + 5 * PI / 180
    GLatD% = GLatR * 180 / PI
    GLngD% = GLngR * 180 / PI
    IF X$ = "Z" THEN MAG = MAG * 2
    IF X$ = "X" THEN MAG = MAG / 2
    IF X$ = "A" THEN SPEED = SPEED * 2
    IF X$ = "S" THEN SPEED = SPEED / 2
    IF X$ = "M" THEN CALL StarMap: RePlot = 1
  END IF
Skip1:
END SUB

SUB LoadStars
OPEN "3dstar.dat" FOR INPUT AS #1
CLS : PRINT "Loading star data..."
DO WHILE (NOT EOF(1))
  LET NumStars = NumStars + 1
  INPUT #1, N$(NumStars), X(NumStars), Y(NumStars), Z(NumStars), M(NumStars), s$(NumStars)
  SS$ = ""
  RESTORE
  DO WHILE s$(NumStars) <> SS$
    READ SS$, s(NumStars, 1), s(NumStars, 2), s(NumStars, 3)
  LOOP
  IF M > 10 THEN a = a - 1
LOOP
NumStars = NumStars - 1
First% = 1
Last% = NumStars
END SUB

SUB MakeScreen
RePlot = 0
CLS 0: SCREEN 12
VIEW (1, 1)-(620, 310), 0, 2
LOCATE 21, 1: PRINT "Speed         ="
LOCATE 22, 1: PRINT "Course        ="
LOCATE 23, 1: PRINT "Coordinates   ="
LOCATE 24, 1: PRINT "Magnification ="
LOCATE 25, 1: PRINT "System Speed  ="

END SUB

SUB Menu
CLS
PRINT "Initial coordinates [default -0.1,-0.1,-0.1]:"
INPUT "  X = "; Xo!: IF Xo! = 0 THEN Xo! = -.1
INPUT "  Y = "; Yo!: IF Yo! = 0 THEN Yo! = -.1
INPUT "  Z = "; Zo!: IF Zo! = 0 THEN Zo! = -.1
PRINT : PRINT "Initial course [default 0 mark 0]:"
INPUT "  GalLong (0ø to 360ø)  = "; GLngD%: GLngR = GLngD% * PI / 180
INPUT "  GalLat (-90ø to +90ø) = "; GLatD%: GLatR = GLatD% * PI / 180
PRINT : INPUT "Speed factor [default .05] = "; SPEED: IF SPEED = 0 THEN SPEED = .05
PRINT : INPUT "Magnification [default 1] = "; MAG: IF MAG = 0 THEN MAG = 1
END SUB

SUB MoveShip (SPEEDX, SPEEDY, SPEEDZ)
  Xo! = Xo! + SPEEDX
  Yo! = Yo! + SPEEDY
  Zo! = Zo! + SPEEDZ
END SUB

SUB PalSet
SCREEN 12
PALETTE 6, 256 * 30 + 60
PALETTE 9, 65536 * 50 + 256 * 40 + 20
PALETTE 11, 65536 * 63 + 256 * 50 + 40
END SUB

SUB PlotStars
  IF RePlot = 1 THEN CALL MakeScreen
  FOR StNum% = First% TO Last%
    IF AM(StNum%, LastHop%) < 6 THEN
      PRESET (THSCR(StNum%, LastHop%), PHSCR(StNum%, LastHop%))
    END IF
    IF PHSCR(StNum%, ThisHop%) < 2 OR THSCR(StNum%, ThisHop%) < 2 OR PHSCR(StNum%, ThisHop%) > 309 OR THSCR(StNum%, ThisHop%) > 619 THEN GOTO Skip
    IF AM(StNum%, ThisHop%) < 6 THEN
      PSET (THSCR(StNum%, ThisHop%), PHSCR(StNum%, ThisHop%)), s(StNum%, l(StNum%))
    END IF
Skip:
  NEXT StNum%
END SUB

SUB StarMap
CLS 0
SCREEN 12
VIEW (1, 1)-(324, 324), 0, 4
LINE (76, 76)-(248, 248), 4, B
LINE (1, 1)-(76, 76), 4
LINE (1, 324)-(76, 248), 4
LINE (324, 1)-(248, 76), 4
LINE (324, 324)-(248, 248), 4
LINE (50, 50)-(275, 275), 1, B
FOR GRIDX = 50 TO 275 STEP 15
  LINE (GRIDX, 50)-(GRIDX, 275), 1
NEXT GRIDX
FOR GRIDY = 50 TO 275 STEP 15
  LINE (50, GRIDY)-(275, GRIDY), 1
NEXT GRIDY
LOCATE 24: INPUT Ready$
END SUB

