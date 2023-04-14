.globl write_matrix

.data 
rows: .word 0
cols: .word 0
.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -30
    sw, ra, 0(sp)
    sw, s0, 4(sp)
    sw, s1, 8(sp)
    sw, s2, 12(sp)
    sw, s3, 16(sp)
    sw, s4, 20(sp)
    sw, s5, 24(sp)
    # EndPrologue

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    
    mv a1, s0
    li a2, 1
    # Call fopen
    jal ra, fopen
    blt a0, x0, fopen_error

    # Store the file descriptor
    mv s4, a0

    # Write the rows and cols to file
    mv a1, s4
    la t0, rows
    sw s2, 0(t0)
    mv a2, t0
    li a3, 1
    li a4, 4
    jal ra, fwrite
    li t0, 1
    bne a0, t0, fwrite_error

    mv a1, s4
    la t0, cols
    sw s3, 0(t0)
    mv a2, t0
    li a3, 1
    li a4, 4
    jal ra, fwrite
    li t0, 1
    bne a0, t0, fwrite_error


    # Write the martrix to file
    mul s3, s2, s3
    li s2, 0
loop_begin:
    bge s2, s3, loop_end
    mv t0, s2
    slli t0, t0, 2
    add t0, t0, s1
    mv a1, s4
    mv a2, t0
    li a3, 1
    li a4, 4
    jal ra, fwrite
    li t0, 1
    bne a0, t0, fwrite_error
    addi s2, s2, 1
    j loop_begin




loop_end:
    mv a1, s4
    jal ra, fclose
    blt a0, x0, fclose_error
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 30
    # EndEpilogue
    ret

fopen_error:
    li a1, 93
    j exit2

fwrite_error:
    li a1, 94
    j exit2
fclose_error:
    li a1, 95
    j exit2