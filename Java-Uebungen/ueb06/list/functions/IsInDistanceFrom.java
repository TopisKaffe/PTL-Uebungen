package ueb.list.functions;
import ueb.Waypoint;
/**
 * function object returning true on call if the given waypoint 'neu' and the called element
 * is within distance of 'dit' 
 * @author iat103971, iam102916
 */
public class IsInDistanceFrom extends PredicateFunctionObject<Waypoint> {
    //attributes
    Waypoint rev;
    double Dist;
    
    /**
     * function constructor giving the values for 'call'
     * @param neu
     * @param dit
     */
    public IsInDistanceFrom(Waypoint neu,double dit){
	rev = neu;
	Dist=dit;
    }
    
    /**
     * the actual function. calculates the distance between p and the caller
     * returns true if it is within the given distance
     * @param p the waypoint the calculate the distance with
     * @return true if within distance
     */
    @Override
    public boolean call(Waypoint p){
	return rev.calcDistance(p)<Dist;
    }
}
