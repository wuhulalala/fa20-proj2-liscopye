.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    li t0, 1
    blt a1, t0, m0_error
    blt a2, t0, m0_error
    blt a4, t0, m1_error
    blt a5, t0, m1_error
    bne a2, a4, match_error
    # Prologue
    addi sp, sp, -44
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    # EndPrologue
    li  s6, 0

    # Save the arguments will change
    add s0, x0, a0
    add s1, x0, a1
    add s2, x0, a2
    add s3, x0, a3
    add s4, x0, a4
    add s5, x0, a5
    add s9, x0, a6
outer_loop_start:
    bge s6, s1, outer_loop_end
    li s7, 0 



inner_loop_start:
    bge s7, s5, inner_loop_end
    # Get the index of the target martrix
    mul s8, s6, s5
    add s8, s8, s7
    slli s8, s8, 2
    add s8, s9, s8


    # Get the dot product
    mul t0, s6, s2
    slli t0, t0, 2
    add a0, t0, s0
    add t0, s7, x0
    slli t0, t0, 2
    add a1, t0, s3
    add a2, s2, x0
    li a3, 1
    add a4, s5, x0
    jal ra, dot

    # Load the dot product
    sw a0, 0(s8)

    # Go to next elements
    addi s7, s7, 1
    j inner_loop_start



inner_loop_end:
    addi s6, s6, 1
    j outer_loop_start


outer_loop_end:
    j resume
m0_error:
    li a0, 72
    j exit

m1_error:
    li a0, 73
    j exit

match_error:
    li a0, 74
    j exit

resume:
    # Epilogue
    lw ra, 0(sp) 
    lw s0, 4(sp) 
    lw s1, 8(sp) 
    lw s2, 12(sp) 
    lw s3, 16(sp) 
    lw s4, 20(sp) 
    lw s5, 24(sp) 
    lw s6, 28(sp) 
    lw s7, 32(sp) 
    lw s8, 36(sp) 
    lw s9, 40(sp) 
    addi sp, sp, 44
exit: 
    ret
