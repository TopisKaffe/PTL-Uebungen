unit DATA_Unit;

{ Unit zur dateiarbeit mit allen dafuer benoetigten functionen
  und zur speicherung aller relevanten daten fuer ein spiel }

interface
  uses TypeUnit,System.SysUtils, Vcl.Graphics;

  { gibt den namen passent zur ubergebenen spieler nr
    @param i nummer des spieler
    @return name des spielers }
  function pName(i:byte):string;

  { ueberfuehrung der moeglichen zielpositionen in einen string
    @return  alle zielpositionen kommasepariert }
  function targetsToString():string;

  { schreiben der log datei waehrend des laufenden spiels
    @param taktik  welche taktic fuer den zug genutzt wurde
    @param wertung wie ist der zug gewertet worden
    @return false wenn fehler aufgetreten sind true wenn nicht }
  function writeLog(taktic:byte;eval:real):boolean;

  { beenden des logs
    @return false wenn fehler aufgetreten sind true wenn nicht }
  function fintlog():boolean;

  { abspeichern aller relevanten daten in eine datei
    @param name der datei
    @return false wenn fehler aufgetreten sind true wenn nicht }
  function savetofile(datName:string):boolean;

  { laden eines spielstands aus einer datei
    @param name der datei
    @return false wenn fehler aufgetreten sind true wenn nicht }
  function loadfromfile(datName:string):boolean;

  { auslesen der Netz.txt
    @return false wenn fehler aufgetreten sind true wenn nicht }
  function readNetData():boolean;

  { initialisierung der spieler und begin der logdatei
    @return false wenn fehler aufgetreten sind true wenn nicht }
  function initPlayers():boolean;


 var
    { alle stationen auf dem spielfeld }
    Stations: TStations;

    { alle spieler }
    Players: TPlayers;

    { aktueller spielstand }
    GameStat: TGameStat;

    { string fuer die ausgabe wer gewonnen hat }
    WinnerLabel: string;

    { ziel des aktuellen spielers }
    Destination: byte;

implementation
  var
    { menge aller moeglichen startpositionen }
    STARTPOS: set of byte = [13,26,29,34,50,53,91,94,103,112,117,132,138,141,155,174,197,198];

    { name der logdatei }
    LOGDAT: string ='scotty.log';


    function targetsToString():string;
    var res:string;
      i:byte;
    begin
      res:='';
      for i := 1 to 199 do
      if i in GameStat.posibleTargets then
        if res='' then
        begin
          res:=res + intToStr(i);
        end
        else
          res:=res +',' + intToStr(i);

      targetsToString:=res;
    end;


  //zeilenweise schreiben in die log datei zug pro zug
   function writeLog(taktic:byte;eval:real):boolean;
   var datei :Text;
    floats :string;
    v:TVehicles;
    splitpos,split:byte;
   begin
    split:=0;
      try
         assign(datei,LOGDAT);
         append(datei);
         write(datei,inttostr(GameStat.currentPlayer)
                + ','+  inttostr(Players[GameStat.currentPlayer].current)
                + ','+  inttostr(Destination));
         for v := SUBWAY to BOAT do
            write(datei,','+ inttostr(Players[GameStat.currentPlayer].vehicles[v]));
         write(datei,','+ inttostr(taktic)+',');
         floats:=floattostr(eval);
         for splitpos:=1 to length(floats) do
            if floats[splitpos]=',' then
                 split:=splitpos;

         if (split=0) then
         begin
           floats:=floats + '.0';
         end  else  begin
           floats[split]:='.' ;
         end;

         write(datei,floats);
         writeln(datei,'');
         close(datei);
         writelog:=true;
      except
         writelog:=false;
      end;

   end;

   //setzt detektiv positionen
   //nach dem laden eines spielstandes
   //@param positions kommasepariert die positionen der detektive
   procedure setpositions(positions:string);
   var i,splitpos,insertpos:byte;
      bug:integer;
   begin
     for i := 1 to GameStat.countDet do
     begin
       splitpos:=pos(',',positions);
       if splitpos <> 0 then
       begin
         val(copy(positions,1,splitpos-1),insertpos,bug);
         Players[i].current:=insertpos;
         delete(positions,1,splitpos);
       end
       else
       begin
         val(copy(positions,1,length(positions)),insertpos,bug);
         Players[i].current:=insertpos;
       end;
     end;
   end;

   //setzt verbleibende tickets fuer einen spieler
   //nach dem laden eines spielstandes
   //@param player spieler um dessen tickets es geht
   //@param tickest kommasepariert die tickets des spielers
   procedure settickets(player:byte;tickets:string);
   var i:TVehicles;
    splitpos,insertticket:byte;
    bug:integer;
   begin
      for i := SUBWAY to BOAT do
      begin
       splitpos:=pos(',',tickets);
       if splitpos <> 0 then
       begin
         val(copy(tickets,1,splitpos-1),insertticket,bug);
         Players[player].vehicles[i]:=insertticket;
         delete(tickets,1,splitpos);
       end
       else
       begin
         val(copy(tickets,1,length(tickets)),insertticket,bug);
         Players[player].vehicles[i]:=insertticket;
       end;
      end;
   end;

   //initalisiert die fartentafel nach dem laden eines spielstandes
   //@param table kommasepariert die von MR.X benutzten tickets
   procedure setmovetable(table:string);
   var i,used,splitpos:byte;
    bug:integer;
   begin
     for i := 1 to 24 do
     begin
        splitpos:=pos(',',table);
        if splitpos <> 0 then
        begin
          val(copy(table,1,splitpos-1),used,bug);
          delete(table,1,splitpos);
        end
        else
          val(copy(table,1,length(table)),used,bug);

        case used of
          0:GameStat.moveTable[i]:=SUBWAY;
          1:GameStat.moveTable[i]:=BUS;
          2:GameStat.moveTable[i]:=TAXi;
          3:GameStat.moveTable[i]:=BOAT;
          4:GameStat.moveTable[i]:=TVehicles.NONE;
        end;
     end;
   end;


   //speichert aktuellen spielstand in datei
   //@param datName name der datei
   //@return obs geklappt hat
   function savetofile(datName:string):boolean;
   var datei:TEXT;
    i:byte;
    ticket:TVehicles;
    winn,test:boolean;
   begin
     test:=true;
     try
       if pos(datName,'.txt') = 0 then
          datName:=datName+ '.txt';
       assign(datei,datName);
       rewrite(datei);
       writeln(datei,inttostr(GameStat.countDet));
       writeln(datei,GameStat.MRai);
       writeln(datei,GameStat.Dai);
       writeln(datei,inttostr(GameStat.CurrentPlayer));
       writeln(datei,inttostr(GameStat.rou));
       writeln(datei,targetsToString());
       writeln(datei,inttostr(GameStat.MRpos));
       writeln(datei,inttostr(players[0].current));

       for i := 1 to GameStat.countDet do
       begin
         write(datei,inttostr(Players[i].current));
         if i <> GameStat.countDet then
            write(datei,',');
       end;
       writeln(datei,'');
       for i := 0 to GameStat.countDet do
       begin
         for Ticket := SUBWAY to BOAT do
         begin
           write(datei,inttostr(Players[i].vehicles[ticket]));
           if Ticket <> BOAT then
              write(datei,',');
         end;
         writeln(datei,'');
       end;
       winn:= not GameStat.gameStartet;
       writeln(datei,winn);
       for i := 1 to 24 do
       begin
         write(datei,inttostr(ord(GameStat.movetable[i])));
         if i <> 24 then
            write(datei,',');
       end;
       writeln(datei,'');

       close(datei);
     except
       test:=false;
     end;
     savetofile:=test;
   end;


   //fuellt ein set of byte aus mit zahlen aus einem komma seperierten string
  //@param str der eingabe string
  //@return ein set of byte mit allen gefundenen zahlen
  function fillSet( str:string ):TTargets;
  var posi,tar,code: integer;
    fill:TTargets;
  begin
    fill:=[];
    repeat
      posi:=pos(',',str);
      if posi<>0 then
        val(copy(str,1,posi-1),tar,code)
      else
        val(str,tar,code);
      delete(str,1,posi);
      if tar <> 0 then
        fill := fill + [tar];
    until posi <= 0;
    fillset:=fill;
  end;

  //liest die netz.txt aus und fuellt das Stations array
  //@return false wenn fehler aufgetreten sind true wenn nicht
  function readNetData():boolean;
  var i:byte;
    xy,code:integer;
    netData: Text;
    strData: string;
    targets: string;
    c: TVehicles;
  begin
    try
      if FileExists('Data/Netz.txt') then
        assign(netData,'Data/Netz.txt')
      else
        assign(netData,'../../Netz.txt');

      reset(netData);
      while not EOF(netData) do
      begin
        readln(netData,strData);
        val(copy(strData,1,pos(';',strData)-1),i,code);
        delete(strData,1,pos(';',strData));
        val(copy(strData,1,pos('/',strData)-1),xy,code);
        delete(strData,1,pos('/',strData));
        Stations[i].posX:=xy;
        val(copy(strData,1,pos(';',strData)-1),xy,code);
        delete(strData,1,pos(';',strData));
        Stations[i].posY:=xy;

        for c := SUBWAY to BOAT do
        begin
          if c <> BOAT then
          begin
            targets:=copy(strData,1,pos(';',strData)-1);
            Stations[i].destinations[c]:=fillSet(targets);
            delete(strData,1,pos(';',strData));
          end
          else
          begin
            targets:=copy(strData,1,length(strData));
            Stations[i].destinations[c]:=fillSet(targets);
          end;
        end;
      end;
      close(netData);
      readNetData:=true;
    except
      readNetData:=false;
    end;

  end;


  //initialisierung der logdatei.....
  function initwriteLog():boolean;
  var logdatei :Text;
    i:byte;
  begin
    try
      assign(logdatei,LOGDAT);
      rewrite(logdatei);
      write(logdatei,inttostr(GameStat.countDet)+','
        , GameStat.MRai ,','
        , GameStat.Dai ,','
        + inttostr(Players[0].current));
      for i := 1 to GameStat.countDet do
         write(logdatei,',' + inttostr(Players[i].current));

      writeln(logdatei,'');
      close(logdatei);
      initwriteLog:=true;
    except
      initwriteLog:=false;
    end;
  end;

  //lookup tabelle fuer die namen der spieler
  function pName(i:byte):string;
  begin
    case i of
      0: pName:='MR. X';
      1: pName:='Red';
      2: pName:='Blue';
      3: pName:='Purple';
      4: pName:='Maroon';
      5: pName:='Yellow';
      6: pName:='Green';
    end;
  end;

  //lookup tabelle fuer die farben der spieler
  function colors(i:byte):TColor;
  begin
    case i of
      0: colors:=clBlack;
      1: colors:=clRed;
      2: colors:=clBlue;
      3: colors:=clPurple;
      4: colors:=clMaroon;
      5: colors:=clYellow;
      6: colors:=clGreen;
      else colors:=clWhite;
    end;
  end;

   //einlesen eines gespeicherten spielstands
   //aus einer datei
   //@param datName Name der datei
   //@return ob das einlesen geklappt hat
   function loadfromfile(datName:string):boolean;
   var datei:TEXT;
    test:boolean;
    tmp:string;
    i:byte;
   begin
     test:=true;
     try
       if Fileexists(datName) then
       begin
         assign(datei,datName);

         reset(datei);
         readln(datei,GameStat.countDet);
         readln(datei,tmp);
         GameStat.MRai:= tmp = 'TRUE';
         readln(datei,tmp);
         GameStat.Dai:= tmp = 'TRUE';

         readln(datei,GameStat.CurrentPlayer);
         readln(datei,GameStat.rou);
         readln(datei,tmp);
         GameStat.posibleTargets:=fillset(tmp);
         readln(datei,GameStat.MRpos);

         setlength(Players,GameStat.countDet+1);
         readln(datei,Players[0].current);

         readln(datei,tmp);
         setpositions(tmp);

         for i := 0 to GameStat.countDet do
         begin
           readln(datei,tmp);
           settickets(i,tmp);
         end;

         readln(datei,tmp);
         GameStat.gameStartet:= tmp = 'FALSE';
         readln(datei,tmp);
         setmovetable(tmp);
         close(datei);
       end
       else
        test:=false;

       for i := 0 to GameStat.countDet do
         Players[i].color:=colors(i);
     except
          test:=false;
     end;
        loadfromfile:=test;
   end;


  //initialiesiert das player array mit startpositionen
  //auf einer uebergebenen laenge
  //@return ob das initialisieren der log datei erfolgreich war
  function initPlayers():boolean;
  var i,pos:uint8;
    Startpositions: set of byte;
  begin
    for i := 1 to 24 do
    begin
      GameStat.moveTable[i]:=TVehicles.NONE;
    end;
      Startpositions:=STARTPOS;
      randomize;
      setlength(Players,GameStat.countDet+1);
      i:=0;
    while i <= GameStat.countDet do
    begin
      pos:=random(199);
      if  pos in Startpositions then
      begin
        Players[i].current:=pos;
        Startpositions:=Startpositions - [pos];
        Players[i].color:=colors(i);
        if i=0 then
        begin
          GameStat.MRpos:=0;
          Players[i].vehicles[TAXi]:=4;
          Players[i].vehicles[BUS]:=3;
          Players[i].vehicles[SUBWAY]:=3;
          Players[i].vehicles[BOAT]:=GameStat.countDet;
        end
        else
        begin
          Players[i].vehicles[TAXi]:=10;
          Players[i].vehicles[BUS]:=8;
          Players[i].vehicles[SUBWAY]:=4;
          Players[i].vehicles[BOAT]:=0;
        end;
       inc(i);
      end;
    end;
    initPlayers:=initwriteLog();

  end;

  //beenden der logdatei wenn ein spiel zuende ist
  //@return false wenn fehler aufgetreten sind true wenn nicht
  function fintlog():boolean;
  var datei:text;
  begin
    try
      assign(datei,LOGDAT);
      append(datei);
      writeln(datei, inttostr(GameStat.winner-1));
      close(datei);
      fintlog:=true;
    except
      fintlog:=false;
    end;

  end;


end.
