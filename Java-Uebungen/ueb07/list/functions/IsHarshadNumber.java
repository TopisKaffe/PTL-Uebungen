
package ueb.list.functions;

/**
 * test class to test integers if its a harshadnumber
 * extens PredicateFunctionObject
 * @author iat103971, iam102916
 */
public class IsHarshadNumber extends PredicateFunctionObject<Integer> {
    
    /**
     * test for a given int if its a harshadnumber
     * @param p int to test
     * @return true if it is a harshadnumber false if not
     */
    @Override
    public boolean call(Integer p){
	return harshAd(p);
    }
    
      /**
     * determines if num is a harshad number
     *
     * @param num integer number
     * @return TRUE if num is a harshad number/else FALSE
     */
    private static boolean harshAd(int num) {
        if (num > 0) {
            return (num % digitSum(num) == 0);
        } else {
            return false;
        }
    }

    
    /**
     * determines the digit sum of num.
     * negative numbers are calculated as if positive, 
     * but with '-' (this is not a smiley)
     * TODO DONE Was passiert für negative Zahlen
     *
     * @param num integer
     * @return digit sum of num
     */
    private static int digitSum(int num) {
        int sum = 0;

        int len = calcNumLength(num);
        for (int i = 1; i <= len; i++) {
            sum += num % 10;
            num /= 10;
        }
        return sum;
    }
    
    
    /**
     * determines length of num ('-12' returns 3, '5' returns 1)ount + 1))
     *
     * @param num integer
     * @return length of num
     */
    private static int calcNumLength(int num) {
        int len = 1;
        while (num >= 10) {
            len++;
            num /= 10;
        }
        return len;
    }


}
