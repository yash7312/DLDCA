.text

main:
    li $s0, 5
    move $a0, $s0

    jal fact

    move $t0, $v0


    li $v0, 65539
    move $a0, $t0
    syscall

    li $v0, 10
    syscall

fact:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $a0, 0($sp)

    bne $a0, $0, loop

    li $v0, 1 #makes v0 1
    j done

loop:
    addi $a0, $a0, -1
    jal fact
    lw $a0, 0($sp)
    mul $v0, $v0, $a0

done:
    # lw $v0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra




