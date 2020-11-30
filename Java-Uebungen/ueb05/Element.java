
package ueb05;

/**
 * Class to bild a list with Figures as payload
 * @author iat103971, iam102916
 */
public class Element {
    public final Figure figure;
    public Element next;
    
    /**
     * Constructer 
     * @param figure  payload
     */
    public Element(Figure figure){
        this.figure=figure;
    }
    
    /**
     * Constructor
     * @param figure payload
     * @param next next element
     */
    public Element(Figure figure, Element next){
        this.figure=figure;
        this.next = next;
    }
    
    /**
     * insert a given payload  sorted in a existing list
     * @param figure payload to insert
     * @return head of changed list unchanged list if figure = null
     */
    public Element insert(Figure figure){
        if(figure==null)return this;
        if(this.figure.compare(figure)==-1){
            Element newStart = new Element(figure,this);
            return newStart;
        }else if(this.next!=null){
            this.next=this.next.insert(figure);
        }else{
            Element newEnd = new Element(figure,null);
            this.next=newEnd;
        }
                            
        return this;
    }
    
    /**
     * counts the elements in list
     * @return number of elements
     */
    public int size(){
        if(this.next!=null){
            return 1 + next.size();
        }else
            return 1;
    }
    
    /**
     * puts the payloads of this list in an array of Figure
     * @return array of Figure
     */
    public Figure[] getValues(){
        int size= this.size();
        Element krueppel=this;
        Figure[] res= new Figure[size];
        for (int c=0;c<size;c++){
            res[c]=krueppel.figure;
            krueppel=krueppel.next;
        }
        return res;
    }
    /**
     * Recursive method used to build a string from all Elements
     * also see "toString" directly below
     * @param dooku parameter is incremented with each call to count and display
     * the number of elements
     * @return the finished String listing all Elements
     */
    
    private String stillIsNotAValidUseOfRecursion(int dooku){
        if(figure.color!=null){
            if(next!=null){
                return String.format("%2d. %-16s %s\n", dooku, figure.color.toString(),figure.getDescription())+next.stillIsNotAValidUseOfRecursion(++dooku);
            }else{
                return String.format("%2d. %-16s %s\n", dooku, figure.color.toString(),figure.getDescription());
            }            
        }else
            if(next!=null){
                return String.format("%2d. %-16s %s\n", dooku, "unknown",figure.getDescription())+next.stillIsNotAValidUseOfRecursion(++dooku);
            }else{
                return String.format("%2d. %-16s %s\n", dooku, "unknown",figure.getDescription());
            }
    }
    /**
     * Uses the method "stillIsNotAValidUseOfRecursion" above to create a list
     * with all Elements and their descriptions as a String, where each Element
     * has its own line
     * @return list with all Elements and their descriptions
     */
    @Override
    public String toString(){
        return this.stillIsNotAValidUseOfRecursion(1);
    }
        
    /**
     * -Checks if this Element and all following Elements are equal to "obj"
     * where "obj" is meant to be another Element.
     * -Equal means both lists have the same length and each element has the same
     * size in the same order.
     * @param obj Element to compare with
     * @return true if they are equal, otherwise false
     */
    @Override
    public boolean equals(Object obj){
        if( obj == null || !(obj instanceof Element)){
            return false;
        }
       
        if((((Element)obj).figure.compare(figure)!=0)){
            return false;
        }
        
        if((next!=null)^(((Element)obj).next!=null)){
            return false;
        }
        
        if( (this.next!=null) ){
            return next.equals(((Element)obj).next);
        }else
            return true;
    }
}
