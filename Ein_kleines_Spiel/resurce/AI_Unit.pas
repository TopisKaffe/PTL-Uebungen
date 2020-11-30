unit AI_Unit;

  { Unit zur logischen verarbeitung aller daten
    und eingaben waerend des programmlaufs
    sie stellt sowohl die ki funktionen
    als auch die verarbeitung fuer alle menschlichen zuege }

interface

uses TypeUnit ,System.SysUtils, Vcl.Graphics, DATA_Unit;

  { ueberpruefung der geklickten position
    @param x,y koordinaten auf die geklickt wurde
    @return die station auf die geklickt wurde 0 wenn keine getroffen wurde }
  function checkClickPos(x,y:integer):byte;

  { kodiert, von welchen tickets der uebergebene spieler noch welche hat, auf einem byte
    @param player dessen tickets benoetigt werden
        beispiel
        5: Blacktickets
        0: Taxiticket
        7: Bustikets
        0: U-Bahntickets
        resultirende codierung
        => (0000 1010)

    @return kodiertes byte }
  function getTickets(player:TPlayer):byte;

  { validiert die klickposition fuer den aktuellen spieler und gibt codiert
    ob er zur gekickten position ziehen kann und gibt codiert auf einem byte
    alle verwendbaren tickets und die anzahl
    der unterschiedlichen nutzbaren tickets zurueck
    @param x,y klickkoordinaten
    @return kodiertes byte mit allen moeglichen tickets }
  function checkMove(x,y:integer):byte;

  { uberpruefung ob eine der gewinn bedingungen erreicht ist
    @return ob das spiel vorbei ist }
  function gameOver():boolean;

  { benutzt das ticket und setzt den spieler auf die neue position
    und schreibt den zug in die logdatei
    @param ticket das zu nutzende ticket
    @param taktik die genutzte taktik
    @param eval wertung des zuges
    @return ob fehler beim schreiben der logdatei aufgetreten sind }
  function useTicket(ticket: TVehicles;taktik:byte;eval:real):boolean;

  { uberprueft ob der spieler zur angegebenen position ziehen darf
    und gibt kodiert alle moeglichen tickets zurueck
    @param dest ziel des zuges
    @param player nummer des spielers
          beispiel:
          black:  false
          taxi:   true
          bus:    true
          u-bahn: false

          resultirende codierung
          => (0010 0110)
    @return kodiertes byte mit allen moeglichen tickets }
  function canGo(dest,player:byte):byte;

  { ueberpruefung ob sich der spieler im naechsten zug bewegen kann
    @return kann sich (nicht) bewegen }
  function canMove(player:byte):boolean;

  { bestimmt welcher spieler als naechstes drann ist }
  procedure nextPlayer();

  { erstellt die moeglichen zielpositionen von misterX anhand seiner benutzten tickets }
  function getTargetsMr(ticket:TVehicles;targets:TTargets):TTargets;

  { verwaltung der ki zuege
    @return ergebnisse zur uebergabe an die gui }
  function aiTurn():TAiTurn;


 implementation


  //ueberprueft die geklickte position ob eine station getroffen wurde
  //@param x,y: koordinaten an denen geklickt wurde
  //@return die geklickte station 0 wenn keine getroffen wurde
  function checkClickPos(x,y:integer):byte;
  var distance:uint16;
    i,dest:byte;
  begin
    i:=1;
    dest:=0;
    while ( I < 200 ) and ( dest = 0 ) do
    begin
      distance := round(sqrt(sqr(x-Stations[i].posX)+sqr(y-Stations[i].posY)));
      if distance < 15 then
        dest:=i;
      inc(i);
    end;
    checkClickPos := dest;
  end;



  //erstellt eine maenge an unterschiedlichen tickets die der uebergebene
  //spieler noch hat
  //@param player: spieler dessen tickets getestet werden sollen
  //@return die menge an tickets die dieser noch hat
  function getTickets(player:TPlayer):byte;
  var tickets:byte;
    i:TVehicles;
  begin
      tickets := 0;
      for i:= SUBWAY to BOAT do
      begin
        if player.vehicles[i] > 0 then
          tickets := tickets or (1 shl ord(i));
      end;
      getTickets:=tickets;
  end;


  //kann der aktuelle spieler an die geklickte position ziehen
  //@param dest station die getestet werden soll
  //@param player nummer des zu testenden spielers
  //@return die menge an tickets die dafuer in frage kommen
  function canGo(dest,player:byte):byte;
  var I:TVehicles;
    count,tickets,mrTicket,current: byte;
    isUsed:boolean;
  begin
    isUsed:=false;
    { ist das feld }
    for count:=1 to Length(Players) -1 do
      if Players[count].current = dest then
        isUsed:=true;

    count:=0;
    current:=Players[player].current;

    if not isUsed then
    begin
      tickets := getTickets(Players[player]);
      mrTicket:=0;

      for I:= SUBWAY to BOAT do
      begin

        if dest in Stations[current].destinations[I] then
        begin
          mrTicket := mrTicket or (1 shl ord(I));
          inc(count);
        end;
      end;

      { erstellen der schnitt menge von vorhanden tickets und den verkehrsmitteln
        ueber die die station erreichbar waere }
      mrTicket := tickets and mrTicket;

      //wenn misterX am zug ist und er noch blacktickets besitzt hinzufuegen in die menge
      if player = 0 then
      begin
        if ((tickets and 8) > 0) and (count > 0) and not (mrTicket =  8) then
        begin
          mrTicket:= mrTicket or 8;
          inc(count);
        end
      end;

      { hinzufuegen der anzahl der moeglichkeiten }
      if (mrTicket = 0)  then
        canGo := mrTicket
      else
        canGo := mrTicket or (count shl 4);
    end
    else
      canGo:=0;
  end;


  //ueberpruefung des klicks obs ein valieder zug ist
  //@param x,y: koordinaten an denen geklickt wurde
  //@return menge und anzahl der tickets die fuer den zug benutzt werden koennen
  //        0 wenn es keines gibt
  function checkMove(x,y:integer):byte;
    var dest,check:byte;
  begin
    check:=0;
    dest:=checkClickPos(x,y);
    if dest <> 0 then
    begin
      check := canGo(dest,GameStat.CurrentPlayer);
      if check <> 0 then
        Destination := dest;
    end;
    checkMove := check;
  end;



  //ob sich ein spieler ueberhaupt bewegen kann...
  //@param player zu testende spieler
  //@return true wenn dieser spieler mindestens eine moeglichkeit
  //        hat sich zu bewegen sonnst false
  function canMove(player:byte):boolean;
    var other,tickets:byte;
      check:boolean;
      I:TVehicles;
      others:TTargets;
  begin
    others:=[];
    tickets := getTickets(Players[player]);
    check:=false;
    if tickets > 0 then
    begin
      for other:=1 to Length(Players) -1 do
        others:=others + [Players[other].current];

      for I:= SUBWAY to BOAT do
        if (tickets and (1 shl ord(I))) > 0 then
          if (Stations[Players[Player].current].destinations[I] <> []) then
            if not (Stations[Players[Player].current].destinations[I] <= others) then
              check:=true;
    end;
    canMove:=check;
  end;

  { hilfsfunction die die positionen aller detektive als menge zurueckliefert }
  function getDetPos():TTargets;
  var i:byte;
    res:TTargets;
  begin
    res:=[];
    for i := 1 to GameStat.countDet do
         res:=res + [Players[i].current];

    getDetPos:=res;
  end;

  { erstellt moegliche zielpositionsmenge fuer misterX }
  function getTargetsMr(ticket:TVehicles;targets:TTargets):TTargets;
  var i:byte;
    nextTargets:TTargets;
  begin
    nextTargets:=[];
     targets:=targets - getDetPos();
    for i := 1 to 199 do
    begin
      if i in targets then
      begin
        nextTargets:=nextTargets + Stations[i].destinations[ticket];
        if ticket =  BOAT then
        begin
          repeat
            dec(ticket);
            nextTargets:=nextTargets + Stations[i].destinations[ticket];
          until ticket = SUBWAY ;
        end;
      end;
    end;
    nextTargets:=nextTargets - getDetPos();
    getTargetsMR:=nextTargets;
  end;


  //decrementiert das ausgewaehlte ticket
  //und setzt die neue position des aktuellen spielers
  //wenn nich Mr.X am zug ist wird das benutzte ticket bei ihm erhoet
  function useTicket(ticket: TVehicles;taktik:byte;eval:real):boolean;
  var show: set of byte;
    log:boolean;
  begin
     show:= [3,8,13,18,24];
     dec(Players[GameStat.CurrentPlayer].vehicles[ticket]);

     log:=writelog(taktik,eval);

     Players[GameStat.CurrentPlayer].current:=Destination;
     Destination:=0;

     if GameStat.CurrentPlayer <> 0 then
     begin
       inc(Players[0].vehicles[ticket]);
     end
     else
     begin

      if GameStat.rou in show then
      begin
        GameStat.MRpos:=Players[0].current;
        GameStat.posibleTargets:= [GameStat.MRpos];
      end
      else
        GameStat.posibleTargets:=getTargetsMr(ticket,GameStat.posibleTargets);

     GameStat.moveTable[GameStat.rou]:=ticket;
     end;
     useTicket:=log;
  end;

  //setzen des naechsten spielers
  procedure nextPlayer();
  var lastPlayer:byte;
  begin
    lastPlayer:=GameStat.CurrentPlayer;
    repeat
      inc(GameStat.CurrentPlayer);
      if GameStat.CurrentPlayer >= length(Players) then
      begin
         GameStat.CurrentPlayer:=0;
         inc(GameStat.rou);
      end;
    until canmove(GameStat.CurrentPlayer);

    GameStat.update:= lastPlayer=0;
  end;

  //ueberpruefung ob das spiel zuende ist also ob und wer gewonnen hat
  //ausserdem wird das Winnerlabel gesetzt
  //@return true wenn eine seite gewonnen hat ansonsten false
  function gameOver():boolean;
    var i,stuck:byte;
      over:boolean;
  begin
    over:=false;
    stuck:=0;
    for i:=1 to GameStat.countDet do
    begin
      if Players[0].current = Players[i].current then
      begin
        WinnerLabel:='Mr. X  wurde von '+ pName(i) +' gefangen!!';
        over:=true;
        GameStat.winner:=2;
      end
      else if not canMove(i) then
        inc(stuck);
    end;
    if (stuck = Length(Players) -1) or (GameStat.rou > 24) then
    begin
      WinnerLabel:='Mr. X  ist Entkommen!!!';
      GameStat.winner:=1;
      over:=true;
    end;
    gameOver:=over;
  end;

  { gibt das ticket zurueck von dem der spieler noch die meisten hat aus der menge
    der in tickets kodierten auswahl
    @param player zu testender spieler
    @param tickets auswahl der tickets
    @return das am heufigsten vorhandene ticket aus der auswahl }
  function hasMoreOf(player:TPlayer;tickets:byte):TVehicles;
  var ticket,toUse:TVehicles;
    lastTest:byte;
  begin
    lastTest:=0;
    toUse:=TVehicles.NONE;
    for ticket := SUBWAY to BOAT do
      if ((tickets and (1 shl ord(ticket))<>0)) and (player.vehicles[ticket] >= lastTest ) then
      begin
        lastTest:=player.vehicles[ticket];
        toUse:=ticket;
      end;

    hasMoreOf:=toUse;
  end;


  { moegliche zielpositionen anhand der ausgewaelten tickets
    @param tickets auswahl von tickets
    @param menge der positionen von denen aus getestet werden soll
    @return resultierende zielpositionsmenge }
  function getTargets(tickets:byte;current:TTargets):TTargets;
  var targets:TTargets;
    hasticket:TVehicles;
    from :byte;
  begin
    targets:=[];
    for from := 1 to 199 do
    begin
      if from in current then
      begin
        for hasticket := SUBWAY to BOAT do
          if ((tickets and (1 shl ord(hasticket))) <> 0)
            or ((tickets and (1 shl ord(BOAT)))<>0) then
            targets:=targets + Stations[from].destinations[hasticket];
      end;
    end;
    for from := 1 to GameStat.countDet do
      targets:=targets - getDetPos();

    getTargets:=targets;
  end;

  { erstellt einen weg von einer position zu einer anderen und nutzt dafuer nur
    die in tickets uebergebene auswahl von verkehrsmitteln
    @param tickets auswahl an verkehrsmitteln
    @param from startposition
    @param target zielposition
    @return den reiseweg als array }
  function getWay(tickets,from,target:byte):TWay;
  var way:TWay;
    i,findRound,fillway:byte;
    targets:TTargets;
  begin
      for i:=1 to 199 do
      begin
        way[i].step:= -1;
        way[i].from:= 0;
      end;

      way[from].step:=0;
      findRound:=1;
      while (findround <= 10) and (way[target].step = -1) do
      begin
        for i := 1 to 199 do
        begin
          if way[i].step = (findRound - 1) then
          begin
            targets:=getTargets(tickets,[i]);
            for fillway := 1 to 199 do
            begin
              if (fillway in targets) and (way[fillway].step = -1) then
              begin
                way[fillway].step:=findRound;
                way[fillway].from:=i;
              end;
            end;
          end;
        end;
        inc(findRound);
      end;
      getWay:=way;
  end;

  { erste ki taktik kann auf eine moegliche zielposition von misterX gezogen werden
    @param player der spieler
    @param current nummer des spielers
    @return zielposition und zu nutzendes ticket }
  function tacticOne(player:TPlayer;current:byte):TMove;
  var tickets, target:byte;
    posTargets, playerTargets:TTargets;
    move:TMove;
  begin
    posTargets:= GameStat.posibleTargets;
    tickets:=getTickets(player);
    playerTargets:=getTargets(tickets,[player.current]);

    move.target:=0;
    move.ticket:=TVehicles.NONE;
    playerTargets:= playerTargets * posTargets;
    if playerTargets <> [] then
    begin
      target:=1;
      repeat
        if target in playerTargets then
        begin
          move.ticket:=hasMoreOf(player,cango(target,current));
          if move.ticket <> TVehicles.NONE then
             move.target:=target;
        end;
        inc(target);
      until ((move.target <> 0)and (move.ticket<>TVehicles.NONE)) or (target >= 200) ;

    end;

    tacticOne:=move;

  end;

  { zweite ki taktik kann auf eine station mit ubahn verbindung gezogen werden
    @param player der spieler
    @param current nummer des spielers
    @return zielposition und zu nutzendes ticket }
  function tacticTwo(player:TPlayer;current:byte):TMove;
  var tickets, target:byte;
    targets:TTargets;
    move:TMove;
  begin
    tickets:=getTickets(player);
    targets:=getTargets(tickets,[player.current]);

    move.target:=0;
    move.ticket:=TVehicles.NONE;
    target:=1;
    repeat
      if target in targets then
        if Stations[target].destinations[SUBWAY] <> [] then
        begin
          move.ticket:=hasMoreOf(player,cango(target,current));
          if move.ticket <> TVehicles.NONE then
             move.target:=target;
        end;

      inc(target);
    until((move.target <> 0)and (move.ticket<>TVehicles.NONE)) or (target >= 200) ;

    tacticTwo:=move;
  end;


  { dritte ki taktik laufe in richtung zur letzten zeigeposition von misterX
    @param player der spieler
    @param current nummer des spielers
    @return zielposition des ersten schritts und zu nutzendes ticket }
  function tacticThree(player:TPlayer;current:byte):TMove;
    var way: TWay;
    findRound, tickets:byte;
    detPos:TTargets;
    move:TMove;
  begin
      move.target:=0;
      move.ticket:=TVehicles.NONE;
    if GameStat.MRpos <> 0 then
    begin


      tickets:= getTickets(player);

      detPos:=getDetPos();
      if not(GameStat.MRpos in detPos) then
      begin
        way:=getWay(tickets,player.current,GameStat.MRpos);

        if (way[GameStat.MRpos].step <> -1) then
        begin
          findRound:=GameStat.MRpos;
          while way[findRound].from <> player.current do
          begin
            findRound:=way[findRound].from;
          end;
          move.ticket:=hasMoreOf(player,cango(findRound,current));
          if move.ticket <> TVehicles.NONE then
            move.target:=findRound;
        end;
      end;
    end;
    tacticThree:=move;
  end;

  { vierte ki taktik bewege dich auf die station mit kleinst moeglicher nummer
    @param player der spieler
    @param current nummer des spielers
    @return zielposition und zu nutzendes ticket }
  function tacticFour(player:TPlayer;current:byte):TMove;
  var targets:TTargets;
    target,tickets:byte;
    move:TMove;
  begin
    tickets:=getTickets(player);
    targets:=getTargets(tickets,[player.current]);
    move.target:=0;
    move.ticket:=TVehicles.NONE;
    target:=1;
    repeat
      if target in targets then
      begin
        move.ticket:=hasMoreOf(player,cango(target,current));
        if move.ticket <> TVehicles.NONE then
          move.target:=target;
      end;
      inc(target);
    until ((move.target <> 0)and (move.ticket<>TVehicles.NONE)) or (target >= 200);

    tacticFour:=move;
  end;

  { zaelt elemente einer menge
    @param targets menge deren elemente gezaelt werden sollen
    @return anzahl der elemente }
  function countTargets(targets:TTargets):byte;
  var
    i, count: byte;
  begin
    count:=0;
    for i := 1 to 199 do
    begin
      if i in targets then
        inc(count);
    end;
    countTargets:=count;
  end;

  { erste bewertungs funktion wie viele moegliche zielpositionen von misterX
    sind nach dem aktuellen zug durch von detektiven erreichbar geteilt durch
    gesammt anzah moeglicherzielpositionen multipliziert mit 10
    @param target ticket und ziel des zu bewertenden zuges
    @return resultat der oben beschriebenen rechnung }
  function ratingOne(target:TMove):double;
  var posibletargets,detTargets:TTargets;
    player,tickets, countMr, count:byte;
    current:TPlayer;
  begin
    detTargets:=[];
    posibletargets:=GameStat.posibleTargets - [target.target];
    current:=Players[GameStat.CurrentPlayer];
    dec(current.vehicles[target.ticket]);
    if posibletargets <> [] then
    begin
      for player := 1 to GameStat.countDet do
      begin
        if player = GameStat.CurrentPlayer then
        begin
          tickets:=getTickets(current);
          detTargets:=detTargets + getTargets(tickets,[target.target]);
        end
        else
        begin
          tickets:=getTickets(Players[player]);
          detTargets:=detTargets + getTargets(tickets,[Players[player].current]);
        end;
      end;
      countMr:=countTargets(posibletargets);
      count:=countTargets(posibletargets * detTargets);
      ratingOne:= (count / countMr) *10;
    end
    else
      ratingOne:=0.0;
  end;

  { zweite bewertungs funktion wie viele schritte werden benoetigt um
    misterX mittlere moegliche zielposition zu erreichen
    wertung = 10 - noetige schritte
    @param target ticket und ziel des zu bewertenden zuges
    @return resultat der oben beschriebenen rechnung }
  function ratingTwo(target:TMove):byte;
  var posTargets,detPos:TTargets;
    i, dest, count:byte;
    mX,mY,distance, oldd:longint;
    way: TWay;
    tickets:byte;
    findRound:integer;
  begin

    posTargets:=GameStat.posibleTargets - [target.target];
    if  (posTargets <> []) and (target.target <> 0) then
    begin
      mX:=0;
      mY:=0;
      dest:=0;
      for i := 1 to 199 do
      begin
        if i in posTargets then
        begin
          mX:=mX + Stations[i].posX;
          mY:=mY + Stations[i].posY;
        end;
      end;
      count:=countTargets(posTargets);
      mX:= round(mX/count);
      mY:= round(mY/count);
      oldd:=700;
      for i := 1 to 199 do
      begin
        distance := round(sqrt(sqr(mX-Stations[i].posX)+sqr(mY-Stations[i].posY)));
        if distance < oldd then
        begin
          oldd:=distance;
          dest:=i;
        end;
      end;

      detPos:=getDetPos();

      if (dest > 0) and not (dest in detPos) and (dest < 200) then
      begin
        tickets:= getTickets(Players[GameStat.CurrentPlayer]);
        way:=getWay(tickets,target.target,dest);
        findround :=  way[dest].step;
        if findround <> -1 then
          ratingTwo:= 10 - findround
        else
          ratingTwo:= 0;
      end
      else
        ratingTwo:= 0;
    end
    else
    ratingTwo:= 0;


  end;

  { dritte ki bewertungsfunktion wie viele stationen koennen nach dem zug
    mit den noch vorhandenen tickets in einem zug erreicht werden
    berechnung = anzahlziele / 13 * 4
    @param target ticket und ziel des zu bewertenden zuges
    @return resultat der oben beschriebenen rechnung }
  function ratingThree(target:TMove):double;
  var tickets:byte;
    count:byte;
    player:TPlayer;
  begin
    if (target.target <> 0) and (target.ticket <> TVehicles.NONE) then
    begin

      player:=Players[GameStat.CurrentPlayer];
      dec(player.vehicles[target.ticket]);
      tickets:=getTickets(player);
      count:=countTargets(getTargets(tickets,[target.target]));

      ratingThree:= (count/13)*4;
    end
    else
      ratingThree:=0;
  end;

  { vierte ki bewertungsfunktion sind noch genug tickets da
    sind von allen tickets noch mehr als 3 da ergibt sich das
    ergebnis zu drei sonnst die kleinste anzahl der verbliebenen tickets
    @param target ticket und ziel des zu bewertenden zuges
    @return resultat der oben beschriebenen rechnung }
  function ratingFour(target:TMove):byte;
  var player:TPlayer;
    ticket:TVehicles;
    count:byte;
  begin
    count:=3;
    player:=Players[GameStat.CurrentPlayer];
    dec(player.vehicles[target.ticket]);
    for ticket := SUBWAY to TAXI do
      if player.vehicles[ticket] < count then
        count:=player.vehicles[ticket];

    ratingFour:=count;
  end;

  { bedingtes fuellen des ergebnis struckts
    @param taktic genutzte taktik
    @param target ticket und ziel des zu bewertenden zuges
    @param wertung des zugs }
  procedure DetAi(taktic:byte;target:TMove;rating:double;var res:TAiTurn);
  begin
    if rating > res.eval then
    begin
      res.taktic:=taktic;
      res.eval:=rating;
      res.ticket:=target.ticket;
      res.target:=target.target;
    end;
  end;

  { bewertungs function fuer die zuege von misterX
    die wertung ergibt sich aus der anzahl der detecktive die ihn nach dem
    zug in einem schritt erreichen koennten, wie viele zielpositionen er nach dem
    schritt zur auswahl hat und wie viele tickets er nach dem schritt von jeder
    sorte noch besitzt }
  function mRating(target:byte):double;
  var tickets,count,det:byte;
    rating:double;
    ticket:TVehicles;
    mr:TPlayer;
  begin
    count:=0;
    for det := 1 to GameStat.countDet do
    begin
      tickets:=getTickets(Players[det]);
      if target in getTargets(tickets,[Players[det].current]) then
        inc(count);
    end;
    rating:= (GameStat.countDet-count)*10;

    mr:=Players[0];
    dec( mr.vehicles[ hasMoreOf( mr, cango( target, 0) ) ] );
    count:=countTargets( getTargets( getTickets(mr), [target]));

    rating:=rating + ((count/13)*4);

    count:=3;
    for ticket := SUBWAY to TAXI do
      if mr.vehicles[ticket] < count then
        count:=mr.vehicles[ticket];


    rating:= rating + count;

    mRating := rating;
  end;

  { misterX ki zug geht alle moeglichen zielpositionen durch und gibt die
    bestbewertete zurueck inclusive ihrer wertung und des zu nutzenden tickets }
  function misterAiTurn():TAiTurn;
  var posTargets:TTargets;
    i,tickets:byte;
    rating:double;
    turn:TAiTurn;
  begin
    turn.taktic:=1;
    turn.eval:=0.0;
    turn.target:=0;
    turn.ticket:=TVehicles.NONE;

    tickets:=getTickets(Players[0]);
    posTargets:= getTargets(tickets,[Players[0].current]);
    for i := 1 to 199 do
      if (i in posTargets) then
      begin
        rating:= mRating(i);
        if rating > turn.eval then
        begin
          turn.ticket:=hasMoreOf(Players[0],cango(i,0));
          turn.target:=i;
          turn.eval:=rating;
        end;
      end;
    misterAiTurn:=turn;
  end;


  { ki zug verwaltung ruft fuer die detektive alle vier takticken auf und gibt die
    bestbewertete zurueck falls misterX am zug ist wird seine taktik ausgefuert }
  function aiTurn():TAiTurn;
  var res:TAiTurn;
    rating:double;
    target:TMove;
  begin
    if GameStat.CurrentPlayer <> 0 then
    begin
      res.taktic:=0;
      res.eval:=0.0;
      res.target:=0;
      res.ticket:=TVehicles.NONE;
      target:=tacticOne(Players[Gamestat.CurrentPlayer],Gamestat.CurrentPlayer);
      if (target.target <> 0) and (target.ticket <> TVehicles.NONE) then
      begin
        rating:=ratingOne(target) + ratingTwo(target) + ratingThree(target) + ratingFour(target);
        DetAi(1,target,rating,res);
      end;

      target:=tacticTwo(Players[Gamestat.CurrentPlayer],Gamestat.CurrentPlayer);
      if (target.target <> 0) and (target.ticket <> TVehicles.NONE) then
      begin
        rating:=ratingOne(target) + ratingTwo(target) + ratingThree(target) + ratingFour(target);
        DetAi(2,target,rating,res);
      end;

      target:=tacticThree(Players[Gamestat.CurrentPlayer],Gamestat.CurrentPlayer);
      if (target.target <> 0) and (target.ticket <> TVehicles.NONE)then
      begin
        rating:=ratingOne(target) + ratingTwo(target) + ratingThree(target) + ratingFour(target);
        DetAi(3,target,rating,res);
      end;

      target:=tacticFour(Players[Gamestat.CurrentPlayer],Gamestat.CurrentPlayer);
      if (target.target <> 0) and (target.ticket <> TVehicles.NONE) then
      begin
        rating:=ratingOne(target) + ratingTwo(target) + ratingThree(target) + ratingFour(target);
        DetAi(4,target,rating,res);
      end;

      Destination:=res.target;
      aiTurn:=res;
    end
    else
    begin
      res:=misterAiTurn();
      Destination:=res.target;
      aiTurn:=res;
    end;

  end;
end.
