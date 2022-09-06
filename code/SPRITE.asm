;Desktop Environment System (DES) Game
;-----------------------------------------------------;
;                                                     ;
;                  ____  _____ ____                   ;
;                 |  _ \| ____/ ___|                  ;
;                 | | | |  _| \___ \                  ;
;                 | |_| | |___ ___) |                 ;
;                 |____/|_____|____/                  ;
;      _       _                 _                    ;
;     / \   __| |_   _____ _ __ | |_ _   _ _ __ ___   ;
;    / _ \ / _` \ \ / / _ \ '_ \| __| | | | '__/ _ \  ;
;   / ___ \ (_| |\ V /  __/ | | | |_| |_| | | |  __/  ;
;  /_/   \_\__,_| \_/ \___|_| |_|\__|\__,_|_|  \___|  ;
;                                                     ;
;------------------------------------------------------
;                                                     ;
;               Written by Brian Chiha                ;
;               brian.chiha@gmail.com                 ;
;           github.com/bchiha/DES_Adventure           ;
;                                                     ;
;------------------------------------------------------

;SPRITE DATA LOOKUP TABLES

;SPOILER - THIS IS THE ACTUAL MAP
;            0 1 2 3 4 5 6 7
;           +-+-+-+-+-+-+-+-+
;       A   |S        |#|   |
;           +-+ +-+-+ + +-+-+
;       B   |   |     |     |
;           + +-+ +-+-+-+-+ +
;       C   |   |   |     | |
;           +-+ +-+-+ +-+ + +
;       D   | |      H  |   |
;           +-+-+-+-+ + +-+-+
;       E   |#| |   | | | |1|
;           + +-+ + + + +-+ +
;       F   |     | | |   | |
;           +-+-+-+ + +-+ + +
;       G   |#| | |     |#| |
;           + +-+-+-+-+ +-+ +
;       H   |             |E|
;           +-+-+-+-+-+-+-+-+
;KEY:
;  S = START, E = END, # = CHEST, H = LADDER, 1 = LEVEL 1

;WORLD MAP.  CONTAINS INDEXES OF 8x8 LOCAL MAP
MAPW_TBL:      DB      &0E,&01,&05,&05,&02,&0D,&10,&10
               DB      &07,&04,&07,&05,&04,&06,&05,&02
               DB      &06,&02,&06,&00,&07,&05,&02,&03
               DB      &10,&06,&05,&05,&0F,&02,&06,&04
               DB      &0D,&10,&07,&02,&03,&03,&10,&09
               DB      &06,&05,&04,&03,&03,&06,&02,&0A
               DB      &0D,&10,&10,&06,&08,&02,&0C,&0A
               DB      &06,&05,&05,&05,&05,&08,&00,&0B


;LOCAL MAP DATA.  CONTAINS INDEX OF SPRTBL ENTRIES
MAPL_TBL:      DW      L_00     ;  OUTSIDE LEFT EXIT
               DW      L_01     ;  OUTSIDE BOTTOM/LEFT/RIGHT EXIT
               DW      L_02     ;  OUTSIDE BOTTOM/LEFT EXIT
               DW      L_03     ;  OUTSIDE BOTTOM/TOP EXIT
               DW      L_04     ;  OUTSIDE LEFT/TOP EXIT
               DW      L_05     ;  OUTSIDE LEFT/RIGHT EXIT
               DW      L_06     ;  OUTSIDE TOP/RIGHT EXIT
               DW      L_07     ;  OUTSIDE BOTTOM/RIGHT EXIT
               DW      L_08     ;  LEFT/RIGHT/TOP EXIT
               DW      L_09     ;  LEVEL 1 BOTTOM EXIT
               DW      L_0A     ;  LEVEL 1 TOP/BOTTOM EXIT
               DW      L_0B     ;  LEVEL 1 TOP/END GAME
               DW      L_0C     ;  CHEST TOP EXIT
               DW      L_0D     ;  CHEST BOTTOM EXIT
               DW      L_0E     ;  SIGN RIGHT EXIT
               DW      L_0F     ;  LADDER ALL EXIT

;SPRITE LOOKUP TABLE.  SORTED BY WALKABLE SPRITES FIRST THEN NON WALKABLE
SPR_TBL:       DW      SPRGRS   ;0  GRASS
               DW      SPRFLO   ;1  FLOWERS
               DW      SPRRDV   ;2  ROAD VERTICAL
               DW      SPRRDH   ;3  ROAD HORIZONTAL      
               DW      SPRRJU   ;4  ROAD JUNCTION UP
               DW      SPRRJD   ;5  ROAD JUNCTION DOWN
               DW      SPRBDG   ;6  BRIDGE
               DW      SPRLAD   ;7  DOWN LADDER
               DW      SPRBRK   ;8  BRICK WALL <-- NON WALKABLE FROM HERE
               DW      SPRSGN   ;9  SIGN
               DW      SPRTRB   ;A  TREE BASE
               DW      SPRTRM   ;B  TREE MID
               DW      SPRTRT   ;C  TREE TOP
               DW      SPRWTR   ;D  WATER
               DW      SPRCST   ;E  CHEST
               DW      SPRGUY   ;F  END GUY

;TREASURE LOOKUP TABLE.  FOUR TO BE FOUND.  INDEX BASED ON CHEST NUMBER
TRES_TBL:      DW      TREA_0   ;0  BLANK
               DW      TREA_1   ;1  SOURCE CODE
               DW      TREA_2   ;2  FLOPPY DISC
               DW      TREA_3   ;3  COMPUTER
               DW      TREA_4   ;4  READY Z80

;SPRITE CHARACTER WALKING TABLE
CHAR_TBL:      DW      SPRMAN_N ;NORTH
               DW      SPRMAN_W ;WEST
               DW      SPRMAN_S ;SOUTH
               DW      SPRMAN_E ;EAST

;SPRITE DATA

;SPRITE CHARACTER
;----------------
;SOUTH FACING
SPRMAN_S:      DB      &00,&0F,&F0,&00,&00,&FC,&3F,&00
               DB      &03,&FF,&FF,&C0,&03,&FF,&FF,&C0
               DB      &0F,&FF,&FF,&F0,&0F,&33,&CC,&F0
               DB      &0C,&C0,&00,&30,&0C,&0C,&30,&30
               DB      &03,&0C,&30,&C0,&00,&C0,&03,&00
               DB      &03,&3F,&FC,&C0,&0C,&30,&0C,&30
               DB      &03,&CF,&F3,&C0,&00,&F0,&0F,&00
               DB      &00,&FF,&FF,&00,&00,&3C,&3C,&00

;EAST FACING
SPRMAN_E:      DB      &00,&0F,&FC,&00,&00,&FF,&FF,&00
               DB      &03,&FF,&FF,&00,&0F,&FF,&FF,&C0
               DB      &0F,&FC,&00,&C0,&0F,&F0,&0C,&C0
               DB      &0F,&F0,&0C,&C0,&0F,&F0,&00,&C0
               DB      &03,&FC,&03,&00,&00,&FF,&FC,&00
               DB      &00,&33,&33,&00,&00,&33,&33,&00
               DB      &00,&30,&F3,&00,&00,&3C,&0C,&00
               DB      &00,&0F,&FC,&00,&00,&03,&F0,&00

;NORTH FACING
SPRMAN_N:      DB      &00,&0F,&F0,&00,&00,&FF,&FF,&00
               DB      &03,&FF,&FF,&C0,&03,&FF,&FF,&C0
               DB      &0F,&FF,&FF,&F0,&0F,&FF,&FF,&F0
               DB      &0C,&FF,&FF,&30,&0C,&3F,&FC,&30
               DB      &03,&00,&00,&C0,&00,&C0,&03,&00
               DB      &03,&3F,&FC,&C0,&0C,&3F,&FC,&30
               DB      &03,&CF,&F3,&C0,&00,&F0,&0F,&00
               DB      &00,&FF,&FF,&00,&00,&3C,&3C,&00

;WEST FACING
SPRMAN_W:      DB      &00,&3F,&F0,&00,&00,&FF,&FF,&00
               DB      &00,&FF,&FF,&C0,&03,&FF,&FF,&F0
               DB      &03,&00,&3F,&F0,&03,&30,&0F,&F0
               DB      &03,&30,&0F,&F0,&03,&00,&0F,&F0
               DB      &00,&C0,&3F,&C0,&00,&3F,&FF,&00
               DB      &00,&CC,&CC,&00,&00,&CC,&CC,&00
               DB      &00,&CF,&0C,&00,&00,&30,&3C,&00
               DB      &00,&3F,&F0,&00,&00,&0F,&C0,&00

;LOCATIONS
;---------
;OUTSIDE LEFT EXIT
L_00:          DB      &0C,&0C,&0C,&0C,&0C,&0C,&0C,&0C
               DB      &0A,&0A,&0A,&0A,&0A,&0A,&0B,&0B
               DB      &00,&00,&00,&00,&01,&01,&0A,&0B
               DB      &03,&03,&03,&03,&03,&00,&01,&0B
               DB      &00,&00,&00,&00,&00,&00,&0C,&0B
               DB      &0C,&00,&01,&0C,&01,&01,&0B,&0B
               DB      &0B,&0C,&0C,&0B,&0C,&0C,&0B,&0B
               DB      &0A,&0A,&0A,&0A,&0A,&0A,&0A,&0A

;OUTSIDE BOTTOM/LEFT/RIGHT EXIT
L_01:          DB      &0C,&0C,&0C,&0C,&0C,&0C,&0C,&0C
               DB      &0A,&0A,&0A,&0A,&0A,&0A,&0A,&0A
               DB      &00,&01,&01,&00,&00,&00,&00,&01
               DB      &03,&03,&03,&05,&03,&03,&03,&03
               DB      &00,&0C,&00,&02,&00,&01,&00,&00
               DB      &0C,&0B,&00,&02,&00,&00,&0C,&0C
               DB      &0B,&0B,&00,&02,&00,&01,&0B,&0B
               DB      &0A,&0A,&00,&02,&00,&00,&0A,&0A

;OUTSIDE BOTTOM/LEFT EXIT
L_02:          DB      &0C,&0C,&0C,&0C,&0C,&0C,&0C,&0C
               DB      &0A,&0A,&0A,&0A,&0A,&0A,&0A,&0B
               DB      &00,&01,&01,&00,&00,&00,&00,&0B
               DB      &03,&03,&03,&05,&03,&01,&00,&0B
               DB      &00,&00,&00,&02,&00,&01,&00,&0B
               DB      &0C,&0C,&00,&02,&00,&00,&0C,&0B
               DB      &0B,&0B,&00,&02,&00,&00,&0B,&0B
               DB      &0A,&0A,&00,&02,&00,&00,&0A,&0A

;OUTSIDE BOTTOM/TOP EXIT
L_03:          DB      &0C,&0C,&00,&02,&00,&00,&0C,&0C
               DB      &0B,&0A,&00,&02,&01,&01,&0A,&0B
               DB      &0B,&00,&01,&02,&00,&01,&01,&0B
               DB      &0B,&00,&00,&02,&00,&01,&01,&0B
               DB      &0B,&00,&00,&02,&00,&01,&01,&0B
               DB      &0B,&0C,&00,&02,&00,&00,&0C,&0B
               DB      &0B,&0B,&00,&02,&00,&00,&0B,&0B
               DB      &0A,&0A,&00,&02,&00,&00,&0A,&0A

;OUTSIDE LEFT/TOP EXIT
L_04:          DB      &0C,&0C,&00,&02,&00,&00,&0C,&0C
               DB      &0A,&0A,&00,&02,&01,&01,&0B,&0B
               DB      &00,&00,&01,&02,&00,&01,&0B,&0B
               DB      &03,&03,&03,&01,&00,&00,&0A,&0B
               DB      &00,&00,&00,&02,&00,&00,&00,&0B
               DB      &0C,&01,&00,&02,&00,&0C,&0C,&0B
               DB      &0B,&0C,&00,&0C,&00,&0B,&0B,&0B
               DB      &0A,&0A,&0C,&0A,&0C,&0A,&0A,&0A

;OUTSIDE LEFT/RIGHT EXIT
L_05:          DB      &0C,&0C,&0C,&0C,&0C,&0C,&0C,&0C
               DB      &0A,&0A,&0A,&0A,&0A,&0A,&0A,&0A
               DB      &00,&00,&01,&01,&00,&01,&01,&01
               DB      &03,&03,&03,&03,&03,&03,&03,&03
               DB      &00,&00,&00,&00,&00,&00,&00,&00
               DB      &0C,&01,&00,&00,&00,&0C,&0C,&0C
               DB      &0B,&0C,&00,&0C,&00,&0B,&0B,&0B
               DB      &0A,&0A,&0C,&0A,&0C,&0A,&0A,&0A

;OUTSIDE TOP/RIGHT EXIT
L_06:          DB      &0C,&0C,&00,&02,&00,&00,&0C,&0C
               DB      &0B,&0B,&00,&02,&00,&0C,&0A,&0A
               DB      &0B,&0B,&01,&02,&00,&0A,&01,&01
               DB      &0B,&0B,&01,&01,&03,&03,&03,&03
               DB      &0B,&0B,&00,&00,&00,&00,&00,&00
               DB      &0B,&0B,&00,&00,&00,&0C,&0C,&0C
               DB      &0B,&0B,&00,&0C,&00,&0B,&0B,&0B
               DB      &0A,&0A,&0C,&0A,&0C,&0A,&0A,&0A

;OUTSIDE BOTTOM/RIGHT EXIT
L_07:          DB      &0C,&0C,&0C,&0C,&0C,&0C,&0C,&0C
               DB      &0B,&0B,&0A,&0A,&0A,&0A,&0A,&0A
               DB      &0B,&0A,&01,&01,&00,&00,&00,&00
               DB      &0B,&00,&00,&01,&03,&03,&03,&03
               DB      &0B,&0C,&00,&02,&00,&00,&00,&00
               DB      &0B,&0B,&00,&02,&00,&01,&0C,&0C
               DB      &0B,&0B,&00,&02,&00,&00,&0B,&0B
               DB      &0A,&0A,&00,&02,&01,&00,&0A,&0A

;OUTSIDE LEFT/RIGHT/TOP EXIT
L_08:          DB      &0C,&0C,&00,&02,&00,&00,&0C,&0C
               DB      &0A,&0A,&00,&02,&01,&00,&0A,&0A
               DB      &00,&00,&01,&02,&00,&01,&01,&01
               DB      &03,&03,&03,&04,&03,&03,&03,&03
               DB      &00,&00,&00,&00,&00,&00,&00,&00
               DB      &0C,&01,&00,&00,&00,&0C,&0C,&0C
               DB      &0B,&0C,&00,&0C,&00,&0B,&0B,&0B
               DB      &0A,&0A,&0C,&0A,&0C,&0A,&0A,&0A

;LEVEL 1 BOTTOM EXIT
L_09:          DB      &0D,&0D,&0D,&0D,&0D,&0D,&0D,&0D
               DB      &0D,&0D,&0D,&0D,&0D,&0D,&0D,&0D
               DB      &0D,&0D,&0D,&06,&0D,&0D,&0D,&0D
               DB      &0D,&0D,&0D,&06,&0D,&0D,&0D,&0D
               DB      &0D,&0D,&0D,&06,&0D,&0D,&0D,&0D
               DB      &0D,&0D,&0D,&06,&0D,&0D,&0D,&0D
               DB      &0D,&0D,&0D,&06,&0D,&0D,&0D,&0D
               DB      &0D,&0D,&0D,&06,&0D,&0D,&0D,&0D

;LEVEL 1 TOP/BOTTOM EXIT
L_0A:          DB      &0D,&0D,&0D,&06,&0D,&0D,&0D,&0D
               DB      &0D,&0D,&0D,&06,&0D,&0D,&0D,&0D
               DB      &0D,&0D,&0D,&06,&0D,&0D,&0D,&0D
               DB      &0D,&0D,&0D,&06,&0D,&0D,&0D,&0D
               DB      &0D,&0D,&0D,&06,&0D,&0D,&0D,&0D
               DB      &0D,&0D,&0D,&06,&0D,&0D,&0D,&0D
               DB      &0D,&0D,&0D,&06,&0D,&0D,&0D,&0D
               DB      &0D,&0D,&0D,&06,&0D,&0D,&0D,&0D

;LEVEL 1 TOP/END GAME
L_0B:          DB      &0D,&0D,&0D,&06,&0D,&0D,&0D,&0D
               DB      &0D,&0D,&0D,&06,&0D,&0D,&0D,&0D
               DB      &0D,&0D,&0D,&06,&0D,&0D,&0D,&0D
               DB      &0D,&0D,&0D,&06,&0D,&0D,&0D,&0D
               DB      &0D,&0D,&0D,&06,&0D,&0D,&0D,&0D
               DB      &08,&00,&00,&00,&00,&00,&00,&08
               DB      &08,&00,&00,&0F,&00,&00,&09,&08
               DB      &08,&08,&08,&08,&08,&08,&08,&08

;CHEST TOP EXIT
L_0C:          DB      &0C,&0C,&00,&02,&00,&00,&0C,&0C
               DB      &0B,&0A,&00,&02,&00,&00,&0A,&0B
               DB      &0B,&01,&00,&02,&00,&00,&01,&0B
               DB      &0B,&08,&01,&01,&01,&01,&08,&0B
               DB      &0B,&08,&01,&0E,&01,&01,&08,&0B
               DB      &0B,&0C,&08,&08,&08,&08,&0C,&0B
               DB      &0B,&0B,&0C,&0C,&0C,&0C,&0B,&0B
               DB      &0A,&0A,&0A,&0A,&0A,&0A,&0A,&0A

;CHEST BOTTOM EXIT
L_0D:          DB      &0C,&0C,&0C,&0C,&0C,&0C,&0C,&0C
               DB      &0B,&0B,&0A,&0A,&0A,&0A,&0B,&0B
               DB      &0B,&0A,&08,&08,&08,&08,&0A,&0B
               DB      &0B,&08,&01,&00,&0E,&00,&08,&0B
               DB      &0B,&08,&00,&00,&00,&00,&08,&0B
               DB      &0B,&01,&00,&02,&00,&00,&01,&0B
               DB      &0B,&0C,&01,&02,&00,&00,&0C,&0B
               DB      &0A,&0A,&01,&02,&00,&00,&0A,&0A

;SIGN RIGHT EXIT
L_0E:          DB      &0C,&0C,&0C,&0C,&0C,&0C,&0C,&0C
               DB      &0B,&0B,&0A,&0A,&0A,&0A,&0A,&0A
               DB      &0B,&0A,&01,&09,&00,&00,&00,&00
               DB      &0B,&01,&00,&03,&03,&03,&03,&03
               DB      &0B,&0C,&00,&00,&00,&00,&00,&00
               DB      &0B,&0B,&01,&01,&0C,&01,&00,&0C
               DB      &0B,&0B,&0C,&0C,&0B,&0C,&0C,&0B
               DB      &0A,&0A,&0A,&0A,&0A,&0A,&0A,&0A

;HOLE ALL EXIT
L_0F:          DB      &0C,&0C,&00,&02,&00,&00,&0C,&0C
               DB      &0A,&0A,&00,&02,&01,&01,&0A,&0A
               DB      &00,&00,&01,&02,&00,&01,&01,&00
               DB      &03,&03,&03,&07,&03,&03,&03,&03
               DB      &00,&00,&00,&02,&00,&01,&00,&00
               DB      &0C,&0C,&00,&02,&00,&00,&0C,&0C
               DB      &0B,&0B,&00,&02,&00,&00,&0B,&0B
               DB      &0A,&0A,&00,&02,&00,&00,&0A,&0A
;SPRITES
;-------
;GRASS
SPRGRS:        DB      &00,&00,&00,&00,&00,&C0,&00,&00
               DB      &C3,&0C,&00,&00,&33,&30,&00,&00
               DB      &00,&00,&30,&00,&00,&03,&0C,&30
               DB      &00,&00,&CC,&C0,&00,&00,&00,&00
               DB      &00,&00,&00,&00,&0C,&00,&00,&00
               DB      &C3,&0C,&00,&00,&33,&30,&00,&00
               DB      &00,&00,&03,&00,&00,&03,&0C,&0C
               DB      &00,&00,&CC,&30,&00,&00,&00,&00

;FLOWERS
SPRFLO:        DB      &30,&00,&00,&0C,&CC,&03,&00,&33
               DB      &30,&0C,&C0,&0C,&30,&33,&00,&0C
               DB      &00,&CF,&0C,&00,&00,&30,&33,&00
               DB      &00,&30,&0C,&0C,&00,&00,&0C,&33
               DB      &0C,&0C,&00,&0C,&33,&33,&0C,&0C
               DB      &0C,&0C,&33,&00,&0C,&0C,&CC,&00
               DB      &00,&C3,&3C,&0C,&03,&30,&C0,&33
               DB      &00,&C0,&C0,&0C,&00,&C0,&00,&0C

;ROAD VERTICAL
SPRRDV:        DB      &0C,&C0,&00,&30,&3C,&00,&00,&3C
               DB      &30,&00,&30,&0C,&30,&00,&00,&0C
               DB      &30,&0C,&00,&0C,&30,&00,&00,&0C
               DB      &30,&00,&00,&3C,&30,&30,&C0,&30
               DB      &30,&00,&00,&30,&30,&00,&00,&0C
               DB      &3C,&00,&C0,&0C,&0C,&00,&00,&0C
               DB      &0C,&00,&03,&0C,&3C,&0C,&00,&30
               DB      &30,&00,&00,&30,&30,&00,&00,&30

;ROAD HORIZONTAL
SPRRDH:        DB      &00,&00,&00,&00,&FC,&3F,&FF,&FC
               DB      &0F,&F0,&00,&0F,&00,&00,&00,&00
               DB      &00,&00,&00,&03,&00,&00,&C0,&00
               DB      &0C,&00,&03,&00,&00,&00,&00,&00
               DB      &00,&30,&C0,&00,&00,&00,&00,&30
               DB      &00,&00,&00,&00,&03,&00,&00,&00
               DB      &00,&00,&00,&00,&FC,&03,&F0,&0F
               DB      &03,&FC,&3F,&FC,&00,&00,&00,&00

;ROAD JUNCTION UP
SPRRJU:        DB      &0C,&00,&00,&3C,&0C,&00,&00,&0F
               DB      &F0,&00,&C0,&00,&00,&00,&00,&00
               DB      &00,&00,&0C,&00,&00,&30,&00,&00
               DB      &00,&00,&00,&00,&00,&00,&03,&00
               DB      &00,&00,&00,&00,&00,&00,&C0,&0C
               DB      &00,&00,&00,&00,&00,&00,&00,&00
               DB      &00,&00,&00,&00,&03,&FF,&C0,&3C
               DB      &FF,&00,&FF,&F3,&00,&00,&00,&00

;ROAD JUNCTION DOWN
SPRRJD:        DB      &00,&00,&00,&00,&CF,&FF,&00,&FF
               DB      &3C,&03,&FF,&C0,&00,&00,&00,&00
               DB      &00,&00,&00,&00,&00,&00,&00,&00
               DB      &30,&03,&00,&00,&00,&00,&00,&00
               DB      &00,&C0,&00,&00,&00,&00,&0C,&00
               DB      &00,&30,&00,&00,&00,&00,&00,&00
               DB      &00,&00,&00,&00,&00,&03,&00,&0F
               DB      &F0,&00,&00,&30,&3C,&00,&00,&30

;BRIDGE
SPRBDG:        DB      &CF,&FF,&FF,&F3,&F0,&00,&03,&0F
               DB      &F0,&0C,&00,&0F,&CF,&FF,&FF,&F3
               DB      &C0,&00,&00,&03,&C0,&00,&0C,&03
               DB      &CF,&FF,&FF,&F3,&F0,&C0,&00,&0F
               DB      &F0,&00,&30,&0F,&CF,&FF,&FF,&C3
               DB      &C0,&00,&00,&03,&C0,&C0,&00,&03
               DB      &CF,&FF,&FF,&F3,&F0,&00,&30,&0F
               DB      &F0,&00,&00,&0F,&C0,&00,&00,&03

;DOWN LADDER
SPRLAD:        DB      &00,&0C,&03,&00,&0C,&0F,&FF,&00
               DB      &C3,&0C,&03,&00,&33,&0C,&03,&00
               DB      &00,&0F,&FF,&C0,&00,&30,&00,&F0
               DB      &00,&F3,&FC,&FC,&0F,&F3,&FC,&FC
               DB      &03,&FF,&FF,&FC,&03,&FF,&FF,&FC
               DB      &00,&FF,&FF,&FC,&00,&FF,&FF,&00
               DB      &0C,&0F,&FC,&0C,&30,&C0,&0C,&30
               DB      &33,&00,&03,&30,&00,&00,&00,&00

;BRICKS
SPRBRK:        DB      &3C,&FC,&3F,&FC,&3F,&FF,&3C,&FF
               DB      &0F,&FF,&0F,&CF,&00,&00,&00,&00
               DB      &FC,&CF,&3F,&0F,&FF,&3F,&FF,&3F
               DB      &FF,&3F,&FC,&3F,&00,&00,&00,&00
               DB      &3F,&F3,&33,&F3,&3F,&FF,&0F,&FF
               DB      &3F,&3F,&0F,&3F,&00,&00,&00,&00
               DB      &FF,&0F,&FF,&3F,&FF,&3F,&3F,&3F
               DB      &FC,&0F,&CF,&0F,&00,&00,&00,&00

;SIGN
SPRSGN:        DB      &00,&00,&00,&00,&00,&00,&00,&00
               DB      &03,&FF,&FF,&C0,&0C,&00,&00,&30
               DB      &0C,&00,&00,&0C,&0C,&F3,&3C,&CC
               DB      &0C,&00,&00,&0C,&0C,&CF,&3C,&CC
               DB      &0C,&00,&00,&0C,&0F,&00,&00,&0C
               DB      &00,&C0,&00,&0C,&00,&FF,&FF,&F0
               DB      &00,&03,&30,&00,&00,&03,&30,&00
               DB      &00,&03,&30,&00,&00,&03,&C0,&00

;TREE BASE
SPRTRB:        DB      &30,&C0,&CC,&3C,&30,&0C,&03,&0C
               DB      &0C,&00,&0C,&0C,&0C,&30,&C0,&3C
               DB      &30,&0F,&33,&FC,&33,&C3,&CF,&FC
               DB      &30,&33,&FF,&F0,&0C,&0F,&FF,&C0
               DB      &03,&F3,&CF,&00,&00,&03,&C0,&00
               DB      &00,&33,&C0,&30,&30,&C3,&F0,&C0
               DB      &0C,&C3,&CC,&C0,&00,&0F,&F0,&00
               DB      &00,&FF,&CC,&00,&00,&00,&00,&00

;TREE MID
SPRTRM:        DB      &C3,&3F,&C3,&0C,&30,&C0,&30,&0C
               DB      &3C,&C3,&0C,&30,&0F,&0C,&33,&30
               DB      &0C,&03,&00,&C0,&30,&C0,&CC,&C0
               DB      &30,&0C,&00,&30,&0C,&00,&00,&30
               DB      &30,&C0,&C3,&0C,&30,&0C,&00,&30
               DB      &0C,&00,&0C,&30,&0C,&30,&C3,&0C
               DB      &30,&0C,&30,&0C,&33,&C0,&00,&3C
               DB      &30,&30,&33,&30,&C0,&00,&C0,&0C

;TREE TOP
SPRTRT:        DB      &00,&3F,&C0,&00,&00,&C0,&30,&00
               DB      &00,&C3,&0C,&00,&0F,&0C,&33,&00
               DB      &0C,&03,&00,&C0,&30,&0C,&CC,&C0
               DB      &30,&0C,&00,&30,&0C,&00,&00,&30
               DB      &30,&C0,&C3,&0C,&30,&0C,&00,&30
               DB      &0C,&00,&0C,&30,&0C,&30,&C3,&0C
               DB      &30,&0C,&30,&0C,&33,&C0,&00,&3C
               DB      &30,&30,&33,&30,&C0,&00,&C0,&0C

;WATER
SPRWTR:        DB      &FF,&FF,&FF,&FF,&F3,&F3,&F3,&F3
               DB      &CF,&CF,&CF,&CF,&FF,&FF,&FF,&FF
               DB      &FF,&FF,&FF,&FF,&F3,&F3,&F3,&F3
               DB      &CF,&CF,&CF,&CF,&FF,&FF,&FF,&FF
               DB      &FF,&FF,&FF,&FF,&F3,&F3,&F3,&F3
               DB      &CF,&CF,&CF,&CF,&FF,&FF,&FF,&FF
               DB      &FF,&FF,&FF,&FF,&F3,&F3,&F3,&F3
               DB      &CF,&CF,&CF,&CF,&FF,&FF,&FF,&FF

;CHSET
SPRCST:        DB      &0C,&00,&00,&00,&30,&00,&00,&00
               DB      &00,&3F,&FF,&F0,&03,&C0,&00,&FC
               DB      &0C,&00,&03,&0C,&0C,&00,&03,&3C
               DB      &30,&3F,&CC,&CC,&3F,&FF,&FF,&0C
               DB      &30,&C3,&0C,&0C,&30,&3C,&0C,&3C
               DB      &30,&00,&0C,&30,&3C,&00,&3F,&C0
               DB      &3F,&00,&FF,&03,&3F,&FF,&FC,&0C
               DB      &00,&00,&00,&0C,&00,&00,&00,&00

;END GUY
SPRGUY:        DB      &00,&FF,&FF,&00,&03,&FC,&3F,&C0
               DB      &03,&FC,&3F,&C0,&03,&C0,&03,&C0
               DB      &0F,&3F,&FC,&F0,&0F,&FF,&FF,&F0
               DB      &33,&C0,&03,&CC,&30,&3C,&3C,&0C
               DB      &0F,&03,&C0,&F0,&0F,&CC,&33,&F0
               DB      &30,&F0,&0F,&0C,&30,&F0,&0F,&0C
               DB      &0F,&CC,&33,&F0,&03,&0F,&F0,&C0
               DB      &03,&FF,&FF,&C0,&00,&FC,&3F,&00

;TREASURES
;---------
;BLANK
TREA_0:        DB      &FF,&FF,&FF,&FF,&C0,&00,&00,&03
               DB      &C0,&00,&00,&03,&C0,&00,&00,&03
               DB      &C0,&00,&00,&03,&C0,&00,&00,&03
               DB      &C0,&00,&00,&03,&C0,&00,&00,&03
               DB      &C0,&00,&00,&03,&C0,&00,&00,&03
               DB      &C0,&00,&00,&03,&C0,&00,&00,&03
               DB      &C0,&00,&00,&03,&C0,&00,&00,&03
               DB      &C0,&00,&00,&03,&FF,&FF,&FF,&FF

;SOURCE CODE
TREA_1:        DB      &FF,&FF,&FF,&FF,&C0,&00,&00,&03
               DB      &CF,&FF,&FF,&F3,&CC,&00,&00,&33
               DB      &CC,&FF,&FC,&33,&CC,&00,&00,&33
               DB      &CC,&FF,&0F,&33,&CC,&00,&00,&33
               DB      &CC,&FF,&F0,&33,&CC,&00,&00,&33
               DB      &CC,&F3,&FC,&33,&CC,&00,&00,&33
               DB      &CC,&00,&00,&33,&CF,&FF,&FF,&F3
               DB      &C0,&00,&00,&03,&FF,&FF,&FF,&FF

;FLOPPY DISC
TREA_2:        DB      &FF,&FF,&FF,&FF,&C0,&00,&00,&03
               DB      &CF,&F0,&03,&C3,&CF,&F0,&F3,&F3
               DB      &CF,&F0,&F3,&F3,&CF,&F0,&F3,&F3
               DB      &CF,&F0,&03,&F3,&CF,&FF,&FF,&F3
               DB      &CF,&00,&00,&F3,&CF,&3F,&FC,&F3
               DB      &CF,&00,&00,&F3,&CF,&3F,&F0,&F3
               DB      &CF,&00,&00,&F3,&CF,&00,&00,&F3
               DB      &C0,&00,&00,&03,&FF,&FF,&FF,&FF

;COMPUTER
TREA_3:        DB      &FF,&FF,&FF,&FF,&C0,&00,&00,&03
               DB      &CF,&FF,&FF,&F3,&CE,&AA,&AA,&B3
               DB      &CD,&55,&55,&73,&CE,&AA,&AA,&B3
               DB      &CD,&55,&55,&73,&CE,&AA,&AA,&B3
               DB      &CF,&FF,&FF,&F3,&C0,&00,&0C,&03
               DB      &C3,&FF,&FF,&C3,&C3,&00,&00,&C3
               DB      &C3,&33,&FC,&C3,&C3,&FF,&FF,&C3
               DB      &C0,&00,&00,&03,&FF,&FF,&FF,&FF

;READY Z80
TREA_4:        DB      &FF,&FF,&FF,&FF,&C0,&00,&00,&03
               DB      &CF,&C3,&C3,&33,&CC,&33,&33,&33
               DB      &CF,&C3,&30,&C3,&CC,&C3,&30,&C3
               DB      &CC,&33,&C0,&C3,&C0,&00,&00,&03
               DB      &C0,&00,&00,&03,&CF,&F3,&F3,&F3
               DB      &C0,&C3,&33,&33,&C3,&03,&F3,&33
               DB      &CC,&03,&33,&33,&CF,&F3,&F3,&F3
               DB      &C0,&00,&00,&03,&FF,&FF,&FF,&FF



;-----------------------------------------------------;
;                              