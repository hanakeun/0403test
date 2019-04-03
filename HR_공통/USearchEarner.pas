unit USearchEarner;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, cxTextEdit,
  cxContainer, cxGroupBox, cxRadioGroup, Vcl.Mask, Vcl.StdCtrls, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxGridCustomView, cxGrid, Vcl.ComCtrls, Vcl.ToolWin, MemDS,
  VirtualTable, cxMaskEdit, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  dxSkinscxPCPainter;

type
  TfmSearchEarner = class(TForm)
    tlb1: TToolBar;
    btnInquiry: TToolButton;
    btnClose: TToolButton;
    stat1: TStatusBar;
    grdEarner: TcxGrid;
    grdviEarner: TcxGridDBTableView;
    grdlvEarner: TcxGridLevel;
    grpgb: TGroupBox;
    img1: TImage;
    lbName: TLabel;
    edtName: TEdit;
    img2: TImage;
    lbIdNo: TLabel;
    medtIdNo: TMaskEdit;
    rgxPersonal: TcxRadioGroup;
    vtEarner: TVirtualTable;
    dsEarner: TDataSource;
    shp1: TShape;
    vtEarnerhr_p_name: TStringField;
    vtEarnerhr_p_sangho: TStringField;
    vtEarnerhr_id_no: TStringField;
    vtEarnerhr_p_no: TStringField;
    vtEarnerhr_p_zip3: TStringField;
    vtEarnerhr_p_addr3: TStringField;
    vtEarnerhr_p_check: TStringField;
    grdcolEarnerhr_p_check: TcxGridDBColumn;
    grdcolEarnerhr_p_name: TcxGridDBColumn;
    grdcolEarnerhr_p_sangho: TcxGridDBColumn;
    grdcolEarnerhr_id_no: TcxGridDBColumn;
    grdcolEarnerhr_p_no: TcxGridDBColumn;
    grdcolEarnerhr_p_zip3: TcxGridDBColumn;
    grdcolEarnerhr_p_addr3: TcxGridDBColumn;
    grdcolEarnerNo: TcxGridDBColumn;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grdviEarnerCellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure btnInquiryClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtNameKeyPress(Sender: TObject; var Key: Char);
    procedure rgxPersonalClick(Sender: TObject);
    procedure grdcolEarnerNoGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: string);
  private
    // �ּ�, �ִ�ũ�� ����
    minSize, maxSize: TPoint;
    procedure WMGetMinMAXInfo(var msg: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;

  public
    { Public declarations }
  end;

var
  fmSearchEarner: TfmSearchEarner;
  arrEarnerInfo: array[0..16] of String;

implementation

uses coop_sql_updel, Unit1;

{$R *.dfm}

procedure TfmSearchEarner.WMGetMinMAXInfo(var msg: TWMGetMinMaxInfo);
begin
  if Visible then
  begin
    msg.MinMaxInfo^.ptMinTrackSize := minSize;
    msg.MinMaxInfo^.ptMaxTrackSize := maxSize;
  end;
end;

procedure TfmSearchEarner.FormCreate(Sender: TObject);
begin
  // ShowMessage �������� ����
  Screen.OnActiveFormChange := Form1.OnScreenActiveFormChange;

  // �� �ּ�ũ�� ���� 740 * 560
  minSize.X := 740;
  minSize.Y := 560;
  // �� �ִ�ũ�� ����
  maxSize.X := GetSystemMetrics(SM_CXSCREEN); // ������ػ�
  maxSize.Y := GetSystemMetrics(SM_CYSCREEN);

  //showCtrl(Memo1);
end;

procedure TfmSearchEarner.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

// ����
procedure TfmSearchEarner.btnCloseClick(Sender: TObject);
begin
  vtEarner.Close;
  Close;
end;

// ����Ű
procedure TfmSearchEarner.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfmSearchEarner.edtNameKeyPress(Sender: TObject; var Key: Char);
begin
  vtEarner.Clear;
  if Key = #13 then
    btnInquiryClick(btnInquiry);
end;

// ��ȸ
procedure TfmSearchEarner.btnInquiryClick(Sender: TObject);
var
  ashSQL, condSQL, ashStr, strName, strIdNo: String;
begin
  vtEarner.Clear;

  strName := Trim(edtName.Text);
  strIdNo := Trim(medtIdNo.Text);

  condSQL := '';
  if rgxPersonal.ItemIndex = 0 then // ����
  begin
    condSQL := ' AND hr_p_check = "0"';
    if (strName <> '') then
      condSQL := condSQL + ' AND hr_p_name LIKE "%' + strName + '%"';

    if (strIdNo <> '') then
      condSQL := condSQL + ' AND hr_id_no LIKE "%' + strIdNo + '%"';
  end
  else if rgxPersonal.ItemIndex = 1 then // ����
  begin
    condSQL := ' AND hr_p_check = "1"';
    if (strName <> '') then
      condSQL := condSQL + ' AND hr_p_sangho LIKE "%' + strName + '%"';

    if (strIdNo <> '') then
      condSQL := condSQL + ' AND hr_p_no LIKE "%' + strIdNo + '%"';
  end;

  ashSQL := 'SELECT hr_p_check, hr_p_name, hr_id, hr_id_no2, hr_id_no'
          + ', hr_p_sangho, hr_p_no, hr_p_zip3, hr_p_addr3'
          + ', hr_p_fgubun, hr_p_countrycd, hr_p_bank_code, hr_p_account_no'
          + ', hr_p_houseno, hr_p_companyno, hr_p_hpno, hr_p_email'
          + ' FROM hr_f_p_soduk'
          + ' WHERE TRUE'
          + condSQL;
  Memo1.Lines.Add(ashSQL);
  ashStr := MySQL_Assign(Form1.db_coophr, Form1.qrysql, ashSQL, vtEarner);
  try
    StrToInt(ashStr);
  except
    ShowMessage('������ �߻��Ͽ����ϴ�.[' + ashStr + '](ERR:�ҵ�����ȸ)');
    Exit;
  end;

  if vtEarner.RecordCount = 0 then
  begin
    ShowMessage('�˻������ �����ϴ�.');
  end;
end;

// �׸��� ����Ŭ�� �� ��޸��� â���� ���� ����
procedure TfmSearchEarner.grdcolEarnerNoGetDisplayText(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
begin
  AText := IntToStr(Arecord.Index + 1);
end;

procedure TfmSearchEarner.grdviEarnerCellDblClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  if vtEarner.RecordCount > 0 then
  begin
    {
    [0]  ����/���α���
    [1]  ����
    [2]  ���θ�(��ȣ)
    [3]  �ֹι�ȣŰ
    [4]  �ֹι�ȣ���ڸ�
    [5]  �ֹε�Ϲ�ȣ
    [6]  ����ڵ�Ϲ�ȣ
    [7]  �����ȣ
    [8]  �ּ�
    [9]  ���ܱ��α����ڵ�
    [10]  ���������ڵ�
    [11]  �����ڵ�
    [12] ���¹�ȣ
    [13] ������ȭ��ȣ
    [14] ȸ����ȭ��ȣ
    [15] �޴���ȭ��ȣ
    [16] �̸���
    }
    arrEarnerInfo[0]  := vtEarner.fieldByName('hr_p_check').AsString;
    arrEarnerInfo[1]  := vtEarner.fieldByName('hr_p_name').AsString;
    arrEarnerInfo[2]  := vtEarner.fieldByName('hr_p_sangho').AsString;
    arrEarnerInfo[3]  := vtEarner.fieldByName('hr_id').AsString;
    arrEarnerInfo[4]  := vtEarner.fieldByName('hr_id_no2').AsString;
    arrEarnerInfo[5]  := vtEarner.fieldByName('hr_id_no').AsString;
    arrEarnerInfo[6]  := vtEarner.fieldByName('hr_p_no').AsString;
    arrEarnerInfo[7]  := vtEarner.fieldByName('hr_p_zip3').AsString;
    arrEarnerInfo[8]  := vtEarner.fieldByName('hr_p_addr3').AsString;
    arrEarnerInfo[9]  := vtEarner.fieldByName('hr_p_fgubun').AsString;
    arrEarnerInfo[10] := vtEarner.fieldByName('hr_p_countrycd').AsString;
    arrEarnerInfo[11] := vtEarner.fieldByName('hr_p_bank_code').AsString;
    arrEarnerInfo[12] := vtEarner.fieldByName('hr_p_account_no').AsString;
    arrEarnerInfo[13] := vtEarner.fieldByName('hr_p_houseno').AsString;
    arrEarnerInfo[14] := vtEarner.fieldByName('hr_p_companyno').AsString;
    arrEarnerInfo[15] := vtEarner.fieldByName('hr_p_hpno').AsString;
    arrEarnerInfo[16] := vtEarner.fieldByName('hr_p_email').AsString;

    ModalResult := mrOk;
  end;
end;

// ����/���� �����׷� ���� ��
procedure TfmSearchEarner.rgxPersonalClick(Sender: TObject);
begin
  vtEarner.Clear;
  if rgxPersonal.ItemIndex = 0 then // ����
  begin
    lbName.Caption := '����';
    lbIdNo.Caption := '�ֹε�Ϲ�ȣ';
    medtIdNo.EditMask := '!999999-9999999;0;_';
    grdviEarner.Columns[2].Visible := True;
    grdviEarner.Columns[3].Visible := False;
    grdviEarner.Columns[4].Visible := True;
    grdviEarner.Columns[5].Visible := False;
  end
  else if rgxPersonal.ItemIndex = 1 then // ����
  begin
    lbName.Caption := '��ȣ';
    lbIdNo.Caption := '����ڵ�Ϲ�ȣ';
    medtIdNo.EditMask := '!999-99-99999;0;_';
    grdviEarner.Columns[2].Visible := False;
    grdviEarner.Columns[3].Visible := True;
    grdviEarner.Columns[4].Visible := False;
    grdviEarner.Columns[5].Visible := True;
  end;
end;

end.
