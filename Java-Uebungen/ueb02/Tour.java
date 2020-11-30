package ueb02;

/**
 * Statische Methoden zur Untersuchung einer Tour, die aus Wegepunkten besteht,
 * welche aus einem int-Array mit einem x- und einem y-Wert bestehen.
 *
 * @author Yannick Schröder, Gerit Kaleck
 */
public class Tour {

    /**
     * Position des x-Wertes im Array eines Wegepunktes
     */
    private static final int X = 0;
    /**
     * Position des y-Wertes im Array eines Wegepunktes
     */
    private static final int Y = 1;

    
    
    public static void main(String[] args) {
    }
    
    /**
     * Berechnet die direkte Entfernung zwischen zwei Wegepunkten. Bei der
     * Berechnung wird dabei ein rechtwinkliges Dreieck zwischen Wegepunkt src
     * und dest gespannt. Anschließend wird die Länge der Hypotenuse berechnet
     * und als direkter Weg bezeichnet. Diagonal zu laufen ist hierbei gewollt.
     *
     * @param src - Wegepunkt des Starts
     * @param dest - Wegepunkt des Ziels
     * @return direkte Dinstanz zwischen src und dest
     * @pre <code>src</code> und <code>dest</code> müssen jeweils 2 Werte
     * enthalten
     */
    private static double calcDistanceBetweenWaypoints(int[] src, int[] dest) {
        assert src.length == 2;
        assert dest.length == 2;
      
        double katX=src[0]-dest[0];
        double katY=src[1]-dest[1];
        
        return Math.sqrt(katX*katX+katY*katY);
    }

    /**
     * Berechnet den Weg, welcher zurück gelegt werden muss, um vom ersten
     * gesetzten Wegepunkt über alle weiteren bis zum letzten Wegepunkt zu kommen.
     * Hierbei soll die Methode <code>calcDistanceBetweenWaypoints()</code> verwendet werden.
     *
     * @param tour - mehrere Wegepunkte in einem Array
     * @return Länge des Wanderweges
     */
    public static double calcDistanceOverAllWaypoints(int[][] tour) {
        double res=0.0f;
        
        for (int i=1;i<tour.length;i++){
            res+=calcDistanceBetweenWaypoints(tour[i-1],tour[i]);
        }
        return res;
    }

    /**
     * Liefert die beiden benachbarten Wegepunkte, deren Distanz am kürzesten
     * ist.
     *
     * @param tour - mehrere Wegepunkte in einem Array
     * @return benachbarte Wegepunkte, deren Distanz zueinander minimal ist, <br>
     * ein leeres Array, wenn weniger als zwei Punkte vorhanden
     */
    public static int[][] getClosestWaypoints(int[][] tour) {
        
        int[][] closestWP=new int[2][2];
        double currMin=0.0f;
        double checkDist=0.0f;
        
        if (tour.length<2){
            return closestWP;
        }else{
            currMin=calcDistanceBetweenWaypoints(tour[0],tour[1]);
            closestWP[0]=tour[0].clone();
            closestWP[1]=tour[1].clone();
        }
        for (int i=1;i<tour.length;i++){
            checkDist=calcDistanceBetweenWaypoints(tour[i-1],tour[i]);
            if(currMin>checkDist){
                currMin=calcDistanceBetweenWaypoints(tour[i-1],tour[i]);
                closestWP[0]=tour[i-1].clone();
                closestWP[1]=tour[i].clone();                
            }
        }
        return closestWP;
    }

 
    /**
     * Liefert eine Tour, die die Wegepunkte der übergebenen Tour von Nord 
     * nach Süd sortiert enthält. Sind Punkte auf gleicher Höhe, so werden 
     * sie von West nach Ost sortiert. Je größer ein Koordinatenwert, desto 
	 * südlicher bzw. östlicher liegt er. 
     *
     * @param tourToSort zu sortierende Tour (darf nicht verändert werden)
     * @return ertellte Tour mit sortierten Wegepunkten
     */
    public static int[][] createTourSortedNorthSouth(int[][] tourToSort) {
        int[][] sorted=tourToSort.clone();
        int currMax= 0;
        int[] safe=new int[2];
        
        for (int i=tourToSort.length-1;i>=0;i--){
            currMax=-1;
            for(int j=i;j>=0;j--){
                if(sorted[j][1]>currMax){
                    currMax=sorted[j][1];
                    safe=sorted[i];
                    sorted[i]=sorted[j].clone();
                    sorted[j]=safe.clone();
                }else if(sorted[j][1]==currMax){
                    if(sorted[j][0]>sorted[i][0]){
                        safe=sorted[i];
                        sorted[i]=sorted[j].clone();
                        sorted[j]=safe.clone();                        
                    }
                }
            }      
        }        
        return sorted;
    }

    /**
     * Berechnet eine "kürzeste" Tour. Kürzeste bedeutetet, dass ausgehend von
     * einem Startpunkt jeweils der nächste naheliegendste Punkt besucht wird,
     * der noch nicht in der Tour berücksichtigt wurde, bis alle Punkte besucht
     * wurden. Je nach Lage der Punkte kann der Algorithmus in einer ineffizient
     * langen Route resultieren. Ob tatsächlich die kürzeste Route gefunden
     * wurde, kann nicht bestimmt werden.
     *
     * @param tour Tour, für die eine kürzeste Route gefunden werden soll 
     *             (Array darf nicht verändert werden)
     * @param idxStartPnt Index des Startpunktes für die kürzeste Tour
     * @return eine neue, (hoffentlich) kürzeste Tour
     */
    public static int[][] createShortestTour(int[][] tour, int idxStartPnt) { 
         boolean[] checkTour = new boolean[tour.length];
         int[][] notShort = new int[tour.length][2];
         double dist=0.0f;
         int last=idxStartPnt;
         int newidx=0;
         
         for(int c=0;c<tour.length;c++){
             checkTour[c]=false;
         }
         checkTour[idxStartPnt]=true;
        notShort[0]=tour[idxStartPnt].clone();
        for (int javaSaugt=1;javaSaugt<tour.length;javaSaugt++){
            dist=120000.0f;
            for (int c=0;c<tour.length;c++){
                if(!checkTour[c]&&dist>calcDistanceBetweenWaypoints(tour[last],tour[c])){
                    dist=calcDistanceBetweenWaypoints(tour[last],tour[c]);
                    newidx=c;
                }
            }
            last=newidx;
            checkTour[newidx]=true;
            notShort[javaSaugt]=tour[newidx].clone();
        }         
        return notShort;
    }
    /**
     * Liefert eine Tour mit den Wegepunkten der übergebenen Tour in der 
     * Reihenfolge, wie sie durch die im Parameter gegebenen Indizes bestimmt 
     * werden.
     *
     * @param tour Tour, aus der eine neue gestaltet werden soll
	 *             (darf nicht verändert werden) 
     * @param indices Indizes der zu verwendenden Wegepunkte
     * @return Tour mit den Wegepunkten in der gegebenen Reihenfolge
     */
    public static int[][] createTourWithOrder(int[][] tour, int[] indices) {
        int[][]order = new int[indices.length][2];
        for(int c=0;c<indices.length;c++){
            order[c]=tour[indices[c]].clone();
        }
        return order;
    }

    
    /**
     * Konvertiert einen Wegepunkt in einen String. Die Werte werden in runde
     * Klammern eingeschlossen und mit Schrägstrich voneinander getrennt: <br>
     * {4, 10} -> (4/10)
     *
     * @param waypoint - Wegepunkt, welcher in einen String überführt werden soll
     * @return der Wegepunkt in Stringdarstellung
     */
    private static String waypointToString(int[] waypoint) {
        String sWaypoint ="(";
        
        sWaypoint=sWaypoint+waypoint[0]+"/"+waypoint[1]+")";
        return sWaypoint;
    }

    /**
     * Stellt eine Tour bestehend aus mehreren Wegepunkten in einem String dar.
     * Hierbei wird die Methode <code>waypointToString</code> genutzt, um jeden 
     * einzelnen Wegepunkt in das gewünschte Format zu bringen. <br>
     * Die Tour wird mit eckigen Klammern umgeben und die Punkte mit 
     * Bindestrich-Größer voneinander getrennt:<br>
     * {{}} -> "[]" <br> {{1,4},{4,10},{12,18}} -> "[(1/4) -> (4/10) ->
     * (12/18)]"
     *
     * @param tour - mehrere Wegepunkte in einem Array
     * @return die Tour als String
     */
    public static String tourToString(int[][] tour) {
        String sTour="[";
        
        for (int i=0;i<tour.length;i++){
           sTour+=waypointToString(tour[i]);
           if (i<tour.length-1){
               sTour+=" -> ";
           }
        }
        sTour+="]";
        return sTour;
    }
}
