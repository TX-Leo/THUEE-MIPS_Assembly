# ###################################################
# Author:TX-Leo
# Tool Versions: Mars4_5 for Mips
# Create Date: 2022/05/01
# Project Name: Experiment_01_04_hanoi.asm
# Source File: Experiment_01_04_hanoi.cpp
# Description: It's TX-Leo's Experiment_01_04
# Function:
# （1）  汉诺塔问题：输入n
# （2）  递推公式： Hanoi(n) = 2 * Hanoi(n - 1) + 1
# ###################################################
.data
    string_1: .asciiz "please input n:"
.text 
    main:
    # input demonstration
        li $v0, 4              # 4代表打印字符串
        la $a0, string_1       # "please input n:"
        syscall

    input_n:
    # input n
        li $v0, 5              # 5代表输入一个整数
        syscall
        move $a0, $v0          # 保存n在a0
    
    output_result:
    # output result from hanoi
        jal hanoi              # 跳到hanoi并且和hanoi连接起来
        move $a0, $v0          # 将参数放入a0
        li $v0, 1              # 1代表打印整数
        syscall

        li $v0, 10             # 10代表换行符'\n'
        syscall
    hanoi:
    # hanoi
        li $t0, 1              # t0置为1
        bne $t0, $a0, next     # if a0(输入的n)!=1, 进入循环next
        li $v0, 1              # 1代表打印整数
        jr $ra                 # 跳回上一级程序(ra 为返回地址)
    next:
    # next
        addi $sp, $sp, -8       # 移动堆栈指针
        sw $a0, 0($sp)          # 保存 basic param
        sw $ra, 4($sp)          # 保存寄存器地址

        addi $a0, $a0, -1       # 更新参数（n-1）
        jal hanoi               # 跳到hanoi并且和hanoi连接起来(Hanoi(n - 1))
        
        li $s1, 1               

        add $s1, $v0, $s1
        add $s1, $v0, $s1
        move $v0, $s1           # return 2 * Hanoi(n - 1) + 1

        lw $a0, 0($sp)          # 更新参数
        lw $ra, 4($sp)          # 更新寄存器地址
        addi $sp, $sp, 8        # 更新堆栈指针

        jr $ra                  # 跳回上一级程序(ra 为返回地址)

