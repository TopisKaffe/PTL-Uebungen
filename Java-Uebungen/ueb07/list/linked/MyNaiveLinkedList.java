
package ueb.list.linked;
import ueb.list.*;
//import ueb.list.functions.PredicateFunctionObject;
/**
 * class to contain a list
 * @author iat103971, iam102916
 * @param <E> Datatype of payloads in the list
 */
public class MyNaiveLinkedList<E> extends MyList<E> {
    private MyElement<E> element;
    
    /**
     * Constructor with empty element
     */
    public MyNaiveLinkedList(){
	this.element=new MyEmptyElement<>();
    }
    /**
     * Constructor with array of values
     * @param values values you want in the list
     */
    public MyNaiveLinkedList(E... values){
	this();
	for (E value : values) {
	    this.element = this.element.append(value);
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

}
