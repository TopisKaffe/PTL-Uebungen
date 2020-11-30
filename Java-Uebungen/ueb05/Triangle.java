
package ueb05;

/**
 * subclass of Figure contains triangles
 * @author iat103971, iam102916
 */
public class Triangle extends Figure {
    double lengthA;
    double lengthB;
    double lengthC;
    
    /**
     * Constructor to set the color and all side lengths
     * @param color color to set
     * @param sideA lenght of one side
     * @param sideB lenght of one side
     * @param sideC lenght of one side
     */
    public Triangle(Color color, double sideA, double sideB, double sideC){
        super(color);
        this.lengthA=sideA;
        this.lengthB=sideB;
        this.lengthC=sideC;
    }
    
    /**
     * method to get the area of the triangle
     * @return the area of the triangle
     */
    @Override
    public double getArea(){
        double s = this.getPerimeter()/2;
        return Math.sqrt( s*(s-lengthA)*(s-lengthB)*(s-lengthC) );
    }
    
    /**
     * method to get the perimeter of the triangle
     * @return the perimeter of the triangle
     */
    @Override
    public double getPerimeter(){
        return lengthA+lengthB+lengthC;
    }
    
    /**
     * method to get a string containing all the data of the triangle
     * @return string containing all the data of the triangle
     */
    @Override
    public String getDescription(){
        return String.format("%-9smit Kantenlängen %-25s  Umfang: %6.2f, Fläche: %6.2f",
            "Dreieck",String.format("( %-5.2f,  %-5.2f,  %-5.2f),", lengthA,lengthB,lengthC),this.getPerimeter(),this.getArea());       
    }
}
