.import read_matrix.s
.import write_matrix.s
.import matmul.s
.import dot.s
.import relu.s
.import argmax.s
.import utils.s

.globl main

.text
main:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0: int argc
    #   a1: char** argv
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
    # Exit if incorrect number of command line args

	li t0, 5
	#addi t0, t0, 5
	beq t0, a0, xxx
	li a1, 3
	jal exit2


	# =====================================
    # LOAD MATRICES
    # =====================================
xxx: 
	mv s1, a1
    # Load pretrained m0

	addi a0, x0, 8
	jal ra malloc
	mv a1, a0
	mv s5, a1#m0 row number--s5
	addi a2, a1, 4
	lw a0, 4(s1)
	jal ra read_matrix
	mv s2, a0#m0's pointer --s2
	
    # Load pretrained m1
	addi a0, x0, 8
	jal ra malloc
	mv a1, a0
	mv s6, a1#m1 row number--s6
	addi a2, a1, 4
	lw a0, 8(s1)
	jal ra read_matrix
	mv s3, a0#m1's pointer --s3
	
    # Load input matrix
	addi a0, x0, 8
	jal ra malloc
	mv a1, a0
	mv s0, a1#input matrix row number--s0
	addi a2, a1, 4
	lw a0, 12(s1)
	jal ra read_matrix
	mv s4, a0 #input matrix's pointer--s4


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
	
	#linear layer 1
	#mv a0, s2
	####
	#lw a1, 0(s5)
	#lw a2, 4(s5)
	#mv a3, s4
	#lw a4, 0(s0)
	#lw a5, 4(s0)
	lw t0, 0(s5)
	lw t1, 4(s0)
	mul a0, t0, t1
	slli a0, a0, 4
	jal ra malloc
	#
	mv s9, a0#pointer to malloc1
	#
	mv a6, a0
	lw a1, 0(s5)
	lw a2, 4(s5)
	mv a3, s4
	lw a4, 0(s0)
	lw a5, 4(s0)
	mv s8, a6#storing the result
	mv a0, s2
	jal ra matmul

	#nonlinear layer 1
	#perform relu on the result funcction
	mv a0, s8
	lw t0, 0(s5)
	lw t1, 4(s0)
	mul a1, t0, t1
	jal ra relu

	#linear layer 2
	lw t0, 0(s6)
	lw t1, 4(s0)
	mul a0, t0, t1
	slli a0, a0, 2
	jal ra malloc 
	mv s7, a0#s7--pointer to malloc2
	
	mv a0, s3
	lw a1, 0(s6)
	lw a2, 4(s6)
	mv a3, s8
	lw a4, 0(s5)
	lw a5, 4(s0)
	mv a6, s7
	jal ra matmul
	
	
	
    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    #lw a0 16(s0) # Load pointer to output filename
	lw a0, 16(s1)
	mv a1, s7
	lw a2, 0(s6)
	lw a3, 4(s0)
	jal ra write_matrix


    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
	mv a0, s7
	lw t0, 0(s6)
	lw t1, 4(s0)
	mul a1, t0, t1
	jal ra argmax

    # Print classification
    mv a1, a0
	jal ra print_int


    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

	#free the memory used
	mv a0, s5
	jal ra free
	mv a0, s6
	jal ra free
	mv a0, s7
	jal ra free
	mv a0, s0
	jal ra free
	mv a0, s9
	jal ra free


    jal exit
