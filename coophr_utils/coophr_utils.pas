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

// �̷� ������  NOW() �Լ� �ð����� ��ȯ
function SQLToHistory(my_sql: String): String;

//���ڿ� ���� ����
function DelBlank(pfStr: String): String;
// *****************************************************************************

// ���ڸ� �Է�
procedure onlyNumber(var key: char);

// ���ڿ� null Ȯ��
function isEmpty(str: String): Boolean;

// RPAD
function rpad(str, pad:string; len: Integer): string;

// �ʼ��Է��׸� Ȯ��
{ obj: �ʼ��Է�������Ʈ��
  lab: �ʼ��Է��׸� label
}
function chkExtVal(obj: TComponent; lab: String): Boolean;

// �����޺��ڽ� �ɼ� 'N'�� �� �����׸� ���� Ȯ��
// �޺��ڽ� index 0�� text �ɼ� (A:��ü, S:�����ϼ���, N:����)
function chkCbCommCode(obj: TComboBox): Boolean;

// �����ȣ, �μ���ȣ ��ȿ�� Ȯ��
{ ntype - 1: �����ȣ
          2: �μ���ȣ
}
function chkTypeNo(obj: TEdit; ntype: Integer = 1): Boolean;

// �ֹι�ȣ ��ȿ�� Ȯ��
{idNo : '-' ������ ���� 13�ڸ�}
function chkIdNo(const idNo: String): Boolean;

// �ܱ��ε�Ϲ�ȣ ��ȿ�� Ȯ��
{idNo : '-' ������ ���� 13�ڸ�}
function chkForeignNo(const idNo: String): Boolean;

// ����ڵ�Ϲ�ȣ ��ȿ�� Ȯ��
{bizRegNo : - ������ ���� 10�ڸ�}
function chkBizRegNo(const bizRegNo: String): Boolean;

// split - ���ڿ� �����ڷ� ������ ���ϴ� ��ġ(����)�� ���� ��������
{ Str       : ���ڿ�
  Position  : ����
  Delimiter : ������
}
function subStr(str: String; const position: Integer = 1; const delimiter: string = ' '): String;
function splitCd(str: String; const position: Integer = 1; const delimiter: string = ' '): string;

// ȭ���庰 �Է� ������Ʈ �Ӽ� ����
{ obj : ������Ʈ��
  mode: ȭ����(0:����, 1:���, 2: ����, 3:����)
  e   : �ʼ�������(0:���ʼ�, 1:�ʼ�, 2:��Ȱ��)
}
procedure setObjEnable(const obj: TComponent; mode: Integer; e: Integer = 0);

// ȭ���庰 ���� ������Ʈ �Ӽ� ����
procedure setCondEnable(const obj: TComponent; mode: Integer; e: Integer);

// (ȭ���庰, ����� ���α׷����Ѻ�) ��ư Ȱ��ȭ ����
//procedure setProBtnEnable(modeInt: Integer; btnInsert, btnUpdate, btnInit, btnSave, btnPrint, btnExcel: TToolButton);

// �μ� ��ȸ - �μ� ���̺� 4������ ����� �߰�
procedure selectPost(db: TZConnection; vtPost: TVirtualTable);

// �����ڵ带 �޺��ڽ�, üũ����Ʈ�ڽ��� ����
{ dsNm      : TZQuery��
  vtTemp    : TVirtualTable��
  codeId    : �����ڵ�ID
  cbFirTxt  : �޺��ڽ� index 0�� text (A:��ü, S:�����ϼ���, N:����)
  cbNm      : �޺��ڽ���, üũ����Ʈ�ڽ���
  ab        : �޺��ڽ� Item �����ֱ� ��� (A: �ڵ�+����, C: �ڵ�, N: ����)
}
procedure setCbCommCode(dsNm: TZQuery; vtTemp: TVirtualTable; codeId, cbFirTxt: String; cbNm: TWinControl; ab: String = 'A');
//procedure setCbCommCode(dsNm: TZQuery; vtTemp: TVirtualTable; codeId, cbFirTxt: String; cbNm: TcxComboBox); overload;
//procedure setCbCommCode(dsNm: TZQuery; vtTemp: TVirtualTable; codeId, cbFirTxt: String; cbNm: TCheckListBox); overload;
//procedure setCbCommCode(dsNm: TZQuery; vtTemp: TVirtualTable; codeId, cbFirTxt: String; cbNm: TcxCheckListBox); overload;

// cxGrid �޺��ڽ��� �����ڵ� ����
procedure setCxCbCommCode(vt: TVirtualTable; codeId, cbFirTxt: String; cxGridCol: TcxCustomGridTableItem);

// TcxLookupComboBox ����
{ codeId   : �ڵ�ID
  cbFirTxt : �޺��ڽ� index 0�� text (A:��ü(ALL), S:�����ϼ���(SELECT), B:�ϰ�����(BATCH), N:����)
}
procedure setCbx(vt: TVirtualTable; codeId, cbFirTxt: string; userCode:String = ''; userCode2:String = '');

// �Ҽ�, ����, ��å �޺��ڽ� ����
{ dsNm      : TZQuery��
  codeId    : �����ڵ�ID
  cbFirTxt  : �޺��ڽ� index 0�� text (A:��ü, S:�����ϼ���, N:����, C:�ڵ常, M:�ڵ����)
  cbNm      : �޺��ڽ���
}
procedure setCbCode(db: TZConnection; dsNm: TZQuery; codeId, cbFirTxt: String; cbNm: TWinControl; userCode:String = ''; userCode2:String = '');

// cxTreeList �ʱ�ȭ
// checkedYn : True - ��ü����, False - ��ü����
procedure setTlInit(tlNm:TcxControl; checkedYn: Boolean = False);

// ��ü ���� cxChekBox ���� �� ��ü����/����
procedure setGrdviAllChecked(vt: TVirtualTable; xchk: TcxCheckBox; fieldNm: string = 'useYn');
// cxGrid üũ�ڽ� ��ü �����ϸ� ��ü���� üũ�ڽ� ����
procedure setXChkGrdviChk(vt: TVirtualTable; xchk: TcxCheckBox; fieldNm: string = 'useYn');
// cxGrid üũ�ڽ� checked count
function getGrdviChkCnt(vt: TVirtualTable; fieldNm: string = 'useYn'): Integer;

// üũ����Ʈ�ڽ� ��ü ����, ����
procedure setCklAll(cklNm:TWinControl);
// üũ����Ʈ�ڽ� �ʱ�ȭ
// checkedYn : True - ��ü����, False - ��ü����
procedure setCklInit(cklNm:TWinControl; checkedYn: Boolean = False);
// üũ����Ʈ�ڽ� checked count
function getCklChkCnt(cklNm: TWinControl): Integer;
function getNCklChkCnt(cklNm: TCheckListBox): Integer;

// üũ�޺��ڽ� checked count
function getCkbChkCnt(ckbNm: TcxCheckComboBox): Integer;

// üũ����Ʈ�ڽ� üũ ���� �ڵ带 �޸�(,)�� ������ ���ڿ�(IN ����)
// 1:�ڵ�, 2:�ڵ尪
function getCklCondStr(cklNm: TWinControl; ab: Integer = 1): String;
function getCkbCondStr(ckbNm: TcxCheckComboBox; ab: Integer = 1): string;

// üũ����Ʈ�ڽ����� ������ text���� �ڵ尪�� ��������
function getCodeValNm(ckl: TCheckListBox): String;

// �޺��ڽ����� ������ �޺�text���� �ڵ常 ��������
function getCommCodeVal(cb: TWinControl): String;
//function getCommCodeVal(cb: TcxComboBox): String; overload;
//function getCommCodeVal(ckl: TCheckListBox): String; overload;

// �޺��ڽ����� value ��Ī code ��������
function getMatchValueCode(value: String; cbNm: TComboBox):String;

// �޺��ڽ����� code ��Ī index ��������
function getMatchCodeIdx(code: String; cbNm: TComboBox):Integer; overload;
function getMatchCodeIdx(code: String; cbNm: TcxComboBox):Integer; overload;
//function getMatchCodeIdx(code: String; cbNm: TwDataCombo):Integer; overload;
function getMatchCodeIdx(code: String; ckl: TCheckListBox):Integer; overload;
function getMatchCodeIdx(code: String; ckl: TcxCheckListBox):Integer; overload;

// �޺��ڽ����� code ��Ī value ��������
function getMatchCodeVal(code: String; cbNm: TComboBox):String;

// �޺��ڽ����� value ��Ī index ��������
function getMatchValueIdx(val: String; cbNm: TComboBox):Integer;

// ����� ���α׷��� ��ü, ���α׷� ���, ����, �μ� ���� ��ȸ
procedure inquirySustaff();
// ����� ���α׷��� ���κ� ����庰 �μ��� ���, ����, ��� ����
procedure setGroupRightYn(obpAb: String = ''; obpCode: String = '');

// �޿�������� ���ѿ� ���� Display Format ��ȯ
function getSalaryFormat(salaryAb: String): String;

// ����ڱ��� ����, �μ� ��ȸ
{ vtSustaff : vtCompany, vtPost
  obpAb     : ����, �μ��ڵ� ����( 'hr_o_code', 'hr_post_code')
  mpstCode  : ����ڻ����ȣ
  return    : �����ִ� ����(�Ǵ� �μ�)�ڵ带 �޸�(,)�� ������ ���ڿ�  ��) �ڵ�1, �ڵ�2, �ڵ�3
}
function getStrObpCode(obpAb: String):String;

// �ش�μ��� ���� ���� Ȯ��
{ vtSustaff : vtCompany, vtPost
  ab        : ����, �μ��ڵ� ����( 'hr_o_code', 'hr_post_code')
  code      : ���������� Ȯ���� ����, �μ��ڵ�
  return    : ��������(Y, N)
}
function getStaffYn(vt: TVirtualTable; ab: String; code: String):String;

// true, false -> Y, N ���� ġȯ (üũ�ڽ�, ������ư�� checked ��ȯ �� ���)
function getYn(bool: Boolean): String; overload;
function getYn(str: string): String; overload;
// true, false -> 0, 1 �� ġȯ
function get01(bool: Boolean): String; overload;
function get01(str: string): String; overload;
// Y, N -> 1, ''(����)
function get1(str: string): String;
// ��, �� -> 1, ''(����)
function getH1(str: string): String;
// ��, �� -> 1, 2
function getH12(str: string): String;
// Y, N -> true, false �� ġȯ
function getBool(yn: String): Boolean;

// ����Ȯ��â �޼���
function confirmDelMsg(msg: String = ''): Integer;

// ��¥ �ʱ�ȭ : 1900-01-01
function initDt(): TDate;
// ��¥ �ʱ�ȭ2 : 1899-12-31 <- ���� �ٲ��� �ʴ� �ʱⰪ
function initDt2: TDate;

// dateTimePicker ������ null�� �� date �����
procedure setDt(dt: TDateTimePicker; strDate: String);

// ��¥ ���ڿ� dateTime Ÿ������ ��ȯ
function convtDateType(strDate: String): TDate;

// �Է³�¥ ��ȿ�� üũ
function isDate(str: String; msgYn: Boolean = False): Boolean;
//function isDate(str: String): Boolean;
//function isDateTime(str: String): Boolean;

// �Է³�¥ From~To �Ⱓ üũ
function validPeriod(fromDt, toDt: TDateTimePicker): Boolean; overload;
function validPeriod(fromDt, toDt: TDateTime): Boolean; overload;

// ��ȭ��ȣ ��ȿ�� Ȯ��
{ telNo : ������(-) ������ ��ȭ��ȣ }
function chkTelNo(telNo: String): Boolean;

// �ֹι�ȣ�� ������� ���ϱ�
{ id1 : �ֹι�ȣ ���ڸ�
  id2 : �ֹι�ȣ ���ڸ�
  id : ������(-) ���� �ֹι�ȣ - �ֹι�ȣ��6�ڸ� + ��ù°�ڸ� �̻��̸� ����
}
function getBirthdayByIdNo(id: String): TDate;

// ��¥�� ���ϱ��ϱ�
function getWeekday(date: TDateTime): String;
// ���ڸ� �ѱ۷� �б�
function numToStr(num: Integer): string;

// �����ü ���� ����
// ������ ���� �� ��ȣ(���� : 1, ��� : 0) ����
{ val : ��
  len : ��ȣǥ�� �ô� ��ȣ���̸� �������� ���� ������ ����
  ab  : ��ȣǥ�ÿ���(0 ������, 1 ����)
}
function getENum(val, len: Integer; ab: Integer = 0): string; overload;
function getENum(val: Double; len: Integer; ab: Integer = 0): string; overload;
// �����ü ���� ����
{
  val : ���ڿ�
  len : (�ִ�)�����ͱ���
  trimYn : �������ſ���
}
function getEStr(val: string; len: integer; trimYn:Boolean = False): string;
// �����ü date to string
function dtToStr(dt: TDate): string;
//function dtToStr(dt: TDate; format: string = 'yyyymmdd'): string;

// ERP��ü�ڵ�� HR�����ڵ� ��Ī
{ dsNm      : TZQuery��
  oCode     : ERP��ü�ڵ� �Ǵ� HR�����ڵ�
  oCodeAb   : ���� : ERP-ERP��ü�ڵ�, HR-HR�����ڵ�
  return    : ��Ī�ڵ�
}
function getMatchOCode(oCode, oCodeAb:String): String;

// �׷�ڽ� �� ������Ʈ �ʱ�ȭ
procedure initGroupBoxControl(grp: TWinControl);

// �׷�ڽ� �� ������Ʈ Ȱ��ȭ ����
{ grp      : TGroupBox��
  bool     : true - Ȱ��ȭ, false - ��Ȱ��ȭ
}
procedure enabledGroupBoxControl(grp: TGroupBox; bool: Boolean = True);

// ������ �׽�Ʈ ��Ʈ�� ����
procedure showCtrl(ctrl: TControl);

// �׸��� Ÿ��Ʋ Ŭ�� �� ����
procedure sortGrid(var cIdx: Integer; var cTitleCaption: String; col: TColumn);

// TcxLookupComboBox �����ڵ� ����
procedure setCbxComm(vt: TVirtualTable; ab: string; para: String = '');

// �ҵ漼 ���������� ��ȸ
function getDeductFamilyCnt(mCode: string): Integer;

// ���̼���ǥ ��ȸ
{
  mCode     : �����ȣ
  familyCnt : ����������
  salAmt    : ���޿��ݾ�(������ҵ� ����)
  salYm     : �ͼӿ��� char(6) yyyymm

  return    : Result[0] ���̼���ǥ�� ���� �ҵ漼
              Result[1] �޿����ѱݾ�(�̻�)
              Result[2] �޿����ѱ޾�(�̸�)
              Result[3] ����������¡�������� ���� �ҵ漼
}
function getSimpleTaxTable(mCode: string; familyCnt: Integer; salAmt: Double; salYm: string): TArray<Double>;

// �ǰ�������� ��ȸ
{
  yyyymm  : �ͼӿ���

  return  : Result[0] �ٷ��ںδ� �ǰ��������
            Result[1] ��������纸�����
            Result[2] ����纸�� �氨��
            Result[3] �������� ���Ѽ�
            Result[4] �������� ���Ѽ�
}
function getNhisRate(yyyymm: string): TArray<Double>;

// �ǰ������ ���
{
  mCode  : �����ȣ
  oCode  : �����ڵ�
  yyyymm : å������
  monthlyWageAmt : ��������, 0 �̸� �ٷ����� �������� ��ȸ

  return  : Result[0] �ǰ������ �����ںδ��
            Result[1] ����纸��� �����ںδ��
}
function getNhisAmt(mCode, oCode, yyyymm: String; monthlyWageAmt: Double = 0): TArray<Double>;

// ���� ����ٰ� ��ȸ
{
  ab  : ������
        1 �����ҵ�ټӿ�������,
        2 �����ҵ�ȯ��޿�����,
        3 �ҵ漼�⺻����,
        4 �����ҵ���⼼��Ư��,
        5 �ٷμҵ����
        6 �ٷμҵ漼�װ���

  ash : �����ڿ� ����
        1 �ټӿ���,
        2 ȯ��޿��ݾ�,
        3 ����ǥ�رݾ�,
        4 �������� ���⼼�� ����(%),
        5 �ٷμҵ� �ѱ޿���

  dt : ȸ�迬�� or ��������(19000101)

  return  : Result[0] ���Ѽ�
            Result[1] ���Ѽ�
            Result[2] ���ذ� - �����ڿ� ���� 1 �����ݾ�, 2 ������, 3 ����, 4 ��������, 5 ������
            Result[3] �ִ�ġ
}
function getTaxBase(ab: string; ash: Double; dt: string = ''): TArray<Double>;

// �ٷμҵ漼�װ����ѵ� ��ȸ
{
  totSalarAmt : �ѱ޿���
  return      : �ٷμҵ漼�װ����ѵ��ݾ�
}
function getEarnedIncomeDeductLimitAmt(totSalaryAmt: Double): Double;

// ���ڽŰ����� ���� �̷� ����
{
  ereportAb   char(1) : ������������ - A ��õ¡�������Ȳ�Ű�, B ���ڹ��ҵ�, C �ٷμҵ�, D �Ƿ��, ... (�����ڵ�Ȯ��)
  presentYm   char(6) : ���⿬��
  strfileCont         : �������ϳ���
}
procedure insertEReportHistory(ereportAb, bCode, oCode, presentYm, strfileCont: string; memo: string = '');

procedure chkEFile(eAb, strfileCont: string);

implementation

uses coop_sql_updel, Unit1, DB;

type
  TADBGrid = class(TDBGrid);

var
  days: array[0..11] of Integer = (31,28,31,30,31,30,31,31,30,31,30,31);
  weekdays: array[1..7] of string = ('��','��','ȭ','��','��','��','��');
  arrCtrl: array of TControl;
  arrCipher: array[0..12] of string = ('��','��','��','õ','��','��','��','õ','��','��','��','õ','��');
  arrStrNum: array[0..9] of string = ('��','��','��','��','��','��','��','ĥ','��','��');

  // �Ƿ�����޸����� A���ڵ� - 24�׸�
  arrM: array[0..23] of Integer = (1,  2,  3,  6,  8,   // �ڷ������ȣ
                                  10, 20,  4,           // ������
                                  10, 40,               // ��õ¡���ǹ���
                                  13,  1, 30,           // �ҵ���(�������� ��û��)
                                  10, 40,  1,           // ����ó
                                   5, 11,  1,           // ���޸���
                                  13,  1,  1,  1, 19);  // �Ƿ�� ���� �����


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

// �̷� ������  NOW() �Լ� �ð����� ��ȯ
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

// ���ڿ� ���� ����
function DelBlank(pfStr: String): String;
begin
 while Pos(' ',pfStr) <> 0 do
   System.Delete(pfStr,Pos(' ',pfStr),1);

  Result := pfStr;
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
        col.Title.Caption := cTitleCaption + '��';
      end
      else if IndexFieldNames = colName + ' DESC' then // DESC
      begin
        IndexFieldNames := colName;
        col.Title.Caption := cTitleCaption + '��';
      end
      else
      begin
        TDBGrid(col.Grid).Columns[cIdx].Title.Caption := cTitleCaption;

        cTitleCaption := titleCaption;
        IndexFieldNames := colName;
        col.Title.Caption := titleCaption + '��';
      end;
      cIdx := colIdx;
    end;
  end;
end;

// ������ ��Ʈ�� visible
procedure showCtrl(ctrl: TControl);
begin
  if (mpst_code = '0579033000') or (mpst_code = '2016060060') then // 0579033000 - ����
  begin
    if ctrl.Visible then
      ctrl.Visible := false
    else
      ctrl.Visible := True;
  end
  else
    ctrl.Visible := false;
end;

// �����ü ���� ����
// ������ ���� �� ��ȣ(���� : 1, ��� : 0) ����
{ val : ��
  len : ��ȣǥ�� �ô� ��ȣ���̸� �������� ���� ������ ����
  ab  : ��ȣǥ�ÿ���(0 ������, 1 ����)
}
function getENum(val, len: Integer; ab: Integer = 0): string; overload;
var
  sign: string;
begin
  if ab = 1 then
  begin
    if val < 0 then // ����
    begin
      sign := '1';
      val := val * (-1); // ���밪
    end
    else // ���
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

// �����ü ���� ����
{
  val : ���ڿ�
  len : (�ִ�)�����ͱ���
  trimYn : �������ſ���
}
function getEStr(val: string; len: integer; trimYn:Boolean = False): string;
var
  str: AnsiString;
begin
  str := AnsiString(Trim(val));
  if trimYn then // ��������
  begin
    str := StringReplace(str, ' ', '', [rfReplaceAll, rfIgnoreCase]);
  end;

  if Length(str) > len then
  begin
    str := Copy(str, 1, len);
    // �ѱ� 2Byte ���� 1Byte�� �߷��� �ѱ� ���� ����
    // function ByteType(const S: string; Index: Integer): TMbcsByteType;
    // TMbcsByteType - mbSingleByte(1����Ʈ ����), mbLeadByte(2����Ʈ ���۹���), mbTrailByte(2����Ʈ ����������)
    if SysUtils.ByteType(str, Length(str)) = mbLeadByte then // ������ ���� Ȯ��
      str := Copy(str, 1, len-1);
  end;

  Result := AnsiStrings.Format('%-' + IntToStr(len) + 's', [str]);
end;

// �����ü date to string
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

// Date�� ������ȸ
function getWeekday(date: TDateTime): String;
begin
  Result := weekdays[DayOfWeek(date)];
end;

// ���� �ѱ۷�
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

// ���ڸ� �Է�
procedure onlyNumber(var key: char);
const
  Bksp = #08; // BackspaceŰ
begin
  if not (key in ['0'..'9', Bksp]) then
    key := #0;
end;

// ���ڿ� null Ȯ��
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

// �����޺��ڽ� �ɼ� 'N'�� �� �����׸� ���� Ȯ��
// �޺��ڽ� index 0�� text �ɼ� (A:��ü, S:�����ϼ���, N:����)
function chkCbCommCode(obj: TComboBox): Boolean;
begin
  if obj.Text = MSG_ERR_CD1 then
  begin
    ShowMessage('���� ������ �׸��� �����ϴ�.');
    Result := False;
  end
  else
    Result := True;
end;

// �����ȣ, �μ���ȣ ��ȿ�� Ȯ��
{ ntype - 1: �����ȣ
          2: �μ���ȣ
}
function chkTypeNo(obj: TEdit; ntype: Integer = 1): Boolean;
begin
  case ntype of
    1: // �����ȣ
    begin
      if (not isEmpty(Trim(obj.Text))) or (Length(Trim(obj.Text)) <> 10) then
      // 2014-02-07 ȫ���ΰ� ������ �̰� �� �����ȣ 10�ڸ��� �ƴ� ��� �����Ͽ� ���� (31Ǯ������ 63��)
      //if (not isEmpty(Trim(obj.Text))) or (Length(Trim(obj.Text)) > 10) then
      begin
        ShowMessage('�����ȣ�� Ȯ���ϼ���.');
        obj.SetFocus;
        result := False;
      end
      else Result := True;
    end;
    2: // �μ��ڵ�
    begin
      if (not isEmpty(Trim(obj.Text))) {or (Length(Trim(obj.Text)) <> 4) or (not TryStrToInt(Copy(Trim(obj.Text),2,3), i))} then
      begin
        ShowMessage('�μ��ڵ带 Ȯ���ϼ���.');
        obj.SetFocus;
        result := False;
      end
      else Result := True;
    end
    else Result := True;
  end;
end;

// �ֹε�Ϲ�ȣ ��ȿ�� Ȯ��
{idNo : - ������ ���� 13�ڸ�}
function chkIdNo(const idNo: String): Boolean;
const weight = '234567892345';
var
  Sum, i: Integer;
  res: Integer;
begin
  Result := False;

  if Length(Trim(idNo)) <> 13 then Exit;

  if StrToInt(idNo[7]) in [5, 6, 7, 8] then // �ܱ��ε�Ϲ�ȣ ��ȿ��
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
  else // �ֹι�ȣ ��ȿ��
  begin
    Sum := 0;
    for i := 1 to 12 do
      Sum := Sum + (StrToInt(idNo[i]) * StrToInt(weight[i]));

    res := (11 - (Sum mod 11)) mod 10;

    if res = StrToInt(idNo[13]) then
      Result := True;
  end;
end;

// �ܱ��ε�Ϲ�ȣ ��ȿ�� Ȯ��
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

// splitCd - �ڵ� �޺��ڽ� ���ڿ� �����ڷ� ������ �ڵ�, �ڵ尪 ����
{ Str       : ���ڿ�
  Position  : 1-�ڵ�, 2-�ڵ尪
  Delimiter : ������
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

// TcxLookupComboBox �����ڵ� ����
procedure setCbxComm(vt: TVirtualTable; ab: string; para: String = '');
var
  ashSQL, ashStr: string;
begin
  if ab = 'city_code' then // �õ��ڵ�
  begin
    ashSQL := 'SELECT hr_code_value city_code, hr_code_value_name city_name'
            + ' FROM hr_common_code_value'
            + ' WHERE hr_code_id = "hr_city_code"'
            + ' AND hr_use_yn = "Y"'
            + ' ORDER BY hr_sort_seq';
  end

  else if ab = 'sigungu_code' then // �ñ����ڵ�
  begin
    ashSQL := 'SELECT hr_code_value sigungu_code, hr_code_value_name sigungu_name'
            + ' FROM hr_common_code_value'
            + ' WHERE hr_code_id = "hr_sigungu_code"'
            + ' AND hr_use_yn = "Y"'
            + ' AND hr_code_value LIKE "' + para + '%" '
            + ' ORDER BY hr_code_value_name ASC';
  end

  else if ab = 'dong_code' then // �������ڵ�
  begin
    ashSQL := 'SELECT hr_code_value dong_code, hr_code_value_name dong_name'
            + ' FROM hr_common_code_value'
            + ' WHERE hr_code_id = "hr_dong_code"'
            + ' AND hr_use_yn = "Y"'
            + ' AND hr_code_value LIKE "' + para + '%" '
            + ' ORDER BY hr_code_value_name ASC';
  end

  else if ab = 'local_dong_code' then  // ����ҵ漼 �������ڵ�
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

// TcxLookupComboBox ����
// cbFirTxt : �޺��ڽ� index 0�� text (A:��ü, S:�����ϼ���, B:�ϰ�����, N:����)
// usercode :
procedure setCbx(vt: TVirtualTable; codeId, cbFirTxt: string; userCode:String = ''; userCode2:String = '');
var
  ashSQL, ashStr: String;
begin
  ashStr := '';
  if codeId = 'o_code' then // ������� �ش� ���α׷��� �����ִ� ���� ��ȸ
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
  end

  // ����� �Ҽ� ���� ��ȸ
  else if codeId = 'emp_o_code' then  // <-- ���� ����
  begin
    // ������� ��� ������ ����
    if userCode2 = '2' then  // ��������ڵ� - 2:�����
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
    else  // ����� �Ҽӹ��� ��ȸ
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

  // ���� ������ ����� ��ȸ
  else if codeId = 'b_code' then
  begin
    // ����ڴ��������Ű����� ��ȸ
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
    if userCode2 = 'Y' then // ����ڴ��������Ű�����
    begin
      // ���� ����� ��ȸ
      ashSQL := 'SELECT "�ϰ�����" hr_b_name, hr_b_code, hr_b_head_yn, hr_b_half_yearly_yn'
              + ' FROM hr_branch'
              + ' WHERE hr_o_code = "' + userCode + '"'
              + ' AND hr_b_head_yn = "Y" AND hr_b_use_yn = "Y"';
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

  // ���� ������ ��� �ٹ��� ��ȸ
  else if codeId = 'unit_code' then
  begin
    ashSQL := 'SELECT hr_unit_code, hr_unit_name FROM hr_work_unit'
            + 'WHERE hr_o_codelist LIKE "%' + userCode + '%"'
            + ' AND hr_use_yn = "Y"';
  end

  // �����ڵ�
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
    vt.InsertRecord([MSG_ERR_CD1]); // ��ȸ ������ �����ϴ�
    Exit;
  end;

  if cbFirTxt = 'A' then
    vt.InsertRecord(['��ü'])
  else if cbFirTxt = 'S' then
    vt.InsertRecord(['�����ϼ���'])
  else if cbFirTxt = 'B' then
    vt.InsertRecord(['�ϰ�����']);
end;

// �Ҽ�, �����, ����, ��å �޺��ڽ� ����
{ dsNm      : TZQuery��
  codeId    : �����ڵ�ID
  cbFirTxt  : �޺��ڽ� index 0�� text (A:��ü, S:�����ϼ���, N:����, C:�ڵ常, M:�ڵ����)
  cbNm      : �޺��ڽ���
  userCode  : �����ȣ(����� �Ҽӹ��� ��ȸ ��), �����ڵ�(�����, �ٹ��� ��ȸ ��),  �� �ܴ� ''
  sort      : '' �ڵ�����, M �ڵ������
}
procedure setCbCode(db: TZConnection; dsNm: TZQuery; codeId, cbFirTxt: String; cbNm: TWinControl; userCode:String = ''; userCode2:String = '');
var
  ashSQL, subSQL, ashStr: String;

begin
  if codeId = 'o_code' then // ������� �ش� ���α׷��� �����ִ� ���� ��ȸ
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

  else if codeId = 'emp_o_code' then // ����� �Ҽӹ��� ��ȸ
  begin
    // 2014.07.10 �߰� - ������� ��� ������ �����ش�.
    if userCode2 = '2' then  // ��������ڵ� - 2:�����
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
    else  // ����� �Ҽӹ��� ��ȸ
    begin
      // ��ϸ�� �� �� ���� �Ҽ� ���θ� ����
      {subSQL := '';
      if userCode2 = '1' then
      begin
        subSQL := 'AND G.hr_ab NOT IN ("B", "E") ';  // ����� �Ҽ��� ������ ���� �ʿ�� ����(�ѹ��� ��û)���� �ּ�
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

  // ��� ���� ��ȸ
  else if codeId = 'a_o_code' then
  begin
    ashSQL := 'SELECT hr_o_code, hr_o_name '
            + 'FROM hr_company '
            + 'WHERE 1=1 '
            //+ 'AND hr_o_use_yn = "Y" '
            + 'AND hr_o_code NOT IN ("0098","0099","9998","9999")'
  end

  // �ټӼ��� ���� ���� ��ȸ
  else if codeId = 'old_o_code' then
  begin
    ashSQL := 'SELECT hr_o_code, hr_o_name '
            + 'FROM hr_company '
            + 'WHERE hr_o_use_yn = "Y" '
            + 'AND hr_o_old_yn = "Y"'
  end

  // ������� �ش� ���α׷��� �����ִ� ���� �Ҽ� ������ �����ִ� ����� ��ȸ
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

    // �������� ����
    if userCode2 <> '' then // �������
    begin
      ashSQL := ashSQL + ' AND (hr_b_end_day >= "' + userCode2 + '" OR hr_b_end_day <= "1900-01-01")' // �������� ����
    end
    else
    begin
      ashSQL := ashSQL + ' AND (hr_b_end_day >= NOW() OR hr_b_end_day <= "1900-01-01")'
    end;
  end

  // �ش� ������ ����� ��ȸ
  else if (codeId = 'b_code') and (userCode <> '') then
  begin
    ashSQL := 'SELECT '
            + 'CONCAT(hr_o_code, "-", hr_b_code) hr_b_code'
            + ', hr_b_name '
            + 'FROM hr_branch '
            + 'WHERE hr_o_code = "' + userCode + '"'
            + ' AND hr_b_use_yn = "Y"';

    // �������� ����
    if userCode2 <> '' then
    begin
      ashSQL := ashSQL + ' AND (hr_b_end_day >= "' + userCode2 + '" OR hr_b_end_day <= "1900-01-01")' // �������� ����
    end
    else
    begin
      ashSQL := ashSQL + ' AND (hr_b_end_day >= NOW() OR hr_b_end_day <= "1900-01-01")'
    end;
  end

  // ����� ���� �Ҽ� ����� ��ȸ  2015-07-06 �߰�
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
            //+ ' AND hr_ab NOT IN ("B", "E")';  // ����� ����� ��ȸ�ǰ� �ּ�ó��
  end

  // ����
  else if codeId = 'po_code' then
  begin
    ashSQL := 'SELECT'
            + ' hr_po_code'
            + ', hr_po_name '
            + 'FROM hr_position '
            + 'WHERE hr_use_yn <> "N" '
            + 'ORDER BY hr_po_code';
  end

  // ��å
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

  // ������� �����ִ� �μ� ��ȸ
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

  // ���μ���/����
  else if codeId = 'pr_sudnag_code' then
  begin
    ashSQL := 'SELECT hr_sg_code, hr_sg_name FROM hr_sudang_gongje '
            + 'WHERE hr_sg_ab = "D" ' // D:���μ���/����
            + 'AND hr_basic_yn <> "Y" ' // Y:������༭ �׸�
            + 'AND hr_use_yn = "Y"';
  end

  // ���ڵ�
  else if codeId = 'bonus_code' then
  begin
   ashSQL := 'SELECT hr_sg_code, hr_sg_name'
          + ' FROM hr_sudang_gongje'
          + ' WHERE hr_sg_ab = "C" AND hr_use_yn <> "N"';
  end

  // �ٹ���
  else if codeId = 'unit_code' then
  begin
    if userCode = '' then // ��ü �ٹ���
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

  {else if (codeId = 'unit_code') and (userCode = '') then // �ٹ���
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

  // �ٹ����ڵ�
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

  //Form1.Memo1.Lines.Add(ashSQL);
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

      if cbFirTxt = 'A' then Items.Add('��ü')
      else if cbFirTxt = 'S' then Items.Add('�����ϼ���');

      if Form1.vtTemp.RecordCount < 1 then
      begin
        Clear;
        items.Add(MSG_ERR_CD1); // ��ȸ ������ �����ϴ�
      end;

      while not Form1.vtTemp.Eof do
      begin
        if cbFirTxt = 'C' then // �ڵ�
          ashStr := Form1.vtTemp.Fields[0].AsString
        else if cbFirTxt = 'M' then // �ڵ��
          ashStr := Form1.vtTemp.Fields[1].AsString
        else // �ڵ� + ' ' + �ڵ��
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

      if cbFirTxt = 'A' then Items.Add('��ü');

      if Form1.vtTemp.RecordCount < 1 then
      begin
        Clear;
        items.Add(MSG_ERR_CD1); // ��ȸ ������ �����ϴ�
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

      if cbFirTxt = 'A' then AddItem('��ü');

      if Form1.vtTemp.RecordCount < 1 then
      begin
        Clear;
        AddItem(MSG_ERR_CD1); // ��ȸ ������ �����ϴ�
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
      //if cbFirTxt = 'A' then items.AddCheckItem('��ü');

      if Form1.vtTemp.RecordCount < 1 then
      begin
        items.Clear;
        items.AddCheckItem(MSG_ERR_CD1); // ��ȸ ������ �����ϴ�
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

// cxTreeList �ʱ�ȭ
// checkedYn : True - ��ü����, False - ��ü����
procedure setTlInit(tlNm:TcxControl; checkedYn: Boolean = False);
var
  i: Integer;
begin
  // cxTreeList üũ�ڽ� �ʱ�ȭ
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

// cxGrid üũ�ڽ� checked count
function getGrdviChkCnt(vt: TVirtualTable; fieldNm: string = 'useYn'): Integer;
var
  chkCnt, i, rowNo: Integer;
begin
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

// cxGrid üũ�ڽ� ��ü �����ϸ� ��ü���� üũ�ڽ� ����
procedure setXChkGrdviChk(vt: TVirtualTable; xchk: TcxCheckBox; fieldNm: string = 'useYn');
var
  rowNo: Integer;
begin
  if vt.RecordCount = 0 then Exit;

  //vt.DisableControls;
  //rowNo := vt.RecNo;

  if getGrdviChkCnt(vt, fieldNm) = vt.RecordCount then
  begin
    xchk.Checked := True;
  end
  else
  begin
    xchk.Checked := False;
  end;

  //vt.RecNo := rowNo;
  //vt.EnableControls;
end;

// ��ü ���� cxChekBox ���� �� ��ü����/����
procedure setGrdviAllChecked(vt: TVirtualTable; xchk: TcxCheckBox; fieldNm: string = 'useYn');
var
  rowNo: Integer;
begin
  if vt.RecordCount = 0 then Exit;

  vt.DisableControls;
  rowNo := vt.RecNo;

  if xchk.Checked then // ��ü����
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
  else  // ��ü����
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

// üũ����Ʈ�ڽ� ��ü ����, ����
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
        if Checked[0] = True then // ��ü����
        begin
          for i := 1 to Items.Count - 1 do
          begin
            Checked[i] := True;
          end;
        end
        else if Checked[0] = False then // ��ü����
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
        if Items[0].State = cbsChecked then // ��ü����
        begin
          for i := 1 to Items.Count - 1 do
          begin
            Items[i].State := cbsChecked;
          end;
        end
        else if Items[0].State = cbsUnchecked then // ��ü����
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

// üũ����Ʈ�ڽ� �ʱ�ȭ
// checkedYn : True - ��ü����, False - ��ü����
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

// üũ�޺��ڽ� checked count
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

// üũ����Ʈ�ڽ� üũ ���� �ڵ带 �޸�(,)�� ������ ���ڿ�(IN ����) ����
// 1:�ڵ�
// 2:�ڵ尪
// 3:������� ��� [�����ڵ�-������ڵ�] �̹Ƿ� �ѹ� �� ó���Ѵ�.
// 4:���θ���Ʈ REGEXP ���� - ���߼��� ����� üũ����Ʈ�ڽ� [�����ڵ�-������ڵ�]���� �����ڵ常..
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
        if ((Pos('����', Items[i]) > 0) or (Items[i] = '��ü')) and (i = 0) then
          Continue;

        if Checked[i] then
        begin
          if (ab = 1) then
          begin
            if cond = '' then
              cond := '"' + subStr(Items[i], 1) + '"'
            else
              cond :=  cond + ',"' + subStr(Items[i], 1) + '"';
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
        if ((Pos('����', Items[i].Text) > 0) or (Items[i].Text = '��ü')) and (i = 0) then
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

// ERP��ü�ڵ�� HR�����ڵ� ��Ī
{
  oCode     : ERP��ü�ڵ� �Ǵ� HR�����ڵ�
  oCodeAb   : ���� : [ERP] ERP��ü�ڵ�, [HR] HR�����ڵ�
  return    : ��Ī�ڵ�
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

// �׷�ڽ� ���� ������Ʈ �ʱ�ȭ
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

// �׷�ڽ� �� ������Ʈ Ȱ��ȭ ����
{ grp      : TGroupBox��
  bool     : true - Ȱ��ȭ, false - ��Ȱ��ȭ
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

// ����� ���α׷��� ��ü, ���α׷� ���, ����, �μ� ���� ��ȸ
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
            + 'AND p_ab = "A"'; // A ���
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

  // �����ִ� ������ �Ҽ� ����� ��ȸ
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

  // ���� virtual table�� ���� �Ҽ� ����� append
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

// �޿�������� ���ѿ� ���� Display Format ����
function getSalaryFormat(salaryAb: String):String;
begin
  if salaryAb = 'A' then // �޿����� Ȯ�κҰ�
    Result := '*******'
  else if salaryAb = 'B' then // ���
    Result := '#,##0'; // ',0.;-,0.';
end;

// ����ڱ��� ����, �μ� ��ȸ
{ vtSustaff : vtCompany, vtPost
  obpAb     : ����, �����, �μ��ڵ� ����(O:����, B:�����, P:�μ�)
  mpstCode  : ����ڻ����ȣ
  return    : �����ִ� ����(�Ǵ� �μ�)�ڵ带 �޸�(,)�� ������ ���ڿ�  ��) �ڵ�1, �ڵ�2, �ڵ�3
}
function getStrObpCode(obpAb: String):String;
var
  obpCode, strSustaff: String;
begin
  // ����� ����, �μ� ���� ��ȸ
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
    Form1

    .vtSuStaff.Next;
  end;

  if strSustaff = '' then
    Result := '""'
  else
    Result := strSustaff;
end;

// �ش�μ��� ���� ���� Ȯ��
function getStaffYn(vt: TVirtualTable; ab: String; code: String):String;
var
  staffYn: String; // ��������
begin
  staffYn := 'N';

  // ���� Ȯ��
  vt.First;
  while not vt.Eof do
  begin
    if (vt.FieldByName(ab).AsString = code) then staffYn := 'Y';
    vt.Next;
  end;
  Result := staffYn;
end;

// �μ� ��ȸ - �μ� ���̺� 4������ ����� ��ü�μ� ��ȸ �߰�
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

// �����ڵ带 �޺��ڽ��� ����
{ dsNm      : TZQuery��
  vtTemp    : TVirtualTable��
  codeId    : �����ڵ�ID
  cbFirTxt  : �޺��ڽ� index 0�� text (A:��ü, S:�����ϼ���, N:����)
  cbNm      : �޺��ڽ���, üũ����Ʈ�ڽ���
  ab        : �޺��ڽ� Item �����ֱ� ��� (A: �ڵ�+����(value), C: �ڵ�, N: ����)
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
    if mpst_code = '0579033000' then
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
        Items.Add('��ü')
      else if cbFirTxt = 'S' then
      begin
        Items.Add('�����ϼ���');
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
      if cbFirTxt = 'A' then Items.Add('��ü');

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
      if cbFirTxt = 'A' then AddItem('��ü');

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
      if cbFirTxt = 'A' then Properties.Items.Add('��ü')
      else if cbFirTxt = 'S' then Properties.Items.Add('�����ϼ���');

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

  if cbFirTxt = 'A' then cbNm.Properties.Items.Add('��ü')
  else if cbFirTxt = 'S' then cbNm.Properties.Items.Add('�����ϼ���');

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

  if cbFirTxt = 'A' then cbNm.Items.Add('��ü')
  else if cbFirTxt = 'S' then cbNm.Items.Add('�����ϼ���');

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

    if cbFirTxt = 'A' then Items.Add('��ü')
    else if cbFirTxt = 'S' then Items.Add('�����ϼ���');

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
  end

  else if (cb is TcxComboBox) then
  begin
    with TcxComboBox(cb)do
    begin
      if ((Pos('����', Properties.Items[0]) > 0) or (Properties.Items[0] = '��ü')) and (ItemIndex = 0) then
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
      if ((Pos('����', Items[0]) > 0) or (Items[0] = '��ü')) and (ItemIndex = 0) then
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
      if ((Pos('����', Items[0].Text) > 0) or (Items[0].Text = '��ü')) and (ItemIndex = 0) then
      begin
          result := '';
      end
      else
      begin
          result := subStr(Items[ItemIndex].Text, 1, ' ');
      end;
    end;
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
      result := subStr(ckl.Items.Strings[ckl.ItemIndex], 2, ' ');
  end;
end;

// �����ڵ� �޺��ڽ����� value ��Ī code ��������
function getMatchValueCode(value: String; cbNm: TComboBox):String;
var
  i: Integer;
  code: String;
begin
  code := '';
  if ((Pos('����', cbNm.Items[0]) > 0) or (cbNm.Items[0] = '��ü')) and (cbNm.ItemIndex = 0) then
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

// �����ڵ� �޺��ڽ����� code ��Ī index ��������
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

// �޺��ڽ����� code ��Ī value ��������
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

// �����ڵ� �޺��ڽ����� value ��Ī index ��������
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

// true, false -> 0, 1 �� ġȯ
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
  if str = '��' then
    result := '1'
  else
    result := '';
end;

function getH12(str: string): String;
begin
  if (str = '��') or (str = 'Y') then
    result := '1'
  else
    result := '2';
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
    msg := '���� �Ŀ��� ������ �� �����ϴ�.' + #13#10 + '�����Ͻ÷��� ����(F4)��ư�� �����ּ���';
  result := MessageBox(0, PChar(msg), '����Ȯ��', MB_OKCANCEL);
end;

// ��¥ �ʱ�ȭ : 1900-01-01
function initDt: TDate;
begin
  result := StrToDate('1900/01/01');
end;

// ��¥ �ʱ�ȭ2 : 1899-12-31
// ���� �ٲ��� �ʴ� �ʱⰪ
function initDt2: TDate;
begin
  result := StrToDate('1899/12/31');
end;

// dateTimePicker ������ null�� �� date �����
procedure setDt(dt: TDateTimePicker; strDate: String);
begin
  if strDate = '' then
    dt.Format := ' '
  else
    dt.Date := StrToDate(strDate);
end;

// ��¥ ���ڿ� dateTime Ÿ������ ��ȯ
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

// �Է³�¥ ��ȿ�� üũ
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

    // ���� Ȯ��
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

// From~To �Ⱓ üũ
function validPeriod(fromDt, toDt: TDateTime): Boolean; overload;
begin
  if CompareDateTime(fromDt, toDt) = 1 then // A=B(0), A>B(1), A<B(-1)
  begin
    ShowMessage(MSG_ERR_VAL_DATE2);
    Result := False;
  end
  else
    Result := True;
end;

// �Է³�¥ From~To �Ⱓ üũ
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

// ��ȭ��ȣ ��ȿ�� Ȯ��
{ telNo : ������(-) ������ ��ȭ��ȣ }
function chkTelNo(telNo: String): Boolean;
var
  delimiter, localNo, middleNo, lastNo: string;
  i, cnt: Integer;
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
  // 070 ������ȣ  TryStrToInt �Լ����� False ��ȯ�Ѵ�. ��???
  //if not TryStrToInt(StringReplace(telNo, '-', '', [rfReplaceAll]), val) then Result := False;

  localNo   := subStr(telNo, 1, delimiter);
  middleNo  := subStr(telNo, 2, delimiter);
  lastNo    := subStr(telNo, 3, delimiter);

  // ������ȣ ù�ڸ� 0 Ȯ��
  if Copy(telNo, 1, 1) <> '0' then Result := False;
  // ������ȣ ����Ȯ��
  if not Length(localNo) in [2,3] then Result := False;
  // �߰��ڸ���ȣ ����Ȯ��
  if not Length(middleNo) in [3,4] then Result := False;
  // ���ڸ���ȣ ����Ȯ��
  if Length(lastNo) <> 4 then Result := False;
end;

// �ֹι�ȣ�� ������� ���ϱ�
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
        TMemo(obj).Enabled  := false; // (��)
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

// �ҵ漼 ���������� ��ȸ
function getDeductFamilyCnt(mCode: string): Integer;
var
  ashSQL: string;
begin
  // �������� Ȯ��(���� + ����� + ������ �ξ簡��)
  ashSql := 'SELECT IFNULL(SUM(IF(hr_family_relation_ab = "06", 2, 1)), 0) + 1 cnt FROM hr_family'
          + ' WHERE hr_m_code = "' + mCode + '"'
          + ' AND hr_use_yn = "Y"'
          + ' AND hr_support_yn = "Y"'          // �ξ��ǹ�
          + ' AND ((hr_living_yn = "Y") OR (hr_family_relation_ab IN ("03","04")))' // �������� - ��(03)��(04)�� ��� ��������
          + ' AND (SUBSTRING(hr_birthday, 1, 4) < (DATE_FORMAT(DATE_ADD(NOW(), INTERVAL -60 YEAR), "%Y"))'  // ���� �� 60���̻�
          + ' OR SUBSTRING(hr_birthday, 1, 4) > (DATE_FORMAT(DATE_ADD(NOW(), INTERVAL -22 YEAR), "%Y"))'    // ���� �� 20������
          + ' OR hr_difficulty_yn = "Y"'         // �������
          + ' OR hr_family_relation_ab = "05")'  // ����ڰ��� '
          + ' AND hr_birthday > "1900-01-01"';
  //Form1.Memo1.Lines.Add('#�������� Ȯ��'+#13+ashSQL);
  ashSQL := MySQL_Assign(Form1.db_coophr, Form1.qrySql, ashSQL, Form1.vtTemp);
  try
    StrToInt(ashSQL);
  except
    if mpst_code = '0579033000' then
    begin
      ShowMessage(AshSQL);
    end;
  end;
  Result := Form1.vtTemp.FieldByName('cnt').AsInteger; // ����������
end;

// ���̼���ǥ ��ȸ
{
  mCode     : �����ȣ
  familyCnt : ����������
  salAmt    : ���޿��ݾ�(������ҵ� ����)
  salYm     : �ͼӿ��� char(6) yyyymm

  return    : Result[0] ���̼���ǥ�� ���� �ҵ漼
              Result[1] �޿����ѱݾ�(�̻�)
              Result[2] �޿����ѱ޾�(�̸�)
              Result[3] ����������¡�������� ���� �ҵ漼
}
function getSimpleTaxTable(mCode: string; familyCnt: Integer; salAmt: Double; salYm: string): TArray<Double>;
var
  ashSQL: string;
  stdAmt1, stdAmt2, stdAmt3, excessAmt, incomeTaxAmt: Double;
begin
  // �ҵ漼
  // �� õ������ �ش� ����(���̼���ǥ)
  // �� 10,000õ�� �ʰ� 14,000õ�� ���� : �� + õ���� �ʰ� �ݾ� * 98% * 35%
  // �� 14,000õ�� �ʰ� : �� + 14,000õ�� �ʰ� �ݾ� * 98% * 38%
  //                      �� + 1,372,000 + 14,000õ�� �ʰ� �ݾ� * 98% * 38%
  // 2017-02������ �������� �߰�
  // �� 14,000õ�� �ʰ� 45,000õ�� ���� : �� + 1,372,000 + 14,000õ�� �ʰ� �ݾ� * 98% * 38%
  // �� 45,000õ�� �ʰ� : �� + 12,916,400 + 45,000õ�� �ʰ� �ݾ� * 98% * 40%
  stdAmt1 := 10000000; stdAmt2 := 14000000; stdAmt3 := 45000000;
  excessAmt := 0; incomeTaxAmt := 0;

  if (salAmt > stdAmt3) then // 45,000õ�� �ʰ�
  begin
    excessAmt := (salAmt - stdAmt3) * 0.98 * 0.4;
    salAmt := stdAmt3;
  end;

  if (salAmt > stdAmt2) then // 14,000õ�� �ʰ�
  begin
    excessAmt := excessAmt + (salAmt - stdAmt2) * 0.98 * 0.38;
    salAmt := stdAmt2;
  end;

  if (salAmt > stdAmt1) then // 10,000õ�� �ʰ�
  begin
    excessAmt := excessAmt + (salAmt - stdAmt1) * 0.98 * 0.35;
    salAmt := stdAmt1;
  end;

  ashSQL := 'SELECT TRUNCATE(hr_g' + IntToStr(familyCnt) + '_amt, 0) hr_g_amt' // ����������, ������ ����
          + ', hr_min_amt, hr_max_amt'
          + ' FROM hr_simple_tax_table '
          + ' WHERE hr_min_amt <= "' + FloatToStr(salAmt / 1000) + '"' // ���̼���ǥ - õ������
          + ' AND hr_max_amt >= "' + FloatToStr(salAmt / 1000) + '"'
          + ' AND hr_apply_ym <= "' + salYm + '"'
          + ' ORDER BY hr_yyyy DESC LIMIT 1';
  //Form1.Memo1.Lines.Add('#���̼���ǥ ��ȸ'+#13+ashSQL);
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
  incomeTaxAmt := Trunc(incomeTaxAmt/10)*10; // ����������

  SetLength(result, 4);
  Result[0] := incomeTaxAmt; // ���̼���ǥ�� ���� �ҵ漼
  Result[1] := Form1.vtTemp.FieldByName('hr_min_amt').AsFloat; // �޿����ѱݾ�(�̻�)
  Result[2] := Form1.vtTemp.FieldByName('hr_max_amt').AsFloat; // �޿����ѱ޾�(�̸�)

  // �ٷ��ں� ��������õ¡������ ��ȸ
  ashSQL := 'SELECT hr_withhold_rate'
          + ' FROM hr_m_incometax_rate'
          + ' WHERE hr_m_code = "' + mCode + '"'
          + ' AND hr_yyyymm <= "' + salYm + '"' // �ͼӿ���
          + ' ORDER BY hr_yyyymm DESC, hr_sn DESC LIMIT 1';
  //Form1.Memo1.Lines.Add('#�ٷ��ں� ��������õ¡������ ��ȸ'+#13+ashSQL);
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
    Result[3] := Trunc(incomeTaxAmt * Form1.vtTemp.FieldByName('hr_withhold_rate').AsFloat/10)*10 // ����������¡�������� ���� �ҵ漼
  else
    Result[3] := incomeTaxAmt;
end;

// �ǰ�������� ��ȸ
{
  yyyymm  : �ͼӿ���

  return  : Result[0] �ٷ��ںδ� �ǰ��������
            Result[1] ��������纸�����
            Result[2] ����纸�� �氨��
            Result[3] �������� ���Ѽ�
            Result[4] �������� ���Ѽ�
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

  //Form1.Memo1.Lines.Add('#�ǰ�������� ��ȸ' + #13#10 + ashSql);
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

// �ǰ������ ���
{
  mCode  : �����ȣ
  oCode  : �����ڵ�
  yyyymm : å������
  monthlyWageAmt : ��������, 0 �̸� �ٷ����� �������� ��ȸ

  return  : Result[0] �ǰ������ �����ںδ��
            Result[1] ����纸��� �����ںδ��
}
function getNhisAmt(mCode, oCode, yyyymm: String; monthlyWageAmt: Double = 0): TArray<Double>;
var
  ashSQL, reductAb: string;
  // ��������, �ٷ��ںδ� �ǰ��������, ��������纸�����, ����纸�� �氨��, �����������Ѽ�, �������׻��Ѽ�
  standardAmt, nhisLaborInRate, recupRate, reductionRate, minAmt, maxAmt, nhisAmt, nhisRecupAmt: Double;
  ashArr: TArray<Double>;
begin
  SetLength(ashArr, 5);
  ashArr := getNhisRate(yyyymm); // �ǰ�������� ��ȸ
  nhisLaborInRate := ashArr[0];
  recupRate       := ashArr[1];
  reductionRate   := ashArr[2];
  minAmt          := ashArr[3];
  maxAmt          := ashArr[4];

  if monthlyWageAmt = 0 then
  begin
    // ��������, �����氨��󿩺� ��ȸ
    ashSQL := 'SELECT hr_standard_amt, hr_reduction_ab, hr_nhis_excl_yn'
            + ' FROM hr_personal_gongje_info'
            + ' WHERE hr_m_code = "' + mCode + '"'
            + ' AND hr_o_code = "'   + oCode + '"'
            + ' AND hr_div_ab = "2"'  // ������ - 2 �ǰ�����
            + ' AND hr_yyyymm <= "'  + yyyymm + '-01"' // ���ο���, �ǰ������� å��������, ���ڴ� ������ 1�Ϸ� �Է�
            + ' AND hr_use_yn = "Y"'
            + ' ORDER BY hr_yyyymm DESC LIMIT 1';

    //Form1.Memo1.Lines.Add('#�ǰ����� �������� ��ȸ' + #13#10 + ashSql);
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
    reductAb := Form1.vtTemp.FieldByName('hr_reduction_ab').AsString; // ����纸��氨�ڵ� - 1 �氨����, 2 �氨���, 3 ��������
  end
  else
  begin
    standardAmt := monthlyWageAmt;
    reductAb := '1';
  end;

  // ������ �Ǽ����� ����
  // 604�� ���� ���� 603 �� ������ ����..
  // �Ǽ�Ÿ���� �������¿� ����������� 2������ ó���� ���� �������� ��ȯ�Ǹ鼭 �Ͼ�� ����
  // �Ǽ������� ���������� ���� Trunc(604) �� 603���� ���͹����� ������ �Ͼ�� ��찡 �ִ�.
  // �̰��� �����ϱ� ���� �Ϲ������� ����Ǵ� ����� ��������� ������ ��ġ�� ���ϸ鼭,
  // �Ǽ����꿡�� �Ͼ �� �ִ� ������ ���̱� ���� ���� ���� ��밡�ɼ�ġ�� �����ִ� ����̴�. (+0.0000001)
  if (standardAmt < (minAmt * 10000)) then  // ���� : ����
  begin
    nhisAmt := Trunc(minAmt * nhisLaborInRate * 10 + 0.0000001)*10; // 10���̸� �ܼ� ����
  end
  else if (standardAmt > (maxAmt * 10000)) then
  begin
    nhisAmt := Trunc(maxAmt * nhisLaborInRate * 10 + 0.0000001)*10;
  end
  else
  begin
    nhisAmt := Trunc(standardAmt * nhisLaborInRate / 1000 + 0.0000001)*10;
  end;

  nhisRecupAmt := Trunc(nhisAmt * recupRate / 1000 + 0.0000001)*10; // �氨����

  if reductAb = '2' then // ����纸��氨���
  begin
    nhisRecupAmt := Trunc(nhisRecupAmt * (1 - reductionRate/100) /10)*10;
  end;

  //Form1.Memo1.Lines.Add('standardAmt::'+FloatToStr(standardAmt)+' nhisAmt:::'+FloatToStr(nhisAmt)+' nhisRecupAmt:::'+FloatToStr(nhisRecupAmt));

  SetLength(result, 2);
  Result[0] := nhisAmt;
  Result[1] := nhisRecupAmt;
end;

// ���� ����ٰ� ��ȸ
{
  ab  : ������
        1 �����ҵ�ټӿ�������,
        2 �����ҵ�ȯ��޿�����,
        3 �ҵ漼�⺻����,
        4 �����ҵ���⼼��Ư��,
        5 �ٷμҵ����
        6 �ٷμҵ漼�װ���

  ash : �����ڿ� ����
        1 �ټӿ���,
        2 ȯ��޿��ݾ�,
        3 ����ǥ�رݾ�,
        4 �������� ���⼼�� ����(%),
        5 �ٷμҵ� �ѱ޿���

  dt : ȸ�迬�� or ��������(19000101)

  return  : Result[0] ���Ѽ�
            Result[1] ���Ѽ�
            Result[2] ���ذ� - �����ڿ� ���� 1 �����ݾ�, 2 ������, 3 ����, 4 ��������, 5 ������
            Result[3] �ִ�ġ
}
function getTaxBase(ab: string; ash: Double; dt: string = ''): TArray<Double>;
var
  ashSQL, subSQL: string;
begin
  if ab = '4' then // �����ҵ���⼼��Ư��
  begin
    subSQL := ' AND hr_standard_value = "' + FloatToStr(ash) + '"'; // ��������
  end
  else
  begin
    subSQL := ' AND hr_over < ' + FloatToStr(ash);
  end;

  if (Length(dt) = 4) then // ȸ�迬��
    dt := dt + '0101';

  if (Length(dt) = 8) then
    subSQL := subSQL + ' AND hr_fiscal <= "' + dt + '"';

  ashSQL := 'SELECT hr_over, hr_less, hr_standard_value, hr_max_value'
          + ' FROM hr_retirement_tax_base'
          + ' WHERE hr_ab = "' + ab + '"'
          + subSQL
          + ' AND hr_use_yn = "Y"'
          + ' ORDER BY hr_fiscal DESC, hr_over DESC LIMIT 1';

  //Form1.Memo1.Lines.Add(ashSql);
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

// �ٷμҵ漼�װ����ѵ� ��ȸ
{
  totSalarAmt : �ѱ޿���
  return      : �ٷμҵ漼�װ����ѵ��ݾ�
}
function getEarnedIncomeDeductLimitAmt(totSalaryAmt: Double): Double;
var
  limitAmt, lessSalAmt, overSalAmt, deductAmt1, deductAmt2, deductAmt3: Double;
begin
  // �����ѵ�
  // 3300���� ����                  - 74����
  // 3300���� �ʰ� ~ 7000���� ����  - MAX[(74���� - (�ѱ޿��� - 3300����) * 0.008), 66����]
  // 7000���� �ʰ�                  - MAX[(66���� - (�ѱ޿��� - 7000����) * 0.5), 50����]
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

// ���ڽŰ����� ���� �̷� ����
procedure insertEReportHistory(ereportAb, bCode, oCode, presentYm, strfileCont: string; memo: string = '');
var
  ashSQL, ashStr: string;
begin
  ashSql := 'SELECT (IFNULL(MAX(hr_sn),0)+1) AS hr_sn FROM hr_ereport_history'
         + ' WHERE hr_ereport_ab = "' + ereportAb + '"' // ������������
         + ' AND hr_b_code = "' + bCode + '"'
         + ' AND hr_pay_ym = "' + presentYm + '"'       // ���⿬��
         + ' AND hr_o_code = "' + oCode + '"';

  //Form1.Memo1.Lines.Add('#�̷��Ϸù�ȣ ��ȸ ��' + #13#10 + ashSQL);
  ashStr := MySQL_Assign(Form1.db_coophr, Form1.qrysql, ashSQL, Form1.vtTemp);
  try
    StrToInt(ashStr);
  except
    ShowMessage('������ �߻��Ͽ����ϴ�.[' + ashStr + '](ERR:)');
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

  //Form1.Memo1.Lines.Add('#�̷����� ��'+#13#10+ashSQL);
  try
    ashReturnRow := StrToInt(MySQL_UpDel(Form1.db_coophr, Form1.qrysql, ashSQL));
  except
    on e: Exception do
    begin
      ShowMessage('���� ����.[hr_ereport_history]' + #13#10 + e.Message);
      Exit;
    end;
  end;
end;

// �������� ���ڵ� �ڸ���
procedure chkEFile(eAb, strfileCont: string);
var
  errList: TStringList;
  arrD: array of string;
  i, k, recSize, dataCnt: Integer;

begin
  if not isEmpty(strfileCont) then Exit;

  errList := TStringList.Create;
  errList.Clear;

  if eAb = 'C' then // �ٷμҵ�

  else if eAb = 'D' then // �Ƿ�����޸�����
  begin
    recSize := 251; // ���ڵ����
    dataCnt := 24;  // ���ڵ� �׸� ����
  end;

  SetLength(arrD, dataCnt);
  System.FillChar(arrD, SizeOf(arrD), #0); // �ʱ�ȭ

  if Length(AnsiString(strfileCont)) <> recSize then
    errList.Add('���ڵ���� ����['+ IntToStr(Length(AnsiString(strfileCont)))+ ' <> '+ IntToStr(recSize) +']');

  k := 1;

  if eAb = 'D' then
  begin
    for i := 0 to Length(arrD) - 1 do
    begin
      arrD[i] := Copy(strfileCont, k, arrM[i]);
      k := k + arrM[i];
      //Form1.Memo1.Lines.Add(arrD[i]);
    end;
  end;

end;

end.