# ###################################################
# Author:TX-Leo
# Tool Versions: Mars4_5 for Mips
# Create Date: 2022/05/01
# Project Name: Experiment_01_01_syscall.asm
# Source File: Experiment_01_01_syscall.cpp
# Description: It's TX-Leo's Experiment_01_01
# Function:
#  (1)   申请一个8byte整数的内存空间。
#  (2)   从“a.in”读取两个整数。
#  (3)   向”a.out”写入这两个整数。
#  (4)   从键盘输入一个整数i。
#  (5)   i = i +1。
#  (6)   向屏幕打印这个整数
# ###################################################

.data # 数据段
    input_file: .asciiz "Experiment_01_01_syscall.in"  # 表示字符串，其中asciiz会自动在最后补上null字符
    output_file: .asciiz "Experiment_01_01_syscall.out"
    buffer_1: .space 4                                 # .space表示一个以byte计长度的数组
    buffer_2: .sapce 4

.text # 代码段
    open_file_for_reading:
        # Open "Experiment_01_01_syscall.in" for reading
        li $v0, 13                                     # 13为打开文件的syscall编号
        la $a0, input_file                             # input_file是一个字符串
        li $a1, 0                                      # flag 0为读取，1为写入
        li $a2, 0                                      # mode is ignored 设置为0就可以了
        syscall                                        # 如果文件打开成功，文件描述符返回到v0
        move $a0, $v0                                  # 将文件描述符载入到$a0中

        # Read integer_01 from "Experiment_01_01_syscall.in"
        li $v0, 14                                     # 14为读取文件的syscall编号
        la $a1, buffer_1                               # buffer_1为数据暂存区
        li $a2, 4                                      # 读取4个byte
        syscall

        # Read integer_02 from "Experiment_01_01_syscall.in"
        li $v0, 14                                     # 14为读取文件的syscall编号
        la $a1, buffer_2                               # buffer_2为数据暂存区
        li $a2, 4                                      # 读取4个byte
        syscall

        # Close "Experiment_01_01_syscall.in"
        li $v0, 16                                     # 16是关闭文件的syscall编号
        syscall

    open_file_for_writing:
        # Open "Experiment_01_01_syscall.out" for writing
        li $v0, 13                                     # 13为打开文件的syscall编号
        la $a0, output_file                            # output_file是一个字符串
        li $a1, 1                                      # flag 0为读取，1为写入
        li $a2, 0                                      # mode is ignored 设置为0就可以了
        syscall
        move $a0, $v0                                  # 将文件描述符载入到$a0中

        # Write interger_01 in "Experiment_01_01_syscall.out"
        li $v0, 15                                     # 15是写入文件的syscall编号
        la $a1, buffer_1                               # buffer_1为数据暂存区
        li $a2, 4                                      # 写入4个byte
        syscall

        # Write interger_02 in "Experiment_01_01_syscall.out"
        li $v0, 15                                     # 15是写入文件的syscall编号
        la $a1, buffer_2                               # buffer_2为数据暂存区
        li $a2, 4                                      # 写入4个byte
        syscall

        # Close "Experiment_01_01_syscall.out"
        li $v0, 16                                     # 16是关闭文件的syscall编号
        syscall
    input:
        # Input an integer by keyboard
        li $v0 5                                       # 5代表输入一个整数
        syscall                                        # 等待输入一个整数
    add:
        # i = i + 1
        addi $t0, $v0, 1

    print:
        # Print the integer
        li $v0, 1                                      # 1代表打印整数
        move $a0, $t0                                  # 将整数存到a0中
        syscall

