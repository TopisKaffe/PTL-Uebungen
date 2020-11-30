
package ueb.list.linked;
import ueb.list.*;
import ueb.list.functions.PredicateFunctionObject;
/**
 * class to contain a list
 * @author iat103971, iam102916
 * @param <E> Datatype of payloads in the list
 */
public class MyLinkedList<E> extends MyList<E> {
    private MyElement<E> element;
    
    /**
     * Constructor with empty element
     */
    public MyLinkedList(){
	this.element=new MyEmptyElement<>();
    }
    /**
     * Constructor with array of values
     * @param values values you want in the list
     */
    public MyLinkedList(E... values){
	this();
	for (E value : values) {
	    this.element = this.element.append(value);
	}
    }
    /**
     * Constructor with list
     * @param cpy base list with which to create the list
     */
    public MyLinkedList(MyLinkedList<E> cpy){
	this();
	int i=cpy.length();
	for(int c=0;c<i;c++){
	    this.append(cpy.element.getValueAt(c));
	}
    }


    /**
     * returns the length of the list
     * @return the length of the list
     */
    @Override
    public int length(){
	return element.length();
    }
    
    
    /**
     * returns the value at index 'i'
     * @param i index starts at 0
     * @return the value at index 'i' null if index is invallid
     */
    @Override
    public E getValueAt(int i){
	return i<0?null:element.getValueAt(i);
    }
    /**
     * inserts 'newe' at index 'i'
     * @param i index starts at 0
     * @param newe element to insert
     */
    @Override
    public void insertAt(int i,E newe){
	this.element=this.element.insertAt(i,newe);
    }


    /**
     * removes element at index 'i'
     * @param i index starts at 0
     */
    @Override
    public void removeAt(int i){
	this.element=this.element.removeAt(i);
    }
    
      /**
     * replaces element at index 'i'
     * @param i index starts at 0
     * @param newe element to be inserted
     */
    @Override
    public void replaceAt(int i, E newe){
	
    }
    
    /**
     * returns the values of the list as a string
     * @return the values of the list as a string
     */
    @Override
    public String toString(){
	return "["+ this.element.toString()+"]";
    }    
    
    
    /**
     * checks if there is an object with the criteria of 'fill'
     * @param fill functionObject with criteria
     * @return true if the criteria are met
     */
    @Override
    public boolean exists(PredicateFunctionObject<E> fill){
	return this.element.find(fill)!=null;
    } 
    
    /**
     * checks all elements in list with the criteria of 'fill'
     * @param fill functionObject with criteria
     * @return true if the criterai are met
     */
    @Override
    public boolean forAll(PredicateFunctionObject<E> fill){
	return this.element.forAll(fill);
    }
    
    /**
     * checks if there is an object with the criteria of 'fill' and returns it
     * @param fill functionObject with criteria
     * @return null if it was not found or the first element meeting the criteria
     */
    @Override
    public E find(PredicateFunctionObject<E> fill){
	return this.element.find(fill);
    } 
    /**
     * filters THIS list with the criteria of 'fill'
     * @param fill functionObject with criteria
     */
    @Override
    public void filterThis(PredicateFunctionObject<E> fill){
	this.element=this.element.filterThis(fill);
    }   
}
