
package ueb.list.array;
//import ueb.list.linked.*;
import ueb.list.*;
import ueb.list.functions.PredicateFunctionObject;
/**
 * class to contain a list
 * @author iat103971, iam102916
 * @param <E> Datatype of payloads in the list
 */
public class MyNaiveArrayList<E> extends MyList<E> {
    private Object[] element;
    
    /**
     * Constructor with empty element
     */
    public MyNaiveArrayList(){
	this.element=null;
    }
    
   

    /**
     * returns the length of the list
     * @return the length of the list
     */
    @Override
    public int length(){
	return element==null?0:element.length;
    }
    
    
    /**
     * returns the value at index 'i'
     * @param i index starts at 0
     * @return the value at index 'i' null if index is invallid
     */
    @Override
    public E getValueAt(int i){
	if(i>=0&&i<length()){
	    return (E)this.element[i];
	}
	return null;
    }
    
    /**
     * inserts 'newe' at index 'i'
     * @param i index starts at 0
     * @param newe element to insert
     */
    @Override
    public void insertAt(int i,E newe){
	if(i>=0&&i<=length()){
	    Object[] neu = new Object[length()==0?1:element.length+1];
	    for(int c=0;c<neu.length;c++){
		if(c==i){
		    neu[c]=newe;
		}else{
		    if(c<i){
			neu[c]=(E)this.element[c];
		    }else{
			neu[c]=(E)this.element[c-1];
		    }
		}
	    }
	    this.element=neu;
	}
    }


    /**
     * removes element at index 'i'=cryyy!!!
     * @param i index starts at 0
     */
    @Override
    public void removeAt(int i){
	if(i>=0 && length()>0 && i<=length()){
	    Object[] neu = new Object[length()==0?0:element.length-1];
	    for(int c=0;c<neu.length;c++){
		if(c<i){
		    neu[c]=(E)this.element[c];
		}else{
		    neu[c]=(E)this.element[c+1];
		}
	    }
	    this.element=neu;
	}
    } 
}
