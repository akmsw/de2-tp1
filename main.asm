;UNC - FCEFyN
;ELECTRÓNICA DIGITAL II
;Trabajo práctico I
;
;Apellido, nombre: Bonino, Francisco Ignacio
;Matrícula: 41279796
;Carrera: Ingeniería en Computación

list P = 16F887

#include <P16F887.inc>

; CONFIG1
; __config 0x3FF1
  __CONFIG _CONFIG1, _FOSC_XT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_ON
; CONFIG2
; __config 0x3FFF
  __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF

     num1 equ 0x20 ; Primer número (parte menos significativa, puerto D).
     num2 equ 0x21 ; Segundo número (parte más significativa, puerto D).
    iter1 equ 0x22 ; Iteradores.
    iter2 equ 0x23
    iter3 equ 0x24

org 0x00      ;Posiciono al PC en 0x00

banksel TRISD ; Voy al banco de memoria donde está TRISD.

clrf TRISD    ; Limpio TRISD (queda con ceros).
comf TRISD,1  ; Complemento TRISD (queda con unos) para que PORTD quede seteado como entrada.

clrf TRISC    ; Limpio TRISC (queda con ceros) para que PORTC quede seteado como salida.

banksel PORTD ; Vuelvo al banco donde tengo PORTD (y también PORTC).

Sumar	movf PORTD,0   ; Guardo en 'W' lo que hay en PORTD.
	andlw 0x0F     ; Hago AND con 0x0F y lo guardo en 'W' para rescatar el nibble menos significativo y guardarlo en 'num1'.
	movwf num1
	movf PORTD,0   ; Guardo nuevamente en 'W' lo que hay en PORTD.
	andlw 0xF0     ; Hago AND con 0xF0 y lo guardo en 'W' para rescatar el nibble más significativo y guardarlo en 'num2'.
	movwf num2
	swapf num2,1   ; Cambio los nibbles de 'num2'.
	movf num1,0    ; Guardo en 'W' lo que hay en 'num1'.
	addwf num2,0   ; Sumo 'W' con 'num2' y guardo el resultado en 'W'.
	movwf PORTC    ; Pongo en PORTC lo que hay en 'W'.
	btfss STATUS,1 ; Chequeo DC (carry de nibble):
	goto Sumar     ; Si es '0' (no hubo carry de nibble), puedo seguir operando;
	goto Parpadeo  ; si es '1' (hubo carry de nibble), detengo el programa haciendo que

Retardo movlw .10		 ; El bucle exterior se repetirá 10 veces.
	movwf iter1		 ; Almaceno en 'iter1' cuántas veces se repetirá este bucle.
	Bucle1
	    movlw .131	         ; El bucle medio se repetirá 131 veces.
	    movwf iter2          ; Almaceno en 'iter2' cuántas veces se repetirá este bucle.
	    Bucle2
	        movlw .255	 ; El bucle interno se repetirá 255 veces.
	        movwf iter3	 ; Almaceno en 'iter2' cuántas veces se repetirá este bucle.
	        Bucle3
		    decfsz iter3 ; Decremento de a 1 'iter3' hasta que sea cero.
		    goto Bucle3
	    decfsz iter2	 ; Decremento de a 1 'iter2' hasta que sea cero.
	    goto Bucle2
	decfsz iter1	         ; Decremento de a 1 'iter1' hasta que sea cero.
	goto Bucle1
	return		         ; Regreso a donde me invocaron.

Parpadeo   bsf PORTC,5   ; Seteo en '1' el bit 5 de PORTC para encender el LED.
	   call Retardo  ; Espero un segundo.
	   bcf PORTC,5   ; Seteo en '0' el bit 5 del PORTC para apagar el LED.
	   call Retardo  ; Espero un segundo.
	   goto Parpadeo ; Vuelvo a ejecutar la instrucción indefinidamente.

end
