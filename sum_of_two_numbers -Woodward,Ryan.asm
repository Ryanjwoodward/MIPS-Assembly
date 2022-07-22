#-----------------------------------------------------------
#Author: Ryan Woodward
#Class: CST-307 w/ Dr. Ricardo Citro
#Date: 7/8/2022
#Assignment: Memory Cache Simulator and MIPS Assembly
#File: sum_of_two_numbers-Woodward,Ryan.asm
#Program Description: Basic Assembly that Adds two numbers a prints the sum to the console.
#-------------------------------------------------------------
.text
.globl main

main:				#main, lets QtSpim know where to execute the jar main
	li $v0, 5		#loads user entered value into register $v0, five is command for input
	syscall			#system call to execute previous intruction
	move $t0, $v0		#moves data from $v0 to register $t0
	li $v0, 5		#loads second user entered value into register $v0
	syscall			#system call to execute previous instructions 
	move $t1, $v0		#moves the user entered value into $t1
	add $t2, $t0, $t1	#conducts a addition operation on registers $t1 and $t0
				#results (sum) are stored in register $t2
	move $a0, $t2		#moves the sum, stored in $t2, into address register $a0 so it can be printed
	li $v0, 1		#loads value 1 into $v0, 1 is command to print to console
	syscall			#system call to execute the above instructions