
package ueb.list.linked;

import ueb.list.functions.PredicateFunctionObject;

/**
 * class to the define the end the list
 * @author iat103971, iam102916
 */
interface MyElement<E>{
    
    /**
     * checks if the list is empty
     * @return true
     */
    abstract public boolean isEmpty();
    
    /**
     * returns the length of the list
     * @return 0 
     */
    abstract public int length();
    
    /**
     * Checks whether the 2 lists have the same values inside
     * @param kackstifft other element with which to compare
     * @return true if they are equal
     */
    @Override
    abstract public boolean equals(Object kackstifft);
    
    /**
     * payload in subclasses 
     * @return assert false 
     */
    abstract public E getPayload();
    
    /**
     * retuns the next element in subclasses
     * @return assert false
     */
    abstract public MyElement<E> getNext();
    
    /**
     * inserts 'newe' at the end of the list
     * @param newe element to add to the list
     * @return the new element
     */
    
    abstract public MyElement<E> append(E newe);
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
     * @return the changed list unchanged if index is invallid
     */
    abstract public MyElement<E> insertAt(int i,E newe);
    
    /**
     * removes element at index 'i'
     * @param i index starts at 0
     * @return the changed list unchanged if index is invallid
     */
    abstract public MyElement<E> removeAt(int i);
    
    /**
     * 'newe' is the new start of the list 
     * @param newe new start
     * @return the changed list
     */
    abstract public MyElement<E> insertAtFront(E newe);
    
    /**
     * method to Override in MyFilledElement 
     * @return empty string
     */
    @Override
    abstract public String toString();

    /**
     * checks all elements in list with the criteria of 'fill'
     * @param fill functionObject with criteria
     * @return true if the criterai are met
     */
    abstract public boolean forAll(PredicateFunctionObject<E> fill);

    /**
     * checks if there is an object with the criteria of 'fill' and returns it
     * @param fill functionObject with criteria
     * @return null if it was not found or the first element meeting the criteria
     */
    abstract public E find(PredicateFunctionObject<E> fill); 
    
    /**
     * filters THIS list with the criteria of 'fill'
     * @param fill functionObject with criteria
     * @return changed list
     */
    abstract public MyElement<E> filterThis(PredicateFunctionObject<E> fill);
    
    
}
