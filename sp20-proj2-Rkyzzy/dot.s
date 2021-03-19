.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 is the pointer to the start of v0
#   a1 is the pointer to the start of v1
#   a2 is the length of the vectors
#   a3 is the stride of v0
#   a4 is the stride of v1
# Returns:
#   a0 is the dot product of v0 and v1
# =======================================================
dot:
	add t3, x0, x0 #initialize the counter
	add t0, x0, x0 #tempvariable to store array0's value
	add t1, x0, x0 #tempvariable to store array1's value
	add t2, x0, x0 #common offset
	add t4, x0, x0 #array0's offset
	add t5, x0, x0 #array1's offset
	add t6, x0, x0
    # Prologue
	addi sp, sp, -24
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	sw s4, 20(sp)
	mv s0, a0
	mv s1, a1
	mv s2, a2
	mv s3, a3
	mv s4, a4
	li a0, 0

loop_start:
	beq t3, s2, loop_end
	#addi s2, s2, -1
	slli t2, t3, 2
	mul t4, t2, s3
	mul t5, t2, s4
	add t4, t4, s0
	add t5, t5, s1
	lw t0, 0(t4)
	lw t1, 0(t5)
	mul t6, t0, t1
	add a0, a0, t6
	addi t3, t3, 1
	#beq s2, x0, loop_end
	jal x0, loop_start


loop_end:


    # Epilogue
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw s3, 16(sp)
	lw s4, 20(sp)
    addi sp, sp, 24
	
    ret
