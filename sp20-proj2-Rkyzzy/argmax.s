.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 is the pointer to the start of the vector
#	a1 is the # of elements in the vector
# Returns:
#	a0 is the first index of the largest element
# =================================================================
argmax:

    # Prologue
	add t3, x0, x0# initialize the counter
	add t0,x0, x0
	add t4,x0, x0# initialize the current max value
	addi sp, sp, -12
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	mv s0, a0
	mv s1, a1
	lw t4, 0(s0)
	li a0, 0
	
loop_start:
	addi s1, s1, -1
	slli t0, t3, 2
	add t1, t0, s0
	lw t2, 0(t1)
    bge t4, t2, loop_continue
	mv t4, t2
	mv a0, t3

loop_continue:
	addi t3, t3, 1
	beq s1, x0, loop_end
	jal x0, loop_start

loop_end:
    lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	addi sp, sp, 12
    # Epilogue


    ret
