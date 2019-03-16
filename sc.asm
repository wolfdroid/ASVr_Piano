;Deklarasi Model Program yang Digunakan
.MODEL SMALL

;Inisialisasi Stack yang akan digunakan
.STACK 100H

.DATA
;Segment Data
    ;DEKLARASI JUDUL
    
    TIT1 db 13,10, 13, 10, 13,10 , 13,10, 13, 10, 13, 10, 13, 10,      '              ___   _____  _   _       ______ _'                             , 13, 10, '$'                  
    TIT2 db                                                            '             / _ \ /  ___|| | | |      | ___ (_)'                            , '$'
    TIT3 db 13,10,                                                     '            / /_\ \\ `--. | | | |_ __  | |_/ /_  __ _ _ __   ___'            , '$'                   
    TIT4 db 13,10,                                                     '            |  _  | `--. \| | | |  __| |  __/| |/ _  |  _ \ / _ \'           , '$'                     
    TIT5 db 13,10,                                                     '            | | | |/\__/ /\ \_/ / |    | |   | | (_| | | | | (_) |'          , '$'                   
    TIT6 db 13,10,                                                     '            \_| |_/\____/  \___/|_|    \_|   |_|\__,_|_| |_|\___/'           , '$'                     
    TIT7 db 13,10,13, 10, 13, 10,                                      '                     Virtual Piano ASCII BASED Graphic            '           , '$'                     
    TIT8 db 13,10,13, 10, 13, 10,                                      '                       Press any Key to continue....            '            , '$'                     
     
    ;MAIN INTERFACE 
    
    PIN1 db 13,10, 13, 10, 13,10 , 13,10, 13, 10, 13, 10,              '           _________________________________________________________'                             , 13, 10, '$'                  
    PIN2 db                                                            '           X+++++++++++++++++++++++++++++++++++++++++++++++++++++++X'                            , '$'
    PIN3 db 13,10,                                                     '           X       |  | | | |  |  | | | | | |  |  | | | |  |       X'            , '$'                   
    PIN4 db 13,10,                                                     '           X       |  | | | |  |  | | | | | |  |  | | | |  |       X'           , '$'                     
    PIN5 db 13,10,                                                     '           X       |  |2| |3|  |  |5| |6| |7|  |  |9| |0|  |       X'          , '$'                   
    PIN6 db 13,10,                                                     '           X       |  |_| |_|  |  |_| |_| |_|  |  |_| |_|  |       X'           , '$'                     
    PIN7 db 13,10,                                                     '           X       |   |   |   |   |   |   |   |   |   |   |       X'           , '$'                     
    PIN8 db 13,10,                                                     '           X       | q | w | e | r | t | y | u | i | o | p |       X'            , '$'
    PIN9 db 13,10,                                                     '           X       |___|___|___|___|___|___|___|___|___|___|       X'           , '$'                     
    PIN0 db 13,10,                                                     '           X                                                       X'           , '$'                     
    PINA db 13,10,                                                     '           XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'            , '$'
    PINB db 13,10,13,10,13,10,                                         '                                Press v to EXIT'                              , '$'                                                                                       
   
    ;EXIT INTERFACE
    
    EXT1 db 13,10, 13, 10, 13,10 , 13,10, 13, 10,                      '                              ENVERIESAGE STUDIOS'                             , 13, 10, '$'                  
    EXT2 db 13,10,                                                     '                                     @2019'                            , '$'
    EXT3 db 13,10,                                                     '                        __________________________________'            , '$'                   
    EXT4 db 13,10,                                                     '                       /    o   oooo ooo oooo   o o o    /\       '           , '$'                     
    EXT5 db 13,10,                                                     '                      /    oo  ooo  oo  oooo   o o o    / /       '          , '$'                   
    EXT6 db 13,10,                                                     '                     /    _________________________    / /         '           , '$'                     
    EXT7 db 13,10,                                                     '                    / // / // /// // /// // /// / /   / /       '           , '$'                     
    EXT8 db 13,10,                                                     '                   /___ //////////////////////////___/ /       '            , '$'
    EXT9 db 13,10,                                                     '                   \____\________________________\___\/       '           , '$'                     
    EXTB db 13,10,13,10,13,10,                                         '                        Press any Key to continue....'                              , '$'                                                                                       
    
    ;Input Variable                                        
    INPUT   DB 128 (?)                                                
    PETUN   DB 'A = DO; S = MI; D = SOL; >> 0 UNTUK KELUAR' ,13,10, '$'
    STOR    DW 0        ;MEMORY                   
                                                      
    
.CODE

.STARTUP 

    JMP FIRST
    
    ;FUNGSI MATIKAN CURSOR
    CURS_OFF PROC NEAR
                MOV     CH, 10h         ;SET BIT UNTUK MATIKAN CURSOR
                MOV     AH, 01H         ;MASUKAN FUNGSI KURSOR
                INT     10h             ;PANGGIL ROM BIOS VIDEO SERVICE
             RET
    CURS_OFF ENDP
    
    CLR_KEYB PROC NEAR
                PUSH    ES                      ;SIMPAN ES
                PUSH    DI                      ;SIMPAN DI
                MOV     AX, 40H                 ;BIOS SEGMEN DIDALAM AX
                MOV     ES, AX                  ;TRANSFER KE ES
                MOV     AX, 1AH                 ;KEYBOARD POINTER DIDALAM AX
                MOV     DI, AX                  ;MASUKAN KE DI
                MOV     AX, 1EH                 ;KEYBOARD BUFFER MULAI DARI AX
                MOV     ES: WORD PTR [DI], AX   ;PINDAHKAN KE HEAD POINTER
                INC     DI                      ;PINDAHKAN POINTER KE KEYBOARD TAIL POINTER
                INC     DI                      
                MOV     ES: WORD PTR [DI], AX   ;PINDAHKAN KE TAIL POINTER
                POP     DI                      ;RESTORE DI
                POP     ES                      ;RESTORE ES
             RET
    CLR_KEYB ENDP
     
    
    ;GENERATE SOUND 
    SOUNDER PROC NEAR
                MOV     AL, 0B6H        ;LOAD CONTROL
                OUT     43H, Al         ;SEND
                MOV     AX, STOR        ;MASUKAN FREKUENSI KE AX
                OUT     42H, AL         ;SEND LSB
                MOV     AL, AH          ;MOVE MSB KE AL
                OUT     42H, AL         ;SEND MSB
                IN      AL, 061H        ;DAPATKAN STATE PORT 61H
                OR      AL, 03H         ;NYALAKAN SPEAKER
                OUT     61H, AL         ;SPEAKER MENYALA
                CALL    DELAY           ;DELAY
                AND     AL, 0FCH        ;MATIKAN SPEAKER
                OUT     61H, AL         ;SPEAKER MATI
                CALL    CLR_KEYB        ;PANGGIL FUNGSI CLEAR KEYBOARD
            RET
    SOUNDER ENDP
    
    ;FUNGSI NYALAKAN CURSOR
    CURS_ON PROC NEAR 
                MOV     CX, 0506h       ;SET BIT UNTUK NYALAKAN CURSOR
                MOV     AH, 01H         ;MASUKAN FUNGSI KURSOR
                INT     10H             ;PANGGIL ROM BIOS VIDEO SERVICE
            RET
    CURS_ON ENDP
             
    
    ;DELAY NADA
       DELAY:
            MOV     AH, 00H         ;FUNGSI 0H - DAPATKAN SYSTEM TIMER
            INT     01AH            ;PANGIL ROM BIOS TIME-OF-DAY SERVICES
            ADD     DX, 4           ;MASUKAN NILAI DELAY
            MOV     BX, DX          ;STORE HASILNYA KE BX

    PZ PROC 
            INT     01AH            ;PANGGIL ROM BIOS TIME-OF-DAY SERVICES
            CMP     DX, BX          ;COMPARE DENGAN BX, APAKAH SUDAH SELESAI DELAY ?
            JL      PZ              ;JIKA BELUM LOOPING
       RET
    PZ ENDP
    
    MAIN:
       MOV AX, 0003h
       MOV BX, 0000h
       MOV DX, 0000h
       INT 10H
       
       MOV AX, @DATA
       MOV DS, AX
       
       CALL CURS_OFF
    
       ;ASCII Penampilan
       LEA DX, PIN1
       MOV AH, 09H
       INT 21H
       
       LEA DX, PIN2
       MOV AH, 09H
       INT 21H
       
       LEA DX, PIN3
       MOV AH, 09H
       INT 21H
       
       LEA DX, PIN4
       MOV AH, 09H
       INT 21H
       
       LEA DX, PIN5
       MOV AH, 09H
       INT 21H
       
       LEA DX, PIN6
       MOV AH, 09H
       INT 21H
       
       LEA DX, PIN7
       MOV AH, 09H
       INT 21H
       
       LEA DX, PIN8
       MOV AH, 09H
       INT 21H
       
       LEA DX, PIN9
       MOV AH, 09H
       INT 21H
       
       LEA DX, PIN0
       MOV AH, 09H
       INT 21H
       
       LEA DX, PINA
       MOV AH, 09H
       INT 21H
       
       LEA DX, PINB
       MOV AH, 09H
       INT 21H
       
       JMP GETIN
       
       
        ;SCAN INPUT KEYBOARD
        GETIN:
            MOV AH, 08H        ;SCAN IMPUT USER
            MOV INPUT, AL
            INT 21H
            JMP X
                NDO:
                    MOV     AX, 2280        ;NILAI DO
                    MOV     STOR, AX
                    CALL    SOUNDER         ;PUTAR NADA
                    JMP GETIN  
                
                NRE:
                    MOV     AX, 2031        ;NILAI RE
                    MOV     STOR, AX
                    CALL    SOUNDER         ;PUTAR NADA
                    JMP GETIN
                    
                NMI:
                    MOV     AX, 1809        ;NILAI MI
                    MOV     STOR, AX
                    CALL    SOUNDER         ;PUTAR NADA
                    JMP GETIN
                    
                NFA:
                    MOV     AX, 1715         ;NILAI FA
                    MOV     STOR, AX
                    CALL    SOUNDER         ;PUTAR NADA
                    JMP GETIN
                    
                NSOL:
                    MOV     AX, 1521        ;NILAI SOL
                    MOV     STOR, AX
                    CALL    SOUNDER         ;PUTAR NADA
                    JMP GETIN
                    
                NLA:
                    MOV     AX, 1355        ;NILAI LA
                    MOV     STOR, AX
                    CALL    SOUNDER         ;PUTAR NADA
                    JMP GETIN
                    
                NSI:
                    MOV     AX, 1207        ;NILAI SI
                    MOV     STOR, AX
                    CALL    SOUNDER         ;PUTAR NADA
                    JMP GETIN
                    
                NDOH:
                    MOV     AX, 1140        ;NILAI DO TINGGI
                    MOV     STOR, AX
                    CALL    SOUNDER         ;PUTAR NADA
                    JMP GETIN
                    
                NREH:
                    MOV     AX, 1015        ;NILAI RE TINGGI
                    MOV     STOR, AX
                    CALL    SOUNDER         ;PUTAR NADA
                    JMP GETIN
                
                NMIH:
                    MOV     AX, 0905        ;NILAI MI TINGGI
                    MOV     STOR, AX
                    CALL    SOUNDER         ;PUTAR NADA
                    JMP GETIN
            
            X:
            
            CMP AL,"q"         ;JIKA USER MASUKAN a > DO
            JE NDO
            
            CMP AL,"2"         ;JIKA USER MASUKAN 2 > DOS
            JE NDOS
            
            CMP AL,"w"         ;JIKA USER MASUKAN w > RE
            JE NRE
            
            CMP AL,"3"         ;JIKA USER MASUKAN 3 > DOS
            JE NRES
            
            CMP AL,"e"         ;JIKA USER MASUKAN e > MI
            JE NMI
            
            CMP AL,"r"         ;JIKA USER MASUKAN r > FA
            JE NFA
            
            CMP AL,"t"         ;JIKA USER MASUKAN t > SOL
            JE NSOL
            
            CMP AL,"y"         ;JIKA USER MASUKAN y > LA
            JE NLA
            
            CMP AL,"u"         ;JIKA USER MASUKAN u > SI
            JE NSI 
            
            CMP AL,"i"         ;JIKA USER MASUKAN o > DO HIGH
            JE NDOH
            
            CMP AL,"o"         ;JIKA USER MASUKAN p > RE HIGH
            JE NREH
            
            CMP AL,"p"         ;JIKA USER MASUKAN p > MI HIGH
            JE NMIH
            
            JMP Y
            
            NDOS:
                    MOV     AX, 2152        ;NILAI DOS
                    MOV     STOR, AX
                    CALL    SOUNDER         ;PUTAR NADA
                    JMP Y
                    
            NRES:
                    MOV     AX, 1917        ;NILAI RES
                    MOV     STOR, AX
                    CALL    SOUNDER         ;PUTAR NADA
                    JMP Y
                    
            NFAS:
                    MOV     AX, 1612         ;NILAI FAS
                    MOV     STOR, AX
                    CALL    SOUNDER         ;PUTAR NADA
                    JMP Y
            
            NSOLS:
                    MOV     AX, 1436         ;NILAI SOLS
                    MOV     STOR, AX
                    CALL    SOUNDER         ;PUTAR NADA
                    JMP Y
            
            NLAS:
                    MOV     AX, 1292         ;NILAI LAS
                    MOV     STOR, AX
                    CALL    SOUNDER         ;PUTAR NADA
                    JMP Y
            
            NDOHS:
                    MOV     AX, 1076         ;NILAI NDOHS
                    MOV     STOR, AX
                    CALL    SOUNDER         ;PUTAR NADA
                    JMP Y
            
            NREHS:
                    MOV     AX, 0958         ;NILAI NDOHS
                    MOV     STOR, AX
                    CALL    SOUNDER         ;PUTAR NADA
                    JMP Y              
                          
            Y :
            
            CMP AL,"2"         
            JE NDOS
            
            CMP AL,"3"         
            JE NRES
            
            CMP AL,"5"         
            JE NFAS
            
            CMP AL,"6"         
            JE NSOLS
            
            CMP AL,"7"         
            JE NLAS
            
            CMP AL,"9"         
            JE NDOHS
            
            CMP AL,"0"         
            JE NREHS
            
            CMP AL,"v"         ;JIKA USER MASUKAN v > EXIT
            JE BREAK
            
            JMP GETIN      ;LOOPING AMBIL INPUT SELANJUTNYA
            
            
    FIRST:
        MOV AX, 0003h
        MOV BX, 0
        MOV DX, 0000h
        INT 10H
        
        ;PRINT EXIT
        LEA DX, TIT1
        MOV AH, 09H
        INT 21H
        
        LEA DX, TIT2
        MOV AH, 09H
        INT 21H
        
        LEA DX, TIT3
        MOV AH, 09H
        INT 21H
        
        LEA DX, TIT4
        MOV AH, 09H
        INT 21H
        
        LEA DX, TIT5
        MOV AH, 09H
        INT 21H
        
        LEA DX, TIT6
        MOV AH, 09H
        INT 21H
        
        LEA DX, TIT7
        MOV AH, 09H
        INT 21H
        
        LEA DX, TIT8
        MOV AH, 09H
        INT 21H
        
        MOV AH, 08H
        INT 21H
        
        JMP MAIN
        
        
   BREAK:
        MOV AX, 0003h
        MOV BX, 0000h
        MOV DX, 0000h
        INT 10H
        CALL CURS_ON
        
        ;PRINT JUDUL
        LEA DX, EXT1
        MOV AH, 09H
        INT 21H
        
        LEA DX, EXT2
        MOV AH, 09H
        INT 21H
        
        LEA DX, EXT3
        MOV AH, 09H
        INT 21H
        
        LEA DX, EXT4
        MOV AH, 09H
        INT 21H
        
        LEA DX, EXT5
        MOV AH, 09H
        INT 21H
        
        LEA DX, EXT6
        MOV AH, 09H
        INT 21H
        
        LEA DX, EXT7
        MOV AH, 09H
        INT 21H
        
        LEA DX, EXT8
        MOV AH, 09H
        INT 21H
        
        LEA DX, EXT9
        MOV AH, 09H
        INT 21H
        
        LEA DX, EXTB
        MOV AH, 09H
        INT 21H
        
        MOV AH, 08H
        INT 21H
        
   .EXIT
END
