;
; EntradasESaidas.asm
;
; Created: 13/04/2021 21:24:25
; Author : Rodrigo
;

; PD5 LED DA PLACA
; PD4 BOTAO
; PD7 LED 2
.org 0X00

start:
	;Ligando o led da placa
	sbi PORTB, 5	; Acende o LED 

	; Setando o botao
	sbi PORTB , 4 ; Botao na porta D4
	ldi r16, (0x01 << 4) ; Valor do PIND quando apenas a porta D4 é chamada

	;Setando o led
	cbi PORTB, 7 ; Led na porta D7

Botao_Zerado:
	in r17, PIND ; Le os pinos D
	and r17, r16 ; Compara os Pinos D com o pino especifico no R16
	brne Botao_Zerado ; Volta se não for igual

	;Botão pressionado
	cbi PORTB, 5 ; Apaga o led da placa

Botao_Pressionado:
	in r17, PIND ; Le os pinos D
	and r17, r16 ; Compara os Pinos D com o pino especifico no R16
	breq Botao_Pressionado ; Volta se for igual

	;Botao Solto

	;Delay de 0.5 segundos
loop:
	sbi PORTD, 7
	rcall delay_05
	cbi PORTD, 7
	rcall delay_05
	rjmp loop
delay_05:
	ldi R16, 20
loop1:
	ldi R24, low(3037)
	ldi R25, high(3037)
delay_loop:
	adiw R24, 1
	brne delay_loop
	dec R16
	brne loop1
	ret
