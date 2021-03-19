.import ../matmul.s
.import ../utils.s
.import ../dot.s

# static values for testing
.data
m0: .word 3
m1: .word 2 1 4 #2 1 4
d: .word 0 0 0# allocate static space for output

.text
main:
    # Load addresses of input matrices (which are in static memory), and set their dimensions
    la s0, m0
	la s1, m1
	la s2, d

	mv a0, s0
	addi a1, x0, 1
	addi a2, x0, 1
	mv a3, s1
	addi a4, x0, 1
	addi a5, x0, 3
	mv a6, s2


    # Call matrix multiply, m0 * m1
    jal ra matmul



    # Print the output (use print_int_array in utils.s)
	mv a0, s2
	addi a1, x0, 1
	addi a2, x0, 3
	jal ra print_int_array



    # Exit the program
    jal exit