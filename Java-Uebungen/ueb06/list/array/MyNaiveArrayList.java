
package ueb.list.array;
//import ueb.list.linked.*;
import ueb.list.*;
//import ueb.list.functions.PredicateFunctionObject;
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
	this.element=new Object[]{null};
    }
    /**
     * Constructor with array of values
     * @param values values you want in the list
     */
    public MyNaiveArrayList(E... values){
	this.element=new Object[values.length];
	this.element = values.clone();
    }
    /**
     * Constructor with list
     * @param cpy base list with which to create the list
     */
    public MyNaiveArrayList(MyNaiveArrayList<E> cpy){
	int i = cpy.length();
	this.element=new Object[i];
	for(int c=0; c<i;c++)    
	    this.element[c]=cpy.getValueAt(c);
    }


    /**
     * returns the length of the list
     * @return the length of the list
     */
    @Override
    public int length(){
	return element[0]==null?0:element.length;
	
    }
    
    
    /**
     * returns the value at index 'i'
     * @param i index starts at 0
     * @return the value at index 'i' null if index is invallid
     */
    @Override
    public E getValueAt(int i){
	return (E)this.element[i];
    }
    /**
     * inserts 'newe' at index 'i'
     * @param i index starts at 0
     * @param newe element to insert
     */
    @Override
    public void insertAt(int i,E newe){
	Object[] neu = new Object[element.length+1];
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


    /**
     * removes element at index 'i'=cryyy!!!
     * @param i index starts at 0
     */
    @Override
    public void removeAt(int i){
	Object[] neu = new Object[element.length-1];
	for(int c=0;c<neu.length;c++){
	    if(c<i){
		neu[c]=(E)this.element[c];
	    }else{
		neu[c]=(E)this.element[c+1];
	    }
	}
    }
     
   
}
