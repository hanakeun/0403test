unit common_utils;

interface

uses
  SysUtils, Classes, Windows,
  DB, ZAbstractRODataset, ZAbstractDataset, ZDataset, ZConnection,
  Messages, Variants, Graphics, Controls, Forms, Dialogs, StdCtrls,
  VirtualTable, DateUtils, ComCtrls, CheckLst, cxCurrencyEdit, cxDBLookupComboBox, Winapi.Imm,
  Mask, DBGrids, Buttons;

// true, false -> Y, N으로 치환 (체크박스, 라디오버튼의 checked 변환 시 사용)
function getYn(bool: Boolean): String;
// Y, N -> true, false 로 치환
function getBool(yn: String): Boolean;

// 화면모드별 입력 컴포넌트 속성 변경
{ obj : 컴포넌트명
  mode: 화면모드(0:보기, 1:등록, 2: 수정, 3:삭제)
  e   : 필수값여부(0:비필수, 1:필수, 2:비활성)
}
procedure setObjEnable(const obj: TComponent; mode: Integer; e: Integer);

// 화면모드별 조건 컴포넌트 속성 변경
procedure setCondEnable(const obj: TComponent; mode: Integer; e: Integer);

// split - 문자열 구분자로 나눠서 원하는 위치(순서)의 문자 가져오기
{ Str       : 문자열
  Position  : 순서
  Delimiter : 구분자
}
function splitCd(str: String; const position: Integer; const delimiter: string = ' '): string;
function splitStr(str: String; const position: Integer; const delimiter: string = ' '): string;

// 콤보박스 검색
procedure findCb(cb: TComboBox; key: Word);

// 공통코드를 콤보박스, 체크리스트박스에 세팅
{ dsNm      : TZQuery명
  vtTemp    : TVirtualTable명
  codeId    : 공통코드ID
  cbFirTxt  : 콤보박스 index 0의 text (A:전체, S:선택하세요, N:없음)
  cbNm      : 콤보박스명, 체크리스트박스명
}
//procedure setCbCommCode(dsNm: TZQuery; vtTemp: TVirtualTable; codeId, cbFirTxt: String; cbNm: TComboBox); overload;
//procedure setCbCommCode(dsNm: TZQuery; vtTemp: TVirtualTable; codeId, cbFirTxt: String; cbNm: TCheckListBox); overload;

// 콤보박스, 체크리스트박스 설정
{ vt   : TZQuery명
  cbAb : 콤보박스 index 0의 text (A:전체, S:선택하세요, N:없음, C:코드만, M:코드명만)
  cbNm : 콤보박스
}
procedure setCb(vt: TVirtualTable; cbAb: String; cbNm: TWinControl);

// 체크리스트박스 전체 선택, 해제
procedure setCklAll(cklNm:TCheckListBox);

// 체크리스트박스 초기화
procedure setCklInit(cklNm:TCheckListBox);

// 체크리스트박스 checked count
function getCklChkCnt(cklNm:TCheckListBox): Integer;
function getNCklChkCnt(cklNm:TCheckListBox): Integer;

// 체크리스트박스 체크 선택 코드를 콤마(,)로 구분한 문자열(IN 조건)
// 1:코드, 2:코드값
function getCklCondStr(cklNm:TCheckListBox; ab:Integer = 1): String;

// 콤보박스에서 선택한 콤보text에서 코드값만 가져오기
function getCommCodeVal(cb: TComboBox): String; overload;
function getCommCodeVal(ckl: TCheckListBox): String; overload;

// 체크리스트박스에서 선택한 text에서 코드값명만 가져오기
function getCodeValNm(ckl: TCheckListBox): String;

// 콤보박스에서 value 매칭 code 가져오기
function getMatchValueCode(value: String; cbNm: TComboBox):String;

// 콤보박스에서 code 매칭 index 가져오기
function getMatchCodeIdx(code: String; cbNm: TComboBox):Integer; overload;
function getMatchCodeIdx(code: String; ckl: TCheckListBox):Integer; overload;

// 콤보박스에서 code 매칭 value 가져오기
function getMatchCodeVal(code: String; cbNm: TComboBox):String;

// 입력날짜 유효성 체크
function isDate(str: String): Boolean;

// 입력날짜 From~To 기간 체크
function validPeriod(fromDt, toDt: TDateTime): Boolean;

// 날짜 초기화 : 1900-01-01
function initDt(): TDate;

// 문자열 null 확인
function isEmpty(str: String): Boolean;

// 필수입력항목 확인
{ obj: 필수입력컴포넌트명
  lab: 필수입력항목 label
}
function chkExtVal(obj: TComponent; lab: String): Boolean;

// 사업자등록번호 유효성 확인
{ bizRegNo : 하이픈(-) 제외한 숫자 10자리 }
function chkBizRegNo(const bizRegNo: String): Boolean;

// 전화번호 유효성 확인
{ telNo : 하이픈(-) 포함한 전화번호 }
function chkTelNo(telNo: String): Boolean;

// 사용자의 권한있는 조직, 센터, 조합 조회
{ ab    : 구분 (O:조직, C:센터, J:조합)
  para1 : ab가 O, C 일 때는 사용자 조합원코드(m_code),  J일 때는    센터코드(c_code)
  para2 : ab가 O 일 때는    프로그램명                  C, J일 때는 조직코드(o_code)
}
procedure inquiryOrg(vt: TVirtualTable; ab, para1, para2: String);

// 개발자 테스트 컨트롤 보임
procedure showCtrl(ctrl: TControl);

implementation

uses Unit1, coop_sql_updel;

var
  days: array[0..11] of Integer = (31,28,31,30,31,30,31,31,30,31,30,31);

// 에러메세지
const
  MSG_ERR_CD1 = '선택 가능 항목이 없습니다.';                       // 공통코드 에러메세지1
  MSG_ERR_VAL1 = ' 항목은 필수값입니다.';                           // 유효성확인1
  MSG_ERR_VAL2 = ' 항목은 필수선택값입니다.';                       // 유효성확인2
  MSG_ERR_VAL_DATE1 = '일자 형식이 맞지않습니다.';                  // 날짜유효성확인1
  MSG_ERR_VAL_DATE2 = '입력기간의 시작일자가 종료일자보다 큽니다.'; // 날짜유효성확인2
  MSG_ERR_MATCH_OCODE = '해당 법인정보의 ERP단체코드를 확인하세요.';// 법인코드, ERP단체코드 매칭오류


// 개발자 테스트 컨트롤 보임
procedure showCtrl(ctrl: TControl); overload;
begin
   if (mpst_code = 'H13080585') or (mpst_code = 'H14103898') then // H13080585 - 정송
  begin
    if ctrl.Visible then
      ctrl.Visible := false
    else
      ctrl.Visible := True;
  end
  else
    ctrl.Visible := false;
end;

// true, false -> Y, N으로 치환
function getYn(bool: Boolean): String;
begin
  if bool = true then
    result := 'Y'
  else if bool = false then
    result := 'N';
end;

// Y, N -> true, false 로 치환
function getBool(yn: String): Boolean;
begin
  if yn = 'Y' then
    result := true
  else
    result := false;
end;

// splitCd - 코드 콤보박스 문자열 구분자로 나눠서 코드, 코드값 리턴
{ Str       : 문자열
  Position  : 1-코드, 2-코드값
  Delimiter : 구분자
}
function splitCd(str: String; const position: Integer; const delimiter: string = ' '): string;
var
  strLen, {zeichenIdx, subIdx,} komPos: integer;
begin
  Result := '';
  strLen := Length(Str);
  komPos := Pos(delimiter, str);

  if position = 1 then
    Result := Trim(Copy(str, 1, komPos))
  else if position = 2 then
    Result := Trim(Copy(str, komPos+1, strLen));
end;

// splitStr - 문자열 구분자로 나눠서 원하는 위치(순서)의 문자 리턴
{ Str       : 문자열
  Position  : 순서
  Delimiter : 구분자
}
function splitStr(str: String; const position: Integer; const delimiter: string = ' '): string;
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

// 콤보박스에서 선택한 콤보text에서 코드값만 가져오기
function getCommCodeVal(cb: TComboBox): String;
begin
  if ((cb.Items[0] = '선택하세요') or (cb.Items[0] = '전체')) and (cb.ItemIndex = 0) then
  begin
      result := '';
  end
  else
  begin
      result := splitCd(cb.Text, 1, ' ');
  end;
end;

function getCommCodeVal(ckl: TCheckListBox): String; overload;
begin
  if ((Pos('선택', ckl.Items[0]) > 0) or (ckl.Items[0] = '전체')) and (ckl.ItemIndex = 0) then
  begin
      result := '';
  end
  else
  begin
      result := splitCd(ckl.Items.Strings[ckl.ItemIndex], 1, ' ');
  end;
end;

function getCodeValNm(ckl: TCheckListBox): String;
begin
  if ((Pos('선택', ckl.Items[0]) > 0) or (ckl.Items[0] = '전체')) and (ckl.ItemIndex = 0) then
  begin
      result := '';
  end
  else
  begin
      result := splitCd(ckl.Items.Strings[ckl.ItemIndex], 2, ' ');
  end;
end;

// 콤보박스에서 value 매칭 code 가져오기
function getMatchValueCode(value: String; cbNm: TComboBox):String;
var
  i: Integer;
  code: String;
begin
  code := '';
  if ((cbNm.Items[0] = '선택하세요') or (cbNm.Items[0] = '전체')) and (cbNm.ItemIndex = 0) then
  begin
      code := '';
  end
  else
  begin
    for i := 1 to cbNm.Items.Count - 1 do
    begin
      if splitCd(cbNm.Items.Strings[i], 2, ' ') = value then
      begin
        code := splitCd(cbNm.Items.Strings[i], 1, ' ');
        Break;
      end;
    end;
  end;
  Result := code;
end;

// 콤보박스에서 code 매칭 index 가져오기
function getMatchCodeIdx(code: String; cbNm: TComboBox):Integer; overload;
var
  i, idx: Integer;
begin
  idx := 0;
  for i := 0 to cbNm.Items.Count - 1 do
  begin
    if splitCd(cbNm.Items.Strings[i], 1, ' ') = code then
    begin
      idx := cbNm.Items.IndexOf(cbNm.Items.Strings[i]);
      Break;
    end;
  end;
  Result := idx;
end;

function getMatchCodeIdx(code: String; ckl: TCheckListBox):Integer; overload;
var
  i, idx: Integer;
begin
  idx := 0;
  for i := 0 to ckl.Items.Count - 1 do
  begin
    if splitCd(ckl.Items.Strings[i], 1, ' ') = code then
    begin
      idx := ckl.Items.IndexOf(ckl.Items.Strings[i]);
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
    if (splitCd(cbNm.Items.Strings[i], 1, ' ') = code) then
    begin
      val := splitCd(cbNm.Items.Strings[i], 2, ' ');
      Break;
    end;
  end;
  Result := val;
end;

// 콤보박스에서 value 매칭 index 가져오기
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

// 체크리스트박스 전체 선택, 해제
procedure setCklAll(cklNm:TCheckListBox);
var i, chkCnt: Integer;
begin
  chkCnt := 0;

  if cklNm.ItemIndex = 0 then
  begin
    if cklNm.Checked[0] = True then // 전체선택
    begin
      for i := 1 to cklNm.Items.Count - 1 do
      begin

        cklNm.Checked[i] := True;
      end;
    end
    else if cklNm.Checked[0] = False then // 전체해제
    begin
      for i := 1 to cklNm.Items.Count - 1 do
      begin
        cklNm.Checked[i] := False;
      end;
    end;
  end
  else
  begin
    cklNm.Checked[0] := False;
  end;

  for i := 0 to cklNm.Items.Count - 1 do
  begin
    if cklNm.Checked[i] then chkCnt := chkCnt + 1;
  end;
  if chkCnt = cklNm.Items.Count - 1 then
    cklNm.Checked[0] := True;
end;

// 체크리스트박스 초기화
procedure setCklInit(cklNm:TCheckListBox);
var
  i: Integer;
begin
  for i := 0 to cklNm.Items.Count - 1 do
  begin
    cklNm.Checked[i] := False;
  end;
  cklNm.ClearSelection;
end;

// 체크리스트박스 checked count
function getCklChkCnt(cklNm:TCheckListBox): Integer;
var
  chkCnt, i: Integer;
begin
  chkCnt := 0;
  for i := 0 to cklNm.Items.Count - 1 do
  begin
    if cklNm.Checked[i] then chkCnt := chkCnt + 1;
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

// 체크리스트박스 체크 선택 코드를 콤마(,)로 구분한 문자열(IN 조건) 리턴
// 1:코드, 2:코드값, 3:사업장일 경우 [법인코드-사업장코드] 이므로 한번 더 처리한다.
// 4:법인리스트 REGEXP 조건 - 다중선택 사업장 체크리스트박스 [법인코드-사업장코드]에서 법인코드만..
function getCklCondStr(cklNm:TCheckListBox; ab:Integer = 1): String;
var
  i: Integer;
  cond: String;
begin
  cond := '';

  for i := 1 to cklNm.Items.Count - 1 do // index 0(전체선택) 제외
  begin
    if cklNm.Checked[i] then
    begin
      if (ab = 1) then
      begin
        if cond = '' then
          cond := '"' + splitCd(cklNm.Items[i], 1) + '"'
        else
          cond :=  cond + ',"' + splitCd(cklNm.Items[i], 1) + '"';
      end
      else if (ab = 2) then
      begin
        if cond = '' then
          cond := splitCd(cklNm.Items[i], 2)
        else
          cond :=  cond + ', ' + splitCd(cklNm.Items[i], 2);
      end
      else if (ab = 3) then
      begin
        if cond = '' then
          cond := '"' + splitCd(splitCd(cklNm.Items[i], 1), 2, '-') + '"'
        else
          cond := cond + ',"' + splitCd(splitCd(cklNm.Items[i], 1), 2, '-') + '"';
      end
      else if (ab = 4) then
      begin
        if cond = '' then
          cond := splitCd(splitCd(cklNm.Items[i], 1), 1, '-')
        else
          cond := cond + '|' + splitCd(splitCd(cklNm.Items[i], 1), 1, '-');
      end;
    end;
  end;
  Result := cond;
end;

// 입력날짜 유효성 체크
// validDate
function isDate(str: String): Boolean;
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
      ShowMessage('일자 형식이 맞지않습니다.');
      Result := false;
    end;
  end
  else
  begin
    ShowMessage('일자 형식이 맞지않습니다.');
    Result := false;
  end;
end;

// 입력날짜 From~To 기간 체크
function validPeriod(fromDt, toDt: TDateTime): Boolean;
begin
  if CompareDateTime(fromDt, toDt) = 1 then // A=B(0), A>B(1), A<B(-1)
  begin
    ShowMessage('입력기간의 시작일자가 종료일자보다 큽니다.');
    Result := False;
  end
  else
    Result := True;
end;

// 날짜 초기화 : 1900-01-01
function initDt: TDate;
begin
  result := StrToDate('1900/01/01');
end;

// 문자열 null 확인
function isEmpty(str: String): Boolean;
begin
  if (Trim(str) = '') or (Length(Trim(str)) = 0) then
    result := False
  else
    result := True;
end;

// 필수입력항목 확인
{ obj: 필수입력컴포넌트명
  lab: 필수입력항목 label
}
function chkExtVal(obj: TComponent; lab: String): Boolean;
// 에러메세지
const
  MSG_ERR_VAL1 = ' 항목은 필수값입니다.';     // 유효성확인1
  MSG_ERR_VAL2 = ' 항목은 필수선택값입니다.'; // 유효성확인2
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
  else if obj is TComboBox then
  begin
    if TComboBox(obj).ItemIndex = 0 then
    begin
      ShowMessage(lab + MSG_ERR_VAL2);
      TComboBox(obj).SetFocus;
      SendMessage(TComboBox(obj).Handle, CB_SHOWDROPDOWN, Integer(true), 0);
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
    if getNCklChkCnt(TCheckListBox(obj)) = 0 then
    begin
      ShowMessage(lab + MSG_ERR_VAL2);
      TEdit(obj).SetFocus;
      Result := False;
    end
    else Result := True;
  end
  else if obj is TcxLookupComboBox then
  begin
    if not isEmpty(Trim(TEdit(obj).Text)) then
    begin
      ShowMessage(lab + MSG_ERR_VAL2);
      TEdit(obj).SetFocus;
      SendMessage(TcxLookupComboBox(obj).Handle, CB_SHOWDROPDOWN, Integer(true), 0);
      Result := False;
    end
    else Result := True;
  end
  else Result := True;
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

// 전화번호 유효성 확인
{ telNo : 하이픈(-) 포함한 전화번호 }
function chkTelNo(telNo: String): Boolean;
var
  delimiter, localNo, middleNo, lastNo: string;
  i, val, cnt: Integer;
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
  if not TryStrToInt(StringReplace(telNo, '-', '', [rfReplaceAll]), val) then Result := False;

  localNo := splitStr(telNo, 1, delimiter);
  middleNo := splitStr(telNo, 2, delimiter);
  lastNo := splitStr(telNo, 3, delimiter);

  // 지역번호 첫자리 0 확인
  if Copy(telNo, 1, 1) <> '0' then Result := False;
  // 지역번호 길이확인
  if not Length(localNo) in [2,3] then Result := False;
  // 중간자리번호 길이확인
  if not Length(middleNo) in [3,4] then Result := False;
  // 끝자리번호 길이확인
  if Length(lastNo) <> 4 then Result := False;
end;

// 사용자의 권한있는 조직, 센터, 조합 조회
{ ab    : 구분 (O:조직, C:센터, J:조합)
  para1 : ab가 O, C 일 때는 사용자 조합원코드(m_code),  J일 때는    센터코드(c_code)
  para2 : ab가 O 일 때는    프로그램명                  C, J일 때는 조직코드(o_code)
}
procedure inquiryOrg(vt: TVirtualTable; ab, para1, para2: String);
var
  ashStr, ashSQL, branchAb: String;

begin
  if ab = 'O' then // 조직
  begin
    if (mpst_code = 'H13080585')or (mpst_code = 'H14103898') then // 정송테스트
    begin
      ashStr := '';
    end
    else
      ashStr := ' AND program_list LIKE "%' + para2 + '%"';

    ashSQL := 'SELECT o_code, o_name FROM org'
            + ' WHERE o_code IN (SELECT o_code FROM staff'
                                + ' WHERE m_code = "' + para1 + '"'
                                + ashStr
                                //+ ' AND o_code <> "0043"' // 2016-06-13 쿱생활건강 제외
                                + ' AND admin_ab = "A")'
            + ' AND p_ab = "A"';
    if(mpst_code = 'H14103898') then
    begin
      ashSQL := 'SELECT o_code, o_name FROM org'
            + ' WHERE o_code';
    end;
    if (mpst_code = 'H11040050') then // 김민경님
    begin
      ashSQL := 'SELECT o_code, o_name FROM org'
              + ' WHERE o_code IN (SELECT o_code FROM staff'
                                + ' WHERE 1=1'
                                + ashStr
                                + ' AND admin_ab = "A")'
            + ' AND p_ab = "A"'
            + ' GROUP BY o_code';
    end;
  end

  else if ab = 'C' then // 센터
  begin
    Form1.lblCenter.Caption := '센터';
    ashSQL := 'SELECT c_code'
            + ', (SELECT c_name FROM center WHERE c_code = staff_center.c_code) c_name '
            + ' FROM staff_center '
            + ' WHERE m_code = "' + para1 + '"'
            + ' AND o_code = "' + para2 + '"'
            + ' AND c_code NOT LIKE "%R"' // 반품센터 제외
            + ' AND p_ab = "A"';

    // 2016-06-22 [43A0 쿱생활건강센터_수도]만 조회
    if para2 = '0043' then
      ashSQL := ashSQL + ' AND c_code = "43A0"';

    if (mpst_code = 'H11040050') then // 김민경님
    begin
      ashSQL := 'SELECT c_code'
              + ', (SELECT c_name FROM center WHERE c_code = staff_center.c_code) c_name '
              + ' FROM staff_center '
              + ' WHERE o_code = "' + para2 + '"'
              + ' AND c_code NOT LIKE "%R"' // 반품센터 제외
              + ' AND p_ab = "A"'
              + ' GROUP BY c_code';
    end;
  end

  else if ab = 'B' then // 지점
  begin
    // 2016-12-12 지점 추가
    ashSQL := 'SELECT branch_ab FROM org WHERE o_code = "' + para2 + '"'; // branch_ab A:센터, B:지점
    ashStr := MySQL_Assign(Form1.db_coopbase, Form1.qrySQL, ashSQL, vt);
    try
      StrToInt(ashStr);
    except
      ShowMessage('오류가 발생하였습니다.[' + ashStr + '](ERR:단체조회)');
      Exit;
    end;

    branchAb := vt.FieldByName('branch_ab').AsString;
    if branchAb = 'A' then // 센터
    begin
      Form1.lblCenter.Caption := '센터';
      Form1.rgxCenterAb.ItemIndex := 0;

      ashSQL := 'SELECT c_code'
              + ', (SELECT c_name FROM center WHERE c_code = staff_center.c_code) c_name '
              + ' FROM staff_center '
              + ' WHERE m_code = "' + para1 + '"'
              + ' AND o_code = "' + para2 + '"'
              + ' AND c_code NOT LIKE "%R"' // 반품센터 제외
              + ' AND p_ab = "A"';

      // 2016-06-22 [43A0 쿱생활건강센터_수도]만 조회
      if para2 = '0043' then
        ashSQL := ashSQL + ' AND c_code = "43A0"';
    end
    else if branchAb = 'B' then // 지점
    begin
      Form1.lblCenter.Caption := '지점';
      {
      ashSQL := 'SELECT j_code, j_name FROM johap'
              + ' WHERE branch_ab = "' + branchAb + '"'
              + ' AND c_code IN (SELECT c_code FROM staff_center '
                              + ' WHERE m_code = "' + para1 + '"'
                              + ' AND o_code = "' + para2 + '"'
                              + ' AND c_code NOT LIKE "%R"' // 반품센터 제외
                              + ' AND p_ab = "A")';

      if(mpst_code = 'H14103898') then
      begin
        ashSQL := 'SELECT j_code, j_name FROM johap'
              + ' WHERE branch_ab = "' + branchAb + '"'
              + ' AND c_code IN (SELECT c_code FROM center '
              + ' WHERE o_code = "' + para2 + '"'
              + ' AND c_code NOT LIKE "%R"' // 반품센터 제외
              + ' AND p_ab = "A")';
      end;
      }

      ashSQL := 'SELECT j_code, j_name FROM johap'
              + ' WHERE branch_ab = "' + branchAb + '"'
              + ' AND j_code IN (SELECT j_code FROM staff_johap '
                              + ' WHERE m_code = "' + para1 + '"'
                              + ' AND o_code = "' + para2 + '"'
                              //+ ' AND c_code NOT LIKE "%R"' // 반품센터 제외
                              + ' AND p_ab = "A")';

      if(mpst_code = 'H14103898 ') then
      begin
        ashSQL := 'SELECT j_code, j_name FROM johap'
              + ' WHERE branch_ab = "' + branchAb + '"'
              + ' AND o_code = "' + para2 + '"';

      end;

    end;
  end
  else if ab = 'J' then // 조합
  begin
    if Length(para1) = 4 then
      ashStr := ' AND c_code = "' + para1 + '"'
    else if para1 <> '' then
      ashStr := ' AND c_code IN (' + para1 + ')'
    else
      ashStr := '';

    ashSQL := 'SELECT j_code, j_name FROM johap'
            + ' WHERE o_code = "' + para2 + '"'
            + ' AND o_code <> "0043"'     // 2016-06-13 쿱생활건강 제외
            + ashStr
//            + 'OR j_code = "0000"'
            + ' ORDER BY j_code';
  end;
  Form1.Memo1.Lines.Add(ashSQL);

  ashStr := MySQL_Assign(Form1.db_coopbase, Form1.qrySQL, ashSQL, vt);
  try
    StrToInt(ashStr);
  except
    ShowMessage('오류가 발생하였습니다.[' + ashStr + '](ERR:단체조회)');
    Exit;
  end;
end;

// 콤보박스, 체크리스트박스 설정
{ vt   : TZQuery명
  cbAb : 콤보박스 index 0의 text (A:전체, S:선택하세요, N:없음, C:코드만, M:코드명만)
  cbNm : 콤보박스
}
procedure setCb(vt: TVirtualTable; cbAb: String; cbNm: TWinControl);
var
  ashStr: String;
begin
   if (cbNm is TComboBox) then
  begin
    with TComboBox(cbNm)do
    begin
      Clear;

      if cbAb = 'A' then Items.Add('전체')
      else if cbAb = 'S' then Items.Add('선택하세요');

      if vt.RecordCount < 1 then
      begin
        Clear;
        items.Add(MSG_ERR_CD1); // 조회 권한이 없습니다
      end;

      vt.First;
      while not vt.Eof do
      begin
        if cbAb = 'C' then      // 코드
          ashStr := vt.Fields[0].AsString
        else if cbAb = 'M' then // 코드명
          ashStr := vt.Fields[1].AsString
        else                    // 코드 + ' ' + 코드명
          ashStr := vt.Fields[0].AsString + ' ' + vt.Fields[1].AsString;

        Items.Add(ashStr);
        ashStr := '';
        vt.Next;
      end;
      ItemIndex := 0;
    end;
  end
  else if (cbNm is TCheckListBox) then
  begin
    with TCheckListBox(cbNm)do
    begin
      Clear;

      if cbAb = 'A' then Items.Add('전체');

      if vt.RecordCount < 1 then
      begin
        Clear;
        items.Add(MSG_ERR_CD1); // 조회 권한이 없습니다
        ItemEnabled[0] := False;
      end;

      vt.First;
      while not vt.Eof do
      begin
        ashStr := vt.Fields[0].AsString + ' ' + vt.Fields[1].AsString;
        Items.Add(ashStr);
        ashStr := '';
        vt.Next;
      end;
      ItemIndex := 0;
    end;
  end;
end;

// 콤보박스 검색
procedure findCb(cb: TComboBox; key: Word);
var
  i, {codeLen, }keyLen, p: Integer;
  keyword: String;

  // 한영입력상태 확인 (한글:TRUE)
  function GetImeHanMode: boolean;
  var
    Mode: HIMC;
    Conversion, Sentence: dword;
  begin
    Mode := ImmGetContext(cb.Handle);
    ImmGetConversionStatus(Mode, Conversion, Sentence);
    result := Conversion = IME_CMODE_HANGEUL;
  end;

begin
  keyword := cb.Text;
  keyLen := Length(keyword);

  for i := 1 to cb.Items.Count - 1 do
  begin
    p := Pos(keyword, cb.Items.Strings[i]);

    if p > 0 then
    begin
      if Key = VK_RETURN then
      begin
        cb.ItemIndex := i;
        cb.Text := cb.Items.Strings[i];
        //SelectNext(ActiveControl, True, True); // SelectNext 함수는 Pubished로 선언된 함수이기 때문에 쓸 수 없다.
        key := 0;
      end

      else
      begin
        SendMessage(cb.Handle, CB_SHOWDROPDOWN, Integer(true), 0);

        if p <= 1 then

        else
        begin
          cb.ItemIndex := i;
          cb.Text := keyword;

          if (GetImeHanMode) and (Key in [$41..$5A]) then
            cb.SelStart := keyLen - 1
          else
            cb.SelStart := keyLen;
        end;
      end;
      Break;
    end;
  end;

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
procedure setObjEnable(const obj: TComponent; mode: Integer; e: Integer);
var
  esseColr, nesseColr, inactColr: TColor;
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

      else if (obj is TComboBox) or (obj is TCheckListBox) or (obj is TcxLookupComboBox) then
      begin
        TComboBox(obj).Enabled := false;
        TComboBox(obj).Color   := inactColr;
      end

      else if (obj is TCheckBox) or (obj is TRadioButton) or (obj is TButton) or (obj is TSpeedButton) then
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

      else if (obj is TComboBox) or (obj is TCheckListBox) or (obj is TcxLookupComboBox) then
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

      else if (obj is TRadioButton) or (obj is TButton) or (obj is TSpeedButton)then
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

      else if (obj is TComboBox) or (obj is TCheckListBox) or (obj is TcxLookupComboBox) then
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

      else if (obj is TCheckBox) or (obj is TRadioButton) or (obj is TButton) or (obj is TSpeedButton)then
      begin
        TWinControl(obj).Enabled := true;
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
        TDBGrid(obj).Enabled := true;
      end;
    end;
  end;
end;

end.
