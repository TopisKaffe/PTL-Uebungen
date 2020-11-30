
package ueb05;

/**
 * subclass of Figure contains rectangles
 * @author iat103971, iam102916
 */
public class Rectangle extends Figure {
    double lengthA;
    double lengthB;
    
    public Rectangle(Color color, double sideA, double sideB){
        super(color);
        lengthA=sideA;
        lengthB=sideB;
    }
    
    /**
     * method to get the area of the rectangle
     * @return the area of the rectangle
     */
    @Override
    public double getArea(){
        return lengthA*lengthB;
    }
    
    /**
     * method to get the perimeter of the rectangle
     * @return the perimeter of the rectangle
     */
    @Override
    public double getPerimeter(){
        return 2*lengthA+2*lengthB;
    }
    
    /**
     * method to get a string containing all the data of the rectangle
     * @return string containing all the data of the rectangle
     */
    @Override
    public String getDescription(){
        return String.format("%-9smit Kantenlängen %-25s  Umfang: %6.2f, Fläche: %6.2f",
            "Rechteck",String.format("( %-5.2f,  %-5.2f),", lengthA,lengthB),this.getPerimeter(),this.getArea());       
    }
}
