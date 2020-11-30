unit Uscotlandyard;

{
   Unit zur Erstellung und verwaltung des Programmfensters

}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls, Vcl.StdCtrls, startmen, TypeUnit, AI_Unit, DATA_Unit;

type
  //klasse des fensters
  Tscotlandyard = class(TForm)
    //hauptmenue
    MainMenu1: TMainMenu;
    //vorauswahlpunkt  im haupt menue
    Game: TMenuItem;
    //ein neues spiel starten
    NewGame: TMenuItem;
    //einen gespeicherten Spielstand laden
    Open: TMenuItem;
    //den aktuellen spielstand speichern
    Save: TMenuItem;
    //programm beenden
    Quit: TMenuItem;
    //zweiter vorauswahlpunkt im haupt menue
    Settings: TMenuItem;
    //landkarte anzeigen? voreingestellt auf true
    showboard: TMenuItem;
    //stationen markieren? voreingestellt auf false
    Stationmarker: TMenuItem;
    //mister X anzeigen? initialisiert auf (nicht misterX KI)
    showMrx: TMenuItem;
    //moegliche zielpositionen von mrX anzeigen
    showPosibleTargets: TMenuItem;
    //spielfeld / landkarte
    board: TImage;
    //black/boat Ticket
    black: TImage;
    //Taxi Ticket
    Itaxi: TImage;
    //Bus Ticket
    Ibus: TImage;
    //UBahn Ticket
    Iunderground: TImage;
    //Label aktueller Spieler
    CurrentPlayer: TLabel;
    //anzahl der blacktickets
    blackcount: TLabel;
    //anzahl der taxitickets
    Itaxicount: TLabel;
    //anzahl der BusTickets
    Ibuscount: TLabel;
    //anzahl der Ubahntickets
    Iundergroundcount: TLabel;
    //Popupmenue zur verkehrsmittel auswahl
    PopupVehicle: TPopupMenu;
    //bild der fahrtentafel
    MoveTableIm: TImage;
    //fenster zum speichern
    SaveDialog: TSaveDialog;
    //fenster fuers laden
    OpenDialog: TOpenDialog;
    //Label fuer die moeglichen ziele
    LPosTargets: TLabel;

    //Event proceduren
    procedure FormCreate(Sender: TObject);
    procedure QuitClick(Sender: TObject);
    procedure NewGameClick(Sender: TObject);
    procedure boardMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure showMrxClick(Sender: TObject);
    procedure StationmarkerClick(Sender: TObject);
    procedure showboardClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure OpenClick(Sender: TObject);
    procedure showPosibleTargetsClick(Sender: TObject);

    //Proceduren zur ticket und positions verwaltung
    procedure ticketUse(opt:byte);
    procedure Use_Bus(Sender: TObject);
    procedure Use_Taxi(Sender: TObject);
    procedure Use_Under(Sender: TObject);
    procedure Use_Black(Sender: TObject);
    procedure ticketHandle(ticket:TVehicles);

  private
    { Private-Deklarationen }

    //proceduren fuer grafische updates
    procedure updateboard();
    procedure drawboard();
    procedure drawPlayer(player:byte);
    procedure drawLine(x1,y1,x2,y2:integer;pen:byte);
    procedure drawcaptions();
    procedure marcStations();
    procedure updatemoveTable();
    procedure drawMoveTable();

    //startet und verwaltet die ki zuege
    procedure AIloop();
  public
    { Public-Deklarationen }
  end;

var
  scotlandyard: Tscotlandyard;


implementation
var
  //bitmaps von spielfeld und tickets
  boardBMP: TBitmap;
  IundergroundBMP: TBitmap;
  ItaxiBMP: TBitmap;
  IbusBMP: TBitmap;
  blackBMP: TBitmap;

{$R *.dfm}
  //Fenster schliessen
  procedure Tscotlandyard.QuitClick(Sender: TObject);
  begin
   self.Close;
  end;

  //Zeichnet einen spieler aufs spielfeld
  //@param I der zu zeichnende spieler
  procedure Tscotlandyard.drawPlayer(player:byte);
  var x,y:integer;
    polypoint: array [0..2] of TPoint;
    show: set of byte;
    draw: boolean;
  begin
    draw:=true;

    x:=Stations[DATA_Unit.Players[player].current].posX;
    y:=Stations[DATA_Unit.Players[player].current].posY;

    //ueberschreiben der zeichen koordinaten falls mrX an der letzten
    //zeigeposition gezeichenet werden muss
    if not GameStat.showMR and (player=0) then
    begin
      if GameStat.MRpos <> 0 then
      begin
        x:=Stations[GameStat.MRpos].posX;
        y:=Stations[GameStat.MRpos].posY;
      end
      else
        draw:=false;
    end;

    if draw then
    begin
      board.Canvas.Brush.Color:=clGray;
      polypoint[0].X:=x;
      polypoint[0].Y:=y-15;
      polypoint[1].X:=x-10;
      polypoint[1].Y:=y+10;
      polypoint[2].X:=x+10;
      polypoint[2].Y:=y+10;

      board.Canvas.Polygon(polypoint);
      board.Canvas.Brush.Color:=Players[player].color;
      board.Canvas.Ellipse(x+7,y-7,x-7,y-21);
    end;
  end;


  //setzt die captions der Ticket labels
  //nach den tickets die der aktuelle spieler noch hat
  procedure Tscotlandyard.drawcaptions();
  begin
     Itaxicount.Caption := intToStr(Players[GameStat.CurrentPlayer].vehicles[TAXI]) + 'X';
     Ibuscount.Caption := intToStr(Players[GameStat.CurrentPlayer].vehicles[BUS]) + 'X';
     Iundergroundcount.Caption := intToStr(Players[GameStat.CurrentPlayer].vehicles[SUBWAY]) + 'X';
     blackcount.Caption := intToStr(Players[GameStat.CurrentPlayer].vehicles[BOAT]) + 'X';
  end;

  //zeichnet die Fahrtentafel abhaengig vom inhalt in GameStat.moveTable
  procedure Tscotlandyard.updatemoveTable();
  var x,y,xi,yi,xh,yh,col,row,table:integer;
    rec:TRect;
    show: set of byte;
  begin
    show:= [3,8,13,18,24];
    //spalten
    x:=3;
    //zeilen
    y:=8;

    col:=MoveTableIm.Width div x;
    row:=MoveTableIm.Height div y;
    rec.Width:=col;
    rec.Height:=row;

    MoveTableIm.Canvas.Brush.Color:=clWhite;
    MoveTableIm.Canvas.Pen.Width:=2;

    for table := 24 downto 1 do
    begin
      xh:=col*(x-1);
      yh:=row*(y-1);
      xi:=(col*x);
      yi:=row*y;
      rec.SetLocation(xh,yh);
      case GameStat.moveTable[table] of
        NONE:begin
          if table in show then
          begin
            xh:=xh + 10;
            yh:=yh;
            xi:=xi - 10;
            yi:=yi ;
            MoveTableIm.Canvas.RoundRect(xi-5,yi-5,xh+5,yh+5,42,42);
          end else begin
            xh:=xh + 30;
            yh:=yh + 5;
            xi:=xi - 30;
            yi:=yi - 5;
            MoveTableIm.Canvas.Ellipse(xi,yi,xh,yh);
          end;
        end;
        SUBWAY:begin
          MoveTableIm.Canvas.StretchDraw(rec,IundergroundBMP);
        end ;
        BUS:begin
          MoveTableIm.Canvas.StretchDraw(rec,IbusBMP);
        end;
        TAXI:begin
          MoveTableIm.Canvas.StretchDraw(rec,ItaxiBMP);
        end ;
        BOAT:begin
          MoveTableIm.Canvas.StretchDraw(rec,blackBMP);
        end;
      end;
      dec(y);
      if y=0 then
      begin
        y:=8;
        dec(x);
      end;

    end;
  end;

  //cheatmodus Stationen markieren
  //malt weisse punkte ueber jede station
  procedure Tscotlandyard.marcStations();
  var I:byte;
    x,y:integer;
  begin
    board.Canvas.Brush.Color:=clWhite;
    for I := 1 to 199 do
    begin
      x:=Stations[I].posX;
      y:=Stations[I].posY;
      board.Canvas.Ellipse(x-10,y-10,x+10,y+10);
    end;
  end;

  //allgemeine update procedure fuer die elemente des Fensters
  procedure Tscotlandyard.updateboard();
  var i:byte;
    labe:string;
  begin
    if GameStat.showboard then
      board.Canvas.draw(0,0,boardBMP)
    else
    begin
      board.Canvas.Brush.Color:=clWhite;
      board.Canvas.Rectangle(0,0,board.Width,board.Height);
    end;

    if GameStat.showstation then
      marcStations;

    if GameStat.showPosTargets then
    begin
      labe:='[' + targetsToString() + ']';

      LPosTargets.Caption:=labe;
    end;

    if GameStat.gameStartet then
    begin
      CurrentPlayer.Caption:= 'Am Zug: '+ pName(GameStat.CurrentPlayer);
      for i := 0 to GameStat.countDet do
      begin
        drawPlayer(i);
      end;

       drawcaptions();
    end;


    if GameStat.update then
       updatemoveTable();
  end;

   //Startet und verwaltet die ki zuege
   procedure Tscotlandyard.AIloop();
   var ai:boolean;
      airesult:TAiTurn;
   begin
      ai:= ((gamestat.CurrentPlayer <> 0) and Gamestat.Dai)
          or ((gamestat.CurrentPlayer = 0) and Gamestat.MRai);
      while GameStat.gameStartet and ai do
      begin
        aiResult:=aiTurn();
        if not useTicket(aiResult.ticket,aiResult.taktic,aiResult.eval) then
          showmessage('log schreiben hat nicht geklappt');
        updateboard;
        if gameOver then
        begin
          showMessage(WinnerLabel);
          GameStat.gameStartet:=false;
          if not fintlog()then
            showmessage('log beenden hat nicht geklappt');
        end;
        Application.ProcessMessages();
        sleep(1000);
        nextPlayer;
        updateboard;
        ai:=((gamestat.CurrentPlayer <> 0) and Gamestat.Dai)
          or ((gamestat.CurrentPlayer = 0) and Gamestat.MRai);

      end;
   end;


  //organisirt die tickets
  //setzt den spieler und ueberprueft
  //ob das spiel vorbei ist..
  //und ggf starten der ki
  //@param fuer den zug zu nutzendes ticket
  procedure Tscotlandyard.ticketHandle(ticket:TVehicles);
  begin
    if ticket <> NONE then
    begin
      if not useTicket(ticket,0,0.0) then
        showmessage('log schreiben hat nicht geklappt');
      updateboard;
      if gameOver then
      begin
        showMessage(WinnerLabel);
        GameStat.gameStartet:=false;
        if not fintlog()then
          showmessage('log beenden hat nicht geklappt');
      end;
      Application.ProcessMessages();
      sleep(1000);
      nextPlayer;
      updateboard;
      AIloop;
    end;
  end;

  //ticket auswahl fuers popup menue (bus)
  procedure Tscotlandyard.Use_Bus(Sender: TObject);
  begin
    ticketHandle(BUS);
  end;

  //ticket auswahl fuers popup menue (taxi)
  procedure Tscotlandyard.Use_Taxi(Sender: TObject);
  begin
    ticketHandle(TAXI);
  end;

  //ticket auswahl fuers popup menue (ubahn)
  procedure Tscotlandyard.Use_Under(Sender: TObject);
  begin
    ticketHandle(SUBWAY);
  end;

  //ticket auswahl fuers popup menue (blackticket/boot)
  procedure Tscotlandyard.Use_Black(Sender: TObject);
  begin
    ticketHandle(BOAT);
  end;

  //ticket verarbeitung nach den moeglichkeiten
  //die gewaelte station zu erreichen
  //ggf erstellen des popup menues
  //@param opt die menge der moeglichkeiten und ihre anzahl codiert auf einem byte
  procedure Tscotlandyard.ticketUse(opt:byte);
  var I:TVehicles;
    menue:TMenuItem;
    ticket:TVehicles;
  begin
    if opt > 32 then
    begin
      PopupVehicle.Items.Clear;
      for I := SUBWAY to BOAT do
      begin
        if (opt and (1 shl ord(I))) <> 0 then
        begin
          menue:= TMenuItem.Create(PopupVehicle);
          case I of
            SUBWAY:
            begin
              menue.Caption:='Underground';
              menue.OnClick:=Use_Under;
            end;
            BUS:
            begin
              menue.Caption:='Bus';
              menue.OnClick:=Use_Bus;
            end;
            TAXI:
            begin
              menue.Caption:='Taxi';
              menue.OnClick:=Use_Taxi;
            end;
            BOAT:
            begin
              menue.Caption:='Black';
              menue.OnClick:=Use_Black;
            end;
          end;
          PopupVehicle.items.add(menue);
        end;
      end;
      PopupVehicle.popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
    end
    else
    begin
      ticket:=NONE;
      opt:= opt and 15;
      case opt of
        1:ticket:=SUBWAY;
        2:ticket:=BUS;
        4:ticket:=TAXI;
        8:ticket:=BOAT;
      end;
      ticketHandle(ticket);
    end;
  end;


  //verarbeitung von klicks auf dem spielfeld
  procedure Tscotlandyard.boardMouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
    var ValidV: byte;
  begin
    if GameStat.gameStartet then
    begin

      ValidV:=checkMove(X,Y);
      if ValidV <> 0 then
      begin
        ticketUse(ValidV);
      end;

    end;
  end;

  //zeichnet eine lienie auf der fahrtentafel
  //@Param x1 x coordinate des startpunktes der linie
  //@Param y1 y coordinate des startpunktes der linie
  //@Param x2 x coordinate des endpunktes der linie
  //@Param y2 y coordinate des endpunktes der linie
  //@Param pen linien dicke
  procedure Tscotlandyard.drawLine(x1,y1,x2,y2:integer;pen:byte);
  begin
    MoveTableIm.Canvas.Pen.Width:=pen;
    MoveTableIm.Canvas.MoveTo(x1,y1);
    MoveTableIm.Canvas.LineTo(x2,y2);
  end;

  //initiales zeichnen der fahrtentafel
  procedure Tscotlandyard.drawMoveTable();
  var I, count,sett :integer;
  begin
    MoveTableIm.Canvas.Brush.Color:=clBlue;
    MoveTableIm.Canvas.Rectangle(0,0,300,400);

    count:=round(MoveTableIm.Height/8);
    MoveTableIm.Canvas.Pen.Color:=clBlack;
    for I := 0 to 8 do
    begin
      sett:=count*I;
      drawLine(0,sett,MoveTableIm.Width,sett,5);
    end;
    count:=round(MoveTableIm.Width/3);
    for I := 0 to 3 do
    begin
      sett:=count*I;
      drawLine(sett,0,sett,MoveTableIm.Height,5);
    end;
    updatemoveTable();
  end;


  //initiales zeichnen des fensterinhalts
  procedure Tscotlandyard.drawboard();
  begin
    board.Canvas.Draw(0,0,boardBMP);

    CurrentPlayer.Caption:='Am Zug: Rosa Rote Gummi Bärchen';

    black.Canvas.StretchDraw(black.Canvas.ClipRect,blackBMP);;

    blackcount.Caption:='0X';

    Itaxi.Canvas.StretchDraw(Itaxi.Canvas.ClipRect,ItaxiBMP);

    Itaxicount.Caption:='50X';

    Ibus.Canvas.StretchDraw(Ibus.Canvas.ClipRect,IbusBMP);

    Ibuscount.Caption:='70X';

    Iunderground.Canvas.StretchDraw(Iunderground.Canvas.ClipRect,IundergroundBMP);

    Iundergroundcount.Caption:='30X';

    MoveTableIm.Height:=400;
    MoveTableIm.Width:=300;
    MoveTableIm.Left:=board.Width + 50;
    MoveTableIm.Top:=board.Height-400;


    drawMoveTable;
  end;

  //einen gespeicherten spielstand aus einer datei laden
  procedure Tscotlandyard.OpenClick(Sender: TObject);
  begin
    if OpenDialog.Execute then
      if not loadfromfile(OpenDialog.FileName) then
        showmessage('Die Datei ist Kaputt!')
      else
      begin
        updateboard;
        drawMoveTable;
      end;
  end;

  //positionierung und initialisierung der kommponenten
  //im haupt fenster
  procedure Tscotlandyard.FormCreate(Sender: TObject);
  var I:byte;
    marboard: integer;
    marticket: integer;
  begin
    //groesse des fensters
    scotlandyard.Width:=1500;
    scotlandyard.Height:=900;

    //margin fuer tickets
    marboard:=150;
    marticket:=50;

    //auslesen der netzt txt
    if not readNetData then
      showmessage('Netz nicht in ordnung');

    boardBMP:= TBitmap.Create;
    if FileExists('Data/Spielplan.bmp') then
      boardBMP.LoadFromFile('Data/Spielplan.bmp')
    else
      boardBMP.LoadFromFile('../../Spielplan.bmp');
    board.Height:=boardBMP.Height;
    board.Width:=boardBMP.Width;

    blackBMP:= TBitmap.Create;
    if FileExists('Data/BlackTicket.bmp') then
      blackBMP.LoadFromFile('Data/BlackTicket.bmp')
    else
      blackBMP.LoadFromFile('../../BlackTicket.bmp');
    black.Height:=  round(blackBMP.Height * 0.6);
    black.Width:= round( blackBMP.Width * 0.6);
    black.Left:= board.Width + marboard;
    black.Top:= marticket;


    CurrentPlayer.Left:= black.Left-100;
    CurrentPlayer.Top:=20;
    CurrentPlayer.Font.Size:=13;

    blackcount.Left:=black.Left-100;
    blackcount.Top:=black.Top+10;
    blackcount.Font.Size:=13;

    ItaxiBMP:= TBitmap.Create;
    if FileExists('Data/Taxi.bmp') then
      ItaxiBMP.LoadFromFile('Data/Taxi.bmp')
    else
      ItaxiBMP.LoadFromFile('../../Taxi.bmp');
    Itaxi.Width:= round (ItaxiBMP.Width * 0.6);
    Itaxi.Height:= round (ItaxiBMP.Height * 0.6);
    Itaxi.Left:=board.Width+marboard;
    Itaxi.Top:=black.Top+marticket;


    Itaxicount.Left:=Itaxi.Left-100;
    Itaxicount.Top:=Itaxi.Top+10;
    Itaxicount.Font.Size:=13;

    IbusBMP:= TBitmap.Create;
    if FileExists('Data/Bus.bmp') then
      IbusBMP.LoadFromFile('Data/Bus.bmp')
    else
      IbusBMP.LoadFromFile('../../Bus.bmp');
    Ibus.Width:= round(IbusBMP.Width * 0.6);
    Ibus.Height:= round(IbusBMP.Height * 0.6);
    Ibus.Left:=board.Width+marboard;
    Ibus.Top:=Itaxi.Top+marticket;

    Ibuscount.Left:=Ibus.Left-100;
    Ibuscount.Top:=Ibus.Top+10;
    Ibuscount.Font.Size:=13;

    IundergroundBMP:= TBitmap.Create;
    if FileExists('Data/Underground.bmp') then
      IundergroundBMP.LoadFromFile('Data/Underground.bmp')
    else
      IundergroundBMP.LoadFromFile('../../Underground.bmp');
    Iunderground.Width:= round(IundergroundBMP.Width * 0.6);
    Iunderground.Height:= round(IundergroundBMP.Height * 0.6);
    Iunderground.Left:= board.Width+marboard;
    Iunderground.Top:=Ibus.Top+marticket;

    Iundergroundcount.Left:=Iunderground.Left-100;
    Iundergroundcount.Top:=Iunderground.Top+10;
    Iundergroundcount.Font.Size:=13;

    LPosTargets.Top:=board.Height + 10;
    LPosTargets.Caption:='';

    GameStat.gameStartet:=false;
    for I := 1 to 24 do
    begin
      GameStat.moveTable[I]:=NONE;
    end;
    GameStat.showstation:=false;
    GameStat.showPosTargets:=false;
    GameStat.showboard:=true;
    GameStat.showMR:=false;
    drawboard;
  end;


  //soll die karte angezeigt werden?
  procedure Tscotlandyard.showboardClick(Sender: TObject);
  begin
    GameStat.showboard:=not GameStat.showboard;

    updateboard;

  end;

  //soll mister x angezeigt werden?
  procedure Tscotlandyard.showMrxClick(Sender: TObject);
  begin
    GameStat.showMR:= not GameStat.showMR;
    updateboard;
  end;

  //sollen die moeglichen positionen von misterX angezeigt werden?
  procedure Tscotlandyard.showPosibleTargetsClick(Sender: TObject);
  begin
    GameStat.showPosTargets:= not GameStat.showPosTargets;
    LPosTargets.Caption:='';
    updateboard;
  end;

//neues spiel inizialisieren und starten...
  procedure Tscotlandyard.NewGameClick(Sender: TObject);
  begin
    if startmenue.ShowModal = mrOk  then
    begin
      GameStat.MRai:=startmenue.getMisterXKi;
      if not GameStat.showMR then
         GameStat.showMR:= not startmenue.getMisterXKi;


      GameStat.Dai:=startmenue.getdetectiveki;
      GameStat.countDet:=startmenue.getplayercount;
      GameStat.gameStartet:=true;
      WinnerLabel:='';
      GameStat.CurrentPlayer:=0;

      GameStat.update:= false;
      GameStat.rou:=1;
      GameStat.posibleTargets:=[];
      if not initPlayers() then
        showmessage('Log initialisierung schlug fehl');

      drawMoveTable;
      updateboard;

      AIloop();
    end
  end;

  //den akktuellen spielstand in eine datei speichern
  procedure Tscotlandyard.SaveClick(Sender: TObject);
  begin
    if SaveDialog.Execute() then
       if not savetofile(SaveDialog.FileName) then
            showmessage('speichern ist für weicheier');
  end;

  //cheatmodus markiere stationen ein bzw ausschalten
  procedure Tscotlandyard.StationmarkerClick(Sender: TObject);
  begin
    GameStat.showstation:=not GameStat.showstation;

    updateboard;

  end;

end.
