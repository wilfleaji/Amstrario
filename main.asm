ORG #8000

start:
include "initGraphics.asm"

gameloop:
  CALL #BB1B
  CP 243
  CALL Z, move_x_right
  CP 242
  CALL Z, move_x_left
  CALL drawSprite
JP gameloop

RET

drawSprite:
  LD B,8
  LD A,(spriteX)
  LD L,A
  LD H,#C0
  LD (BaseMarioAddr),HL
  LD IX,MarioIdle
  CALL drawBloc

  ;LD HL,#C050 ;bloc de base #C000 + 80octet
  LD DE,#50
  LD HL,(BaseMarioAddr)
  ADD HL,DE
  LD B,8
  CALL drawBloc
  
RET

drawBloc:
    PUSH BC          ;on sauvegarde le registre BC pour garder notre compteur sur le registre B (car B est modifier dans des sous-routine)
    LD D,H           ;on sauvegarde HL dans DL, on ne peut pas utiliser PUSH car PUSH sauvegarde dans SP et on ecrase BC
    LD E,L
    CALL drawLine
    LD BC,#0800     ;#0800 permet de sauter a la ligne suivante
    LD H,D          ;on restaure HL
    LD L,E
    ADD HL,BC       ;On rajoute #0800 dans HL pour aller a la ligne suivante
    POP BC          ;On restaure BC pour remettre notre compteur dans B
    DJNZ drawBloc
    RET

drawLine:
  LD B,6
  drawLineLoop:
    CALL drawPixel
    DJNZ drawLineLoop
  RET

drawPixel:
  LD A,(IX+0)        ;On charge l'octet en cours du sprite dans le registre A
  LD (HL),A          ;On l'affiche
  INC HL             ;On passe a l'octet suivant en memoire
  INC IX             ;On passe a l'octet suivant dans le sprite
  RET

clearMario:
  LD B,8
  LD A,(spriteX)
  LD L,A
  LD H,#C0
  LD (BaseMarioAddr),HL
  CALL clearBloc

  LD DE,#50
  LD HL,(BaseMarioAddr)
  ADD HL,DE
  LD B,8
  CALL clearBloc
RET

clearBloc:
    PUSH BC
    LD D,H
    LD E,L
    CALL clearLine
    LD BC,#0800
    LD H,D
    LD L,E
    ADD HL,BC
    POP BC
    DJNZ clearBloc
    RET

clearLine:
  LD B,6
  clearLineLoop:
    CALL clearPixel
    DJNZ clearLineLoop
  RET

clearPixel:
  LD (HL),0
  INC HL
RET

include "sprite.asm"
spriteX: DB 0
BaseMarioAddr: DW 0
StartScreenAddr: DW #C000

move_x_right:
  CALL clearMario
  CALL #BD19
  LD A,(spriteX)
  INC A
  LD (spriteX),A
RET

move_x_left:
  CALL clearMario
  CALL #BD19
  LD A,(spriteX)
  DEC A
  LD (spriteX),A
RET

end:
SAVE "player.bin", #8000, end - start, AMSDOS