
package ueb04;

/**
 * klasse besitzt eine tour liste als attribut 
 * und einige methoden zur bearbeitung derselben.
 * @author iat103971, iam102916
 */
public class Tour {
    TourElement knoten;
    
    /**
     * Default construcktor
     */
    public Tour(){
        knoten=null;
    }
    
    /**
     * construcktor mit int array als parameter zur initialisierung der wegpunkte
     * @param wpListe int array als parameter zur initialisierung der wegpunkte
     */
    public Tour(int wpListe[][]){
        //assert(WPList!=null&&WPList[0].length==2);
        if(wpListe!=null&&wpListe.length>0){
            for(int c = wpListe.length-1 ; c >= 0 ; c--){
                    this.knoten = new TourElement(new Waypoint(wpListe[c][0],wpListe[c][1]),this.knoten); 
            }
        }
    }
    
    /**
     * Ueberprueft ob beide touren die gleichen wegpunkte in der gleichen reihenfolge enthalten
     * @param other die tour mit der die aktuelle tour ueberprueft werden soll
     * @return boolean true wenn gleich false wenn nicht
     */
    public boolean isEqual(Tour other){
        //TODO DONE other == null?
        if(other!=null){
            if(this.isEmpty()!=other.isEmpty()){
                return false;
            }
            if(this.isEmpty()&&other.isEmpty()){
                return true;
            }
            return this.knoten.isEqual(other.knoten);
        }
        return false;
    }
    
    /**
     * gibt eine kopie der aktuellen tour zurueck
     * @return eine kopie der aktuellen tour zurueck 
     */
    public Tour copy(){
        Tour tourCpy = new Tour();
        TourElement cpy= knoten;

        if(!this.isEmpty()){        
            tourCpy.knoten=new TourElement(this.knoten.getWaypoint());

            while(cpy.hasNext()){
                tourCpy.knoten.append(cpy.getNext().getWaypoint());
                cpy=cpy.getNext();
            }
        }
        return tourCpy;
    }
    
    
    /**
     * haengt die als parameter uebergebene tour an die aktuelle an 
     * @param other tour die angehaengt werden soll
     * @return laengere tour
     */
    public Tour createConcatenatedTour(Tour other){
        //TODO DONE other == null?
        Tour res = this.copy();
        if(other!=null){
            if(this.knoten!=null&&!other.isEmpty()){
                res.knoten.concat(other.knoten);
            }else if(!other.isEmpty()){
                res = other.copy();
            }
        }
        return res;
    }
    
    /**
     * erstellt eine tour die mit veraenderter reihenfolge 
     * @param indc int array mit neuen indices
     * @return veraenderte tour
     */
    public Tour createTourWithOrder(int[] indc){
        //TODO DONE indc == null?
        Tour res = new Tour();
        
        if (indc!=null){
            //FIXME GEFIXT indc>0 ist gar nicht notwendig, da es schon im Schleifenkopf passiert
            for (int c=0;c<indc.length;c++){
                res.append(this.getWaypointAt(indc[c]));
            }
        } 
        return res;
    }
    
    /**
     * erstellt neue tour mit ausschliesslich elementen die in beiden enthalten sind 
     * @param other zweite tour
     * @return neue tour....
     */
    public Tour createPopularTour(Tour other){
        //TODO DONE other == null?
    	Tour pop = new Tour();
        Tour cpy = this.copy();

        if(other!=null){
            while(cpy.knoten!=null){
                Waypoint checker = cpy.knoten.getWaypoint();
                if (other.contains(checker)&&!pop.contains(checker)) {
                    pop.append(cpy.knoten.getWaypoint());
                }
                cpy.knoten = cpy.knoten.getNext();
            }
        }
    	return pop;
    }
    
    
    /**
     * erstellt eine tour von einem uebergebenen startpunkt aus 
     * immer zum dichtesten wegpunkt laeuft 
     * @param idxStartPnt startpunkt der neuen tour
     * @return neu sortierte tour
     */
    public Tour createShortestTour(int idxStartPnt){
        //TODO DONE getNoOfWaypoints nicht im Schleifenkopf aufrufen
        //TODO DONE idxStartPnt vorher überprüfen
    	Tour shoreTest = new Tour();
        Tour deleTour = this.copy();
        int noOfWp = this.getNoOfWaypoints();
                
        if(idxStartPnt<noOfWp && idxStartPnt>=0){ //FIXME GEFIXT ihr habt noch ein Problem bei negativen Indizes (diese werden bei removeAt von TourElement gar nicht behandelt!)
            deleTour.removeAt(idxStartPnt);
            shoreTest.knoten = new TourElement(this.getWaypointAt(idxStartPnt)) ;
        
            for(int c=0;c<noOfWp-1;c++){
                int idx= deleTour.knoten.getIdxOfClosestWaypoint(shoreTest.getWaypointAt(c));
                shoreTest.append(deleTour.getWaypointAt(idx));
                deleTour.removeAt(idx);
            }
        }
        return shoreTest;
    }
    
    /**
     * loescht alle doppelten elemente der tour 
     * @return tour ohne doppelte
     */
    public Tour createTourWithoutDuplicates(){
    	Tour res = new Tour();
    	while(knoten!=null){
    		if(res.contains(knoten.getWaypoint())){
    			knoten=knoten.getNext();
    		}else{
    			res.append(knoten.getWaypoint());
    		}
    	}
    	return res;
    }
    
    /**
     * fuegt zwei touren zu einer zusammen mit der logic die auch in shortesttour 
     * verwendet wird
     * @param other zweite tour 
     * @return neue tour die aus beiden zusammen gestellt wurde
     */
    public Tour createUnion(Tour other){        
        Tour uni = this.createConcatenatedTour(other);
        
        uni = uni.createTourWithoutDuplicates();
        uni = uni.createShortestTour(0);
        return uni;
    }
    
//<editor-fold defaultstate="collapsed" desc="Bisherige Tour Methoden">
    /**
     * gibt an, ob Listenelemente enthalten sind.
     * @return ob Listenelemente enthalten sind
     */
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
     * und liefert diese Tour zurück.
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
     * und liefert diese Tour zurück.
     * @param waypoint wegpunkt mit x und y koordinaten
     * @return veraenderte tour, unveraendert wenn waypoint gleich null
     */
    public Tour append(Waypoint waypoint){
        if(isEmpty()){
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
     * und liefert diese Tour zurückgegeben. Bei ungueltigem Index passiert nichts.
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
//</editor-fold>
}
