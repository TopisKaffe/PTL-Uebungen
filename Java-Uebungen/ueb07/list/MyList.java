
package ueb.list;
import ueb.list.functions.PredicateFunctionObject;
/**
 * class to contain a list
 * @author iat103971, iam102916
 * @param <E> Datatype of payloads in the list
 */
public abstract class MyList<E> {
    

    /**
     * 'newe' is the new start of the list 
     * @param newe new start
     */
    public void insertAtFront(E newe){
	insertAt(0, newe);    
    }
    /**
     * inserts 'newe' at the end of the list
     * @param newe element to add to the list
     */
    public void append(E newe){
	insertAt(length(), newe);
    }
    
    /**
     * checks if the list is empty
     * @return true if empty
     */
    public boolean isEmpty(){
	if(length()== 0){
	    return true;
	}else
	return false;
    }
    
    /**
     * replaces element at index 'i'
     * @param i index starts at 0
     * @param newe element to be inserted
     */
    public void replaceAt(int i, E newe){
	removeAt(i);
	insertAt(i, newe);
    }
    
     /**
     * Checks whether the 2 lists have the same values inside
     * @param kackstifft other list with which to compare
     * @return true if they are equal
     */
    @Override
    public boolean equals(Object kackstifft){
	int leng = length();
	boolean same = true;
	if(kackstifft instanceof MyList && ((MyList)kackstifft).length()==leng){
	    
	    for(int i=0;i<leng && same; i++){
		same = ((MyList)kackstifft).getValueAt(i) == this.getValueAt(i);
	    }
	    return same;
	}
	return false;
    }
    
    /**
     * checks if there is an object with the criteria of 'fill'
     * @param fill functionObject with criteria
     * @return true if the criteria are met
     */
    public boolean exists(PredicateFunctionObject<E> fill){
	boolean mist=false;
	for(int c=0; c<length() && !mist;c++){
	    mist=fill.call(getValueAt(c));
	}
	return mist;
    }
    
    /**
     * checks all elements in list with the criteria of 'fill'
     * @param fill functionObject with criteria
     * @return true if the criterai are met
     */
    public boolean forAll(PredicateFunctionObject<E> fill){
	boolean mist=true;
	for(int c=0; c<length() && mist;c++){
	    mist=fill.call(getValueAt(c));
	}
	return mist;
    }
    
    /**
     * checks if there is an object with the criteria of 'fill' and returns it
     * @param fill functionObject with criteria
     * @return null if it was not found or the first element meeting the criteria
     */
    public E find(PredicateFunctionObject<E> fill){
	E mist=null;
	for(int c=0; c<length() && (mist==null);c++){
	    mist=fill.call(getValueAt(c))?getValueAt(c):null;
	}
	return mist;
    }
    
    /**
     * filters THIS list with the criteria of 'fill'
     * @param fill functionObject with criteria
     */
    public void filterThis(PredicateFunctionObject<E> fill){
	for(int c=0; c<length();c++){
	    if(!(fill.call(getValueAt(c)))){
		removeAt(c);
		c--;
	    }
	}
    }
    
    
    //------------------------- ABSTRACT METHODS ------------------------------
    

    /**
     * returns the length of the list
     * @return the length of the list
     */
    abstract public int length();
    
    /**
     * returns the value at index 'i'
     * @param i index starts at 0
     * @return the value at index 'i' null if index is invallid
     */
    abstract public E getValueAt(int i);

    /**
     * inserts 'newe' at index 'i'
     * @param i index starts at 0
     * @param newe element to insert
     */
    abstract public void insertAt(int i,E newe);
    
    /**
     * removes element at index 'i'
     * @param i index starts at 0
     */
    abstract public void removeAt(int i);
    
}
