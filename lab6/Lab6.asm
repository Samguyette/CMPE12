#LAB 6: FLOATING POINT MATH
#CMPE 012 Spring 2018
#Samuel Guyette, sguyette
#01E — Mike

# Pseudocode:
#
#
# FindParts: 
# Using bitshift it will loop through each componet the proper ammount of times (1,8, 23)
# while storing each in their respective registars. This Function is useful for all others to work.
# PrintFloat:
# Prints proper header than for each of the three registars it will banch to another function that 
# will loop through it and apply a mask to the front which will print a 1 or a 0 depending on which
# the value is after anding together. It will shift each iteration. For sign if 1 - if + 0
#
#CompareFloats:
#First uses find parts and stores all 6 in respective registars. Next compare sign if different break.
#Next compare exponet if different break. Next compare fraction if different break. If none hit the
#result is they are the same. If not they will break to a function that prints a 1 or -1 depending 
#on which is larger.
#
#AddFloats:
#First uses find parts and stores all 6 in respective registars. If one is negative and one is positive
#it will also change the negative one to positive to be able to perform operations on it. It will also mark 
#a flag (registar) to note which one was changed. After this both numbers will be positive. it will find out 
#which is larger using compareFloats and assign the sum sign. Next depending on which is bigger it will bit shift the smaller one to #match the bigger one. 
#This will be done with shifting bits. After it will now change the sign back to negative
#if flag is triggered. Next add the fractions. Finally we will have to normailze. This will be done by equalities
#if the frac. is bigger than 1.1111... it will divide the frac. and add an exponet. If it is smaller than 1.000..1 it will 
#multiply the frac. by 2 (bit shift left) and subtract the exponet. Once this is done store in v0.
#
#MultFloats:
#First uses find parts and stores all 6 in respective registars. Have 0 cases if either one is 0 return 0. 
#xor the two signs to find the product sign. Add the exponets to find the products exponet. Next put a 1. in
#front of both by adding 8388608 and mult both together. Storing first 32 frac in $a1 and next 32 in $a2.
#
#NormalizeFloat:
#Take the first 9 bits of $a2 and concatinate them onto the back of $a1 by bitshifting. Loop 9.
#Next if the frac. is bigger than 1.1111... it will divide the frac. and add an exponet. If it is smaller than 1.000..1 it will 
#multiply the frac. by 2 (bit shift left) and subtract the exponet. While doing this make sure if you shift left
#and there is a 1 at the front of $a2 move it onto the back of $a1. And if you shift right and there is a 1 at the 
#back of $a1 move it onto the front of $a2. This is done with bitmasking. Once done round - finds if there is another one in bit 24 
#and if there is another one past that all the way to bit 32. If so a 1 has to be added to $a1 to round up. After this 
#add them together. Add the sign sift 8 add the exponet shift 23 add the fraction. Return this value to v0.



#****REGISTARS ARE NOT LISTED OUT HERE, HOWEVER THEY ARE SPECIFIED IN COMMENTS FOR ALL IMPORTANT 
#REGISTARS USED. IT WOULD BE REDUNDANT TO LIST OUT TWICE****
FindParts:
	subi $sp, $sp, 4
	sw $ra, ($sp)
	
	#registars used
	addi $t1, $zero, 0	#reset sum
	addi $t2, $zero, 0 	#counter
	addi $t3, $zero, 0 	#sign
	addi $t4, $zero, 0 	#exp
	addi $t5, $zero, 0 	#fraction
	addi $t6, $zero, 1	#mask

	loop:	
		beq $t2, 32, divide		#divide to remove 0s

		bge $t2, 31, sign		#breaks into proper section
		bge $t2, 23, exp
		bge $t2, 0, fraction
		
	sign:	
		and $t1, $t0, $t6		#sign loops to store once
		add $t3, $t3, $t1

		sll $t6, $t6, 1
		addi $t2, $t2, 1
		j loop
	
	exp:	
		and $t1, $t0, $t6		#exponet loops to store eight times
		add $t4, $t4, $t1
				
		sll $t6, $t6, 1
		addi $t2, $t2, 1
		j loop
	
	fraction:
		and $t1, $t0, $t6		#fraction loops twenty three times
		add $t5, $t5, $t1
			
		sll $t6, $t6, 1
		addi $t2, $t2, 1		#everytime loop always shift mask to evaluate next binary digit
		j loop

	divide:
		div $t3, $t3, -2147483648
		div $t4, $t4, 8388608
		j exitFindParts
		
	exitFindParts:	
		lw $ra, ($sp)
		addi $sp, $sp, 4
		jr $ra

	
# Subroutine PrintFloat
# Prints the sign, mantissa, and exponent of a SP FP value.
# input: $a0 = Single precision float
# Side effects: None
# Notes: See the example for the exact output format.
PrintFloat:
	subi $sp, $sp, 4
	sw $ra, ($sp)		

	move $t0, $a0		#moves desired value to run findparts on
	jal FindParts

	li $v0, 4	
	la $a0, signPrint	#prints text then the desired registar storing the part for all three
	syscall
		
	jal printSign
	
	li $v0, 4	#adds a new line
	la $a0, newLine
	syscall	
		
	
	li $v0, 4			#prints desired componet in binary in respected function 
	la $a0, expPrint
	syscall

	jal printExp

	li $v0, 4	#adds a new line
	la $a0, newLine
	syscall	
		
	li $v0, 4	
	la $a0, fractionPrint
	syscall

	jal printFraction
	
		
	li $v0, 4	#adds a new line
	la $a0, newLine
	syscall	
	
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra
	
printSign:
	subi $sp, $sp, 4
	sw $ra, ($sp)
	
	beq $t3, 1, printOneSign		#checks if is negative or positive and prints
	beq $t3, 0, printZeroSign
		
	printOneSign:
		li $v0, 4	
		la $a0, one
		syscall	
		j exitSign
	
	printZeroSign:
		li $v0, 4	
		la $a0, zero
		syscall		
		j exitSign
		
	exitSign: 
		lw $ra, ($sp)
		addi $sp, $sp, 4
		
		jr $ra
	
printExp:nop
	subi $sp, $sp, 4
	sw $ra, ($sp)
	
	addi $t0, $zero, 128	#mask
	addi $t1, $zero, 0	#counter
	addi $t2, $zero, 0 	#reset sum
	
	loopExp:
		beq $t1, 8, exitExp		
		and $t2, $t4, $t0			#uses a mask simmular to get parts 
		sll $t4, $t4, 1
		addi $t1, $t1, 1
		
		beq $t2, 1, printOneExp			#depending on what anding the mask with registar prints one or zero
		beq $t2, 0, printZeroExp
	
	printOneExp:
		li $v0, 4	
		la $a0, one
		syscall	
		
		j loopExp
	
	printZeroExp:
		li $v0, 4	
		la $a0, zero
		syscall
			
		j loopExp
	exitExp: 
		lw $ra, ($sp)
		addi $sp, $sp, 4
	
		jr $ra		
				

printFraction:
	subi $sp, $sp, 4			#same logic as printExp
	sw $ra, ($sp)
	
	addi $t0, $zero, 4194304	#mask
	addi $t1, $zero, 0		#counter
	addi $t2, $zero, 0 		#reset sum
	
	loopFraction:
		beq $t1, 23, exitFraction		
		and $t2, $t5, $t0
		sll $t5, $t5, 1
		beq $t2, 1, printOneFraction
		beq $t2, 0, printZeroFraction
	
	printOneFraction:
		li $v0, 4	
		la $a0, one
		syscall	
		
		addi $t1, $t1, 1
		j loopFraction
	
	printZeroFraction:
		li $v0, 4	
		la $a0, zero
		syscall
		
		addi $t1, $t1, 1	
		j loopFraction
	
	
	exitFraction: 
		lw $ra, ($sp)
		addi $sp, $sp, 4
		
		jr $ra

	
# Subroutine CompareFloats
# Compares two floating point values A and B.
# input: $a0 = Single precision float A
#	 $a1 = Single precision float B
# output: $v0 = Comparison result
# Side effects: None
# Notes: Returns 1 if A>B, 0 if A==B, and -1 if A<B

CompareFloats:
	subi $sp, $sp, 4
	sw $ra, ($sp)

	move $t0, $a0		#moves desired value to run findparts on
	move $t1, $zero
	jal FindParts		#find parts for a0 is now stored in t7-t9


	add $t7, $zero, $t3																								#A ($a0)
	add $t8, $zero, $t4	#sign, exp, fraction
	add $t9, $zero, $t5
	
	move $t0, $a1		#moves desired value to run findparts on		#B ($a1)
	jal FindParts		#find parts for a0 is now stored in t3-t5			
	

	addi $v0, $a0, 0
	
	blt $t7, $t3, zeroGreaterThan		#equality for comparing signs 
	bgt $t7, $t3, oneGreaterThan
	
	bgt $t8, $t4, zeroGreaterThan		#equality for exp
	blt $t8, $t4, oneGreaterThan
	
	bgt $t9, $t5, zeroGreaterThan		#equality for fraction
	blt $t9, $t5, oneGreaterThan
	
	beq $t9, $t5, equal
	
	equal:	
		addi $v0, $zero, 0
		
		j exitCompare
		
	zeroGreaterThan:
		addi $v0, $zero, 1
		
		j exitCompare
	
	oneGreaterThan:
		addi $v0, $zero, -1
		
		j exitCompare
		
	
	exitCompare:
		lw $ra, ($sp)
		addi $sp, $sp, 4
		jr $ra
	

# Subroutine AddFloats
# Adds together two floating point values A and B.
# input: $a0 = Single precision float A
#	 $a1 = Single precision float B
# output: $v0 = Addition result A+B
# Side effects: None
# Notes: Returns the normalized FP result of A+B
AddFloats:
	subi $sp, $sp, 4
	sw $ra, ($sp)
	
	subi $sp, $sp, 32
	sw $s0, 0($sp)			#stores s registars
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
		

	beq $a0, 0, equalsa1
	beq $a1, 0, equalsa0
	bne $a0, 0, continue
	
	equalsa1:				#if a0 or a1 is 0 stores other and exits
		add $v0, $zero, $a1
		j printFloats
	equalsa0:
		add $v0, $zero, $a0
		j printFloats
	
	
	continue:	
	move $t0, $a0		#moves desired value to run findparts on
	move $t1, $zero
	jal FindParts		#find parts for a0 is now stored in t7-t9
	
	li $v0, 1
	
	add $t7, $zero, $t3																								#A ($a0)
	add $t8, $zero, $t4	#sign, exp, fraction
	add $t9, $zero, $t5
	
	move $t0, $a1		#moves desired value to run findparts on		#B ($a1)
	jal FindParts		#find parts for a0 is now stored in t3-t5			

	addi $s3, $zero, 1			#checks for negatives
	addi $s4, $zero, 1			#and multiplies before addFractions

	beq $t7, $t3, sameSign
	bne $t7, $t3, differentSign
	

	#sum componets will be stored in s0-s2
	sameSign:
		beq $t7, 1, setNeg			#if same sign the overall sign is already found
		beq $t7, 0, setPos
	
		setNeg:
			addi $s0, $zero, 1
			j compare
		setPos:
			addi $s0, $zero, 0	
			j compare
		
	compare: 
		jal CompareFloats
	
		beq $v0, 0, same
		beq $v0, 1, aBigger			#desides which is larger and jumps to the right function
		beq $v0, -1, bBigger
		
		aBigger:
			sub $s5, $t8, $t4		#s5 is the difference
			add $s1, $zero, $t8		#s1 is storing sum exp
			beq $s3, -1, addNegativea	#if a is bigger and negative add negative
			j loopShiftaBigger
		bBigger:
			sub $s5, $t4, $t8		#s5 is the difference
			add $s1, $zero, $t4		#s1 is storing sum exp
			beq $s4, -1, addNegativeb	#if b is bigger and negative add negative
			j loopShiftbBigger
		same:
			add $s1, $zero, $t4		#s1 is storing sum exp
			j loopShiftbBigger
		
		addNegativea:
			addi $s0, $zero, 1		#changes the sign componet of entire func
			j loopShiftaBigger
		
		addNegativeb:
			addi $s0, $zero, 1
			j loopShiftbBigger
			
			
		loopShiftaBigger:
			beq $s5, 0, addFracs
			addi $s7, $zero, 8388608		#mask
			or $t5, $t5, $s7			#adds the 1. in front of both fraction componets to add easier
			or $t9, $t9, $s7
			srlv $t5, $t5, $s5			#shifts smaller right to match other fraction
			j addFracs
		loopShiftbBigger:
			beq $s5, 0, addFracs
			addi $s7, $zero, 8388608		#mask
			or $t5, $t5, $s7			#adds the 1. in front of both fraction componets to add easier
			or $t9, $t9, $s7
			srlv $t9, $t9, $s5			#shifts smaller right to match other fraction
			j addFracs
		

		addFracs:
			mult $t9, $s3
			mflo $t9			#multiplies by s3 and s4 to reastablish the negative
			mult $t5, $s4
			mflo $t5
		
			add $s2, $t5, $t9		#t2 stores the sum frac
			
			
			blt $s2, 0, changeSign
			
			j Normalize
		
		changeSign:
			addi $s4, $zero, -1		#changes the sign of the fraction componet
			mult $s2, $s4
			mflo $s2
			
			j Normalize
		
	
	differentSign:
		jal CompareFloats
		addi $s6, $zero, -2147483648		#mask
		beq $v0, -1, aNegative			#if different sign need to find out which is larger
		beq $v0, 1, bNegative
		
		aNegative:
			addi $s3, $s3, -2
			xor $a0, $a0, $s6		#changes s3 and s4 to match the sign of t5 and t9
			j compare
		bNegative:
			addi $s4, $s4, -2
			xor $a1, $a1, $s6
			j compare
	
	
	Normalize:
		bgt $s2, 16777215, divAndAdd	#if frac is greater has to shift exponet right and add to exponet
		blt $s2, 8388608, multAndSub	#if frac is smaller has to shift exponet left and sub to exponet
		j printFloats
		
		divAndAdd:
			srl $s2, $s2, 1
			addi $s1, $s1, 1
			j Normalize
		multAndSub:
			sll $s2, $s2, 1
			subi $s1, $s1, 1
			j Normalize
			
			
			
	printFloats:
		subi $s2, $s2, 8388608	#subtracts the extra 1 we added (1.)
		add $v0, $zero, $s0	#combines all values by bitshifting v0 and adding the three componets
		sll $v0, $v0, 8
		add $v0, $v0, $s1
		sll $v0, $v0, 23
		add $v0, $v0, $s2	
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)			#loads back s registars
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	addi $sp, $sp, 32
		
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra	

# Subroutine MultFloats
# Multiplies two floating point values A and B.
# input: $a0 = Single precision float A
#	 $a1 = Single precision float B
# output: $v0 = Multiplication result A*B
# Side effects: None
# Notes: Returns the normalized FP result of A*B
MultFloats:
	subi $sp, $sp, 4
	sw $ra, ($sp)
	
	subi $sp, $sp, 32
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)

	beq $a0, 0, zeroa0
	beq $a1, 0, zeroa1
	bne $a0, 0, continueMult
	
	zeroa0:				#if a0 or a1 is 0 stores other and exits
		add $v0, $zero, 0
		j exitMult
	zeroa1:
		add $v0, $zero, 0
		j exitMult
	
	
	continueMult:	
		move $t0, $a0		#moves desired value to run findparts on
		move $t1, $zero
		jal FindParts		#find parts for a0 is now stored in t7-t9
	
		li $v0, 1
	
		add $t7, $zero, $t3																								#A ($a0)
		add $t8, $zero, $t4	#sign, exp, fraction
		add $t9, $zero, $t5
	
		move $t0, $a1		#moves desired value to run findparts on		#B ($a1)
		jal FindParts		#find parts for a0 is now stored in t3-t5	
		
		j compareMult	

	compareMult:
		xor $s3, $t3, $t7
		beq $s3, 1, signNegative	#determines if products sign is negative or positive
		beq $s3, 0, signPositive
		
		signNegative:
			addi $a0, $zero, 1
			j addExpos
		signPositive:
			addi $a0, $zero, 0
			j addExpos
			
		addExpos:
			subi $t8, $t8, 127		#subtracts 127 from both exponets
			subi $t4, $t4, 127		
			add $a3, $t8, $t4		#adds them both together
			addi $a3, $a3, 127		#adds 127 back and stores in a3
			j multFracs			
			
		multFracs:
			addi $t5, $t5, 8388608		#adds a .1 in front of both numbers
			addi $t9, $t9, 8388608
			multu $t5, $t9			#multiplies them both together
			
			mfhi $a1			#stores first 32 in a1
			mflo $a2			#stores next 32 in a2

			j exitMult

	exitMult:
		jal NormalizeFloat
	
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	addi $sp, $sp, 32
		
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra	


# Subroutine NormalizeFloat
# Normalizes, rounds, and “packs” a floating point value.
# input:  $a0 = 1-bit Sign bit (right aligned)
#	  $a1 = [63:32] of Mantissa
#	  $a2 = [31:0] of Mantissa
#	  $a3 = 8-bit Biased Exponent (right aligned)
# output: $v0 = Normalized FP result of $a0, $a1, $a2
# Side effects: None
# Notes: Returns the normalized FP value by adjusting the exponent and mantissa so that 
# the 23-bit result mantissa has the leading 1(hidden bit).
NormalizeFloat:
	subi $sp, $sp, 4
	sw $ra, ($sp)
	
	subi $sp, $sp, 32
	sw $s0, 0($sp)			#stores s registars
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)			#**** a0 has sign bit, a1 has [63:32] of Mantissa, a2 has [31:0] of Mantissa
	sw $s6, 24($sp)			# a3 has 8-bit Biased Exponent (right aligned). ****
	sw $s7, 28($sp)
	
	addi $s1, $zero, -2147483648		#mask
	addi $s2, $zero, 0 			#counter
	
	shift:
		beq $s2, 8, doneShifting
		and $s3, $s1, $a2		#find out what the leading bit is
		srl $s3, $s3, 31		#matches back of a1
		sll $a1, $a1, 1			#adds result to a1
		add $a1, $a1, $s3
		
		sll $a2, $a2, 1			#shifts a2 by 1 and repeats process 8 times
		addi $s2, $s2, 1
		j shift

	doneShifting:
		addi $s1, $zero, -2147483648		#mask
		addi $s4, $zero, 1			#mask
		bgt $a1, 16777215, divAndAdd2	#if frac is greater has to shift exponet right and add to exponet
		blt $a1, 8388608, multAndSub2	#if frac is smaller has to shift exponet left and sub to exponet
		j round				#modified from addFloat
		
		divAndAdd2:
			and $s3, $s4, $a1
			sll $s3, $s3, 31	#if $s3 is 1 it will add a 1 to the front of a2 before shifting
			srl $a2, $a2, 1		#this is done so no bit is lost by shifting
			add $a2, $a2, $s3
			
			srl $a1, $a1, 1
			addi $a3, $a3, 1

			
			j doneShifting

		multAndSub2:
			and $s3, $s1, $a2
			srl $s3, $s3, 31	#if $s3 is 1 it will add a 1 to the back of a1 before shifting
			sll $a1, $a1, 1		#this is done so no bit is lost by shifting
			add $a1, $a1, $s3
			
			sll $a2, $a2, 1
			subi $a3, $a3, 1
			
			
			j doneShifting	
	
	round:
		addi $s1, $zero, -2147483648		#mask
		addi $s2, $zero, 0
		
		and $s3, $s1, $a2		#find out what the leading bit is
		bgt $s3, 0, triggerOne
		beq  $s3, 0, exitNormalize
		
		triggerOne:
			sll $a2, $a2, 1
			j findIfLarger
		
		findIfLarger:
			beq $s2, 31, exitNormalize
			and $s3, $s1, $a2		#find out what the leading bit is

			sll $a2, $a2, 1
			addi $s2, $s2, 1
			bgt $s3, 0, triggerTwo		#if leading bit is 1 concatinate to back of a1
			j findIfLarger
	
		triggerTwo:
			addi $a1, $a1, 1
			j exitNormalize
	
	
	exitNormalize:
	add $v0, $zero, $a0	#combines all values by bitshifting v0 and adding the three componets
	sll $v0, $v0, 8
	add $v0, $v0, $a3
	sll $v0, $v0, 23
	add $v0, $v0, $a1



	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	addi $sp, $sp, 32
		
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra	


#---------------------END FUNCTIONS-------------------------------------------------


.data	#variables
signPrint: .asciiz "SIGN: "
expPrint: .asciiz "EXPONENT: "
fractionPrint: .asciiz "MANTISSA: "
zero: .asciiz "0"
one: .asciiz "1"
newLine: .asciiz "\n"
