unit common_utils;

interface

uses
  SysUtils, Classes, Windows,
  DB, ZAbstractRODataset, ZAbstractDataset, ZDataset, ZConnection,
  Messages, Variants, Graphics, Controls, Forms, Dialogs, StdCtrls,
  VirtualTable, DateUtils, ComCtrls, CheckLst, cxCurrencyEdit, cxDBLookupComboBox, Winapi.Imm,
  Mask, DBGrids, Buttons;

// true, false -> Y, N���� ġȯ (üũ�ڽ�, ������ư�� checked ��ȯ �� ���)
function getYn(bool: Boolean): String;
// Y, N -> true, false �� ġȯ
function getBool(yn: String): Boolean;

// ȭ���庰 �Է� ������Ʈ �Ӽ� ����
{ obj : ������Ʈ��
  mode: ȭ����(0:����, 1:���, 2: ����, 3:����)
  e   : �ʼ�������(0:���ʼ�, 1:�ʼ�, 2:��Ȱ��)
}
procedure setObjEnable(const obj: TComponent; mode: Integer; e: Integer);

// ȭ���庰 ���� ������Ʈ �Ӽ� ����
procedure setCondEnable(const obj: TComponent; mode: Integer; e: Integer);

// split - ���ڿ� �����ڷ� ������ ���ϴ� ��ġ(����)�� ���� ��������
{ Str       : ���ڿ�
  Position  : ����
  Delimiter : ������
}
function splitCd(str: String; const position: Integer; const delimiter: string = ' '): string;
function splitStr(str: String; const position: Integer; const delimiter: string = ' '): string;

// �޺��ڽ� �˻�
procedure findCb(cb: TComboBox; key: Word);

// �����ڵ带 �޺��ڽ�, üũ����Ʈ�ڽ��� ����
{ dsNm      : TZQuery��
  vtTemp    : TVirtualTable��
  codeId    : �����ڵ�ID
  cbFirTxt  : �޺��ڽ� index 0�� text (A:��ü, S:�����ϼ���, N:����)
  cbNm      : �޺��ڽ���, üũ����Ʈ�ڽ���
}
//procedure setCbCommCode(dsNm: TZQuery; vtTemp: TVirtualTable; codeId, cbFirTxt: String; cbNm: TComboBox); overload;
//procedure setCbCommCode(dsNm: TZQuery; vtTemp: TVirtualTable; codeId, cbFirTxt: String; cbNm: TCheckListBox); overload;

// �޺��ڽ�, üũ����Ʈ�ڽ� ����
{ vt   : TZQuery��
  cbAb : �޺��ڽ� index 0�� text (A:��ü, S:�����ϼ���, N:����, C:�ڵ常, M:�ڵ��)
  cbNm : �޺��ڽ�
}
procedure setCb(vt: TVirtualTable; cbAb: String; cbNm: TWinControl);

// üũ����Ʈ�ڽ� ��ü ����, ����
procedure setCklAll(cklNm:TCheckListBox);

// üũ����Ʈ�ڽ� �ʱ�ȭ
procedure setCklInit(cklNm:TCheckListBox);

// üũ����Ʈ�ڽ� checked count
function getCklChkCnt(cklNm:TCheckListBox): Integer;
function getNCklChkCnt(cklNm:TCheckListBox): Integer;

// üũ����Ʈ�ڽ� üũ ���� �ڵ带 �޸�(,)�� ������ ���ڿ�(IN ����)
// 1:�ڵ�, 2:�ڵ尪
function getCklCondStr(cklNm:TCheckListBox; ab:Integer = 1): String;

// �޺��ڽ����� ������ �޺�text���� �ڵ尪�� ��������
function getCommCodeVal(cb: TComboBox): String; overload;
function getCommCodeVal(ckl: TCheckListBox): String; overload;

// üũ����Ʈ�ڽ����� ������ text���� �ڵ尪�� ��������
function getCodeValNm(ckl: TCheckListBox): String;

// �޺��ڽ����� value ��Ī code ��������
function getMatchValueCode(value: String; cbNm: TComboBox):String;

// �޺��ڽ����� code ��Ī index ��������
function getMatchCodeIdx(code: String; cbNm: TComboBox):Integer; overload;
function getMatchCodeIdx(code: String; ckl: TCheckListBox):Integer; overload;

// �޺��ڽ����� code ��Ī value ��������
function getMatchCodeVal(code: String; cbNm: TComboBox):String;

// �Է³�¥ ��ȿ�� üũ
function isDate(str: String): Boolean;

// �Է³�¥ From~To �Ⱓ üũ
function validPeriod(fromDt, toDt: TDateTime): Boolean;

// ��¥ �ʱ�ȭ : 1900-01-01
function initDt(): TDate;

// ���ڿ� null Ȯ��
function isEmpty(str: String): Boolean;

// �ʼ��Է��׸� Ȯ��
{ obj: �ʼ��Է�������Ʈ��
  lab: �ʼ��Է��׸� label
}
function chkExtVal(obj: TComponent; lab: String): Boolean;

// ����ڵ�Ϲ�ȣ ��ȿ�� Ȯ��
{ bizRegNo : ������(-) ������ ���� 10�ڸ� }
function chkBizRegNo(const bizRegNo: String): Boolean;

// ��ȭ��ȣ ��ȿ�� Ȯ��
{ telNo : ������(-) ������ ��ȭ��ȣ }
function chkTelNo(telNo: String): Boolean;

// ������� �����ִ� ����, ����, ���� ��ȸ
{ ab    : ���� (O:����, C:����, J:����)
  para1 : ab�� O, C �� ���� ����� ���տ��ڵ�(m_code),  J�� ����    �����ڵ�(c_code)
  para2 : ab�� O �� ����    ���α׷���                  C, J�� ���� �����ڵ�(o_code)
}
procedure inquiryOrg(vt: TVirtualTable; ab, para1, para2: String);

// ������ �׽�Ʈ ��Ʈ�� ����
procedure showCtrl(ctrl: TControl);

implementation

uses Unit1, coop_sql_updel;

var
  days: array[0..11] of Integer = (31,28,31,30,31,30,31,31,30,31,30,31);

// �����޼���
const
  MSG_ERR_CD1 = '���� ���� �׸��� �����ϴ�.';                       // �����ڵ� �����޼���1
  MSG_ERR_VAL1 = ' �׸��� �ʼ����Դϴ�.';                           // ��ȿ��Ȯ��1
  MSG_ERR_VAL2 = ' �׸��� �ʼ����ð��Դϴ�.';                       // ��ȿ��Ȯ��2
  MSG_ERR_VAL_DATE1 = '���� ������ �����ʽ��ϴ�.';                  // ��¥��ȿ��Ȯ��1
  MSG_ERR_VAL_DATE2 = '�Է±Ⱓ�� �������ڰ� �������ں��� Ů�ϴ�.'; // ��¥��ȿ��Ȯ��2
  MSG_ERR_MATCH_OCODE = '�ش� ���������� ERP��ü�ڵ带 Ȯ���ϼ���.';// �����ڵ�, ERP��ü�ڵ� ��Ī����


// ������ �׽�Ʈ ��Ʈ�� ����
procedure showCtrl(ctrl: TControl); overload;
begin
   if (mpst_code = 'H13080585') or (mpst_code = 'H14103898') then // H13080585 - ����
  begin
    if ctrl.Visible then
      ctrl.Visible := false
    else
      ctrl.Visible := True;
  end
  else
    ctrl.Visible := false;
end;

// true, false -> Y, N���� ġȯ
function getYn(bool: Boolean): String;
begin
  if bool = true then
    result := 'Y'
  else if bool = false then
    result := 'N';
end;

// Y, N -> true, false �� ġȯ
function getBool(yn: String): Boolean;
begin
  if yn = 'Y' then
    result := true
  else
    result := false;
end;

// splitCd - �ڵ� �޺��ڽ� ���ڿ� �����ڷ� ������ �ڵ�, �ڵ尪 ����
{ Str       : ���ڿ�
  Position  : 1-�ڵ�, 2-�ڵ尪
  Delimiter : ������
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

// splitStr - ���ڿ� �����ڷ� ������ ���ϴ� ��ġ(����)�� ���� ����
{ Str       : ���ڿ�
  Position  : ����
  Delimiter : ������
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

// �޺��ڽ����� ������ �޺�text���� �ڵ尪�� ��������
function getCommCodeVal(cb: TComboBox): String;
begin
  if ((cb.Items[0] = '�����ϼ���') or (cb.Items[0] = '��ü')) and (cb.ItemIndex = 0) then
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
  if ((Pos('����', ckl.Items[0]) > 0) or (ckl.Items[0] = '��ü')) and (ckl.ItemIndex = 0) then
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
  if ((Pos('����', ckl.Items[0]) > 0) or (ckl.Items[0] = '��ü')) and (ckl.ItemIndex = 0) then
  begin
      result := '';
  end
  else
  begin
      result := splitCd(ckl.Items.Strings[ckl.ItemIndex], 2, ' ');
  end;
end;

// �޺��ڽ����� value ��Ī code ��������
function getMatchValueCode(value: String; cbNm: TComboBox):String;
var
  i: Integer;
  code: String;
begin
  code := '';
  if ((cbNm.Items[0] = '�����ϼ���') or (cbNm.Items[0] = '��ü')) and (cbNm.ItemIndex = 0) then
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

// �޺��ڽ����� code ��Ī index ��������
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

// �޺��ڽ����� code ��Ī value ��������
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

// �޺��ڽ����� value ��Ī index ��������
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

// üũ����Ʈ�ڽ� ��ü ����, ����
procedure setCklAll(cklNm:TCheckListBox);
var i, chkCnt: Integer;
begin
  chkCnt := 0;

  if cklNm.ItemIndex = 0 then
  begin
    if cklNm.Checked[0] = True then // ��ü����
    begin
      for i := 1 to cklNm.Items.Count - 1 do
      begin

        cklNm.Checked[i] := True;
      end;
    end
    else if cklNm.Checked[0] = False then // ��ü����
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

// üũ����Ʈ�ڽ� �ʱ�ȭ
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

// üũ����Ʈ�ڽ� checked count
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

// üũ����Ʈ�ڽ� index 0�� ������ checked count
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

// üũ����Ʈ�ڽ� üũ ���� �ڵ带 �޸�(,)�� ������ ���ڿ�(IN ����) ����
// 1:�ڵ�, 2:�ڵ尪, 3:������� ��� [�����ڵ�-������ڵ�] �̹Ƿ� �ѹ� �� ó���Ѵ�.
// 4:���θ���Ʈ REGEXP ���� - ���߼��� ����� üũ����Ʈ�ڽ� [�����ڵ�-������ڵ�]���� �����ڵ常..
function getCklCondStr(cklNm:TCheckListBox; ab:Integer = 1): String;
var
  i: Integer;
  cond: String;
begin
  cond := '';

  for i := 1 to cklNm.Items.Count - 1 do // index 0(��ü����) ����
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

// �Է³�¥ ��ȿ�� üũ
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

    // ���� Ȯ��
    if (y mod 4 = 0) and (y mod 100 > 0) or (y mod 400 = 0) then
      days[1] := 29;

    if (m > 0) and (m < 13) and (d > 0) and (d <= days[m - 1]) then
        Result := true
    else
    begin
      ShowMessage('���� ������ �����ʽ��ϴ�.');
      Result := false;
    end;
  end
  else
  begin
    ShowMessage('���� ������ �����ʽ��ϴ�.');
    Result := false;
  end;
end;

// �Է³�¥ From~To �Ⱓ üũ
function validPeriod(fromDt, toDt: TDateTime): Boolean;
begin
  if CompareDateTime(fromDt, toDt) = 1 then // A=B(0), A>B(1), A<B(-1)
  begin
    ShowMessage('�Է±Ⱓ�� �������ڰ� �������ں��� Ů�ϴ�.');
    Result := False;
  end
  else
    Result := True;
end;

// ��¥ �ʱ�ȭ : 1900-01-01
function initDt: TDate;
begin
  result := StrToDate('1900/01/01');
end;

// ���ڿ� null Ȯ��
function isEmpty(str: String): Boolean;
begin
  if (Trim(str) = '') or (Length(Trim(str)) = 0) then
    result := False
  else
    result := True;
end;

// �ʼ��Է��׸� Ȯ��
{ obj: �ʼ��Է�������Ʈ��
  lab: �ʼ��Է��׸� label
}
function chkExtVal(obj: TComponent; lab: String): Boolean;
// �����޼���
const
  MSG_ERR_VAL1 = ' �׸��� �ʼ����Դϴ�.';     // ��ȿ��Ȯ��1
  MSG_ERR_VAL2 = ' �׸��� �ʼ����ð��Դϴ�.'; // ��ȿ��Ȯ��2
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
    if DateToStr(TDateTimePicker(obj).Date) = '1900/01/01' then // ����Ʈ�� ���� Ȯ��
    begin
      ShowMessage(lab + ' ���ڸ� Ȯ���ϼ���.');
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

// ����ڵ�Ϲ�ȣ ��ȿ�� Ȯ��
{bizRegNo : - ������ ���� 10�ڸ�}
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

// ��ȭ��ȣ ��ȿ�� Ȯ��
{ telNo : ������(-) ������ ��ȭ��ȣ }
function chkTelNo(telNo: String): Boolean;
var
  delimiter, localNo, middleNo, lastNo: string;
  i, val, cnt: Integer;
begin
  Result := True;
  delimiter := '-';

  // ������(-) ���� 2 Ȯ��
  i := 1; cnt := 0;
  while i <= Length(telNo) do
  begin
    if Copy(telNo,i,1) = delimiter then
      inc(cnt);
    inc(i);
  end;
  if cnt <> 2 then Result := False;

  // �������� �����ϰ� ���ڸ� �Է� Ȯ��
  if not TryStrToInt(StringReplace(telNo, '-', '', [rfReplaceAll]), val) then Result := False;

  localNo := splitStr(telNo, 1, delimiter);
  middleNo := splitStr(telNo, 2, delimiter);
  lastNo := splitStr(telNo, 3, delimiter);

  // ������ȣ ù�ڸ� 0 Ȯ��
  if Copy(telNo, 1, 1) <> '0' then Result := False;
  // ������ȣ ����Ȯ��
  if not Length(localNo) in [2,3] then Result := False;
  // �߰��ڸ���ȣ ����Ȯ��
  if not Length(middleNo) in [3,4] then Result := False;
  // ���ڸ���ȣ ����Ȯ��
  if Length(lastNo) <> 4 then Result := False;
end;

// ������� �����ִ� ����, ����, ���� ��ȸ
{ ab    : ���� (O:����, C:����, J:����)
  para1 : ab�� O, C �� ���� ����� ���տ��ڵ�(m_code),  J�� ����    �����ڵ�(c_code)
  para2 : ab�� O �� ����    ���α׷���                  C, J�� ���� �����ڵ�(o_code)
}
procedure inquiryOrg(vt: TVirtualTable; ab, para1, para2: String);
var
  ashStr, ashSQL, branchAb: String;

begin
  if ab = 'O' then // ����
  begin
    if (mpst_code = 'H13080585')or (mpst_code = 'H14103898') then // �����׽�Ʈ
    begin
      ashStr := '';
    end
    else
      ashStr := ' AND program_list LIKE "%' + para2 + '%"';

    ashSQL := 'SELECT o_code, o_name FROM org'
            + ' WHERE o_code IN (SELECT o_code FROM staff'
                                + ' WHERE m_code = "' + para1 + '"'
                                + ashStr
                                //+ ' AND o_code <> "0043"' // 2016-06-13 ���Ȱ�ǰ� ����
                                + ' AND admin_ab = "A")'
            + ' AND p_ab = "A"';
    if(mpst_code = 'H14103898') then
    begin
      ashSQL := 'SELECT o_code, o_name FROM org'
            + ' WHERE o_code';
    end;
    if (mpst_code = 'H11040050') then // ��ΰ��
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

  else if ab = 'C' then // ����
  begin
    Form1.lblCenter.Caption := '����';
    ashSQL := 'SELECT c_code'
            + ', (SELECT c_name FROM center WHERE c_code = staff_center.c_code) c_name '
            + ' FROM staff_center '
            + ' WHERE m_code = "' + para1 + '"'
            + ' AND o_code = "' + para2 + '"'
            + ' AND c_code NOT LIKE "%R"' // ��ǰ���� ����
            + ' AND p_ab = "A"';

    // 2016-06-22 [43A0 ���Ȱ�ǰ�����_����]�� ��ȸ
    if para2 = '0043' then
      ashSQL := ashSQL + ' AND c_code = "43A0"';

    if (mpst_code = 'H11040050') then // ��ΰ��
    begin
      ashSQL := 'SELECT c_code'
              + ', (SELECT c_name FROM center WHERE c_code = staff_center.c_code) c_name '
              + ' FROM staff_center '
              + ' WHERE o_code = "' + para2 + '"'
              + ' AND c_code NOT LIKE "%R"' // ��ǰ���� ����
              + ' AND p_ab = "A"'
              + ' GROUP BY c_code';
    end;
  end

  else if ab = 'B' then // ����
  begin
    // 2016-12-12 ���� �߰�
    ashSQL := 'SELECT branch_ab FROM org WHERE o_code = "' + para2 + '"'; // branch_ab A:����, B:����
    ashStr := MySQL_Assign(Form1.db_coopbase, Form1.qrySQL, ashSQL, vt);
    try
      StrToInt(ashStr);
    except
      ShowMessage('������ �߻��Ͽ����ϴ�.[' + ashStr + '](ERR:��ü��ȸ)');
      Exit;
    end;

    branchAb := vt.FieldByName('branch_ab').AsString;
    if branchAb = 'A' then // ����
    begin
      Form1.lblCenter.Caption := '����';
      Form1.rgxCenterAb.ItemIndex := 0;

      ashSQL := 'SELECT c_code'
              + ', (SELECT c_name FROM center WHERE c_code = staff_center.c_code) c_name '
              + ' FROM staff_center '
              + ' WHERE m_code = "' + para1 + '"'
              + ' AND o_code = "' + para2 + '"'
              + ' AND c_code NOT LIKE "%R"' // ��ǰ���� ����
              + ' AND p_ab = "A"';

      // 2016-06-22 [43A0 ���Ȱ�ǰ�����_����]�� ��ȸ
      if para2 = '0043' then
        ashSQL := ashSQL + ' AND c_code = "43A0"';
    end
    else if branchAb = 'B' then // ����
    begin
      Form1.lblCenter.Caption := '����';
      {
      ashSQL := 'SELECT j_code, j_name FROM johap'
              + ' WHERE branch_ab = "' + branchAb + '"'
              + ' AND c_code IN (SELECT c_code FROM staff_center '
                              + ' WHERE m_code = "' + para1 + '"'
                              + ' AND o_code = "' + para2 + '"'
                              + ' AND c_code NOT LIKE "%R"' // ��ǰ���� ����
                              + ' AND p_ab = "A")';

      if(mpst_code = 'H14103898') then
      begin
        ashSQL := 'SELECT j_code, j_name FROM johap'
              + ' WHERE branch_ab = "' + branchAb + '"'
              + ' AND c_code IN (SELECT c_code FROM center '
              + ' WHERE o_code = "' + para2 + '"'
              + ' AND c_code NOT LIKE "%R"' // ��ǰ���� ����
              + ' AND p_ab = "A")';
      end;
      }

      ashSQL := 'SELECT j_code, j_name FROM johap'
              + ' WHERE branch_ab = "' + branchAb + '"'
              + ' AND j_code IN (SELECT j_code FROM staff_johap '
                              + ' WHERE m_code = "' + para1 + '"'
                              + ' AND o_code = "' + para2 + '"'
                              //+ ' AND c_code NOT LIKE "%R"' // ��ǰ���� ����
                              + ' AND p_ab = "A")';

      if(mpst_code = 'H14103898 ') then
      begin
        ashSQL := 'SELECT j_code, j_name FROM johap'
              + ' WHERE branch_ab = "' + branchAb + '"'
              + ' AND o_code = "' + para2 + '"';

      end;

    end;
  end
  else if ab = 'J' then // ����
  begin
    if Length(para1) = 4 then
      ashStr := ' AND c_code = "' + para1 + '"'
    else if para1 <> '' then
      ashStr := ' AND c_code IN (' + para1 + ')'
    else
      ashStr := '';

    ashSQL := 'SELECT j_code, j_name FROM johap'
            + ' WHERE o_code = "' + para2 + '"'
            + ' AND o_code <> "0043"'     // 2016-06-13 ���Ȱ�ǰ� ����
            + ashStr
//            + 'OR j_code = "0000"'
            + ' ORDER BY j_code';
  end;
  Form1.Memo1.Lines.Add(ashSQL);

  ashStr := MySQL_Assign(Form1.db_coopbase, Form1.qrySQL, ashSQL, vt);
  try
    StrToInt(ashStr);
  except
    ShowMessage('������ �߻��Ͽ����ϴ�.[' + ashStr + '](ERR:��ü��ȸ)');
    Exit;
  end;
end;

// �޺��ڽ�, üũ����Ʈ�ڽ� ����
{ vt   : TZQuery��
  cbAb : �޺��ڽ� index 0�� text (A:��ü, S:�����ϼ���, N:����, C:�ڵ常, M:�ڵ��)
  cbNm : �޺��ڽ�
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

      if cbAb = 'A' then Items.Add('��ü')
      else if cbAb = 'S' then Items.Add('�����ϼ���');

      if vt.RecordCount < 1 then
      begin
        Clear;
        items.Add(MSG_ERR_CD1); // ��ȸ ������ �����ϴ�
      end;

      vt.First;
      while not vt.Eof do
      begin
        if cbAb = 'C' then      // �ڵ�
          ashStr := vt.Fields[0].AsString
        else if cbAb = 'M' then // �ڵ��
          ashStr := vt.Fields[1].AsString
        else                    // �ڵ� + ' ' + �ڵ��
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

      if cbAb = 'A' then Items.Add('��ü');

      if vt.RecordCount < 1 then
      begin
        Clear;
        items.Add(MSG_ERR_CD1); // ��ȸ ������ �����ϴ�
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

// �޺��ڽ� �˻�
procedure findCb(cb: TComboBox; key: Word);
var
  i, {codeLen, }keyLen, p: Integer;
  keyword: String;

  // �ѿ��Է»��� Ȯ�� (�ѱ�:TRUE)
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
        //SelectNext(ActiveControl, True, True); // SelectNext �Լ��� Pubished�� ����� �Լ��̱� ������ �� �� ����.
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

// ȭ���庰 ���� ������Ʈ �Ӽ� ����
procedure setCondEnable(const obj: TComponent; mode: Integer; e: Integer);
begin
  if mode = 0 then mode := 1
  else if mode = 2 then mode := 0;

  setObjEnable(obj, mode, e);
end;

// ȭ���庰 �Է� ������Ʈ �Ӽ� ����
{ obj : ������Ʈ��
  mode: ȭ����(0:����, 1:���, 2: ����, 3:����)
  e   : �ʼ�������(0:���ʼ�, 1:�ʼ�, 2:��Ȱ��(������忡��))
}
procedure setObjEnable(const obj: TComponent; mode: Integer; e: Integer);
var
  esseColr, nesseColr, inactColr: TColor;
begin
  esseColr  := $00D2FEFF; // �ʼ�
  nesseColr := $00FFFFFF; // ���ʼ�
  inactColr := $00FCFCFC; // ��Ȱ�� $00EEEEEE
  case mode of
    0, 3: // ����, ����
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

    1: // ���
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

    2: // ����
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
