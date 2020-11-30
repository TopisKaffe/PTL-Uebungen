
package ueb.list.array;
import ueb.list.linked.*;
import ueb.list.*;
//import ueb.list.functions.PredicateFunctionObject;
/**
 * class to contain a list
 * @author iat103971, iam102916
 * @param <E> Datatype of payloads in the list
 */
public class MyCapacityArrayList<E> extends MyList<E> {
    private Object[] element;
    
    public static final int DEFAULT_CAPACITY = 42;
    public static final float DEFAULT_GROW_FACTOR = 1.42f;
    
    private float actualGrowFactor;
    private int size=0;
    private int capacity;
    /**
     * Constructor with empty element
     */
    public MyCapacityArrayList(){
	this.element=new Object[DEFAULT_CAPACITY];
	this.capacity=DEFAULT_CAPACITY;
	this.actualGrowFactor=DEFAULT_GROW_FACTOR;
    }
    /**
     * constructor with capacity setting
     * @param capacity memory allocation size for the array
     */
    public MyCapacityArrayList(int capacity){
	this.element=new Object[capacity];
	this.capacity=capacity;
	this.actualGrowFactor=DEFAULT_GROW_FACTOR;
    }
    
    /**
     * constructor with capacity setting
     * @param capacity memory allocation size for the array
     * @param growthFactor growth factor by which the memory allocation will be increased when necessary
     */
    public MyCapacityArrayList(int capacity, float growthFactor){
	this.element=new Object[capacity];
	this.capacity=capacity;
	this.actualGrowFactor=growthFactor;
    }


    /**
     * returns the length of the list
     * @return the length of the list
     */
    @Override
    public int length(){
	return size;
    }
    
    //I AM TOOOOOTALLY UNIQUE, DUH!
    private int getSize(){
	return size;
    }
    
    //fuckin getter method
    private int getCapacity(){
	return capacity;
    }
    
    /**
     * fuckin getter method for grow factor
     * @return growFactor of this array/list
     */
    public float getGrowFactor(){
	return actualGrowFactor;
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
	
	size+=1;
		
	if(i>=0&&i<=length()){
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
    }


    /**
     * removes element at index 'i'=cryyy!!!
     * @param i index starts at 0
     */
    @Override
    public void removeAt(int i){
	size-=1;

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