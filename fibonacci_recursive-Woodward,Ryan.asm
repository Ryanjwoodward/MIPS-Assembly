#***************************************************************************************************************
#	Author: 		Ryan Woodward
#	Class: 			CST307 - Dr. Ricardo Citro
#	Date: 			7/20/2022
#	Assignment: 	Procedures and Stack Management
#	Program: 		fibonacci_recursive-Woodward,Ryan.asm
#	Description: 		A program that emulates the fibonacci formula to produce a fibonacci value.
#*****************************************************************************************************************


#-----------------------------------------------------------------------------
#.text Section - main:
#-----------------------------------------------------------------------------
.text
main:

	la $a0,queryUser 	            # loads the variable 'queryUser' into register $a0

	li $v0,4                        # passing value 4 is the service code to print
                                    # when this is executed this will print 'queryUser' to the console

	syscall                         # system call to execute above command(s)

	li $v0,5                        # passing value 5 is the service code to read the integer
                                    # contained in the register

	syscall                         # system call to execute above command(s)

	move $t2,$v0                    # move opcode copies the value stored in $v0, at this point
                                    # it is the user entered value from queryUser

	move $a0,$t2                    # copies, 'moves' the value store in register $t2 into
                                    # register $a0 which will be used for display later

	move $v0,$t2                    # copies, 'moves' the value in $t2 into register $v0

	jal fibonacciFormula            # jump-and-link opcode has program jump to subroutine 
                                    # called 'fibonacciFormula

	move $t3,$v0                    # copies, 'moves', the value stored in $v0. Which, after the
                                    # fibonacciFormula subroutine contains the next value in the sequence
                                    # of the fibonacci sequence

	la $a0,printResult              # loads the address of variable 'printResult' into register $a0

	li $v0,4                        # passing value 4 is the service code to print
                                    # when this is executed this will print 'queryUser' to the console

	syscall                         # system call to execute above command(s)

	move $a0,$t2                    # copies, 'moves' the value stored in $t2 to $a0 to be 
                                    # used as an argument. At this point $t2 holds the user
                                    # entered value. And the recursion through fibonacciFormula
                                    # subroutine is complete.

	li $v0,1                        # passing value '1' to $v0 is the service code to load an
                                    # integer so it can be printed to console

	syscall                         # system call to execute above command(s)

	la $a0,printResultFill          # loads the address of the variable 'printResultFill' into
                                    # register so it can be called and displayed to console

	li $v0,4                        # passing value '4' to $v0 is service code to print strings

	syscall                         # system call to execute above command(s)

	move $a0,$t3                    # copies, 'moves' the value in $t3 into register $a0
                                    # this is to prepare to print the integer stored in $t3

	li $v0,1                        # passing '1' to $v0 is the service code to print integers

	syscall                         # system call to execute above command(s)

	li $v0,10                       # passing value '10' is the service code to print a character

	syscall                         # system call to execute above command(s)

#---------------------------------------------------------------------------
#.text Section - Subroutines
#---------------------------------------------------------------------------

#----------------------------------------------------
# fibonacciFormula subroutine
#----------------------------------------------------
# This subroutine is accessed to process the user entered
# value, from above, and recursively calculate the
# value of the fibonacci sequence associated with
# the user entered value.
#
# Fibonacci Formula: Fn = Fn -1 + Fn - 2
# example of expected outputs:
#   F7 = 13, F10 = 55, F20 = 6765, F30 = 832040
#----------------------------------------------------
fibonacciFormula:

	beqz $a0,ifValIsZero 			# branch-if-equal-to-zero, this opcode reads the value stored in
                                    # in $a0, which at this point is the initial user entered value
                                    # if the value is equal to zero the program jumps to the 
                                    # 'ifValIsZero subroutine' - which prints 0 to console

	beq $a0,1,ifValIsOne 		    # branch-if-equal-to, this opcode reads the value store in $a0,
                                    # which at this point is the initial user entered value. If the value
                                    # is equal to 1 the program jumps to the 'ifValIsOne' subroutine
                                    # which prints 1 to the console for final result

	sub $sp,$sp,4 					# $sp is the 'stack pointer' register, '4' is the service code to 
                                    # store an address. This line subtracts and stores the address 
                                    # in the stack pointer register

	sw $ra,0($sp)                   # $ra is the return-address register, this line stores the word (sw)
                                    # contained at this point in the stack

	sub $a0,$a0,1 					# This line represents the first operator in the fibonacci formula,
                                    # the value, previously stored in $a0, is being subtracted by 1
                                    # i.e. (n - 1)

	jal fibonacciFormula 			# jump-and-link, this is a recursive jump to the fibonacciFormula subr
                                    # for the first operation of the fibonacci formula

	add $a0,$a0,1                   # adds the value 1 to the values stored in $a0

	lw $ra,0($sp) 					# load word, gets the address from the return-address register

	add $sp,$sp,4                   # $sp is the 'stack pointer' register, '4' is the service code to 
                                    # store an address. This line adds and stores the address 
                                    # in the stack pointer register

	sub $sp,$sp,4 				    # $sp is the 'stack pointer' register, '4' is the service code to 
                                    # store an address. This line subs and stores the address 
                                    # in the stack pointer register

	sw $v0,0($sp)                   # store-word opcode into register $v0


	sub $sp,$sp,4                   # $sp is the 'stack pointer' register, '4' is the service code to 
                                    # store an address. This line adds and stores the address 
                                    # in the stack pointer register

	sw $ra,0($sp)                   # store word opcode, gets the address from the return-address register

	sub $a0,$a0,2                   # This line represents the second operator in the fibonacci formula,
                                    # the value, previously stored in $a0, is being subtracted by 2
                                    # i.e. (n - 2)

	jal fibonacciFormula            # jump-and-link, this is a recursive jump to the fibonacciFormula subr
                                    # for the second operation of the fibnacci formula

	add $a0,$a0,2                   # adds the value 2 to the values stored in $a0

	lw $ra,0($sp)                   # load word, gets the address from the return-address register, essentially
                                    # getting the stack's address

	add $sp,$sp,4                   # $sp is the 'stack pointer' register, '4' is the service code to 
                                    # store an address. This line adds and stores the address 
                                    # in the stack pointer register
	
	lw $s7,0($sp)                   # load word opcode, gets the end result value from the stack and stores it in #s7

	add $sp,$sp,4                   # $sp is the 'stack pointer' register, '4' is the service code to 
                                    # store an address. This line adds and stores the address 
                                    # in the stack pointer register

	add $v0,$s7,$v0                 # this line links the first and second operations of the fibonacci sequence and stores
                                    # the in $v0

	jr $ra                          # jump register opcode has the program jump to the resturn address which will be the 
                                    # the jump and link  (jal) opcode in the main:  part of .text

#-------------------------------------------------
# ifValIsOne subroutine
#-------------------------------------------------
# When accessed this function loads '1' into the
# register and jumps to end of program. This will
# only be accessed if the user enters '1'
#-------------------------------------------------
ifValIsOne:

	li $v0,1                        # this loads the value '1' into the register so it can be printed

	jr $ra                          # returns the portion of main: at the jump with '1' in $v0 so 
                                    # that will be printed if the user entered 1


#-------------------------------------------------
# ifValIsZero subroutine
#-------------------------------------------------
# When accessed this subroutine loads '0' into the 
# the register and jumps to the end of the program.
# This will only be accessed if the user enters '0'
#-------------------------------------------------
ifValIsZero:

	li $v0,0                        # this loads the value '1' into the register so it can be printed

	jr $ra                          # returns the portion of main: at the jump with '1' in $v0 so 
                                    # that will be printed if the user entered 1

#-------------------------------------------------------------------------------------------------------
#.data Section
#-------------------------------------------------------------------------------------------------------

.data

	queryUser: .asciiz "Enter a value: "                # string used to query the user for integer imput

	printResult: .asciiz "Fibonacci Value for "         # string -portion to be printed once the recursive
                                                        # fibonacci formula is finished executing

	printResultFill: .asciiz " is "                     # final poriton of result displying strings

#--------------------------------------------------------------------------------------------------------

#----------------------------------------------* END *---------------------------------------------------






