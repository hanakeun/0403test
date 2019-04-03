unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ToolWin, Vcl.StdCtrls,
  dxGDIPlusClasses, Vcl.ExtCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, ZAbstractConnection, ZConnection, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, MemDS, VirtualTable, cxTextEdit, Vcl.Grids,
  Vcl.DBGrids, Excels, Comobj, cxGridExportLink;
  {$I coop_data.inc}                                                 // ShellApi,OleCtrls
type
  TForm1 = class(TForm)
    MainGrpBox: TGroupBox;
    grplabel: TLabel;
    Image1: TImage;
    StatusBar1: TStatusBar;
    edtMain: TEdit;
    grpcode: TGroupBox;
    grpcodevalue: TGroupBox;
    imgcode1: TImage;
    imgcode2: TImage;
    imgcode3: TImage;
    imgcode4: TImage;
    imgcode5: TImage;
    imgcode6: TImage;
    grpcode1: TLabel;
    grpcode2: TLabel;
    grpcode3: TLabel;
    grpcode4: TLabel;
    grpcode5: TLabel;
    grpcode6: TLabel;
    cbxCodeAb: TComboBox;
    edtCodeid: TEdit;
    edtCodename: TEdit;
    edtCodelength: TEdit;
    chkCode: TCheckBox;
    btn1insert: TButton;
    btn1update: TButton;
    btn1save: TButton;
    btn1init: TButton;
    btn1delete: TButton;
    memoGrpCode: TMemo;
    imgvalue1: TImage;
    imgvalue4: TImage;
    imgvalue2: TImage;
    imgvalue5: TImage;
    imgvalue3: TImage;
    grpvalue1: TLabel;
    grpvalue2: TLabel;
    grpvalue3: TLabel;
    grpvalue4: TLabel;
    grpvalue5: TLabel;
    edtValue: TEdit;
    edtValuename: TEdit;
    edtValueArray: TEdit;
    chkValue: TCheckBox;
    memoGrpValue: TMemo;
    btn2insert: TButton;
    btn2update: TButton;
    btn2save: TButton;
    btn2init: TButton;
    btn2delete: TButton;
    cxCodeView: TcxGridDBTableView;
    cxCodeLevel1: TcxGridLevel;
    cxCode: TcxGrid;
    cxCodeValueView: TcxGridDBTableView;
    cxCodeValueLevel1: TcxGridLevel;
    cxCodeValue: TcxGrid;
    db_coophr: TZConnection;
    qrysql: TZQuery;
    vtTemp: TVirtualTable;
    vtSuStaff: TVirtualTable;
    Memo1: TMemo;
    vtCode: TVirtualTable;
    vtCodeValue: TVirtualTable;
    dsCode: TDataSource;
    dsCodevalue: TDataSource;
    grpcode7: TLabel;
    chkadmin: TCheckBox;
    Label2: TLabel;
    Label1: TLabel;
    Image2: TImage;
    Image3: TImage;
    cxStyleRepository1: TcxStyleRepository;
    cxHeader: TcxStyle;
    cxContent: TcxStyle;
    cxCodeValueViewhr_code_value: TcxGridDBColumn;
    cxCodeValueViewhr_code_value_name: TcxGridDBColumn;
    cxCodeValueViewhr_sort_seq: TcxGridDBColumn;
    cxCodeValueViewhr_use_yn: TcxGridDBColumn;
    cxCodeValueViewhr_memo: TcxGridDBColumn;
    cxCodeValueViewmpst_code: TcxGridDBColumn;
    cxCodeValueViewp_day: TcxGridDBColumn;
    cxCodeViewhr_code_id: TcxGridDBColumn;
    cxCodeViewhr_code_id_name: TcxGridDBColumn;
    cxCodeViewhr_code_value_ab: TcxGridDBColumn;
    cxCodeViewhr_code_value_length: TcxGridDBColumn;
    cxCodeViewhr_admin_yn: TcxGridDBColumn;
    cxCodeViewhr_use_yn: TcxGridDBColumn;
    cxCodeViewhr_memo: TcxGridDBColumn;
    cxCodeViewhr_mpst_code: TcxGridDBColumn;
    ToolBar1: TToolBar;
    btnInquiry: TToolButton;
    btnClose: TToolButton;
    cxCodeViewcode_no: TcxGridDBColumn;
    dsTemp: TDataSource;
    dsSuStaff: TDataSource;
    cxCodeValueViewhr_code_id: TcxGridDBColumn;
    Memo2: TMemo;
    btnExcelForm: TButton;
    btnExcelUpload: TButton;
    btnExcelCode: TButton;
    btnExcelPrint: TButton;
    vtCodecode_no: TIntegerField;
    vtCodehr_code_id: TStringField;
    vtCodehr_code_id_name: TStringField;
    vtCodehr_code_value_length: TIntegerField;
    vtCodehr_code_value_ab: TStringField;
    vtCodehr_admin_yn: TStringField;
    vtCodehr_use_yn: TStringField;
    vtCodehr_memo: TStringField;
    vtCodehr_mpst_code: TStringField;
    vtCodeValuevalue_no: TIntegerField;
    vtCodeValuehr_code_id: TStringField;
    vtCodeValuehr_code_value: TStringField;
    vtCodeValuehr_code_value_name: TStringField;
    vtCodeValuehr_sort_seq: TIntegerField;
    vtCodeValuehr_use_yn: TStringField;
    vtCodeValuehr_memo: TStringField;
    vtCodeValuempst_code: TStringField;
    vtCodeValuep_day: TDateTimeField;
    splitter: TSplitter;
    BigPanel1: TPanel;
    BigPanel2: TPanel;
    SmallPanel1: TPanel;
    SmallPanel2: TPanel;
    vtCodep_day: TDateTimeField;
    cxCodeViewp_day: TcxGridDBColumn;
    vtCodeValuempst_code2: TStringField;
    vtCodempst_code: TStringField;
    cxCodeValueViewvalue_no: TcxGridDBColumn;
    Excel1: TExcel;
    OpenDialog1: TOpenDialog;
    codeCenterPanel: TPanel;
    valueCenterPanel: TPanel;
    btn1: TButton;
    procedure grdviMouseWheel(Sender: TObject; Shift: TShiftState;
          WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxCodeViewcode_noGetDisplayText(
      Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
      var AText: string);
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnInquiryClick(Sender: TObject);
    procedure cxCodeViewCellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure cxCodeValueViewCellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure btn1insertClick(Sender: TObject);
    procedure vtCodeAfterOpen(DataSet: TDataSet);
    procedure vtCodeAfterScroll(DataSet: TDataSet);
    procedure vtCodeValueAfterScroll(DataSet: TDataSet);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btn1updateClick(Sender: TObject);
    procedure btn1saveClick(Sender: TObject);
    procedure btn1initClick(Sender: TObject);
    procedure btn1deleteClick(Sender: TObject);
    procedure btn2insertClick(Sender: TObject);
    procedure btn2updateClick(Sender: TObject);
    procedure btn2saveClick(Sender: TObject);
    procedure btn2initClick(Sender: TObject);
    procedure btn2deleteClick(Sender: TObject);
    procedure ToolBar1DblClick(Sender: TObject);
    procedure edtMainKeyPress(Sender: TObject; var Key: Char);
    procedure edtValueKeyPress(Sender: TObject; var Key: Char);
    procedure btnExcelPrintClick(Sender: TObject);
    procedure btnExcelFormClick(Sender: TObject);
    procedure btnExcelUploadClick(Sender: TObject);
    procedure btnExcelCodeClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure edtValueKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);


  private
    ashSql, ashSql_bak, ashStr: String;

    // 최소, 최대크기 제한
    minSize, maxSize: TPoint;

    procedure WMGetMinMAXInfo(var msg: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
    { Private declarations }

    // 화면모드에 따라 컴포넌트 활성화 설정
    procedure setMode(AshModeInt: integer);               // hr_common_code 공통코드
    procedure setModeValue(AshModeInt: Integer);          // hr_common_code_value 공통코드값

    // 화면모드에 따라 입력 컴포넌트 값 설정
    procedure setValue;
    procedure setCodeValue;

    // 입력컴포넌트 값 초기화
    procedure setInit;
    procedure setValueInit;

    procedure cellClick;

  public
    CoopData : PCoopDllData;
    ThisHandleNum: Integer;
    { Public declarations }
  end;

var
  Form1: TForm1;
  mpst_code, mpst_name, PromptStr: String;          // 사용자 사원번호, 사원명,   // 기본
  insertYn, editYn, printYn, salaryAb: string;      // setmode
  svrconn, ashReturnRow: Integer;                   // formcreate
  modeInt, modeIntvalue: Integer;                   // 화면모드(0:보기, 1:등록, 2:수정, 3:삭제)
  isScroll: Boolean;                                // AfterScroll을 위해서
  rowSave1, rowSave2, rowSave3 : integer;           // row저장
  adminYn : Boolean;                                // 관리자권한
  updateCheck, insertCheck, deleteCheck : boolean;  // 수정,등록,삭제 버튼 (recno/locate사용)

  procedure GetCoopData(var pCoopData: PCoopDllData); stdcall; External 'coop_dll.dll';   // 기본

implementation

uses coophr_utils, coop_sql_updel;

{$R *.dfm}

// 폼 크기
procedure TForm1.WMGetMinMAXInfo(var msg: TWMGetMinMaxInfo);
begin
  if Visible then
  begin
    msg.MinMaxInfo^.ptMinTrackSize := minSize;
    msg.MinMaxInfo^.ptMaxTrackSize := maxSize;
  end;
end;

// FormCreate
procedure TForm1.FormCreate(Sender: TObject);
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
    if MessageDlg('OK=공통코드, NO=공통코드값',mtConfirmation,[mbNO,mbOK],0) <> mrOK then
      PromptStr := '';
  end;

  case svrconn of
    1:
      begin
        db_coophr.HostName := CoopData^.DBHost_1st;
        db_coophr.Database := CoopData^.DBName_1st;
        db_coophr.User := CoopData^.DBLogin_1st;
        db_coophr.Password := CoopData^.DBPassword_1st;
      end;
    2:
      begin
        db_coophr.HostName := CoopData^.DBHost_2nd;
        db_coophr.Database := CoopData^.DBName_2nd;
        db_coophr.User := CoopData^.DBLogin_2nd;
        db_coophr.Password := CoopData^.DBPassword_2nd;
      end;
    3:
      begin
        db_coophr.HostName := CoopData^.DBHost_3rd;
        db_coophr.Database := CoopData^.DBName_3rd;
        db_coophr.User := CoopData^.DBLogin_3rd;
        db_coophr.Password := CoopData^.DBPassword_3rd;
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


  {20181026yik 슬기선배님 요청으로 사이즈 제한 x
  // 폼 최소크기 제한 1280 * 745
  minSize.X := 1280;
  minSize.Y := 745;

  // 폼 최대크기 제한
  maxSize.X := GetSystemMetrics(SM_CXSCREEN); // 모니터해상도
  maxSize.Y := GetSystemMetrics(SM_CYSCREEN);
  }

  // 실행파일의 프로그램 생성(수정)날짜
  Form1.Caption := Form1.caption + ' (' + 'Build: '
          + FormatDateTime('yyyy/mm/dd hh:nn:ss', FileDateToDateTime(FileAge(ExtractFileName(Application.ExeName)))) + ')';

  // 법인별 사업장별 등록, 수정, 출력 권한 (insertYn := 'Y' / editYn := 'Y' ) 바꿔줌
  setGroupRightYn;

  // 초기화면 위치 설정
  Set_MainPosition(Form1);

  if (mpst_code = '0579033000') or (mpst_code = '2016060060') or (mpst_code = '2018010038') then
  begin
    adminYn := true; // 관리자권한 기본값 ( 컴포넌트 visible 설정 )
  end;

  setMode(0);          // 프로그램시작하자마자 0모드로
  setModeValue(0);     // edit창 활성화 연관있음.

end;

// 프로그램시작시 [메인edit창]에 setFocus
procedure TForm1.FormShow(Sender: TObject);
begin
  edtMain.SetFocus;
  //setmode에서 [ edtMain.SetFocus; ] 이거때문에 오류생김 (Cannot focus a dosabled or invisible window.)
end;

// 입력컴포넌트 값 초기화 ( hr_common_code )
procedure TForm1.setInit;
begin
  edtCodeid.Text          :=  '';        // 코드ID 초기화
  edtCodename.Text        :=  '';        // 코드명 초기화
  cbxCodeAb.ItemIndex     :=  0;         // 코드값형식 초기화
  edtCodelength.Text      :=  '';        // 코드값길이 초기화
  chkcode.Checked         :=  True;      // 사용여부 초기화
  memoGrpCode.Text        :=  '';        // 메모 초기화
  chkadmin.Checked        :=  False;     // 관리자권한 초기화
end;

// 입력컴포넌트 값 초기화 ( hr_common_code_value )
procedure TForm1.setValueInit;
begin
  edtValue.Text           :=  '';        // 코드값ID(value) 초기화
  edtValuename.Text       :=  '';        // 코드값명(value) 초기화
  edtValueArray.Text      :=  '';        // 정렬순서(value) 초기화
  chkValue.Checked        :=  True;      // 사용여부(value) 초기화
  memoGrpValue.Text       :=  '';        // 메모(value) 초기화
end;

// 관리자권한 컴포넌트
procedure TForm1.ToolBar1DblClick(Sender: TObject);
begin
  // admin_click 기본값은 true이다. FormCreate에서 주고 시작.
  if (mpst_code = '0579033000') or (mpst_code = '2016060060') or (mpst_code = '2018010038') then
  begin
    if adminYn = false then
    begin
      Memo1.Visible           :=  false;
      Memo2.Visible           :=  false;
      grpcode7.Visible        :=  false;
      chkadmin.Visible        :=  false;
      btnExcelForm.Visible    :=  false;
      btnExcelUpload.Visible  :=  false;
      btnExcelCode.Visible    :=  false;
      btnExcelPrint.Visible   :=  false;
      cxCodeViewhr_code_id.Visible      :=  false;
      cxCodeValueViewhr_code_id.Visible :=  false;

      adminYn := true;  // 더블클릭 시 다시 보기위해서
    end
    else // if admin_click = true then
    begin
      Memo1.Visible           :=  true;
      Memo2.Visible           :=  true;
      grpcode7.Visible        :=  true;
      chkadmin.Visible        :=  true;
      btnExcelForm.Visible    :=  true;
      btnExcelUpload.Visible  :=  true;
      btnExcelCode.Visible    :=  true;
      btnExcelPrint.Visible   :=  true;
      cxCodeViewhr_code_id.Visible      :=  true;
      cxCodeValueViewhr_code_id.Visible :=  true;

      adminYn := false;  // 더블클릭 시 다시 감추기위해서
    end;
  end;
end;

// 화면모드에 따라 컴포넌트 활성화 설정 ( hr_common_code )
procedure TForm1.setMode(AshModeInt: integer);
begin

  modeInt := AshModeInt;

  // setmode 보기화면 ( hr_common_code )
  setObjEnable(edtCodeid, AshModeInt, 2);         // 1 필수($00D2FEFF : 개나리색)  //코드ID      // [등록] : 0만 아니면 노란배경 [수정] : 2는 수정할 때 변경못하게하려고 enabled:false
  setObjEnable(edtCodename, AshModeInt, 1);       // 1 필수($00D2FEFF : 개나리색)  //코드명      // [등록] : 0만 아니면 노란배경 [수정] : 1은 필수값표시
  setObjEnable(cbxCodeAb, AshModeInt, 0);         // cbx 0 비필수                  //코드형식
  setObjEnable(edtCodelength, AshModeInt, 0);     // 0 비필수                      //코드길이
  setObjEnable(chkCode, AshModeInt, 0);           // chk 0 비필수                  //코드사용여부
  setObjEnable(memoGrpCode, AshModeInt, 0);       // 0 비필수                      //코드메모
  setObjEnable(chkadmin, AshModeInt, 0);          // chk 0 비필수 / 관리자         //관리자권한

  if AshModeInt = 1 then        // 등록버튼
    edtCodeid.SetFocus
  else if AshModeInt = 2 then   // 수정버튼
    edtCodename.SetFocus;

  case AshModeInt of
    0: // 보기
    begin // 버튼활성화 설정
      if insertYn = 'Y' then
      begin
        btn1insert.Enabled  :=  True;
        btn1update.Enabled  :=  True;
      end;

      if editYn = 'Y' then
      begin
        btn1Update.Enabled  :=  True;
      end
      else
      begin
        btn1Update.Enabled  :=  False;
      end;

      btn1Delete.Enabled  :=  true;        // 삭제버튼활성화
      btn1Save.Enabled    :=  false;
      btn1Init.Enabled    :=  false;

    end;

    1, 2, 3: // 등록, 수정, 삭제
    begin
      btn1insert.Enabled  :=  false;
      btn1update.Enabled  :=  False;
      btn1delete.Enabled  :=  false;
      btn1Save.Enabled    :=  true;
      btn1Init.Enabled    :=  true;

      btn2Save.Enabled    :=  false;
      btn2Init.Enabled    :=  false;
    end;
  end;

  {
  // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 조회누르기전엔 모든 버튼 비활성화
  if vtcode.RecordCount < 1 then
    begin
      btn1insert.Enabled  :=  False;
      btn1update.Enabled  :=  False;
      btn1delete.Enabled  :=  False;
      btn1save.Enabled    :=  False;
      btn1init.Enabled    :=  False;
    end;
  }
  setValue;
end;

// 화면모드에 따라 컴포넌트 활성화 설정 ( hr_common_code_value )
procedure TForm1.setModeValue(AshModeInt: Integer);
begin
  modeIntvalue := AshModeInt;

  // setmode 보기화면 ( hr_common_code_value )
  setObjEnable(edtValue, AshModeInt, 2);            // 1 필수($00D2FEFF : 개나리색)
  setObjEnable(edtValuename, AshModeInt, 1);        // 1 필수($00D2FEFF : 개나리색)
  setObjEnable(edtValueArray, AshModeInt, 0);       // 0 비필수
  setObjEnable(chkValue, AshModeInt, 0);            // chk 0 비필수
  setObjEnable(memoGrpValue, AshModeInt, 0);        // 0 비필수


  case AshModeInt of
    0: // 보기
    begin
      if insertYn = 'Y' then
      begin
        btn2insert.Enabled  := True;
      end
      else
      begin
        btn2insert.Enabled  := false;
      end;

      if editYn = 'Y' then
      begin
        btn2Update.Enabled  := True;
      end
      else
      begin
        btn2Update.Enabled  := False;
      end;
        btn2delete.Enabled  := true;
        btn2Save.Enabled    := false;
        btn2Init.Enabled    := false;
        
    end;

    1, 2, 3: // 등록, 수정, 삭제
    begin
      btn2insert.Enabled  := false;
      btn2update.Enabled  := false;
      btn2delete.Enabled  := false;
      btn2Save.Enabled    := true;
      btn2Init.Enabled    := true;
    end;
  end;

  {
  //2018.06.20 다시 버튼 활성화
  if vtcode.RecordCount = 0 then
  begin
    btn2insert.Enabled  := false;
    btn2update.Enabled  := false;
    btn2delete.Enabled  := false;
  end;
  }
  setCodeValue;
end;

// 화면모드에 따라 입력 컴포넌트 값 설정 ( hr_common_code )
procedure TForm1.setValue;
begin
  // 입력컴포넌트 값 초기화
  setInit;

  // 등록모드(1)가 아닐 때 입력 컴포넌트에 값 매칭
  if modeInt <> 1 then
  begin                                                                              // fieldbyname : 오픈 된 필드의 값에 접근할 때
      edtCodeid.Text        :=  vtCode.FieldByName('hr_code_id').AsString;           // vtcode테이블에서 hr_cide_id필드의 값을 받아오겠다
      edtCodename.Text      :=  vtCode.FieldByName('hr_code_id_name').AsString;
      cbxCodeAb.ItemIndex   :=  getMatchCodeIdx(vtCode.FieldByName('hr_code_value_ab').AsString, cbxCodeAb); //콤보박스
      edtCodelength.Text    :=  vtCode.FieldByName('hr_code_value_length').AsString;
      chkCode.Checked       :=  getBool(vtCode.FieldByName('hr_use_yn').AsString);
      memoGrpCode.text      :=  vtCode.FieldByName('hr_memo').AsString;
      chkadmin.Checked      :=  getBool(vtCode.FieldByName('hr_admin_yn').AsString);
  end;
end;

// 화면모드에 따라 입력 컴포넌트 값 설정 ( hr_common_code_value )
procedure TForm1.setCodeValue;
begin
  setValueInit;

  // 등록모드(1)가 아닐 때 입력 컴포넌트에 값 매칭
  if modeIntvalue <> 1 then
  begin
      edtValue.Text         :=  vtCodeValue.FieldByName('hr_code_value').AsString;
      edtValuename.Text     :=  vtCodeValue.FieldByName('hr_code_value_name').AsString;
      edtValueArray.Text    :=  vtCodeValue.FieldByName('hr_sort_seq').AsString;
      chkValue.Checked      :=  getBool(vtCodeValue.FieldByName('hr_use_yn').AsString);
      memoGrpValue.Text     :=  vtCodeValue.FieldByName('hr_memo').AsString;
  end;
end;

// 마우스 휠 이동 시 row값 edit에 적용
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


procedure TForm1.btn1Click(Sender: TObject);
begin
  {
  Excel1.Connect;
  Excel1.Exec('[WORKBOOK.INSERT(1)]');

  Excel1.PutStr(1, 1, '코드ID');
  Excel1.PutStr(1, 2, '코드값');
  Excel1.PutStr(1, 3, '코드값명');
  Excel1.PutStr(1, 4, '정렬순서');
  Excel1.PutStr(1, 5, '사용여부');
  Excel1.PutStr(1, 6, '메모');

  Excel1.Disconnect;
  }


end;


// 삭제 ( hr_common_code )
procedure TForm1.btn1deleteClick(Sender: TObject);
begin
  rowsave3 := vtCode.RecNo;
  deletecheck := True;
  // 관리자가 아닐 때 ( 관리자권한 )
  if not ((mpst_code = '0579033000') or (mpst_code = '2016060060') or (mpst_code = '2018010038')) then
  begin
    ShowMessage('전산실에 요청(문의)해주세요');
    Exit;
  end;

  if vtCode.RecordCount = 0 then
  begin
    ShowMessage('조회 후 사용하세요');
    Exit;
  end;

  // 삭제확인 메세지창
  if MessageDlg('코드를 삭제하시겠습니까?',mtConfirmation,[mbNO,mbOK],0) <> mrOK then
  begin
    ShowMessage('삭제를 취소하셨습니다.');
    exit;
  end
  else
  begin
    setmode(3);
    btn1saveClick(btn1save);
  end;
end;

// 취소 ( hr_common_code )
procedure TForm1.btn1initClick(Sender: TObject);
begin
  updateCheck := True;    // 등록,수정 눌렀다가 저장안누르고 취소눌렀을때 scroll기능 살리기 위해서
  insertCheck := True;
  deleteCheck := True;
  setmode(0);
end;

// 수정 ( hr_common_code )
procedure TForm1.btn1updateClick(Sender: TObject);
begin
  rowsave1 := vtCode.RecNo;              // 몇 번째 row인지 ( 코드 )
  updatecheck := true;                   // locate 와 recNo 때문에 ( 등록이나 수정 후 그 수정한 row로 이동시키기 위해서 사용)

  if not ((mpst_code = '0579033000') or (mpst_code = '2016060060') or (mpst_code = '2018010038')) then
  begin
    if chkadmin.Checked = true then
    begin
      showmessage('전산실에 문의(요청)하세요');  // 사용자는 [관리자권한='Y']코드는 등록,수정 x
      Exit;
    end;
  end;
    
  setMode(2);
end;

// 등록 ( hr_common_code )
procedure TForm1.btn1insertClick(Sender: TObject);
begin
  insertcheck := True;                    // locate 와 recNo 때문에 ( 등록이나 수정 후 그 수정한 row로 이동시키기 위해서 사용)

  // 관리자가 아닐 때 ( 관리자권한 )
  if not ((mpst_code = '0579033000') or (mpst_code = '2016060060') or (mpst_code = '2018010038')) then
  begin
    ShowMessage('전산실에 요청(문의)해주세요');
    Exit;
  end;

  setmode(1);
end;

// 저장 ( hr_common_code )
procedure TForm1.btn1saveClick(Sender: TObject);
var
  codeid, codename, valueid  : String;
  codetmp : string;           // row focus를 위한 변수
  i, recTemp : integer;       // dbsdlf11 ( 공통코드값 테이블 사용여부 삭제 )
begin

  codetmp := Trim(edtCodeid.text);

    // 등록
    if modeInt = 1 then
    begin
      codeid   :=  Trim(edtCodeid.Text);
      codename :=  trim(edtCodename.Text);

      if Length(codeid) = 0 then
      begin
        ShowMessage('코드ID를  입력하세요');
        edtCodeid.SetFocus;
        exit;
      end;

      if Length(codename) = 0 then
      begin
        ShowMessage('코드명을 입력하세요');
        edtCodename.SetFocus;
        Exit;
      end;

      // 코드 중복 확인
      ashSql := 'SELECT COUNT(*) cnt FROM hr_common_code ' + 'WHERE hr_code_id ="' + codeid + '"';

      ashStr := MySQL_Assign(db_coophr, qrysql, ashSql, vtCode); // ashStr 1
//    ShowMessage(ashStr);//dbsdlf11
      try
        StrToInt(ashStr);
//    ShowMessage(ashStr);//dbsdlf11
      except
        ShowMessage('오류가 발생하였습니다.[' + ashStr + '](ERR:726)');  // (윤)직급명 오류날 때
        Exit;
      end;

      if vtCode.FieldByName('cnt').AsInteger > 0 then
      begin
        ShowMessage('코드ID가 중복됩니다.');                             // (윤)직급명 중복
        Exit;
      end;

      ashSql_bak := 'INSERT INTO hr_common_code ('    
              + 'hr_code_id'
              + ', hr_code_id_name'
              + ', hr_code_value_ab'
              + ', hr_code_value_length'
              + ', hr_admin_yn'
              + ', hr_use_yn'
              + ', hr_memo'
              + ', hr_mpst_code'    //최초등록사원번호
              + ', hr_p_day'
              + ', mpst_code'       //최종변경사원번호
              + ', p_day'
              + ', chk_svr'
              + ') VALUES ("'
              + Trim(edtCodeid.text)              + '", "'         //'  hr_code_id'
              + Trim(edtCodename.Text)            + '", "'         //', hr_code_id_name'
              + getCommCodeVal(cbxCodeAb)         + '", "'         //', hr_code_value_ab'      -> [text=A 숫자]에서 'A'만 가져온다
              + Trim(edtCodelength.text)          + '", "'         //', hr_code_value_length'
              + getYn(chkadmin.checked)           + '", "'         //', hr_admin_yn'
              + getYn(chkCode.Checked)            + '", "'         //', hr_use_yn'
              + Trim(memoGrpCode.Text)            + '", "'         //', hr_memo'
              + mpst_code
              + '", NOW(), "'  // 현재시간출력
              + mpst_code
              + '", NOW(), "'
              + IntToStr(svrconn) + '")';

      ashSql := 'INSERT INTO hr_common_code ('    //********************** 여기부터 수정
              + 'hr_code_id'
              + ', hr_code_id_name'
              + ', hr_code_value_ab'
              + ', hr_code_value_length'
              + ', hr_admin_yn'
              + ', hr_use_yn'
              + ', hr_memo'
              + ', hr_mpst_code'
              + ', hr_p_day'
              + ', mpst_code'
              + ', p_day'
              + ', history'
              + ', chk_svr'
              + ') VALUES ("'
              + Trim(edtCodeid.text)              + '", "'          //'hr_code_id'
              + Trim(edtCodename.Text)            + '", "'          //', hr_code_id_name'
              + getCommCodeVal(cbxCodeAb)         + '", "'          //', hr_code_value_ab'
              + Trim(edtCodelength.text)          + '", "'          //', hr_code_value_length'
              + getYn(chkadmin.checked)           + '", "'          //', hr_admin_yn'
              + getYn(chkCode.Checked)            + '", "'          //', hr_use_yn'
              + Trim(memoGrpCode.Text)            + '", "'          //', hr_memo'
              + mpst_code
              + '", NOW(), "'  // (윤)현재시간출력
              + mpst_code
              + '", NOW(), "'
              + SQLToHistory(ashSql_bak) + '", "' // history    // (윤)SQLToHistory : 이력 쿼리의  NOW() 함수 시간으로 변환
              + IntToStr(svrconn) + '")';
    Memo1.Lines.Add(ashsql);
    end

    // 수정
    else if modeInt = 2 then
    begin
      codeid := vtCode.FieldByName('hr_code_id').AsString;

      ashSql_bak := 'UPDATE hr_common_code SET '
              + 'hr_code_id_name = "'           +     Trim(edtCodename.Text)
              + '", hr_code_value_ab = "'       +     getCommCodeVal(cbxCodeAb) // 콤보박스
              + '", hr_code_value_length = "'   +     trim(edtCodelength.text)
              + '", hr_admin_yn  = "'           +     getYn(chkadmin.Checked)
              + '", hr_use_yn = "'              +     getYn(chkCode.Checked)
              + '", hr_memo = "'                +     Trim(memoGrpCode.Text)
              + '", mpst_code = "'              +     mpst_code
              + '", p_day = NOW()'
              + ', chk_svr = "'                 +     IntToStr(svrconn) + '"'
              + ' WHERE hr_code_id = "'         +     codeid + '"';

      ashSql := 'UPDATE hr_common_code SET '
              + 'hr_code_id_name = "'           +     Trim(edtCodename.Text)
              + '", hr_code_value_ab = "'       +     getCommCodeVal(cbxCodeAb) // 콤보박스
              + '", hr_code_value_length = "'   +     trim(edtCodelength.text)
              + '", hr_admin_yn  = "'           +     getYn(chkadmin.Checked)
              + '", hr_use_yn = "'              +     getYn(chkCode.Checked)
              + '", hr_memo = "'                +     Trim(memoGrpCode.Text)
              + '", mpst_code = "'              +     mpst_code
              + '", p_day = NOW()'
              + ', history = concat(history, "' +     SQLToHistory(ashSql_bak) + '") '
              + ', chk_svr = "'                 +     IntToStr(svrconn) + '"'
              + ' WHERE hr_code_id = "'         +     codeid + '"';

      Memo1.Lines.Add(ashSql);
    end
    
    // 삭제
    else if modeInt = 3 then
    begin

      codeid := vtCode.FieldByName('hr_code_id').AsString;

      ashSql_bak := 'UPDATE hr_common_code SET '
              + 'hr_use_yn = "N"'
              + ', mpst_code = "'                   + mpst_code
              + '", p_day = NOW()'
              + ', chk_svr = "'                     + IntToStr(svrconn) + '" '
              + ' WHERE hr_use_yn = "Y"'
              + ' AND hr_code_id = "'               + codeid + '"';

      ashSql := 'UPDATE hr_common_code SET '
              + 'hr_use_yn = "N"'
              + ', mpst_code = "'                   + mpst_code
              + '", p_day = NOW()'
              + ', history = concat(history, "'     + SQLToHistory(ashSql_bak) + '") '
              + ', chk_svr = "'                     + IntToStr(svrconn) + '" '
              + ' WHERE hr_use_yn = "Y"'
              + ' AND hr_code_id = "'               + codeid + '"';
              
    Memo1.Lines.Add(ashSql);              
    end;
   

    try
      ashReturnRow := StrToInt(MySQL_UpDel(db_coophr, qrysql, ashSql));  // ashReturnRow : 1
//    ShowMessage(IntToStr(ashReturnRow));
    except
    on e: Exception do
      begin
        if ashReturnRow <> 1 then
        begin
          ShowMessage('입력(수정) 실패하였습니다.[hr)common_code]');
	        ShowMessage(e.Message);
          Exit;
        end;
      end;
    end;

    // 공통코드값테이블의 코드들도 사용여부를 'N'으로 바꿔주기 위해서. //dbsdlf11
    if modeInt = 3 then
    begin
      if vtCodeValue.RecordCount > 0 then
      begin
      
        recTemp := vtCodeValue.RecordCount;
        
//      ShowMessage(inttostr(recTemp));
        for i := 1 to recTemp do
        begin
//      ShowMessage(IntToStr(i));     
        codeid := vtCode.FieldByName('hr_code_id').AsString;

        ashSql_bak := 'UPDATE hr_common_code_value SET '
                + 'hr_use_yn = "N"'
                + ', mpst_code = "'                   + mpst_code
                + '", p_day = NOW()'
                + ', chk_svr = "'                     + IntToStr(svrconn) + '" '
                + ' WHERE hr_use_yn = "Y"'
                + ' AND hr_code_id = "'               + codeid + '"';

        ashSql := 'UPDATE hr_common_code_value SET '
                + 'hr_use_yn = "N"'
                + ', mpst_code = "'                   + mpst_code
                + '", p_day = NOW()'
                + ', history = concat(history, "'     + SQLToHistory(ashSql_bak) + '") '
                + ', chk_svr = "'                     + IntToStr(svrconn) + '" '
                + ' WHERE hr_use_yn = "Y"'
                + ' AND hr_code_id = "'               + codeid + '"';

          try
            ashReturnRow := StrToInt(MySQL_UpDel(db_coophr, qrysql, ashSql));
          except
            on e: Exception do
            begin
              if ashReturnRow <> 1 then
              begin
                ShowMessage('입력(수정) 실패하였습니다.[hr)common_code]');
                ShowMessage(e.Message);
                Exit;
              end;
            end;
          end;  
        end;
      end;
    end;



    btnInquiryClick(btnInquiry); // 재조회     //dbsdlf11  4월2일오후3시52분

    if updatecheck = true then
    begin
      vtCode.RecNo := rowsave1;                     // ①RecNo를 하면 모든 row를 거친다. 그걸 막기위해서 vtCodeAfterScroll
      cellClick;                                    // ③셀클릭을 해서 조회를 한다. (위치한 row값 셋팅)
      updatecheck := false;                         // ④다시 false로 바꿔준다. ( vtCodeAfterScroll 실행을 위해서)
    end;

    if insertcheck = True then
    begin
      vtCode.Locate('hr_code_id',codetmp,[]);        //등록(insert) 후 위치 시켜주기위해서
      cellClick;
      insertcheck := False;
    end;

    if deletecheck = True then
    begin
      vtCode.RecNo := rowsave3;
      cellClick;
      deletecheck := false;
    end;
end;

// 삭제 ( hr_common_code_value )
procedure TForm1.btn2deleteClick(Sender: TObject);
begin

  // 관리자가 아닐 때 ( 관리자권한 )
  if not ((mpst_code = '0579033000') or (mpst_code = '2016060060') or (mpst_code = '2018010038')) then
  begin
    ShowMessage('전산실에 요청(문의)해주세요');
    Exit;
  end;

  if vtCodeValue.RecordCount = 0 then
  begin
    ShowMessage('조회 후 사용하세요');
    Exit;
  end;

  // 삭제확인 메세지창
  if MessageDlg('코드를 삭제하시겠습니까?[사용자여부(N)]',mtConfirmation,[mbNO,mbOK],0) <> mrOK then
  begin
    ShowMessage('삭제를 취소하셨습니다.');
    exit;
  end
  else
  begin
    setmodevalue(3);
    btn2saveClick(btn2save);
  end;
end;

// 취소 ( hr_common_code_value )
procedure TForm1.btn2initClick(Sender: TObject);
begin
  setmodevalue(0);
end;

// 등록 ( hr_common_code_value )
procedure TForm1.btn2insertClick(Sender: TObject);
begin

  // 사용자는 [관리자권한='Y']코드는 등록,수정 x
  if not ((mpst_code = '0579033000') or (mpst_code = '2016060060') or (mpst_code = '2018010038')) then
  begin
    if chkadmin.Checked = true then
    begin
      showmessage('전산실에 문의(요청)하세요');  // 사용자는 [관리자권한='Y']코드는 등록,수정 x
      Exit;
    end;
  end;

  setModevalue(1);
  edtValue.SetFocus;

end;

// 수정 ( hr_common_code_value )
procedure TForm1.btn2updateClick(Sender: TObject);
begin
  rowsave2 := vtCodeValue.RecNo;              // 몇 번째 row인지 ( 코드값 )

  if vtCodeValue.RecordCount < 1 then
    begin
      ShowMessage('등록 후 사용하세요.');
      Exit;
    end;

  if not ((mpst_code = '0579033000') or (mpst_code = '2016060060') or (mpst_code = '2018010038')) then
  begin
    if chkadmin.Checked = true then
    begin
      showmessage('전산실에 문의(요청)하세요');  // 사용자는 [관리자권한='Y']코드는 등록,수정 x
      Exit;
    end;
  end;

  setModeValue(2);
  edtValuename.setfocus;
end;


// 저장 ( hr_common_code_value )
procedure TForm1.btn2saveClick(Sender: TObject);
var
  codeid, valueid, valuename  : String;
  codevaluetmp  : string;                 // row focus를 위한 변수
  valuelength, strlen : Integer;
begin

  codevaluetmp := Trim(edtvalue.text);
    
  // 등록
  if modeIntvalue = 1 then
  begin
    codeid := trim(edtCodeid.Text);
    valueid := Trim(edtValue.Text);
    valuename := trim(edtValuename.Text);
    valuelength := StrToInt(trim(edtCodelength.text));
    strlen    := Length(valueid);
    
    // 코드값길이같지않으면 등록불가 ( 같은길이여야만 등록 ) (edtValueKeyPress와 같이 사용)
    if not (valuelength = strlen) then
    begin
      ShowMessage('코드값 길이를 확인 해주세요');
      edtValue.SetFocus;
      exit;
    end;
    
    if length(valueid) = 0 then
    begin
      ShowMessage('코드값을  입력하세요');
      edtValue.SetFocus;
      Exit;
    end;

    if Length(valuename) = 0 then
    begin
      ShowMessage('코드값명을 입력하세요');
      edtValuename.SetFocus;
      exit;
    end;

    // 코드 중복 확인
    ashSql := 'SELECT COUNT(*) cnt'
                   + ' FROM hr_common_code_value'
                   + ' WHERE (hr_code_value ="' + valueid + '")'
                   + ' AND (hr_code_id="' + codeid + '")';      // codeid까지 해줘야 해.

    Memo2.Lines.Add('ashSql  :  ' + ashSql);

    ashStr := MySQL_Assign(db_coophr, qrysql, ashSql, vtTemp);  // ashStr 1이었다.

    try
      StrToInt(ashStr);
    except
      ShowMessage('오류가 발생하였습니다.[' + ashStr + '](ERR:1070)');    // (윤)직급명 오류날 때
      Exit;
    end;

    if vtTemp.FieldByName('cnt').AsInteger > 0 then
    begin
      ShowMessage('코드값이  중복됩니다.');                               // (윤)직급명 중복
      edtValue.SetFocus;
      Exit;
    end;

    ashSql_bak := 'INSERT INTO hr_common_code_value ('
            + 'hr_code_id'
            + ',hr_code_value'
            + ', hr_code_value_name'
            + ', hr_sort_seq'
            + ', hr_use_yn'
            + ', hr_memo'
            + ', hr_mpst_code'
            + ', hr_p_day'
            + ', mpst_code'
            + ', p_day'
            + ', chk_svr'
            + ') VALUES ("'
            + Trim(edtCodeid.text)               + '", "'           //'  hr_code_id'
            + Trim(edtValue.text)                + '", "'           //', hr_code_value'
            + Trim(edtValuename.Text)            + '", "'           //', hr_code_value_name'
            + Trim(edtValueArray.text)           + '", "'           //', hr_sort_seq'
            + getYn(chkValue.Checked)            + '", "'           //', hr_use_yn'
            + Trim(memoGrpValue.Text)            + '", "'           //', hr_memo'
            + mpst_code
            + '", NOW(), "'  // (윤)현재시간출력
            + mpst_code
            + '", NOW(), "'
            + IntToStr(svrconn) + '")';

    ashSql := 'INSERT INTO hr_common_code_value ('
            + 'hr_code_id'
            + ',hr_code_value'
            + ', hr_code_value_name'
            + ', hr_sort_seq'
            + ', hr_use_yn'
            + ', hr_memo'
            + ', hr_mpst_code'
            + ', hr_p_day'
            + ', mpst_code'
            + ', p_day'
            + ', history'
            + ', chk_svr'
            + ') VALUES ("'
            + Trim(edtCodeid.text)               + '", "'           //', hr_code_id'
            + Trim(edtValue.text)                + '", "'           //', hr_code_value'
            + Trim(edtValuename.Text)            + '", "'           //', hr_code_value_name'
            + Trim(edtValueArray.text)           + '", "'           //', hr_sort_seq'
            + getYn(chkValue.Checked)            + '", "'           //', hr_use_yn'
            + Trim(memoGrpValue.Text)            + '", "'           //', hr_memo'
            + mpst_code
            + '", NOW(), "'  // (윤)현재시간출력
            + mpst_code
            + '", NOW(), "'
            + SQLToHistory(ashSql_bak) + '", "'       // history    // (윤)SQLToHistory : 이력 쿼리의  NOW() 함수 시간으로 변환
            + IntToStr(svrconn) + '")';
    Memo2.Lines.Add(ashsql);
    end
    // 수정
    else if modeIntvalue = 2 then
    begin
      valueid := vtCodeValue.FieldByName('hr_code_value').AsString;
      codeid  := vtCode.FieldByName('hr_code_id').AsString;

      ashSql_bak := 'UPDATE hr_common_code_value SET '
                        + 'hr_code_value_name = "'         +     Trim(edtValuename.text)
                        + '", hr_sort_seq = "'             +     trim(edtValueArray.text)
                        + '", hr_use_yn = "'               +     getYn(chkValue.Checked)
                        + '", hr_memo = "'                 +     Trim(memoGrpValue.Text)
                        + '", mpst_code = "'               +     mpst_code
                        + '", p_day = NOW()'
                        + ', chk_svr = "'                  +     IntToStr(svrconn) + '"'
                        + ' WHERE (hr_code_value ="'       +     valueid + '")'
                        + ' AND (hr_code_id="'             +     codeid  + '")';

      ashSql := 'UPDATE hr_common_code_value SET '
                        + 'hr_code_value_name = "'         +     Trim(edtValuename.text)
                        + '", hr_sort_seq = "'             +     trim(edtValueArray.text)
                        + '", hr_use_yn = "'               +     getYn(chkValue.Checked)
                        + '", hr_memo = "'                 +     Trim(memoGrpValue.Text)
                        + '", mpst_code = "'               +     mpst_code
                        + '", p_day = NOW()'
                        + ', history = concat(history, "'  +     SQLToHistory(ashSql_bak) + '") '
                        + ', chk_svr = "'                  +     IntToStr(svrconn) + '"'
                        + ' WHERE (hr_code_value ="'       +     valueid + '")'
                        + ' AND (hr_code_id="'             +     codeid  + '")';

    Memo2.Lines.Add(ashSql);
    end

    // 삭제
    else if modeIntvalue = 3 then
    begin
      valueid := vtCodeValue.FieldByName('hr_code_value').AsString;
      codeid  := vtCode.FieldByName('hr_code_id').AsString;
      
      ashSql_bak := 'UPDATE hr_common_code_value SET '
              + 'hr_use_yn = "N"'
              + ', mpst_code = "'                          +  mpst_code
              + '", p_day = NOW()'
              + ', chk_svr = "'                            +  IntToStr(svrconn) + '" '
              + ' WHERE (hr_code_value ="'                 +  valueid + '")'
              + ' AND (hr_code_id="'                       +  codeid  + '")';

      ashSql := 'UPDATE hr_common_code_value SET '
              + 'hr_use_yn = "N"'
              + ', mpst_code = "'                          +  mpst_code
              + '", p_day = NOW()'
              + ', history = concat(history, "'            +  SQLToHistory(ashSql_bak) + '") '
              + ', chk_svr = "'                            +  IntToStr(svrconn) + '" '
              + ' WHERE (hr_code_value ="'                 +  valueid + '")'
              + ' AND (hr_code_id="'                       +  codeid  + '")';

      Memo2.Lines.Add(ashSql);
    end;

    try
      ashReturnRow := StrToInt(MySQL_UpDel(db_coophr, qrysql, ashSql));
    except
    on e: Exception do
      begin
        if ashReturnRow <> 1 then
        begin
          ShowMessage('입력(수정) 실패하였습니다.[hr)common_code_value]');
	        ShowMessage(e.Message);
          Exit;
        end;
      end;
    end;


    cellClick; // 재조회
    setModeValue(0); // 다시 (보기)화면(윤)
    vtcodevalue.RecNo := rowsave2; // (윤)
    vtcodevalue.Locate('hr_code_value',codevaluetmp,[]);  //(윤)

end;

// [HR공통기초코드관리] 프로그램 종료 ( hr_common_code )
procedure TForm1.btnCloseClick(Sender: TObject);
begin
  Close;
end;

// 조회
procedure TForm1.btnInquiryClick(Sender: TObject);
var
  mainInquiry : string;
begin
    vtCodeValue.Clear;    // 코드값테이블 초기화
    mainInquiry := Trim(edtmain.text);  // edtMain입력창

     // 코드 조회
    {if Length(mainInquiry) <> 0 then    // edtMain에 글자 입력되면
    begin
      ashSql := 'SELECT'
                + '  hr_code_id'
                + ', hr_code_id_name'
                + ', hr_code_value_ab'
                + ', hr_code_value_length'
                + ', hr_admin_yn'
                + ', hr_use_yn'
                + ', hr_memo'
                + ', (SELECT hr_m_name FROM hr_members WHERE hr_m_code = hr_common_code.mpst_code) mpst_code'
                + ', p_day'
                + ' FROM hr_common_code'
                + ' WHERE (hr_code_id LIKE "%' + mainInquiry + '%")'       // LIKE 함수를 써서 단어만있으면 앞뒤상관없이 검색가능.
                + ' OR (hr_code_id_name LIKE "%' + mainInquiry + '%")';
    end
    else
    begin
      ashSql := 'SELECT'
                + '  hr_code_id'
                + ', hr_code_id_name'
                + ', hr_code_value_ab'
                + ', hr_code_value_length'
                + ', hr_admin_yn'
                + ', hr_use_yn'
                + ', hr_memo'
                + ', (SELECT hr_m_name FROM hr_members WHERE hr_m_code = hr_common_code.mpst_code) mpst_code'
                + ', p_day'
                + ' FROM hr_common_code';
    end;}

    ashSql := 'SELECT'
                + '  hr_code_id'
                + ', hr_code_id_name'
                + ', hr_code_value_ab'
                + ', hr_code_value_length'
                + ', hr_admin_yn'
                + ', hr_use_yn'
                + ', hr_memo'
                + ', (SELECT hr_m_name FROM hr_members WHERE hr_m_code = hr_common_code.mpst_code) mpst_code'
                + ', p_day'
                + ' FROM hr_common_code';

    if Length(mainInquiry) <> 0 then    // edtMain에 글자 입력되면
    begin
      ashSql := ashSql + ' WHERE (hr_code_id LIKE "%'   + mainInquiry + '%")'   // LIKE 함수를 써서 단어만 있으면 앞뒤 상관없이 검색가능.
                       + ' OR (hr_code_id_name LIKE "%' + mainInquiry + '%")';
    end;

    ashStr := MySQL_Assign(db_coophr, qrysql, ashSql, vtCode);  //(윤) mysql(db명,query,쿼리문변수,(가상)테이블)
                                                                //(윤) ShowMessage(ashStr);   -> MySQL_Assign의 값은 string이다
    try
      StrToInt(ashStr);
    except
      ShowMessage('오류가 발생하였습니다.[' + ashStr + '](ERR:1285)');
      Exit;
    end;

    Memo1.Lines.Add('ashSql : ' + ashSql);

    setMode(0);
    btn2insert.Enabled := false;
    btn2update.Enabled := False;
    isScroll := True;
    cellClick;
end;


// 코드(hr_common_code)클릭 시 발생
procedure TForm1.cellClick;
var
  codeid : string;
begin

  codeid := vtCode.FieldByName('hr_code_id').AsString;

  ashSqL := 'SELECT'
          + ' hr_code_id'
          + ', hr_code_value'
          + ', hr_code_value_name'
          + ', hr_sort_seq'
          + ', hr_use_yn'
          + ', hr_memo'
          + ', (SELECT hr_m_name FROM hr_members WHERE hr_m_code = hr_common_code_value.mpst_code) mpst_code'
          + ', p_day'
          + ' FROM hr_common_code_value'
          + ' WHERE hr_code_id = "' + codeid + '"'
          + ' ORDER BY hr_sort_seq';

  ashStr := MySQL_Assign(db_coophr, qrysql, ashSql, vtCodevalue); // (윤)mysql(db명,query,쿼리문변수,(가상)테이블)

  try
    StrToInt(ashStr);
  except
    ShowMessage('오류가 발생하였습니다.[' + ashStr + '](ERR:1324)');
    Exit;
  end;
Memo2.Lines.Add(ashsql);

  setMode(0);                     // 코드edit에 값
  setModeValue(0);                // 코드값edit에 값
  isScroll := True;               // AfterScroll기능을 위해서

end;

// 코드(hr_common_code)그리드 행 클릭 시
procedure TForm1.cxCodeViewCellClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  cellClick;  // hr_common_code_value 조회
end;


// No필드 추가 ( 맨 앞에 넘버링해주기 )( 가독성 ↑ )
procedure TForm1.cxCodeViewcode_noGetDisplayText(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
begin
  AText := IntToStr(Arecord.index+1);
end;


// 코드값(hr_common_code_value)그리드 행 클릭 시
procedure TForm1.cxCodeValueViewCellClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  setmodeValue(0);
end;


// (Enter누르면) edtMain에서 조회(F9)
procedure TForm1.edtMainKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then     // ENTER키의 번호는 [#13]이다.
    begin
      btnInquiryClick(btnInquiry);
    end;
end;

//CTRL+V (붙여넣기)기능 20181026yik
//슬기선배님 요청
procedure TForm1.edtValueKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  strlen, valuelength : Integer;
  valueid : string;
//edtValueKeyPress이벤트 그대로 복붙 20181026yik
begin
  if (Shift = [ssCtrl]) and (Key = ord('V')) then
  begin

  end;
end;

procedure TForm1.edtValueKeyPress(Sender: TObject; var Key: Char);
var
  strlen, valuelength : Integer;
  valueid : string;
begin
  // 코드값형식 구분 ( 0 = A숫자, 1 = B알파벳, 2 = C기타 )
  if cbxCodeAb.ItemIndex = 0 then
  begin
    if Key in ['0'..'9',#25,#08,#13] then   // #25는 BackSpace키, #08은 방향키, #13은 Enter키
    else
    begin
      Key := #0;                            // #0 : key를 Null으로 반환
      edtValue.Clear;
      ShowMessage('숫자만 입력하세요');
    end;
  end
  else if cbxCodeAb.ItemIndex = 1 then
  begin
    if Key in ['a'..'z','A'..'Z',#25,#08,#13] then
    else
    begin
      Key := #0;
      edtValue.Clear;
      ShowMessage('알파벳만 입력하세요');
    end;
  end
  else if cbxCodeAb.ItemIndex = 2 then
  begin
    if Key in ['a'..'z','A'..'Z','0'..'9','_',#25,#08,#13] then
    else
    begin
      key := #0;
      edtValue.Clear;
      ShowMessage('한글/특수문자는 입력이 안됩니다.');
    end;
  end;

  // 문자열길이 기능(dbsdlf11)
  valuelength  :=  StrToInt(trim(edtCodelength.text));
  valueid      :=  Trim(edtValue.text);
  strlen       :=  Length(valueid);

  // edit창에 입력되자마자 바로 길이를 인식하지 않으므로. [ ex)1입력된 상태인데 strlen은 0이다. 그 다음 숫자가입력되야 그제서야 strlen이 1이 된다.]
  if valuelength = strlen then
  begin
    key := #0;      // #0 : key를 Null으로 반환
    ShowMessage('코드값 길이를 확인 해주세요');
    edtValue.Clear; // 초기화시켜줌
  end;

end;


// 메인폼(TForm1)에서 키 다운 이벤트 발생 시
procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssAlt]) or (Shift = [ssCtrl]) then Exit;   // 질문 알트나 컨트롤을 누르면 exit하게 하려는거 아닌가?

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

    // 조회
    VK_F9:
    begin
      if btnInquiry.Enabled then
      begin
        btnInquiryClick(btnInquiry);
        key := 0;
      end;
    end;

    // 종료 ( #27 )
    VK_ESCAPE:
    begin
      if btnClose.Enabled then
        btnCloseClick(btnClose);
      Key := 0;
    end;
  end;
end;

// 코드(hr_common_code)테이블 연결 후
procedure TForm1.vtCodeAfterOpen(DataSet: TDataSet);    //(윤) AfterOpen : 테이블을 엽니다.( Query나 Table이 오픈된 후에 )
begin                                                   //(윤) 조회 후 조회된 row(행)을 누른상태에서 다시 조회를 누르면, row(행) 누른상태 해제
  isScroll := false;
//ShowMessage(BoolToStr(isScroll, true));
end;


// 코드(hr_common_code)테이블, 조회 후 스크롤의 변화에 따라서 진행되어야 하므로
procedure TForm1.vtCodeAfterScroll(DataSet: TDataSet);
begin
  if isScroll = False then Exit;
  if (updateCheck = True) or (insertCheck = True) or (deleteCheck = True) then Exit;  // ② true면 afterscroll을 바로 종료해준다. 그리고 다시

  cellClick;
end;

// 코드(hr_common_code_value)테이블, 스크롤 움직임 후
procedure TForm1.vtCodeValueAfterScroll(DataSet: TDataSet);
begin
  if isScroll = false then Exit;

  setCodeValue; //  코드값 edit창에 값 출력
end;

// 엑셀양식
procedure TForm1.btnExcelFormClick(Sender: TObject);
var
  ExcelApp  :  Variant;   // 가변형(variant type) - 실행시 임의의 자료형을 포함할 수 있는 자료형
  strfname  :  string;

begin
  // 기존파일만선택가능 ( Only allow existing files to be selected  )
  OpenDialog1.Options := OpenDialog1.Options + [ofFileMustExist];

  // 파일포멧확인
  OpenDialog1.Filter := '|*.xlsx';
  OpenDialog1.DefaultExt := '.xlsx';

  // 파일열기 함수가 실행되지 않으면 종료
  if(OpenDialog1.Execute <> TRUE) then exit;

  // onpendialog로 연 파일명 변수에 저장
  strfname := OpenDialog1.FileName;

  //엑셀 설치여부 확인
  try
    ExcelApp:= CreateOleObject('Excel.Application');
  except
    ShowMessage('엑셀이 설치되어 있는지 확인해주세요');
    exit;
  end;

  //선택한 엑셀 파일 로딩 방법
  try
    ExcelApp:= CreateOleObject('Excel.Application');

    ExcelApp.Visible := true;
    ExcelApp.WorkBooks.Open(strfname);

    ExcelApp.Cells[1,1].Value := '코드ID';
    ExcelApp.Cells[1,1].interior.ColorIndex := 6;      // 필수값 [6] : 노란색
    ExcelApp.Cells[1,1].HorizontalAlignment := -4108;  // 가운데정렬
    ExcelApp.Cells[1,1].borders.LineStyle := 1;        // 셀테두리지정 (선스타일) : 1
    ExcelApp.Cells[1,1].borders.Weight := 2;           // 셀테두리지정 (선두께)   : 2
//  EXLSApp.Cells[1,1].Mergecells := True;             // 셀병합

    ExcelApp.Cells[1,2].Value := '코드값';
    ExcelApp.Cells[1,2].interior.ColorIndex := 6;
    ExcelApp.Cells[1,2].HorizontalAlignment := -4108;
    ExcelApp.Cells[1,2].borders.LineStyle := 1;
    ExcelApp.Cells[1,2].borders.Weight := 2;

    ExcelApp.Cells[1,3].Value := '코드값명';
    ExcelApp.Cells[1,3].interior.ColorIndex := 2;      // 비필수값 [2] : 흰색
    ExcelApp.Cells[1,3].HorizontalAlignment := -4108;
    ExcelApp.Cells[1,3].borders.LineStyle := 1;
    ExcelApp.Cells[1,3].borders.Weight := 2;

    ExcelApp.Cells[1,4].Value := '정렬순서';
    ExcelApp.Cells[1,4].interior.ColorIndex := 2;
    ExcelApp.Cells[1,4].HorizontalAlignment := -4108;
    ExcelApp.Cells[1,4].borders.LineStyle := 1;
    ExcelApp.Cells[1,4].borders.Weight := 2;

    ExcelApp.Cells[1,5].Value := '사용여부';
    ExcelApp.Cells[1,5].interior.ColorIndex := 2;
    ExcelApp.Cells[1,5].HorizontalAlignment := -4108;
    ExcelApp.Cells[1,5].borders.LineStyle := 1;
    ExcelApp.Cells[1,5].borders.Weight := 2;

    ExcelApp.Cells[1,6].Value := '메모';
    ExcelApp.Cells[1,6].interior.ColorIndex := 2;
    ExcelApp.Cells[1,6].HorizontalAlignment := -4108;
    ExcelApp.Cells[1,6].borders.LineStyle := 1;
    ExcelApp.Cells[1,6].borders.Weight := 2;

  except
    showmessage('선택한 엑셀파일을 확인해주세요');
    Exit;
  end;

end;

// 엑셀업로드
procedure TForm1.btnExcelUploadClick(Sender: TObject);
var
  ExcelApp    :  Variant;
  cntR, cntC  :  integer;       // 행/열 변수
  i, j        :  Integer;       // 순환변수
  startRow    :  Integer;

begin

  // 파일열기
  if OpenDialog1.Execute then
  begin                                                 //  객체연결삽입(Object Linking and Embedding)
    ExcelApp := CreateOleObject('Excel.application');   //  OLE컨트롤 생성
    try
    except
      showmessage('Excel 설치되어 있지 않습니다.');
      exit;
    end;
    ExcelApp.workbooks.open(OpenDialog1.FileName);      //  새화일 open
  end
  else
  begin
    Exit;
  end;

  Screen.Cursor := crHourGlass;

  vtCodeValue.Clear;

  startRow := 2;
  cntR  :=  StrToInt(ExcelApp.ActiveSheet.UsedRange.Rows.Count);        // 행의 개수
  cntC  :=  StrToInt(ExcelApp.ActiveSheet.UsedRange.Columns.Count);     // 열의 개수
  cxCodeValueView.DataController.DataSource := nil;

  //값가져오기
  for i := startRow to cntR do     // 필드명 빼고 시작이라 2행부터 ( i:= 2 )
  begin
    if not vtCodeValue.Active then
      vtCodeValue.Active := True;


    // 필수입력값 확인 ( 코드ID )
    if Length(Trim(ExcelApp.cells[i, 1])) = 0 then
    begin
      if messageDlg('코드ID가 유효하지 않습니다. 계속하시겠습니까?.', mtConfirmation, [mbNo, mbOK], 0) <> mrOK then
      begin
        ShowMessage('취소되었습니다.');
        Screen.Cursor := crDefault;
        Exit;
      end;
        Continue;
    end;

    // 필수입력값 확인 ( 코드값 )
    if Length(Trim(ExcelApp.cells[i, 2])) = 0 then
    begin
      if messageDlg('코드값이 유효하지 않습니다. 계속하시겠습니까?.', mtConfirmation, [mbNo, mbOK], 0) <> mrOK then
      begin
        ShowMessage('취소되었습니다.');
        Screen.Cursor := crDefault;
        Exit;
      end;
      Continue;
    end;


                                    //  내용을 추가하기 위해 기존 텍스트 파일을 엽니다.
    vtCodeValue.Append;             //  Append : data가 End of File로 추가
                                    //  디스크상의 기존에 있는 파일에 데이터를 추가로 출력하기 위한 파일 오픈 함수이다.

    if vtCode.RecordCount = 0 then
    begin
    for j := 0 to cntC - 1 do
      vtCodeValue.Fields[j+1].AsString := Trim(ExcelApp.cells[i, j+1]); // 조회 안하고 했을 때, (No컬럼때문에 1을 더해줘야 한다.)

      // 정렬순서 default값 ( 0 ) 주기
      if Length(Trim(ExcelApp.cells[i, 4])) = 0 then
      begin
        vtCodeValue.Fields[3+1].AsString := '0'; // 정렬순서 default값 : '0'
      end;
    end
    else
    begin
    for j := 0 to cntC - 1 do
      vtCodeValue.Fields[j].AsString := Trim(ExcelApp.cells[i, j+1]);   // 조회 하고 했을 때,

      // 정렬순서 default값 ( 0 ) 주기
      if Length(Trim(ExcelApp.cells[i, 4])) = 0 then
      begin
        vtCodeValue.Fields[3].AsString := '0'; // 정렬순서 default값 : '0'
      end;
    end;

    Memo2.Lines.Add(IntToStr(i-1) + ' : R' );

    vtCodeValue.Post;

  end;

  cxCodeValueView.DataController.DataSource := dsCodeValue;

  ExcelApp.quit;
  Screen.Cursor := crDefault;

//vtCodeValue.First;

end;

// 코드값일괄반영
procedure TForm1.btnExcelCodeClick(Sender: TObject);
var
  codeid, codevalue, valuename, sortseq, useYn, memo : string;
  failList : string;
begin
  if vtCodeValue.RecordCount = 0 then
  begin
    ShowMessage('엑셀 업로드 후 사용하세요');
    Exit;
  end;

  if MessageDlg('일괄반영하시겠습니까?', mtConfirmation, [mbNo, mbOK], 0) <> mrOK then
  begin
    ShowMessage('취소되었습니다');
    Exit;
  end;

  vtCodeValue.First;              // First : DataSet의 제일 첫 레코드로 이동
  while not vtCodeValue.Eof do    // EOF : 마지막 레코드에 커서가 있을 때 Next가 수행되면 True로 발생됩니다.
  begin
    codeid    := Trim(vtCodeValue.FieldByName('hr_code_id').AsString);
    codevalue := Trim(vtCodeValue.FieldByName('hr_code_value').AsString);
    valuename := Trim(vtCodeValue.FieldByName('hr_code_value_name').AsString);
    sortseq   := Trim(vtCodeValue.FieldByName('hr_sort_seq').AsString);

    // if sortseq = '' then sortseq := '0'; // 정렬순서 기본값 처리 (2)

    // 공통코드테이블에 코드ID가 없으면 등록저장x
    if codeid <> Trim(edtCodeid.text) then
    begin
      ShowMessage('코드ID를 확인해주세요');
      EXIT;
    end;    

    useYn   :=  Trim(vtCodeValue.FieldByName('hr_use_yn').AsString); 
    memo    :=  Trim(vtCodeValue.FieldByName('hr_memo').AsString);

    //코드값 중복확인
    ashSQL := 'SELECT hr_code_value_name, hr_sort_seq, hr_use_yn, hr_memo FROM hr_common_code_value'
            + ' WHERE (hr_code_id = "' + codeid + '")'
            + ' AND (hr_code_value = "' + codevalue + '")';

    Memo2.Lines.Add(ashSQL);
    ashStr := MySQL_Assign(db_coophr, qrysql, ashSql, vtTemp);

    try
      StrToInt(ashStr); //row반환
    except
      ShowMessage('오류가 발생하였습니다.[' + ashStr + '](ERR:코드값 중복확인(2))');
      Exit;
    end;

    if vtTemp.RecordCount > 0 then // 수정
    begin
      if (valuename = vtTemp.FieldByName('hr_code_value_name').AsString)
          and (sortseq = vtTemp.FieldByName('hr_sort_seq').AsString)
          and (useYn = vtTemp.FieldByName('hr_use_yn').AsString)
          and (memo = vtTemp.FieldByName('hr_memo').AsString) then
      begin
Memo1.Lines.Add(codevalue+ '  Continue');

        vtCodeValue.Next;   // Next : 현재 레코드보다 하나 뒤의 레코드로 이동
        Continue;           // 루프의 남은 뒷부분은 무시되며 루프의 조건 점검부로 점프한다.
      end;

      ashSql_bak := 'UPDATE hr_common_code_value SET '
              + 'hr_code_value_name = "' + valuename
              + '", hr_sort_seq = "'     + sortseq
              + '", hr_use_yn = "'       + useYn
              + '", hr_memo = "'         + memo
              + '", mpst_code = "'       + mpst_code
              + '", p_day = NOW()'
              + ', chk_svr = "' + IntToStr(svrconn) + '" '
              + ' WHERE hr_code_id = "' + codeid
              + '" AND hr_code_value = "' + codevalue + '"';

      ashSql := 'UPDATE hr_common_code_value SET '
              + 'hr_code_value_name = "' + valuename
              + '", hr_sort_seq = "'     + sortseq
              + '", hr_use_yn = "'       + useYn
              + '", hr_memo = "'         + memo
              + '", mpst_code = "'       + mpst_code
              + '", p_day = NOW()'
              + ', history = concat(history, "' + SQLToHistory(ashSql_bak) + '") '
              + ', chk_svr = "' + IntToStr(svrconn) + '" '
              + ' WHERE hr_code_id = "' + codeid
              + '" AND hr_code_value = "' + codevalue + '"';
    end
    else // 등록
    begin
      ashSql_bak := 'INSERT INTO hr_common_code_value ('
              + 'hr_code_id'
              + ', hr_code_value'
              + ', hr_code_value_name'
              + ', hr_sort_seq'
              + ', hr_use_yn'
              + ', hr_memo'
              + ', hr_mpst_code'
              + ', hr_p_day'
              + ', mpst_code'
              + ', p_day'
              + ', chk_svr'
              + ') VALUES ("'
              + codeid + '", "'
              + codevalue + '", "'
              + valuename + '", "'
              + sortseq + '", "'
              + useYn + '", "'
              + memo + '", "'
              + mpst_code
              + '", NOW(), "'
              + mpst_code
              + '", NOW(), "'
              + IntToStr(svrconn) + '")';

      ashSql := 'INSERT INTO hr_common_code_value ('
              + 'hr_code_id'
              + ', hr_code_value'
              + ', hr_code_value_name'
              + ', hr_sort_seq'
              + ', hr_use_yn'
              + ', hr_memo'
              + ', hr_mpst_code'
              + ', hr_p_day'
              + ', mpst_code'
              + ', p_day'
              + ', history'
              + ', chk_svr'
              + ') VALUES ("'
              + codeid + '", "'
              + codevalue + '", "'
              + valuename + '", "'
              + sortseq + '", "'
              + useYn + '", "'
              + memo + '", "'
              + mpst_code
              + '", NOW(), "'
              + mpst_code
              + '", NOW(), "'
              + SQLToHistory(ashSql_bak) + '", "' // history
              + IntToStr(svrconn) + '")';
    end;
Memo1.Lines.Add(ashSql);

    failList := '';

    try
      ashReturnRow := StrToInt(MySQL_UpDel(db_coophr, qrysql, ashSql));
    except
    on e: Exception do
      begin
        if ashReturnRow <> 1 then
        begin
          failList := failList + codeid + '-' + codevalue + #13;
        end;
      end;
    end;
    vtCodeValue.Next;
  end;

  if failList <> '' then
  begin
    ShowMessage('일괄반영실패' + #13 + failList);
  end
  else
    ShowMessage('일괄저장되었습니다.');
end;

// 엑셀출력
procedure TForm1.btnExcelPrintClick(Sender: TObject);  // Comobj추가(CreateOleObject), cxGridExportLink추가(ExportGridToExcel)
var
  xl        :  Variant;
  xlbook    :  Variant;
  xlsheet1  :  Variant;
begin
  if vtCode.RecordCount = 0 then
  begin
    ShowMessage('조회 후 사용하세요');
    Exit;
  end;

  if vtCodeValue.RecordCount = 0 then
  begin
    ShowMessage('조회 후 사용하세요');
    Exit;
  end;

  xl:= CreateOleObject('Excel.Application');  // 엑셀설치

  // 어떤걸 출력할거냐 선택해서 띄우기
  if MessageDlg('[OK]는 코드내역을, [NO]는 코드상세내역을 출력합니다.',mtConfirmation,[mbNO,mbOK]
  ,0) <> mrOK then
  begin
    ExportGridToExcel('HR공통코드값.xls', cxCodeValue);
    xlbook := xl.WorkBooks.Add(ExtractFilePath(Application.ExeName)+'HR공통코드값.xls');
  end
  else
  begin
    ExportGridToExcel('HR공통코드.xls', cxCode);
    xlsheet1 := xl.WorkBooks.Add(ExtractFilePath(Application.ExeName)+'HR공통코드.xls');
  end;

  xl.DisplayAlerts := False;
  xl.Visible := true;

  try
  except
    xlbook.Close;
    xl.Quit;
    xl := UnAssigned;
  end;

end;

// FormClose
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  qrySql.Close;           // 쿼리종료
  vtCode.Close;           // 코드(hr_common_code)테이블 연결 종료
  vtCodeValue.Close;      // 코드값(hr_common_code_value)테이블 연결 종료
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

{
procedure TForm1.Button1Click(Sender: TObject);
var
  EXLSApp  : Variant;
  XLbook : Variant;
  after : Variant;
  Sheet1, Sheet2, Sheet3, sheet4, AshxlSheet : Variant;
begin
  if not vtCodeValue.active then
    Exit;
  if vtCodeValue.RecordCount = 0 then
    Exit;

  Screen.Cursor := crHourGlass;

  ExportGridToExcel('HR테스트.xls', cxCodeValue);
  EXLSApp := CreateOleObject('Excel.Application');
  XLbook  := EXLSApp.WorkBooks.Add(ExtractFilePath(Application.ExeName)+'HR테스트.xls');

  Sheet1 := XLBook.workSheets.Add;
  Sheet1.Name := 'aSheet1';         //ExcelApp.Cells[1,1].Value := '코드ID';

  Sheet2 := XLBook.workSheets.Add;
  Sheet2.Name := 'aSheet2';

  Sheet3 := XLBook.workSheets.Add;
  Sheet3.Name := 'aSheet3';

  Sheet4 := XLBook.workSheets.Add;
  Sheet4.Name := 'aSheet4';


//  XLbook.Worksheets.Add(After:=Sheet1[sheet1.count]);
//  XLBook.Add(After:=XLBook[XLBook.count]);

//XLbook.ActiveSheet.Delete;

  EXLSApp.Visible := True;
  Screen.Cursor := crDefault;

end;
}

end.



{
// delimiter test
procedure TForm1.Button1Click(Sender: TObject);
var
 List1 : TStringList;
begin
 List1 := TStringList.Create;

  try List1.Delimiter:='_';
      List1.DelimitedText:='this_is_the_first_post';

    ShowMessage(List1[0]);
    ShowMessage(List1[1]);
    ShowMessage(List1[2]);
    ShowMessage(List1[3]);
    ShowMessage(List1[4]);
  finally
    List1.Free;
  end;
end;
}

// 엑셀출력(original)
{
procedure TForm1.btnExcelPrintClick(Sender: TObject);  // Comobj추가(CreateOleObject), cxGridExportLink추가(ExportGridToExcel)
var
  EXLSApp   :  Variant;
  Workbook  :  Variant;
begin
  if not vtcodevalue.Active then
    Exit;
  if vtcodevalue.RecordCount = 0 then
    Exit;

  Screen.Cursor := crHourGlass; // 마우스모양(모래시계)

  ExportGridToExcel('HR공통코드관리.xls', cxCodeValue);
  EXLSApp:= CreateOleObject('Excel.Application');
  EXLSApp.Application.EnableEvents := false;
  Workbook := EXLSApp.WorkBooks.Add(ExtractFilePath(Application.ExeName)+'HR공통코드관리.xls');

  EXLSApp.Visible := true;

  Screen.Cursor := crDefault; // 마우스모양

end;
}

  //엑셀시트추가
//  xlsheet1 := xl.WorkBooks[1].Sheets.Add(After:=xl.WorkBooks[1].Sheets[xl.WorkBooks[1].Sheets.count]);

  //엑셀시트명
//  xlsheet1.Name := '시트명';


// cxgrid값가져오는거 생각해보기 (cell값)
