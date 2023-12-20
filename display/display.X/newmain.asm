;*******************************************************************************
; UFSC- Universidade Federal de Santa Catarina
; Aluna: Alice Motin
; Matrícula: 22201175
; Contador
;*******************************************************************************
	
; Incluindo o arquivo de definições específicas para o 16F877A
#include <P16F877A.inc>

; Configuração dos bits de configuração do microcontrolador
__CONFIG   _CP_OFF & _WDT_OFF & _PWRTE_ON & _XT_OSC

; Define os bits para incrementar e decrementar
#DEFINE		incrementa	PORTC,0
#DEFINE		decrementa	PORTC,1

; Configuração de portas
org 0x000 			; Origem do código

; Configuração do banco de registros
bsf STATUS,RP0 			; Muda para o banco 1	
bcf STATUS,RP1

; Configuração dos registradores de controle de portas
movlw b'00000011' 		
movwf TRISC
movlw b'00000000'	
movwf TRISB
movlw b'00000000'		
movwf TRISD

; Retorna para o banco de registros 0
bcf STATUS,RP0
bcf STATUS,RP1	

; Inicialização dos registradores PORTB e PORTD
movlw 0x00	
movwf PORTB
movlw 0x00
movwf PORTD

main
; Verifica se o bit de incremento está setado
	BTFSS incrementa	
	call incrementar	
			 
; Verifica se o bit de decremento está setado
	BTFSS decrementa
	call decrementar	

; Retorna ao loop principal
	goto main			
			
incrementar
; Chama a função de atraso
	call atraso 

; Adiciona um valor a PORTB
	movf PORTB, W
	addlw d'247'
; Verifica se o resultado é zero
	BTFSC STATUS, Z
; Chama a função de incremento na segunda porta
	call incrementarD

; Incrementa PORTB
	movf PORTB, W 
	addlw b'01'	
	movwf PORTB
return

decrementar
; Chama a função de atraso
	call atraso
	
; Subtrai um valor de PORTB
	movf PORTB, W
	addlw 0x00
; Verifica se o resultado é zero
	BTFSC STATUS, Z
; Chama a função de decremento na segunda porta
	call decrementarD

; Decrementa PORTB
	movf PORTB, W
	addlw d'255'  
	movwf PORTB
return

incrementarD
; Chama a função de atraso
	call atraso
; Zera PORTB
	movlw 0x00 
	movwf PORTB

; Adiciona um valor a PORTD
	movf PORTD, W
	addlw d'247'
; Verifica se o resultado é zero
	BTFSC STATUS, Z
; Chama a função de zerar na primeira porta
	call zerarA

; Incrementa PORTD
	movf PORTD, W
	addlw b'01'
	movwf PORTD
goto main

zerarA
; Chama a função de atraso
	call atraso
; Zera PORTB e PORTD
	movlw 0x00
	movwf PORTB
	movlw d'255'
	movwf PORTD
return

decrementarD
; Chama a função de atraso
	call atraso
; Configura PORTB para um valor específico
	movlw b'1001' 
	movwf PORTB	

; Subtrai um valor de PORTD
	movf PORTD, W
	addlw 0x00
; Verifica se o resultado é zero
	BTFSC STATUS, Z
; Chama a função de zerar na segunda porta
	call zerarB

; Decrementa PORTD
	movf PORTD, W
	addlw d'255'  
	movwf PORTD
goto main

zerarB
; Chama a função de atraso
	call atraso
; Configura PORTB e PORTD para valores específicos
	movlw b'1001'
	movwf PORTB
	movlw b'1010'
	movwf PORTD
return

atraso
; Configura um valor de atraso
	movlw d'200'
	movwf 0x0C

aux1:
	movlw d'250'
	movwf 0x0D

aux2:
	nop			

	; Loop de atraso
	decfsz 0x0D
	goto aux2
	decfsz 0x0C
	goto aux1

return

END


