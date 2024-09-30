# .data

# A:  .word 1, 2, 3, 4, 5
# len: .word 5

# .text
# main:
    
#     # TAKE INPUT !!!!!!!!
#     # li $v0, 5
#     # syscall
#     # move $s0, $v0
#     li $s0, 4
    
 
    
    
#     # # binarySearch(A, <len-of-A>, 0, <len-of-A>, <some-val>)
#     # la $a0, 0($sp)

#     la $a0, A
    
#     la $t0, len
#     lw $a1, 0($t0)

#     li $a2, 0
#     lw $a3, 0($t0)
    
#     addi $sp, $sp, -4
#     sw $s0, 0($sp)

#     jal binarySearch

#     addi $sp, $sp, 4
#     # Print the result of the search onto the console (STDOUT).
#     move $a0, $v0
#     li $v0, 1
#     syscall
    
#     j exit_code

# binarySearch:

    
#     lw $s0, 0($sp)

#     addi $sp, $sp, -4
#     sw $ra, 0($sp)

#     blt $a2, $a3, check
    
#     add $t0, $a2, $a3
#     srl $t0, $t0, 1 #mid

#     sll $t1, $t0, 2

    
#     add $t2, $t1, $a0


#     lw $t3, 0($t2) # t2 is value of a(mid)

#     # move $a0, $t0
    
#     beq $t3, $s0,mid # return mid


# check:
#     add $t0, $a2, $a3
#     srl $t0, $t0, 1 #mid

#     sll $t1, $t0, 2

    
#     add $t2, $t1, $a0


#     lw $t3, 0($t2) # t2 is value of a(mid)

#     # move $a0, $t0
    
#     beq $t3, $s0,mid # return mid

#     bgt $t3, $s4, greater #end = mid
    
#     blt $t3, $s4, lesser #start = mid + 1
    

# greater:
#     addi $sp, $sp, -4
#     sw $ra, 0($sp)

#     move $a3, $t0

#     jal binarySearch

#     j mid

# lesser:

#     addi $sp, $sp, -4
#     sw $ra, 0($sp)

#     addi $t0, $t0, 1
#     move $a2, $t0

#     jal binarySearch
    
#     j mid


# false:
#     li $v0, -1
#     lw $ra, 0($sp)
#     addi $sp, $sp, 4
#     jr $ra

# mid:
#     move $v0, $t0 # $a0 stores mid
#     lw $ra, 0($sp)
#     addi $sp, $sp, 4
#     jr $ra



# done:
#     lw $ra, 0($sp)
#     addi $sp, $sp, 4
#     jr $ra

# exit_code:


.data

A:  .word 1, 2, 3, 4, 5
len: .word 5

.text
main:
    # Input value (can be changed to syscall for user input)
    li $s0, 23  # Searching for value 4
    
    # Set up the array, length, start, and end values
    la $a0, A    # Base address of array
    la $t0, len
    lw $a1, 0($t0)   # $a1 = len of array
    
    li $a2, 0       # Start index = 0
    lw $a3, 0($t0)  # End index = len
    
    addi $sp, $sp, -4
    sw $s0, 0($sp)  # Push the search value (4) onto the stack

    # Call binarySearch with array, len, start, end, and search value
    jal binarySearch

    addi $sp, $sp, 4  # Restore stack after function call

    # Print the result (index or -1 if not found)
    move $a0, $v0
    li $v0, 1
    syscall
    
    j exit_code

binarySearch:
    # Load search value from the stack
    # lw $s0, 0($sp)


    addi $sp, $sp, -4
    sw $ra, 0($sp)  # Save return address on stack

    # Base case: If start >= end, return -1 (value not found)
    bge $a2, $a3, not_found
    
    # Calculate mid = (start + end) / 2
    add $t0, $a2, $a3
    srl $t0, $t0, 1  # mid = (start + end) / 2

    # Calculate A[mid] address and load A[mid] value
    sll $t1, $t0, 2  # t1 = mid * 4 (byte offset)
    add $t2, $t1, $a0  # t2 = A + mid * 4
    lw $t3, 0($t2)  # t3 = A[mid]

    # If A[mid] == search value, return mid
    beq $t3, $s0, mid_found

    # If A[mid] > search value, search the left half (end = mid)
    bgt $t3, $s0, search_left

    # If A[mid] < search value, search the right half (start = mid + 1)
    j search_right

binaryanother:
    
    addi $sp, $sp, -4
    sw $ra, 0($sp)  # Save return address on stack

    # Base case: If start >= end, return -1 (value not found)
    bge $a2, $a3, not_found
    
    # Calculate mid = (start + end) / 2
    add $t0, $a2, $a3
    srl $t0, $t0, 1  # mid = (start + end) / 2

    # Calculate A[mid] address and load A[mid] value
    sll $t1, $t0, 2  # t1 = mid * 4 (byte offset)
    add $t2, $t1, $a0  # t2 = A + mid * 4
    lw $t3, 0($t2)  # t3 = A[mid]

    # If A[mid] == search value, return mid
    beq $t3, $s0, mid_found

    # If A[mid] > search value, search the left half (end = mid)
    bgt $t3, $s0, search_left

    # If A[mid] < search value, search the right half (start = mid + 1)
    j search_right

    
search_left:
    # Update end = mid and recursively call binarySearch
    move $a3, $t0  # end = mid
    jal binarySearch

    # move $v0, $v0  # Propagate the result back
    j done

search_right:
    # Update start = mid + 1 and recursively call binarySearch
    addi $t0, $t0, 1
    move $a2, $t0  # start = mid + 1
    jal binarySearch

    # move $v0, $v0  # Propagate the result back
    j done

mid_found:
    # Return mid index in $v0
    move $v0, $t0
    j done

not_found:
    # Return -1 to indicate value not found
    li $v0, -1
    j done    

done:
    # Restore return address and return from function
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

exit_code:
    # Exit program
    li $v0, 10
    syscall
