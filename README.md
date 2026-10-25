# Barrera-post1-u4
## Descripción
Laboratorio de la Unidad 4: programa NASM con segmentos y salida DOS (Parte 1) y
macros con control de flujo (Parte 2).

**##Parte 1**
## Decisiones técnicas (Parte 1)

### Decisión 1: EQU frente a %define para ANCHO_LINEA

Para la constante ANCHO_LINEA se eligió EQU. EQU define un símbolo numérico que el ensamblador propiamente dicho resuelve y verifica: su valor se calcula una sola 
vez y, si se intenta definir de nuevo el mismo símbolo, NASM reporta un error de redefinición. En cambio, %define es una sustitución de texto que el preprocesador 
realiza antes de que NASM ensamble una sola instrucción; no evalúa nada, solo reemplaza el nombre por los caracteres definidos, y una nueva definición simplemente 
sobrescribe la anterior. Eso genera ambigüedades: si se escribiera %define ANCHO_LINEA 20+20 y luego se usara ANCHO_LINEA*2, el resultado sería 20+20*2 = 60 y no 
80, porque el texto se sustituye sin paréntesis. Como ANCHO_LINEA se usa como argumento numérico de TIMES y podría usarse en comparaciones aritméticas, EQU evita 
mejor estos errores de sustitución mal formada. Aun así, %define sí es preferible cuando lo que se reutiliza no es un valor numérico sino un fragmento literal de 
texto o de código, por ejemplo %define IMPRIMIR_CADENA mov ah, 09h, o un alias de registro como %define CONTADOR cx, algo que EQU no puede representar.

