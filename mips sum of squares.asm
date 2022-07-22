data
msg1 : .asciiz "Sum of squares from 1-10 is "

.text
li $v0, 4
la $a0, msg1
syscall

li $t0, 0 # loop variable
li $s0, 1 # Register to find square of the number
li $t2, 0 # Result register
find_sum:
mult $s0, $s0 # finding $s0 square
mflo $t1 # $t1 = $s0 square
add $t2, $t2, $t1 # $t2 = $t2+$t1 sum of the squares of $s0
addi $s0, $s0, 1 # $s0 incrementing by 1
addi $t0, $t0, 1 # loop variable increment by 1
bne $t0, 10, find_sum # repeating the squaring of numbers and adding the result for 10 numbers

li $v0, 1 # printing the result on STDOUT
move $a0, $t2 # moving $t2 contents to $a0
syscall

exit:
li $v0, 10
syscall