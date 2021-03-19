.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is a pointer to an integer, we will set it to the number of rows
#   a2 is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 is the pointer to the matrix in memory
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -28
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	sw s4, 20(sp)
	sw s5, 24(sp)
	mv s0, a0#filename pointer
	mv s1, a1#rownumber pointer
	mv s2, a2#column number pointer 
	mv a1, s0
	addi t0, x0, -1
	add a2, x0, x0
	jal ra fopen
	beq a0, t0, eof_or_error
	mv s5, a0# store the file description
	
	#read the row number
	mv a1, s5
	mv a2, s1
	addi a3, x0, 4
	addi t0, x0, 4
	jal ra fread
	bne a0, t0, eof_or_error
	
	#read the column number
	mv a1, s5
	mv a2, s2
	addi a3, x0, 4
	addi t0, x0, 4
	jal ra fread
	bne a0, t0, eof_or_error

	lw t1, 0(s1)
	lw t2, 0(s2)
	mul t3, t1, t2
	slli t3, t3, 2
	mv s4, t3#number of bytes that needs to be read
	mv a0, s4
	jal ra malloc
	mv s3, a0#store the address
	mv a1, s5
	
	mv a2, s3
	mv a3, s4
	
	jal ra fread
	bne a0, s4, eof_or_error
	
	addi t0, x0, -1
	mv a1, s5
	jal ra fclose
	beq t0, a0, eof_or_error
	
	mv a0, s3
	mv a1, s1
	mv a2, s2
    # Epilogue
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw s3, 16(sp)
	lw s4, 20(sp)
	lw s5, 24(sp)
	addi sp, sp, 28

    ret

eof_or_error:
    li a1 1
    jal exit2
    