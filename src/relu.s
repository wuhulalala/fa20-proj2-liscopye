.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    li t0, 1
    blt a1, t0, exit
    li t0, 0
    

loop_start:
    beq t0, a1, loop_end
    slli t1, t0, 2
    add t1, t1, a0
    lw t2, 0(t1)
    bge t2, x0, loop_continue
    addi t2, x0, 0
    sw t2, 0(t1)
    

loop_continue:
    addi t0, t0, 1
    j loop_start
    
exit:
    li a0, 78

loop_end:


    # Epilogue

    
    ret

