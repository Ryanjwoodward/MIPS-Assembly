#***************************************************************************************************************
#	Author: 		Ryan Woodward
#	Class: 			CST307 - Dr. Ricardo Citro
#	Date: 			7/13/2022
#	Assignment: 	I/O System Design Tool and MIPS Assembly
#	Program: 		palindrome-Woodward,Ryan.asm
#	Description: 	An ASM program that accepts user input for a string and loops through the entered string and compares individual
#					characters to see if the entered string is a palindrome
#*****************************************************************************************************************

#-----------------------------------------------------------------------------
#.text Section - main:
#-----------------------------------------------------------------------------
.text

main:

	la $a0, greeting 		# loads the variable 'greeting' in register $a0

	li $v0, 4			# passing value 4 is the service code to print
					# when this is executed it will print 'greeting' to the console

	syscall				# system call to execute the previous commands

	la $a0, userInputStr 		# loads the variable 'userInputStr' to register
					# this prompts the user to enter a string

	li $a1, 50			# pass 50 to the address is the confirm dialog service
					# which will pass the message to the user

	li $v0, 8			# call the input buffer to obtain the input from the user

	syscall 			# system call to execute above command(s)

#---------------------------------------------------------------------------
#.text Section - Subroutines
#---------------------------------------------------------------------------

#----------------------------------------------------
#setupReverseStr subroutine
#----------------------------------------------------

# This is called to setup the reverse string
# of the user's for interative comparisons

#---------------------------------------------------- 

setupReverseStr:

	la $t1, reverseUsrStr		# loads the address of the variable 'reverseUsrStr' to the register for later use

#----------------------------------------------------
# strPrepLoop subroutine
#----------------------------------------------------

# When this is called it runs a couple other subs for
# preparing the the string for comparisons and initial
# error checking

#----------------------------------------------------  

strPrepLoop:								

	lb $t7, ($a0)			# this opcode is to copy the byte in one register into another, 
					# at this point $a0 should hold the address of the current char/index in the string

	beq $t7, 10, checkStr 		# when the values contained between the compared string are equal this branches to another subroutine				
	
	bgt $t7, 47, strTest		# this opcode will branch on a greater than comparison to the serial testing of the character in the strings							

	j inputCheck			# when this is executed this jumps to subroutine that validate the input string


#---------------------------------------------------
#NOTE:  the three test subroutines are implemented as 
#if-else statements to compare the values between 
#the string represented by each of the characters

#----------------------------------------------------
#	strTest subroutine
#----------------------------------------------------

# When this is accessed it uses message dialog service
# and checks less than, greater, than or jumps to check
# the inputted String

#----------------------------------------------------  
strTest: 
	
	blt $t7, 58, addChar		# branch less than, will go to the addChar subr where the index of the current character is added for comparison 

	bgt $t7, 64, strTest2		# branch greater than, branches to the second test to compare the indices/char in the string

	j inputCheck			# if this is reached the program jumps to subroutine that validates the input string

#----------------------------------------------------
#	strTest2 subroutine
#----------------------------------------------------

# When this is accessed it uses message dialog service
# and checks less than, greater, than or jumps to check
# the inputted String, this is step 2 in testing

#----------------------------------------------------  
strTest2: 
	
	blt $t7, 91, addChar 		# branch less than, will go to the addChar subr where the index of the current character is added for comparison

	bgt $t7, 96, strTest3		# branch greater than, branches to the second test to compare the indices/char in the string

	j inputCheck			# if this is reached the program jumps to subroutine that validates the input string

#----------------------------------------------------
#	strTest3 subroutine
#----------------------------------------------------

# When this is accessed it uses message dialog service
# and checks less than or jumps to check
# the inputted String. This is step 3 in testing

#----------------------------------------------------  

strTest3: 

	blt $t7, 123, addChar		# branch less than, will go to the addChar subr where the index of the current character is added for comparison

	j inputCheck			# if this is reached the program jumps to subroutine that validates the input string

#----------------------------------------------------
#addChar subroutine
#----------------------------------------------------

# This is accessed to store the characters in the
# holder register

#----------------------------------------------------  

addChar: 

	bgt $t7, 96, charToUpperCase	# compares the values and then runs a call to subroutine to store the new char
					# to prep for the jump to compare

	j checkCharIndex		# jumps to subroutine checkCharIndex

#----------------------------------------------------
# charToUpperCase subroutine
#----------------------------------------------------

# When this is accessed the registers compres $t7 are used
# to get the value of the capital letter version of the character
# this is to avoid case-sensitivity

#---------------------------------------------------- 

charToUpperCase: 

	addi $t7, $t7, -32 		# this addition changes the value of the char to it's capital-case version

#----------------------------------------------------
# checkCharIndex subroutine
#----------------------------------------------------

# When this is called it increments the index at the
# location and then moves to continue preparing string
# for comparison

#---------------------------------------------------- 

checkCharIndex:		

	sb $t7, ($t1)			# store byte opcode transfers the byte between registers
					# this is to prepare for incremental comparsion between characters
					# of the entered string and it's reverse

	addi $a0, $a0, 1 		# addition that increments the values in the register

	addi $t1, $t1, 1 		# addition that increments the values in the register

	j strPrepLoop                   # jumps to strPrepLoop, for further preparation of the string for further
					#comparisons between its indices/chars               


#----------------------------------------------------
# inputCheck subroutine
#----------------------------------------------------

# When this is called it increments the input and jumps
# back to the prep loop for checking of the inputted
# string

#----------------------------------------------------  

inputCheck: 		

	addi $a0, $a0, 1 		# increments the values in the registers

	j strPrepLoop 			# jumps to the subroutine to prep the values/char at that incremented address							

#----------------------------------------------------
# checkStr subroutine
#----------------------------------------------------

# When this is accessed, this is where comparisons
# of matching indices are handled then passed so
# the next iteration in the loop proceeds

#----------------------------------------------------   

checkStr:

	la $t4, reverseUsrStr  		# loads the variable 'reverseUsrStr' into the register

	sb $zero, ($a0)			# stored the byte, $zero (0) into $a0, essentially a reset for loop

	addi $t1, $t1, -1 		# decrements the value in $t1, for tracking indices

#----------------------------------------------------
# compareStrLoop subroutine
#----------------------------------------------------

# When this is called this will 'loop' to compare the
# user entered string and the reversed string icrementally
# by index

#----------------------------------------------------  

compareStrLoop: 

	lb $t3, ($t4)			# copies (loads bytes) fro the register on the right to the one on the left, used for maintain addresses of the characters

	lb $t2, ($t1)			# copies (loads bytes) fro the register on the right to the one on the left, used for maintain addresses of the characters

	beq $t3, $t2, step 		# compares teh addresses (bytes) and will take next 'step' if they are equal, 		

	j negativePalindrome 		# if this is accessed, because the line above proves untrue, the program jumps to where the user is informed the word is
					# not a palindrome			

#----------------------------------------------------
# step subroutine
#----------------------------------------------------

# When this is accessed it first checks the positions
# of the index of the current character then compares
# the character to the character in the reverse string
# This is called as the next step after each comparison

#---------------------------------------------------- 

step: 

	jal findIndex 					# this jump goes to the findIndex subr to check that the lastbyte of the string has been reached

	addi $t4, $t4, 1 #add 1 to $t4			# increments the value in $t4 

	addi $t1, $t1, -1 #sub 1 from $t1		# decrements the value in $t1

	j compareStrLoop 				# jumps to the loop for continuation to next iteration	

	j negativePalindrome				# this jump, if accessed will go to print that the string is not a palindrome																

#----------------------------------------------------
# findIndex subroutine
#----------------------------------------------------

# When this is called it will first check if the str, 
# so far is a palindrome and then proceed to find more
# characters to verify if the string is a palindrome

#---------------------------------------------------- 

findIndex:

	beq $t4, $t1, confirmedPalindrome		# this line will branch when these values are the same, this should be the final index
							# of charactet of the string, this will branch to the subroutine to print that the string 
							# has been verified to be a palindrome

	addi $t1, $t1, -1				#decrements 1 from the value the register holds to check the position,in next line

	beq $t4, $t1, confirmedPalindrome 		# this line check if there is any more characters to test in the string, and branches similar
							# to first instruction in this subr.

	addi $t1, $t1, 1				# increments the value to maintain the proper index of the characters in the String

	jr $ra						# final statement of a program to jump to return address

#----------------------------------------------------
# confirmedPalindrome subroutine
#----------------------------------------------------

# When this is accessed from a jump in other sunroutines
# this will load the user's string and a string stating
# the user entered string is a palindrome to the console
# NOTE: this subr is only called after the user entered
# string has been confirmed to be a palindrome

#-----------------------------------------------------  

confirmedPalindrome:

	la $a0, userInputStr		# This line loads the variable 'userInputStr' into register	

	li $v0, 4			# passing 4 to the register is the command to print the string in the register

	syscall				# system call to execute the above command(s)

	la $a0, strIsPalindrome		# loads the variable 'strIsPalindrome' to the register to for printing			

	syscall				# system call to execute the above command(s)

	li $v0, 10			# passing 10 to a register is the service for exiting/ terminating the program
					# I could change this command to loop continually.

	syscall				# system call to execute the above command(s)

#----------------------------------------------------
# negativePalindrome subroutine
#----------------------------------------------------

# When this is accessed from a jump in other subroutines
# This will load the user's string and the string stating 
# the string entered is not a palindrome to the console

#----------------------------------------------------  
negativePalindrome:

	la $a0, userInputStr		# This line loads the variable 'userInputStr' into register	

	li $v0, 4			# passing 4 to the register is the command to print the string in the register

	syscall				# system call to execute the above command(s)

	la $a0, strNotPalindrome	# loads the variable 'strNotPalindrome' to the register to for printing			

	syscall				# system call to execute the above command(s)

	li $v0, 10			# passing 10 to a register is the service for exiting/ terminating the program
					# I could change this command to loop continually.

	syscall				# system call to execute the above command(s)


#-------------------------------------------------------------------------------------------------------
#.data Section
#-------------------------------------------------------------------------------------------------------
.data

	greeting: .asciiz "Enter a String to Check for Palindrome: "

	userInputStr: .space 50						#userInputStr will be the variable that holds the string the user enters

	reverseUsrStr: .space 50					# this variable will hold a reverse version of the entered string, added character by character in the loop
									# it is reverse so the indices can be compared, if they are equal in literal value the string is a palindrome 

	strIsPalindrome: .asciiz " is a palindrome"			# variable to hold statement listed, to be called if the user enetered string is determined to be a palindrome

	strNotPalindrome: .asciiz " is not a palindrome"		# variable to holde statement listed, to be called if the usser entered string is determined to not be a palindrome 

#--------------------------------------------------------------------------------------------------------

#------------------------------------------------ END ---------------------------------------------------