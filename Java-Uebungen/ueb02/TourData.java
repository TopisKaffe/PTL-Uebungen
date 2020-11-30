package ueb02;

/**
 * Datenquelle für Touren.
 * @author Yannick Schröder, Gerit Kaleck
 */
public class TourData {

    /**
     * Mehrere Touren mit mehreren Wegepunkten, die aus jeweils x- und y-Wert bestehen.
     */
    private static final int[][][] TOUR = new int[][][]{
        {{0, 0}, {4, 0}, {4, 3}, {0, 3}}, 
        {{0, 0}, {3, 0}, {3, 4}, {0, 0}}, 
        {{1, 3}, {3, 2}, {0, 4}, {2, 2}, {3, 1}, {1, 4}, {2, 3}}, 
        {{-2, -1}, {-2, +3}, {4, 3}, {0, 0}} 
    };
    
    /**
     * Liefert die Anzahl der vorhandenen Touren in der Konstante.
     * @return die Anzahl der vorhandenen Touren
     */
    public static int getCountOfTours() {
        return TOUR.length; 
    }
    
    /**
     * Liefert die tiefe Kopie der Tour.
     *
     * @param idx index der zu kopierenden Tour
     * @return tiefe Kopie der Tour
     */
    public static int[][] createDeepCopyOfTour(int idx) {
        return TOUR[idx].clone(); 
    }    
    
}
