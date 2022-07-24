.data #define item_list
in_buff: .space 64
filename: .asciiz "test.dat"

.text #main code segment for test
main:
la $a0, filename
li $a1, 0
li $a2, 0
li $v0, 13
syscall
move $a0, $v0
la $a1, in_buff
li $a2, 512
li $v0, 14
syscall
li $v0 16
syscall
la $t0, in_buff
lw $a0, 4($t0)
addi $a1, $t0, 8
lw $a2, 0($t0)
jal knapsack_dp_recursion #call function knapsack_dp_recursion
j exit

.text
knapsack_dp_recursion:
bne $a0, $zero, knapsack_dp_recursion_nez #if(item_num == 0)
move $v0, $zero
j knapsack_dp_recursion_exit  #return 0
knapsack_dp_recursion_nez:
lw $s0, 0($a1) #item_list[0].weight
lw $s1, 4($a1) #item_list[0].value
li $t0, 1
bne $a0, $t0, knapsack_dp_recursion_neo #if(item_num == 1)
slt $t0, $a2, $s0 
bne $t0, $zero, knapsack_dp_recursion_eo_rz #if(knapsack_capacity < item_list[0].weight)
move $v0, $s1 
j knapsack_dp_recursion_exit #return item_list[0].value
knapsack_dp_recursion_eo_rz:
li $v0, 0 #return 0
j knapsack_dp_recursion_exit
knapsack_dp_recursion_neo:
addi $sp, $sp, -24
sw $a2, 20($sp)
sw $a1, 16($sp)
sw $a0, 12($sp)
sw $ra, 8($sp)
sw $s1, 4($sp)
sw $s0, 0($sp)
addi $a0, $a0, -1
addi $a1, $a1, 8
jal knapsack_dp_recursion #knapsack_dp_recursion(item_num - 1, item_list + 1, knapsack_capacity)
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $ra, 8($sp)
lw $a0, 12($sp)
lw $a1, 16($sp)
lw $a2, 20($sp)
addi $sp, $sp, 24 
move $s2, $v0 #val_out
addi $sp, $sp, -28 
sw $a2, 24($sp)
sw $a1, 20($sp)
sw $a0, 16($sp)
sw $ra, 12($sp)
sw $s2, 8($sp)
sw $s1, 4($sp)
sw $s0, 0($sp)
addi $a0, $a0, -1
addi $a1, $a1, 8
sub $a2, $a2, $s0
jal knapsack_dp_recursion
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $ra, 12($sp)
lw $a0, 16($sp)
lw $a1, 20($sp)
lw $a2, 24($sp)
addi $sp, $sp, 28 
add $s3, $v0, $s1 #val_in
slt $t0, $a2, $s0
bne $t0, $zero, knapsack_dp_recursion_return_val_out #if(knapsack_capacity < item_list[0].weight)
slt $t0, $s2, $s3
bne $t0, $zero, knapsack_dp_recursion_return_val_in #if(val_in > val_out)
knapsack_dp_recursion_return_val_out:
move $v0, $s2
j knapsack_dp_recursion_exit
knapsack_dp_recursion_return_val_in:
move $v0, $s3
knapsack_dp_recursion_exit:
jr $ra
exit:
