#***************************************************************************************************************
#	Author: 		Ryan Woodward
#	Class: 			CST307 - Dr. Ricardo Citro
#	Date: 			7/20/2022
#	Assignment: 	Procedures and Stack Management
#	Program: 		recursive sum of numbers -Woodward,Ryan.asm
#	Description: 		A program that accepts an input compares it and adds 
#*****************************************************************************************************************
#This code is largely appropriated from push-pop.asm file provided by Dr. Citro
#*****************************************************************************************************************

#-----------------------------------------------------------------------------
#.text Section - main:
#-----------------------------------------------------------------------------
.text
main:

        la $t0, numArray        # loads the array's start address into register $t0

        li $t1, 0               # loop index, begins at 0, loaded into register $t1

        lw $t2, arrLength       # length of loop (var) loaded into register $t2

        jal pushArrToStack

#---------------------------------------------------------------------------
#.text Section - Subroutines
#---------------------------------------------------------------------------

#-------------------------------------------
# pushArrToStack subroutine
#-------------------------------------------
# When accessed this is used to push the array
# of numbers to the stack. Upon the loop's
# termination the program continues to the next
# subroutine
#-------------------------------------------

pushArrToStack:

        lw $t4 ($t0)            # loads the array address into $t4

        move $a0, $t4           # copies 'moves' the array address to $a0

        subu $sp, $sp 4         # push array[i] to stack

        sw $t4, ($sp)           

        add $t1, $t1, 1         # increment the index, stored in $t1

        add $t0, $t0, 4         # update the array address

        blt $t1, $t2, pushArrToStack      # branch-on-less-than, 

        la $t0, numArray        # get the array starting address, stores in $t0

        li $t1, 0               # sets our loop index back to 0  stored in $t1

#-------------------------------------------
# popTwoToAdd subroutine
#-------------------------------------------
# When accesses this subroutine will pop two
# values from the stack and then add them and
# display the sum to the console and repeat until
# each pair of values in the array has been added
#-------------------------------------------

popTwoToAdd:   

        #----------------------------------
        # First portion is to pop and store the first value from stack

        lw $t4, ($sp)           # loads the array, from stack, to register $t4

        move $t5, $t4           # *** Should copy the contents of $t4 the current index of the
                                # the array to $t5

        addu $sp, $sp, 4        # should pop the current value of the array

        sw $t4, ($t0)           # sets the array, stored in $t0, to it

        add $t1, $t1, 1         # increments the index

        add $t0, $t0, 4         # updates the array address

        #----------------------------------
        #second portion is to pop and store the second value from stack

        lw $t4, ($sp)           # loads the array, from the stack, to register $t4

        move $t6, $t4           # *** Should copy the contents of $t4 the current index of the
                                # the array to $t6

        addu $sp, $sp, 4        # should pop the current value of the array
      
        sw $t4, ($t0)           # sets the array, stored in $t0, to it

        add $t1, $t1, 1         # increments the index

        add $t0, $t0, 4         # updates the array address

        #----------------------------------
        # third portion adds the two numbers popped from the stack
        # and displays the result, then branches back to start of subroutine

        add $t7, $t6, $t5       # should add the two values popped from the stack
        
        la $a0, statement       # loads address of variable for printing

        li $v0, 4               # 4 is service code to print string

        syscall                 # system call to execute above statement(s)
       
        move $a0, $t7           # loads the address of the sum of the two values for printing

        li $v0, 1               # 1 is service code to print integer

        syscall                 # system call to execute above statement(s)

        la $a0, newLine         # loads address of variable to register for printing

        li, $v0, 4              # 4 is service code to print string

        syscall                  # system call to execute above statement(s)

        blt $t1, $t2, popTwoToAdd    # branch-less-than, branches to beginning of subroutine
                                     # if index < length   

        li $v0, 10              # 10 is service code to terminate program

        syscall                 # system call to execute above statement(s)

#-------------------------------------------------------------------------------------------------------
#.data Section
#-------------------------------------------------------------------------------------------------------
.data

        numArray: .word 100, 32, 75, 115, 42, 82           # is pushed and popped from the stack
        
        arrLength: .word 6                                             # variable to hold the length of the array
                                                                        # for indexing purposes

        statement: .asciiz "Current Sum: "                              # string variable used in displaying the sum
                                                                        # of the two numbers popped from the stack

        newLine: .asciiz "\n"                                           # string variable, just for escape character in
                                                                        # making the display on console look nice

#--------------------------------------------------------------------------------------------------------

#----------------------------------------------* END *---------------------------------------------------

