unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, Excels, DB;

type
  TForm2 = class(TForm)
    DBGrid1: TDBGrid;
    f2btnExcel: TBitBtn;
    BitBtn2: TBitBtn;
    Excel1: TExcel;
    Label1: TLabel;
    Label2: TLabel;
    OpenDialog1: TOpenDialog;
    procedure BitBtn2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure f2btnExcelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
//https://github.com/hanakeun/0403test.git///https://github.com/hanakeun/0403test.git//https://github.com/hanakeun/0403test.git

  private
    { Private declarations }

  public
    procedure MouseWheelHandler(var Message: TMessage); override;
    { Public declarations }

  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.dfm}

{

★ 20181022yik  밑에 마우스휠핸들러로 변경. 이거는 밑으로 내리면 올라가는 버그가 있음.★

procedure TForm2.MouseWheelHandler(var Message: TMessage);
begin
  if Message.msg = WM_MOUSEWHEEL then
  begin
    if (ActiveControl is TDBgrid) then
    begin
      if Message.wParam > 0 then
      begin
        keybd_event(VK_UP, VK_UP, 0, 0);
      end
      else if Message.wParam < 0 then
      begin
        keybd_event(VK_DOWN, VK_DOWN, 0, 0);
      end;
    end;
  end;
end;
}

procedure TForm2.MouseWheelHandler(var Message: TMessage);
var
i: SmallInt;
begin
// inherited;
  if Message.Msg = WM_MOUSEWHEEL then
  begin
    if ActiveControl is TDBGrid then
    begin
      Message.Msg := WM_KEYDOWN;
      Message.lParam := 0;
      i := HiWord(Message.wParam);
      if i > 0 then
          Message.wParam := VK_UP
      else
          Message.wParam := VK_DOWN;
          SendMessage(ActiveControl.Handle, Message.Msg, Message.wParam, Message.LParam);
          SendMessage(ActiveControl.Handle, Message.Msg, Message.wParam, Message.LParam);
          SendMessage(ActiveControl.Handle, Message.Msg, Message.wParam, Message.LParam);
          (ActiveControl as TDBGrid).Refresh;
      end;
  end;
end;


procedure TForm2.BitBtn2Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TForm2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (Shift = [ssAlt]) or (Shift = [ssCtrl]) then
   Exit;

 case Key of
   VK_Escape:
   begin
     ModalResult := mrOK;
     Key := 0;
   end;
   {VK_F4:
   begin
    if f2btnSave.Enabled then
      f2btnSaveClick(f2btnSave);
     Key := 0;
   end;
 }
   VK_F11:
   begin
    if f2btnExcel.Enabled then
      f2btnExcelClick(f2btnExcel);
     Key := 0;
   end;

 end;
end;

//엑셀버튼
procedure TForm2.f2btnExcelClick(Sender: TObject);
var
  i : integer;
begin
  // 엑셀출력
  if ((Form1.tblmembership.Active = False) or (Form1.tblmembership.RecordCount = 0)) then
  begin
    ShowMessage('조회 후 선택하십시요!!!');
    Exit;
  end;
  Screen.Cursor   := crHourGlass;
  DBGrid1.Enabled := False;
  Excel1.Connect;
  Excel1.Exec('[WORKBOOK.INSERT(1)]');

  Excel1.PutStr(1,1,'수수료부과매장 List');
  Excel1.PutStr(2,1,'접속단체 : '+Form1.tblorg.FieldByName('o_name').AsString);
  Excel1.PutStr(2,3,'출력일시 : '+formatDateTime('yyyy-mm-dd', now));
  Excel1.PutStr(2,5,'출력자 : '+ mpst_name);

  Excel1.PutStr(3,1,'조합원코드');
  Excel1.PutStr(3,2,'조합원명');
  Excel1.PutStr(3,3,'수수료부과매장명');
  Excel1.PutStr(3,4,'수수료부과매장코드');

  Form1.tblmembership.First;
  for i:=4 to Form1.tblmembership.RecordCount+3 do
  begin
    Excel1.PutStr(i, 01, ''''+Form1.tblmembership.fieldByName('m_code').AsString);
    Excel1.PutStr(i, 02, Form1.tblmembership.fieldByName('m_name').AsString);
    Excel1.PutStr(i, 03, Form1.tblmembership.fieldByName('j_name').AsString);
    Excel1.PutStr(i, 04, Form1.tblmembership.fieldByName('maejang_code').AsString);

  Form1.tblmembership.Next;

  end;

  Excel1.Disconnect;
  DBGrid1.Enabled := True;
  Screen.Cursor := crDefault;
  Form1.tblmembership.First;

  DBGrid1.Refresh;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  Label1.Caption := intTostr(Form1.tblmembership.RecordCount)+' 건';
end;

end.
