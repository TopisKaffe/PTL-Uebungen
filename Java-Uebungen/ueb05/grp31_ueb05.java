
package ueb05;

import static ueb05.Color.*;

/**
 * main class used to create a list of Element
 * also prints the list in standard out via the overwritten Element.toString
 * @author iat103971, iam102916
 */
public class grp31_ueb05 {
    
    
    /**
     * creates an Element and inserts all additional Elements to it
     * see Element.insert for more information
     * @param figures several Elements to be combines into a List
     * @return first Element of the created list
     */
    private static Element createList(Figure... figures) {
        Element head = null;
        if (figures.length > 0) {
            head = new Element(figures[figures.length-1]);
            for (int i = figures.length-2; i >= 0; i--) {
                head = head.insert(figures[i]);
            }
        }
        return head;
    }
    /**
     * main function: see doc this .java (grp31_ueb05.java)
     * @param args not used
     */
    public static void main(String[] args){
        Element list;
        Circle    eins      = new Circle(RED, 3);         
        Square    zwei      = new Square(RED,  2.5);      
        Circle    drei      = new Circle(RED, 3);         
        Square    vier      = new Square(RED,  2.5);      
        Rectangle fuenf     = new Rectangle(RED, 2, 3);   
        Triangle  sechs     = new Triangle(RED, 2, 3, 4); 
        Rectangle sieben    = new Rectangle(RED, 2, 3);   
        Rectangle acht      = new Rectangle(RED, 2, 3);   
        Circle    neun      = new Circle(RED, 3);         
        Square    zehn      = new Square(RED,  2.5);      
        Triangle  elf       = new Triangle(RED, 2, 3, 4); 
        Circle    zwoelf    = new Circle(WHITE, 3);         
        Square    dreizehn  = new Square(WHITE,  2.5);      
        Rectangle vierzehn  = new Rectangle(YELLOW, 2, 3);   
        Triangle  fuenfzehn = new Triangle(YELLOW, 2, 3, 4); 
        Square    sechzehn  = new Square(YELLOW,  4);        
        Rectangle sibzehn   = new Rectangle(BLACK,  2, 8);  
        list = createList(eins,zwei,drei,vier,fuenf,sechs,
                sieben,acht,neun,zehn,elf,zwoelf,dreizehn,vierzehn,
                fuenfzehn,sechzehn,sibzehn);
        System.out.printf(list.toString()); 
    }
    
}
