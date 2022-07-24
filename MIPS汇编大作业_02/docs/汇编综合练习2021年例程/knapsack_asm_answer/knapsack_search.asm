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
jal knapsack_search #call function knapsack_search
j exit


.text #knapsack_search_function
knapsack_search:
move $s0, $zero #val_max = 0
li $s1, 1
sllv $s1, $s1, $a0 #0x1 << item_num
move $t0, $zero #state_cnt = 0
loop_state_cnt_start:
slt $t1, $t0, $s1
beq $t1, $zero, loop_state_cnt_exit
move $t1, $zero #i = 0
move $t2, $zero #weight = 0
move $t3, $zero #val = 0
loop_i_start:
slt $t4, $t1, $a0
beq $t4, $zero, loop_i_exit
srav $t4, $t0, $t1 
andi $t4, $t4, 0x1 #(state >> i) & 0x1 
beq $t4, $zero, assign_skip
sll $t5, $t1, 3
add $t5, $a1, $t5 #item_list + i
lw $t6, 0($t5)
add $t2, $t2, $t6 #weight = weight + item_list[i].weight
lw $t6, 4($t5)
add $t3, $t3, $t6 #val = val + item_list[i].value
assign_skip:
addi $t1, $t1, 1
j loop_i_start
loop_i_exit:
slt $t4, $a2, $t2
bne  $t4, $zero, if_exit 
slt $t4, $s0, $t3
beq $t4, $zero, if_exit 
move $s0, $t3
if_exit:
addi $t0, $t0, 1
j loop_state_cnt_start
loop_state_cnt_exit:
move $v0, $s0
jr $ra
exit:
