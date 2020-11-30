unit TypeUnit;

{
  Typen Unit zur verwendung in projekt Scotlandyard
  zur bereitstellung aller noetigen typen
}
interface
uses System.SysUtils, Vcl.Graphics;

type
  { aufzaelungstyp fuer die tickets/verkehrsmittel }
  TVehicles = (SUBWAY,BUS,TAXI,BOAT,NONE);

  { menge fuer stationsverwaltung }
  TTargets = set of byte;

  { array fuer anzahlen einzelner tickets }
  TVehicle = array [SUBWAY .. BOAT] of byte;

  { array fuer moegliche ziele einer station }
  TSetVehicle = array [SUBWAY .. BOAT] of TTargets;

  { record fuer eine einzelne station
    posX/posY koordinaten der station
    destinations moegliche ziele von dieser station aus }
  TStation = record
    posX: integer;
    posY: integer;
    destinations: TSetVehicle;
  end;

  { spieler record
    current  aktuelle station auf der der spieler steht
    color    farbe des spielers
    vehicles alle noch vorhandenen tickets }
  TPlayer = record
    current: byte;
    color: TColor;
    vehicles: TVehicle;
  end;

  { weg punkt fuer die wegfindung
    step  im wievielten schritt ist diese station zu erreichen
    from  von welcher station kommt der spieler }
  TWayPoint = record
    step:integer;
    from:byte;
  end;

  { ki record zur speicherung des naechsten schritts
    target  zielstation
    ticket  das zu nutzende ticket }
  TMove = record
    target:byte;
    ticket:TVehicles;
  end;

  { ein kompletter weg }
  TWay = array [1..199] of TWayPoint;

  { ergebnis record der ki zuege
    taktic  die gewaehlte taktik
    ticket  das gewaehlte ticket
    eval    die wertung zue zuges
    target  zielstation }
  TAiTurn = record
    taktic:byte;
    ticket:TVehicles;
    eval:double;
    target:byte;
  end;

  { spielstand record mit fast allen global noetiigen infos
    countDet anzahl detektive
    MRai            ob misterX von der ki gesteuert wird
    Dai             ob die detektive von der ki gesteuert werden
    showMR          wird misterX immer angezeigt?
    showstation     sollen die stationen markiert werden
    showboard       soll die landkarte angezeigt werden
    showPosTargets  sollen die moeglichen ziele ausgegeben werden
    gameStartet     ist ein spiel gestartet
    winner          ob und wer das spiel gewonnen hat
    MRpos           letzte zeigeposition von misterX 0 wenns noch keine gab
    currentPlayer   nummer des aktuellen spielers
    moveTable       array mit bisher von misterX benutzten tickets
    posibleTargets  moegliche positionen von misterX
    update          muss die fahrtentafel aktualisiert werden
    rou             die wievielte runde ist es aktuell }
  TGamestat = record
    countDet: byte;
    MRai: boolean;
    Dai: boolean;
    showMR:boolean;
    showstation:boolean;
    showboard:boolean;
    showPosTargets: boolean;
    gameStartet: boolean;
    winner:byte;
    MRpos: byte;
    CurrentPlayer: byte;
    moveTable: array [1..24] of TVehicles;
    posibleTargets:TTargets;
    update: boolean;
    rou: byte;
  end;

  { alle stationen }
  TStations = array [1..199] of TStation;

  { alle spieler }
  TPlayers = array of TPlayer;


implementation

end.
