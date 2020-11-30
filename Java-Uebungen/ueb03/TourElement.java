
package ueb03;

/**
 * diese Klasse stellt einen listen knoten mit einem zeiger auf das naechste 
 * Element und weech(Waypoint) als nutz last.
 * zusaetzlich einige rekursiv implementierte methoden zur bearbeitung der Liste
 * @author iat103971
 */
public class TourElement {
    private Waypoint weech;
    private TourElement next;
   
    
    /**
     * inizialisation
     */
    public TourElement(){
        this.weech=null;
        this.next=null;
    }
    
    /**
     * fuellt weech mit den daten von waypoint
     * @param waypoint wegpunkt mit x und y koordinaten
     */
    // TODO: DONE Beschreibung von @param fehlt (bitte ÜBERALL ergänzen) 
    public void setWaypoint(Waypoint waypoint){
        weech=waypoint;
    }
    
    /**
     * ruft setWaypoint fuer das naechste element auf
     * @param waypoint wegpunkt mit x und y koordinaten
     */
    // TODO: DONE Beschreibung von @param fehlt
    public void setNext(Waypoint waypoint){
        TourElement WURST=new TourElement();
        WURST.setWaypoint(waypoint);
        next=WURST;
    }
    
    /**
     * gibt die nuztlast dieses listenelements
     * @return die nuztlast dieses listenelements
     */
    // TODO: DONE @return tag nicht ausgefüllt (bitte ÜBERALL ergänzen)
    public Waypoint getWaypoint(){
       return weech;
    }
    
    /**
     * gibt den zeiger aufs naechste element der liste zurueck
     * @return den zeiger aufs naechste element der liste zurueck
     */
    public TourElement getNext(){
        return next;
    }
    
    /**
     * ueberprueft ob ein naechstes element existiert
     * @return ob ein naechstes element existiert
     */
    public boolean hasNext(){
        return (next!=null);
    }
    
    /**
     * zaehlt die vorhandenen listen elemente
     * @return anzahl der vorhandenen listen elemente
     */
    public int getNoOfWaypoints(){
        if(hasNext()){
           return next.getNoOfWaypoints()+1;
        }else{
           return 1;
        }
    }
    
    /**
     * uberprueft op waypoint in der aktuellen liste enthalten ist
     * @param waypoint wegpunkt mit x und y koordinaten
     * @return op waypoint in der aktuellen liste enthalten ist
     */
    public boolean contains(Waypoint waypoint){
        if(weech.isEqual(waypoint)){
            return true;
        }else{
            if(hasNext()){
                return next.contains(waypoint);
            }else{
                return false;
            }        
        }
    }
    
    /**
     * summiert die strecke ueber alle wegepunkte auf der liste
     * @return strecke ueber alle wegepunkte auf der liste
     */
    public double calcDistance(){
        if(hasNext()){
            return next.weech.calcDistance(weech)+next.calcDistance();
        }else{
            return 0;
        }
    }
    
    /**
     * gibt den wegpunkt der liste an der stelle index zurueck 
     * wenn der wert von in kleiner 0 ist oder groesser als die liste
     * wegepunkte hat dann wird null zurueck gegeben
     * @param index wegpunkt der liste an der stelle index
     * @return wegpunkt anstelle index, wenn index zu gross oder kleiner 0: null
     */
    public Waypoint getWaypointAt(int index){
        if(index<0) return null;
        if(index == 0){
            return getWaypoint();
        }else if(hasNext()){
            return next.getWaypointAt(index-1);
        }else return null;
    }
    
    /**
     * fuegt den uebergebenen wegepunkt(waypoint) am anfang der liste an
     * wenn "waypoint" gleich null ist wird die unveraenderte liste zurueckgegeben
     * @param waypoint wegpunkt mit x und y koordinaten
     * @return liste inklusive waypoint wenn dieser null ist wird nichts veraendert
     */
    public TourElement addStart(Waypoint waypoint){
        if(waypoint==null){
            return this;
        }else{
            if(weech==null){
                setWaypoint(waypoint);
                return this;
            }
            TourElement unnoetig = new TourElement();
            unnoetig.weech=waypoint;
            unnoetig.next=this;
            return unnoetig;
        } 
    }
    
    /**
     * haengt den uebergebenen wegepunkt am ende der liste an
     * wenn waypoint gleich null return unveraenderte liste
     * @param waypoint wegpunkt mit x und y koordinaten
     * @return liste wenn wazpoint null unveraenderte liste
     */
    public TourElement append(Waypoint waypoint){
        if(waypoint!=null){
            if(hasNext()){
                next=next.append(waypoint);
            }else{
                TourElement unnoetig = new TourElement();
                unnoetig.weech=waypoint;
                next=unnoetig;
            }
        }
        return this;
    }
    
    /**
     * fuegt den uebergebenen wegepunkt an der stelle index in die liste ein
     * wenn index kleiner 0 oder der uebergebene wegepunkt ungueltig ist 
     * wird die tour unveraendert zurueckgegeben
     * @param index stelle an der eingefuegt werden soll
     * @param waypoint wegpunkt mit x und y koordinaten
     * @return liste, wenn waypoint null oder index ungueltig die unveraenderte liste
     */
    // TODO: DONE Tests schlagen fehl: Liste erst leer, dann wird 1 Punkt bei 0 hinzugefügt, dann wird der Punkt bei Index 1 abgerufen - erwatet null, bekommt Punkt bei Index 0!
    // TODO: DONE Tests schlagen fehl: Hinzufügen bei Index 4, wenn Liste nur 3 Elemente hat (soll nicht angeängt werden)
    public TourElement insertAt(int index, Waypoint waypoint){
        if( waypoint==null || index < 0 ){
            return this;
        }else if(index==0){
            return this.addStart(waypoint);
        }else{
            if(hasNext()){
               next = next.insertAt(index-1,waypoint);
               return this;
            }else{
                return index==1 ? this.append(waypoint) : this;
            }
        }
    }
    
    /**
     * loescht das element der liste das sich an position index befindet
     * @param index stelle an der das element geloescht werden soll
     * @return veraenderte liste, unveraendert wenn index kleiner 0 oder 
     *      groesser als die anyahl der listen elemente
     */
    public TourElement removeAt(int index){
        if(index==0){
            return next;
        }else{
            if(hasNext()){
                next=next.removeAt(index-1);    
            } 
            return this;
        }
    }
    
    /**
     * konvertiert die gesammte liste in einen string...
     * @return neuerstellten string
     */
    public String toString(){
        if(hasNext()){
            return weech.toString()+" -> "+next.toString();
        }else return weech.toString();
    }
}