/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ueb02;

/**
 * Ausgabe-Klasse, welche die Touren in vorgegebenem Format und den gegebenen
 * Methoden aufruft und eben halt ausgibt.
 * @author iam102916, iat103971
 */
public class Grp31_ueb02 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        int[] newindices = new int[5];
        newindices[0]=1;
        newindices[1]=2;
        newindices[2]=0;
        newindices[3]=3;
        newindices[4]=1;
        
        int shortIdx=0;
        String outPut;
        
        System.out.printf("Indices for new order: ");
        for (int d=0;d<newindices.length;d++){
            System.out.printf("%d ", newindices[d]);
        }
        System.out.printf("\n-----------------------------\n");
        
        for(int c=0;c<TourData.getCountOfTours();c++){
            int[][]currTour=TourData.createDeepCopyOfTour(c);
            
    
            //First line
            outPut="TOUR["+c+"]";
            System.out.printf("%-21s : %s, distance: %.2f\n",
                    outPut,
                    Tour.tourToString(currTour),
                    Tour.calcDistanceOverAllWaypoints(currTour));
            //Second line
            outPut="closest waypoints";
            System.out.printf("%-21s : %s, distance: %.2f\n",
                    outPut,
                    Tour.tourToString(Tour.getClosestWaypoints(currTour)),
                    Tour.calcDistanceOverAllWaypoints(Tour.getClosestWaypoints(currTour)));
            //Third line
            outPut="sorted NorthSouth";
            System.out.printf("%-21s : %s, distance: %.2f\n",
                    outPut,
                    Tour.tourToString(Tour.createTourSortedNorthSouth(currTour)),
                    Tour.calcDistanceOverAllWaypoints(Tour.createTourSortedNorthSouth(currTour)));
            //Fourth line
            outPut="short tour start at 0";
            System.out.printf("%-21s : %s, distance: %.2f\n",
                    outPut,
                    Tour.tourToString(Tour.createShortestTour(currTour, shortIdx)),
                    Tour.calcDistanceOverAllWaypoints(Tour.createShortestTour(currTour, shortIdx)));
            //Fifth line
            outPut="new ordered tour";
            System.out.printf("%-21s : %s, distance: %.2f\n",
                    outPut,
                    Tour.tourToString(Tour.createTourWithOrder(currTour, newindices)),
                    Tour.calcDistanceOverAllWaypoints(Tour.createTourWithOrder(currTour, newindices)));
            //First line again but without distance
            outPut="TOUR["+c+"]";
            System.out.printf("%-21s : %s\n",
                    outPut,
                    Tour.tourToString(currTour));            
            System.out.printf("-----------------------------\n");
        }
        
        
    }
    
    
}
