
package ueb05;

/**
 * this class is a parent class for figures and is uesed as payload in 
 * the class Element
 * @author iat103971, iam102916
 */
public class Figure {
    public Color color;
    
    /**
     * Constructor just puts color
     * @param color  color to put
     */
    public Figure(Color color){
        this.color=color;
    }
    
    /**
     * method has Override in sub classes
     * @return 0
     */
    public double getArea(){
        return 0;
    }
    
    /**
     * method has Override in sub classes
     * @return 0
     */
    public double getPerimeter(){
        return 0;
    }
    
    /**
     * compares the area of a given Figure to the area of the current element 
     * @param other Figure to test
     * @return 1 if current is bigger, -1 if other is bigger, 0 if equal 
     */
    public int compare(Figure other){
        if(this.getArea()>other.getArea()){
            return 1;            
        }
        if( this.getArea()<other.getArea()){
            return -1;
        }
        return 0;
    }
    
    /**
     * wrapper method for compare
     * @param object to test with
     * @return true if equal false if not
     */
    @Override
    public boolean equals(Object object){
        if(object!=null && object instanceof Figure){
            return 0 == ((Figure)object).compare(this);
        }else
            return false;
    }
    
    /**
     * method is Overridden in sub classes
     * @return ""
     */
    public String getDescription(){
        
        return"";
    }
}
