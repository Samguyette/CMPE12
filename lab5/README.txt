Describe what you learned, what was surprising, what worked well and what did not:
This lab was far more challenging than what I inticipated. A major lack of understanding
I didn't grasp was all numbers a prestored in binary. Therefore, when I started I tried 
to add registars that carried 0000, 0001, 0010... and so one and somehow place them in the
correct spot. Once this was cleared up I was able to store them way more efficiently.
I learned alot from this lab about how numbers are actually stored in the code and how
to minipulate them from that. Such as HEX to Binary then printing them out maniually.

1. How many representations of 0 are there in your input number?
One representation would be if it is leading 0s which in what you wouldn't print and another would be following 0s
which you would include in the printout. 

(Not sure if I interpreted this question correctly.)

2. What is the largest input value (in decimal) that your program supports?
The largest value in decimal
Max positive is 2147483648

3. What is the smallest (most negative) input value (in decimal) that your program supports?
Max negative is 2147483647

4. What is the difference between signed and unsigned arithmetic in MIPS (add vs addu, mult vs
multu)? Which type did you use? What were the advantages or disadvantages of this choice?
Unsigned ignores overflow while signed takes into account overflow. This was important when dividing 
the main number and finding the remainder which enabled me to print out the correct digit

5. Consider how you might write a binary-to-decimal converter, in which the user inputs a string of ASCII 
“0”s and “1”s and your code prints an equivalent decimal string. How would you write your code?
I would write the code by thinking about what I just wrote and taking it in reverse. I would group in 4 bits and or and shift. 
The code for the question would mimic the code I just wrote pretty simmularly