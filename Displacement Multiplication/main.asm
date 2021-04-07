;
; Multiplicacao Por Deslocamento e Adicao.asm
;
; Created: 31/03/2021 10:59:52
; Author : Rodrigo
;


; Replace with your application code
start:
	;Vars de Entradas e Saidas
    ldi R16, 195 ;  registrador x (fator 1) = 1100 0011
	ldi R17, 201 ;  registrador y (fator 2) = 1100 1001
	ldi R18, 0 ; Registrador Z (produto) parte alta 
	ldi R19, 0 ; Registrador Z (produto) parte baixa 

	;Var de Controle
	ldi r20, 8 ; Tamanho de um byte para saber quantos deslocamentos deve fazer

check_Lower_Bit_R17:
	ldi R21, 1 ; = 0000 0001
	and R21, R17;
	breq shift_Answer
;Soma
	adc R18, R16 ; Soma o fator 1 na parte alta do produto

shift_Answer:
	;Shifta a resposta
	ror r18 ; shifta pra direita a parte alta do produto
	ror r19 ; shifta pra direita a parte baixa do produto

	;Arrumar o controle
	ror R17 ; shifta pra direita o fator 2 (para validar o ultimo bit na funcao: check_Lower_Bit_R17)
	subi R20, 1 ; Diminuir quantos bits faltam para rotar do byte

	;Faz o controle
	tst r20 ; R20 and R20
	brne check_Lower_Bit_R17 ; Se R20 nao for zero (não varreu o byte (8 bits)) repete todo o processo	

end:
    rjmp end