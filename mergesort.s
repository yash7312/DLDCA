.data
prompt:     .asciiz "Enter a number: "
result_msg: .asciiz "\nThe Fibonacci number is: "
newline:    .asciiz "\n"

.text
.globl main

main:
    li $a0, 5
    
    # Call the recursive Fibonacci function
    jal fibonacci

    # Print the Fibonacci number
    move $a0, $v0             # move the result (Fib(n)) to $a0
    li   $v0, 1               # syscall for printing integer
    syscall


    # Exit program
    li   $v0, 10              # syscall for exit
    syscall

# Recursive Fibonacci function
# Input: $a0 = n
# Output: Fibonacci number in $v0
fibonacci:
    # Base case: if n <= 1, return n
    li   $t0, 1               # load 1 into $t0
    ble  $a0, $t0, base_case  # if n <= 1, go to base_case

    move $t2, $a0
    # Push return address onto stack
    addi $sp, $sp, -4          # make space on stack
    sw   $ra, 0($sp)          # save return address

    # Prepare for the first recursive call: fibonacci(n - 1)
    addi $a0, $a0, -1          # n - 1
    jal  fibonacci             # call fibonacci(n - 1)

    # Save the result of fibonacci(n - 1) into $t1
    move $t1, $v0              # move result to $t1

    # Prepare for the second recursive call: fibonacci(n - 2)
    move $a0, $t2
    
    lw   $ra, 0($sp)           # restore return address
    addi $sp, $sp, 4           # pop stack
    addi $a0, $a0, -1          # restore n to original value
    addi $a0, $a0, -1          # now call fibonacci(n - 2)
    jal  fibonacci             # call fibonacci(n - 2)

    # Add the results of fibonacci(n - 1) and fibonacci(n - 2)
    add  $v0, $v0, $t1         # $v0 = Fib(n - 1) + Fib(n - 2)

    # Return from the function
    jr   $ra                   # return to caller

base_case:
    li $v0, 1              # if n <= 1, return n
    jr   $ra                   # return to caller