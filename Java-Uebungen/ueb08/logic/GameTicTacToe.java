package logic;

import static logic.GameTicTacToe.Symbol.*;

/**
 * TODO add comment
 *
 * @author cei
 */
public class GameTicTacToe {

    /**
     * Name of the players in an array. Length must be 2.
     */
    private String[] players;
    /**
     * Index of the player. Must be either 0 or 1.
     */
    private int idxCurrPlayer;
    /**
     * Connection to the gui.
     */
    private GUIConnector gui;
    
    private int[] marvin={0,0};
    
    private int winnn=3;
      /**
     * Enum for the symbols used by the players. The ordinal value of the
     * respective symbol of a player should correspond with the index of this
     * player in the player array. The additional value "EMPTY" (marking an
     * empty cell) thus has the highest ordinal value. Visibility should be as
     * restricted as possible.
     */
    public enum Symbol {X,O,EMPTY}
    /**
     * The 2-dimensional field on which the player play.
     */
    private Symbol[][] leckmichdoch;
    /**
     * Constructor for a game of tic tac toe. Initializes the field.
     *
     * @param p1 name of the first player
     * @param p2 name of the second player
     * @param size size of the game field
     * @param gui connection to the gui
     */
    public GameTicTacToe(String p1, String p2, int size, GUIConnector gui) {
        this.players = new String[]{p1, p2};
        this.idxCurrPlayer = 0;
        this.gui = gui;
        this.gui.nanny();
        leckmichdoch=new Symbol[size][size];
        for (int bla=0;bla<size;bla++){
            for(int blub=0; blub<size;blub++){
                leckmichdoch[bla][blub]=EMPTY;
            }
        }
        this.winnn=size;        
    }
    
    public GameTicTacToe(String[] player , Symbol[][] startBoard, GUIConnector gui){
        this.players = player;
        this.idxCurrPlayer = 0;
        this.gui = gui;
        this.winnn=startBoard.length;
        this.gui.nanny();
        leckmichdoch=startBoard;
    }

    /**
     * Handles the turn of a player. If the cell chosen by the player is not
     * empty, nothing happens (the player can chose another cell). If it was
     * empty, the symbol of the current player is placed and the update of the
     * gui is initiated. Then the current player is changed, so that it is the
     * turn of the next player. Finally, the method checks if through this turn
     * a player has won the game.
     *
     * @param coord coordinate in the field at which the player wants to place
     * his/her symbol, length must be 2 otherwise program terminates through
     * assert
     */
    public void playerTurn(int[] coord) {
        //TODO
        if(leckmichdoch[coord[0]][coord[1]]==Symbol.EMPTY){
            gui.displaySymbol(coord, GameTicTacToe.Symbol.values()[idxCurrPlayer]);
            leckmichdoch[coord[0]][coord[1]]=Symbol.values()[idxCurrPlayer];
            idxCurrPlayer^=1;
            
            gui.setCurrentPlayer(players[idxCurrPlayer], GameTicTacToe.Symbol.values()[idxCurrPlayer]);
            
        }
        
        this.handleEndOfGame();
        
    }
    
    protected boolean emptyCellsLeft(){
        boolean empty = false;
        for(int c=marvin[0];c<leckmichdoch.length&&!empty;c++){
            for(int b=marvin[1];b<leckmichdoch.length&&!empty;b++){
                marvin[1]=b;
                empty= leckmichdoch[c][b]==EMPTY;
            }
            marvin[1]=0;
            marvin[0]=c;
        }
        
        return empty;
    }
    
    String fieldToString(){
        String feld="";
        
        for(int fxus=0;fxus<leckmichdoch.length;fxus++){
            for(int durch=0;durch<leckmichdoch.length;durch++){
                feld += String.format("%5s ", leckmichdoch[durch][fxus]);
            }
            feld += "\n";   
        }
        return feld;
    }
    
    protected void handleEndOfGame(){
        String winora=getWinnerName();
        if(winora!=null){
            gui.onGameEnd(winora);
        }
    }
    
    protected String getWinnerName(){
        String winnerName="null";
        int xCount=0;
        int oCount=0;
        
        for(int eger=0; winnerName.matches("null")&&eger<leckmichdoch[0].length;eger++){
            for(int elligenz=0; elligenz<leckmichdoch[0].length;elligenz++){
                if(leckmichdoch[eger][elligenz]==Symbol.X){ xCount++; oCount=0;}
                if(leckmichdoch[eger][elligenz]==Symbol.O){ oCount++; xCount=0;}
                if(leckmichdoch[eger][elligenz]==Symbol.EMPTY){ oCount=0; xCount=0;}
                
                if(xCount==winnn){ winnerName = this.players[0]; }
                if(oCount==winnn){ winnerName = this.players[1]; }
            }
            xCount=0;
            oCount=0;
        }
        
        for(int eger=0; winnerName.matches("null")&&eger<leckmichdoch[0].length;eger++){
            for(int elligenz=0; elligenz<leckmichdoch[0].length;elligenz++){
                if(leckmichdoch[elligenz][eger]==Symbol.X){ xCount++; oCount=0;}
                if(leckmichdoch[elligenz][eger]==Symbol.O){ oCount++; xCount=0;}
                if(leckmichdoch[elligenz][eger]==Symbol.EMPTY){ oCount=0; xCount=0;}
                
                if(xCount==winnn){ winnerName = this.players[0]; }
                if(oCount==winnn){ winnerName = this.players[1]; }
            }
            xCount=0;
            oCount=0;
        }
        
                
        for( int k = 0 ; k < leckmichdoch.length * 2 ; k++ ) {
            for( int j = 0 ; j <= k ; j++ ) {
                int i = k - j;
                if( i < leckmichdoch.length && j < leckmichdoch.length ) {
                        if(leckmichdoch[i][j]==Symbol.X){ xCount++; oCount=0;}
                        if(leckmichdoch[i][j]==Symbol.O){ oCount++; xCount=0;}
                        if(leckmichdoch[i][j]==Symbol.EMPTY){ oCount=0; xCount=0;}

                        if(xCount==winnn){ winnerName = this.players[0]; }
                        if(oCount==winnn){ winnerName = this.players[1]; }
                }
            }
            xCount=0;
            oCount=0;
        }
        
        
        Symbol[][] spinArr = new Symbol[leckmichdoch.length][leckmichdoch.length];
        for ( int spin = 0; spin < leckmichdoch.length;spin++){
            for( int spin2 = 0; spin2 < leckmichdoch.length; spin2++){
                spinArr[spin][spin2]=leckmichdoch[(leckmichdoch.length-1)-spin][spin2];
            }
        }
        for( int k = 0 ; k < spinArr.length * 2 ; k++ ) {
            for( int j = 0 ; j <= k ; j++ ) {
                int i = k - j;
                if( i < spinArr.length && j < spinArr.length ) {
                        if(spinArr[i][j]==Symbol.X){ xCount++; oCount=0;}
                        if(spinArr[i][j]==Symbol.O){ oCount++; xCount=0;}
                        if(spinArr[i][j]==Symbol.EMPTY){ oCount=0; xCount=0;}

                        if(xCount==winnn){ winnerName = this.players[0]; }
                        if(oCount==winnn){ winnerName = this.players[1]; }
                }
            }
            xCount=0;
            oCount=0;
        }
               
        return winnerName=="null"?null:winnerName;
    }
    
}
