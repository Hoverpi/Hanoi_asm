####### C Code #######
# #include <stdio.h>
 
# // C recursive function to solve tower of hanoi puzzle
# void TowerOfHanoi(int n, char from_rod, char to_rod, char aux_rod) {
#     if (n == 0) return;
#     towerOfHanoi(n-1, from_rod, aux_rod, to_rod);
#     printf("Move disk %d from rod %c to rod %c\n", n, from_rod, to_rod);
#     TowerOfHanoi(n-1, aux_rod, to_rod, from_rod);
# }
 
# int main() {
#     int N = 3; // Number of disks
#     TowerOfHanoi(n, 'A', 'C', 'B');  // A, B and C are names of rods
#     return 0;
# }
####### C Code #######

.text
main:		addi s0, zero, 15			# N = 3
			
			lui  s1, 0x10010
			addi s1, s1, 0			    # Torre A = 0x10010000
			addi s2, s1, 4			    # Torre B = 0x10010004
			addi s3, s2, 4			    # Torre C = 0x10010008
			
			# Move B and C pointer to the start of stack
			slli t0, s0, 5		        # start = N << 5
			add  s2, s2, t0			    # Direccion en memoria de B			
			add  s3, s3, t0				# Direccion en memoria de C

			# Desplazamiento inicial en bytes
			addi t2, zero, 0x00			# Desplazamiento inicial
			
			addi s10, zero, 0			# Counter
			addi s11, zero, 0x20
			
			addi t0, zero, 0			# i = 0
			addi t1, s0, -1				# n = N - 1
			
			addi t5, zero, 0
			
for:		beq s0, t0, hanoi			# Si i == N, salir

			addi t1, t0, 1				# a = i + 1
			# Calcular la dirección personalizada para almacenar el dato
			add t2, zero, s1			# t3 = dirección de almacenamiento
			add t4, t2, t5 
			
			sw t1, 0(t4)				# Guardar t1 en la dirección calculada
				
			addi t5, t5, 0x20			# count += 0x20
			addi t0, t0, 1				# Incrementar i
			j for						# Volver al inicio del bucle
		
end_for:    jal  ra, hanoi
	    	j    exit
		
hanoi:	    addi t0, zero, 1
	if:	   	bne s0, t0, else            # Si s0 != 1, ir a else
	    	sw zero, 0x0(s1)            # Borrar disco de SRC
	    	addi s1, s1, 0x20           # Mover SRC -> SRC + OFFSET
	    	addi s3, s3, -0x20          # Mover DST -> DST - OFFSET
	    	sw s0, 0(s3)                # Agregar disco a DST
	    	addi s10, s10, 1			# counter = counter + 1
	    	jalr ra                     # Retornar de la recursión
	    
# Guardar ra y s0 en el stack antes de la primera llamada recursiva	
else:	    addi sp, sp, -4             # Espacio en el stack
			sw ra, 0x0(sp)              # Guardar ra
			addi sp, sp, -4
			sw s0, 0x0(sp)              # Guardar s0
			addi s0, s0, -1             # n = n - 1
		
			# Intercambiar auxiliares para la llamada recursiva
			add t1, s2, zero            # AUX -> TEMP
			add s2, s3, zero            # AUX -> DST
			add s3, t1, zero            # DST -> AUX/TEMP
			
			jal ra, hanoi               # hanoi(n-1, SRC, AUX, DST)
		
			# Restaurar auxiliares para la siguiente llamada recursiva
			add t1, s2, zero            # AUX -> TEMP
			add s2, s3, zero            # AUX -> DST
			add s3, t1, zero            # DST -> AUX/TEMP
		
			# Restaurar s0 y ra después de la primera llamada recursiva
			lw s0, 0x0(sp)              # Recuperar s0
			addi sp, sp, 4
			lw ra, 0x0(sp)              # Recuperar ra
			addi sp, sp, 4
		
			sw zero, 0x0(s1)            # Borrar disco de SRC
			addi s1, s1, 0x20           # Mover SRC -> SRC + OFFSET
			addi s3, s3, -0x20          # Mover DST -> DST - OFFSET
			sw s0, 0x0(s3)              # Agregar disco a DST
			
			addi s10, s10, 1 			# n = n + 1
			
			# Guardar ra y s0 en el stack antes de la segunda llamada recursiva
			addi sp, sp, -4
			sw ra, 0x0(sp)              # Guardar ra
			addi sp, sp, -4
			sw s0, 0x0(sp)              # Guardar s0
			
			addi s0, s0, -1             # n = n - 1
		
			# Intercambiar auxiliares para la segunda llamada recursiva
			add t1, s1, zero            # TEMP -> AUX
			add s1, s2, zero            # AUX -> DST
			add s2, t1, zero            # DST -> TMP
			jal ra, hanoi               # hanoi(n-1, AUX, DST, SRC)
		
			# Restaurar auxiliares y limpiar el stack después de la segunda llamada
			add t1, s1, zero            # TEMP -> SRC
			add s1, s2, zero            # SRC -> AUX
			add s2, t1, zero            # AUX -> TEMP
			
			lw s0, 0x0(sp)              # Recuperar s0
			addi sp, sp, 4
			lw ra, 0x0(sp)              # Recuperar ra
			addi sp, sp, 4
		
			jalr ra                     # Retornar
		
exit:		j exit                      # Fin del programa
