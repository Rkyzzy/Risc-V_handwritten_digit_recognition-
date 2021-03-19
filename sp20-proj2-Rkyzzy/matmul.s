.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   If the dimensions don't match, exit with exit code 2
# Arguments:
# 	a0 is the pointer to the start of m0
#	a1 is the # of rows (height) of m0
#	a2 is the # of columns (width) of m0
#	a3 is the pointer to the start of m1
# 	a4 is the # of rows (height) of m1
#	a5 is the # of columns (width) of m1
#	a6 is the pointer to the the start of d
# Returns:
#	None, sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error if mismatched dimensions
	bne a2, a4, mismatched_dimensions

    # Prologue
	addi sp, sp, -32
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	sw s4, 20(sp)
	sw s5, 24(sp)
	sw s6, 28(sp)
	mv s0, a0
	mv s1, a1
	mv s2, a2
	mv s3, a3
	mv s4, a4
	mv s5, a5
	mv s6, a6
	
	#the # of elements don't need to be changed since it is already stored in a2
	#stride of matrix1 is always the value of s5

	add t0, x0, x0#count the rows of matrix0
	add t1, x0, x0#count the column of matrix1
	slli t3, s2, 2#switching a row takes t3 effort
	
outer_loop_start:#rows of matrix0
	beq t0, s1, outer_loop_end
	mul t2, t0, t3#represent the row offset
	add a0, t2, s0#getting the current location for the m0 pointer
	#addi t0, t0, 1
	addi a3, x0, 1#stride of matrix0 is always 1 
	mv a2, s2
inner_loop_start:
	slli t4, t1, 2
	add t4, t4, s3
	mv a1, t4#setting a1 to be the m1 pointer
	add a4, x0, s5
	
	#prologue
	addi sp, sp, -52
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw a0, 8(sp)
    sw a1, 12(sp)
    sw a2, 16(sp)
    sw a3, 20(sp)
    sw a4, 24(sp)
    sw a5, 28(sp)
    sw a6, 32(sp)
	sw s5, 36(sp)
	sw s6, 40(sp)
	sw t3, 44(sp)
	sw t2, 48(sp)
	
	#call the dot function
	jal ra dot
	
	#epilogue
	mv t4, a0
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw a0, 8(sp)
    lw a1, 12(sp)
    lw a2, 16(sp)
    lw a3, 20(sp)
    lw a4, 24(sp)
    lw a5, 28(sp)
    lw a6, 32(sp)
	lw s5, 36(sp)
	lw s6, 40(sp)
	lw t3, 44(sp)
	lw t2, 48(sp)
    addi sp, sp, 52

	#store it in the new matrix (result get from dot is stored in a0)
	#find the relative address of the new matrix in this case***
	add t5, t0, x0
	#addi t5, t5, -1
	mul t5, t5, s5
	add t5, t5, t1
	slli t5, t5, 2
	add t5, t5, s6
	sw t4, 0(t5)
	
	
	addi t1, t1, 1
	beq t1, s5, inner_loop_end
	jal x0 inner_loop_start
inner_loop_end:
    addi t0, t0, 1
	mv t1, x0
	jal x0, outer_loop_start

outer_loop_end:

    # Epilogue
    lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw s3, 16(sp)
	lw s4, 20(sp)
	lw s5, 24(sp)
	lw s6, 28(sp)
	addi sp, sp, 32
    
    ret


mismatched_dimensions:
    li a1 2
    jal exit2
