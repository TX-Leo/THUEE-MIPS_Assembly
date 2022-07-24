# ###################################################
# Author:TX-Leo
# Tool Versions: Mars4_5 for Mips
# Create Date: 2022/05/01
# Project Name: Experiment_01_03_array.asm
# Source File: Experiment_01_03_array.cpp
# Description: It's TX-Leo's Experiment_01_03
# Function:
# （1）  输入数组a的长度n
#  (2)   任意输入n个整数
#  (3)   将数组a逆序，并且仍然存储在a中
#  (4)   打印数组a的值
# ###################################################

.data # 数据段
    string_1: .asciiz "please input the length of the array:\n"
    string_2: .asciiz "please input a["
    string_3: .asciiz "]:"
    string_space: " "

.text # 代码段
    input_demonstration:
    # print input demonstration
        li $v0 ,4                   # 4代表打印字符串
        la $a0, string_1            # "please input the length of the array:\n"
        syscall
    input_array_length:
    # input the length of the array
        li $v0, 5                   # 5代表输入一个整数（数组的长度）
        syscall
        move $s0, $v0               # 保存整数至s0
    create_array:
    # get dynamic memory allocation
        mul $t0, $v0, 4             # get max_offset  t0=v0*4是max_offset
        move $a0, $t0               # 保存数组的大小size
        li $v0, 9                   # 
        syscall

        move $s1, $v0               # 将动态内存的地址放在s1
        li $t1, 0                   # 将寄存器t1的值置为0（t1是现在的offset）
        
        li $t8, 0                   # temp
    input_array:
    # input and save n integers
        bge $t1, $t0, end_input     # if offset>=max_offset, 输入结束
        # input demonstration
        li $v0, 4                   # 4代表打印字符串
        la $a0, string_2            # "please input a["
        syscall
        
        li $v0, 1                   # 1是打印整数的标识
        move $a0, $t8             # 将整数存到a0中
        syscall

        li $v0, 4                   # 4代表打印字符串
        la $a0, string_3            # "]"
        syscall

        li $v0, 5                   # 5代表输入一个整数
        syscall

        add $t3, $t1, $s1           # a[i]的地址 t3=t1+s1
        sw $v0, ($t3)               # 给a[i]赋值 {v0：(输入的整数)，t3:(a[i]的地址)}

        addi $t1, $t1, 4            # 更新offset
        addi $t8, $t8, 1            # temp++
        j input_array               # 循环input 
    
    end_input:
    # end input
        mul $t4, $s0, 2             # 
        li $t1, 0                   # 更新现在的offset为0                         

    reverse_array:
    # reverse the array 
        bge $t1, $t4, end_reverse   # offset >= 2 * n, jump to end (equal to "i < n / 2")
        add $t3, $t1, $s1           # addr of a[i]
        lw $t5, ($t3)               # value of a[i]
        sub $t6, $t0, $t1           
        addi $t6, $t6, -4           # offset of a[n - i - 1]
        add $t6, $t6, $s1           # addr of a[n - i - 1]
        lw $t7, ($t6)               # value of a[n - i - 1]
        sw $t5, ($t6)               
        sw $t7, ($t3)               # exchange both values in both addrs
        addi $t1, $t1, 4            # update offset
        j reverse_array

    end_reverse:
    # end reverse array
         li $t1, 0                   # 更新offset = 0

    print:
    # print
        bge $t1, $t0, end           # if offset >= max_offset, then over
        add $t3, $t1, $s1           
        lw $a0, ($t3)               # value of a[i]
        li $v0, 1               
        syscall                     # print a[i]

        # print one space
        li $v0, 4
        la $a0, string_space        
        syscall 

        addi $t1, $t1, 4            # update offset
        j print
    end:
    # end
