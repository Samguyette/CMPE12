#LAB 5: HEX TO DECIMAL CONVERSION
#CMPE 012 Spring 2018
#Samuel Guyette, sguyette
#01E — Mike

#PSUEDO CODE
#First:
#	Prompt user for input and add new line.
#	Take in the input using lw and assigning a registar to the data in a1
#	print out the output line and a new line

#Second:
#	LOOP 8 TIMES:
#		load the first/next bit in
#		determine if it less than 57 or greater than 65
#		branch to proper function

#		depending on function subtract proper ammount
#		or it with s0
#		add to counter

#		continue loop

#(now s0 contains the binary value of the HEX value)
#Third:
#	check if the value is negative if so add "-"

#Fourth:
#	LOOP UNTIL CONSTANT IS 1:
#		divide value by 1000000000
#		replace old value with new value
#		depending on the quotient branch to proper print func
#		divide constant by 10

#Fifth: 
#	once constant is 0 move to print remainder func 
#	which will print out what is left of the value 
#	that has been being divided

#Sixth:
#	end program





.text	#instructions
main:
	#the input is stored from program arguments
	#$a0 is 1 if argument is passed
	#$a1 contains an address where input is stored
	li $v0, 4
	la $a0, input	#prompt for input
	syscall
	
	li $v0, 4	#adds a new line
	la $a0, newLine
	syscall
	
	lw  $t0, ($a1)  #makes t0 equal to the data in a1	$t0 now holds the input
	li $v0, 4
	la $a0, ($t0)	#prepares for printing
	syscall
	
	li $v0, 4
	la $a0, newLine	#adds a new line
	syscall
	
	li $v0, 4
	la $a0, output	#prompt for output
	syscall
	
	li $v0, 4
	la $a0, newLine	#adds new line
	syscall
	
	and $s0, $s0, $zero
	addi $t2, $t2, 57		#anything under is a int
	addi $t3, $t3, 65		#anything over is a char
	addi $t4, $t4, 0		#counter
	addi $t5, $t5, 1		#second counter
	
	addi $t0, $t0, 2		#ignore 0x at the start of the input

	loopHextoBinary:
		bge $t4, 8, breaker			#conditional
		
		lb $t1, ($t0)
		
		ble $t1, $t2, loadNumber		#checks if less than 57
		bge $t1, $t3, loadCharacter		#checks if greater than 65
	
	
	loadCharacter:
		subi $t1, $t1, 55			#subtracts original 55 to get real number
		j addOn	

	loadNumber:
		subi $t1, $t1, 48			#subtracts original 48 to get real number
		j addOn
		
	addOn:
		or $s0, $s0, $t1			#ors with current s0
		addi $t4, $t4, 1			#increments all counters
		bge $t4, 8, checkNegative			#conditional
		addi $t0, $t0, 1
		
		sll $s0, $s0, 4
		
		j loopHextoBinary			#jumps back to main loop
	
	checkNegative:
		move $t8, $s0				#sets t8 to converted value
		
		move $t4, $zero
		move $t9, $zero
		move $s6, $zero

		blt $t8, 0, addNegative			#checks if the number is negative
	
		j breaker
		
	addNegative:
		li $a0, '-'
		li $v0, 11				#if so adds a negative sign
		syscall
		
		j breaker		
	
	breaker:
		move $t8, $s0				#sets t8 to converted value
		
		move $t9, $zero
		move $s6, $zero
		
		addi $t9, $t9, 1000000000		#div constant 

		j printout
		
		
	printout:
		beq $s7, 1, end
		div $t8, $t9

		mflo $t7				#stores quotient
		mfhi $t8				#stores remainder
		
		div $t9, $t9, 10			
		
		beq $t8, 0, printRemainder		#depending on quotient branches to print
		beq $t7, 0, printZeroChecker
		beq $t7, 1, printOne
		beq $t7, 2, printTwo
		beq $t7, 3, printThree
		beq $t7, 4, printFour
		beq $t7, 5, printFive
		beq $t7, 6, printSix
		beq $t7, 7, printSeven
		beq $t7, 8, printEight
		beq $t7, 9, printNine
		beq $t7, -1, printOne
		beq $t7, -2, printTwo
		beq $t7, -3, printThree
		beq $t7, -4, printFour
		beq $t7, -5, printFive
		beq $t7, -6, printSix
		beq $t7, -7, printSeven
		beq $t7, -8, printEight
		beq $t7, -9, printNine
		
		
		
	printZeroChecker:					#insures no 0s are printed before the first number
		li $v0, 4

		bge $s6, 1, printZero
		addi $t5, $t5, 1
		j printout

	printZero:						#all print methods bellow
		li $a0, '0'
		li $v0, 11
		syscall
		
		addi $t5, $t5, 1
		j printout
	printOne:
		li $a0, '1'
		li $v0, 11
		syscall
		
		addi $s6, $s6, 1
		addi $t5, $t5, 1
		j printout
	printTwo:
		li $a0, '2'
		li $v0, 11
		syscall
		
		addi $s6, $s6, 1
		addi $t5, $t5, 1
		j printout
	printThree:
		li $a0, '3'
		li $v0, 11
		syscall
		
		addi $s6, $s6, 1
		addi $t5, $t5, 1
		j printout
	printFour:
		li $a0, '4'
		li $v0, 11
		syscall	
		
		addi $s6, $s6, 1
		addi $t5, $t5, 1
		j printout
	printFive:
		li $a0, '5'
		li $v0, 11
		syscall
		
		addi $s6, $s6, 1
		addi $t5, $t5, 1
		j printout
	printSix:
		li $a0, '6'
		li $v0, 11
		syscall	
		
		addi $s6, $s6, 1
		addi $t5, $t5, 1
		j printout
	printSeven:
		li $a0, '7'
		li $v0, 11
		syscall	
		
		addi $s6, $s6, 1
		addi $t5, $t5, 1
		j printout
	printEight:
		li $a0, '8'
		li $v0, 11
		syscall
		
		addi $s6, $s6, 1
		addi $t5, $t5, 1
		j printout
	printNine:
		li $a0, '9'
		li $v0, 11
		syscall	
		
		addi $s6, $s6, 1
		addi $t5, $t5, 1
		j printout
		
		
	printRemainder:					#function that prints the remainder of what is left
		li $v0, 11

		addi $s7, $s7, 1
		beq $t7, 0, printZero
		beq $t7, 1, printOne
		beq $t7, 2, printTwo
		beq $t7, 3, printThree
		beq $t7, 4, printFour
		beq $t7, 5, printFive
		beq $t7, 6, printSix
		beq $t7, 7, printSeven
		beq $t7, 8, printEight
		beq $t7, 9, printNine

		beq $t7, -1, printOne
		beq $t7, -2, printTwo
		beq $t7, -3, printThree
		beq $t7, -4, printFour
		beq $t7, -5, printFive
		beq $t7, -6, printSix
		beq $t7, -7, printSeven
		beq $t7, -8, printEight
		beq $t7, -9, printNine
				
	end:
		li $v0, 10						#end of program
		syscall
		jr $ra
	
				
.data	#variables
input: .asciiz "Input a hex number:"
output: .asciiz "The decimal value is:"
newLine: .asciiz "\n"
array: .space 32
