# ###################################################
# Author:TX-Leo
# Tool Versions: Mars4_5 for Mips
# Create Date: 2022/05/04
# Project Name: Experiment_02_01_string_matching_bf.asm
# Source File: Experiment_02_01_string_matching_bf.c
# Description: It's TX-Leo's Experiment_02_01
# Function:Bruce-Force Algorithm
#  (1)   从目标串s的第一个字符起和模式串t的第一个字符进行比较，
#        若相等，则继续逐个比较后续字符，
#        否则从串s 的第二个字符起再重新和串t进行比较。
#  (2)   依此类推，直至串t中的每个字符依次和串s的一个连续的字符序列相等，
#        则称模式匹配成功，此时串t的第一个字符在串s中的位置就是t在s中的位置，
#        否则模式匹配不成功。
# ###################################################

.data
    str: .space 512
    pattern: .space 512
    filename: .asciiz "test.dat"

.text
    main:
        # fopen
        la $a0, filename                # load filename
        li $a1, 0                       # flag
        li $a2, 0                       # mode
        li $v0, 13                      # open file syscall index
        syscall

        # read str
        move $a0, $v0                   # load file description to $a0
        la $a1, str
        li $a2, 1
        li $s0, 0                       # len_pattern = 0

    read_str_entry:
        slti $t0, $s0, 512
        beqz $t0, read_str_exit
        li $v0, 14                      # read file syscall index
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
        li $s1, 0                       # len_pattern = 0
    
    read_pattern_entry:
        slti $t0, $s1, 512
        beqz $t0, read_pattern_exit
        li $v0, 14                      # read file syscall index
        syscall
        lb $t0, 0($a1)
        addi $t1, $zero, '\n'
        beq $t0, $t1, read_pattern_exit
        addi $a1, $a1, 1
        addi $s1, $s1, 1
        j read_pattern_entry
    
    read_pattern_exit:
        # close file
        li $v0, 16                      # close file syscall index
        syscall

        # call brute_force
        move $a0, $s0
        la $a1, str
        move $a2, $s1
        la $a3, pattern
        jal brute_force

        # printf
        move $a0, $v0
        li $v0, 1
        syscall
        # return 0
        li $a0, 0
        li $v0, 17
        syscall

    brute_force:
        # #push params and register into stack
        addi $sp, $sp, -20
        sw $a0, 0($sp)                  # store len_str
        sw $a1, 4($sp)                  # store the address of str
        sw $a2, 8($sp)                  # store len_pattern
        sw $a3, 12($sp)                 # store address of pattern
        sw $ra, 16($sp)                 # store register

        # initialize i, j and cnt
        li $t1, 0                       # i = 0
        li $t2, 0                       # j = 0
        li $t3, 0                       # cnt = 0
        sub $t4, $a0, $a2               # store len_str - len_pattern

    loop_i:
        bgt $t1, $t4, exit_loop_i   
        li $t2, 0                       # j = 0

    loop_j:
        beq $t2, $a2, exit_loop_j

        add $t5, $t1, $t2               # get i + j
        add $t5, $a1, $t5               # get the address of str[i + j]
        lb $t5, ($t5)                   # get the value of str[i + j]

        add $t6, $a3, $t2               # get the address of pattern[j]
        lb $t6, ($t6)                   # get the value of pattern[j]

        bne $t5, $t6, exit_loop_j

        addi $t2, $t2, 1
        j loop_j

    exit_loop_j:
        beq $t2, $a2, update            # if (j == len_pattern)
        j exit_update                   # else

    update:
        addi $t3, $t3, 1                # cnt += 1
    
    exit_update:

        addi $t1, $t1, 1                # i++
        j loop_i

    exit_loop_i:
        move $v0, $t3
        lw $a0, 0($sp)                  # load len_str
        lw $a1, 4($sp)                  # load the address of str
        lw $a2, 8($sp)                  # load len_pattern
        lw $a3, 12($sp)                 # load address of pattern
        lw $ra, 16($sp)                 # load register 
        addi $sp, $sp, 20               # recover the $sp stack
        jr $ra                          # go back to the main program