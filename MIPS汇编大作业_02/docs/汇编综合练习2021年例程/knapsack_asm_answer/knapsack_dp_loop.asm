.data #define item_list
in_buff: .space 64
cache: .space 64
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
jal knapsack_dp_loop #call function knapsack_dp_loop
j exit

.text
knapsack_dp_loop:
la $s0, cache
li $t0, 0
li $t1, 256
reset_buffer:
slt $t2, $t0, $t1
beq $t2, $zero, reset_buffer_exit  #if(i < 256)
sll $t2, $t0, 2
add $t2, $t2, $s0
sw $zero, 0($t2)
addi $t0, $t0, 1
j reset_buffer #flush cache
reset_buffer_exit:
li $t0, 0 #i = 0
move $t1, $a0 #item_num
dp_i_loop:
slt $t2, $t0, $t1 
beq $t2, $zero, dp_i_loop_exit #if(i < item_num)
sll $t2, $t0, 3
add $t2, $t2, $a1 #(Item*)item_list + i
lw $s1, 0($t2) #weight=item_list[i].weight
lw $s2, 4($t2) #val=item_list[i].value
move $t2, $a2 #j = knapsack_capacity
dp_j_loop:
slt $t3, $t2, $zero #if(j >= 0)
bne $t3, $zero, dp_j_loop_exit
slt $t3, $t2, $s1 #if(j >= weight)
bne $t3, $zero, dp_j_loop_continue
sll $t3, $t2, 2
add $t3, $t3, $s0 #(int*)cache_ptr + j
sub $t4, $t2, $s1
sll $t4, $t4, 2
add $t4, $t4, $s0 #(int*)cache_ptr + j - weight
lw  $s3, 0($t3) #cache_ptr[j]
lw  $s4, 0($t4) #cache_ptr[j - weight]
add $s4, $s4, $s2 #cache_ptr[j - weight] + val
slt $t4, $s4, $s3
bne $t4, $zero, compare_skip
move $s3, $s4
compare_skip:
sw $s3, 0($t3)
dp_j_loop_continue:
addi $t2, $t2, -1
j dp_j_loop
dp_j_loop_exit:
addi $t0, $t0, 1
j dp_i_loop
dp_i_loop_exit:
sll $t0, $a2, 2
add $t0, $t0, $s0 #cache_ptr[knapsack_capacity]
lw $v0, 0($t0)
jr $ra
exit:
