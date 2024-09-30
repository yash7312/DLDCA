.data
a1: .word 4        # Data of first node
    .word a2       # Pointer to the second node

a2: .word 3        # Data of second node
    .word a3       # Pointer to the third node

a3: .word 2        # Data of third node
    .word a4       # Pointer to the fourth node

a4: .word 1        # Data of fourth node
    .word 0        # Null (end of list), no next node

.text

.globl main

main:
    la $t0, a1          # Load address of the first node into $t0
    move $a0, $t0       # Pass the head of the list as an argument
    
    jal bubble_sort     # Call bubble sort function

    jal traverse_list   # Traverse the list and print its content

    j exit

# Bubble Sort Function
bubble_sort:
    move $t1, $a0       # Copy the head of the list to $t1
    li $t2, 1           # Sorting flag, $t2 = 1 means we need to sort

outer_loop:
    beq $t2, $zero, exit_sort # If no swaps, list is sorted, exit
    move $t2, $zero      # Reset the swap flag

    move $t1, $a0        # Start from the head of the list again

inner_loop:
    lw $t3, 0($t1)       # Load the data of the current node into $t3
    lw $t4, 4($t1)       # Load the address of the next node into $t4
    beq $t4, $zero, outer_loop  # If the next node is NULL, exit inner loop

    lw $t5, 0($t4)       # Load the data of the next node into $t5

    # Compare the current node's data with the next node's data
    ble $t3, $t5, no_swap  # If current <= next, no swap needed

    # Swap the data between current and next node
    sw $t5, 0($t1)       # Store next node's data in current node
    sw $t3, 0($t4)       # Store current node's data in next node
    li $t2, 1            # Set the swap flag to indicate a swap occurred

no_swap:
    move $t1, $t4        # Move to the next node
    j inner_loop         # Repeat the inner loop

exit_sort:
    jr $ra               # Return from the function

# Function to traverse and print the linked list
traverse_list:
    beq $t0, $zero, exit1  # If the current node is NULL, exit

    lw $t1, 0($t0)         # Load the data of the current node into $t1
    li $v0, 1              # Print integer syscall
    move $a0, $t1          # Move the data to $a0 for printing
    syscall

    lw $t0, 4($t0)         # Load the address of the next node
    j traverse_list        # Repeat the process for the next node

exit1:
    jr $ra                 # Return from the function

exit:
    li $v0, 10             # Exit syscall
    syscall
