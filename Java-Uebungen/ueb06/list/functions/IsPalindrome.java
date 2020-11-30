
package ueb.list.functions;

/**
 * checks if the String in calling element is a palindrome
 * @author iat103971, iam102916
 */
public class IsPalindrome extends PredicateFunctionObject<String>{
    
    /**
     * default construckter
     */
    public IsPalindrome(){
	
    }
    
    /**
     * actual function
     * checks if the String in calling element is a palindrome
     * @param p the string to check
     * @return true if palindrome
     */
    @Override
    public boolean call(String p){
	p=p.toUpperCase();
	String check ="";
	
	for (int c=p.length()-1; c >= 0; c--){
	    check += p.charAt(c);
	}	
	return p.compareTo(check)==0;
    }  
}
