.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
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
    # EndPrologue


inital:
    mv s0, a0
    mv s1, a1
    mv s2, a2
    # Call fopen
    mv a1, s0
    addi a2, x0, 0
    jal ra, fopen
    li t0, -1
    # If fopen error, exit with code 90
    beq t0, a0, fopen_error

    # Call fread(read the col and row)
    mv a1, a0
    mv s4, a0
    mv a2, s1
    addi a3, x0, 4
    jal ra, fread
    # If fread error, exit with code 91
    li t0, 4
    bne t0, a0, fread_error

    # Call fread(read the col and row)
    mv a1, s4
    mv a2, s2
    addi a3, x0, 4
    jal ra, fread
    # If fread error, exit with code 91
    li t0, 4
    bne t0, a0, fread_error

    # Malloc space for martrix
    lw t1, 0(s1)
    lw t2, 0(s2)
    mul t0, t1, t2
    slli t0, t0, 2
    mv a0, t0
    mv s3, t0
    jal ra, malloc
    beq a0, x0, malloc_error 

    # Read the matrix to the buffer
    mv s5, a0
    mv a1, s4
    mv a2, s5
    lw t1, 0(s1)
    lw t2, 0(s2)
    mul t0, t1, t2
    slli a3, t0, 2
    jal ra, fread
    lw t1, 0(s1)
    lw t2, 0(s2)
    mul t0, t1, t2
    slli t0, t0, 2
    bne a0, t0, fread_error

    mv a1, s4
    jal ra, fclose
    blt a0, x0, fclose_error
    mv a0, s5    


    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28
    # EndEpilogue
    ret

fopen_error:
    li a1, 90
    j exit2
fread_error:
    li a1, 91
    j exit2

malloc_error:
    li a1, 88
    j exit2
fclose_error:
    li a1, 92
    j exit2
