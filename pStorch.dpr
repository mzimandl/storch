program pStorch;

uses
  Forms,
  uStorch in 'uStorch.pas' {Form1},
  kresleni in 'kresleni.pas',
  Procedury in 'Procedury.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '��orch';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
