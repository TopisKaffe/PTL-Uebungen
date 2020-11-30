/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gui;

import java.net.URL;
import java.util.ResourceBundle;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.GridPane;
import logic.GameTicTacToe;

/**
 *
 * @author iat103971
 */
public class FXMLDocumentController implements Initializable {
    
    @FXML
    private Button btnNewGame;
    @FXML
    private GridPane grdpane;
    @FXML
    private Button btn00;
    @FXML
    private Button btn01;
    @FXML
    private Button btn02;
    @FXML
    private Button btn10;
    @FXML
    private Button btn11;
    @FXML
    private Button btn12;
    @FXML
    private Button btn20;
    @FXML
    private Button btn21;
    @FXML
    private Button btn22;
    @FXML
    private Label lblCurrentPlayer;
    @FXML
    private Label lblWinner;
    @FXML
    private TextField tf1;
    @FXML
    private TextField tf2;
    @FXML
    private Button btnstart;
    
    private GameTicTacToe game;
    
    /**
     * defines what happen on button klick
     * @param event klick
     */
    @FXML
    public void handleButtonAction(ActionEvent event) {
        String but=((Button)event.getSource()).getId();
        but=but.replace("btn","");
        int pos = Integer.parseInt(but);
        int[] posxy={pos%10,pos/10};
        this.game.playerTurn(posxy);
    }
    
    
    /**
     * initializes a new game 
     * @param btns button array
     */
    public void neuesS(Button[][] btns){
        lblCurrentPlayer.setText(tf1.getText() + "(X)");
        this.game=new GameTicTacToe(tf1.getText(),tf2.getText(),3
                ,new JavaFXGUI(btns,lblCurrentPlayer,lblWinner,grdpane));
    }
    
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        lblWinner.setVisible(false);
        grdpane.setDisable(true);
        btnstart.setDisable(false);
    }    

    @FXML
    public void newGame(ActionEvent event) {
        grdpane.setDisable(true);
        tf1.setVisible(true);
        tf2.setVisible(true);
        btnstart.setDisable(false);
        btnNewGame.setDisable(true);
        lblWinner.setVisible(false);
    }

    @FXML
    public void startGame(ActionEvent event) {
        Button[][] btns={{btn00,btn10,btn20},{btn01,btn11,btn21},{btn02,btn12,btn22}};
        this.neuesS(btns);
        grdpane.setDisable(false);
        tf1.setVisible(false);
        tf2.setVisible(false);
        btnstart.setDisable(true);
        btnNewGame.setDisable(false);
        lblWinner.setVisible(false);
    }
    
}
