.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # Prologue
    li t0, 1
    blt a1, t0, exit
    lw t3, 0(a0)
    li t4, 0


loop_start:
    beq t0, a1, loop_end
    slli t1, t0, 2
    add t1, t1, a0
    lw t2, 0(t1)
    blt t2, t3, loop_continue
    addi t3, t2, 0 
    addi t4, t0, 0 


loop_continue:
    addi t0, t0, 1
    j loop_start


loop_end:
    addi a0, t4, 0 
    j return

exit:
    li a0, 77

    # Epilogue
return:
    ret
