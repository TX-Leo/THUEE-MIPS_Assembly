# ###################################################
# Author:TX-Leo
# Tool Versions: Mars4_5 for Mips
# Create Date: 2022/05/04
# Project Name: Experiment_02_02_string_matching_horspool.asm
# Source File: Experiment_02_02_string_matching_horspool.c
# Description: It's TX-Leo's Experiment_02_02
# Function:Horspool Algorithm
#  (1)   从后往前匹配
#  (2)   找到不匹配的字符。
#  (3)   移动：字符串后移位数=失配字符位置-失配字符上一次出现的位置
# ###################################################

.data
    str: .space 512
    pattern: .space 512
    filename: .asciiz "test.dat"

.text
    main:
        # fopen
        la $a0, filename                    # load filename
        li $a1, 0                           # flag
        li $a2, 0                           # mode
        li $v0, 13                          # open file syscall index
        syscall

        # read str
        move $a0, $v0                       # load file description to $a0
        la $a1, str
        li $a2, 1
        li $s0, 0                           # len_pattern = 0
    
    read_str_entry:
        slti $t0, $s0, 512
        beqz $t0, read_str_exit
        li $v0, 14                          # read file syscall index
        syscall
        lb $t0, 0($a1)
        addi $t1, $zero, '\n'
        beq $t0, $t1, read_str_exit
        addi $a1, $a1, 1
        addi $s0, $s0, 1
        j read_str_entry
    read_str_exit:
        # read pattern
        la $a1, pattern
        li $a2, 1
        li $s1, 0                           # len_pattern = 0
    
    read_pattern_entry:
        slti $t0, $s1, 512
        beqz $t0, read_pattern_exit
        li $v0, 14                          # read file syscall index
        syscall
        lb $t0, 0($a1)
        addi $t1, $zero, '\n'
        beq $t0, $t1, read_pattern_exit
        addi $a1, $a1, 1
        addi $s1, $s1, 1
        j read_pattern_entry
    
    read_pattern_exit:
        # close file
        li $v0, 16                          # close file syscall index
        syscall

        # call brute_force
        move $a0, $s0
        la $a1, str
        move $a2, $s1
        la $a3, pattern
        jal horspool

        # printf
        move $a0, $v0
        li $v0, 1
        syscall
        
        # return 0
        li $a0, 0
        li $v0, 17
        syscall

    horspool:
        # #push params and register into stack
        addi $sp, $sp, -20
        sw $a0, 0($sp)                      # store len_str
        sw $a1, 4($sp)                      # store the address of str
        sw $a2, 8($sp)                      # store len_pattern
        sw $a3, 12($sp)                     # store address of pattern
        sw $ra, 16($sp)                     # store register

        li $s1, 0                           # i = 0
        li $s2, 0                           # j = 0
        li $s3, 0                           # cnt = 0
        li $s4, 256                         # save 256 into $s4
        li $s5, -1                          # save -1 into $s5

        # dynamic memory allocation
        li $a0, 256
        li $v0, 9
        syscall
        
        move $s0, $v0                       # save addr in $s0
        lw $a0, 0($sp)                      # reload $a0

    loop_1:
        bge $s1, $s4, exit_1

        mul $t0, $s1, 4                     # get i * 4
        add $t1, $s0, $t0                   # get the addr of table[i]
        sw $s5, ($t1)                       # save -1 in array

        addi $s1, $s1, 1
        j loop_1

    exit_1:
        li $s1, 0
    
    loop_2:
        bge $s1, $a2, exit_2

        add $t1, $a3, $s1                   # get the addr of pattern[i]
        lb $t1, ($t1)                       # get the value of it
        mul $t0, $t1, 4     
        add $t1, $s0, $t0                   # get the addr of table[pattern[i]]
        sw $s1, ($t1)                       # store i in it

        addi $s1, $s1, 1
        j loop_2

    exit_2:
        subi $s1, $a2, 1                    # i = len_pattern - 1
    
    while_1:
        bge $s1, $a0, exit_w1
        li $s2, 0                           # j = 0
    
    while_2:
        bge $s2, $a2, exit_w2
        add $t1, $a2, $s5
        sub $t1, $t1, $s2                   # len_pattern - 1 - j

        add $t1, $t1, $a3                   # get the addr of pattern[len_pattern - 1 -j]
        lb $t1, ($t1)                       # get the value of it

        sub $t2, $s1, $s2                   # i - j
        add $t2, $a1, $t2                   # get the addr of str[i - j]
        lb $t2, ($t2)                       # get the value of it

        bne $t1, $t2, exit_w2
        addi $s2, $s2, 1                    # j += 1

        j while_2

    exit_w2:
        beq $s2, $a2, update_1
        j end_update_1

    update_1:
        addi $s3, $s3, 1                    # cnt += 1

    end_update_1:
        add $t1, $a1, $s1                   # get the addr of str[i]
        lb $t1, ($t1)                       # get the value of it

        mul $t0, $t1, 4
        add $t1, $s0, $t0                   # get the addr of table[str[i]]
        lw $t1, ($t1)                       # get the value of it

        addi $t1, $t1, 1                    # table[str[i]] + 1

        add $t2, $a2, $s5
        sub $t2, $t2, $s2                   # len_pattern - 1 - j

        bgt $t1, $t2, not_update_2

    update_2:
        sub $t2, $a2, $t1                   # len_pattern - 1 - table[str]
        add $s1, $s1, $t2
        j end_update_2

    not_update_2:
        addi $s1, $s1, 1
    
    end_update_2:
        j while_1

    exit_w1:
        move $v0, $s3                       # return cnt
        lw $a0, 0($sp)                      # load len_str
        lw $a1, 4($sp)                      # load the address of str
        lw $a2, 8($sp)                      # load len_pattern
        lw $a3, 12($sp)                     # load address of pattern
        lw $ra, 16($sp)                     # load register
        addi $sp, $sp, 20
        jr $ra