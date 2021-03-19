.import ../read_matrix.s
.import ../utils.s

.data
file_path: .asciiz "./test_input.bin"

.text
main:
    # Read matrix into memory
	#allocating memory
	addi a0, x0, 8
	jal ra malloc 
	mv a1, a0
	addi a2, a0, 4
	la a0, file_path
	#addi sp, sp, -8
    #sw a1, 0(sp)
    #sw a2, 4(sp)
	jal ra read_matrix
	#lw a1, 0(sp)
    #lw a2, 4(sp)
    #addi sp, sp, 8
	lw a1, 0(a1)
	lw a2, 0(a2)
    # Print out elements of matrix
	jal ra print_int_array
	

    # Terminate the program
    addi a0, x0, 10
    ecall