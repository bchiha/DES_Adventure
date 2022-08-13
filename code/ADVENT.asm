NOLIST

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

WRITE "ADVENT."            

        ORG     &4000

;DES JUMPBLOCK TABLE
        READ "DESJBLK.Z80"
;RAM LOCATIONS
        READ "RAM.Z80"

PRINT "ASSEMBLING CODE..."

;CONSTANTS
C_SCREEN_X      EQU       &2E
C_SCREEN_Y      EQU       &28   ;SPRITE SCREEN TOP LEFT X,Y POS
C_SPRSOLID      EQU       &08   ;SOLID SPRITE ONWARDS
C_LADDER        EQU       &1B   ;DOWN LEVEL LADDER OFFSET ON LOCAL MAP
C_LEVEL1        EQU       &27   ;LEVEL 1 START LOCATION OFFSET ON WORLD MAP

;START OF GAME
        DB      "DES APPLICATION:"
        DW      &4000

;SAVE RETURN ADDRESS
        PUSH    BC
        PUSH    HL
        CALL    ADVENTURE     ;RUN THE GAME
        POP     HL
        POP     BC
        JP      &001B         ;JUMP BACK TO DES ON GAME EXIT

ADVENTURE:
;DATA SETUP
        LD     HL,MAPW_TBL
        LD     (V_PLAYERW),HL ;START AT LOCATION 0
        LD     A,&02
        LD     (V_PLAYERX),A ;PLAYER START X=2
        LD     (V_PLAYERZ),A ;PLAYER DIRECTION 2=SOUTH
        INC    A
        LD     (V_PLAYERY),A ;PLAYER START Y=3
        LD     A,&0F
        LD     (V_CHESTFG),A ;NO CHESTS FOUND, BIT 0-3 ARE SET

;SCREEN SETUP
        LD     HL,MENUTXT   ;MENU SETUP
        CALL   MENUBAR

        CALL   GETBLANKER   ;GET SCREEN BLANKER
        LD     (HL),&00     ;TURN IT OFF...ITS BLUDDY ANNOYING
        
;WINDOW DISPLAYS
        LD     HL,&0020     ;MAIN WINDOW
        LD     DE,&2C90
        CALL   NORMBOX

        LD     HL,&2C20     ;GAME WINDOW
        LD     DE,&2490
        CALL   ALERTBOX

        LD     HL,&00B0     ;INFO WINDOW
        LD     DE,&5010
        CALL   NORMBOX

;TEXT / ZONE SETUP
        
        LD     HL,HEADTXT   ;DISPLAY GAME TITLE
        CALL   PRINTSTRING

        LD     DE,&0410     ;MOVEMENT BUTTONS
        LD     HL,&0930
        CALL   NORMBOX      ;KEY W
        LD     HL,&0440
        CALL   NORMBOX      ;KEY A
        LD     HL,&0E40
        CALL   NORMBOX      ;KEY D
        LD     HL,&0950
        CALL   NORMBOX      ;KEY S
        LD     DE,&0A10
        LD     HL,&1540
        CALL   NORMBOX      ;KEY Look
        
        LD     HL,MAINTXT   ;MAIN WINDOW TEXT
        CALL   PRINTSTRING
 
        CALL   ZONESETUP    ;SET UP CLICK ZONES

        CALL   DRAWMAP      ;DRAW INITIAL MAP
        CALL   DRAWTREASURE ;DRAW INITIAL TREASURE FOUND

;MAIN USER LOOP.  WAIT FOR KEY PRESS OR MOUSE CLICK (SPACE).  THEN
;DO THE ACTION.  VALUE RETURNED FROM MOUSE IS A CLICK ZONE
USERLOOP:
        CALL   WAIT       ;GET POINTER/KEY INPUT
        CALL   MOUSE
        CALL   WAIT
CLICK:
        OR     A          ;CHECK FOR VALID INPUT
        CALL   Z,PING
        JR     Z,USERLOOP

        CP     &FF        ;UNKNOWN
        JR     Z,USERLOOP
        
        CP     &01        ;MENU ITEM
        JP     Z,MENU 
        
        CP     &06        ;LOOK
        JP     Z,LOOKAT

        CP     &06
        JP     C,MOVEPLAYER ;MOVE PLAYER

        JR     USERLOOP
        
;DRAW THE CURRENT LOCAL MAP BASED AND PLAYER ON CURRENT MAP LOCATION
DRAWMAP:
        LD     HL,(V_PLAYERW) ;GET CURRENT PLAYER LOCATION IN WORLD
        LD     A,(HL)       ;GET LOCAL MAP IN WORLD
        LD     HL,MAPL_TBL
        CALL   VECTOR_IT    ;GET MAPL INDEX
        LD     (V_CURLMAP),HL  ;SAVE LOCAL MAP ADDRESS
        LD     E,C_SCREEN_Y
        LD     C,&08        ;EIGHT ROWS
D_ROW:
        LD     D,C_SCREEN_X
        LD     B,&08        ;EIGHT COLUMNS
D_COL:
        PUSH   HL
        LD     A,(HL)       ;GET SPRITE INDEX
        LD     HL,SPR_TBL
        CALL   VECTOR_IT    ;GET SPR INDEX
        XOR    A
        CALL   DRAWICON     ;DISPLAY SPRITE
        POP    HL
        INC    HL
        LD     A,&04
        ADD    D
        LD     D,A
        DJNZ   D_COL
        LD     A,&10
        ADD    E
        LD     E,A
        DEC    C
        JR     NZ,D_ROW

;UPDATE PLAYER INDEX ON WORLD MAP
        LD     HL,(V_PLAYERW)
        LD     DE,MAPW_TBL
        OR     A
        SBC    HL,DE   ;FIND DIFFERENCE
        LD     A,L
        LD     (V_CURWMAP),A

;UPDATE PLAYER ADDRESS ON LOCAL MAP
        LD     HL,(V_CURLMAP)
        LD     A,(V_PLAYERX)
        LD     D,&00
        LD     E,A
        LD     A,(V_PLAYERY)
        RLCA           ;x BY 8
        RLCA
        RLCA
        ADD    A,E           ;UPDATE E
        LD     E,A
        ADD    HL,DE         ;ADJUST HL TO PLAYER POSITION
        LD     (V_PLAYERL),HL

;CLEAR INFO BOX
        LD     HL,INFOCLR
        CALL   PRINTSTRING

;DRAW PLAYER ON SCREEN BASED ON CURRENT POSITION X,Y AND Z
DRAWPLAYER:
        ;GET PLAYER COORDINATES
        LD     D,C_SCREEN_X
        LD     E,C_SCREEN_Y
        LD     A,(V_PLAYERX)
        RLCA           ;MULTIPLY BY 4
        RLCA
        ADD    A,D
        LD     D,A
        LD     A,(V_PLAYERY)
        RLCA           ;MULTIPLY BY 16
        RLCA
        RLCA
        RLCA
        ADD    A,E
        LD     E,A
        ;SAVE BACKGROUND
        PUSH   DE
        PUSH   DE
        POP    HL
        CALL   SAVEBG
        POP    DE
        ;GET PLAYER SPRITE
        LD     A,(V_PLAYERZ) ;DIRECTION
        LD     HL,CHAR_TBL
        CALL   VECTOR_IT
        ;DRAW PLAYER
        XOR    A
        CALL   DRAWICON
        RET

;GET NEXT POSITION.  IF IT IS OFF THE SCREEN, SET NEW MAP, IF IT IS NOT A
;SOLID OBJECT, MOVE PLAYER
MOVEPLAYER:
        SUB    &02           ;ADJUST FOR INDEXING
        LD     (V_PLAYERZ),A ;STORE DIRECTION
        LD     HL,V_PLAYERX  ;SET X DEFAULT
        BIT    0,A           ;N/S=Z OR E/W=NZ
        JR     NZ,MOVE_EW
MOVE_NS:
        DEC    A             ;N=-1, S=1
        INC    HL            ;MOVE TO PLAYERY
        JR     MOVE_MAP
MOVE_EW:
        SUB    &02           ;W=-1, E=1
MOVE_MAP:
        ADD    A,(HL)        ;GET NEW POSITION
        LD     C,A           ;STORE IN C FOR LATER
        BIT    3,A           ;IF SET EITHER 08 OR FF, PLAYER IS OFF MAP
        JR     Z,MOVE_CHECK
        
        AND    &07           ;MASK OUT TO LOOP BACK AROUND
        LD     (HL),A        ;SAVE PLAYER POSITION
        ;ADJUST CURRENT MAP INDEX
        LD     HL,(V_PLAYERW)
        CALL   LOOKAHEAD     ;GET NEXT MAP ADDRESS
        LD     (V_PLAYERW),HL
        CALL   DRAWMAP       ;DRAW NEW MAP AND PLAYER
        JP     USERLOOP

MOVE_CHECK:
        PUSH   HL            ;SAVE PLAYER POSITION
        LD     HL,(V_PLAYERL)
        CALL   LOOKAHEAD     ;GET NEXT LOCAL MAP ADDRESS/DATA
        CP     C_SPRSOLID    ;IS GROUND WALKABLE?
        JR     NC,MOVE_FIX   ;NO, IGNORE MOVE, BUT STILL DRAW PLAYER
        
        LD     (V_PLAYERL),HL ;UPDATE PLAYER LOCAL ADDRESS
        LD     A,C
        POP    HL
        LD     (HL),A        ;UPDATE MOVE
        JR     MOVE_IT
MOVE_FIX:
        POP    HL
MOVE_IT:
        CALL   LOADBG        ;
        CALL   DRAWPLAYER    ;REDRAW PLAYER
        ;CHECK FOR SPECIAL DOWN LADDER
        LD     DE,L_0F + C_LADDER  ;ONLY ON ONE MAP
        LD     HL,(V_PLAYERL)
        OR     A
        SBC    HL,DE
        JP     NZ,USERLOOP     ;NOT ON SPOT, IGNORE
        LD     A,(V_CHESTFG)   ;SEE IF ALL ITEMS ARE COLLECTED
        OR     A
        JR     Z,MOVE_SPC      ;IF Z WE HAVE ALL THE ITEMS
        LD     HL,MSG_TBL
        LD     A,&09           ;FORCE MESSAGE
        CALL   INFOMSG
        JP     USERLOOP
MOVE_SPC:
        LD     HL,MAPW_TBL
        LD     DE,C_LEVEL1
        ADD    HL,DE         ;MOVE TO LEVEL 1 MAP
        LD     (V_PLAYERW),HL ;SAVE IT
        CALL   DRAWMAP       ;DRAW NEW MAP AND PLAYER
        JP     USERLOOP

;WHEN FACING AN OBJECT, EXAMINE IT.  SIGNS AND CHEST HAVE SPECIAL 
;MEANINGS AS THERE ARE MORE THAN ONE.  OTHERWISE, DISPLAY WHAT THE
;PLAYER SEES.
LOOKAT:
        ;CHECK IF FACING OFF THE MAP.  
        LD     DE,(V_PLAYERX);SAVE D=Y, E=X
        LD     A,(V_PLAYERZ) ;GET FACING DIRECTION
        BIT    0,A        ;N/S=Z OR E/W=NZ
        JR     Z,LO_NS
LO_EW:
        DEC    A          ;MAKE E=2,W=0
        ADD    A,E        ;ADD X TO A
        JR     LO_CHECK
LO_NS:
        ADD    A,D        ;ADD Y TO A
LO_CHECK:
        OR     A          ;IS IT ZERO?
        JR     Z,LO_NOLOOK
        CP     &09        ;IS IT 9?
        JR     Z,LO_NOLOOK
        LD     HL,(V_PLAYERL)  ;NOT OFF MAP
        CALL   LOOKAHEAD  ;SEE WHAT THE PLAYER IS LOOKING AT
        CP     &09        ;A SIGN
        JR     Z,LO_SIGN 
        CP     &0E        ;A CHEST
        JR     Z,LO_CHEST
        JR     LO_GETMSG 
LO_NOLOOK:
        LD     A,&13      ;CANT SEE MESSAGE
LO_GETMSG:        
        CALL   INFOMSG
        JP     USERLOOP   ;RETURN FROM LOOK ROUTINE

        ;HANDLE SIGN LOOKING
LO_SIGN:
        LD     A,(V_CURWMAP) ;WHERE IN THE WORLD ARE WE?
        LD     BC,&0002      ;TWO TO FIND
        LD     HL,SIGNLOC
        CPIR                 ;WHICH SIGN ARE WE LOOKING AT?
        LD     A,&10         ;BASE OF SIGN MESSAGE
        ADD    A,C           ;C=0 OR 1
        JR     LO_GETMSG     ;DISPLAY THE MESSAGE

        ;HANDLE CHEST LOOKING
LO_CHEST:
        LD     A,(V_CURWMAP) ;WHERE IN THE WORLD ARE WE?
        LD     BC,&0004      ;FOUR TO FIND
        LD     HL,CHESTLOC
        CPIR                 ;WHICH CHEST ARE WE LOOKING AT?
        LD     A,(V_CHESTFG) ;GET CHEST FLAG
        LD     B,C           ;TRANFER CHEST NUMBER TO B
        INC    B             ;MAKE NON ZERO
LO_CH1:
        RRCA                 ;GET CHEST FLAG IN CARRY
        DJNZ   LO_CH1        ;REPEAT
        LD     A,&0E         ;EMPTY CHEST MESSAGE
        JR     NC,LO_GETMSG  ;DISPLAY DEFAULT MESSAGE
        ;NEW CHEST FOUND, UPDATE CHEST FLAG
        LD     A,C           ;TRANSFER CHEST NUMBER TO A
        OR     A             ;IS IT ZERO
        JR     Z,LO_CH3      ;SKIP BIT ADDITION
        LD     B,A
        LD     A,&01         ;SET ONE BIT         
LO_CH2:
        RLCA                 ;MOVE IT TO NEXT BIT
        DJNZ   LO_CH2       
        JR     LO_CH4        ;DO THE TOGGLE
LO_CH3:
        INC    A
LO_CH4:
        LD     B,A           ;GET BIT TOGGLE IN B
        LD     A,(V_CHESTFG) ;LOAD CHEST FLAG
        XOR    B             ;FLIP BIT TO NOT SET
        LD     (V_CHESTFG),A ;SAVE UPDATED CHEST FLAG
        
        ;FLASH SCREEN!
        PUSH   BC            ;SAVE C FOR LATER
        LD     B,&06         ;DO 6 TIMES
        LD     HL,&2C20      ;GAME WINDOW
        LD     DE,&2490
LO_CH5:
        CALL   INVERTBOX
        CALL   PING
        DJNZ   LO_CH5

        CALL   DRAWTREASURE  ;DRAW COLLECTED TREASURE
        ;PRINT INFO MESSAGE
        LD     A,&12         ;CHEST FOUND GENERAL MESSAGE
        CALL   INFOMSG
        POP    BC       
        LD     A,&14         ;TREASURE BASE
        ADD    A,C           ;GET MESSAGE INDEX FOR TREASURE
        LD     HL,MSG_TBL
        CALL   VECTOR_IT    
        CALL   PRINTSTRING   ;DISPLAY NAME AT END OF LAST MESSAGE
        JP     USERLOOP      ;EXIT CHEST FOUND

;DRAW THE TREASURE FOUND ON THE MAIN SCREEN
DRAWTREASURE:
        LD     BC,&0401      ;CURRENT TREASURE INDEX AND LOOP COUNTER
        LD     A,(V_CHESTFG) ;GET CHEST FLAG
        LD     DE,&0888      ;X Y POS
DT1:
        RRCA                 ;CHECK BIT IN CARRY
        PUSH   AF            ;SAVE A
        JR     C,DT_NF       ;IF SET NOT FOUND
        LD     A,C           ;TREASURE INDEX
        JR     DT_F
DT_NF:
        XOR    A             ;BLANK TREASURE
DT_F:
        LD     HL,TRES_TBL
        CALL   VECTOR_IT     ;GET CORRECT TREASURE ICON
        XOR    A             ;ENSURE HL IS USED
        CALL   DRAWICON      ;DRAW IT
        LD     A,&08
        ADD    A,D
        LD     D,A           ;UPDATE X POS
        INC    C             ;NEXT TREASURE
        POP    AF
        DJNZ   DT1           ;DO NEXT TREASURE
        
        RET        

;USING 8x8 BYTE MAPS, MOVE THE PLAYER ONE SPOT BASED ON THEIR
;FACING DIRECTION.  RETURN THE NEW ADDRESS ON MAP IN HL AND
;THE VALUE OF HL.  THIS IS USED FOR WORLD AND LOCAL MAP TABLES
LOOKAHEAD:
        LD     A,(V_PLAYERZ)  ;GET FACING DIRECTION
        BIT    0,A        ;N/S=Z OR E/W=NZ
        JR     NZ,LA_EW
LA_NS:
        DEC    A          ;ADJUST N=-1, S=1
        ADD    A,A        ;A x 8
        ADD    A,A
        ADD    A,A
        JR     LA_UPD
LA_EW:
        SUB    &02        ;ADJUST W=-1, E=1
LA_UPD:
        LD     D,&00
        BIT    7,A        ;IS IT A MINUS?
        JR     Z,LA_POS     
        DEC    D
LA_POS:
        LD     E,A
        ADD    HL,DE      ;GET NEXT MOVE ADDRESS
        LD     A,(HL)     ;ALSO GET ITS CONTENTS
        RET

;MESSAGE DISPLAY ROUTINE.  GIVEN AN INDEX A, A MESSAGE ON THE MSG_TBL
;WILL BE DISPLAYED ON THE INFO WINDOW 
INFOMSG:
        ;CLEAR INFO BOX
        PUSH   AF
        LD     HL,INFOCLR ;SPACES
        CALL   PRINTSTRING
        ;PRINT MESSAGE
        LD     HL,&02B4   ;MOVE TO INFO BOX
        CALL   LOCATE     ;MOVE CURSOR
        POP    AF
        LD     HL,MSG_TBL
        CALL   VECTOR_IT  ;ADJUST HL TO POINT TO MESSAGE
        CALL   PRINTSTRING

        RET
        
;MENU SETUP.  CREATES A PULLMENU AND HANDLES THE CLICKS
MENU:
        LD     HL,MENUTBL ;MENU DATA
        LD     DE,MENUDIS ;NOTHING DISABLED
        CALL   PULLMENU
        JP     C,CLICK    ;SELECTED OUTSIDE MENU
        CP     &01        ;MENU ITEM 1 SELECTED
        JP     Z,MSGWIN
        CP     &02        ;MENU ITEM 2 SELECTED
        JP     Z,MSGWIN
        CP     &04        ;MENU ITEM 3 SELECTED
        JP     Z,AGAIN    ;RESTART GAME
        CP     &06        ;MENU ITEM 4 SELECTED
        JP     Z,QUIT     ;JUMP TO EXIT ALERT
        JP     USERLOOP

;POPUP WINDOW.  TEXT IS BASED ON VALUE OF REGISTER A
MSGWIN:
        PUSH   AF         ;SAVE MENU ITEM
        ;SAVE AREA - MID SCREEN
        LD     HL,&1331   ;19 X 49
        LD     DE,&2864   ;40 X 100
        CALL   SAVEAREA   ;SAVE BACKGROUND

        ;DISPLAY WINDOW
        CALL   MENUBOX    ;DISPLAY A WINDOW
        LD     HL,INSTXT  ;INSTRUCTION TEXT
        POP    AF         ;RESTORE ITEM
        DEC    A          ;CHECK FOR 1 OR 2
        JR     Z,PP1
        LD     HL,ABOUTXT ;ABOUT TEXT
PP1:
        CALL   PRINTSTRING ;DISPLAY INSTRUCTIONS
        LD     HL,&2280   ;34 X 128
        LD     B,&0A      ;10 CHAR WIDTH
        LD     DE,OKTXT   ;OK TEXT
        CALL   BUTTON     ;DISPLAYS A BUTTON
PP2:
        CALL   WAIT       ;GET POINTER/KEY INPUT
        CALL   MOUSE
        CALL   WAIT

        CP     &07        ;BUTTON IS CLICK ZONE 7
        JR     NZ,PP2     ;MUST PRESS OK BUTTON

        ;OK BUTTON PRESS.  RESTORE BACKGROUND AND CLICK ZONES
        CALL   LOADAREA   ;RESTORE BACKGROUND
        CALL   ZONESETUP  ;RESTORE ZONES
        JP     USERLOOP   ;RETURN

;GENERAL SAVE BACKGROUND ROUTINE.  REQUIRES HL=x,y, DE=w,d
;MAX DE=4000 bytes
SAVEAREA:
        LD     BC,&3000   ;STORAGE ADDRESS
        CALL   STOREBOX   ;STORE IT
        RET  

;GENERAL RESTORE BACKGROUND ROUTINE
LOADAREA:
        LD     DE,&3000   ;STORAGE ADDRESS
        CALL   RESTOREBOX ;RETREIVE AREA
        RET

;PLAYER SAVE BACKGROUND ROUTINE.  REQUIRES HL=x,y
;MAX DE=64 bytes
SAVEBG:
        LD     DE,&0410   ;ICON SIZE
        LD     BC,&3FB0   ;STORAGE ADDRESS
        CALL   STOREBOX   ;STORE IT
        RET  

;PLAYER RESTORE BACKGROUND ROUTINE
LOADBG:
        LD     DE,&3FB0   ;STORAGE ADDRESS
        CALL   RESTOREBOX ;RETREIVE AREA
        RET

;GENERAL VECTOR TABLE LOOKUP
;INPUTS A=INDEX, HL=TABLE ADDRESS
;OUTPUT HL=ADDRESS OF VECTOR
VECTOR_IT:
        PUSH   BC
        RLCA              ;WORD INDEX
        LD     B,&00 
        LD     C,A 
        ADD    HL,BC      ;INDEX HL
        LD     A,(HL)
        INC    HL
        LD     H,(HL)
        LD     L,A
        POP    BC
        RET
        
;DISPLAY QUIT WINDOW AND HANDLE BUTTON PRESS
QUIT:
        LD     HL,QUITTXT ;EXIT TEXT
        LD     A,&01      ;TWO BUTTONS, QUERY ICON
        LD     DE,YESTXT  ;LEFT BUTTON TEXT
        LD     BC,NOTXT   ;RIGHT BUTTON TEXT
        CALL   ALERTRESPONSE
        RET    C          ;YES CLICKED, EXIT
        CALL   ZONESETUP  ;RESTORE CLICK ZONES
        JP     USERLOOP   ;NO CLICKED, CONTINUE

;DISPLAY RESTART ENQUIRY WINDOW AND HANDLE BUTTON PRESS
AGAIN:
        LD     HL,AGNTXT  ;TEXT
        LD     A,&01      ;TWO BUTTONS, QUERY ICON
        LD     DE,YESTXT  ;LEFT BUTTON TEXT
        LD     BC,NOTXT   ;RIGHT BUTTON TEXT
        CALL   ALERTRESPONSE
        JP     C,ADVENTURE   ;YES CLICKED, RESTART
        CALL   ZONESETUP  ;RESTORE CLICK ZONES
        JP     USERLOOP   ;NO CLICKED, CONTINUE

;GENERAL CLICK ZONE SETUP ROUTINE
ZONESETUP:
        CALL   CLRZONES
        CALL   CLEARKEYS

        LD     HL,ZONETBL   ;CLICK ZONES
        LD     B,&06        ;NUMBER OF ZONES
        CALL   RAMZONES

        LD     HL,KEYZTBL   ;SHORTCUT KEY ZONES
        LD     B,&07        ;NUMBER OF KEYS
        CALL   ZONEKEYS 
        RET

;DATA TABLES
HEADTXT:       DB      31,&1C,&14,11,"DES ADVENTURE",14,0
MAINTXT:       DB      31,&0A,&34,11,1,"W",31,&05,&44,1,"A",31,&0F,&44,1,"D"
               DB      31,&0A,&54,1,"S",31,&16,&44,1,"Look",31,&12,&2A
               DB      "Controls",31,&07,&70,"Treasures Found",14,0
MENUTXT:       DB      1,"Game",18,&32,&20,130," BRIAN CHIHA - 2022",0
QUITTXT:       DB      "Are you sure you would like to quit this great Game!",0
AGNTXT:        DB      "Do you want to Restart this Game??",0
YESTXT:        DB      43,"  ",1,"Yes",0
NOTXT:         DB      46,"   ",1,"No",0
INSTXT:        DB      31,&16,&3A,"Your mission is to find four items"
               DB      31,&16,&46,"that will literally help you"
               DB      31,&16,&52,"complete the game.  Move around the"
               DB      31,&16,&5E,"map using W,S,A,D and to search use"
               DB      31,&16,&6A,"L for look. Find an old man to win!",0
ABOUTXT:       DB      31,&14,&3A,"This game is written using the"
               DB      31,&14,&44,"Desktop Environment System developed"
               DB      31,&14,&4E,"by Michael Beckett for CampurSoft."
               DB      31,&14,&58,"I wanted to show off what DES can do"
               DB      31,&14,&62,"This DES Adventure is the result."
               DB      31,&14,&6C,"Check out ",146,15,"Ready? Z80",16,147," on YouTube!",0               
OKTXT:         DB      18,&02,&20,1,"Ok",0
INFOCLR:       DB      31,&02,&B4,18,&4D,32,0

;SPECIAL WORLD LOCATIONS IN REVERSE ORDER
SIGNLOC:       DB      &3F,&00
CHESTLOC:      DB      &36,&30,&20,&05

;PULL MENU CONFIG
MENUTBL:       DB      &02,&0A,&10,6,1,"Instructions",0
               DB      1,"About",0,"-",0,1,"Restart",0
               DB      "-",0,"E",1,"xit",0
MENUDIS:       DB      0,0,0,0   ;None disabled

;MESSAGE LOOKUP TABLE, INDEX BASED ON SPRITE TABLE
MSG_TBL:       DW      MSGGRS,MSGFLO,MSGROA,MSGROA,MSGROA,MSGROA,MSGBDG,MSGLAD
               DW      MSGBRK,MSGSPE,MSGTRE,MSGTRE,MSGTRE,MSGWTR,MSGCHE,MSGGUY
               DW      MSGSG1,MSGSG2,MSGCH1,MSGNOS,MSGTR1,MSGTR2,MSGTR3,MSGTR4

MSGGRS:        DB      "Just some grass...",0
MSGFLO:        DB      "Some pretty flowers",0
MSGROA:        DB      "A dusty path leading you nowhere!",0
MSGBDG:        DB      "A wobbly pontoon",0
MSGLAD:        DB      "A secret down passage, it looks dangerous",0
MSGBRK:        DB      "Some nice sprite brickwork",0
MSGSPE:        DB      "A strange force prevents you from entering....",0
MSGTRE:        DB      "A tree that is blocking your path",0
MSGWTR:        DB      "Icy cold water",0
MSGCHE:        DB      "An Empty Chest",0
MSGGUY:        DB      "You have found me...My name is Slartibartfast",0
MSGSG1:        DB      "Welcome to my game.  It's really easy.  Have fun exploring...",0
MSGSG2:        DB      "Nice one!  You have completed the game...Now go forth and make it better!",0
MSGCH1:        DB      "You found a Chest!, Inside is a ",0
MSGNOS:        DB      "Can't see anything!  Try moving to the next map!",0
MSGTR1:        DB      "Z80 source code game listing",0
MSGTR2:        DB      "3 Inch Floppy Disc",0
MSGTR3:        DB      "Amstrad CPC 664 computer",0
MSGTR4:        DB      "Ready? Z80 YouTube channel subcription",0



;CLICK ZONES CONFIG
ZONETBL:       DB      &03,&00,&06,&0A  ;MENU 1
               DB      &09,&30,&0C,&3E  ;KEY W
               DB      &04,&40,&07,&4E  ;KEY A
               DB      &09,&50,&0C,&5E  ;KEY S
               DB      &0E,&40,&11,&4E  ;KEY D
               DB      &15,&40,&1E,&4E  ;KEY L
                
KEYZTBL:       DB      52,1,59,2,69,3,60,4,61,5,36,6,34,7   ;MENU SHORTCUTS (MAP TO AMS NUMBERS)

;LOAD SPRITE DATA AT END

PRINT "LOAD SPRITE DATA"
        READ "SPRITE.Z80"

PRINT "ASSEMBLING COMPLETE..."
ENT  $$$ÿ ÿop Environment System (DES) Game
;-----------------------------------------------------;
;                    