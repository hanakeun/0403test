unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, Grids, DBGrids, Menus, StdCtrls, Buttons,
  ZConnection, DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, RxMemDS, MemDS, VirtualTable, Excels,
  ExtCtrls, ComObj, ZAbstractConnection, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit,
  cxDBLookupComboBox, cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxNavigator, cxDBData, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxClasses;
{$I coop_data.inc}
//주석처리
//주석처리
//주석처리
//주석처리
//주석처리
//주석처리
//주석처리
//주석처리

//dfdfefe
//eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee          zxvczxcv






type
  TForm1 = class(TForm)
    ToolBar1: TToolBar;
    StatusBar1: TStatusBar;
    btnSearch: TToolButton;
    btnExcel: TToolButton;
    btnClose: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    btnSave: TBitBtn;
    PopupMenu1: TPopupMenu;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Label3: TLabel;
    edtFs_day: TDateTimePicker;
    tblCms: TRxMemoryData;
    dtstblCms: TDataSource;
    tblorg: TVirtualTable;
    dtstblorg: TDataSource;
    tbljohap: TVirtualTable;
    dtstbljohap: TDataSource;
    Label5: TLabel;
    tblCmssno: TIntegerField;
    tblCmsm_code: TStringField;
    tblCmsnum: TIntegerField;
    tblCmss_money: TFloatField;
    tblCmsj_code: TStringField;
    tblCmsc_code: TStringField;
    tblCmskind: TStringField;
    tblCmsbank: TStringField;
    tblCmsj_name: TStringField;
    tblCmsm_name: TStringField;
    tblCmsc_name: TStringField;
    qrycenter: TVirtualTable;
    qrymembers: TVirtualTable;
    qryCode: TVirtualTable;
    tblCmsbank_name: TStringField;
    tblCmskind_name: TStringField;
    tblCmsr_ab: TStringField;
    tblCmsj_code1: TStringField;
    qryjohap: TVirtualTable;
    tblCmsj_name1: TStringField;
    qrymembership: TVirtualTable;
    tblCmsr_ab_name: TStringField;
    pb1: TProgressBar;
    tblCmsc_code1: TStringField;
    tblCmsc_name1: TStringField;
    Excel1: TExcel;
    N1: TMenuItem;
    tblCmso_code: TStringField;
    rg1: TRadioGroup;
    Label4: TLabel;
    tblorders: TRxMemoryData;
    dtstblorders: TDataSource;
    tblordersm_code: TStringField;
    tblordersg_code: TStringField;
    tblorderss_day: TDateField;
    tblordersa_day: TDateField;
    tblordersc_code: TStringField;
    tblorderscost: TFloatField;
    tblordersm_name: TStringField;
    tblordersc_code1: TStringField;
    tblordersc_name1: TStringField;
    tblordersj_code1: TStringField;
    tblordersj_name1: TStringField;
    tblorderso_code: TStringField;
    Label6: TLabel;
    Label7: TLabel;
    chk1: TCheckBox;
    BitBtn1: TBitBtn;
    ToolButton1: TToolButton;
    dtstblmembership: TDataSource;
    qrymembershipm_code: TStringField;
    qrymembershipmaejang_code: TStringField;
    qrymembershipm_name: TStringField;
    qrymembershipj_name: TStringField;
    tblmembership: TVirtualTable;
    tblCmsr_money: TFloatField;
    db_coopbase: TZConnection;
    qryEtc: TZQuery;
    qrySql: TZQuery;
    qry_imsi: TVirtualTable;
    qry_etc: TVirtualTable;
    edtorg: TcxLookupComboBox;
    edtjname: TcxLookupComboBox;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    cxStyle2: TcxStyle;
    cxStyle3: TcxStyle;
    cxStyle4: TcxStyle;
    cxStyle5: TcxStyle;
    cxStyle6: TcxStyle;
    cxStyle7: TcxStyle;
    cxStyle8: TcxStyle;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1DBTableView1Column1: TcxGridDBColumn;
    cxGrid1DBTableView1Column2: TcxGridDBColumn;
    cxGrid1DBTableView1Column3: TcxGridDBColumn;
    cxGrid1DBTableView1Column4: TcxGridDBColumn;
    cxGrid1DBTableView1Column5: TcxGridDBColumn;
    cxGrid1DBTableView1Column6: TcxGridDBColumn;
    cxGrid1DBTableView1Column7: TcxGridDBColumn;
    cxGrid1DBTableView1Column8: TcxGridDBColumn;
    cxGrid1DBTableView1Column9: TcxGridDBColumn;
    cxGrid1DBTableView1Column10: TcxGridDBColumn;
    cxGrid1DBTableView1Column11: TcxGridDBColumn;
    cxGrid1DBTableView1Column12: TcxGridDBColumn;
    cxGrid1DBTableView1Column13: TcxGridDBColumn;
    cxGrid1Level1: TcxGridLevel;
    Memo2: TMemo;
    strngfldCmsmaejang_code: TStringField;
    strngfld_code: TStringField;
    strngfldCmso_name: TStringField;
    strngfld_name1: TStringField;
    OpenDialog1: TOpenDialog;
    strngfld_d_code: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSearchClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnExcelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure edtorgKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure edtjnameClick(Sender: TObject);
    procedure tblCmsCalcFields(DataSet: TDataSet);
    procedure edtFs_dayChange(Sender: TObject);

//    procedure SaveAcc(cd_chk, d_code, e_code, Ashj_code, Ashcomm: string; Ashamount, AshDamt, AshEamt: real;
//      AshCDate, AshCash_ab, AshAc_num: string);
//    procedure SaveAcc_new(cd_chk, d_code, e_code, Ashj_code, Ashcomm: string; Ashamount, AshDamt, AshEamt: real;
//      AshCDate, AshCash_ab, AshAc_num, Ash_reg_num, Ash_reg_name: string);

    procedure save_cost_ldg_nq(cd_chk, d_code, nq_code, e_code, Ashj_code, Ashcomm: string; Ashamount, AshDamt, AshEamt: real;
      AshCDate, AshCash_ab, AshAc_num, Ash_reg_num, Ash_reg_name: string);
    procedure save_cost_ldg(cd_chk, d_code, e_code, Ashj_code, Ashcomm: string; Ashamount, AshDamt, AshEamt: real;
      AshCDate, AshCash_ab, AshAc_num, Ash_reg_num, Ash_reg_name: string);

//  procedure N1Click(Sender: TObject);
    procedure rg1Click(Sender: TObject);
    procedure tblordersCalcFields(DataSet: TDataSet);
    procedure chk1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure cxGrid1DBTableView1MouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
      var Handled: Boolean);

  private
    { Private declarations }
  public
    CoopData: PCoopDllData;
    ThisHandleNum: Integer;
    { Public declarations }
  end;

var
  Form1: TForm1;
  mpst_code, mpst_name, j_code, c_code, org_code, PromptStr: string;
  svrconn: Integer;
  NoCalBool: Boolean;

  cms21_unified_day, cms21_unified_day_update, cms21_created_day: TDate;    // cms21_created_day, cms21_unified_day_update 안씀
  orders_unified_day, orders_unified_day_update, orders_created_day: TDate; // orders_created_day, orders_unified_day_update 안씀

  Dacntd, Dacnte, Cacntd, Cacnte, acntd, nqdcode: string;   //nqdcode추가(부가세원계정) 2018115yik -> cug-1286098:61
  Comment, Ac_num, Asho_code, Ashj_code, AshSnum, AshTDate, AshCDate, Ash_Cost_date: string;

  Ashm_codeList: string;

procedure GetCoopData(var pCoopData: PCoopDllData); stdcall; External 'coop_dll.dll';

implementation

uses coop_utils, Unit2, coop_sql_updel;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  AshsQL, AshStr: string;
  Ashchk: string;
  Ashint: Integer;
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
  if CoopData^.svrconn = 0 then
  begin
    ShowMessage('현재 연결된 서버가 없습니다!!!');
    Close;
    Application.Terminate;
    Exit;
  end;

  case ThisHandleNum of
    1:
      CoopData^.Handle1 := Application.Handle;
    2:
      CoopData^.Handle2 := Application.Handle;
    3:
      CoopData^.Handle3 := Application.Handle;
  else
    begin
      ShowMessage('잠시 후 다시 시도하십시요!!!');
      Close;
      Application.Terminate;
      Exit;
    end;
  end;

  mpst_code := CoopData^.mpst_code;
  mpst_name := CoopData^.mpst_name;
  j_code    := CoopData^.j_code;
  c_code    := CoopData^.c_code;
  org_code  := CoopData^.org_code;
  svrconn   := CoopData^.svrconn;
  PromptStr := CoopData^.prompt_ab;

  if ((mpst_code = '365818276') and (PromptStr = 'Z')) then
  begin
    if MessageDlg('디버깅모드로 실행하시겠습니까?', mtConfirmation, [mbNO, mbOK], 0) <> mrOK then
      PromptStr := '';
  end
  else
    PromptStr := '';

  case svrconn of
    1:
      begin
        db_coopbase.HostName := CoopData^.DBHost_1st;
        db_coopbase.Database := CoopData^.DBName_1st;
        db_coopbase.User     := CoopData^.DBLogin_1st;
        db_coopbase.Password := CoopData^.DBPassword_1st;
      end;
    2:
      begin
        db_coopbase.HostName := CoopData^.DBHost_2nd;
        db_coopbase.Database := CoopData^.DBName_2nd;
        db_coopbase.User     := CoopData^.DBLogin_2nd;
        db_coopbase.Password := CoopData^.DBPassword_2nd;
      end;
    3:
      begin
        db_coopbase.HostName := CoopData^.DBHost_3rd;
        db_coopbase.Database := CoopData^.DBName_3rd;
        db_coopbase.User     := CoopData^.DBLogin_3rd;
        db_coopbase.Password := CoopData^.DBPassword_3rd;
      end;
  end;
  db_coopbase.Protocol := 'mysql-5';  // ******************************************************여기까지가 공통



  if mpst_code = 'X18020001' then
    ShowMessage(MySQL_Initiate(db_coopbase, qrySql))
  else
    MySQL_Initiate(db_coopbase, qrySql);

  //해당 법인만 프로그램이 활성화
  if (org_code <> '0023') and (org_code <> 'A049') and (org_code <> '0039') then
  // 2014-01-17 cug=752522 0039 추가
  begin
    AshStr := '본 프로그램은' + #13#10 + #13#10 + '[(주)쿱엔지니어링-(0023)]' + #13#10 + '[(주)클러스터지원그룹(CMG)-(A049)]' + #13#10 +
      '[(주)씨엘씨(CLC)-(0039)]'
    // 2014-01-17 cug=752522 0039 추가
      + #13#10 + #13#10 + '법인에서만 사용할 수 있습니다!!!';
    ShowMessage(AshStr);
    Close;
    Application.Terminate;
    db_coopbase.Disconnect;
    Exit;
  end;

  // 해당 법인 권한 체크 20181016yik
  // 법인열기
  if mpst_code <> 'X18020001' then
  begin
    //org : (사용자의 소속 구분)조직테이블
    //staff : 사원테이블
    //★★★★test 후에 where m_code="' + mpst_code + '"' + ' and o_code 이렇게 다시 변경하기
    AshsQL := 'Select o_code,o_name' + ' from org' + ' Where o_code in (Select o_code from staff' + ' Where m_code="H11074064"'
       + ' and o_code in ("0023","A049","0039")'
      + ' and program_list like "%' + Application.Title + '%"' + ' and admin_ab="A")' + ' and p_ab="A"';//p_ab(사용여부)A:사용 B:중단
                                                                                                        //admin_ab(인증여부)(사원의erp인증여부)A:인증 B:일시중단 C:인증취소
  end
  else
  begin
    AshsQL := 'Select o_code,o_name' + ' from org' + ' Where o_code in ("0023","A049","0039")';

  end;
  Ashchk := MySQL_Assign(db_coopbase, qrySql, AshsQL, tblorg);

  try
    Ashint := strtoint(Ashchk);
  except
    db_coopbase.Disconnect;
    ShowMessage('서버연결에 실패했습니다.!! 프로그램을 종료합니다~~!!');
    Close;
    Application.Terminate;
    Exit;
  end;

  if tblorg.RecordCount = 0 then
  begin
    ShowMessage('해당 프로그램에 접근가능한 법인이 없습니다. 프로그램을 종료합니다!!!');
    Close;
    Application.Terminate;
    Exit;
  end;

  tblorg.IndexFieldNames := 'o_name;o_code';  //필드를 원하는 순서대로 정해줌.
  tblorg.Locate('o_code', org_code, []);
  edtorg.Text := tblorg.FieldByName('o_name').AsString;

  // 법인선택 버튼 클릭
  BitBtn2Click(BitBtn2);

  // ************************************************************************************

  //FormatSettings.DateSeparator = / (구분자)
//cms21_created_day := StrToDate('2004' + FormatSettings.DateSeparator + '12' + FormatSettings.DateSeparator + '31');
  cms21_unified_day := StrToDate('2004' + FormatSettings.DateSeparator + '09' + FormatSettings.DateSeparator + '30');
//cms21_unified_day_update := StrToDate('2004' + FormatSettings.DateSeparator + '09' + FormatSettings.DateSeparator + '30');

  // daytable_cre_uni_dro(일자별 테이블 생성, 통합, 삭제 기록)
  // tbl_name: 테이블명, a_day: 진행일, created_day: 최종생성일, unified_day: 최종통합일
  AshsQL := 'Select tbl_name,created_day,unified_day' + ' from daytable_cre_uni_dro' + ' Where tbl_name = "cms21_"' +
    ' Order by a_day Desc' + ' Limit 1';  //created_day 2018/10/28

  Ashchk := MySQL_Assign(db_coopbase, qrySql, AshsQL, qry_imsi);

  try
    Ashint := strtoint(Ashchk);
  except
    db_coopbase.Disconnect;
    ShowMessage('잠시 후 다시 시도하십시요!!! ERR:278');
    Close;
    Application.Terminate;
    Exit;
  end;


  if qry_imsi.RecordCount > 0 then
  begin
    //cms21_created_day := qry_imsi.FieldByName('created_day').AsDateTime;
    if FormatDateTime('yyyymmdd', qry_imsi.FieldByName('unified_day').AsDateTime) = '20041231' then
    begin
      AshsQL := 'Select Now() as ashdate';  // 실행결과 (2018-09-21 13:24:07)이런 형태로 출력됨.
      Ashchk := MySQL_Assign(db_coopbase, qrySql, AshsQL, qry_imsi);
    end
    else
    begin
      cms21_unified_day := qry_imsi.FieldByName('unified_day').AsDateTime;

    end;
  end;
  // ************************************************************************************
  // ************************************************************************************
  orders_created_day := StrToDate('2004' + FormatSettings.DateSeparator + '12' + FormatSettings.DateSeparator + '31');
  orders_unified_day := StrToDate('2004' + FormatSettings.DateSeparator + '09' + FormatSettings.DateSeparator + '30');


  //daytable_cre_uni_dro(일자별 테이블(생성,통합,삭제,기록))
  AshsQL := 'Select tbl_name,created_day,unified_day' + ' from daytable_cre_uni_dro' + ' Where tbl_name = "orders_"' +
    ' Order by a_day Desc' + ' Limit 1';
  Ashchk := MySQL_Assign(db_coopbase, qrySql, AshsQL, qry_imsi);

  try
    Ashint := strtoint(Ashchk);
  except
    db_coopbase.Disconnect;
    ShowMessage('잠시 후 다시 시도하십시요!!! ERR:312');
    Close;
    Application.Terminate;
    Exit;
  end;

  if qry_imsi.RecordCount > 0 then
  begin
    orders_created_day := qry_imsi.FieldByName('created_day').AsDateTime;
    if FormatDateTime('yyyymmdd', qry_imsi.FieldByName('unified_day').AsDateTime) = '20041231' then
    begin
      AshsQL := 'Select Now() as ashdate';  //현재시간(yyyy-mm-dd hh:mm:ss)
      Ashchk := MySQL_Assign(db_coopbase, qrySql, AshsQL, qry_imsi);

    end
    else
    begin
      orders_unified_day := qry_imsi.FieldByName('unified_day').AsDateTime;
    end;
  end;
  // ************************************************************************************

  //code(회계코드)테이블
  //fkind: 해당필드명(은행코드는 'bank' / 입금종류는 'kind')  //fval: 값  //fname: 항목이름
  AshsQL := 'Select fkind, fval, fname' + ' from code where fkind="bank"';
  Ashchk := MySQL_Assign(db_coopbase, qrySql, AshsQL, qryCode);

  try
    Ashint := strtoint(Ashchk);
  except
    db_coopbase.Disconnect;
    ShowMessage('서버연결에 실패했습니다.!! ( code ) Err : 381');
    Exit;
  end;

  // 질문 ↓밑에 2줄 무슨말? 1001yik

  // 전표처리시 연결매장코드에 전표분개해야함
  // maejang 조합코드랑 연결되어 있다..

//20181011yik 주석처리●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●

// icoop_ab(조합법인구분) -> B:조합법인 A:그룹법인
// A(그룹법인)만 불러옴
// EX) A049-(주)클러스터지원그룹, 0023-(주)쿱엔지니어링, 0039-(주)씨엘씨

//  AshsQL := 'Select m_code, maejang_code' + ' from membership as ship where length(maejang_code)=4' +
//    ' AND o_code NOT IN (SELECT o_code FROM org WHERE icoop_ab="B")';
//  // 수수료부과지점연결된자료
//  Ashchk := MySQL_Assign(db_coopbase, qrySql, AshsQL, qrymembership);
//
//  try
//    Ashint := strtoint(Ashchk);
//  except
//    db_coopbase.Disconnect;
//    ShowMessage('서버연결에 실패했습니다.!! ( membership ) Err : 390');
//    Exit;
//  end;
//
//  Ashm_codeList := '"........."';
//  qrymembership.first;
//  while not qrymembership.eof do
//  begin
//    //바로 위 [qrymembership]에서 조회한 m_code들의 List.
//    Ashm_codeList := Ashm_codeList + ',"' + qrymembership.FieldByName('m_code').AsString + '"';
//    qrymembership.Next;
//  end;
//●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●

  //johap(조합정보테이블)
  //j_code:조합코드, j_name:조합명, c_code:소속센터, o_code:조직코드
  AshsQL := 'SELECT a.j_code, a.j_name, a.c_code, a.o_code, b.o_name' + ' FROM johap AS a' + ' JOIN org AS b' + ' ON a.o_code=b.o_code';
  Ashchk := MySQL_Assign(db_coopbase, qrySql, AshsQL, qryjohap);

  try
    Ashint := strtoint(Ashchk);
  except
    db_coopbase.Disconnect;
    ShowMessage('서버연결에 실패했습니다.!! ( johap ) Err : 406');
    Exit;
  end;
  if mpst_code = 'X18020001' then
    Memo2.Visible := True;

  Set_MainPosition(Form1);  //초기화면 위치 설정
  db_coopbase.Disconnect;
end;

procedure TForm1.FormShow(Sender: TObject);
begin

  Label5.Caption := ' ';
  Label6.Caption := ' ';
  Label7.Caption := ' ';

  edtFs_day.Date := Now; // 인출일..
  edtFs_day.SetFocus;
  rg1.ItemIndex  := 0; // 전표생성옵션..
  Label3.Caption := '인출일';

end;


procedure TForm1.BitBtn2Click(Sender: TObject);
var
  AshsQL, Ashchk: string;
  Ashint: Integer;
begin
  // 법인선택
  if Trim(edtorg.Text) = '' then
  begin
    edtorg.SetFocus;
    Exit;
  end;

  Screen.Cursor := crHourGlass;

  org_code := tblorg.FieldByName('o_code').AsString;
  edtorg.Text := tblorg.FieldByName('o_name').AsString;

  // center: 센터테이블
  // R은 '반품센터' ex)0010:풀무채소위원회 001R:반품센타[0010]
  AshsQL := 'Select c_code,c_name' + ' from center' + ' Where c_code Not like "%R%"';
  Ashchk := MySQL_Assign(db_coopbase, qrySql, AshsQL, qrycenter);
//  memo2.Lines.Add(AshsQL);

  try
    Ashint := strtoint(Ashchk);
  except
    db_coopbase.Disconnect;
    ShowMessage('서버연결에 실패했습니다.!! ( center ) Err : 460');
    Exit;
  end;

  {
  // 조합열기
  // johap: 조합정보
  // staff_johap: 직원의 조합 접근 권한정리
  // reg_num: 사업장번호

  // ' and staff_johap.m_code="' + mpst_code + '"' +  나중에 mpst_code로 다시 수정해야 함. 20181017yik
  AshsQL := 'Select johap.j_code, johap.j_name, johap.c_code, johap.o_code, johap.reg_num' + ' from johap, staff_johap'
    + ' Where johap.j_name <> "" ' + ' and johap.j_code = staff_johap.j_code' + ' and staff_johap.p_ab="A"' +
    ' and staff_johap.m_code="H11074064"' + ' and johap.o_code="' + org_code + '"' + ' and staff_johap.o_code="'
    + org_code + '"' + ' order by johap.j_name, johap.j_code'; //staff_johap.p_ab="A" (접근가능여부)
  }

  // [윤일근테스트]위해서 20181017yik
  if mpst_code <> 'X18020001' then
  begin
    AshsQL := 'Select johap.j_code, johap.j_name, johap.c_code, johap.o_code, johap.reg_num' + ' from johap, staff_johap'
    + ' Where johap.j_name <> "" ' + ' and johap.j_code = staff_johap.j_code' + ' and staff_johap.p_ab="A"' +
    ' and staff_johap.m_code="' + mpst_code + '"' + ' and johap.o_code="' + org_code + '"' + ' and staff_johap.o_code="'
    + org_code + '"' + ' order by johap.j_name, johap.j_code'; //staff_johap.p_ab="A" (접근가능여부)
  end
  else
  begin
    AshsQL := 'Select johap.j_code, johap.j_name, johap.c_code, johap.o_code, johap.reg_num' + ' from johap, staff_johap'
    + ' Where johap.j_name <> "" ' + ' and johap.j_code = staff_johap.j_code' + ' and staff_johap.p_ab="A"' +
    ' and staff_johap.m_code="H11074064"' + ' and johap.o_code="' + org_code + '"' + ' and staff_johap.o_code="'
    + org_code + '"' + ' order by johap.j_name, johap.j_code'; //staff_johap.p_ab="A" (접근가능여부)
//ShowMessage('이거');
  end;


  Ashchk := MySQL_Assign(db_coopbase, qrySql, AshsQL, tbljohap);
//  Memo2.Lines.Add(AshsQL);
  try
    Ashint := strtoint(Ashchk);
  except
    db_coopbase.Disconnect;
    ShowMessage('서버연결에 실패하였습니다!!! (Johap:476)');
    Exit;
  end;

  tbljohap.Locate('j_code', j_code, []);
  edtjname.Text := tbljohap.FieldByName('j_name').AsString;

  // 조합원명
  // members: 조합원테이블
  AshsQL := 'Select m_code,m_name' + ' from members' + ' Where j_code = "' + tbljohap.FieldByName('j_code').AsString + '"';
  Ashchk := MySQL_Assign(db_coopbase, qrySql, AshsQL, qrymembers);
//  Memo2.Lines.Add(AshsQL);

  try
    Ashint := strtoint(Ashchk);
  except
    db_coopbase.Disconnect;
    ShowMessage('서버연결에 실패했습니다.!! ( members ) Err : 487');
    Exit;
  end;

  case rg1.ItemIndex of
    0:
      begin
        Label3.Caption := '인출일';
        Label6.Caption := '';
      end;
    1:
      begin
        Label3.Caption := '출고일';
        if org_code = 'A049' then //클러스터지원그룹
        begin
          Label6.Caption := '물품명 : POS유지보수_멀티매장(10003CD100),복합매장(10002CD100),일반매장(10001CD100)'
        end
        else if org_code = '0023' then //쿱엔지니어링
        begin
          Label6.Caption := '물품명 : A/S*유지보수(0000200000),냉장냉동자재*판넬(0000500000)';
        end
        else if org_code ='0039' then //씨엘씨
        begin
          Label6.Caption := '물품명 : 렌탈비(8847300000)'; //20181018yik
        end;
      end;
  end;

  edtorg.Enabled := False;
  BitBtn2.Enabled := False;
  BitBtn3.Enabled := True;

  db_coopbase.Disconnect;

  Form1.Caption := Application.Title + '[작업영역: ' + edtorg.Text + ']';
  // Application.Title

  Screen.Cursor := crDefault;
  db_coopbase.Disconnect;
end;

// 법인선택 취소
procedure TForm1.BitBtn3Click(Sender: TObject);
begin
  // 법인취소
  if (tblCms.Active) then
    tblCms.Close;
  if (tblorders.Active) then
    tblorders.Close;

  pb1.Position := 0;
  org_code := '';
  c_code := '';
  j_code := '';
  edtjname.Text := '';

  case rg1.ItemIndex of
    0:
      begin
        Label3.Caption := '인출일';
        Label6.Caption := '';
      end;
    1:
      begin
        Label3.Caption := '출고일';
        if org_code = 'A049' then //클러스터지원그룹
        begin
          Label6.Caption := '물품명 : POS유지보수_멀티매장(10003CD100),복합매장(10002CD100),일반매장(10001CD100)'
        end
        else if org_code = '0023' then //쿱엔지니어링
        begin
          Label6.Caption := '물품명 : A/S*유지보수(0000200000),냉장냉동자재*판넬(0000500000)';
        end
        else if org_code ='0039' then //씨엘씨
        begin
          Label6.Caption := '물품명 : 렌탈비(8847300000)'; //20181018yik
        end;
      end;
  end;

  Label5.Caption := '';
  Label7.Caption := '';

  BitBtn3.Enabled := False;
  BitBtn2.Enabled := True;
  edtorg.Enabled := True;

  Form1.Caption := Application.Title + '[작업영역: ]'; // Application.Title

  if edtorg.Enabled then
    edtorg.SetFocus;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if (Shift = [ssAlt]) or (Shift = [ssCtrl]) then
    Exit;

  case Key of
    VK_F4:
      begin
        if btnSave.Enabled then
          btnSaveClick(btnSave);
        Key := 0;
      end;
    VK_F9:
      begin
        if btnSearch.Enabled then
          btnSearchClick(btnSearch);
        Key := 0;
      end;
    VK_F11:
      begin
        if btnExcel.Enabled then
          btnExcelClick(btnExcel);
        Key := 0;
      end;

  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  db_coopbase.Disconnect;
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

procedure TForm1.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//조회
procedure TForm1.btnSearchClick(Sender: TObject);
var
  AshsQL, AshSubSQL, AshSubSQL2: string;
  i: Integer;
  AshSum: real;
  Ashchk: string;
  Ashint: Integer;
begin
  // (주)쿱냉동0023-2300-2300
  // (주)친환경식품클러스터 A049-9040-9040
  // cms21_yyyymmdd 에서 자료추출. 작업자가 결과처리를 해주면 r_ab=B 수신으로 된다.
  // (주)씨엘씨 추가 0039-3910-3910   // 2018-10-22 cug=2076142 yik
  if edtorg.Text = '' then
    Exit;

  if edtjname.Text = '' then
    Exit;

  if rg1.ItemIndex = -1 then
    Exit;

  Screen.Cursor := crHourGlass;
  cxGrid1DBTableView1.DataController.DataSource := nil;

  // ★★★★★★Form2의 조회화면(수수료부과지점조회)★★★★★★
  // membership(조합원),members(배송관련조합원),johap(조합정보)테이블
  AshsQL := 'Select membership.m_code, members.m_name, membership.maejang_code, johap.j_name' +
    ' from membership, members, johap' + ' Where membership.m_code=members.m_code' +
    ' and membership.maejang_code=johap.j_code' + ' and members.j_code="' + tbljohap.FieldByName('j_code').AsString +
    '"' + ' and length(membership.maejang_code)=4'; // 매장코드는4자리
  Ashchk := MySQL_Assign(db_coopbase, qrySql, AshsQL, tblmembership);
//Memo2.Lines.Add(AshsQL);

  try
    Ashint := strtoint(Ashchk);
  except
    db_coopbase.Disconnect;
    ShowMessage('수수료부과지점 연결시 접속이 원활치 않습니다. 지속적으로 발생되면 전산실에 문의해 주세요!!! err:418');
    Exit;
  end;

//  // 수수료 부과된 매장만 보기..
//  AshSubSQL := '';
//  if chk1.Checked then //chk1:[수수료부과지점]연결된 자료만 보기 checkbox
//                       //Ashm_codeList: FormCreate에서 준비한 m_code(조합원코드)리스트 (조합법인이 아닌 -> 그룹법인만)
//    AshSubSQL := ' and a.m_code in (' + Ashm_codeList + ')';


  // 20181011yik Ashm_codeList사용x 이걸로 대체
  // cms21테이블과 membership m_code로 join 그리고 maejang_code로 list해결
  // 수수료 부과된 매장만 보기..
  AshSubSQL := '';
  if chk1.Checked then   //chk1:[수수료부과지점]연결된 자료만 보기 checkbox
    AshSubSQL := ' and length(b.maejang_code)=4 and b.maejang_code <> "" ';


  case rg1.ItemIndex of // 전표생성옵션
    0: // 인출일
       // 신청금액이 아닌 출금액으로 반영시켜야 한다. 2012-10-19 s_money --> r_money로 변경함!!
      begin
        if StrToDate(DateToStr(edtFs_day.Date)) > cms21_unified_day then
        begin
          // cms21_yyyyyyyy(cms[일자]별 출금신청 테이블)(as a)
          // members(배송관련 조합원 테이블)(as b)
          // sno(일련번호),m_code(대상자),num(순번 : ★승인된 계좌 번호),s_money(신청금액), r_money(출금금액),kind(출금종류),bank(은행명), r_ab(수신여부)
          AshsQL := 'Select a.sno, a.m_code, (SELECT m_name from members where m_code=a.m_code) as m_name,' +
            ' a.num, a.j_code, a.c_code, a.s_money, a.r_money, a.kind, a.bank, a.r_ab, b.maejang_code' + ' From cms21_' +
            FormatDateTime('yyyymmdd', edtFs_day.Date) + ' as a' + ' join membership as b' + ' on a.m_code=b.m_code' + ' Where a.s_day = "' +
            FormatDateTime('yyyy-mm-dd', edtFs_day.Date) + '"' + ' and a.j_code = "' + tbljohap.FieldByName('j_code').AsString +
            '"' + ' and b.o_code NOT IN (SELECT o_code FROM org WHERE icoop_ab="B")' + AshSubSQL;
          if mpst_code <> 'X18020001' then
            AshsQL := AshsQL + ' and a.r_ab = "B"'; // 수신된것만(r_ab:수신여부[A:미수신/B:수신])
        end
        else
        begin
          // cms21_yyyy(cms일자별 출금신청 [년도] 통합 테이블)(as a)
          AshsQL := 'Select a.sno, a.m_code, (SELECT m_name from members where m_code=a.m_code) as m_name,' +
            ' a.num, a.j_code, a.c_code, a.s_money, a.r_money, a.kind, a.bank, a.r_ab, b.maejang_code' + ' From cms21_' +
            FormatDateTime('yyyy', edtFs_day.Date) + ' as a' + ' join membership as b' + ' on a.m_code=b.m_code' + ' Where a.s_day = "' +
            FormatDateTime('yyyy-mm-dd', edtFs_day.Date) + '"' + ' and a.j_code = "' + tbljohap.FieldByName('j_code').AsString +
            '"' + ' and b.o_code NOT IN (SELECT o_code FROM org WHERE icoop_ab="B")' + AshSubSQL;
          if mpst_code <> 'X18020001' then
            AshsQL := AshsQL + ' and a.r_ab = "B"'; // 수신된것만(r_ab:수신여부[A:미수신/B:수신])
        end;
        // 확인필요..
        Ashchk := MySQL_Assign(db_coopbase, qrySql, AshsQL, qry_imsi);
Memo2.Lines.Add(AshsQL);


        try
          Ashint := strtoint(Ashchk);
          if Ashint = 0 then
          begin
            ShowMessage('선택한 날짜 또는 선택한 지점에 자료가 없습니다. 확인하세요!!! msg:644');
            Screen.Cursor := crDefault;
            edtFs_day.SetFocus;
            Exit;
          end;
        except
          db_coopbase.Disconnect;
          ShowMessage('연결에 실패했습니다. 재조회 해보시고 전산팀에 문의하세요!! ( cms21_ ) Err : 638');
          Screen.Cursor := crDefault;
          Exit;
        end;

        cxGrid1DBTableView1.DataController.DataSource := nil; //연결된 datasource끊기
        NoCalBool := True;
        tblCms.Close;
        tblCms.LoadFromDataSet(qry_imsi, 0, lmAppend);

        NoCalBool := False;
        tblCms.SortOnFields('m_code', True, False);

      end;
    1: // 출고일 orders_yyyymmdd  //물품코드지정됨
      begin
        if org_code = 'A049' then // [CMG]
        begin
          // CUG-1308809 포스 유지로 물품코드 새로 생성 2016-07-11 수정
          // 20181012 yik (출고)수수료내용
          // POS 유지보수_멀티매장, POS유지보수_복합매장, POS유지보수_일반매장...
          AshSubSQL2 := ' and a.g_code in ("10003CD100","10002CD100","10001CD100", "10010CD100", "10009CD100" ,"10008CD100" ,"10007CD100" ,"10006CD100")'
        end
        else if org_code ='0023' then // [쿱엔지니어링] 20181012yik
        begin
          // if org_code='0023' then // 2014-01-17막음.
          // A/S*유지보수(고정), 냉장냉동자재*판넬
          AshSubSQL2 := ' and a.g_code in ("0000200000", "0000500000")';
        end
        else if org_code ='0039' then // [씨엘씨]20181015yik
        begin
          //[CUG-1286098:47]씨엘씨 수수료 내용(g_code) 20181016yik
          //8847300000: 렌탈비
          AshSubSQL2 := ' and a.g_code in ("8847300000")';
        end;


        if StrToDate(DateToStr(edtFs_day.Date)) > orders_unified_day then
        begin
          //orders_yyyyyyyy(일자별 주문 테이블)
          AshsQL := 'Select a.m_code, (SELECT m_name from members where m_code=a.m_code) as m_name,' +
            ' a.g_code,a.s_day,a.a_day,a.c_code,a.cost, b.maejang_code' + ' from orders_' + FormatDateTime('yyyymmdd', edtFs_day.Date) + ' as a' +
            ' join membership as b' + ' on a.m_code=b.m_code' + ' Where a.s_day = "' + FormatDateTime('yyyy-mm-dd', edtFs_day.Date) + '"' + ' and a.a_day = "' +
            FormatDateTime('yyyy-mm-dd', edtFs_day.Date) + '"' + AshSubSQL2 // 물품코드
            + AshSubSQL + ' and b.o_code NOT IN (SELECT o_code FROM org WHERE icoop_ab="B")'
            + ' and a.c_code = "' + tbljohap.FieldByName('j_code').AsString + '"';
        end
        else
        begin
          //orders_yyyy테이블(년도별 주문 테이블)
          AshsQL := 'Select a.m_code, (SELECT m_name from members where m_code=a.m_code) as m_name,' +
            'a.g_code,a.s_day,a.a_day,a.c_code,a.cost, b.maejang_code' + ' from orders_' + FormatDateTime('yyyy', edtFs_day.Date) + ' as a' +
            ' join membership as b' + ' on a.m_code=b.m_code' + ' Where a.s_day = "' + FormatDateTime('yyyy-mm-dd', edtFs_day.Date) + '"' + ' and a.a_day = "' +
            FormatDateTime('yyyy-mm-dd', edtFs_day.Date) + '"' + AshSubSQL2 // 물품코드
            + AshSubSQL + ' and b.o_code NOT IN (SELECT o_code FROM org WHERE icoop_ab="B")'
            + ' and a.c_code = "' + tbljohap.FieldByName('j_code').AsString + '"';
        end;
        // 확인필요..
        Ashchk := MySQL_Assign(db_coopbase, qrySql, AshsQL, qry_imsi);
Memo2.Lines.Add(AshsQL);

        try
          Ashint := strtoint(Ashchk);
          if Ashint = 0 then
          begin
            ShowMessage('선택한 날짜 또는 선택한 지점에 자료가 없습니다. 확인하세요!!! msg:688');
            Screen.Cursor := crDefault;
            edtFs_day.SetFocus;
            Exit;
          end;
        except
          db_coopbase.Disconnect;
          ShowMessage('연결에 실패했습니다. 재조회 해보시고 전산팀에 문의하세요!! ( orders_ ) Err : 682');
          Screen.Cursor := crDefault;
          Exit;
        end;

        cxGrid1DBTableView1.DataController.DataSource := nil;
        NoCalBool := True;
//      NoScrollBool := True;
        tblorders.Close;
        tblorders.LoadFromDataSet(qry_imsi, 0, lmAppend);

        NoCalBool := False;
        tblorders.first;
//      NoScrollBool := False;

      end;
  end; // case~end

  // edit1.text := AshSQL;

  AshSum := 0; //총액변수
  if rg1.ItemIndex = 0 then //총액구하기위해서 (우측상단에 Label7-caption)
  begin
    tblCms.first;
    while not tblCms.eof do
    begin
      AshSum := AshSum + tblCms.FieldByName('r_money').AsFloat; //r_money(출금금액)
      tblCms.Next;
    end;
  end
  else
  begin
    tblorders.first;
    while not tblorders.eof do
    begin
      AshSum := AshSum + tblorders.FieldByName('cost').AsFloat; //cost(실가격)
      tblorders.Next;
    end;
  end;

  if rg1.ItemIndex = 0 then
  begin
    cxGrid1DBTableView1.DataController.DataSource := dtstblCms; //★★★ 여기서 연결해준다
    tblCms.first;
    Label5.Caption := IntToStr(tblCms.RecordCount) + ' 건';
  end
  else
  begin
    cxGrid1DBTableView1.DataController.DataSource := dtstblorders;  //★★★ 여기서 연결해준다
    tblorders.first;
    Label5.Caption := IntToStr(tblorders.RecordCount) + ' 건';
  end;

  Label7.Caption := '총액 : ' + FormatFloat('#,0', AshSum) + '';

  Screen.Cursor := crDefault;
  db_coopbase.Disconnect;
end;

// 일괄반영
procedure TForm1.btnSaveClick(Sender: TObject);
var
  AshsQL, Ashm_code, Ashc_code, AshStr, Ash_reg_num: string;
  AshMsg, Ashmemo, AshCash_ab: string;
  Ashamount, AshDamt, AshEamt: real;

  Ash_ab, AshSQL1, Ash_ab_name, Ash_mm, Ash_cost_now: string;
  Ashv_amount, Ashvat: real; // 선급부가세 : 미리 납부한 부가세
  Ashchk: string;
  Ashint: Integer;
  reg_num, reg_name: string;
  jcode_gubun: string;               // 신규지점구분 20181102yik   ->
  qry_jcode, result_jcode: string;   // 세목101인지점 20181218yik  -> 둘 다 안씀 20190305yik

begin
  if edtorg.Text = '' then
    Exit;

  if edtjname.Text = '' then
    Exit;

  if rg1.ItemIndex = 0 then
    pb1.Max := tblCms.RecordCount
  else
    pb1.Max := tblorders.RecordCount;

  // 2012-11-09 처리당일로 now로 처리한 것을 각각 출금일, 출고일로 반영해달라는 요청으로 변경함
  // cug=563919 28번댓글  lsj 수정

  // yik회계용어정리
  // 계정 : 기업회계에 있어서 기업 재산의 모든 변동을 파악하여 기록하고 계산하기 위한 특수 형식 ( 원장(A4용지)에 써져있는 목록 )
  // 계정원장 : 계정을 총괄하여 관리하고 기록하는 문서

//AshTDate := FormatDateTime('yyyy-mm-dd', edtFs_day.Date); // 계정원장 처리일

  AshCDate      := FormatDateTime('yyyy-mm-dd', edtFs_day.Date);  // 계정원장 반영일   : (save_cost_ldg에서사용)cost_ldg테이블의 i_day(실제 입출금 날짜)에 반영
  Ash_cost_now  := FormatDateTime('yyyy-mm-dd', Now());           // 계정원장 반영일   : (쿼리에서사용)cost_ldg테이블의 a_day(입력일)에 반영
  Ash_Cost_date := FormatDateTime('yyyy-mm-dd', Now());           // 제반입출금 처리일 : (테이블에 insert/쿼리에서사용) a_day(입력일자)(실제반영일자)(=원장에 입력일자) insert -> cost_ldg테이블에 insert

  pb1.Position  := 0;
  Screen.Cursor := crHourGlass;

  if rg1.ItemIndex = 0 then // 인출일
  begin
    Ash_ab := 'A';
    Ash_ab_name := 'CMS'
  end
  else if rg1.ItemIndex = 1 then // 출고일
  begin
    Ash_ab := 'B';
    Ash_ab_name := '출고'
  end;

  // yik회계용어정리
  // 원장 : 거래를 계정별로 기록/계산하는 장부 ( 작성할 [A4용지]라고 생각하면 됨. )

  // 원장에 반영유무 체크하기 테이블별도로 만듦
  // acc_yn : 수수료처리유무
  // i_day(CMS 또는 출고날짜), cms_orders_ab(cms/출고의 유무)
  AshsQL := 'select i_day, j_code, cms_orders_ab' + ' from acc_yn' + ' Where i_day="' +
    FormatDateTime('yyyy-mm-dd', edtFs_day.Date) + '"' + ' and j_code="' + tbljohap.FieldByName('j_code').AsString + '"'
    + ' and cms_orders_ab="' + Ash_ab + '"';

  Ashchk := MySQL_Assign(db_coopbase, qrySql, AshsQL, qry_imsi);
//  Memo2.Lines.Add(AshsQL);
//  exit;

  try
    Ashint := strtoint(Ashchk);
  except
    db_coopbase.Disconnect;
    ShowMessage('연결에러입니다. 메세지가 지속적으로 나올때 전산실로 문의바랍니다.!!! ( acc_yn ) Err : 1052');
    Screen.Cursor := crDefault;
    Exit;
  end;

  if qry_imsi.RecordCount <> 0 then
  begin
    if MessageDlg('이미 반영된 일자 입니다!!. 이중반영될수도 있습니다. 그래도 처리하시겠습니까???', mtConfirmation, [mbNO, mbOK], 0) <> mrOK then
    begin
      Screen.Cursor := crDefault;
      Exit;
    end;

    // 그래도 처리하면 update
    // acc_yn 수수료 처리유무 테이블..

    // CMS : A  / 출고 : B
    // CMS 입금일자 또는 출금날짜

    // history구성
    AshsQL := 'Update acc_yn' + ' Set' + ' etc_memo="작업자에의해 재처리함/' + FormatDateTime('yyyy-mm-dd', Now()) + '"' +
      ',mpst_code = "' + mpst_code + '"' + ',p_day = now()' + ',chk_svr = "' + IntToStr(svrconn) + '"' +
      ' Where i_day = "' + FormatDateTime('yyyy-mm-dd', edtFs_day.Date) + '"'
      + ' and j_code = "' + tbljohap.FieldByName('j_code').AsString + '"' + ' and cms_orders_ab= "' + Ash_ab + '"';

    AshSQL1 := 'Update acc_yn' + ' Set' + ' etc_memo="작업자에의해 재처리함/' + FormatDateTime('yyyy-mm-dd', Now()) + '"' +
      ',mpst_code = "' + mpst_code + '"' + ',p_day = now()' + ',chk_svr = "' + IntToStr(svrconn) + '"' +
      ',history = concat(history,"' + SQLToHistory(AshsQL) + '")' + ' Where i_day = "' +
      FormatDateTime('yyyy-mm-dd', edtFs_day.Date) + '"' + ' and j_code = "' + tbljohap.FieldByName('j_code').AsString +
      '"' + ' and cms_orders_ab= "' + Ash_ab + '"';

    Ashchk := MySQL_UpDel(db_coopbase, qrySql, AshSQL1);

    try
      Ashint := strtoint(Ashchk);
    except
      db_coopbase.Disconnect;
      ShowMessage('중복저장하면서 서버연결에 실패했습니다.!!! Err : 1089');
      Screen.Cursor := crDefault;
      Exit;
    end;
  end
  else // 하나도 없으면 처리유무테이블에 'insert' 하고 분개시작한다...
       // yik회계용어정리
       // 분개 : 부기에서, 거래 내용을 차변과 대변으로 나누어 적는 일(계정계좌에 기입하기 전에 누락방지를 위하여)
       // 부기 : 자산, 자본, 부채의 출납, 변동 등을 밝히는 기장법
  begin
    //history구성
    AshsQL := 'Insert Into acc_yn' + ' (i_day, j_code, cms_orders_ab, etc_memo, mpst_code, p_day, chk_svr)' + ' Values'
      + ' ("' + FormatDateTime('yyyy-mm-dd', edtFs_day.Date) + '"' + ',"' + tbljohap.FieldByName('j_code').AsString +
      '"' + ',"' + Ash_ab + '"' + ',"' + Ash_ab_name + '-' + Label5.Caption + '반영"' + ',"' + mpst_code + '"' + ',Now()'
      + ',"' + IntToStr(svrconn) + '")';

    AshSQL1 := 'Insert Into acc_yn' + ' (i_day, j_code, cms_orders_ab, etc_memo, mpst_code, p_day, chk_svr, history)' +
      ' Values' + ' ("' + FormatDateTime('yyyy-mm-dd', edtFs_day.Date) + '"' + ',"' + tbljohap.FieldByName('j_code')
      .AsString + '"' + ',"' + Ash_ab + '"' + ',"' + Ash_ab_name + '-' + Label5.Caption + '반영"' + ',"' + mpst_code + '"'
      + ',Now()' + ',"' + IntToStr(svrconn) + '"' + ',"' + SQLToHistory(AshsQL) + '")';

    Ashchk := MySQL_UpDel(db_coopbase, qrySql, AshSQL1);

    try
      Ashint := strtoint(Ashchk);
    except
      db_coopbase.Disconnect;
      ShowMessage('원장처리유무 등록시 에러!!! 전산실에 문의하세요~~ Err : 1116');
      Screen.Cursor := crDefault;
      Exit;
    end;
  end;

  // acc_yn(수수료 처리여부 완료..)
  case rg1.ItemIndex of
    0: // CMS인출자료반영
      begin
//showmessage('CMS인출자료반영 0 ');
        AshStr := 'CMS인출 자료 중 수신 상태이고,' + #10#13 + #10#13 + '매장연결지점코드가 있는 출금액이 제반에 반영됩니다!!' + #10#13 + #10#13 + #10#13 +
          '수수료부과지점연결코드가 없으면 반영되지 않습니다.' + #10#13 + #10#13 + '한번 더 확인해 보시기 바랍니다.' + #10#13 + #10#13 +
          '제반의 [처리일 과 반영일 = 출고일,출금일] 로 반영합니다.' + #10#13 + #10#13 + #10#13 + '정말로 진행하시겠습니까???';
        if MessageDlg(AshStr, mtConfirmation, [mbNO, mbOK], 0) <> mrOK then
        begin
          Screen.Cursor := crDefault;
          Exit;
        end;

        tblCms.first;
        while not tblCms.eof do
        begin
          pb1.Position := pb1.Position + 1;

          pb1.Refresh;  // 게이지를 초기화해주는게 아니고, 렉(?)같은거 걸리지 말라고 리프레쉬해주는 것

          Ashm_code := tblCms.FieldByName('m_code').AsString;       // 거래처코드
          Ashj_code := tblCms.FieldByName('maejang_code').AsString; // 매장코드
          Ashc_code := tblCms.FieldByName('c_code1').AsString;      // 센터코드
//        Asho_code := tblCms.FieldByName('o_code').AsString;       // 법인코드 20181030yik주석처리
          Ashamount := tblCms.FieldByName('r_money').AsFloat;       // 출금금액
//ShowMessage('ashj_code :' + Ashj_code);


          if tblCms.FieldByName('r_ab').AsString <> 'B' then // '수신상태(B)'가 아니면 넘어간다
          begin
            tblCms.Next;
            Continue; //아래의 문장을 실행하지 않고, 반복조건문으로 다시 올라감
          end;

          if tblCms.FieldByName('maejang_code').AsString = '' then // '연결매장코드' 없으면 넘어간다
          begin
            tblCms.Next;
            Continue;
          end;

          { 20181030yik주석처리
          if tblCms.FieldByName('o_code').AsString = '' then // '법인코드' 없으면 넘어간다.
          begin
            tblCms.Next;
            Continue;
          end;
          }

          if tblCms.FieldByName('r_money').AsFloat = 0 then // '출금액' 없으면 넘어간다.
          begin
            tblCms.Next;
            Continue;
          end;


          //* 계정과목의 하위 개념이 (계정)세목이다.yik
          Dacntd := ''; // 차변 cost_ldg테이블의 d_code(계정과목)yik
          Dacnte := ''; // 차변 cost_ldg테이블의 e_code(세목)yik
          Cacntd := ''; // 대변 cost_ldg테이블의 d_code(계정과목)yik
          Cacnte := ''; // 대변 cost_ldg테이블의 e_code(세목)yik
          AshEamt := 0; // ★ 실제로 save_cost_ldg에선 사용x yik
          AshDamt := 0; // 과목잔액,세목잔액
          AshCash_ab := 'A'; // ★ 실제로 save_cost_ldg에선 사용x yik
          Ash_reg_num := ''; // 사업장번호 [ ex)aaa-aa-aaaaa ]

          //yik회계용어정리
          // 대체 ①계정금액을 다른 계정에 옮기는 경우
          //      ② (대체전표)현금수지가 따르지 않는 거래가 발생한 때 기입하는 전표이다.
          //         대체전표 차변에 입금거래를, 대변에 출금거래를 기입한다
          // 적요 : 요점을 뽑아 적음or기록

          Ash_mm := ''; // 이전 달

          //DATE_SUB: 기준 날짜에 입력된 기간만큼을 빼는 함수(MYSQL) ＊DATE_SUB(기준날짜, INTERVAL)
          //[test결과 : 2018-09-30 = 08 , 2018-08-01 = 07]처럼 (출금) 이전 달을 계산해주기 위해서
          //CUG(1354925)(2016-10-12일): 6번 댓글(내용 : 9월인출은 8월분수수료 이기때문에 '8월(이전달)수수료'로 뿌려져야함)
          AshsQL := 'SELECT SUBSTRING(DATE_SUB("' + FormatDateTime('yyyy-mm-dd', edtFs_day.Date) +
            '", INTERVAL 1 MONTH  ) ,6,2) AS mm_month';
          Ashchk := MySQL_Assign(db_coopbase, qrySql, AshsQL, qry_imsi);
//        Memo2.Lines.Add(AshsQL);
//        exit;

          Ash_mm := qry_imsi.FieldByName('mm_month').AsString; // CUG( 1354925)- 2016-10-12일 적용

          // 출금일때 적요
          if tbljohap.FieldByName('j_code').AsString = '2300' then // 쿱엔지니어링
          begin
            Ash_mm := FormatDateTime('mm', edtFs_day.Date); //쿱엔지니어링은 이전 달로 안해주나? ★질문 yik
            Ash_reg_num := Trim(tbljohap.FieldByName('reg_num').AsString); // CUG(563919)-140번 2016-09-05 반영
            Ash_reg_num := copy(Ash_reg_num, 1, 3) + '-' + copy(Ash_reg_num, 4, 2) + '-' + copy(Ash_reg_num, 6, 5); //사업장번호 형태 갖추기 위해서yik
            reg_num := Ash_reg_num;
            reg_name := tblorg.FieldByName('o_name').AsString;

            Comment := Ash_mm + '월 CMS출금자동전표/냉장냉동기유지보수료';  //수수료내용
          end
          else if tbljohap.FieldByName('j_code').AsString = '9040' then // (주)클러스터지원그룹CMG
          begin
            Ash_reg_num := Trim(tbljohap.FieldByName('reg_num').AsString); // CUG(1354925) 2016-09-05 반영
            Ash_reg_num := copy(Ash_reg_num, 1, 3) + '-' + copy(Ash_reg_num, 4, 2) + '-' + copy(Ash_reg_num, 6, 5);

            Comment := Ash_reg_num + ' / ' + Ash_mm + '월 CMS출금자동전표/(' + tblorg.FieldByName('o_name').AsString +
              ')/포스유지보수료'; //수수료내용
          end
          else if (tbljohap.FieldByName('j_code').AsString = '3910') or (tbljohap.FieldByName('j_code').AsString = '3920') then //씨엘씨 본점(3910) / 지점(3920) 20181026yik
          begin
            //20181012yik임의로 일단 내용 복붙해둠.
            Ash_reg_num := Trim(tbljohap.FieldByName('reg_num').AsString);
            Ash_reg_num := copy(Ash_reg_num, 1, 3) + '-' + copy(Ash_reg_num, 4, 2) + '-' + copy(Ash_reg_num, 6, 5);
            //20181101yik 제반입출금처리(사업자번호,상호(법인명)) CUG-1286098:54
            reg_num := Ash_reg_num;
            reg_name := tblorg.FieldByName('o_name').AsString;

            //comment:적요
            Comment := Ash_mm + '월 CMS출금자동전표/ ' + tblorg.FieldByName('o_name').AsString +
              ' 차량렌탈비'; //20181016yik ( 201807부터 방제사업 X ), [cug-1286098:47]
          end;


          // 전표번호: I을 추가해야함.
          Ac_num := 'I' + '-' + FormatDateTime('yyyymmdd', Now()) + '-' + Ashj_code; // 20자리중 16자리

          // cost_ldg(비용전표처리테이블) snum(일련번호)값
          AshSnum := '1';

          //cost_ldg(비용전표처리)테이블
          //a_day(입력일자), j_code(처리소속(조합): 입금처리 당시의 소속. 각 회계단위(조합)으로 처리한다.)
          AshsQL := 'Select max(snum) as snum' + ' from cost_ldg' + ' Where a_day="' + Ash_cost_now + '"' +
            ' and j_code ="' + Ashj_code + '"';
          Ashchk := MySQL_Assign(db_coopbase, qrySql, AshsQL, qry_imsi);

          try
            Ashint := strtoint(Ashchk);
          except
            db_coopbase.Disconnect;
            ShowMessage('연결에 실패했습니다!! ( cost_ldg ) Err : 1257');
            Screen.Cursor := crDefault;
            Exit;
          end;

          if qry_imsi.RecordCount <> 0 then
            AshSnum := IntToStr(qry_imsi.FieldByName('snum').AsInteger + 1);

          // yik회계용어정리
          // 제예금 : 회계상에서 당좌예금 이외의 예금을 처리하는 통괄계정.(금액이 적거나 거래빈도수가 적을 때 이 계정으로 처리한다)

          // cms인출은 세개 법인(클러스터지원그룹/쿱엔지니어링/씨엘씨) 차.대 가 동일함

          Dacntd := '2415'; // 차: 미지급비용  (yik : cost_ldg테이블의 d_code값)
          Dacnte := '100';

          Cacntd := '2010'; // 대: 제예금

//20181218yik추가 START ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
          //직영매장[지점] 세목 101이 되는 지점목록 조회조건
          //스토어 본점의 물품을 취급하는 곳(goods_ocode='0004')
          //지점(branch_ab='B')
          AshsQL := 'SELECT j_code FROM johap WHERE o_code IN (SELECT o_code FROM org WHERE goods_ocode="0004") AND branch_ab ="B" ';
          Ashchk := MySQL_Assign(db_coopbase, qrySql, AshsQL, qry_imsi);

          try
            Ashint := strtoint(Ashchk);
          except
            db_coopbase.Disconnect;
            ShowMessage('세목 101지점 조회실패했습니다!! (일괄반영) Err : 1288');
            Screen.Cursor := crDefault;
            Exit;
          end;

          //locate사용
          if qry_imsi.locate('j_code', Ashj_code,[]) = true then  // 일치하는 j_code 있으면
            Cacnte := '101'
//20181218yik추가 END ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
          else if (Ashj_code = 'A060') then // 직영분당이매점
            Cacnte := '401'
            // 2014-12-09 CUG(563919)-83 START 김샛별님 요청
          else if (Ashj_code = 'C002') then
            Cacnte := '100'
            // 2014-12-09 CUG(563919)-83 END
            // 2016-08-12 CUG(563919)-129 START 송영숙님 요청
          else if (Ashj_code = 'B045') or (Ashj_code = 'B046') then
          begin
            Cacnte := '202';
          end

          // 2016-08-12 CUG(563919)-129 START 송영숙님 END
          else
            Cacnte := '201';
          // 2012-12-04 cug=563919 댓글30번에 의해 직영점 분리 끝!


          // 씨엘씨 101주기※20190305yik
          if (tbljohap.FieldByName('j_code').AsString = '3910') or (tbljohap.FieldByName('j_code').AsString = '3920') then //씨엘씨 본점(3910) / 지점(3920) 20181026yik
          begin
            Cacnte := '101';
          end;

          //전표처리
          //D:차변
          save_cost_ldg('D', Dacntd, Dacnte, Ashj_code, Comment, Ashamount, AshDamt, AshEamt, AshCDate, AshCash_ab,
            Ac_num, reg_num, reg_name);
          //C:대변
          save_cost_ldg('C', Cacntd, Cacnte, Ashj_code, Comment, Ashamount, AshDamt, AshEamt, AshCDate, AshCash_ab,
            Ac_num, reg_num, reg_name);

          Application.ProcessMessages;
          tblCms.Next;
        end;

      end;

    1: // 출고자료 반영
      begin
        AshStr := '출고 자료 자동전표 발생합니다...' + #10#13 + #10#13 + '매장연결지점코드가 있고, 출고액이 있는것만 제반에 반영됩니다!!' + #10#13 + #10#13 +
          #10#13 + '수수료부과매장지점코드가 없으면 반영되지 않습니다.' + #10#13 + #10#13 + '한번 더 확인해 보시기 바랍니다.' + #10#13 + #10#13 +
          '제반의 처리일과 반영일은 처리하는 당일로 반영합니다.' + #10#13 + #10#13 + #10#13 + '정말로 진행하시겠습니까???';
        if MessageDlg(AshStr, mtConfirmation, [mbNO, mbOK], 0) <> mrOK then
        begin
          Screen.Cursor := crDefault;
          Exit;
        end;

        tblorders.first;
        while not tblorders.eof do
        begin
          Ashvat := 0;
          Ashv_amount := 0;
          Ashamount := 0;
          pb1.Position := pb1.Position + 1;
          pb1.Refresh;

          Ashm_code := tblorders.FieldByName('m_code').AsString;       // 거래처코드
          Ashj_code := tblorders.FieldByName('maejang_code').AsString; // 소속조합
          Ashc_code := tblorders.FieldByName('c_code1').AsString;      // 소속센터
//        Asho_code := tblorders.FieldByName('o_code').AsString;       // 법인코드 20181030yik주석처리
          Ashamount := tblorders.FieldByName('cost').AsFloat;          // 미지급비용

          // 수수료yik
          Ashv_amount := Round(Ashamount / 1.1); // 지급수수료 (round:반올림)  ★★★★★★★★★★ 얘네 유무가 cms와 다름

          // [미지급비용 - 수수료] 뺀 값yik
          Ashvat := Ashamount - Ashv_amount;     // 선급부가세                 ★★★★★★★★★★ (=cms와 다름)

          if tblorders.FieldByName('maejang_code').AsString = '' then
          // 연결매장코드 없으면 넘어간다
          begin
            tblorders.Next;
            Continue;
          end;

          { 20181030yik주석처리
          if tblorders.FieldByName('o_code').AsString = '' then
          // 법인코드 없으면 넘어간다.
          begin
            tblorders.Next;
            Continue;
          end;
          }

          if tblorders.FieldByName('cost').AsFloat = 0 then
          // 출고금액이 0이면 넘어간다.
          begin
            tblorders.Next;
            Continue;
          end;

          Dacntd := ''; // 차변 cost_ldg테이블의 d_code(계정과목)yik
          Dacnte := ''; // 차변 cost_ldg테이블의 e_code(세목)yik
          Cacntd := ''; // 대변 cost_ldg테이블의 d_code(계정과목)yik
          Cacnte := ''; // 대변 cost_ldg테이블의
          AshEamt := 0;
          AshDamt := 0; // 과목잔액,세목잔액

          AshCash_ab := 'A'; // 대체
          Ash_reg_num := ''; // 사업장번호 [ ex)aaa-aa-aaaaa ]

          // 출고일때 적요
          if tbljohap.FieldByName('j_code').AsString = '2300' then  // 쿱엔지니어링
          begin
            Ash_reg_num := Trim(tbljohap.FieldByName('reg_num').AsString); // CUG(563919)-140번 2016-09-05 반영
            Ash_reg_num := copy(Ash_reg_num, 1, 3) + '-' + copy(Ash_reg_num, 4, 2) + '-' + copy(Ash_reg_num, 6, 5);
            reg_num  := Ash_reg_num;
            reg_name := tblorg.FieldByName('o_name').AsString;

            Comment := FormatDateTime('mm', edtFs_day.Date) + '월 냉장냉동기유지보수료 자동전표';
          end
          else if tbljohap.FieldByName('j_code').AsString = '9040' then // 클러스터지원그룹
          begin
            Ash_reg_num := Trim(tbljohap.FieldByName('reg_num').AsString); // CUG(1354925) 2016-09-05 반영
            Ash_reg_num := copy(Ash_reg_num, 1, 3) + '-' + copy(Ash_reg_num, 4, 2) + '-' + copy(Ash_reg_num, 6, 5);
            Comment := Ash_reg_num + ' / ' + tblorg.FieldByName('o_name').AsString + '' +
            FormatDateTime('mm', edtFs_day.Date) + '월 포스유지보수료 자동전표';
          end
          //씨엘씨 본점(3910) / 지점(3920) 20181026yik
          else if (tbljohap.FieldByName('j_code').AsString = '3910') or (tbljohap.FieldByName('j_code').AsString = '3920') then
          begin
            Ash_reg_num := Trim(tbljohap.FieldByName('reg_num').AsString);
            Ash_reg_num := copy(Ash_reg_num, 1, 3) + '-' + copy(Ash_reg_num, 4, 2) + '-' + copy(Ash_reg_num, 6, 5);
            reg_num  := Ash_reg_num;
            reg_name := tblorg.FieldByName('o_name').AsString;

            Comment := FormatDateTime('mm', edtFs_day.Date) + '월 (주)씨엘씨 차량렌탈비 자동전표';
          end;


          // 전표번호 :I을 추가해야함.
          Ac_num := 'I' + '-' + FormatDateTime('yyyymmdd', Now()) + '-' + Ashj_code; // 20자리중 16자리

          //cost_ldg테이블 일련번호
          AshSnum := '1';

          //cost_ldg(비용전표처리)테이블
          //snum(일련번호) 계산
          AshsQL := 'Select max(snum) as snum' + ' from cost_ldg' + ' Where a_day="' + Ash_cost_now + '"' +
            ' and j_code ="' + Ashj_code + '"';
          Ashchk := MySQL_Assign(db_coopbase, qrySql, AshsQL, qry_imsi);

          try
            Ashint := strtoint(Ashchk);
          except
            db_coopbase.Disconnect;
            ShowMessage('연결에 실패했습니다!! ( cost_ldg ) Err : 1517');
            Screen.Cursor := crDefault;
            Exit;
          end;

          if qry_imsi.RecordCount <> 0 then
            AshSnum := IntToStr(qry_imsi.FieldByName('snum').AsInteger + 1);  //일련번호 +1증가

          // 출고는 두개 법인 차변계정세목이 틀림
          if tbljohap.FieldByName('j_code').AsString = '2300' then // 쿱냉동(쿱엔지니어링)
          begin

            Dacntd := '1765';  // 차:지급수수료-냉장냉동유지보수
            Dacnte := '200';
            nqdcode := Dacntd; // 부가세원계정20181115yik

          end
          else if tbljohap.FieldByName('j_code').AsString = '9040' then // 클러스터지원그룹
          begin
            // 2014-01-08 CUG=563919 60번 답글
            if (Ashm_code = 'X12120004') or (Ashm_code = 'X13070003') or (Ashm_code = 'X12070005') or
              (Ashm_code = 'X13100019') or (Ashm_code = 'X12120018') // 구의,대치,보정,서울랜,소사
              or (Ashm_code = 'X12050003') or (Ashm_code = 'X12050005') or (Ashm_code = 'X12100007')
            // 2015-03-09 CUG(563919)-87 김현호님 요청 START
              or (Ashm_code = 'X14120004') or (Ashm_code = 'X14080014') or (Ashm_code = 'X14090001')
            // 2015-03-09 CUG(563919)-87 김현호님 요청 END
            // 2015-06-22 CUG(563919)-100 김현호님 요청 START
              or (Ashm_code = 'X15020001') or (Ashm_code = 'X16040012') // CUG(563919)-142 2016-09-19 일 추가
            // 2015-06-22 CUG(563919)-100 김현호님 요청 END
            then // 신내,쌍문,잠실
            begin
              Dacntd := '1765';
              Dacnte := '112';
            end
            else if (Ashm_code = 'X12030005') then // 행복한밥상
            begin
              Dacntd := '1765';
              Dacnte := '919';
            end
            // 2014-01-08 End
            else
            begin
              Dacntd := '1765'; // 차:지급수수료-포스유지관리
              Dacnte := '119';
            end;

            nqdcode := Dacntd;  // 부가세원계정20181115yik

          end
          //씨엘씨 본점(3910) / 지점(3920) 20181026yik
          else if (tbljohap.FieldByName('j_code').AsString = '3910') or (tbljohap.FieldByName('j_code').AsString = '3920') then
          begin
            Dacntd := '1760';   //임차료
            Dacnte := '100';    //미지급비용

            //20190312,0313 씨엘씨 세목 변경 요청 (cug-563919:233,234,235)
            if (Ashj_code = '4010') then
            begin
              Dacnte := '103';  //쿱스토어울산 본점(4010) 20190313yik
            end
            else if (Ashj_code = '52A0') or (Ashj_code = '59A0') then
            begin
              Dacnte := '120';  //쿱스토어대구 본점(52A0), 쿱스토어전북 본점 (59A0) 20190313yik
            end;

            nqdcode := Dacntd;  // 부가세원계정20181115yik

          end;

          // 원장반영 (A4(원장)용지에 적는다)
          // **차변 원장반영1
          // 지급수수료 변수명으로 넘김
          if tbljohap.FieldByName('j_code').AsString = '2300' then //쿱엔지니어링
          begin
            Ashamount := Ashv_amount; // 지급수수료를 Ashamount에

            save_cost_ldg_nq('D', Dacntd, nqdcode, Dacnte, Ashj_code, Comment, Ashamount, AshDamt, AshEamt, AshCDate, AshCash_ab,
              Ac_num, reg_num, reg_name);

            // SaveAcc_new('D', Dacntd, Dacnte, Ashj_code, Comment, Ashamount, AshDamt, AshEamt, AshCDate, AshCash_ab,
            // Ac_num, reg_num, reg_name);

            // ** 차변 원장반영2
            // 차변동일하게 선급부가세 발생.
            Dacntd := '2065';     // cost_ldg테이블의 d_code(계정과목)
            Dacnte := '100';      // cost_ldg테이블의 e_code(세목)
            Ashamount := Ashvat;  // 선급부가세를 Ashamount에

            save_cost_ldg_nq('D', Dacntd, nqdcode, Dacnte, Ashj_code, Comment, Ashamount, AshDamt, AshEamt, AshCDate, AshCash_ab,
              Ac_num, reg_num, reg_name);

            // SaveAcc_new('D', Dacntd, Dacnte, Ashj_code, Comment, Ashamount, AshDamt, AshEamt, AshCDate, AshCash_ab,
            // Ac_num, reg_num, reg_name);

            // 대변은 같음
            Cacntd := '2415'; // 대:미지급비용
            Cacnte := '100';

            // **대변 원장반영
            Ashamount := tblorders.FieldByName('cost').AsFloat;

            save_cost_ldg_nq('C', Cacntd, nqdcode, Cacnte, Ashj_code, Comment, Ashamount, AshDamt, AshEamt, AshCDate, AshCash_ab,
              Ac_num, reg_num, reg_name);

            // SaveAcc_new('C', Cacntd, Cacnte, Ashj_code, Comment, Ashamount, AshDamt, AshEamt, AshCDate, AshCash_ab,
            // Ac_num, reg_num, reg_name);
          end
          else if tbljohap.FieldByName('j_code').AsString = '9040' then //클러스터지원그룹
          begin
            // **차변 원장반영1
            Ashamount := Ashv_amount;
            save_cost_ldg_nq('D', Dacntd, nqdcode, Dacnte, Ashj_code, Comment, Ashamount, AshDamt, AshEamt, AshCDate, AshCash_ab,
              Ac_num, reg_num, reg_name);
            // SaveAcc('D', Dacntd, Dacnte, Ashj_code, Comment, Ashamount, AshDamt, AshEamt, AshCDate, AshCash_ab, Ac_num);

            // ** 차변 원장반영2
            // 차변동일하게 선급부가세 발생.
            Dacntd := '2065';
            Dacnte := '100';
            Ashamount := Ashvat;
            save_cost_ldg_nq('D', Dacntd, nqdcode, Dacnte, Ashj_code, Comment, Ashamount, AshDamt, AshEamt, AshCDate, AshCash_ab,
              Ac_num, reg_num, reg_name);
            // SaveAcc('D', Dacntd, Dacnte, Ashj_code, Comment, Ashamount, AshDamt, AshEamt, AshCDate, AshCash_ab, Ac_num);

            //////////////////// 대변은 같음
            Cacntd := '2415'; // 대: 미지급비용
            Cacnte := '100';
            // **대변 원장반영
            Ashamount := tblorders.FieldByName('cost').AsFloat;
            save_cost_ldg_nq('C', Cacntd, nqdcode, Cacnte, Ashj_code, Comment, Ashamount, AshDamt, AshEamt, AshCDate, AshCash_ab,
              Ac_num, reg_num, reg_name);
            // SaveAcc('C', Cacntd, Cacnte, Ashj_code, Comment, Ashamount, AshDamt, AshEamt, AshCDate, AshCash_ab, Ac_num);
          end
          //씨엘씨 본점(3910) / 지점(3920) 20181026yik
          else if (tbljohap.FieldByName('j_code').AsString = '3910') or (tbljohap.FieldByName('j_code').AsString = '3920') then
          begin
          // [ cug-1286098:47 ] 확인
            // **차변 원장반영1
            Ashamount := Ashv_amount;
            save_cost_ldg_nq('D', Dacntd, nqdcode, Dacnte, Ashj_code, Comment, Ashamount, AshDamt, AshEamt, AshCDate, AshCash_ab,
              Ac_num, reg_num, reg_name);

            // ** 차변 원장반영2
            // 차변동일하게 선급부가세 발생
            Dacntd := '2065';
            Dacnte := '102';
            Ashamount := Ashvat;
            save_cost_ldg_nq('D', Dacntd, nqdcode, Dacnte, Ashj_code, Comment, Ashamount, AshDamt, AshEamt, AshCDate, AshCash_ab,
              Ac_num, reg_num, reg_name);

            //////////////////// 대변은 같음
            Cacntd := '2415'; // 대: 미지급비용
            Cacnte := '100';
            // **대변 원장반영
            Ashamount := tblorders.FieldByName('cost').AsFloat;
            save_cost_ldg_nq('C', Cacntd, nqdcode, Cacnte, Ashj_code, Comment, Ashamount, AshDamt, AshEamt, AshCDate, AshCash_ab,
              Ac_num, reg_num, reg_name);

          end;
          Application.ProcessMessages;
          tblorders.Next;
        end;
      end;

  end; // case ~ end
  ShowMessage('반영하였습니다!! 제반입출금처리 확인하세요.');
  Screen.Cursor := crDefault;
  db_coopbase.Disconnect;
end;

// github테스트하려고 추가합니다. 0401
// (cug-1286098:61) -> 맨 처음 차변계정과목(Dacntd)이 부가세원계정(nq_d_code)에 동일하게 떠야함.
// nqdcode추가(부가세원계정) 2018115yik
procedure TForm1.save_cost_ldg_nq(cd_chk, d_code, nq_code, e_code, Ashj_code, Ashcomm: string; Ashamount, AshDamt, AshEamt: real;
  AshCDate, AshCash_ab, AshAc_num, Ash_reg_num, Ash_reg_name: string);          // AshCash_ab,AshDamt,AshEamt,AshAc_num
var
  AshsQL: string;
  AshCnt: Integer;
  Ashchk: string;
  Ashint: Integer;
begin

  // cost_ldg(비용전표처리)에 반영하기
  if cd_chk = 'D' then // 차변
  begin

    AshCnt := 1;

    while AshCnt <= 5 do   //yik -> 상경선배님한테 물어봄
    begin
      if AshSnum = '' then //일련번호 yik
      begin
        //cost_ldg(비용전표처리)
        AshsQL := 'select snum' + ' from cost_ldg' + ' where a_day="' + Ash_Cost_date + '"' + ' and j_code ="' +
          Ashj_code + '"' + ' order by snum desc limit 1';
        Ashchk := MySQL_Assign(db_coopbase, qrySql, AshsQL, qry_etc);

        try
          Ashint := strtoint(Ashchk);
        except
          db_coopbase.Disconnect;
          ShowMessage('계정원장 전표번호 추출시 서버연결에 실패했습니다.!! ( cost_ldg_nq ) Err : 1114');
          Screen.Cursor := crDefault;
          Exit;
        end;

        if qry_etc.RecordCount = 0 then
          AshSnum := '1' //
        else
          AshSnum := IntToStr(qry_etc.FieldByName('snum').AsInteger + 1);
      end;

        //2018-11-12 CUG-1286098:59내용 -> [출고일]전표만 해당 되어서 rg1으로 구분.
        //nq_d_code(부가세원계정코드)
        //2018-11-13반영yik
        case rg1.ItemIndex of
        0:
          begin
            AshsQL := 'Insert into cost_ldg (a_day, snum, cd_chk, d_code, j_code, e_code, comment' +
              ', amount, i_day, post_code, ac_reg_num, ac_reg_name, mpst_code, p_day, chk_svr)' + ' Values (' + '"' +
              Ash_Cost_date + '"' + ',"' + AshSnum + '"' + ',"' + cd_chk + '"' + ',"' + d_code + '"' + ',"' + Ashj_code + '"' +
              ', "' + e_code + '"' + ', "' + Ashcomm + '"' + ',' + floatToStr(Ashamount) + ', "' + AshCDate + '"' // 발생일자
              + ', "0000"' + ', "' + Ash_reg_num + '", "' + Ash_reg_name + '", "' + mpst_code + '"' + ',now()' + ',"' +
              IntToStr(svrconn) + '")';
          end;
        1:
          begin  //nq_d_code(부가세원계정코드)추가 (=d_code '계정과목')
            AshsQL := 'Insert into cost_ldg (a_day, snum, cd_chk, d_code, nq_d_code, j_code, e_code, comment' +
              ', amount, i_day, post_code, ac_reg_num, ac_reg_name, mpst_code, p_day, chk_svr)' + ' Values (' + '"' +
              Ash_Cost_date + '"' + ',"' + AshSnum + '"' + ',"' + cd_chk + '"' + ',"' + d_code + '"' + ',"' + nq_code + '"' + ',"' + Ashj_code + '"' +
              ', "' + e_code + '"' + ', "' + Ashcomm + '"' + ',' + floatToStr(Ashamount) + ', "' + AshCDate + '"' // 발생일자
              + ', "0000"' + ', "' + Ash_reg_num + '", "' + Ash_reg_name + '", "' + mpst_code + '"' + ',now()' + ',"' +
              IntToStr(svrconn) + '")';
          end;
        end;

         Ashchk := MySQL_UpDel(db_coopbase, qrySql, AshsQL);

        try
          AshCnt := 9;  // yik -> 상경선배님한테 물어봄
        except
          AshCnt := AshCnt + 1;
          AshSnum := '';
        end;
      end; // while~end

      if AshCnt = 6 then
      begin
        ShowMessage('입력처리 에러cost_ldg: 차변Insert_Error_1928  : 담당자에게 문의 바랍니다.');
        ShowMessage(AshsQL);
        Exit;
      end;
  end
  else // (C:대변)
  begin
        AshsQL := 'Insert into cost_ldg (a_day, snum, cd_chk, d_code, nq_d_code, j_code, e_code, comment' +
          ', amount, i_day, post_code, ac_reg_num, ac_reg_name, mpst_code, p_day, chk_svr)' + ' Values (' + '"' +
          Ash_Cost_date + '"' + ',"' + AshSnum + '"' + ',"' + cd_chk + '"' + ',"' + d_code + '"' + ',"' + nq_code + '"' + ',"' + Ashj_code + '"' +
          ', "' + e_code + '"' + ', "' + Ashcomm + '"' + ',' + floatToStr(Ashamount) + ', "' + AshCDate + '"' // 발생일자
          + ', "0000"' + ', "' + Ash_reg_num + '", "' + Ash_reg_name + '", "' + mpst_code + '"' + ',now()' + ',"' +
          IntToStr(svrconn) + '")';

    Ashchk := MySQL_UpDel(db_coopbase, qrySql, AshsQL);
    try
      Ashint := strtoint(Ashchk);
    except
      ShowMessage('입력처리 에러 cost_ldg: 대변Insert_Error_1929  : 담당자에게 문의 바랍니다.'); //차변은 왜 이렇게 안했지?yik
      Exit;
    end;
  end;

  db_coopbase.Disconnect;

end;


procedure TForm1.save_cost_ldg(cd_chk, d_code, e_code, Ashj_code, Ashcomm: string; Ashamount, AshDamt, AshEamt: real;
  AshCDate, AshCash_ab, AshAc_num, Ash_reg_num, Ash_reg_name: string);          // AshCash_ab,AshDamt,AshEamt,AshAc_num
var
  AshsQL: string;
  AshCnt: Integer;
  Ashchk: string;
  Ashint: Integer;
begin

  // cost_ldg(비용전표처리)에 반영하기
  if cd_chk = 'D' then // 차변
  begin

    AshCnt := 1;

    while AshCnt <= 5 do   //yik -> 상경선배님한테 물어봄
    begin
      if AshSnum = '' then //일련번호 yik
      begin
        //cost_ldg(비용전표처리)
        AshsQL := 'select snum' + ' from cost_ldg' + ' where a_day="' + Ash_Cost_date + '"' + ' and j_code ="' +
          Ashj_code + '"' + ' order by snum desc limit 1';
        Ashchk := MySQL_Assign(db_coopbase, qrySql, AshsQL, qry_etc);

        try
          Ashint := strtoint(Ashchk);
        except
          db_coopbase.Disconnect;
          ShowMessage('계정원장 전표번호 추출시 서버연결에 실패했습니다.!! ( cost_ldg ) Err : 1114');
          Screen.Cursor := crDefault;
          Exit;
        end;

        if qry_etc.RecordCount = 0 then
          AshSnum := '1' //
        else
          AshSnum := IntToStr(qry_etc.FieldByName('snum').AsInteger + 1);
      end;


        //a_day: 입력일자(now), snum: 일련번호, cd_chk: 차대구분, d_code: 계정과목, j_code:처리소속(조합), e_code: 세목, comment: 적요, amount: 입출금액
        //i_day: 실제 입출금 날짜(edts_day), post_code: 지출비용부서, ac_reg_num: 증빙사업자번호, ac_reg_name: 증빙사업자명, mpst_code: (최종)처리자, p_day: (최종)처리일
        AshsQL := 'Insert into cost_ldg (a_day, snum, cd_chk, d_code, j_code, e_code, comment' +
          ', amount, i_day, post_code, ac_reg_num, ac_reg_name, mpst_code, p_day, chk_svr)' + ' Values (' + '"' +
          Ash_Cost_date + '"' + ',"' + AshSnum + '"' + ',"' + cd_chk + '"' + ',"' + d_code + '"' + ',"' + Ashj_code + '"' +
          ', "' + e_code + '"' + ', "' + Ashcomm + '"' + ',' + floatToStr(Ashamount) + ', "' + AshCDate + '"' // 발생일자
          + ', "0000"' + ', "' + Ash_reg_num + '", "' + Ash_reg_name + '", "' + mpst_code + '"' + ',now()' + ',"' +
          IntToStr(svrconn) + '")';

//Memo2.Lines.Add(AshsQL);

         Ashchk := MySQL_UpDel(db_coopbase, qrySql, AshsQL);

        try
          AshCnt := 9;  // yik -> 상경선배님한테 물어봄
        except
          AshCnt := AshCnt + 1;
          AshSnum := '';
        end;
      end; // while~end

      if AshCnt = 6 then
      begin
        ShowMessage('입력처리 에러cost_ldg: 차변Insert_Error_2019  : 담당자에게 문의 바랍니다.');
        ShowMessage(AshsQL);
        Exit;
      end;
  end
  else // (C:대변)
  begin
    AshsQL := 'Insert into cost_ldg (a_day, snum, cd_chk, d_code, j_code, e_code, comment' +
      ', amount, i_day, post_code, ac_reg_num, ac_reg_name, mpst_code, p_day, chk_svr)' + ' Values (' + '"' +
      Ash_Cost_date + '"' + ',"' + AshSnum + '"' + ',"' + cd_chk + '"' + ',"' + d_code + '"' + ',"' + Ashj_code + '"' +
      ', "' + e_code + '"' + ', "' + Ashcomm + '"' + ',' + floatToStr(Ashamount) + ', "' + AshCDate + '"' // 발생일자
      + ', "0000"' + ', "' + Ash_reg_num + '", "' + Ash_reg_name + '", "' + mpst_code + '"' + ',now()' + ',"' +
      IntToStr(svrconn) + '")';

    Ashchk := MySQL_UpDel(db_coopbase, qrySql, AshsQL);
    try
      Ashint := strtoint(Ashchk);
    except
      ShowMessage('입력처리 에러 cost_ldg: 대변Insert_Error_2037  : 담당자에게 문의 바랍니다.');
      Exit;
    end;
  end;

  db_coopbase.Disconnect;

end;

//엑셀버튼
procedure TForm1.btnExcelClick(Sender: TObject);
var
  i, j, cntR, cntC: Integer;
  Excel: OleVariant;
//v, vTitle: variant;
begin
  // 엑셀
  if rg1.ItemIndex = 0 then
  begin
    if ((tblCms.Active = False) or (tblCms.RecordCount = 0)) then
    begin
      ShowMessage('CMS인출자료 조회 후 엑셀출력 하세요!!!');
      edtFs_day.SetFocus;
      Exit;
    end;
  end
  else if ((tblorders.Active = False) or (tblorders.RecordCount = 0)) then
  begin
    ShowMessage('출고자료 조회 후 엑셀출력 하세요!!!');
    edtFs_day.SetFocus;
    Exit;
  end;

  Screen.Cursor := crHourGlass;
  cxGrid1DBTableView1.DataController.DataSource := nil;

  Excel1.Connect;
  Excel1.Exec('[WORKBOOK.INSERT(1)]');


  if rg1.ItemIndex = 0 then
  begin
    Excel1.PutStr(1, 1, '수수료처리 내역_CMS인출');

    Excel1.PutStr(2, 1, '조합명:' + tbljohap.FieldByName('j_name').AsString + '');

    Excel1.PutStr(3, 1, '인출일 :' + FormatDateTime('yyyy-mm-dd', edtFs_day.Date));
    Excel1.PutStr(3, 4, '출력자 :' + mpst_name);
    Excel1.PutStr(3, 7, '출력일 :' + FormatDateTime('yyyy-mm-dd HH:mm:ss', Now));

    Excel1.PutStr(4, 1, '인출조합원코드');
    Excel1.PutStr(4, 2, '조합원명');
    Excel1.PutStr(4, 3, '신청액');
    Excel1.PutStr(4, 4, '출금액');
    Excel1.PutStr(4, 5, '출금종류');
    Excel1.PutStr(4, 6, '은행코드');
    Excel1.PutStr(4, 7, '은행명');
    Excel1.PutStr(4, 8, '연결지점조합코드');
    Excel1.PutStr(4, 9, '연결지점명');
    Excel1.PutStr(4, 10, '연결지점소속센터명()');
    Excel1.PutStr(4, 11, '수신여부');

    tblCms.first;
    for i := 5 to tblCms.RecordCount + 4 do
    begin
      Excel1.PutStr(i, 1, '''' + tblCms.FieldByName('m_code').AsString);
      Excel1.PutStr(i, 2, tblCms.FieldByName('m_name').AsString);
      Excel1.PutStr(i, 3, FormatFloat('#,0', tblCms.FieldByName('s_money').AsFloat));
      Excel1.PutStr(i, 4, FormatFloat('#,0', tblCms.FieldByName('r_money').AsFloat));
      Excel1.PutStr(i, 5, tblCms.FieldByName('kind_name').AsString);
      Excel1.PutStr(i, 6, '''' + tblCms.FieldByName('bank').AsString);
      Excel1.PutStr(i, 7, tblCms.FieldByName('bank_name').AsString);
      Excel1.PutStr(i, 8, tblCms.FieldByName('maejang_code').AsString);
      Excel1.PutStr(i, 9, tblCms.FieldByName('j_name1').AsString);
      Excel1.PutStr(i, 10, tblCms.FieldByName('c_name1').AsString + '(' + tblCms.FieldByName('c_code1').AsString + ')');
      Excel1.PutStr(i, 11, tblCms.FieldByName('r_ab_name').AsString);

      tblCms.Next;
    end;
    tblCms.first;
  end
  else
  begin
    Excel1.PutStr(1, 1, '수수료처리 내역_출고자료');
    Excel1.PutStr(2, 1, '조합명:' + tbljohap.FieldByName('j_name').AsString + '');

    Excel1.PutStr(3, 1, '인출일 :' + FormatDateTime('yyyy-mm-dd', edtFs_day.Date));
    Excel1.PutStr(3, 4, '출력자 :' + mpst_name);
    Excel1.PutStr(3, 7, '출력일 :' + FormatDateTime('yyyy-mm-dd HH:mm:ss', Now));

    Excel1.PutStr(4, 1, '조합원코드');
    Excel1.PutStr(4, 2, '조합원명');
    Excel1.PutStr(4, 3, '금액');
    Excel1.PutStr(4, 4, '공급일');
    Excel1.PutStr(4, 5, '반영일');
    Excel1.PutStr(4, 6, '연결지점조합코드');
    Excel1.PutStr(4, 7, '연결지점명');
    Excel1.PutStr(4, 8, '연결지점소속센터명()');

    tblorders.first;
    for i := 5 to tblorders.RecordCount + 4 do
    begin
      Excel1.PutStr(i, 1, '''' + tblorders.FieldByName('m_code').AsString);
      Excel1.PutStr(i, 2, tblorders.FieldByName('m_name').AsString);
      Excel1.PutStr(i, 3, FormatFloat('#,0', tblorders.FieldByName('cost').AsFloat));
      Excel1.PutStr(i, 4, tblorders.FieldByName('s_day').AsString);
      Excel1.PutStr(i, 5, tblorders.FieldByName('a_day').AsString);
      Excel1.PutStr(i, 6, tblorders.FieldByName('maejang_code').AsString);
      Excel1.PutStr(i, 7, tblorders.FieldByName('j_name1').AsString);
      Excel1.PutStr(i, 8, tblorders.FieldByName('c_name1').AsString + '(' + tblorders.FieldByName('c_code1')
        .AsString + ')');

      tblorders.Next;
    end;
    tblorders.first;
  end;

  Excel1.Disconnect;

  Screen.Cursor := crDefault;

  if rg1.ItemIndex = 0 then
    cxGrid1DBTableView1.DataController.DataSource := dtstblCms
  else if rg1.ItemIndex = 1 then
    cxGrid1DBTableView1.DataController.DataSource := dtstblorders;

  Screen.Cursor := crDefault;
  Excel := CreateOleObject('Excel.Application');
  Excel.Visible := True;



// 엑셀 셀 가로길이 자동조절
// Excel.Cells.EntireColumn.AutoFit;
end;

procedure TForm1.edtorgKeyPress(Sender: TObject; var Key: Char);
begin
  if Key <> #13 then
    Exit;

  SelectNext(ActiveControl, True, True);
  Key := #0;
end;

procedure TForm1.edtjnameClick(Sender: TObject);
begin
  if (tblCms.Active) then
    tblCms.Close;
  if (tblorders.Active) then
    tblorders.Close;
  Label5.Caption := ' ';
  Label6.Caption := ' ';
  Label7.Caption := ' ';
end;

//OnCalcFields : 응용프로그램에서 계산 된 필드를 다시 계산할 때 특정 작업을 수행하도록 사용
procedure TForm1.tblCmsCalcFields(DataSet: TDataSet);
begin
  if NoCalBool then // TRUE면 밑에 소스 안탄다.
    Exit;

  with DataSet do  //DataSet : 실제 데이터를 가져오는 데이터셋 컴포넌트를 연결 하는 기능.
  begin

    FieldByName('c_name').AsString := '';
    if qrycenter.Locate('c_code', FieldByName('c_code').AsString, []) then
      FieldByName('c_name').AsString := qrycenter.FieldByName('c_name').AsString;

//    j_code1 수수료부과매장연결 조합코드
//    FieldByName('j_code1').AsString := '';
//    if qrymembership.Locate('m_code', FieldByName('m_code').AsString, []) then
//      FieldByName('j_code1').AsString := qrymembership.FieldByName('maejang_code').AsString;

    // j_name1 매장연결 조합명
    FieldByName('j_name1').AsString := '';
    FieldByName('c_code1').AsString := '';
    if qryjohap.Locate('j_code', FieldByName('maejang_code').AsString, []) then
    begin
      FieldByName('j_name1').AsString := qryjohap.FieldByName('j_name').AsString;
      // maejang_code 의 소속센터
      FieldByName('c_code1').AsString := qryjohap.FieldByName('c_code').AsString;
      // maejang_code 의 소속법인
      FieldByName('o_name1').AsString := qryjohap.FieldByName('o_name').AsString;
    end;
//    else if qrymembership.Locate('maejang_code', FieldByName('m_code').AsString, []) then
//      FieldByName('j_name1').AsString := qrymembership.FieldByName('maejang_name').AsString;

    FieldByName('c_name1').AsString := '';
    if qrycenter.Locate('c_code', FieldByName('c_code1').AsString, []) then
      FieldByName('c_name1').AsString := qrycenter.FieldByName('c_name').AsString;

    // bank_name
    FieldByName('bank_name').AsString := '';
    if qryCode.Locate('fval', FieldByName('bank').AsString, []) then
      FieldByName('bank_name').AsString := qryCode.FieldByName('fname').AsString;

    // 물품대금(1),조합비(2), 기초출자금(3),증좌출자금(4), 기금(5)
    FieldByName('kind_name').AsString := '';
    if FieldByName('kind').AsString = '1' then
      FieldByName('kind_name').AsString := '물품대금(1)'
    else if FieldByName('kind').AsString = '2' then
      FieldByName('kind_name').AsString := '조합비(2)'
    else if FieldByName('kind').AsString = '3' then
      FieldByName('kind_name').AsString := '기초출자금(3)';

    FieldByName('r_ab_name').AsString := '';
    if FieldByName('r_ab').AsString = 'A' then
      FieldByName('r_ab_name').AsString := '미수신'
    else if FieldByName('r_ab').AsString = 'B' then
      FieldByName('r_ab_name').AsString := '수신';

  end; // with~end
end;

procedure TForm1.edtFs_dayChange(Sender: TObject);
begin
  if (tblCms.Active) then
    tblCms.Close;
  if (tblorders.Active) then
    tblorders.Close;

  pb1.Position := 0;
  Label5.Caption := '';
  Label7.Caption := '';
end;


procedure TForm1.rg1Click(Sender: TObject);
begin
  if tblCms.Active then
    tblCms.Close;
  if tblorders.Active then
    tblorders.Close;

  case rg1.ItemIndex of
    0: // cms인출일
      begin
        Label3.Caption := '인출일';
        Label6.Caption := ' ';

        cxGrid1DBTableView1.Columns[0].Caption  := '조합원코드';
        cxGrid1DBTableView1.Columns[1].Caption  := '거래처명';
        cxGrid1DBTableView1.Columns[2].Caption  := '신청액';
        cxGrid1DBTableView1.Columns[2].Summary.FooterKind   := skSum; //합계 ( skMax, skCount, skAverage 등 )
        cxGrid1DBTableView1.Columns[2].Summary.FooterFormat := '#,0'; //값이 표시되는 방식
        cxGrid1DBTableView1.Columns[3].Caption  := '출금액';
        cxGrid1DBTableView1.Columns[3].Summary.FooterKind   := skSum;
        cxGrid1DBTableView1.Columns[3].Summary.FooterFormat := '#,0';
        cxGrid1DBTableView1.Columns[4].Caption  := '수수료부과지점명';
        cxGrid1DBTableView1.Columns[5].Caption  := '수수료부과지점코드';
        cxGrid1DBTableView1.Columns[6].Caption  := '수수료부과지점소속센터명';
        cxGrid1DBTableView1.Columns[7].Caption  := '출금종류';
        cxGrid1DBTableView1.Columns[8].Caption  := '은행코드';
        cxGrid1DBTableView1.Columns[9].Caption  := '은행명';
        cxGrid1DBTableView1.Columns[10].Caption := '수신여부';
        cxGrid1DBTableView1.Columns[11].Caption := '지점코드';
        cxGrid1DBTableView1.Columns[12].Caption := '법인명';

        cxGrid1DBTableView1.Columns[0].DataBinding.FieldName  := 'm_code';
        cxGrid1DBTableView1.Columns[1].DataBinding.FieldName  := 'm_name';
        cxGrid1DBTableView1.Columns[2].DataBinding.FieldName  := 's_money';
        cxGrid1DBTableView1.Columns[3].DataBinding.FieldName  := 'r_money';
        cxGrid1DBTableView1.Columns[4].DataBinding.FieldName  := 'j_name1';
        cxGrid1DBTableView1.Columns[5].DataBinding.FieldName  := 'maejang_code';
        cxGrid1DBTableView1.Columns[6].DataBinding.FieldName  := 'c_name1';
        cxGrid1DBTableView1.Columns[7].DataBinding.FieldName  := 'kind_name';
        cxGrid1DBTableView1.Columns[8].DataBinding.FieldName  := 'bank';
        cxGrid1DBTableView1.Columns[9].DataBinding.FieldName  := 'bank_name';
        cxGrid1DBTableView1.Columns[10].DataBinding.FieldName := 'r_ab_name';
        cxGrid1DBTableView1.Columns[11].DataBinding.FieldName := 'c_code1';
        cxGrid1DBTableView1.Columns[12].DataBinding.FieldName := 'o_name1';

        //20181011yik
        cxGrid1DBTableView1.Columns[3].width  := 100;
        cxGrid1DBTableView1.Columns[4].Width  := 140;
        cxGrid1DBTableView1.Columns[5].Width  := 80;
        cxGrid1DBTableView1.Columns[6].Width  := 140;
        cxGrid1DBTableView1.Columns[11].Visible := true;
        cxGrid1DBTableView1.Columns[12].Visible := true;
        //20181012yik
        cxGrid1DBTableView1.Columns[3].Styles.Content := cxStyle1;
        cxGrid1DBTableView1.Columns[3].Styles.Header  := cxStyle2;
        cxGrid1DBTableView1.Columns[4].Styles.Content := cxStyle4;
        cxGrid1DBTableView1.Columns[4].Styles.Header  := cxStyle7;
      end;
    1: // 출고일
      begin
        Label3.Caption := '출고일';
        if org_code = 'A049' then //클러스터지원그룹
        begin
          Label6.Caption := '물품명 : POS유지보수_멀티매장(10003CD100),복합매장(10002CD100),일반매장(10001CD100)'
        end
        else if org_code = '0023' then //쿱엔지니어링
        begin
          Label6.Caption := '물품명 : A/S*유지보수(0000200000),냉장냉동자재*판넬(0000500000)';
        end
        else if org_code ='0039' then //씨엘씨
        begin
          Label6.Caption := '물품명 : 렌탈비(8847300000)'; //20181018yik
        end;

        cxGrid1DBTableView1.Columns[0].Caption := '조합원코드';
        cxGrid1DBTableView1.Columns[1].Caption := '거래처명';
        cxGrid1DBTableView1.Columns[2].Caption := '출고금액';
        cxGrid1DBTableView1.Columns[2].Summary.FooterKind := skSum;
        cxGrid1DBTableView1.Columns[2].Summary.FooterFormat := '#,0';
        cxGrid1DBTableView1.Columns[3].Caption := '수수료부과지점명';
        cxGrid1DBTableView1.Columns[3].Summary.FooterKind := skNone;
        cxGrid1DBTableView1.Columns[3].Summary.FooterFormat := '';
        cxGrid1DBTableView1.Columns[4].Caption := '수수료부과지점코드';
        cxGrid1DBTableView1.Columns[5].Caption := '수수료부과지점소속센터명';
        cxGrid1DBTableView1.Columns[6].Caption := '공급일';
        cxGrid1DBTableView1.Columns[7].Caption := '반영일';
        cxGrid1DBTableView1.Columns[8].Caption := '물품코드';
        cxGrid1DBTableView1.Columns[9].Caption := '지점코드';
        cxGrid1DBTableView1.Columns[10].Caption := '법인명';
        cxGrid1DBTableView1.Columns[11].Caption := '';
        cxGrid1DBTableView1.Columns[12].Caption := '';

        cxGrid1DBTableView1.Columns[0].DataBinding.FieldName := 'm_code';
        cxGrid1DBTableView1.Columns[1].DataBinding.FieldName := 'm_name';
        cxGrid1DBTableView1.Columns[2].DataBinding.FieldName := 'cost';
        cxGrid1DBTableView1.Columns[3].DataBinding.FieldName := 'j_name1';
        // 수수료부과매장명
        cxGrid1DBTableView1.Columns[4].DataBinding.FieldName := 'maejang_code';
        // 수수료부과매장코드
        cxGrid1DBTableView1.Columns[5].DataBinding.FieldName := 'c_name1';
        // 수수료부과매장 소속센터명
        cxGrid1DBTableView1.Columns[6].DataBinding.FieldName := 's_day';
        cxGrid1DBTableView1.Columns[7].DataBinding.FieldName := 'a_day';
        cxGrid1DBTableView1.Columns[8].DataBinding.FieldName := 'g_code';
        cxGrid1DBTableView1.Columns[9].DataBinding.FieldName := 'c_code1';
        // 수수료부과매장 소속센터코드
        cxGrid1DBTableView1.Columns[10].DataBinding.FieldName := 'o_name1';
        cxGrid1DBTableView1.Columns[11].DataBinding.FieldName := '';
        cxGrid1DBTableView1.Columns[12].DataBinding.FieldName := '';

        //20181011yik
        cxGrid1DBTableView1.Columns[3].Width  := 140;
        cxGrid1DBTableView1.Columns[4].Width  := 80;
        cxGrid1DBTableView1.Columns[5].Width  := 140;
        cxGrid1DBTableView1.Columns[11].Visible := false;
        cxGrid1DBTableView1.Columns[12].Visible := false;
        //20181012yik
        cxGrid1DBTableView1.Columns[3].Styles.Content := cxStyle4;
        cxGrid1DBTableView1.Columns[3].Styles.Header  := cxStyle7;
        cxGrid1DBTableView1.Columns[4].Styles.Content := cxStyle1;
        cxGrid1DBTableView1.Columns[4].Styles.Header  := cxStyle2;
      end;

  end;
end;

procedure TForm1.tblordersCalcFields(DataSet: TDataSet);  // (팝업메뉴:개별반영)
begin
  if NoCalBool then
    Exit;

  with DataSet do
  begin

    // j_name1 매장연결 조합명
    FieldByName('j_name1').AsString := '';
    FieldByName('c_code1').AsString := '';
    FieldByName('o_code').AsString := '';
    if qryjohap.Locate('j_code', FieldByName('maejang_code').AsString, []) then
    begin
      FieldByName('j_name1').AsString := qryjohap.FieldByName('j_name').AsString;
      // maejang_code 의 소속센터
      FieldByName('c_code1').AsString := qryjohap.FieldByName('c_code').AsString;
      // maejang_code 의 소속법인
      FieldByName('o_name1').AsString := qryjohap.FieldByName('o_name').AsString;
    end;
    // 수수료부과매장조합의 소속센터명
    FieldByName('c_name1').AsString := '';
    if qrycenter.Locate('c_code', FieldByName('c_code1').AsString, []) then
      FieldByName('c_name1').AsString := qrycenter.FieldByName('c_name').AsString;

  end; // with~end
end;

procedure TForm1.chk1Click(Sender: TObject);
begin
  if tblCms.Active then
    tblCms.Close;
  if tblorders.Active then
    tblorders.Close;
end;

procedure TForm1.cxGrid1DBTableView1MouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint; var Handled: Boolean);
begin
  Handled := True;
  with TcxGridDBTableView(cxGrid1.FocusedView) do
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

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  // 수수료부과매장 조회하기
  // 설정방법은 cug=514644 의 박종우 팀장님의 10번 댓글임.
  with TForm2.Create(Form1) do
  begin
    if ShowModal = mrOK then
    begin

    end;

    Free;
  end; // with~end

  db_coopbase.Disconnect;
end;

end.

