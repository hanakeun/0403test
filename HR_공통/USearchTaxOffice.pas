unit USearchTaxOffice;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Grids, DBGrids, StdCtrls, ExtCtrls, ToolWin, DB,
  MemDS, VirtualTable, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,
  cxNavigator, cxDBData, cxTextEdit, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridLevel, cxClasses, cxGridCustomView, cxGrid, Excels, ComObj, OleCtrls;

type
  TfmSearchTaxOffice = class(TForm)
    ToolBar1: TToolBar;
    btnInquiry: TToolButton;
    btnClose: TToolButton;
    gb_cd_save: TGroupBox;
    Image1: TImage;
    Image30: TImage;
    Label1: TLabel;
    Label2: TLabel;
    edtTaxOffice: TEdit;
    StatusBar1: TStatusBar;
    edtZone: TEdit;
    dsTaxOffice: TDataSource;
    vtTaxOffice: TVirtualTable;
    grdviTaxOffice: TcxGridDBTableView;
    grdlvTaxOffice: TcxGridLevel;
    grdTaxOffice: TcxGrid;
    grdcolTaxOfficeCode: TcxGridDBColumn;
    grdcolTaxOfficeName: TcxGridDBColumn;
    grdcolAcctNo: TcxGridDBColumn;
    grdcolZone: TcxGridDBColumn;
    grdcolZip: TcxGridDBColumn;
    grdcolAddr: TcxGridDBColumn;
    grdcolTelNo: TcxGridDBColumn;
    grdcolFaxNo: TcxGridDBColumn;
    grdcolMpstCode: TcxGridDBColumn;
    grdcolPday: TcxGridDBColumn;
    strngfldTaxOfficehr_group_ab: TStringField;
    grdcolGroupAb: TcxGridDBColumn;
    btn1: TToolButton;
    btnExcelUp: TToolButton;
    btnSave: TToolButton;
    Excel1: TExcel;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnInquiryClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure edtTaxOfficeKeyPress(Sender: TObject; var Key: Char);
    procedure edtZoneKeyPress(Sender: TObject; var Key: Char);
    procedure grdviTaxOfficeCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure grdviTaxOfficeStylesGetContentStyle(
      Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
    procedure grdviTaxOfficeCellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure btnExcelUpClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure ToolBar1DblClick(Sender: TObject);

  private
    ashSql, ashStr: String;
    // �ּ�, �ִ�ũ�� ����
    minSize, maxSize: TPoint;
    procedure WMGetMinMAXInfo(var msg: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
  end;

var
  fmSearchTaxOffice: TfmSearchTaxOffice;
  arrTaxOfficeInfo: array[0..7] of String;

implementation

uses coophr_utils, coop_sql_updel, Unit1;

{$R *.dfm}

// �� ũ��
procedure TfmSearchTaxOffice.WMGetMinMAXInfo(var msg: TWMGetMinMaxInfo);
begin
  if Visible then
  begin
    msg.MinMaxInfo^.ptMinTrackSize := minSize;
    msg.MinMaxInfo^.ptMaxTrackSize := maxSize;
  end;
end;

// FormCreate
procedure TfmSearchTaxOffice.FormCreate(Sender: TObject);
begin
  // �� �ּ�ũ�� ���� 650 * 600
  minSize.X := 650;
  minSize.Y := 600;
  // �� �ִ�ũ�� ����
  maxSize.X := GetSystemMetrics(SM_CXSCREEN); // ������ػ�
  maxSize.Y := GetSystemMetrics(SM_CYSCREEN);

  ToolBar1DblClick(ToolBar1);
end;

procedure TfmSearchTaxOffice.ToolBar1DblClick(Sender: TObject);
begin
  showCtrl(btnExcelUp);
  showCtrl(btnSave);
end;

// ��ȸ
procedure TfmSearchTaxOffice.btnInquiryClick(Sender: TObject);
begin
  ashSql := 'SELECT'
          + ' hr_tax_office_code'
	        + ', hr_group_ab'
	        + ', CASE hr_group_ab WHEN 0 THEN CONCAT(hr_tax_office_code, "000")'
	          + ' ELSE CONCAT(hr_group_ab, hr_tax_office_code) END AS orderNo'
	        + ', hr_tax_office_name'
          + ', hr_acct_no'
          + ', hr_zone'
          + ', hr_zip'
          + ', hr_addr1'
          + ', hr_tel_no'
          + ', hr_fax_no'
          + ', (SELECT hr_m_name FROM hr_members WHERE hr_m_code = hr_tax_office.mpst_code) mpst_code'
          + ', p_day'
          + ' FROM hr_tax_office'
          + ' WHERE 1=1'
          + ' AND (hr_tax_office_code LIKE "%' + Trim(edtTaxOffice.Text) + '%"'
          + ' OR hr_tax_office_name LIKE "%' + Trim(edtTaxOffice.Text) + '%")'
          + ' AND hr_zone LIKE "%' + Trim(edtZone.Text) + '%"'
          + ' ORDER BY orderNo';

  ashStr := MySQL_Assign(Form1.db_coophr, Form1.qrysql, ashSql, vtTaxOffice);
  try
    StrToInt(ashStr);
  except
    ShowMessage('������ �߻��Ͽ����ϴ�.[' + ashStr + '](ERR:112)');
    Exit;
  end;

  {if vtTaxOffice.RecordCount = 1 then // �˻������ �ϳ��̸�
  begin
    grdTaxOfficeDblClick(grdTaxOffice);
  end
  else}
  if vtTaxOffice.RecordCount < 1 then
  begin
    //Application.Title := '�������˻�';
    ShowMessage('�˻������ �����ϴ�.');
  end;
end;

// ����
procedure TfmSearchTaxOffice.btnCloseClick(Sender: TObject);
begin
  Close;
end;

// ������ Ű �ٿ� �̺�Ʈ �߻� ��
procedure TfmSearchTaxOffice.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssAlt]) or (Shift = [ssCtrl]) then
    Exit;

  case Key of
    VK_RIGHT: // VK_RIGHT ������Ŀ�� �̵�Ű
      begin
        SelectNext(ActiveControl, False, True);
        key := 0;
      end;
    VK_RETURN:
      begin
        SelectNext(ActiveControl, True, True);
        key := 0;
      end;
    VK_F1:
      begin
        ShowMessage('F1');
        Key := 0;
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

// FormClose
procedure TfmSearchTaxOffice.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  vtTaxOffice.Close;
  Form1.db_coophr.Disconnect;
  Action := caFree;
end;

// �׸��� ����Ŭ�� �� ��޸��� â���� ������� ����
procedure TfmSearchTaxOffice.grdviTaxOfficeCellDblClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  if vtTaxOffice.RecordCount > 0 then
  begin
    {
    [0] û���ڵ�
    [1] û����
    [2] ���¹�ȣ
    [3] ���ұ���
    [4] �����ȣ
    [5] �ּ�
    [6] ��ȭ��ȣ
    [7] �ѽ���ȣ
    }
    arrTaxOfficeInfo[0] := vtTaxOffice.FieldByName('hr_tax_office_code').AsString;
    arrTaxOfficeInfo[1] := vtTaxOffice.FieldByName('hr_tax_office_name').AsString;
    arrTaxOfficeInfo[2] := vtTaxOffice.FieldByName('hr_acct_no').AsString;
    arrTaxOfficeInfo[3] := vtTaxOffice.FieldByName('hr_zone').AsString;
    arrTaxOfficeInfo[4] := vtTaxOffice.FieldByName('hr_zip').AsString;
    arrTaxOfficeInfo[5] := vtTaxOffice.FieldByName('hr_addr1').AsString;
    arrTaxOfficeInfo[6] := vtTaxOffice.FieldByName('hr_tel_no').AsString;
    arrTaxOfficeInfo[7] := vtTaxOffice.FieldByName('hr_fax_no').AsString;

    ModalResult := mrOk;
  end;
end;

procedure TfmSearchTaxOffice.grdviTaxOfficeCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  ARect: TRect;
begin
  {ACanvas.Brush.Color := clMoneyGreen;
  ARect := AViewInfo.Bounds;
  //columnID := grdviTaxOffice.GetColumnByFieldName('hr_group_ab').Index;
  //cellValue := AViewInfo.GridRecord.Values[columnID];

  // ����û row ����ٲٱ�
  if vtTaxOffice.FieldByName('hr_group_ab').AsString = '0' then
  begin
    ACanvas.Brush.Color := clMoneyGreen;
    ACanvas.FillRect(ARect);
  end;
  }
end;

procedure TfmSearchTaxOffice.grdviTaxOfficeStylesGetContentStyle(
  Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
begin
  {if vtTaxOffice.FieldByName('hr_group_ab').AsString = '0' then
  begin
    AStyle := Form1.cxstylGrdRow1;
  end;
  }

  if ARecord.Values[grdcolGroupAb.Index] = '0' then
    AStyle := Form1.cxstylGrdRow1;
end;

// ��ȸ���� û���� edit���� ���� Ű�� ��ȸ
procedure TfmSearchTaxOffice.edtTaxOfficeKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
    btnInquiryClick(btnInquiry);
end;

// ��ȸ���� ���ұ��� edit���� ���� Ű�� ��ȸ
procedure TfmSearchTaxOffice.edtZoneKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
    btnInquiryClick(btnInquiry);
end;

// �������ε�  - ������
procedure TfmSearchTaxOffice.btnExcelUpClick(Sender: TObject);
var
  v: Variant;
  i, x, rowCnt, startRow: integer;
  taxCd, taxNm, groupAb, acctNo, zone, zip, addr, telNo, faxNo: String;
begin
  if OpenDialog1.Execute then
  begin
    v := CreateOleObject('Excel.application');
    try
    except
      showmessage('Excel ��ġ�Ǿ� ���� �ʽ��ϴ�.');
      exit;
    end;
    v.workbooks.open(OpenDialog1.FileName);
  end
  else
    Exit;

  startRow := 3;
  rowCnt := strtoint(v.ActiveSheet.UsedRange.Rows.Count);

  if not vtTaxOffice.Active then vtTaxOffice.Active := True;
  vtTaxOffice.Clear;
  for i := 0 to vtTaxOffice.FieldCount - 1 do
  begin
    vtTaxOffice.Fields[i].ReadOnly := False;
  end;
  vtTaxOffice.Edit;

  for i := startRow to rowCnt do
  begin
    x := 1;
    taxCd   := Trim(v.cells[i, x]); Inc(x);
    taxNm   := Trim(v.cells[i, x]); Inc(x);
    groupAb := Trim(v.cells[i, x]); Inc(x);
    acctNo  := Trim(v.cells[i, x]); Inc(x);
    zone    := Trim(v.cells[i, x]); Inc(x);
    zip     := Trim(v.cells[i, x]); Inc(x);
    addr    := Trim(v.cells[i, x]); Inc(x);
    telNo   := Trim(v.cells[i, x]); Inc(x);
    faxNo   := Trim(v.cells[i, x]); Inc(x);

    vtTaxOffice.Append;
    vtTaxOffice.FieldByName('hr_tax_office_code').AsString := taxCd;
    vtTaxOffice.FieldByName('hr_tax_office_name').AsString := taxNm;
    vtTaxOffice.FieldByName('hr_group_ab').AsString := groupAb;
    vtTaxOffice.FieldByName('hr_acct_no').AsString := acctNo;
    vtTaxOffice.FieldByName('hr_zone').AsString := zone;
    vtTaxOffice.FieldByName('hr_zip').AsString := zip;
    vtTaxOffice.FieldByName('hr_addr1').AsString := addr;
    vtTaxOffice.FieldByName('hr_tel_no').AsString := telNo;
    vtTaxOffice.FieldByName('hr_fax_no').AsString := faxNo;
  end;
  v.quit;

  ShowMessage('�������ε� �Ϸ�');
end;

// ����
procedure TfmSearchTaxOffice.btnSaveClick(Sender: TObject);
var
  taxCd, taxNm, groupAb, acctNo, zone, zip, addr, telNo, faxNo: String;
begin
  vtTaxOffice.First;
  while not vtTaxOffice.Eof do
  begin
    taxCd   := Trim(vtTaxOffice.FieldByName('hr_tax_office_code').AsString);
    taxNm   := Trim(vtTaxOffice.FieldByName('hr_tax_office_name').AsString);
    groupAb := Trim(vtTaxOffice.FieldByName('hr_group_ab').AsString);
    acctNo  := Trim(vtTaxOffice.FieldByName('hr_acct_no').AsString);
    zone    := Trim(vtTaxOffice.FieldByName('hr_zone').AsString);
    zip     := Trim(vtTaxOffice.FieldByName('hr_zip').AsString);
    addr    := Trim(vtTaxOffice.FieldByName('hr_addr1').AsString);
    telNo   := Trim(vtTaxOffice.FieldByName('hr_tel_no').AsString);
    faxNo   := Trim(vtTaxOffice.FieldByName('hr_fax_no').AsString);

    ashSql := 'INSERT INTO hr_tax_office ('
            + 'hr_tax_office_code, hr_tax_office_name, hr_group_ab, hr_acct_no, hr_zone'
            + ', hr_zip, hr_addr1, hr_tel_no, hr_fax_no'
            + ', hr_mpst_code, hr_p_day, mpst_code, p_day, chk_svr'
            + ') VALUES ('
            + '"' + taxCd + '"'
            + ', "' + taxNm + '"'
            + ', "' + groupAb + '"'
            + ', "' + acctNo + '"'
            + ', "' + zone + '"'
            + ', "' + zip + '"'
            + ', "' + addr + '"'
            + ', "' + telNo + '"'
            + ', "' + faxNo + '"'
            + ', "' + mpst_code + '"'
            + ', NOW()'
            + ', "' + mpst_code + '"'
            + ', NOW()'
            + ', "' + IntToStr(svrconn) + '"'
            + ') ON DUPLICATE KEY UPDATE'
            + ' hr_tax_office_name = "' + taxNm + '"'
            + ', hr_group_ab = "' + groupAb + '"'
            + ', hr_acct_no = "' + acctNo + '"'
            + ', hr_zone = "' + zone + '"'
            + ', hr_zip = "' + zip + '"'
            + ', hr_addr1 = "' + addr + '"'
            + ', hr_tel_no = "' + telNo + '"'
            + ', hr_fax_no = "' + faxNo + '"'
            + ', mpst_code = "' + mpst_code + '"'
            + ', p_day = NOW()'
            + ', chk_svr = "' + IntToStr(svrconn) + '"';

    try
      ashReturnRow := StrToInt(MySQL_UpDel(Form1.db_coophr, Form1.qrysql, ashSql));
    except
    on e: Exception do
      begin
        ShowMessage('���� ����.[hr_branch]' + #13 + e.Message);
        Exit;
      end;
    end;

    vtTaxOffice.Next;
  end;

  ShowMessage('����!');
end;

end.
