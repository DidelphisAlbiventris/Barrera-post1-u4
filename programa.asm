; programa.asm - Laboratorio Post1 Unidad 4
; Proposito: demostrar directivas de seccion, datos y constantes en NASM (obj, 16 bits)

; --- Constantes (EQU, no reservan memoria) ---
CR           EQU 0Dh          ; Carriage Return
LF           EQU 0Ah          ; Line Feed
TERMINADOR   EQU 24h          ; "$" terminador de cadena para DOS
ITERACIONES  EQU 5            ; repeticiones del bucle
ANCHO_LINEA  EQU 40           ; ancho de la linea decorativa

; --- Datos inicializados ---
segment data class=DATA
    bienvenida  db "=== Laboratorio NASM - Unidad 4 ===", CR, LF, TERMINADOR
    separador   db "----------------------------------------", CR, LF, TERMINADOR
    etiqueta_a  db "Variable A (word):  ", TERMINADOR
    etiqueta_b  db "Variable B (dword): ", TERMINADOR
    fin_msg     db "Programa finalizado correctamente.", CR, LF, TERMINADOR

    var_byte    db 42
    var_word    dw 1234h
    var_dword   dd 0DEADBEEFh
    tabla_bytes db 10, 20, 30, 40, 50

linea_gruesa:
    times ANCHO_LINEA db '='  ; repetido en tiempo de ensamblado
    db CR, LF, TERMINADOR

; --- Datos no inicializados ---
segment bss class=BSS
    buffer      resb 80
    resultado   resw 1

; --- Pila ---
segment stack class=STACK stack
    resb 256

; --- Codigo ejecutable ---
segment code class=CODE
..start:
    mov  ax, data            ; segmento de datos
    mov  ds, ax              ; DS apunta a los datos

    mov  ah, 09h
    mov  dx, bienvenida
    int  21h

    mov  dx, separador
    int  21h

    mov  dx, etiqueta_a
    int  21h

    ; Funcion 02h: imprimir un caracter
    mov  al, [var_byte]
    add  al, 30h
    mov  ah, 02h
    mov  dl, al
    int  21h

    mov  ah, 02h
    mov  dl, CR
    int  21h
    mov  dl, LF
    int  21h

    ; Recorrer la tabla de bytes
    lea  si, [tabla_bytes]
    mov  cx, ITERACIONES

imprimir_tabla:
    mov  al, [si]
    add  al, 30h
    mov  ah, 02h
    mov  dl, al
    int  21h

    mov  ah, 02h
    mov  dl, 20h             ; espacio
    int  21h

    inc  si
    loop imprimir_tabla

    mov  ah, 02h
    mov  dl, CR
    int  21h
    mov  dl, LF
    int  21h

    ; Mensaje final
    mov  ah, 09h
    mov  dx, fin_msg
    int  21h

    ; Linea decorativa generada con TIMES
    mov  dx, linea_gruesa
    int  21h

    ; Terminar
    mov  ax, 4C00h
    int  21h