OPEN "3DSTAR.DAT" FOR APPEND AS #1
PI = 3.141592653589793#
ALF = 62.53 * PI / 180
BET = 78.56 * PI / 180
GAM = 33.02 * PI / 180

Start:
CLS
INPUT "Star Name"; N$
INPUT "Right Ascension (HHMMT)"; RA$
        ' DIVIDE STRING INTO HOUR AND MINUTE VARIABLES
        HR = VAL(LEFT$(RA$, 2))
        RAMIN = (VAL(RIGHT$(RA$, 3))) / 10
INPUT "Declination (ÒDDMM)"; DEC$
        ' DIVIDE STRING INTO DEGREE AND MINUTE VARIABLES
        DEG = VAL(LEFT$(DEC$, LEN(DEC$) - 2))
        MIN = VAL(RIGHT$(DEC$, 2))
        IF DEG < 1 THEN MIN = -1 * MIN
INPUT "Distance in light-years"; D
INPUT "Absolute Magnitude"; M
INPUT "Spectral Type"; S$

        ' COMPUTE VALUES IN RADIANS
        RA1 = ((24 - (HR + RAMIN / 60)) / 24) * 2 * PI
        DEC = ((DEG + MIN / 60) / 360) * 2 * PI

        ' COMPUTE X,Y,Z COORDINATES
        X = D * COS(DEC) * SIN(RA1)
        Y = D * COS(DEC) * COS(RA1)
        Z = D * SIN(DEC)

        ' COMPUTE X,Y,Z GALACTIC COORDINATES
        XG = X * COS(BET) * COS(ALF) * COS(GAM) - Y * SIN(BET) * COS(ALF) * COS(GAM) - Z * SIN(ALF) * COS(GAM) - Y * COS(BET) * SIN(GAM) - X * SIN(BET) * SIN(GAM)
        YG = Y * COS(BET) * COS(GAM) + X * SIN(BET) * COS(GAM) + X * COS(BET) * COS(ALF) * SIN(GAM) - Y * SIN(BET) * COS(ALF) * SIN(GAM) - Z * SIN(ALF) * SIN(GAM)
        ZG = Z * COS(ALF) + X * COS(BET) * SIN(ALF) - Y * SIN(BET) * SIN(ALF)
       
PRINT : PRINT "The rectangular equatorial coordinates of "; N$; " are:"
PRINT : PRINT "X = "; X
PRINT "Y = "; Y
PRINT "Z = "; Z

PRINT : PRINT "The rectangular galactic coordinates of "; N$; " are:"
PRINT : PRINT "X = "; XG
PRINT "Y = "; YG
PRINT "Z = "; ZG

PRINT : INPUT "Would you like to save this data"; YN$
IF YN$ = "Y" THEN GOTO Save
IF YN$ = "y" THEN GOTO Save

Another:
PRINT : INPUT "Another star"; YN$
IF YN$ = "Y" THEN GOTO Start
IF YN$ = "y" THEN GOTO Start
END

Save:
WRITE #1, N$, XG, YG, ZG, M, S$
PRINT : PRINT "Data saved."
GOTO Another

