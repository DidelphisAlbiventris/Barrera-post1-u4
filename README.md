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

### Chechkpoint 3 Decisión 2: TIMES en data frente a RESB con relleno en tiempo de ejecución

Para la línea decorativa se usó TIMES ANCHO_LINEA DB '=' en el segmento de datos. Frente a escribir manualmente los 40 signos dentro del literal DB, cambiar el 
ancho solo requiere modificar un número, mientras que el literal obliga a contar y editar caracteres a mano, con riesgo de dejar la línea más corta o más larga de 
lo previsto. La alternativa de reservar 40 bytes con RESB en el segmento bss y llenarlos con un bucle LOOP al inicio de main sería válida en principio, pero 
innecesaria aquí: el contenido de la línea nunca cambia entre ejecuciones, así que construirla en tiempo de ejecución repite siempre el mismo trabajo. Con TIMES, 
los 40 bytes ya forman parte de la imagen del ejecutable que DOS carga en memoria, de modo que el arranque no ejecuta ninguna instrucción para producirlos. Con 
RESB habría que inicializar CX, un puntero y el carácter, y ejecutar 40 iteraciones del bucle cada vez que se corre el programa. El costo de TIMES es que el .exe 
ocupa 40 bytes más en disco, algo despreciable frente a evitar esas instrucciones.

**##Parte 2**
## Decisiones técnicas (Parte 2)

### Chechkpoint Decisión 1: %rep frente a LOOP para un número de repeticiones fijo

Para imprimir el separador corto tres veces, %rep es una alternativa razonable a repetir_str. Como el número de copias se conoce al escribir el programa, el 
preprocesador puede duplicar el código antes de ensamblar y el programa no necesita contador ni salto en tiempo de ejecución. El costo es tamaño: cada expansión 
de print_str ocupa unos 9 bytes de código máquina (PUSH, dos MOV, INT y POP), de modo que tres copias suman unos 27 bytes, un precio mínimo. Con 1000 copias 
serían unos 9000 bytes de código, mientras que repetir_str ocupa unos 12 bytes sin importar cuántas veces se repita. Por eso repetir_str sigue siendo la opción 
correcta cuando el número de repeticiones se lee en tiempo de ejecución, por ejemplo con leer_char: %rep necesita una constante conocida al ensamblar, y un valor 
tecleado solo existe cuando el programa corre, así que hace falta un bucle real. El código expandido de repetir_str contiene la carga de CX y la instrucción LOOP; 
el de bloque_decorativo no contiene ninguna de las dos, y esa ausencia es precisamente el costo cero en tiempo de ejecución de %rep.

### Chechkpoint Decisión 2: ¿necesitan etiquetas locales %% las extensiones de los Pasos 7 y 8?

La macro bloque_decorativo no necesita ninguna etiqueta, ni %% ni de otro tipo, porque su cuerpo es código lineal: solo repite expansiones de print_str, sin 
saltos ni destinos de salto. Al no definir símbolos, no hay nada que pueda repetirse entre una invocación y otra. Si se modificara para que un salto condicional 
omitiera la última copia, el salto necesitaría una etiqueta destino dentro del cuerpo de la macro. Esa etiqueta se definiría de nuevo en cada invocación, NASM 
reportaría un símbolo duplicado, y por eso pasaría a necesitar %%, que genera un nombre único por expansión. Las etiquetas con punto de comparar_menor_o_igual 
(.menor_o_igual y .fin_cmp2) son suficientes porque en NASM pertenecen a la etiqueta no local anterior, es decir, el nombre completo es 
comparar_menor_o_igual.menor_o_igual, distinto de comparar_e_imprimir.son_iguales. Además, un procedimiento se define una sola vez y no se expande en cada 
llamada, de modo que el mecanismo %%, pensado para macros que se expanden varias veces, no es necesario.

