DECLARE SUB StarMap ()
DIM N$(75), X(75), Y(75), Z(75), M(75), S$(75), S(75, 3), l(75), PHSCR(75, 5), THSCR(75, 5), t(5), AM(75, 5)
PI = 3.1415926535#

OPEN "3dstar.dat" FOR INPUT AS #1
CLS : PRINT "Loading star data..."
DO WHILE N$(NumStars) <> "done"
  LET NumStars = NumStars + 1
  INPUT #1, N$(NumStars), X(NumStars), Y(NumStars), Z(NumStars), M(NumStars), S$(NumStars)
  SS$ = ""
  RESTORE
  DO WHILE S$(NumStars) <> SS$
    READ SS$, S(NumStars, 1), S(NumStars, 2), S(NumStars, 3)
  LOOP
  IF M > 10 THEN a = a - 1
LOOP
NumStars = NumStars - 1

CLS
PRINT "Initial coordinates [default -0.1,-0.1,-0.1]:"
INPUT "  X = "; Xo: IF Xo = 0 THEN Xo = -.1
INPUT "  Y = "; Yo: IF Yo = 0 THEN Yo = -.1
INPUT "  Z = "; Zo: IF Zo = 0 THEN Zo = -.1
PRINT : PRINT "Initial course [default 0 mark 0]:"
INPUT "  GalLong (0ø to 360ø) = "; GalLong: GalLong = GalLong * PI / 180
INPUT "  GalLat (-90ø to +90ø) = "; GalLat: GalLat = GalLat * PI / 180
PRINT : INPUT "Speed factor [default .05] = "; SPEED: IF SPEED = 0 THEN SPEED = .05
PRINT : INPUT "Magnification [default 1] = "; MAG: IF MAG = 0 THEN MAG = 1

First = 1
Last = NumStars

MakeScreen:
RePlot = 0
CLS 0: SCREEN 12
VIEW (1, 1)-(620, 310), 0, 2

DO
  MAGX = 1.7222 * MAG
  MAGY = 1.7222 * MAG
  StarHopMinusOne = StarHop
  StarHop = StarHop + 1: IF StarHop = 5 THEN StarHop = 1: StarHopMinusOne = 4
  FOR StarNum = First TO Last
  XS = (X(StarNum) - Xo) * COS(GalLong) - (Y(StarNum) - Yo) * SIN(GalLong)
  YS = (Y(StarNum) - Yo) * COS(GalLong) * COS(GalLat) + (X(StarNum) - Xo) * SIN(GalLong) * COS(GalLat) + (Z(StarNum) - Zo) * SIN(GalLat)
  ZS = (Z(StarNum) - Zo) * COS(GalLat) - (Y(StarNum) - Yo) * COS(GalLong) * SIN(GalLat) - (X(StarNum) - Xo) * SIN(GalLong) * SIN(GalLat)
  DIST = SQR(XS ^ 2 + YS ^ 2 + ZS ^ 2)
  AM(StarNum, StarHop) = M(StarNum) - 5 + 5 * LOG(DIST / 3.26) / LOG(10)
  IF AM(StarNum, StarHop) < 2 THEN l(StarNum) = 1 ELSE IF AM(StarNum, StarHop) < 4 THEN l(StarNum) = 2 ELSE IF AM(StarNum, StarHop) < 7 THEN l(StarNum) = 3
  IF YS = 0 THEN IF XS > 0 THEN THETA = 90 ELSE THETA = -90 ELSE THETA = ATN(XS / YS) * 180 / PI
  IF SQR(XS ^ 2 + YS ^ 2) = 0 THEN IF Z > 0 THEN PHI = 90 ELSE PHI = -90 ELSE PHI = ATN(ZS / SQR(XS ^ 2 + YS ^ 2)) * 180 / PI
  IF YS < 0 THEN THETA = THETA + 180
  IF THETA > 180 THEN THETA = THETA - 360
  THSCR(StarNum, StarHop) = 310 + THETA * MAGX
  PHSCR(StarNum, StarHop) = 155 - PHI * MAGY
  NEXT StarNum
  SPEEDX = SPEED * COS(GalLat) * SIN(GalLong)
  SPEEDY = SPEED * COS(GalLat) * COS(GalLong)
  SPEEDZ = SPEED * SIN(GalLat)
  t(StarHop) = TIMER: C = SPEED * 31536000 / (t(StarHop) - t(StarHopMinusOne))
  SPD! = SPEED * 31536000 / (t(StarHop) - t(StarHopMinusOne))
  LOCATE 21, 1: PRINT "Speed         ="; SPEED; "light-years per jump ("; SPD!; "c)  "
  LOCATE 22, 1: PRINT "Course        ="; GalLong * 180 / PI; "mark"; GalLat * 180 / PI
  LOCATE 23, 1: PRINT "Coordinates   ="; Xo; ","; Yo; ","; Zo
  LOCATE 24, 1: PRINT "Magnification ="; MAG
  X$ = INKEY$
  IF X$ = "2" THEN GalLat = GalLat - 5 * PI / 180
  IF X$ = "8" THEN GalLat = GalLat + 5 * PI / 180
  IF X$ = "4" THEN GalLong = GalLong - 5 * PI / 180
  IF X$ = "6" THEN GalLong = GalLong + 5 * PI / 180
  IF X$ = "Z" THEN MAG = MAG * 2
  IF X$ = "X" THEN MAG = MAG / 2
  IF X$ = "A" THEN SPEED = SPEED * 2
  IF X$ = "S" THEN SPEED = SPEED / 2
  IF X$ = "M" THEN CALL StarMap: RePlot = 1
  IF RePlot = 1 GOTO MakeScreen
  FOR StarNum = First TO Last
    IF AM(StarNum, StarHopMinusOne) < 6 THEN PAINT (THSCR(StarNum, StarHopMinusOne), PHSCR(StarNum, StarHopMinusOne)), 0
    IF THSCR(StarNum, StarHop) > 2 THEN IF PHSCR(StarNum, StarHop) > 2 THEN IF THSCR(StarNum, StarHop) < 619 THEN IF PHSCR(StarNum, StarHop) < 309 THEN IF AM(StarNum, StarHop) < 6 THEN CIRCLE (THSCR(StarNum, StarHop), PHSCR(StarNum, StarHop)), ((6 - AM(StarNum, StarHop)) / 4.75), S(StarNum, l(StarNum))
    IF THSCR(StarNum, StarHop) > 2 THEN IF PHSCR(StarNum, StarHop) > 2 THEN IF THSCR(StarNum, StarHop) < 619 THEN IF PHSCR(StarNum, StarHop) < 309 THEN IF AM(StarNum, StarHop) < 6 THEN PAINT (THSCR(StarNum, StarHop), PHSCR(StarNum, StarHop)), S(StarNum, l(StarNum))
  NEXT StarNum
  Xo = Xo + SPEEDX
  Yo = Yo + SPEEDY
  Zo = Zo + SPEEDZ
LOOP

DATA "O",11,9,8,"B",11,9,8,"A",15,7,8,"F",15,7,8
DATA "G",14,14,8,"K",6,4,8,"M",12,4,8,"0",0,0,0

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

