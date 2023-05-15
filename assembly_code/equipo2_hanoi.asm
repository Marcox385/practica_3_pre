#################################################
# Practica 1: Torres de Hanoi                   #
# IS727550 - Diaz Aguayo, Adriana               #
# IS727272 - Cordero Hernandez, Marco Ricardo   #
#################################################

# Seccion del programa
.text

start:  addi s0, zero, 3		# Cantidad inicial de discos
        addi s1, zero, 1                # Registro para comparar contra caso base

        add t0, s0, zero                # Copia manipulable de discos
        
tower_a: lui a0, 0x10010                # Posicionar torre 'a' en direccion de memoria de datos
        
        lui a1, 0x10010                 # Posicionar torre 'b' en direccion de memoria de datos
        add t1, zero, s0		# Declarar iterador
tower_b: addi a1, a1, 0x4               # Desplazamiento de memoria
	addi t1, t1, -1                 # Decrementar iterador
	bge t1, s1, tower_b             # Repetir hasta obtener el desplazamiento deseado

        lui a2, 0x10010                 # Posicionar torre 'c' en direccion de memoria de datos
        add t1, zero, zero		# Restaurar iterador
tower_c: addi a2, a2, 0x8               # Desplazamiento de memoria
	addi t1, t1, 1                  # Incrementar iterador
	blt t1, s0, tower_c             # Repetir hasta obtener el desplazamiento deseado
#------------------------------------------------------------------------
# Posicionar discos en torre 'a' (escenario inicial)
disk_load: sw t0, 0(a0)                 # Copia manipulable almacena disco en torre 'a'
        addi t0, t0, -1                 # Decrementar copia manipulable para sig. disco
        addi a0, a0, 4                  # Aumentar apuntador de torre 'a' para espacio del sig. disco
        bne t0, zero, disk_load         # Iterar hasta finalizar discos
#------------------------------------------------------------------------
        jal ra, hanoi                   # Almacenar valor de retorno y comenzar funcion recursiva
        jal zero, end                   # Salto a utileria para finalizar
#------------------------------------------------------------------------
# Se inicia el proceso de movimiento de discos        
hanoi:  addi sp, sp, -4                 # Incremento de stack para direccion de retorno
        sw ra, 0(sp)                    # Guardado de valor de retorno desde stack
        
        beq s0, s1, default             # Cuando la cantidad de discos sea 1, ir a default
        
        # Hacer cambios de variables (swap) entre torres 'b' y 'c'
        addi s0, s0, -1                 # Decrementar numero de discos para iterar sobre disponibles en torre actual
        add t0, a1, zero                # Temporal pasa a ser 'b'
        add a1, a2, zero                # 'b' pasa a ser 'c'
        add a2, t0, zero                # 'c' pasa a ser 'b'

        jal ra, hanoi                   # Se retorna al comienzo de la funcion

        # Hacer cambios de variables (swap) entre torres 'c' y 'b' (regresar al orden original)
        add t0, a2, zero                # Temporal pasa a ser 'b' (por el swap anterior)
        add a2, a1, zero                # a2 que de momento es 'b' pasa a ser 'c'
        add a1, t0, zero                # a1 pasa a ser 'b' nuevamente

        addi a0, a0, -4                 # Se toma el disco que se encuentre arriba en torre 'a'
        lw t0, 0(a0)                    # Se genera la copia manipulable
        sw zero, 0(a0)                  # Se seniala que ya no se encuentra el disco en 'a'
        sw t0, 0(a2)                    # Se pasa el disco a 'c'
        addi a2, a2, 4                  # Se incrementa el apuntador de 'c'

        # Cambio (swap) de torres 'a' y 'b'
        add t0, a0, zero                # Temporal pasa a ser 'a'
        add a0, a1, zero                # a0 pasa a ser torre 'b'
        add a1, t0, zero                # a1 pasa a ser en 'a'

        addi s0, s0, -1                 # Decremento de los discos para siguiente torre
        jal ra, hanoi                   # Recursion hasta llegar a caso base

        # Swap de las torres 'b' y 'a'
        add t0, a0, zero                # Temporal pasa a ser 'b' (por swap anterior)
        add a0, a1, zero                # a1 regresa a ser torre 'a'
        add a1, t0, zero                # a2 regresa a ser torre 'b'

        lw ra, 0(sp)                    # Cargar direccion de retorno a main
        addi sp, sp, 4                  # Decrementar stack para direccion de retorno
        
        addi s0, s0, 1                  # Volver a caso base y finalizar desde ahi
        jalr zero, ra, 0                # Continuar con flujo inicial para terminar la ejecucion

#------------------------------------------------------------------------
# Caso cuando solo se tenga un disco
default: addi a0, a0, -4                # Se toma el disco que se encuentra al comienzo
        lw t0, 0(a0)                    # Leer el valor del disco y va a temporal
        sw zero, 0(a0)                  # Reemplazar el valor del disco por 0
        sw t0, 0(a2)                    # Se escribe el disco en el destino dado por el swap
        addi a2, a2, 4                  # Incrementa apuntador de referencia a la torre que se le escribio el disco
        addi s0, s0, 1                  # Aumento adicional para evitar discos := 0

        lw ra, 0(sp)                    # Poner en direccion de retorno la sig. instruccion
        addi sp, sp, 4                  # Decremento (simbolico) en stack
        jalr zero, ra, 0                # Continuar con la ejecucion de hanoi
#-------------------------------------------------------------------------              
end: 	jal zero, end			# Fin del programa
