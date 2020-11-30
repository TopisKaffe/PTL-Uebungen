
package ueb.list.linked;

import ueb.list.functions.PredicateFunctionObject;

/**
 * class for list elements contains the payload of type E
 * and a referenz to the next element
 * @author iat103971, iam102916
 */
class MyFilledElement<E> implements MyElement<E> {
    private E elem;
    private MyElement<E> next;
    
    /**
     * Constructor with element
     */
    public MyFilledElement(E elem){
	this.elem = elem;
    }
    
    /**
     * Constructor with element and next
     */
    public MyFilledElement(E elem, MyElement<E> next){
	this.elem = elem;
	this.next = next;
    }
    
    /**
     * returns the length of the list
     * @return the length of the list
     */
    @Override
    public int length(){
	return 1 + next.length();
    }
    
    /**
     * checks if the list is empty
     * @return false
     */
    @Override
    public boolean isEmpty(){
	return false;
    }
    
    /**
     * returns the payload
     * @return elem 
     */
    @Override
    public E getPayload(){
	return elem;
    }
    
//    /**
//     * Checks whether the 2 lists have the same values inside
//     * @param kackstifft other element with which to compare
//     * @return true if they are equal
//     */
//    @Override
//    public boolean equals(Object kackstifft){
//	if(kackstifft instanceof MyElement){
//	    MyElement<E> kacke2 = (MyElement)kackstifft;
//	
//	    if(kacke2.isEmpty()){
//		return false;
//	    }else{
//		return kacke2.getPayload()==elem?this.next.equals(kacke2.getNext()):false;
//	    }	
//	}
//	return false;	
//    }
    
    /**
     * retuns the next element 
     * @return assert false
     */
    @Override
    public MyElement<E> getNext(){
	return next;
    }
    
    /**
     * inserts 'newe' at the end of the list
     * @param newe element to add to the list
     * @return the changed list
     */
    @Override
    public MyElement<E> append(E newee){
	this.next = this.next.append(newee);
	return this;
    }
    
    /**
     * returns the value at index 'i'
     * @param i index starts at 0
     * @return the value at index 'i' null if index is invallid
     */
    @Override
    public E getValueAt(int i){ 
	return i==0?elem:next.getValueAt(i-1);
    }
   
    /**
     * inserts 'newe' at index 'i'
     * @param i index starts at 0
     * @param newe element to insert
     * @return the changed list unchanged if index is invallid
     */
    @Override
    public MyElement<E> insertAt(int i,E newe){
	if(i==0){
	    return new MyFilledElement<>(newe,this);
	}else{
	    this.next=this.next.insertAt(--i, newe);
	    return this;
	}
    }
    
    /**
     * replaces the element at index 'i'
     * @param i index starts at 0
     * @param newe the element 
     */
    @Override
    public MyElement<E> replaceAt(int i, E newe){
	if(i==0){
	    elem = newe;
	}else
	    this.next=this.next.replaceAt(i-1, newe);
	
	return this;
    }    
    
    /**
     * removes element at index 'i'
     * @param i index starts at 0
     * @return the changed list unchanged if index is invallid
     */
    @Override
    public MyElement<E> removeAt(int i){
	if(i==0){
	    return this.next;
	}else{
	    this.next=this.next.removeAt(--i);
	    return this;
	}
    }
    
    /**
     * 'newe' is the new start of the list 
     * @param newe new start
     * @return the changed list
     */
    @Override
    public MyElement<E> insertAtFront(E newe){
	return new MyFilledElement<>(newe,this);
    }
    
    /**
     * returns the values of the list as a string
     * @return the values of the list as a string
     */
    @Override
    public String toString(){
	return next.isEmpty()?String.format("%s",elem):String.format("%s, ",elem)+next.toString();
    }        

    /**
     * checks all elements in list with the criteria of 'fill'
     * @param fill functionObject with criteria
     * @return true if the criterai are met
     */
    @Override
    public boolean forAll(PredicateFunctionObject<E> fill){
	//return fill.call(elem)?next.forAll(fill):false;
	return fill.call(elem) && next.forAll(fill);
    }
    
    /**
     * checks if there is an object with the criteria of 'fill' and returns it
     * @param fill functionObject with criteria
     * @return null if it was not found or the first element meeting the criteria
     */
    @Override
    public E find(PredicateFunctionObject<E> fill){
	return fill.call(elem)?(E)elem:(E)next.find(fill);
    } 
    
    /**
     * filters THIS list with the criteria of 'fill'
     * @param fill functionObject with criteria
     * @return changed list
     */
    @Override
    public MyElement<E> filterThis(PredicateFunctionObject<E> fill){
	this.next=this.next.filterThis(fill);
	if(fill.call(elem)){
	    return this;
	}else{
	    return this.next;
	    
	}
	
    }

}
