; **********************************************************************
; * IST-UL
; *
; * Grupo 18
; *
; * Alunos:	99073	Gon�alo Direito
; *			99081	Henrique Anjos       
; *			99125	Tiago Caldas
; *
; * Modulo:    grupo18.asm
; * Descri��o: Vers�o final do projeto
; *
; *
; *
; **********************************************************************

; **********************************************************************
; * Constantes
; **********************************************************************
DISPLAYS   		EQU 0A000H   	; endere�o dos displays de 7 segmentos (perif�rico POUT-1)
TEC_LIN    		EQU 0C000H   	; endere�o das linhas do teclado (perif�rico POUT-2)
TEC_COL    		EQU 0E000H   	; endere�o das colunas do teclado (perif�rico PIN)
LINHA      		EQU 01H   		; endere�o da primeira linha do teclado a testar 
ULTIMA_LINHA	EQU	08H			; endere�o da �ltima linha do teclado a testar
NIBBLE_LOW 		EQU 0000FH		; isolar o nibble low do byte low
NIBBLE_HIGH		EQU 000F0H		; isolar o nibble high do byte low
BYTE_LOW		EQU	000FFH		; isolar o byte low
BYTE_HIGH		EQU	0FF00H		; isolar o byte high
DEZ				EQU	0AH			; valor (10 decimal) para ser utilizado na rotina de convers�o hexadecimal/decimal
TECLA_0    		EQU 00011H   	; c�digo de tecla 0
TECLA_1    		EQU 00012H		; c�digo de tecla 1
TECLA_2    		EQU 00014H   	; c�digo de tecla 2
TECLA_C    		EQU 00081H		; c�digo de tecla C
TECLA_D    		EQU 00082H		; c�digo de tecla D
TECLA_E    		EQU 00084H		; c�digo de tecla E

MEMORIA_ECRA	EQU	8000H	 	; endere�o base da mem�ria do ecr�
NUM_ECRAS		EQU 5			; n�mero de ecr�s utilizados

DEFINE_LINHA    EQU 600AH      	; endere�o do comando para definir a linha
DEFINE_COLUNA   EQU 600CH      	; endere�o do comando para definir a coluna
DEFINE_PIXEL    EQU 6012H      	; endere�o do comando para escrever um pixel
APAGA_AVISO     EQU 6040H      	; endere�o do comando para apagar o aviso de nenhum cen�rio selecionado
LIMPA_ECRA		EQU 6000H      	; endere�o do comando para apagar um ecr�
ECRA_SELECIONAR EQU	6004H      	; endere�o do comando para selecionar um ecr�

IMG_FUNDO		EQU	6042H		; endere�o do comando de sele��o de imagem de fundo
SOM				EQU	6048H		; endere�o do comando de sele��o de som
PLAY_SOM_VD		EQU	605AH		; endere�o do comando de inicio de reprodu��o de som/video
STOP_SOM_VD		EQU	6066H		; endere�o do comando de fim de reprodu��o de som/video

ENERGIA			EQU	64H			; valor incial da energia da nave

SOM_TIRO		EQU	0			; n�mero do som de tiro
SOM_MINERAR		EQU 1			; n�mero do som de minerar
SOM_EXPLOSAO_O	EQU 2			; n�mero do som de explos�o de ovni
SOM_EXPLOSAO_N	EQU 3			; n�mero do som de explos�o da nave


ECRA_INICIO		EQU	0			; n�mero do ecra inicial
ECRA_JOGO		EQU	1			; n�mero do ecra de jogo
ECRA_SEMENERGIA	EQU 2			; n�mero do ecra de fim do jogo por falta de energia
ECRA_DESTRUIDO	EQU 3			; n�mero do ecra de fim do jogo por destrui��o
ECRA_TERMINADO	EQU 4			; n�mero do ecra de fim do jogo pelo utilizador
ECRA_PAUSA		EQU 5			; n�mero do ecra de pausa do jogo pelo utilizador

POS_TIRO_INI	EQU 0FEH		; desfasamento da 1a representa��o do tiro face � nave (-1L + 2C) na representacao (LLLLLLLLCCCCCCCC)
TIRO_ULT_LINHA	EQU 0FH			; �ltima linha v�lida para o tiro
UMA_LINHA		EQU 100H		; valor de uma linha no formato LLLLLLLLCCCCCCCC

PRIM_COL		EQU	0			; primeira coluna do ecr�
PRIM_LIN		EQU	0			; primeira linha do ecr�
LIM_COL			EQU	40h			; limite do ecr� (coluna)
LIM_LIN			EQU	20H			; limite do ecr� (linha)
POS_OVNI_INI	EQU 001EH		; posi��o inicial do ovni linha 0 coluna 30
DIM_OVNI_INI	EQU 11H			; dimens�o inicial do ovni (1x1) no formato 00000000LLLLCCCC

POS_NAVE_INI	EQU	01B1DH		; posi��o inicial da nave

COR_PIXEL       EQU 0FF00H     ; cor do pixel: vermelho em ARGB (opaco e vermelho no m�ximo, verde e azul a 0)
LIMPA_PIXEL		EQU	0

ATRASO			EQU	0F00H

MISSIL			EQU 0			; parametro para a rotina que deteta uma colis�o
NAVE			EQU 1			; parametro para a rotina que deteta uma colis�o

DIM_NAVE		EQU	5			; dimens�o da nave (em linhas e colunas)
ESQUERDA		EQU 0FFFFH		; deslocamento para a esquerda
PARADA			EQU 0			; sem deslocamento
DIREITA			EQU 1			; deslocamento para a direita

DIM_CFG_OVNI	EQU	6			; dimens�o em bytes da configura��o de um ovni
DIM_FIG_OVNI	EQU	055H		; dimens�o em bytes das tabelas de figuras de ovnis (85d)
DIM_MAX_OVNI	EQU 5			; diemns�o m�xima do tamanho de um ovni (5x5)
NUM_MAX_OVNI	EQU 4			; n�mero m�ximo de ovnis poss�vel        						
INI_LIN_OVNI	EQU	0			; linha incial de representa��o de um ovni
INI_COL_OVNI	EQU	01EH		; coluna incial de representa��o de um ovni
MENOS_45		EQU 0FFFFH		; deslocamento obliquo a -45�
VERTICAL		EQU 0			; deslocamento vertical
MAIS_45			EQU 1			; deslocamento obliquo a +45�

HALT			EQU	0FFFFH		; jogo parado
STOP			EQU	0			; jogo pausado
EXEC 			EQU	1			; jogo em execu��o

MENOS_ENERGIA	EQU	0FFFBH		; valor da diminui��o de energia por tempo ou disparo de tiro (-5)
MAIS_ENERGIA_N	EQU	5			; valor do aumento de energia por destrui��o de nave inimiga
MAIS_ENERGIA_M	EQU	10			; valor do aumento de energia por minera��o de meteorito

ESPERA_TECLA    EQU 0    		; estado do processo atende_teclado
PREMIU_TECLA    EQU 1    		; estado do processo atende_teclado
TECLA_CARREGADA	EQU 2    		; estado do processo atende_teclado

NAO_HA_TIRO    	EQU 0    		; estado do processo tiro
TIRO_EFETUADO  	EQU 1    		; estado do processo tiro
HA_TIRO    		EQU 2    		; estado do processo tiro

NAO_HA_OVNI	    EQU 0    		; estado do processo ovni
HA_OVNI		    EQU 1    		; estado do processo ovni
EXPLOSAO		EQU	2    		; estado do processo ovni
MINERAR			EQU	3    		; estado do processo ovni

ESPERA			EQU	0			; estado do processo controlo
INICIO			EQU	1			; estado do processo controlo
A_EXECUTAR		EQU	2			; estado do processo controlo
PAUSADO			EQU	3			; estado do processo controlo
TERMINADO		EQU	4			; estado do processo controlo

DIM_WORD		EQU	2			; dimens�o em bytes de uma word

; COLIS�ES
SEM_COLISAO		EQU	0			; n�o existe colis�o
NAVE_VS_NAVE	EQU	1			; colis�o entre a nave e uma nave inimiga
NAVE_VS_METEO	EQU	2			; colis�o entre a nave e um meteorito
MISSIL_VS_NAVE	EQU	3			; missil atinge nave inimiga
MISSIL_VS_METEO	EQU	4			; missil atinge meteorito

NAO_GERAR_OVNI	EQU 0			; 
GERAR_OVNI		EQU	1

OFF				EQU 0			; valor para utiliza��o em flags
ON				EQU	1			; valor para utiliza��o em flags

; TIPOS DE OVNIS
METEORITO		EQU 0			
NAVE_INIMIGA	EQU 1


; **********************************************************************
; * Dados
; **********************************************************************
PLACE			1000H
pilha:      	TABLE	 100H	; espa�o reservado para a pilha (200H bytes)
SP_inicial:						; endere�o de inicializa��o do SP (1200H) 

; Tabela das rotinas de interrup��o
tab_int:      	WORD 	rot_int_0      ; rotina de atendimento da interrup��o 0
				WORD 	rot_int_1      ; rotina de atendimento da interrup��o 1
				WORD 	rot_int_2      ; rotina de atendimento da interrup��o 2

energia:		WORD  	ENERGIA	; contador de energia - inicia a 100 decimal
existe_tiro:	WORD  	OFF		; flag de exist�ncia de tiro no ecr�
posicao_tiro:	WORD	0		; posi��o no ecr� (LLLLLLLLCCCCCCCC) da �ltima representa��o do tiro
aleatorio:		WORD  	3		; contador utilizado para gerar n�meros aleat�rios
func_jogo:		WORD	HALT	; funcionamento do jogo: -1 parado; 0 pausado; 1 - execu��o				
primeira_vez:	WORD	ON		; flag utilizada para garantir que o primeiro pedido de interrupt 2 (contagem do tempo de energia) n�o � atendido

anima_ovnis:	WORD	OFF		; flag de ocorr�ncia de INT 0
anima_tiro:		WORD	OFF		; flag de ocorr�ncia de INT 1
anima_energia:	WORD	OFF		; flag de ocorr�ncia de INT 2

tecla_premida:	WORD 	0      	; vari�vel que indica se uma tecla foi carregada
								; 0 - n�o
								; 11, 12, 14, 18, 21, 22, 24, 28, 41, 42, 44, 48, 81, 82, 84 ou 88 - sim, e valor indica a linha/coluna da tecla) 

estado_jogo:				 	; vari�vel de estado do jogo
				WORD 	ESPERA 			; estado inicial, por omiss�o
estado_teclado:             	; vari�vel de estado do processo atende_teclado
				WORD 	ESPERA_TECLA    	; estado inicial, por omiss�o

estado_tiro:         	    	; vari�vel de estado do processo tiro
				WORD 	NAO_HA_TIRO    	; estado inicial, por omiss�o
				
estado_ovnis:					; vari�veis de estado de cada ovni
				WORD	NAO_HA_OVNI		; estado inicial do ovni 0, por omiss�o
				WORD	NAO_HA_OVNI		; estado inicial do ovni 1, por omiss�o
				WORD	NAO_HA_OVNI		; estado inicial do ovni 2, por omiss�o
				WORD	NAO_HA_OVNI		; estado inicial do ovni 3, por omiss�o
				
sentido_nave:	WORD	DIREITA	; sentido do movimento da nave (-1: esquerda; 1: direita; 0: sem movimento) - come�a a 1 para permitir que seja desenhada quando o jogo come�a

tecla_0:		WORD	0		; disable (0) / enable (TECLA_0) da tecla 0
tecla_1:		WORD	0		; disable (0) / enable (TECLA_1) da tecla 1 
tecla_2:		WORD	0		; disable (0) / enable (TECLA_2) da tecla 2
tecla_C:		WORD	0		; disable (0) / enable (TECLA_C) da tecla C
tecla_D:		WORD	0		; disable (0) / enable (TECLA_D) da tecla D
tecla_E:		WORD	0		; disable (0) / enable (TECLA_E) da tecla E

; DEFINI��O DO MISSIL	
missil:			WORD	0FFF0H	; defini��o do pixel do tiro

; CONFIGURA��O DA NAVE
; 1� word com a a posi��o no ecr� l (byte high) x c (byte high) 
; 2� word com o n� do ecra (nibble low do byte high) e a dimens�o l x c da figura (byte low: LLLLCCCC)
; 3� word com o endere�o do endere�o da figura da nave a representar (n�o era necessario. feito para se poder usar a mesma fun��o para desenhar figuras)
cfg_nave:		WORD	POS_NAVE_INI	; da primeira vez a nave vai ser desnhada em 01B1EH j� que o sentido da nave inicia por defeito para a direita 
				WORD	0055H
				WORD	tab_nave
; FIGURA DA NAVE (figura em string para melhor leitura das linhas e colunas da figura)
tab_nave:     	WORD 	nave   		; n�o era necessario. feito para poder usar a mesma fun��o para desenhar nave e ovnis

nave:			STRING	000H, 000H, 000H, 000H, 0FFH, 000H, 000H, 000H, 000H, 000H
				STRING	000H, 000H, 000H, 000H, 0FFH, 000H, 000H, 000H, 000H, 000H
				STRING	000H, 000H, 0FFH, 000H,	0FFH, 000H, 0FFH, 000H,	000H, 000H		
				STRING	0FFH, 000H,	0FFH, 000H, 0FFH, 000H,	0FFH, 000H,	0FFH, 000H
				STRING	000H, 000H, 0FFH, 000H,	000H, 000H, 0FFH, 000H,	000H, 000H	

; FIGURA DA EXPLOS�O (figura em string para melhor leitura das linhas e colunas da figura)
tab_explosao:   WORD 	explosao   	; n�o era necessario. feito para poder usar a mesma fun��o para desenhar figuras
				
explosao:       STRING	000H, 000H, 0FFH, 050H, 0FFH, 090H, 0FFH, 030H, 000H, 000H
                STRING	0FFH, 050H, 000H, 000H, 0FFH, 0B0H, 0FFH, 090H, 0FFH, 050H
                STRING	0FFH, 090H, 0FFH, 0B0H, 0FFH, 0D0H, 000H, 000H, 0FFH, 090H
                STRING	0FFH, 050H, 0FFH, 090H, 0FFH, 0B0H, 0FFH, 090H, 0FFH, 050H
                STRING	00FH, 030H, 0FFH, 050H, 000H, 000H, 0FFH, 050H, 000H, 000H				
				
; CONFIGURA��O DOS OVNIS (METEORITO E DAS NAVES INIMIGAS) - 4 porque s�o as que em simult�neo podem estar representadas
; 1� word com a a posi��o no ecr� l (byte high) x c (byte high) 
; 2� word com o n� do ecra (nibble low do byte high) e a dimens�o l x c da figura (byte low: LLLLCCCC)
; 3� word com o endere�o da tabela de endere�os de representa��es 
cfg_ovnis:		WORD	POS_OVNI_INI; posi��o inicial linha 0 coluna 30
				WORD	0111H		; ecr� 1 e dimens�o inicial 1x1
				WORD	0

				WORD	POS_OVNI_INI
				WORD	0211H
				WORD	0				
				
				WORD	POS_OVNI_INI
				WORD	0311H
				WORD	0				
				
				WORD	POS_OVNI_INI
				WORD	0411H
				WORD	0			
				
; FIGURAS DO METEORITO (figuras em string para melhor leitura das linhas e colunas da figura)
tab_ovni1:     	WORD 	ovni1_1x1      
				WORD 	ovni1_2x2      
				WORD 	ovni1_3x3      
				WORD 	ovni1_4x4      
				WORD 	ovni1_5x5      

ovni1_1x1:		STRING	0FDH, 0DDH		

ovni1_2x2:		STRING	0FDH, 0DDH,	0FDH, 0DDH
				STRING	0FDH, 0DDH,	0FDH, 0DDH		

ovni1_3x3:		STRING	000H, 000H,	0B0H, 0F0H, 000H, 000H
				STRING	0B0H, 0F0H,	0B0H, 0F0H, 0B0H, 0F0H
				STRING	000H, 000H,	0B0H, 0F0H, 000H, 000H

ovni1_4x4:		STRING	000H, 000H,	0B0H, 0F0H, 0B0H, 0F0H, 000H, 000H
				STRING	0B0H, 0F0H,	0B0H, 0F0H, 0B0H, 0F0H, 0B0H, 0F0H
				STRING	0B0H, 0F0H,	0B0H, 0F0H, 0B0H, 0F0H, 0B0H, 0F0H
				STRING	000H, 000H,	0B0H, 0F0H, 0B0H, 0F0H, 000H, 000H

ovni1_5x5:		STRING	000H, 000H,	0B0H, 0F0H, 0B0H, 0F0H, 0B0H, 0F0H, 000H, 000H
				STRING	0B0H, 0F0H,	0B0H, 0F0H, 0B0H, 0F0H, 0B0H, 0F0H, 0B0H, 0F0H
				STRING	0B0H, 0F0H,	0B0H, 0F0H, 0B0H, 0F0H, 0B0H, 0F0H, 0B0H, 0F0H
				STRING	0B0H, 0F0H,	0B0H, 0F0H, 0B0H, 0F0H, 0B0H, 0F0H, 0B0H, 0F0H
				STRING	000H, 000H,	0B0H, 0F0H, 0B0H, 0F0H, 0B0H, 0F0H, 000H, 000H

; FIGURAS DAS NAVES INIMIGAS (figuras em string para melhor leitura das linhas e colunas da figura)
tab_ovni2:     	WORD 	ovni2_1x1      
				WORD 	ovni2_2x2      
				WORD 	ovni2_3x3      
				WORD 	ovni2_4x4      
				WORD 	ovni2_5x5   

ovni2_1x1:		STRING	0FDH, 0DDH		

ovni2_2x2:		STRING	0FDH, 0DDH,	0FDH, 0DDH
				STRING	0FDH, 0DDH,	0FDH, 0DDH		

ovni2_3x3:		STRING	0BFH, 000H, 000H, 000H, 0BFH, 000H
				STRING	000H, 000H, 0BFH, 000H, 000H, 000H
				STRING	0BFH, 000H, 000H, 000H, 0BFH, 000H

ovni2_4x4:		STRING	0BFH, 000H, 000H, 000H, 000H, 000H, 0BFH, 000H
				STRING	000H, 000H, 0BFH, 000H, 0BFH, 000H, 000H, 000H
				STRING	000H, 000H, 0BFH, 000H, 0BFH, 000H, 000H, 000H
				STRING	0BFH, 000H, 000H, 000H, 000H, 000H, 0BFH, 000H

ovni2_5x5:		STRING	0BFH, 000H, 000H, 000H, 000H, 000H, 000H, 000H, 0BFH, 000H
				STRING	000H, 000H, 0BFH, 000H, 000H, 000H, 0BFH, 000H, 000H, 000H
				STRING	000H, 000H, 000H, 000H, 0BFH, 000H, 000H, 000H, 000H, 000H
				STRING	000H, 000H, 0BFH, 000H, 000H, 000H, 0BFH, 000H, 000H, 000H
				STRING	0BFH, 000H, 000H, 000H, 000H, 000H, 000H, 000H, 0BFH, 000H

; TIPOS DE OVNIS
tipo_ovnis:		TABLE	4
				
; DIRE��O DOS OVNIS
dir_ovnis:		TABLE	4
				
; COLIS�ES DOS OVNIS
colisao_ovnis:	WORD	SEM_COLISAO
				WORD	SEM_COLISAO
				WORD	SEM_COLISAO
				WORD	SEM_COLISAO

; GERA��O DOS OVNIS
geracao_ovnis:	WORD	GERAR_OVNI
				WORD	GERAR_OVNI
				WORD	GERAR_OVNI
				WORD	GERAR_OVNI

; CONTADOR DE MOVIMENTOS DOS OVNIS (para o aumento de dimens�o)		
cont_mov_ovnis:	WORD	0	
				WORD	0
				WORD	0
				WORD	0

				
; **********************************************************************
; *
; * Programa principal
; *
; **********************************************************************
PLACE      	0
inicio:		
	MOV  BTE, tab_int    		; inicializa BTE (registo de Base da Tabela de Exce��es)
    MOV  SP, SP_inicial 		; inicializa��o do stack pointer									  
	EI0                      	; permite interrup��es 0
    EI1                      	; permite interrup��es 1
    EI2                    		; permite interrup��es 2

ciclo_principal:           

	CALL incrementa_aleatorio	; incrementa o contador de gera��o de n�meros aleat�rios
	CALL cont2display			; mostra no display o valor da energia da nave
	CALL controlo_jogo			; controlo e execu��o do jogo
	CALL teclado				; dete��o de teclas
	CALL atende_teclado			; atendimento da tecla premida
	CALL trata_energia			; diminui a energia em fun�a� da passagem do tempo (interrupt 2)

	JMP  ciclo_principal		; volta ao inicio do ciclo		
		
		
; **********************************************************************
; *
; * rotina:   	controlo_jogo
; * Descri��o: 	Executa todas as ac��es relativas ao controlo do jogo
; *			   
; * Par�metros de entrada
; *				
; * Par�metros de sa�da
; *
; **********************************************************************
controlo_jogo:
	PUSH R0						; preserva registos a utilizar
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R7
	PUSH R8
	
	MOV	 R2, estado_jogo		; R1 com o atual
	MOV  R1, [R2]				;		estado do jogo
				
	MOV  R3, ESPERA				; verificar se o 
	CMP  R1, R3					; 		estado � o 0
	JNZ	 cj_estado1				; caso n�o seja vai verificar o pr�ximo estado
								; #################  estado 0 - ESPERA #################
	CALL clr_scr				; limpa o ecr�
	MOV  R1, ECRA_INICIO		; Coloca a imagem do ecr� inicial
	CALL muda_ecra				; 		como imagem de fundo do ecr� (R1 - numero do ecr�)
	CALL permite_teclaC			; permitir o uso da tecla C
	MOV  R1, INICIO				; assinala o facto de se estar em condi��es de 
	MOV  [R2], R1				;		poder iniciar o jogo no estado do controlo de jogo
	JMP  cj_fim
cj_estado1:	
	MOV  R3, INICIO				; verificar se o 
	CMP  R1, R3					; 		estado � o 1
	JNZ	 cj_estado2				; caso n�o seja vai verificar o pr�ximo estado
								; #################  estado 1 - INICIO  #################
	MOV  R3, func_jogo			; ver se o 
	MOV  R1, [R3]				;		jogo 
	MOV  R3, HALT				;			pode
	CMP  R1, R3					;				come�ar
	JZ   cj_fim					; se n�o pode come�ar n�o h� mais nada a fazer 
	
								; preparar o jogo para come�ar
	CALL inicializacoes 		; inicializa todas as vari�veis necess�rias ao jogo
	MOV  R1, ECRA_JOGO			; Colocar a imagem 1 (ecr� do jogo)
	CALL muda_ecra				; 		como imagem de fundo do ecr� (R1 - numero do ecr�)

	CALL inibe_teclaC			; n�o permitir o uso da tecla C
	CALL permite_teclas012		; permitir o uso das teclas 0, 1 e 2
	CALL permite_teclaD			; permitir o uso da tecla D
	CALl permite_teclaE			; permitir o uso da tecla E
	MOV  R1, A_EXECUTAR			; assinala o facto do jogo passar a  
	MOV  [R2], R1				;		estar em execu��o no estado do controlo de jogo							
	EI							; passa a permitir interrup��es                                                      
	JMP  cj_fim				
cj_estado2:	
	MOV  R3, A_EXECUTAR			; verificar se o 
	CMP  R1, R3					; 		estado � o 2
	JNZ	 cj_estado3				; caso n�o seja vai verificar o pr�ximo estado
								; #################  estado 2 - A_EXECUTAR  #################

	MOV  R7, energia			; verificar o fim  
	MOV  R3, [R7]				;		do jogo por
	CMP  R3, 0					;			falta de energia
	JNZ	 cj_cont0				; se n�o aconteceu passa ao pr�ximo teste
								; mudar para o ecr� de fim de jogo por falta de energia
	CALL clr_scr	
	MOV  R1, ECRA_SEMENERGIA	; colocar a imagem 2 (ecr� de fim do jogo por falta de energia)
	CALL muda_ecra				; 		como imagem de fundo do ecr� (R1 - numero do ecr�)
	
	MOV  R1, TERMINADO			; assinala o facto do jogo ter  
	MOV  [R2], R1				;		terminado no estado do controlo de jogo								
	DI							; deixar de atender a interrup��es	
	
	MOV  R0, func_jogo			; assinalar
	MOV  R1, HALT				;		que o jogo
	MOV  [R0], R1				;			est� parado	
	CALL permite_teclaC			; permitir o uso da tecla C	
	CALL inibe_teclaE			; n�o permitir o uso da tecla E	

	JMP cj_cont3				; inibir as restantes teclas que n�o s�o necess�rias e terminar
cj_cont0:
								; verificar o fim do jogo por colis�o com uma nave inimiga
	MOV  R8, NAVE_VS_NAVE
	CALL existem_colisoes		; verifica se existe colis�o com uma nave inimiga (R1 com o resultado)
	CMP  R1, NAVE_VS_NAVE
	JNZ  cj_cont1				; se n�o aconteceu passa ao pr�ximo teste
		
	CALL clr_scr	
	MOV  R1, ECRA_DESTRUIDO		; colocar a imagem 3(ecr� de fim do jogo por colis�o com nave inimiga)
	CALL muda_ecra				; 		como imagem de fundo do ecr� (R1 - numero do ecr�)
	
	MOV  R1, SOM_EXPLOSAO_N		; reproduz o 
	CALL play_som				;		som de explos�o da nave
	
	MOV  R1, TERMINADO			; assinala o facto do jogo ter  
	MOV  [R2], R1				;		terminado no estado do controlo de jogo								
	DI							; deixar de atender a interrup��es	
	
	MOV  R0, func_jogo			; assinalar
	MOV  R1, HALT				;		que o jogo
	MOV  [R0], R1				;			est� parado	
	CALL permite_teclaC			; permitir o uso da tecla C	
	CALL inibe_teclaE			; n�o permitir o uso da tecla E	
	
	JMP cj_cont3				; inibir as restantes teclas que n�o s�o necess�rias e terminar	
cj_cont1:							
	MOV  R3, func_jogo			; ver se o
	MOV  R1, [R3]				;		jogo foi
	CMP  R1, EXEC				;			imterrompido
	JZ	 cj_cont5				; se o n�o foi imterrompido vai fazer as a��es do estado
								; determinar o tipo de interrup��o
	MOV  R3, HALT				; verificar se 
	CMP  R1, R3					; 		jogo vai terminar
	JNZ  cj_cont2				; se n�o termina vai testar a pausa
	MOV  R1, TERMINADO			; assinala o facto do jogo ter  
	MOV  [R2], R1				;		terminado no estado do controlo de jogo	
	DI							; deixar de atender a interrup��es		
	
	CALL clr_scr	
	MOV  R1, ECRA_TERMINADO		; colocar a imagem 4 (ecr� de fim do jogo por interven�ao do utilizador)
	CALL muda_ecra				; 		como imagem de fundo do ecr� (R1 - numero do ecr�)
	CALL permite_teclaC			; permitir o uso da tecla C	
	CALL inibe_teclaE			; n�o permitir o uso da tecla E	
		

	JMP cj_cont3				; inibir as restantes teclas que n�o s�o necess�rias e terminar
cj_cont2:
	MOV  R1, PAUSADO			; assinala o facto do jogo ter sido 
	MOV  [R2], R1				;		pausado no estado do controlo de jogo	
	DI							; deixar de atender a interrup��es	

	MOV  R1, ECRA_PAUSA			; colocar a imagem 5 (ecr� de pausa do jogo por interven�ao do utilizador)
	CALL muda_ecra				; 		como imagem de fundo do ecr� (R1 - numero do ecr�)
    MOV  [R0], R1       		; 		de fundo do ecr�	
	JMP  cj_cont4				; inibir as teclas que n�o s�o necess�rias e terminar
cj_cont3:	
	CALL inibe_teclaD			; n�o permitir o uso da tecla D
cj_cont4:
	CALL inibe_teclas012		; n�o permiitr o uso das teclas 0, 1 e 2
	JMP  cj_fim	
cj_cont5:						; a��es a executar no decurso normal do jogo
	CALL desenha_nave			; desenha a nave na posi��o determinada pela a��o das teclas 0 e 2
	CALL trata_ovnis			; realiza todas as a��es relativas aos ovnis (gera��o, desenho, etc.)
	CALL tiro					; realiza as a��es relativas ao missil 
	CALL deteta_colisoes		; preenche a tabela de colis�es 
	JMP  cj_fim; 
cj_estado3:
	MOV  R3, PAUSADO			; verificar se o 
	CMP  R1, R3					; 		estado � o 3
	JNZ	 cj_estado4				; caso n�o seja vai verificar o pr�ximo estado
								; #################  estado 3 - PAUSADO  #################

	MOV  R3, func_jogo			; ver se o
	MOV  R1, [R3]				;		jogo vai
	CMP  R1, EXEC				;			recome�ar
	JNZ	 cj_term				; se n�o vai recome�ar vai ver se vai terminar
								; jogo vai recome�ar
								; repor ecr� de jogo
	CALL permite_teclas012		; permite teclas de jogo
	MOV  R1, A_EXECUTAR			; assinala o facto do jogo ir  
	MOV  [R2], R1				;		recome�ar no estado do controlo de jogo		
	MOV  R1, ECRA_JOGO			; Colocar a imagem 1 (ecr� do jogo)
	CALL muda_ecra				; 		como imagem de fundo do ecr� (R1 - numero do ecr�)
	EI							; voltar a atender a interrup��es	
	JMP  cj_fim
cj_term:
	MOV  R3, HALT				; ver se o jogo
	CMP  R1, R3					; 		vai terminar
	JNZ	 cj_fim					; se n�o vai terminar o jogo n�o h� mais nada a fazer
								; o jogo vai terminar
	MOV  R1, TERMINADO			; assinala o facto do jogo ir  
	MOV  [R2], R1				;		terminar no estado do controlo de jogo		
	DI

	CALL clr_scr	
	MOV  R1, ECRA_TERMINADO		; colocar a imagem 4 (ecr� de fim do jogo por interven�ao do utilizador)
	CALL muda_ecra				; 		como imagem de fundo do ecr� (R1 - numero do ecr�)
	CALL permite_teclaC			; permitir o uso da tecla C	
	CALL inibe_teclaD			; n�o permitir o uso da tecla D	
	CALL inibe_teclaE			; n�o permitir o uso da tecla E	
	
	JMP  cj_fim	
cj_estado4:
	MOV  R3, TERMINADO			; verificar se o 
	CMP  R1, R3					; 		estado � o 4
	JNZ	 cj_fim					; caso n�o seja vai terminar
								; #################  estado 4 - TERMINADO  #################
	
	MOV  R3, func_jogo			; ver se o
	MOV  R1, [R3]				;		jogo vai
	CMP  R1, EXEC				;			reiniciar
	JNZ	 cj_fim					; se n�o vai reiniciar ent�o n�o faz nada
	CALL clr_scr
	MOV  R1, INICIO				; assinala o facto do jogo ir  
	MOV  [R2], R1				;		reiniciar no estado do controlo de jogo		

	
cj_fim:
	POP  R8						; rep�e registos utilizados
	POP  R7
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET

; **********************************************************************
; *
; * rotina:   	existem_colisoes
; * Descri��o: 	Deteta se existe algum tipo de colis�o com um ovni
; *				Devolve o tipo de colis�o caso exista (0 se n�o) 
; *			   
; * Par�metros de entrada
; *				R8 - tipo de colis�o a testar
; * Par�metros de sa�da
; *				R1 - tipo de colis�o (0 se inexistente)
; **********************************************************************
existem_colisoes:
	PUSH R0
	PUSH R3
	PUSH R5
	PUSH R8
	
	MOV  R3, colisao_ovnis		; base da tabela de colis�es dos ovnis
	MOV  R5, 0					; primeiro ovni
ecn_prox_ovni:	
	MOV  R0, R5					; R0 com o deslocamento 
	SHL  R0, 1					;		em rela��o � base da tabela
	MOV  R1, [R3+R0]			; se existe uma colis�o 
	CMP  R1, R8					;		termina e devolve o
	JZ   ecn_colisao_fim		;			tipo da colis�o detetatda
	ADD  R5, 1					; se ainda n�o 
	CMP  R5, NUM_MAX_OVNI		;		chegou ao �ltimo
	JNZ  ecn_prox_ovni			;			ovni passa ao pr�ximo
	MOV  R1, SEM_COLISAO		; assinala n�o terem sido detetadas colis�es
ecn_colisao_fim:
	POP  R8						; rep�e registos utilizados
	POP  R5
	POP  R3
	POP  R0
	RET
	
	
; **********************************************************************
; *
; * rotina:   	existe_colisao
; * Descri��o: 	Deteta se existe alguma colis�o com um ovni
; *				Devolve o tipo de colis�o caso exista (0 se n�o) 
; *			   
; * Par�metros de entrada
; *				R0 - n�mero do ovni a testar
; * Par�metros de sa�da
; *				R0 - tipo de colis�o (0 se inexistente)
; **********************************************************************	
existe_colisao:
	PUSH R1						; preserva registos a utilizar
	
	MOV	 R1, colisao_ovnis 		; R1 com a base da tabela de colis�es
	SHL  R0, 1					; R0 com o deslocamento relativo � base da tabela
	MOV  R1, [R1+R0]			; R0 com o tipo de colis�o
	MOV  R0, R1					; 		ocorrida caso exista 
	
	POP  R1						; rep�e registos utilizados
	RET
	
	
; **********************************************************************
; *
; * rotina:   	limpa_colisao
; * Descri��o: 	limpa a aocorr�ncia de uma colis�o na tabela de colis�es
; *			   
; * Par�metros de entrada
; *				R0 - n�mero do ovni cuja colis�o vai ser limpa
; * Par�metros de sa�da
; *				
; **********************************************************************	
limpa_colisao:
	PUSH R0						; preserva registos a utilizar
	PUSH R1
	PUSH R2
	
	MOV	 R1, colisao_ovnis 		; R1 com a base da tabela de colis�es
	SHL  R0, 1					; R0 com o deslocamento relativo � base da tabela
	MOV  R2, SEM_COLISAO		; assinalar a 
	MOV  [R1+R0], R2			; 		inexist�ncia de colis�o
	
	POP  R2						; rep�e registos utilizados
	POP  R1
	POP  R0
	RET
	
	
; **********************************************************************
; *
; * rotina:   	teclado
; * Descri��o: 	Testa o teclado e assinala na vari�vel tecla_premida a 
; *			   	exist�ncia ou inexist�ncia de tecla premida 
; * 			tecla_premida = 0 - n�o existe tecla premida
; * 			tecla_premida != 0 - existe tecla premida
; *						valor da vaiavel corresponde � tecla premida
; *				 			11, 12, 14, 18 - teclas 0, 1, 2, 3  
; *							21, 22, 24, 28 - teclas 4, 5, 6, 7 
; * 						41, 42, 44, 48 - teclas 8, 9, A, B
; *							81, 82, 84, 88 - teclas C, D, E, F
; *			   
; * Par�metros de entrada
; *			
; * Par�metros de sa�da
; *
; **********************************************************************
teclado:
    PUSH R0						; preserva registos a utilizar
    PUSH R1
    PUSH R2
    PUSH R3
	PUSH R4
	
    MOV  R2, TEC_LIN   	 		; endere�o do perif�rico das linhas
    MOV  R3, TEC_COL    		; endere�o do perif�rico das colunas
	MOV  R1, LINHA				; colocar em R1 o endere�o da 1a linha do teclado a testar	 
tc_prox_linha:	 
    MOVB [R2], R1        		; escrever no perif�rico de sa�da (linhas)
    MOVB R0, [R3]         		; ler do perif�rico de entrada (colunas)
    CMP  R0, 0             		; existe alguma
    JNZ  tc_ha_tecla			; 		 tecla premida?
	ROL  R1, 1					; nenhuma tecla premida, muda para a pr�xima linha
	MOV	 R4, ULTIMA_LINHA		; se ainda n�o 
	CMP	 R1, R4					; 		testou todas as linhas  
	JLE  tc_prox_linha			; 			do teclado passa � pr�xima
    JMP  tc_fim					; se todas foram testadas termina
tc_ha_tecla:
	ROL  R1, 4					; como houve uma tecla premida associar � respetiva 
	ADD  R0, R1					;			coluna (R0) � linha (R1) correspondente (00000000 LLLLCCCC)       
tc_fim:
    MOV  R1, tecla_premida		; atualiza na vari�vel a informa��o 
    MOV  [R1], R0           	; 		sobre se houve ou n�o tecla premida
	
	POP  R4						; rep�e registos utilizados
	POP  R3
    POP  R2
    POP  R1
    POP  R0
    RET


; **********************************************************************
; *
; * rotina:   	incrementa_aleatorio
; * Descri��o: 	Incrementa o contador utilizado na gera��o de aleat�rios 
; *			   
; * Par�metros de entrada
; *			 
; * Par�metros de sa�da
; *
; **********************************************************************
incrementa_aleatorio:	
    PUSH R0						; preserva registos a utilizar
    PUSH R1
	
	MOV  R0, aleatorio			; incrementa		
	MOV  R1, [R0]				; 		o valor do contador
	ADD  R1, 1					; 			utilizado na gera��o
	MOV  [R0], R1				; 				de n�meros aleat�rios
	
    POP  R1						; rep�e registos utilizados
    POP  R0
    RET
	

; **********************************************************************
; *
; * rotina:   	desenha_nave
; * Descri��o: 	desenha a nave 
; *			   
; * Par�metros de entrada
; *			 
; * Par�metros de sa�da
; *
; **********************************************************************
desenha_nave:
	PUSH R0						; preserva registos a utilizar
	PUSH R1
	PUSH R2	
	PUSH R3
	PUSH R4	
	PUSH R5
	PUSH R6
	PUSH R7	
	PUSH R8
	PUSH R9

	MOV  R0, sentido_nave		; recolhe o sentido do movimento
	MOV  R4, [R0]				;		da nave (-1: esq.; 1: dir.)
	CMP  R4, PARADA				;			e no caso de n�o ser para 
	JZ 	 dn_fim					;  				a movimentar (0) termina
	MOV  R8, R4					; R8 preserva o sentido do movimento
	MOV  R0, cfg_nave
	CALL rd_cfg_obj				; R1/R2 com linha/coluna do ecr�, R3 com � n� de ecr� e R6/R5 com o n� de linhas/colunas da figura, R7 com o endere�o de mem�ria da figura

	;verificar os limites do ecr�. se tiverem sido atingidos e o movimento for nesse sentido n�o fazer nada
	CMP  R8, DIREITA			; sentido do
	JZ   dn_dir					; 		deslocamento � para a direita?
								; analisar a possibilidade de continuar o deslocamento para a esquerda
								; (verificar se canto superior esquerdo da nave (R2) j� atingiu o limite esquerdo do ecr� 
	CMP  R2, 0					; se o deslocamento � para esquerda e a
	JZ	 dn_fim					;		nave j� n�o pode avan�ar mais n�o desenha a nave
	JMP	 dn_movimento			; vai desenhar a nave uma coluna � esquerda

dn_dir:							; analisar a possibilidade de continuar o deslocamento para a direita 
								; (verificar se canto superior direito da nave [R2 (canto superior esquerdo) + R5 (dimens�o da nave)] j� atingiu o limite direito do ecr�
	MOV  R0, R2					; se o deslocamento 		
	ADD  R0, R5					; 		� para a direita 
	MOV  R9, LIM_COL			;			e a nave j� n�o
	CMP  R0, R9					;				pode avan�ar mais 
	JZ   dn_fim					; 					n�o desenha a nave

dn_movimento:					; o movimento � poss�vel vai desenhar a nave
	MOV  R4, 0					; R4 = 0 (limpar zona do ecr�) => valor de R0 irrelevante
	CALL escreve_bloco
	ADD  R2, R8					; R2 com a pr�xima coluna
	MOV  R0, cfg_nave
	CALl wr_cfg_obj				; atualiza a figura com os novos valores de R1, R2, R3, R5, R6 e R7
	
	MOV  R0, [R7]				; R0 com a primeira posi��o da imagem
	MOV  R4, 1					; R4 != 0 (� para copiar a imagem)
	CALL escreve_bloco			; vai copiar o bloco para o ecr�
dn_assinala:
	MOV  R0, sentido_nave		; assinala que j� foi
	MOV  R4, PARADA				;		feita a desloca��o
	MOV  [R0], R4				;			no sentido indicado
dn_fim:
	POP  R9						; rep�e registos utilizados
	POP  R8
	POP  R7
	POP	 R6
	POP	 R5
	POP  R4
	POP	 R3
	POP	 R2
	POP	 R1
	POP	 R0
	RET

	
; **********************************************************************
; *
; * rotina:    	hex2dec
; * Descri��o: 	Converte um valor hexadecimal no valor decimal correspondente 
; * 
; * Par�metros de entrada
; *            	R1 - valor hexadecimal a converter 
; * Par�metros de sa�da
; *            	R2 - valor decimal resultado da convers�o
; *
; **********************************************************************
hex2dec:
	PUSH R1						; preserva registos a utilizar
	PUSH R3
	PUSH R6
	PUSH R7
	
	MOV  R7, DEZ				; valor decimal 10 para ser utilizado na divis�o de convers�o para base decimal
	MOV  R2, 0					; acumulador para o valor convertido (inicia a 0)
	MOV  R3, 1					; peso do digito convertido (inicia a 1 - valor da base levantado a 0)
h2d_prox_dig:
	CMP  R1, 0					; o n�mero j� foi todo convertido?
	JZ   h2d_fim				; fim da convers�o
	MOV  R6, R1					; R6 com a convers�o do digito decimal de 
	MOD  R6, R7					; 		menor peso do atual de valor contido em R1
	DIV  R1, R7					; R1 com o restante n�mero por converter 
	MUL  R6, R3					; R6 com o digito decimal obtido multiplicado pelo peso do digito 
	ADD  R2, R6					; acumular o valor da convers�o
	SHL  R3, 4					; R3 com o peso do digito seguinte
	JMP  h2d_prox_dig			; pr�ximo digito a converter
	
h2d_fim:
	POP	 R7						; rep�e registos utilizados
	POP  R6
	POP  R3
	POP  R1
	RET

	
; **********************************************************************
; *
; * rotina:    	atende_teclado
; * Descri��o: 	Controla o estado do teclado
; * 			caso exista tecla faz o seu tratamento	
; *				C - In�cio do jogo
; *				D - Pausa / Recome�o
; *				E - Fim do jogo
; *				0 - Movimento da nave para a esquerda (permite repeti��o)
; *				1 - Tiro
; *				2 - Movimento da nave para a direita (permite repeti��o)
; * 		   		
; * Par�metros de entrada
; *            	
; * Par�metros de sa�da
; * 
; **********************************************************************	
atende_teclado:			
	PUSH R1						; preserva registos a utilizar
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R7
	PUSH R8
	
	MOV	 R2, estado_teclado 	; R1 com o atual
	MOV  R1, [R2]				;		estado do teclado
				
	MOV  R3, ESPERA_TECLA		; verificar se o 
	CMP  R1, R3					; 		estado � o 0
	JNZ	 at_estado1				; caso n�o seja vai verificar o pr�ximo estado
								; #################  estado 0 - ESPERA TECLA  #################
	MOV  R3, tecla_premida		; verifica se 
	MOV  R1, [R3]				;		foi premida
	CMP  R1, 0					;			alguma tecla
	JZ	 at_fim					; se n�o existir tecla premida termina
	MOV  R3, PREMIU_TECLA		; caso exista tecla assinala
	MOV  [R2], R3				;		esse facto no estado do teclado
	JMP  at_fim					;			e termina
at_estado1:				
	MOV  R3, PREMIU_TECLA		; verificar se o 
	CMP  R1, R3					; 		estado � o 1
	JNZ	 at_estado2				; caso n�o seja vai verificar o pr�ximo estado
								; #################  estado 1 - PREMIU TECLA  #################  
	MOV  R3, TECLA_CARREGADA	; assinala o facto de existir  
	MOV  [R2], R3				;		uma tecla premida no estado do teclado
	MOV  R3, tecla_premida 	 	; R8 com a
	MOV  R8, [R3]				;		tecla premida
								; como foi premida uma tecla vai promover o atendimento das teclas v�lidas
	MOV  R4, tecla_C			; tecla de INICIO
	MOV  R7, [R4]				; 		foi a tecla
	CMP  R8, R7					; 			que foi premida?
	JNZ  at_prox_tecla1			; se n�o � passa para a proxima tecla
								; a��es da tecla de inicio
	MOV  R4, func_jogo			; assinalar
	MOV  R7, EXEC				;		que o jogo
	MOV  [R4], R7				;			est� a decorrer
	JMP  at_fim					; fim do tratamento de teclas
at_prox_tecla1:
	MOV  R4, tecla_D			; tecla de PAUSA
	MOV  R7, [R4]				; 		foi a tecla
	CMP  R8, R7					; 			que foi premida?	
	JNZ  at_prox_tecla2			; se n�o � passa para a proxima tecla
								; a��es da tecla de pausa:
								; duas a��es poss�veis: se est� a executar pausa, se esta pausado 		
	MOV  R4, func_jogo			; verificar
	MOV  R7, [R4]				; 		se o jogo 
	CMP  R7, STOP				;			est� pausado
	JNZ  at_exec				; caso n�o esteja vai colocar em pausa
								; jogo pausado
	MOV  R7, EXEC				; assinalar que o jogo
	MOV  [R4], R7				;		vai voltar a decorrer
	JMP  at_fim					; fim do tratamento de teclas
at_exec:						; jogo em execu��o
	MOV  R7, STOP				; assinalar que o jogo 
	MOV  [R4], R7				;		vai entrar em pausa	
	JMP  at_fim					; fim do tratamento de teclas
at_prox_tecla2:
	MOV  R4, tecla_E			; tecla de FIM
	MOV  R7, [R4]				; 		foi a tecla
	CMP  R8, R7					; 			que foi premida?	
	JNZ  at_prox_tecla3			; se n�o � passa para a proxima tecla
								; a��es da tecla de fim
	MOV  R4, func_jogo			; assinalar
	MOV  R7, HALT				;		que o jogo
	MOV  [R4], R7				;			est� parado
	JMP  at_fim					; fim do tratamento de teclas
at_prox_tecla3:
	MOV  R4, tecla_1			; tecla de TIRO
	MOV  R7, [R4]				; 		foi a tecla
	CMP  R8, R7					; 			que foi premida?
	JNZ  at_prox_tecla4			; se n�o � passa para a proxima tecla
	MOV  R3, existe_tiro		; n�o assinala a exist�ncia  
	MOV  R1, [R3]				; 		de tiro no ecr� no caso
	MOV  R4, ON					; 			caso ainda estar presente
	CMP  R1, R4					;				outro tiro que tenha sido
	JZ   at_fim					;					anteriormente disparado
	MOV  R1, ON					; caso j� n�o exista nenhum tiro no ecr�  
	MOV  [R3], R1				; 		assinala a exist�ncia de um novo na respetiva flag		
	JMP  at_fim					; fim do tratamento de teclas
at_prox_tecla4:
	MOV  R4, tecla_0			; tecla de MOVIMENTO PARA A ESQUERDA
	MOV  R7, [R4]				; 		foi a tecla
	CMP  R8, R7					; 			que foi premida?
	JNZ  at_prox_tecla5			; 			se n�o � passa para a proxima tecla
	MOV  R1, ESQUERDA			; assinalar que
	MOV  R3, sentido_nave		; 		a nave se vai
	MOV  [R3], R1				; 			movimentar para a esquerda
	JMP  at_fim					; fim do tratamento de teclas
at_prox_tecla5:
	MOV  R4, tecla_2			; tecla de MOVIMENTO PARA A DIREITA
	MOV  R7, [R4]				; 		foi a tecla
	CMP  R8, R7					; 			que foi premida?
	JNZ  at_fim					; se n�o � e porque n�o existem mais teclas termina
	MOV  R1, DIREITA			; a��es da tecla de movimento para a direita
	MOV  R3, sentido_nave		; 		a nave se vai
	MOV  [R3], R1				; 			movimentar para a direita
	JMP  at_fim
at_estado2:
	MOV  R3, TECLA_CARREGADA	; verificar se o 
	CMP  R1, R3					; 		estado � o 2
	JNZ	 at_fim					; caso n�o seja termina
								; #################  estado 2 - TECLA CARREGADA  #################
	MOV  R3, tecla_premida		; verifica se
	MOV  R8, [R3]				;		foi premida
	CMP  R8, 0					;			alguma tecla
	JZ	 at_estado0				; se j� n�o existir tecla premida vai para o pr�ximo estado
								; como a tecla continua premida promove o atendimento das teclas de repeti��o v�lidas 
	MOV  R4, tecla_0			; tecla de MOVIMENTO PARA A ESQUERDA
	MOV  R7, [R4]				; 		foi a tecla
	CMP  R8, R7					; 			que foi premida?
	JNZ  at_prox_tecla_rep1		; se n�o � passa para a proxima tecla
	MOV  R1, ESQUERDA			; a��es da tecla de movimento para a esquerda
	MOV  R3, sentido_nave		; 		a nave se vai
	MOV  [R3], R1				; 			movimentar para a esquerda
	JMP  at_fim					; fim do tratamento de teclas
at_prox_tecla_rep1:
	MOV  R4, tecla_2			; tecla de MOVIMENTO PARA A DIREITA
	MOV  R7, [R4]				; 		foi a tecla
	CMP  R8, R7					; 			que foi premida?
	JNZ  at_fim					; 			se n�o � e porque n�o existem mais teclas termina
	MOV  R1, DIREITA					; a��es da tecla de movimento para a direita
	MOV  R3, sentido_nave		; 		a nave se vai
	MOV  [R3], R1				; 			movimentar para a direita
	JMP  at_fim
at_estado0:	
	MOV  R3, ESPERA_TECLA		; caso j� n�o exista tecla assinala
	MOV  [R2], R3				;		esse facto no estado do teclado e termina
at_fim:	
	POP  R8						; rep�e registos utilizados
	POP  R7
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	RET
	
	
; **********************************************************************
; *
; * rotina:    	cont2display
; * Descri��o: 	Escreve nos displays a convers�o em decimal do valor do contador
; * 
; * Par�metros de entrada
; *           
; * Par�metros de sa�da
; * 
; **********************************************************************	
cont2display:	
	PUSH R1						; preserva registos a utilizar
	PUSH R2
	
	MOV  R2, energia			; R1 com o valor
	MOV  R1, [R2]				; 		do contador	de energia	
	CALL hex2dec				; converte valor de R1 (hexa) em decimal. Resultado da convers�o em R2
    MOV  R1, DISPLAYS  			; escreve o valor decimal
	MOV  [R1], R2    			; 		correspondente ao contador de energia nos displays
	
	POP  R2						; rep�e registos utilizados
	POP  R1
	RET


; **********************************************************************
; *
; * rotina:    	endereco_ecra
; * Descri��o: 	Devolve o endere�o do ecr� correspondente � linha 
; *				e coluna recebidos como par�metros			
; * 
; * Par�metros de entrada
; *			    R1 - linha do ecr�
; *			    R8 - coluna do ecr�
; * Par�metros de sa�da
; *			    R10 - endere�o do ecr� correlinha do ecr�
; *
; **********************************************************************
endereco_ecra:
	PUSH R1						; preserva registos a utilizar
	PUSH R8
	PUSH R9
	
	; endere�o do ecr� � dado por MEMORIA_ECRA + 2 * (linha * 64 + coluna)
	MOV	 R10, MEMORIA_ECRA		; endere�o de base da mem�ria do ecr�
	MOV  R9, R1
	SHL	 R9, 6					; linha * 64
    ADD  R9, R8            		; linha * 64 + coluna
    SHL  R9, 1             		; * 2, para ter o endere�o da palavra
	ADD	 R10, R9				; MEMORIA_ECRA + 2 * (linha * 64 + coluna)

	POP  R9						; rep�e registos utilizados
	POP  R8
	POP  R1
	RET

	

; **********************************************************************
; *
; * rotina:   	escreve_bloco
; * Descri��o: 	Escreve um bloco de pixels (m�x: 5 x 5) ou apaga o conte�do do ecr� 
; * 			a partir da linha e coluna indicadas nas coordenadas do ecr� tamb�m indicadas
; *			   
; * Par�metros de entrada
; *				R0 - Endere�o inicial da figura (corresponde ao canto superior esquerdo) 
; *				R4 - indica se � para apagar (0) ou n�o (qualquer outro valor)
; *			    R1 - linha do ecr�
; *			    R2 - coluna do ecr�
; *			    R3 - n� de ecr�
; *			    R5 - n� de colunas do bloco a escrever
; *			    R6 - n� de linhas do bloco a escrever
; * Par�metros de sa�da
; *
; **********************************************************************
escreve_bloco:
	PUSH R0						; preserva registos a utilizar
	PUSH R1
	PUSH R2	
	PUSH R3	
	PUSH R4
	PUSH R5
	PUSH R6	
	PUSH R7
	PUSH R8
	PUSH R9
	PUSH R10

	MOV  R10, ECRA_SELECIONAR	; selecionar o
	MOV  [R10], R3				;		ecr� para desenho	
eb_linha:
	MOV  R7, R5					; contador de n� de colunas
	MOV  R8, R2					; coluna do ecr�
eb_col:	
	MOV  R10, LIM_COL			; se a coluna j� vai cair fora do
	CMP  R8, R10				;		ecr� ajusta o valor da coluna
	JGT	 eb_cont1				; 			para poder passar � pr�xima coluna
	CALL endereco_ecra			; coloca em R10 o endere�o do ecra correspondente a linha (R1) e coluna (R8)
	CMP	 R4, 0					; copiar bloco para o ecr�
	JZ   eb_limpar				;		ou limpar o ecr� (R4=0)
	MOV  R9, [R0]				; l� pixel 
	MOV	[R10], R9				; escreve pixel
	ADD	 R0, DIM_WORD			; endere�o do pr�ximo pixel a ler
	JMP  eb_cont2
eb_limpar:
	MOV  [R10], R4				; limpar pixel
	JMP  eb_cont2				; passar � pr�xima coluna
eb_cont1:
	MOV  R9, BYTE_HIGH			; ajustar o valor da coluna
	OR   R8, R9					; 		se for cair fora do ecr�
eb_cont2:	
	ADD  R8, 1					; pr�xima columa 

	MOV  R9, LIM_COL			; se a coluna desenhada � a �ltima coluna
	CMP  R9, R8					;		do ecr� vai mudar para a pr�xima linha mas primeiro acertar
	JZ	 eb_acerta_adr			;			em conformidade o endere�o do pr�ximo pixel do bloco a escrever
	
	SUB  R7, 1					; ainda n�o terminou
	JNZ  eb_col					;		de escrever as colunas?
	JMP	 eb_next_lin			; se terminou vai mudar para a pr�xima linha
eb_acerta_adr:
	SUB  R7, 1					; contador de colunas acertado (n�o tinha sido atualizado)
	SHL  R7, 1					; x 2 (pixel = word) de maneira a acertar o endere�o do pr�ximo pixel
	ADD  R0, R7					; 		a representar levando em conta as colunas que sa�am fora do ecr�
eb_next_lin:
	ADD  R1, 1					; avan�a para a linha seguinte
	
	MOV  R9, LIM_LIN			; se a linha desenhada 
	CMP  R9, R1					;		� a �ltima linha do ecr�
	JZ	 eb_fim					;			termina o desenho do bloco

	SUB  R6, 1					; pr�xima linha
	JNZ  eb_linha				; ainda n�o terminou de escrever as linhas?
		
eb_fim:	
	POP  R10					; rep�e registos utilizados
	POP  R9
	POP  R8
	POP  R7
	POP	 R6
	POP	 R5
	POP  R4
	POP	 R3
	POP	 R2
	POP	 R1
	POP	 R0
	RET

	
; **********************************************************************
; *
; * rotina:   	gera_ovni
; * Descri��o: 	gera um novo ovni 
; *			   
; * Par�metros de entrada
; * 			 R0 - n�mero do ovni a gerar
; * Par�metros de sa�da
; *
; **********************************************************************
gera_ovni:
	PUSH R0						; preserva registos a utilizar
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R5
	PUSh R6
	PUSH R7
	PUSH R8
	PUSH R9
	
	MOV  R3, geracao_ovnis		; endere�o base da tabela de gera��o dos ovnis
	MOV  R5, R0					; R5 com o deslocamento na tabela em
	SHL  R5, 1					;		fun��o do n�mero do ovni (multiplica por 2 por serem words)
	MOV  R1, [R3+R5]			; verificar se existe 
	CMP  R1, GERAR_OVNI			; 		necessidade e gerar o ovni
	JNZ  go_fim
	MOV  R1, NAO_GERAR_OVNI		; assinalar na tabela que j� 
	MOV  [R3+R5], R1			;		n�o existe a necessidade de gerar o ovni
	
	
	MOV  R8, R0					; preservar numero do ovni em R8
	CALL gera_aleatorios		; R1 - trajet�ria; R2 - tipo de ovni
	
	MOV  R3, dir_ovnis			; endere�o base da tabela de dire��es dos ovnis
	MOV  R5, R0					; R5 com o deslocamento na tabela em
	SHL  R5, 1					;		fun��o do n�mero do ovni (multiplica por 2 por serem words)
	MOV  [R3+R5], R1			; guardar a trajet�ria do ovni na tabela
	
	CMP  R2, 0					; verifica se o ovni � meteorito
	JNZ	 go_cont1
	MOV  R7, tab_ovni1			; R7 com o endere�o de mem�ria da figura do meteorito
	MOV  R9, METEORITO			; R9 com o tipo de ovni
	JMP  go_cont2
go_cont1:
	MOV  R7, tab_ovni2			; R7 com o endere�o de mem�ria da figura da nave inimiga
	MOV  R9, NAVE_INIMIGA		; R9 com o tipo de ovni
go_cont2:
	MOV  R1, INI_LIN_OVNI		; linha do ecra onde vair ser inicialmente representada figura
	MOV  R2, INI_COL_OVNI		; coluna do ecra onde vair ser inicialmente representada figura
	MOV  R3, R0					; n�mero do ecr� onde
	ADD  R3, 1					;		vai ser representado o ovni (+1 porque primeiro ovni tem n� 0)
	MOV  R5, 1					; n�mero inicial de colunas da figura
	MOV  R6, 1					; n�mero inicial de linhas da figura	
	MOV  R0, R8 				; R0 com o n�mero do ovni
	CALL ovni_num2cfg			; obter (em R0) o endere�o da configura��o do ovni 
	CALL wr_cfg_obj				; escrever os valores na configura��o do ovni
	
	MOV  R0, R8 				; R0 com o n�mero do ovni
	CALL limpa_colisao			; limpa a posi��o relativa a este novo ovni na tabela de colis�es

	MOV	 R0, tipo_ovnis			; preencher tipo de 
	SHL  R8, 1					; 		ovni na tabela 
	MOV  [R0+R8], R9			;			de tipos de ovni	

go_fim:	
	POP  R9						; rep�e registos utilizados
	POP  R8
	POP  R7
	POP  R6
	POP  R5
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET
	
	
; **********************************************************************
; *
; * rotina:   	trata_ovnis
; * Descri��o: 	controla os ovnis 
; *			   
; * Par�metros de entrada
; * 			 
; * Par�metros de sa�da
; *
; **********************************************************************
trata_ovnis:
	PUSH R0						; preserva registos a utilizar
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	PUSH R9
	PUSH R10

	MOV  R4, anima_ovnis		; verificar se 
	MOV  R0, [R4]				;		ocorreu o caso 
	CMP  R0, OFF				;			de ter que redesenhar os ovnis
	JNZ  ovs_cont0				; n�o foi utilizado JZ   ovs_fim
	JMP  ovs_fim				;		em virtude de n�o ter alcance suficiente
	
ovs_cont0:	

	MOV  R0, 0					; R0 com o n�mero do primeiro ovni
	MOV	 R9, estado_ovnis 		; R9 com a base da tabela de estados dos ovnis
	MOV  R8, R0					; R8 dom o deslocamento relativo � base da tabela
ovs_prox_ovni:
	MOV  R10, R0				; preservar n�mero do ovni
	MOV  R1, [R9+R8]			; R1 com o atual estado do ovni
	
	MOV  R3, NAO_HA_OVNI		; verificar se o 
	CMP  R1, R3					; 		estado � o 0
	JNZ	 ovs_estado1			; caso n�o seja vai verificar o pr�ximo estado
								; #################  estado 0 - NAO HA OVNI  #################
								; gerar um novo ovni
	CALL gera_ovni

	MOV  R0, R10				; pr�ximo estado do
	MOV  R1, HA_OVNI			;		ovni de n�mero R0
	CALL prox_estado_ovni		;			vai ser HA_OVNI
	JMP  ovs_fim
ovs_estado1:	
	MOV  R3, HA_OVNI			; verificar se o 
	CMP  R1, R3					; 		estado � o 1
	JNZ	 ovs_estado2			; caso n�o seja vai verificar o pr�ximo estado
								; #################  estado 1 - HA_OVNI  #################  
	
	MOV  R0, R10
	CALL ovni_num2cfg			; obter (em R0) o endere�o da configura��o do ovni 
	CALL rd_cfg_obj				; ler configura��o: R1/R2 - linha/coluna do ecr�, R3 - n� de ecr�, R6/R5 - n� de linhas/colunas da figura, R7 - endere�o de mem�ria da figura
	CMP  R5, DIM_MAX_OVNI		; se j� � o maior dimens�o (5x5)
	JZ   ovs_e1_cont1			; vai desenhar os ovnis	   
	
	MOV  R8, cont_mov_ovnis		; somar 1 ao 
	MOV  R0, R10				;		contador de 3
	SHL  R0, 1					;			movimentos do ovni
	MOV  R4, [R8+R0]			;				com o n�mero constante
	ADD  R4, 1					;					em R0 e atualizar o seu
	MOV  [R8+R0], R4			; 						valor respetivo na tabela
	
	CMP  R4, 4					; ainda n�o foram contados 3 movimentos
	JNZ  ovs_e1_cont1			; 		vai desenhar os ovnis no tamanho atual
	MOV  R4, 0					; contador novamente a 0
	MOV  [R8+R0], R4			; atualizar o contador de 3 movimentos do ovni na tabela 
	
	MOV  R0, R10				; R0 com o n�mero do ovni
	CALL ovni_num2cfg			; obter (em R0) o endere�o da configura��o do ovni 
	CALL rd_cfg_obj				; ler configura��o: R1/R2 - linha/coluna do ecr�, R3 - n� de ecr�, R6/R5 - n� de linhas/colunas da figura, R7 - endere�o de mem�ria da figura
	ADD	 R5, 1					; mudar a dimens�o da  
	ADD  R6, 1					; 		figura para o tamanho seguinte
	ADD  R7, DIM_WORD			; mudar para o endere�o do tamanho seguinte
	MOV  R0, R10 				; R0 com o n�mero do ovni
	CALL ovni_num2cfg			; obter (em R0) o endere�o da configura��o do ovni 
	CALL wr_cfg_obj				; guardar a nova configura��o 	

ovs_e1_cont1:	
	MOV  R0, R10				; verificar se    
	CALL existe_colisao			; 		o ovni sofreu  
	CMP  R0, SEM_COLISAO		; 			uma colis�o 
	JZ   ovs_e1_cont4			; caso n�o tenha acontecido continua	
	
								; existe colis�o
	CMP  R0, NAVE_VS_METEO		; se a colis�o n�o foi 
	JNZ  ovs_e1_cont2			; 		nave vs meteorito passa ao pr�ximo teste
								
								; colis�o nave vs meteorito
	MOV  R1, SOM_MINERAR		; reproduz o 
	CALL play_som				;		som de minerar
	MOV  R0, MAIS_ENERGIA_M		; soma 10 ao valor atual
	CALL atualiza_energia		; 		da energia e atualiza-o na vari�vel

	MOV  R0, R10				; como o meteorito vai desaparecer assinala
	CALL novo_ovni				; 		que tem que ser gerado um novo ovni (R0 com o n�mero)
	
	MOV  R0, R10				; pr�ximo estado do
	MOV  R1, MINERAR			;		ovni de n�mero R0
	CALL prox_estado_ovni		;			vai ser MINERAR
	JMP  ovs_cont2				; passa ao pr�ximo ovni

								; as colis�es do missil com ovnis t� o mesmo tratamento � exece��o
								; do acr�scimo de 5 � energia no caso de ter ocorrido com uma nave
ovs_e1_cont2:					
	CMP  R0, MISSIL_VS_METEO	; se a colis�o foi 
	JZ   ovs_e1_cont3			; 		missil vs meteorito vai explodir	
	CMP  R0, MISSIL_VS_NAVE		; se a colis�o n�o foi 
	JNZ  ovs_e1_cont4			; 		missil vs nave continua	
	MOV  R0, MAIS_ENERGIA_N		; soma 5 ao valor atual
	CALL atualiza_energia		; 		da energia e atualiza-o na vari�vel

ovs_e1_cont3:
								; a reprodu��o do som da explos�o � feita neste estado e n�o no seguinte (EXPLOSAO)
								; para melhor sinconismo entre a imagem da explos�o e o som
	MOV  R1, SOM_EXPLOSAO_O		; reproduz o 
	CALL play_som				;		som de explos�o de ovni

	MOV  R0, R10 				; R0 com o n�mero do ovni
	CALL ovni_num2cfg			; obter (em R0) o endere�o da configura��o do ovni 
	CALL rd_cfg_obj				; ler configura��o: R1/R2 - linha/coluna do ecr�, R3 - n� de ecr�, R6/R5 - n� de linhas/colunas da figura, R7 - endere�o de mem�ria da figura
	MOV  R7, tab_explosao		; trocar a figura do 
	MOV  R5, DIM_MAX_OVNI		;		ovni pela da explos�o
	MOV  R6, DIM_MAX_OVNI		;			para que esta possa ser
	CALL wr_cfg_obj				; 		 		representada no ecr�

	MOV  R0, R10				; pr�ximo estado do
	MOV  R1, EXPLOSAO			;		ovni de n�mero R0
	CALL prox_estado_ovni		;			vai ser EXPLOSAO
	JMP  ovs_cont1				; vai desenhar a explos�o	
	
ovs_e1_cont4:	
	MOV  R3, geracao_ovnis		; endere�o base da tabela de gera��o dos ovnis
	MOV  R5, R10				; R5 com o deslocamento na tabela em
	SHL  R5, 1					;		fun��o do n�mero do ovni (multiplica por 2 por serem words)
	MOV  R8, [R3+R5]			; verificar se existe 
	CMP  R8, GERAR_OVNI			; 		necessidade de gerar o ovni
	JNZ  ovs_cont1				; caso n�o exista necessidade continua
	
	MOV  R0, R10				; pr�ximo estado do
	MOV  R1, NAO_HA_OVNI		;		ovni de n�mero R0
	CALL prox_estado_ovni		;			vai ser NA_HA_OVNI
	JMP  ovs_cont2				; passa ao pr�ximo ovni
	
ovs_estado2:	
	MOV  R3, EXPLOSAO			; verificar se o 
	CMP  R1, R3					; 		estado � o 2
	JNZ	 ovs_estado3			; caso n�o seja vai verificar o pr�ximo estado
								; #################  estado 2 - EXPLOSAO  #################  

								; limpar explos�o
	MOV  R0, R10 				; apaga ovni do ecra (R0 com o n�mero)
	CALL apaga_ovni				; 		neste caso a figura do ovni tinha sido substituida pela da explos�o		

	MOV  R0, R10				; como o existiu colis�o assinala   
	CALL novo_ovni				; 		que tem que ser gerado um novo ovni  (R0 com o n�mero)

	MOV  R0, R10				; pr�ximo estado do
	MOV  R1, NAO_HA_OVNI		;		ovni de n�mero R0
	CALL prox_estado_ovni		;			vai ser NA_HA_OVNI
	JMP  ovs_cont2				; vai desenhar os ovnis 
	
ovs_estado3:	
	MOV  R3, MINERAR			; verificar se o 
	CMP  R1, R3					; 		estado � o 3
	JNZ	 ovs_cont1				; caso n�o seja vai terminar
								; #################  estado 3 - MINERAR  #################  
								
								; limpar a figura do meteorito	
	MOV  R0, R10 				; apaga ovni do ecra
	CALL apaga_ovni				;		(R0 com o n�mero)

	MOV  R0, R10				; como o meteorito vai desaparecer assinala   
	CALL novo_ovni				; 		que tem que ser gerado um novo ovni (R0 com o n�mero)

	MOV  R0, R10				; pr�ximo estado do
	MOV  R1, NAO_HA_OVNI		;		ovni de n�mero R0
	CALL prox_estado_ovni		;			vai ser NA_HA_OVNI
	JMP  ovs_cont2				; vai desenhar os ovnis 
	
ovs_cont1:
	MOV  R0, R10 				; R0 com o n�mero do ovni
	MOV  R2, dir_ovnis			; endere�o base da tabela de dire��es dos ovnis
	SHL  R0, 1					; R0 com o deslocamento na tabela em
	MOV  R4, [R2+R0]			;		fun��o do n�mero do ovni (multiplica por 2 por serem words)
	SHR  R0, 1					; repor R0
	CALL desenha_ovni			; desenha o ovni	
	
ovs_cont2:
	MOV  R0, R10 				; R0 com o n�mero do ovni
	ADD  R0, 1					; n�mero do pr�ximo ovni
	MOV  R8, R0					; R8 com o deslocamento relativo ao pr�ximo
	SHL  R8, 1					;		ovni face � base da tabela de estados dos ovnis 
	CMP  R0, NUM_MAX_OVNI		; 
	JZ   ovs_cont3				; n�o foi utilizado JNZ ovs_prox_ovni
	JMP  ovs_prox_ovni			;		em virtude de n�o ter alcance suficiente
ovs_cont3:	

	MOV  R0, OFF				; assinalar que 
	MOV  R4, anima_ovnis		;		j� foi tratada a
	MOV [R4], R0				;			ocorr�ncia do interrupt	

ovs_fim:
	POP  R10						; rep�e registos utilizados					
	POP  R9									
	POP  R8
	POP  R7
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET	
	

; **********************************************************************
; *
; * rotina:   	prox_estado_ovni
; * Descri��o: 	guarda o pr�ximo estado de um ovni
; *			   
; * Par�metros de entrada
; * 			R0 - n�mero do ovni
; *				R1 - pr�ximo estado
; * Par�metros de sa�da
; *
; **********************************************************************	
prox_estado_ovni:	
	PUSH R0						; preserva registos a utilizar
	PUSH R1
	PUSH R2

	MOV  R2, estado_ovnis 		; R1 com a base da tabela de estados dos ovnis  
	SHL  R0, 1					; R0 com o deslocamento calculado a partir do n�mero do ovni   
	MOV  [R2+R0], R1			; guarda o pr�ximo estado do ovni no lugar corresponente da tabela 

	POP  R2						; rep�e registos utilizados		
	POP  R1
	POP  R0
	RET
	
	
; **********************************************************************
; *
; * rotina:   	apaga_ovni
; * Descri��o: 	apaga um ovni do ecr�
; *			   
; * Par�metros de entrada
; * 			 R0 - n�mero do ovni
; * Par�metros de sa�da
; *
; **********************************************************************
apaga_ovni:
	PUSH R0						; preserva registos a utilizar
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7

	CALL ovni_num2cfg			; obter (em R0) o endere�o da configura��o do ovni 
	CALL rd_cfg_obj				; ler configura��o: R1/R2 - linha/coluna do ecr�, R3 - n� de ecr�, R6/R5 - n� de linhas/colunas da figura, R7 - endere�o de mem�ria da figura
	MOV  R4, 0					; R4 = 0 (limpar zona do ecr�) => valor de R0 irrelevante		
	CALL escreve_bloco
							
	POP  R7						; rep�e registos utilizados	
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET
	
	
; **********************************************************************
; *
; * rotina:   	novo_ovni
; * Descri��o: 	assinala na tabela que ter� que ser gerado um ovni
; *			   
; * Par�metros de entrada
; * 			 R0 - n�mero do ovni a gerar
; * Par�metros de sa�da
; *
; **********************************************************************
novo_ovni:
	PUSH R0						; preserva registos a utilizar
	PUSH R1
	PUSH R2

	MOV  R1, geracao_ovnis		; R1 com a base da tabela de geral��o de ovnis    
	SHL  R0, 1					; R0 com o deslocamento calculado a partir do n�mero do ovni    
	MOV  R2, GERAR_OVNI			; assinala no endere�o corresspondente da tabela de
	MOV  [R1+R0], R2			; 		gera��o de ovnis a necessidade de gera��o de um novo ovni

	POP  R2						; rep�e registos utilizados
	POP  R1
	POP  R0
	RET

	
; **********************************************************************
; *
; * rotina:   	desenha_ovni
; * Descri��o: 	desenha um ovni 
; *			   
; * Par�metros de entrada
; * 			R0 - n� do ovni a desenhar
; *				R4 - dire��o do movimento (-1: -45�; 0: 0�; 1: 45�) 
; * Par�metros de sa�da
; *
; **********************************************************************
desenha_ovni:
	PUSH R0						; preserva registos a utilizar
	PUSH R1
	PUSH R2	
	PUSH R3
	PUSH R4	
	PUSH R5
	PUSH R6	
	PUSH R7
	PUSH R8
	PUSH R9
	
	MOV  R8, R4					; R8 preserva a dire��o
	MOV  R9, R0					; R9 preserva o n�mero do ovni
	CALL ovni_num2cfg			; obter (em R0) o endere�o da configura��o do ovni 
	CALL rd_cfg_obj				; ler configura��o: R1/R2 - linha/coluna do ecr�, R3 - n� de ecr�, R6/R5 - n� de linhas/colunas da figura, R7 - endere�o de mem�ria da figura

	MOV  R4, 0					; R4 = 0 (limpar zona do ecr�) => valor de R0 irrelevante
	CALL escreve_bloco

								; pr�ximas coordenadas
	ADD  R1, 1					; R1 com a pr�xima linha	
	ADD  R2, R8					; R2 com a pr�xima coluna
	MOV  R0, R9 				; R0 com o n�mero do ovni
	CALL ovni_num2cfg			; obter (em R0) o endere�o da configura��o do ovni 
	CALl wr_cfg_obj				; atualiza a figura com os novos valores de R1, R2, R3, R5, R6 e R7
	
	MOV  R8, LIM_LIN			; se o ovni n�o 
	CMP  R1, R8					; 		desapareceu do 
	JNZ  do_cont1				;			ecr� vai desenhar
	
	MOV  R0, R9					; se o ovni desapareceu no 
	CALL novo_ovni				; 		fundo do ecr� vai gerar um novo ovni
	JMP  do_fim
								; ler os dados da nova situa��o do ovni para o pode desenhar convenientemente
do_cont1:
	MOV  R0, R9 				; R0 com o n�mero do ovni
	CALL ovni_num2cfg			; obter (em R0) o endere�o da configura��o do ovni
	CALL rd_cfg_obj				; ler configura��o: R1/R2 - linha/coluna do ecr�, R3 - n� de ecr�, R6/R5 - n� de linhas/colunas da figura, R7 - endere�o de mem�ria da figura
	MOV  R0, [R7]				; R0 com a primeira posi��o da imagem
	MOV  R4, 1					; R4 != 0 (� para representar a imagem no ecr�)
	CALL escreve_bloco			; vai copiar o bloco para o ecr�
		
do_fim:
	POP  R9						; rep�e registos utilizados				
	POP  R8
	POP  R7
	POP	 R6
	POP	 R5
	POP  R4
	POP	 R3
	POP	 R2
	POP	 R1
	POP	 R0
	RET


; **********************************************************************
; *
; * rotina:   	rd_cfg_obj
; * Descri��o: 	L� a configura��o de uma figura
; *			   
; * Par�metros de entrada
; *				R0 -  endere�o da figura
; * Par�metros de sa�da
; *				R1 - linha do ecr� onde a figura come�a
; *				R2 - coluna do ecr� onde a figura come�a
; *             R3 - n� do ecr�
; *				R5 - n� de colunas da figura
; *				R6 - n� de linhas da figura
; *				R7 - endere�o de mem�ria da figura a representar
; *
; **********************************************************************
rd_cfg_obj:
	PUSH R0						; preserva registos a utilizar
	PUSH R8
	
	MOV  R1, [R0]
	MOV  R2, R1
	MOV  R5, BYTE_LOW
	AND  R2, R5					; R2 com a coluna do ecr�
	SHR  R1, 8					; R1 com a linha do ecr�
	
	ADD  R0, DIM_WORD
	MOV  R3, [R0]
	MOV  R5, R3 
	SHR  R3, 8					; R3 com o n� de ecr�
	MOV  R8, BYTE_LOW
	AND  R5, R8
	MOV  R6, R5
	MOV  R8, NIBBLE_LOW
	AND  R5, R8					; R5 com o n� de colunas da figura
	SHR	 R6, 4					; R6 com o n� de linhas da figura
	
	ADD	 R0, DIM_WORD
	MOV  R7, [R0]				; R7 com o endere�o de mem�ria da figura	

	POP  R8						; rep�e registos utilizados			
	POP  R0
	RET

	
; **********************************************************************
; *
; * rotina:   	wr_cfg_obj
; * Descri��o: 	Escreve a configura��o de uma figura
; *			   
; * Par�metros de entrada
; *				R0 - endere�o da figura
; *				R1 - linha do ecr� onde a figura come�a
; *				R2 - coluna do ecr� onde a figura come�a
; *             R3 - n� do ecr�
; *				R5 - n� de colunas da figura
; *				R6 - n� de linhas da figura
; *				R7 - endere�o de mem�ria da figura a representar
; * Par�metros de sa�da
; *
; **********************************************************************
wr_cfg_obj:
	PUSH R0						; preserva registos a utilizar
	PUSH R1
	PUSH R2 
	PUSH R3 
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	
	SHL  R1, 8					; construir uma word
	MOV  R8, BYTE_LOW			;		com R1 como byte high
	AND  R2, R8					;			e R2 como byte low
	OR   R1, R2					;				correspondente � primeira
	MOV  [R0], R1				;					word da configura��o da figura
	
	SHL  R6, 4					; construir um byte com R6 como 
	OR   R6, R5					;		nibble high e R7 como niblle low
	SHL  R3, 8					; construir uma word com R3 como byte high
	OR   R3, R6					;		e o byte construido atr�s como byte low
	ADD  R0, DIM_WORD			; correspondente � segunda 
	MOV  [R0], R3				; 		word da configura��o da figura		.
	
	ADD  R0, DIM_WORD			; endere�o de mem�ria da figura a representar 
	MOV  [R0], R7				;		com terceira word da configura��o da figura

	POP  R8						; rep�e registos utilizados			
	POP  R7
	POP  R6
	POP  R5
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET
	

; **********************************************************************
; *
; * rotina:   	desenha_tiro
; * Descri��o: 	Desenha ou apaga o pixel correspondente ao missil
; *			   
; * Par�metros de entrada
; *				R4 - indica se � para desenhar (1) ou apagar (0)
; * Par�metros de sa�da
; *
; **********************************************************************	
desenha_tiro:
	PUSH R0						; preserva registos a utilizar
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R7
	PUSH R8
	
	MOV	 R0, missil				; R0 com o pixel a representar
	MOV  R8, posicao_tiro		; R1 e R2 
	MOV  R1, [R8]				;		com a 
	MOV  R2, R1					; 			linha e a 
	MOV  R7, BYTE_LOW			;				coluna do tiro  
	AND  R2, R7					;					obtidos a partir da
	SHR	 R1, 8					;						variavel posi��o de tiro 
	MOV  R3, 0					; R3 com o ecr� do tiro (0)
	CALL escreve_pixel

	POP  R8						; rep�e registos utilizados			
	POP  R7
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET
	
	
; **********************************************************************
; *
; * rotina:   	tiro
; * Descri��o: 	Executa as ac��es relativas ao processo tiro
; *			   
; * Par�metros de entrada
; *				
; * Par�metros de sa�da
; *
; **********************************************************************
tiro:
	PUSH R0						; preserva registos a utilizar
	PUSH R1						
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R7
	PUSH R8
	
	MOV	 R2, estado_tiro 		; R1 com o atual
	MOV  R1, [R2]				;		estado do tiro
				
	MOV  R3, NAO_HA_TIRO		; verificar se o 
	CMP  R1, R3					; 		estado � o 0
	JNZ	 t_estado1				; caso n�o seja vai verificar o pr�ximo estado
								; #################  estado 0 - NAO HA TIRO  #################
	MOV  R8, existe_tiro		; R1 com flag de tiro   
	MOV  R1, [R8]				; 		existente no ecr�	
	CMP  R1, OFF				; se n�o existe tiro
	JZ   t_fim					;		n�o faz nada
	MOV  R3, TIRO_EFETUADO		; assinala o facto de ter sido
	MOV  [R2], R3				; 		 efetuado um tiro no estado do tiro
	JMP  t_fim
	
t_estado1:	
	MOV  R3, TIRO_EFETUADO		; verificar se o 
	CMP  R1, R3					; 		estado � o 1
	JNZ	 t_estado2				; caso n�o seja vai verificar o pr�ximo estado
								; #################   estado 1 - TIRO EFETUADO  #################  
								; diminui a energia se puder
	MOV  R7, energia			; R1 com o valor  
	MOV  R1, [R7]				; 		da energia	
	CMP  R1, 0					; se j� n�o existe energia
	JZ   t_fim					; 		para disparar n�o faz nada	
	MOV  R0, MENOS_ENERGIA		; sen�o retira 5 ao valor atual
	CALL atualiza_energia		; 		da energia e atualiza-o na vari�vel

								; emite o som referente ao tiro
	MOV  R1, SOM_TIRO			; reproduz o 				
	CALL play_som				; 		som de tiro
	
								; regista a posi��o onde vai ser desenhado o tiro
	MOV  R8, posicao_tiro		; determinar a posi��o  
	MOV  R7, cfg_nave			;		onde o tiro dever� ser 
	MOV  R1, [R7]				;			representado a partir	
	MOV  R7, POS_TIRO_INI		;				da posi��o da nave e 
	SUB  R1, R7					;					guardar esse valor na
	MOV  [R8], R1				;						variavel da posi��o de tiro	
	MOV  R4, 1					; desenha a primeira
	CALL desenha_tiro			; 		ocorr�ncia do tiro

	MOV  R3, HA_TIRO			; assinala o facto de passar
	MOV  [R2], R3				;		a existir um tiro no ecr�  no estado do tiro
	JMP  t_fim					; 
t_estado2:
	MOV  R3, HA_TIRO			; verificar se o 
	CMP  R1, R3					; 		estado � o 2
	JNZ	 t_fim					; caso n�o seja termina
								; #################  estado 2 - HA TIRO  #################  
							
								; verificar se � o timing de refrescamento do ecra
	MOV  R0, anima_tiro			; verificar 
	MOV  R1, [R0]				;		se ocorreu
	CMP	 R1, ON					; 			o interrupt 1
	JNZ	 t_fim					; se n�o ocorreu termina

	MOV  R8, MISSIL_VS_NAVE		; verifica se est�  
	CALL existem_colisoes		; 		na circunst�ncia do
	CMP  R1, MISSIL_VS_NAVE		;			tiro se extinguir por ter	 
	JZ   t_vai_estado0			; 				existido colis�o com uma nave inimiga
	
	MOV  R8, MISSIL_VS_METEO	; verifica se est�  
	CALL existem_colisoes		; 		na circunst�ncia do
	CMP  R1, MISSIL_VS_METEO	;			tiro se extinguir por ter	
	JZ   t_vai_estado0				; 				existido colis�o com um meteorito	

	MOV  R4, 0					; limpa o tiro
	CALL desenha_tiro			; 		existente no ecr�
	
	MOV  R8, posicao_tiro		; R1 com a posi��o 
	MOV  R1, [R8]				;		atual do tiro no ecr�
	MOV  R7, R1					; preservar R1

	SHR  R7, 8					; verifica se est�
	MOV  R3, TIRO_ULT_LINHA		; 		na circunst�ncia do 
	CMP	 R7, R3					;			tiro se extinguir por 
	JZ	 t_vai_estado0			;				motivo da dist�ncia 
	
								; verificar se existem colis�es do missil se sim vai para o estado 0
	MOV	 R7, UMA_LINHA			; atualizar a
	SUB  R1, R7					; 		vari�vel posi��o
	MOV  R8, posicao_tiro		;			de tiro com a nova
	MOV  [R8], R1				;				posi��o do tiro no ecr�
	
	MOV  R4, 1					; desenha o tiro
	CALL desenha_tiro			; 		na nova posi��o
	
	MOV  R0, anima_tiro			; assinalar que 
	MOV  R1, OFF				;		o interrupt
	MOV  [R0], R1				;			j� foi tratado
	
	JMP  t_fim
t_vai_estado0:
	MOV  R3, NAO_HA_TIRO		; assinala o facto de deixar de existir
	MOV  [R2], R3				;		um tiro no ecr� no estado do tiro
	
	MOV  R4, 0					; limpa o tiro
	CALL desenha_tiro			; 		existente no ecr�

 	MOV  R8, posicao_tiro		; limpa a vari�vel			
	MOV  R2, 0					;		que tem a posi��o
	MOV  [R8], R2				;			do tiro no ecra
	
	MOV  R8, existe_tiro		; flag de tiro   
	MOV  R2, OFF				;		assinala a 
	MOV  [R8], R2				; 			inexistencia de tiro	
    
t_fim:
	POP  R8						; rep�e registos utilizados		
	POP  R7
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET
	
	
; **********************************************************************
; * rotina:		escreve_pixel
; * Descri��o: 	escreve a cor de um pixel na linha e coluna indicadas
; *             O endere�o do pixel � dado por MEMORIA_ECRA + 2 * (linha * 64 + coluna)
; * 
; * Par�metros de entrada
; *				R0 - Endere�o do pixel a representar 
; *			    R1 - linha do ecr�
; *			    R2 - coluna do ecr�
; *			    R3 - n� de ecr�
; *				R4 - indica se � para apagar (0) ou n�o (qualquer outro valor)
; * Par�metros de sa�da
; *
; **********************************************************************
escreve_pixel:
	PUSH R0						; preserva registos a utilizar
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	push R8
	PUSH R10
	
	MOV  R10, ECRA_SELECIONAR	; selecionar o ecr�  
	MOV  [R10], R3				; 		onde o pixel vai ser desenhado
	
	CMP  R4, 0					; verifica se �
	JZ	 ep_cont				;		para limpar um pixel
	MOV  R4, [R0]				; se n�o for ir buscar o pixel a representar
ep_cont:
	MOV  R8, R2
	CALL endereco_ecra			; coloca em R10 o endere�o do ecra correspondente a linha (R1) e coluna (R8)
	MOV	 [R10], R4				; escreve no pixel
	
	POP	 R10					; rep�e registos utilizados	
	POP  R8	
	POP	 R4
	POP	 R3
	POP	 R2
	POP	 R1
	POP	 R0
	RET
	
	
; **********************************************************************
; *
; * rotina:    	clr_scr
; * Descri��o: 	limpa um ecra
; * 
; * Par�metros de entrada
; *            R1 - n� do ecr�
; * Par�metros de sa�da
; *
; **********************************************************************
clr_scr:
	PUSH R0						; preserva registos a utilizar
	PUSH R1
	PUSH R2
	
	MOV	 R0, LIMPA_ECRA
	MOV  R1, 0
	MOV  R2, NUM_ECRAS
cs_ciclo:
	MOV	 [R0], R1
	ADD  R1, 1
	CMP  R1, NUM_ECRAS
	JNZ  cs_ciclo
	MOV  R0, APAGA_AVISO 
    MOV  [R0], R1        
	
	POP  R2						; rep�e registos utilizados		
	POP  R1
	POP  R0
	RET


; **********************************************************************
; *
; * rotina:    	play_som
; * Descri��o: 	limpa um ecra
; * 
; * Par�metros de entrada
; *            R1 - n� som
; * Par�metros de sa�da
; *
; **********************************************************************
play_som:
	PUSH R0						; preserva registos a utilizar
	PUSH R1
					;
	MOV  R0, SOM				;
    MOV  [R0], R1       		; 

	MOV  R0, PLAY_SOM_VD		; reproduz o som cujo
    MOV  [R0], R1        		; 		n�mero � recebido por par�metro

	POP  R1						; rep�e registos utilizados				
	POP  R0
	RET
	

; **********************************************************************
; *
; * rotina:    	gera_aleatorios
; * Descri��o:	gera dois n�mero aleat�rios a partir de um contador
; * 			para a defini��o da trajet�ria (33% para cada uma das 3 poss�veis)
; *					-1 - esquerda 45�; 0 - baixo; 1 - direita 45�
; *				para o tipo de ovni (25% - meteorito; 75% - nave inimiga)
; *					0 - meteorito; 1,2 ou 3 - nave inimiga
; * 
; * Par�metros de entrada
; *            
; * Par�metros de sa�da
; *				R1 - trajet�ria
; *				R2 - tipo de ovni
; *
; **********************************************************************
gera_aleatorios:
	PUSH R0 					; preserva registos a utilizar
	
	MOV  R0, aleatorio			; recolhe para R1 o valor do contador
	MOV  R1, [R0]				; 		que suporta a gera��o dos n�meros aleat�rios
	MOV  R2, R1					; preserva-o em R2
	MOV	 R0, 3					; R1 com a trajetoria obtida a apartir do resto da 
	MOD	 R1, R0					; 		divis�o inteira por 3 diminuida de 1 
	SUB	 R1, 1					;			-1 - esquerda 45�; 0 - baixo; 1 - direita 45�
	AND  R2, R0					; R2 com o tipo de ovni (0 - meteorito; 1,2 ou 3 - inimigo)
	
ga_fim:	
	POP  R0						; rep�e registos utilizados
	RET
	
	
; **********************************************************************
; *
; * rotina:		ovni_num2cfg
; * Descri��o:	copia um bloco de mem�ria de um endere�o para outro
; * 
; * Par�metros de entrada
; * 			R0 - n�mero do ovni
; * Par�metros de sa�da
; * 			R0 - endere�o da configura��o do ovni
; *
; **********************************************************************
ovni_num2cfg:
	PUSH R1						; preserva registos a utilizar
	PUSH R2

	MOV  R1, cfg_ovnis 			; base da tabela de configura��o dos ovnis
	MOV  R2, DIM_CFG_OVNI		; dimens�o em bytes da configura��o de um ovni 
	MUL  R0, R2					; multiplicar numero do ovni pela dimens�o da configura��o para obter o deslocamento em rela��o � base
	ADD  R0, R1					; somar o deslocamento � base da tabela
	
	POP  R2						; rep�e registos utilizados
	POP  R1
	RET
	

; **********************************************************************
; *
; * rotina:		permite_teclas012
; * Descri��o:	permite a utiliza��o das teclas 0, 1 e 2
; * 
; * Par�metros de entrada
; * 			
; * Par�metros de sa�da
; * 			
; *
; **********************************************************************	
permite_teclas012:
	PUSH R0						; preserva registos a utilizar
	PUSH R1
	
	MOV  R0, tecla_0			; permitir
	MOV  R1, TECLA_0			;		o uso da
	MOV  [R0], R1				;			tecla 0
	MOV  R0, tecla_1			; permitir
	MOV  R1, TECLA_1			;		o uso da
	MOV  [R0], R1				;			tecla 1
	MOV  R0, tecla_2			; permitir
	MOV  R1, TECLA_2			;		o uso da
	MOV  [R0], R1				;			tecla 2
	
	POP  R1						; rep�e registos utilizados
	POP  R0
	RET

; **********************************************************************
; *
; * rotina:		inibe_teclas012
; * Descri��o:	n�o permite a utiliza��o das teclas 0, 1 e 2
; * 
; * Par�metros de entrada
; * 			
; * Par�metros de sa�da
; * 			
; *
; **********************************************************************	
inibe_teclas012:
	PUSH R0						; preserva registos a utilizar
	PUSH R1
	
	MOV  R0, tecla_0			; n�o permitir
	MOV  R1,0					;		o uso da
	MOV  [R0], R1				;			tecla 0
	MOV  R0, tecla_1			; e da 
	MOV  [R0], R1				;		tecla 1
	MOV  R0, tecla_2			; e da
	MOV  [R0], R1				;		tecla 2
	
	POP  R1						; rep�e registos utilizados
	POP  R0
	RET	
	
	
; **********************************************************************
; *
; * rotina:		permite_teclaC
; * Descri��o:	permite a utiliza��o da tecla C
; * 
; * Par�metros de entrada
; * 			
; * Par�metros de sa�da
; * 			
; *
; **********************************************************************	
permite_teclaC:	
	PUSH R0						; preserva registos a utilizar
	PUSH R1

	MOV  R0, tecla_C			; permitir 
	MOV  R1, TECLA_C			;		o uso da
	MOV  [R0], R1				;			tecla C	
	
	POP  R1						; rep�e registos utilizados
	POP  R0
	RET	

	
; **********************************************************************
; *
; * rotina:		inibe_teclaC
; * Descri��o:	n�o permite a utiliza��o da tecla C
; * 
; * Par�metros de entrada
; * 			
; * Par�metros de sa�da
; * 			
; *
; **********************************************************************	
inibe_teclaC:	
	PUSH R0						; preserva registos a utilizar
	PUSH R1

	MOV  R0, tecla_C			; n�o permitir 
	MOV  R1, 0					;		o uso da
	MOV  [R0], R1				;			tecla C	
	
	POP  R1						; rep�e registos utilizados
	POP  R0
	RET	

; **********************************************************************
; *
; * rotina:		permite_teclaD
; * Descri��o:	permite a utiliza��o da tecla D
; * 
; * Par�metros de entrada
; * 			
; * Par�metros de sa�da
; * 			
; *
; **********************************************************************	
permite_teclaD:	
	PUSH R0						; preserva registos a utilizar
	PUSH R1

	MOV  R0, tecla_D			; permitir
	MOV  R1, TECLA_D			;		o uso da
	MOV  [R0], R1				;			tecla D
	
	POP  R1						; rep�e registos utilizados
	POP  R0
	RET	

; **********************************************************************
; *
; * rotina:		inibe_teclaD
; * Descri��o:	n�o permite a utiliza��o da tecla D
; * 
; * Par�metros de entrada
; * 			
; * Par�metros de sa�da
; * 			
; *
; **********************************************************************	
inibe_teclaD:	
	PUSH R0						; preserva registos a utilizar
	PUSH R1

	MOV  R0, tecla_D			; n�o permitir
	MOV  R1, 0					;		o uso da
	MOV  [R0], R1				;			tecla D
	
	POP  R1						; rep�e registos utilizados
	POP  R0
	RET	
	
	
; **********************************************************************
; *
; * rotina:		permite_teclaE
; * Descri��o:	permite a utiliza��o da tecla E
; * 
; * Par�metros de entrada
; * 			
; * Par�metros de sa�da
; * 			
; *
; **********************************************************************	
permite_teclaE:	
	PUSH R0						; preserva registos a utilizar
	PUSH R1

	MOV  R0, tecla_E			; permitir
	MOV  R1, TECLA_E			;		o uso da
	MOV  [R0], R1				;			tecla E	
	
	POP  R1						; rep�e registos utilizados
	POP  R0
	RET	
	
	
; **********************************************************************
; *
; * rotina:		inibe_teclaE
; * Descri��o:	n�o permite a utiliza��o da tecla E
; * 
; * Par�metros de entrada
; * 			
; * Par�metros de sa�da
; * 			
; *
; **********************************************************************	
inibe_teclaE:	
	PUSH R0						; preserva registos a utilizar
	PUSH R1

	MOV  R0, tecla_E			; n�o permitir
	MOV  R1, 0					;		o uso da
	MOV  [R0], R1				;			tecla E	
	
	POP  R1						; rep�e registos utilizados
	POP  R0
	RET	


; **********************************************************************
; *
; * rotina:		muda_ecra
; * Descri��o:	coloca como fundo o ecr� de n�mero recebido como par�metro
; * 
; * Par�metros de entrada
; * 			R1 - numero do ecra a visualizar
; * Par�metros de sa�da
; * 			
; *
; **********************************************************************	
muda_ecra:	
	PUSH R0						; preserva registos a utilizar
	PUSH R1

	MOV  R0, IMG_FUNDO			; 	como imagem de 
    MOV  [R0], R1       		; 		de fundo do ecr�	
	
	POP  R1						; rep�e registos utilizados
	POP  R0
	RET	


; **********************************************************************
; *
; * rotina:		deteta_colisoes
; * Descri��o: 	preenche a tabela de colis�es dos ovnis com as colis�es 
; *			   	que possam ter ocorrido 
; *
; * Par�metros de entrada
; *				
; * Par�metros de sa�da
; *
; **********************************************************************
deteta_colisoes:
	PUSH R0						; preserva registos a utilizar
	PUSH R1
	PUSH R2				
	PUSH R3
	PUSH R4
	PUSH R5

	MOV  R3, colisao_ovnis		; base da tabela de colis�es dos ovnis
	MOV  R2, 0					; n�mero do primeiro ovni
dcs_ciclo:
	MOV  R1, R2					; verificar se existe 
	MOV  R0, MISSIL				; 		colis�o entre o ovni 
	CALL deteta_colisao			; 			a ser analisado e o missil (resultado em R1)
	CMP  R1, SEM_COLISAO		; se n�o foi detetada colis�o
	JZ  dcs_tst_nave			; 		passa vai testar se existe colis�o com a anave	
	JMP dcs_guarda				; vai guardar a colis�o
dcs_tst_nave:
	MOV  R1, R2					; verificar se existe 
	MOV  R0, NAVE				; 		colis�o entre o ovni 
	CALL deteta_colisao			; 			a ser analisado e a nave (resultado em R1)
	CMP  R1, SEM_COLISAO		; se n�o foi detetada colis�o
	JZ  dcs_prox_ovni			; 		passa ao pr�ximo ovni	
dcs_guarda:
	MOV  R0, R2					; R0 com o deslocamento 
	SHL  R0, 1					;		em rela��o � base da tabela
	MOV  R5, [R3+R0]			; se a colis�o
	CMP  R5, R1					;		j� foi antes detetada
	JZ  dcs_prox_ovni			; 			passa ao pr�ximo ovni
	MOV  [R3+R0], R1			; para guardar o resultado
dcs_prox_ovni:	
	ADD  R2, 1					; pr�ximo ovni
	CMP  R2, NUM_MAX_OVNI
	JNZ  dcs_ciclo

	POP  R5						; rep�e registos utilizados	
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET
 	
	
; **********************************************************************
; *
; * rotina:		deteta_colisao
; * Descri��o: 	Verifica se existe colis�o entre duas figuras no ecr� 
; *			   
; * Par�metros de entrada
; *				R0 - objeto que se pretende testar se provocou colis�o 
; * 				missil - 0
; *					nave - qualquer outro valor
; *				R1 - ovni a testar
; * Par�metros de sa�da
; *				R1 - tipo de colis�o 
; * 				0 - sem colisao 
; *					1 - colis�o nave com nave
; * 				2 - colis�o nave com meterorito, 
; *					3 - colis�o missil com nave 
; * 				4 - colis�o missil com meteorito
; *
; **********************************************************************
deteta_colisao:	
	PUSH R2						; preserva registos a utilizar
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	PUSH R9
	PUSH R10
	PUSH R11
	PUSH R0
	
	MOV  R2, R1					; com o n�mero do ovni
	SHL  R2, 1					;		ir buscar para R8 
	MOV  R3, tipo_ovnis			;			o tipo de ovni a partir
	MOV  R8, [R3+R2]			;				 da tabela de tipo de ovnis
			
								; obter as coordenadas dos cantos superiores esquedos e inferiores direitos das duas figuras
								; OVNI
	MOV  R0, R1	
	CALL ovni_num2cfg			; obter (em R0) o endere�o da configura��o do ovni 
	CALL rd_cfg_obj				; ler configura��o: R1/R2 - linha/coluna do ecr�, R3 - n� de ecr�, R6/R5 - n� de linhas/colunas da figura, R7 - endere�o de mem�ria da figura	
	MOV  R9, R1					; R9 e R10 com a linha e coluna 
	MOV  R10, R2				; 		do canto superior esquerdo do ovni	
	ADD  R1, R6					; R1 com o valor da linha do ecr� correspondente ao  
	SUB  R1, 1					; 		canto inferior direito (canto superior esquerdo + n�mero de linhas da figura - 1)
	ADD  R2, R5					; R2 com o valor da coluna do ecr� correspondente ao  	SUB  R2, 1					; 		canto inferior direito (canto superior esquerdo + n�mero de colunas da figura - 1)
	MOV  R11, R1				; R11 e R4 com a linha e coluna 
	MOV  R4, R2					; 		do canto inferior direito do ovni	

								; NAVE ou MISSIL
	POP  R0						; repor em R0 o objeto que provoca a colis�o (era o �ltimo valor guardado no stack)
	PUSH R0						; 		  para poder ir buscar o canto superior esquerdo e determinar a sua dimens�o (5x5 no caso da nave, 1x1 no caso do missil)
	CMP  R0, MISSIL				; verificar se � missil
	JZ 	dc_eh_missil			; caso seja, ir comparar (o missil tem dimens�o 1x1: cantos superior esquerdo e inferior direito coincidem) 
	MOV  R0, cfg_nave			; ler os valores de configura��o da nave: s� R1 e R2 interessam 
	CALL rd_cfg_obj				; 		e ficam com a linha e coluna do canto superior esquerdo da nave
	MOV  R5, R1					; R5 e R6 com os 
	MOV  R6, R2					;		valores de R1 e R2			
	MOV  R0, DIM_NAVE			; dimens�o da nave
	SUB  R0, 1					; -1 porque vai ser somado ao valor do canto superior esquerdo para obter o inferior direito
	ADD  R5, R0					; R5 e R6 com os valores de linha e coluna do 
	ADD  R6, R0					; 		canto inferior direito do objeto que pode ter provocado a colis�o
	JMP  dc_comparacoes
dc_eh_missil:	
	MOV  R2, existe_tiro
	MOV  R1, [R2]
	CMP  R1, OFF
	JZ   dc_fim

	MOV  R2, posicao_tiro		; R1 e R2 
	MOV  R1, [R2]				;		com a 
	MOV  R2, R1					; 			linha e a 
	MOV  R3, BYTE_LOW			;				coluna do tiro  
	AND  R2, R3					;					obtidos a partir da
	SHR	 R1, 8					;						variavel posi��o de tiro 	
	MOV  R5, R1					; como o tiro s� tem um pixel o canto 
	MOV  R6, R2					;		 superior esquerdo e inferior direito coincidem
dc_comparacoes:					; OVNI - R9, R10 LC canto superior esquerdo; R11, R4 LC canto inferior direito
								; NAVE ou MISSIL - R1, R2 LC canto superior esquerdo; R5, R6 LC canto inferior direito
	CMP  R9, R5				
	JGT  dc_sem_colisao			
	CMP  R11, R1
	JLT	 dc_sem_colisao
	CMP  R10, R6
	JGT  dc_sem_colisao
	CMP  R4, R2
	JLT	 dc_sem_colisao
								; existe colis�o vai devolver o tipo 
	MOV  R5, METEORITO
	CMP  R8, R5					; verifica se � meteorito
	JZ  dc_meteorito
								; colis�o com nave inimiga
	POP  R0						; repor em R0 o objeto que provoca a colis�o (era o �ltimo valor guardado no stack)
	PUSH R0						; 		  para poder ir buscar o canto superior esquerdo e determinar a sua dimens�o (5x5 no caso da nave, 1x1 no caso do missil)
	CMP  R0, MISSIL				; verificar se � missil
	JZ 	 dc_missil_x_nave
	MOV  R1, NAVE_VS_NAVE		; colis�o nave com nave
	JMP  dc_fim
dc_missil_x_nave:
	MOV  R1, MISSIL_VS_NAVE		; colis�o missil com nave	
	JMP  dc_fim
dc_meteorito:
	CMP  R0, MISSIL
	JZ 	 dc_missil_x_meteorito
	MOV  R1, NAVE_VS_METEO		; colis�o nave com meteorito
	JMP  dc_fim
dc_missil_x_meteorito:
	MOV  R1, MISSIL_VS_METEO	; colis�o missil com meteorito	
	JMP  dc_fim
dc_sem_colisao:
	MOV  R1, SEM_COLISAO
	
dc_fim:
	POP  R0						; rep�e registos utilizados
	POP  R11
	POP  R10		
	POP  R9
	POP  R8
	POP  R7
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	RET

	
; **********************************************************************
; *
; * rotina:   	trata_energia
; * Descri��o: 	Procede ao decr�scimo de energia fun��o do decurso do tempo
; *			   	marcado pelo interrupt 2
; * Par�metros de entrada
; * 			 
; * Par�metros de sa�da
; *
; **********************************************************************
trata_energia:
	PUSH R0						; preserva registos a utilizar
	PUSH R1
	PUSH R2


	MOV  R1, anima_energia		; verificar se 
	MOV  R0, [R1]				;		ocorreu o caso 
	CMP  R0, OFF				;			de ter que diminuir energia
	JZ   te_fim					; se n�o ocorreu, termina
	
	MOV  R2, MENOS_ENERGIA		; valor (-5) a retirar � energia
	MOV  R0, energia			; retirar ao valor
	MOV  R1, [R0]				; 		da energia da nave
	ADD  R1, R2					;			5% correspondentes
	MOV  [R0], R1				;				� passagem do tempo	
	
	MOV  R0, OFF				; assinalar que 
	MOV  R1, anima_energia		;		j� foi tratada a
	MOV [R1], R0				;			ocorr�ncia do interrupt	

te_fim:	
	POP  R2						; rep�e registos utilizados
	POP  R1
	POP  R0
	RET

	
; **********************************************************************
; *
; * rotina:   	atualiza_energia
; * Descri��o: 	adiciona o valor recebido em R0 ao valor da energia
; * 			(se for rpetendido diinuir passar valor negativo)
; *			   
; * Par�metros de entrada
; *				R0 - valor (positivo ou negativo) a adicionar � energia
; * Par�metros de sa�da
; *
; **********************************************************************
atualiza_energia:
	PUSH R0						; preserva registos a utilizar
	PUSH R1
	PUSH R2

	MOV  R2, energia			; adicionar ao valor
	MOV  R1, [R2]				; 		da energia da nave
	ADD  R1, R0					;			o valor recebido
	MOV  [R2], R1				;				 como par�metro em R0
	
	POP  R2						; rep�e registos utilizados
	POP  R1
	POP  R0
	RET

	
; **********************************************************************
; *
; * rotina:   	rot_int_0
; * Descri��o: 	Rotina de atendimento da interrup��o 0 
; *			    Assinala a necessidade de refrescamento dos ovnis
; *			   
; * Par�metros de entrada
; *			
; * Par�metros de sa�da
; *
; **********************************************************************
rot_int_0:
	PUSH R0						; preserva registos a utilizar
	PUSH R1
	
	MOV  R0, anima_ovnis		; ativa a flag 
	MOV  R1, ON					;		correspondente 
	MOV  [R0], R1				;			a este interrupt 	
	
	POP  R1						; rep�e registos utilizados
	POP	 R0
    RFE                     

	
; **********************************************************************
; *
; * rotina:   	rot_int_1
; * Descri��o: 	Rotina de atendimento da interrup��o 1 
; *			    Assinala a necessidade de refrescamento do tiro
; *				Tamb�m faz a contagem que suporta a gera��o de aleat�rios
; *			   
; * Par�metros de entrada
; *			
; * Par�metros de sa�da
; *
; **********************************************************************	
rot_int_1:
	PUSH R0						; preserva registos a utilizar
	PUSH R1
	
	MOV  R0, anima_tiro			; ativa a flag 
	MOV  R1, ON					;		correspondente 
	MOV  [R0], R1				;			a este interrupt 	
	
	POP  R1						; rep�e registos utilizados
	POP	 R0
    RFE                     


; **********************************************************************
; *
; * rotina:   	rot_int_2
; * Descri��o: 	Rotina de atendimento da interrup��o 2 
; *			    Diminui a energia da nave em fun��o da passagem do tempo
; *			   
; * Par�metros de entrada
; *			
; * Par�metros de sa�da
; *
; **********************************************************************		
rot_int_2:
	PUSH R0						; preserva registos a utilizar
	PUSH R1

	MOV  R0, primeira_vez		; se j� n�o � o
	MOV  R1, [R0]				; 		primeiro pedido 
	CMP  R1, ON					; 			de interrupt ent�o
	JNZ  ri2_inicio				;				executa as a��es do pedido
	MOV  R1, OFF				; se � a primeira vez
	MOV  [R0], R1				; 		assinala que j� 
	JMP  ri2_fim				; 			ocorreu e n�o faz nada
ri2_inicio:
	
	MOV  R0, anima_energia		; ativa a flag 
	MOV  R1, ON					;		correspondente 
	MOV  [R0], R1				;			a este interrupt 

ri2_fim:	
	POP  R1						; rep�e registos utilizados
	POP	 R0
    RFE                     

	
; **********************************************************************
; *
; * rotina:   	inicializacoes
; * Descri��o: 	Coloca os valores iniciais nas vari�veis em que isso � 
; *				necess�rio de modo a poder suportar o in�cio/rein�cio 
; *				do jogo
; *			   
; * Par�metros de entrada
; *				
; * Par�metros de sa�da
; *
; **********************************************************************
inicializacoes:
	PUSH R0						; preserva registos a utilizar
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	
	MOV  R1, ENERGIA
	MOV  R0, energia
	MOV  [R0], R1
	MOV  R1, ESPERA
	MOV  R0, estado_jogo
	MOV  [R0], R1	
	MOV  R1, ESPERA_TECLA
	MOV  R0, estado_teclado
	MOV  [R0], R1	
	MOV  R1, NAO_HA_TIRO
	MOV  R0, estado_tiro
	MOV  [R0], R1
	MOV  R1, DIREITA
	MOV  R0, sentido_nave
	MOV  [R0], R1	
	MOV  R1, ON
	MOV  R0, primeira_vez
	MOV  [R0], R1	
	
	MOV  R1, 0
	MOV  R0, existe_tiro
	MOV  [R0], R1
	MOV  R0, posicao_tiro
	MOV  [R0], R1
	MOV  R0, anima_ovnis
	MOV  [R0], R1
	MOV  R0, anima_tiro
	MOV  [R0], R1	
	MOV  R0, anima_energia
	MOV  [R0], R1	
	MOV  R0, tecla_premida
	MOV  [R0], R1	
	MOV  R0, tecla_0
	MOV  [R0], R1	
	MOV  R0, tecla_1
	MOV  [R0], R1	
	MOV  R0, tecla_2
	MOV  [R0], R1	
	MOV  R0, tecla_C
	MOV  [R0], R1	
	MOV  R0, tecla_D
	MOV  [R0], R1	
	MOV  R0, tecla_E
	MOV  [R0], R1	

	MOV  R4, cfg_nave
	MOV  R1, POS_NAVE_INI
	MOV  [R4], R1

	MOV  R1, POS_OVNI_INI
	MOV  R2, DIM_OVNI_INI
	MOV  R4, cfg_ovnis

	MOV  R7, tab_ovni2
	MOV  R5, 0
	MOV  R3, 1
i_ciclo1:	
	MOV  [R4+R5], R1
	ADD  R5, 2
	MOV  R6, R3
	SHL  R6, 8
	OR   R6, R2
	MOV  [R4+R5], R6	
	ADD  R5, 2
	MOV  [R4+R5], R7	
	ADD  R5, 2
	ADD  R3, 1
	CMP  R3, NUM_MAX_OVNI
	JLE  i_ciclo1
	MOV  R7, tab_ovni1
	SUB  R5, 2
	MOV  [R4+R5], R7						

	MOV  R4, colisao_ovnis
	MOV  R1, SEM_COLISAO	
	MOV  R5, 0
	MOV  R3, 1	
i_ciclo2:	
	MOV  [R4+R5], R1
	ADD  R5, 2
	ADD  R3, 1
	CMP  R3, NUM_MAX_OVNI
	JLE  i_ciclo2
	
	MOV  R4, tipo_ovnis
	MOV  R1, NAVE_INIMIGA	
	MOV  R5, 0
	MOV  R3, 1	
i_ciclo3:	
	MOV  [R4+R5], R1
	ADD  R5, 2
	ADD  R3, 1
	CMP  R3, NUM_MAX_OVNI
	JLE  i_ciclo3
	MOV  R1, METEORITO	
	SUB  R5, 2	
	MOV  [R4+R5], R1	

	MOV  R4, cont_mov_ovnis
	MOV  R1, 0	
	MOV  R5, 0
	MOV  R3, 1	
i_ciclo4:	
	MOV  [R4+R5], R1
	ADD  R5, 2
	ADD  R3, 1
	CMP  R3, NUM_MAX_OVNI
	JLE  i_ciclo4
	
	MOV  R4, cont_mov_ovnis
	MOV  R1, GERAR_OVNI	
	MOV  R5, 0
	MOV  R3, 1	
i_ciclo5:	
	MOV  [R4+R5], R1
	ADD  R5, 2
	ADD  R3, 1
	CMP  R3, NUM_MAX_OVNI
	JLE  i_ciclo5

	MOV  R4, estado_ovnis
	MOV  R1, NAO_HA_OVNI	
	MOV  R5, 0
	MOV  R3, 1	
i_ciclo6:	
	MOV  [R4+R5], R1
	ADD  R5, 2
	ADD  R3, 1
	CMP  R3, NUM_MAX_OVNI
	JLE  i_ciclo6

	POP  R7						; rep�e registos utilizados
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET	
