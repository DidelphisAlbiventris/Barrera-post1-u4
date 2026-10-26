; macros.asm - biblioteca de macros utilitarias (Laboratorio Post1 U4, Parte 2)
; Todas las macros se apoyan en la interrupcion INT 21h de DOS.

; Macro: terminar el programa DOS con codigo de salida 0
%macro fin_dos 0
    mov  ax, 4C00h
    int  21h
%endmacro

; Macro: imprimir nueva linea (CR + LF)
%macro nueva_linea 0
    mov  ah, 02h
    mov  dl, 0Dh
    int  21h
    mov  dl, 0Ah
    int  21h
%endmacro

; Macro: imprimir cadena terminada en "$"
; %1 = etiqueta de la cadena
; La funcion 09h deja AL = 24h al terminar, lo que arruinaria un print_digito
; posterior; por eso la macro preserva AX con PUSH/POP.
%macro print_str 1
    push ax
    mov  ah, 09h
    mov  dx, %1
    int  21h
    pop  ax
%endmacro

; Macro: imprimir un caracter unico
; %1 = valor ASCII del caracter (inmediato o registro de 8 bits)
%macro print_char 1
    mov  ah, 02h
    mov  dl, %1
    int  21h
%endmacro

; Macro: leer un caracter desde teclado (sin eco); el resultado queda en AL
%macro leer_char 0
    mov  ah, 07h
    int  21h
%endmacro

; Macro: imprimir una cadena N veces (bucle en tiempo de ejecucion con LOOP)
; %1 = etiqueta de la cadena a imprimir
; %2 = numero de repeticiones (inmediato numerico)
%macro repetir_str 2
    mov  cx, %2             ; CX = contador de repeticiones
%%ciclo:                    ; %% genera una etiqueta unica por expansion
    mov  ah, 09h
    mov  dx, %1
    int  21h
    loop %%ciclo            ; CX--; si CX != 0, repetir
%endmacro

; Macro: imprimir el digito decimal (0-9) almacenado en AL
%macro print_digito 0
    push ax                 ; preservar AX
    and  al, 0Fh            ; quedarse con el nibble bajo
    add  al, 30h            ; convertir a ASCII
    mov  ah, 02h
    mov  dl, al
    int  21h
    pop  ax                 ; restaurar AX
%endmacro

; Macro: imprimir un separador corto N veces, desenrollada en tiempo de ensamblado
; %1 = numero de copias (constante conocida al ensamblar)
; Requiere que exista la etiqueta separador_corto en el programa que la use.
%macro bloque_decorativo 1
    %rep %1
    print_str separador_corto   ; cada copia se expande como codigo independiente
    %endrep
%endmacro
