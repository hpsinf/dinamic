program ProjetoTest;

uses
  Vcl.Forms,
  UTest in 'UTest.pas' {Form2},
  uJson in 'uJson.pas',
  Helper in 'Helper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
