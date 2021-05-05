;
; ReverseAlgorithm.asm
;
; Created: 15/04/2021 10:31:01
; Author : joaof & Rodrigo Schardong
;
.cseg

; Replace with your application code
start:
	;Disable Interrupts and configure stack pointer for 328p
	cli
	ldi r16, low(RAMEND) // RAMEND address 0x08ff
	out SPL, r16 //Stack Pointer low SPL at i/o address 0x3d
	ldi r16, high(RAMEND)
	out SPH, r16 //Stack Pointer High SPH at i/o adress 0x3e

	; copia dados para vetores
	rcall copia_v_z
	;chamando rotina para ordenar vetor
	ldi r26, 10
	ldi r25, high(v_z)
	ldi r24, low(v_z)
	rcall sort
	;chamando rotina para encontrar maior
	ldi r26, 10
	ldi r25, high(v_v)
	ldi r24, low(v_v)
	rcall maior
	ldi r24, 0x27
	sts v_maior, r24 ; guarda na memoria o resultado
	;chamando rotina para encontrar maior
	ldi r26, 10
	ldi r25, high(v_v)
	ldi r24, low(v_v)
	rcall menor
	sts v_menor, r24

_end:
	nop
    rjmp _end

; r25:r24 recebe o endereco do vetor (high-low)
; r26 recebe o tamanho do vetor
; a rotina ordena o vetor
sort:
;I'm not using Piles in this sub Routine, and there isn't interrupts that use piles too
	;Saving return address
	;push r15 
	;in r15, SREG
	;push r16
sort_init:
	;Sub Routine Start:
	mov zh, r25
	mov zl, r24
	ldi r19, 1 ; array index + 1
compare:
	ld r17, z+ ; Getting array[z] element
	ld r18, z  ; Getting array[z+1] element
	inc r19    ; inc array index

	cp r17, r18 ;Comparing if r17 > r18
	brmi keep_values ; if not, jmp to keep_values
	breq keep_values
	;switch values
	dec zl
	brpl z_not_neg
	dec zh
z_not_neg:
	st z+, r18
	st z, r17
	jmp sort_init
keep_values:
	cp r19, r26
	brne compare
	;End Sub Routine
	;pop r16
	;out SREG, r15
	;pop r15
	ret
; r25:r24 recebe o endereco do vetor (high-low)
; r26 recebe o tamanho do vetor
; retorna r25 igual a zero e r24 com o MAIOR valor do vetor
maior:
;I'm not using Piles in this sub Routine, and there isn't interrupts that use piles too
	;Saving return address
	;push r15 
	;in r15, SREG
	;push r16

	;Sub Routine Start:
	ldi r18, 0 ; Setting minor value in r17
	ldi r19, 0 ; Setting array index

	mov zh, r25
	mov zl, r24
bigger_compare:
	ld r17, z+ ; Getting an array element
	cp r17, r18 ;Comparing if r17 > r18
	brlo not_bigger ; if not, jmp to not_bigger
	mov r18, r17
not_bigger:
	inc r19     ; inc array index
	cp r19, r26 ; comparing array index with array lenght
	brne bigger_compare ; jmp if is not equal 
	clr r25
	mov r24, r18 ; Putting bigger value in r24
	;End Sub Routine
	;pop r16
	;out SREG, r15
	;pop r15
	ret

; r25:r24 recebe o endereco do vetor
; r26 recebe o tamanho do vetor
; retorna r25 igual a zero e r24 com o MENOR valor do vetor
menor:
	;I'm not using Piles in this sub Routine, and there isn't interrupts that use piles too
	;Saving return address
	;push r15 
	;in r15, SREG
	;push r16

	;Sub Routine Start:
	ldi r18, 0xff ; Setting bigger value in r17
	ldi r19, 0 ; Setting array index

	mov zh, r25
	mov zl, r24
lower_compare:
	ld r17, z+ ; Getting an array element
	cp r18, r17 ;Comparing if r17 < r18
	brlo not_lower ; if not, jmp to not_bigger
	mov r18, r17
not_lower:
	inc r19     ; inc array index
	cp r19, r26 ; comparing array index with array lenght
	brne lower_compare ; jmp if is not equal 
	clr r25
	mov r24, r18 ; Putting lower value in r24
	;End Sub Routine
	;pop r16
	;out SREG, r15
	;pop r15
	ret


;; simples codigo para copiar o vetor para a memoria IRAM
copia_v_z:
	ldi zh, high(__v)
	ldi zl, low(__v)
	ldi xh, high(v_v) ;; suas rotinas não devem usar os labels (so parametros)
	ldi xl, low(v_v)
	clc
	rol zl
	rol zh
	ldi r16, v_size ;; suas rotinas não devem usar v_size
loop1:
	lpm r17,z+
	st x+,r17
	dec r16
	brne loop1
	nop
	ldi zh, high(__v)
	ldi zl, low(__v)
	ldi xh, high(v_z)
	ldi xl, low(v_z)
	clc
	rol zl
	rol zh
	ldi r16, v_size
loop2:
	lpm r17,z+
	st x+,r17
	dec r16
	brne loop2
	nop
	ret

; este é um vetor de teste
; lembre-se que este valores podem mudar
; sinta-se livre para alterar e testar o seu programa
__v: 
.db 3,4,7,1,2,3,2,9,8,0,0,0
.equ v_size = 10

.dseg
v_v: ;vector 1
.byte 20
v_z: ;vector 2
.byte 20 
v_maior:
.byte 1
v_menor:
.byte 1
