.data
prompt1 : .asciiz " Enter aside : "
prompt2 : .asciiz " Enter bside : "
prompt3 : .asciiz " Enter cside : "
msg: .asciiz "\n***********OUTPUT*****************"
msg1 : .asciiz " \naside :"
msg2 : .asciiz " \nbside :"
msg3 : .asciiz " \ncside :"
msg4 : .asciiz " \nVolume :"
msg5 : .asciiz " \nSurface area :"
.text
li $v0 , 4
la $a0,prompt1
syscall

li $v0, 5 # read aside
syscall
move $t0 ,$v0

li $v0 , 4
la $a0,prompt2
syscall

li $v0, 5 #read bside
syscall
move $t1 ,$v0

li $v0 , 4
la $a0,prompt3
syscall

li $v0, 5 #read cside
syscall
move $t2 ,$v0

mul $t3,$t0,$t1 # $t3 = aside * bside
mul $t6,$t3,$t2 # volume = $t3 * cside

mul $t4,$t0,$t2 # aside * cside
mul $t5,$t1,$t2 # bside * cside

add $t7 , $t3,$t4 # add aside * bside and aside * cside
add $s1 ,$t7,$t5 # add aside * bside and aside * cside and bside * cside

addi $s2 ,$0,2
mul $s1 ,$s2 ,$s1 # surface area = 2( aside * bside + aside * cside + bside * cside)

li $v0 , 4
la $a0,msg
syscall

li $v0 , 4
la $a0,msg1
syscall
li $v0 , 1
add $a0, $t0,$0
syscall

li $v0 , 4
la $a0,msg2
syscall
li $v0 , 1
add $a0, $t1,$0
syscall

li $v0 , 4
la $a0,msg3
syscall
li $v0 , 1
add $a0, $t2,$0
syscall

li $v0 , 4
la $a0,msg4
syscall
li $v0 , 1
add $a0, $t6,$0
syscall

li $v0 , 4
la $a0,msg5
syscall
li $v0 , 1
add $a0, $s1,$0
syscall