//-----------------------------------------------------------------------------
// Samuel Guyette
// sguyette
// 1518801
// FeedBabe.java
// This program is to iterate through a set of integers (1-500) and output 
// one of four outputs depending on the number
//-----------------------------------------------------------------------------

class FeedBabe{
	public static void main(String[] args){

		int currentNum = 1;
		while(currentNum <= 500){
			if(currentNum%3 == 0 && currentNum%4 != 0){
				System.out.println("FEED");
			}
			if(currentNum%4 == 0 && currentNum%3 != 0){
				System.out.println("BABE");
			}
			if(currentNum%4 == 0 && currentNum%3 == 0){
				System.out.println("FEEDBABE");
			}
			if(currentNum%4 != 0 && currentNum%3 != 0){
				System.out.println(currentNum);
			}

			currentNum++;
		}	
	}
}