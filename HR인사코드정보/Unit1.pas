//******************************************************************************
// 프로그램 : COOP-HR > 기초정보관리 > HR인사코드정보
// 담 당 자 : 윤일근
// 작업일자 :
// 완료일자 :
// 개    요 :
{
  2018-03-06
}
//******************************************************************************


unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Vcl.ComCtrls, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  ZAbstractConnection, ZConnection, MemDS, VirtualTable, Vcl.StdCtrls, URNEdit,
  URCtrls, dxGDIPlusClasses, Vcl.ExtCtrls, Vcl.ToolWin, cxTextEdit, URLabels;

{$I coop_data.inc}

type
  TForm1 = class(TForm)
    GroupBox2: TGroupBox;
    lbl1: TLabel;
    cbCondUseYn: TComboBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    gb_cond: TGroupBox;
    lbl7: TLabel;
    lbl8: TLabel;
    lbl9: TLabel;
    lbl10: TLabel;
    lbl11: TLabel;
    img6: TImage;
    img7: TImage;
    img8: TImage;
    img9: TImage;
    img10: TImage;
    edtNextPoMonth: TwNumEdit;
    edtClsfCd: TEdit;
    edtClsfNm: TEdit;
    edtEngClsfNm: TEdit;
    chkPoUseYn: TCheckBox;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    lbl12: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    img1: TImage;
    img2: TImage;
    img3: TImage;
    img4: TImage;
    img5: TImage;
    edtRspofcCd: TEdit;
    edtRspofcNm: TEdit;
    edtEngRspofcNm: TEdit;
    chkDuUseYN: TCheckBox;
    chkDuAb: TCheckBox;
    vtTemp: TVirtualTable;
    vtSuStaff: TVirtualTable;
    db_coophr: TZConnection;
    qrysql: TZQuery;
    vtPosition: TVirtualTable;
    dsPosition: TDataSource;
    vtDuty: TVirtualTable;
    dsDuty: TDataSource;
    grdClsfDBTableView1: TcxGridDBTableView;
    grdClsfLevel1: TcxGridLevel;
    grdClsf: TcxGrid;
    grdRspofcDBTableView1: TcxGridDBTableView;
    grdRspofcLevel1: TcxGridLevel;
    grdRspofc: TcxGrid;
    ToolBar1: TToolBar;
    btnInquiry: TToolButton;
    btnInsert: TToolButton;
    btnUpdate: TToolButton;
    btnSave: TToolButton;
    btnInit: TToolButton;
    btnDelete: TToolButton;
    btnClose: TToolButton;
    StatusBar1: TStatusBar;
    Label1: TLabel;
    grdRspofcDBTableView1hr_du_code: TcxGridDBColumn;
    grdRspofcDBTableView1hr_du_name: TcxGridDBColumn;
    grdRspofcDBTableView1hr_du_ename: TcxGridDBColumn;
    grdRspofcDBTableView1hr_du_ab: TcxGridDBColumn;
    grdRspofcDBTableView1hr_use_yn: TcxGridDBColumn;
    grdRspofcDBTableView1mpst_code: TcxGridDBColumn;
    grdRspofcDBTableView1p_day: TcxGridDBColumn;
    grdClsfDBTableView1hr_po_code: TcxGridDBColumn;
    grdClsfDBTableView1hr_po_name: TcxGridDBColumn;
    grdClsfDBTableView1hr_po_ename: TcxGridDBColumn;
    grdClsfDBTableView1hr_next_po_month: TcxGridDBColumn;
    grdClsfDBTableView1hr_use_yn: TcxGridDBColumn;
    grdClsfDBTableView1mpst_code: TcxGridDBColumn;
    grdClsfDBTableView1p_day: TcxGridDBColumn;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    cxStyle2: TcxStyle;
    wNumLabel1: TwNumLabel;
    vtPositionhr_po_code: TStringField;
    vtPositionhr_po_name: TStringField;
    vtPositionhr_po_ename: TStringField;
    vtPositionhr_next_po_month: TStringField;
    vtPositionhr_use_yn: TStringField;
    vtPositionmpst_code: TStringField;
    vtPositionp_day: TStringField;
    vtDutyhr_du_code: TStringField;
    vtDutyhr_du_name: TStringField;
    vtDutyhr_du_ename: TStringField;
    vtDutyhr_du_ab: TStringField;
    vtDutyhr_use_yn: TStringField;
    vtDutympst_code: TStringField;
    vtDutyp_day: TStringField;
    Memo1: TMemo;

    procedure btnInsertClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnInitClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnInquiryClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PageControl1Change(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure vtdutyAfterOpen(DataSet: TDataSet);
    procedure vtdutyAfterScroll(DataSet: TDataSet);
    procedure grdClsfDBTableView1CellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure grdRspofcDBTableView1CellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure grdviMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure edtRspofcNmKeyPress(Sender: TObject; var Key: Char);

  private
     ashSql, ashSql_bak, ashStr: String;

    // 화면모드에 따라 컴포넌트 활성화 설정
    procedure setMode(AshModeInt: integer);

    // 화면모드에 따라 입력 컴포넌트 값 설정
    procedure setValue;

    // 입력컴포넌트 값 초기화
    procedure setInit;

  public
    CoopData : PCoopDllData;
    ThisHandleNum: Integer;
    { Public declarations }

  end;

var
  Form1: TForm1;
  modeInt: Integer;     // 화면모드(0:보기, 1:등록, 2:수정, 3:삭제)
  mpst_code, mpst_name, PromptStr : String; // 사용자 사원번호, 사원명,   // 기본
  svrconn, ashReturnRow: Integer;
  insertYn, editYn, printYn, salaryAb: String; // 등록, 수정, 인쇄 권한유무
  isScroll: Boolean;
  rowsave1, rowsave2 : Integer;   // row저장


procedure GetCoopData(var pCoopData: PCoopDllData); stdcall; External 'coop_dll.dll';     // 기본

implementation

uses coophr_utils, coop_sql_updel;

{$R *.dfm}

// FormCreate
procedure TForm1.FormCreate (Sender: TObject);
begin
  GetCoopData(CoopData);

  ThisHandleNum := CoopData^.menuclick;

  if CoopData^.Main_Handle = 0 then
  begin
    ShowMessage('정상적인 과정으로 사용을 하십시요(1)!!!');
    Close;
    Application.Terminate;
    Exit;
  end;

  if CoopData^.menuclick = 0 then
  begin
    ShowMessage('정상적인 과정으로 사용을 하십시요(2)!!!');
    Close;
    Application.Terminate;
    Exit;
  end
  else
    CoopData^.menuclick := 0;

  if CoopData^.SvrConn = 0 then
  begin
    ShowMessage('현재 연결된 서버가 없습니다!!!');
    Close;
    Application.Terminate;
    Exit;
  end;

  case ThisHandleNum of
    1: CoopData^.Handle1:= Application.Handle;
    2: CoopData^.Handle2:= Application.Handle;
    3: CoopData^.Handle3:= Application.Handle;
    else
    begin
      ShowMessage('잠시 후 다시 시도하십시요!!!');
      Close;
      Application.Terminate;
      Exit;
    end;
  end;

  mpst_code:= CoopData^.mpst_code;
  mpst_name:= CoopData^.mpst_name;
  svrconn  := CoopData^.SvrConn;
  PromptStr:= CoopData^.prompt_ab;

  if ((mpst_code = 'H13080585') and (PromptStr = 'Z')) then
  begin
    if MessageDlg('디버깅모드로 실행하시겠습니까?',mtConfirmation,[mbNO,mbOK],0) = mrNO then
      PromptStr := '';
  end;

  case svrconn of
   1:
   begin
     db_coophr.HostName:= CoopData^.DBHost_1st;
     db_coophr.Database:= CoopData^.DBName_1st;
     db_coophr.User    := CoopData^.DBLogin_1st;
     db_coophr.Password:= CoopData^.DBPassword_1st;
   end;
   2:
   begin
     db_coophr.HostName:= CoopData^.DBHost_2nd;
     db_coophr.Database:= CoopData^.DBName_2nd;
     db_coophr.User    := CoopData^.DBLogin_2nd;
     db_coophr.Password:= CoopData^.DBPassword_2nd;
   end;
   3:
   begin
     db_coophr.HostName:= CoopData^.DBHost_3rd;
     db_coophr.Database:= CoopData^.DBName_3rd;
     db_coophr.User:= CoopData^.DBLogin_3rd;
     db_coophr.Password:= CoopData^.DBPassword_3rd;
   end;
  end;

  db_coophr.Protocol := 'mysql-5';

  try
    MySQL_Initiate(db_coophr, qrysql);
  except
    on e: Exception do
    begin
     ShowMessage(e.Message);
    end;
  end;

  // 실행파일의 프로그램 생성(수정)날짜
  Form1.Caption := Form1.caption + ' (' + 'Build: '
          + FormatDateTime('yyyy/mm/dd hh:nn:ss', FileDateToDateTime(FileAge(ExtractFileName(Application.ExeName)))) + ')';


  // 초기화면 위치 설정
  Set_MainPosition(Form1);

  insertYn := 'Y'; editYn := 'Y'; // (윤)등록,수정 활성화 setGroupRightYn 의 기본값이 둘다 'N'이다
                                  // (윤)setGroupRightYn : 사용자 프로그램의 법인별 사업장별 부서별 등록, 수정, 출력 권한
  setMode(0);
end;


// 입력컴포넌트 값 초기화
procedure TForm1.setInit;
begin
  // 직급
  if PageControl1.ActivePageIndex = 0 then
  begin
    edtClsfCd.Text    := '';
    edtClsfNm.Text    := '';
    edtEngClsfNm.Text := '';
    edtNextPoMonth.Value := 0;
    chkPoUseYn.Checked := True;
  end

  // 직책
  else if PageControl1.ActivePageIndex = 1 then
  begin
    edtRspofcCd.Text    := '';
    edtRspofcNm.Text    := '';
    edtEngRspofcNm.Text := '';
    chkDuAb.Checked     := False;
    chkDuUseYN.Checked  := True;
  end;
end;

// 화면모드에 따라 컴포넌트 활성화 설정
procedure TForm1.setMode(AshModeInt: integer);
begin
  modeInt := AshModeInt;

  // 입력 컴포넌트 활성화 설정
  cbCondUseYn.ItemIndex := 0;                   //(윤) 콤보박스 (0 : 전체)

  // 직급
  if PageControl1.ActivePageIndex = 0 then
  begin
    setObjEnable(edtClsfCd, AshModeInt, 2);
    setObjEnable(edtClsfNm, AshModeInt, 1);
    setObjEnable(edtEngClsfNm, AshModeInt, 0);
    setObjEnable(edtNextPoMonth, AshModeInt, 0);
    setObjEnable(chkPoUseYn, AshModeInt, 0);

    if AshModeInt = 1 then
      edtClsfCd.SetFocus
    else if AshModeInt = 2 then
      edtClsfNm.SetFocus;
  end

  // 직책
  else if PageControl1.ActivePageIndex = 1 then
  begin
    setObjEnable(edtRspofcCd, AshModeInt, 2);
    setObjEnable(edtRspofcNm, AshModeInt, 1);
    setObjEnable(edtEngRspofcNm, AshModeInt, 0);
    setObjEnable(chkDuAb, AshModeInt, 0);
    setObjEnable(chkDuUseYN, AshModeInt, 0);

    if AshModeInt = 1 then
      edtRspofcCd.SetFocus
    else if AshModeInt = 2 then
      edtRspofcNm.SetFocus;
  end;

  case AshModeInt of
    0: // 보기
    begin
      // 버튼활성화 설정
      if insertYn = 'Y' then
      begin
        btnInsert.Enabled  := True;
        btnUpdate.Enabled  := True;
      end
      else
      begin
        if editYn = 'Y' then
          btnUpdate.Enabled  := True
        else
          btnUpdate.Enabled  := False;

        btnInsert.Enabled  := False;
      end;

      btnDelete.Enabled  := true;
      btnSave.Enabled    := false;
      btnInit.Enabled    := false;
    end;

    1, 2, 3: // 등록, 수정, 삭제
    begin
      // 버튼활성화 설정
      btnInsert.Enabled  := false;
      btnUpdate.Enabled  := false;
      btnDelete.Enabled  := false;
      btnSave.Enabled    := true;
      btnInit.Enabled    := true;
    end;
  end;

  setValue;
end;

// 화면모드에 따라 입력 컴포넌트 값 설정
procedure TForm1.setValue;
begin
  // 입력컴포넌트 값 초기화
  setInit;

  // 등록모드(1)가 아닐 때 입력 컴포넌트에 값 매칭
  if modeInt <> 1 then
  begin
    // 직급
    if PageControl1.ActivePageIndex = 0 then
    begin
      if vtPosition.RecordCount = 0 then exit;
                                                                          // (윤)vtposition테이블에서 hr_po_code필드의 값을 받아오겠다
      edtClsfCd.Text    := vtPosition.FieldByName('hr_po_code').AsString; // (윤) fieldbyname : 오픈 된 필드의 값에 접근할 때
      edtClsfNm.Text    := vtPosition.FieldByName('hr_po_name').AsString;
      edtEngClsfNm.Text := vtPosition.FieldByName('hr_po_ename').AsString;
      edtNextPoMonth.Value := vtPosition.FieldByName('hr_next_po_month').AsFloat;
      chkPoUseYn.Checked := getBool(vtPosition.FieldByName('hr_use_yn').AsString);
    end
    // 직책
    else if PageControl1.ActivePageIndex = 1 then
    begin
      if vtDuty.RecordCount = 0 then exit;

      edtRspofcCd.Text    := vtDuty.FieldByName('hr_du_code').AsString;
      edtRspofcNm.Text    := vtDuty.FieldByName('hr_du_name').AsString;
      edtEngRspofcNm.Text := vtDuty.FieldByName('hr_du_ename').AsString;
      chkDuUseYN.Checked  := getBool(vtDuty.FieldByName('hr_use_yn').AsString);

      if vtDuty.FieldByName('hr_du_ab').AsString = '임원' then
        chkDuAb.Checked := True
      else
        chkDuAb.Checked := False;
    end;
  end;
end;


// 조회
procedure TForm1.btnInquiryClick(Sender: TObject);
var
  subSql: string;
begin
  subSql := '';
  if cbCondUseYn.ItemIndex = 1 then // 사용함
    subSql := ' WHERE hr_use_yn = "Y"'
  else if cbCondUseYn.ItemIndex = 2 then // 사용안함
    subSql := ' WHERE hr_use_yn = "N"';

  // 직급조회
  if PageControl1.ActivePageIndex = 0 then
  begin
    ashSql := 'SELECT'
            + '  hr_po_code'
            + ', hr_po_name'
            + ', hr_po_ename'
            + ', hr_next_po_month'
            + ', hr_use_yn'
            + ', (SELECT hr_m_name FROM hr_members WHERE hr_m_code = hr_position.mpst_code) mpst_code'
            + ', p_day'
            + ' FROM hr_position'
            + subSql;

    ashStr := MySQL_Assign(db_coophr, qrysql, ashSql, vtPosition); // (윤)mysql(db명,query,쿼리문변수,(가상)테이블)
    try
      StrToInt(ashStr);
    except
      ShowMessage('오류가 발생하였습니다.[' + ashStr + '](ERR:450)');
      Exit;
    end;
  end

  // 직책조회
  else if PageControl1.ActivePageIndex = 1 then
  begin
    ashSql := 'SELECT'
            + '  hr_du_code'
            + ', hr_du_name'
            + ', hr_du_ename'
            + ', IF(hr_du_ab = "B", "임원", "") hr_du_ab'
            + ', hr_use_yn'
            + ', (SELECT hr_m_name FROM hr_members WHERE hr_m_code = hr_duty.mpst_code) mpst_code'
            + ', p_day'
            + ' FROM hr_duty'
            + subSql;

    ashStr := MySQL_Assign(db_coophr, qrysql, ashSql, vtDuty);
    try
      StrToInt(ashStr);
    except
      ShowMessage('오류가 발생하였습니다.[' + ashStr + '](ERR:473)');
      Exit;
    end;
  end;

  isScroll := True;
end;

// 직급그리드 행 클릭 시
procedure TForm1.grdClsfDBTableView1CellClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  setMode(0);
end;

// 직책그리드 행 클릭 시
procedure TForm1.grdRspofcDBTableView1CellClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  setMode(0);  // 버튼활성화설정
end;

// 등록버튼 클릭 시 입력모드
procedure TForm1.btnInsertClick(Sender: TObject);
begin
  setMode(1);
end;

// 수정버튼 클릭 시 수정모드
procedure TForm1.btnUpdateClick(Sender: TObject);
begin
  rowsave1 := vtPosition.RecNo;     // 몇 번째 row인지 ( vtposition )
  rowsave2 := vtDuty.RecNo;         // 몇 번째 row인지 ( vtduty )


  // 직급
  if PageControl1.ActivePageIndex = 0 then
  begin
    if vtPosition.RecordCount < 1 then
    begin
      ShowMessage('조회 후 사용하세요.');
      Exit;
    end;
  end
  else // 직책
  begin
    if vtDuty.RecordCount < 1 then
    begin
      ShowMessage('조회 후 사용하세요.');
      Exit;
    end;
  end;

  setMode(2);
end;

// 공백문제해결을 위해서 추가 (2018.04.26)
procedure TForm1.edtRspofcNmKeyPress(Sender: TObject; var Key: Char);
var
  i : Integer;
  ilen : integer;
  emptemp : string;
  result : string;
begin

  emptemp := edtRspofcNm.Text;   // 입력받은 직급명
  ilen := Length(emptemp);       // 입력받은 직급명 길이

  for i := 0 to ilen do
  begin
    result := Copy(emptemp,i,1);

    if result = ' ' then
    begin
      ShowMessage('공백을 입력하셨습니다. 다시 입력해주세요');
      edtRspofcNm.clear;
      Exit;
    end;
  end;
end;

// 저장
procedure TForm1.btnSaveClick(Sender: TObject);
var
  poCd, duCd, duAb: String;
  positiontmp, dutytmp : string;        // row focus를 위한 변수

begin

  positiontmp := Trim(edtClsfCd.text);
  dutytmp := Trim(edtRspofcCd.text);


  if PageControl1.ActivePageIndex = 0 then
  begin
    if not chkExtVal(edtClsfCd, '직급코드')
    then Exit;
    if not chkExtVal(edtClsfNm, '직급명')
    then Exit;

    // 등록
    if modeInt = 1 then
    begin
      poCd := UpperCase(Trim(edtClsfCd.Text));

      // 직급코드 중복 확인
      ashSql := 'SELECT COUNT(*) cnt FROM hr_position ' + 'WHERE hr_po_code ="' + poCd + '"';

      ashStr := MySQL_Assign(db_coophr, qrysql, ashSql, vtTemp);  // vtCode등 테이블명 변경하니까 오류 (윤)
      try
        StrToInt(ashStr);
      except
        ShowMessage('오류가 발생하였습니다.[' + ashStr + '](ERR:568)');    // (윤)직급명 오류날 때
        Exit;
      end;

      if vtTemp.FieldByName('cnt').AsInteger > 0 then
      begin
        ShowMessage('직급코드가 중복됩니다.');                             // (윤)직급명 중복
        edtClsfCd.SetFocus;
        Exit;
      end;

      ashSql_bak := 'INSERT INTO hr_position ('
              + 'hr_po_code'
              + ', hr_po_name'
              + ', hr_po_ename'
              + ', hr_next_po_month'
              + ', hr_use_yn'
              + ', hr_mpst_code'
              + ', hr_p_day'
              + ', mpst_code'
              + ', p_day'
              + ', chk_svr'
              + ') VALUES ("'
              + poCd + '", "'
              + Trim(edtClsfNm.Text) + '", "'
              + Trim(edtEngClsfNm.Text) + '", '
              + FloatToStr(edtNextPoMonth.Value) + ', "'
              + getYn(chkPoUseYn.Checked) + '", "'
              + mpst_code
              + '", NOW(), "'  // (윤)현재시간출력
              + mpst_code
              + '", NOW(), "'
              + IntToStr(svrconn) + '")';

      ashSql := 'INSERT INTO hr_position ('
              + 'hr_po_code'
              + ', hr_po_name'
              + ', hr_po_ename'
              + ', hr_next_po_month'
              + ', hr_use_yn'
              + ', hr_mpst_code'
              + ', hr_p_day'
              + ', mpst_code'
              + ', p_day'
              + ', history'
              + ', chk_svr'
              + ') VALUES ("'
              + poCd + '", "'
              + Trim(edtClsfNm.Text) + '", "'
              + Trim(edtEngClsfNm.Text) + '", '
              + FloatToStr(edtNextPoMonth.Value) + ', "'
              + getYn(chkPoUseYn.Checked) + '", "'
              + mpst_code
              + '", NOW(), "'
              + mpst_code
              + '", NOW(), "'
              + SQLToHistory(ashSql_bak) + '", "' // history    // (윤)SQLToHistory : 이력 쿼리의  NOW() 함수 시간으로 변환
              + IntToStr(svrconn) + '")';
    Memo1.Lines.Add(ashSql);
    end

    // 수정
    else if modeInt = 2 then
    begin
      poCd := vtPosition.FieldByName('hr_po_code').AsString;

      ashSql_bak := 'UPDATE hr_position SET '
              + 'hr_po_name = "'        + Trim(edtClsfNm.Text)
              + '", hr_po_ename = "'    + Trim(edtEngClsfNm.Text)
              + '", hr_next_po_month = '+ FloatToStr(edtNextPoMonth.Value)
              + ', hr_use_yn = "'       + getYn(chkPoUseYn.Checked)
              + '", mpst_code = "'      + mpst_code
              + '", p_day = NOW()'
              + ', chk_svr = "'         + IntToStr(svrconn) + '" '
              + ' WHERE '
              + 'hr_po_code = "'        + poCd + '"';

      ashSql := 'UPDATE hr_position SET '
              + 'hr_po_name = "'        + Trim(edtClsfNm.Text)
              + '", hr_po_ename = "'    + Trim(edtEngClsfNm.Text)
              + '", hr_next_po_month = '+ FloatToStr(edtNextPoMonth.Value)
              + ', hr_use_yn = "'       + getYn(chkPoUseYn.Checked)
              + '", mpst_code = "'      + mpst_code
              + '", p_day = NOW()'
              + ', history = concat(history, "' + SQLToHistory(ashSql_bak) + '") '
              + ', chk_svr = "'         + IntToStr(svrconn) + '" '
              + ' WHERE '
              + 'hr_po_code = "'        + poCd + '"';
    Memo1.Lines.Add(ashSql);
    end

    // 삭제
    else if modeInt = 3 then
    begin

      poCd := vtPosition.FieldByName('hr_po_code').AsString;

      ashSql_bak := 'UPDATE hr_position SET '
              + 'hr_use_yn = "N", '
              + 'mpst_code = "' + mpst_code
              + '", p_day = NOW()'
              + ', chk_svr = "' + IntToStr(svrconn) + '" '
              + ' WHERE '
              + 'hr_po_code = "' + poCd + '"';

      ashSql := 'UPDATE hr_position SET '
              + 'hr_use_yn = "N", '
              + 'mpst_code = "' + mpst_code
              + '", p_day = NOW()'
              + ', history = concat(history, "' + SQLToHistory(ashSql_bak) + '") '
              + ', chk_svr = "' + IntToStr(svrconn) + '" '
              + ' WHERE '
              + 'hr_po_code = "' + poCd + '"';
    Memo1.Lines.Add(ashSql);
    end;


    try
      ashReturnRow := StrToInt(MySQL_UpDel(db_coophr, qrysql, ashSql));
    except
    on e: Exception do
      begin
        if ashReturnRow <> 1 then
        begin
          ShowMessage('입력(수정) 실패하였습니다.[hr_position]');
	        ShowMessage(e.Message);
          Exit;
        end;
      end;
    end;


    setMode(0); // 다시 (보기)화면(윤)
    btnInquiryClick(btnInquiry);  // 재조회
    vtPosition.RecNo := rowsave1; // (윤)
    vtPosition.Locate('hr_po_code',positiontmp,[]);  //(윤)

  end

  // 직책
  else if PageControl1.ActivePageIndex = 1 then
  begin
    if not chkExtVal(edtRspofcCd, '직책코드')
    then Exit;
    if not chkExtVal(edtRspofcNm, '직책명')
    then Exit;

    if chkDuAb.Checked then duAb := 'B' else duAb := 'A';

    // 등록
    if modeInt = 1 then
    begin
      duCd := UpperCase(Trim(edtRspofcCd.Text));

      // 직책코드 중복 확인
      ashSql := 'SELECT COUNT(*) cnt FROM hr_duty '
              + 'WHERE hr_du_code = "' + duCd + '"';

      ashStr := MySQL_Assign(db_coophr, qrysql, ashSql, vtTemp);
      try
        StrToInt(ashStr);
      except
        ShowMessage('오류가 발생하였습니다.[' + ashStr + '](ERR:719)');
        Exit;
      end;

      if vtTemp.FieldByName('cnt').AsInteger > 0 then
      begin
        ShowMessage('직책코드가 중복됩니다.');
        edtRspofcCd.SetFocus;
        Exit;
      end;

      ashSql_bak := 'INSERT INTO hr_duty ('
              + 'hr_du_code'
              + ', hr_du_name'
              + ', hr_du_ename'
              + ', hr_du_ab'
              + ', hr_use_yn'
              + ', hr_mpst_code'
              + ', hr_p_day'
              + ', mpst_code'
              + ', p_day'
              + ', chk_svr'
              + ') VALUES ("'
              + duCd                      + '", "'
              + Trim(edtRspofcNm.Text)    + '", "'
              + Trim(edtEngRspofcNm.Text) + '", "'
              + duAb                      + '", "'
              + getYn(chkDuUseYN.Checked) + '", "'
              + mpst_code
              + '", NOW(), "'
              + mpst_code
              + '", NOW(), "'
              + IntToStr(svrconn) + '")';

      ashSql := 'INSERT INTO hr_duty ('
              + 'hr_du_code'
              + ', hr_du_name'
              + ', hr_du_ename'
              + ', hr_du_ab'
              + ', hr_use_yn'
              + ', hr_mpst_code'
              + ', hr_p_day'
              + ', mpst_code'
              + ', p_day'
              + ', history'
              + ', chk_svr'
              + ') VALUES ("'
              + duCd                      + '", "'
              + Trim(edtRspofcNm.Text)    + '", "'
              + Trim(edtEngRspofcNm.Text) + '", "'
              + duAb                      + '", "'
              + getYn(chkDuUseYN.Checked) + '", "'
              + mpst_code
              + '", NOW(), "'
              + mpst_code
              + '", NOW(), "'
              + SQLToHistory(ashSql_bak) + '", "' // history
              + IntToStr(svrconn) + '")';
    Memo1.Lines.Add(ashSql);
    end

    // 수정
    else if modeInt = 2 then
    begin
      duCd := vtDuty.FieldByName('hr_du_code').AsString;

      ashSql_bak := 'UPDATE hr_duty SET '
              + 'hr_du_name = "'      + Trim(edtRspofcNm.Text)
              + '", hr_du_ename = "'  + Trim(edtEngRspofcNm.Text)
              + '", hr_du_ab = "'     + duAb
              + '", hr_use_yn = "'    + getYn(chkDuUseYN.Checked)
              + '", mpst_code = "'    + mpst_code
              + '", p_day = NOW()'
              + ', chk_svr = "'       + IntToStr(svrconn) + '" '
              + ' WHERE '
              + 'hr_du_code = "'      + duCd + '"';

      ashSql := 'UPDATE hr_duty SET '
              + 'hr_du_name = "'      + Trim(edtRspofcNm.Text)
              + '", hr_du_ename = "'  + Trim(edtEngRspofcNm.Text)
              + '", hr_du_ab = "'     + duAb
              + '", hr_use_yn = "'    + getYn(chkDuUseYN.Checked)
              + '", mpst_code = "'    + mpst_code
              + '", p_day = NOW()'
              + ', history = concat(history, "' + SQLToHistory(ashSql_bak) + '") '
              + ', chk_svr = "'       + IntToStr(svrconn) + '" '
              + ' WHERE '
              + 'hr_du_code = "'      + duCd + '"';
    Memo1.Lines.Add(ashSql);
    end

    // 삭제

    else if modeInt = 3 then
    begin
      duCd := vtDuty.FieldByName('hr_du_code').AsString;

      ashSql_bak := 'UPDATE hr_duty SET '
              + 'hr_use_yn = "N", '
              + 'mpst_code = "'  + mpst_code
              + '", p_day = NOW()'
              + ', chk_svr = "'     + IntToStr(svrconn) + '" '
              + ' WHERE '
              + 'hr_du_code = "'    + duCd + '"';

      ashSql := 'UPDATE hr_duty SET '
              + 'hr_use_yn = "N", '
              + 'mpst_code = "'  + mpst_code
              + '", p_day = NOW()'
              + ', history = concat(history, "' + SQLToHistory(ashSql_bak) + '") '
              + ', chk_svr = "'     + IntToStr(svrconn) + '" '
              + ' WHERE '
              + 'hr_du_code = "'    + duCd + '"';
    Memo1.Lines.Add(ashSql);
    end;


    try
      ashReturnRow := StrToInt(MySQL_UpDel(db_coophr, qrysql, ashSql));
    except
    on e: Exception do
      begin
        if ashReturnRow <> 1 then
        begin
          ShowMessage('입력(수정) 실패하였습니다.[hr_duty]');
	        ShowMessage(e.Message);
          Exit;
        end;
      end;
    end;

    // 재조회

    setMode(0);
    btnInquiryClick(btnInquiry);
    vtduty.RecNo := rowsave2; // (윤)
    vtduty.Locate('hr_du_code',dutytmp,[]); // (윤)
  end;
end;

// 취소(초기화)
procedure TForm1.btnInitClick(Sender: TObject);
begin
  setMode(0);
end;

// 삭제모드
procedure TForm1.btnDeleteClick(Sender: TObject);
var
  n: Integer;
begin
  rowsave1 := vtPosition.RecNo;     // 몇 번째 row인지 ( vtposition )
  rowsave2 := vtDuty.RecNo;         // 몇 번째 row인지 ( vtduty )

  if MessageDlg('삭제하시겠습니까?',mtConfirmation,[mbNO,mbOK],0) = mrNO then
  begin
    ShowMessage('삭제를 취소하셨습니다.');
    exit;
  end
  else
  begin
    setMode(3);
    btnSaveClick(btnsave);
  end;
end;


// 활성탭 변경 시 ((윤)직급,직책)
procedure TForm1.PageControl1Change(Sender: TObject);
begin
  btnInquiryClick(btnInquiry);
  setMode(0);
end;

// 폼에서 키 다운 이벤트 발생 시
procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssAlt]) or (Shift = [ssCtrl]) then
   Exit;

  case Key of
    // 탭오더 오른쪽방향키로 이동
    VK_RIGHT: //(윤) 화살표오른쪽방향
    begin
        SelectNext(ActiveControl, True, True);
        key := 0;
    end;

    // 탭오더 엔터키로 이동
    VK_RETURN: // (윤)엔터키
    begin
        SelectNext(ActiveControl, True, True);
        key := 0;
    end;

    // 도움말
    VK_F1:
    begin
        ShowMessage('도움말 준비중입니다.');
        key := 0;
    end;

    // 등록모드
    VK_F2:
    begin
      if btnInsert.Enabled then
        btnInsertClick(btnInsert);
      key := 0;
    end;

    // 수정모드
    VK_F3:
     begin
      if btnUpdate.Enabled then
        btnUpdateClick(btnUpdate);
      key := 0;
     end;

    // 저장
    VK_F4:
    begin
      if btnSave.Enabled then
        btnSaveClick(btnSave);
      key := 0;
    end;

    // 취소
    VK_F5:
    begin
      if btnInit.Enabled then
        btnInitClick(btnInit);
      key := 0;
    end;

    // 삭제모드
    VK_F6:
    begin
      if btnDelete.Enabled then
        btnDeleteClick(btnDelete);
      key := 0;
    end;

    // 조회
    VK_F9:
    begin
      if btnInquiry.Enabled then
        btnInquiryClick(btnInquiry);
      key := 0;
    end;

    // 종료
    VK_ESCAPE:
    begin
      if btnClose.enabled then
        btnCloseClick(btnClose);
      key := 0;
    end;
  end;
end;

// (윤)마우스 휠 이동 시 row값 edit에 적용
procedure TForm1.grdviMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  Handled := True;
  with TcxGridTableView(TcxGridSite(Sender).GridView) do
  begin
    if WheelDelta < 0 then
    begin
      Controller.FocusedRow.Selected := False;
      DataController.GotoNext;
      DataController.MakeRecordVisible(DataController.FocusedRecordIndex);
      Controller.FocusedRow.Selected := True;
    end
    else
    begin
      Controller.FocusedRow.Selected := False;
      DataController.GotoPrev;
      DataController.MakeRecordVisible(DataController.FocusedRecordIndex);
      Controller.FocusedRow.Selected := True;
    end;
  end;
end;

// 종료
procedure TForm1.btnCloseClick(Sender: TObject);
begin
  Close;
end;

// FormClose
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  qrySql.Close;
  vtPosition.Close;
  vtDuty.Close;
  db_coophr.Disconnect;
  Action := caFree;       // caFree = System.UITypes.TCloseAction.caFree;

  case ThisHandleNum of
    1:
      begin
        CoopData^.Handle1 := 0;
        CoopData^.Program1 := '';
      end;
    2:
      begin
        CoopData^.Handle2 := 0;
        CoopData^.Program2 := '';
      end;
    3:
      begin
        CoopData^.Handle3 := 0;
        CoopData^.Program3 := '';
      end;
  end;
  CoopData^.ProgramCount := CoopData^.ProgramCount - 1;
end;

procedure TForm1.vtdutyAfterOpen(DataSet: TDataSet); //(윤) AfterOpen : 테이블을 엽니다.( Query나 Table이 오픈된 후에 )
begin                                                //(윤) 조회 후 조회된 row(행)을 누른상태에서 다시 조회를 누르면, row(행) 누른상태 해제
  isScroll := False;
end;

procedure TForm1.vtdutyAfterScroll(DataSet: TDataSet); // 스크롤이 움직힌 후에 실행
begin
  if (Not DataSet.Active) or (DataSet.RecordCount = 0) then Exit;
  if isScroll = false then Exit;

  setValue; // edit창에 값 출력
end;

end.
