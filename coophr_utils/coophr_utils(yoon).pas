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
//�ʱ�ȭ�� ��ġ ����
procedure Set_MainPosition(app_main: TForm);

// ������ �̷� ������������ ��ȯ
function SQLToHistory(my_sql: String): String;

// *****************************************************************************
// split - ���ڿ� �����ڷ� ������ ���ϴ� ��ġ(����)�� ���� ��������
{ Str       : ���ڿ�
  Position  : ����
  Delimiter : ������
}
function subStr(str: String; const position: Integer = 1; const delimiter: string = ' '): String;
//function splitCd(str: String; const position: Integer = 1; const delimiter: string = ' '): string;

// ȭ���庰 �Է� ������Ʈ �Ӽ� ����
{ obj : ������Ʈ��
  mode: ȭ����(0:����, 1:���, 2: ����, 3:����)
  e   : �ʼ�������(0:���ʼ�, 1:�ʼ�, 2:��Ȱ��)
}
procedure setObjEnable(const obj: TComponent; mode: Integer; e: Integer = 0);


// �޺��ڽ����� ������ �޺�text���� �ڵ常 ��������
function getCommCodeVal(cb: TWinControl): String;
//function getCommCodeVal(cb: TcxComboBox): String; overload;
//function getCommCodeVal(ckl: TCheckListBox): String; overload;

// �޺��ڽ����� code ��Ī index ��������
function getMatchCodeIdx(code: String; cbNm: TComboBox):Integer; overload;

// �޺��ڽ����� code ��Ī value ��������
//function getMatchCodeVal(code: String; cbNm: TComboBox):String;

// ����� ���α׷��� ���κ� ����庰 �μ��� ���, ����, ���, �޿��������� ����
procedure setGroupRightYn(obpAb: String = ''; obpCode: String = '');

// true, false -> Y, N ���� ġȯ (üũ�ڽ�, ������ư�� checked ��ȯ �� ���)
function getYn(bool: Boolean): String; overload;
function getYn(str: string): String; overload;

// Y, N -> true, false �� ġȯ
function getBool(yn: String): Boolean;

// üũ����Ʈ�ڽ� checked count
function getCklChkCnt(cklNm: TWinControl): Integer;

// ����Ȯ��â �޼���
function confirmDelMsg(msg: String = ''): Integer;
function chkExtVal(obj: TComponent; lab: String): Boolean;

// ���ڿ� null Ȯ��
function isEmpty(str: String): Boolean;

// ������ �׽�Ʈ ��Ʈ�� ����
//procedure showCtrl(ctrl: TControl);

// TcxLookupComboBox �����ڵ� ����

implementation

uses coop_sql_updel, Unit1, DB;

type
  TADBGrid = class(TDBGrid);

// �����޼���
const
  MSG_ERR_CD1         = '���� ���� �׸��� �����ϴ�.';                 // �����ڵ� �����޼���1
  MSG_ERR_VAL1        = ' �׸��� �ʼ����Դϴ�.';                      // ��ȿ��Ȯ��1
  MSG_ERR_VAL2        = ' �׸��� �ʼ����ð��Դϴ�.';                  // ��ȿ��Ȯ��2
  MSG_ERR_VAL_DATE1   = '���� ������ �����ʽ��ϴ�.';                  // ��¥��ȿ��Ȯ��1
  MSG_ERR_VAL_DATE2   = '�Է±Ⱓ�� �������ڰ� �������ں��� Ů�ϴ�.'; // ��¥��ȿ��Ȯ��2
  MSG_ERR_MATCH_OCODE = '�ش� ���������� ERP��ü�ڵ带 Ȯ���ϼ���.';  // �����ڵ�, ERP��ü�ڵ� ��Ī����
  MSG_NO_DATA         = '��ȸ ����� �����ϴ�.';


// �ʱ�ȭ�� ��ġ ����
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

// ���ڿ� null Ȯ��
function isEmpty(str: String): Boolean;
begin
  if (Trim(str) = '') or (Length(Trim(str)) = 0) then
    result := False
  else
    result := True;
end;

// ������ �̷� ������������ ��ȯ
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
    System.Insert('��', my_sql,AshPosInt);
  end;

  my_sql := mpst_name+'['+mpst_code+']-('+FormatDateTime('yyyy-mm-dd hh:mm:ss', Now)+')'+#13#10+my_sql+#13#10;
  Result := my_sql;
end;


// �׸��� Ÿ��Ʋ Ŭ�� �� ����
{
 1. �������� ����
      colIdx: Integer; titleCaption: String;

 2. ��ȸ �� �����ʱ�ȭ
      vt.IndexFieldNames := '';
      grid.Columns[colIdx].Title.Caption := titleCaption;

 3. OnTitleClick �̺�Ʈ���� �Լ� ȣ��
      sortGrid(colIdx, titleCaption, Column);
}
{
// ������ ��Ʈ�� visible
procedure showCtrl(ctrl: TControl);                                                              // 2018010038 - ���ϱ�
begin                                                                                            // 2016060060 - �ֽ���
  if (mpst_code = '0579033000') or (mpst_code = '2016060060') or (mpst_code = '2018010038') then // 0579033000 - ����
  begin
    if ctrl.Visible then
      ctrl.Visible := false
    else
      ctrl.Visible := True;
  end
  else
    ctrl.Visible := false;
end;
}


// ����� ���α׷��� ���κ� ����庰 �μ��� ���, ����, ��� ����
// obpAb: 'O'-����, 'B'-�����, 'P'-�μ�, 'A'-�ϳ� �̻��� ���� ���� ������ ���Ѻο�
// 2014.03.12 ���κ� �޿�������뿩�� ���� �߰� hr_salary_ab(A:Ȯ�κҰ� B:���)
procedure setGroupRightYn(obpAb: String = ''; obpCode: String = '');
begin
  insertYn := 'N'; editYn := 'N'; printYn := 'N'; salaryAb := 'A';

  // ��ü��ü���� - hr_obp_ab:A �Ǵ� hr_obp_code:9999
  // ���κ� ����庰 �μ��� ���� ����ȭ�� �ʿ���� ���α׷� �Ǵ� ���۴�ü���� �����
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
    if obpAb = '' then // FormCreate �� (����, �����, �μ� �̼���)
    begin
      if Form1.vtSuStaff.Locate('hr_insert', 'N', []) then insertYn := 'N' else insertYn := 'Y';
      if Form1.vtSuStaff.Locate('hr_edit', 'N', []) then editYn := 'N' else editYn := 'Y';
      if Form1.vtSuStaff.Locate('hr_print', 'N', []) then printYn := 'N' else printYn  := 'Y';
      if Form1.vtSuStaff.Locate('hr_salary_ab', 'A', []) then salaryAb := 'A' else salaryAb  := 'B';
    end

    // ����, �����, �μ� ������Ʈ �ʱ�ȭ ��
    else if (obpAb <> '') and (obpCode = '') then
    begin
      if Form1.vtSuStaff.Locate('hr_obp_ab;hr_insert', VarArrayOf([obpAb, 'N']), []) then insertYn := 'N' else insertYn := 'Y';
      if Form1.vtSuStaff.Locate('hr_obp_ab;hr_edit', VarArrayOf([obpAb, 'N']), []) then editYn := 'N' else editYn := 'Y';
      if Form1.vtSuStaff.Locate('hr_obp_ab;hr_print', VarArrayOf([obpAb, 'N']), []) then printYn := 'N' else printYn  := 'Y';
      if Form1.vtSuStaff.Locate('hr_obp_ab;hr_salary_ab', VarArrayOf([obpAb, 'A']), []) then salaryAb := 'A' else salaryAb := 'B';
    end

    // ����, �����, �μ� ���� ��
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

// split - ���ڿ� �����ڷ� ������ ���ϴ� ��ġ(����)�� ���� ����
{ Str       : ���ڿ�
  Position  : ����
  Delimiter : ������
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
    komPos := Pos(delimiter, str);    // pos ('',A'')

    if komPos <> 0 then
    begin
      if subIdx = position then
      begin
        Result := Copy(str, 1, komPos - 1);    // Copy(A,1,1) �׷��� RESULT�� [A]
        break;
      end;

      Delete(Str, 1, komPos);
      Inc(subIdx);
    end;
    Inc(zeichenIdx);
  end;
end;

// �����ڵ� �޺��ڽ����� ������ �޺�text���� �ڵ尪�� ��������
function getCommCodeVal(cb: TWinControl): String;
begin
  if (cb is TComboBox) then
  begin
    with TComboBox(cb)do
    begin
      if ((Pos('����', Items[0]) > 0) or (Items[0] = '��ü')) and (ItemIndex = 0) then
      begin
          result := '';
      end
      else
      begin
          result := subStr(Text, 1, ' ');
      end;
    end;
  end;
end;


// �����ڵ� �޺��ڽ����� code ��Ī index ��������
function getMatchCodeIdx(code: String; cbNm: TComboBox):Integer; overload;
var
  i, idx: Integer;
begin
  idx := 0;
  for i := 0 to cbNm.Items.Count - 1 do                     // (��) itemindex�� 0���� �����ϴϱ�
  begin
    if subStr(cbNm.Items.Strings[i], 1, ' ') = code then    // (��) ex)vtCode.FieldByName('hr_code_value_ab').AsString = "A"
    begin                                                   //      code = A
      idx := cbNm.Items.IndexOf(cbNm.Items.Strings[i]);
      Break;
    end;
  end;
  Result := idx;
end;

// true, false -> Y, N���� ġȯ
function getYn(bool: Boolean): String; overload;
begin
  if bool = true then
    result := 'Y'
  else //if bool = false then
    result := 'N';
end;

// 1, 0 -> Y, N���� ġȯ
function getYn(str: string): String; overload;
begin
  if str = '1' then
    result := 'Y'
  else
    result := 'N';
end;

// Y, N -> true, false �� ġȯ
function getBool(yn: String): Boolean;
begin
  if (yn = 'Y') or (yn = '1') then
    result := True
  else
    result := False;
end;

// ����Ȯ��â �޼���
function confirmDelMsg(msg: String = ''): Integer;
begin
  if msg = '' then
    msg := '���� �Ŀ��� ������ �� �����ϴ�.' + #13#10 + '�����Ͻ÷��� ����(F4)��ư�� �����ּ���'; // ������� �ٹٲ޽� #13#10�� ��� ����ϴ� ���� ǥ������ �մϴ�.
  result := MessageBox(0, PChar(msg), '����Ȯ��', MB_OKCANCEL);
end;


// ȭ���庰 �Է� ������Ʈ �Ӽ� ����
{ obj : ������Ʈ��
  mode: ȭ����(0:����, 1:���, 2: ����, 3:����)
  e   : �ʼ�������(0:���ʼ�, 1:�ʼ�, 2:��Ȱ��(������忡��))
}
procedure setObjEnable(const obj: TComponent; mode: Integer; e: Integer = 0);
var
  esseColr, nesseColr, inactColr: TColor;
  i: Integer;
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
        TMemo(obj).Enabled := false; // (��)
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
        TMemo(obj).Enabled := true;         // (��)
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
        TMemo(obj).Enabled := true; // (��)
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

// �ʼ��Է��׸� Ȯ��
{ obj: �ʼ��Է�������Ʈ��
  lab: �ʼ��Է��׸� label
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
      and ((Pos('����', TComboBox(obj).Items[0]) > 0) or (TComboBox(obj).Items[0] = '��ü')) then
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

// üũ����Ʈ�ڽ� checked count
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
end.