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
COMMON SHARED infostar%
COMMON SHARED INFOTH
COMMON SHARED INFOPH
COMMON SHARED INFODX

DIM N$(350), X(350), Y(350), Z(350), M(350), s$(350), s(350, 3), l(350), PHSCR(350, 2), THSCR(350, 2), t(2), AM(350, 2), tt(4)
CONST PI = 3.141592653589793#
infostar% = 1

CALL PalSet
CALL LoadStars
CALL Menu
CALL MakeScreen
DO
  'tt(0) = TIMER: LOCATE 14: PRINT tt(0) - tt(4)
  CALL Calc
  'tt(1) = TIMER
  CALL PlotStars
  'tt(2) = TIMER
  CALL MoveShip(SPEEDX, SPEEDY, SPEEDZ)
  'tt(3) = TIMER
  CALL GetKey
  'tt(4) = TIMER
  'LOCATE 10: FOR jed = 1 TO 4: PRINT tt(jed) - tt(jed - 1): NEXT jed
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
  IF DIST(XS, YS, ZS) > 0 THEN
    AM(StNum%, ThisHop%) = M(StNum%) - 5 + 5 * LOG(DIST(XS, YS, ZS) / 3.26) / LOG(10)
    IF AM(StNum%, ThisHop%) < 2.5 THEN l(StNum%) = 1 ELSE IF AM(StNum%, ThisHop%) < 4 THEN l(StNum%) = 2 ELSE IF AM(StNum%, ThisHop%) < 7 THEN l(StNum%) = 3
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
    IF X$ = "M" THEN CALL StarMap: RePlot = 1
    IF X$ = "N" THEN infostar% = infostar% + 1
    IF X$ = "n" THEN infostar% = infostar% - 1
  END IF
END SUB

SUB LoadStars
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
LOOP
First% = 1
Last% = NumStars%
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
  IF RePlot = 1 THEN CALL MakeScreen
  FOR StNum% = First% TO Last%
    IF AM(StNum%, LastHop%) < 6 THEN
      PRESET (THSCR(StNum%, LastHop%), PHSCR(StNum%, LastHop%))
      IF AM(StNum%, LastHop%) < 1.5 THEN
        PRESET (THSCR(StNum%, LastHop%), PHSCR(StNum%, LastHop%) + 1)
        PRESET (THSCR(StNum%, LastHop%), PHSCR(StNum%, LastHop%) - 1)
        PRESET (THSCR(StNum%, LastHop%) + 1, PHSCR(StNum%, LastHop%))
        PRESET (THSCR(StNum%, LastHop%) - 1, PHSCR(StNum%, LastHop%))
        IF AM(StNum%, LastHop%) < -3 THEN
          PRESET (THSCR(StNum%, LastHop%), PHSCR(StNum%, LastHop%) + 2)
          PRESET (THSCR(StNum%, LastHop%), PHSCR(StNum%, LastHop%) - 2)
          PRESET (THSCR(StNum%, LastHop%) + 2, PHSCR(StNum%, LastHop%))
          PRESET (THSCR(StNum%, LastHop%) - 2, PHSCR(StNum%, LastHop%))
        END IF
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
        IF AM(StNum%, ThisHop%) < -3 THEN
          PSET (THSCR(StNum%, ThisHop%), PHSCR(StNum%, ThisHop%) + 2), 8
          PSET (THSCR(StNum%, ThisHop%), PHSCR(StNum%, ThisHop%) - 2), 8
          PSET (THSCR(StNum%, ThisHop%) + 2, PHSCR(StNum%, ThisHop%)), 8
          PSET (THSCR(StNum%, ThisHop%) - 2, PHSCR(StNum%, ThisHop%)), 8
        END IF
      END IF
    END IF
Skip:
  NEXT StNum%
t(ThisHop%) = TIMER
IF SPEED > 0 THEN SPD! = SPEED * 31536000 / (t(ThisHop%) - t(LastHop%)) ELSE SPD! = 0
IF SPEED < .01 THEN
    sped = SPEED * 63170
    U$ = "A.U."
ELSE
    sped = SPEED
    U$ = "light-years"
END IF
LOCATE 21, 17: PRINT USING "###.## & per jump          "; sped; U$
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

