
package ueb05;

/**
 *Enum class for colors 
 * @author iat103971, iam102916
 */
public enum Color {
    BLACK   (0x00, 0x00, 0x00),
    NAVY    (0x00, 0x00, 0x80),
    BLUE    (0x00, 0x00, 0xFF),
    GREEN   (0x00, 0x80, 0x00),
    LIME    (0x00, 0xFF, 0x00),
    AQUA    (0x00, 0xFF, 0xFF),
    PURPLE  (0x80, 0x00, 0x80),
    SILVER  (0xC0, 0xC0, 0xC0),
    RED     (0xFF, 0x00, 0x00),
    FUCHSIA (0xFF, 0x00, 0xFF),
    YELLOW  (0xFF, 0xFF, 0x00),
    WHITE   (0xFF, 0xFF, 0xFF);

    /* the values are handled like attributes */
    private final int r;
    private final int g;
    private final int b;

    /* there must be a public getter for each attribute */
    public int getR() {return r;}
    public int getG() {return g;}
    public int getB() {return b;}

    /* there must be a private constructor that takes all attributes */
    private Color(int red, int green, int blue) {
        this.r = red;
        this.g = green;
        this.b = blue;
    }    
    
    /**
     * method to validate three int variables if they match with 
     * values of of this enum
     * @param red    red value
     * @param green  green value   
     * @param blue   blue value
     * @return one of defined colors or null
     */
    public static Color getColor(int red, int green, int blue){
        int limit = values().length;
        
        for(int c = 0; c<limit; c++){
            Color test = values()[c];
            if (test.r==red&&
                test.g==green&&
                test.b==blue)
            {
                return test;
            }
        }
        return null;
    }
    
    /**
     * method to validate three int variables if they match with 
     * values of of this enum
     * @param color array of int with lenth three
     * @return one of defined colors or null
     */
    public static Color getColor(int[] color){
        if(color!=null){
            return getColor(color[0],color[1],color[2]);
        }
        return null;
    }
    
    /**
     * compares a given string with the names of all defined colors
     * @param color string to test
     * @return one of defined colors or null 
     */
    public static Color getColor(String color){
        if(color!=null){
            int limit = values().length;
            color=color.toUpperCase();

            for(int c = 0; c<limit; c++){
                Color test = values()[c];
                if (test.name().toUpperCase().compareTo(color)==0)
                {
                    return test;
                }
            }
        }
        return null;        
    }
    
    /**
     * turns the packed RGB value of the parameter "color" into a "Color"
     * if it is a defined "Color"
     * @param color packed RGB value into one int.
     *        each channel has 8 bits
     * @return if "color" is defined it returns the defined Color. 
     *         Otherwise null
     */
    public static Color getColor(int color){
        int blue =  color & 255;
        int green = (255 & color >>> 8);
        int red = (255 & color >>> 16);

        return getColor(red,green,blue);
    }
    
    /**
     * tests if the given rbg values represents a defined color
     * @param rgb int array with values  to test: [0]=r, [1]=g, [2]=b
     * @return true if it is defined false if not 
     */
    public static boolean isKnownColor(int[] rgb){
        return getColor(rgb)!=null;
    }
    
    /**
     * tests if the given string represents a defined color
     * @param color string to test
     * @return true if it is defined false if not 
     */
    public static boolean isKnownColor(String color){
        return getColor(color)!=null;
    }
    
    /**
     * method to get the rgb values of the current Figure in a int array
     * @return rgb values of the current Figure in a int array [0]=r, [1]=g, [2]=b
     */
    public int[] getRGB(){
        int[] res = new int[3];
        res[0]=this.r;
        res[1]=this.g;
        res[2]=this.b;
        return res;
    }
    
    /**
     * method to get the rgb values of colorName if its defined in a int array 
     * @param colorName color to get rbgs from 
     * @return rgb values of the current Figure in a int array [0]=r, [1]=g, [2]=b
     */
    public static int[] getRGB(String colorName){
        if (colorName!=null){
            return getColor(colorName).getRGB();
        }
        return null;
    }    
    
    /**
     * puts r, g, and b, values of current color in one integer value
     * @return packed integer
     */
    public int getPackedRGB(){
        return (this.r <<16) + (this.g << 8) + (this.b);
    }
    
    /**
     * formates a string inclouding the name of current color and  the associated
     * rgb values 
     * @return formated string!!!
     */
    @Override
    public String toString(){
        return String.format("%-8s #%06X", this.name(), this.getPackedRGB());
    }
    
}
