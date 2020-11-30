program Pscotlandyard;

uses
  Vcl.Forms,
  Uscotlandyard in 'Uscotlandyard.pas' {scotlandyard},
  startmen in 'startmen.pas' {Startmenue},
  TypeUnit in 'TypeUnit.pas',
  AI_Unit in 'AI_Unit.pas',
  DATA_Unit in 'DATA_Unit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tscotlandyard, scotlandyard);
  Application.CreateForm(TStartmenue, Startmenue);
  Application.Run;
end.
