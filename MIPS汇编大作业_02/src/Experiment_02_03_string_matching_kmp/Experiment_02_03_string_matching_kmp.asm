# ###################################################
# Author:TX-Leo
# Tool Versions: Mars4_5 for Mips
# Create Date: 2022/05/04
# Project Name: Experiment_02_03_string_matching_kmp.asm
# Source File: Experiment_02_03_string_matching_kmp.c
# Description: It's TX-Leo's Experiment_02_03
# Function:KMP Algorithm
#  (1)next[]数组和索引数组的初始化
#       1.索引数组从0开始
#       2.next[]数组：表示下标为i的字符前的字符串最长相等前后缀的长度(next[0]=-1)
#  (2)开始匹配
#       1.找到未匹配的字符
#       2.找到索引为未匹配的字符对应的next的字符,移动到这个未匹配的位置
#       3.若第一个字符就出现了不同,那就直接往后移动一个
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
        jal kmp

        # printf
        move $a0, $v0
        li $v0, 1
        syscall
        # return 0
        li $a0, 0
        li $v0, 17
        syscall

    kmp:
        # #push params and register into stack
        addi $sp, $sp, -20
        sw $a0, 0($sp)                  # store len_str
        sw $a1, 4($sp)                  # store the address of str
        sw $a2, 8($sp)                  # store len_pattern
        sw $a3, 12($sp)                 # store address of pattern
        sw $ra, 16($sp)                 # store register

        li $s1, 0                       # i = 0
        li $s2, 0                       # j = 0
        li $s3, 0                       # cnt = 0

        # dynamic memory allocation
        mul $a0, $a2, 16                # offset for len_pattern * 4
        li $v0, 9
        syscall

        move $a0, $v0                   # put *next in $a0
        move $a1, $a2                   # put len_pattern in $a1
        move $a2, $a3                   # put *pattern in $a2

        jal genNext

        move $s0, $a0                   # put *next in $s0
        lw $a0, 0($sp)                  # reload len_str
        lw $a1, 4($sp)                  # reload *str
        lw $a2, 8($sp)                  # reload len_pattern
        lw $a3, 12($sp)                 # reload *pattern

    while_k:
        # i >= len_str, return
        bge $s1, $a0, return_k

        add $t1, $a3, $s2               # addr of pattern[j]
        lb $t1, ($t1)                   # value of pattern[j]

        add $t2, $a1, $s1               # addr of str[i]
        lb $t2, ($t2)                   # value of str[i]

        # pattern[j] != str[i], else
        bne $t1, $t2, else1        
        addi $t1, $a2, -1               # len_pattern - 1

        # j != len_pattern - 1, else
        bne $t1, $s2, else2

        addi $s3, $s3, 1                # cnt++
        mul $t0, $t1, 4                 # offset
        add $t0, $t0, $s0               # addr of next[len_pattern - 1]
        lw $s2, ($t0)                   # j = next[len_pattern - 1]
        addi $s1, $s1, 1
        j while_k

    else2:
        addi $s1, $s1, 1                # i++
        addi $s2, $s2, 1                # j++
        j while_k

    else1:
        # j > 0
        bgt $s2, $zero, update
        j not_update

    update:
        addi $t1, $s2, -1               # j - 1
        mul $t0, $t1, 4
        add $t0, $s0, $t0               # addr of next[j - 1]
        lw $s2, ($t0)                   # j = next[j - 1]
        j while_k

    not_update:
        addi $s1, $s1, 1                # i++
        j while_k

    return_k:
        move $v0, $s3                   # return cnt
        lw $a0, 0($sp)                  # load len_str
        lw $a1, 4($sp)                  # load the address of str
        lw $a2, 8($sp)                  # load len_pattern
        lw $a3, 12($sp)                 # load address of pattern
        lw $ra, 16($sp)                 # load register

        jr $ra

    genNext:
        addi $sp, $sp, -24
        sw $a0, 0($sp)                  # store *next
        sw $a1, 4($sp)                  # store len_pattern
        sw $a2, 8($sp)                  # store *pattern
        sw $s1, 12($sp)                 # store i
        sw $s2, 16($sp)                 # store j
        sw $ra, 20($sp)                 # store register

        li $s1, 1                       # i = 1
        li $s2, 0                       # j = 0
        beqz $a1, final

        sw $zero, 0($a0)                # next[0] = 0

    while:
        # i >= len_pattern, jump to end
        bge $s1, $a1, end
        
        add $t1, $a2, $s1               # addr of pattern[i]
        lb $t1, ($t1)                   # value of pattern[i]

        add $t2, $a2, $s2               # addr of pattern[j]
        lb $t2, ($t2)                   # value of pattern[j]

        bne $t1, $t2, elseif
        mul $t0, $s1, 4                 # offset
        add $t0, $a0, $t0               # addr of next[i]
        addi $t1, $s2, 1                # j + 1
        sw $t1, ($t0)                   # next[i] = j + 1
        addi $s1, $s1, 1                # i++
        addi $s2, $s2, 1                # j++
        j while
    
    elseif:
        # j <= 0, jump to else 
        ble $s2, $zero, else    
        subi $t0, $s2, 1                # j - 1
        mul $t0, $t0, 4                 # offset
        add $t0, $a0, $t0               # addr of next[j - 1]
        lw $s2, ($t0)                   # j = next[j - 1]
        j while

    else:
        mul $t0, $s1, 4
        add $t0, $a0, $t0               # the addr of next[i]
        addi $s1, $s1, 1                # i++
        j while   

    end:
        li $v0, 0                       # return 0
        j return

    final:
        li $v0, 1                       # return 1

    return:
        lw $a0, 0($sp)                  # load *next
        lw $a1, 4($sp)                  # load len_pattern
        lw $a2, 8($sp)                  # load *pattern
        lw $s1, 12($sp)                 # load i
        lw $s2, 16($sp)                 # load j
        lw $ra, 20($sp)                 # load register

        addi $sp, $sp, 24
        jr $ra