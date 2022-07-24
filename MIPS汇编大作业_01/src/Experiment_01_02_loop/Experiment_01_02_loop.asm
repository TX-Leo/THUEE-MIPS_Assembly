# ###################################################
# Author:TX-Leo
# Tool Versions: Mars4_5 for Mips
# Create Date: 2022/05/01
# Project Name: Experiment_01_02_loop.asm
# Source File: Experiment_01_01_loop.cpp
# Description: It's TX-Leo's Experiment_01_02
# Function:
# （1）  将输入值取绝对值，存在变量i，j中
#  (2)   从变量i开始，循环j轮，每轮i = i+1
# ###################################################

.text # 代码段
    main: 
    # 主函数
        # 输入i并且保存至s0
        li $v0, 5                      # 5代表输入一个整数
        syscall
        move $s0, $v0                  # 保存i至s0

        # 输入j并且保存至s1
        li $v0, 5                      # 5代表输入一个整数
        syscall
        move $s1, $v0                  # 保存j至s1

    check_i: 
    # 检查i
        # 获得i的绝对值
        slt $t0, $s0, $zero            # t0 = (i<0),获得临时变量t0
        beq $t0, $zero, check_j        # if i>=0, 检查j
        sub $s0, $s=zero, $s0          # if i<0,i=-i
        j check_j                      # 开始检查j
    
    check_j: 
    # 检查j
        # 获得j的绝对值
        slt $t0, $s1, $zero            # t0 = (j<0),获得临时变量t0
        beq $t0, $zero, loop_start     # if j>=0, 继续
        sub $s1, $sero, $s1            # if j<0,j=-j
        j loop_start                   # 开始循环
    
    loop_start:
    # loop_start
        li $t0 0                       # 临时变量temp = 0

    loop:
    # loop
        addi $s0, $s0, 1               # i++
        addi $t0, $t0, 1               # temp++
        blt $t0, $s1, loop             # if temp < j, 继续循环

    print: 
    # print
        li $v0, 1                      # 1是打印整数的标识
        move $a0, $s0                  # 将整数存到a0中
        syscall 