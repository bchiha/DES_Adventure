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

;RAM LOCATIONS

;&3000-&3FF3 RESERVED FOR SCREEN MEMORY

V_PLAYERX       EQU       &3FF4 ;PLAYER X LOCATION ON MAP 0-7
V_PLAYERY       EQU       &3FF5 ;PLAYER Y LOCATION ON MAY 0-7
V_PLAYERZ       EQU       &3FF6 ;PLAYER FACING DIRECTION 0-3=N,E,S,W
V_PLAYERW       EQU       &3FF7 ;CURRENT PLAYER WORLD MAP ADDRESS LOCATION
V_PLAYERL       EQU       &3FF9 ;CURRENT PLAYER LOCAL MAP ADDRESS LOCATION
V_CURWMAP       EQU       &3FFB ;CURRENT PLAYER WORLD MAP INDEX
V_CURLMAP       EQU       &3FFC ;CURRENT LOCAL MAP ADDRESS LOCATION
V_CHESTFG       EQU       &3FFE ;CHEST FLAG, BITS SET IF NOT FOUND YET
    $$$� �ment System (DES) Game
;-----------------------------------------------------;
;                              