.text
main:
    li a7, 5         # Set system call number for read to a7
    ecall            # Make the system call

    li t2, 0         # Initialize t2 to 0
    li t3, 256       # Load 256 into t3
    slli t3, t3, 14  # Shift left logical immediate by 14

    # Example of using csrrw to read the cycle counter and store it in t6
    csrrw t6, cycle, x0

loop:
    beqz t3, print   # Branch to print if t3 is zero
    mul t4, t2, t2   # Multiply t2 by itself and store in t4
    mulhu t5, t2, t2 # Multiply high unsigned and store in t5
    srli t4, t4, 14  # Shift right logical immediate by 14
    slli t5, t5, 18  # Shift left logical immediate by 18
    add t4, t4, t5   # Add t4 and t5
    beq t4, a0, print # Branch to print if t4 equals a0
    bltu t4, a0, lt   # Branch to lt if t4 is less than a0
    bge t4, a0, gt   # Branch to gt if t4 is greater than or equal to a0

lt:
    add t2, t2, t3   # Add t3 to t2
    srli t3, t3, 1   # Shift right logical immediate by 1
    j loop           # Jump to loop

gt:
    sub t2, t2, t3   # Subtract t3 from t2
    srli t3, t3, 1   # Shift right logical immediate by 1
    j loop           # Jump to loop

print:
    mv a0, t2        # Move t2 to a0
    li a7, 1         # Set system call number for write to a7
    ecall            # Make the system call

    # Example of using csrrw to write back the cycle counter value to the CSR
    csrrw x0, cycle, t6
