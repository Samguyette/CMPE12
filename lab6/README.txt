--------------------------------
LAB 6: FLOATING POINT MATH
CMPE 012 Spring 2018

Samuel Guyette, sguyette
01E — Mike
--------------------------------


----------------
LEARNING

This was by far the most time i've ever put into any program even after taking cmps101 and 12b. This program allowed me to learn what was really going on under the hood of HLL. For this lab I really needed to understand what each operation was really doing and each step for all four. Beyond that this lab I had to understand and visuallize what bitshifting and masking did to a number since that was such a large aspect to the lab. I also learned how the stack stores variables while calling functions and how it has to store a return address as while. This is never thought about when coding in java or c because it is done for you.


----------------
ANSWERS TO QUESTIONS

1.
Basically for my test code I modded the one givin by starting from the top and excluding all of the functions I haven't written or not using at the moment to focus on one funciton. Then I would change the inputs and test every case I could think of.

2.
Floating point overflow means that the number is too large to represent with the current ammount of bits allocated for the three componets. An example would be 0 110 1111 * 0 110 1111 = 0 111 0000

3.
I did not have any problems with rounding. I created a function to deal with this and round when applicable. Not sure how else to answer the question/if there was more to it.

4.
The main function I added was one that found the 3 parts to each floating point. This was very helpful because for each other function It requires you need to know the 3 parts to perform the opperation. Therefore I called it at the start of mult add and compare. This turned out to reuse alot of code and was very helpful.
