REM ***********
REM * 3D-STAR *
REM * V. 0.95 *
REM ***********

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
DECLARE FUNCTION U$ (SPEED)
COMMON SHARED RePlot%
COMMON SHARED MapOn%
COMMON SHARED First%
COMMON SHARED Last%
COMMON SHARED AM()
COMMON SHARED StNum%
COMMON SHARED ThisHop%
COMMON SHARED LastHop%
COMMON SHARED X()
COMMON SHARED Y()
COMMON SHARED Z()
COMMON SHARED XSSCR()
COMMON SHARED YSSCR()
COMMON SHARED ZSSCR()
COMMON SHARED M()
COMMON SHARED l()
COMMON SHARED l2()
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
COMMON SHARED infostar%
COMMON SHARED INFOTH
COMMON SHARED INFOPH
COMMON SHARED INFODX

DIM N$(400), X(400), Y(400), Z(400), M(400), s$(400), s(400, 3), l2(400), l(400), PHSCR(400, 2), THSCR(400, 2), t(2), AM(400, 2), tt(4), XSSCR(400, 2), YSSCR(400, 2), ZSSCR(400, 2)
CONST PI = 3.141592653589793#
infostar% = 1

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

DATA "O",11,9,8,"B",11,7,8,"A",15,7,8,"F",15,7,8
DATA "G",14,7,8,"K",6,7,8,"M",12,7,8,"0",0,0,0
DATA "W",11,9,8,"N",12,7,8

SUB Calc
  IF infostar% < 1 THEN infostar% = Last%
  IF infostar% > Last% THEN infostar% = 1
  MAGX = 1.7222 * MAG: MAGY = 1.7222 * MAG
  LastHop% = ThisHop%: ThisHop% = ABS(ThisHop% - 1)
  FOR StNum% = First% TO Last%
  XS = (X(StNum%) - Xo!) * COS(GLngR) - (Y(StNum%) - Yo!) * SIN(GLngR)
  YS = (Y(StNum%) - Yo!) * COS(GLngR) * COS(GLatR) + (X(StNum%) - Xo!) * SIN(GLngR) * COS(GLatR) + (Z(StNum%) - Zo!) * SIN(GLatR)
  ZS = (Z(StNum%) - Zo!) * COS(GLatR) - (Y(StNum%) - Yo!) * COS(GLngR) * SIN(GLatR) - (X(StNum%) - Xo!) * SIN(GLngR) * SIN(GLatR)
  XSSCR(StNum%, ThisHop%) = 310 + (XS * MAG)
  YSSCR(StNum%, ThisHop%) = 155 - (YS * MAG)
  IF DIST(XS, YS, ZS) > 0 THEN
    AM(StNum%, ThisHop%) = M(StNum%) - 5 + 5 * LOG(DIST(XS, YS, ZS) / 3.26) / LOG(10)
    IF AM(StNum%, ThisHop%) < 2.5 THEN l(StNum%) = 1 ELSE IF AM(StNum%, ThisHop%) < 4 THEN l(StNum%) = 2 ELSE IF AM(StNum%, ThisHop%) < 7 THEN l(StNum%) = 3
    IF M(StNum%) < 2.5 THEN l2(StNum%) = 1 ELSE IF M(StNum%) < 4 THEN l2(StNum%) = 2 ELSE IF M(StNum%) < 7 THEN l2(StNum%) = 3
    IF YS = 0 THEN IF XS > 0 THEN THETA = 90 ELSE THETA = -90 ELSE THETA = ATN(XS / YS) * 180 / PI
    IF SQR(XS ^ 2 + YS ^ 2) = 0 THEN IF Z > 0 THEN PHI = 90 ELSE PHI = -90 ELSE PHI = ATN(ZS / SQR(XS ^ 2 + YS ^ 2)) * 180 / PI
    IF YS < 0 THEN THETA = THETA + 180
    IF THETA > 180 THEN THETA = THETA - 360
    IF StNum% = infostar% THEN
      INFOTH = THETA
      INFOPH = PHI
      INFODX = DIST(XS, YS, ZS)
    END IF
  END IF
  THSCR(StNum%, ThisHop%) = 310 + THETA * MAGX
  PHSCR(StNum%, ThisHop%) = 155 - PHI * MAGY
  NEXT StNum%
  SPEEDX = SPEED * COS(GLatR) * SIN(GLngR)
  SPEEDY = SPEED * COS(GLatR) * COS(GLngR)
  SPEEDZ = SPEED * SIN(GLatR)
END SUB

FUNCTION DIST (XS, YS, ZS)
DIST = SQR(XS ^ 2 + YS ^ 2 + ZS ^ 2)
END FUNCTION

SUB GetKey
  X$ = INKEY$
  IF X$ <> "" THEN
    IF X$ = "Q" OR X$ = "q" THEN END
    IF X$ = "2" THEN GLatR = GLatR - 5 * PI / 180
    IF X$ = "8" THEN GLatR = GLatR + 5 * PI / 180
    IF X$ = "4" THEN GLngR = GLngR - 5 * PI / 180
    IF X$ = "6" THEN GLngR = GLngR + 5 * PI / 180
    IF X$ = "5" THEN
        GLngR = GLngR + INFOTH * PI / 180
        GLatR = GLatR + INFOPH * PI / 180
    END IF
    GLatD% = GLatR * 180 / PI
    GLngD% = GLngR * 180 / PI
    IF X$ = "Z" THEN MAG = MAG * 2
    IF X$ = "z" THEN MAG = MAG / 2
    IF X$ = "A" THEN
      IF SPEED > 0 THEN
        SPEED = SPEED * 2
      ELSE
        SPEED = .01
      END IF
    END IF
    IF X$ = "a" THEN SPEED = SPEED / 2
    IF X$ = "M" THEN MapOn% = ABS(MapOn% - 1): RePlot% = 1
    IF X$ = "N" THEN infostar% = infostar% + 1
    IF X$ = "n" THEN infostar% = infostar% - 1
  END IF
END SUB

SUB LoadStars
INPUT "How many stars would you like to load [Enter = all of them]"; MaxStars%
IF MaxStars% = 0 THEN MaxStars% = 9999
OPEN "3dstar.dat" FOR INPUT AS #1
CLS : LOCATE 1: PRINT "Loading star data..."
DO WHILE (NOT EOF(1))
  LET NumStars% = NumStars% + 1
  LOCATE 1, 22: COLOR 14: PRINT NumStars%: COLOR 15
  INPUT #1, N$(NumStars%), X(NumStars%), Y(NumStars%), Z(NumStars%), M(NumStars%), s$(NumStars%)
  SS$ = ""
  RESTORE
  DO WHILE s$(NumStars%) <> SS$
    READ SS$, s(NumStars%, 1), s(NumStars%, 2), s(NumStars%, 3)
  LOOP
  IF M > 10 THEN a = a - 1
IF NumStars% >= MaxStars% THEN GOTO Label1
LOOP
Label1:
First% = 1
Last% = NumStars%
END SUB

SUB MakeScreen
RePlot% = 0
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
INPUT "Starting point"; LOC$
FOR NumStar% = 1 TO Last%
  IF N$(NumStar%) = LOC$ THEN
    Xo! = X(NumStar%)
    Yo! = Y(NumStar%)
    Zo! = Z(NumStar%)
    GOTO COURSE
  END IF
NEXT NumStar%
PRINT "Initial coordinates [default 0, 0, 0]:"
INPUT "  X = "; Xo!
INPUT "  Y = "; Yo!
INPUT "  Z = "; Zo!
COURSE:
PRINT : PRINT "Initial course [default 0 mark 0]:"
INPUT "  GalLong (0ø to 360ø)  = "; GLngD%: GLngR = GLngD% * PI / 180
INPUT "  GalLat (-90ø to +90ø) = "; GLatD%: GLatR = GLatD% * PI / 180
PRINT : INPUT "Speed factor [default 0.0] = "; SPEED
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
  IF RePlot% = 1 THEN CALL MakeScreen
 
  SELECT CASE MapOn%
 
  CASE 0
  FOR StNum% = First% TO Last%
    IF AM(StNum%, LastHop%) < 6 THEN
      PRESET (THSCR(StNum%, LastHop%), PHSCR(StNum%, LastHop%))
      IF AM(StNum%, LastHop%) < 1.5 THEN
        PRESET (THSCR(StNum%, LastHop%), PHSCR(StNum%, LastHop%) + 1)
        PRESET (THSCR(StNum%, LastHop%), PHSCR(StNum%, LastHop%) - 1)
        PRESET (THSCR(StNum%, LastHop%) + 1, PHSCR(StNum%, LastHop%))
        PRESET (THSCR(StNum%, LastHop%) - 1, PHSCR(StNum%, LastHop%))
      END IF
    END IF
    IF PHSCR(StNum%, ThisHop%) < 2 OR THSCR(StNum%, ThisHop%) < 2 OR PHSCR(StNum%, ThisHop%) > 309 OR THSCR(StNum%, ThisHop%) > 619 THEN GOTO Skip
    IF AM(StNum%, ThisHop%) < 6 THEN
      PSET (THSCR(StNum%, ThisHop%), PHSCR(StNum%, ThisHop%)), s(StNum%, l(StNum%))
      IF AM(StNum%, ThisHop%) < 1.5 THEN
        PSET (THSCR(StNum%, ThisHop%), PHSCR(StNum%, ThisHop%) + 1), s(StNum%, l(StNum%))
        PSET (THSCR(StNum%, ThisHop%), PHSCR(StNum%, ThisHop%) - 1), s(StNum%, l(StNum%))
        PSET (THSCR(StNum%, ThisHop%) + 1, PHSCR(StNum%, ThisHop%)), s(StNum%, l(StNum%))
        PSET (THSCR(StNum%, ThisHop%) - 1, PHSCR(StNum%, ThisHop%)), s(StNum%, l(StNum%))
      END IF
    END IF
Skip:
NEXT StNum%

CASE 1
  CIRCLE (310, 155), 2, 3
  FOR StNum% = First% TO Last%
    IF M(StNum%) < 6 THEN
      PRESET (XSSCR(StNum%, LastHop%), YSSCR(StNum%, LastHop%))
      IF M(StNum%) < 0 THEN
        PRESET (XSSCR(StNum%, LastHop%), YSSCR(StNum%, LastHop%) + 1)
        PRESET (XSSCR(StNum%, LastHop%), YSSCR(StNum%, LastHop%) - 1)
        PRESET (XSSCR(StNum%, LastHop%) + 1, YSSCR(StNum%, LastHop%))
        PRESET (XSSCR(StNum%, LastHop%) - 1, YSSCR(StNum%, LastHop%))
      END IF
    END IF
    IF XSSCR(StNum%, ThisHop%) < 2 OR YSSCR(StNum%, ThisHop%) < 2 OR XSSCR(StNum%, ThisHop%) > 619 OR YSSCR(StNum%, ThisHop%) > 309 THEN GOTO Skip2
    IF M(StNum%) < 6 THEN
      PSET (XSSCR(StNum%, ThisHop%), YSSCR(StNum%, ThisHop%)), s(StNum%, l2(StNum%))
      IF M(StNum%) < 0 THEN
        PSET (XSSCR(StNum%, ThisHop%), YSSCR(StNum%, ThisHop%) + 1), s(StNum%, l2(StNum%))
        PSET (XSSCR(StNum%, ThisHop%), YSSCR(StNum%, ThisHop%) - 1), s(StNum%, l2(StNum%))
        PSET (XSSCR(StNum%, ThisHop%) + 1, YSSCR(StNum%, ThisHop%)), s(StNum%, l2(StNum%))
        PSET (XSSCR(StNum%, ThisHop%) - 1, YSSCR(StNum%, ThisHop%)), s(StNum%, l2(StNum%))
      END IF
    END IF
Skip2:
NEXT StNum%

END SELECT

t(ThisHop%) = TIMER
IF SPEED > 0 THEN SPD! = SPEED * 31536000 / (t(ThisHop%) - t(LastHop%)) ELSE SPD! = 0
IF SPEED < .01 THEN
    sped = SPEED * 63170
ELSE
    sped = SPEED
END IF
LOCATE 21, 17: PRINT USING "###.## & per jump          "; sped; U$(SPEED)
LOCATE 21, 50: PRINT USING "########.## c"; SPD!
LOCATE 22, 17: PRINT USING "####.#  mark ####.#  "; GLngD%; GLatD%
LOCATE 23, 17: PRINT USING "####.##     ####.##     ####.##"; Xo!; Yo!; Zo!
LOCATE 24, 17: PRINT MAG
LOCATE 25, 17: PRINT (t(ThisHop%) - t(LastHop%))
LOCATE 26, 1: COLOR 13: PRINT USING "\              \    ####.##  mark ####.##    ####.## ly    ##.#M       "; N$(infostar%); INFOTH; INFOPH; INFODX; AM(infostar%, ThisHop): COLOR 15
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

FUNCTION U$ (SPEED)
IF SPEED < .01 THEN
        U$ = "A.U."
ELSE
        U$ = "light years"
END IF
END FUNCTION

