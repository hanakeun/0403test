program test_sun;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  coop_utils in '..\..\coop_utils\coop_utils.pas',
  Unit2 in 'Unit2.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '��ǥ�Է�';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
