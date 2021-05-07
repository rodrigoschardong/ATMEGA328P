;
; Interrupts.asm
;
; Created: 05/05/2021 21:22:43
; Author : Rodrigo
;
; https://portal.vidadesilicio.com.br/pcint-interrupcoes-por-mudanca-de-estado/
; https://www.avrfreaks.net/forum/pin-change-interrupt-tutorial


.cseg
.org 0x0000
	jmp start					; 0x0000 Reset
	jmp	irq0 					; 0x0002 IRQ0
	;jmp irq1
.org 0x0008
	jmp pcint

.org INT_VECTORS_SIZE

; Replace with your application code
start:
	sbi DDRD, 7 ;Led as out

	ldi r20, 1; Status blink led On

	;Disable Interrupts and configure stack pointer for 328p
	cli
	ldi r16, low(RAMEND) // RAMEND address 0x08ff
	out SPL, r16 //Stack Pointer low SPL at i/o address 0x3d
	ldi r16, high(RAMEND)
	out SPH, r16 //Stack Pointer High SPH at i/o adress 0x3e

	;Setting button interrupt (int0)
    cbi DDRD, 2 ;Button on d2 (in)
	
	ldi r19, (3<<int0) ; Falling Border Interrupt
	sts EICRA, r19
	ldi r19, (1 << int0) 
	out EIMSK, r19

	;Setting button interrupt (pcint1)
	cbi DDRC, 5 ;Button on c5
	;ldi r21, (0x01 << 5); Value of PINC when D5 is pressed 
	ldi r19 ,(1 << PCIE1) 
	sts PCICR, r19
	ldi r19, (1<<PCINT1)
	sts PCMSK1, r19

	sei
	ldi r19, 80 ; Setting Led Delay
loop:
	cpi r20, 1 ;check if status blink led is on
	breq blink
	cbi PORTD, 7 ;turn down led
	jmp loop
blink:
	sbi PORTD, 7 ; turn on led
	mov r18, r19
	rcall delay_05
	cbi PORTD, 7 ;turn down led
	mov r18, r19
	rcall delay_05
	jmp loop

;Subroutine to blink led
delay_05:
	;Saving return address
	push r15 
	in r15, SREG
	push r16

	;ldi r18, 40
loop1:
  	ldi R24, low(3037)
  	ldi R25, high(3037)
delay_loop:
  	adiw R24, 1
  	brne delay_loop
  	dec R18
  	brne loop1

	;End Sub Routine
	pop r16
	out SREG, r15
	pop r15
  	ret

pcint:
	cpi r19, 80
	brne check_1hz
	ldi r19, 40
	jmp end_change_frequency
check_1hz:
	cpi r19, 40
	brne check_2hz
	ldi r19, 20
	jmp end_change_frequency
check_2hz:
	cpi r19, 20
	brne check_4hz
	ldi r19, 10
	jmp end_change_frequency
check_4hz:
	;Its an else
	ldi r19, 80

end_change_frequency:
	reti	

irq0:
	;sbi DDRD, 7 ;acende o led
	;cbi PORTB, 5 ;acende o led da placa
	neg r20 ;Change Status Blink Led
	reti



