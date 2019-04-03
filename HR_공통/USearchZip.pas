unit USearchZip;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Grids, DBGrids, StdCtrls, ExtCtrls, ToolWin, DB,
  MemDS, VirtualTable, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,
  cxNavigator, cxDBData, cxTextEdit, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridLevel, cxClasses, cxGridCustomView, cxGrid;

type
  TfmSearchZip = class(TForm)
    ToolBar1: TToolBar;
    btnInquiry: TToolButton;
    btnClose: TToolButton;
    StatusBar1: TStatusBar;
    vtZip: TVirtualTable;
    dsZip: TDataSource;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    gb_cd_save: TGroupBox;
    Image1: TImage;
    Image30: TImage;
    Label1: TLabel;
    Image2: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Image3: TImage;
    Label4: TLabel;
    edtZip1Addr2: TEdit;
    cbCityNm: TComboBox;
    cbSigunguCode: TComboBox;
    cbCityCd: TComboBox;
    edtZip1Addr1: TEdit;
    GroupBox1: TGroupBox;
    Image4: TImage;
    Image5: TImage;
    Label5: TLabel;
    Image6: TImage;
    Label6: TLabel;
    Label7: TLabel;
    cbSigunguCode2: TComboBox;
    cbCityCd2: TComboBox;
    cbCityNm2: TComboBox;
    edtZipAddr: TEdit;
    vtZip1: TVirtualTable;
    dsZip1: TDataSource;
    grdviZip1: TcxGridDBTableView;
    grdlvZip1: TcxGridLevel;
    grdZip1: TcxGrid;
    grdcolZip1Code: TcxGridDBColumn;
    grdcolZip1Addr1: TcxGridDBColumn;
    grdcolZip1Addr2: TcxGridDBColumn;
    grdviZipDBTableView1: TcxGridDBTableView;
    grdlvZipLevel1: TcxGridLevel;
    grdZip: TcxGrid;
    grdcolZipCode: TcxGridDBColumn;
    grdcolAddr1: TcxGridDBColumn;
    grdcolAddr2: TcxGridDBColumn;
    cbCitySortSeq: TComboBox;
    Memo1: TMemo;
    procedure btnInquiryClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbCityNmChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtZip1Addr2KeyPress(Sender: TObject; var Key: Char);
    procedure grdviZip1CellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure PageControl1Change(Sender: TObject);

  private
    ashSql, ashStr: String;

  end;

var
  fmSearchZip: TfmSearchZip;
  arrZipInfo: array[0..2] of String;

implementation

uses coophr_utils, coop_sql_updel, Unit1;

{$R *.dfm}

// FormCreate
procedure TfmSearchZip.FormCreate(Sender: TObject);
begin
  // 시/도 콤보박스 세팅
  ashSql := 'SELECT hr_code_value, hr_code_value_name, hr_sort_seq'
          + ' FROM hr_common_code_value'
          + ' WHERE hr_code_id = "hr_city_code"'
          + ' AND hr_use_yn <> "N"';
          //+ ' ORDER BY hr_sort_seq ASC';

  ashStr := MySQL_Assign(Form1.db_coophr, Form1.qrysql, ashSql, Form1.vtTemp);

  try
    StrToInt(ashStr);
  except
    ShowMessage(ashStr);
  end;

  cbCityCd.Clear;
  cbCityNm.Clear;
  cbCitySortSeq.Clear;
  cbCityCd.Items.Add('선택하세요.');
  cbCityNm.Items.Add('선택하세요.');
  cbCitySortSeq.Items.Add('선택하세요.');

  Form1.vtTemp.First;
  while not Form1.vtTemp.Eof do
  begin
    //cbCityNm.Items.AddObject(Form1.vtTemp.Fields[2].AsString, TObject(Form1.vtTemp.Fields[1].AsString));
    cbCityCd.Items.Add(Form1.vtTemp.Fields[0].AsString);
    cbCityNm.Items.Add(Form1.vtTemp.Fields[1].AsString);
    cbCitySortSeq.Items.Add(Form1.vtTemp.Fields[2].AsString);

    Form1.vtTemp.Next;
  end;
  cbCityNm.ItemIndex := 0;

  cbSigunguCode.Items.Add('선택하세요.');
  cbSigunguCode.ItemIndex := 0;
  cbSigunguCode.Enabled := False;

  // 지번주소 우편번호 검색 시
  ashSql := 'SELECT hr_code_value, hr_code_value_name '
          + 'FROM hr_common_code_value '
          + 'WHERE hr_code_id = "hr_city_code2" '
          + 'AND hr_use_yn <> "N"';
          //+ ' ORDER BY hr_sort_seq ASC';

  ashStr := MySQL_Assign(Form1.db_coophr, Form1.qrysql, ashSql, Form1.vtTemp);

  try
    StrToInt(ashStr);
  except
    ShowMessage(ashStr);
  end;

  cbCityCd2.Clear;
  cbCityNm2.Clear;
  cbCityCd2.Items.Add('선택하세요.');
  cbCityNm2.Items.Add('선택하세요.');

  Form1.vtTemp.First;
  while not Form1.vtTemp.Eof do
  begin
    cbCityCd2.Items.Add(Form1.vtTemp.Fields[0].AsString);
    cbCityNm2.Items.Add(Form1.vtTemp.Fields[1].AsString);

    Form1.vtTemp.Next;
  end;

  cbCityNm2.ItemIndex := 0;
  cbSigunguCode2.Items.Add('선택하세요.');
  cbSigunguCode2.ItemIndex := 0;
  cbSigunguCode2.Enabled := False;

  //showCtrl(cbCityCd);
  //showCtrl(cbCitySortSeq);
  //showCtrl(Memo1);
end;

// 조회
procedure TfmSearchZip.btnInquiryClick(Sender: TObject);
var
  subSql, zipNm: String;
begin
  subSql := '';

  if PageControl1.ActivePageIndex = 0 then // 도로명주소
  begin
    // 필수입력항목 확인
    if not chkExtVal(cbCityNm, '시·도') then Exit;
    if not chkExtVal(edtZip1Addr2, '도로명') then Exit;

    Screen.Cursor := crHourGlass;
    if cbCityNm.ItemIndex > 0 then
    begin
      subSql := ' AND addr1 LIKE "' + cbCityNm.Text + '%"';

      if cbSigunguCode.ItemIndex > 0 then
        subSql := ' AND addr1 LIKE "' + cbCityNm.Text + ' ' + cbSigunguCode.Text + '%"';
    end;

    if isEmpty(edtZip1Addr1.Text) then
      subSql := subSql + ' AND addr1 LIKE "%' + Trim(edtZip1Addr1.Text) + '%"';

    zipNm := cbCitySortSeq.Items[cbCityNm.ItemIndex];
    ashSql := 'SELECT zip_code, addr1, addr2'
            + ' FROM zip_' + zipNm
            + ' WHERE TRUE'
            + subSql
            + ' AND addr2 LIKE "%' + Trim(edtZip1Addr2.Text) + '%" '
            + ' AND p_ab = "A"';

    Memo1.Lines.Add(ashSql);
    ashStr := MySQL_Assign(Form1.db_coopbase, Form1.qrysql, ashSql, vtZip1);
    try
      StrToInt(ashStr);
    except
      ShowMessage('오류가 발생하였습니다.[' + ashStr + '](ERR:도로명 우편번호 조회)');
      Screen.Cursor := crDefault;
      Exit;
    end;
    Screen.Cursor := crDefault;

    if vtZip1.RecordCount = 0 then
      ShowMessage('검색결과가 없습니다.');

  end
  else if PageControl1.ActivePageIndex = 1 then // 지번주소
  begin
    // 필수입력항목 확인
    if not chkExtVal(edtZipAddr, '주소검색어') then Exit;

    Screen.Cursor := crHourGlass;
    if cbCityNm2.ItemIndex > 0 then
    begin
      subSql := 'AND addr1 LIKE "' + cbCityNm2.Text + '%" ';

      if cbSigunguCode2.ItemIndex > 0 then
        subSql := 'AND addr1 LIKE "' + cbCityNm2.Text + ' ' + cbSigunguCode2.Text + '%" ';
    end;

    ashSql := 'SELECT zip_code, addr1, addr2 '
            + 'FROM zip WHERE 1=1 '
            + subSql
            + 'AND (addr1 LIKE "%' + Trim(edtZipAddr.Text) + '%" '
            + 'OR addr2 LIKE "%' + Trim(edtZipAddr.Text) + '%")';

    Memo1.Lines.Add(ashSql);
    ashStr := MySQL_Assign(Form1.db_coopbase, Form1.qrysql, ashSql, vtZip);
    try
      StrToInt(ashStr);
    except
      ShowMessage('오류가 발생하였습니다.[' + ashStr + '](ERR:지번주소 우편번호 조회)');
      Screen.Cursor := crDefault;
      Exit;
    end;
    Screen.Cursor := crDefault;

    if vtZip.RecordCount = 0 then
      ShowMessage('검색결과가 없습니다.');
  end;
end;

// 종료
procedure TfmSearchZip.btnCloseClick(Sender: TObject);
begin
  Close;
end;

// 시/도 콤보박스 선택 시 시/군/구 설정
procedure TfmSearchZip.cbCityNmChange(Sender: TObject);
var
  cb: TComboBox;
  codeValue: String;
begin
  if PageControl1.ActivePageIndex = 0 then // 도로명주소
  begin
    cb := cbSigunguCode;
    codeValue := cbCityCd.Items[cbCityNm.ItemIndex];
  end
  else if PageControl1.ActivePageIndex = 1 then // 지번주소
  begin
    cb := cbSigunguCode2;
    codeValue := cbCityCd.Items[cbCityNm2.ItemIndex];
  end;

  if TComboBox(Sender).ItemIndex > 0 then
  begin
    ashSql := 'SELECT hr_code_value, hr_code_value_name '
            + 'FROM hr_common_code_value '
            + 'WHERE hr_code_id = "hr_sigungu_code" '
            + 'AND hr_use_yn <> "N"'
            + 'AND hr_code_value LIKE "' + codeValue + '%" '
            + 'ORDER BY hr_code_value_name ASC';

    ashStr := MySQL_Assign(Form1.db_coophr, Form1.qrysql, ashSql, Form1.vtTemp);

    try
      StrToInt(ashStr);
    except
        ShowMessage(ashStr);
    end;

    cb.Clear;
    cb.Items.Add('선택하세요.');

    Form1.vtTemp.First;
    while not Form1.vtTemp.Eof do
    begin
      cb.Items.Add(Form1.vtTemp.Fields[1].AsString);
      Form1.vtTemp.Next;
    end;
    cb.Enabled := True;
    cb.ItemIndex := 0;
  end
  else
  begin
    cb.Enabled := False;
    cb.ItemIndex := 0;
  end;
end;

// 그리드 더블클릭 시 모달리스 창으로 우편번호정보 전달
procedure TfmSearchZip.grdviZip1CellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  with TcxGridDBTableView(Sender).DataController.DataSet do
  begin
    if RecordCount > 0 then
    begin
      {
      [0] 우편번호
      [1] 시군구명(주소1)
      [2] 도로명+건물번호(상세주소)
      }
      arrZipInfo[0] := FieldByName('zip_code').AsString;
      arrZipInfo[1] := FieldByName('addr1').AsString;
      arrZipInfo[2] := FieldByName('addr2').AsString;

      ModalResult := mrOk;
    end;
  end;
end;

procedure TfmSearchZip.PageControl1Change(Sender: TObject);
begin
  // 지번주소
  if PageControl1.ActivePageIndex = 1 then
  begin
    ShowMessage('지번주소는 [2015.08.01]부터 시행된 신우편번호를 조회할 수 없습니다.');
  end;
end;

procedure TfmSearchZip.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssAlt]) or (Shift = [ssCtrl]) then
    Exit;

  case Key of
    VK_RIGHT: // VK_RIGHT 오른쪽커서 이동키
    begin
      SelectNext(ActiveControl, True, True);
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

    VK_ESCAPE: // ESC 키
    begin
      if btnClose.Enabled then
        btnCloseClick(btnClose);
      Key := 0;
    end;
  end;
end;

procedure TfmSearchZip.edtZip1Addr2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btnInquiryClick(btnInquiry);
end;

end.
