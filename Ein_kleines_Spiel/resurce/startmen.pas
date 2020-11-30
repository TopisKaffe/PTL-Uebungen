unit startmen;

{ Startmenue fenster }
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TStartmenue = class(TForm)
    PlayerCount: TComboBox;
    Abbrechen: TButton;
    Start: TButton;
    MisterX: TCheckBox;
    Detective: TCheckBox;
    KISelect: TLabel;
    Detectiveanzahl: TLabel;

    { getter fuer detectiv anzah }
    function getplayercount():byte;
    { getter fuer checkbox }
    function getMisterXKi():boolean;
    { getter fuer checkbox }
    function getdetectiveKi():boolean;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Startmenue: TStartmenue;

implementation

{$R *.dfm}
function TStartmenue.getplayercount():byte;
begin
  getplayercount:=PlayerCount.ItemIndex+3;
end;

function TStartmenue.getMisterXKi():boolean;
begin
  getMisterXKi:=MisterX.Checked;
end;

function TStartmenue.getdetectiveKi():boolean;
begin
  getdetectiveKi:=Detective.Checked;
end;


end.
