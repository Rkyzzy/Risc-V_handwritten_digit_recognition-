.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is the pointer to the start of the matrix in memory
#   a2 is the number of rows in the matrix
#   a3 is the number of columns in the matrix
# Returns:
#   None
# ==============================================================================
write_matrix:

    # Prologue
	addi sp, sp, -28
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	sw s4, 20(sp)
	sw s5, 24(sp)
	mv s0, a0
	mv s1, a1
	mv s2, a2
	mv s3, a3
	
	#using fopen to open the file
	mv a1, s0
	addi t0, x0, -1
	addi a2, x0, 1
	jal ra fopen
	beq a0, t0, eof_or_error
	mv s4, a0#save the file descriptor
	
	#malloc space for row number and column number
	addi a0, x0, 8
	jal ra malloc
	mv s5, a0
	sw s2, 0(s5)
	sw s3, 4(s5)
	
	#write in the row number and the column number
	mv a1, s4
	mv a2, s5
	mul s5, s3, s2
	addi a3, x0, 2
	addi a4, x0, 4
	addi t0, x0, 2
	jal ra fwrite
	bne t0, a0, eof_or_error
	
	#free the memory allocated
	mv a1, s4
	jal ra fflush
	bne a0, x0, eof_or_error
	
	#write in the matrix
	mv a1, s4
	mv a2, s1
	mv a3, s5
	addi a4, x0, 4
	jal ra fwrite
	bne a3, a0, eof_or_error

	#should i free here?
	#mv a1, s4
	#jal ra fflush
	#bne a0, x0, eof_or_error
	
	#close the file
	mv a1, s4
	jal ra fclose
	bne a0, x0, eof_or_error
	
	
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
    