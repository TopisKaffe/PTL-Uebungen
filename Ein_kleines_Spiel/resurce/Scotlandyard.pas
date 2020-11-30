unit Scotlandyard;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls;

type
  TFscotlandyard = class(TForm)
    MainMenu1: TMainMenu;
    Spiel1: TMenuItem;
    Einstellungen1: TMenuItem;
    Neu1: TMenuItem;
    ffnen1: TMenuItem;
    Speichern1: TMenuItem;
    Beenden1: TMenuItem;
    Karteanzeigen1: TMenuItem;
    Netzanzeigen1: TMenuItem;
    Stationenanzeigen1: TMenuItem;
    MisterXanzeigencheatmodus1: TMenuItem;
    MglicheZielpositzionenanzeigencheatmodus1: TMenuItem;
    karte: TImage;
    karteBMP: TBitmap;
    procedure Beenden1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure drawboard();
  public
    { Public-Deklarationen }
  end;

var
  Fscotlandyard: TFscotlandyard;

implementation

{$R *.dfm}


procedure TFscotlandyard.drawboard();
begin
  karte.Canvas.Draw(0,0,karteBMP);

end;
procedure TFscotlandyard.Beenden1Click(Sender: TObject);
begin
  Fscotlandyard.Close;
end;

procedure TFscotlandyard.FormCreate(Sender: TObject);
begin
  karteBMP := TBitmap.Create;
  karteBMP.LoadFromFile('../../Spielplan.bmp');
  Fscotlandyard.Width:=1400;
  Fscotlandyard.Height:=900;
end;

end.
