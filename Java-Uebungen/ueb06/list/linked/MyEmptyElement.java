
package ueb.list.linked;

import ueb.list.functions.PredicateFunctionObject;

/**
 * class to the define the end the list
 * @author iat103971, iam102916
 */
class MyEmptyElement<E> implements MyElement<E>{
    
    /**
     * checks if the list is empty
     * @return true
     */
    public boolean isEmpty(){
	return true;
    }
    
    /**
     * returns the length of the list
     * @return 0 
     */
    public int length(){
	return 0;
    }
    
    /**
     * Checks whether the 2 lists have the same values inside
     * @param kackstifft other element with which to compare
     * @return true if they are equal
     */
    @Override
    public boolean equals(Object kackstifft){
        //if(kackstifft.getClass() == this.getClass())
	if (kackstifft instanceof MyElement){
	    
	    MyElement<E> kacke2 = (MyElement)kackstifft;
	    return kacke2.isEmpty(); 
	}
	return false;
    }
    
    /**
     * payload in subclasses 
     * @return assert false 
     */
    public E getPayload(){
	assert(false);
	return null;
    }
    
    /**
     * retuns the next element in subclasses
     * @return assert false
     */
    public MyElement<E> getNext(){
	assert(false);
	return this;
    }
    
    /**
     * inserts 'newe' at the end of the list
     * @param newe element to add to the list
     * @return the new element
     */
    public MyElement<E> append(E newe){
	return new MyFilledElement<>(newe,this);
    }
    
    /**
     * returns the value at index 'i'
     * @param i index starts at 0
     * @return the value at index 'i' null if index is invallid
     */
    public E getValueAt(int i){
	return null;
    }
    
    /**
     * inserts 'newe' at index 'i'
     * @param i index starts at 0
     * @param newe element to insert
     * @return the changed list unchanged if index is invallid
     */
    public MyElement<E> insertAt(int i,E newe){
	return i==0?new MyFilledElement<>(newe,this):this; 
    }
    
    /**
     * removes element at index 'i'
     * @param i index starts at 0
     * @return the changed list unchanged if index is invallid
     */
    public MyElement<E> removeAt(int i){
	return this;
    }
    
    /**
     * 'newe' is the new start of the list 
     * @param newe new start
     * @return the changed list
     */
    public MyElement<E> insertAtFront(E newe){
	return new MyFilledElement<>(newe,this);
    }
    
    /**
     * method to Override in MyFilledElement 
     * @return empty string
     */
    @Override
    public String toString(){
	return "";
    }

    /**
     * checks all elements in list with the criteria of 'fill'
     * @param fill functionObject with criteria
     * @return true if the criterai are met
     */
    public boolean forAll(PredicateFunctionObject<E> fill){
	return true;
    }
    
    /**
     * checks if there is an object with the criteria of 'fill' and returns it
     * @param fill functionObject with criteria
     * @return null if it was not found or the first element meeting the criteria
     */
    public E find(PredicateFunctionObject<E> fill){
	return null;
    } 
    
    /**
     * filters THIS list with the criteria of 'fill'
     * @param fill functionObject with criteria
     * @return changed list
     */
    public MyElement<E> filterThis(PredicateFunctionObject<E> fill){
	return this;
    }
    
    
}
