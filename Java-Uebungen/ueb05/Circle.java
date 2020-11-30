
package ueb05;

/**
 * subclass of Figure contains circles
 * @author iat103971, iam102916
 */
public class Circle extends Figure {
    double diameter;
    
    public Circle(Color color, double diameter){
        super(color);
        this.diameter=diameter;
    }
    
    /**
     * method to get the area of the circle
     * @return the area of the circle
     */
    @Override
    public double getArea(){
        return (this.diameter/2)*(this.diameter/2) * Math.PI;
    }
    
    /**
     * method to get the perimeter of the circle
     * @return the perimeter of the circle
     */
    @Override
    public double getPerimeter(){
        return (this.diameter/2)* Math.PI *2;
    }
    
    /**
     * method to get a string containing all the data of the circle
     * @return string containing all the data of the circle
     */
    @Override
    public String getDescription(){
        return String.format("%-9smit Durchmesser  %-25s  Umfang: %6.2f, Fläche: %6.2f",
            "Kreis",String.format("( %-5.2f),", diameter),this.getPerimeter(),this.getArea());       
    }
}
