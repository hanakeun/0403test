﻿//******************************************************************************
// 프로그램 : 연말정산 오류기준
// 담 당 자 : 최슬기
// 작업일자 :
// 완료일자 : 2018.02.25
// 개    요 :
// 작업상세 : 최초참고자료 2017년 귀속_근로소득(의료비포함)_전산매체제출요령(2017.10.30)
//            최종참고자료 20180212a_연말정산
//******************************************************************************
unit coophr_chkFile_utils;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, Forms,
  Dialogs, StdCtrls, ZConnection, ZDataset, DBGrids, Graphics, Grids,
  ComCtrls, Buttons, VirtualTable, Mask, CheckLst, DateUtils, cxCurrencyEdit,
  cxDBLookupComboBox, cxCheckComboBox, cxCheckBox, cxLookAndFeelPainters,
  cxGridTableView, cxGridCustomTableView, cxDropDownEdit, cxCheckListBox, cxRadioGroup,
  cxControls, cxTL, System.Types, System.RegularExpressions, System.Math;

  //연말정산 근로소득 레코드 검증
  function ChkFile(strfileCont : string; ab : string) : Boolean;
  //의료비 명세서 레코드 검증
  function ChkMedicalFile(strfileCont : string; ab : string) : boolean;
  //오류기입
  function errStr(recordAb : string; title : string; mName : string = ''; idNo : string = ''): string;

implementation

uses coop_sql_updel, Unit1, DB, coophr_utils;

function errStr(recordAb : string; title : string; mName : string = ''; idNo : string = ''): string;
begin
  if Copy(recordAb, 1, 1) = 'B' then
    Result := recordAb + '오류' + ' - ' + '[' + mName  + '] ' + title + ' 확인'
  else
  begin
    if isEmpty(mName) then
      Result := recordAb + '오류' + ' - ' + mName + '[' + idNo  + '] ' + title + ' 확인'
    else
      Result := recordAb + '오류' + ' - ' + title + ' 확인';
  end
end;

//의료비 명세서 레코드 검증
function ChkMedicalFile(strfileCont : string; ab : string) : boolean;
var
  chkList, errList : TStringList;
  A : array of AnsiString;
  tempArr : TArray<DOUBLE>;
  i, j, startNo, intSize : Integer;
  strSize, mName, idNo : string;
begin
  if not isEmpty(strfileCont) then Exit;

  chkList := TStringList.Create;
  errList := TStringList.Create;
  chkList.Clear;
  errList.Clear;
  chkList.Text := strfileCont;

  errList.Sorted := True;

  for i := 0 to chkList.Count - 1 do
  begin
    strSize := ''; startNo := 1; intSize := 0;

//Form1.memo1.Lines.Add(IntToStr(i) + ' > ' + IntToStr(Length(AnsiString(chkList.Strings[i]))));

    if Length(AnsiString(chkList.Strings[i])) <> 251 then
    begin
      errList.Add('기본사항 - 1. 레코드길이 오류');
    end;

    if Copy(AnsiString(chkList.Strings[i]), 1, 1) = 'A' then
    begin
      //초기값 할당
      System.FillChar(A, SizeOf(A), #0);

      //배열길이 할당 A[1] ~ A[24]만 사용한다
      SetLength(A, 25);

      // A레코드 [제출자 레코드]
      strSize := '1, 2, 3, 6, 8'     //자료관리번호
               + ', 10, 20, 4'       //제출자
               + ', 10, 40'          //원천징수의무자
               + ', 13, 1, 30'       //소득자(연말정산 신청자)
               + ', 10, 40, 1'       //지급처
               + ', 5, 11, 1'        //지급명세
               + ', 13, 1, 1, 1 ,19';//의료비 공제 대상자

      strSize := StringReplace(strSize, ' ', '',[rfReplaceAll, rfIgnoreCase]);
      for j := 1 to 24 do
      begin
        intSize := StrToInt(subStr(strSize, j, ','));

        A[j] := Copy(AnsiString(chkList.Strings[i]), startNo, intSize);

//Form1.memo1.Lines.Add(IntToStr(j) + ' > ' + A[j]);

        startNo := startNo + intSize;
      end;

      mName := A[13];
      mName := StringReplace(mName, ' ', '',[rfReplaceAll, rfIgnoreCase]);
      idNo := A[11];

      //【자료관리번호】
      //1 레코드 구분 X(1)
      //영문 대문자 ‘A’ 아니면 오류
      if A[1] <> 'A' then errList.Add(errStr('1', '레코드 구분', mName, idNo));

      //2 자료구분 9(2)
      //‘26’이 아니면 오류
      if A[2] <> '26' then errList.Add(errStr('2', '자료구분', mName, idNo));

      //3 세무서 X(3)
      //기재되어 있지 않으면 오류
      if not isEmpty(A[3]) then errList.Add(errStr('3', '세무서코드', mName, idNo));

      //4 일련번호 9(6)
      //기재되어 있지 않으면 오류
      if not isEmpty(A[4]) then errList.Add(errStr('4', '일련번호', mName, idNo));

      //5 제출년월일 9(8)
      //날짜형식에 맞지 않으면 오류
      if not isDate(A[5]) then errList.Add(errStr('5', '제출연월일', mName, idNo));

      //【제출자】
      //6 사업자등록번호 X(10)
      //1.공란이면 오류
      //2.잘못된 사업자등록번호 입력 시 오류
      if not isEmpty(A[6]) then
        errList.Add(errStr('6', '사업자등록번호-1', mName, idNo))
      else
      begin
        if not chkBizRegNo(A[6]) then
          errList.Add(errStr('6', '사업자등록번호-2', mName, idNo))
      end;

      //7 홈택스ID X(20)
      //홈택스 이용하여 전자신고하는 경우 기재되어 있지 않으면 오류
      if not isEmpty(A[7]) then errList.Add(errStr('7', '홈택스ID', mName, idNo));

      //8 세무프로그램코드 X(4)
      //기타프로그램은 “9000” 입력
      if A[8] <> '9000' then errList.Add(errStr('8', '세무프로그램코드', mName, idNo));

      //【원천징수의무자】
      //9 사업자등록번호 X(10)
      //1.기재되어 있지 않으면 오류
      //2.잘못된 사업자등록번호 입력 시 오류
      if not isEmpty(A[9]) then
        errList.Add(errStr('9', '사업자등록번호-1', mName, idNo))
      else
      begin
        if not chkBizRegNo(A[9]) then
          errList.Add(errStr('9', '사업자등록번호', mName, idNo));
      end;

      //10 상호 X(40)
      //기재되어 있지 않으면 오류
      if not isEmpty(A[10]) then errList.Add(errStr('10', '상호', mName, idNo));

      //【소득자(연말정산 신청자)】
      //11 소득자주민등록번호 X(13)
      //1.기재되어 있지 않으면 오류
      //2.잘못된 주민등록번호 입력 시 오류
      if not isEmpty(A[11]) then
        errList.Add(errStr('11', '소득자주민등록번호', mName, idNo))
      else
      begin
        if not chkIdNo(A[11]) then
          errList.Add(errStr('11', '소득자주민등록번호', mName, idNo));
      end;

      //12 내외국인 코드 9(1)
      //(‘1’,‘9’)가 아니면 오류
      if Pos(A[12], '[1][9]') = 0 then errList.Add(errStr('12', '내외국인 코드', mName, idNo)) ;

      //13 성명 X(30)
      //기재되어 있지 않으면 오류
      if not isEmpty(A[13]) then errList.Add(errStr('13', '성명', mName, idNo));

      //【지급처】
      //14 지급처 사업자등록번호
      //1.의료증빙코드(항목16)가‘1’이 아닌 경우 기재되어 있지 않으면 오류
      //2.잘못된 사업자등록번호 입력 시 오류
      if (A[16] <> '1') and (not isEmpty(A[14])) then
      begin
        errList.Add(errStr('14', '지급처 사업자등록번호-1', mName, idNo))
      end
      else
      begin
        if (isEmpty(A[14])) and (not chkBizRegNo(A[14])) then
          errList.Add(errStr('14', '지급처 사업자등록번호-2', mName, idNo))
      end;

      //15 지급처 상호 X(40)
      //의료증빙코드(항목16)가‘1’이 아닌 경우 기재되어 있지 않으면 오류
      if A[16] <> '1' then
      begin
        if not isEmpty(A[15]) then
          errList.Add(errStr('15', '의료증빙코드', mName, idNo)) ;
      end;

      //16 의료증빙코드 X(1)
      //(1,2,3,4,5)가 아니면 오류
      if Pos(A[16], '[1][2][3][4][5]') = 0 then errList.Add(errStr('16', '의료증빙코드', mName, idNo)) ;

      //【지급명세】
      //17 건수 9(5)
      //1.건수 < 0 이면 오류
      //2.의료증빙코드(항목16)가‘1’이 아닌데 건수가‘00000’이면 오류
      if strToInt(A[17]) < 0 then
        errList.Add(errStr('17', '건수', mName, idNo))
      else
      begin
        if (A[16] <> '1') and (A[17] = '00000') then
          errList.Add(errStr('17', '건수', mName, idNo));
      end;

      //18 금액 9(11)
      //지급금액 <= 0 이면 오류
      if strToFloat(A[18]) <= 0 then errList.Add(errStr('18', '금액', mName, idNo));

      //19 난임시술비 해당 여부 X(1)
      //(1 또는 공란)이 아니면 오류
      if Pos(A[19], '[1][ ]') = 0  then errList.Add(errStr('19', '난임시술비 해당 여부', mName, idNo));

      //【의료비 공제 대상자】
      //20 주민등록번호 X(13)
      //1.기재되어 있지 않으면 오류
      //2.잘못된 사업자등록번호 입력 시 오류
      if not isEmpty(A[20]) then
        errList.Add(errStr('20', '주민등록번호-1', mName, idNo))
      else
      begin
        if not chkIdNo(A[20]) then
          errList.Add(errStr('20', '주민등록번호-2', mName, idNo));
      end;

      //21 내외국인 코드 9(1)
      //(‘1’, ‘9’)가 아니면 오류
      if Pos(A[21], '[1][9]') = 0 then errList.Add(errStr('21', '내외국인 코드', mName, idNo));

      //22 본인 등 해당여부 9(1)
      //(‘1’, ‘2’)가 아니면 오류
      if Pos(A[22], '[1][2]') = 0 then errList.Add(errStr('22', '본인 등 해당여부', mName, idNo));

      //23 제출대상기간코드
      //(‘1’, ‘2’, ‘3’)이 아니면 오류
      if Pos(A[23], '[1][2][3]') = 0 then errList.Add(errStr('23', '제출대상기간코드', mName, idNo));
    end;
  end;

  Result := True;
  if errList.Count > 0 then
  begin
    if MessageDlg('*** 에러 ***' + #13#10 + errList.Text + #13
                    + '전산매체를 생성하시겠습니까?'
                    , mtConfirmation, [mbNo, mbYes], 0) = mrNo then
    begin
      ShowMessage('취소되었습니다.');
      Result := False;
    end;
  end;
end;

function ChkFile(strfileCont : string; ab : string) : boolean;
var
  chkList, errList : TStringList;
  A, B, C, D, H, E, F, G, iRecord : array of AnsiString;
  tempArr : TArray<DOUBLE>;

  i, j, startNo, intSize,
  aRecordCnt, aPersonCnt,
  bRecordCnt, bNo, bNo0,
  bworkplaceCnt, bBeforeWorkplaceCnt,
  cRecordCnt, cBeforeWorkplaceCnt, cLinealCnt, cSeniorCnt, cDisabledCnt,
  cChildDeductCnt, cUnderSixChildCnt, cAdoptChildCnt, cTempWorkCnt,
  dRecordCnt, dPersonalRecordCnt, dTempWorkCnt,
  eSeniorCnt, eDisabledCnt, eChildDeductCnt, eHouseHoldCnt,
  eUnderSixChildCnt, eAdoptChildCnt, eLinealCnt, eCnt,
  eRelationCnt, eRepeatCnt, eCond, eLength,
  fRelationCnt, fRepeatCnt, fCond, fLength,
  gRelationCnt, gRepeatCnt, gCond, gLength : Integer;

  bSalaryAmt, bIncometaxAmt, bLocalIncometaxAmt, bWithHoldFarmTaxAmt, bTotTaxAmt,
  cTempAmt, cTempAmt0, cTempAmt1, cTempMinAmt, cTempMaxAmt,
  cTempLimitAmt, cHouseHolderAmt, cLinealAmt,
  cSeniorAmt, cDisabledAmt, cLadyAmt, cSingleParentAmt,
  //C54, C58, C58ⓐ, C58ⓑ, C59
  cT01Amt, cT10Amt, cT11Amt, cT12Amt, cT20Amt,
  //C63, C112 ~ C117
  cTotSalaryAmt, cStandardTaxAmt, cCalculateTaxAmt,
  cIncometaxReduceAmt, cSpecialTaxAmt1, cSpecialTaxAmt2,
  cTaxPactReduceAmt, cNonTaxSumAmt, cTotAmt,
  cRentRepayAmt2, cDonationCarryAmt, cPrAnnuitySavingAmt,
  cSubscriptDepositAmt, cGeneralSubscriptDepositAmt, cHousePurchaseAmt,
  cNhisAmt, cEiAmt, cChildDeductAmt,
  cUnderSixChildAmt, cAdoptChildAmt, cHouseOptionAmt,
  //C128, C130, C132, C133, C135, C137, C139
  c128Amt, c130Amt, c132Amt, c133Amt, c135Amt, c137Amt, c139Amt,
  //C141, C143, C145, C147, C149, C150A
  c141Amt, c143Amt, c145Amt, c147Amt, c149Amt, c150aAmt,
  //C63 합계, C159 합계, C160 합계, C161 합계
  cSumTotSalaryAmt, cSumIncomeTaxAmt, cSumLocalTaxAmt, cWithHoldFarmTaxAmt,
  //C165, C166, C167
  cExIncomeTaxAmt, cExLocalTaxAmt, cExWithholdFarmTaxAmt,
  //C168 , C168 계산값, C169 , C169 계산값
  cCalIncomeTaxAmt, cIncomeTaxAmt, cCalLocalTaxAmt, cLocalTaxAmt,
  //C170 , C170 계산값
  cCalWithholdFarmTaxAmt, cWithholdFarmTamAmt,
  dTempAmt, dTempAmt0,
  //D47의 합, D52의 합
  dT01TotAmt, dT20TotAmt,
  dNonTaxSumAmt, dTotAmt, dTotHouseOptionAmt,
  //D51의 합, D51(a)의 합, D51(b)의 합
  dT10TotAmt, dT11TotAmt, dT12TotAmt,
  dTotPaidIncomeTaxAmt, dTotPaidLocalTaxAmt, dTotPaidWithholdFarmTaxAmt,
  fTempAmt, fTempRate,
  //F7 소득공제구분이 11, 12, 21, 22, 32, 34인 경우 합계
  f11TotAmt, f12TotAmt, f21TotAmt, f22TotAmt, f32TotAmt, f34TotAmt,
  //H15 중 H9의 구분에 따른 합계
  h10DonationAmt, h20DonationAmt,
  h40DonationAmt, h41DonationAmt, h42DonationAmt,
  //E30의 합계, E31의 합계, E32의 합계,
  eTotE30Amt, eTotE31Amt, eTotE32Amt, eTotMedicalAmt,
  eEduOwnAmt, eEduSpecailAmt, eEduStudentAmt, eEduCollegeAmt : Double;

  strSize, mName, IdNo,
  btaxOffice, bBizNo, bName,
  cForeignTaxYn, cForeignAb,
  cMname, cIdNo,
  cStrReduceFromDate, cStrReduceToDate, cResidentAb,
  dIdNo, dIdNo0,
  eIdNo, eIdNo0 : String;

  lastPayDt, yyyyDt : TDate;

  cSingleParentYn, dDeductDateYn : Boolean;

  {C85 ~ C93 중 금액이 있는 항목의 공제한도 금액 중 최고값 반환
  항목 공제한도 공제한도 Numbering
  C85	600만원   > 4
  C86	1,000만원 > 3
  C87	1,500만원 > 2
  C88	1,500만원 > 2
  C89	500만원   > 5
  C90	1,800만원 > 1
  C91	1,500만원 > 2
  C92	500만원   > 5
  C93	300만원   > 6}
  Function totalLimitAmt(C85, C86, C87, C88, C89, C90, C91, C92, C93 : Double) : Double;
  begin
    if C90 <> 0 then
      Result := 18000000
    else if (C87 <> 0) or (C88 <> 0) or (C91 <> 0) then
      Result := 15000000
    else if C86 > 0 then
      Result := 10000000
    else if C85 > 0 then
      Result := 6000000
    else if (C89 <> 0) or (C92 <> 0) then
      Result := 5000000
    else if C93 <> 0 then
      Result := 3000000
    else
      Result := 0;
  end;

  {ab
  1 0보다 작을 경우                                ▶ getErrYn('1', strToFloat(C[])
  2 외국인 단일세율 일 때, 값이 0이 아닌 경우      ▶ getErrYn('2', strToFloat(C[]), cForeignAb, cForeignTaxYn)
  3 비거주자 일 때, 값이 0이 아닌 경우             ▶ getErrYn('3', strToFloat(C[]), C[7])
  4 관계코드가 (‘6’,‘7’,‘8‘)인데 값이 0보다 큰 경우▶ getErrYn('4', strToFloat(C[]), E[7])

  val         ▶값
  cond, cond0 ▶ab에 따른 값의 조건}
  Function getErrYn(ab: string; val: Double = 0; cond : string = ''; cond0 : string = ''): Boolean;
  begin
    Result := false;
    if ab = '1' then
    begin
      if val < 0 then Result := True;
    end
    else if ab = '2' then
    begin
      //외국인이면서 단일세율 적용함인 경우
      if (cond = '9') and (cond0 = '1') then
      begin
        if val <> 0 then Result := True;
      end;
    end
    else if ab = '3' then
    begin
      if cond = '2' then
      begin
        if val <> 0 then Result := True;
      end;
    end
    else if ab = '4' then
    begin
      if Pos(cond, '[6][7][8]') > 0 then
      begin
        if val > 0 then Result := True;
      end;
    end;
  end;

  function getErrLimitAmt(mainVal: Double = 0; subVal: Double = 0; workCnt: Integer = 0; limitAmt: Double = 0) : Boolean;
  var
    calLimitAmt: Double;
  begin
    calLimitAmt := 0;
    calLimitAmt := workCnt * limitAmt;

    Result := false;
    if mainVal < 0 then
    begin
      Result := True;
    end
    else
    begin
      if subVal > 0 then
      begin
        if mainVal + subVal > calLimitAmt then Result := True;
      end
      else
      begin
        if mainVal > calLimitAmt then Result := True;
      end;
    end;
  end;

  //String의 값이 0 or Null인지 확인
  function isEmpty0(str: String): Boolean;
  var
    i : Integer;
  begin
    str := StringReplace(Trim(str), ' ', '',[rfReplaceAll, rfIgnoreCase]);

    if not isEmpty(str) then
      Result := False
    else
    begin
      if TryStrToInt(str, i) then
      begin
        if StrToFloat(str) = 0 then
          Result := false
      end
      else
        Result := True;
    end;
  end;

  //F레코드에서는 반복이 있으므로 한번 vt에 넣고 Locate
  {function commonCodeVt(codeId : string) : TVirtualTable;
  var
    ashSQL, ashStr: string;
  begin
    ashSQL := 'SELECT hr_code_id, hr_code_value, hr_code_value_name'
            + ' FROM hr_common_code_value'
            + ' WHERE hr_code_id = "' + codeId + '"'
            + ' AND hr_use_yn <> "N"'
            + ' ORDER BY hr_sort_seq ASC, hr_code_value ASC';

    Form1.Memo1.Lines.Add('commonCodeVt > ' + #13#10 + ashSQL);
    ashStr := MySQL_Assign(Form1.db_coophr, Form1.qrysql, ashSQL, Form1.vtTemp);
    try
      StrToInt(ashStr);
    except
      if mpst_code = '2016060060' then
      begin
        ShowMessage(ashStr);
      end;
    end;
  end;}

  //hr_country_ab           ▶외국명코드
  //hr_financial_company_ab ▶금융기관코드
  //C소득자마다 반복되는데 내국인이 상대적으로 많으므로 조회로 변경
  function commonCodeYn(codeId : string; codeValue : string) : Boolean;
  var
    ashSQL, ashStr: string;
  begin
    ashSQL := 'SELECT hr_code_id, hr_code_value, hr_code_value_name'
            + ' FROM hr_common_code_value'
            + ' WHERE hr_code_id = "' + codeId + '"'
            + ' AND hr_code_value = "' + codeValue + '"'
            + ' AND hr_use_yn <> "N"'
            + ' ORDER BY hr_sort_seq ASC, hr_code_value ASC';

    Form1.Memo1.Lines.Add('commonCodeYn > ' + #13#10 + ashSQL);
    ashStr := MySQL_Assign(Form1.db_coophr, Form1.qrysql, ashSQL, Form1.vtTemp);
    try
      StrToInt(ashStr);
    except
      if mpst_code = '2016060060' then
      begin
        ShowMessage(ashStr);
      end;
    end;

    if Form1.vtTemp.RecordCount = 0 then
      Result := False
    else
      Result := True;
  end;

  procedure bRecordErrCompare;
  begin
    //B9 주(현)근무처 (C레코드)수 9(7) bworkplaceCnt
    //1.주(현)근무처수 ≦ 0 이면 오류
    //2.주(현)근무처수가 C레코드수와 일치하지 않으면 오류
    if (bworkplaceCnt <= 0) or (bworkplaceCnt <> cRecordCnt) then
      errList.Add(errStr('B9', '주(현)근무처 (C레코드)수', bName));

    //B10 종(전)근무처 (D레코드)수 9(7) bBeforeWorkplaceCnt
    //1.종(전)근무처수 < 0 이면 오류
    //2.종(전)근무처수가 D레코드수와 일치하지 않으면 오류
    if (bBeforeWorkplaceCnt < 0) or (bBeforeWorkplaceCnt <> dRecordCnt) then
      errList.Add(errStr('B10', '종(전)근무처 (D레코드)수', bName));

    //B11 총급여 총계 9(14)  bSalaryAmt
    //1.총급여총계 < 0 이면 오류
    //2.총급여총계[B11] ≠ (C레코드의 총급여[C63] 합)이면 오류
    if (bSalaryAmt < 0) or (bSalaryAmt <> cSumTotSalaryAmt) then
    begin
      errList.Add(errStr('B11', '총급여 총계', bName));
ShowMessage('bSalaryAmt > '+FloatToStr(bSalaryAmt));
ShowMessage('cSumTotSalaryAmt > '+FloatToStr(cSumTotSalaryAmt));
    end;

    //B12 결정세액(소득세)총계 9(13) bIncometaxAmt
    //1.결정세액(소득세)총계 < 0 이면 오류
    //2.결정세액(소득세)총계[B12] ≠ (C레코드의 결정세액(소득세)[C159]의합)이면 오류
    if (bIncometaxAmt < 0) or (bIncometaxAmt <> cSumIncomeTaxAmt) then
      errList.Add(errStr('B12', '결정세액(소득세)총계', bName));

    //B13 결정세액(지방소득세) 총계 9(13) bLocalIncometaxAmt
    //1.결정세액(지방소득세)총계 < 0 이면 오류
    //2.결정세액(지방소득세)총계[B14]≠(C레코드의 결정세액(지방소득세)[C160]의합)이면 오류
    if (bLocalIncometaxAmt < 0) or (bLocalIncometaxAmt <> cSumLocalTaxAmt) then
      errList.Add(errStr('B13', '결정세액(지방소득세) 총계', bName));

    //B14 결정세액(농특세) 총계 9(13) bWithHoldFarmTaxAmt
    //1.결정세액(농특세)총계 < 0 이면 오류
    //2.결정세액(농특세)총계[B15] ≠ (C레코드의 결정세액(농특세)[C161]의합)이면 오류
    if (bWithHoldFarmTaxAmt < 0) or (bWithHoldFarmTaxAmt <> cWithHoldFarmTaxAmt) then
      errList.Add(errStr('B14', '결정세액(농특세) 총계', bName));

    cRecordCnt := 0; dRecordCnt := 0;
    cSumTotSalaryAmt := 0; cSumIncomeTaxAmt := 0;
    cSumLocalTaxAmt := 0; cWithHoldFarmTaxAmt := 0;
  end;

  procedure cRecordErrCompare;
  begin
    //C6 종(전)근무처 수
    //2. 소득자(근로자)의 D레코드수와 일치하지 않으면 오류
    if (cBeforeWorkplaceCnt <> dPersonalRecordCnt) or (cBeforeWorkplaceCnt < 0) then
      errList.Add(errStr('C6', '종(전)근무처 수-1', mName, idNo));

    //C20	감면기간 시작연월일
    //5.세액감면이 있는데([C114+C115+C116+C117]>0)
    //주(현)감면기간([C20], [C21]) 또는 모든 종(전)의 감면기간([D13], [D14])이 기재되어 있지 않으면 오류
    if cIncometaxReduceAmt + cSpecialTaxAmt1 + cSpecialTaxAmt2 + cTaxPactReduceAmt > 0 then
    begin
      if (cStrReduceFromDate = '00000000') and (cStrReduceToDate = '00000000') then
      begin
        if not dDeductDateYn then
          errList.Add(errStr('C20', '감면기간 시작연월일-0', mName, idNo));
      end
    end;

    //D47 T01-외국인기술자 9(10)
    //4.세액감면(조특법)이 있는데(C114>0) 감면소득이 없으면(C54+(모든 종(전)의 (D47)의 합)=0) 오류
    if (cIncometaxReduceAmt > 0) and (cT01Amt + dT01TotAmt = 0) then
      errList.Add(errStr('D47', 'T01-외국인기술자', mName, idNo));

    //D52 T20-조세조약상 교직자 감면
    //5.세액감면(조세조약)이 있는데(C116>0) 감면소득이 없으면(C59+(모든 종(전)의 (D52)의 합)=0) 오류
    if (cSpecialTaxAmt2 > 0) and (cT20Amt + dT20TotAmt = 0) then
    begin
//Form1.Memo1.Lines.Add('D52 mName ▶ '+ mName + ' C116  ▶ '+ FloatToStr(cSpecialTaxAmt2) +
//' C59   ▶ '+ FloatToStr(cT20Amt) +' 모든 종(전)의 (D52)의 합 ▶ '+ FloatToStr(dT20TotAmt));

      errList.Add(errStr('D52', 'T20-조세조약상 교직자 감면', mName, idNo));
    end;

    //C54 T01-외국인기술자
    //4.세액감면(조특법)이 있는데([C115]>0) :[C54] + [모든 종(전) [D47]의 합]=0 이면 오류
    if (cSpecialTaxAmt1 > 0) and (cT01Amt + dT01TotAmt = 0) then
      errList.Add(errStr('C54', 'T01-외국인기술자', mName, idNo));

    //C59 T20-조세조약상 교직자감면 9(10)
    //5.세액감면(조세조약)이 있는데([C117]>0) :[C59] + [모든 종(전)의 [D52]의 합] = 0 이면 오류
    if (cTaxPactReduceAmt > 0) AND (cT20Amt + dT20TotAmt = 0) then
      errList.Add(errStr('C59', 'T20-조세조약상 교직자감면', mName, idNo));

    //C63 총급여 9(11)
    //1.총급여 < 0 이면 오류
    //2.외국인 단일세율([C11]=‘9’, [C9]=‘1’)인 경우:
    //[C63] < [C29+C60]+[모든 종(전)의 [D22+D53]의 합] 이면 오류
    //3.외국인 단일세율적용이 아닌 경우 :[C63] ≠ [C29] + [모든 종(전) [D22]의 합]이면 오류
    {C63 : cTotSalaryAmt, C29 : cTotAmt, C60 : cNonTaxSumAmt, D22 : dTotAmt, D53 : dNonTaxSumAmt}
    if cTotSalaryAmt < 0 then
    begin
      errList.Add(errStr('C63', '총급여-1', mName, idNo));
    end
    else 
    begin
      if (cForeignAb = '9') AND (cForeignTaxYn = '1') then
      begin
        if cTotSalaryAmt < cTotAmt + cNonTaxSumAmt + dTotAmt + dNonTaxSumAmt then
          errList.Add(errStr('C63', '총급여-2', mName, idNo));
      end
      else
      begin
        if cTotSalaryAmt <> cTotAmt + dTotAmt then
          errList.Add(errStr('C63', '총급여-3', mName, idNo));
      end;
    end;

    //C114  소득세법, C115	조특법(제외), C116	조특법 제30조, C117	조세조약
    //3.주(현) 감면기간([C20], [C21])과 모든 종(전)의 감면기간([D13], [D14])이 기재되어 있지 않은데
    //[C114] + [C115] + [C116] + [C117] ≠ 0이면 오류
    if (cStrReduceFromDate = '00000000') and (cStrReduceToDate = '00000000') then
    begin
      if not dDeductDateYn  then
      begin
        if cIncometaxReduceAmt + cSpecialTaxAmt1 + cSpecialTaxAmt2 + cTaxPactReduceAmt <> 0 then
        begin
          errList.Add(errStr('C114', '소득세법-0', mName, idNo));
          errList.Add(errStr('C115', '조특법(제외)-0', mName, idNo));
          errList.Add(errStr('C116', '조특법 제30조-0', mName, idNo));
          errList.Add(errStr('C117', '조세조약-0', mName, idNo));
        end;
      end;
    end;

    //C115	조특법(제외)
    //3.[C54]+[모든 종(전)의 [D47]의 합]=0 일 때:[C115] ≠ 0 이면 오류
    //4.[C115]>[C113]×(([C54]+[모든종(전)의 [D47]의 합])/[C63])×50%이면오류
    if (cT01Amt + dT01TotAmt = 0) and (cIncometaxReduceAmt <> 0 ) then
      errList.Add(errStr('C115', '조특법(제외)', mName, idNo))
    else
    begin
      cTempAmt := 0;
      cTempAmt := cCalculateTaxAmt * ((cT01Amt + dT01TotAmt)/cTotSalaryAmt) * 0.5;

      if cIncometaxReduceAmt > cTempAmt then
        errList.Add(errStr('C115', '조특법(제외)', mName, idNo));
    end;

    //C116	조특법 제30조
    //2.[C116] > ①+②+③ 이면 오류
    //1)=[C113]×(([C58]+[종(전)의[D51]의합])/[C63])×100%
    //2)=[C113]×(([C58ⓐ]+[종(전)의[D51ⓐ]의합])/[C63])×50%
    //3)=MIN([C113]×(([C58ⓑ]+[종(전)의[D51ⓑ]의합])/[C63])×70%, 150만원)
    cTempAmt  := 0; cTempAmt0 := 0; cTempAmt1 := 0;

    cTempAmt  := ((cT10Amt + dT10TotAmt) / cTotSalaryAmt) * 1;
    cTempAmt0 := ((cT11Amt + dT11TotAmt) / cTotSalaryAmt) * 0.5;
    cTempAmt1 := ((cT12Amt + dT12TotAmt) / cTotSalaryAmt) * 0.7;

    if cTempAmt1 > 1500000 then cTempAmt1 := 1500000;

    if cSpecialTaxAmt1 > cTempAmt + cTempAmt0 + cTempAmt1 then
      errList.Add(errStr('C116', '조특법 제30조-2', mName, idNo));

    //C117	조세조약
    //3.[C59] + [모든 종(전)의 [D52]의 합] = 0 일 때:[C117] ≠ 0 이면 오류
    //4.[C117]>[C113]×(([C59]+[모든종(전)의 [D52]의 합])/[C63])×100%이면오류
    if (cT20Amt + dT20TotAmt = 0) and (cTaxPactReduceAmt <> 0) then
    begin
      errList.Add(errStr('C117', '조세조약-1', mName, idNo))
    end
    else
    begin
      cTempAmt := 0;
      if cTotSalaryAmt <> 0 then
        cTempAmt := cCalculateTaxAmt * ((cT20Amt + dT20TotAmt)/cTotSalaryAmt);

      if cTaxPactReduceAmt > cTempAmt then errList.Add(errStr('C117', '조세조약-2', mName, idNo))
    end;

    //【납부특례세액】
    //C165 소득세 9(10) cExIncomeTaxAmt
    //1.[C165] < 0 이면 오류
    //2.[C25] + [모든 종(전)의 [D18] 의 합] = 0 일 때:[C165] > 0 이면 오류
    if cExIncomeTaxAmt < 0  then
      errList.Add(errStr('C165', '소득세', mName, idNo))
    else if (cHouseOptionAmt + dTotHouseOptionAmt = 0) and (cExIncomeTaxAmt > 0) then
      errList.Add(errStr('C165', '소득세', mName, idNo));

    //C166 지방소득세 9(10)
    //1.[C166] < 0 이면 오류
    //2.[C25] + [모든 종(전)의 [D18] 의 합] = 0 일 때:[C166] > 0 이면 오류
    if cExLocalTaxAmt < 0 then
      errList.Add(errStr('C166', '지방소득세', mName, idNo))
    else if (cHouseOptionAmt + dTotHouseOptionAmt = 0) and (cExLocalTaxAmt > 0) then
      errList.Add(errStr('C166', '지방소득세', mName, idNo));

    //C167 농특세 9(10)
    //1.[C167] < 0 이면 오류
    //2.[C25] + [모든 종(전)의 [D18] 의 합] = 0 일 때:[C167] > 0 이면 오류
    if cExWithholdFarmTaxAmt < 0 then
      errList.Add(errStr('C167', '농특세', mName, idNo))
    else if (cHouseOptionAmt + dTotHouseOptionAmt = 0) and (cExWithholdFarmTaxAmt > 0) then
      errList.Add(errStr('C167', '농특세', mName, idNo));

    //【차감징수세액】
    //C168 소득세 9(1) 9(10)
    //1.계산값*) < 0 일 때: 부호가 ‘0’ 이면 오류
    //2.계산값*) ≧ 0 일 때: 부호가 ‘1’ 이면 오류
    //3.계산값*) ≧ 0 이고 계산값*) < 1,000원 일 때: [C168] ≠ 0 이면 오류
    //4.계산값*) < 0 또는 계산값*) ≧ 1,000원 일 때: [C168] ≠ 계산값(10원 미만 단수절사) 이면 오류
    //계산값*)=[C159]-[C162]-[모든종(전)의[D56]의합] - [C165]
    //cCalIncomeTaxAmt에서 [모든종(전)의[D56]의합]을 차감하고 10원 미만 단수절사를 진행
    cCalIncomeTaxAmt := Trunc((cCalIncomeTaxAmt - dTotPaidIncomeTaxAmt) * 0.1) * 10;

    if cCalIncomeTaxAmt < 0 then
    begin
      //부호가 0이면 양수
      if cIncomeTaxAmt >= 0 then
        errList.Add(errStr('C168', '소득세', mName, idNo));
    end
    else
    begin
      //부호가 1이면 음수
      if cIncomeTaxAmt < 0 then
        errList.Add(errStr('C168', '소득세', mName, idNo))
      else
      begin
        if cCalIncomeTaxAmt < 1000 THEN
        begin
          if cIncomeTaxAmt <> 0 then
            errList.Add(errStr('C168', '소득세', mName, idNo));
        end
        else
        begin
          if cIncomeTaxAmt <> cCalIncomeTaxAmt then
          errList.Add(errStr('C168', '소득세', mName, idNo));
        end;
      end;
    end;

    //C169 지방소득세 9(1) 9(10)
    //차감징수세액(소득세)이 소액부징수인 경우 소액부징수 함
    //1.계산값*) < 0 일 때: 부호가  ‘0’ 이면 오류
    //2.계산값*) ≧ 0 일 때: 부호가 ‘1’ 이면 오류
    //3.[C168] = 0 일 때: [C169] ≠ 0 이면 오류
    //4.[C168] < 0 또는 [C168] ≧ 1,000원 일 때:[C169] ≠ 계산값*)(10원 미만 단수절사) 이면 오류
    //계산값=[C160]-[C163]-[모든종(전)의[D57]의합] - [C166]
    //cCalLocalTaxAmt에서 [모든종(전)의[D57]의합]을 차감하고 10원 미만 단수절사를 진행
    cCalLocalTaxAmt := Trunc((cCalLocalTaxAmt - dTotPaidLocalTaxAmt) * 0.1) * 10;

    if cCalLocalTaxAmt < 0 then
    begin
      if cLocalTaxAmt >= 0 then
        errList.Add(errStr('C169', '지방소득세', mName, idNo));
    end
    else
    begin
      if cLocalTaxAmt < 0 then
        errList.Add(errStr('C169', '지방소득세', mName, idNo))
      else
      begin
        if cCalLocalTaxAmt < 1000 then
        begin
          if cLocalTaxAmt <> 0 then
            errList.Add(errStr('C169', '지방소득세', mName, idNo));
        end
        else
        begin
          if cLocalTaxAmt <> cCalLocalTaxAmt then
            errList.Add(errStr('C169', '지방소득세', mName, idNo));
        end;
      end;
    end;

    //C170 농특세 9(1) 9(10)
    //1.계산값*) < 0 일 때: 부호가  ‘0’ 이면 오류
    //2.계산값*) ≧ 0 일 때: 부호가 ‘1’ 이면 오류
    //3.계산값*) ≧ 0 이고 계산값*) < 1,000원 일 때: [C170] ≠ 0 이면 오류
    //4.계산값*) < 0 또는 계산값*) ≧ 1,000원 일 때: [C170] ≠ 계산값*)(10원 미만 단수절사) 이면 오류
    //계산값=[C161]-[C164]-[모든종(전)의[D58]의합] - [C167]
    // dTotPaidWithholdFarmTaxAmt에서 [모든종(전)의[D58]의합]을 차감하고 10원 미만 단수절사를 진행
    cCalWithholdFarmTaxAmt := Trunc((cCalWithholdFarmTaxAmt - dTotPaidWithholdFarmTaxAmt) * 0.1) * 10;

    if cCalWithholdFarmTaxAmt < 0 then
    begin
      if cWithholdFarmTamAmt >= 0 then
        errList.Add(errStr('C170', '농특세', mName, idNo));
    end
    else
    begin
      if cWithholdFarmTamAmt < 0 then
        errList.Add(errStr('C170', '농특세', mName, idNo))
      else
      begin
        if cCalWithholdFarmTaxAmt < 1000 then
        begin
          if cWithholdFarmTamAmt <> 0 then
            errList.Add(errStr('C170', '농특세', mName, idNo));
        end
        else
        begin
          if cWithholdFarmTamAmt <> cCalWithholdFarmTaxAmt then
            errList.Add(errStr('C170', '농특세', mName, idNo));
        end;
      end;
    end;

    //C141	㉮특별세액공제_기부금_정치자금_10만원이하_공제대상금액
    //5.[C141]+[C143] ≠ [H15]*) 이면 오류
    //C143	㉮특별세액공제_기부금_정치자금_10만원초과_공제대상금액
    //5.[C141]+[C143] ≠ [H15]*) 이면 오류
    if c141Amt + c143Amt <> h20DonationAmt then
    begin
      errList.Add(errStr('C141', '특별세액공제_기부금_정치자금_10만원이하_공제대상금액', mName, idNo));
      errList.Add(errStr('C143', '특별세액공제_기부금_정치자금_10만원초과_공제대상금액', mName, idNo));
    end;

    //C145	㉯특별세액공제_기부금_법정기부금_공제대상금액
    //5.[C145] ≠ [H15]*) 이면 오류
    if c145Amt <> h10DonationAmt then
      errList.Add(errStr('C145', '특별세액공제_기부금_법정기부금_공제대상금액-0', mName, idNo));

    //C147	㉰특별세액공제_기부금_우리사주조합기부금_공제대상금액
    //5.[C147] ≠ [H15]*) 이면 오류
    if c147Amt <> h42DonationAmt then
      errList.Add(errStr('C147', '특별세액공제_기부금_우리사주조합기부금_공제대상금액-0', mName, idNo));

    //C149	㉱특별세액공제_기부금_지정기부금_종교단체외_공제대상금액
    //5.[C141]+[C143] ≠ [H15]*) 이면 오류
    if c149Amt <> h40DonationAmt then
      errList.Add(errStr('C149', '특별세액공제_기부금_지정기부금_종교단체외_공제대상금액-0', mName, idNo));

    //C150ⓐ	㉲특별세액공제_기부금_지정기부금_종교단체_공제대상금액
    //5.[C141]+[C143] ≠ [H15]*) 이면 오류
    if c150aAmt <> h41DonationAmt then
      errList.Add(errStr('C150ⓐ', '특별세액공제_기부금_지정기부금_종교단체_공제대상금액', mName, idNo));

    //C67 배우자공제금액
    //4.[C67] > 0 인 경우 : 배우자 인원수*) ≠ 1 이면 오류
    if (cHouseHolderAmt > 0) and (eHouseHoldCnt <> 1) then errList.Add(errStr('C67', '배우자공제금액', mName, idNo));

    if cResidentAb = '1' then
    begin
      //C68 부양가족공제인원
      //3.[C7]=‘1’ 인 경우: [C68] ≠ 공제인원수*) 이고 [C69] ≠ 0 이면 오류
      if (cLinealCnt <> eLinealCnt) and (cLinealAmt <> 0) then
        errList.Add(errStr('C67', '주민등록번호', mName, idNo));

      //C70	경로우대공제인원
      //2.[C7]=‘1’ 인  경우: [C70] ≠ 경로공제인원수*) 이고 [C71] ≠ 0 이면 오류
      if (cSeniorCnt <> eSeniorCnt) and (cSeniorAmt <> 0) then
        errList.Add(errStr('C70', '경로우대공제인원', mName, idNo));

      //C72	장애인공제인원
      //2.[C7]=‘1’인 경우: [C72] ≠ 장애인공제인원수*) 이고 [C73] ≠ 0 이면 오류
      if (cDisabledCnt <> eDisabledCnt) and (cDisabledAmt <> 0) then
        errList.Add(errStr('C72', '장애인공제인원', mName, idNo));
    end;

    //C75 한부모가족공제금액
    //5.[C75] > 0인 경우: 소득공제명세(E레코드)에
    //-기본공제가 ‘여’(1)인 직계비속(관계코드:4,5)이 없으면 오류
    if (cSingleParentAmt > 0) and (not cSingleParentYn) then
      errList.Add(errStr('C75', '한부모가족공제금액', mName, idNo));

    //C81	㉮보험료-건강보험료(노인장기요양보험료 포함)
    //4.[C81+C82]>[소득공제명세(E레코드)의 건강·고용 보험료 합계]이면 오류
    //C82	㉯보험료-고용보험료
    //4.[C81+C82]>[소득공제명세(E레코드)의 건강·고용 보험료 합계]이면 오류
    if cNhisAmt + cEiAmt <> eTotE30Amt then
    begin
      errList.Add(errStr('C81', '보험료-건강보험료(노인장기요양보험료 포함)', mName, idNo));
      errList.Add(errStr('C82', '보험료-고용보험료', mName, idNo));
    end;

    // C121 ㉮자녀세액공제 인원
    //4.[C121] > 자녀세액공제인원수*) 이고 [C122] ≠ 0 이면 오류
    // C123 ㉯6세이하자녀 세액공제 인원
    //4.[C123] > 6세이하자녀세액공제인원수*) 이고 [C124] ≠ 0 이면 오류
    if (cChildDeductCnt > eChildDeductCnt) and (cChildDeductAmt <> 0) then
      errList.Add(errStr('C121', '자녀세액공제 인원', mName, idNo));
    if (cUnderSixChildCnt > eUnderSixChildCnt) and (cUnderSixChildAmt <> 0) then
      errList.Add(errStr('C121', '세이하자녀 세액공제 인원', mName, idNo));

    //C125	출산/입양세액공제인원
    //4.[C125] > 출산‧입양세액공제인원수*) 이고 [C126] ≠ 0 이면 오류
    if (cAdoptChildCnt > eAdoptChildCnt) and (cAdoptChildAmt <> 0) then
      errList.Add(errStr('C125', '출산/입양세액공제인원', mName, idNo));

    //C133	특별세액공제_보장성보험료_공제대상금액
    //4.[C133]>[소득공제명세(E레코드)의 보장성보험료 합계] 이면 오류
    //C135	특별세액공제_장애인전용보장성보험료_공제대상금액
    //4.[C135] > 소득공제명세(E레코드)의 장애인전용보장성보험료 합계 이면 오류
    if c133Amt > eTotE31Amt then
      errList.Add(errStr('C133', '특별세액공제_보장성보험료_공제대상금액', mName, idNo));
    if c135Amt > eTotE32Amt then
      errList.Add(errStr('C135', '특별세액공제_장애인전용보장성보험료_공제대상금액', mName, idNo));

    // * 본인 등 의료비 지출금액
    //: 소득공제명세(E레코드)의 본인
    //, 과세기간종료일 현재 65세 이상인 자(’52.12.31.이전 출생)
    //, 장애인의 의료비와 난임수술비용 합계액
    //**그 외 의료비 지출액: 본인 등 의료비 지출금액에 해당하지 않는 그 외 부양가족의 소득공제명세의 의료비 합계액
    // A레코드 의료비 명세서로 진행하는 편이 좋을 듯
    //eTotMedicalAmt
    //eMedicalOwnAmt
    //eMedicalDependentAmt
    //eMedicalDisableAmt
    //if E[7 + eRepeatCnt] = '0' then
    //if Copy(E[10 + eRepeatCnt], 1, 8) < FormatDateTime('yymmdd', IncYear(yyyyDt, -65)) then
    //if Pos(E[12], '[1][2][3]') > 0 then

    //C137	특별세액공제_의료비_공제대상금액
    //5.[C137]>소득공제명세(E레코드)의 의료비 합계이면 오류
    if c137Amt > eTotMedicalAmt then errList.Add(errStr('C137', '특별세액공제_의료비_공제대상금액', mName, idNo));

    //C139	특별세액공제_교육비_공제대상금액
    //4.[C139] > 교육비 공제대상금액 합계*) 이면 오류
    if c139Amt > eEduOwnAmt + eEduSpecailAmt + eEduStudentAmt + eEduCollegeAmt then
      errList.Add(errStr('C139', '특별세액공제_교육비_공제대상금액', mName, idNo));

    //C98	개인연금저축소득공제
    //5.[C98] > [연금·저축등소득·세액명세(F레코드) 개인연금저축(소득공제구분:21)의 공제금액 합계]이면 오류
    if cPrAnnuitySavingAmt > f21TotAmt then
      errList.Add(errStr('C98', '개인연금저축소득공제', mName, idNo));

    //C100	㉮주택마련저축소득공제_청약저축
    //5.[C101] > 주택청약종합저축(소득공제구분:32)의 공제금액 합계 이면 오류
    //C101	㉯주택마련저축소득공제_주택청약종합저축
    //5.[C101] > 주택청약종합저축(소득공제구분:32)의 공제금액 합계 이면 오류
    if cGeneralSubscriptDepositAmt > f32TotAmt then
    begin
      errList.Add(errStr('C100', '주택마련저축소득공제_청약저축', mName, idNo));
      errList.Add(errStr('C101', '주택마련저축소득공제_주택청약종합저축', mName, idNo));
    end;

    //C102	㉰주택마련저축소득공제_근로자주택마련저축
    //3.[C102] > 근로자주택마련저축(소득공제구분:34)의 공제금액 합계 이면 오류
    if cHousePurchaseAmt > f34TotAmt then
      errList.Add(errStr('C102', '주택마련저축소득공제_근로자주택마련저축', mName, idNo));

    //C128	연금계좌_과학기술인공제_세액공제액
    //6.[C128]>과학기술인공제(소득공제구분:12)의 공제금액 합계이면 오류
    if cHousePurchaseAmt > f12TotAmt then
      errList.Add(errStr('C128', '연금계좌_과학기술인공제_세액공제액', mName, idNo));

    //C130	연금계좌_근로자퇴직급여보장법에 따른 퇴직급여_세액공제액
    //6.[C130]> 근로자퇴직급여(소득공제구분:11)의 공제금액 합계이면 오류
    if c130Amt > f11TotAmt then
      errList.Add(errStr('C130', '연금계좌_근로자퇴직급여보장법에 따른 퇴직급여_세액공제액', mName, idNo));

    //C132	연금계좌_연금저축_세액공제액
    //6.[C130]> 연금저축(소득공제구분:22)의 공제금액 합계이면 오류
    if c130Amt > f22TotAmt then
      errList.Add(errStr('C132', '연금계좌_연금저축_세액공제액', mName, idNo));

    //mName := ''; IdNo := '';
    //cMname := ''; cIdNo := '';
    dIdNo := ''; dIdNo0 := '';
    //D47의 합, D51의 합, D51(a)의 합, D51(b)의 합, D52의 합
    dT01TotAmt := 0; dT10TotAmt := 0; dT11TotAmt := 0; dT12TotAmt := 0; dT20TotAmt := 0;
    //개인별 D레코드의 합
    dPersonalRecordCnt := 0;
    dNonTaxSumAmt := 0; dTotAmt := 0;
    dTotHouseOptionAmt := 0; dTotPaidIncomeTaxAmt := 0;
    dTotPaidLocalTaxAmt := 0; dTotPaidWithholdFarmTaxAmt := 0;
    //2014년 이후 기부금코드와 합계를 표기
    h10DonationAmt := 0; h20DonationAmt := 0;
    h40DonationAmt := 0; h41DonationAmt := 0; h42DonationAmt := 0;
    //C67, 배우자 인원수*
    cHouseHolderAmt := 0; eHouseHoldCnt := 0;
    //C68, 공제인원수, C69
    cLinealCnt := 0; eLinealCnt := 0; cLinealAmt := 0;
    //C70, 경로공제인원수, C71
    cSeniorCnt := 0; eSeniorCnt := 0; cSeniorAmt := 0;
    //C72, 장애인공제인원수, C73
    cDisabledCnt := 0; eDisabledCnt := 0; cDisabledAmt := 0;
    //C75, 소득공제명세(E레코드)에 기본공제가 ‘여’(1)인 직계비속(관계코드:4,5)이 Boolean
    cSingleParentAmt := 0; cSingleParentYn := False;
    //C81, C82, 소득공제명세(E레코드)의 건강·고용 보험료 합계
    cNhisAmt := 0; cEiAmt := 0; eTotE30Amt := 0;
    //C121, 자녀세액공제인원수*, C122
    cChildDeductCnt := 0; cChildDeductAmt := 0; eChildDeductCnt := 0;
    //C123, 6세이하자녀세액공제인원수*, C124
    cUnderSixChildCnt := 0; cUnderSixChildAmt := 0; eUnderSixChildCnt := 0;
    //C133, 소득공제명세(E레코드)의 보장성보험료 합계
    c133Amt := 0; eTotE31Amt := 0;
    //C135,	특별세액공제_장애인전용보장성보험료_공제대상금액
    c135Amt := 0; eTotE32Amt := 0;
    //C137, 소득공제명세(E레코드)의 의료비 합계
    c137Amt := 0; eTotMedicalAmt := 0;
    //C139 특별세액공제_교육비_공제대상금액
    c139Amt := 0;
    //본인, 장애인 특수교육비, 취학전아동과 초·중·고등학, 대학생
    eEduOwnAmt := 0; eEduSpecailAmt := 0; eEduStudentAmt := 0;eEduCollegeAmt := 0;
    dDeductDateYn := False;
  end;

BEGIN
  if not isEmpty(strfileCont) then Exit;

  chkList := TStringList.Create;
  errList := TStringList.Create;
  chkList.Clear;
  errList.Clear;
  chkList.Text := strfileCont;

  //귀속연월 설정
  //StrToDate('2017/12/31');
  yyyyDt := EndOfTheYear(IncYear(Now, -1));

  //add전에 Sort를 True로 변경해야 한다.  그렇지 않으면 중복된 데이터를 허용하고 정렬기능만 허용한다.
  errList.Sorted := True;

  aRecordCnt := 0;
  aPersonCnt := 0;

  for i := 0 to chkList.Count - 1 do
  begin
//Memo1.Lines.add(Copy(AnsiString(chkList.Strings[i]), 1, 1) +' > '+IntToStr(i));
    strSize := ''; startNo := 1; intSize := 0;

    //*********************************************************기본사항
    {Y 1. 레코드 길이  A,B,C,D,E,F,G,H,I 각 레코드의 길이가 1,620 BYTE가 아니면 오류
    Y 2. 제출파일     제출파일의 첫번째 레코드가 'A'레코드가 아니면 오류
    Y 3. A레코드의 수 제출파일에 A레코드가 1개가 아니면 오류
    Y 4. B레코드의 수 제출파일에 수록되는 B레코드 수가 A레코드의 신고의무자수(항목14)와 일치하지 않으면 오류
    5. C레코드의 수 제출파일에 수록되는 C레코드 수가 B레코드의 주(현)근무처수(항목9)의 합계와 일치하지 않으면 오류
    6. D레코드의 수 제출파일에 수록되는 D레코드 수가 C레코드의 종(전)근무처수(항목6)의 합계와 일치하지 않으면 오류
    7. E레코드의 수 C레코드의 거주자구분코드(항목7)가 비거주자인 근로소득자에 대한 E레코드가 1개가 아니면 오류
    8. F레코드의 수 C레코드의 퇴직연금,연금저축,주택마련저축,장기집합투자증권저축 소득공제금액이 있는 경우 F레코드가 존재하지 않으면 오류
    9. G레코드의 수 C레코드의 월세액,거주자간 주택임차차입금원리금상환액 공제금액이 있을 경우 G레코드가 존재하지 않으면 오류
    10. H레코드의 수 C레코드의 기부금 공제금액이 있을 경우 H레코드가 존재하지 않으면 오류
    11. I레코드의 수 E레코드의 기부금 공제금액(해당 연도)이 있을 경우 I레코드가 존재하지 않으면 오류
    }
    //*********************************************************

    if Length(AnsiString(chkList.Strings[i])) <> 1620 then
      errList.Add('기본사항 - 1. 레코드길이 오류');

    if (i = 0) AND (Copy(AnsiString(chkList.Strings[i]), 1, 1) <> 'A') then
      errList.Add('기본사항 - 2. 제출파일의 첫번째 레코드가 A레코드가 아니면 오류');

    if Copy(AnsiString(chkList.Strings[i]), 1, 1) = 'A' then
    begin
      cBeforeWorkplaceCnt := 0;
      bRecordCnt := 0; bNo := 0; bNo0 := 0;
      //C63 합계, C159 합계, C160 합계, C161 합계
      cSumTotSalaryAmt := 0; cSumIncomeTaxAmt := 0;
      cSumLocalTaxAmt := 0; cWithHoldFarmTaxAmt := 0;
      //B9, B10, B11, B12, B13, B14, B15
      bworkplaceCnt := 0; bBeforeWorkplaceCnt := 0;
      bSalaryAmt := 0; bIncometaxAmt := 0;
      bLocalIncometaxAmt := 0; bWithHoldFarmTaxAmt := 0; bTotTaxAmt := 0;
      //D47의 합, D52의 합
      //D51의 합, D51(a)의 합, D51(b)의 합
      dT01TotAmt := 0; dT10TotAmt := 0; dT11TotAmt := 0;
      dT12TotAmt := 0; dT20TotAmt := 0;
      dPersonalRecordCnt := 0;
      //2014년 이후 기부금코드와 합계를 표기
      h10DonationAmt := 0; h20DonationAmt := 0;
      h40DonationAmt := 0; h41DonationAmt := 0;  h42DonationAmt := 0;
      //C레코드와 비교하기 위한 e레코드 Count
      eSeniorCnt := 0; eDisabledCnt := 0; eChildDeductCnt := 0;
      eUnderSixChildCnt := 0; eAdoptChildCnt := 0; eLinealCnt := 0;
      eTotE30Amt := 0; eTotE31Amt := 0; eTotE32Amt := 0; eTotMedicalAmt := 0;
      eEduOwnAmt := 0; eEduSpecailAmt := 0; eEduStudentAmt := 0; eEduCollegeAmt := 0;
      //
      cSingleParentYn := False;
      //F7 소득공제구분이 11, 12, 21, 22, 32, 34인 경우 합계
      f11TotAmt := 0; f12TotAmt := 0; f21TotAmt := 0; f22TotAmt := 0; f32TotAmt := 0; f34TotAmt := 0;
      //
      cRecordCnt := 0; dRecordCnt := 0;

      //A레코드 증가
      Inc(aRecordCnt);

      //초기값 할당
      System.FillChar(A, SizeOf(A), #0);

      //배열길이 할당 A[1] ~ A[16]만 사용한다
      SetLength(A, 17);

      // A레코드 [제출자 레코드]
      strSize := '1, 2, 3, 8'
                + ', 1, 6, 20, 4, 10, 40, 30, 30, 15'
                + ', 5, 3, 1442';

      strSize := StringReplace(strSize, ' ', '',[rfReplaceAll, rfIgnoreCase]);
      for j := 1 to 16 do
      begin
        intSize := StrToInt(subStr(strSize, j, ','));

        A[j] := Copy(AnsiString(chkList.Strings[i]), startNo, intSize);

form1.Memo1.Lines.Add('A > ' + inttostr(j) + ' > ' + A[j]);

        startNo :=  startNo + intSize;
      end;

      aPersonCnt := StrToInt(A[14]);

      // A1 레코드 구분 X(1) 영문 대문자 ‘A’ 아니면 오류
      if A[1] <> 'A' then errList.Add(errStr('A1', '레코드 구분'));
      // A2 자료구분    9(2) '20’이 아니면 오류
      if A[2] <> '20' then errList.Add(errStr('A2', '자료구분'));
      // A3 세무서코드  X(3) 기재되어 있지 않으면 오류
      if not isEmpty(A[3]) then errList.Add(errStr('A3', '세무서코드'));
      // A4 제출연월일  9(8) 날짜형식에 맞지 않으면 오류
      if not isDate(A[4]) then errList.Add(errStr('A4', '제출연월일'));
      // A5 제출자 구분 9(1) ‘1’,‘2’,‘3’이 아니면 오류
      if Pos(A[5], '[1][2][3]') = 0 then errList.Add(errStr('A5', '제출자 구분'));

      //A6 세무대리인 관리번호 X(6)
      //1.제출자가 세무대리인인 경우(A5=‘1’) 공란이면 오류
      //2.제출자가 세무대리인이 아닌 경우(A5≠‘1’) 공란이 아니면 오류
      if A[5] = '1' then
      begin
        if not isEmpty(A[6]) then errList.Add(errStr('A6', '세무대리인관리번호'));
      end
      else
      begin
        if isEmpty(A[6]) then errList.Add(errStr('A6', '세무대리인관리번호'));
      end;

      //A7 홈택스ID X(20)
      //홈택스를 이용하여 전자신고하는 경우 기재되어 있지 않으면 오류
      if not isEmpty(A[7]) then errList.Add(errStr('A7', '홈택스ID'));

      //A8 세무프로그램코드 X(4)
      //세무프로그램 코드가 아니면 오류
      if A[8] <> '9000' then errList.Add(errStr('A8', '세무프로그램코드'));

      //A9 사업자등록번호 X(10)
      //1.공란이면 오류
      //2.잘못된 사업자등록번호 입력 시 오류
      if not isEmpty(A[9]) then
        errList.Add(errStr('A9', '사업자등록번호'))
      else
      begin
        if not chkBizRegNo(A[9]) then
          errList.Add(errStr('A9', '사업자등록번호'));
      end;

      //A10 법인명(상호) X(40)
      //기재되어 있지 않으면 오류
      if not isEmpty(A[10]) then errList.Add(errStr('A10', '법인명(상호)'));

      //A11 담당자 부서  X(30)
      //기재되어 있지 않으면 오류
      if not isEmpty(A[11]) then errList.Add(errStr('A11', '담당자 부서'));

      //A13 담당자 전화번호 X(15)
      //기재되어 있지 않으면 오류
      if not isEmpty(A[13]) then errList.Add(errStr('A13', '담당자 전화번호'));

      //A14 신고의무자수 9(5)
      //B레코드수(원천징수의무자별 집계레코드)와 일치하지 않으면 오류

      //A15 사용한글코드 9(3)
      //‘101’이 아니면 오류
      if A[15] <> '101' then errList.Add(errStr('A15', '사용한글코드'));

      //A16 공란 X(1442)
      //공란이 아니면 오류
      if isEmpty(A[16]) then errList.Add(errStr('A16', '공란'));
    end;

    if Copy(AnsiString(chkList.Strings[i]), 1, 1) = 'B' then
    begin
      btaxOffice := ''; bBizNo := '';

      //초기값 할당
      System.FillChar(B, SizeOf(B), #0);

      //B레코드 수 증가
      Inc(bRecordCnt);

      //배열길이 할당 B[1] ~ B[17]만 사용한다
      SetLength(B, 18);

      strSize := '1, 2, 3, 6' //4
              + ', 10, 40, 30, 13' //4
              + ', 7, 7, 14, 13, 13, 13, 13, 1, 1434'; // 9

      strSize := StringReplace(strSize, ' ', '',[rfReplaceAll, rfIgnoreCase]);
      for j := 1 to 17 do
      begin
        intSize := StrToInt(subStr(strSize, j, ','));

        B[j] := Copy(AnsiString(chkList.Strings[i]), startNo, intSize);

form1.Memo1.Lines.Add('B > ' + inttostr(j) + ' > ' + B[j]);

        startNo :=  startNo + intSize;
      end;

      btaxOffice  := B[3];
      bBizNo      := B[5];
      bName       := B[6];                  //법인명
      bName       := StringReplace(bName, ' ', '',[rfReplaceAll, rfIgnoreCase]);
      bworkplaceCnt       := strToInt(B[9]);
      bBeforeWorkplaceCnt := strToInt(B[10]);
      bSalaryAmt          := strToFloat(B[11]);
      bIncometaxAmt       := strToFloat(B[12]);
      bLocalIncometaxAmt  := strToFloat(B[13]);
      bWithHoldFarmTaxAmt := strToFloat(B[14]);
      bTotTaxAmt          := strToFloat(B[15]);

      //B1 레코드 구분 X(1)
      //영문 대문자 ‘B’ 아니면 오류
      if B[1] <> 'B' then errList.Add(errStr('B1', '레코드 구분', bName));

      //B2 자료구분 9(2)
      //'20’이 아니면 오류
      if B[2] <> '20' then errList.Add(errStr('B2', '자료구분', bName));

      //B3 세무서코드 X(3)
      //기재되어 있지 않으면 오류
      if not isEmpty(B[3]) then errList.Add(errStr('B3', '세무서', bName));

      //B4 일련번호 9(6)
      //마지막 B레코드의 일련번호가 A레코드의 신고의무자수[A14]와 일치하지 않으면 오류
      bNo := StrToInt(B[4]);

      //B9, B10, B11, B12, B13, B14 레코드 비교
      if (bRecordCnt > 1) and (bNo <> bNo0) then bRecordErrCompare;

      bNo0 := bNo;

      //B5 사업자등록번호 X(10)
      //1.기재되어 있지 않으면 오류
      //2.잘못된 사업자등록번호 입력 시 오류
      if not isEmpty(B[5]) then
        errList.Add(errStr('B5', '사업자등록번호', bName))
      else
      begin
        if not chkBizRegNo(B[5]) then
          errList.Add(errStr('B5', '사업자등록번호', bName));
      end;

      //B6 법인명(상호) X(40)
      //기재되어 있지 않으면 오류
      if not isEmpty(B[6]) then errList.Add(errStr('B6', '법인명(상호)', bName));

      //B7 대표자(성명) X(30)
      //기재되어 있지 않으면 오류
      if not isEmpty(B[7]) then errList.Add(errStr('B7', '대표자(성명)', bName));

      //B8 주민(법인)등록번호 X(13)
      //법인 : 법인등록번호, 개인 : 주민등록번호
      //1.기재되어 있지 않으면 오류
      //2.잘못된 주민등록번호 입력 시 오류
      if not isEmpty(B[8]) then
        errList.Add(errStr('B8', '주민(법인)등록번호', bName))
      else
      begin
        if Length(Trim(B[8])) = 13 then
        begin
          if not chkIdNo(B[8]) then errList.Add(errStr('B8', '주민(법인)등록번호', bName));
        end
      end;

      //B15 결정세액총계 9(13)
      //1.결정세액총계 < 0 이면 오류
      //2.결정세액총계[B15] ≠ (결정세액(소득세)[B12]  + 결정세액(지방소득세)[B13] + 결정세액(농특세) [B14])이면 오류
      if strToFloat(B[15]) < 0 then
        errList.Add(errStr('B15', '결정세액총계', bName))
      else
      begin
        if strToFloat(B[15]) <> strToFloat(B[12]) + strToFloat(B[13]) + strToFloat(B[14]) then
          errList.Add(errStr('B15', '결정세액총계', bName));
      end;

      //B16 제출대상기간 코드 9(1)
      //(‘1’,‘2’,‘3’)이 아니면 오류
      if Pos(B[16], '[1][2][3]') = 0 then errList.Add(errStr('B16', '제출대상기간 코드', bName));

      //B17 공란 X(1434)
      //공백이 아니면 오류}
      if isEmpty(B[17]) then errList.Add(errStr('B17', '공란', bName));
    end;

    if Copy(AnsiString(chkList.Strings[i]), 1, 1) = 'C' then
    begin
      cForeignTaxYn := ''; cForeignAb := '';
      eCnt := 0; eRelationCnt := 0;
      eIdNo := ''; eIdNo0 := '';
      dIdNo := ''; dIdNo0 := '';
      dDeductDateYn := False;

      //초기값 할당
      System.FillChar(C, SizeOf(C), #0);

      //C레코드 증가
      Inc(cRecordCnt);

      //배열길이 할당 C[1] ~ C[173]만 사용한다
      SetLength(C, 174);

      //※주의사항 : 소득자(근로자) C9, C9(a)을 하나로 합친다.
      //※주의사항 : C56, C56(a)를 하나로 합친다.
      //※주의사항 : C58, C58(a), C58(b)를 하나로 합친다.
      //※주의사항 : C150, C150ⓐ, C150ⓑ를 하나로 합친다.

      strSize := '1, 2, 3, 6'                       // 자료관리번호    4 > C1 ~ C4
               + ', 10'                             // 원천징수의무자  1 > C5
               + ', 2, 1, 2, 2, 30, 1, 13, 2, 1, 1' // 소득자(근로자) 10 > C6 ~ C15 ★(C9, C9(a))

               + ', 10, 40, 8, 8, 8'   // C16 ~ C20
               + ', 8, 11, 11, 11, 11' // C21 ~ C25
               + ', 11, 11, 21, 11'    // C26 ~ C29
                                       // 근무처별 소득명세- 주(현)근무처 14

               + ', 10, 10, 10, 10, 10' // C30 ~ C34
               + ', 10, 10, 10, 10, 10' // C35 ~ C39
               + ', 10, 10, 10, 10, 10' // C40 ~ C44
               + ', 10, 10, 10, 10, 10' // C45 ~ C49
               + ', 10, 10, 10, 10, 10' // C50 ~ C54
               + ', 10, 20, 10, 30, 10, 10, 10' // C55 ~ C61 ★(C56, C56(a)) (C58, C58(a), C58(b))
                                                  // 주(현)근무처 비과세소득 및 감면 소득 32

               + ', 0, 11, 10, 11'                                       // 정산명세 3 C63 ~ C65  (★62)
               + ', 8, 8, 2, 8'                                          // 기본공제 4 C66 ~ C69
               + ', 2, 8, 2, 8, 8, 10'                                   // 추가공제 6 C70 ~ C75
               + ', 10, 10, 10, 10, 10'                                  // 연금보험료공제 5 C76 ~ C80
               + ', 10, 10'                                              // 특별소득공제 2   C81 ~ C82
               + ', 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 11, 0, 11, 11'         // 주택자금 14      C83 ~ C97 (★95)
               + ', 8, 10, 10, 10, 10, 10, 8, 10, 0, 10, 0, 10, 11, 11, 11, 10'// 그 밖의 소득공제 14 C98 ~ C113  (★106, 108)
               + ', 10, 10, 10, 10, 0, 10'                                  // 세액감면 5          C114 ~ C119 (★118)

               + ', 10, 2, 10, 2, 10, 2'                                 // 세액공제 42         C120 ~ C125
               + ', 10, 10, 10, 10, 10, 10, 10, 10'                      // C126 ~ C133
               + ', 10, 10, 10, 10, 10, 10, 10, 10'                      // C134 ~ C141
               + ', 10, 11, 10, 11, 10, 11, 10, 11'                      // C142 ~ C149
               + ', 31, 10, 10, 10, 10, 10, 10, 8, 10'                   // C150 ~ C158 ★(C150, C150ⓐ, C150ⓑ)

               + ', 10, 10, 10'                                           // C159 ~ C161 결정세액
               + ', 10, 10, 10'                                           // C162 ~ C164 기납부세액 - 주(현)근무지 3
               + ', 10, 10, 10'                                           // C165 ~ C167 납부특례세액 3
               + ', 11, 11, 11, 1, 4, 20';                                // C168 ~ C173 차감징수세액 5

      strSize := StringReplace(strSize, ' ', '',[rfReplaceAll, rfIgnoreCase]);
      for j := 1 to 173 do
      begin
        //if j in [62, 95, 106, 108, 118] then continue;

        intSize := StrToInt(subStr(strSize, j, ','));

        C[j] := Copy(AnsiString(chkList.Strings[i]), startNo, intSize);

form1.Memo1.Lines.Add('C  ▶ ' + inttostr(j) + ' ▶ ' + inttostr(intSize) + ' ▶ ' +  C[j] + ' ▶ ' + inttostr(startNo));

        startNo :=  startNo + intSize;
      end;

      cForeignTaxYn := Copy(C[9], 1, 1);
      cForeignAb := C[11];
      cMname := StringReplace(C[10], ' ', '',[rfReplaceAll, rfIgnoreCase]);;
      cIdNo := StringReplace(C[12], ' ', '',[rfReplaceAll, rfIgnoreCase]);;

      //
      if (cRecordCnt > 1) and (cIdNo <> IdNo) then cRecordErrCompare;

      mName := cMname;
      IdNo := cIdNo;

      //************************************************************************【자료관리번호】
      //C1 레코드 구분 X(1)
      //영문 대문자 ‘C’ 아니면 오류
      if C[1] <> 'C' then errList.Add(errStr('C1', '레코드 구분', mName, idNo));

      //C2 자료구분 9(2)
      //‘20’이 아니면 오류
      if C[2] <> '20' then errList.Add(errStr('C2', '자료구분', mName, idNo));

      //C3 세무서코드 X(3)
      //[C3] ≠ [B3]이면 오류
      if C[3] <> btaxOffice then errList.Add(errStr('C3', '세무서코드', mName, idNo));

      //************************************************************************【원천징수의무자】
      //C5 사업자등록번호 X(10)
      //1.[C5] ≠ [B5]이면 오류
      //2.잘못된 사업자등록번호 입력 시 오류
      if C[5] <> bBizNo then
        errList.Add(errStr('C5', '사업자등록번호', mName, idNo))
      else
      begin
        if not chkBizRegNo(C[5]) then
          errList.Add(errStr('C5', '사업자등록번호', mName, idNo));
      end;
      //************************************************************************【소득자(근로자)】
      //C6 종(전)근무처 수 9(2)
      //1.종(전)근무처수 < 0이면 오류
      //N 2.소득자(근로자)의 D레코드수와 일치하지 않으면 오류
      cBeforeWorkplaceCnt := StrToInt(C[6]);

      //C7 거주자구분코드 9(1)
      //‘1’, ‘2’가 아니면 오류
      cResidentAb := C[7];
      if Pos(C[7], '[1][2]') = 0 then errList.Add(errStr('C7', '거주자구분코드', mName, idNo));

      //C8 거주지국코드 X(2)
      //1.[C7] = ‘2’인 경우 : ‘KR’ 또는 공백이면 오류
      //2.[C7] = ‘1’인 경우 :
      // -[C11] = ‘1’ 일때 : ‘KR’또는 공백이 아니면 오류
      // -[C11] = ‘9’ 일때 : 공백이 아니면 오류
      //3.기재된 국가코드가 미등록된 코드이면 오류

      if C[7] = '2' then
      begin
        if Pos(C[8], '[KR][  ]') > 0 then
          errList.Add(errStr('C8', '거주지국코드', mName, idNo));
      end
      else if C[7] = '1' then
      begin
        if C[11] = '1' then
        begin
          if Pos(C[8], '[KR][  ]') = 0 then
            errList.Add(errStr('C8', '거주지국코드', mName, idNo));
        end
        else if C[11] = '9' then
        begin
          if not isEmpty(C[8]) then
            errList.Add(errStr('C8', '거주지국코드', mName, idNo))
          else
          begin
            if not commonCodeYn('hr_country_ab', C[8]) then
              errList.Add(errStr('C8', '거주지국코드', mName, idNo))
          end;
        end;
      end;

      //C9, C9(a)를 합침
      //C9 외국인단일세율적용 9(1)
      //1.(‘1’,‘2’)가 아니면 오류
      //2.[C11] = ‘1’ 일때 : [C9] = '1' 이면 오류
      if Pos(cForeignTaxYn, '[1][2]') = 0 then
      begin
        errList.Add(errStr('C9', '외국인단일세율적용', mName, idNo));
      end
      else
      begin
        if (C[11] = '1') and (cForeignTaxYn = '1') then
          errList.Add(errStr('C9', '외국인단일세율적용', mName, idNo));
      end;

      //C9(a) 외국법인소속 파견근로자여부 X(1)
      //1.(‘1’,‘2’)가 아니면 오류
      //2.[C11] = ‘1’ 일때 : [C9ⓐ] = '1' 이면 오류
      if Pos(Copy(C[9], 2, 1), '[1][2]') = 0 then
      begin
        errList.Add(errStr('C9(a)', '외국인단일세율적용', mName, idNo));
      end
      else
      begin
        if (C[11] = '1') and (Copy(C[9], 2, 1) = '1') then
          errList.Add(errStr('C9(a)', '외국인단일세율적용', mName, idNo));
      end;

      //C10 성명 X(30)
      //기재되어 있지 않으면 오류
      if not isEmpty(C[10]) then errList.Add(errStr('C10', '성명', mName, idNo));

      //C11 내외국인 구분코드 9(1)
      //1:내국인, 9:외국인
      //1. (‘1’,‘9’)가 아니면 오류
      if Pos(C[11], '[1][9]') = 0 then errList.Add(errStr('C11', '내외국인 구분코드', mName, idNo));

      //C12 주민등록번호 X(13)
      //1.기재되어 있지 않으면 오류
      //2. [C11] = ‘1’인 경우 : 잘못된 주민등록번호 입력 시 오류
      if not isEmpty(C[12]) then
        errList.Add(errStr('C12', '주민등록번호', mName, idNo))
      else
      begin
        if C[11] = '1' then
        begin
          if not chkIdNo(C[12]) then
            errList.Add(errStr('C12', '주민등록번호', mName, idNo));
        end;
      end;

      //C13 국적코드 X(2)
      //외국인인 경우만 기재, 내국인은 공란(거주지국 코드표 참조, 영문 대문자로 기재)
      //1.[C11] = ‘1’ 인 경우: ‘KR’ 또는 공백 아니면 오류
      //2.[C11] = ‘9’ 인 경우: 기재되어 있지 않으면 오류, 국가코드가 미등록된 코드 또는 ‘KR’ 이면 오류
      if C[11] = '1' then
      begin
        if Pos(C[13], '[KR][  ]') = 0 then
          errList.Add(errStr('C13', '국적코드', mName, idNo));
      end
      else if C[11] = '9' then
      begin
        if not isEmpty(C[13]) then
          errList.Add(errStr('C13', '국적코드', mName, idNo))
        else
        begin
          if not commonCodeYn('hr_country_ab', C[13]) then
            errList.Add(errStr('C13', '국적코드', mName, idNo))
          else
          begin
            if C[13] = 'KR' then
              errList.Add(errStr('C13', '국적코드', mName, idNo));
          end;
        end;
      end;

      //C14 세대주여부 X(1)
      //1.(‘1’, ‘2’)가 아니면 오류
      //2.외국인(C11 = ‘9’)이 세대주(‘1’)이면 오류
      if Pos(C[14], '[1][2]') = 0 then
        errList.Add(errStr('C14', '세대주여부', mName, idNo))
      else if (C[11] = '9') and (C[14] = '1') then
        errList.Add(errStr('C14', '세대주여부', mName, idNo));

      //C15 연말정산구분 X(1)
      //1:계속근로, 2:중도퇴사
      //(‘1’, ‘2’)가 아니면 오류
      if Pos(C[15], '[1][2]') = 0 then errList.Add(errStr('C15', '연말정산구분', mName, idNo));

      //************************************************************************【근무처별 소득명세- 주(현)근무처】
      //C16 ⑩주현근무처- 사업자등록번호 X(10)
      //1.기재되어 있지 않으면 오류
      //2.잘못된 사업자등록번호 입력 시 오류
      if not isEmpty(C[16]) then
        errList.Add(errStr('C16', '주현근무처- 사업자등록번호', mName, idNo))
      else
      begin
        if not chkBizRegNo(C[16]) then
          errList.Add(errStr('C16', '주현근무처- 사업자등록번호', mName, idNo));
      end;

      //C17 ⑨주현근무처-근무처명 X(40)
      //기재되어 있지 않으면 오류
      if not isEmpty(C[17]) then errList.Add(errStr('C17', '주현근무처-근무처명', mName, idNo));

      //C18 ⑪근무기간 시작연월일 9(8)
      //주(현)근무처 해당 과세기간의 근무기간 시작연월일
      //예)2017년1월1일 20170101
      //1.[C18] > [C19]이면 오류
      //2.귀속년도를 벗어나면 오류
      // CompareDate(convtDateType(C[18]), convtDateType(C[19])) = 1 (A > B)
      if C[18] > C[19] then
        errList.Add(errStr('C18', '근무기간 시작연월일', mName, idNo))
      else if Copy(C[18], 1, 4) > FormatDateTime('yyyy', yyyyDt) then
        errList.Add(errStr('C18', '근무기간 시작연월일', mName, idNo));

      //C19 ⑪근무기간 종료연월일 9(8)
      //주(현)근무처 해당 과세기간의 근무기간 종료연월일
      //예)2017년12월31일 20171231
      //1.귀속년도를 벗어나면 오류
      //2.[C15]='1'인 경우 귀속년도 마지막날(12.31일)이 아니면 오류
      if Copy(C[19], 1, 4) > FormatDateTime('yyyy', yyyyDt) then
        errList.Add(errStr('C19', '근무기간 종료연월일', mName, idNo))
      else if C[15] = '1' then
      begin
        if C[19] <> FormatDateTime('yyyymmdd', EndOfTheYear(yyyyDt)) then
          errList.Add(errStr('C19', '근무기간 종료연월일', mName, idNo));
      end;

      //C20 ⑫감면기간 시작연월일 9(8)
      //해당 과세기간에 해당하는 감면기간 시작연월일 기재(해당사항 없는 경우 0으로 채움)
      //예)2017년1월1일 20170101
      //근무기간을 초과하여 기재할 수 없음
      //1.[C20] > [C21] 이면 오류
      //2.귀속년도를 벗어나면 오류
      //3.[C20] < [C18] 이면 오류
      //4. [C113] > 0이고, 세액감면이 없는데 ([C114+C115+C116+C117]=0): [C20], [C21]이 기재되어 있으면 오류
      //N 5.세액감면이 있는데([C114+C115+C116+C117]>0)
      //주(현)감면기간([C20], [C21]) 또는  모든 종(전)의 감면기간([D13], [D14])이 기재되어 있지 않으면 오류
      //C20 6.감면소득이 있는데([C54+C58+C59]>0) 감면기간([C20], [C21])이 기재되어 있지 않으면 오류
      //cStrReduceFromDate := ''; cStrReduceToDate := '';
      cStrReduceFromDate := C[20];
      cStrReduceToDate := C[21];
      //cTempAmt := 0;

      if C[20] = '00000000' then
      begin
        if (StrToFloat(C[54]) + StrToFloat(Copy(C[58], 1, 10)) + StrToFloat(C[59]) > 0) and (C[21] = '00000000') then
          errList.Add(errStr('C20', '감면기간 시작연월일-1', mName, idNo));
      end
      else
      begin
        //CompareDate(convtDateType(C[20]), convtDateType(C[21])) = 1 (A > B)
        if C[20] > C[21] then
          errList.Add(errStr('C20', '감면기간 시작연월일-2', mName, idNo))
        else if Copy(C[20], 1, 4) > FormatDateTime('yyyy', yyyyDt) then
          errList.Add(errStr('C20', '감면기간 시작연월일-3', mName, idNo))
        //CompareDate(convtDateType(C[20]), convtDateType(C[18])) = -1 (A < B)
        else if C[20] < C[18] then
          errList.Add(errStr('C20', '감면기간 시작연월일-4', mName, idNo))
        else
        begin
          if (StrToFloat(C[113]) > 0) and (StrToFloat(C[114]) + StrToFloat(C[115]) + StrToFloat(C[116]) + StrToFloat(C[117]) = 0) then
          begin
            if (C[20] <> '00000000') or (C[21] <> '00000000') then
              errList.Add(errStr('C20', '감면기간 시작연월일-5', mName, idNo));
          end;
        end;
      end;

      //C21 ⑫감면기간 종료연월일 9(8)
      //해당 과세기간에 해당하는 감면기간 종료연월일 기재(해당사항 없는 경우 0으로 채움)
      //1.귀속년도를 벗어나면 오류
      //2.[C21] > [C19] 이면 오류
      if C[21] <> '00000000' then
      begin
        if Copy(C[21], 1, 4) > FormatDateTime('yyyy', yyyyDt) then
          errList.Add(errStr('C21', '감면기간 종료연월일', mName, idNo))
        else if C[21] > C[19] then
          errList.Add(errStr('C21', '감면기간 종료연월일', mName, idNo));
      end;

      //C22 ⑬급여 9(11)
      //주(현)근무처 급여(비과세제외)
      //[C22]< 0 이면 오류
      if StrToFloat(C[22]) < 0 then errList.Add(errStr('C22', '급여', mName, idNo));

      //C23 ⑭상여 9(11)
      //주(현)근무처 상여(비과세제외)
      //[C23] < 0 이면 오류
      if StrToFloat(C[23]) < 0 then errList.Add(errStr('C23', '상여', mName, idNo));

      //C24 ⑮인정상여 9(11)
      //[C24] < 0 이면 오류
      if StrToFloat(C[24]) < 0 then errList.Add(errStr('C24', '인정상여', mName, idNo));

      //C25 ⑮-1주식매수 선택권행사이익 9(11)
      //[C25] < 0 이면 오류
      cHouseOptionAmt := 0;
      cHouseOptionAmt := StrToFloat(C[25]);
      if StrToFloat(C[25]) < 0 then errList.Add(errStr('C25', '주식매수 선택권행사이익', mName, idNo));

      //C26 ⑮-2 우리사주조합인출금 9(11)
      //[C26] < 0 이면 오류
      if StrToFloat(C[26]) < 0 then errList.Add(errStr('C26', '우리사주조합인출금', mName, idNo));

      //C27 ⑮-3 임원퇴직소득금액한도초과액 9(11)
      //[C27] < 0 이면 오류
      if StrToFloat(C[27]) < 0 then errList.Add(errStr('C27', '임원퇴직소득금액한도초과액', mName, idNo));

      //C28 공란 9(21)
      //숫자 0으로 21자리를 반드시 채움
      //'000000000000000000000' 아니면 오류
      if C[28] <> '000000000000000000000' then errList.Add(errStr('C28', '공란', mName, idNo));

      //C29 계 9(11)
      //1.[C29] < 0 이면 오류
      //2.[C29] ≠ [C22+C23+C24+C25+C26+C27]이면 오류
      cTempAmt := 0; cTotAmt := 0;
      cTotAmt := StrToFloat(C[29]);

      if cTotAmt < 0 then
        errList.Add(errStr('C29', '계', mName, idNo))
      else
      begin
        for j := 22 to 27 do
        begin
          cTempAmt := cTempAmt + StrToFloat(C[j]);
        end;

        if cTotAmt <> cTempAmt then
          errList.Add(errStr('C29', '계', mName, idNo));
      end;

      //************************************************************************【주(현)근무처 비과세소득 및 감면 소득】(18) ~ (20) -1
      //(1)각 비과세감면소득 항목별 금액을 기재
      //(2)월 한도가 있는 비과세소득은 근무월수를 기준으로 한도 체크(*근무월수 : 근무기간 시작연월 ~ 근무기간 종료연월 의 개월 수
      //【근무처별 소득명세 - 주(현)근무처】
      //Q. 선배님께 근무월수 구하는 부분 점검받기

      cTempWorkCnt := 0; cTempLimitAmt := 0;
      //cTempWorkCnt := MonthsBetween(convtDateType(C[18]), convtDateType(C[19])) + 1;
      //2017-01-01 ~ 2017-12-31 > 12개월 근무 > 12 - 1 + 2 > Max값인 13개월 설정
      //cTempWorkCnt는 근무월수 + 1을 진행
      cTempWorkCnt := MonthOf(convtDateType(C[19])) - MonthOf(convtDateType(C[18])) + 2;

      //C30 G01-비과세학자금 9(10)
      //[C30] < 0 이면 오류
      if StrToFloat(C[30]) < 0 then errList.Add(errStr('C30', 'G01-비과세학자금', mName, idNo));

      //C31 H01-무보수위원수당 9(10)
      //[C31] < 0 이면 오류
      if StrToFloat(C[31]) < 0 then errList.Add(errStr('C31', 'H01-무보수위원수당', mName, idNo));

      //C32 H05-경호/승선수당 9(10)
      //[C32] < 0 이면 오류
      if StrToFloat(C[32]) < 0 then errList.Add(errStr('C32', 'H05-경호/승선수당', mName, idNo));

      //C33 H06-유아/초중등 9(10)
      // -한도 : 월 20만원
      //1.[C33] < 0 이면 오류
      //2.[C33] > MIN(근무월수+1,12)×20만원 이면 오류
      //3.[C33] > MIN(근무월수,12)×20만원 일때 확인
      if cTempWorkCnt > 12 then cTempWorkCnt := 12;

      if getErrLimitAmt(StrToFloat(C[33]), 0, cTempWorkCnt, 200000) then
        errList.Add(errStr('C33', 'H06-유아/초중등', mName, idNo));

      //C34 H07-고등교육법 9(10)
      // -한도 : 월 20만원
      //1.[C34] < 0 이면 오류
      //2.[C34] > MIN(근무월수+1,12)×20만원 이면 오류
      //3.[C34] > MIN(근무월수,12)×20만원 일때 확인
      if getErrLimitAmt(StrToFloat(C[34]), 0, cTempWorkCnt, 200000) then
        errList.Add(errStr('C34', 'H07-고등교육법', mName, idNo));

      //C35 H08-특별법 9(10)
      // -한도 : 월 20만원
      //1.[C35] < 0 이면 오류
      //2.[C35] > MIN(근무월수+1,12)×20만원 이면 오류
      //3.[C35] > MIN(근무월수,12)×20만원 일때 확인
      if getErrLimitAmt(StrToFloat(C[35]), 0, cTempWorkCnt, 200000) then
        errList.Add(errStr('C35', 'H08-특별법', mName, idNo));

      //C36 H09-연구기관 등 9(10)
      // -한도 : 월 20만원
      //1.[C36] < 0 이면 오류
      //2.[C36] > MIN(근무월수+1,12)×20만원 이면 오류
      //3.[C36] > MIN(근무월수,12)×20만원 일때 확인
      if getErrLimitAmt(StrToFloat(C[36]), 0, cTempWorkCnt, 200000) then
        errList.Add(errStr('C36', 'H09-연구기관 등', mName, idNo));

      //C37 H10-기업부설연구소 9(10)
      //-한도 : 월 20만원
      //1.[C37] < 0 이면 오류
      //2.[C37] > MIN(근무월수+1,12)×20만원 이면 오류
      //3.[C37] > MIN(근무월수,12)×20만원 일때 확인
      if getErrLimitAmt(StrToFloat(C[37]), 0, cTempWorkCnt, 200000) then
        errList.Add(errStr('C37', 'H10-기업부설연구소', mName, idNo));

      //C38 H14-보육교사 근무환경개선비 9(10)
      //[C38] < 0이면 오류
      if StrToFloat(C[38]) < 0 then
        errList.Add(errStr('C38', 'H14-보육교사 근무환경개선비', mName, idNo));

      //C39 H15-사립유치원수석교사/교사의 인건비 9(10)
      //[C39] < 0이면 오류
      if StrToFloat(C[39]) < 0 then
        errList.Add(errStr('C39', 'H15-사립유치원수석교사/교사의 인건비', mName, idNo));

      //C40 H11-취재수당 9(10)
      // -한도 : 월 20만원
      //1.[C40] < 0 이면 오류
      //2.[C40] > MIN(근무월수+1,12)×20만원 이면 오류
      //3.[C40] > MIN(근무월수,12)×20만원 일때 확인
      if getErrLimitAmt(StrToFloat(C[40]), 0, cTempWorkCnt, 200000) then
        errList.Add(errStr('C40', 'H11-취재수당', mName, idNo));

      //C41 H12-벽지수당 9(10)
      // -한도 : 월 20만원
      //1.[C41] < 0 이면 오류
      //2.[C41] > MIN(근무월수+1,12)×20만원 이면 오류
      //3.[C41] > MIN(근무월수,12)×20만원 일때 확인
      if getErrLimitAmt(StrToFloat(C[41]), 0, cTempWorkCnt, 200000) then
        errList.Add(errStr('C41', 'H12-벽지수당', mName, idNo));

      //C42 H13-재해관련급여 9(10)
      //[C42] < 0이면 오류
      if StrToFloat(C[42]) < 0 then errList.Add(errStr('C42', 'H13-재해관련급여', mName, idNo));

      //C43 H16-정부/공공기관지방이전기관 종사자 이주수당 9(10)
      //[소득세법 시행령 제12조 17호]의 소득
      // -한도 : 월 20만원
      //1.[C43] < 0이면 오류
      //2.[C43] > MIN(근무월수+1,12)×20만원 이면 오류
      //3.[C43] > MIN(근무월수,12)×20만원 일때 확인
      if getErrLimitAmt(StrToFloat(C[43]), 0, cTempWorkCnt, 200000) then
        errList.Add(errStr('C43', 'H16-정부/공공기관지방이전기관 종사자 이주수당', mName, idNo));

      //C44 I01-외국정부등근무자 9(10)
      //[C44] < 0 이면 오류
      if StrToFloat(C[44]) < 0 then errList.Add(errStr('C44', 'I01-외국정부등근무자', mName, idNo));

      //C45 K01-외국주둔군인등 9(10)
      //[C45] < 0 이면 오류
      if StrToFloat(C[45]) < 0 then errList.Add(errStr('C45', 'K01-외국주둔군인등', mName, idNo));

      //C46 M01-국외근로100만원 9(10)
      // -한도: 월 100만원, 국외근로300만원(항목47)과 합하여 월300만원이내 금액
      //1.[C46] < 0 이면 오류
      //2.[C46] > MIN(근무월수+1,12)×100만원 이면 오류
      //3.[C46] > MIN(근무월수,12)×100만원 일때 확인
      if getErrLimitAmt(StrToFloat(C[46]), 0, cTempWorkCnt, 1000000) then
        errList.Add(errStr('C46', 'M01-국외근로100만원', mName, idNo));

      //C47 M02-국외근로300만원 9(10)
      //1.[C47] < 0 이면 오류
      //2.[C46+C47] > MIN(근무월수+1,12)×300만원 이면 오류
      //3.[C46+C47] > MIN(근무월수,12)×300만원 일때 확인
      if getErrLimitAmt(StrToFloat(C[47]), StrToFloat(C[46]), cTempWorkCnt, 3000000) then
        errList.Add(errStr('C47', 'M02-국외근로300만원', mName, idNo));

      //C48 M03-국외근로 9(10)447
      //[C48] < 0 이면 오류
      if StrToFloat(C[48]) < 0 then errList.Add(errStr('C48', 'M03-국외근로', mName, idNo));

      //C49 O01-야간근로수당 9(10)
      // -한도 : 연 240만원 ※광산근로자 및 일용 근로자의 경우 한도 없음
      //1.[C49] < 0 이면 오류
      //2.[C49] > 240만원 이면 오류(광산/일용 근로자가 아닌 경우)
      if getErrLimitAmt(StrToFloat(C[49]), 0, 1, 2400000) then
        errList.Add(errStr('C49', 'O01-야간근로수당', mName, idNo));

      //C50 Q01-출산보육수당 9(10)
      // -한도 : 월 10만원
      //1.[C50] < 0 이면 오류
      //2.[C50] > MIN(근무월수+1,12)×10만원 이면 오류
      //3.[C50] > MIN(근무월수,12)×10만원 일때 확인
      if getErrLimitAmt(StrToFloat(C[50]), 0, cTempWorkCnt, 100000) then
        errList.Add(errStr('C50', 'Q01-출산보육수당', mName, idNo));

      //C51 R10-근로장학금 9(10)
      //[C51] < 0 이면 오류
      if StrToFloat(C[51]) < 0 then errList.Add(errStr('C51', 'R10-근로장학금', mName, idNo));

      //C52 R11-직무발명보상금 9(10)
      //1.[C52] < 0 이면 오류
      //2.[C52] > 300만원 이면 오류
      if getErrLimitAmt(StrToFloat(C[52]), 0, 1, 3000000) then
        errList.Add(errStr('C52', 'R11-직무발명보상금', mName, idNo));

      //C53 S01-주식매수선택권 9(10)
      // -한도 : 연 3,000만원
      //1.[C53] < 0 이면 오류
      //2.[C53] > 3,000만원 이면 오류
      if getErrLimitAmt(StrToFloat(C[53]), 0, 1, 30000000) then
        errList.Add(errStr('C53', 'S01-주식매수선택권', mName, idNo));

      //C54 T01-외국인기술자 9(10)
      // -한도 : 국내에서 내국인에게 근로를 제공하여 받은 근로소득에 대한 소득세 50%
      //1.[C54] < 0 이면 오류
      //2.외국인 단일세율 적용([C11]=‘9’, [C9]=‘1’)인 경우:[C54] ≠ 0이면 오류
      //3.감면기간 ([C20],[C21])이 기재되어 있지 않은데 [C54] ≠ 0이면 오류
      //N 4.세액감면(조특법)이 있는데([C115]>0) :[C54] + [모든 종(전) [D47]의 합]=0 이면 오류
      //5.산출세액([C113])>0이고,[C115]=0 일때:[C54] ≠ 0 이면 오류
      cT01Amt := 0;
      cT01Amt := StrToFloat(C[54]);

      if StrToFloat(C[54]) < 0 then
        errList.Add(errStr('C54', 'T01-외국인기술자', mName, idNo))
      else if getErrYn('2', StrToFloat(C[54]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C54', 'T01-외국인기술자', mName, idNo))
      else if ((C[20] = '00000000') or (C[21] = '00000000')) and (StrToFloat(C[54]) <> 0) then
        errList.Add(errStr('C54', 'T01-외국인기술자', mName, idNo))
      else if (StrToFloat(C[113]) > 0) and (StrToFloat(C[115]) = 0) and (StrToFloat(C[54]) <> 0 ) then
        errList.Add(errStr('C54', 'T01-외국인기술자', mName, idNo));

      //C55 Y02-우리사주조합인출금50% 9(10)
      //[C55] < 0 이면 오류
      if getErrYn('1', StrToFloat(C[55])) then
        errList.Add(errStr('C55', 'Y02-우리사주조합인출금50%', mName, idNo));

      //C56 Y03-우리사주조합인출금75% 9(10)
      //[C56] < 0 이면 오류
      if getErrYn('1', strToFloat(Copy(C[56], 1, 10))) then
        errList.Add(errStr('C56', 'Y03-우리사주조합인출금75%', mName, idNo));

      //C56 Y04-우리사주조합인출금100% 9(10)
      //[C56ⓐ] < 0 이면 오류
      if getErrYn('1', strToFloat(Copy(C[56], 11, 10))) then
        errList.Add(errStr('C56', 'Y04-우리사주조합인출금100%', mName, idNo));

      //C57 Y22-전공의 수련 보조 수당 9(10)
      //[C57] < 0 이면 오류
      if getErrYn('1', StrToFloat(C[57])) then
        errList.Add(errStr('C57', 'Y22-전공의 수련 보조 수당', mName, idNo));

      //C58 T10-중소기업취업청년 소득세 감면100% 9(10)
      //1.[C58] < 0 이면 오류
      //2.외국인 단일세율 적용([C11]=‘9’, [C9]=‘1’) 인 경우:[C58] ≠ 0 이면 오류
      //3.감면기간([C20], [C21])이 기재되어 있지 않을때:[C58] ≠ 0이면 오류
      cT10Amt := strToFloat(Copy(C[58], 1, 10));

      if strToFloat(Copy(C[58], 1, 10)) < 0 then
        errList.Add(errStr('C58', 'T10-중소기업취업청년 소득세 감면100%', mName, idNo))
      else if getErrYn('2', strToFloat(Copy(C[58], 1, 10)), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C58', 'T10-중소기업취업청년 소득세 감면100%', mName, idNo))
      else if ((C[20] = '00000000') or (C[21] = '00000000')) and (strToFloat(Copy(C[58], 1, 10)) <> 0) then
        errList.Add(errStr('C58', 'T10-중소기업취업청년 소득세 감면100%', mName, idNo));

      //C58(a) T11-중소기업취업청년 소득세 감면50% 9(10)
      //1.[C58ⓐ] < 0 이면 오류
      //2.외국인 단일세율 적용([C11]=‘9’, [C9]=‘1’) 인 경우:[C58ⓐ] ≠ 0 이면 오류
      //3.감면기간([C20], [C21])이 기재되어 있지 않을때:[C58ⓐ] ≠ 0이면 오류
      cT11Amt := strToFloat(Copy(C[58], 11, 10));

      if strToFloat(Copy(C[58], 11, 10)) < 0 then
        errList.Add(errStr('C58(a)', 'T11-중소기업취업청년 소득세 감면50%', mName, idNo))
      else if getErrYn('2', strToFloat(Copy(C[58], 11, 10)), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C58(a)', 'T11-중소기업취업청년 소득세 감면50%', mName, idNo))
      else if ((C[20] = '00000000') or (C[21] = '00000000')) and (strToFloat(Copy(C[58], 11, 10)) <> 0) then
        errList.Add(errStr('C58(a)', 'T11-중소기업취업청년 소득세 감면50%', mName, idNo));

      //C58(b) T12-중소기업취업청년 소득세 감면70% 9(10)
      //1.[C58ⓑ] < 0 이면 오류
      //2.외국인 단일세율 적용([C11]=‘9’, [C9]=‘1’) 인 경우:[C58ⓑ] ≠ 0 이면 오류
      //3.감면기간([C20], [C21])이 기재되어 있지 않을때:[C58ⓑ] ≠ 0이면 오류
      cT12Amt := strToFloat(Copy(C[58], 21, 10));

      if strToFloat(Copy(C[58], 21, 10)) < 0 then
        errList.Add(errStr('C58(b)', 'T12-중소기업취업청년 소득세 감면70%', mName, idNo))
      else if getErrYn('2', strToFloat(Copy(C[58], 21, 10)), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C58(b)', 'T12-중소기업취업청년 소득세 감면70%', mName, idNo))
      else if ((C[20] = '00000000') or (C[21] = '00000000')) and (strToFloat(Copy(C[58], 21, 10)) <> 0) then
        errList.Add(errStr('C58(b)', 'T12-중소기업취업청년 소득세 감면70%', mName, idNo));

      //C59 T20-조세조약상 교직자감면 9(10)
      //1.[C59] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’인 경우: [C59] ≠ 0 이면 오류
      //3.내국인([C11]='1')인데 : [C59] ≠ 0 이면 오류
      //4.[C20], [C21]이 기재되어 있지 않을때 :[C59] ≠ 0이면 오류
      //N 5.세액감면(조세조약)이 있는데([C117]>0) :[C59] + [모든 종(전)의 [D52]의 합] = 0 이면 오류
      //6.[C113] > 0이고 [C117]=0 일때 : [C59] ≠ 0이면 오류
      cT20Amt := 0;
      cT20Amt := StrToFloat(C[59]);
      if StrToFloat(C[59]) < 0 then
        errList.Add(errStr('C59', 'T20-조세조약상 교직자감면', mName, idNo))
      else if getErrYn('2', StrToFloat(C[59]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C59', 'T20-조세조약상 교직자감면', mName, idNo))
      else
      begin
        //StrToFloat(C[59]) <> 0 공통조건
        if StrToFloat(C[59]) <> 0 then
        begin
          if cForeignAb = '1' then
          begin
            errList.Add(errStr('C59', 'T20-조세조약상 교직자감면', mName, idNo));
          end
          else if (C[20] = '00000000') and (C[21] = '00000000') then
          begin
            errList.Add(errStr('C59', 'T20-조세조약상 교직자감면', mName, idNo));
          end
          else if (StrToFloat(C[113]) > 0) and (StrToFloat(C[117]) = 0) then
          begin
            errList.Add(errStr('C59', 'T20-조세조약상 교직자감면', mName, idNo));
          end;
        end;
      end;

      //C60 비과세 계 9(10)
      //[항목30+∼+항목52]+[항목54+∼+항목57]
      //1.[C60] < 0 이면 오류
      //2.[C60]≠[C30+∼+C53]+[C55+∼+C57] 이면 오류
      cNonTaxSumAmt := 0; cTempAmt := 0;
      cNonTaxSumAmt := StrToFloat(C[60]);

      if StrToFloat(C[60]) < 0 then
        errList.Add(errStr('C60', '비과세 계', mName, idNo))
      else
      begin
        for j := 30 to 57 do
        begin
          if j = 54 then
            Continue
          else if j = 56 then
            cTempAmt := cTempAmt + strToFloat(Copy(C[56], 1, 10)) + strToFloat(Copy(C[56], 11, 10))
          else
            cTempAmt := cTempAmt + StrToFloat(C[j]);
        end;

        if StrToFloat(C[60]) <> cTempAmt then
          errList.Add(errStr('C60', '비과세 계', mName, idNo));
      end;

      //C61 감면소득 계 9(10)
      //[항목53+항목58+항목59]
      //1.[C61] < 0 이면 오류
      //2.[C61]≠[C54+C58+C58ⓐ+C58ⓑ+C59]이면오류
      //3.[C61] > [C63] 이면 오류
      cTempAmt := 0;
      if StrToFloat(C[61]) < 0 then
        errList.Add(errStr('C61', '감면소득 계', mName, idNo))
      else
      begin
        cTempAmt := StrToFloat(C[54])
                + StrToFloat(Copy(C[58], 1, 10))
                + StrToFloat(Copy(C[58], 11, 10))
                + StrToFloat(Copy(C[58], 21, 10))
                + StrToFloat(C[59]);

        if StrToFloat(C[61]) <> cTempAmt then
          errList.Add(errStr('C61', '감면소득 계', mName, idNo))
        else if StrToFloat(C[61]) > StrToFloat(C[63]) then
          errList.Add(errStr('C61', '감면소득 계', mName, idNo));

      end;

      //************************************************************************【정산명세】
      //C63 총급여 9(11)
      //N 1.총급여 < 0 이면 오류
      //N 2.외국인 단일세율([C11]=‘9’, [C9]=‘1’)인 경우:[C63] < [C29+C60]+[모든 종(전)의 [D22+D53]의 합] 이면 오류
      //N 3.외국인 단일세율적용이 아닌 경우 :[C63] ≠ [C29] + [모든 종(전) [D22]의 합]이면 오류
      cTotSalaryAmt := 0;
      cTotSalaryAmt := StrToFloat(C[63]);
      cSumTotSalaryAmt := cSumTotSalaryAmt + StrToFloat(C[63]);

//form1.Memo5.Lines.Add(mName + ' ▶ '+ C[63] + #13);

      //C64 근로소득공제 9(10)
      //1.[C64] < 0 이면 오류
      //2.외국인단일세율 적용([C11]=‘9’, [C9]=‘1’)인 경우 :[C64] ≠ ‘0’ 이면 오류
      //3.[C64] ≠ (총급여 구간별 근로소득공제 금액) 이면 오류

      if StrToFloat(C[64]) < 0 then
        errList.Add(errStr('C64', '근로소득공제', mName, idNo))
      else if getErrYn('2', StrToFloat(C[64]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C64', '근로소득공제', mName, idNo))
      else
      begin
        //3.
        tempArr := getTaxBase('5', StrToFloat(C[63]), '2017');
        {----------------------------------------------------------------------
        hr_over	      hr_less	        hr_standard_value	  hr_max_value

         - 	          5,000,000	      70%	                - 	                총급여액의 70%
        5,000,000	    15,000,000	    40%	                3,500,000 	        350만원 + (500만원 초과분*40%)
        15,000,000	  45,000,000	    15%	                7,500,000 	        750만원 + (1500만원 초과분*15%)
        45,000,000	  100,000,000	    5%	                12,000,000 	        1200만원 + (4500만원 초과분*5%)
        100,000,000			              2%	                14,750,000 	        1475만원 + (1억원 초과분*2%)
        ----------------------------------------------------------------------
        tempArr[0] 'hr_over'
        tempArr[1] 'hr_less'
        tempArr[2] 'hr_standard_value'
        tempArr[3] 'hr_max_value'}

        cTempAmt := Floor(tempArr[3] + (StrToFloat(C[63]) - tempArr[0]) * tempArr[2] * 0.01);
        if Abs(StrToFloat(C[64]) - cTempAmt) > 100  then
          errList.Add(errStr('C64', '근로소득공제', mName, idNo));

      end;

form1.Memo1.Lines.Add('C64');
      //C65 근로소득금액 9(11)
      //총급여 - 근로소득공제
      //1.[C65] < 0 이면 오류
      //2.[C65] ≠ [C63] - [C64] 이면 오류
      if StrToFloat(C[65]) < 0 then
        errList.Add(errStr('C65', '근로소득금액', mName, idNo))
      else if StrToFloat(C[65]) <> StrToFloat(C[63]) - StrToFloat(C[64]) then
        errList.Add(errStr('C65', '근로소득금액', mName, idNo));

form1.Memo1.Lines.Add('C65');
      //************************************************************************【기본공제】
      //C66 본인공제금액 9(8)
      //공제한도 : 150만원
      //1.[C66] < 0 또는 [C66] > 150만원이면 오류
      //2.[C11]=‘9’, [C9]=‘1’인 경우 : [C66] ≠ 0 이면 오류
      cTempLimitAmt := 1500000;

      if (StrToFloat(C[66]) < 0) or (StrToFloat(C[66]) > cTempLimitAmt) then
        errList.Add(errStr('C66', '본인공제금액', mName, idNo))
      else if getErrYn('2', StrToFloat(C[66]), cForeignAb, cForeignTaxYn) then
          errList.Add(errStr('C66', '본인공제금액', mName, idNo));

 form1.Memo1.Lines.Add('C66');
      //C67 배우자공제금액 9(8)
      //연간소득금액 100만원이하인 배우자
      // -공제한도 : 150만원
      //1.[C67] < 0 또는 [C67] > 150만원이면 오류
      //2.[C11]=‘9’, [C9]=‘1’인 경우 : [C67] ≠ 0 이면 오류
      //3.비거주자([C7]=‘2’)인 경우 : [C67] ≠ 0 이면 오류
      //N 4.[C67] > 0 인 경우 : 배우자 인원수*) ≠ 1 이면 오류
      //N *배우자 인원수: 소득공제명세(E레코드)에서 관계(E7) 배우자(관계코드:3)이고 기본공제(E11)가 ‘여(1)’인 인원수
      cHouseHolderAmt := 0; cTempLimitAmt := 1500000;
      cHouseHolderAmt := StrToFloat(C[67]);
      if (StrToFloat(C[67]) < 0) or (StrToFloat(C[67]) > cTempLimitAmt) then
        errList.Add(errStr('C67', '배우자공제금액', mName, idNo))
      else if getErrYn('2', StrToFloat(C[67]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C67', '배우자공제금액', mName, idNo))
      else if getErrYn('3', StrToFloat(C[67]), C[7]) then
        errList.Add(errStr('C67', '배우자공제금액', mName, idNo));

form1.Memo1.Lines.Add('C67');
      //C68 부양가족공제인원 9(2)
      //1.[C11]=‘9’, [C9]=‘1’인 경우: [C68] ≠ 0 이면 오류
      //2.[C7]=‘2’ 인 경우: [C68] ≠ 0 이면 오류
      //N 3.[C7]=‘1’ 인 경우: [C68] ≠ 공제인원수*) 이고 [C69] ≠ 0 이면 오류
      //N *공제인원수: 소득공제명세(E레코드)에서 본인(관계코드:0), 배우자(관계코드:3)를 제외한 기본공제가 ‘여(1)’인 인원수
      cLinealCnt := 0; cLinealAmt := 0;
      cLinealCnt := StrToInt(C[68]);
      cLinealAmt := StrToFloat(C[69]);

      if getErrYn('2', StrToInt(C[68]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C68', '부양가족공제인원', mName, idNo))
      else if getErrYn('3', StrToInt(C[68]), C[7]) then
        errList.Add(errStr('C68', '부양가족공제인원', mName, idNo));

form1.Memo1.Lines.Add('C68');
      //C69 부양가족공제금액 9(8)
      //1.[C69] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’인 경우 : [C69] ≠ 0 이면 오류
      //3.[C7]=‘2’인 경우 : [C69] ≠ 0 이면 오류
      //4.[C69] > [C68] × 150만원 이면 오류
      //5.[C68] = 0 일때 : [C69] ≠ 0이면 오류
      cTempAmt := 1500000 * StrToInt(C[68]);

      if StrToFloat(C[69]) < 0 then
        errList.Add(errStr('C69', '부양가족공제금액', mName, idNo))
      else if getErrYn('2', StrToFloat(C[69]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C69', '부양가족공제금액', mName, idNo))
      else if getErrYn('3', StrToFloat(C[69]), C[7]) then
        errList.Add(errStr('C69', '부양가족공제금액', mName, idNo))
      else if StrToFloat(C[69]) > cTempAmt then
        errList.Add(errStr('C69', '부양가족공제금액', mName, idNo))
      else if (StrToInt(C[68]) = 0) and (StrToFloat(C[69]) <> 0) then
        errList.Add(errStr('C69', '부양가족공제금액', mName, idNo));

form1.Memo1.Lines.Add('C69');
      //************************************************************************【추가공제】
      //C70 경로우대공제인원 9(2)
      //1.외국인 단일세율 적용([C11]=‘9’, [C9]=‘1’)인 경우:[C70] ≠ 0 이면 오류
      //N 2.[C7]=‘1’ 인  경우: [C70] ≠ 경로공제인원수*) 이고 [C71] ≠ 0 이면 오류
      //N *경로공제인원수: 소득공제명세(E레코드)에서 기본공제가 ‘여(1)’ 이고 경로우대공제가 ‘여(1)’인 인원수
      //N 3.비거주자([C7]=‘2’)인 경우 : (본인 1명만 공제 가능)
      //N -소득자 본인이 경로우대공제대상인 경우*): [C70] ≠ 1 이면 오류
      //N *소득자 본인이 경로우대공제 대상인 경우:
      //N 소득공제명세(E레코드)에서 본인(관계코드:0)이 기본공제가 ‘여(1)’, 경로우대공제가 ‘여(1)’인 경우
      //N -그 외의 경우 : [C70] ≠ 0이면 오류
      cSeniorCnt := 0; cSeniorAmt := 0;
      cSeniorCnt := StrToInt(C[70]);
      cSeniorAmt := StrToFloat(C[71]);

      if getErrYn('2', StrToInt(C[70]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C71', '경로우대공제금액', mName, idNo));

form1.Memo1.Lines.Add('C70');
      //C71 경로우대공제금액 9(8)
      //1.[C71] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’인 경우 0이 아니면 오류
      //3.[C71] > [C70] × 100만원 이면 오류
      cTempAmt := StrToInt(C[70]) * 1000000;
      if StrToFloat(C[71]) < 0 then
        errList.Add(errStr('C71', '경로우대공제금액', mName, idNo))
      else if getErrYn('2', StrToInt(C[71]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C71', '경로우대공제금액', mName, idNo))
      else if StrToFloat(C[71]) > cTempAmt then
        errList.Add(errStr('C71', '경로우대공제금액', mName, idNo));

form1.Memo1.Lines.Add('C71');
      //C72 장애인공제인원 9(2)
      //1.[C11]=‘9’, [C9]=‘1’인 경우 0이 아니면 오류
      //N 2.[C7]=‘1’인 경우: [C72] ≠ 장애인공제인원수*) 이고 [C73] ≠ 0 이면 오류
      //N *장애인공제인원수: 소득공제명세(E레코드)에서 기본공제가 ‘여(1)’ 이고 장애인공제가 (‘1’,‘2’,‘3’)인 인원수
      //N 3.[C7]=‘2’인 경우: (본인 1명만 공제 가능)
      //N -소득자 본인이 장애인공제대상인 경우*): [C72] ≠ 1 이면 오류
      //N *소득자 본인이 장애인공제 대상인 경우: 소득공제명세(E레코드)에서
      //N 본인(관계코드:0)이 기본공제가 ‘여(1)’, 장애인공제가 (‘1’,‘2’,‘3’)인 경우
      //N -그 외의 경우 : [C72] ≠ 0이면 오류
      cDisabledCnt := 0; cDisabledAmt := 0;
      cDisabledCnt := strToInt(C[72]);
      cDisabledAmt := strToFloat(C[73]);

      if getErrYn('2', strToInt(C[72]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C72', '장애인공제인원', mName, idNo));

form1.Memo1.Lines.Add('C72');
      //C73 장애인공제금액 9(8)
      //200만원 × 장애인공제인원
      //1.[C73] < 0 이면 오류
      //2.외국인 단일세율 적용([C11]=‘9’, [C9]=‘1’)인 경우:[C73] ≠ 0 이면 오류
      //3.[C73] > [C72] × 200만원 이면 오류
      cTempAmt := StrToFloat(C[72]) * 2000000;

      if strToFloat(C[73]) < 0 then
        errList.Add(errStr('C73', '장애인공제금액', mName, idNo))
      else if getErrYn('2', strToFloat(C[73]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C73', '장애인공제금액', mName, idNo))
      else if strToFloat(C[73]) > cTempAmt then
        errList.Add(errStr('C73', '장애인공제금액', mName, idNo));

form1.Memo1.Lines.Add('C73');
      //C74 부녀자공제금액 9(8)
      //1.[C74] < 0 또는 [C74] > 50만원 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’인 경우: [C74] ≠ 0 이면 오류
      //3.소득자가 남성 일때: [C74] ≠ 0 이면 오류
      //4.[C74] > 0인 경우:
      //N -소득공제명세(E레코드)에 본인(관계코드:0)이 부녀자공제 ‘여’(1)가 아니면 오류
      // -[C75] ≠ 0이면 오류
      // -[C65] > 3,000만원 이면 오류
      cLadyAmt := 0;
      cLadyAmt := strToFloat(C[74]);
      //cTempLimitAmt := 500000;

      if (strToFloat(C[74]) < 0) or (strToFloat(C[74]) > 500000) then
        errList.Add(errStr('C74', '부녀자공제금액', mName, idNo))
      else if getErrYn('2', strToFloat(C[74]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C74', '부녀자공제금액', mName, idNo))
      else if (Pos(Copy(idNo, 7, 1), '[1][3][5][7][9]') > 0) and (strToFloat(C[74]) <> 0) then
        errList.Add(errStr('C74', '부녀자공제금액', mName, idNo))
      else if strToFloat(C[74]) > 0 then
      begin
        if (strToFloat(C[75]) <> 0) or (StrToFloat(C[65]) > 30000000) then
          errList.Add(errStr('C74', '부녀자공제금액', mName, idNo))
      end;

form1.Memo1.Lines.Add('C74');
      //C75 한부모가족공제금액 9(10)
      //1.[C75] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’인 경우: [C75] ≠ 0이 아니면 오류
      //3.비거주자([C7]=‘2’)인 경우: [C75] ≠ 0이 아니면 오류
      //4.[C75] > 100만원 이면 오류
      //N 5.[C75] > 0인 경우: 소득공제명세(E레코드)에
      //N - 기본공제가 ‘여’(1)인 배우자(관계코드:3)가 있는 경우 오류
      //N - 기본공제가 ‘여’아닌 배우자가 있는 경우 확인
      //N - 본인(관계코드:0)의 한부모가족공제가 ‘여’(1) 아니면 오류
      //N - 기본공제가 ‘여’(1)인 직계비속(관계코드:4,5)이 없으면 오류}
      cSingleParentAmt := 0;
      cSingleParentAmt := strToFloat(C[75]);
      if strToFloat(C[75]) < 0 then
        errList.Add(errStr('C75', '한부모가족공제금액', mName, idNo))
      else if getErrYn('2', strToFloat(C[75]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C75', '한부모가족공제금액', mName, idNo))
      else if getErrYn('3', strToFloat(C[75]), C[7]) then
        errList.Add(errStr('C75', '한부모가족공제금액', mName, idNo))
      else if strToFloat(C[75]) > 1000000 then
        errList.Add(errStr('C75', '한부모가족공제금액', mName, idNo));

form1.Memo1.Lines.Add('C75');
      //************************************************************************【연금보험료공제】
      //C76 국민연금보험료공제 9(10)
      //1.[C76] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’인 경우: [C76] ≠ 0 이면 오류
      if getErrYn('1', strToFloat(C[76])) then
        errList.Add(errStr('C76', '국민연금보험료공제', mName, idNo))
      else if getErrYn('2', strToFloat(C[76]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C76', '국민연금보험료공제', mName, idNo));
form1.Memo1.Lines.Add('C76');

      //C77 -㉮공적연금보험료공제_공무원연금 9(10)
      //1.[C77] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’인 경우: [C77] ≠ 0 이면 오류
      if getErrYn('1', strToFloat(C[77])) then
        errList.Add(errStr('C77', '㉮공적연금보험료공제_공무원연금', mName, idNo))
      else if getErrYn('2', strToFloat(C[77]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C77', '㉮공적연금보험료공제_공무원연금', mName, idNo));

form1.Memo1.Lines.Add('C77');

      //C78 -㉯공적연금보험료공제_군인연금 9(10)
      //1.[C78] < 0이면 오류
      //2.[C11]=‘9’, [C9]=‘1’인 경우: [C78] ≠ 0 이면 오류
      if getErrYn('1', strToFloat(C[78])) then
        errList.Add(errStr('C78', '㉯공적연금보험료공제_군인연금', mName, idNo))
      else if getErrYn('2', strToFloat(C[78]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C78', '㉯공적연금보험료공제_군인연금', mName, idNo));
form1.Memo1.Lines.Add('C78');

      //C79 -㉰공적연금보험료공제_사립학교교직원연금 9(10)
      //1.[C79] < 0이면 오류
      //2.외국인 단일세율 적용([C11]=‘9’, [C9]=‘1’)인 경우:[C79] ≠ 0 이면 오류
      if getErrYn('1', strToFloat(C[79])) then
        errList.Add(errStr('C79', '㉰공적연금보험료공제_사립학교교직원연금', mName, idNo))
      else if getErrYn('2', strToFloat(C[79]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C79', '㉰공적연금보험료공제_사립학교교직원연금', mName, idNo));

form1.Memo1.Lines.Add('C79');

      //C80 -㉱공적연금보험료공제_별정우체국연금 9(10)
      //1.[C80] < 0이면 오류
      //2.[C11]=‘9’, [C9]=‘1’인 경우: [C80] ≠ 0 이면 오류
      if strToFloat(C[80]) < 0 then
        errList.Add(errStr('C80', '㉱공적연금보험료공제_별정우체국연금', mName, idNo))
      else if getErrYn('2', strToFloat(C[80]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C80', '㉱공적연금보험료공제_별정우체국연금', mName, idNo));

form1.Memo1.Lines.Add('C80');
      //************************************************************************【특별소득공제】
      //C81 -㉮보험료-건강보험료(노인장기요양보험료 포함) 9(10)
      //1.[C81] < 0이면 오류
      //2.[C11]=‘9’, [C9]=‘1’인 경우: [C81] ≠ 0 이면 오류
      //3.비거주자([C7]=‘2’)인 경우: [C81] ≠ 0 이면 오류
      //N 4.[C81+C82]>[소득공제명세(E레코드)의 건강·고용 보험료 합계]이면 오류
      cNhisAmt := 0;
      cNhisAmt := strToFloat(C[81]);
      if strToFloat(C[81]) < 0 then
        errList.Add(errStr('C81', '㉮보험료-건강보험료(노인장기요양보험료 포함)-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[81]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C81', '㉮보험료-건강보험료(노인장기요양보험료 포함)-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[81]), C[7]) then
        errList.Add(errStr('C81', '㉮보험료-건강보험료(노인장기요양보험료 포함)-3', mName, idNo));

form1.Memo1.Lines.Add('C81');
      //C82 -㉯보험료-고용보험료 9(10)
      //1.[C82] < 0이면 오류
      //2.[C11]=‘9’, [C9]=‘1’인 경우: [C82] ≠ 0 이면 오류
      //3.비거주자([C7]=‘2’)인 경우: [C82] ≠ 0 이면 오류
      //N 4.[C81+C82]>[소득공제명세(E레코드)의 건강·고용 보험료 합계]이면 오류
      cEiAmt := 0;
      cEiAmt := strToFloat(C[82]);

      if strToFloat(C[82]) < 0 then
        errList.Add(errStr('C82', '㉯보험료-고용보험료-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[82]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C82', '㉯보험료-고용보험료-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[82]), C[7]) then
        errList.Add(errStr('C82', '㉯보험료-고용보험료-3', mName, idNo));

form1.Memo1.Lines.Add('C82');
      //************************************************************************[주택자금(주택임차차입금,장기주택저당차입금, 주택마련저축) 관련 공통 사항]
      //C83 -㉮주택자금_주택임차차입금원리금상환액_ 대출기관 9(8)
      //1.[C83] < 0 이면 오류
      //4.[C154] > 0 인 경우: [C83] ≠ 0 이면 오류
      //5.[C83+C84]+[C100+C101+C102] > 300만원 이면 오류
      cTempAmt := strToFloat(C[83])+ strToFloat(C[84]) + strToFloat(C[100]) + strToFloat(C[101]) + strToFloat(C[102]);

      if strToFloat(C[83]) < 0 then
        errList.Add(errStr('C83', '㉮주택자금_주택임차차입금원리금상환액_ 대출기관', mName, idNo))
      else if (strToFloat(C[154]) > 0) and (strToFloat(C[83]) <> 0) then
        errList.Add(errStr('C83', '㉮주택자금_주택임차차입금원리금상환액_ 대출기관', mName, idNo))
      else if cTempAmt > 3000000 then
        errList.Add(errStr('C83', '㉮주택자금_주택임차차입금원리금상환액_ 대출기관', mName, idNo));

form1.Memo1.Lines.Add('C83');
      //C84 -㉮주택자금_주택임차차입금원리금상환액_거주자 9(8)
      //1.[C84] < 0 이면 오류
      //2.[C63] > 5,000만원 일때: [C84] ≠ 0 이면 오류
      //3.[C154] > 0 인 경우    : [C84] ≠ 0 이면 오류
      //4.[C83+C84]+[C100+C101+C102] > 300만원 이면 오류
      //N 5.[C84] > [월세 거주자주택임차차입금소득명세(G레코드)의 주택임차차입금원리금상환액_거주자 공제금액 합계] 이면 오류
      cRentRepayAmt2 := 0;
      cRentRepayAmt2 := strToFloat(C[84]);

      if strToFloat(C[84]) < 0 then
        errList.Add(errStr('C84', '㉮주택자금_주택임차차입금원리금상환액_거주자', mName, idNo))
      else if (StrToFloat(C[63]) > 50000000) and (strToFloat(C[84]) <> 0) then
        errList.Add(errStr('C84', '㉮주택자금_주택임차차입금원리금상환액_거주자', mName, idNo))
      else if (strToFloat(C[154]) > 0) and (strToFloat(C[84]) <> 0) then
        errList.Add(errStr('C84', '㉮주택자금_주택임차차입금원리금상환액_거주자', mName, idNo))
      else if cTempAmt > 3000000 then
        errList.Add(errStr('C84', '㉮주택자금_주택임차차입금원리금상환액_거주자', mName, idNo));

form1.Memo1.Lines.Add('C84');
      //C85 -㉯(2011년 이전 차입분)주택자금_장기주택저당차입금이자상환액_15년미만 9(8)
      //공제한도: 600만원
      //1.[C85] < 0 이면 오류
      //오류기준 변경(2018.01.11) ▶2.[C85] > 0 일 때: C85>600만원 이면 오류
      if getErrLimitAmt(strToFloat(C[85]), 0, 1, 6000000) then
        errList.Add(errStr('C85', '㉯(2011년 이전 차입분)주택자금_장기주택저당차입금이자상환액_15년미만', mName, idNo));

form1.Memo1.Lines.Add('C85');

      //C86 -㉯(2011년 이전 차입분) 주택자금_장기주택저당차입금이자상환액_15년~29년 9(8)
      //공제한도: 1,000만원
      //1.[C86] < 0 이면 오류
      //오류기준 변경(2018.01.11) ▶2.[C86] > 0 일 때: C86 > 1,000만원 이면 오류

      if getErrLimitAmt(strToFloat(C[86]), 0, 1, 10000000) then
        errList.Add(errStr('C86', '㉯(2011년 이전 차입분) 주택자금_장기주택저당차입금이자상환액_15년~29년', mName, idNo));
form1.Memo1.Lines.Add('C86');
      //C87 -㉯(2011년 이전 차입분)주택자금_장기주택저당차입금이자상환액_30년이상 9(8)
      //공제한도: 1,500만원
      //1.[C87] < 0이면 오류
      //오류기준 변경(2018.01.11) ▶2.[C87] > 0 일 때: C87>1,500만원 이면 오류
      //3.종합한도*) 확인([C87] = 0일 때에도 확인):
      // [C83+～+C87+C100+C101+C102] > 종합한도*) 이면 오류
      //*종합한도: C85, C86, C87중금액이 있는 항목의 공제한도 금액 중 최고값

      if strToFloat(C[87]) < 0 then
        errList.Add(errStr('C87', '㉯(2011년 이전 차입분)주택자금_장기주택저당차입금이자상환액_30년이상', mName, idNo))
      else if strToFloat(C[87]) > 15000000 then
          errList.Add(errStr('C87', '㉯(2011년 이전 차입분)주택자금_장기주택저당차입금이자상환액_30년이상', mName, idNo))
      else
      begin
        if strToFloat(C[85]) + strToFloat(C[86]) + strToFloat(C[87]) > 0 then
        begin
          if cTempAmt0 > totalLimitAmt(strToFloat(C[85]), strToFloat(C[86]), strToFloat(C[87])
                                      , 0, 0, 0
                                      , 0, 0, 0) then
            errList.Add(errStr('C87', '㉯(2011년 이전 차입분)주택자금_장기주택저당차입금이자상환액_30년이상', mName, idNo));
        end;
      end;

form1.Memo1.Lines.Add('C87');

      //C88 -㉯(2012년 이후 차입분, 15년 이상)고정금리/비거치식 상환 대출 9(8)
      //공제한도: 1,500만원
      //1.[C88] < 0 이면 오류
      //오류기준 변경(2018.01.11) ▶2.[C88] > 0 일 때: C88 > 1,500만원 이면 오류

      if getErrLimitAmt(strToFloat(C[88]), 0, 1, 15000000) then
        errList.Add(errStr('C88', '㉯(2012년 이후 차입분, 15년 이상)고정금리/비거치식 상환 대출', mName, idNo));
form1.Memo1.Lines.Add('C88');

      //C89 -㉯(2012년 이후 차입분, 15년 이상)기타 대출 9(8)
      //공제한도: 500만원
      //1.[C89] < 0이면 오류
      //오류기준 변경(2018.01.11) ▶2.[C89] > 0 일 때: C89 > 500만원 이면 오류
      //4.종합한도*) 확인(C89 = 0일 때에도 확인):[C83+∼+C89+C100+C101+C102] > 종합한도*) 이면 오류
      //*종합한도: C85,C86,C87,C88,C89중금액이 있는 항목의 공제한도 금액 중 최고값
      cTempAmt0 := cTempAmt + strToFloat(C[89]);

      if strToFloat(C[89]) < 0 then
        errList.Add(errStr('C89', '㉯(2012년 이후 차입분, 15년 이상)기타 대출-1', mName, idNo))
      else if strToFloat(C[89]) > 5000000 then
        errList.Add(errStr('C89', '㉯(2012년 이후 차입분, 15년 이상)기타 대출-2', mName, idNo))
      else
      begin
        if strToFloat(C[85]) + strToFloat(C[86]) + strToFloat(C[87]) + strToFloat(C[88]) + strToFloat(C[89]) > 0 then
        begin
          if cTempAmt0 > totalLimitAmt(strToFloat(C[85]), strToFloat(C[86]), strToFloat(C[87])
                                    , strToFloat(C[88]), strToFloat(C[89]), 0, 0, 0, 0) then
            errList.Add(errStr('C89', '㉯(2012년 이후 차입분, 15년 이상)기타 대출-3', mName, idNo));
        end;
      end;

form1.Memo1.Lines.Add('C89');
      //C90 -㉯(2015년 이후 차입분, 상환기간 15년 이상)고정금리 and 비거치상환 대출 9(8)
      //공제한도: 1,800만원
      //1.[C90] < 0이면 오류
      //오류기준 변경(2018.01.11) ▶ 2.[C90] > 0)일 때: C90 > 1,800만원 이면 오류

      if getErrLimitAmt(strToFloat(C[90]), 0, 1, 18000000) then
        errList.Add(errStr('C90', '㉯(2015년 이후 차입분, 상환기간 15년 이상)고정금리 and 비거치상환 대출', mName, idNo));

form1.Memo1.Lines.Add('C90');

      //C91 -㉯(2015년 이후 차입분, 상환기간 15년 이상)고정금리 or 비거치 상환 대출 9(8)
      //공제한도: 1,500만원
      //1.[C91] < 0이면 오류
      //2.[C91] > 0) 일 때: [C83+C84+ C91+C100+C101+C102] > 1,500만원 이면 오류
      if getErrLimitAmt(strToFloat(C[91]), 0, 1, 15000000) then
        errList.Add(errStr('C91', '㉯(2015년 이후 차입분, 상환기간 15년 이상)고정금리 or 비거치 상환 대출', mName, idNo));

form1.Memo1.Lines.Add('C91');

      //C92 -㉯(2015년 이후 차입분, 상환기간 15년 이상)그 밖의 대출 9(8)
      //공제한도: 500만원
      //1.[C92] < 0이면 오류
      //오류기준 변경(2018.01.11) ▶2.[C92] > 0 일 때:C92 > 500만원 이면 오류

      if getErrLimitAmt(strToFloat(C[92]), 0, 1, 5000000) then
        errList.Add(errStr('C92', '㉯(2015년 이후 차입분, 상환기간 15년 이상)그 밖의 대출', mName, idNo));

form1.Memo1.Lines.Add('C92');

      //C93 -㉯(2015년 이후 차입분, 상환기간 10년 이상)고정금리 or 비거치 상환 대출 9(8)
      //공제한도: 300만원
      //1.[C93] < 0이면 오류
      //오류기준 변경(2018.01.11) ▶2.[C93] > 0 일 때: C93 > 300만원 이면 오류
      //3.종합한도*) 확인([C93] = 0 일 때도 확인)
      // [C83+∼+C93+C100+C101+C102] > 종합한도*) 이면 오류
      //*종합한도: C85,C86,C87,C88,C89,C90,C91,C92,C93중금액이 있는 항목의 공제한도 금액 중 최고값
      cTempAmt0 := cTempAmt + strToFloat(C[93]);
      cTempLimitAmt := 3000000;

      if strToFloat(C[93]) < 0 then
        errList.Add(errStr('C93', '㉯(2015년 이후 차입분, 상환기간 10년 이상)고정금리 or 비거치 상환 대출', mName, idNo))
      else if strToFloat(C[93]) > 3000000 then
        errList.Add(errStr('C93', '㉯(2015년 이후 차입분, 상환기간 10년 이상)고정금리 or 비거치 상환 대출', mName, idNo))
      else
      begin
        if  (strToFloat(C[85]) + strToFloat(C[86]) + strToFloat(C[87])
          + strToFloat(C[88]) + strToFloat(C[89]) + strToFloat(C[90])
          + strToFloat(C[91]) + strToFloat(C[92]) + strToFloat(C[93])) > 0 then
        begin
          if cTempAmt0 > totalLimitAmt(strToFloat(C[85]), strToFloat(C[86]), strToFloat(C[87])
                                  , strToFloat(C[88]), strToFloat(C[89]), strToFloat(C[90])
                                  , strToFloat(C[91]), strToFloat(C[92]), strToFloat(C[93])) then
            errList.Add(errStr('C93', '㉯(2015년 이후 차입분, 상환기간 10년 이상)고정금리 or 비거치 상환 대출', mName, idNo));
        end;
      end;

form1.Memo1.Lines.Add('C93');
      //C94 기부금(이월분) 9(11)
      //1.[C94] < 0 이면 오류
      //2.외국인 단일세율 적용([C11]=‘9’, [C9]=‘1’)인 경우:[C94] ≠ 0 이면 오류
      //3.비거주자([C7]=‘2’)인 경우 0이 아니면 오류
      //N 4.[C94] ≠ [H15]*) 이면 오류
      //*기부금 조정명세(H레코드) 중 2013년 이전 이월종교단체외 지정기부금, 13년 이전 이월종교단체기부금 공제대상금액 합계와 비교
      cDonationCarryAmt := 0;
      cDonationCarryAmt := strToFloat(C[94]);

      if strToFloat(C[94]) < 0 then
        errList.Add(errStr('C94', '기부금(이월분)-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[94]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C94', '기부금(이월분)-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[94]), C[7]) then
        errList.Add(errStr('C94', '기부금(이월분)-3', mName, idNo));

form1.Memo1.Lines.Add('C94');
      //C96 계 9(11)
      //1.[C96] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’인 경우: [C96] ≠ 0 이면 오류
      //3.비거주자([C7]=‘2’)인 경우: [C96] ≠ 0 이면 오류
      //4.[C93] ≠ ([C81+C82]+[C83+∼+C93]+[C94])이면 오류
      if strToFloat(C[96]) < 0 then
        errList.Add(errStr('C96', '계-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[96]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C96', '계-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[96]), C[7]) then
        errList.Add(errStr('C96', '계-3', mName, idNo))
      else
      begin
        cTempAmt := 0;
        for j := 81 to 94 do
        begin
          cTempAmt := cTempAmt + strToFloat(C[j]);
form1.Memo1.Lines.Add(IntToStr(j) + ' ▶ ' + C[j]);
        end;
form1.Memo1.Lines.Add(C[93] + ' ▶ ' + floattostr(cTempAmt));

        if strToFloat(C[93]) <> cTempAmt then
          errList.Add(errStr('C96', '계-4', mName, idNo));
      end;

form1.Memo1.Lines.Add('C96');

      //C97 차감소득금액 9(11)
      //1.[C94] < 0 이면 오류
      //2.[C97]≠[C65]-([C66+C67+C69]+[C71+C73+∼+C75]+[C76+∼+C80]+[C81+∼+C94]) 이면 오류
      if strToFloat(C[94]) < 0 then
        errList.Add(errStr('C97', '차감소득금액', mName, idNo))
      else
      begin
        //C68, C70, C72
        cTempAmt := 0;
        for j := 66 to 94 do
        begin
          if not (j in [68, 70, 72]) then
          begin
            cTempAmt := cTempAmt + strToFloat(C[j]);
          end;
        end;

        if strToFloat(C[97]) <> strToFloat(C[65]) - cTempAmt then
          errList.Add(errStr('C97', '차감소득금액', mName, idNo));
      end;

form1.Memo1.Lines.Add('C97');

      //************************************************************************   【그 밖의 소득공제】
      //C98 개인연금저축소득공제 9(8)
      // -공제한도 : 72만원[조특법 제86조]
      //1.[C98] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’인 경우: [C98]≠0 이면 오류
      //3.[C7]=‘2’일 때: 0이 아니면 오류
      //4.[C98] > 72만원 이면 오류
      //N 5.[C98] > [연금·저축등소득·세액명세(F레코드) 개인연금저축(소득공제구분:21)의 공제금액 합계]이면 오류
      cPrAnnuitySavingAmt := 0;
      cPrAnnuitySavingAmt := strToFloat(C[98]);

      if strToFloat(C[98]) < 0 then
        errList.Add(errStr('C98', '개인연금저축소득공제', mName, idNo))
      else if getErrYn('2', strToFloat(C[98]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C98', '개인연금저축소득공제', mName, idNo))
      else if getErrYn('3', strToFloat(C[98]), C[7]) then
        errList.Add(errStr('C98', '개인연금저축소득공제', mName, idNo))
      else if strToFloat(C[98]) > 720000 then
        errList.Add(errStr('C98', '개인연금저축소득공제', mName, idNo));
   
form1.Memo1.Lines.Add('C98');
      //C99 소기업·소상공인 공제부금 9(10)
      //-공제한도 : 근로소득금액            공제한도
      //            4천만원이하             500만원
      //            4천만원초과∼1억원이하  300만원
      //            1억원 초과              200만원
      //1.[C99] < 0 이면 오류
      //2.외국인 단일세율 적용([C11]=‘9’, [C9]=‘1’)인 경우:[C99] ≠ 0 이면 오류
      //3.비거주자([C7]=‘2’)인 경우: [C99] ≠ 0 이면 오류
      //4.[C65] <= 4천만원인 경우 :　[C99] > 500만원 이면 오류
      //  [C65] > 4천만원이고, [C65] <= 1억인 경우 :　[C99] > 300만원 이면 오류
      //  [C65] > 1억인 경우 : [C99] > 200만원 이면 오류
      cTempLimitAmt := 3000000;

      if strToFloat(C[99]) < 0 then
        errList.Add(errStr('C99', '소기업·소상공인 공제부금', mName, idNo))
      else if getErrYn('2', strToFloat(C[99]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C99', '소기업·소상공인 공제부금', mName, idNo))
      else if getErrYn('3', strToFloat(C[99]), C[7]) then
        errList.Add(errStr('C99', '소기업·소상공인 공제부금', mName, idNo))
      else
      begin
        //cTempLimitAmt를 4천만원초과∼1억원이하인 300만원으로 기본값 Setting
        if StrToFloat(C[65]) <= 40000000 then
          cTempLimitAmt := 5000000
        else if StrToFloat(C[65]) > 100000000 then
          cTempLimitAmt := 2000000;

        if strToFloat(C[99]) > cTempLimitAmt then
          errList.Add(errStr('C99', '소기업·소상공인 공제부금', mName, idNo));
      end;

 form1.Memo1.Lines.Add('C99');
      //C100 -㉮주택마련저축소득공제_청약저축 9(10)
      //1.[C100] < 0 이면 오류
      //2.[C100] > 96만원이면 오류
      //N 3.[C63] > 7,000만원 이고 청약저축을 ’15.01.01.이후 가입한 경우: [C100] > 0 이면 오류
      //N 4.[C63] > 7,000만원 이고 청약저축을 ’14.12.31.이전 가입한 경우: [C100] > 48만원 이면 오류
      //N 5.[C100] > [연금저축등명세(F레코드)의 청약저축(소득공제구분:31)의 공제금액 합계] 이면 오류
      //6.[C83+C84]+[C100+C101+C102] > 300만원 이면 오류

      //청약저축의 가입일이 넘어오지 않는다고 판단되므로 제외
      cSubscriptDepositAmt := 0;
      cSubscriptDepositAmt := strToFloat(C[100]);
      cTempAmt := strToFloat(C[83]) + strToFloat(C[84]) + strToFloat(C[100]) + strToFloat(C[101]) + strToFloat(C[102]) ;

      if strToFloat(C[100]) < 0 then
        errList.Add(errStr('C100', '㉮주택마련저축소득공제_청약저축', mName, idNo))
      else if strToFloat(C[100]) > 960000 then
        errList.Add(errStr('C100', '㉮주택마련저축소득공제_청약저축', mName, idNo))
      else if cTempAmt > 3000000 then
        errList.Add(errStr('C100', '㉮주택마련저축소득공제_청약저축', mName, idNo));

form1.Memo1.Lines.Add('C100');
      //C101 -㉯주택마련저축소득공제_주택청약종합저축 9(10)
      //1.[C101] < 0 이면 오류
      //2.[C101] > 96만원이면 오류
      //N 3.[C63] > 7,000만원 이고 주택청약종합저축을 ’15.01.01.이후 가입한 경우: [C101] > 0 이면 오류
      //N 4.[C63] > 7,000만원 이고 주택청약종합저축을 ’14.12.31.이전 가입한 경우: [C101] > 48만원 이면 오류
      //N 5.[C101] > [연금저축등명세(F레코드)의 주택청약종합저축(소득공제구분:32)의 공제금액 합계] 이면 오류
      //6.[C83+C84]+[C100+C101+C102] > 300만원 이면 오류
      cGeneralSubscriptDepositAmt := 0;
      cGeneralSubscriptDepositAmt := strToFloat(C[101]);

      if strToFloat(C[101]) < 0 then
        errList.Add(errStr('C101', '㉯주택마련저축소득공제_주택청약종합저축', mName, idNo))
      else if strToFloat(C[101]) > 960000 then
        errList.Add(errStr('C101', '㉯주택마련저축소득공제_주택청약종합저축', mName, idNo))
      else if cTempAmt > 3000000 then
        errList.Add(errStr('C101', '㉯주택마련저축소득공제_주택청약종합저축', mName, idNo));

form1.Memo1.Lines.Add('C101');
      //C102 -㉰주택마련저축소득공제_근로자주택마련저축 9(10)
      //1.[C102] < 0 이면 오류
      //2.[C102] > 72만원이면 오류
      //N 3.[C102] > [연금저축등명세(F레코드)의 근로자주택마련저축(소득공제구분:34)의 공제금액 합계] 이면 오류
      //4.[C83+C84]+[C100+C101+C102] > 300만원 이면 오류
      cHousePurchaseAmt := 0;
      cHousePurchaseAmt := strToFloat(C[102]);

      if strToFloat(C[102]) < 0 then
        errList.Add(errStr('C102', '㉰주택마련저축소득공제_근로자주택마련저축', mName, idNo))
      else if strToFloat(C[102]) > 720000 then
        errList.Add(errStr('C102', '㉰주택마련저축소득공제_근로자주택마련저축', mName, idNo))
      else if cTempAmt > 3000000 then
        errList.Add(errStr('C102', '㉰주택마련저축소득공제_근로자주택마련저축', mName, idNo));

form1.Memo1.Lines.Add('C102');
      //C103 투자조합출자등소득공제 9(10)
      //1.[C103] < 0 이면 오류
      //2.외국인 단일세율 적용([C11]=‘9’, [C9]=‘1’)인 경우:[C103] ≠ 0 이면 오류
      //3.비거주자([C7]=‘2’)인 경우: [C103] ≠ 0 이면 오류
      //4.[C103] > [C65] × 50%이면 오류
      if strToFloat(C[103]) < 0 then
        errList.Add(errStr('C103', '투자조합출자등소득공제', mName, idNo))
      else if getErrYn('2', strToFloat(C[103]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C103', '투자조합출자등소득공제', mName, idNo))
      else if getErrYn('3', strToFloat(C[103]), C[7]) then
        errList.Add(errStr('C103', '투자조합출자등소득공제', mName, idNo))
      else if strToFloat(C[103]) > StrToFloat(C[65]) * 0.5 then
        errList.Add(errStr('C103', '투자조합출자등소득공제', mName, idNo));

form1.Memo1.Lines.Add('C103');
      //C104 신용카드등소득공제 9(8)
      //  공제한도 : 급여수준별 차등 적용
      //  총급여액                 공제한도
      //  7천만원이하              300만원과 총급여의 20% 중 적은금액
      //  7천만원초과∼1.2억원이하 300만원(‘18.1.1.이후 250만원)
      //  1.2억원 초과             200만원
      //1.[C104] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’인 경우: [C104] ≠ 0 이면 오류
      //3.비거주자([C7]=‘2’)인 경우: [C104] ≠ 0 이면 오류
      //N 4.[신용카드 등 사용금액*)합계] < [C63]*25%인 경우: [C104] > 0 이면 오류
      //N 5.[C104] > [신용카드 등 소득공제 계산값]이면 오류
      //※신용카드 등 소득공제계산값=소득공제명세(E레코드)의본인(관계코드:0)
      //, 배우자(관계코드:3) 및 직계존비속(관계코드:1,2,4,5)의 Min(6,7)+8+9 계산값의 합계

      if strToFloat(C[104]) < 0 then
        errList.Add(errStr('C104', '신용카드등소득공제', mName, idNo))
      else if getErrYn('2', strToFloat(C[104]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C104', '신용카드등소득공제', mName, idNo))
      else if getErrYn('3', strToFloat(C[104]), C[7]) then
        errList.Add(errStr('C104', '신용카드등소득공제', mName, idNo));

form1.Memo1.Lines.Add('C104');
      //C105 우리사주조합출연금 9(10)
      //-한도액 : 400만원  [조특법 제88조의4]
      //1.우리사주조합출연금소득공제 < 0이면 오류
      //2.[C11]=‘9’, [C9]=‘1’인 경우 0이 아니면 오류
      //3.우리사주조합출연금소득공제 > 400만원이면 오류

      if strToFloat(C[105]) < 0 then
        errList.Add(errStr('C105', '우리사주조합출연금', mName, idNo))
      else if getErrYn('2', strToFloat(C[105]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C105', '우리사주조합출연금', mName, idNo))
      else if strToFloat(C[105]) > 4000000 then
        errList.Add(errStr('C105', '우리사주조합출연금', mName, idNo));

form1.Memo1.Lines.Add('C105');
      //C107 고용유지중소기업 근로자소득공제 9(10)
      //-공제한도 : 연간 1,000만원[조특법 제30조의3]
      //1.[C107] < 0이면 오류
      //2.외국인 단일세율 적용([C11]=‘9’, [C9]=‘1’)인 경우:[C107] ≠ 0 이면 오류
      //3.비거주자([C7]=‘2’)인 경우: [C107] ≠ 0 이면 오류
      //4.[C107] > 1000만원이면 오류
      //N 5.임금삭감액의 50% 초과여부 확인

      if strToFloat(C[107]) < 0 then
        errList.Add(errStr('C107', '고용유지중소기업 근로자소득공제', mName, idNo))
      else if getErrYn('2', strToFloat(C[107]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C107', '고용유지중소기업 근로자소득공제', mName, idNo))
      else if getErrYn('3', strToFloat(C[107]), C[7]) then
        errList.Add(errStr('C107', '고용유지중소기업 근로자소득공제', mName, idNo))
      else if strToFloat(C[107]) > 10000000 then
        errList.Add(errStr('C107', '고용유지중소기업 근로자소득공제', mName, idNo));

form1.Memo1.Lines.Add('C107');
      //C109 장기집합투자증권저축 9(10)
      //-공제한도: 240만원 [조특법 제91조의16]
      //1.[C109] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C109] ≠ 0 이면 오류
      //3.[C7] = ‘2’ 일 때: [C109] ≠ 0 이면 오류
      //4.[C63] > 8,000만원 일 때: [C109] ≠ 0 이면 오류
      //5.[C109] > 240만원 이면 오류
      //N 6.[C109] > [연금저축등명세(F레코드)의 장기집합투자증권저축(소득공제구분:51)의 공제금액 합계] 이면 오류

      if strToFloat(C[109]) < 0 then
        errList.Add(errStr('C109', '장기집합투자증권저축', mName, idNo))
      else if getErrYn('2', strToFloat(C[109]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C109', '장기집합투자증권저축', mName, idNo))
      else if getErrYn('3', strToFloat(C[109]), C[7]) then
        errList.Add(errStr('C109', '장기집합투자증권저축', mName, idNo))
      else if (StrToFloat(C[63]) > 80000000) and (strToFloat(C[109]) <> 0) then
        errList.Add(errStr('C109', '장기집합투자증권저축', mName, idNo))
      else if strToFloat(C[109]) > 2400000 then
        errList.Add(errStr('C109', '장기집합투자증권저축제', mName, idNo));

form1.Memo1.Lines.Add('C109');
      //C110 그 밖의 소득공제계 9(11)
      //1.[C110] < 0이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C110] ≠ 0 이면 오류
      //3.[C110] ≠ [C98+∼+C105] + [C107+∼+C109]이면 오류
      //4.[C110] > [C97] 이면 오류
      cTempAmt := 0;

      if strToFloat(C[110]) < 0 then
        errList.Add(errStr('C110', '그 밖의 소득공제계', mName, idNo))
      else if getErrYn('2', strToFloat(C[110]), cForeignAb, cForeignTaxYn) then
          errList.Add(errStr('C110', '그 밖의 소득공제계', mName, idNo))
      else
      begin
        for j := 98 to 109 do
        begin
          if not (j in [106, 108]) then
          begin
            cTempAmt := cTempAmt + strToFloat(C[j]);
          end;
        end;

        if strToFloat(C[110]) <> cTempAmt then
          errList.Add(errStr('C110', '그 밖의 소득공제계', mName, idNo))
        else
        begin
          if strToFloat(C[110]) > strToFloat(C[97]) then
            errList.Add(errStr('C110', '그 밖의 소득공제계', mName, idNo));
        end;
      end;

form1.Memo1.Lines.Add('C110');
      //C111 소득공제종합한도초과액 9(11)
      //1.[C111] < 0 이면 오류
      //2.[외국인 단일세율 적용([C11]=‘9’, [C9]=‘1’)인 경우: [C111] ≠ 0 이면 오류
      //3.[C97] = 0 일 때: [C111] ≠ 0 이면 오류
      //4.[C65]<[C83+∼+C93]+[C99]+[C100+∼+C105]+[C109]이면오류
      //5.[C111]≠MAX([소득공제종합한도초과액대상항목계산값*)], 0) 이면 오류
      //*소득공제종합한도초과액대상항목계산값=[C83+∼+C93]+[C99]+[C100+∼+C105]+[C109]-2500만원
      cTempAmt := 0;

      if strToFloat(C[111]) < 0 then
        errList.Add(errStr('C111', '소득공제종합한도초과액-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[111]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C111', '소득공제종합한도초과액-2', mName, idNo))
      else if (strToFloat(C[97]) = 0) and (strToFloat(C[111]) <> 0) then
        errList.Add(errStr('C111', '소득공제종합한도초과액-3', mName, idNo))
      else
      begin
        for j := 83 to 109 do
        begin
          if not (j in [94..98, 106..108]) then
          begin
            cTempAmt := cTempAmt + strToFloat(C[j]);
          end;
        end;

        if StrToFloat(C[65]) < cTempAmt then
          errList.Add(errStr('C111', '소득공제종합한도초과액-4', mName, idNo))
        else
        begin
          if cTempAmt - 25000000 > 0 then
            cTempAmt := cTempAmt - 25000000
          else
            cTempAmt := 0;  
            
          if strToFloat(C[111]) <> cTempAmt then
            errList.Add(errStr('C111', '소득공제종합한도초과액-5', mName, idNo));
        end;
      end;

form1.Memo1.Lines.Add('C111');
      //C112 종합소득 과세표준 9(11)
      //1.[C112] < 0 이면 오류
      //2.[C112]≠그밖의소득공제적용값*)+[C111] 이면 오류
      //*그밖의소득공제적용값 = MAX([C97-C110], 0)
      cStandardTaxAmt := 0; cTempAmt := 0;
      cStandardTaxAmt := strToFloat(C[112]);

      if strToFloat(C[112]) < 0 then
        errList.Add(errStr('C112', '종합소득 과세표준', mName, idNo))
      else
      begin
        if strToFloat(C[97]) - strToFloat(C[110]) > 0 then
          cTempAmt := strToFloat(C[97]) - strToFloat(C[110]);

        if strToFloat(C[112]) <> cTempAmt + strToFloat(C[111]) then
          errList.Add(errStr('C112', '종합소득 과세표준', mName, idNo));
      end;
form1.Memo1.Lines.Add('C112');

      //C113 산출세액 9(10)
      //1.[C113] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C113]≠[C112]×19%이면 오류
      //3.[C113] ≠ ([C112]에 의한 산출세액 계산값) 이면 오류
      cCalculateTaxAmt := 0; cTempAmt := 0;
      cCalculateTaxAmt := strToFloat(C[113]);
      cTempAmt := Abs(strToFloat(C[113]) - strToFloat(C[112]) * 0.19);

      if strToFloat(C[113]) < 0 then
        errList.Add(errStr('C113', '산출세액', mName, idNo))
      else if (cForeignAb = '9') and (cForeignTaxYn = '1') and (cTempAmt > 100) then
      begin
        errList.Add(errStr('C113', '산출세액', mName, idNo))
      end
      else
      begin
        {hr_over	        hr_less	    hr_standard_value	hr_max_value
                        과세표준		  세율	            최대치
         - 	            12,000,000	  6%	              - 	            과세표준 * 6%
        1200만원 초과	  46,000,000	  15%	              720,000 	      72만원 + (과세표준 - 1200만원)*15%
        4600만원 초과	  88,000,000	  24%	              5,820,000 	    582만원 + (과세표준 - 4600만원)*24%
        8800만원 초과	  150,000,000	  35%	              15,900,000 	    1590만원 + (과세표준 - 8800만원)*35%
        1억5천만원 초과	500,000,000	  38%	              37,600,000 	    3760만원 + (과세표준 - 1억 5천만원)*38%
        5억 초과		                  40%	              170,600,000 	  1억7,060만원 + (5억원 초과금액의 40%)}

        cTempAmt := 0;
        tempArr := getTaxBase('3', StrToFloat(C[112]), '2017');
        cTempAmt := Floor(tempArr[3] + (StrToFloat(C[112]) - tempArr[0]) * tempArr[2] * 0.01);

        if Abs(strToFloat(C[113]) - cTempAmt) > 100  then
          errList.Add(errStr('C113', '산출세액', mName, idNo));
      end;
form1.Memo1.Lines.Add('C113');
      //************************************************************************【세액감면】
      //1.(-)금액일 경우 오류
      //2.외국인 단일세율 적용([C11]=‘9’, [C9]=‘1’)인 경우: 0 아니면 오류
      //N 3.주(현) 감면기간([C20], [C21])과 모든 종(전)의 감면기간([D13], [D14])이 기재되어 있지 않은데
      //  [C114] + [C115] + [C116] + [C117] ≠ 0이면 오류

      //C114 소득세법 9(10)
      //1.내국인(C11=‘1’) 일 때: [C114] ≠ 0 이면 오류
      //2.[C114] > [C113]이면 오류
      cIncometaxReduceAmt := 0;
      cIncometaxReduceAmt := strToFloat(C[114]);

      if strToFloat(C[114]) < 0 then
        errList.Add(errStr('C114', '소득세법', mName, idNo))
      else if getErrYn('2', strToFloat(C[114]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C114', '소득세법', mName, idNo))
      else if (cForeignAb = '1') AND (strToFloat(C[114]) <> 0) then
        errList.Add(errStr('C114', '소득세법', mName, idNo))
      else if strToFloat(C[114]) > strToFloat(C[113]) then
        errList.Add(errStr('C114', '소득세법', mName, idNo));

form1.Memo1.Lines.Add('C114');
      //C115 조특법(제외) 9(10)
      //조세특례제한법에 의한 세액감면(제외)
      //1.[C11]=‘1’ 일 때: [C115]≠0 이면 오류
      //2.[C115] > [C113] 이면 오류
      //N 3.[C54]+[모든 종(전)의 [D47]의 합]=0 일 때:[C115] ≠ 0 이면 오류
      //N 4.[C115]>[C113]×(([C54]+[모든종(전)의 [D47]의 합])/[C63])×50%이면오류
      cSpecialTaxAmt1 := 0;
      cSpecialTaxAmt1 := strToFloat(C[115]);

      if strToFloat(C[115]) < 0 then
        errList.Add(errStr('C115', '조특법(제외)', mName, idNo))
      else if getErrYn('2', strToFloat(C[115]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C115', '조특법(제외)', mName, idNo))
      else if (cForeignAb = '1') AND (strToFloat(C[115]) <> 0) then
        errList.Add(errStr('C115', '조특법(제외)', mName, idNo))
      else if strToFloat(C[114]) > strToFloat(C[113]) then
        errList.Add(errStr('C115', '조특법(제외)', mName, idNo));

form1.Memo1.Lines.Add('C115');
      //C116 조특법 제30조 9(10)
      //1.[C116] > [C113] 이면 오류
      //N 2.[C116] > ①+②+③ 이면 오류
      // 1)=[C113]×(([C58]+[종(전)의[D51]의합])/[C63])×100%
      // 2)=[C113]×(([C58ⓐ]+[종(전)의[D51ⓐ]의합])/[C63])×50%
      // 3)=MIN([C113]×(([C58ⓑ]+[종(전)의[D51ⓑ]의합])/[C63])×70%, 150만원)
      cSpecialTaxAmt2 := 0;
      cSpecialTaxAmt2 := strToFloat(C[116]);

      if strToFloat(C[116]) < 0 then
        errList.Add(errStr('C116', '조특법 제30조-3', mName, idNo))
      else if getErrYn('2', strToFloat(C[116]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C116', '조특법 제30조-4', mName, idNo))
      else if strToFloat(C[116]) > strToFloat(C[113]) then
        errList.Add(errStr('C116', '조특법 제30조-5', mName, idNo));

form1.Memo1.Lines.Add('C116');
      //C117 조세조약 9(10)
      //1.[C11]=‘1’ 일 때: [C117]≠0 이면 오류
      //2.[C117] > [C113] 이면 오류
      //N 3.[C59] + [모든 종(전)의 [D52]의 합] = 0 일 때:[C117] ≠ 0 이면 오류
      //N 4.[C117]>[C113]×(([C59]+[모든종(전)의 [D52]의 합])/[C63])×100%이면오류
      cTaxPactReduceAmt := 0;
      cTaxPactReduceAmt := strToFloat(C[117]);

      if strToFloat(C[117]) < 0 then
        errList.Add(errStr('C117', '조세조약-3', mName, idNo))
      else if getErrYn('2', strToFloat(C[117]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C117', '조세조약-4', mName, idNo))
      else if (cForeignAb = '1') AND (strToFloat(C[117]) <> 0) then
        errList.Add(errStr('C117', '조세조약-5', mName, idNo))
      else if strToFloat(C[117]) > strToFloat(C[113]) then
        errList.Add(errStr('C117', '조세조약-6', mName, idNo));

form1.Memo1.Lines.Add('C117');
      //C119 세액감면계 9(10)
      //1.[C119] < 0 이면 오류
      //2.[C119] > [C113]이면 오류
      //3.[C119] ≠ [C114+C115+C116+C117] 이면 오류
      cTempAmt := 0;
      cTempAmt := strToFloat(C[114]) + strToFloat(C[115]) + strToFloat(C[116]) + strToFloat(C[117]);

      if strToFloat(C[119]) < 0 then
        errList.Add(errStr('C119', '세액감면계', mName, idNo))
      else if strToFloat(C[119]) > strToFloat(C[113]) then
        errList.Add(errStr('C119', '세액감면계', mName, idNo))
      else if Abs(strToFloat(C[119]) - cTempAmt) > 100 then
        errList.Add(errStr('C119', '세액감면계', mName, idNo));

form1.Memo1.Lines.Add('C119');
      //【세액공제】
      //C120 근로소득세액공제 9(10)
      //1)근로소득 세액공제 계산값 : 산출세액(항목113)이
      // -130만원 이하: 산출세액 × 55%
      // -130만원 초과: 71만5천원+(130만원초과금액의 30%)
      //2)감면급여비율*) 적용
      // -근로소득 세액공제 계산값(1) × [1-[중소기업취업청년소득세감면액(항목116)/산출세액(항목113)]]
      // *감면급여비율 = 중소기업 취업자에 대한 소득세 감면액 ÷ 산출세액
      //1.[C120] < 0 이면 오류
      //2.외국인 단일세율 적용([C11]=‘9’, [C9]=‘1’)인 경우:[C120] ≠ 0 이면 오류
      //3.[C120] > [C113] - [C119] 이면 오류
      //4.[C120] > 근로소득세액공제 계산값 × [1-[C116/C113]] 이면 오류
      cTempAmt := 0; cTempAmt0 := 0;

      if strToFloat(C[120]) < 0 then
        errList.Add(errStr('C120', '근로소득세액공제-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[120]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C120', '근로소득세액공제-2', mName, idNo))
      else
      begin
        if strToFloat(C[120]) > strToFloat(C[113]) - strToFloat(C[119])  then
          errList.Add(errStr('C120', '근로소득세액공제-3', mName, idNo))
        else
        begin
          cTempAmt := 0;
          if strToFloat(C[113]) <= 1300000 then
            cTempAmt := strToFloat(C[113]) * 0.55
          else
            cTempAmt := 715000 + (strToFloat(C[113]) - 1300000) * 0.3;

          if strToFloat(C[113]) <> 0 then
          begin
            cTempAmt0 := cTempAmt * (1 - (strToFloat(C[116])/strToFloat(C[113])));

            if strToFloat(C[120]) > cTempAmt0 then
              errList.Add(errStr('C120', '근로소득세액공제-4', mName, idNo));
          end;
        end;
      end;

form1.Memo1.Lines.Add('C120');
      //C121-㉮자녀세액공제 인원 9(2)
      //1.[C121] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C121] ≠ 0 이면 오류
      //3.비거주자([C7]=‘2’) 일 때: [C121] ≠ 0 이면 오류
      //N 4.[C121] > 자녀세액공제인원수*) 이고 [C122] ≠ 0 이면 오류
      // *자녀세액공제인원수: 소득공제명세(E레코드)에서 기본공제가 ‘여(1)’ 이고 직계비속(관계코드:4,8)인 인원수
      cChildDeductCnt := 0; cChildDeductAmt := 0;
      cChildDeductCnt := strToInt(C[121]);
      cChildDeductAmt := strToFloat(C[122]);

      if strToInt(C[121]) < 0 then
        errList.Add(errStr('C121', '자녀세액공제 인원-1', mName, idNo))
      else if getErrYn('2', strToInt(C[121]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C121', '자녀세액공제 인원-2', mName, idNo))
      else if getErrYn('3', strToInt(C[121]), C[7]) then
        errList.Add(errStr('C121', '자녀세액공제 인원-3', mName, idNo));

form1.Memo1.Lines.Add('C121');
      //C122 -㉮자녀세액공제 9(10)
      //1.[C122] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C122] ≠ 0 이면 오류
      //3.[C7] = ‘2’ 일 때: [C122] ≠ 0 이면 오류
      //4.[C121]?2인경우:[C122] > [C121]×15만원이면 오류 [C121]?3인경우:[C122] > 30만원+([C121]-2)×30만원이면 오류
      //5.[C122] > [C113] - [C119] 이면 오류

      if strToFloat(C[122]) < 0 then
        errList.Add(errStr('C122', '자녀세액공제-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[122]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C122', '자녀세액공제-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[122]), C[7]) then
        errList.Add(errStr('C122', '자녀세액공제-3', mName, idNo))
      else if (strToInt(C[121]) <= 2) and (strToFloat(C[122]) > strToInt(C[121]) * 150000) then
        errList.Add(errStr('C122', '자녀세액공제-4', mName, idNo))
      else if (strToInt(C[121]) >= 3) and (strToFloat(C[122]) > 300000 + (strToInt(C[121]) - 2) * 300000) then
        errList.Add(errStr('C122', '자녀세액공제-5', mName, idNo))
      else if strToFloat(C[122]) > strToFloat(C[113]) - strToFloat(C[119]) then
        errList.Add(errStr('C122', '자녀세액공제-6', mName, idNo));

form1.Memo1.Lines.Add('C122');
      //C123 -㉯6세이하자녀 세액공제 인원 9(2)
      //1.[C123] < 0 이면 오류
      //2.외국인 단일세율 적용([C11]=‘9’, [C9]=‘1’)인 경우:[C123] ≠ 0 이면 오류
      //3.비거주자([C7]=‘2’)인 경우: [C123] ≠ 0 이면 오류
      //4.[C123] > 6세이하자녀세액공제인원수*) 이고 [C124] ≠ 0 이면 오류
      // *6세이하자녀세액공제인원수: 소득공제명세(E레코드)에서 6세이하공제가 ‘여(1)’ 이고 기본공제가 ‘여(1)’ 이고 직계비속(관계코드:4,8)인 인원수
      cUnderSixChildCnt := 0; cUnderSixChildAmt := 0;
      cUnderSixChildCnt := strToInt(C[123]);
      cUnderSixChildAmt := strToFloat(C[124]);

      if strToInt(C[123]) < 0 then
        errList.Add(errStr('C123', '6세이하자녀 세액공제 인원-1', mName, idNo))
      else if getErrYn('2', strToInt(C[123]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C123', '6세이하자녀 세액공제 인원-2', mName, idNo))
      else if getErrYn('3', strToInt(C[123]), C[7]) then
        errList.Add(errStr('C123', '6세이하자녀 세액공제 인원-3', mName, idNo));

form1.Memo1.Lines.Add('C123');
      //C124 -㉯6세이하자녀 세액공제 9(10)
      //1.[C124] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C124] ≠ 0 이면 오류
      //3.[C7] = ‘2’ 일 때: [C124] ≠ 0 이면 오류
      //4.[C124] > ([C123] - 1) × 15만원 이면 오류
      if strToFloat(C[124]) < 0 then
        errList.Add(errStr('C124', '6세이하자녀 세액공제-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[124]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C124', '6세이하자녀 세액공제-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[124]), C[7]) then
        errList.Add(errStr('C124', '6세이하자녀 세액공제-3', mName, idNo))
      else if (strToFloat(C[124]) > (strToInt(C[123]) - 1) * 150000) and (strToFloat(C[124]) > 0) then
        errList.Add(errStr('C124', '6세이하자녀 세액공제-4', mName, idNo));

form1.Memo1.Lines.Add('C124');
      //C125 -㉰출산/입양세액공제인원 9(2)
      //1.[C125] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C125] ≠ 0 이면 오류
      //3.[C7]=‘2’ 일 때: [C125] ≠ 0 이면 오류
      //N 4.[C125] > 출산?입양세액공제인원수*) 이고 [C126] ≠ 0 이면 오류
      // *출산?입양세액공제인원수: 소득공제명세(E레코드)에서 출산?입양공제(E16,E49,E82,E115,E148)가 ‘1’ 이고 직계비속(관계코드:4)인 인원수
      cAdoptChildCnt := 0; cAdoptChildAmt := 0;
      cAdoptChildCnt := strToInt(C[125]);
      cAdoptChildAmt := strToFloat(C[126]);
      if strToInt(C[125]) < 0 then
        errList.Add(errStr('C125', '출산/입양세액공제인원-1', mName, idNo))
      else if getErrYn('2', strToInt(C[125]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C125', '출산/입양세액공제인원-2', mName, idNo))
      else if getErrYn('3', strToInt(C[125]), C[7]) then
        errList.Add(errStr('C125', '출산/입양세액공제인원-3', mName, idNo));

form1.Memo1.Lines.Add('C125');
      //C126 -㉰출산/입양세액공제 9(10)
      //1.[C126] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C126] ≠ 0이면 오류
      //3.[C7]=‘2’ 일 때: [C126] ≠ 0이면 오류
      //4.[C126] > [C125] × 70만원 이면 오류
      if strToFloat(C[126]) < 0 then
        errList.Add(errStr('C126', '출산/입양세액공제-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[126]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C126', '출산/입양세액공제-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[126]), C[7]) then
        errList.Add(errStr('C126', '출산/입양세액공제-3', mName, idNo))
      else if strToFloat(C[126]) > (strToInt(C[125]) * 700000) then
        errList.Add(errStr('C126', '출산/입양세액공제-4', mName, idNo));

form1.Memo1.Lines.Add('C126');
      //C127 연금계좌_과학기술인공제_공제대상금액 9(10)
      //1.[C127] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C127] ≠ 0 이면 오류
      //3.[C7] = ‘2’ 일 때: [C127] ≠ 0 이면 오류
      //4.[C127]+[C129]+MIN([C131], 400만원)>700만원 이면 오류
      cTempAmt := 4000000; cTempAmt0 := 0;
      if strToFloat(C[131]) < cTempAmt then cTempAmt := strToFloat(C[131]);

      cTempAmt0 := strToFloat(C[127]) + strToFloat(C[129]) + cTempAmt;

      if strToFloat(C[127]) < 0 then
        errList.Add(errStr('C127', '연금계좌_과학기술인공제_공제대상금액-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[127]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C127', '연금계좌_과학기술인공제_공제대상금액-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[127]), C[7]) then
        errList.Add(errStr('C127', '연금계좌_과학기술인공제_공제대상금액-3', mName, idNo))
      else if cTempAmt0 > 7000000 then
        errList.Add(errStr('C127', '연금계좌_과학기술인공제_공제대상금액-4', mName, idNo));

form1.Memo1.Lines.Add('C127');

      //C128 연금계좌_과학기술인공제_세액공제액 9(10)
      //1.[C128] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C128] ≠ 0 이면 오류
      //3.[C7]=‘2’ 일 때: [C128] ≠ 0 이면 오류
      //4.[C63]?5,500만원일때:[C128] > [C127]×15% 이면 오류
      //5.[C63]>5,500만원일때:[C128] > [C127]×12% 이면 오류
      //N 6.[C128]>[연금저축등명세(F레코드)의 과학기술인공제(소득공제구분:12)의 공제금액 합계] 이면 오류
      //7.[C128] > [C113] - [C119] 이면 오류
      c128Amt := 0;
      c128Amt := strToFloat(C[128]);
      if strToFloat(C[128]) < 0 then
        errList.Add(errStr('C128', '연금계좌_과학기술인공제_세액공제액-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[128]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C128', '연금계좌_과학기술인공제_세액공제액-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[128]), C[7]) then
        errList.Add(errStr('C128', '연금계좌_과학기술인공제_세액공제액-3', mName, idNo))
      else if (StrToFloat(C[63]) <= 55000000) and (strToFloat(C[128]) > strToFloat(C[127]) * 0.15 ) then
        errList.Add(errStr('C128', '연금계좌_과학기술인공제_세액공제액-4', mName, idNo))
      else if (StrToFloat(C[63]) > 55000000) and (strToFloat(C[128]) > strToFloat(C[127]) * 0.12) then
        errList.Add(errStr('C128', '연금계좌_과학기술인공제_세액공제액-5', mName, idNo))
      else if strToFloat(C[128]) > strToFloat(C[113]) - strToFloat(C[119]) then
        errList.Add(errStr('C128', '연금계좌_과학기술인공제_세액공제액-6', mName, idNo));
  

form1.Memo1.Lines.Add('C128');
      //C129 연금계좌_근로자퇴직급여보장법에 따른 퇴직급여_공제대상금액 9(10)
      //1.[C129] < 0 이면 오류
      //2.외국인 단일세율 적용([C11]=‘9’, [C9]=‘1’)인 경우:[C129] ≠ 0 이면 오류
      //3.비거주자([C7]=‘2’) 일 때: [C129] ≠ 0 이면 오류
      //4.[C127]+[C129]+MIN([C131], 400만원)>700만원 이면 오류
      if strToFloat(C[129]) < 0 then
        errList.Add(errStr('C129', '연금계좌_근로자퇴직급여보장법에 따른 퇴직급여_공제대상금액-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[129]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C129', '연금계좌_근로자퇴직급여보장법에 따른 퇴직급여_공제대상금액-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[129]), C[7]) then
        errList.Add(errStr('C129', '연금계좌_근로자퇴직급여보장법에 따른 퇴직급여_공제대상금액-3', mName, idNo))
      else if cTempAmt0 > 7000000 then
        errList.Add(errStr('C129', '연금계좌_근로자퇴직급여보장법에 따른 퇴직급여_공제대상금액-4', mName, idNo));

form1.Memo1.Lines.Add('C129');
      //C130 연금계좌_근로자퇴직급여보장법에 따른 퇴직급여_세액공제액 9(10)
      //1.[C130] < 0이면 오류
      //2.[C11]=‘9’, [C9]=‘1’인 경우: [C130] ≠ 0 이면 오류
      //3.[C7]='2' 인 경우: [C130] ≠ 0 이면 오류
      //4.[C63]?5500만원일때:[C130]>[C129]×15%이면오류
      //5.[C63]>5500만원일때:[C130]>[C129]×12% 이면 오류
      //N 6.[C130] > [연금저축등명세(F레코드)의 근로자퇴직급여(소득공제구분:11)의 공제금액 합계] 이면 오류
      //7.[C130] > [C113] - [C119] 이면 오류
      c130Amt := 0;
      c130Amt := strToFloat(C[130]);
      if strToFloat(C[130]) < 0 then
        errList.Add(errStr('C130', '연금계좌_근로자퇴직급여보장법에 따른 퇴직급여_세액공제액-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[130]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C130', '연금계좌_근로자퇴직급여보장법에 따른 퇴직급여_세액공제액-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[130]), C[7]) then
        errList.Add(errStr('C130', '연금계좌_근로자퇴직급여보장법에 따른 퇴직급여_세액공제액-3', mName, idNo))
      else if (StrToFloat(C[63]) <= 55000000) and (strToFloat(C[130]) > strToFloat(C[129]) * 0.15 ) then
        errList.Add(errStr('C130', '연금계좌_근로자퇴직급여보장법에 따른 퇴직급여_세액공제액-4', mName, idNo))
      else if (StrToFloat(C[63]) > 55000000) and (strToFloat(C[130]) > strToFloat(C[129]) * 0.12 ) then
        errList.Add(errStr('C130', '연금계좌_근로자퇴직급여보장법에 따른 퇴직급여_세액공제액-5', mName, idNo))
      else if strToFloat(C[130]) > strToFloat(C[113]) - strToFloat(C[119]) then
        errList.Add(errStr('C130', '연금계좌_근로자퇴직급여보장법에 따른 퇴직급여_세액공제액-6', mName, idNo));

form1.Memo1.Lines.Add('C130');
      //C131 연금계좌_연금저축_공제대상금액 9(10)
      //1.[C131] < 0 이면 오류
      //2.외국인 단일세율 적용([C11]=‘9’, [C9]=‘1’)인 경우:[C131] ≠ 0 이면 오류
      //3.[C7]=‘2’ 일 때: [C131] ≠ 0 이면 오류
      //4.[C63] <= 1억2천만원 일 때:[C131] > 400만원 이면 오류
      //  [C63] > 1억2천만원 일 때:[C131] > 300만원 이면 오류
      //5.[C127]+[C129]+MIN([C131], 400만원)>700만원 이면 오류
      if strToFloat(C[131]) < 0 then
        errList.Add(errStr('C131', '연금계좌_연금저축_공제대상금액-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[131]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C131', '연금계좌_연금저축_공제대상금액-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[131]), C[7]) then
        errList.Add(errStr('C131', '연금계좌_연금저축_공제대상금액-3', mName, idNo))
      else if (StrToFloat(C[63]) <= 120000000) and (strToFloat(C[131]) > 4000000 ) then
        errList.Add(errStr('C131', '연금계좌_연금저축_공제대상금액-4', mName, idNo))
      else if (StrToFloat(C[63]) > 120000000) and (strToFloat(C[131]) > 3000000) then
        errList.Add(errStr('C131', '연금계좌_연금저축_공제대상금액-5', mName, idNo))
      else if cTempAmt0 > 7000000 then
        errList.Add(errStr('C131', '연금계좌_연금저축_공제대상금액-6', mName, idNo));

form1.Memo1.Lines.Add('C131');
      //C132 연금계좌_연금저축_세액공제액 9(10)
      //1.[C132] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C132] ≠ 0 이면 오류
      //3.[C7] = ‘2’ 일 때: [C132] ≠ 0 이면 오류
      //4.[C63]?5500만원일때:[C132]>[C131]×15%이면오류
      //5.[C63]>5500만원일때:[C132]>[C131]×12% 이면 오류
      //N 6.[C130] > [연금저축등명세(F레코드)의 연금저축(소득공제구분:22)의 공제금액 합계] 이면 오류
      //7.[C132] > [C113] - [C119] 이면 오류
      if strToFloat(C[132]) < 0 then
        errList.Add(errStr('C132', '연금계좌_연금저축_세액공제액-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[132]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C132', '연금계좌_연금저축_세액공제액-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[132]), C[7]) then
        errList.Add(errStr('C132', '연금계좌_연금저축_세액공제액-3', mName, idNo))
      else if (StrToFloat(C[63]) <= 55000000) and (strToFloat(C[132]) > strToFloat(C[131]) * 0.15) then
        errList.Add(errStr('C132', '연금계좌_연금저축_세액공제액-4', mName, idNo))
      else if (StrToFloat(C[63]) > 55000000) and (strToFloat(C[132]) > strToFloat(C[131]) * 0.12) then
        errList.Add(errStr('C132', '연금계좌_연금저축_세액공제액-5', mName, idNo))
      else if strToFloat(C[132]) > strToFloat(C[113]) - strToFloat(C[119]) then
        errList.Add(errStr('C132', '연금계좌_연금저축_세액공제액-6', mName, idNo));

form1.Memo1.Lines.Add('C132');
      //C133 특별세액공제_보장성보험료_공제대상금액 9(10)
      //-공제한도 : 100만원
      //1.[C133] > 100만원 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C133] ≠ 0 이면 오류
      //3.[C7]=‘2’ 일 때: [C133] ≠ 0 이면 오류
      //N 4.[C133]>[소득공제명세(E레코드)의 보장성보험료 합계] 이면 오류
      c133Amt := 0;
      c133Amt := strToFloat(C[133]);

      if strToFloat(C[133]) > 1000000  then
        errList.Add(errStr('C133', '특별세액공제_보장성보험료_공제대상금액-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[133]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C133', '특별세액공제_보장성보험료_공제대상금액-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[133]), C[7]) then
        errList.Add(errStr('C133', '특별세액공제_보장성보험료_공제대상금액-3', mName, idNo));

form1.Memo1.Lines.Add('C133');
      //C134 특별세액공제_보장성보험료_세액공제액 9(10)
      //1.[C134] < 0 이면 오류
      //2.외국인 단일세율 적용([C11]=‘9’, [C9]=‘1’)인 경우:[C134] ≠ 0 이면 오류
      //3.비거주자([C7]=‘2’) 일 때: [C134] ≠ 0 이면 오류
      //4.[C134] > [C133] × 12% 이면 오류
      //5.[C134] > [C113] - [C119] 이면 오류
      if strToFloat(C[134]) < 0 then
        errList.Add(errStr('C134', '특별세액공제_보장성보험료_세액공제액-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[134]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C134', '특별세액공제_보장성보험료_세액공제액-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[134]), C[7]) then
        errList.Add(errStr('C134', '특별세액공제_보장성보험료_세액공제액-3', mName, idNo))
      else if strToFloat(C[134]) > strToFloat(C[133]) * 0.12 then
        errList.Add(errStr('C134', '특별세액공제_보장성보험료_세액공제액-4', mName, idNo))
      else if strToFloat(C[134]) > strToFloat(C[113]) - strToFloat(C[119]) then
        errList.Add(errStr('C134', '특별세액공제_보장성보험료_세액공제액-5', mName, idNo));

form1.Memo1.Lines.Add('C134');
      //C135 특별세액공제_장애인전용보장성보험료_공제대상금액 9(10)
      //-공제한도 : 100만원
      //1.[C135] > 100만원 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C135] ≠ 0 이면 오류
      //3.[C7]=‘2’ 일 때: [C135] ≠ 0 이면 오류
      //4.[C135] > {소득공제명세(E레코드)의 장애인전용보장성보험료 합계} 이면 오류
      c135Amt := 0;
      c135Amt := strToFloat(C[135]);
      if strToFloat(C[135]) > 1000000  then
        errList.Add(errStr('C135', '특별세액공제_장애인전용보장성보험료_공제대상금액', mName, idNo))
      else if getErrYn('2', strToFloat(C[135]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C135', '특별세액공제_장애인전용보장성보험료_공제대상금액', mName, idNo))
      else if getErrYn('3', strToFloat(C[135]), C[7]) then
        errList.Add(errStr('C135', '특별세액공제_장애인전용보장성보험료_공제대상금액', mName, idNo));
        
form1.Memo1.Lines.Add('C135');
      //C136 특별세액공제_장애인전용보장성보험료_세액공제액 9(10)
      //1.[C136] < 0 이면 오류
      //2.외국인 단일세율 적용([C11]=‘9’, [C9]=‘1’)인 경우:[C136] ≠ 0 이면 오류
      //3.비거주자([C7]=‘2’) 일 때: [C136] ≠ 0 이면 오류
      //4.[C136] > [C135] × 15% 이면 오류
      //5.[C136] > [C113] - [C119] 이면 오류
      if strToFloat(C[136]) < 0 then
        errList.Add(errStr('C136', '특별세액공제_장애인전용보장성보험료_세액공제액-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[136]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C136', '특별세액공제_장애인전용보장성보험료_세액공제액-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[136]), C[7]) then
        errList.Add(errStr('C136', '특별세액공제_장애인전용보장성보험료_세액공제액-3', mName, idNo))
      else if strToFloat(C[136]) > strToFloat(C[135]) * 0.15 then
        errList.Add(errStr('C136', '특별세액공제_장애인전용보장성보험료_세액공제액-4', mName, idNo))
      else if strToFloat(C[136]) > strToFloat(C[113]) - strToFloat(C[119]) then
        errList.Add(errStr('C136', '특별세액공제_장애인전용보장성보험료_세액공제액-5', mName, idNo));

form1.Memo1.Lines.Add('C136');
      //C137 특별세액공제_의료비_공제대상금액 9(10)
      //1.[C137] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C137] ≠ 0  이면 오류
      //3.[C7]=‘2’ 일 때: [C137] ≠ 0  이면 오류
      //N 4.[C137] > MAX(①+②, 0) 이면 오류
      //①본인 등 의료비 지출금액*)
      //②MIN(그외의료비지출액**)-([C63]×3%), 700만원)
      //*본인 등 의료비 지출금액
      //: 소득공제명세(E레코드)의 본인, 과세기간종료일 현재 65세 이상인 자(’52.12.31.이전 출생), 장애인의 의료비와 난임수술비용 합계액
      //**그 외 의료비 지출액: 본인 등 의료비 지출금액에 해당하지 않는 그 외 부양가족의 소득공제명세의 의료비 합계액

      //N 5.[C137]>소득공제명세(E레코드)의 의료비 합계이면 오류
      c137Amt := 0;
      c137Amt := strToFloat(C[137]);
      if strToFloat(C[137]) < 0 then
        errList.Add(errStr('C137', '특별세액공제_의료비_공제대상금액-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[137]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C137', '특별세액공제_의료비_공제대상금액-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[137]), C[7]) then
        errList.Add(errStr('C137', '특별세액공제_의료비_공제대상금액-3', mName, idNo));

form1.Memo1.Lines.Add('C137');
      //C138 특별세액공제_의료비_세액공제액 9(10)
      //1.[C138] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C138] ≠ 0 이면 오류
      //3.[C7] = ‘2’ 일 때: [C138] ≠ 0 이면 오류
      //4.[C138] > [C137] × 20% 이면 오류
      //5.[C138] > [C113] - [C119] 이면 오류
      if strToFloat(C[138]) < 0 then
        errList.Add(errStr('C138', '특별세액공제_의료비_세액공제액-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[138]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C138', '특별세액공제_의료비_세액공제액-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[138]), C[7]) then
        errList.Add(errStr('C138', '특별세액공제_의료비_세액공제액-3', mName, idNo))
      else if strToFloat(C[138]) > strToFloat(C[137]) * 0.2 then
        errList.Add(errStr('C138', '특별세액공제_의료비_세액공제액-4', mName, idNo))
      else if strToFloat(C[138]) > strToFloat(C[113]) - strToFloat(C[119]) then
        errList.Add(errStr('C138', '특별세액공제_의료비_세액공제액-5', mName, idNo));

form1.Memo1.Lines.Add('C138');
      //C139 특별세액공제_교육비_공제대상금액 9(10)
      //1.[C139] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C139] ≠ 0 이면 오류
      //3.[C7] = ‘2’ 일 때: [C139] ≠ 0 이면 오류
      //N 4.[C139] > 교육비 공제대상금액 합계*) 이면 오류
      //*소득공제명세(E레코드)의 교육비 지출금액 중 한도를 초과하지 않는 공제대상금액의 합계
      c139Amt := 0;
      c139Amt := strToFloat(C[139]);
      if strToFloat(C[139]) < 0 then
        errList.Add(errStr('C139', '특별세액공제_교육비_공제대상금액-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[139]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C139', '특별세액공제_교육비_공제대상금액-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[139]), C[7]) then
        errList.Add(errStr('C139', '특별세액공제_교육비_공제대상금액-3', mName, idNo));

form1.Memo1.Lines.Add('C139');
      //C140 특별세액공제_교육비_세액공제액 9(10)
      //1.[C140] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’일 때: [C140] ≠ 0 이면 오류
      //3.[C7] = ‘2’일 때: [C140] ≠ 0 이면 오류
      //4.[C140] > [C139] × 15% 이면 오류
      //5.[C140] > [C113] - [C119] 이면 오류
      if strToFloat(C[140]) < 0 then
        errList.Add(errStr('C140', '특별세액공제_교육비_세액공제액-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[140]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C140', '특별세액공제_교육비_세액공제액-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[140]), C[7]) then
        errList.Add(errStr('C140', '특별세액공제_교육비_세액공제액-3', mName, idNo))
      else if strToFloat(C[140]) > strToFloat(C[139]) * 0.15 then
        errList.Add(errStr('C140', '특별세액공제_교육비_세액공제액-4', mName, idNo))
      else if strToFloat(C[140]) > strToFloat(C[113]) - strToFloat(C[119]) then
        errList.Add(errStr('C140', '특별세액공제_교육비_세액공제액-5', mName, idNo));

form1.Memo1.Lines.Add('C140');
      //C141 -㉮특별세액공제_기부금_정치자금_10만원이하_공제대상금액 9(10)
      //1.[C141] < 0이면 오류
      //2.외국인 단일세율 적용([C11]=‘9’, [C9]=‘1’)인 경우:[C141] ≠ 0 이면 오류
      //3.비거주자([C7]=‘2’)일 때: [C141] ≠ 0 이면 오류
      //4.[C141] > 10만원이면 오류
      //N 5.[C141]+[C143] ≠ [H15]*) 이면 오류
      //*기부금 조정명세(H레코드) 중 2014년 이후 정치자금기부금 공제대상금액과 비교
      //오류기준 추가(2017.12.19) 6.[C141] > [C65] 이면 오류

      //오류기준 변경(2018.02.05) ▶ 5.[C141]+[C143] ≠ [H15]*) 이면 오류
      //*기부금 조정명세(H레코드) 중 정치자금기부금 해당 연도 공제금액과 비교
      c141Amt := 0;
      c141Amt := strToFloat(C[141]);

      if strToFloat(C[141]) < 0 then
        errList.Add(errStr('C141', '특별세액공제_기부금_정치자금_10만원이하_공제대상금액-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[141]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C141', '특별세액공제_기부금_정치자금_10만원이하_공제대상금액-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[141]), C[7]) then
        errList.Add(errStr('C141', '특별세액공제_기부금_정치자금_10만원이하_공제대상금액-3', mName, idNo))
      else if strToFloat(C[141]) > 100000 then
        errList.Add(errStr('C141', '특별세액공제_기부금_정치자금_10만원이하_공제대상금액-4', mName, idNo))
      else if strToFloat(C[141]) > strToFloat(C[65]) then
        errList.Add(errStr('C141', '특별세액공제_기부금_정치자금_10만원이하_공제대상금액-5', mName, idNo));

form1.Memo1.Lines.Add('C141');
      //C142 -㉮특별세액공제_기부금_정치자금_10만원이하_세액공제액 9(10)
      //1.[C142] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C142] ≠ 0 이면 오류
      //3.[C7] = ‘2’ 일 때: [C142] ≠ 0 이면 오류
      //4.[C142] > [C141] × 100 / 110 이면 오류
      //5.[C142] > 90,909원 이면 오류
      //6.[C142] > [C113-C119-C120-C122-C124-C126-C134-C136-C138-C140] 이면 오류
       
      cTempAmt0 := strToFloat(C[113]);
      while j >= 119 do
      begin
        //합계 : j in [113, 119, 120..140] 
        if j in [119, 120..140] then
        begin
          cTempAmt0 := cTempAmt0 - strToFloat(C[j]);
          
form1.Memo1.Lines.Add('1 ▶ ' + IntToStr(j) + ' ▶ ' + C[j]);
        end;
          
        //증가
        if j >= 120 then
          j := j + 2
        else
          j := j + 1;

        //종료
        if j > 140 then Break;
      end;
      
form1.Memo1.Lines.Add('cTempAmt0 ▶ ' + FloatToStr(cTempAmt0)); 
form1.Memo1.Lines.Add('C[142] ▶ ' + C[142]);     
        
      if strToFloat(C[142]) < 0 then
        errList.Add(errStr('C142', '특별세액공제_기부금_정치자금_10만원이하_세액공제액-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[142]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C142', '특별세액공제_기부금_정치자금_10만원이하_세액공제액-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[142]), C[7]) then
        errList.Add(errStr('C142', '특별세액공제_기부금_정치자금_10만원이하_세액공제액-3', mName, idNo))
      else if strToFloat(C[142]) > strToFloat(C[141]) * 100/110 then
        errList.Add(errStr('C142', '특별세액공제_기부금_정치자금_10만원이하_세액공제액-4', mName, idNo))
      else if strToFloat(C[142]) > 90909 then
        errList.Add(errStr('C142', '특별세액공제_기부금_정치자금_10만원이하_세액공제액-5', mName, idNo))
      else if strToFloat(C[142]) > cTempAmt0 then
        errList.Add(errStr('C142', '특별세액공제_기부금_정치자금_10만원이하_세액공제액-6', mName, idNo));

form1.Memo1.Lines.Add('C142');
      //C143 -㉮특별세액공제_기부금_정치자금_10만원초과_공제대상금액 9(11)
      //1.[C143] < 0이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C142] ≠ 0 이면 오류
      //3.[C7] = ‘2’ 일 때: [C142] ≠ 0 이면 오류
      //4.[C143] > [C65] 이면 오류
      //5.[C141]+[C143] ≠ [H15]*) 이면 오류
      //*기부금 조정명세(H레코드) 중 2014년 이후 정치자금기부금 공제대상금액과 비교

      //오류기준 변경 (2017.12.19) ▶ 4.[C143] > [C65] - [C141] 이면 오류
      //오류기준 변경(2018.02.05) ▶5.{[C141]+[C143]} ≠ [H15]*) 이면 오류
      //*기부금 조정명세(H레코드) 중 정치자금기부금 해당 연도 공제금액과 비
      c143Amt := 0;
      c143Amt := strToFloat(C[143]);

      if strToFloat(C[143]) < 0 then
        errList.Add(errStr('C143', '특별세액공제_기부금_정치자금_10만원초과_공제대상금액-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[143]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C143', '특별세액공제_기부금_정치자금_10만원초과_공제대상금액-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[143]), C[7]) then
        errList.Add(errStr('C143', '특별세액공제_기부금_정치자금_10만원초과_공제대상금액-3', mName, idNo))
      else if strToFloat(C[143]) > strToFloat(C[65]) - strToFloat(C[141]) then
        errList.Add(errStr('C143', '특별세액공제_기부금_정치자금_10만원초과_공제대상금액-4', mName, idNo));

form1.Memo1.Lines.Add('C143');
      //C144 -㉮특별세액공제_기부금_정치자금_10만원초과_세액공제액 9(10)
      //1.[C144] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C144] ≠ 0 이면 오류
      //3.[C7] = ‘2’ 일 때: [C144] ≠ 0 이면 오류
      //4.[C141+C143]<=3천만원,[C141+C143]>0일때: [C144] > [C143] × 15% 이면 오류
      //5.[C141+C143]>3천만원일때:[C144]>(3천만원-[C141])×15% + ([C141+C143]-3천만원) × 25% 이면 오류
      //6.[C144] > [C113-C119-C120-C122-C124-C126-C134-C136-C138-C140-C142] 이면 오류
      cTempAmt := 0;
      cTempAmt0 := cTempAmt0 - strToFloat(C[142]);

      if strToFloat(C[141]) + strToFloat(C[143]) > 30000000 then
      begin
        cTempAmt := (30000000 - strToFloat(C[141])) * 0.15 +
                    ((strToFloat(C[141]) + strToFloat(C[143])) - 30000000) * 0.25;
      end
      else
      begin
        if strToFloat(C[141]) + strToFloat(C[143]) > 0 then
          cTempAmt := strToFloat(C[143]) * 0.15;
      end;

      if strToFloat(C[144]) < 0 then
        errList.Add(errStr('C144', '특별세액공제_기부금_정치자금_10만원초과_세액공제액-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[144]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C144', '특별세액공제_기부금_정치자금_10만원초과_세액공제액-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[144]), C[7]) then
        errList.Add(errStr('C144', '특별세액공제_기부금_정치자금_10만원초과_세액공제액-3', mName, idNo))
      else if strToFloat(C[144]) > cTempAmt then
        errList.Add(errStr('C144', '특별세액공제_기부금_정치자금_10만원초과_세액공제액-4', mName, idNo))
      else if strToFloat(C[144]) > cTempAmt0 then
        errList.Add(errStr('C144', '특별세액공제_기부금_정치자금_10만원초과_세액공제액-5', mName, idNo));

form1.Memo1.Lines.Add('C144');
      //C145 -㉯특별세액공제_기부금_법정기부금_공제대상금액 9(11)
      //-공제한도: 근로소득금액?정치자금기부금 공제대상금액
      //1.[C145] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C145] ≠ 0 이면 오류
      //3.[C7] = ‘2’ 일 때: [C145] ≠ 0 이면 오류
      //4.[C145] > [C65] - [C141] - [C143] 이면 오류
      //N 5.[C145] ≠ [H15]*) 이면 오류
      //*기부금 조정명세(H레코드) 중 2014년 이후 법정기부금 공제대상금액과 비교

      //오류기준 변경(2018.02.05) ▶  5.[C145] ≠ [H15]*) 이면 오류
      //*기부금 조정명세(H레코드) 중 2014년 이후 법정기부금 해당 연도 공제금액과 비교

      c145Amt := 0;
      c145Amt := strToFloat(C[145]);

      if strToFloat(C[145]) < 0 then
        errList.Add(errStr('C145', '특별세액공제_기부금_법정기부금_공제대상금액-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[145]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C145', '특별세액공제_기부금_법정기부금_공제대상금액-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[145]), C[7]) then
        errList.Add(errStr('C145', '특별세액공제_기부금_법정기부금_공제대상금액-3', mName, idNo))
      else if strToFloat(C[145]) > strToFloat(C[65]) - strToFloat(C[141]) - strToFloat(C[143]) then
        errList.Add(errStr('C145', '특별세액공제_기부금_법정기부금_공제대상금액-4', mName, idNo));

form1.Memo1.Lines.Add('C145');
      //C146 -㉯특별세액공제_기부금_법정기부금_세액공제액 9(10)
      //1.[C146] < 0 이면 오류
      //2.외국인 단일세율 적용([C11]=‘9’, [C9]=‘1’)인 경우:[C146] ≠ 0 이면 오류
      //3.비거주자([C7]=‘2’) 일 때: [C146] ≠ 0 이면 오류
      //오류기준 변경(17.11.08) ▶
      //4.[C146] > MIN[2천만원, [C145]] × 15% + MAX[0, ([C145] - 2천만원)] × 30%
      //5.[C146] > [C113-C119-C120-C122-C124-C126-C134-C136-C138-C140-C153-C154-C157-C142-C144] 이면 오류
      cTempAmt1 := 0; cTempLimitAmt := 0;
      cTempMinAmt := 0; cTempMaxAmt := 0;

      cTempAmt0 := cTempAmt0 - strToFloat(C[144]);

      //4-1) 공제대상 합계액
      cTempAmt1 := strToFloat(C[145]);

      //4-2) 기부금세액공제액 - MIN[2천만원, [C145]] × 15%MIN[2천만원, (1)]
      if cTempAmt1 > 20000000 then
        cTempMinAmt := 20000000 * 0.15
      else
        cTempMinAmt := cTempAmt1 * 0.15;
      //4-2) 기부금세액공제액 - Max[0,(1)–2천만원)]MAX[0, ([C145] - 2천만원)]
      if cTempAmt1 - 20000000 > 0 then cTempMaxAmt := (cTempAmt1 - 20000000) * 0.3;

      cTempLimitAmt := cTempMinAmt + cTempMaxAmt;

      if strToFloat(C[146]) < 0 then
        errList.Add(errStr('C146', '특별세액공제_기부금_법정기부금_세액공제액', mName, idNo))
      else if getErrYn('2', strToFloat(C[146]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C146', '특별세액공제_기부금_법정기부금_세액공제액', mName, idNo))
      else if getErrYn('3', strToFloat(C[146]), C[7]) then
        errList.Add(errStr('C146', '특별세액공제_기부금_법정기부금_세액공제액', mName, idNo))
      else if strToFloat(C[146]) > cTempLimitAmt then
        errList.Add(errStr('C146', '특별세액공제_기부금_법정기부금_세액공제액', mName, idNo))
      else if strToFloat(C[146]) > cTempAmt0 then
        errList.Add(errStr('C146', '특별세액공제_기부금_법정기부금_세액공제액', mName, idNo));

form1.Memo1.Lines.Add('C146');

      //C147 -㉰특별세액공제_기부금_우리사주조합기부금_공제대상금액 9(11)
      //-공제한도: (근로소득금액 - 정치자금기부금 공제대상금액 ? 법정기부금(14년 이후 이월분 포함) 공제대상금액) × 30%
      //1.[C147] < 0이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C149] ≠ 0 이면 오류
      //3.[C7] = ‘2’ 일 때: [C149] ≠ 0 이면 오류
      //4.[C147] > [C65–C141–C143–C145]×30% 이면 오류
      //오류기준 변경(2018.02.05) ▶  5.[C145] ≠ [H15]*) 이면 오류
      //*기부금 조정명세(H레코드) 중 우리사주조합기부금 해당 연도 공제금액과 비교

      c147Amt := 0; cTempAmt := 0;
      c147Amt := strToFloat(C[147]);
      cTempAmt := (strToFloat(C[65]) - strToFloat(C[141]) - strToFloat(C[143]) - strToFloat(C[145])) * 0.3;

      if strToFloat(C[147]) < 0 then
        errList.Add(errStr('C147', '특별세액공제_기부금_우리사주조합기부금_공제대상금액-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[147]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C147', '특별세액공제_기부금_우리사주조합기부금_공제대상금액-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[147]), C[7]) then
        errList.Add(errStr('C147', '특별세액공제_기부금_우리사주조합기부금_공제대상금액-3', mName, idNo))
      else if strToFloat(C[147]) > cTempAmt then
        errList.Add(errStr('C147', '특별세액공제_기부금_우리사주조합기부금_공제대상금액-4', mName, idNo));

form1.Memo1.Lines.Add('C147');
      //C148 -㉰특별세액공제_기부금_우리사주조합기부금_세액공제액 9(10)
      //1.[C148] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C148] ≠ 0 이면 오류
      //3.[C7] = ‘2’ 일 때: [C148] ≠ 0 이면 오류
      //오류기준 변경(17.11.08) ▶
      //4.[C148] > 우리사주조합기부금 세액공제액 계산값*)
      //*우리사주조합기부금 세액공제액 계산값
      // ･[C145]+[C147]≦2천만원 이면 [C147] × 15%
      // ･[C145]+[C147]>2천만원, [C145]>2천만원 이면 [C147] × 30%
      // ･[C145]+[C147]>2천만원, [C145]≦2천만원 이면
      //  (2천만원-[C145]) × 15% + {([C145]+[C147])-2천만원} × 30%
      //5.[C148] > [C113-C119-C120-C122-C124-C126-C134-C136-C138-C140-C153-C154-C157-C142-C144-C146-C152] 이면 오류

      cTempLimitAmt := 0;
      cTempAmt0 := cTempAmt0 - strToFloat(C[146]) - strToFloat(C[152]);
      cTempAmt1 := cTempAmt1 + strToFloat(C[147]);

      if cTempAmt1 <= 20000000 then
      begin
        cTempLimitAmt := strToFloat(C[147]) * 0.15
      end
      else
      begin
        if strToFloat(C[145]) > 20000000 then
          cTempLimitAmt := strToFloat(C[147]) * 0.3
        else
        begin
          cTempLimitAmt := (20000000 - strToFloat(C[145])) * 0.15 + (cTempAmt1 - 20000000) * 0.3
        end;
      end;

      if strToFloat(C[148]) < 0 then
        errList.Add(errStr('C148', '특별세액공제_기부금_우리사주조합기부금_세액공제액', mName, idNo))
      else if getErrYn('2', strToFloat(C[148]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C148', '특별세액공제_기부금_우리사주조합기부금_세액공제액', mName, idNo))
      else if getErrYn('3', strToFloat(C[148]), C[7]) then
        errList.Add(errStr('C148', '특별세액공제_기부금_우리사주조합기부금_세액공제액', mName, idNo))
      else if strToFloat(C[148]) > cTempLimitAmt then
        errList.Add(errStr('C148', '특별세액공제_기부금_우리사주조합기부금_세액공제액', mName, idNo))
      else if strToFloat(C[148]) > cTempAmt0 then
        errList.Add(errStr('C148', '특별세액공제_기부금_우리사주조합기부금_세액공제액', mName, idNo));

form1.Memo1.Lines.Add('C148');
      //C149-㉱특별세액공제_기부금_지정기부금_종교단체외_공제대상금액 9(11)
      //1.[C149] < 0이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C149] ≠ 0 이면 오류
      //3.[C7] = ‘2’ 일 때: [C149] ≠ 0 이면 오류
      //4.[C149]>㉠×30% 이면 오류(단, ㉠=[C65?C141?C143?C145?C147])
      //N 5.[C149] ≠ [H15]*) 이면 오류
      //*기부금 조정명세(H레코드) 중 2014년 이후 지정기부금_종교단체외 공제대상금액과 비교

      //오류기준 변경(18.02.05) ▶ 5.[C149] ≠ [H15]*) 이면 오류
      //*기부금 조정명세(H레코드) 중 2014년 이후 지정기부금_종교단체외 해당 연도 공제금액과 비교

      c149Amt := 0; cTempAmt := 0;
      c149Amt := strToFloat(C[149]);
      cTempAmt := (strToFloat(C[65]) - strToFloat(C[141]) - strToFloat(C[143]) - strToFloat(C[145]) - strToFloat(C[147])) * 0.3;

      if strToFloat(C[149]) < 0 then
        errList.Add(errStr('C149', '특별세액공제_기부금_지정기부금_종교단체외_공제대상금액-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[149]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C149', '특별세액공제_기부금_지정기부금_종교단체외_공제대상금액-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[149]), C[7]) then
        errList.Add(errStr('C149', '특별세액공제_기부금_지정기부금_종교단체외_공제대상금액-3', mName, idNo))
      else if strToFloat(C[149]) > cTempAmt then
        errList.Add(errStr('C149', '특별세액공제_기부금_지정기부금_종교단체외_공제대상금액-4', mName, idNo));

form1.Memo1.Lines.Add('C149');
      //C150 -㉱특별세액공제_기부금_지정기부금_종교단체외_세액공제액 9(10)
      //1.[C150] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C150] ≠ 0 이면 오류
      //3.비거주자([C7]=‘2’) 일 때: [C150] ≠ 0 이면 오류
      //4.[C150] > 종교단체외 지정기부금 세액공제액 계산값*)
      //*종교단체외 지정기부금 세액공제액 계산값
      // ･ [C145]+[C147]+[C149]≦2천만원 이면 [C149] × 15%
      // ･ [C145]+[C147]+[C149]>2천만원, [C145]+[C147]>2천만원 이면 [C149] × 30%
      // ･ [C145]+[C147]+[C149]>2천만원, [C145]+[C147]≦2천만원 이면
      //   [2천만원-([C145]+[C147])] × 15% + [([C145]+[C147]+[C149])-2천만원] × 30%
      //5.[C150] > [C113-C119-C120-C122-C124-C126-C134-C136-C138-C140-C153-C154-C157-C142-C144-C146-C148] 이면 오류

      cTempLimitAmt := 0;
      cTempAmt0 := cTempAmt0 - strToFloat(C[148]);
      cTempAmt1 := cTempAmt1 + strToFloat(C[149]);

      if cTempAmt1 <= 20000000 then
      begin
        cTempLimitAmt := strToFloat(C[149]) * 0.15
      end
      else
      begin
        if strToFloat(C[145]) + strToFloat(C[147]) > 20000000 then
          cTempLimitAmt := strToFloat(C[149]) * 0.3
        else
        begin
          cTempLimitAmt := (20000000 - (strToFloat(C[145]) + strToFloat(C[147]))) * 0.15 + (cTempAmt1 - 20000000) * 0.3
        end;
      end;

      if strToFloat(Copy(C[150], 1, 10)) < 0 then
        errList.Add(errStr('C150', '특별세액공제_기부금_지정기부금_종교단체외_세액공제액', mName, idNo))
      else if getErrYn('2', strToFloat(Copy(C[150], 1, 10)), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C150', '특별세액공제_기부금_지정기부금_종교단체외_세액공제액', mName, idNo))
      else if getErrYn('3', strToFloat(Copy(C[150], 1, 10)), C[7]) then
        errList.Add(errStr('C150', '특별세액공제_기부금_지정기부금_종교단체외_세액공제액', mName, idNo))
      else if strToFloat(Copy(C[150], 1, 10)) > cTempLimitAmt then
        errList.Add(errStr('C150', '특별세액공제_기부금_지정기부금_종교단체외_세액공제액', mName, idNo))
      else if strToFloat(Copy(C[150], 1, 10)) > cTempAmt0 then
        errList.Add(errStr('C150', '특별세액공제_기부금_지정기부금_종교단체외_세액공제액', mName, idNo));

form1.Memo1.Lines.Add('C150');
      //C150ⓐ -㉲특별세액공제_기부금_지정기부금_종교단체_공제대상금액
      //1.[C150ⓐ] < 0이면 오류
      //2.외국인 단일세율 적용([C11]=‘9’, [C9]=‘1’)인 경우:[C150ⓐ] ≠ 0 이면 오류
      //3.[C7] = ‘2’ 일 때: [C150ⓐ] ≠ 0 이면 오류
      //4.[C150ⓐ]>㉠×30%-[C149] 이면 오류(단, ㉠=[C65?C141?C143?C145?C147])
      //오류기준 변경(18.02.05) ▶
      //5.[C150ⓐ] ≠ [H15]*) 이면 오류
      //*기부금 조정명세(H레코드) 중 2014년 이후 지정기부금_종교단체 해당 연도 공제금액과 비교

      c150aAmt := 0; cTempAmt := 0;
      c150aAmt := strToFloat(Copy(C[150], 11, 11));
      cTempAmt := (strToFloat(C[65]) - strToFloat(C[141]) - strToFloat(C[143]) - strToFloat(C[145]) - strToFloat(C[147])) * 0.3 - strToFloat(C[149]);

      if c150aAmt < 0 then
        errList.Add(errStr('C150(a)', '특별세액공제_기부금_지정기부금_종교단체_공제대상금액', mName, idNo))
      else if getErrYn('2', c150aAmt, cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C150(a)', '특별세액공제_기부금_지정기부금_종교단체_공제대상금액', mName, idNo))
      else if getErrYn('3', c150aAmt, C[7]) then
        errList.Add(errStr('C150(a)', '특별세액공제_기부금_지정기부금_종교단체_공제대상금액', mName, idNo))
      else if c150aAmt > cTempAmt then
        errList.Add(errStr('C150(a)', '특별세액공제_기부금_지정기부금_종교단체_공제대상금액', mName, idNo));

form1.Memo1.Lines.Add('C150-a');

      //C150ⓑ -㉲특별세액공제_기부금_지정기부금_종교단체_세액공제액 9(10)
      //1.[C150ⓑ] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C150ⓑ] ≠ 0 이면 오류
      //3.[C7] = ‘2’ 일 때: [C150ⓑ] ≠ 0 이면 오류
      //4.[C150ⓑ] > 종교단체 지정기부금 세액공제액 계산값*)
      //*종교단체 지정기부금 세액공제액 계산값
      // ･[C145]+[C147]+[C149]+[C150ⓐ]≦2천만원 이면 [C150ⓐ]× 15%
      // ･[C145]+[C147]+[C149]+[C150ⓐ]>2천만원, [C145]+[C147]+[C149]
      //   >2천만원 이면 [C150ⓐ] × 30%
      // ･[C145]+[C147]+[C149]+[C150ⓐ]>2천만원, [C145]+[C147]+[C149]≦2천만원 이면
      //  [2천만원-([C145]+[C147]+[C149])] × 15% + [([C145]+[C147]+[C149]+[C150ⓐ])-2천만원] × 30%
      //5.[C150ⓑ] > [C113-C119-C120-C122-C124-C126-C134-C136-C138-C140-C153-C154-C157-C142-C144-C146-C148-C150] 이면 오류

      cTempLimitAmt := 0;
      cTempAmt0 := cTempAmt0 - strToFloat(Copy(C[150], 1, 10));
      cTempAmt1 := cTempAmt1 + c150aAmt;

      if cTempAmt1 <= 20000000 then
      begin
        cTempLimitAmt := c150aAmt * 0.15
      end
      else
      begin
        if strToFloat(C[145]) + strToFloat(C[147]) + strToFloat(C[149]) > 20000000 then
          cTempLimitAmt := c150aAmt * 0.3
        else
        begin
          cTempLimitAmt := (20000000 - (strToFloat(C[145]) + strToFloat(C[147]) + strToFloat(C[149]))) * 0.15
                          + (cTempAmt1 - 20000000) * 0.3
        end;
      end;

      if strToFloat(Copy(C[150], 22, 10)) < 0 then
        errList.Add(errStr('C150(b)', '특별세액공제_기부금_지정기부금_종교단체_세액공제액', mName, idNo))
      else if getErrYn('2', strToFloat(Copy(C[150], 22, 10)), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C150(b)', '특별세액공제_기부금_지정기부금_종교단체_세액공제액', mName, idNo))
      else if getErrYn('3', strToFloat(Copy(C[150], 22, 10)), C[7]) then
        errList.Add(errStr('C150(b)', '특별세액공제_기부금_지정기부금_종교단체_세액공제액', mName, idNo))
      else if strToFloat(Copy(C[150], 22, 10)) > cTempLimitAmt then
        errList.Add(errStr('C150(b)', '특별세액공제_기부금_지정기부금_종교단체_세액공제액', mName, idNo))
      else if strToFloat(Copy(C[150], 22, 10)) > cTempAmt0 then
        errList.Add(errStr('C150(b)', '특별세액공제_기부금_지정기부금_종교단체_세액공제액', mName, idNo));

form1.Memo1.Lines.Add('C150-b');
      //C151 특별세액공제계 9(10)
      //1.[C151] < 0 이면 오류
      //2.외국인 단일세율 적용([C11]=‘9’, [C9]=‘1’)인 경우:[C151] ≠ 0 이면 오류
      //3.비거주자([C7]=‘2’)일 때: [C151] ≠ 0 이면 오류
      //4.[C151]≠[C134+C136+C138+C140+C142+C144+C146+C148+C150+C150ⓑ] 이면 오류

      //델파이 for문에서 count1에 값을 대입하면 아래의 오류메세지가 발생한다.
      //[Error] Unit1.pas(36): Assignment to FOR-Loop variable ‘count1’
      cTempAmt := 0;

      if strToFloat(C[151]) < 0 then
        errList.Add(errStr('C151', '특별세액공제계', mName, idNo))
      else if getErrYn('2', strToFloat(C[151]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C151', '특별세액공제계', mName, idNo))
      else if getErrYn('3', strToFloat(C[151]), C[7]) then
        errList.Add(errStr('C151', '특별세액공제계', mName, idNo))
      else
      begin
        j := 134;
        while j >= 134 do
        begin
          //합계
          if j = 150 then
          begin
            cTempAmt := cTempAmt + strToFloat(Copy(C[150], 1, 10)) + strToFloat(Copy(C[150], 22, 10));
          end
          else
            cTempAmt := cTempAmt + strToFloat(C[j]);

          //증가
          j := j + 2;

          //종료
          if j > 150 then Break;
        end;

        if strToFloat(C[151]) > cTempAmt then errList.Add(errStr('C151', '특별세액공제계', mName, idNo));
      end;

form1.Memo1.Lines.Add('C151');
      //C152 표준세액공제 9(10)
      //1.[C152] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C152] ≠ 0 이면 오류
      //3.[C7] = ‘2’ 일 때: [C152] ≠ 0 이면 오류
      //4.[C152] > 13만원 이면 오류
      //5.[C152] <= 13만원 and [C152] > 0 일때
      //①[C81+∼+C94] ≠ 0이면 오류
      //②[C133+∼+C140+C145+C146+C149+∼+C150ⓑ]≠0이면 오류
      //③[C156 + C157] ≠ 0 이면 오류
      cTempAmt := 0; cTempAmt0 := 0; cTempAmt1 := 0;

      if strToFloat(C[152]) < 0 then
        errList.Add(errStr('C152', '표준세액공제', mName, idNo))
      else if getErrYn('2', strToFloat(C[152]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C152', '표준세액공제', mName, idNo))
      else if getErrYn('3', strToFloat(C[152]), C[7]) then
        errList.Add(errStr('C152', '표준세액공제', mName, idNo))
      else
      begin
        if strToFloat(C[152]) > 130000 then
          errList.Add(errStr('C152', '표준세액공제', mName, idNo))
        else
        begin
          if strToFloat(C[152]) > 0 then
          begin
            for j := 81 to 157 do
            begin
              if j in [81..94] then
                cTempAmt := cTempAmt + strToFloat(C[j]);

              if j in [133..150] then
              begin
                if j = 150 then
                begin
                  cTempAmt0 := cTempAmt0
                              + strToFloat(Copy(C[150], 1, 10))
                              + strToFloat(Copy(C[150], 11, 11))
                              + strToFloat(Copy(C[150], 22, 10));
                end
                else
                  cTempAmt0 := cTempAmt0 + strToFloat(C[j]);
              end;

              if j in [156, 157] then
                cTempAmt1 := cTempAmt1 + strToFloat(C[j]);
            end;

            if cTempAmt <> 0 then errList.Add(errStr('C152', '표준세액공제', mName, idNo));
            if cTempAmt0 <> 0 then errList.Add(errStr('C152', '표준세액공제', mName, idNo));
            if cTempAmt1 <> 0 then errList.Add(errStr('C152', '표준세액공제', mName, idNo));
          end;
        end;
      end;

form1.Memo1.Lines.Add('C152');
      //C153 납세조합공제 9(10)
      //1.[C153] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C153] ≠ 0 이면 오류
      //N 3.주(현)의 원천징수의무자([C5])가 납세조합이 아니고, 종(전)의 납세조합여부([D8])=‘2’ 일 때: [C153] ≠ 0이면 오류
      //N 4.납세조합에 의하여 원천징수된 근로소득에 대한 종합소득산출세액의 10% 초과여부 확인
      if strToFloat(C[153]) < 0 then
        errList.Add(errStr('C153', '납세조합공제', mName, idNo))
      else if getErrYn('2', strToFloat(C[153]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C153', '납세조합공제', mName, idNo));

form1.Memo1.Lines.Add('C153');
      //C154 주택차입금 9(10)
      //1.[C154] < 0이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C154] ≠ 0 이면 오류
      //3.[C7] = ‘2’ 일 때: [C154] ≠ 0 이면 오류
      //4.[C154] > 0 일 때: [C83+C84]+[C85+∼+C93]+[C100+∼+C102] ≠ 0 이면 오류
      cTempAmt := 0;

      if strToFloat(C[154]) < 0 then
        errList.Add(errStr('C154', '주택차입금', mName, idNo))
      else if getErrYn('2', strToFloat(C[154]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C154', '주택차입금', mName, idNo))
      else if getErrYn('3', strToFloat(C[154]), C[7]) then
        errList.Add(errStr('C154', '주택차입금', mName, idNo))
      else
      begin
        //
        if strToFloat(C[154]) > 0 then
        begin
          for j := 83 to 102 do
          begin
            if not (j in [94..99]) then
              cTempAmt := cTempAmt + strToFloat(C[j]);
          end;

          if strToFloat(C[154]) > cTempAmt then
            errList.Add(errStr('C154', '주택차입금', mName, idNo));
        end;
      end;

form1.Memo1.Lines.Add('C154');

      //C155 외국납부 9(10)
      //1.[C155] < 0이면 오류
      //2.외국인 단일세율 적용([C11]=‘9’, [C9]=‘1’)인 경우:[C155] ≠ 0 이면 오류
      //3.비거주자([C7]=‘2’)일 때: [C155] ≠ 0 이면 오류
      if strToFloat(C[155]) < 0 then
        errList.Add(errStr('C155', '외국납부', mName, idNo))
      else if getErrYn('2', strToFloat(C[155]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C155', '외국납부', mName, idNo))
      else if getErrYn('3', strToFloat(C[155]), C[7]) then
        errList.Add(errStr('C155', '외국납부', mName, idNo));

form1.Memo1.Lines.Add('C155');

      //C156 월세세액공제대상금액 9(10)
      //-공제한도 : 750만원
      //1.[C156] < 0이면 오류
      //2.[C11]=‘9’, [C9]=‘1’ 일 때: [C156] ≠ 0 이면 오류
      //3.[C7] = ‘2’ 일 때: [C156] ≠ 0 이면 오류
      //4.[C63] > 7,000만원 일 때: [C156] ≠ 0 이면 오류
      //N 5.[C156]>[월세·거주자주택임차차입금소득명세(G레코드)의 연간 월세액 합계] 이면 오류
      //6.[C156] > 750만원 이면 오류
      if strToFloat(C[156]) < 0 then
        errList.Add(errStr('C156', '월세세액공제대상금액', mName, idNo))
      else if getErrYn('2', strToFloat(C[156]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C156', '월세세액공제대상금액', mName, idNo))
      else if getErrYn('3', strToFloat(C[156]), C[7]) then
        errList.Add(errStr('C156', '월세세액공제대상금액', mName, idNo))
      else if (StrToFloat(C[63]) > 70000000) and (strToFloat(C[156]) <> 0) then
        errList.Add(errStr('C156', '월세세액공제대상금액', mName, idNo))
      else if strToFloat(C[156]) > 750000 then
        errList.Add(errStr('C156', '월세세액공제대상금액', mName, idNo));

form1.Memo1.Lines.Add('C156');
      //C157 월세세액공제액 9(8)
      //세액공제 한도 : 75만원
      //1.[C157] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’: [C157] ≠ 0 이면 오류
      //3.[C7] = ‘2’ 일 때: [C157] ≠ 0 이면 오류
      //4.[C157] > [C156] × 10% 이면 오류
      //5.[C157] > 75만원 이면 오류
      //6.[C157] > [C113 - C119] 이면 오류
      if strToFloat(C[157]) < 0 then
        errList.Add(errStr('C157', '월세세액공제액-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[157]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C157', '월세세액공제액-2', mName, idNo))
      else if getErrYn('3', strToFloat(C[157]), C[7]) then
        errList.Add(errStr('C157', '월세세액공제액-3', mName, idNo))
      else if strToFloat(C[157]) > (strToFloat(C[156]) * 0.1) then
        errList.Add(errStr('C157', '월세세액공제액-4', mName, idNo))
      else if strToFloat(C[157]) > 750000 then
        errList.Add(errStr('C157', '월세세액공제액-5', mName, idNo))
      else if strToFloat(C[157]) > strToFloat(C[113]) - strToFloat(C[119]) then
        errList.Add(errStr('C157', '월세세액공제액-6', mName, idNo));

form1.Memo1.Lines.Add('C157');
      //C158 세액공제계 9(10)
      //1.[C158] < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’: [C158] ≠ 0 이면 오류
      //3.[C158]≠[C120+C122+C124+C126+C128+C130+C132+C134+C136+C138+C140+C142+C144+C146+C148+C150+C150ⓑ+C152+C153+C154+C155+C157] 이면 오류
      //4.[C158] > [C113] - [C119] 이면 오류

      if strToFloat(C[158]) < 0 then
        errList.Add(errStr('C158', '세액공제계-1', mName, idNo))
      else if getErrYn('2', strToFloat(C[158]), cForeignAb, cForeignTaxYn) then
        errList.Add(errStr('C158', '세액공제계-2', mName, idNo))
      else
      begin
        cTempAmt := 0;
        j := 120;
        while j >= 120 do
        begin
          //합계
          if j in [120..148, 152..155, 157] then
            cTempAmt := cTempAmt + strToFloat(C[j])
          else if j = 150 then
            cTempAmt := cTempAmt + strToFloat(Copy(C[150], 1, 10)) + strToFloat(Copy(C[150], 22, 10));

          //증가
          if j in [120..148] then
            j := j + 2
          else
            j := j + 1;

          //종료
          if j > 157 then Break;
        end;

        if strToFloat(C[158]) <> cTempAmt then
          errList.Add(errStr('C158', '세액공제계-3', mName, idNo))
        else if strToFloat(C[158]) > strToFloat(C[113]) - strToFloat(C[119]) then
          errList.Add(errStr('C158', '세액공제계-4', mName, idNo));
      end;

form1.Memo1.Lines.Add('C158');

      //【결정세액】
      //C159 소득세 9(10)
      //1.[C159] < 0 이면 오류
      //2.[C159] ≠ [C113-C119-C158] 이면 오류
      cSumIncomeTaxAmt := cSumIncomeTaxAmt + strToFloat(C[159]);
      if strToFloat(C[159]) < 0 then
        errList.Add(errStr('C159', '소득세', mName, idNo))
      else if strToFloat(C[159]) <> strToFloat(C[113]) - strToFloat(C[119]) - strToFloat(C[158]) then
        errList.Add(errStr('C159', '소득세', mName, idNo));

form1.Memo1.Lines.Add('C159');
      //C160 지방소득세 9(10)
      //1.[C160] < 0 이면 오류
      //2.[C160] ≠ [C159] × 10% 이면 오류
      cSumLocalTaxAmt := cSumLocalTaxAmt + strToFloat(C[160]);
      if strToFloat(C[160]) < 0 then
        errList.Add(errStr('C160', '지방소득세-1', mName, idNo))
      else if strToFloat(C[160]) <> Trunc(strToFloat(C[159]) * 0.1) then
        errList.Add(errStr('C160', '지방소득세-2', mName, idNo));

form1.Memo1.Lines.Add('C160');
      //C161 농특세 9(10)
      //1.[C161] < 0이면 오류
      //2.[C154] > 0 일 때: [C161] = 0 이면 오류
      //3.[C161] ≠ [C154] × 20% 이면 오류
      cWithHoldFarmTaxAmt := cWithHoldFarmTaxAmt + strToFloat(C[161]);
      if strToFloat(C[161]) < 0 then
        errList.Add(errStr('C161', '농특세', mName, idNo))
      else if (strToFloat(C[154]) > 0) and (strToFloat(C[161]) = 0) then
        errList.Add(errStr('C161', '농특세', mName, idNo))
      else if strToFloat(C[161]) <> strToFloat(C[154]) * 0.2 then
        errList.Add(errStr('C161', '농특세', mName, idNo));

form1.Memo1.Lines.Add('C161');
      //【기납부세액 - 주(현)근무지】
      //C162 소득세 9(10)
      //1.[C162] < 0 이면 오류
      //2.[C29]+[C60]+[C61] = 0 일 때: [C162] ≠ 0 이면 오류
      cTempAmt := 0;
      cTempAmt := strToFloat(C[29]) + strToFloat(C[60]) + strToFloat(C[61]);

      if strToFloat(C[162]) < 0 then
        errList.Add(errStr('C162', '농특세', mName, idNo))
      else if (cTempAmt = 0) and (strToFloat(C[162]) <> 0) then
        errList.Add(errStr('C162', '농특세', mName, idNo));

form1.Memo1.Lines.Add('C162');
      //C163 지방소득세 9(10)
      //1.[C163] < 0 이면 오류
      //2.[C29]+[C60]+[C61] = 0 일 때: [C163] ≠ 0 이면 오류
      if strToFloat(C[163]) < 0 then
        errList.Add(errStr('C163', '지방소득세', mName, idNo))
      else if (cTempAmt = 0) and (strToFloat(C[163]) <> 0) then
        errList.Add(errStr('C163', '지방소득세', mName, idNo));

form1.Memo1.Lines.Add('C163');
      //C164 농특세 9(10)
      //1.[C164] < 0 이면 오류
      //2.[C29]+[C60]+[C61] = 0 일 때: [C164] ≠ 0 이면 오류
      if strToFloat(C[164]) < 0 then
        errList.Add(errStr('C164', '농특세', mName, idNo))
      else if (cTempAmt = 0) and (strToFloat(C[164]) <> 0) then
        errList.Add(errStr('C164', '농특세', mName, idNo));

form1.Memo1.Lines.Add('C164');

      //【납부특례세액】
      //C165 소득세     9(10)
      //C166 지방소득세 9(10)
      //C167 농특세     9(10)
      cExIncomeTaxAmt := strToFloat(C[165]);
      cExLocalTaxAmt := strToFloat(C[166]);
      cExWithholdFarmTaxAmt := strToFloat(C[167]);

form1.Memo1.Lines.Add('C167');

      //【차감징수세액】
      // -차감징수세액은 결정세액-주(현)근무지기납부세액+종(전)근무지결정세액의합-납부특레세액소득세로 계산한 후 10원 미만 단수절사
      // -차감징수세액 계산값이 0 이상 1,000원 미만일 경우 ‘0’을 기재(소액부징수)
      // -부호(0 또는 1)와 계산금액의 절대값으로 구분하여 기재
      // -부호: 계산값이 0 이상인 경우 ‘0’, 계산값이 0 미만인 경우 ‘1’ 기재
      // ex)차감징수세액 계산값  12,345: 10원미만 단수절사 12,340 ⇒ (양수) 부호‘0’, 금액‘12340’
      // 기재차감징수세액 계산값 -12,345: 10원미만 단수절사 -12,340 ⇒ (음수) 부호‘1’, 금액‘12340’기재

      //C168, C169, C170 부호가 있으므로 값을 설정
      //C168 소득세 9(1) 9(10)
      //계산값=[C159]-[C162]-[모든종(전)의[D56]의합] - [C165]
      //C169 지방소득세 9(1) 9(10)
      //계산값=[C160]-[C163]-[모든종(전)의[D57]의합] - [C166]
      //C170 농특세 9(1) 9(10)
      //C170 계산값=[C161]-[C164]-[모든종(전)의[D58]의합] - [C167]

      cCalIncomeTaxAmt := 0; cIncomeTaxAmt := 0;
      cCalLocalTaxAmt := 0; cLocalTaxAmt := 0;
      cCalWithholdFarmTaxAmt := 0; cWithholdFarmTamAmt := 0;

      if Copy(C[168], 1, 1) = '0' then
        cIncomeTaxAmt := strToFloat(Copy(C[168], 2, 10))
      else if Copy(C[168], 1, 1) = '1' then
        cIncomeTaxAmt := strToFloat(Concat('-', Copy(C[168], 2, 10)));

      if Copy(C[169], 1, 1) = '0' then
        cLocalTaxAmt := strToFloat(Copy(C[169], 2, 10))
      else if Copy(C[169], 1, 1) = '1' then
        cLocalTaxAmt := strToFloat(Concat('-', Copy(C[169], 2, 10)));

      if Copy(C[170], 1, 1) = '0' then
        cWithholdFarmTamAmt := strToFloat(Copy(C[170], 2, 10))
      else if Copy(C[170], 1, 1) = '1' then
        cWithholdFarmTamAmt := strToFloat(Concat('-', Copy(C[170], 2, 10)));

      cCalIncomeTaxAmt := strToFloat(C[159]) - strToFloat(C[162]) - strToFloat(C[165]);
      cCalLocalTaxAmt := strToFloat(C[159]) - strToFloat(C[162]) - strToFloat(C[165]);
      cCalWithholdFarmTaxAmt := strToFloat(C[161]) - strToFloat(C[164]) - strToFloat(C[167]);

form1.Memo1.Lines.Add('C170');
      //C171 ③-1 사업자단위과세자 여부 X(1)
      //‘1’, ‘2’가 아니면 오류
      if Pos(C[171], '[1][2]') = 0 then
        errList.Add(errStr('C171', '사업자단위과세자 여부', mName, idNo));

form1.Memo1.Lines.Add('C171');
      //C172 ③-2 종사업장 일련번호 X(4)
      //1.사업자단위과세자 여부가 여인 경우[C171]=‘1’ 공란이면 오류
      //오류기준 변경(17.11.20) ▶ 사업자단위과세자인 경우, 종사업장 일련번호 기재(주사업장은 ‘0000’ 기재)
      //주사업장을 확인할 수 있는 판단기준을 구분할 수 없어서 패스
      //2.사업자단위과세자 여부가 부인 경우[C171]=‘2’ 공란이 아니면 오류
      if C[171] = '1' then
      begin
        if not isEmpty(C[172]) then
          errList.Add(errStr('C172', '종사업장 일련번호', mName, idNo))
      end
      else if C[171] = '2' then
      begin
        if isEmpty(C[172]) then
          errList.Add(errStr('C172', '종사업장 일련번호', mName, idNo))
      end;
form1.Memo1.Lines.Add('C172');
    end;

    if Copy(AnsiString(chkList.Strings[i]), 1, 1) = 'D' then
    begin

      //초기값 할당
      System.FillChar(D, SizeOf(D), #0);

      Inc(dRecordCnt);

      //배열길이 할당 D[1] ~ D[60]까지만 사용한다
      SetLength(D, 61);

      //49 20자리로 49, 49(A)
      //51 30자리로 51, 51(A), 51(B)
      strSize := '1, 2, 3, 6' //【자료관리번호】 4
                + ', 10, 50'  //【원천징수의무자】2
                + ', 13'      //【소득자】 1
                //【근무처별 소득명세- 종(전)근무처】 15
                + ', 1, 40, 10, 8, 8, 8, 8, 11, 11, 11, 11, 11, 11, 22, 11'
                //【종(전)근무처 비과세소득 및 감면 소득】 33
                + ', 10, 10, 10, 10, 10, 10, 10, 10, 10'
                + ', 10, 10, 10, 10, 10, 10, 10, 10'
                + ', 10, 10, 10, 10, 10, 10, 10, 10'
                + ', 10, 20, 10, 30, 10, 10, 10, 10'
                //【기납부세액 - 종(전)근무지】 5
                + ', 10, 10, 10, 2, 961';

      strSize := StringReplace(strSize, ' ', '',[rfReplaceAll, rfIgnoreCase]);
      for j := 1 to 60 do
      begin
        intSize := StrToInt(subStr(strSize, j, ','));

        D[j] := Copy(AnsiString(chkList.Strings[i]), startNo, intSize);

form1.Memo1.Lines.Add('D  ▶ ' + inttostr(j) + ' ▶ ' + inttostr(intSize) + ' ▶ ' +  D[j] + ' ▶ ' + inttostr(startNo));

        startNo :=  startNo + intSize;
      end;

      //【자료관리번호】
      //D1 레코드 구분 X(1)
      //영문 대문자 ‘D’ 아니면 오류
      if D[1] <> 'D' then errList.Add(errStr('D1', '레코드 구분', mName, idNo));

      //D2 자료구분 9(2)
      //‘20’이 아니면 오류
      if D[2] <> '20' then errList.Add(errStr('D2', '자료구분', mName, idNo));

      //D3 세무서코드 X(3)
      //세무서코드[D3] ≠ 세무서코드[B3]이면 오류
      if D[3] <> btaxOffice then errList.Add(errStr('D3', '세무서코드', mName, idNo));

      //【원천징수의무자】
      //D5 ③사업자등록번호 X(10)
      //사업자등록번호[D5] ≠ 사업자등록번호[B5]이면 오류
      if D[5] <> bBizNo then errList.Add(errStr('D5', '사업자등록번호', mName, idNo));

      //【소득자】
      //D7 ⑦소득자주민등록번호 X(13)
      //소득자주민등록번호[D7] ≠ 소득자주민등록번호[C12]이면 오류
      if D[7] <> IdNo then errList.Add(errStr('D7', '소득자주민등록번호', mName, idNo));

      //소득자가 같은 경우 종전근무지 Count
      dIdNo := D[7];
      if dIdNo <> dIdNo0 then
      begin
        if dIdNo0 = '' then dPersonalRecordCnt := 1;
      end
      else
        Inc(dPersonalRecordCnt);
      dIdNo0:= dIdNo;

      //【근무처별 소득명세- 종(전)근무처】
      //D8 -1납세조합 여부X(01)
      //(1, 2)가 아니면 오류
      if Pos(D[8], '[1][2]') = 0 then errList.Add(errStr('D8', '납세조합 여부', mName, idNo));

      //D9 ⑨법인명(상호) X(40)
      //기재되어 있지 않으면 오류
      if not isEmpty(D[9]) then errList.Add(errStr('D9', '법인명(상호)', mName, idNo));

      //D10 ⑩사업자등록번호 X(10)
      //기재되어 있지 않으면 오류
      if not isEmpty(D[10]) then errList.Add(errStr('D10', '사업자등록번호', mName, idNo));

      //D11 ⑪근무기간 시작연월일 9(8)
      //1.근무기간시작연월일 > 근무기간종료연월일이면 오류
      //2.근무기간시작연월일이 2017.1.1∼2017.12.31 사이가 아니면 오류
      //CompareDate(convtDateType(D[11]), convtDateType(D[12])) = 1
      //if CompareDate(convtDateType(D[11]), StartOfTheYear(yyyyDt)) = -1 then  // 시작연월 < 2017-01-01
      //if CompareDate(convtDateType(D[11]), EndOfTheYear(yyyyDt)) = 1 then   // 시작연월 > 2017-12-31
      if D[11] > D[12] then
      begin
        errList.Add(errStr('D11', '근무기간 시작연월일', mName, idNo));
      end
      else
      begin
        if (D[11] < FormatDateTime('yyyymmdd', StartOfTheYear(yyyyDt)))
          or (D[11] > FormatDateTime('yyyymmdd', EndOfTheYear(yyyyDt))) then
          errList.Add(errStr('D11', '근무기간 시작연월일', mName, idNo))
      end;

      //D12 ⑪근무기간 종료연월일 9(8)
      //1.근무기간시작연월일 > 근무기간종료연월일이면 오류
      //2.근무기간종료연월일이 2017.1.1∼2017.12.31 사이가 아니면 오류
      if D[11] > D[12] then
      begin
        errList.Add(errStr('D12', '근무기간 종료연월일', mName, idNo));
      end
      else
      begin
        if (D[12] < FormatDateTime('yyyymmdd', StartOfTheYear(yyyyDt)))
          or (D[12] > FormatDateTime('yyyymmdd', EndOfTheYear(yyyyDt))) then
          errList.Add(errStr('D12', '근무기간 종료연월일', mName, idNo))
      end;

      //D13 ⑫감면기간 시작연월일 9(8)
      //1.감면기간시작연월일 > 감면기간종료연월일이면 오류
      //2.감면기간시작연월일이 2017.1.1～2017.12.31사이가 아니면 오류
      //3.감면기간시작연월일 < 근무기간시작연월일(D11)이면 오류
      //4.산출세액(C113)>0이고 세액감면액이 없는데 (C114+C115+C116+C117=0) 감면기간(D13,D14)이 기재되어 있으면 오류
      //5.세액감면액이 있는데(C114+C115+C116+C117>0)
      //주(현) 감면기간(C20,C21)과 모든 종(전)의 감면기간(D13,D14)이 기재되어 있지 않으면 오류
      //6.감면소득이 있는데(D47+D51+D52>0) 감면기간(D13, D14)이 기재되어 있지 않으면 오류

      dTempAmt := 0;
      dTempAmt := cIncometaxReduceAmt + cSpecialTaxAmt1 + cSpecialTaxAmt2 + cTaxPactReduceAmt; //C114~C117

      if (D[13] <> '00000000') and (D[14] <> '00000000') then dDeductDateYn := True;

      //종전 감면기간이 하나라도 기재되어 있으면 True
      if D[13] <> '00000000' then
      begin
        
        if D[13] > D[14] then
          errList.Add(errStr('D13', '감면기간 시작연월일-1', mName, idNo))
        else
        begin
          if (D[13] < FormatDateTime('yyyymmdd', StartOfTheYear(yyyyDt)))
            or (D[13] > FormatDateTime('yyyymmdd', EndOfTheYear(yyyyDt))) then
            errList.Add(errStr('D13', '감면기간 시작연월일-2', mName, idNo))
          //C113 cCalculateTaxAmt
          else if ((cCalculateTaxAmt > 0) and (dTempAmt = 0)) and ((D[13] <> '00000000') or (D[14] <> '00000000')) then
            errList.Add(errStr('D13', '감면기간 시작연월일-3', mName, idNo))
          //cStrReduceFromDate := C[20]; cStrReduceToDate := C[21];
          else if (dTempAmt > 0) and ((D[13] = '00000000') or (D[14] = '00000000') or (cStrReduceFromDate = '00000000') or (cStrReduceToDate = '00000000') ) then
            errList.Add(errStr('D13', '감면기간 시작연월일-4', mName, idNo))
          else if (strToFloat(D[47]) + strToFloat(D[51]) + strToFloat(D[52]) > 0) and ((D[13] = '00000000') or (D[14] = '00000000')) then
            errList.Add(errStr('D13', '감면기간 시작연월일-5', mName, idNo));
        end;
      end;

      //D14 ⑫감면기간 종료연월일 9(8)
      //1.감면기간시작연월일 > 감면기간종료연월일이면 오류
      //2.감면기간시작연월일이 2017.1.1～2017.12.31 사이가 아니면 오류
      //3.감면기간종료연월일 > 근무기간종료연월일(D12)이면 오류
      //4.산출세액(C113)>0이고 세액감면액이 없는데(C114+ C115+C116+C117=0) 감면기간(D13,D14)이 기재되어 있으면 오류
      //5.세액감면액이 있는데(C114+C115+C116+C117>0)
      //주(현) 감면기간(C20,C21)과 모든 종(전)의 감면기간(D13,D14)이 기재되어 있지 않으면 오류
      //6.감면소득이 있는데(D47+D51+D52>0) 감면기간(D13, D14)이 기재되어 있지 않으면 오류
      if D[14] <> '00000000' then
      begin
        if D[13] > D[14] then
          errList.Add(errStr('D14', '감면기간 종료연월일', mName, idNo))
        else
        begin
          if (D[14] < FormatDateTime('yyyymmdd', StartOfTheYear(yyyyDt)))
            or (D[14] > FormatDateTime('yyyymmdd', EndOfTheYear(yyyyDt))) then
            errList.Add(errStr('D14', '감면기간 종료연월일-1', mName, idNo))
          else if D[14] > D[12] then
            errList.Add(errStr('D14', '감면기간 종료연월일-2', mName, idNo))
          //C113 cCalculateTaxAmt
          else if ((cCalculateTaxAmt > 0) and (dTempAmt = 0)) and ((D[13] <> '00000000') or (D[14] <> '00000000')) then
            errList.Add(errStr('D14', '감면기간 종료연월일-3', mName, idNo))
          //cStrReduceFromDate := C[20]; cStrReduceToDate := C[21];
          else if (dTempAmt > 0) and ((D[13] = '00000000') or (D[14] = '00000000') or (cStrReduceFromDate = '00000000') or (cStrReduceToDate = '00000000') ) then
            errList.Add(errStr('D14', '감면기간 종료연월일-4', mName, idNo))
          else if (strToFloat(D[47]) + strToFloat(D[51]) + strToFloat(D[52]) > 0) and ((D[13] = '00000000') or (D[14] = '00000000')) then
            errList.Add(errStr('D14', '감면기간 종료연월일-5', mName, idNo));
        end;
      end;

      //D15 ⑬급여 9(11)
      //급여 < 0 이면 오류
      if strToFloat(D[15]) < 0 then errList.Add(errStr('D15', '급여', mName, idNo));

      //D16 ⑭상여 9(11)
      //상여 < 0 이면 오류
      if strToFloat(D[16]) < 0 then errList.Add(errStr('D16', '상여', mName, idNo));

      //D17 ⑮인정상여 9(11)
      //인정상여총액 < 0 이면 오류
      if strToFloat(D[17]) < 0 then errList.Add(errStr('D17', '인정상여', mName, idNo));

      //D18 ⑮-1 주식매수선택권행사이익 9(11)
      //주식매수선택권행사이익 < 0 이면 오류
      dTotHouseOptionAmt := dTotHouseOptionAmt + strToFloat(D[18]);
      if strToFloat(D[18]) < 0 then errList.Add(errStr('D18', '주식매수선택권행사이익', mName, idNo));

      //D19 ⑮-2 우리사주조합인출금 9(11)
      //우리사주조합인출금 < 0 이면 오류
      if strToFloat(D[19]) < 0 then errList.Add(errStr('D19', '우리사주조합인출금', mName, idNo));

      //D20 ⑮-3 임원퇴직소득 한도 초과액 9(11)
      //임원 퇴직소득 한도초과액 < 0 이면 오류
      if strToFloat(D[20]) < 0 then errList.Add(errStr('D20', '임원퇴직소득 한도 초과액', mName, idNo));

      //D21 공란 9(22)
      //숫자 0으로 22자리가 채워있지 않으면 오류
      if D[21] <> '0000000000000000000000' then errList.Add(errStr('D21', '공란', mName, idNo));

      //D22 계
      //1.종(전)소득 계 < 0 이면 오류
      //2.[D22] ≠ [D15+D16+D17+D18+D19+D20]이면 오류
      dTotAmt := dTotAmt + strToFloat(D[22]);

      if strToFloat(D[22]) < 0 then
        errList.Add(errStr('D22', '계', mName, idNo))
      else
      begin
        dTempAmt := 0;
        for j := 15 to 20 do
        begin
          dTempAmt := dTempAmt + strToFloat(D[j]);
        end;

        if strToFloat(D[22]) <> dTempAmt then
          errList.Add(errStr('D22', '계', mName, idNo));
      end;

      //【종(전)근무처 비과세소득 및 감면 소득】
      //D23 -5 G01-비과세학자금 9(10)
      //비과세학자금(G01) < 0 이면 오류
      if strToFloat(D[23]) < 0 then errList.Add(errStr('D23', 'G01-비과세학자금', mName, idNo));

      //D24 -9 H01-무보수위원수당 9(10)
      //무보수위원수당(H01) < 0 이면 오류
      if strToFloat(D[24]) < 0 then errList.Add(errStr('D24', 'H01-무보수위원수당', mName, idNo));

      //D25 -18 H05-경호·승선수당
      //경호·승선수당(H05) < 0 이면 오류
      if strToFloat(D[25]) < 0 then errList.Add(errStr('D25', 'H05-경호·승선수당', mName, idNo));

      //D26 -4 H06-유아·초중등 9(10)
      //1.유아·초중등(H06) < 0 이면 오류
      //2.MIN(근무월수+1,12)×20만원 초과 시 오류
      //3.MIN(근무월수,12)×20만원 초과 시 확인

      //2017-01-01 ~ 2017-12-31 > 12개월 근무 > 12 - 1 + 2 > Max값인 13개월 설정
      //dTempWorkCnt는 근무월수 + 1을 진행
      dTempWorkCnt := 0; dTempAmt := 0;
      dTempWorkCnt := MonthOf(convtDateType(D[12])) - MonthOf(convtDateType(D[11])) + 2;
      if dTempWorkCnt > 12 then dTempWorkCnt := 12;

      if getErrLimitAmt(StrToFloat(D[26]), 0, dTempWorkCnt, 200000) then
        errList.Add(errStr('D26', 'H06-유아·초중등', mName, idNo));

      //D27 -4 H07-고등교육법9(10)
      //1.고등교육법(H07) < 0 이면 오류
      //2.MIN(근무월수+1,12)×20만원 초과 시 오류
      //3.MIN(근무월수,12)×20만원 초과 시 확인
      if getErrLimitAmt(StrToFloat(D[27]), 0, dTempWorkCnt, 200000) then
        errList.Add(errStr('D27', 'H07-고등교육법', mName, idNo));

      //D28 -4 H08-특별법 9(10)
      //1.특별법(H08) < 0 이면 오류
      //2.MIN(근무월수+1,12)×20만원 초과 시 오류
      //3.MIN(근무월수,12)×20만원 초과 시 확인
      if getErrLimitAmt(StrToFloat(D[28]), 0, dTempWorkCnt, 200000) then
        errList.Add(errStr('D28', 'H08-특별법', mName, idNo));

      //D29 -4 H09-연구기관 등 9(10)
      //1.연구기관등(H09) < 0 이면 오류
      //2.MIN(근무월수+1,12)×20만원 초과 시 오류
      //3.MIN(근무월수,12)×20만원 초과 시 확인
      if getErrLimitAmt(StrToFloat(D[29]), 0, dTempWorkCnt, 200000) then
        errList.Add(errStr('D29', 'H09-연구기관 등', mName, idNo));

      //D30 -4 H10-기업부설연구소 9(10)
      //1.기업연구소(H10) < 0 이면 오류
      //2.MIN(근무월수+1,12)×20만원 초과 시 오류
      //3.MIN(근무월수,12)×20만원 초과 시 확인
      if getErrLimitAmt(StrToFloat(D[30]), 0, dTempWorkCnt, 200000) then
        errList.Add(errStr('D30', 'H10-기업부설연구소', mName, idNo));

      //D31 -22 H14-보육교사 근무환경 개선비 9(10)
      //1.보육교사근무환경개선비(H14) < 0 이면 오류
      if strToFloat(D[31]) < 0 then
        errList.Add(errStr('D31', 'H14-보육교사 근무환경 개선비', mName, idNo));

      //D32 -23 H15-사립유치원 수석교사·교사의 인건비 9(10)
      //1.사립유치원수석교사·교사의 인건비(H15) < 0 이면 오류
      if strToFloat(D[32]) < 0 then
        errList.Add(errStr('D32', 'H15-사립유치원 수석교사·교사의 인건비', mName, idNo));

      //D33 -6 H11-취재수당 9(10)
      //1.취재수당(H11) < 0 이면 오류
      //2.MIN(근무월수+1,12)×20만원 초과 시 오류
      //3.MIN(근무월수,12)×20만원 초과 시 확인
      if getErrLimitAmt(StrToFloat(D[33]), 0, dTempWorkCnt, 200000) then
        errList.Add(errStr('D33', 'H11-취재수당', mName, idNo));

      //D34 -7 H12-벽지수당 9(10)
      //1.벽지수당(H12) < 0 이면 오류
      //2.MIN(근무월수+1,12)×20만원 초과 시 오류
      //3.MIN(근무월수,12)×20만원 초과 시 확인
      if getErrLimitAmt(StrToFloat(D[34]), 0, dTempWorkCnt, 200000) then
        errList.Add(errStr('D34', 'H12-벽지수당', mName, idNo));

      //D35 -8 H13-재해관련급여 9(10)
      //재해관련급여(H13) < 0이면 오류
      if strToFloat(D[35]) < 0 then
        errList.Add(errStr('D35', 'H13-재해관련급여', mName, idNo));

      //D36 -24 H16-정부?공공 기관 지방이전기관 종사자 이주수당 9(10)
      //1.이주수당(H16) < 0 이면 오류
      //2.MIN(근무월수+1,12)×20만원 초과 시 오류
      //3.MIN(근무월수,12)×20만원 초과 시 확인
      if getErrLimitAmt(StrToFloat(D[30]), 0, dTempWorkCnt, 200000) then
        errList.Add(errStr('D30', 'H10-기업부설연구소', mName, idNo));

      //D37 -19 I01-외국정부등근무자 9(10)
      //외국정부등근무자(I01) < 0 이면 오류
      if strToFloat(D[37]) < 0 then
        errList.Add(errStr('D37', 'I01-외국정부등근무자', mName, idNo));

      //D38 -10 K01-외국주둔군인등 9(10)
      //외국주둔군인등(K01) < 0 이면 오류
      if strToFloat(D[38]) < 0 then
        errList.Add(errStr('D38', 'K01-외국주둔군인등', mName, idNo));

      //D39 M01-국외근로100만원 9(10)
      //1.국외근로100만원(M01) < 0 이면 오류
      //2.MIN(근무월수+1,12)×100만원 초과 시 오류
      //3.MIN(근무월수,12)×100만원 초과 시 확인
      //4.국외근로300만원(항목40)과 합하여 MIN(근무월수+1,12)×300만원 초과 시 오류
      //5.국외근로300만원(항목40)과 합하여 MIN(근무월수,12)×300만원 초과 시 확인
      dTempAmt := 0; dTempAmt0 := 0;
      //dTempAmt := dTempWorkCnt * 1000000;
      //dTempAmt0 := dTempWorkCnt * 3000000;

      if getErrLimitAmt(StrToFloat(D[39]), 0, dTempWorkCnt, 1000000) then
        errList.Add(errStr('D30', 'H10-기업부설연구소', mName, idNo))
      else if getErrLimitAmt(StrToFloat(D[39]), strToFloat(D[40]), dTempWorkCnt, 3000000) then
        errList.Add(errStr('D30', 'H10-기업부설연구소', mName, idNo));

      //D40 M02-국외근로300만원 9(10)
      //1.국외근로300만원(M02) < 0 이면 오류
      //2.국외근로100만원(항목39)과 합하여 MIN(근무월수+1,12)×300만원 초과 시 오류
      //3.국외근로100만원(항목39)과 합하여 MIN(근무월수,12)×300만원 초과 시 확인
      if getErrLimitAmt(StrToFloat(D[40]), strToFloat(D[39]), dTempWorkCnt, 3000000) then
        errList.Add(errStr('D40', 'M02-국외근로300만원', mName, idNo));

      //D41 M03-국외근로 9(10)
      //국외근로(M03) < 0 이면 오류
      if strToFloat(D[41]) < 0 then errList.Add(errStr('D41', 'M03-국외근로', mName, idNo));

      //D42 O01-야간근로수당 9(10)
      //1.야간근로수당(O01) < 0 이면 오류
      //N 2.광산·일용 근로자가 아닌 경우 240만원 초과시 오류
      if strToFloat(D[42]) < 0 then errList.Add(errStr('D42', 'O01-야간근로수당', mName, idNo));

      //D43 Q01-출산보육수당 9(10)
      //1.출산보육수당(Q01) < 0 이면 오류
      //2.MIN(근무월수+1,12)×10만원 초과 시 오류
      //3.MIN(근무월수,12)×10만원 초과 시 확인
      dTempAmt := 0;
      if getErrLimitAmt(StrToFloat(D[43]), 0, dTempWorkCnt, 100000) then
        errList.Add(errStr('D43', 'Q01-출산보육수당', mName, idNo));

      //D44 R10-근로장학금 9(10)
      //근로장학금(R10) < 0 이면 오류
      if strToFloat(D[44]) < 0 then errList.Add(errStr('D44', 'R10-근로장학금', mName, idNo));

      //D45 R11-직무발명보상금 9(10)
      //1.직무발명보상금(R11) < 0 이면 오류
      //2.직무발명보상금(R11) > 300만원 이면 오류
      if getErrLimitAmt(StrToFloat(D[45]), 0, 1, 3000000) then
        errList.Add(errStr('D45', 'R11-직무발명보상금', mName, idNo));

      //D46 S01-주식매수선택권 9(10)
      //1.주식매수선택권(S01) < 0 이면 오류
      //2.3,000만원 초과시 오류
      if getErrLimitAmt(StrToFloat(D[46]), 0, 1, 30000000) then
        errList.Add(errStr('D46', 'S01-주식매수선택권', mName, idNo));

      //D47 T01-외국인기술자 9(10)
      //1.외국인기술자(T01) < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’인 경우 기재되어 있으면 오류
      //3.감면기간 (D13,D14)이 기재되어 있지 않은데 외국인기술자(D47)≠ 0이면 오류
      //N 4.세액감면(조특법)이 있는데(C114>0) 감면소득이 없으면(C54+(모든 종(전)의 (D47)의 합)=0) 오류
      //N 5.산출세액(C112>0이고 세액감면(조특법)이 없는데(C114 =0) 외국인기술자(D47) ≠ 0이면 오류

      dT01TotAmt := dT01TotAmt + strToFloat(D[47]); //dT01TotAmt 모든 종(전)의 (D47)의 합

      if strToFloat(D[47]) < 0 then
        errList.Add(errStr('D47', 'T01-외국인기술자', mName, idNo))
      else
      begin
        if getErrYn('2', strToFloat(D[47]), cForeignAb, cForeignTaxYn) then
          errList.Add(errStr('D47', 'T01-외국인기술자', mName, idNo))
        else if ((D[13] = '00000000') or (D[14] = '00000000')) and (strToFloat(D[47]) <> 0) then
          errList.Add(errStr('D47', 'T01-외국인기술자', mName, idNo))
      end;

      //D48 Y02-우리사주조합인출금50% 9(10)
      //우리사주조합인출금50%(Y02) < 0 이면 오류
      if strToFloat(D[48]) < 0 then errList.Add(errStr('D48', 'Y02-우리사주조합인출금50%', mName, idNo));

      //D49 -15 Y03-우리사주조합인출금75% 9(10)
      //우리사주조합인출금75%(Y03) < 0 이면 오류
      if strToFloat(Copy(D[49], 1, 10)) < 0 then errList.Add(errStr('D49', 'Y03-우리사주조합인출금75%', mName, idNo));

      //D49ⓐ-16 Y04-우리사주조합인출금100% 9(10)
      //[D49ⓐ] < 0 이면 오류
      if strToFloat(Copy(D[49], 11, 10)) < 0 then errList.Add(errStr('D49ⓐ', 'Y04-우리사주조합인출금100%', mName, idNo));

      //D50 Y22-전공의 수련 보조수당 9(10)
      //전공의 수련 보조수당(Y22) < 0 이면 오류
      if strToFloat(D[50]) < 0 then errList.Add(errStr('D50', 'Y22-전공의 수련 보조수당', mName, idNo));

      //D51 -25 T10-중소기업취업청년 소득세 감면100% 9(10)
      //1.[D51] < 0이면 오류
      //2.[C11]=‘9’, [C9]=‘1’인 경우: [D51] ≠ 0 이면 오류
      //3.감면기간([D13], [D14])이 기재되어 있지 않을때:  [D51] ≠ 0이면 오류

      //D51의 합 구하기
      dT10TotAmt := dT10TotAmt + strToFloat(Copy(D[51], 1, 10));

      if strToFloat(Copy(D[51], 1, 10)) < 0 then
        errList.Add(errStr('D51', 'T10-중소기업취업청년 소득세 감면100%', mName, idNo))
      else
      begin
        if getErrYn('2', strToFloat(Copy(D[51], 1, 10)), cForeignAb, cForeignTaxYn) then
          errList.Add(errStr('D51', 'T10-중소기업취업청년 소득세 감면100%', mName, idNo))
        else if (strToFloat(Copy(D[51], 1, 10)) <> 0)  and ((D[13] = '00000000') or (D[14] = '00000000')) then
          errList.Add(errStr('D51', 'T10-중소기업취업청년 소득세 감면100%', mName, idNo));
      end;

      //D51ⓐ-26 T11-중소기업취업청년 소득세 감면50% 9(10)
      //1.[D51ⓐ] < 0이면 오류
      //2.[C11]=‘9’, [C9]=‘1’인 경우: [D51ⓐ] ≠ 0 이면 오류
      //3.감면기간([D13], [D14])이 기재되어 있지 않을때:  [D51ⓐ] ≠ 0이면 오류

      //D51(a)의 합 구하기
      dT11TotAmt := dT11TotAmt + strToFloat(Copy(D[51], 11, 10));

      if strToFloat(Copy(D[51], 11, 10)) < 0 then
        errList.Add(errStr('D51ⓐ', 'T11-중소기업취업청년 소득세 감면50%', mName, idNo))
      else
      begin
        if getErrYn('2', strToFloat(Copy(D[51], 11, 10)), cForeignAb, cForeignTaxYn) then
          errList.Add(errStr('D51ⓐ', 'T11-중소기업취업청년 소득세 감면50%', mName, idNo))
        else if (strToFloat(Copy(D[51], 11, 10)) <> 0 ) and ((D[13] = '00000000') or (D[14] = '00000000')) then
          errList.Add(errStr('D51ⓐ', 'T11-중소기업취업청년 소득세 감면50%', mName, idNo));
      end;

      //D51ⓑ-27 T12-중소기업취업청년 소득세 감면70% 9(10)
      //1.[D51ⓑ] < 0이면 오류
      //2.[C11]=‘9’, [C9]=‘1’인 경우: [D51ⓑ] ≠ 0 이면 오류
      //3.감면기간([D13], [D14])이 기재되어 있지 않을때:  [D51ⓑ] ≠ 0이면 오류

      //D51(b)의 합 구하기
      dT12TotAmt := dT12TotAmt + strToFloat(Copy(D[51], 21, 10));

      if strToFloat(Copy(D[51], 21, 10)) < 0 then
        errList.Add(errStr('D51ⓑ', 'T12-중소기업취업청년 소득세 감면70%', mName, idNo))
      else
      begin
        if getErrYn('2', strToFloat(Copy(D[51], 21, 10)), cForeignAb, cForeignTaxYn) then
          errList.Add(errStr('D51ⓑ', 'T12-중소기업취업청년 소득세 감면70%', mName, idNo))
        else if (strToFloat(Copy(D[51], 21, 10)) <> 0) and ((D[13] = '00000000') or (D[14] = '00000000')) then
          errList.Add(errStr('D51ⓑ', 'T12-중소기업취업청년 소득세 감면70%', mName, idNo));
      end;

      //D52 -28 T20-조세조약상 교직자 감면 9(10)
      //1.조세조약상교직자감면(T20) < 0 이면 오류
      //2.[C11]=‘9’, [C9]=‘1’인 경우 기재되어 있으면 오류
      //3.내국인(C11='1')인데 기재되어 있으면 오류
      //D52 4.감면기간 (D13,D14)이 기재되어 있지 않은데 조세조약상교직자 감면(D52) ≠ 0이면 오류
      //D52 6.산출세액(C112> 0)이고 세액감면(조세조약)이 없는데(C116=0) 조세조약상 교직자 소득세감면(D52) ≠ 0이면 오류
      //D52의 합 구하기
      dT20TotAmt := dT20TotAmt + strToFloat(D[52]);

      if strToFloat(D[52]) < 0 then
        errList.Add(errStr('D52', 'T20-조세조약상 교직자 감면-1', mName, idNo))
      else
      begin
        if getErrYn('2', strToFloat(D[52]), cForeignAb, cForeignTaxYn) then
          errList.Add(errStr('D52', 'T20-조세조약상 교직자 감면-2', mName, idNo))
        else if (cForeignAb = '1') and (strToFloat(D[52]) <> 0) then
          errList.Add(errStr('D52', 'T20-조세조약상 교직자 감면-3', mName, idNo))
        else if (Concat(D[13], D[14]) = '0000000000000000') and (strToFloat(D[52]) <> 0) then
          errList.Add(errStr('D52', 'T20-조세조약상 교직자 감면-4', mName, idNo))
        else if (cStandardTaxAmt > 0) and (cSpecialTaxAmt2 = 0) and (strToFloat(D[52]) <> 0) then
          errList.Add(errStr('D52', 'T20-조세조약상 교직자 감면-5', mName, idNo));
      end;

      //D53 비과세 계 9(10)
      //1.비과세 계 < 0 이면 오류
      //2.[D53]≠[D23+∼+D36+∼+D46]+[D48+∼+D50]이면 오류
      dNonTaxSumAmt := dNonTaxSumAmt + strToFloat(D[53]);
      dTempAmt := 0;
      for j := 23 to 50 do
      begin
        if j = 47 then continue;

        if j = 49 then
          dTempAmt := strToFloat(Copy(D[49], 1, 10)) + strToFloat(Copy(D[49], 11, 10))
        else
          dTempAmt := dTempAmt + strToFloat(D[j]);
      end;

      if strToFloat(D[53]) < 0 then
        errList.Add(errStr('D53', '비과세 계', mName, idNo))
      else if strToFloat(D[53]) <> dTempAmt then
        errList.Add(errStr('D53', '비과세 계', mName, idNo));

      //D54 -1 감면소득 계 9(10)
      //1.감면소득 계 < 0 이면 오류
      //2.[D54]≠[D47 + D51 + D52]이면 오류
      dTempAmt := 0;
      dTempAmt := strToFloat(D[47])
                + strToFloat(Copy(D[51], 1, 10))
                + strToFloat(Copy(D[51], 11, 10))
                + strToFloat(Copy(D[51], 21, 10))
                + strToFloat(D[52]);

      if strToFloat(D[54]) < 0 then
      begin
        errList.Add(errStr('D54', '감면소득 계', mName, idNo));
      end
      else if strToFloat(D[54]) <> dTempAmt then
        errList.Add(errStr('D54', '감면소득 계', mName, idNo));

      //D55 공란 9(10)
      //‘0000000000’이 아니면 오류
      if D[55] <> '0000000000' then errList.Add(errStr('D55', '공란', mName, idNo));

      //【기납부세액 - 종(전)근무지】: 결정세액란의 세액 기재
      //D56 소득세 9(10)
      //1.종(전)기납부세액(소득세) < 0 이면 오류
      //2.(종(전)소득계 + 종(전)비과세계 + 종(전)감면소득계) = 0인데 종(전)근무지 기납부세액(소득세) ≠ 0이면 오류
      dTempAmt := 0;
      dTempAmt := strToFloat(D[22]) + strToFloat(D[53]) + strToFloat(D[54]);
      dTotPaidIncomeTaxAmt := dTotPaidIncomeTaxAmt + strToFloat(D[56]);

      if strToFloat(D[56]) < 0 then
        errList.Add(errStr('D56', '소득세', mName, idNo))
      else if (dTempAmt = 0) and (strToFloat(D[56]) <> 0) then
        errList.Add(errStr('D56', '소득세', mName, idNo));

      //D57 지방소득세 9(10)
      //1.종(전)기납부세액(지방소득세) < 0 이면 오류
      //2.(종(전)소득계 + 종(전)비과세계 + 종(전)감면소득계) = 0인데 종(전)근무지 기납부세액(지방소득세) ≠ 0이면 오류
      dTotPaidLocalTaxAmt := dTotPaidLocalTaxAmt + strToFloat(D[57]);
      if strToFloat(D[57]) < 0 then
        errList.Add(errStr('D57', '지방소득세', mName, idNo))
      else if (dTempAmt = 0) and (strToFloat(D[57]) <> 0) then
        errList.Add(errStr('D57', '지방소득세', mName, idNo));

      //D58 농특세 9(10)
      //1.종(전)기납부세액(농특세) < 0 이면 오류
      //2.(종(전)소득계 + 종(전)비과세계 + 종(전)감면소득계) = 0인데 종(전)근무지 기납부세액(농특세) ≠ 0이면 오류
      dTotPaidWithholdFarmTaxAmt := dTotPaidWithholdFarmTaxAmt + strToFloat(D[58]);
      if strToFloat(D[58]) < 0 then
        errList.Add(errStr('D58', '농특세', mName, idNo))
      else if (dTempAmt = 0) and (strToFloat(D[58]) <> 0) then
          errList.Add(errStr('D58', '농특세', mName, idNo));
    end;

    if Copy(AnsiString(chkList.Strings[i]), 1, 1) = 'E' then
    begin
      System.FillChar(E, SizeOf(E), #0);

      //배열길이 할당 E[1] ~ E[173]만 사용한다
      SetLength(E, 172);

      strSize := '1, 2, 3, 6'      //【자료관리번호】E1 ~ E4
                + ', 10'           //【원천징수의무자】E5
                + ', 13'           //【소득자】E6
                + ', 1, 1, 20, 13, 1, 1, 1, 1, 1, 1, 1, 1'       //【소득공제명세의 인적사항1】E7 ~ E18
                + ', 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 13' //【소득공제명세의 국세청 자료1】E19 ~ E29
                + ', 10, 10, 10, 10, 10, 10, 10, 10, 10, 13'     //【소득공제명세의 기타 자료1】E30 ~ E39

                + ', 1, 1, 20, 13, 1, 1, 1, 1, 1, 1, 1, 1'       //【소득공제명세의 인적사항1】E40 ~
                + ', 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 13' //【소득공제명세의 국세청 자료1】
                + ', 10, 10, 10, 10, 10, 10, 10, 10, 10, 13'     //【소득공제명세의 기타 자료1】      E72

                + ', 1, 1, 20, 13, 1, 1, 1, 1, 1, 1, 1, 1'       //【소득공제명세의 인적사항1】E73 ~
                + ', 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 13' //【소득공제명세의 국세청 자료1】
                + ', 10, 10, 10, 10, 10, 10, 10, 10, 10, 13'     //【소득공제명세의 기타 자료1】      E105

                + ', 1, 1, 20, 13, 1, 1, 1, 1, 1, 1, 1, 1'       //【소득공제명세의 인적사항1】E106 ~
                + ', 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 13' //【소득공제명세의 국세청 자료1】
                + ', 10, 10, 10, 10, 10, 10, 10, 10, 10, 13'     //【소득공제명세의 기타 자료1】      E138

                + ', 1, 1, 20, 13, 1, 1, 1, 1, 1, 1, 1, 1'       //【소득공제명세의 인적사항1】E139 ~
                + ', 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 13' //【소득공제명세의 국세청 자료1】
                + ', 10, 10, 10, 10, 10, 10, 10, 10, 10, 13';     //【소득공제명세의 기타 자료1】      E171

      strSize := StringReplace(strSize, ' ', '',[rfReplaceAll, rfIgnoreCase]);
      for j := 1 to 171 do
      begin
        intSize := StrToInt(subStr(strSize, j, ','));

        E[j] := Copy(AnsiString(chkList.Strings[i]), startNo, intSize);

form1.Memo1.Lines.Add('E  ▶ ' + inttostr(j) + ' ▶ ' + inttostr(intSize) + ' ▶ ' +  E[j] + ' ▶ ' + inttostr(startNo));

        startNo := startNo + intSize;
      end;

      //【자료관리번호】
      //E1 레코드 구분 X(1)
      //영문 대문자 ‘E’ 아니면 오류
      if E[1] <> 'E' then errList.Add(errStr('E1', '레코드 구분'));

      //E2 자료구분 9(2)
      //‘20’이 아니면 오류
      if E[2] <> '20' then errList.Add(errStr('E2', '자료구분'));

      //E3 세무서코드 X(3)
      //세무서코드[E3] ≠ 세무서코드[B3]이면 오류
      if E[3] <> btaxOffice then errList.Add(errStr('E3', '세무서'));

      //【원천징수의무자】
      //E5 ③사업자등록번호 X(10)
      //사업자등록번호[E5] ≠ 사업자등록번호[B5]이면 오류
      if E[5] <> bBizNo then errList.Add(errStr('E5', '사업자등록번호'));

      //【소득자】
      //E6 ⑦소득자 주민등록번호 X(13)
      //소득자주민등록번호[E6] ≠ 소득자주민등록번호[C12]이면 오류
      if E[6] <> IdNo then errList.Add(errStr('E6', '주민등록번호'));

      //【소득공제명세】서식항목
      // - 각종 소득공제 항목에 대한 본인 및 부양가족의 해당연도 실제 지출금액을 기재합니다.
      // - 한 개의 레코드에 5명까지 수록 가능하며 초과되는 경우는 새로운 E레코드를 추가하여 수록합니다.
      // - 본인의 소득공제명세는 반드시 첫 레코드의 첫 자료로 1번만 수록합니다.

      //소득자의 관계가 본인인 경우 증가
      eIdNo := E[6];
      if eIdNo <> eIdNo0 then
        eCnt := 1
      else
      begin
        if E[7] = '0' then inc(eCnt);
      end;
      eIdNo0 := eIdNo;

      //E6까지의 누적된 레코드의 길이가 35
      //eLength := 35;
      eCond := 0;
      for eRelationCnt := 7 to 171 do
      begin
        //eLength := eLength + Length(E[eRelationCnt]);

        //40, 73, 106, 139 위치에서만 비교
        if eRelationCnt in [40, 73, 106, 139] then
        begin
          if not isEmpty(E[eRelationCnt]) then Break;
          //if not isEmpty0(Copy(chkList.Strings[i], eLength + 1, Length(chkList.Strings[i]) - eLength)) then
          //  Break;
        end;

        case eRelationCnt of
          7..39:
            eRepeatCnt := 33*0;
          40..72:
            eRepeatCnt := 33*1;
          73..105:
            eRepeatCnt := 33*2;
          106..138:
            eRepeatCnt := 33*3;
          139..171:
            eRepeatCnt := 33*4;
        end;

        //해당 위치에서 비교할 조건을 설정한다.
        eCond := eRelationCnt - eRepeatCnt - 6;

        //소득자주민등록번호와 주민등록번호가 같고, 본인인 경우는 count를 1로 초기화한다.
        if (E[10 + eRepeatCnt] = E[6]) and (E[7 + eRepeatCnt] = '0') then
        begin
          if eCnt = 1 then
            eCnt := 1
          else
            eCnt := eCnt;
        end
        else
          inc(eCnt);

        if eCond = 1 then
        begin
          if Pos(E[7 + eRepeatCnt], '[0][1][2][3][4][5][6][7][8]') = 0 then
            errList.Add(errStr('E'+IntToStr(7 + eRepeatCnt), '관계-1', mName, idNo))
          else
          begin
            //2.
            if eCnt > 1 then
            begin
              if E[7 + eRepeatCnt] = '0' then
                errList.Add(errStr('E'+IntToStr(7 + eRepeatCnt), '관계-2', mName, idNo));
            end
            //3.
            else if eCnt = 1 then
            begin
              if (E[10 + eRepeatCnt] = E[6]) and (E[7 + eRepeatCnt] <> '0') then
                errList.Add(errStr('E'+IntToStr(7 + eRepeatCnt), '관계-3', mName, idNo))
            end;

            //C67 배우자공제금액
            //*배우자 인원수: 소득공제명세(E레코드)에서 배우자(관계코드:3)이고 기본공제가 ‘여(1)’인 인원수
            if (E[7 + eRepeatCnt] = '3') and (E[11 + eRepeatCnt] = '1') then Inc(eHouseHoldCnt);

            //C68 부양가족공제인원
            //*공제인원수: 소득공제명세(E레코드)에서 본인(관계코드:0), 배우자(관계코드:3)를 제외한 기본공제가 ‘여(1)’인 인원수
            if (Pos(E[7 + eRepeatCnt], '[0][3]') = 0) and (E[11 + eRepeatCnt] = '1') then Inc(eLinealCnt);

            //C70	경로우대공제인원, C72 장애인공제인원 비거주자 오류기준 제외

            //C74	부녀자공제금액
            //4.[C74] > 0인 경우:
            //-소득공제명세(E레코드)에 본인(관계코드:0)이 부녀자공제 ‘여’(1)가 아니면 오류
            if (cLadyAmt > 0) and (E[7 + eRepeatCnt] = '0') and (E[13 + eRepeatCnt] <> '1') then
              errList.Add(errStr('C74', '부녀자공제금액', mName, idNo));

            //C75 한부모가족공제금액
            //5.[C75] > 0인 경우: 소득공제명세(E레코드)에
            //-기본공제가 ‘여’(1)인 배우자(관계코드:3)가 있는 경우 오류
            //-기본공제가 ‘여’아닌 배우자가 있는 경우 확인()
            //-본인(관계코드:0)의 한부모가족공제가 ‘여’(1) 아니면 오류
            //-기본공제가 ‘여’(1)인 직계비속(관계코드:4,5)이 없으면 오류
            if cSingleParentAmt > 0 then
            begin
              if (E[11 + eRepeatCnt] = '1') and (E[7 + eRepeatCnt] = '3') then
              begin
                errList.Add(errStr('C75', '한부모가족공제금액', mName, idNo));
              end
              else if (E[7 + eRepeatCnt] = '0') and (E[15 + eRepeatCnt] <> '1') then
              begin
                errList.Add(errStr('C75', '한부모가족공제금액', mName, idNo));
              end
              else if (Pos(E[7 + eRepeatCnt], '[4][5]') > 0) and (E[11 + eRepeatCnt] = '1') then
              begin
                //Boolean으로 값을 넘겨서 C레코드에서 진행
                cSingleParentYn := True;
              end;
            end;

            //C121	㉮자녀세액공제 인원
            //*자녀세액공제인원수: 소득공제명세(E레코드)에서 기본공제가 ‘여(1)’ 이고 직계비속(관계코드:4,8)인 인원수

            //C123 	㉯6세이하자녀 세액공제 인원
            //*6세이하자녀세액공제인원수: 소득공제명세(E레코드)에서
            //6세이하공제가 ‘여(1)’ 이고 기본공제가 ‘여(1)’ 이고 직계비속(관계코드:4,8)인 인원수
            if (Pos(E[7 + eRepeatCnt], '[4][8]') > 0) and (E[11 + eRepeatCnt] = '1') then
            begin
              Inc(eChildDeductCnt);

              if E[17 + eRepeatCnt] = '1' then Inc(eUnderSixChildCnt);
            end;
          end;

form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 2 then
        begin
          //E8 내·외국인구분코드 X(1)
          //1.관계(E7), 성명(E9), 주민등록번호(E10)가 있을 때 ‘1’, ‘9’가 아니면 오류
          //2.첫번째 소득공제명세의 내·외국인구분코드:[E8] ≠ [C11]이면 오류
          if isEmpty(E[7 + eRepeatCnt]) and isEmpty(E[9 + eRepeatCnt]) and isEmpty(E[10 + eRepeatCnt])  then
          begin
            if Pos(E[8 + eRepeatCnt], '[1][9]') = 0 then
              errList.Add(errStr('E'+IntToStr(8 + eRepeatCnt), '내·외국인구분코드', mName, idNo))
            else if (eCnt = 1) and (E[8 + eRepeatCnt] <> cForeignAb) then
              errList.Add(errStr('E'+IntToStr(8 + eRepeatCnt), '내·외국인구분코드', mName, idNo));
          end;
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 3 then
        begin
          //E9 성명 X(20)
          //관계(E7), 주민등록번호(E10)가 있는데, 기재되어 있지 않으면 오류
          if isEmpty(E[7 + eRepeatCnt]) and isEmpty(E[10 + eRepeatCnt]) then
          begin
            if not isEmpty(E[9 + eRepeatCnt]) then
              errList.Add(errStr('E'+IntToStr(9 + eRepeatCnt), '성명', mName, idNo));
          end;
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 4 then
        begin
          //E10 주민등록번호 X(13)
          //귀속년도 중에 출생한 주민등록번호가 없는 내국인의 경우:
          // -생년월일(YYMMDD:6자리)+남녀구분(남:3,여:4:1자리)+‘000000’로 기입
          // 예시)2017년 12월30일 출생한 남자아이의 경우:→ 1712303000000
          //1.관계가 본인([E7]=‘0’)인데 소득공제명세의 주민등록번호가 소득자주민등록번호와 같지 않으면 오류
          // - [E10] ≠ [E6], [E10] ≠ [C12]이면 오류
          //N 2.소득공제명세의 주민등록번호가 중복되면 오류
          //3.잘못된 주민등록번호이면 오류(귀속년도 중에 출생한 주민등록번호가 없는 내국인의 경우 예외 : 항목설명 참고)

          if (E[7 + eRepeatCnt] = '0') and ((E[10 + eRepeatCnt] <> E[6]) or (E[10 + eRepeatCnt] <> IdNo)) then
            errList.Add(errStr('E'+IntToStr(10 + eRepeatCnt), '주민등록번호', mName, idNo))
          else
          begin
            if not ((Copy(E[10 + eRepeatCnt], 1, 2) = '17') and (Pos(Copy(E[10 + eRepeatCnt], 7, 1), '[3][4]') > 0)) then
            begin
              if not chkIdNo(E[10 + eRepeatCnt]) then
                errList.Add(errStr('E'+IntToStr(10 + eRepeatCnt), '주민등록번호', mName, idNo));
            end;
          end;
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 5 then
        begin
          //E11 기본공제 X(1)
          //1.(1 또는 공란)이 아니면 오류
          //2.직계존비속,형제자매,위탁아동이 연령 요건에 해당되지 않으면서 기본공제가 여('1')이면 오류
          // *다만, 장애인에 해당하는 경우 나이기준을 적용하지 아니함
          //3.첫번째 소득공제명세의 기본공제([E11]) ≠ ‘1’이면 오류
          //4.관계가 본인(‘0’)인데 기본공제가 여(‘1’)가 아니면 오류
          //5.비거주자(C7=‘2’)가 기본공제 여(‘1’)일때 본인(관계=‘0’)이 아니면 오류
          if Pos(E[11 + eRepeatCnt], '[1][ ]') = 0  then
            errList.Add(errStr('E'+IntToStr(11 + eRepeatCnt), '기본공제-1', mName, idNo))
          else
          begin
            //점검할 것!!!
            if (Pos(E[12 + eRepeatCnt], '[1][2][3]') = 0) and (E[11 + eRepeatCnt] = '1') then
            begin
              //1 소득자의 직계존속     , 2 배우자의 직계존속
              //4 직계비속(자녀, 입양자), 5 직계비속(코드 4 제외)
              //6 형제자매              , 8 위탁아동
              if Pos(E[7 + eRepeatCnt], '[1][2][4][5][6]') > 0 then
              begin
                //만20세 이하(1997.1.1.이후 출생) 또는 만60세 이상(1957.12.31.이전 출생)
                if not ((Copy(E[7 + eRepeatCnt], 1, 6) > FormatDateTime('yymmdd', StartOfTheYear(IncYear(yyyyDt, -20))))
                  or (Copy(E[7 + eRepeatCnt], 1, 6) < FormatDateTime('yymmdd', EndOfTheYear(IncYear(yyyyDt, -60))))) then
                  errList.Add(errStr('E'+IntToStr(11 + eRepeatCnt), '기본공제-2'+Copy(E[10 + eRepeatCnt], 1, 6), mName, idNo));
              end
              //(단, 위탁아동의 경우 만18세 미만 : 1999.1.2.이후 출생)
              else if Pos(E[11 + eRepeatCnt], '[8]') > 0 then
              begin
                if Copy(E[7 + eRepeatCnt], 1, 6) < FormatDateTime('yymmdd', StartOfTheYear(IncYear(yyyyDt, -18))) then
                  errList.Add(errStr('E'+IntToStr(11 + eRepeatCnt), '기본공제-3', mName, idNo));
              end;
            end;

            //3.
            if (eCnt = 1) and (E[11 + eRepeatCnt] <> '1') then
              errList.Add(errStr('E'+IntToStr(11 + eRepeatCnt), '기본공제-4', mName, idNo))
            //4.
            else if (E[7 + eRepeatCnt] = '0') and (E[11 + eRepeatCnt] <> '1') then
              errList.Add(errStr('E'+IntToStr(11 + eRepeatCnt), '기본공제-5', mName, idNo))
            //5.
            else if (cResidentAb = '2') and (E[11 + eRepeatCnt] = '1') and (E[7 + eRepeatCnt] <> '0') then
              errList.Add(errStr('E'+IntToStr(11 + eRepeatCnt), '기본공제-6', mName, idNo));
          end;
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 6 then
        begin
          //E12 장애인공제 X(1)
          //1.‘1’, ‘2’, ‘3’ 또는 공란이 아니면 오류
          //2.장애인공제가 여(‘1’,‘2’,‘3’)일때 기본공제가 여(‘1’)가 아니면 오류
          //3.비거주자(C7=‘2’)가 장애인공제 여(‘1’,‘2’,‘3’)일때 본인(관계=‘0’)이 아니면 오류

          if Pos(E[12 + eRepeatCnt], '[1][2][3][ ]') = 0 then
            errList.Add(errStr('E'+IntToStr(12 + eRepeatCnt), '장애인공제-1', mName, idNo))
          else
          begin
            //2.
            if Pos(E[12 + eRepeatCnt], '[1][2][3]') > 0 then
            begin
              //C72	장애인공제인원
              //*장애인공제인원수: 소득공제명세(E레코드)에서 기본공제가 ‘여(1)’ 이고 장애인공제가 (‘1’,‘2’,‘3’)인 인원수
              if E[11 + eRepeatCnt] = '1' then Inc(eDisabledCnt);

              if E[11 + eRepeatCnt] <> '1' then
                errList.Add(errStr('E'+IntToStr(12 + eRepeatCnt), '장애인공제-2', mName, idNo))
              else if (cResidentAb = '2') and (E[7 + eRepeatCnt] <> '0') then
                errList.Add(errStr('E'+IntToStr(12 + eRepeatCnt), '장애인공제-3', mName, idNo));
            end;
          end;
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 7 then
        begin
          //E13 부녀자공제 X(1)
          //1.(1 또는 공란)이 아니면 오류
          //2.첫번째 소득공제명세(본인) 일 경우만 공제(‘1’) 가능
          //3.남성이면 오류
          //4.한부모가족공제가 여(‘1’)일 때 부녀자가족공제가 여(‘1’)이면 오류
          if Pos(E[13 + eRepeatCnt], '[1][ ]') = 0  then
            errList.Add(errStr('E'+IntToStr(13 + eRepeatCnt), '부녀자공제-1', mName, idNo))
          else
          begin
            if (eCnt > 1) and (E[7 + eRepeatCnt] = '0') and (E[13 + eRepeatCnt] = '1') then
              errList.Add(errStr('E'+IntToStr(13 + eRepeatCnt), '부녀자공제-2', mName, idNo))
            else if Pos(E[12 + eRepeatCnt], '[1][3][5][7][9]') > 0 then
              errList.Add(errStr('E'+IntToStr(13 + eRepeatCnt), '부녀자공제-3', mName, idNo))
            else if (E[15 + eRepeatCnt] = '1') and (E[13 + eRepeatCnt] = '1') then
              errList.Add(errStr('E'+IntToStr(13 + eRepeatCnt), '부녀자공제-4', mName, idNo));
          end;
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 8 then
        begin
          //------------------------------------------------------------------------
          //E14 경로우대공제 X(1)
          //1.(1 또는 공란)이 아니면 오류
          //2.경로우대공제 여(‘1’)일때 기본공제가 여(‘1’)가 아니면 오류
          //3.만 70세이상(1947.12.31이전 출생)이 아니면 오류
          //4.비거주자(C7=‘2’)가 경로우대공제 여(‘1’)일때 본인(관계=‘0’)이 아니면 오류
          if Pos(E[14 + eRepeatCnt], '[1][ ]') = 0 then
            errList.Add(errStr('E'+IntToStr(14 + eRepeatCnt), '경로우대공제-1', mName, idNo))
          else
          begin
            if E[14 + eRepeatCnt] = '1' then
            begin
              //C70	경로우대공제인원
              //*경로공제인원수: 소득공제명세(E레코드)에서 기본공제가 ‘여(1)’ 이고 경로우대공제가 ‘여(1)’인 인원수
              if E[11 + eRepeatCnt] = '1' then Inc(eSeniorCnt);

              //2.
              if E[11 + eRepeatCnt] <> '1' then
                errList.Add(errStr('E'+IntToStr(14 + eRepeatCnt), '경로우대공제-2', mName, idNo))
              //3.
              else if Copy(E[7 + eRepeatCnt], 1, 6) > FormatDateTime('yymmdd', EndOfTheYear(IncYear(yyyyDt, -70))) then
                errList.Add(errStr('E'+IntToStr(14 + eRepeatCnt), '경로우대공제-3', mName, idNo))
              //4.
              else if (cResidentAb = '2') and (E[7 + eRepeatCnt] <> '0') then
                errList.Add(errStr('E'+IntToStr(14 + eRepeatCnt), '경로우대공제-4', mName, idNo));
            end;
          end;
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 9 then
        begin
          //E15 한부모가족공제 X(1)
          //1.(1 또는 공란)이 아니면 오류
          //2.첫번째 소득공제명세(본인) 일 경우만 공제(‘1’) 가능
          //3.비거주자(C7=‘2’)가 한부모가족공제 여(‘1’)이면 오류
          if Pos(E[15 + eRepeatCnt], '[1][ ]') = 0 then
            errList.Add(errStr('E'+IntToStr(15 + eRepeatCnt), '한부모가족공제-1', mName, idNo))
          else
          begin
            if E[15 + eRepeatCnt] = '1' then
            begin
              //2.
              if (eCnt > 1) and (E[7 + eRepeatCnt] = '0') then
                errList.Add(errStr('E'+IntToStr(15 + eRepeatCnt), '한부모가족공제-2', mName, idNo))
              //3.
              else if cResidentAb = '2' then
                errList.Add(errStr('E'+IntToStr(15 + eRepeatCnt), '한부모가족공제-3', mName, idNo));
            end;
          end;
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 10 then
        begin
          //E16 출산입양공제 X(1)
          //1.(1 또는 공란)이 아니면 오류
          //2.출산입양공제가 여(‘1’)일 때 기본공제가 여(‘1’)가 아니면 오류
          //3.출산입양공제가 여(‘1’)일 때 직계비속(관계:'4')이 아니면 오류
          if Pos(E[16 + eRepeatCnt], '[1][ ]') = 0 then
            errList.Add(errStr('E'+IntToStr(16 + eRepeatCnt), '출산입양공제-1', mName, idNo))
          else
          begin
            if E[16 + eRepeatCnt] = '1' then
            begin
              //2.
              if E[11 + eRepeatCnt] <> '1' then
                errList.Add(errStr('E'+IntToStr(16 + eRepeatCnt), '출산입양공제-2', mName, idNo))
              //3.
              else if E[7 + eRepeatCnt] <> '4' then
                errList.Add(errStr('E'+IntToStr(16 + eRepeatCnt), '출산입양공제-3', mName, idNo));

              //C125 출산/입양세액공제인원
              //소득공제명세(E레코드)에서 출산입양공제(E16,E49,E82,E115,E148)가 ‘1’ 이고 직계비속(관계코드:4)인 인원수
              if E[7 + eRepeatCnt] = '4' then Inc(eAdoptChildCnt);
            end;
          end;
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 11 then
        begin
          //E17 6세이하공제 X(1)
          //1.(1 또는 공란)이 아니면 오류
          //2.6세이하공제가 여(‘1’)일 때 기본공제가 여(‘1’)가 아니면 오류
          //3.6세이하공제가 여(‘1’)일 때 직계비속(관계:'4'),위탁아동(관계:'8')이 아니면 오류
          //4.6세이하(2011.01.01 이후 출생)가 아니면 오류
          if Pos(E[17 + eRepeatCnt], '[1][ ]') = 0 then
            errList.Add(errStr('E'+IntToStr(17 + eRepeatCnt), '6세이하공제-1', mName, idNo))
          else
          begin
            if E[17 + eRepeatCnt] = '1' then
            begin
              //2.
              if E[11 + eRepeatCnt] <> '1' then
                errList.Add(errStr('E'+IntToStr(17 + eRepeatCnt), '6세이하공제-2', mName, idNo))
              //3.
              else if Pos(E[7 + eRepeatCnt], '[4][8]') = 0 then
                errList.Add(errStr('E'+IntToStr(17 + eRepeatCnt), '6세이하공제-3', mName, idNo))
              //4.
              else if Copy(E[7 + eRepeatCnt], 1, 6) < FormatDateTime('yymmdd', StartOfTheYear(IncYear(yyyyDt, -6))) then
                errList.Add(errStr('E'+IntToStr(17 + eRepeatCnt), '6세이하공제-4', mName, idNo));
            end;
          end;
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 12 then
        begin
          //E18 교육비공제 X(1)
          //1.(‘1’,‘2’,‘3’,‘4’,‘5’ 또는 공란)이 아니면 오류
          //2.[E23]+[E34] > 0 일때 ‘1’,‘2’,‘3’,‘4’,‘5’가 아니면 오류
          if Pos(E[18 + eRepeatCnt], '[1][2][3][4][5][ ]') = 0 then
            errList.Add(errStr('E'+IntToStr(18 + eRepeatCnt), '교육비공제-1', mName, idNo))
          else
          begin
            if Pos(E[18 + eRepeatCnt], '[ ]') > 0 then
            begin
              if strToFloat(E[23 + eRepeatCnt]) + strToFloat(E[34 + eRepeatCnt]) > 0 then
                errList.Add(errStr('E'+IntToStr(18 + eRepeatCnt), '교육비공제-2', mName, idNo));
            end;

            //C139	특별세액공제_교육비_공제대상금액
            //4.[C139] > 교육비 공제대상금액 합계*) 이면 오류
            //-취학전아동과 초·중·고등학생 : 1인당 연300만원 한도
            //-대학생 : 1인당 연900만원 한도
            //-본인 : 전액
            //-장애인 특수교육비 : 전액
            //※체험학습비(초·중·고등학생 1인당 연 30만원 한도)
            //본인
            if E[18 + eRepeatCnt] = '1' then
              eEduOwnAmt := eEduOwnAmt + StrToFloat(E[23 + eRepeatCnt]) + StrToFloat(E[34 + eRepeatCnt])
            //초중고등학생 한도 300만원
            else if E[18 + eRepeatCnt] = '3' then
            begin
              if eEduStudentAmt <= 30000000 then
                eEduStudentAmt := eEduStudentAmt + StrToFloat(E[23 + eRepeatCnt]) + StrToFloat(E[34 + eRepeatCnt])
            end
            //대학생 한도 900만원
            else if E[18 + eRepeatCnt] = '4' then
            begin
              if eEduCollegeAmt <= 90000000 then
                eEduCollegeAmt := eEduCollegeAmt + StrToFloat(E[23 + eRepeatCnt]) + StrToFloat(E[34 + eRepeatCnt]);
            end
            //장애인
            else if E[18 + eRepeatCnt] = '5' then
              eEduSpecailAmt := eEduSpecailAmt + StrToFloat(E[23 + eRepeatCnt]) + StrToFloat(E[34 + eRepeatCnt]);
          end;
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 13 then
        begin
          //【소득공제명세의 국세청 자료1】
          //E19 보험료_건강·고용보험 9(10)
          //보험료_건강·고용보험 < 0 이면 오류
          if getErrYn('1', StrToFloat(E[19 + eRepeatCnt])) then
            errList.Add(errStr('E'+IntToStr(19 + eRepeatCnt), '보험료_건강·고용보험', mName, idNo));

          //[소득공제명세(E레코드)의 건강·고용 보험료 합계]이면 오류
          //C81	㉮보험료-건강보험료(노인장기요양보험료 포함)
          //4.[C81+C82]>[소득공제명세(E레코드)의 건강·고용 보험료 합계]이면 오류
          //C82	㉯보험료-고용보험료
          //4.[C81+C82]>[소득공제명세(E레코드)의 건강·고용 보험료 합계]이면 오류
          eTotE30Amt := eTotE30Amt + StrToFloat(E[19 + eRepeatCnt]) + StrToFloat(E[30 + eRepeatCnt]);
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 14 then
        begin
          //E20 보험료_보장성보험 9(10)
          //보험료 < 0 이면 오류
          if getErrYn('1', StrToFloat(E[20 + eRepeatCnt])) then
            errList.Add(errStr('E'+IntToStr(20 + eRepeatCnt), '보험료_보장성보험', mName, idNo));

          //C133	특별세액공제_보장성보험료_공제대상금액
          //4.[C133]>[소득공제명세(E레코드)의 보장성보험료 합계] 이면 오류
          eTotE31Amt := eTotE31Amt + StrToFloat(E[20 + eRepeatCnt]) + StrToFloat(E[31 + eRepeatCnt]);
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 15 then
        begin
          //E21 보험료_장애인전용 보장성보험 9(10)
          //장애인전용보장성보험료 < 0이면 오류
          if getErrYn('1', StrToFloat(E[21 + eRepeatCnt])) then
            errList.Add(errStr('E'+IntToStr(21 + eRepeatCnt), '보험료_장애인전용 보장성보험', mName, idNo));

          //C135	특별세액공제_장애인전용보장성보험료_공제대상금액
          //4.[C135] > 소득공제명세(E레코드)의 장애인전용보장성보험료 합계 이면 오류
          eTotE32Amt := eTotE32Amt + StrToFloat(E[21 + eRepeatCnt]) + StrToFloat(E[32 + eRepeatCnt]);
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 16 then
        begin
          //E22 의료비 9(10)
          //의료비 < 0 이면 오류
          if getErrYn('1', StrToFloat(E[22 + eRepeatCnt])) then
            errList.Add(errStr('E'+IntToStr(22 + eRepeatCnt), '보험료_의료비', mName, idNo));

          //C137	특별세액공제_의료비_공제대상금액
          //5.[C137]>소득공제명세(E레코드)의 의료비 합계이면 오류
          eTotMedicalAmt := eTotMedicalAmt + StrToFloat(E[22 + eRepeatCnt]) + StrToFloat(E[33 + eRepeatCnt]);
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 17 then
        begin
          //E23 교육비 9(10)
          //교육비 < 0 이면 오류
          if getErrYn('1', StrToFloat(E[23 + eRepeatCnt])) then
            errList.Add(errStr('E'+IntToStr(23 + eRepeatCnt), '보험료_교육비', mName, idNo));
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 18 then
        begin
          //E24 신용카드(전통시장?대중 교통비 제외) 9(10)
          //1.[E24] < 0이면 오류
          //2.관계코드가 (‘6’,‘7’,‘8‘)인데 [E24] > 0 이면 오류
          if getErrYn('1', StrToFloat(E[24 + eRepeatCnt])) then
            errList.Add(errStr('E'+IntToStr(24 + eRepeatCnt), '신용카드(전통시장/대중 교통비 제외)-1', mName, idNo))
          else if getErrYn('4', strToFloat(E[24 + eRepeatCnt]), E[7 + eRepeatCnt]) then
            errList.Add(errStr('E'+IntToStr(24 + eRepeatCnt), '신용카드(전통시장/대중 교통비 제외)-2', mName, idNo));
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 19 then
        begin
          //E25 직불?선불카드(전통시장?대중 교통비 제외) 9(10)
          //1.[E25] < 0 이면 오류
          //2.관계코드가 (‘6’,‘7’,‘8’)인데 [E25] > 0이면 오류
          if getErrYn('1', StrToFloat(E[25 + eRepeatCnt])) then
            errList.Add(errStr('E'+IntToStr(25 + eRepeatCnt), '직불/선불카드(전통시장/대중 교통비 제외)-1', mName, idNo))
          else if getErrYn('4', strToFloat(E[25 + eRepeatCnt]), E[7 + eRepeatCnt]) then
            errList.Add(errStr('E'+IntToStr(25 + eRepeatCnt), '직불/선불카드(전통시장/대중 교통비 제외)-2', mName, idNo));

form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 20 then
        begin
          //E26 현금영수증(전통시장?대중  교통비 제외) 9(10)
          //1.[E26] < 0이면 오류
          //2.관계코드가 (‘6’,‘7’,‘8’)인데 [E26] > 0 이면 오류
          if getErrYn('1', StrToFloat(E[26 + eRepeatCnt])) then
            errList.Add(errStr('E'+IntToStr(26 + eRepeatCnt), '현금영수증(전통시장/대중  교통비 제외)-1', mName, idNo))
          else if getErrYn('4', strToFloat(E[26 + eRepeatCnt]), E[7 + eRepeatCnt]) then
            errList.Add(errStr('E'+IntToStr(26 + eRepeatCnt), '현금영수증(전통시장/대중  교통비 제외)-2', mName, idNo));
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 21 then
        begin
          //E27 전통시장사용액 9(10)
          //1.[E27] < 0 이면 오류
          //2.관계코드가 (‘6’,‘7’,‘8’)인데 [E27]> 0이면 오류
          //3. 1,000만원이상이면 확인
          if getErrYn('1', StrToFloat(E[27 + eRepeatCnt])) then
            errList.Add(errStr('E'+IntToStr(27 + eRepeatCnt), '전통시장사용액', mName, idNo))
          else if getErrYn('4', strToFloat(E[27 + eRepeatCnt]), E[7 + eRepeatCnt]) then
            errList.Add(errStr('E'+IntToStr(27 + eRepeatCnt), '전통시장사용액', mName, idNo));
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 22 then
        begin
          //E28 대중교통이용액 9(10)
          //1.[E28] < 0 이면 오류
          //2.관계코드가 (‘6’,‘7’,‘8’)인데 [E28] > 0이면 오류
          //3. 1,000만원이상이면 확인
          if getErrYn('1', StrToFloat(E[28 + eRepeatCnt])) then
            errList.Add(errStr('E'+IntToStr(28 + eRepeatCnt), '대중교통이용액', mName, idNo))
          else if getErrYn('4', strToFloat(E[28 + eRepeatCnt]), E[7 + eRepeatCnt]) then
            errList.Add(errStr('E'+IntToStr(28 + eRepeatCnt), '대중교통이용액', mName, idNo));
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 23 then
        begin
          //E29 기부금 9(13)
          //1.기부금 < 0 이면 오류
          //N 2.[E29] + [E39] ≠ [I15]*) 이면 오류
          //*해당 연도 기부명세(I레코드)의 기부자별 기부금합계금액의 합산값
          if getErrYn('1', StrToFloat(E[29 + eRepeatCnt])) then
            errList.Add(errStr('E'+IntToStr(29 + eRepeatCnt), '기부금', mName, idNo));
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 24 then
        begin
          //【소득공제명세의 기타 자료1】
          //E30 보험료_건강·고용보험 9(10)
          //건강·고용보험료 외 < 0이면 오류
          if getErrYn('1', StrToFloat(E[30 + eRepeatCnt])) then
            errList.Add(errStr('E'+IntToStr(30 + eRepeatCnt), '보험료_건강·고용보험', mName, idNo));
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 25 then
        begin
          //E31 보험료_보장성보험 9(10)
          //보장성 보험료 외 < 0 이면 오류
          if getErrYn('1', StrToFloat(E[31 + eRepeatCnt])) then
            errList.Add(errStr('E'+IntToStr(31 + eRepeatCnt), '보험료_보장성보험', mName, idNo));
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 26 then
        begin
          //E32  보험료_장애인전용 보장성보험 9(10)
          //장애인 전용 보장성 보험료 외 < 0이면 오류
          if getErrYn('1', StrToFloat(E[32 + eRepeatCnt])) then
            errList.Add(errStr('E'+IntToStr(32 + eRepeatCnt), '보험료_장애인전용 보장성보험', mName, idNo));
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 27 then
        begin
          //E33 의료비 9(10)
          //의료비 외 < 0이면 오류
          if getErrYn('1', StrToFloat(E[33 + eRepeatCnt])) then
            errList.Add(errStr('E'+IntToStr(33 + eRepeatCnt), '의료비', mName, idNo));
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 28 then
        begin
          //E34  교육비 9(10)
          //교육비 외 < 0이면 오류
          if getErrYn('1', StrToFloat(E[34 + eRepeatCnt])) then
            errList.Add(errStr('E'+IntToStr(34 + eRepeatCnt), '교육비', mName, idNo));
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 29 then
        begin
          //E35 신용카드 외(전통시장?대중교통비 제외) 9(10)
          //1.[E35] < 0이면 오류
          //2.관계코드가 (‘6’,‘7’,‘8’)인데 [E35] > 0이면 오류
          if getErrYn('1', StrToFloat(E[35 + eRepeatCnt])) then
            errList.Add(errStr('E'+IntToStr(35 + eRepeatCnt), '신용카드 외(전통시장/대중교통비 제외)', mName, idNo))
          else if getErrYn('4', strToFloat(E[35 + eRepeatCnt]), E[7 + eRepeatCnt]) then
            errList.Add(errStr('E'+IntToStr(35 + eRepeatCnt), '신용카드 외(전통시장/대중교통비 제외)', mName, idNo));
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 30 then
        begin
          //E36 직불?선불카드 외(전통시장?대중교통비 제외) 9(10)
          //1.[E36] < 0이면 오류
          //2.관계코드가 (‘6’,‘7’,‘8’)인데 [E36] > 0이면 오류
          if getErrYn('1', StrToFloat(E[36 + eRepeatCnt])) then
            errList.Add(errStr('E'+IntToStr(36 + eRepeatCnt), '직불/선불카드 외(전통시장/대중교통비 제외)', mName, idNo))
          else if getErrYn('4', strToFloat(E[36 + eRepeatCnt]), E[7 + eRepeatCnt]) then
            errList.Add(errStr('E'+IntToStr(36 + eRepeatCnt), '직불/선불카드 외(전통시장/대중교통비 제외)', mName, idNo));
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 31 then
        begin
          //E37 전통시장사용액 외 9(10)
          //1.[E37] < 0 이면 오류
          //2.관계코드가 (‘6’,‘7’,‘8’)인데 [E37] > 0이면 오류
          //3. 1,000만원이상이면 확인
          if getErrYn('1', StrToFloat(E[37 + eRepeatCnt])) then
            errList.Add(errStr('E'+IntToStr(37 + eRepeatCnt), '전통시장사용액 외', mName, idNo))
          else if getErrYn('4', strToFloat(E[37 + eRepeatCnt]), E[7 + eRepeatCnt]) then
            errList.Add(errStr('E'+IntToStr(37 + eRepeatCnt), '전통시장사용액 외', mName, idNo));
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 32 then
        begin
          //E38 대중교통이용액 외 9(10)
          //1.[E38] < 0 이면 오류
          //2.관계코드가 (‘6’,‘7’,‘8’)인데 [E38] > 0이면 오류
          //3. 1,000만원이상이면 확인
          if getErrYn('1', StrToFloat(E[38 + eRepeatCnt])) then
            errList.Add(errStr('E'+IntToStr(38 + eRepeatCnt), '대중교통이용액 외', mName, idNo))
          else if getErrYn('4', strToFloat(E[38 + eRepeatCnt]), E[7 + eRepeatCnt]) then
            errList.Add(errStr('E'+IntToStr(38 + eRepeatCnt), '대중교통이용액 외', mName, idNo));
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end
        else if eCond = 33 then
        begin
          //E39 기부금 외 9(13)
          //1.기부금외 < 0 이면 오류
          //N 2.[E29] + [E39] ≠ [I15]*) 이면 오류
          //*해당 연도 기부명세(I레코드)의 기부자별 기부금합계금액의 합산값
          if getErrYn('1', StrToFloat(E[39 + eRepeatCnt])) then
            errList.Add(errStr('E'+IntToStr(39 + eRepeatCnt), '기부금 외', mName, idNo));
form1.Memo1.Lines.Add('e - ' + IntToStr(eRelationCnt));
        end;
      end;
    end;

    if Copy(AnsiString(chkList.Strings[i]), 1, 1) = 'F' then
    begin
      System.FillChar(F, SizeOf(F), #0);

      //배열길이 할당 F[1] ~ F[96]만 사용한다
      SetLength(F, 97);

      strSize := '1, 2, 3, 6' //【자료관리번호】
                + ', 10'      //【원천징수의무자】
                + ', 13'      //【소득자】 6
                + ', 2, 3, 50, 20, 10, 10' //【연금·저축등 소득·세액 공제명세1】
                + ', 2, 3, 50, 20, 10, 10' //【연금·저축등 소득·세액 공제명세2】
                + ', 2, 3, 50, 20, 10, 10' //【연금·저축등 소득·세액 공제명세3】
                + ', 2, 3, 50, 20, 10, 10' //【연금·저축등 소득·세액 공제명세4】
                + ', 2, 3, 50, 20, 10, 10' //【연금·저축등 소득·세액 공제명세5】
                + ', 2, 3, 50, 20, 10, 10' //【연금·저축등 소득·세액 공제명세6】
                + ', 2, 3, 50, 20, 10, 10' //【연금·저축등 소득·세액 공제명세7】
                + ', 2, 3, 50, 20, 10, 10' //【연금·저축등 소득·세액 공제명세8】
                + ', 2, 3, 50, 20, 10, 10' //【연금·저축등 소득·세액 공제명세9】
                + ', 2, 3, 50, 20, 10, 10' //【연금·저축등 소득·세액 공제명세10】
                + ', 2, 3, 50, 20, 10, 10' //【연금·저축등 소득·세액 공제명세11】
                + ', 2, 3, 50, 20, 10, 10' //【연금·저축등 소득·세액 공제명세12】
                + ', 2, 3, 50, 20, 10, 10' //【연금·저축등 소득·세액 공제명세13】
                + ', 2, 3, 50, 20, 10, 10' //【연금·저축등 소득·세액 공제명세14】
                + ', 2, 3, 50, 20, 10, 10'; //【연금·저축등 소득·세액 공제명세15】

      strSize := StringReplace(strSize, ' ', '',[rfReplaceAll, rfIgnoreCase]);
      for j := 1 to 96 do
      begin
        intSize := StrToInt(subStr(strSize, j, ','));

        F[j] := Copy(AnsiString(chkList.Strings[i]), startNo, intSize);

form1.Memo1.Lines.Add('F  ▶ ' + inttostr(j) + ' ▶ ' + inttostr(intSize) + ' ▶ ' +  F[j] + ' ▶ ' + inttostr(startNo));

        startNo := startNo + intSize;
      end;

      //【자료관리번호】
      //F1 레코드 구분 X(1)
      //영문 대문자 ‘F’ 아니면 오류
      if F[1] <> 'F' then errList.Add(errStr('F1', '레코드 구분', mName, idNo));

      //F2 자료구분 9(2)
      //‘20’이 아니면 오류
      if F[2] <> '20' then errList.Add(errStr('F2', '자료구분', mName, idNo));

      //F3 세무서코드 X(3)
      //세무서코드[F3] ≠ 세무서코드[B3]이면 오류
      if F[3] <> btaxOffice then errList.Add(errStr('F3', '세무서', mName, idNo));

      //【원천징수의무자】
      //F5 ②사업자등록번호 X(10)
      //사업자등록번호[F5] ≠ 사업자등록번호[B5]이면 오류
      if F[5] <> bBizNo then errList.Add(errStr('F5', '사업자등록번호', mName, idNo));

      //【소득자】 F6 ④소득자 주민등록번호 X(13)
      //[F6] ≠ [C12] 이면 오류
      if F[6] <> IdNo then errList.Add(errStr('F6', '소득자 주민등록번호', mName, idNo));

      //【연금·저축등 소득·세액 공제명세1】
      //  - 퇴직연금, 연금저축, 주택마련저축, 장기집합투자증권 소득공제를 받는 소득자의 해당 소득·세액 공제 명세를 각 공제구분ㆍ금융기관ㆍ계좌번호별 납입금액 등을 수록합니다.
      //  - 한 개의 레코드에 15개까지 수록하며 초과되는 경우는 새로운 F레코드를 추가하여 수록합니다.
      //  - 공제금액이 0인 경우 기재하지 않습니다.
      fLength := 35; fCond := 0;
      for fRelationCnt := 7 to 96 do
      begin
        //fRepeatCnt := 0;
        fLength := fLength + Length(F[fRelationCnt]);

        //13, 19, 25, 31, 37, 43, 49, 55, 61, 67, 73, 79, 85, 91
        if fRelationCnt in [13, 19, 25, 31, 37, 43, 49, 55, 61, 67, 73, 79, 85, 91] then
        begin
          if not isEmpty(F[fRelationCnt]) then Break;
          // if not isEmpty0(Copy(chkList.Strings[i], fLength + 1, Length(chkList.Strings[i]) - fLength)) then
          //  Break;
        end;

        case fRelationCnt of
          7..12:
            fRepeatCnt := 6*0;
          13..18:
            fRepeatCnt := 6*1;
          19..24:
            fRepeatCnt := 6*2;
          25..30:
            fRepeatCnt := 6*3;
          31..36:
            fRepeatCnt := 6*4;
          37..42:
            fRepeatCnt := 6*5;
          43..48:
            fRepeatCnt := 6*6;
          49..54:
            fRepeatCnt := 6*7;
          55..60:
            fRepeatCnt := 6*8;
          61..66:
            fRepeatCnt := 6*9;
          67..72:
            fRepeatCnt := 6*10;
          73..78:
            fRepeatCnt := 6*11;
          79..84:
            fRepeatCnt := 6*12;
          85..90:
            fRepeatCnt := 6*13;
          91..96:
            fRepeatCnt := 6*14;
        end;

        //해당 위치에서 비교할 조건을 설정한다.
        fCond := fRelationCnt - fRepeatCnt - 6;

        //반복을 발생하게 해서 진행하도록 한다.(E레코드 코드전개와 유사하게 진행)
        if fCond = 1 then
        begin
          //F7 소득공제구분 X(2)
          //‘11’, ‘12’, ‘21’, ‘22’, ‘31’, ‘32’, ‘34’, ‘51’이 아니면 오류
          if Pos(F[7 + fRepeatCnt], '[11][12][21][22][31][32][34][51]') = 0 then
            errList.Add(errStr('F'+IntToStr(7 + fRepeatCnt), '소득공제구분', mName, idNo));
        end
        else if fCond = 2 then
        begin
          //F8 금융기관코드 X(3)
          //1.기재되어 있지 않으면 오류
          //2.기재된 금융기관코드가 미등록된 코드이면 오류
          if not isEmpty(F[8 + fRepeatCnt]) then
            errList.Add(errStr('F'+IntToStr(8 + fRepeatCnt), '금융기관코드', mName, idNo))
          else
          begin
            //if not Form1.vtTemp.Active then Form1.vtTemp.Active := True;
            //if not Form1.vtTemp.Locate('hr_code_id', 'hr_financial_company_ab', []) then
            //  commonCodeVt('hr_financial_company_ab');
            //if not Form1.vtTemp.Locate('hr_financial_company_ab',F[8 + fRepeatCnt], []) then
            //  errList.Add(errStr('F8', '금융기관코드', mName, idNo));

            if not commonCodeYn('hr_financial_company_ab', F[8 + fRepeatCnt]) then
              errList.Add(errStr('F'+IntToStr(8 + fRepeatCnt),  '금융기관코드', mName, idNo));
          end;
        end
        else if fCond = 3 then
        begin
          //F9 금융기관상호 X(50)
          //기재되어 있지 않으면 오류
          if not isEmpty(F[9 + fRepeatCnt]) then errList.Add(errStr('F'+IntToStr(9 + fRepeatCnt), '금융기관상호', mName, idNo));
        end
        else if fCond = 4 then
        begin
          //F10 계좌번호(또는 증권번호) X(20)
          //기재되어 있지 않으면 오류
          if not isEmpty(F[10 + fRepeatCnt]) then errList.Add(errStr('F'+IntToStr(10 + fRepeatCnt), '계좌번호(또는 증권번호)', mName, idNo));
        end
        else if fCond = 5 then
        begin
          //F11 납입금액 9(10)
          //1.납입금액 ? 0 이면 오류
          if strToFloat(F[11 + fRepeatCnt]) <= 0 then errList.Add(errStr('F'+IntToStr(11 + fRepeatCnt), '납입금액', mName, idNo));
        end
        else if fCond = 6 then
        begin
          //F12 소득·세액공제금액 9(10)
          //1.공제금액 < 0 이면 오류
          //2.공제금액 > [소득공제구분별 금융기관별 계좌별 납입금액에 의한 아래 공제금액 계산값]이면 오류
          fTempAmt := 0; fTempRate := 0;

          if strToFloat(F[12 + fRepeatCnt]) < 0 then
            errList.Add(errStr('F'+IntToStr(12 + fRepeatCnt), '소득·세액공제금액', mName, idNo))
          else
          begin
            if cTotSalaryAmt <= 55000000 then
              fTempRate := 0.15
            else
              fTempRate := 0.12;

            {-f32TotAmt f34TotAmt
            -f11TotAmt  f12TotAmt
            -f21TotAmt  f22TotAmt}

            // ①퇴직연금소득세액공제(소득공제구분 '11', '12')인 경우:
            // MIN(납입금액,700만원)×12%(총급여[항목63] 5,500만원 이하인 경우 15%)
            if Pos(F[7 + fRepeatCnt], '[11][12]') > 0 then
            begin
              if strToFloat(F[11 + fRepeatCnt]) > 7000000 then
                fTempAmt := 7000000 * fTempRate
              else
                fTempAmt := strToFloat(F[11 + fRepeatCnt]) * fTempRate;

              if F[7 + fRepeatCnt] = '11' then
                f11TotAmt := strToFloat(F[12 + fRepeatCnt]) + f11TotAmt
              else
                f12TotAmt := strToFloat(F[12 + fRepeatCnt]) + f12TotAmt;
            end
            // ③연금저축계좌공제(연금저축, 소득공제구분 '22')인 경우:
            // MIN(납입금액,400만원)×12%(총급여[항목63] 5,500만원 이하인 경우 15%)
            else if Pos(F[7 + fRepeatCnt], '[22]') > 0 then
            begin
              if strToFloat(F[11 + fRepeatCnt]) > 4000000 then
                fTempAmt := 4000000 * fTempRate
              else
                fTempAmt := strToFloat(F[11 + fRepeatCnt]) * fTempRate;

              f22TotAmt := strToFloat(F[12 + fRepeatCnt]) + f22TotAmt;
            end
            // ④주택마련저축소득공제(소득공제구분 '31', '32')인 경우: MIN(납입금액,240만원) × 40%
            else if Pos(F[7 + fRepeatCnt], '[31][32]') > 0 then
            begin
              if strToFloat(F[11 + fRepeatCnt]) > 2400000 then
                fTempAmt := 2400000 * 0.4
              else
                fTempAmt := strToFloat(F[11 + fRepeatCnt]) * 0.4;

              f32TotAmt := strToFloat(F[12 + fRepeatCnt]) + f32TotAmt;
            end
            // ②개인연금저축(소득공제구분 '21')인 경우 : MIN(납입금액,180만원) × 40%
            // ⑤주택마련저축소득공제(소득공제구분'34')인 경우: MIN(납입금액, 180만원) × 40%
            else if Pos(F[7 + fRepeatCnt], '[21][34]') > 0 then
            begin
              if strToFloat(F[11 + fRepeatCnt]) > 1800000 then
                fTempAmt := 1800000 * 0.4
              else
                fTempAmt := strToFloat(F[11 + fRepeatCnt]) * 0.4;

              if F[7 + fRepeatCnt] = '21' then
                f21TotAmt := strToFloat(F[12 + fRepeatCnt]) + f21TotAmt
              else
                f34TotAmt := strToFloat(F[12 + fRepeatCnt]) + f34TotAmt;
            end
            // ⑥장기집합투자증권소득공제(소득공제구분‘51’)인 경우: MIN(납입금액, 600만원) × 40%
            else if Pos(F[7 + fRepeatCnt], '[51]') > 0 then
            begin
              if strToFloat(F[11 + fRepeatCnt]) > 6000000 then
                fTempAmt := 6000000 * 0.4
              else
                fTempAmt := strToFloat(F[11 + fRepeatCnt]) * 0.4;
            end;

            if strToFloat(F[12 + fRepeatCnt]) > fTempAmt then
              errList.Add(errStr('F'+IntToStr(12 + fRepeatCnt), '소득·세액공제금액', mName, idNo));
          end;
        end;
      end;
    end;

    if Copy(AnsiString(chkList.Strings[i]), 1, 1) = 'G' then
    begin
      System.FillChar(G, SizeOf(G), #0);

      //배열길이 할당 G[1] ~ G[86]만 사용한다
      SetLength(G, 85);

      strSize :=  '1, 2, 3, 6' //【자료관리번호】
                + ', 10'       //【원천징수의무자】
                + ', 13'       //【소득자】
                + ', 20, 13, 1, 5, 100, 8, 8, 10, 10' //【월세액 소득공제명세1】
                + ', 20, 13, 8, 8, 4, 10, 10, 10, 10' //【거주자간 주택임차차입금 원리금 상환액 - 금전소비대차 계약내용1】
                + ', 20, 13, 1, 5, 100, 8, 8, 10'     //【거주자간 주택임차차입금 원리금 상환액 - 임대차 계약내용1】
                + ', 20, 13, 1, 5, 100, 8, 8, 10, 10' //【월세액 소득공제명세2】
                + ', 20, 13, 8, 8, 4, 10, 10, 10, 10' //【거주자간 주택임차차입금 원리금 상환액 - 금전소비대차 계약내용2】
                + ', 20, 13, 1, 5, 100, 8, 8, 10'     //【거주자간 주택임차차입금 원리금 상환액 - 임대차 계약내용2】
                + ', 20, 13, 1, 5, 100, 8, 8, 10, 10' //【월세액 소득공제명세3】
                + ', 20, 13, 8, 8, 4, 10, 10, 10, 10' //【거주자간 주택임차차입금 원리금 상환액 - 금전소비대차 계약내용3】
                + ', 20, 13, 1, 5, 100, 8, 8, 10';    //【거주자간 주택임차차입금 원리금 상환액 - 임대차 계약내용3】

      strSize := StringReplace(strSize, ' ', '',[rfReplaceAll, rfIgnoreCase]);
      for j := 1 to 84 do
      begin
        intSize := StrToInt(subStr(strSize, j, ','));

        G[j] := Copy(AnsiString(chkList.Strings[i]), startNo, intSize);

form1.Memo1.Lines.Add('G  ▶ ' + inttostr(j) + ' ▶ ' + inttostr(intSize) + ' ▶ ' +  G[j] + ' ▶ ' + inttostr(startNo));


        startNo :=  startNo + intSize;
      end;

      //【자료관리번호】
      //G1 레코드 구분 X(1)
      //영문 대문자 ‘G’ 아니면 오류
      //G2 자료구분 9(2)
      //‘20’이 아니면 오류
      //G3 세무서코드 X(3)
      //세무서코드[G3] ≠ 세무서코드[B3]이면 오류
      if G[1] <> 'G' then errList.Add(errStr('G1', '레코드 구분', mName, idNo));
      if G[2] <> '20' then errList.Add(errStr('G2', '자료구분', mName, idNo));
      if G[3] <> btaxOffice then errList.Add(errStr('G3', '세무서코드', mName, idNo));

      //【원천징수의무자】
      //G5 사업자등록번호 X(10)
      //사업자등록번호[G5] ≠ 사업자등록번호[B5]이면 오류
      if G[5] <> bBizNo then errList.Add(errStr('G5', '사업자등록번호', mName, idNo));

      //【소득자】
      //G6 소득자 주민등록번호 X(13)
      //[G6] ≠ [C12] 이면 오류
      if G[6] <> IdNo then errList.Add(errStr('G6', '소득자 주민등록번호', mName, idNo));

      //***********************************************************반복시작

      //gLength := 35;
      gCond := 0;
      for gRelationCnt := 7 to 84 do
      begin
        //gRepeatCnt := 0;
        //gLength := gLength + Length(G[gRelationCnt]);

        //16, 25, 33, 42, 51, 59, 68, 77
        //16 ~ 68 범위에 해당하는 경우는 gRelaionCnt + 7로 넘겨주고 싶지만 for문 초기값 변경 시 에러발생하므로 제외
        if gRelationCnt in [16..77] then
        begin
          if not isEmpty0(G[gRelationCnt]) then
          begin
            if gRelationCnt = 77 then
              Break
            else
              Continue;
          end;

          //if not isEmpty0(Copy(chkList.Strings[i], gLength + 1, Length(chkList.Strings[i]) - gLength)) then
          // Break;
        end;

        case gRelationCnt of
          7..32:
            gRepeatCnt := 26*0;
          33..58:
            gRepeatCnt := 26*1;
          59..84:
            gRepeatCnt := 26*2;
        end;

        //해당 위치에서 비교할 조건을 설정한다.
        gCond := gRelationCnt - gRepeatCnt - 6;

        //【월세액 소득공제명세1】
        // - 월세액 소득공제 명세가 없는 소득자는 월세액 소득공제명세1?2?3의 각 항목에 기본값
        //(문자인 경우 공란, 숫자인 경우 ‘0’)을 수록합니다.

        if gCond = 1 then
        begin
          //G7 임대인 성명(상호) X(20)
          //기재되어 있지 않으면 오류
          if not isEmpty(G[7 + gRepeatCnt]) then errList.Add(errStr('G'+IntToStr(7 + gRepeatCnt), '임대인 성명(상호)', mName, idNo));
        end
        else if gCond = 2 then
        begin
          //G8 주민등록번호(사업자등록번호) X(13)
          //1.기재되어 있지 않으면 오류
          //2.잘못된 주민(사업자)등록번호 입력 시 오류
          //3.소득자주민번호(G6)와 일치하면 오류
          if not isEmpty(G[8 + gRepeatCnt]) then
            errList.Add(errStr('G'+IntToStr(8 + gRepeatCnt), '주민등록번호(사업자등록번호)', mName, idNo))
          else
          begin
            if G[6] = G[8 + gRepeatCnt] then
              errList.Add(errStr('G'+IntToStr(8 + gRepeatCnt), '주민등록번호(사업자등록번호)', mName, idNo))
            else
            begin
              if Length(Trim(G[8 + gRepeatCnt])) = 13 then
              begin
                if not chkIdNo(G[8 + gRepeatCnt]) then
                  errList.Add(errStr('G'+IntToStr(8 + gRepeatCnt), '주민등록번호(사업자등록번호)', mName, idNo))
              end
              else if Length(Trim(G[8 + gRepeatCnt])) = 10 then
              begin
                if not chkBizRegNo(G[8 + gRepeatCnt]) then
                  errList.Add(errStr('G'+IntToStr(8 + gRepeatCnt), '주민등록번호(사업자등록번호)', mName, idNo))
              end;
            end;
          end;
        end
        else if gCond = 3 then
        begin
          //G9 주택유형 X(1)
          //1.기재되어 있지 않으면 오류
          //2.(‘1’, ‘2’, ‘3’, ‘4’, ‘5’, ‘6’, ‘7’, ‘8’)이 아니면 오류
          if not isEmpty(G[9 + gRepeatCnt]) then
            errList.Add(errStr('G'+IntToStr(9 + gRepeatCnt), '주택유형', mName, idNo))
          else
          begin
            if Pos(G[9 + gRepeatCnt], '[1][2][3][4][5][6][7][8]') = 0 then
              errList.Add(errStr('G'+IntToStr(9 + gRepeatCnt), '주택유형', mName, idNo));
          end;
        end
        else if gCond = 4 then
        begin
          //G10 (월세)주택계약면적(㎡) 9(5)
          //주택계약면적(m2)을기재
          // -정수3자리+소수2자리기재
          //※예) 85.32㎡ → '08532', 78.3㎡ → '07830',  140㎡ → '14000'
          //기재되어 있지 않으면 오류
          //※주택유형이 고시원(‘7’)인 경우, ‘00000’ 기재 가능
          if (G[9 + gRepeatCnt] <> '7') and (G[10 + gRepeatCnt] = '00000') then
            errList.Add(errStr('G'+IntToStr(10 + gRepeatCnt), '(월세)주택계약면적(㎡)', mName, idNo));
        end
        else if gCond = 5 then
        begin
          //G11 임대차계약서상 주소지 X(100)
          //기재되어 있지 않으면 오류
          if not isEmpty(G[11 + gRepeatCnt]) then
            errList.Add(errStr('G'+IntToStr(11 + gRepeatCnt), '임대차계약서상 주소지', mName, idNo));
        end
        else if gCond = 6 then
        begin
          //G12 임대차계약기간 시작 9(8)
          //1.[G12] > [G13]이면 오류
          //2.날짜 형식(YYYYMMDD)에 맞지 않으면 오류
          //3.해당과세기간이 임대차계약기간에 포함되어 있지 않으면 오류
          if G[12 + gRepeatCnt] > G[13 + gRepeatCnt] then
            errList.Add(errStr('G'+IntToStr(12 + gRepeatCnt), '임대차계약기간 시작', mName, idNo))
          else
          begin
            if not isDate(G[12 + gRepeatCnt]) then
              errList.Add(errStr('G'+IntToStr(12 + gRepeatCnt), '임대차계약기간 시작', mName, idNo))
            else
            begin
              // 2017-12-31 보다 크면 해당과세기간에 포함되어 있지 않음
              if G[12 + gRepeatCnt] > FormatDateTime('yyyymmdd', yyyyDt) then
                errList.Add(errStr('G'+IntToStr(12 + gRepeatCnt), '임대차계약기간 시작', mName, idNo))
            end;
          end;
        end
        else if gCond = 7 then
        begin
          //G13 임대차계약기간 종료 9(8)
          //1.날짜 형식(YYYYMMDD)에 맞지 않으면 오류
          //2.해당과세기간이 임대차계약기간에 포함되어 있지 않으면 오류
          if not isDate(G[13 + gRepeatCnt]) then
            errList.Add(errStr('G'+IntToStr(13 + gRepeatCnt), '임대차계약기간 종료', mName, idNo))
          else
          begin
            // 2017-01-01 보다 작으면 해당과세기간에 포함되어 있지 않음
            // 2016-01-01 ~ 2018-01-01 (O)
            // 2016-01-01 ~ 2017-01-01 (O)
            // 2016-01-01 ~ 2016-12-30 (X)
            if G[13 + gRepeatCnt] < FormatDateTime('yyyymmdd', StartOfTheYear(yyyyDt)) then
              errList.Add(errStr('G'+IntToStr(13 + gRepeatCnt), '임대차계약기간 시작', mName, idNo))
          end;
        end
        else if gCond = 8 then
        begin
          //G14 연간 월세액(원) 9(10)
          //기재되어 있지 않으면 오류
          if strToFloat(G[14 + gRepeatCnt]) = 0 then
            errList.Add(errStr('G'+IntToStr(14 + gRepeatCnt), '연간 월세액(원)', mName, idNo));
        end
        else if gCond = 9 then
        begin
          //G15 세액공제금액(원) 9(10)
          //1.세액공제금액 > 연간 월세액 × 10%이면 오류
          //2.세액공제금액 > 75만원이면 오류
          if strToFloat(G[15 + gRepeatCnt]) > strToFloat(G[14 + gRepeatCnt]) * 0.1 then
            errList.Add(errStr('G'+IntToStr(15 + gRepeatCnt), '세액공제금액(원)', mName, idNo))
          else
          begin
            if strToFloat(G[15 + gRepeatCnt]) > 750000 then
              errList.Add(errStr('G'+IntToStr(15 + gRepeatCnt), '세액공제금액(원)', mName, idNo))
          end;
        end
        else if gCond = 10 then
        begin
          //【거주자간 주택임차차입금 원리금 상환액 - 금전소비대차 계약내용1】
          //G16 대주(貸主) 성명 X(20)
          //기재되어 있지 않으면 오류
          if not isEmpty(G[16 + gRepeatCnt]) then
            errList.Add(errStr('G'+IntToStr(16 + gRepeatCnt), '대주(貸主) 성명', mName, idNo));
        end
        else if gCond = 11 then
        begin
          //G17 대주 주민등록번호 X(13)
          //기재되어 있지 않으면 오류
          if not isEmpty(G[17 + gRepeatCnt]) then
            errList.Add(errStr('G'+IntToStr(17 + gRepeatCnt), '대주 주민등록번호', mName, idNo));
        end
        else if gCond = 12 then
        begin
          //G18 금전 소비대차 계약기간 시작 9(8)
          //금전 소비대차 계약기간의 시작연월일수록
          //예) 2015년 11월 1일 → ‘20151101‘
          //1.[G18] > [G19] 이면 오류
          //2.날짜 형식에 맞지 않으면 오류
          //3.해당과세기간이 금전 소비대차 계약기간에 포함되어 있지 않으면 오류
          if G[18 + gRepeatCnt] > G[19 + gRepeatCnt] then
            errList.Add(errStr('G'+IntToStr(18 + gRepeatCnt), '금전 소비대차 계약기간 시작', mName, idNo))
          else
          begin
            if not isDate(G[18 + gRepeatCnt]) then
              errList.Add(errStr('G'+IntToStr(18 + gRepeatCnt), '금전 소비대차 계약기간 시작', mName, idNo))
            else
            begin
              if G[18 + gRepeatCnt] > FormatDateTime('yyyymmdd', yyyyDt) then
                errList.Add(errStr('G'+IntToStr(18 + gRepeatCnt), '금전 소비대차 계약기간 시작', mName, idNo))
            end;
          end;
        end
        else if gCond = 13 then
        begin
          //G19 금전 소비대차 계약기간 종료 9(8)
          //금전 소비대차 계약기간의 종료연월일수록
          //예) 2017년 10월 31일 → ‘20171031‘
          //1.날짜 형식에 맞지 않으면 오류
          //2.해당과세기간이 금전 소비대차 계약기간에 포함되어 있지 않으면 오류
          if not isDate(G[19 + gRepeatCnt]) then
            errList.Add(errStr('G'+IntToStr(19 + gRepeatCnt), '금전 소비대차 계약기간 종료', mName, idNo))
          else
          begin
            if G[19 + gRepeatCnt] < FormatDateTime('yyyymmdd', StartOfTheYear(yyyyDt)) then
              errList.Add(errStr('G'+IntToStr(19 + gRepeatCnt), '금전 소비대차 계약기간 종료', mName, idNo))
          end;
        end
        else if gCond = 14 then
        begin
          //G20 차입금 이자율 9(4)
          //-소수점 2자리까지 수록
          //※예)14.10% → ‘1410’, 0.95% → '0095'
          //N 기재 형식에 맞지 않으면 오류
        end
        else if gCond = 15 then
        begin
          //G21 원리금 상환액 계 9(10)
          //해당 과세기간에 상환한 원금, 이자의 합계와 일치하지 않으면 오류
          if strToFloat(G[21 + gRepeatCnt]) <> strToFloat(G[22 + gRepeatCnt]) + strToFloat(G[23 + gRepeatCnt])  then
            errList.Add(errStr('G'+IntToStr(21 + gRepeatCnt), '원리금 상환액 계', mName, idNo));
        end
        //G22, G23 오류검증 기준 없음
        else if gCond = 18 then
        begin
          //G24 공제금액 9(10)
          //공제금액 > 원리금 상환액 계 × 40%이면 오류
          if strToFloat(G[24 + gRepeatCnt]) > strToFloat(G[21 + gRepeatCnt]) * 0.4 then
            errList.Add(errStr('G'+IntToStr(24 + gRepeatCnt), '공제금액', mName, idNo));
        end
        else if gCond = 19 then
        begin
          //【거주자간 주택임차차입금 원리금 상환액 - 임대차 계약내용1】
          //- 거주자간 주택임차차입금 원리금 상환액 공제가  없는 소득자는 거주자간 주택임차 차입금 원리금 상환액1?2?3의 각 항목에 기본값(문자인 경우 공란, 숫자인 경우 ‘0’)을 수록합니다.
          //G25 임대인 성명(상호) X(20)
          //기재되어 있지 않으면 오류
          if not isEmpty(G[25 + gRepeatCnt]) then
            errList.Add(errStr('G'+IntToStr(25 + gRepeatCnt), '임대인 성명(상호)', mName, idNo));
        end
        else if gCond = 20 then
        begin
          //G26 주민등록번호(사업자등록번호) X(13)
          //기재되어 있지 않으면 오류
          if not isEmpty(G[26 + gRepeatCnt]) then
            errList.Add(errStr('G'+IntToStr(26 + gRepeatCnt), '주민등록번호(사업자등록번호)', mName, idNo));
        end
        else if gCond = 21 then
        begin
          //G27 주택유형 X(1)
          //1.기재되어 있지 않으면 오류
          //2.(‘1’, ‘2’, ‘3’, ‘4’, ‘5’, ‘6’, ‘7’, ‘8’)이 아니면 오류
          if not isEmpty(G[27 + gRepeatCnt]) then
            errList.Add(errStr('G'+IntToStr(27 + gRepeatCnt), '주택유형', mName, idNo))
          else
          begin
            if Pos(G[27 + gRepeatCnt], '[1][2][3][4][5][6][7][8]') = 0 then
              errList.Add(errStr('G'+IntToStr(27 + gRepeatCnt), '주택유형', mName, idNo))
          end;
        end
        else if gCond = 22 then
        begin
          //G28 (임대차)주택계약면적(㎡) 9(5)
          //기재되어 있지 않으면 오류
          //※주택유형이 고시원(‘7’)인 경우, ‘00000’ 기재 가능
          if (G[27 + gRepeatCnt] <> '7') and (G[28 + gRepeatCnt] = '00000') then
            errList.Add(errStr('G'+IntToStr(28 + gRepeatCnt), '(임대차)주택계약면적(㎡)', mName, idNo));
        end
        else if gCond = 23 then
        begin
          //G29 임대차계약서상 주소지 X(100)
          //기재되어 있지 않으면 오류
          if not isEmpty(G[29 + gRepeatCnt]) then
            errList.Add(errStr('G'+IntToStr(29 + gRepeatCnt), '임대차계약서상 주소지', mName, idNo));
        end
        else if gCond = 24 then
        begin
          //G30 임대차계약기간 시작 9(8)
          //1.임대차계약기간 시작연월일 > 임대차계약기간 종료연월일이면 오류
          //2.날짜 형식에 맞지 않으면 오류
          //3.해당과세기간이 임대차계약기간에 포함되어 있지 않으면 오류
          if G[30 + gRepeatCnt] > G[31 + gRepeatCnt] then
            errList.Add(errStr('G'+IntToStr(30 + gRepeatCnt), '임대차계약기간 시작', mName, idNo))
          else
          begin
            if not isDate(G[30 + gRepeatCnt]) then
              errList.Add(errStr('G'+IntToStr(30 + gRepeatCnt), '임대차계약기간 시작', mName, idNo))
            else
            begin
              if G[30 + gRepeatCnt] > FormatDateTime('yyyymmdd', yyyyDt) then
                errList.Add(errStr('G'+IntToStr(30 + gRepeatCnt), '임대차계약기간 시작', mName, idNo))
            end;
          end;
        end
        else if gCond = 25 then
        begin
          //G31 임대차계약기간 종료 9(8)
          //1.임대차계약기간 시작연월일 > 임대차계약기간 종료연월일이면 오류
          //2.날짜 형식에 맞지 않으면 오류
          //3.해당과세기간이 임대차계약기간에 포함되어 있지 않으면 오류
          if not isDate(G[31 + gRepeatCnt]) then
            errList.Add(errStr('G'+IntToStr(31 + gRepeatCnt), '임대차계약기간 종료', mName, idNo))
          else
          begin
            if G[31 + gRepeatCnt] < FormatDateTime('yyyymmdd', StartOfTheYear(yyyyDt)) then
              errList.Add(errStr('G'+IntToStr(31 + gRepeatCnt), '임대차계약기간 종료', mName, idNo))
          end;
        end
        else if gCond = 26 then
        begin
          //G32 전세보증금 9(10)
          //기재되어 있지 않으면 오류
          if strToFloat(G[32 + gRepeatCnt]) = 0 then
            errList.Add(errStr('G'+IntToStr(32 + gRepeatCnt), '전세보증금', mName, idNo));
        end;
      end;
    end;

    if Copy(AnsiString(chkList.Strings[i]), 1, 1) = 'H' then
    begin
      //hIdNo := ''; hMname := '';

      System.FillChar(H, SizeOf(H), #0);

      //배열길이 할당 H[1] ~ H[19]만 사용한다
      SetLength(H, 20);

      strSize := '1, 2, 3, 6'  //자료관리번호
              + ', 10'         //원천징수의무자
              + ', 13, 1, 30'  //소득자(연말정산신청자)
              + ', 2, 4, 13, 13, 13, 13, 13, 13, 13, 5, 1452'; //기부금조정명세

      strSize := StringReplace(strSize, ' ', '',[rfReplaceAll, rfIgnoreCase]);
      for j := 1 to 19 do
      begin
        intSize := StrToInt(subStr(strSize, j, ','));

        H[j] := Copy(AnsiString(chkList.Strings[i]), startNo, intSize);

form1.Memo1.Lines.Add('H  ▶ ' + inttostr(j) + ' ▶ ' + inttostr(intSize) + ' ▶ ' +  H[j] + ' ▶ ' + inttostr(startNo));

        startNo :=  startNo + intSize;
      end;

      //【자료관리번호】
      //H1 레코드 구분 X(1)
      //영문 대문자 ‘H’ 아니면 오류
      if H[1] <> 'H' then errList.Add(errStr('H1', '레코드 구분', mName, idNo));

      //H2 자료구분 9(2)
      //‘20’이 아니면 오류
      if H[2] <> '20' then errList.Add(errStr('H2', '자료구분', mName, idNo));

      //H3 세무서 X(3)
      //세무서코드[H3] ≠ 세무서코드[B3]이면 오류
      if H[3] <> btaxOffice then errList.Add(errStr('H3', '세무서', mName, idNo));

      //사업자등록번호[H5] ≠ 사업자등록번호[B5]이면 오류
      if H[5] <> bBizNo then errList.Add(errStr('H5', '사업자등록번호', mName, idNo));

      //【소득자(연말정산신청자)】
      //H6 ④주민등록번호 X(13)
      //※C레코드의 소득자 주민등록번호(C12)와 항상 일치
      //1.기재되어 있지 않으면 오류
      //2.잘못된 주민등록번호 입력 시 오류

      if not isEmpty(H[6]) then
        errList.Add(errStr('H6', '주민등록번호', mName, idNo))
      else
      begin
        if idNo <> H[6] then
          errList.Add(errStr('H6', '주민등록번호', mName, idNo))
        else
        begin
          if not chkIdNo(H[6]) then
            errList.Add(errStr('H6', '주민등록번호', mName, idNo))
        end
      end;
     
      //H7 내/외국인 구분코드 9(1)
      //※C레코드의 소득자 내/외국인 구분코드(C11)와 항상 일치
      //(‘1’,‘9’)가 아니면 오류
      if Pos(H[7], '[1][9]') = 0 then errList.Add(errStr('H7', '내/외국인 구분코드', mName, idNo));

      //H8 ③성명 X(30)
      //기재되어 있지 않으면 오류
      if not isEmpty(H[8]) then errList.Add(errStr('H8', '성명', mName, idNo));

      //【기부금조정명세】
      //H9 ⑦유형⑧코드 X(2)
      //기부유형코드 ('10','20','40','41','42')가 아니면 오류
      if Pos(H[9], '[10][20][40][41][42]') = 0 then errList.Add(errStr('H9', '기부유형코드', mName, idNo));

      //H10 기부연도 9(04)
      // -법정기부금(10): ‘2014’, ‘2015’, ‘2016’, '2017'이 아니면 오류
      // -정치자금기부금(20), 우리사주조합기부금(42) : '2017‘이 아니면 오류
      // -종교단체외 지정기부금(40), 종교단체 지정기부금(41) : (‘2012’, '2013', ‘2014’, ‘2015’, ‘2016’, ‘2017’)이  아니면 오류
      if H[9] = '10' then
      begin
        if Pos(H[10], '[2014][2015][2016][2017]') = 0 then
         errList.Add(errStr('H10', '기부연도', mName, idNo));
      end
      else if (H[9] = '20') or (H[9] = '42')  then
      begin
        if H[10] <> '2017' then
          errList.Add(errStr('H10', '기부연도', mName, idNo));
      end
      else if (H[9] = '40') or (H[9] = '41') then
      begin
        if Pos(H[10], '[2012][2013][2014][2015][2016][2017]') = 0 then
          errList.Add(errStr('H10', '기부연도', mName, idNo));
      end;

      //H11 기부금액 9(13)
      //1.기부금액 <= 0 이면 오류
      //2.[H10] = '2017'인 경우
      //N ­ [H11] ≠ [[H9]=[I7]인 [I16]의 합계] 이면 오류
      // ­ [H11] ≠ [H13] 이면 오류
      //3.[H11] ≠ [[H12] + [H13]] 이면 오류
      if strToFloat(H[11]) <= 0 then
        errList.Add(errStr('H11', '기부금액', mName, idNo))
      else
      begin
        if (H[10] = '2017') and (H[11] <> H[13]) then
          errList.Add(errStr('H11', '기부금액', mName, idNo))
        else if strToFloat(H[11]) <> strToFloat(H[12]) + strToFloat(H[13]) then
          errList.Add(errStr('H11', '기부금액', mName, idNo));
      end;

      //H12 전년까지 공제된 금액 9(13)
      //1.전년까지공제된금액 < 0 이면 오류
      //2.기부연도가 '2017'인 경우 전년까지 공제된금액≠0이면 오류
      //3.전년까지공제된금액 ≥ 기부금액[H11]이면 오류
      //4.기부유형코드가 정치자금기부금(20), 우리사주조합기부금(42)인데 전년까지 공제된금액 ≠0 이면 오류
      if strToFloat(H[12]) < 0 then
      begin
        errList.Add(errStr('H12', '전년까지 공제된 금액', mName, idNo))
      end
      else
      begin
        if (H[10] = '2017') and (strToFloat(H[12]) <> 0) then
          errList.Add(errStr('H12', '전년까지 공제된 금액', mName, idNo))
        else if strToFloat(H[12]) >= strToFloat(H[11]) then
          errList.Add(errStr('H12', '전년까지 공제된 금액', mName, idNo))
        else if (Pos(H[9], '[20][42]') > 0) and (strToFloat(H[12]) <> 0) then
          errList.Add(errStr('H12', '전년까지 공제된 금액', mName, idNo));
      end;

      //H13 공제대상금액 9(13)
      //1.공제대상금액 <= 0 이면 오류
      //2.[H13] ≠ [H15 + H16 + H17] 이면 오류
      if strToFloat(H[13]) <= 0 then
        errList.Add(errStr('H13', '공제대상금액-1', mName, idNo))
      else if strToFloat(H[13]) <> strToFloat(H[15]) + strToFloat(H[16]) + strToFloat(H[17]) then
        errList.Add(errStr('H13', '공제대상금액-2', mName, idNo));

      //H14 해당연도 공제금액 필요경비 9(13)
      //‘0000000000000’ 아니면 오류
      if H[14] <> '0000000000000' then
        errList.Add(errStr('H14', '해당연도 공제금액 필요경비', mName, idNo));

      //H15 해당연도 공제금액_세액(소득)공제 9(13)
      //1.해당 연도 세액(소득)공제금액 < 0 이면 오류
      //2.해당 연도 세액(소득)공제금액 > 공제대상금액[H13] 이면 오류
      if strToFloat(H[15]) < 0 then
        errList.Add(errStr('H15', '해당연도 공제금액_세액(소득)공제', mName, idNo))
      else if strToFloat(H[15]) > strToFloat(H[13]) then
        errList.Add(errStr('H15', '해당연도 공제금액_세액(소득)공제', mName, idNo));

      //C141, C143, C145, C147, C149, C150ⓐ
      if H[10] >= '2014' then
      begin
        if H[9] = '10' then
          h10DonationAmt := h10DonationAmt + strToFloat(H[15])  //C141, C143
        else if H[9] = '40' then
          h40DonationAmt := h40DonationAmt + strToFloat(H[15])  //C145
      end;

      if H[9] = '20' then
        h20DonationAmt := h20DonationAmt + strToFloat(H[15])  //C145
      else if H[9] = '41' then
        h41DonationAmt := h41DonationAmt + strToFloat(H[15])  //C149
      else if H[9] = '42' then
        h42DonationAmt := h42DonationAmt + strToFloat(H[15]); //C150ⓐ

      //H16 해당 연도에 공제받지 못한금액_소멸금액 9(13)
      //1.소멸금액 < 0 이면 오류
      //2.소멸금액  > 공제대상금액[H13] 이면 오류
      //3.이월금액([H17])이 기재되어 있는데 소멸금액 ≠ 0 이면 오류
      //4.법정기부금(10) 이면서 기부연도가(‘2014’,‘2015’,‘2016’,‘2017’)인 경우 소멸금액 ≠ 0 이면 오류
      //5.종교단체외 지정기부금(40), 종교단체 지정기부금(41) 이면서
      //기부연도가 (‘2013’,‘2014’,‘2015’,‘2016’,‘2017’)인 경우 소멸금액 ≠ 0 이면 오류

      //오류기준변경(2018.02.08) //▶5. 종교단체외 지정기부금(40), 종교단체 지정기부금(41) 이면서
      //기부연도가 (‘2013’,‘2014’,‘2015’,‘2016’)인 경우 소멸금액 ≠ 0 이면 오류
      if strToFloat(H[16]) < 0 then
        errList.Add(errStr('H16', '해당 연도에 공제받지 못한금액_소멸금액-1', mName, idNo))
      else
      begin
        if strToFloat(H[16]) > strToFloat(H[13]) then
          errList.Add(errStr('H16', '해당 연도에 공제받지 못한금액_소멸금액-2', mName, idNo))
        else if (strToFloat(H[17]) > 0) and (strToFloat(H[16]) <> 0) then
          errList.Add(errStr('H16', '해당 연도에 공제받지 못한금액_소멸금액-3', mName, idNo))
        else if (H[9] = '10') and (Pos(H[10], '[2014][2015][2016][2017]') > 0) and (strToFloat(H[16]) <> 0) then
          errList.Add(errStr('H16', '해당 연도에 공제받지 못한금액_소멸금액-4', mName, idNo))
        else if (Pos(H[9], '[40][41]') > 0) and (Pos(H[10], '[2013][2014][2015][2016]') > 0) and (strToFloat(H[16]) <> 0) then
          errList.Add(errStr('H16', '해당 연도에 공제받지 못한금액_소멸금액-5', mName, idNo));
      end;

      //H17 해당 연도에 공제받지못한금액_이월금액 9(13)
      //1.이월금액 < 0 이면 오류
      //2.이월금액 > 공제대상금액[H13] 이면 오류
      //3.정치자금기부금('20'), 우리사주조합기부금('42')인 경우 이월금액 ≠ 0 이면 오류
      //4.소멸금액([H16])이 기재되어 있는데 이월금액 ≠ 0 이면 오류
      //5.종교단체외 지정기부금(40), 종교단체 지정기부금(41) 이면서 기부연도가 ‘2012’인 경우 이월금액 ≠ 0 이면 오류
      if strToFloat(H[17]) < 0 then
        errList.Add(errStr('H17', '해당 연도에 공제받지못한금액_이월금액', mName, idNo))
      else if strToFloat(H[17]) > strToFloat(H[13]) then
        errList.Add(errStr('H17', '해당 연도에 공제받지못한금액_이월금액', mName, idNo))
      else if (Pos(H[9], '[20][42]') > 0) and (strToFloat(H[17]) <> 0) then
        errList.Add(errStr('H17', '해당 연도에 공제받지못한금액_이월금액', mName, idNo))
      else if (strToFloat(H[16]) > 0) and (strToFloat(H[17]) <> 0) then
        errList.Add(errStr('H17', '해당 연도에 공제받지못한금액_이월금액', mName, idNo))
      else if (Pos(H[9], '[40][41]') > 0) and (H[10] = '2012') and (strToFloat(H[17]) <> 0) then
        errList.Add(errStr('H17', '해당 연도에 공제받지못한금액_이월금액', mName, idNo));

      //H18 기부금조정명세 일련번호 9(05)
      //기재되어 있지 않으면 오류
      if not isEmpty(H[18]) then errList.Add(errStr('H18', '기부금조정명세 일련번호', mName, idNo));
    end;

    if Copy(AnsiString(chkList.Strings[i]), 1, 1) = 'I' then
    begin
      System.FillChar(iRecord, SizeOf(iRecord), #0);

      //배열길이 할당 I[1] ~ I[20]만 사용한다
      SetLength(iRecord, 21);

      strSize := '1, 2, 3, 6' //자료관리번호
              + ', 10'        //원천징수의무자
              + ', 13'        //소득자(연말정산신청자)
              + ', 2'         //기부유형코드
              + ', 13, 30'                      //기부처
              + ', 1, 1, 20, 13'                //기부자
              + ', 5, 13, 13, 13, 13, 5, 1443'; //기부내역

      strSize := StringReplace(strSize, ' ', '',[rfReplaceAll, rfIgnoreCase]);
      for j := 1 to 20 do
      begin
        intSize := StrToInt(subStr(strSize, j, ','));

        iRecord[j] := Copy(AnsiString(chkList.Strings[i]), startNo, intSize);

form1.Memo1.Lines.Add('iRecord  ▶ ' + inttostr(j) + ' ▶ ' + inttostr(intSize) + ' ▶ ' +  iRecord[j] + ' ▶ ' + inttostr(startNo));


        startNo :=  startNo + intSize;
      end;

      //【자료관리번호】
      //I1 레코드 구분 X(1)
      //영문 대문자 ‘I’ 아니면 오류
      if iRecord[1] <> 'I' then errList.Add(errStr('I1', '레코드 구분', mName, idNo));

      //I2 자료구분 9(2)
      //‘20’이 아니면 오류
      if iRecord[2] <> '20' then errList.Add(errStr('I2', '자료구분', mName, idNo));

      //I3 세무서코드 X(3)
      //세무서코드[I3] ≠ 세무서코드[B3]이면 오류}
      if iRecord[3] <> btaxOffice then errList.Add(errStr('I3', '세무서', mName, idNo));

      //【원천징수의무자】
      //I5 ②사업자등록번호 X(10)
      //1.[I5] ≠ 사업자등록번호[B5]이면 오류
      //2.잘못된 사업자등록번호 입력 시 오류
      if iRecord[5] <> bBizNo then
        errList.Add(errStr('I5', '사업자등록번호', mName, idNo))
      else
      begin
        if not chkBizRegNo(iRecord[5]) then
          errList.Add(errStr('I5', '사업자등록번호', mName, idNo))
      end;

      //【소득자(연말정산신청자)】
      //I6 ④소득자주민등록번호 X(13)
      //소득자주민등록번호[I6] ≠ 소득자주민등록번호[C6]이면 오류
      if IdNo <> iRecord[6] then errList.Add(errStr('I6', '소득자주민등록번호', mName, idNo));

      //【기부유형코드】
      //I7 ⑦유형⑧코드 X(2)
      //1.기부유형코드 ('10','20','40','41','42')가 아니면 오류
      //2.기부유형코드가 ('20','42')인데 관계코드가 거주자(본인)이 아니면(I10 ≠'1') 오류
      //N 3.기부금조정명세(H레코드)에 기부연도 ‘2017’인 기부유형코드(I7)의 자료가 없으면 오류
      if Pos(iRecord[7], '[10][20][40][41][42]') = 0 then
        errList.Add(errStr('I7', '기부유형코드', mName, idNo))
      else if (Pos(iRecord[7], '[20][42]') > 0) and (iRecord[10] <> '1') then
        errList.Add(errStr('I7', '기부유형코드', mName, idNo));

      //【기부처】
      //I8 ⑪사업자(주민)등록번호 X(13)
      //1.기재되어 있지 않으면 오류(단, 정치자금기부금([I7]=‘20’)인 경우 공란 가능,
      //회사일괄기부금([I9]=“회사일괄기부금”)인 경우 공란 아니면 오류)
      //2.잘못된 주민등록번호 입력 시 오류
      //3.기부장려금신청금액[I15] > 0 인 경우, 잘못된 사업자등록번호 입력 시 오류
      iRecord[8] := StringReplace(iRecord[8], ' ', '',[rfReplaceAll, rfIgnoreCase]);
      if not isEmpty(iRecord[8]) then
      begin
        if iRecord[7] <> '20' then errList.Add(errStr('I8', '사업자(주민)등록번호-1', mName, idNo));
      end
      else
      begin
        if Trim(iRecord[9]) = '회사일괄기부금' then
          errList.Add(errStr('I8', '사업자(주민)등록번호-2', mName, idNo))
        else
        begin
          if (length(iRecord[8]) = 13) and (not chkIdNo(iRecord[8])) then
            errList.Add(errStr('I8', '사업자(주민)등록번호-3 ', mName, idNo))
          else if (strToFloat(iRecord[15]) > 0) and (not chkBizRegNo(iRecord[8])) then
            errList.Add(errStr('I8', '사업자(주민)등록번호-4 ', mName, idNo));
        end;
      end;

      //I9 ⑩상호(법인명) X(30)
      //1.기재되어 있지 않으면 오류(단, 정치자금기부금([I7]=‘20’)인 경우 공란 가능)
      //2.회사일괄기부금(([I9]=“회사일괄기부금”)일 경우 기부처([I8])가 공란 아니면 오류
      if (not isEmpty(iRecord[9])) and (iRecord[7] <> '20') then
        errList.Add(errStr('I9', '상호(법인명)', mName, idNo))
      else if (Trim(iRecord[9]) = '회사일괄기부금') and (isEmpty(iRecord[8])) then
        errList.Add(errStr('I9', '상호(법인명)', mName, idNo));

      //【기부자】
      //I10 ⑫관계코드 X(1)
      //(‘1’,‘2’,‘3’,‘4’,‘5’,‘6’)이 아니면 오류
      if Pos(iRecord[10], '[1][2][3][4][5][6]') = 0 then
        errList.Add(errStr('I10', '관계코드', mName, idNo));

      //I11 내/외국인 구분코드
      //(‘1’,‘9’)가 아니면 오류
      if Pos(iRecord[11], '[1][9]') = 0 then errList.Add(errStr('I11', '내/외국인 구분코드', mName, idNo));

      //I12 ⑫성명 X(20)
      //기재되어 있지 않으면 오류
      if not isEmpty(iRecord[12]) then errList.Add(errStr('I12', '성명', mName, idNo));

      //I13 ⑫주민등록번호 X(13)
      //1.기재되어 있지 않으면 오류
      //2.잘못된 주민등록번호 입력 시 오류
      if not isEmpty(iRecord[13]) then
        errList.Add(errStr('I13', '주민등록번호', mName, idNo))
      else if not chkIdNo(iRecord[13]) then
        errList.Add(errStr('I13', '주민등록번호', mName, idNo));

      //【기부내역】
      //I14 건수 9(5)
      //건수 <= 0 이면 오류
      if strToInt(iRecord[14]) <= 0 then errList.Add(errStr('I14', '건수', mName, idNo));

      //I15 ⑬기부금합계금액
      //연간 기부금액 기재
      //1. [I15] <= 0 이면 오류
      //2. [I15] ≠ [I16] + [I17] + [I18]이면 오류
      if strToFloat(iRecord[15]) <= 0 then
        errList.Add(errStr('I15', '기부금합계금액', mName, idNo))
      else if strToFloat(iRecord[15]) <> strToFloat(iRecord[16]) + strToFloat(iRecord[17]) + strToFloat(iRecord[18]) then
        errList.Add(errStr('I15', '기부금합계금액', mName, idNo));

      //I16 ⑭공제대상기부금액 9(13)
      //[I16] < 0 이면 오류
      if strToFloat(iRecord[16]) < 0 then
        errList.Add(errStr('I16', '공제대상기부금액', mName, idNo));

      //I17 ⑮기부장려금신청금액
      //1.기부장려금신청금액([I17]) < 0 이면 오류
      //2.기부장려금신청금액([I17]) > 0 일 때 유형코드([I7])가 법정기부금 또는 지정기부금(‘10’,‘40’,‘41’)이 아니면 오류
      if strToFloat(iRecord[17]) < 0 then
        errList.Add(errStr('I17', '기부장려금신청금액', mName, idNo))
      else if (strToFloat(iRecord[17]) > 0) and (Pos(iRecord[7], '[10][40][41]') = 0 ) then
        errList.Add(errStr('I17', '기부장려금신청금액', mName, idNo));

      //I18 ?기타 9(13)
      //‘0000000000000’ 아니면 오류
      if iRecord[18] <> '0000000000000' then errList.Add(errStr('I18', '기타', mName, idNo));

      //I19 해당 연도 기부명세 일련번호 9(05)
      //기재되어 있지 않으면 오류
      if not isEmpty(iRecord[19]) then
        errList.Add(errStr('I19', '해당 연도 기부명세 일련번호', mName, idNo));
    end;

    if i = chkList.Count - 1 then
    begin
      if aRecordCnt > 1 then
        errList.Add('기본사항 - 3. 제출파일에 A레코드가 1개가 아니면 오류');

      // ■ 497, 500같은 오류점검 기준으로 보임
      if aPersonCnt <> bRecordCnt then
        errList.Add('기본사항 - 3. 제출파일에 수록되는 B레코드 수가 A레코드의 신고의무자수(항목14)와 일치하지 않으면 오류');

      if aPersonCnt <> bNo then
      begin
        errList.Add(errStr('A14', '신고의무자수'));
        errList.Add(errStr('B4', '일련번호'));
      end;

      //B9, B10, B11, B12, B13, B14
      if bRecordCnt = 1 then bRecordErrCompare;
      if cRecordCnt = 1 then cRecordErrCompare;
    end;

  end;

  Result := True;
  if errList.Count > 0 then
  begin
    if MessageDlg('*** 에러 ***' + #13#10 + errList.Text + #13
                    + '전산매체를 생성하시겠습니까?'
                    , mtConfirmation, [mbNo, mbYes], 0) = mrNo then
    begin
      ShowMessage('취소되었습니다.');
//form1.Memo7.lines.Add(#13#10 + errList.Text);
      Result := False;
    end;
  end;
end;
end.
