package gui;

import logic.GUIConnector;
import logic.GameTicTacToe.Symbol; 
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.layout.GridPane;

/**
 * This class is responsible for changing the gui when the logic deems it
 * necessary. Created by the gui and then passed as a parameter into the logic.
 * <br>
 * Addtional private or protected methods may be added to this.
 *
 * @author cei
 */
public class JavaFXGUI implements GUIConnector {

    /**
     * The buttons of the game field stored in an array (position in the array =
     * position on the surface).
     */
    private Button[][] btnsField;
    
    //label of current player
    private Label lblCurrPlayer;
    
    //winner label
    private Label lblWinner;
    
   //playground
    private GridPane grdpane;
    //TODO add additional private attributes (= components from the gui, like buttons, labels...)
    
    /**
     * The constructor. Gets passed all components of the gui that may change
     * due to actions in the logic.
     *
     * @param btns the buttons of the game field (can change their text to the
     * symbols of the players)
     * <br>
     * @param lblCurrPlayer label of current player
     * @param lblWinner winner label
     * @param grdpane playground
     */
    public JavaFXGUI(Button[][] btns,Label lblCurrPlayer,Label lblWinner,GridPane grdpane) {
        this.btnsField = btns;
        this.lblCurrPlayer=lblCurrPlayer;
        this.lblWinner=lblWinner;
        this.grdpane=grdpane;
        lblWinner.setVisible(false);
    }
    
    /**
     * sets text (symbol of current player) on one selectet button 
     * @param coord coordinates of klickt button
     * @param symbol of current player
     */
    @Override
    public void displaySymbol(int[] coord, Symbol symbol) {
        this.btnsField[coord[0]][coord[1]].setText(symbol.name());
    }
    
    
    /**
     * sets the text of the current Player Label
     * @param name of current Player
     * @param symbol of current Player
     */
    @Override
    public void setCurrentPlayer(String name, Symbol symbol) {
        lblCurrPlayer.setText(name + "(" + symbol + ")");
    }
    
    /**
     * sets the text of the winner Label and disables the grdpane
     * @param winnerName name of the winner 
     */
    @Override
    public void onGameEnd(String winnerName) {
        
        lblWinner.setText("Winner is " + winnerName);
        lblWinner.setVisible(true);
        grdpane.setDisable(true);
        //TODO add code that makes sense
    }
    
    /**
     * cleans the playground
     */
    @Override
    public void nanny() {
        for(int x=0;x<3;x++){
            for(int y=0;y<3;y++){
                this.btnsField[x][y].setText("");
            }
        }
        
    }

}
