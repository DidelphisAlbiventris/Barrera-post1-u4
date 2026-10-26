; programa2.asm - Laboratorio Post1 Unidad 4, Parte 2
; Proposito: macros con parametros, bucles con LOOP y condicionales con CMP/Jcc
 
%include "macros.asm"       ; biblioteca de macros utilitarias
 
; --- Datos inicializados ---
segment data class=DATA
    titulo          db "=== Macros y Control de Flujo ===", 0Dh, 0Ah, 24h
    linea_a         db "[Linea A] Primera impresion", 0Dh, 0Ah, 24h
    linea_b         db "[Linea B] Segunda impresion", 0Dh, 0Ah, 24h
    msg_mayor       db "El valor mayor es: ", 24h
    msg_iguales     db "Los valores son iguales.", 0Dh, 0Ah, 24h
    msg_fin         db "Fin del programa.", 0Dh, 0Ah, 24h
    separador_corto db "---", 0Dh, 0Ah, 24h
    msg_menor_igual db "AX es menor o igual: ", 24h
    msg_mayor2      db "AX es mayor: ", 24h
 
; --- Datos no inicializados ---
segment bss class=BSS
    valor_a         resw 1
    valor_b         resw 1
 
; --- Pila ---
segment stack class=STACK stack
    resb 256
 
; --- Codigo ejecutable ---
segment code class=CODE
..start:
    mov  ax, data
    mov  ds, ax
 
    ; 1. Encabezado con macro
    print_str titulo
 
    ; 2. Macro repetir_str: linea_a exactamente 3 veces
    repetir_str linea_a, 3
 
    ; 3. Suma 1+2+3 = 6 con el procedimiento sumar_serie
    mov  cx, 3
    call sumar_serie        ; AX = 6
    print_str msg_mayor
    print_digito            ; imprime "6"
    nueva_linea
 
    ; 4. Comparar 9 vs 4 -> el mayor es 9
    mov  ax, 9
    mov  bx, 4
    call comparar_e_imprimir
 
    ; 5. Comparar 5 vs 5 -> iguales
    mov  ax, 5
    mov  bx, 5
    call comparar_e_imprimir
 
    ; 6. Bloque decorativo desenrollado con %rep (3 copias)
    bloque_decorativo 3
 
    ; 7. Comparacion con JLE, reutilizando las macros existentes
    mov  ax, 3
    mov  bx, 8
    call comparar_menor_o_igual
 
    ; 8. Mensaje final y terminacion
    print_str msg_fin
    fin_dos
 
; ---------------------------------------------------------------------------
; Procedimiento: suma acumulativa 1+2+...+N
; Entrada: CX = N        Salida: AX = suma total
; ---------------------------------------------------------------------------
sumar_serie:
    push cx                 ; preservar CX (LOOP lo modifica)
    xor  ax, ax             ; AX = 0 (acumulador)
.paso:
    add  ax, cx             ; AX += CX
    loop .paso              ; CX--; si CX != 0, continuar
    pop  cx                 ; restaurar CX original
    ret
 
; ---------------------------------------------------------------------------
; Procedimiento: comparar AX y BX e imprimir el mayor (decide con JE y JG)
; ---------------------------------------------------------------------------
comparar_e_imprimir:
    push ax
    push bx
 
    cmp  ax, bx             ; flags de AX - BX
    je   .son_iguales       ; AX == BX
    jg   .ax_mayor          ; AX > BX (con signo)
 
    ; Caso: BX es mayor
    print_str msg_mayor
    mov  al, bl             ; AL = valor de BX
    print_digito
    nueva_linea
    jmp  .fin_comp
 
.ax_mayor:
    print_str msg_mayor
    print_digito            ; AL contiene el valor de AX
    nueva_linea
    jmp  .fin_comp
 
.son_iguales:
    print_str msg_iguales
 
.fin_comp:
    pop  bx
    pop  ax
    ret
 
; ---------------------------------------------------------------------------
; Procedimiento: indicar si AX es menor o igual que BX, o mayor (decide con JLE)
; Reutiliza print_str, print_digito y nueva_linea de macros.asm
; ---------------------------------------------------------------------------
comparar_menor_o_igual:
    push ax
    push bx
 
    cmp  ax, bx             ; flags de AX - BX
    jle  .menor_o_igual     ; AX <= BX (con signo)
 
    print_str msg_mayor2
    print_digito
    jmp  .fin_cmp2
 
.menor_o_igual:
    print_str msg_menor_igual
    print_digito
 
.fin_cmp2:
    nueva_linea
    pop  bx
    pop  ax
    ret
 