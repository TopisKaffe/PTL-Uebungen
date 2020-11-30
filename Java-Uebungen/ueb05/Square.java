
package ueb05;

/**
 * subclass of Figure contains Squares
 * @author iat103971, iam102916
 */
public class Square extends Figure {
    double length;
    
    /**
     * Constructor witch sets the color of the figure and the length of the sides
     * @param color of figure
     * @param length of the sides
     */
    public Square(Color color, double length){
        super(color);
        this.length=length;
    }
    
    /**
     * method to get the area of the square
     * @return the area of the square
     */
    @Override
    public double getArea(){
        return length*length;
    }
    
    /**
     * method to get the perimeter of the square
     * @return the perimeter of the square
     */
    @Override
    public double getPerimeter(){
        return length*4;
    }
    
    /**
     * method to get a string containing all the data of the square
     * @return string containing all the data of the square
     */
    @Override
    public String getDescription(){
        return String.format("%-9smit Kantenlänge  %-25s  Umfang: %6.2f, Fläche: %6.2f",
                "Quadrat",String.format("( %-5.2f),", length),this.getPerimeter(),this.getArea());
    }
}