program hr_common_code;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  coophr_utils in '..\..\coophr_utils\coophr_utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'HR공통코드관리';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
