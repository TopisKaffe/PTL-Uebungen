
package ueb03;

/**
 * klasse besitzt eine tour liste als attribut 
 * und einige methoden zur bearbeitung derselben.
 * @author iat103971
 */
public class Tour {
    TourElement knoten;
    /**
     * gibt an, ob Listenelemente enthalten sind.
     * @return ob Listenelemente enthalten sind
     */
    // TODO: DONE auch hier überall das @return ausfüllen
    public boolean isEmpty(){
        return knoten==null;
    }
    
    /**
     *  liefert den Startpunkt der Tour, null bei leerer Liste.
     * @return Startpunkt der Tour, null bei leerer Liste
     */
    public Waypoint getStartPoint(){
        if(isEmpty()){
        return null;
        }
        return knoten.getWaypoint();
    }
    
    /**
     *  liefert die Anzahl der enthaltenen Wegepunkte.
     * @return Anzahl der enthaltenen Wegepunkte
     */
    public int getNoOfWaypoints(){
        if(isEmpty()){
            return 0;
        }
        return knoten.getNoOfWaypoints();
    }
    
    /**
     *  liefert die Gesamtlaenge der Tour bei Aufsuchen aller Wegepunkte.
     * @return Gesamtlaenge der Tour bei Aufsuchen aller Wegepunkte
     */
    public double calcDistance(){
        if(isEmpty()){
            return 0.0;
        }
        return knoten.calcDistance();
    }
    
    /**
     * liefert den Wegepunkt an der Stelle index, null bei ungültigem Index.
     * @param index stelle des gewuenschten wegpunkts
     * @return Wegepunkt an der Stelle index, null bei ungültigem Index
     */
    // TODO: DONE auch hier überall das @param ausfüllen
    public Waypoint getWaypointAt(int index){
        if(isEmpty()){
        return null;
        }
        return knoten.getWaypointAt(index);
    }
    
    /**
     * prüft, ob ein Wegepunkt enthalten ist.
     * @param waypoint wegpunkt mit x und y koordinaten
     * @return wenn enthalten true false wenn nicht
     */
    public boolean contains(Waypoint waypoint){
        if(isEmpty()){
        return false;
        }
        return knoten.contains(waypoint);
    }
    
    /**
     * fügt den übergebenen Wegepunkt an den Anfang der Liste 
 und liefert diese Tour zurück.
     * @param waypoint wegpunkt mit x und y koordinaten
     * @return veraenderte tour, unveraenderte tour wenn waypoint null
     */
    public Tour addStart(Waypoint waypoint){
        if(isEmpty()){
            this.knoten = new TourElement();
            this.knoten.setWaypoint(waypoint);
        }else{
            this.knoten = knoten.addStart(waypoint);
        }
        return this;
    }
    
    /**
     * fügt den übergebenen Wegepunkt an das Ende der Liste 
 und liefert diese Tour zurück.
     * @param waypoint wegpunkt mit x und y koordinaten
     * @return veraenderte tour, unveraendert wenn waypoint gleich null
     */
    public Tour append(Waypoint waypoint){
        if(isEmpty()){
            // TODO: DONE Test schlägt fehl: an leere Liste einen Punkt anhängen
            // TODO 2: DONE schlägt immer noch fehl für leere Liste: nachdem ein Punkt angehängt wurde, sollte tour.getWaypointAt(1) null ergeben, es kommt aber der Wegpunkt zurück
            this.knoten = new TourElement();
            this.knoten.setWaypoint(waypoint);
        }else{
            this.knoten = knoten.append(waypoint);
        }
        return this;
    }
    
    /**
     * fuegt das uebergebene element an der stelle index ein wenn index groesser
     * gleich 0 und kleiner gleich laenge der liste plus 1
     * @param index stelle an der eingefuegt werden soll
     * @param waypoint wegpunkt mit x und y koordinaten
     * @return bearbeitete liste unveraendert wenn index oder waypoint ungueltig
     */
    public Tour insertAt(int index, Waypoint waypoint){
        // TODO 2: DONE schlägt fehl für leere Liste: nachdem ein Punkt angehängt wurde, sollte tour.getWaypointAt(1) null ergeben, es kommt aber der Wegpunkt zurück
        if(isEmpty() && index != 0){
            return null;
        }
        if(isEmpty() && index == 0){
            this.knoten = new TourElement();
            this.knoten.setWaypoint(waypoint);
        }else{
            this.knoten = knoten.insertAt(index, waypoint);
        }
        return this;
    }
    
    /**
     * fügt den übergebenen Wegepunkt am Index in die Liste ein 
 und liefert diese Tour zurückgegeben. Bei ungueltigem Index passiert nichts.
     * @param index stelle an der geloescht werden soll
     * @return veraenderte liste, unveraendert wenn index ungueltig
     */
    public Tour removeAt(int index){
        if(isEmpty()){
        return null;
        }
        this.knoten = knoten.removeAt(index);
        return this;
    }
    
    /**
     * liefert eine Stringdarstellung der Tour
     * @return erstellter string
     */
    public String toString(){
        if(isEmpty()){
            return "[]";
        }else{
            return "["+this.knoten.toString()+"]";
        }
    }
}
