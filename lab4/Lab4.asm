#LAB 4: FEEDBABE IN MIPS
#CMPE 012 Spring 2018
#Samuel Guyette, sguyette
#01E —, Mike

.data	#variables
	prompt: .asciiz "Please input a number: "
	feed: .asciiz "FEED"
	babe: .asciiz "BABE"
	feedbabe: .asciiz "FEEDBABE"
	newLine: .asciiz "\n"

.text	#instructions
	main:
		#prompts user to enter a number
		li $v0, 4	#prepares to print statment
		la $a0, prompt 	#loads print statment				
		syscall
		#stores user input
		li $v0, 5	#number is stored in v0
		syscall 
		#move value to t0
		move $t0, $v0							#user input is stored in t0
		
		addi $t1, $zero, 0						#counter int is stored in t1		
		
		while:
			bgt   $t1, $t0, exit
			j loop	
		exit:
		#end of program
		li $v0, 10
		syscall

		
	loop:
		addi $t3, $zero, 3						#dividing int 3 is stored in t3
		addi $t4, $zero, 4						#dividing int 4 is stored in t4
		add $t1, $t1, 1							#increment int stored in t2
		
		bgt   $t1, $t0, exit
		#checks if num can be divided by 3 evenly
		div $t1, $t3
		mfhi $s1		
		beq $s1, $zero, printFeed
		
		#checks if num can be divided by 4 evenly
		div $t1, $t4
		mfhi $s1
		beq $s1, $zero, printBabe
		
		#prints value of counter
		li $v0, 1
		add $a0, $zero, $t1
		syscall
		
		
		li $v0, 4
		la $a0, newLine
		syscall
		j while
		

	printFeed:
		#checks if num can be divided by 4 evenly
		div $t1, $t4
		mfhi $s1
		beq $s1, $zero, printFeedBabe
		#else
		li $v0, 4
		la $a0, feed
		syscall
		li $v0, 4
		la $a0, newLine
		syscall
		j loop
	printBabe:
		#checks if num can be divided by 3 evenly
		div $t1, $t3
		mfhi $s1		
		beq $s1, $zero, printFeed
		#else
		li $v0, 4
		la $a0, babe
		syscall
		li $v0, 4
		la $a0, newLine
		syscall
		j loop
	
	printFeedBabe:
		li $v0, 4	#prints feedbabe
		la $a0, feedbabe
		syscall
		li $v0, 4
		la $a0, newLine
		syscall
		j loop
		
		
