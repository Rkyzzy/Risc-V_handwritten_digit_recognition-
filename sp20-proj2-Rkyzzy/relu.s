.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 is the pointer to the array
#	a1 is the # of elements in the array
# Returns:
#	None
# ==============================================================================
relu:
    # Prologue 2?
	add t3, x0, x0# initialize the counter
	add t0,x0,x0
	addi sp, sp, -12
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	mv s0 a0
	mv s1 a1
loop_start:#8
    addi s1, s1, -1
	slli t0, t3, 2
	addi t3, t3, 1
	add t1, t0, a0
	lw t2, 0(t1)
	bge t2, x0, loop_continue
    sw x0, 0(t1) 

loop_continue:#3
	beq s1, x0, loop_end
	jal x0 loop_start


loop_end:#2
    # Epilogue 2?
	lw ra, 0(sp)
	lw s0, 4(sp)
    lw s1, 8(sp)
	addi sp, sp, 12
	ret
