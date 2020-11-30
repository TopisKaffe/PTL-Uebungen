package ueb;

/**
 * Stellt koordinaten eines punktes und grundlegende Methoden 
 * diese zu bearbeiten
 * @author iat103971, iam102916
 */
public class Waypoint {
    private int X;
    private int Y;


    /**
     * Constructor fuer Waypoint mit X- und Y-Parameter
     * @param X Position von X
     * @param Y Position von Y
     */
    public Waypoint(int X, int Y) {
        this.X = X;
        this.Y = Y;
    }    
    
//<editor-fold defaultstate="collapsed" desc="Bisherige Waypoint Methoden">
    
    
    /**
     *initialisation
     * Selbstgebauter default-constructor O.ô
     * @deprecated 
     */
    public Waypoint() {
        this.X = 0;
        this.Y = 0;
    }

    /**
     * gibt X zurueck
     * @return wert von X
     */
    public int getX(){
        return X;
    }
    
    /**
     * gibt Y zureck
     * @return wert von Y
     */
    public int getY(){
        return Y;
    }
    
    /**
     * setzt uebergebene werte fuer X und Y ein
     * @param x wert fuer x
     * @param y wert fuer z
     * @deprecated 
     */
    public void setXY(int x , int y){
        X = x;
        Y = y;
    }
    
    /**
     * berechnet die Strecke zwischen dem punkt other und dem punkt XY
     * wenn other gleich null ist wird 0.0 zurueckgegeben.
     * @param other punkt mit dem gerechnet werden soll
     * @return entfernung zwischen den punkten
     */
    public double calcDistance(Waypoint other){
        if(other !=null){
            return Math.sqrt(Math.pow(X-other.getX(),2)+Math.pow(Y-other.getY(),2));
        }else return 0.0;
    }
    
    /**
     * ueberprueft ob der aktuelle punkt mit dem punkt other uebereinstimmt
     * @param other punkt der getest werden soll
     * @return true wenn die punkte gleich sind, false wenn nich oder other gleich null
     */
    public boolean isEqual(Waypoint other){
//        if(other != null){
//            return ((X == other.getX()) && (Y == other.getY()));
//        }else return false;

        return other != null && ((X == other.getX()) && (Y == other.getY()));
    }
    
    /**
     * erstellt ein Array mit den werten von XY
     * @return das neuerstellte Array
     */
    public int[] toArray(){
        return new int[]{X,Y};
    }
    
    /**
     * erstellt einen String mit den werten von X und Y geklammert und durch einen
     * slash getrennt
     * @return  erstellten string
     */
    public String toString(){
        return "("+X+"/"+Y+")";
    }

//</editor-fold>


}