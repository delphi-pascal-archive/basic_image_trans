program BasicImageTransitions;

uses
  Forms,
  FMain in 'FMain.pas' {FrmMain},
  CustomTransition in 'CustomTransition.pas',
  FadeTransition in 'FadeTransition.pas',
  WipeTransition in 'WipeTransition.pas',
  ScrollTransition in 'ScrollTransition.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
