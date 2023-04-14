.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:

    # Prologue
	li t0, 1
	blt a2, t0, exit_len
	blt a3, t0, exit_stride
	blt a4, t0, exit_stride
	li t0, 0
	li t1, 0
	li t2, 0
    li t4, 0

loop_start:
	bge t0, a2, loop_end		
	slli t1, t0, 2
	mul t1, a3, t1
	slli t2, t0, 2
	mul t2, a4, t2
    add t1, a0, t1
    add t2, a1, t2
	lw t1, 0(t1)
	lw t2, 0(t2)
	mul t3, t1, t2
    add t4, t4, t3
	addi t0, t0, 1
	j loop_start


loop_end:
	add a0, t4, x0
	j exit

exit_len:
	addi a0, x0, 75
	j exit	

exit_stride:
	addi a0, x0, 76

exit:    
    ret

