unit USearchBank;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  MemDS, VirtualTable, Vcl.ComCtrls, Vcl.ToolWin, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, cxDBData, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses,
  cxGridLevel, cxGrid, cxTextEdit;

type
  TfmSearchBank = class(TForm)
    tlb1: TToolBar;
    btnInquiry: TToolButton;
    btnClose: TToolButton;
    vtBankCode: TVirtualTable;
    dsBankCode: TDataSource;
    grpgb: TGroupBox;
    img1: TImage;
    lb1: TLabel;
    edtBank: TEdit;
    stat1: TStatusBar;
    grdBank: TcxGrid;
    grdlvBank: TcxGridLevel;
    grdviBank: TcxGridDBTableView;
    vtBankCodefval: TStringField;
    vtBankCodefname: TStringField;
    grdcolBankfval: TcxGridDBColumn;
    grdcolBankfname: TcxGridDBColumn;
    grdcolBankNo: TcxGridDBColumn;
    procedure grdviBankCellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure btnInquiryClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure edtBankKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure grdcolBankNoGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmSearchBank: TfmSearchBank;
  arrBankCode: array[0..1] of String;
  str: string;

implementation

uses coop_sql_updel, Unit1;

{$R *.dfm}

procedure TfmSearchBank.FormCreate(Sender: TObject);
begin
  // ShowMessage �������� ����
  Screen.OnActiveFormChange := Form1.OnScreenActiveFormChange;

  str := Trim(Form1.edtBankName.Text);
  if str <> '' then
  begin
    edtBank.Text := str;
    btnInquiryClick(btnInquiry);
  end;
end;

// ����Ű�� ����� ��ȸ
procedure TfmSearchBank.edtBankKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btnInquiryClick(btnInquiry);
end;

// ��ȸ
procedure TfmSearchBank.btnInquiryClick(Sender: TObject);
var
  ashSQL, ashStr, bankCode: String;
begin
  ashSQL := 'SELECT fval, fname FROM code '
          + 'WHERE fkind = "BANK" AND fcode = 0 AND fname <> ""';

  bankCode := Trim(edtBank.Text);
  if bankCode <> '' then
  begin
    ashSQL := ashSQL + ' AND (fval LIKE "%' + bankCode + '%" '
            + 'OR fname LIKE "%' + bankCode + '%")';
  end;

  ashStr := MySQL_Assign(Form1.db_coopbase, Form1.qrysql, ashSQL, vtBankCode);
  try
    StrToInt(ashStr);
  except
    ShowMessage('������ �߻��Ͽ����ϴ�.[' + ashStr + '](ERR:�����ڵ���ȸ)');
    Exit;
  end;

  if vtBankCode.RecordCount = 0 then
  begin
    ShowMessage('�˻������ �����ϴ�.');
  end;
end;

// ����
procedure TfmSearchBank.btnCloseClick(Sender: TObject);
begin
  vtBankCode.Close;
  Close;
end;

procedure TfmSearchBank.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

// �׸��� ����Ŭ�� �� ��޸��� â���� �ڵ����� ����
procedure TfmSearchBank.grdcolBankNoGetDisplayText(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
begin
  AText := IntToStr(Arecord.Index + 1);
end;

procedure TfmSearchBank.grdviBankCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  if vtBankCode.RecordCount > 0 then
  begin
    {
    [0] �����ڵ�
    [1] �����
    }
    arrBankCode[0] := vtBankCode.fieldByName('fval').AsString;
    arrBankCode[1] := vtBankCode.fieldByName('fname').AsString;

    ModalResult := mrOk;
  end;
end;

// ����Ű
procedure TfmSearchBank.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssAlt]) or (Shift = [ssCtrl]) then
    Exit;

  case Key of
    VK_RIGHT: // VK_RIGHT ������Ŀ�� �̵�Ű
    begin
      SelectNext(ActiveControl, True, True);
      key := 0;
    end;

    VK_RETURN:
    begin
      SelectNext(ActiveControl, True, True);
      key := 0;
    end;

    VK_F9:
    begin
      if btnInquiry.Enabled then
        btnInquiryClick(btnInquiry);
      Key := 0;
    end;

    VK_ESCAPE: // ESC Ű
    begin
      if btnClose.Enabled then
        btnCloseClick(btnClose);
      Key := 0;
    end;
  end;
end;

end.
