unit coophr_utils;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, Forms,
  Dialogs, StdCtrls, ZConnection, ZDataset, DBGrids, Graphics, Grids,
  ComCtrls, Buttons, VirtualTable, Mask, CheckLst, DateUtils, cxCurrencyEdit,
  cxDBLookupComboBox, cxCheckComboBox, cxCheckBox, cxLookAndFeelPainters,
  cxGridTableView, cxGridCustomTableView, cxDropDownEdit, cxCheckListBox, cxRadioGroup,
  cxControls, cxTL, cxDBTL, AnsiStrings;

// coop_utils
//초기화면 위치 설정
procedure Set_MainPosition(app_main: TForm);

// 쿼리를 이력 저장형식으로 변환
function SQLToHistory(my_sql: String): String;

//문자열 공백 제거
function DelBlank(pfStr: String): String;
// *****************************************************************************

// 숫자만 입력
procedure onlyNumber(var key: char);

// 문자열 null 확인
function isEmpty(str: String): Boolean;

// RPAD
function rpad(str, pad:string; len: Integer): string;

// 필수입력항목 확인
{ obj: 필수입력컴포넌트명
  lab: 필수입력항목 label
}
function chkExtVal(obj: TComponent; lab: String): Boolean;

// 공통콤보박스 옵션 'N'일 때 선택항목 유무 확인
// 콤보박스 index 0의 text 옵션 (A:전체, S:선택하세요, N:없음)
function chkCbCommCode(obj: TComboBox): Boolean;

// 사원번호, 부서번호 유효성 확인
{ ntype - 1: 사원번호
          2: 부서번호
}
function chkTypeNo(obj: TEdit; ntype: Integer = 1): Boolean;

// 주민번호 유효성 확인
{idNo : '-' 제외한 숫자 13자리}
function chkIdNo(const idNo: String): Boolean;

// 외국인등록번호 유효성 확인
{idNo : '-' 제외한 숫자 13자리}
function chkForeignNo(const idNo: String): Boolean;

// 사업자등록번호 유효성 확인
{bizRegNo : - 제외한 숫자 10자리}
function chkBizRegNo(const bizRegNo: String): Boolean;

// split - 문자열 구분자로 나눠서 원하는 위치(순서)의 문자 가져오기
{ Str       : 문자열
  Position  : 순서
  Delimiter : 구분자
}
function subStr(str: String; const position: Integer = 1; const delimiter: string = ' '): String;
function splitCd(str: String; const position: Integer = 1; const delimiter: string = ' '): string;

// 화면모드별 입력 컴포넌트 속성 변경
{ obj : 컴포넌트명
  mode: 화면모드(0:보기, 1:등록, 2: 수정, 3:삭제)
  e   : 필수값여부(0:비필수, 1:필수, 2:비활성)
}
procedure setObjEnable(const obj: TComponent; mode: Integer; e: Integer = 0);

// 화면모드별 조건 컴포넌트 속성 변경
procedure setCondEnable(const obj: TComponent; mode: Integer; e: Integer);

// (화면모드별, 사용자 프로그램권한별) 버튼 활성화 설정
//procedure setProBtnEnable(modeInt: Integer; btnInsert, btnUpdate, btnInit, btnSave, btnPrint, btnExcel: TButton);

// 부서 조회 - 부서 테이블 4차서버 연결로 추가
procedure selectPost(db: TZConnection; vtPost: TVirtualTable);

// 공통코드를 콤보박스, 체크리스트박스에 세팅
{ dsNm      : TZQuery명
  vtTemp    : TVirtualTable명
  codeId    : 공통코드ID
  cbFirTxt  : 콤보박스 index 0의 text (A:전체, S:선택하세요, N:없음)
  cbNm      : 콤보박스명, 체크리스트박스명
  ab        : 콤보박스 Item 보여주기 방식 (A: 코드+네임, C: 코드, N: 네임)
}
procedure setCbCommCode(dsNm: TZQuery; vtTemp: TVirtualTable; codeId, cbFirTxt: String; cbNm: TWinControl; ab: String = 'A');
//procedure setCbCommCode(dsNm: TZQuery; vtTemp: TVirtualTable; codeId, cbFirTxt: String; cbNm: TcxComboBox); overload;
//procedure setCbCommCode(dsNm: TZQuery; vtTemp: TVirtualTable; codeId, cbFirTxt: String; cbNm: TCheckListBox); overload;
//procedure setCbCommCode(dsNm: TZQuery; vtTemp: TVirtualTable; codeId, cbFirTxt: String; cbNm: TcxCheckListBox); overload;

// cxGrid 콤보박스에 공통코드 세팅
procedure setCxCbCommCode(vt: TVirtualTable; codeId, cbFirTxt: String; cxGridCol: TcxCustomGridTableItem);

// TcxLookupComboBox 세팅
{ codeId   : 코드ID
  cbFirTxt : 콤보박스 index 0의 text (A:전체(ALL), S:선택하세요(SELECT), B:일괄제출(BATCH), N:없음)
}
procedure setCbx(vt: TVirtualTable; codeId, cbFirTxt: string; userCode:String = ''; userCode2:String = '');

// 소속, 직급, 직책 콤보박스 세팅
{ dsNm      : TZQuery명
  codeId    : 공통코드ID
  cbFirTxt  : 콤보박스 index 0의 text (A:전체, S:선택하세요, N:없음, C:코드만, M:코드명만)
  cbNm      : 콤보박스명
}
procedure setCbCode(db: TZConnection; dsNm: TZQuery; codeId, cbFirTxt: String; cbNm: TWinControl; userCode:String = ''; userCode2:String = '');

// cxTreeList 초기화
// checkedYn : True - 전체선택, False - 전체해제
procedure setTlInit(tlNm:TcxControl; checkedYn: Boolean = False);

// 전체 선택 cxChekBox 선택 시 전체선택/해제
procedure setGrdviAllChecked(vt: TVirtualTable; xchk: TcxCheckBox; fieldNm: string = 'useYn');
// cxGrid 체크박스 전체 선택하면 전체선택 체크박스 설정
procedure setXChkGrdviChk(vt: TVirtualTable; xchk: TcxCheckBox; fieldNm: string = 'useYn');
// cxGrid 체크박스 checked count
function getGrdviChkCnt(vt: TVirtualTable; fieldNm: string = 'useYn'): Integer;

// 체크리스트박스 전체 선택, 해제
procedure setCklAll(cklNm:TWinControl);
// 체크리스트박스 초기화
// checkedYn : True - 전체선택, False - 전체해제
procedure setCklInit(cklNm:TWinControl; checkedYn: Boolean = False);
// 체크리스트박스 checked count
function getCklChkCnt(cklNm: TWinControl): Integer;
function getNCklChkCnt(cklNm: TCheckListBox): Integer;

// 체크콤보박스 checked count
function getCkbChkCnt(ckbNm: TcxCheckComboBox): Integer;

// 체크리스트박스 체크 선택 코드를 콤마(,)로 구분한 문자열(IN 조건)
// 1:코드, 2:코드값
function getCklCondStr(cklNm: TWinControl; ab: Integer = 1): String;
function getCkbCondStr(ckbNm: TcxCheckComboBox; ab: Integer = 1): string;

// 체크리스트박스에서 선택한 text에서 코드값만 가져오기
function getCodeValNm(ckl: TCheckListBox): String;

// 콤보박스에서 선택한 콤보text에서 코드만 가져오기
function getCommCodeVal(cb: TWinControl): String;
//function getCommCodeVal(cb: TcxComboBox): String; overload;
//function getCommCodeVal(ckl: TCheckListBox): String; overload;

// 콤보박스에서 value 매칭 code 가져오기
function getMatchValueCode(value: String; cbNm: TComboBox):String;

// 콤보박스에서 code 매칭 index 가져오기
function getMatchCodeIdx(code: String; cbNm: TComboBox):Integer; overload;
function getMatchCodeIdx(code: String; cbNm: TcxComboBox):Integer; overload;
//function getMatchCodeIdx(code: String; cbNm: TwDataCombo):Integer; overload;
function getMatchCodeIdx(code: String; ckl: TCheckListBox):Integer; overload;
function getMatchCodeIdx(code: String; ckl: TcxCheckListBox):Integer; overload;

// 콤보박스에서 code 매칭 value 가져오기
function getMatchCodeVal(code: String; cbNm: TComboBox):String;

// 콤보박스에서 value 매칭 index 가져오기
function getMatchValueIdx(val: String; cbNm: TComboBox):Integer;

// 사용자 프로그램의 단체, 프로그램 등록, 수정, 인쇄 권한 조회
procedure inquirySustaff();
// 사용자 프로그램의 법인별 사업장별 부서별 등록, 수정, 출력, 급여정보열람 권한
procedure setGroupRightYn(obpAb: String = ''; obpCode: String = '');

// 급여정보허용 권한에 따른 Display Format 반환
function getSalaryFormat(salaryAb: String): String;

// 사용자권한 법인, 부서 조회
{ vtSustaff : vtCompany, vtPost
  obpAb     : 법인, 부서코드 구분( 'hr_o_code', 'hr_post_code')
  mpstCode  : 사용자사원번호
  return    : 권한있는 법인(또는 부서)코드를 콤마(,)로 구분한 문자열  예) 코드1, 코드2, 코드3
}
function getStrObpCode(obpAb: String):String;

// 해당부서의 권한 유무 확인
{ vtSustaff : vtCompany, vtPost
  ab        : 법인, 부서코드 구분( 'hr_o_code', 'hr_post_code')
  code      : 권한유무를 확인할 법인, 부서코드
  return    : 권한유무(Y, N)
}
function getStaffYn(vt: TVirtualTable; ab: String; code: String):String;

// true, false -> Y, N 으로 치환 (체크박스, 라디오버튼의 checked 변환 시 사용)
function getYn(bool: Boolean): String; overload;
function getYn(str: string): String; overload;
// true, false -> 0, 1 로 치환
function get01(bool: Boolean): String; overload;
function get01(str: string): String; overload;
// Y, N -> 1, ''(공란)
function get1(str: string): String;
// 여, 부 -> 1, ''(공란)
function getH1(str: string): String;
// 여, 부 -> 1, 2
function getH12(str: string): String;
// Y, N -> true, false 로 치환
function getBool(yn: String): Boolean;

// 삭제확인창 메세지
function confirmDelMsg(msg: String = ''): Integer;

// 날짜 초기화 : 1900-01-01
function initDt(): TDate;
// 날짜 초기화2 : 1899-12-31 <- 값이 바뀌지 않는 초기값
function initDt2: TDate;

// dateTimePicker 데이터 null일 때 date 지우기
procedure setDt(dt: TDateTimePicker; strDate: String);

// 날짜 문자열 dateTime 타입으로 변환
function convtDateType(strDate: String): TDate;

// 입력날짜 유효성 체크
function isDate(str: String; msgYn: Boolean = False): Boolean;
//function isDate(str: String): Boolean;
//function isDateTime(str: String): Boolean;

// 입력날짜 From~To 기간 체크
function validPeriod(fromDt, toDt: TDateTimePicker): Boolean; overload;
function validPeriod(fromDt, toDt: TDateTime): Boolean; overload;

// 전화번호 유효성 확인
{ telNo : 하이픈(-) 포함한 전화번호 }
function chkTelNo(telNo: String): Boolean;

// 주민번호로 생년월일 구하기
{ id1 : 주민번호 앞자리
  id2 : 주민번호 뒷자리
  id : 하이픈(-) 없는 주민번호 - 주민번호앞6자리 + 뒷첫째자리 이상이면 가능
}
function getBirthdayByIdNo(id: String): TDate;

// 날짜로 요일구하기
function getWeekday(date: TDateTime): String;
// 숫자를 한글로 읽기
function numToStr(num: Integer): string;

// 전산매체 숫자 포맷
// 데이터 길이 및 부호(음수 : 1, 양수 : 0) 적용
{ val : 값
  len : 부호표시 시는 부호길이를 포함하지 않은 데이터 길이
  ab  : 부호표시여부(0 미포함, 1 포함)
}
function getENum(val, len: Integer; ab: Integer = 0): string; overload;
function getENum(val: Double; len: Integer; ab: Integer = 0): string; overload;
// 전산매체 문자 포맷
{
  val : 문자열
  len : (최대)데이터길이
  trimYn : 공백제거여부
}
function getEStr(val: string; len: integer; trimYn:Boolean = False): string;
// 전산매체 date to string
function dtToStr(dt: TDate): string;
//function dtToStr(dt: TDate; format: string = 'yyyymmdd'): string;

// ERP단체코드와 HR법인코드 매칭
{ dsNm      : TZQuery명
  oCode     : ERP단체코드 또는 HR법인코드
  oCodeAb   : 구분 : ERP-ERP단체코드, HR-HR법인코드
  return    : 매칭코드
}
function getMatchOCode(oCode, oCodeAb:String): String;

// 그룹박스 내 콤포넌트 초기화
procedure initGroupBoxControl(grp: TWinControl);

// 그룹박스 내 콤포넌트 활성화 설정
{ grp      : TGroupBox명
  bool     : true - 활성화, false - 비활성화
}
procedure enabledGroupBoxControl(grp: TGroupBox; bool: Boolean = True);

// 개발자 테스트 컨트롤 보임
procedure showCtrl(ctrl: TControl);

// 그리드 타이틀 클릭 시 정렬
procedure sortGrid(var cIdx: Integer; var cTitleCaption: String; col: TColumn);

// TcxLookupComboBox 공통코드 설정
procedure setCbxComm(vt: TVirtualTable; ab: string; para: String = '');

// 소득세 공제가족수 조회
function getDeductFamilyCnt(mCode: string): Integer;

// 간이세액표 조회
{
  mCode     : 사원번호
  familyCnt : 공제가족수
  salAmt    : 월급여금액(비과세소득 제외)
  salYm     : 귀속연월 char(6) yyyymm

  return    : Result[0] 간이세액표에 의한 소득세
              Result[1] 급여하한금액(이상)
              Result[2] 급여상한급액(미만)
              Result[3] 맞춤형원정징수비율에 의한 소득세
}
function getSimpleTaxTable(mCode: string; familyCnt: Integer; salAmt: Double; salYm: string): TArray<Double>;

// 건강보험요율 조회
{
  yyyymm  : 귀속연월

  return  : Result[0] 근로자부담 건강보험요율
            Result[1] 노인장기요양보험요율
            Result[2] 장기요양보험 경감율
            Result[3] 보수월액 하한선
            Result[4] 보수월액 상한선
}
function getNhisRate(yyyymm: string): TArray<Double>;

// 건강보험료 계산
{
  mCode  : 사원번호
  oCode  : 법인코드
  yyyymm : 책정연월
  monthlyWageAmt : 보수월액, 0 이면 근로자의 보수월액 조회

  return  : Result[0] 건강보험료 가입자부담분
            Result[1] 장기요양보험료 가입자부담분
}
function getNhisAmt(mCode, oCode, yyyymm: String; monthlyWageAmt: Double = 0): TArray<Double>;

// 세액 산출근거 조회
{
  ab  : 구분자
        1 퇴직소득근속연수공제,
        2 퇴직소득환산급여공제,
        3 소득세기본세율,
        4 퇴직소득산출세액특례,
        5 근로소득공제
        6 근로소득세액공제

  ash : 구분자에 따라
        1 근속연수,
        2 환산급여금액,
        3 과세표준금액,
        4 종전규정 산출세액 비율(%),
        5 근로소득 총급여액

  dt : 회계연도 or 적용일자(19000101)

  return  : Result[0] 하한선
            Result[1] 상한선
            Result[2] 기준값 - 구분자에 따라 1 공제금액, 2 공제율, 3 세율, 4 퇴직연도, 5 공제율
            Result[3] 최대치
}
function getTaxBase(ab: string; ash: Double; dt: string = ''): TArray<Double>;

// 근로소득세액공제한도 조회
{
  totSalarAmt : 총급여액
  return      : 근로소득세액공제한도금액
}
function getEarnedIncomeDeductLimitAmt(totSalaryAmt: Double): Double;

// 전자신고파일 생성 이력 저장
{
  ereportAb   char(1) : 전자파일종류 - A 원천징수이행상황신고, B 이자배당소득, C 근로소득, D 의료비, ... (공통코드확인)
  presentYm   char(6) : 제출연월
  strfileCont         : 전자파일내용
}
procedure insertEReportHistory(ereportAb, bCode, oCode, presentYm, strfileCont: string; memo: string = '');

procedure chkEFile(eAb, strfileCont: string);

implementation

uses coop_sql_updel, Unit1, DB;

type
  TADBGrid = class(TDBGrid);

var
  days: array[0..11] of Integer = (31,28,31,30,31,30,31,31,30,31,30,31);
  weekdays: array[1..7] of string = ('일','월','화','수','목','금','토');
  arrCtrl: array of TControl;
  arrCipher: array[0..12] of string = ('일','십','백','천','만','십','백','천','억','십','백','천','조');
  arrStrNum: array[0..9] of string = ('영','일','이','삼','사','오','육','칠','팔','구');

  // 의료비지급명세서 A레코드 - 24항목
  arrM: array[0..23] of Integer = (1,  2,  3,  6,  8,   // 자료관리번호
                                  10, 20,  4,           // 제출자
                                  10, 40,               // 원천징수의무자
                                  13,  1, 30,           // 소득자(연말정산 신청자)
                                  10, 40,  1,           // 지급처
                                   5, 11,  1,           // 지급명세
                                  13,  1,  1,  1, 19);  // 의료비 공제 대상자


// 에러메세지
const
  MSG_ERR_CD1         = '선택 가능 항목이 없습니다.';                 // 공통코드 에러메세지1
  MSG_ERR_VAL1        = ' 항목은 필수값입니다.';                      // 유효성확인1
  MSG_ERR_VAL2        = ' 항목은 필수선택값입니다.';                  // 유효성확인2
  MSG_ERR_VAL_DATE1   = '일자 형식이 맞지않습니다.';                  // 날짜유효성확인1
  MSG_ERR_VAL_DATE2   = '입력기간의 시작일자가 종료일자보다 큽니다.'; // 날짜유효성확인2
  MSG_ERR_MATCH_OCODE = '해당 법인정보의 ERP단체코드를 확인하세요.';  // 법인코드, ERP단체코드 매칭오류
  MSG_NO_DATA         = '조회 결과가 없습니다.';


// 초기화면 위치 설정
procedure Set_MainPosition(app_main: TForm);
begin
 if (Screen.Width - app_main.Width) >= 0 then
  begin
    app_main.Left := (Screen.Width - app_main.Width) div 2;
    app_main.Top  := 0;
  end
 else
   app_main.Position := poScreenCenter;
end;

// 쿼리를 이력 저장형식으로 변환
function SQLToHistory(my_sql: String): String;
var
  AshStr: String;
  AshPosInt: Integer;
begin
  my_sql := Trim(my_sql);
  AshStr := UpperCase(my_sql);
  while Pos('NOW()',AshStr) <> 0 do
  begin
    AshPosInt:= Pos('NOW()',AshStr);
    System.Delete(my_sql,AshPosInt,5);
    System.Insert('"'+FormatDateTime('yyyy-mm-dd hh:mm:ss',Now)+'"',my_sql,AshPosInt);
    AshStr := UpperCase(my_sql);
  end;

  while (Pos('"',my_sql) <> 0) OR (Pos('''',my_sql) <> 0) do
  begin
    AshPosInt := Pos('"',my_sql);
    if AshPosInt = 0 then
      AshPosInt := Pos('''',my_sql);
    System.Delete(my_sql,AshPosInt,1);
    System.Insert('∬', my_sql,AshPosInt);
  end;

  my_sql := mpst_name+'['+mpst_code+']-('+FormatDateTime('yyyy-mm-dd hh:mm:ss', Now)+')'+#13#10+my_sql+#13#10;
  Result := my_sql;
end;

// 문자열 공백 제거
function DelBlank(pfStr: String): String;
begin
 while Pos(' ',pfStr) <> 0 do
   System.Delete(pfStr,Pos(' ',pfStr),1);

  Result := pfStr;
end;


// 그리드 타이틀 클릭 시 정렬
{
 1. 전역변수 선언
      colIdx: Integer; titleCaption: String;

 2. 조회 시 정렬초기화
      vt.IndexFieldNames := '';
      grid.Columns[colIdx].Title.Caption := titleCaption;

 3. OnTitleClick 이벤트에서 함수 호출
      sortGrid(colIdx, titleCaption, Column);
}
procedure sortGrid(var cIdx: Integer; var cTitleCaption: String; col: TColumn);
var
  colIdx: Integer;
  titleCaption, colName: String;

begin
  with TVirtualTable(col.Grid.DataSource.DataSet) do
  begin
    if (RecordCount > 1) then
    begin
      colIdx := col.Index;
      titleCaption := col.Title.Caption;
      colName := col.FieldName;

      if IndexFieldNames = colName then // ASC
      begin
        IndexFieldNames := colName + ' DESC';
        col.Title.Caption := cTitleCaption + '▼';
      end
      else if IndexFieldNames = colName + ' DESC' then // DESC
      begin
        IndexFieldNames := colName;
        col.Title.Caption := cTitleCaption + '▲';
      end
      else
      begin
        TDBGrid(col.Grid).Columns[cIdx].Title.Caption := cTitleCaption;

        cTitleCaption := titleCaption;
        IndexFieldNames := colName;
        col.Title.Caption := titleCaption + '▲';
      end;
      cIdx := colIdx;
    end;
  end;
end;

// 개발자 컨트롤 visible
procedure showCtrl(ctrl: TControl);
begin
  if (mpst_code = '0579033000') or (mpst_code = '2016060060') or (mpst_code = '2018010038') then // 0579033000 - 정송
  begin
    if ctrl.Visible then
      ctrl.Visible := false
    else
      ctrl.Visible := True;
  end
  else
    ctrl.Visible := false;
end;

// 전산매체 숫자 포맷
// 데이터 길이 및 부호(음수 : 1, 양수 : 0) 적용
{ val : 값
  len : 부호표시 시는 부호길이를 포함하지 않은 데이터 길이
  ab  : 부호표시여부(0 미포함, 1 포함)
}
function getENum(val, len: Integer; ab: Integer = 0): string; overload;
var
  sign: string;
begin
  if ab = 1 then
  begin
    if val < 0 then // 음수
    begin
      sign := '1';
      val := val * (-1); // 절대값
    end
    else // 양수
      sign := '0';
  end
  else
    sign := '';

  Result := sign + Format('%.' + IntToStr(len) + 'd', [val]);
end;
function getENum(val: Double; len: Integer; ab: Integer = 0): string; overload;
var
  intVal: Integer;
begin
  intVal := Trunc(val);
  Result := getENum(intVal, len, ab);
end;

// 전산매체 문자 포맷
{
  val : 문자열
  len : (최대)데이터길이
  trimYn : 공백제거여부
}
function getEStr(val: string; len: integer; trimYn:Boolean = False): string;
var
  str: AnsiString;
begin
  str := AnsiString(Trim(val));
  if trimYn then // 공백제거
  begin
    str := StringReplace(str, ' ', '', [rfReplaceAll, rfIgnoreCase]);
  end;

  if Length(str) > len then
  begin
    str := Copy(str, 1, len);
    // 한글 2Byte 문자 1Byte만 잘려서 한글 깨짐 현상
    // function ByteType(const S: string; Index: Integer): TMbcsByteType;
    // TMbcsByteType - mbSingleByte(1바이트 문자), mbLeadByte(2바이트 시작문자), mbTrailByte(2바이트 마지막문자)
    if SysUtils.ByteType(str, Length(str)) = mbLeadByte then // 마지막 문자 확인
      str := Copy(str, 1, len-1);
  end;

  Result := AnsiStrings.Format('%-' + IntToStr(len) + 's', [str]);
end;

// 전산매체 date to string
function dtToStr(dt: TDate): string;
var
  strDt: string;
begin
  if CompareDate(dt, StrToDate('1900/01/01')) = 1 then // A=B(0), A>B(1), A<B(-1)
    strDt := FormatDateTime('yyyymmdd', dt)
  else
    strDt := '00000000';
  Result := strDt;
end;

// Date로 요일조회
function getWeekday(date: TDateTime): String;
begin
  Result := weekdays[DayOfWeek(date)];
end;

// 숫자 한글로
function numToStr(num: Integer): string;
var
  i, len: Integer;
  ashCha, strNum, rst: string;
begin
  rst := '';
  strNum := IntToStr(num);
  len := Length(strNum);

  for i := 0 to len - 1 do
  begin
    ashCha := Copy(strNum, len-i, 1);

    if ashCha <> '0' then
      rst := arrStrNum[StrToInt(ashCha)] + arrCipher[i] + rst;
  end;

  Result := rst;
end;

// 숫자만 입력
procedure onlyNumber(var key: char);
const
  Bksp = #08; // Backspace키
begin
  if not (key in ['0'..'9', Bksp]) then
    key := #0;
end;

// 문자열 null 확인
function isEmpty(str: String): Boolean;
begin
  if (Trim(str) = '') or (Length(Trim(str)) = 0) then
    result := False
  else
    result := True;
end;

// RPAD
function rpad(str, pad:string; len: Integer): string;
var
  i: Integer;
  rst: string;
begin
  rst := str;

  for i := Length(str) to len - 1 do
  begin
    rst := rst + pad;
  end;

  Result := rst;
end;

// 필수입력항목 확인
{ obj: 필수입력컴포넌트명
  lab: 필수입력항목 label
}
function chkExtVal(obj: TComponent; lab: String): Boolean;
begin
  if obj is TEdit then
  begin
    if not isEmpty(Trim(TEdit(obj).Text)) then
    begin
      ShowMessage(lab + MSG_ERR_VAL1);
      TEdit(obj).SetFocus;
      Result := False;
    end
    else Result := True;
  end
  else if obj is TMaskEdit then
  begin
    if not isEmpty(Trim(TMaskEdit(obj).Text)) then
    begin
      ShowMessage(lab + MSG_ERR_VAL1);
      TMaskEdit(obj).SetFocus;
      Result := False;
    end
    else Result := True;
  end
  else if obj is TComboBox then
  begin
    if (TComboBox(obj).ItemIndex = 0)
      and ((Pos('선택', TComboBox(obj).Items[0]) > 0) or (TComboBox(obj).Items[0] = '전체')) then
    begin
      ShowMessage(lab + MSG_ERR_VAL2);
      TComboBox(obj).SetFocus;
      SendMessage(TComboBox(obj).Handle, CB_SHOWDROPDOWN, Integer(True), 0);
      Result := False;
    end
    else Result := True;
  end
  else if obj is TcxComboBox then
  begin
    if TcxComboBox(obj).ItemIndex < 1 then
    begin
      ShowMessage(lab + MSG_ERR_VAL2);
      TcxComboBox(obj).SetFocus;
      SendMessage(TcxComboBox(obj).Handle, CB_SHOWDROPDOWN, Integer(true), 0);
      Result := False;
    end
    else Result := True;
  end
  else if obj is TcxLookupComboBox then
  begin
    if TcxLookupComboBox(obj).ItemIndex < 1 then
    begin
      ShowMessage(lab + MSG_ERR_VAL2);
      TComboBox(obj).SetFocus;
      Result := False;
    end
    else Result := True;
  end
  else if obj is TcxCurrencyEdit then
  begin
    if TcxCurrencyEdit(obj).Value = 0 then
    begin
      ShowMessage(lab + MSG_ERR_VAL1);
      TcxCurrencyEdit(obj).SetFocus;
      Result := False;
    end
    else Result := True;
  end
  else if obj is TDateTimePicker then
  begin
    if DateToStr(TDateTimePicker(obj).Date) = '1900/01/01' then // 디폴트값 변경 확인
    begin
      ShowMessage(lab + ' 일자를 확인하세요.');
      TDateTimePicker(obj).SetFocus;
      Result := False;
    end
    else Result := True;
  end
  else if obj is TCheckListBox then
  begin
    if getCklChkCnt(TCheckListBox(obj)) = 0 then
    begin
      ShowMessage(lab + MSG_ERR_VAL2);
      TCheckListBox(obj).SetFocus;
      Result := False;
    end
    else Result := True;
  end
  else Result := True;
end;

// 공통콤보박스 옵션 'N'일 때 선택항목 유무 확인
// 콤보박스 index 0의 text 옵션 (A:전체, S:선택하세요, N:없음)
function chkCbCommCode(obj: TComboBox): Boolean;
begin
  if obj.Text = MSG_ERR_CD1 then
  begin
    ShowMessage('선택 가능한 항목이 없습니다.');
    Result := False;
  end
  else
    Result := True;
end;

// 사원번호, 부서번호 유효성 확인
{ ntype - 1: 사원번호
          2: 부서번호
}
function chkTypeNo(obj: TEdit; ntype: Integer = 1): Boolean;
begin
  case ntype of
    1: // 사원번호
    begin
      if (not isEmpty(Trim(obj.Text))) or (Length(Trim(obj.Text)) <> 10) then
      // 2014-02-07 홍익인간 데이터 이관 시 사원번호 10자리가 아닌 사원 존재하여 수정 (31풀무법인 63명)
      //if (not isEmpty(Trim(obj.Text))) or (Length(Trim(obj.Text)) > 10) then
      begin
        ShowMessage('사원번호를 확인하세요.');
        obj.SetFocus;
        result := False;
      end
      else Result := True;
    end;
    2: // 부서코드
    begin
      if (not isEmpty(Trim(obj.Text))) {or (Length(Trim(obj.Text)) <> 4) or (not TryStrToInt(Copy(Trim(obj.Text),2,3), i))} then
      begin
        ShowMessage('부서코드를 확인하세요.');
        obj.SetFocus;
        result := False;
      end
      else Result := True;
    end
    else Result := True;
  end;
end;

// 주민등록번호 유효성 확인
{idNo : - 제외한 숫자 13자리}
function chkIdNo(const idNo: String): Boolean;
const weight = '234567892345';
var
  Sum, i: Integer;
  res: Integer;
begin
  Result := False;

  if Length(Trim(idNo)) <> 13 then Exit;

  if StrToInt(idNo[7]) in [5, 6, 7, 8] then // 외국인등록번호 유효성
  begin
    Sum := 0;
    for i := 1 to 12 do
      Sum := Sum + (StrToInt(idNo[i]) * StrToInt(weight[i]));

    res := (11 - (Sum mod 11)) mod 10 + 2;

    if res = 10 then res := 0
    else if res = 11 then res := 1;

    if res = StrToInt(idNo[13]) then
      Result := True;
  end
  else // 주민번호 유효성
  begin
    Sum := 0;
    for i := 1 to 12 do
      Sum := Sum + (StrToInt(idNo[i]) * StrToInt(weight[i]));

    res := (11 - (Sum mod 11)) mod 10;

    if res = StrToInt(idNo[13]) then
      Result := True;
  end;
end;

// 외국인등록번호 유효성 확인
function chkForeignNo(const idNo: String): Boolean;
const weight = '234567892345';
var
  Sum, i: Integer;
  res: Integer;
begin
  Result := False;

  if Length(Trim(idNo)) <> 13 then Exit
  //else if StrToInt(idNo[12]) in [5, 6, 7, 8] then Exit
  //else if ((StrToInt(idNo[8]) * 10 + StrToInt(idNo[9])) div 2) <> 0 then Exit
  else
  begin
    Sum := 0;
    for i := 1 to 12 do
      Sum := Sum + (StrToInt(idNo[i]) * StrToInt(weight[i]));

    res := (11 - (Sum mod 11)) mod 10 + 2;

    if res = 10 then res := 0
    else if res = 11 then res := 1;

    if res = StrToInt(idNo[13]) then
      Result := True;
  end;
end;

// 사업자등록번호 유효성 확인
{bizRegNo : - 제외한 숫자 10자리}
function chkBizRegNo(const bizRegNo: String): Boolean;
const weight = '1371371351';
var
  Sum, i: Integer;
  res: Integer;
begin
  Result := False;

  if Length(Trim(bizRegNo)) <> 10 then Exit
  else
  begin
    Sum := 0;
    for i := 1 to 9 do
      Sum := Sum + (StrToInt(bizRegNo[i]) * StrToInt(weight[i]));

    res := (10 - (sum + Trunc(StrToInt(bizRegNo[9]) * 5 / 10)) mod 10) mod 10;

    if res = StrToInt(bizRegNo[10]) then
      Result := True;
  end;
end;

// splitCd - 코드 콤보박스 문자열 구분자로 나눠서 코드, 코드값 리턴
{ Str       : 문자열
  Position  : 1-코드, 2-코드값
  Delimiter : 구분자
}
function splitCd(str: String; const position: Integer = 1; const delimiter: string = ' '): string;
var
  strLen, komPos: integer;
begin
  Result := '';
  strLen := Length(Str);
  komPos := Pos(delimiter, str);

  if position = 1 then
    Result := Trim(Copy(str, 1, komPos))
  else if position = 2 then
    Result := Trim(Copy(str, komPos+1, strLen));
end;

// split - 문자열 구분자로 나눠서 원하는 위치(순서)의 문자 리턴
{ Str       : 문자열
  Position  : 순서
  Delimiter : 구분자
}
function subStr(str: String; const position: Integer = 1; const delimiter: string = ' '): string;
var
  strLen, zeichenIdx, subIdx, komPos: integer;
begin
  Result    := '';
  str       := str + delimiter;
  strLen    := Length(Str);
  zeichenIdx:= 1;
  subIdx    := 1;

  While zeichenIdx <= strLen do
  begin
    komPos := Pos(delimiter, str);

    if komPos <> 0 then
    begin
      if subIdx = position then
      begin
        Result := Copy(str, 1, komPos - 1);
        break;
      end;

      Delete(Str, 1, komPos);
      Inc(subIdx);
    end;
    Inc(zeichenIdx);
  end;
end;

// TcxLookupComboBox 공통코드 설정
procedure setCbxComm(vt: TVirtualTable; ab: string; para: String = '');
var
  ashSQL, ashStr: string;
begin
  if ab = 'city_code' then // 시도코드
  begin
    ashSQL := 'SELECT hr_code_value city_code, hr_code_value_name city_name'
            + ' FROM hr_common_code_value'
            + ' WHERE hr_code_id = "hr_city_code"'
            + ' AND hr_use_yn = "Y"'
            + ' ORDER BY hr_sort_seq';
  end

  else if ab = 'sigungu_code' then // 시군구코드
  begin
    ashSQL := 'SELECT hr_code_value sigungu_code, hr_code_value_name sigungu_name'
            + ' FROM hr_common_code_value'
            + ' WHERE hr_code_id = "hr_sigungu_code"'
            + ' AND hr_use_yn = "Y"'
            + ' AND hr_code_value LIKE "' + para + '%" '
            + ' ORDER BY hr_code_value_name ASC';
  end

  else if ab = 'dong_code' then // 법정동코드
  begin
    ashSQL := 'SELECT hr_code_value dong_code, hr_code_value_name dong_name'
            + ' FROM hr_common_code_value'
            + ' WHERE hr_code_id = "hr_dong_code"'
            + ' AND hr_use_yn = "Y"'
            + ' AND hr_code_value LIKE "' + para + '%" '
            + ' ORDER BY hr_code_value_name ASC';
  end

  else if ab = 'local_dong_code' then  // 지방소득세 법정동코드
  begin
    ashSQL := 'SELECT hr_code_value local_dong_code, hr_code_value_name local_dong_name'
            + ' FROM hr_common_code_value'
            + ' WHERE hr_code_id = "hr_local_dong_code"'
            + ' AND hr_use_yn = "Y"'
            + ' AND hr_code_value LIKE "' + para + '%" '
            + ' ORDER BY hr_code_value_name ASC';
  end;

  ashStr := MySQL_Assign(Form1.db_coophr, Form1.qrysql, ashSQL, vt);
  try
    StrToInt(ashStr);
  except
    if mpst_code = '0579033000' then
    begin
      ShowMessage(ashStr);
    end;
  end;
end;

// TcxLookupComboBox 세팅
// cbFirTxt : 콤보박스 index 0의 text (A:전체, S:선택하세요, B:일괄제출, N:없음)
// usercode :
procedure setCbx(vt: TVirtualTable; codeId, cbFirTxt: string; userCode:String = ''; userCode2:String = '');
var
  ashSQL, ashStr: String;
begin
  ashStr := '';
  if codeId = 'o_code' then // 사용자의 해당 프로그램의 권한있는 법인 조회
  begin
    ashSQL := 'SELECT hr_o_name, hr_o_code, hr_o_unit_tax_yn'
            + ' FROM hr_company'
            + ' WHERE hr_o_code IN (SELECT hr_obp_code'
                                  + ' FROM hr_sustaff_log'
                                  + ' WHERE hr_m_code = "' + mpst_code + '"'
                                  + ' AND hr_pro_name = "' + ExtractFileName(Application.ExeName) + '"'
                                  + ' AND hr_obp_ab = "O"'
                                  + ' AND p_ab = "A")'
                                  + userCode;

form1.memo1.Lines.add('o_code ' + ashSQL);
  end

  // 사원의 소속 법인 조회
  else if codeId = 'emp_o_code' then  // <-- 쿼리 수정
  begin
    // 퇴사자의 경우 퇴사법인 포함
    if userCode2 = '2' then  // 사원구분코드 - 2:퇴사자
    begin
      ashSQL := 'SELECT C.hr_o_code, C.hr_o_name, C.hr_o_unit_tax_yn '
                + 'FROM hr_company C '
                + 'JOIN hr_group_his G '
                + 'ON C.hr_o_code = G.hr_o_code '
                + 'WHERE 1=1 '
                + 'AND (G.hr_b_code, G.hr_seq_no) IN (SELECT hr_b_code, MAX(hr_seq_no) FROM hr_group_his '
                                                    + 'WHERE hr_m_code = "' + userCode + '" '
                                                    + 'GROUP BY hr_b_code) '
                + 'AND G.hr_m_code = "' + userCode + '" '
                + 'AND G.hr_update_yn = "N" '
                + 'GROUP BY C.hr_o_code '
                + 'ORDER BY G.hr_changeday DESC LIMIT 1';
    end
    else  // 사원의 소속법인 조회
    begin
      ashSQL := 'SELECT C.hr_o_code, C.hr_o_name, C.hr_o_unit_tax_yn '
                + 'FROM hr_company C '
                + 'JOIN hr_group_his G '
                + 'ON C.hr_o_code = G.hr_o_code '
                + 'WHERE 1=1 '
                + 'AND (G.hr_b_code, G.hr_seq_no) IN (SELECT hr_b_code, MAX(hr_seq_no) FROM hr_group_his '
                                                    + 'WHERE hr_m_code = "' + userCode + '" '
                                                    + 'AND hr_update_yn = "N" '
                                                    + 'GROUP BY hr_b_code) '
                + 'AND G.hr_m_code = "' + userCode + '" '
                + 'AND G.hr_update_yn = "N" '
                + 'GROUP BY C.hr_o_code '
                + 'ORDER BY C.hr_o_code ASC';
    end;
  end

  // 선택 법인의 사업장 조회
  else if codeId = 'b_code' then
  begin
    // 사업자단위과세신고유무 조회
    {ashSQL := 'SELECT hr_o_unit_tax_yn FROM hr_company WHERE hr_o_code = "' + userCode + '"';
    ashStr := MySQL_Assign(Form1.db_coophr, Form1.qrysql, ashSQL, vt);
    try
      StrToInt(ashStr);
    except
      if mpst_code = '0579033000' then
      begin
        ShowMessage(ashStr);
      end;
    end;

    if vt.FieldByName('hr_o_unit_tax_yn').AsString = 'Y' then}
    if userCode2 = 'Y' then // 사업자단위과세신고유무
    begin
      // 본점 사업장 조회
      {ashSQL := 'SELECT "일괄제출" hr_b_name'
              //+ 'SELECT IF(hr_b_head_yn = "Y", "일괄제출", hr_b_name) hr_b_name'
              + ', hr_b_code, hr_b_head_yn, hr_b_half_yearly_yn'
              + ' FROM hr_branch'
              + ' WHERE hr_o_code = "' + userCode + '"'
              + ' AND hr_b_head_yn = "Y"'
              + ' AND hr_b_use_yn = "Y"';
      }
      // 2018-04-18 [CUG-1901863] 사업자단위과세 법인도 사업장 선택하여 조회할 수 있도록 수정
      ashSQL :=  'SELECT "일괄제출" hr_b_name, "000" hr_b_code, "" hr_b_head_yn, hr_b_half_yearly_yn'
              + ' FROM hr_branch'
              + ' WHERE hr_o_code = "' + userCode + '"'
              + ' AND hr_b_head_yn = "Y"'
              + ' AND hr_b_use_yn = "Y"'
              + ' UNION ALL'
              + ' SELECT hr_b_name , hr_b_code, hr_b_head_yn, hr_b_half_yearly_yn'
              + ' FROM hr_branch'
              + ' WHERE hr_o_code = "' + userCode + '"'
              + ' AND hr_b_use_yn = "Y"';

      cbFirTxt := '';
    end
    else
    begin
      ashSQL := 'SELECT hr_b_name, hr_b_code, hr_b_head_yn, hr_b_half_yearly_yn'
              + ' FROM hr_branch'
              + ' WHERE hr_o_code = "' + userCode + '"'
              + ' AND hr_b_use_yn = "Y"';
    end;
  end

  // 선택 법인의 사용 근무조 조회
  else if codeId = 'unit_code' then
  begin
    ashSQL := 'SELECT hr_unit_name, hr_unit_code FROM hr_work_unit'
            + ' WHERE hr_o_codelist LIKE "%' + userCode + '%"'
            + ' AND hr_use_yn = "Y"';

form1.memo1.Lines.add('unit_code ' + ashSQL);
  end

  // 공통코드
  else
  begin
    if userCode <> '' then
      ashStr := ' AND hr_code_value = "' + userCode + '"';

    ashSQL := 'SELECT hr_code_value_name nm, hr_code_value cd, hr_memo ab'
            + ' FROM hr_common_code_value'
            + ' WHERE hr_code_id = "' + codeId + '"'
            + ashStr
            + ' AND hr_use_yn <> "N"'
            + ' ORDER BY hr_sort_seq ASC, hr_code_value ASC';
  end;

  ashStr := MySQL_Assign(Form1.db_coophr, Form1.qrysql, ashSQL, vt);
  try
    StrToInt(ashStr);
  except
    if mpst_code = '0579033000' then
    begin
      ShowMessage(ashStr);
    end;
  end;

  if vt.RecordCount < 1 then
  begin
    vt.Clear;
    vt.InsertRecord([MSG_ERR_CD1]); // 조회 권한이 없습니다
    Exit;
  end;

  if cbFirTxt = 'A' then
    vt.InsertRecord(['전체'])
  else if cbFirTxt = 'S' then
    vt.InsertRecord(['선택하세요'])
  else if cbFirTxt = 'B' then
    vt.InsertRecord(['일괄제출']);
end;

// 소속, 사업장, 직급, 직책 콤보박스 세팅
{ dsNm      : TZQuery명
  codeId    : 공통코드ID
  cbFirTxt  : 콤보박스 index 0의 text (A:전체, S:선택하세요, N:없음, C:코드만, M:코드명만)
  cbNm      : 콤보박스명
  userCode  : 사원번호(사원의 소속법인 조회 시), 법인코드(사업장, 근무조 조회 시),  그 외는 ''
  sort      : '' 코드정렬, M 코드명정렬
}
procedure setCbCode(db: TZConnection; dsNm: TZQuery; codeId, cbFirTxt: String; cbNm: TWinControl; userCode:String = ''; userCode2:String = '');
var
  ashSQL, subSQL, ashStr: String;

begin
  if codeId = 'o_code' then // 사용자의 해당 프로그램의 권한있는 법인 조회
  begin
    if mpst_code = '0579033000' then
      ashSQL := 'SELECT hr_o_code, hr_o_name FROM hr_company WHERE hr_o_use_yn = "Y"'
    else
      ashSQL := 'SELECT hr_o_code, hr_o_name '
              + 'FROM hr_company '
              + 'WHERE hr_o_code IN (SELECT hr_obp_code '
                                    + 'FROM hr_sustaff_log '
                                    + 'WHERE hr_m_code = "' + mpst_code + '" '
                                    + 'AND hr_pro_name = "' + ExtractFileName(Application.ExeName) + '" '
                                    + 'AND hr_obp_ab = "O" '
                                    + 'AND p_ab = "A")'
              + ' AND hr_o_use_yn = "Y"';
  end

  else if codeId = 'emp_o_code' then // 사원의 소속법인 조회
  begin
    // 2014.07.10 추가 - 퇴사자의 경우 퇴사법인 보여준다.
    if userCode2 = '2' then  // 사원구분코드 - 2:퇴사자
    begin
      ashSQL := 'SELECT C.hr_o_code, C.hr_o_name '
                + 'FROM hr_company C '
                + 'JOIN hr_group_his G '
                + 'ON C.hr_o_code = G.hr_o_code '
                + 'WHERE 1=1 '
                + 'AND (G.hr_o_code, G.hr_seq_no) IN (SELECT hr_o_code, MAX(hr_seq_no) FROM hr_group_his '
                                                    + 'WHERE hr_m_code = "' + userCode + '" '
                                                    + 'GROUP BY hr_o_code) '
                + 'AND G.hr_m_code = "' + userCode + '" '
                + 'AND G.hr_update_yn = "N" '
                + 'ORDER BY G.hr_changeday DESC LIMIT 1';
    end
    else  // 사원의 소속법인 조회
    begin
      // 등록모드 일 때 현재 소속 법인만 선택
      {subSQL := '';
      if userCode2 = '1' then
      begin
        subSQL := 'AND G.hr_ab NOT IN ("B", "E") ';  // 퇴사한 소속의 데이터 변경 필요로 수정(총무팀 요청)으로 주석
      end;
      }
      ashSQL := 'SELECT C.hr_o_code, C.hr_o_name '
                + 'FROM hr_company C '
                + 'JOIN hr_group_his G '
                + 'ON C.hr_o_code = G.hr_o_code '
                + 'WHERE 1=1 '
                + 'AND (G.hr_o_code, G.hr_seq_no) IN (SELECT hr_o_code, MAX(hr_seq_no) FROM hr_group_his '
                                                    + 'WHERE hr_m_code = "' + userCode + '" '
                                                    + 'AND hr_update_yn = "N" '
                                                    + 'GROUP BY hr_o_code) '
                + 'AND G.hr_m_code = "' + userCode + '" '
                //+ subSQL
                + 'AND G.hr_update_yn = "N" '
                + 'ORDER BY C.hr_o_code ASC';
    end;
  end

  // 모든 법인 조회
  else if codeId = 'a_o_code' then
  begin
    ashSQL := 'SELECT hr_o_code, hr_o_name '
            + 'FROM hr_company '
            + 'WHERE 1=1 '
            //+ 'AND hr_o_use_yn = "Y" '
            + 'AND hr_o_code NOT IN ("0098","0099","9998","9999")'
  end

  // 근속수당 지급 법인 조회
  else if codeId = 'old_o_code' then
  begin
    ashSQL := 'SELECT hr_o_code, hr_o_name '
            + 'FROM hr_company '
            + 'WHERE hr_o_use_yn = "Y" '
            + 'AND hr_o_old_yn = "Y"'
  end

  // 사용자의 해당 프로그램의 권한있는 법인 소속 사업장과 권한있는 사업장 조회
  else if (codeId = 'b_code') and (userCode = '')  then
  begin
    ashSQL := 'SELECT '
            + 'CONCAT(hr_o_code, "-", hr_b_code) hr_b_code'
            + ', hr_b_name '
            + 'FROM hr_branch '
            + 'WHERE hr_o_code IN (SELECT hr_obp_code '
                                + 'FROM hr_sustaff_log '
                                + 'WHERE hr_m_code = "' + mpst_code + '" '
                                + 'AND hr_pro_name = "' + ExtractFileName(Application.ExeName) + '" '
                                + 'AND hr_obp_ab = "O" '
                                + 'AND p_ab = "A")'
            + 'OR hr_b_code IN (SELECT hr_obp_code '
                                + 'FROM hr_sustaff_log '
                                + 'WHERE hr_m_code = "' + mpst_code + '" '
                                + 'AND hr_pro_name = "' + ExtractFileName(Application.ExeName) + '" '
                                + 'AND hr_obp_ab = "B" '
                                + 'AND p_ab = "A")'
            + ' AND hr_b_use_yn = "Y"';

    // 폐업사업장 제외
    if userCode2 <> '' then // 폐업일자
    begin
      ashSQL := ashSQL + ' AND (hr_b_end_day >= "' + userCode2 + '" OR hr_b_end_day <= "1900-01-01")' // 폐업사업장 제외
    end
    else
    begin
      ashSQL := ashSQL + ' AND (hr_b_end_day >= NOW() OR hr_b_end_day <= "1900-01-01")'
    end;
  end

  // 해당 법인의 사업장 조회
  else if (codeId = 'b_code') and (userCode <> '') then
  begin
    ashSQL := 'SELECT '
            + 'CONCAT(hr_o_code, "-", hr_b_code) hr_b_code'
            + ', hr_b_name '
            + 'FROM hr_branch '
            + 'WHERE hr_o_code = "' + userCode + '"'
            + ' AND hr_b_use_yn = "Y"';

    // 폐업사업장 제외
    if userCode2 <> '' then
    begin
      ashSQL := ashSQL + ' AND (hr_b_end_day >= "' + userCode2 + '" OR hr_b_end_day <= "1900-01-01")' // 폐업사업장 제외
    end
    else
    begin
      ashSQL := ashSQL + ' AND (hr_b_end_day >= NOW() OR hr_b_end_day <= "1900-01-01")'
    end;
  end

  // 사원의 현재 소속 사업장 조회  2015-07-06 추가
  else if (codeId = 'emp_b_code') then
  begin
    subSQL := '';
    if userCode2 <> '' then
    begin
      subSQL := ' AND hr_o_code = "' + userCode2+ '"';
    end;

    ashSQL := 'SELECT CONCAT(hr_o_code, "-", hr_b_code) hr_b_code, (SELECT hr_b_name FROM hr_branch WHERE hr_b_code = hr_group_his.hr_b_code) hr_b_name'
            + ' FROM hr_group_his'
            + ' WHERE hr_m_code = "' + userCode + '"'
            + ' AND (hr_b_code, hr_seq_no) IN (SELECT hr_b_code, MAX(hr_seq_no) FROM hr_group_his'
                                            + ' WHERE hr_m_code = "' + userCode + '"'
                                            + subSQL
                                            + ' AND hr_update_yn = "N"'
                                            + ' GROUP BY hr_b_code, hr_m_code)'
            + ' AND hr_update_yn = "N"';
            //+ ' AND hr_ab NOT IN ("B", "E")';  // 퇴사자 사업장 조회되게 주석처리
  end

  // 직급
  else if codeId = 'po_code' then
  begin
    ashSQL := 'SELECT hr_po_code'
            + ', hr_po_name '
            + 'FROM hr_position '
            + 'WHERE hr_use_yn <> "N" '
            + 'ORDER BY hr_po_code';
  end

  // 직책
  else if codeId = 'du_code' then
  begin
    ashSQL := 'SELECT'
            + ' hr_du_code'
            + ', hr_du_name '
            + 'FROM hr_duty '
            + 'WHERE hr_use_yn <> "N" '
            + 'AND hr_du_ab = "A"'
            + 'ORDER BY hr_du_code';
  end

  // 사용자의 권한있는 부서 조회
  else if codeId = 'post_code' then
  begin
    {ashSQL := 'SELECT'
            + ' post_code'
            + ', post_name '
            + 'FROM admin_post '
            + 'WHERE post_code IN (SELECT hr_obp_code '
                                + 'FROM hr_sustaff_log '
                                + 'WHERE hr_m_code = "' + mpst_code + '" '
                                + 'AND hr_pro_name = "' + ExtractFileName(Application.ExeName) + '" '
                                + 'AND hr_obp_ab = "P" '
                                + 'AND p_ab = "A")';
    }

    ashSQL := 'SELECT hr_obp_code '
          + 'FROM hr_sustaff_log '
          + 'WHERE hr_m_code = "' + mpst_code + '" '
          + 'AND hr_pro_name = "' + ExtractFileName(Application.ExeName) + '" '
          + 'AND hr_obp_ab = "P" '
          + 'AND p_ab = "A"';

    ashStr := MySQL_Assign(Form1.db_coophr, dsNm, ashSQL, Form1.vtTemp);
    try
      StrToInt(ashStr);
    except
      if mpst_code = '0579033000' then
      begin
        ShowMessage(ashStr);
      end;
    end;

    ashStr := '""';
    Form1.vtTemp.First;
    while not Form1.vtTemp.Eof do
    begin
      if ashStr = '' then
        ashStr := '"' + Form1.vtTemp.FieldByName('hr_obp_code').AsString + '"'
      else
        ashStr := ashStr + ',"' + Form1.vtTemp.FieldByName('hr_obp_code').AsString + '"';
      Form1.vtTemp.Next;
    end;

    ashSQL := 'SELECT post_code, post_name '
            + 'FROM admin_post '
            + 'WHERE post_code IN (' + ashStr + ')';

  end

  // 개인수당/공제
  else if codeId = 'pr_sudnag_code' then
  begin
    ashSQL := 'SELECT hr_sg_code, hr_sg_name FROM hr_sudang_gongje '
            + 'WHERE hr_sg_ab = "D" ' // D:개인수당/공제
            + 'AND hr_basic_yn <> "Y" ' // Y:연봉계약서 항목
            + 'AND hr_use_yn = "Y"';
  end

  // 상여코드
  else if codeId = 'bonus_code' then
  begin
   ashSQL := 'SELECT hr_sg_code, hr_sg_name'
          + ' FROM hr_sudang_gongje'
          + ' WHERE hr_sg_ab = "C" AND hr_use_yn <> "N"';
  end

  // 근무조
  else if codeId = 'unit_code' then
  begin
    if userCode = '' then // 전체 근무조
      ashSQL := 'SELECT hr_unit_code'
              + ', hr_unit_name '
              + 'FROM hr_work_unit '
              + 'WHERE hr_use_yn = "Y"'
    else
      ashSQL := 'SELECT hr_unit_code'
              + ', hr_unit_name '
              + 'FROM hr_work_unit '
              + 'WHERE hr_o_codelist REGEXP "' + userCode + '" '
              + 'AND hr_use_yn = "Y"';
  end

  {else if (codeId = 'unit_code') and (userCode = '') then // 근무조
  begin
      ashSQL := 'SELECT'
              + ' hr_unit_code'
              + ', hr_unit_name '
              + 'FROM hr_work_unit';
  end
  else if (codeId = 'unit_code') and (Length(userCode) = 2) then
  begin
      ashSQL := 'SELECT'
              + ' hr_unit_code'
              + ', hr_unit_name '
              + 'FROM hr_work_unit '
              + 'WHERE hr_o_code = "' + userCode + '" ';
  end
  else if (codeId = 'unit_code') and (Length(userCode) = 6) then
  begin
      ashSQL := 'SELECT'
              + ' hr_unit_code'
              + ', hr_unit_name '
              + 'FROM hr_work_unit '
              + 'WHERE hr_o_code = "' + Copy(userCode,1,2) + '" '
              + 'AND hr_b_code = "' + Copy(userCode,4,3) + '"';
  end;
  }

  // 근무지코드
  else if codeId = 'w_code' then
  begin
    if userCode <> '' then
      subSQL := ' AND hr_work_place_div = "' + userCode + '"'
    else
      subSQL := '';

    if userCode2 = 'M' then
      subSQL := subSQL + ' ORDER BY hr_w_name';

    ashSQL := 'SELECT hr_w_code, hr_w_name FROM hr_office'
            + ' WHERE hr_use_yn = "Y"'
            + subSQL;
  end

  else if codeId = 'common_code' then
  begin
    ashSQL := 'SELECT hr_code_value cd, hr_code_value_name nm, hr_memo ab'
            + ' FROM hr_common_code_value'
            + ' WHERE hr_code_id = "' + userCode + '"'
            + ' AND hr_use_yn <> "N"'
            + ' ORDER BY hr_sort_seq ASC, hr_code_value ASC';
  end;

  ashStr := MySQL_Assign(db, dsNm, AshSQL, Form1.vtTemp);
  try
    StrToInt(ashStr);
  except
    if mpst_code = '0579033000' then
    begin
      ShowMessage(ashStr);
    end;
  end;

  if (cbNm is TComboBox) then
  begin
    with TComboBox(cbNm)do
    begin
      Clear;

      if cbFirTxt = 'A' then Items.Add('전체')
      else if cbFirTxt = 'S' then Items.Add('선택하세요');

      if Form1.vtTemp.RecordCount < 1 then
      begin
        Clear;
        items.Add(MSG_ERR_CD1); // 조회 권한이 없습니다
      end;

      while not Form1.vtTemp.Eof do
      begin
        if cbFirTxt = 'C' then // 코드
          ashStr := Form1.vtTemp.Fields[0].AsString
        else if cbFirTxt = 'M' then // 코드명
          ashStr := Form1.vtTemp.Fields[1].AsString
        else // 코드 + ' ' + 코드명
          ashStr := Form1.vtTemp.Fields[0].AsString + ' ' + Form1.vtTemp.Fields[1].AsString;

        Items.Add(ashStr);
        ashStr := '';
        Form1.vtTemp.Next;
      end;
      ItemIndex := 0;
    end;
  end

  else if (cbNm is TCheckListBox) then
  begin
    with TCheckListBox(cbNm) do
    begin
      Clear;

      if cbFirTxt = 'A' then Items.Add('전체');

      if Form1.vtTemp.RecordCount < 1 then
      begin
        Clear;
        items.Add(MSG_ERR_CD1); // 조회 권한이 없습니다
        ItemEnabled[0] := False;
      end;

      while not Form1.vtTemp.Eof do
      begin
        ashStr := Form1.vtTemp.Fields[0].AsString + ' ' + Form1.vtTemp.Fields[1].AsString;
        Items.Add(ashStr);
        ashStr := '';
        Form1.vtTemp.Next;
      end;
      ItemIndex := 0;
    end;
  end

  else if (cbNm is TcxCheckListBox) then
  begin
    with TcxCheckListBox(cbNm) do
    begin
      Clear;

      if cbFirTxt = 'A' then AddItem('전체');

      if Form1.vtTemp.RecordCount < 1 then
      begin
        Clear;
        AddItem(MSG_ERR_CD1); // 조회 권한이 없습니다
        Items[0].Enabled := False;
      end;

      while not Form1.vtTemp.Eof do
      begin
        ashStr := Form1.vtTemp.Fields[0].AsString + ' ' + Form1.vtTemp.Fields[1].AsString;
        AddItem(ashStr);
        ashStr := '';
        Form1.vtTemp.Next;
      end;
      //ItemIndex := 0;
    end;
  end

  else if (cbNm is TcxCheckComboBox) then
  begin
    TcxCheckComboBox(cbNm).Properties.Items.Clear;

    with TcxCheckComboBox(cbNm).Properties do
    begin
      //if cbFirTxt = 'A' then items.AddCheckItem('전체');

      if Form1.vtTemp.RecordCount < 1 then
      begin
        items.Clear;
        items.AddCheckItem(MSG_ERR_CD1); // 조회 권한이 없습니다
        items[0].Enabled := False;
      end;

      while not Form1.vtTemp.Eof do
      begin
        Items.AddCheckItem(Form1.vtTemp.Fields[0].AsString + ' ' + Form1.vtTemp.Fields[1].AsString, Form1.vtTemp.Fields[0].AsString);
        Form1.vtTemp.Next;
      end;
    end;
  end;
end;

// cxTreeList 초기화
// checkedYn : True - 전체선택, False - 전체해제
procedure setTlInit(tlNm:TcxControl; checkedYn: Boolean = False);
var
  i: Integer;
begin
  // cxTreeList 체크박스 초기화
  for i := 0 to TcxTreeList(tlNm).AbsoluteCount - 1 do
  begin
    if checkedYn then
    begin
      TcxTreeList(tlNm).AbsoluteItems[i].CheckState := cbsChecked;
      TcxTreeList(tlNm).Root.Expand(True);
    end
    else
    begin
      TcxTreeList(tlNm).AbsoluteItems[i].CheckState := cbsUnchecked;
      TcxTreeList(tlNm).Root.Collapse(True);
    end;
  end;
end;

// cxGrid 체크박스 checked count
function getGrdviChkCnt(vt: TVirtualTable; fieldNm: string = 'useYn'): Integer;
var
  chkCnt, i, rowNo: Integer;
begin
  //isScroll := False;

  chkCnt := 0;

  vt.DisableControls;
  rowNo := vt.RecNo;

  vt.First;
  while not vt.Eof do
  begin
    if vt.FieldByName(fieldNm).AsInteger = 1 then
    begin
      chkCnt := chkCnt + 1;
    end;
    vt.Next;
  end;

  vt.RecNo := rowNo;
  vt.EnableControls;

  Result := chkCnt;
end;

// cxGrid 체크박스 전체 선택하면 전체선택 체크박스 설정
procedure setXChkGrdviChk(vt: TVirtualTable; xchk: TcxCheckBox; fieldNm: string = 'useYn');
var
  rowNo: Integer;
begin
  if vt.RecordCount = 0 then Exit;

  vt.DisableControls;
  rowNo := vt.RecNo;

  if getGrdviChkCnt(vt, fieldNm) = vt.RecordCount then
  begin
    xchk.Checked := True;
  end
  else
  begin
    xchk.Checked := False;
  end;

  vt.RecNo := rowNo;
  vt.EnableControls;
end;

// 전체 선택 cxChekBox 선택 시 전체선택/해제
procedure setGrdviAllChecked(vt: TVirtualTable; xchk: TcxCheckBox; fieldNm: string = 'useYn');
var
  rowNo: Integer;
begin
  if vt.RecordCount = 0 then Exit;

  vt.DisableControls;
  rowNo := vt.RecNo;

  if xchk.Checked then // 전체선택
  begin
    vt.First;
    while not vt.Eof do
    begin
      vt.Edit;
      vt.FieldByName(fieldNm).ReadOnly := False;
      vt.FieldByName(fieldNm).Value := 1;
      vt.Next;
    end;
  end
  else  // 전체해제
  begin
    vt.First;
    while not vt.Eof do
    begin
      vt.Edit;
      vt.FieldByName(fieldNm).ReadOnly := False;
      vt.FieldByName(fieldNm).Value := 0;
      vt.Next;
    end;
  end;

  vt.RecNo := rowNo;
  vt.EnableControls;
end;

// 체크리스트박스 전체 선택, 해제
procedure setCklAll(cklNm:TWinControl);
var i, chkCnt: Integer;
begin
  chkCnt := 0;
  if (cklNm is TCheckListBox) then
  begin
    with TCheckListBox(cklNm) do
    begin
      if ItemIndex = 0 then
      begin
        if Checked[0] = True then // 전체선택
        begin
          for i := 1 to Items.Count - 1 do
          begin
            Checked[i] := True;
          end;
        end
        else if Checked[0] = False then // 전체해제
        begin
          for i := 1 to Items.Count - 1 do
          begin
            Checked[i] := False;
          end;
        end;
      end
      else
      begin
        Checked[0] := False;
      end;

      for i := 0 to Items.Count - 1 do
      begin
        if Checked[i] then chkCnt := chkCnt + 1;
      end;
      if chkCnt = Items.Count - 1 then
        Checked[0] := True;
    end;
  end

  else if (cklNm is TcxCheckListBox) then
  begin
    with TcxCheckListBox(cklNm) do
    begin
      if ItemIndex = 0 then
      begin
        if Items[0].State = cbsChecked then // 전체선택
        begin
          for i := 1 to Items.Count - 1 do
          begin
            Items[i].State := cbsChecked;
          end;
        end
        else if Items[0].State = cbsUnchecked then // 전체해제
        begin
          for i := 1 to Items.Count - 1 do
          begin
            Items[i].State := cbsUnchecked;
          end;
        end;
      end
      else
      begin
        Items[0].State := cbsUnchecked;
      end;

      for i := 0 to Items.Count - 1 do
      begin
        if Items[i].State = cbsChecked then chkCnt := chkCnt + 1;
      end;
      if chkCnt = Items.Count - 1 then
        Items[0].State := cbsChecked;
    end;
  end
end;

// 체크리스트박스 초기화
// checkedYn : True - 전체선택, False - 전체해제
procedure setCklInit(cklNm:TWinControl; checkedYn: Boolean = False);
var
  i: Integer;
begin
  if (cklNm is TCheckListBox) then
  begin
    with TCheckListBox(cklNm) do
    begin
      for i := 0 to Items.Count - 1 do
      begin
        Checked[i] := checkedYn;
      end;
      ClearSelection;
    end;
  end

  else if (cklNm is TcxCheckListBox) then
  begin
    with TcxCheckListBox(cklNm) do
    begin
      for i := 0 to Items.Count - 1 do
      begin
        Items[i].Checked := checkedYn;
      end;
    end;
  end
end;

// 체크리스트박스 checked count
function getCklChkCnt(cklNm:TWinControl): Integer;
var
  chkCnt, i: Integer;
begin
  chkCnt := 0;
  if (cklNm is TCheckListBox) then
  begin
    for i := 0 to TCheckListBox(cklNm).Items.Count - 1 do
    begin
      if TCheckListBox(cklNm).Checked[i] then chkCnt := chkCnt + 1;
    end;
  end

  else if (cklNm is TcxCheckListBox) then
  begin
    for i := 0 to TcxCheckListBox(cklNm).Items.Count - 1 do
    begin
      if TcxCheckListBox(cklNm).Items[i].Checked then chkCnt := chkCnt + 1;
    end;
  end;

  Result := chkCnt;
end;

// 체크리스트박스 index 0를 제외한 checked count
function getNCklChkCnt(cklNm:TCheckListBox): Integer;
var
  chkCnt, i: Integer;
begin
  chkCnt := 0;
  for i := 1 to cklNm.Items.Count - 1 do
  begin
    if cklNm.Checked[i] then chkCnt := chkCnt + 1;
  end;
  Result := chkCnt;
end;

// 체크콤보박스 checked count
function getCkbChkCnt(ckbNm: TcxCheckComboBox): Integer;
var
  chkCnt, i: Integer;
begin
  chkCnt := 0;
  for i := 0 to ckbNm.Properties.Items.Count - 1 do
  begin
    if ckbNm.GetItemState(i) = cbsChecked then chkCnt := chkCnt + 1;
  end;
  Result := chkCnt;
end;

// 체크리스트박스 체크 선택 코드를 콤마(,)로 구분한 문자열(IN 조건) 리턴
// 1:코드
// 2:코드값
// 3:사업장일 경우 [법인코드-사업장코드] 이므로 한번 더 처리한다.
// 4:법인리스트 REGEXP 조건 - 다중선택 사업장 체크리스트박스 [법인코드-사업장코드]에서 법인코드만..
function getCklCondStr(cklNm:TWinControl; ab:Integer = 1): String;
var
  i: Integer;
  cond: String;
begin
  cond := '';

  if (cklNm is TCheckListBox) then
  begin

    with TCheckListBox(cklNm) do
    begin

      for i := 0 to Items.Count - 1 do
      begin
        if ((Pos('선택', Items[i]) > 0) or (Items[i] = '전체')) and (i = 0) then
          Continue;

        if Checked[i] then
        begin
          if (ab = 1) then
          begin
            if cond = '' then
              cond := '"' + subStr(Items[i], 1) + '"'
            else
              cond :=  cond + ',"' + subStr(Items[i], 1) + '"'; // 중복선택 dbsdlf11
          end
          else if (ab = 2) then
          begin
            if cond = '' then
              cond := subStr(Items[i], 2)
            else
              cond :=  cond + ', ' + subStr(Items[i], 2);
          end
          else if (ab = 3) then
          begin
            if cond = '' then
              cond := '"' + subStr(subStr(Items[i], 1), 2, '-') + '"'
            else
              cond := cond + ',"' + subStr(subStr(Items[i], 1), 2, '-') + '"';
          end
          else if (ab = 4) then
          begin
            if cond = '' then
              cond := subStr(subStr(Items[i], 1), 1, '-')
            else
              cond := cond + '|' + subStr(subStr(Items[i], 1), 1, '-');
          end;
        end;

      end;
    end;
  end

  else
  if (cklNm is TcxCheckListBox) then
  begin
    with TcxCheckListBox(cklNm) do
    begin
      for i := 0 to Items.Count - 1 do
      begin
        if ((Pos('선택', Items[i].Text) > 0) or (Items[i].Text = '전체')) and (i = 0) then
          Continue;

        if Items[i].State = cbsChecked then
        begin
          if (ab = 1) then
          begin
            if cond = '' then
              cond := '"' + subStr(Items[i].Text, 1) + '"'
            else
              cond :=  cond + ',"' + subStr(Items[i].Text, 1) + '"';
          end
          else if (ab = 2) then
          begin
            if cond = '' then
              cond := subStr(Items[i].Text, 2)
            else
              cond :=  cond + ', ' + subStr(Items[i].Text, 2);
          end
          else if (ab = 3) then
          begin
            if cond = '' then
              cond := '"' + subStr(subStr(Items[i].Text, 1), 2, '-') + '"'
            else
              cond := cond + ',"' + subStr(subStr(Items[i].Text, 1), 2, '-') + '"';
          end
          else if (ab = 4) then
          begin
            if cond = '' then
              cond := subStr(subStr(Items[i].Text, 1), 1, '-')
            else
              cond := cond + '|' + subStr(subStr(Items[i].Text, 1), 1, '-');
          end;
        end;
      end;
    end;
  end;

  Result := cond;
end;

function getCkbCondStr(ckbNm: TcxCheckComboBox; ab: Integer = 1): string;
var
  i: Integer;
  cond: String;
begin
  cond := '';

  with ckbNm do
  begin
    for i := 0 to Properties.Items.Count - 1 do
    begin
      if GetItemState(i) = cbsChecked then
      begin
        if (ab = 1) then
        begin
          if cond = '' then
            cond := '"' + Properties.Items[i].ShortDescription + '"'
          else
            cond :=  cond + ',"' + Properties.Items[i].ShortDescription + '"';
        end
        else if (ab = 2) then
        begin
          if cond = '' then
            cond := Properties.Items[i].Description
          else
            cond :=  cond + ', ' + Properties.Items[i].Description;
        end;
      end;
    end;
  end;
  Result := cond;
end;

// ERP단체코드와 HR법인코드 매칭
{
  oCode     : ERP단체코드 또는 HR법인코드
  oCodeAb   : 구분 : [ERP] ERP단체코드, [HR] HR법인코드
  return    : 매칭코드
}
function getMatchOCode(oCode, oCodeAb:String): String;
var
  ashSql: String;
begin
  if oCodeAb = 'ERP' then
  begin
    ashSql := 'SELECT hr_o_code AS oCode FROM hr_company WHERE erp_o_code = "' + oCode + '" AND hr_o_use_yn = "Y"';
  end
  else if oCodeAb = 'HR' then
  begin
    ashSql := 'SELECT erp_o_code AS oCode FROM hr_company WHERE hr_o_code = "' + oCode + '" AND hr_o_use_yn = "Y"';
  end;

  AshSQL := MySQL_Assign(Form1.db_coophr, Form1.qrysql, AshSQL, Form1.vtTemp);
  try
    StrToInt(AshSQL);
  except
    if mpst_code = '0579033000' then
    begin
      ShowMessage(ashSql);
    end;
  end;

  if Form1.vtTemp.FieldByName('oCode').AsString <> '' then
    Result := Form1.vtTemp.FieldByName('oCode').AsString
  else
  begin
    //ShowMessage(MSG_ERR_MATCH_OCODE);
    Exit;
  end;
end;

// 그룹박스 내의 콤포넌트 초기화
procedure initGroupBoxControl(grp: TWinControl);
var
  i: Integer;
begin
  for i := 0 to grp.ControlCount - 1 do
  begin
    if grp.Controls[i].ClassType = TEdit then
      TEdit(grp.Controls[i]).Text := ''
    else
    if grp.Controls[i].ClassType = TcxCurrencyEdit then
      TcxCurrencyEdit(grp.Controls[i]).Value := 0
    else
    if grp.Controls[i].ClassType = TCheckBox then
      TCheckBox(grp.Controls[i]).Checked := False
    else
    if grp.Controls[i].ClassType = TComboBox then
      TComboBox(grp.Controls[i]).ItemIndex := 0
    else
    if grp.Controls[i].ClassType = TcxCheckListBox then
      TcxCheckListBox(grp.Controls[i]).Clear;
  end;
end;

// 그룹박스 내 콤포넌트 활성화 설정
{ grp      : TGroupBox명
  bool     : true - 활성화, false - 비활성화
}
procedure enabledGroupBoxControl(grp: TGroupBox; bool: Boolean = True);
var
  i: Integer;
begin
  for i := 0 to grp.ControlCount - 1 do
  begin
    grp.Controls[i].Enabled := bool;
  end;
end;

// 사용자 프로그램의 단체, 프로그램 등록, 수정, 인쇄 권한 조회
procedure inquirySustaff();
var
  ashSQL, ashStr: String;
  i: Integer;
begin
  if mpst_code = '0579033000' then
  begin
    ashSQL := 'SELECT "O" hr_obp_ab, hr_o_code hr_obp_code, "Y" hr_insert, "Y" hr_edit, "Y" hr_print, "B" hr_salary_ab'
            + ' FROM hr_company WHERE hr_o_use_yn = "Y"';
  end
  else
  begin
    ashSQL := 'SELECT hr_obp_ab, hr_obp_code, hr_insert, hr_edit, hr_print, hr_salary_ab '
            + 'FROM hr_sustaff_log '
            + 'WHERE hr_pro_name = "' + ExtractFileName(Application.ExeName) + '" '
            + 'AND hr_m_code = "' + mpst_code + '" '
            + 'AND p_ab = "A"'; // A 사용
  end;

  ashStr := MySQL_Assign(Form1.db_coophr, Form1.qrysql, ashSQL, Form1.vtSuStaff);
  try
    StrToInt(ashStr);
  except
    if mpst_code = '0579033000' then
    begin
      ShowMessage(ashStr);
    end;
  end;

  // 권한있는 법인의 소속 사업장 조회
  if mpst_code = '0579033000' then
  begin
    ashSQL := 'SELECT hr_o_code, hr_b_code FROM hr_branch WHERE hr_b_use_yn = "Y"';
  end
  else
  begin
    ashSQL := 'SELECT hr_o_code, hr_b_code '
            + 'FROM hr_branch '
            + 'WHERE hr_o_code IN (SELECT hr_obp_code '
                                + 'FROM hr_sustaff_log '
                                + 'WHERE hr_m_code = "' + mpst_code + '" '
                                + 'AND hr_pro_name = "' + ExtractFileName(Application.ExeName) + '" '
                                + 'AND hr_obp_ab = "O" '
                                + 'AND p_ab = "A")';
  end;

  ashStr := MySQL_Assign(Form1.db_coophr, Form1.qrysql, ashSQL, Form1.vtTemp);
  try
    StrToInt(ashStr);
  except
    if mpst_code = '0579033000' then
    begin
      ShowMessage(ashStr);
    end;
  end;

  // 권한 virtual table에 법인 소속 사업장 append
  if Form1.vtTemp.RecordCount > 0 then
  begin
    Form1.vtSuStaff.Edit;
    for i := 0 to Form1.vtSuStaff.FieldCount - 1 do
    begin
      Form1.vtSuStaff.Fields[i].ReadOnly := False;
    end;

    Form1.vtTemp.First;
    while not Form1.vtTemp.Eof do
    begin
      if Form1.vtSuStaff.Locate('hr_obp_ab;hr_obp_code', VarArrayOf(['O', Form1.vtTemp.FieldByName('hr_o_code').AsString]), []) then
      begin
        Form1.vtSuStaff.AppendRecord(['B', Form1.vtTemp.FieldByName('hr_b_code').AsString,
            Form1.vtSuStaff.FieldByName('hr_insert').AsString, Form1.vtSuStaff.FieldByName('hr_edit').AsString,
            Form1.vtSuStaff.FieldByName('hr_print').AsString, Form1.vtSuStaff.FieldByName('hr_salary_ab').AsString]);
      end;
      Form1.vtTemp.Next;
    end;
  end;
end;

// 사용자 프로그램의 법인별 사업장별 부서별 등록, 수정, 출력 권한
// obpAb: 'O'-법인, 'B'-사업장, 'P'-부서, 'A'-하나 이상의 법인 권한 있으면 권한부여
// 2014.03.12 법인별 급여정보허용여부 권한 추가 hr_salary_ab(A:확인불가 B:허용)
procedure setGroupRightYn(obpAb: String = ''; obpCode: String = '');
begin
  insertYn := 'N'; editYn := 'N'; printYn := 'N'; salaryAb := 'A';

  // 단체전체권한 - hr_obp_ab:A 또는 hr_obp_code:9999
  // 법인별 사업장별 부서별 권한 세분화가 필요없는 프로그램 또는 수퍼단체권한 사용자
  {if Form1.vtSuStaff.FieldByName('hr_obp_ab').AsString = 'A' then
  //if Form1.vtSuStaff.FieldByName('hr_obp_code').AsString = '9999' then
  begin
    insertYn := Form1.vtSuStaff.FieldByName('hr_insert').AsString;
    editYn   := Form1.vtSuStaff.FieldByName('hr_edit').AsString;
    printYn  := Form1.vtSuStaff.FieldByName('hr_print').AsString;
  end
  }
  if obpAb = 'A' then
  begin
    if Form1.vtSuStaff.Locate('hr_insert', 'Y', []) then insertYn := 'Y' else insertYn := 'N';
    if Form1.vtSuStaff.Locate('hr_edit', 'Y', []) then editYn := 'Y' else editYn := 'N';
    if Form1.vtSuStaff.Locate('hr_print', 'Y', []) then printYn := 'Y' else printYn  := 'N';
    if Form1.vtSuStaff.Locate('hr_salary_ab', 'B', []) then salaryAb := 'B' else salaryAb  := 'A';
  end
  else
  begin
    if obpAb = '' then // FormCreate 시 (법인, 사업장, 부서 미선택)
    begin
      if Form1.vtSuStaff.Locate('hr_insert', 'N', []) then insertYn := 'N' else insertYn := 'Y';
      if Form1.vtSuStaff.Locate('hr_edit', 'N', []) then editYn := 'N' else editYn := 'Y';
      if Form1.vtSuStaff.Locate('hr_print', 'N', []) then printYn := 'N' else printYn  := 'Y';
      if Form1.vtSuStaff.Locate('hr_salary_ab', 'A', []) then salaryAb := 'A' else salaryAb  := 'B';
    end

    // 법인, 사업장, 부서 컴포넌트 초기화 시
    else if (obpAb <> '') and (obpCode = '') then
    begin
      if Form1.vtSuStaff.Locate('hr_obp_ab;hr_insert', VarArrayOf([obpAb, 'N']), []) then insertYn := 'N' else insertYn := 'Y';
      if Form1.vtSuStaff.Locate('hr_obp_ab;hr_edit', VarArrayOf([obpAb, 'N']), []) then editYn := 'N' else editYn := 'Y';
      if Form1.vtSuStaff.Locate('hr_obp_ab;hr_print', VarArrayOf([obpAb, 'N']), []) then printYn := 'N' else printYn  := 'Y';
      if Form1.vtSuStaff.Locate('hr_obp_ab;hr_salary_ab', VarArrayOf([obpAb, 'A']), []) then salaryAb := 'A' else salaryAb := 'B';
    end

    // 법인, 사업장, 부서 선택 시
    else
    begin
      if Form1.vtSuStaff.Locate('hr_obp_ab;hr_obp_code', VarArrayOf([obpAb, obpCode]), []) then
      begin
        insertYn := Form1.vtSuStaff.FieldByName('hr_insert').AsString;
        editYn   := Form1.vtSuStaff.FieldByName('hr_edit').AsString;
        printYn  := Form1.vtSuStaff.FieldByName('hr_print').AsString;
        salaryAb := Form1.vtSuStaff.FieldByName('hr_salary_ab').AsString;
      end;
    end;
  end;

  //Form1.Memo3.Lines.Add('setGroupRightYn> '+insertYn+' '+salaryAb);
end;

// 급여정보허용 권한에 따른 Display Format 리턴
function getSalaryFormat(salaryAb: String):String;
begin
  if salaryAb = 'A' then // 급여정보 확인불가
    Result := '*******'
  else if salaryAb = 'B' then // 허용
    Result := '#,##0'; // ',0.;-,0.';
end;

// 사용자권한 [법인/부서] 조회
{ vtSustaff : vtCompany, vtPost
  obpAb     : 법인, 사업장, 부서코드 구분(O:법인, B:사업장, P:부서)
  mpstCode  : 사용자사원번호
  return    : 권한있는 법인(또는 부서)코드를 콤마(,)로 구분한 문자열  예) 코드1, 코드2, 코드3
}
function getStrObpCode(obpAb: String):String;
var
  obpCode, strSustaff: String;
begin
  // 사용자 [법인/부서] 권한 조회
  {AshSQL := 'SELECT hr_obp_code '
          + 'FROM hr_sustaff_log '
          + 'WHERE hr_m_code = "' + mpst_code + '" '
          + 'AND hr_pro_name = "' + ExtractFileName(Application.ExeName) + '" '
          + 'AND hr_obp_ab = "' + obpAb + '" '
          + 'AND p_ab = "A"';

  AshSQL := MySQL_Assign(Form1.db_coophr, dsNm, AshSQL, vtSustaff);

  try
    StrToInt(AshSQL);
  except
    if mpst_code = '0579033000' then
    begin
      ShowMessage(AshSQL);
    end;
  end;
  }

  strSustaff := '';

  Form1.vtSuStaff.First;

  while not Form1.vtSuStaff.Eof do
  begin
    obpCode := '';
    if Form1.vtSuStaff.FieldByName('hr_obp_ab').AsString = obpAb then
      obpCode := Form1.vtSuStaff.FieldByName('hr_obp_code').AsString;

    if isEmpty(obpCode) then
    begin
      if strSustaff = '' then obpCode := '"' + obpCode + '"'
      else obpCode :=  ',"' + obpCode + '"';

      strSustaff := strSustaff + obpCode;
    end;
    Form1.vtSuStaff.Next;
  end;

  if strSustaff = '' then
    Result := '""'
  else
    Result := strSustaff;
end;

// 해당부서의 권한 유무 확인
function getStaffYn(vt: TVirtualTable; ab: String; code: String):String;
var
  staffYn: String; // 권한유무
begin
  staffYn := 'N';

  // 권한 확인
  vt.First;
  while not vt.Eof do
  begin
    if (vt.FieldByName(ab).AsString = code) then staffYn := 'Y';
    vt.Next;
  end;
  Result := staffYn;
end;

// 부서 조회 - 부서 테이블 4차서버 연결로 전체부서 조회 추가
procedure selectPost(db: TZConnection; vtPost: TVirtualTable);
var
  AshSQL: String;
begin
  AshSQL := 'SELECT post_code, post_name FROM admin_post';

  AshSQL := MySQL_Assign(db, Form1.qrysql, AshSQL, vtPost);
  try
    StrToInt(AshSQL);
  except
    if mpst_code = '0579033000' then
    begin
      ShowMessage(AshSQL);
    end;
  end;
end;

// 공통코드를 콤보박스에 세팅
{ dsNm      : TZQuery명
  vtTemp    : TVirtualTable명
  codeId    : 공통코드ID
  cbFirTxt  : 콤보박스 index 0의 text (A:전체, S:선택하세요, N:없음)
  cbNm      : 콤보박스명, 체크리스트박스명
  ab        : 콤보박스 Item 보여주기 방식 (A: 코드+네임(value), C: 코드, N: 네임)
}
procedure setCbCommCode(dsNm: TZQuery; vtTemp: TVirtualTable; codeId, cbFirTxt: String; cbNm: TWinControl; ab: String = 'A'); overload;
var
  AshSQL, str: String;
begin
  AshSQL  := 'SELECT hr_code_value, hr_code_value_name '
            + 'FROM hr_common_code_value '
            + 'WHERE hr_code_id = "' + codeId
            + '" AND hr_use_yn <> "N" '
            + 'ORDER BY hr_sort_seq ASC, hr_code_value ASC';

  AshSQL := MySQL_Assign(Form1.db_coophr, dsNm, AshSQL, vtTemp);

  try
    StrToInt(AshSQL);
  except
    if (mpst_code = '0579033000') or (mpst_code = '2018010038') then
    begin
      ShowMessage(AshSQL);
    end;
  end;

  if (cbNm is TComboBox) then
  begin
    with TComboBox(cbNm)do
    begin
      Clear;
      if cbFirTxt = 'A' then
        Items.Add('전체')
      else if cbFirTxt = 'S' then
      begin
        Items.Add('선택하세요');
      end;

      vtTemp.First;
      while not vtTemp.Eof do
      begin
        if ab = 'A' then
        begin
          str := vtTemp.Fields[0].AsString + ' ' + vtTemp.Fields[1].AsString;
        end
        else if ab = 'C' then
        begin
          str := vtTemp.Fields[0].AsString;
        end
        else if ab = 'N' then
        begin
          str :=  vtTemp.Fields[1].AsString;
        end;

        Items.Add(str);
        str := '';
        vtTemp.Next;
      end;

      ItemIndex := 0;
    end;
  end

  else if (cbNm is TCheckListBox) then
  begin
    with TCheckListBox(cbNm) do
    begin
      Clear;
      if cbFirTxt = 'A' then Items.Add('전체');

      vtTemp.First;
      while not vtTemp.Eof do
      begin
        str := vtTemp.Fields[0].AsString + ' ' + vtTemp.Fields[1].AsString;
        Items.Add(str);
        str := '';
        vtTemp.Next;
      end;

      ItemIndex := 0;
    end;
  end

  else if (cbNm is TcxCheckListBox) then
  begin
    with TcxCheckListBox(cbNm) do
    begin
      Clear;
      if cbFirTxt = 'A' then AddItem('전체');

      vtTemp.First;
      while not vtTemp.Eof do
      begin
        str := vtTemp.Fields[0].AsString + ' ' + vtTemp.Fields[1].AsString;
        AddItem(str);
        str := '';
        vtTemp.Next;
      end;

      ItemIndex := 0;
    end;
  end

  else if (cbNm is TcxComboBox) then
  begin
    with TcxComboBox(cbNm)do
    begin
      Clear;
      if cbFirTxt = 'A' then Properties.Items.Add('전체')
      else if cbFirTxt = 'S' then Properties.Items.Add('선택하세요');

      vtTemp.First;
      while not vtTemp.Eof do
      begin
        str := vtTemp.Fields[0].AsString + ' ' + vtTemp.Fields[1].AsString;
        Properties.Items.Add(str);
        str := '';
        vtTemp.Next;
      end;

      ItemIndex := 0;
    end;
  end
end;

{procedure setCbCommCode(dsNm: TZQuery; vtTemp: TVirtualTable; codeId, cbFirTxt: String; cbNm: TcxComboBox); overload;
var
  ashSQL, str: String;
begin
  cbNm.Clear;

  if cbFirTxt = 'A' then cbNm.Properties.Items.Add('전체')
  else if cbFirTxt = 'S' then cbNm.Properties.Items.Add('선택하세요');

  ashSQL  := 'SELECT hr_code_value, hr_code_value_name '
          + 'FROM hr_common_code_value '
          + 'WHERE hr_code_id = "' + codeId
          + '" AND hr_use_yn <> "N" '
          + 'ORDER BY hr_sort_seq ASC, hr_code_value ASC';

  ashSQL := MySQL_Assign(Form1.db_coophr, dsNm, AshSQL, vtTemp);

  try
    StrToInt(ashSQL);
  except
    if mpst_code = '0579033000' then
    begin
      ShowMessage(AshSQL);
    end;
  end;

  vtTemp.First;
  while not vtTemp.Eof do
  begin
    str := vtTemp.Fields[0].AsString + ' ' + vtTemp.Fields[1].AsString;
    cbNm.Properties.Items.Add(str);
    str := '';
    vtTemp.Next;
  end;

  cbNm.ItemIndex := 0;
end;

procedure setCbCommCode(dsNm: TZQuery; vtTemp: TVirtualTable; codeId, cbFirTxt: String; cbNm: TCheckListBox); overload;
var
  AshSQL, str: String;
begin
  cbNm.Clear;

  if cbFirTxt = 'A' then cbNm.Items.Add('전체')
  else if cbFirTxt = 'S' then cbNm.Items.Add('선택하세요');

  AshSQL := 'SELECT hr_code_value, hr_code_value_name'
          + ' FROM hr_common_code_value'
          + ' WHERE hr_code_id = "' + codeId + '"'
          + ' AND hr_use_yn <> "N"'
          + ' ORDER BY hr_sort_seq ASC';

  AshSQL := MySQL_Assign(Form1.db_coophr, dsNm, AshSQL, vtTemp);

  try
    StrToInt(AshSQL);
  except
    if mpst_code = '0579033000' then
    begin
      ShowMessage(AshSQL);
    end;
  end;

  vtTemp.First;
  while not vtTemp.Eof do
  begin
    str := vtTemp.Fields[0].AsString + ' ' + vtTemp.Fields[1].AsString;
    cbNm.Items.Add(str);
    str := '';
    vtTemp.Next;
  end;

  cbNm.ItemIndex := 0;
end;
}

procedure setCxCbCommCode(vt: TVirtualTable; codeId, cbFirTxt: String; cxGridCol: TcxCustomGridTableItem);
var
  AshSQL, str: String;
begin
  with TcxComboBoxProperties(cxGridCol.Properties) do
  begin
    Items.Clear;

    if cbFirTxt = 'A' then Items.Add('전체')
    else if cbFirTxt = 'S' then Items.Add('선택하세요');

    AshSQL := 'SELECT hr_code_value, hr_code_value_name'
            + ' FROM hr_common_code_value'
            + ' WHERE hr_code_id = "' + codeId + '"'
            + ' AND hr_use_yn <> "N"'
            + ' ORDER BY hr_sort_seq ASC';

    AshSQL := MySQL_Assign(Form1.db_coophr, Form1.qrysql, AshSQL, vt);

    try
      StrToInt(AshSQL);
    except
      if mpst_code = '0579033000' then
      begin
        ShowMessage(AshSQL);
      end;
    end;

    vt.First;
    while not vt.Eof do
    begin
      str := vt.Fields[0].AsString + ' ' + vt.Fields[1].AsString;
      Items.Add(str);
      str := '';
      vt.Next;
    end;
  end;
end;

// 공통코드 콤보박스에서 선택한 콤보text에서 코드값만 가져오기
function getCommCodeVal(cb: TWinControl): String;
begin
  if (cb is TComboBox) then
  begin
    with TComboBox(cb)do
    begin
      if ((Pos('선택', Items[0]) > 0) or (Items[0] = '전체')) and (ItemIndex = 0) then
      begin
        result := '';
      end
      else
      begin
        result := subStr(Text, 1, ' ');
      end;
    end;
  end

  else if (cb is TcxComboBox) then
  begin
    with TcxComboBox(cb)do
    begin
      if ((Pos('선택', Properties.Items[0]) > 0) or (Properties.Items[0] = '전체')) and (ItemIndex = 0) then
      begin
          result := '';
      end
      else
      begin
          result := subStr(Text, 1, ' ');
      end;
    end;
  end

  else if (cb is TCheckListBox) then
  begin
    with TCheckListBox(cb)do
    begin
      if ((Pos('선택', Items[0]) > 0) or (Items[0] = '전체')) and (ItemIndex = 0) then
      begin
          result := '';
      end
      else
      begin
          result := subStr(Items.Strings[ItemIndex], 1, ' ');
      end;
    end;
  end

  else if (cb is TcxCheckListBox) then
  begin
    with TcxCheckListBox(cb)do
    begin
      if ((Pos('선택', Items[0].Text) > 0) or (Items[0].Text = '전체')) and (ItemIndex = 0) then
      begin
          result := '';
      end
      else
      begin
          result := subStr(Items[ItemIndex].Text, 1, ' ');
      end;
    end;
  end;
  {
  else if (cb is TcxLookupComboBox) then
  begin
    with TcxLookupComboBox(cb)do
    begin
      if ((Pos('선택', Properties.Items[0]) > 0) or (Properties.Items[0] = '전체')) and (ItemIndex = 0) then
      begin
          result := '';
      end
      else
      begin
          result := subStr(Properties.Items[ItemIndex], 1, ' ');
      end;
    end;
  end;
  }
end;

function getCodeValNm(ckl: TCheckListBox): String;
begin
  if ((Pos('선택', ckl.Items[0]) > 0) or (ckl.Items[0] = '전체')) and (ckl.ItemIndex = 0) then
  begin
      result := '';
  end
  else
  begin
      result := subStr(ckl.Items.Strings[ckl.ItemIndex], 2, ' ');
  end;
end;

// 공통코드 콤보박스에서 value 매칭 code 가져오기
function getMatchValueCode(value: String; cbNm: TComboBox):String;
var
  i: Integer;
  code: String;
begin
  code := '';
  if ((Pos('선택', cbNm.Items[0]) > 0) or (cbNm.Items[0] = '전체')) and (cbNm.ItemIndex = 0) then
  begin
      code := '';
  end
  else
  begin
    for i := 1 to cbNm.Items.Count - 1 do
    begin
      if subStr(cbNm.Items.Strings[i], 2, ' ') = value then
      begin
        code := subStr(cbNm.Items.Strings[i], 1, ' ');
        Break;
      end;
    end;
  end;
  Result := code;
end;

// 공통코드 콤보박스에서 code 매칭 index 가져오기
function getMatchCodeIdx(code: String; cbNm: TComboBox):Integer; overload;
var
  i, idx: Integer;
begin
  idx := 0;
  for i := 0 to cbNm.Items.Count - 1 do
  begin
    if subStr(cbNm.Items.Strings[i], 1, ' ') = code then
    begin
      idx := cbNm.Items.IndexOf(cbNm.Items.Strings[i]);
      Break;
    end;
  end;
  Result := idx;
end;
{
// 공통코드 콤보박스에서 code 매칭 index 가져오기
function getMatchCodeIdx(code: String; cbNm: TcxLookupComboBox):Integer; overload;
var
  i, idx: Integer;
begin
  idx := 0;
  for i := 0 to cbNm.editvalue.Count - 1 do
  begin
    if subStr(cbNm.editvalue.Strings[i], 1, ' ') = code then
    begin
      idx := cbNm.editvalue.IndexOf(cbNm.editvalue.Strings[i]);
      Break;
    end;
  end;
  Result := idx;
end;
}
function getMatchCodeIdx(code: String; cbNm: TcxComboBox):Integer; overload;
var
  i, idx: Integer;
begin
  idx := 0;
  for i := 0 to cbNm.Properties.Items.Count - 1 do
  begin
    if subStr(cbNm.Properties.Items.Strings[i], 1, ' ') = code then
    begin
      idx := cbNm.Properties.Items.IndexOf(cbNm.Properties.Items.Strings[i]);
      Break;
    end;
  end;
  Result := idx;
end;

{function getMatchCodeIdx(code: String; cbNm: TwDataCombo):Integer; overload;
var
  i, idx: Integer;
begin
  idx := 0;
  cbNm.ListSource.DataSet.First;
  while not cbNm.ListSource.DataSet.Eof do
  begin
    if cbNm.ListSource.DataSet.FieldByName('g_code').AsString = code then
    begin
      idx := cbNm.ListSource.DataSet.RecNo;
      Break;
    end;
    cbNm.ListSource.DataSet.Next;
  end;
  Result := idx;
end;
}
function getMatchCodeIdx(code: String; ckl: TCheckListBox):Integer; overload;
var
  i, idx: Integer;
begin
  idx := 0;
  for i := 0 to ckl.Items.Count - 1 do
  begin
    if subStr(ckl.Items.Strings[i], 1, ' ') = code then
    begin
      idx := ckl.Items.IndexOf(ckl.Items.Strings[i]);
      Break;
    end;
  end;
  Result := idx;
end;

function getMatchCodeIdx(code: String; ckl: TcxCheckListBox):Integer; overload;
var
  i, idx: Integer;
begin
  idx := 0;
  for i := 0 to ckl.Items.Count - 1 do
  begin
    if splitCd(ckl.Items[i].Text, 1) = code then
    begin
      idx := i;
      Break;
    end;
  end;
  Result := idx;
end;

// 콤보박스에서 code 매칭 value 가져오기
function getMatchCodeVal(code: String; cbNm: TComboBox):String;
var
  i: Integer;
  val: String;
begin
  val := '';
  for i := 0 to cbNm.Items.Count - 1 do
  begin
    if (splitCd(cbNm.Items.Strings[i], 1) = Trim(code)) then
    begin
      val := splitCd(cbNm.Items.Strings[i], 2);
      Break;
    end;
  end;
  Result := val;
end;

// 공통코드 콤보박스에서 value 매칭 index 가져오기
function getMatchValueIdx(val: String; cbNm: TComboBox):Integer;
var
  i, idx: Integer;
begin
  idx := 0;
  for i := 0 to cbNm.Items.Count - 1 do
  begin
    if splitCd(cbNm.Items.Strings[i], 2, ' ') = val then
    begin
      idx := cbNm.Items.IndexOf(cbNm.Items.Strings[i]);
    end;
  end;
  Result := idx;
end;

// true, false -> Y, N으로 치환
function getYn(bool: Boolean): String; overload;
begin
  if bool = true then
    result := 'Y'
  else //if bool = false then
    result := 'N';
end;

// 1, 0 -> Y, N으로 치환
function getYn(str: string): String; overload;
begin
  if str = '1' then
    result := 'Y'
  else
    result := 'N';
end;

// true, false -> 0, 1 로 치환
function get01(bool: Boolean): String; overload;
begin
  if bool = True then
    result := '1'
  else //if bool = false then
    result := '0';
end;

function get01(str: string): String; overload;
begin
  if str = 'Y' then
    result := '1'
  else //if str = 'N' then
    result := '0';
end;

function get1(str: string): String;
begin
  if str = 'Y' then
    result := '1'
  else
    result := '';
end;

function getH1(str: string): String;
begin
  if str = '여' then
    result := '1'
  else
    result := '';
end;

function getH12(str: string): String;
begin
  if (str = '여') or (str = 'Y') then
    result := '1'
  else
    result := '2';
end;


// Y, N -> true, false 로 치환
function getBool(yn: String): Boolean;
begin
  if (yn = 'Y') or (yn = '1') then
    result := True
  else
    result := False;
end;

// 삭제확인창 메세지
function confirmDelMsg(msg: String = ''): Integer;
begin
  if msg = '' then
    msg := '삭제 후에는 복원할 수 없습니다.' + #13#10 + '삭제하시려면 저장(F4)버튼을 눌러주세요';
  result := MessageBox(0, PChar(msg), '삭제확인', MB_OKCANCEL);
end;

// 날짜 초기화 : 1900-01-01
function initDt: TDate;
begin
  result := StrToDate('1900/01/01');
end;

// 날짜 초기화2 : 1899-12-31
// 값이 바뀌지 않는 초기값
function initDt2: TDate;
begin
  result := StrToDate('1899/12/31');
end;

// dateTimePicker 데이터 null일 때 date 지우기
procedure setDt(dt: TDateTimePicker; strDate: String);
begin
  if strDate = '' then
    dt.Format := ' '
  else
    dt.Date := StrToDate(strDate);
end;

// 날짜 문자열 dateTime 타입으로 변환
function convtDateType(strDate: String): TDate;
var
  y, m, d: String;
begin
  strDate := StringReplace(strDate, '-', '',[rfReplaceAll, rfIgnoreCase]);
  strDate := StringReplace(strDate, '/', '',[rfReplaceAll, rfIgnoreCase]);

  if Length(strDate) = 8 then
  begin
    y := Copy(strDate, 1, 4);
    m := Copy(strDate, 5, 2);
    d := Copy(strDate, 7, 2);

    Result := StrToDate(y + FormatSettings.DateSeparator + m + FormatSettings.DateSeparator + d);
  end
  else
    Result := StrToDate('1900/01/01');
end;

// 입력날짜 유효성 체크
// validDate
function isDate(str: String; msgYn: Boolean = False): Boolean;
var
  strDate: String;
  y, m, d: Integer;
begin
  strDate := StringReplace(str, '-', '',[rfReplaceAll, rfIgnoreCase]);
  strDate := StringReplace(str, '/', '',[rfReplaceAll, rfIgnoreCase]);

  if Length(strDate) = 8 then
  begin
    y := StrToInt(Copy(strDate, 1, 4));
    m := StrToInt(Copy(strDate, 5, 2));
    d := StrToInt(Copy(strDate, 7, 2));

    // 윤년 확인
    if (y mod 4 = 0) and (y mod 100 > 0) or (y mod 400 = 0) then
      days[1] := 29;

    if (m > 0) and (m < 13) and (d > 0) and (d <= days[m - 1]) then
        Result := true
    else
    begin
      if msgYn then ShowMessage(MSG_ERR_VAL_DATE1);
      Result := false;
    end;
  end
  else
  begin
    if msgYn then ShowMessage(MSG_ERR_VAL_DATE1);
    Result := false;
  end;
end;
// validDateTime

// From~To 기간 체크
function validPeriod(fromDt, toDt: TDateTime): Boolean; overload;
begin
  if CompareDateTime(fromDt, toDt) = 1 then // A=B(0), A>B(1), A<B(-1)
  begin
    ShowMessage(MSG_ERR_VAL_DATE2); // 입력기간의 시작일자가 종료일자보다 큽니다.'; -> 날짜유효성확인
    Result := False;
  end
  else
    Result := True;
end;

// 입력날짜 From~To 기간 체크
function validPeriod(fromDt, toDt: TDateTimePicker): Boolean; overload;
begin
  if (CompareDate(fromDt.Date, toDt.Date) = 1) then // A=B(0), A>B(1), A<B(-1)
  begin
    ShowMessage(MSG_ERR_VAL_DATE2);
    fromDt.SetFocus;
    Result := False;
  end
  else
    Result := True;
end;

// 전화번호 유효성 확인
{ telNo : 하이픈(-) 포함한 전화번호 }
function chkTelNo(telNo: String): Boolean;
var
  delimiter, localNo, middleNo, lastNo: string;
  i, cnt: Integer;
begin
  Result := True;
  delimiter := '-';

  // 하이픈(-) 개수 2 확인
  i := 1; cnt := 0;
  while i <= Length(telNo) do
  begin
    if Copy(telNo,i,1) = delimiter then
      inc(cnt);
    inc(i);
  end;
  if cnt <> 2 then Result := False;

  // 하이픈을 제외하고 숫자만 입력 확인
  // 070 지역번호  TryStrToInt 함수에서 False 반환한다. 왜???
  //if not TryStrToInt(StringReplace(telNo, '-', '', [rfReplaceAll]), val) then Result := False;

  localNo   := subStr(telNo, 1, delimiter);
  middleNo  := subStr(telNo, 2, delimiter);
  lastNo    := subStr(telNo, 3, delimiter);

  // 지역번호 첫자리 0 확인
  if Copy(telNo, 1, 1) <> '0' then Result := False;
  // 지역번호 길이확인
  if not Length(localNo) in [2,3] then Result := False;
  // 중간자리번호 길이확인
  if not Length(middleNo) in [3,4] then Result := False;
  // 끝자리번호 길이확인
  if Length(lastNo) <> 4 then Result := False;
end;

// 주민번호로 생년월일 구하기
function getBirthdayByIdNo(id: String): TDate;
var
  y, m, d, k: Integer;
begin
  if (Length(id) < 7) then Exit;

  k := StrToInt(Copy(id, 7, 1));
  y := 1900;

  if (k = 1) or (k = 2) or (k = 5) or (k = 6) then
    y := StrToInt('19' + Copy(id, 1, 2))
  else if (k = 3) or (k = 4) or (k = 7) or (k = 8) then
    y := StrToInt('20' + Copy(id, 1, 2));

  m := StrToInt(Copy(id, 3, 2));
  d := StrToInt(Copy(id, 5, 2));

  result := EncodeDate(y, m, d);
end;

// 화면모드별 조건 컴포넌트 속성 변경
procedure setCondEnable(const obj: TComponent; mode: Integer; e: Integer);
begin
  if mode = 0 then mode := 1
  else if mode = 2 then mode := 0;

  setObjEnable(obj, mode, e);
end;

// 화면모드별 입력 컴포넌트 속성 변경
{ obj : 컴포넌트명
  mode: 화면모드(0:보기, 1:등록, 2: 수정, 3:삭제)
  e   : 필수값여부(0:비필수, 1:필수, 2:비활성(수정모드에서))
}
procedure setObjEnable(const obj: TComponent; mode: Integer; e: Integer = 0);
var
  esseColr, nesseColr, inactColr: TColor;
  i: Integer;
begin
  esseColr  := $00D2FEFF; // 필수
  nesseColr := $00FFFFFF; // 비필수
  inactColr := $00FCFCFC; // 비활성 $00EEEEEE
  case mode of
    0, 3: // 보기, 삭제
    begin
      if (obj is TEdit) or (obj is TMaskEdit) or (obj is TcxCurrencyEdit) then
      begin
        TEdit(obj).Enabled  := false;
        TEdit(obj).Color    := inactColr ;
      end

      else if (obj is TComboBox) or (obj is TCheckListBox) or (obj is TcxComboBox) or (obj is TcxCheckListBox) then
      begin
        TComboBox(obj).Enabled := false;
        TComboBox(obj).Color   := inactColr;
      end

      else if (obj is TCheckBox) or (obj is TRadioButton) or (obj is TButton) or (obj is TSpeedButton) or (obj is TcxRadioGroup) then
      begin
        TWinControl(obj).Enabled := false;
      end

      else if obj is TDateTimePicker then
      begin
        TDateTimePicker(obj).Enabled := false;
        TDateTimePicker(obj).Color   := inactColr;
      end

      else if obj is TDBGrid then
      begin
        TDBGrid(obj).Enabled := false;
        TDBGrid(obj).Color   := inactColr;
      end

      else if obj is TMemo then
      begin
        TMemo(obj).ReadOnly := True;
        TMemo(obj).Color    := inactColr;
      end

      else if obj is TcxLookupComboBox then
      begin
        TcxLookupComboBox(obj).Enabled := False;
        TcxLookupComboBox(obj).Style.Color := inactColr;
      end

      else if obj is TcxControl then
      begin
        TcxControl(obj).Enabled := false;
      end

      else if obj is TGroupBox then
      begin
        for i := 0 to TGroupBox(obj).ControlCount - 1 do
        begin
          TGroupBox(obj).Controls[i].Enabled := False;
        end;
      end;
    end;

    1: // 등록
    begin
      if (obj is TEdit) or (obj is TMaskEdit) or (obj is TcxCurrencyEdit) then
      begin
        TEdit(obj).Enabled := true;

        if e = 0 then
          TEdit(obj).Color := nesseColr
        else
          TEdit(obj).Color := esseColr;
      end

      else if (obj is TComboBox) or (obj is TCheckListBox) or (obj is TcxComboBox) or (obj is TcxCheckListBox) then
      begin
        TComboBox(obj).Enabled := true;

        if e = 0 then
          TComboBox(obj).Color := nesseColr
        else
          TComboBox(obj).Color := esseColr;
      end

      else if obj is TCheckBox then
      begin
        TCheckBox(obj).Enabled := true;
        //TCheckBox(obj).Checked := false;
      end

      else if (obj is TRadioButton) or (obj is TButton) or (obj is TSpeedButton) or (obj is TcxRadioGroup) then
      begin
        TWinControl(obj).Enabled := true;
      end

      else if obj is TDateTimePicker then
      begin
        TDateTimePicker(obj).Enabled := true;
        if e = 0 then
          TDateTimePicker(obj).Color := nesseColr
        else
          TDateTimePicker(obj).Color := esseColr;
      end

      else if obj is TMemo then
      begin
        TMemo(obj).ReadOnly := False;
        if e = 0 then
          TMemo(obj).Color := nesseColr
        else
          TMemo(obj).Color := esseColr;
      end

      else if obj is TDBGrid then
      begin
        TDBGrid(obj).Enabled := true;
        TDBGrid(obj).Color := nesseColr;
      end

      else if obj is TcxLookupComboBox then
      begin
        TcxLookupComboBox(obj).Enabled := True;
        if e = 0 then
          TcxLookupComboBox(obj).Style.Color := nesseColr
        else
          TcxLookupComboBox(obj).Style.Color := esseColr;
      end

      else if obj is TcxControl then
      begin
        TcxControl(obj).Enabled := True;
      end

      else if obj is TGroupBox then
      begin
        for i := 0 to TGroupBox(obj).ControlCount - 1 do
        begin
          TGroupBox(obj).Controls[i].Enabled := True;
        end;
      end;
    end;

    2: // 수정
    begin
      if (obj is TEdit) or (obj is TMaskEdit) or (obj is TcxCurrencyEdit) then
      begin
        if e = 0 then
        begin
          TEdit(obj).Enabled  := true;
          TEdit(obj).Color    := nesseColr;
        end
        else if e = 1 then
        begin
          TEdit(obj).Enabled  := true;
          TEdit(obj).Color    := esseColr;
        end
        else if e = 2 then
        begin
          TEdit(obj).Enabled  := false;
          TEdit(obj).Color    := inactColr;
        end;
      end

      else if (obj is TComboBox) or (obj is TCheckListBox) or (obj is TcxComboBox) or (obj is TcxCheckListBox) then
      begin
        if e = 0 then
        begin
          TComboBox(obj).Enabled  := true;
          TComboBox(obj).Color    := nesseColr;
        end
        else if e = 1 then
        begin
          TComboBox(obj).Enabled  := true;
          TComboBox(obj).Color    := esseColr;
        end
        else if e = 2 then
        begin
          TComboBox(obj).Enabled  := false;
          TComboBox(obj).Color    := inactColr;
        end;
      end

      else if (obj is TCheckBox) or (obj is TRadioButton) or (obj is TButton) or (obj is TSpeedButton) or (obj is TcxRadioGroup) then
      begin
        TWinControl(obj).Enabled := true;
        if e in [0,1] then
        begin
          TWinControl(obj).Enabled := true;
        end
        else if e = 2 then
        begin
          TWinControl(obj).Enabled := False;
        end;
      end

      else if obj is TDateTimePicker then
      begin
        if e = 0 then
        begin
          TDateTimePicker(obj).Enabled  := true;
          TDateTimePicker(obj).Color    := nesseColr;
        end
        else if e = 1 then
        begin
          TDateTimePicker(obj).Enabled  := true;
          TDateTimePicker(obj).Color    := esseColr;
        end
        else if e = 2 then
        begin
          TDateTimePicker(obj).Enabled  := false;
          TDateTimePicker(obj).Color    := inactColr;
        end;
      end

      else if obj is TMemo then
      begin
        TMemo(obj).ReadOnly := False;
        if e = 0 then
          TMemo(obj).Color := nesseColr
        else
          TMemo(obj).Color := esseColr;
      end

      else if obj is TDBGrid then
      begin
        TDBGrid(obj).Enabled := True;
      end

      else if obj is TcxLookupComboBox then
      begin
        if e = 0 then
        begin
          TcxLookupComboBox(obj).Enabled := True;
          TcxLookupComboBox(obj).Style.Color := nesseColr;
        end
        else if e = 1 then
        begin
          TcxLookupComboBox(obj).Enabled := True;
          TcxLookupComboBox(obj).Style.Color := esseColr;
        end
        else if e = 2 then
        begin
          TcxLookupComboBox(obj).Enabled := False;
          TcxLookupComboBox(obj).Style.Color := inactColr;
        end;
      end

      else if obj is TcxControl then
      begin
        if e in [0,1] then
        begin
          TcxControl(obj).Enabled  := True;
        end
        //else if e = 1 then
        //begin
        //  TcxControl(obj).Enabled  := True;
        //end
        else if e = 2 then
        begin
          TcxControl(obj).Enabled  := False;
        end;
      end

      else if obj is TGroupBox then
      begin
        for i := 0 to TGroupBox(obj).ControlCount - 1 do
        begin
          TGroupBox(obj).Controls[i].Enabled := True;
        end;
      end
    end;
  end;
end;

// 소득세 공제가족수 조회
function getDeductFamilyCnt(mCode: string): Integer;
var
  ashSQL: string;
begin
  // 가족공제 확인(본인 + 배우자 + 세법상 부양가족)
  ashSql := 'SELECT IFNULL(SUM(IF(hr_family_relation_ab = "06", 2, 1)), 0) + 1 cnt FROM hr_family'
          + ' WHERE hr_m_code = "' + mCode + '"'
          + ' AND hr_use_yn = "Y"'
          + ' AND hr_support_yn = "Y"'          // 부양의무
          + ' AND ((hr_living_yn = "Y") OR (hr_family_relation_ab IN ("03","04")))' // 동거유무 - 부(03)모(04)의 경우 동거유무
          + ' AND (SUBSTRING(hr_birthday, 1, 4) < (DATE_FORMAT(DATE_ADD(NOW(), INTERVAL -60 YEAR), "%Y"))'  // 나이 만 60세이상
          + ' OR SUBSTRING(hr_birthday, 1, 4) > (DATE_FORMAT(DATE_ADD(NOW(), INTERVAL -22 YEAR), "%Y"))'    // 나이 만 20세이하
          + ' OR hr_difficulty_yn = "Y"'         // 장애유무
          + ' OR hr_family_relation_ab = "05")'  // 배우자공제 '
          + ' AND hr_birthday > "1900-01-01"';
  //Form1.Memo1.Lines.Add('#가족공제 확인'+#13+ashSQL);
  ashSQL := MySQL_Assign(Form1.db_coophr, Form1.qrySql, ashSQL, Form1.vtTemp);
  try
    StrToInt(ashSQL);
  except
    if mpst_code = '0579033000' then
    begin
      ShowMessage(AshSQL);
    end;
  end;
  Result := Form1.vtTemp.FieldByName('cnt').AsInteger; // 공제가족수
end;

// 간이세액표 조회
{
  mCode     : 사원번호
  familyCnt : 공제가족수
  salAmt    : 월급여금액(비과세소득 제외)
  salYm     : 귀속연월 char(6) yyyymm

  return    : Result[0] 간이세액표에 의한 소득세
              Result[1] 급여하한금액(이상)
              Result[2] 급여상한급액(미만)
              Result[3] 맞춤형원정징수비율에 의한 소득세
}
function getSimpleTaxTable(mCode: string; familyCnt: Integer; salAmt: Double; salYm: string): TArray<Double>;
var
  ashSQL: string;
  stdAmt1, stdAmt2, stdAmt3, excessAmt, incomeTaxAmt: Double;
begin
  // 소득세
  // ① 천만원의 해당 세액(간이세액표)
  // ② 10,000천원 초과 14,000천원 이하 : ① + 천만원 초과 금액 * 98% * 35%
  // ③ 14,000천원 초과 : ② + 14,000천원 초과 금액 * 98% * 38%
  //                      ① + 1,372,000 + 14,000천원 초과 금액 * 98% * 38%
  // 2017-02월시행 개정으로 추가
  // ③ 14,000천원 초과 45,000천원 이하 : ① + 1,372,000 + 14,000천원 초과 금액 * 98% * 38%
  // ④ 45,000천원 초과 : ① + 12,916,400 + 45,000천원 초과 금액 * 98% * 40%
  stdAmt1 := 10000000; stdAmt2 := 14000000; stdAmt3 := 45000000;
  excessAmt := 0; incomeTaxAmt := 0;

  if (salAmt > stdAmt3) then // 45,000천원 초과
  begin
    excessAmt := (salAmt - stdAmt3) * 0.98 * 0.4;
    salAmt := stdAmt3;
  end;

  if (salAmt > stdAmt2) then // 14,000천원 초과
  begin
    excessAmt := excessAmt + (salAmt - stdAmt2) * 0.98 * 0.38;
    salAmt := stdAmt2;
  end;

  if (salAmt > stdAmt1) then // 10,000천원 초과
  begin
    excessAmt := excessAmt + (salAmt - stdAmt1) * 0.98 * 0.35;
    salAmt := stdAmt1;
  end;

  ashSQL := 'SELECT TRUNCATE(hr_g' + IntToStr(familyCnt) + '_amt, 0) hr_g_amt' // 공제가족수, 원단위 절사
          + ', hr_min_amt, hr_max_amt'
          + ' FROM hr_simple_tax_table '
          + ' WHERE hr_min_amt <= "' + FloatToStr(salAmt / 1000) + '"' // 간이세액표 - 천원단위
          + ' AND hr_max_amt >= "' + FloatToStr(salAmt / 1000) + '"'
          + ' AND hr_apply_ym <= "' + salYm + '"'
          + ' ORDER BY hr_yyyy DESC LIMIT 1';
  //Form1.Memo1.Lines.Add('#간이세액표 조회'+#13+ashSQL);
  ashSQL := MySQL_Assign(Form1.db_coophr, Form1.qrySql, ashSQL, Form1.vtTemp);
  try
    StrToInt(ashSQL);
  except
    if mpst_code = '0579033000' then
    begin
      ShowMessage(AshSQL);
    end;
  end;

  incomeTaxAmt := Form1.vtTemp.FieldByName('hr_g_amt').AsFloat + excessAmt;
  incomeTaxAmt := Trunc(incomeTaxAmt/10)*10; // 원단위절사

  SetLength(result, 4);
  Result[0] := incomeTaxAmt; // 간이세액표에 의한 소득세
  Result[1] := Form1.vtTemp.FieldByName('hr_min_amt').AsFloat; // 급여하한금액(이상)
  Result[2] := Form1.vtTemp.FieldByName('hr_max_amt').AsFloat; // 급여상한급액(미만)

  // 근로자별 맞춤형원천징수비율 조회
  ashSQL := 'SELECT hr_withhold_rate'
          + ' FROM hr_m_incometax_rate'
          + ' WHERE hr_m_code = "' + mCode + '"'
          + ' AND hr_yyyymm <= "' + salYm + '"' // 귀속연월
          + ' ORDER BY hr_yyyymm DESC, hr_sn DESC LIMIT 1';
  //Form1.Memo1.Lines.Add('#근로자별 맞춤형원천징수비율 조회'+#13+ashSQL);
  ashSQL := MySQL_Assign(Form1.db_coophr, Form1.qrySql, ashSQL, Form1.vtTemp);
  try
    StrToInt(ashSQL);
  except
    if mpst_code = '0579033000' then
    begin
      ShowMessage(AshSQL);
    end;
  end;

  if Form1.vtTemp.RecordCount > 0 then
    Result[3] := Trunc(incomeTaxAmt * Form1.vtTemp.FieldByName('hr_withhold_rate').AsFloat/10)*10 // 맞춤형원정징수비율에 의한 소득세
  else
    Result[3] := incomeTaxAmt;
end;

// 건강보험요율 조회
{
  yyyymm  : 귀속연월

  return  : Result[0] 근로자부담 건강보험요율
            Result[1] 노인장기요양보험요율
            Result[2] 장기요양보험 경감율
            Result[3] 보수월액 하한선
            Result[4] 보수월액 상한선
}
function getNhisRate(yyyymm: string): TArray<Double>;
var
  ashSQL, yyyy, mm: string;
begin
  yyyy := Copy(yyyymm,1,4);
  mm   := Copy(yyyymm,5,2);
  ashSql := 'SELECT hr_labor_in_rate, hr_recup_rate,  hr_reduction_rate, hr_base_min_amt, hr_base_max_amt'
          + ' FROM hr_nhis_rate'
          + ' WHERE hr_nhis_yyyy = "' + yyyy + '" AND hr_mm_from <= ' + mm + ' AND hr_mm_to >= ' + mm
          + ' ORDER BY hr_nhis_yyyy DESC, hr_mm_from DESC LIMIT 1';

  //Form1.Memo1.Lines.Add('#건강보험요율 조회' + #13#10 + ashSql);
  ashSQL := MySQL_Assign(Form1.db_coophr, Form1.qrySql, ashSQL, Form1.vtTemp);
  try
    StrToInt(ashSQL);
  except
    if mpst_code = '0579033000' then
    begin
      ShowMessage(AshSQL);
    end;
  end;

  SetLength(result, 5);
  Result[0] := Form1.vtTemp.FieldByName('hr_labor_in_rate').AsFloat;
  Result[1] := Form1.vtTemp.FieldByName('hr_recup_rate').AsFloat;
  Result[2] := Form1.vtTemp.FieldByName('hr_reduction_rate').AsFloat;
  Result[3] := Form1.vtTemp.FieldByName('hr_base_min_amt').AsFloat;
  Result[4] := Form1.vtTemp.FieldByName('hr_base_max_amt').AsFloat;
end;

// 건강보험료 계산
{
  mCode  : 사원번호
  oCode  : 법인코드
  yyyymm : 책정연월
  monthlyWageAmt : 보수월액, 0 이면 근로자의 보수월액 조회

  return  : Result[0] 건강보험료 가입자부담분
            Result[1] 장기요양보험료 가입자부담분
}
function getNhisAmt(mCode, oCode, yyyymm: String; monthlyWageAmt: Double = 0): TArray<Double>;
var
  ashSQL, reductAb: string;
  // 보수월액, 근로자부담 건강보험요율, 노인장기요양보험요율, 장기요양보험 경감율, 보수월액하한선, 보수월액상한선
  standardAmt, nhisLaborInRate, recupRate, reductionRate, minAmt, maxAmt, nhisAmt, nhisRecupAmt: Double;
  ashArr: TArray<Double>;
begin
  SetLength(ashArr, 5);
  ashArr := getNhisRate(yyyymm); // 건강보험요율 조회
  nhisLaborInRate := ashArr[0];
  recupRate       := ashArr[1];
  reductionRate   := ashArr[2];
  minAmt          := ashArr[3];
  maxAmt          := ashArr[4];

  if monthlyWageAmt = 0 then
  begin
    // 보수월액, 장기요양경감대상여부 조회
    ashSQL := 'SELECT hr_standard_amt, hr_reduction_ab, hr_nhis_excl_yn'
            + ' FROM hr_personal_gongje_info'
            + ' WHERE hr_m_code = "' + mCode + '"'
            + ' AND hr_o_code = "'   + oCode + '"'
            + ' AND hr_div_ab = "2"'  // 구분자 - 2 건강보험
            + ' AND hr_yyyymm <= "'  + yyyymm + '-01"' // 국민연금, 건강보험은 책정연월만, 일자는 무조건 1일로 입력
            + ' AND hr_use_yn = "Y"'
            + ' ORDER BY hr_yyyymm DESC LIMIT 1';

    Form1.Memo1.Lines.Add('#건강보험 보수월액 조회' + #13#10 + ashSql);
    ashSQL := MySQL_Assign(Form1.db_coophr, Form1.qrySql, ashSQL, Form1.vtTemp);
    try
      StrToInt(ashSQL);
    except
      if mpst_code = '0579033000' then
      begin
        ShowMessage(AshSQL);
      end;
    end;

    standardAmt := StrToFloat(Return_Decode_Money(mCode, Form1.vtTemp.FieldByName('hr_standard_amt').AsString));
    reductAb := Form1.vtTemp.FieldByName('hr_reduction_ab').AsString; // 장기요양보험경감코드 - 1 경감제외, 2 경감대상, 3 적용제외
  end
  else
  begin
    standardAmt := monthlyWageAmt;
    reductAb := '1';
  end;

  // 델파이 실수연산 오류
  // 604가 나올 값이 603 이 나오는 현상..
  // 실수타입의 저장형태와 연산과정에서 2진수로 처리된 것이 십진수로 변환되면서 일어나는 문제
  // 실수연산의 문제점으로 인해 Trunc(604) 가 603으로 나와버리는 현상이 일어나는 경우가 있다.
  // 이것을 방지하기 위해 일반적으로 권장되는 방법은 계산결과값에 영향을 미치지 못하면서,
  // 실수연산에서 일어날 수 있는 오차를 줄이기 위한 범위 내의 허용가능수치를 더해주는 방법이다. (+0.0000001)
  if (standardAmt < (minAmt * 10000)) then  // 단위 : 만원
  begin
    nhisAmt := Trunc(minAmt * nhisLaborInRate * 10 + 0.0000001)*10; // 10원미만 단수 버림
  end
  else if (standardAmt > (maxAmt * 10000)) then
  begin
    nhisAmt := Trunc(maxAmt * nhisLaborInRate * 10 + 0.0000001)*10;
  end
  else
  begin
    nhisAmt := Trunc(standardAmt * nhisLaborInRate / 1000 + 0.0000001)*10;
  end;

  nhisRecupAmt := Trunc(nhisAmt * recupRate / 1000 + 0.0000001)*10; // 경감제외

  if reductAb = '2' then // 장기요양보험경감대상
  begin
    nhisRecupAmt := Trunc(nhisRecupAmt * (1 - reductionRate/100) /10)*10;
  end;

  Form1.Memo1.Lines.Add('standardAmt::'+FloatToStr(standardAmt)+' nhisAmt:::'+FloatToStr(nhisAmt)+' nhisRecupAmt:::'+FloatToStr(nhisRecupAmt));

  SetLength(result, 2);
  Result[0] := nhisAmt;
  Result[1] := nhisRecupAmt;
end;

// 세액 산출근거 조회
{
  ab  : 구분자
        1 퇴직소득근속연수공제,
        2 퇴직소득환산급여공제,
        3 소득세기본세율,
        4 퇴직소득산출세액특례,
        5 근로소득공제
        6 근로소득세액공제

  ash : 구분자에 따라
        1 근속연수,
        2 환산급여금액,
        3 과세표준금액,
        4 종전규정 산출세액 비율(%),
        5 근로소득 총급여액

  dt : 회계연도 or 적용일자(19000101)

  return  : Result[0] 하한선
            Result[1] 상한선
            Result[2] 기준값 - 구분자에 따라 1 공제금액, 2 공제율, 3 세율, 4 퇴직연도, 5 공제율
            Result[3] 최대치
}
function getTaxBase(ab: string; ash: Double; dt: string = ''): TArray<Double>;
var
  ashSQL, subSQL: string;
begin
  if ab = '4' then // 퇴직소득산출세액특례
  begin
    subSQL := ' AND hr_standard_value = "' + FloatToStr(ash) + '"'; // 퇴직연도
  end
  else
  begin
    subSQL := ' AND hr_over < ' + FloatToStr(ash);
  end;

  if (Length(dt) = 4) then // 회계연도
    dt := dt + '0101';

  if (Length(dt) = 8) then
    subSQL := subSQL + ' AND hr_fiscal <= "' + dt + '"';

  ashSQL := 'SELECT hr_over, hr_less, hr_standard_value, hr_max_value'
          + ' FROM hr_retirement_tax_base'
          + ' WHERE hr_ab = "' + ab + '"'
          + subSQL
          + ' AND hr_use_yn = "Y"'
          + ' ORDER BY hr_fiscal DESC, hr_over DESC LIMIT 1';

  Form1.Memo1.Lines.Add(ashSql);
  ashSQL := MySQL_Assign(Form1.db_coophr, Form1.qrySql, ashSQL, Form1.vtTemp);
  try
    StrToInt(ashSQL);
  except
    if mpst_code = '0579033000' then
    begin
      ShowMessage(AshSQL);
    end;
  end;

  SetLength(result, 4);
  Result[0] := Form1.vtTemp.FieldByName('hr_over').AsFloat;
  Result[1] := Form1.vtTemp.FieldByName('hr_less').AsFloat;
  Result[2] := Form1.vtTemp.FieldByName('hr_standard_value').AsFloat;
  Result[3] := Form1.vtTemp.FieldByName('hr_max_value').AsFloat;
end;

// 근로소득세액공제한도 조회
{
  totSalarAmt : 총급여액
  return      : 근로소득세액공제한도금액
}
function getEarnedIncomeDeductLimitAmt(totSalaryAmt: Double): Double;
var
  limitAmt, lessSalAmt, overSalAmt, deductAmt1, deductAmt2, deductAmt3: Double;
begin
  // 공제한도
  // 3300만원 이하                  - 74만원
  // 3300만원 초과 ~ 7000만원 이하  - MAX[(74만원 - (총급여액 - 3300만원) * 0.008), 66만원]
  // 7000만원 초과                  - MAX[(66만원 - (총급여액 - 7000만원) * 0.5), 50만원]
  lessSalAmt := 33000000;
  overSalAmt := 70000000;
  deductAmt1 := 740000;
  deductAmt2 := 660000;
  deductAmt3 := 500000;

  if totSalaryAmt > overSalAmt then
  begin
    limitAmt := deductAmt2 - (totSalaryAmt - overSalAmt) / 2;
    if limitAmt < deductAmt3 then limitAmt := deductAmt3;
  end;

  if (totSalaryAmt > lessSalAmt) and (totSalaryAmt <= overSalAmt) then
  begin
    limitAmt := deductAmt1 - (totSalaryAmt - lessSalAmt) * 0.008;
    if limitAmt < deductAmt2 then limitAmt := deductAmt2;
  end;

  if totSalaryAmt <= lessSalAmt then
  begin
    limitAmt := deductAmt1;
  end;

  Result := limitAmt;
end;

// 전자신고파일 생성 이력 저장
procedure insertEReportHistory(ereportAb, bCode, oCode, presentYm, strfileCont: string; memo: string = '');
var
  ashSQL, ashStr: string;
begin
  ashSql := 'SELECT (IFNULL(MAX(hr_sn),0)+1) AS hr_sn FROM hr_ereport_history'
         + ' WHERE hr_ereport_ab = "' + ereportAb + '"' // 전자파일종류
         + ' AND hr_b_code = "' + bCode + '"'
         + ' AND hr_pay_ym = "' + presentYm + '"'       // 제출연월
         + ' AND hr_o_code = "' + oCode + '"';

  Form1.Memo1.Lines.Add('#이력일련번호 조회 ▶' + #13#10 + ashSQL);
  ashStr := MySQL_Assign(Form1.db_coophr, Form1.qrysql, ashSQL, Form1.vtTemp);
  try
    StrToInt(ashStr);
  except
    ShowMessage('오류가 발생하였습니다.[' + ashStr + '](ERR:)');
    Exit;
  end;

  ashSQL := 'INSERT into hr_ereport_history (' +
         'hr_ereport_ab,' +
         'hr_b_code, ' +
         'hr_pay_ym, ' +
         //'hr_final_sn, ' +
         'hr_sn, ' +
         'hr_o_code, ' +
         //'hr_yyyymm,' +
         'hr_memo, ' +
         'hr_ereport_content, ' +
         'hr_program_build_day, ' +
         'mpst_code, ' +
         'p_day, ' +
         'chk_svr' +
         ') VALUES (' +
         '"' + ereportAb + '",' +
         '"' + bCode + '",' +
         '"' + presentYm + '",' +
         IntToStr(Form1.vtTemp.FieldByName('hr_sn').AsInteger) + ',' +
         '"' + oCode + '",' +
         '"' + memo + '",' +
         '"' + strfileCont + '",' +
         '"' + FormatDateTime('yyyy/mm/dd hh:nn:ss', FileDateToDateTime(FileAge(ExtractFileName(Application.ExeName)))) + '",' +
         '"' + mpst_code + '",' +
         'now(),' +
         '"' + IntToStr(svrconn) + '"' +
         ')';

  Form1.Memo1.Lines.Add('#이력저장 ▶'+#13#10+ashSQL);
  try
    ashReturnRow := StrToInt(MySQL_UpDel(Form1.db_coophr, Form1.qrysql, ashSQL));
  except
    on e: Exception do
    begin
      ShowMessage('저장 실패.[hr_ereport_history]' + #13#10 + e.Message);
      Exit;
    end;
  end;
end;

// 전산파일 레코드 자르기
procedure chkEFile(eAb, strfileCont: string);
var
  errList: TStringList;
  arrD: array of string;
  i, k, recSize, dataCnt: Integer;

begin
  if not isEmpty(strfileCont) then Exit;

  errList := TStringList.Create;
  errList.Clear;

  if eAb = 'C' then // 근로소득

  else if eAb = 'D' then // 의료비지급명세서
  begin
    recSize := 251; // 레코드길이
    dataCnt := 24;  // 레코드 항목 개수
  end;

  SetLength(arrD, dataCnt);
  System.FillChar(arrD, SizeOf(arrD), #0); // 초기화

  if Length(AnsiString(strfileCont)) <> recSize then
    errList.Add('레코드길이 오류['+ IntToStr(Length(AnsiString(strfileCont)))+ ' <> '+ IntToStr(recSize) +']');

  k := 1;

  if eAb = 'D' then
  begin
    for i := 0 to Length(arrD) - 1 do
    begin
      arrD[i] := Copy(strfileCont, k, arrM[i]);
      k := k + arrM[i];
      Form1.Memo1.Lines.Add(arrD[i]);
    end;
  end;

end;

end.
