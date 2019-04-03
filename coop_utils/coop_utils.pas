unit coop_utils;

interface

uses
  SysUtils, Classes, Windows,
  DB, ZAbstractRODataset, ZAbstractDataset, ZDataset, ZConnection, coop_sql_updel,
  Messages, Variants, Graphics, Controls, Forms, Dialogs, StdCtrls, VirtualTable, WinSock, Grids, DBGrids, excels;

// ���ڿ����� ��������.
function DelBlank(pfStr: string): string;

// �����޼��� ó��.
procedure Error(const Msg: string);

// �ʱ�ȭ�� ��ġ����.
procedure Set_MainPosition(app_main: TForm);

// �ֹε�Ϲ�ȣ üũ.
function CheckJumin(str: string): Boolean;

// �ֹε�Ϲ�ȣ ���ڸ� ���ϱ�.
function MakeJuminCRC(str: string): Char;

// 20110530 ��ΰ� �߰�
// FUND, PAY, UNION_DUES���̺��� PATH�� �ش� ���ڿ��� �����ϱ�
function PathToDetail(path: string): string;

// ���̺� Open �� Execute
function SQLToHistory(my_sql: string): string;
function MySQL_OpenExecute(my_dataset: TZQuery; my_sql: string): string;
function MySQL_OpenAssign(my_dataset: TZQuery; my_sql: string; my_virtual: TVirtualTable): string;
function DataSet_ReAssign(my_dataset: TDataSet; my_virtual: TVirtualTable): string;
function DataSet_FieldsAssign(my_dataset: TDataSet; my_virtual: TVirtualTable; my_keyfields: string): string;

// ItemIndex <-> DataValue('A','B','C', ...)
function ReturnABC(pfint: Integer): string;
function ReturnItemIndex(pfStr: string): Integer;
function NEWReturnItemIndex(pfStr: string): Integer;
function GetComboText(pfStr: string; pfcombo: TComboBox): string;

// ���ϰ���.
function ExtractFileNameNoExt(const fileName: string): string;
procedure StrToSaveToFile(var s: string; const fileName: string); overload;
procedure StrToSaveToFile(s1: PChar; len: Integer; const fileName: string); overload;
procedure GetComboFieldValue(pfcombo: TComboBox; my_virtual: TVirtualTable; compareStr: String; getfieldStr: String);
// 20150115 �޺��ڽ��� �������߰��κ�
procedure ComboBoxDataAdd(pfcombo: TComboBox; my_virtual: TVirtualTable; fieldname: String);

// ��ȣȭ����.
function Encrypt(const s: string; Key: Word): string;
function Decrypt(const s: string; Key: Word): string;

// �����ͺ���Ȯ��.
function CompDbData(pfDataSet: TDataSet; pfField: string; pfValue: string; pfType: Integer): string;

// ������ȯ.
function LunarHexToBin(pfData: string): string;
procedure syslog(strlog: string);
function Solar2Lunar(pfsoYear, pfsoMonth, pfsoDay: Word; var pfluYear, pfluMonth, pfluDay: Word;
  var pfIsLeap, pfIsLarge: Boolean; var pfErrMsg: string): Boolean;
function Lunar2Solar(pfluYear, pfluMonth, pfluDay: Word; pfIsLeap: Boolean; var pfsoYear, pfsoMonth, pfsoDay: Word;
  var pfErrMsg: string): Boolean;

// ���þ����Ǹ���Ʈ.
// function cuGetLocalIP: TStrings;

// �׸��� �������.
function DBGridToExcel(pfGrid: TDBGrid; pfDataSet: TDataSet; pfExcel: TExcel; pfstartRow: Integer): Integer;

// �ҷ����� üũ.
function ChkStrVal(pfString: string): string;

// ���ڿ�ġȯ.
function Str_ReplaceStr(pffromStr, pftoStr, pfSourceStr: string): string;

// Query Error ��������.
function Str_Truncate(pf_exceptStr, pf_SourceStr: string): string;

// ���Ϲ�ȯ.
function DayOfWeekDay(pf_day: TDate; pf_galho: Boolean): string;

// ȸ���̰� FTP ID,PW ����

function SetFTPID(checkInt : Integer): String;
function SetFTPPassword(ftpID : string; checkInt : Integer): String;

// ���ڿ����Ἲ.
function Str_Integrity(pf_Source, pf_After: string): string;

function Sol2Lun(soYear, soMonth, soDay: Word; var luYear, luMonth, luDay: Word; var IsLeap, IsLarge: Boolean;
  var ErrMsg: string): Boolean;
function Lun2Sol(luYear, luMonth, luDay: Word; IsLeap: Boolean; var soYear, soMonth, soDay: Word;
  var ErrMsg: string): Boolean;

function johapreturn(my_db: TZConnection; my_dataset: TZQuery; my_virtual: TVirtualTable; jcode: string) : TArray<string>;

function SendSMSToManager(my_db: TZConnection; my_dataset: TZQuery; my_virtual: TVirtualTable;
 send_time: string; mCode: string; mTel: string; sTel: string; msg: string; smCode: string; oCode: string; jCode: string; smsGubun: string) : string;

//

const
  pjwC1 = 74102;
  pjwC2 = 12337;
  HexaChar: packed array [0 .. 15] of Char = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D',
    'E', 'F');

  pjws_Year = 1881;
  pjwe_Year = 2050;
  s_Year = 1881;
  e_Year = 2050;
  LunDays: array [1 .. 6] of Integer = (353, 354, 355, 383, 384, 385);
  LunData: array [pjws_Year .. pjwe_Year, 1 .. 5] of Char = ('5H57A', '3 55B', '2 25D', '5F95B', '2 92B', '2 A95',
    '5ED95', '2 B4A', '3 B55', '5C6D5', // 1890
    '3 55B', '5G277', '2 257', '2 52B', '4FAAA', '3 E95', '2 6AA', '5DBAA', '3 AB5', '5I4BD', // 1900
    '2 4AE', '3 A57', '4F54D', '2 D26', '3 D95', '5e655', '2 56A', '3 9AD', '5C55D', '2 4AE', // 1910
    '5GA5B', '2 A4D', '2 D25', '5FDA9', '3 B55', '2 56A', '5CADA', '3 95D', '5H4BB', '2 49B', // 1920
    '2 A4B', '5FB4B', '2 6A9', '2 AD4', '6EBB5', '2 2B6', '3 95B', '5C537', '2 497', '4G656', // 1930
    '2 E4A', '3 EA5', '5f6A9', '3 5B5', '2 2B6', '5d8AE', '2 92E', '5hC8D', '2 C95', '2 D4A', // 1940
    '5gD8A', '3 B69', '3 56D', '5e25B', '2 25D', '2 92D', '5CD2B', '2 A95', '5HD55', '2 B4A', // 1950
    '3 B55', '5f555', '3 4DB', '2 25B', '5d857', '2 52B', '5IA9B', '2 695', '2 6AA', '5GAEA', // 1960
    '3 AB5', '2 4B6', '5EAAE', '3 A57', '2 527', '4D726', '3 D95', '5H6B5', '2 56A', '3 9AD', // 1970
    '5F4DD', '2 4AE', '2 A4E', '5ED4D', '2 D25', '5ID59', '2 B54', '3 D6A', '5g95A', '3 95B', // 1980
    '2 49B', '5EA9B', '2 A4B', '5KB27', '2 6A5', '2 6D4', '6GB75', '2 2B6', '3 95B', '5F4B7', // 1990
    '2 497', '2 64B', '4D74A', '3 EA5', '5I6D9', '3 5AD', '2 2B6', '5F96E', '2 92E', '2 C96', // 2000
    '5EE95', '2 D4A', '3 DA5', '5C755', '2 56C', '6HABB', '2 25D', '2 92D', '5FCAB', '2 A95', // 2010
    '2 B4A', '5dB4A', '3 B55', '5J55D', '2 4BA', '3 A5B', '5F557', '2 52B', '2 A95', '5EB95', // 2020
    '2 6AA', '3 AD5', '5C6B5', '2 4B6', '5GA6E', '3 A57', '2 527', '4F6A6', '3 D93', '2 5AA', // 2030
    '5DB6A', '3 96D', '5L4AF', '2 4AE', '2 A4D', '5gD0D', '2 D25', '2 D52', '5FDD4', '3 B6A', // 2040
    '3 96D', '5C55B', '2 49B', '5HA57', '2 A4B', '2 B25', '5fB25', '2 6D4', '3 ADA', '5d8B6'); // 2050

implementation

uses Unit1;

// 2015-02-05 �߰�

function LunHexToBin(Data: string): string;
var
  I, Hex, Temp: Integer;
begin
  SetLength(Result, 12);
  Hex := StrToInt('$' + Copy(Data, 3, 3));
  Temp := 2048; // 10000000000  12�ڸ� 2���� ��Ʈ��
  for I := 1 to 12 do
  begin
    if Hex < Temp then
      Result[I] := #0 // ������
    else
    begin
      Result[I] := #1; // ū��
      Hex := Hex - Temp;
    end;
    Temp := Temp shr 1;
  end;
  case Data[2] of
    'A' .. 'L':
      Insert(#0, Result, Ord(Data[2]) - 64); // ���� ������ ����
    'a' .. 'l':
      Insert(#1, Result, Ord(Data[2]) - 96); // "  ū��    "
  end;
end;

function Sol2Lun(soYear, soMonth, soDay: Word; var luYear, luMonth, luDay: Word; var IsLeap, IsLarge: Boolean;
  var ErrMsg: string): Boolean;
var
  EnDays: Integer;

  function CheckDays(d: Integer): Boolean;
  begin
    Result := EnDays - d > 0;
    if Result then
      EnDays := EnDays - d;
  end;

  procedure DoLuner(StartYear, Days: Integer);
  var
    BitStr: string;
    LeapIndex: Integer;
  begin
    Result := True;
    EnDays := EnDays - Days;
    luYear := StartYear;
    while CheckDays(LunDays[StrToInt(LunData[luYear, 1])]) do
      Inc(luYear);
    BitStr := LunHexToBin(LunData[luYear]);
    luMonth := 1;
    while CheckDays(29 + Ord(BitStr[luMonth])) do
      Inc(luMonth);
    luDay := EnDays;
    IsLarge := BitStr[luMonth] = #1;
    LeapIndex := Ord(UpCase(LunData[luYear, 2])) - 64;
    IsLeap := luMonth = LeapIndex;
    if (LeapIndex > 0) and (LeapIndex <= luMonth) then
      Dec(luMonth);
  end;

begin
  Result := False;
  try
    EnDays := Trunc(EnCodeDate(soYear, soMonth, soDay));
  except
    ErrMsg := '�Էµ� ���ڰ� �ùٸ��� �ʽ��ϴ�.';
  end;
  if (EnDays < -6909) or (EnDays > 55194) then // EnCodeDate(1881, 1, 30), EnCodeDate(2051, 2, 10)
    ErrMsg := '����� �Է¹����� 1881-01-30 ~ 2051-02-10 �Դϴ�.'
  else if EnDays > 24128 then
    DoLuner(1966, 24128)
  else
    DoLuner(1881, -6909);
end;

function Lun2Sol(luYear, luMonth, luDay: Word; IsLeap: Boolean; var soYear, soMonth, soDay: Word;
  var ErrMsg: string): Boolean;
var
  LeapIndex: Integer;
  BitStr: string;

  procedure DoSolar(StartYear, Days: Integer);
  var
    I: Integer;
  begin
    Result := True;
    Days := luDay + Days;
    for I := StartYear to luYear - 1 do
      Days := Days + LunDays[StrToInt(LunData[I, 1])];
    if IsLeap or (LeapIndex > 0) and (LeapIndex <= luMonth) then
      Inc(luMonth);
    for I := 1 to luMonth - 1 do
      Days := Days + 29 + Ord(BitStr[I]);
    DeCodeDate(Days, soYear, soMonth, soDay);
  end;

begin
  Result := False;
  if (luYear < s_Year) or (luYear > e_Year) then
    ErrMsg := '������ �Է¹����� 1881�� ~ 2050�� �Դϴ�.'
  else
  begin
    BitStr := LunHexToBin(LunData[luYear]);
    LeapIndex := Ord(UpCase(LunData[luYear, 2])) - 64;
    if IsLeap and (LeapIndex <> luMonth + 1) then
      ErrMsg := IntToStr(luYear) + '-' + IntToStr(luMonth) + '���� ������ �����ϴ�'
    else if luDay > 29 + Ord(BitStr[luMonth]) then
      ErrMsg := IntToStr(luYear) + '-' + IntToStr(luMonth) + '���� ' + IntToStr(29 + Ord(BitStr[luMonth])) + '�� ���� �Դϴ�.'
    else if luYear > 1965 then
      DoSolar(1966, 24128)
    else
      DoSolar(1881, -6909);
  end;
end;

// 2015-02-05 �߰� END

function Str_Integrity(pf_Source, pf_After: string): string;
var
  AshStr: string;
begin
  AshStr := Trim(pf_Source);
  AshStr := StringReplace(AshStr, '''', pf_After, [rfReplaceAll]);
  AshStr := StringReplace(AshStr, '"', pf_After, [rfReplaceAll]);
  Result := AshStr;
end;

function DayOfWeekDay(pf_day: TDate; pf_galho: Boolean): string;
begin
  case DayOfWeek(pf_day) of
    1:
      begin
        if pf_galho then
          Result := '(��)'
        else
          Result := '��';
      end;
    2:
      begin
        if pf_galho then
          Result := '(��)'
        else
          Result := '��';
      end;
    3:
      begin
        if pf_galho then
          Result := '(ȭ)'
        else
          Result := 'ȭ';
      end;
    4:
      begin
        if pf_galho then
          Result := '(��)'
        else
          Result := '��';
      end;
    5:
      begin
        if pf_galho then
          Result := '(��)'
        else
          Result := '��';
      end;
    6:
      begin
        if pf_galho then
          Result := '(��)'
        else
          Result := '��';
      end;
    7:
      begin
        if pf_galho then
          Result := '(��)'
        else
          Result := '��';
      end;
  else
    begin
      if pf_galho then
        Result := '(��)'
      else
        Result := '��';
    end;
  end;
end;

function Str_ReplaceStr(pffromStr, pftoStr, pfSourceStr: string): string;
var
  AshInt: Integer;
  AshfromStr, AshtoStr, AshSourceStr: string;
begin
  Result := 'Error';
  AshfromStr := pffromStr;
  AshtoStr := pftoStr;
  AshSourceStr := pfSourceStr;
  if Pos(AshfromStr, AshtoStr) <> 0 then
  begin
    ShowMessage('[' + AshtoStr + ']���ڿ� [' + AshfromStr + ']�� ���ԵǾ� �ֽ��ϴ�!!!');
    Exit;
  end;

  while Pos(AshfromStr, AshSourceStr) <> 0 do
  begin
    AshInt := Pos(AshfromStr, AshSourceStr);
    System.Delete(AshSourceStr, AshInt, Length(AshfromStr));
    System.Insert(AshtoStr, AshSourceStr, AshInt);
  end;
  Result := AshSourceStr
end;

function Str_Truncate(pf_exceptStr, pf_SourceStr: string): string;
var
  AshSourceStr: string;
begin
  AshSourceStr := pf_SourceStr;
  if Pos(' ', pf_exceptStr) = 0 then
    AshSourceStr := Str_ReplaceStr(' ', '', AshSourceStr);
  if Pos('''', pf_exceptStr) = 0 then
    AshSourceStr := Str_ReplaceStr('''', '', AshSourceStr);
  if Pos('"', pf_exceptStr) = 0 then
    AshSourceStr := Str_ReplaceStr('"', '', AshSourceStr);
  Result := AshSourceStr;
end;

function ChkStrVal(pfString: string): string;
begin
  Result := '';
  if Pos('''', pfString) <> 0 then
  begin
    Result := '���ڿ� ����ǥ(''), �ֵ���ǥ(")�� ����� �� �����ϴ�!!!';
    Exit;
  end;
  if Pos('"', pfString) <> 0 then
  begin
    Result := '���ڿ� �ֵ���ǥ("), ����ǥ('')�� ����� �� �����ϴ�!!!';
    Exit;
  end;
end;

function DBGridToExcel(pfGrid: TDBGrid; pfDataSet: TDataSet; pfExcel: TExcel; pfstartRow: Integer): Integer;
var
  I: Integer;
begin
  Result := pfstartRow;
  if not pfDataSet.Active then
    Exit;
  if pfDataSet.RecordCount = 0 then
    Exit;

  if pfstartRow < 1 then
    pfstartRow := 1;
  if pfstartRow = 1 then
  begin
    pfExcel.Connect;
    pfExcel.Exec('[WORKBOOK.INSERT(1)]');
  end;

  for I := 0 to pfGrid.Columns.Count - 1 do
  begin
    if pfGrid.Columns.Items[I].Visible then
      pfExcel.PutStr(pfstartRow, I + 1, pfGrid.Columns.Items[I].Title.Caption);
  end;
  pfstartRow := pfstartRow + 1;

  pfDataSet.First;
  while not pfDataSet.Eof do
  begin
    for I := 0 to pfGrid.Columns.Count - 1 do
    begin
      if pfGrid.Columns.Items[I].Visible then
        pfExcel.PutStr(pfstartRow, I + 1, pfDataSet.FieldByName(pfGrid.Columns.Items[I].fieldname).AsString);
    end;
    pfstartRow := pfstartRow + 1;
    pfDataSet.Next;
  end;
  pfExcel.Disconnect;
  Result := pfstartRow;
end;

{
  function cuGetLocalIP: TStrings;
  type
  cuTaPInAddr = array[0..10] of PInAddr;
  cuPaPInAddr = ^cuTaPInAddr;
  var
  i: Integer;
  Ashphe: PHostEnt;
  Ashpptr: cuPaPInAddr;
  AshBuffer: array[0..63] of Char;
  AshGInitData: TWSAData;
  begin
  WSAStartup($101, AshGInitData);
  Result := TStringList.Create;
  Result.Clear;
  GetHostName(AshBuffer, SizeOf(AshBuffer));
  Ashphe := GetHostByName(AshBuffer);
  if Ashphe = nil then
  Exit;

  Ashpptr := cuPaPInAddr(Ashphe^.h_addr_list);
  i := 0;
  while Ashpptr^[i] <> nil do
  begin
  Result.Add(inet_ntoa(Ashpptr^[i]^));
  Inc(i);
  end;
  WSACleanup;
  end;
}

function LunarHexToBin(pfData: string): string;
var
  I, AshHex, AshTemp: Integer;
begin
  SetLength(Result, 12);
  AshHex := StrToInt('$' + Copy(pfData, 3, 3));
  AshTemp := 2048; // 10000000000  12�ڸ� 2���� ��Ʈ��
  for I := 1 to 12 do
  begin
    if AshHex < AshTemp then
      Result[I] := #0 // ������
    else
    begin
      Result[I] := #1; // ū��
      AshHex := AshHex - AshTemp;
    end;
    AshTemp := AshTemp shr 1;
  end;
  case pfData[2] of
    'A' .. 'L':
      Insert(#0, Result, Ord(pfData[2]) - 64); // ���� ������ ����
    'a' .. 'l':
      Insert(#1, Result, Ord(pfData[2]) - 96); // "  ū��    "
  end;
end;

// 20150115 comboboxdataAdd
procedure ComboBoxDataAdd(pfcombo: TComboBox; my_virtual: TVirtualTable; fieldname: String);
begin
  my_virtual.First;
  while not my_virtual.Eof do
  begin
    pfcombo.Items.Add(my_virtual.FieldByName(fieldname).AsString);
    my_virtual.Next;
  end;
  pfcombo.Text := '';
  my_virtual.First;
end;

function Solar2Lunar(pfsoYear, pfsoMonth, pfsoDay: Word; var pfluYear, pfluMonth, pfluDay: Word;
  var pfIsLeap, pfIsLarge: Boolean; var pfErrMsg: string): Boolean;
var
  AshEnDays: Integer;

  function Sub_CheckDays(sub_pfd: Integer): Boolean;
  begin
    Result := AshEnDays - sub_pfd > 0;
    if Result then
      AshEnDays := AshEnDays - sub_pfd;
  end;

  procedure DoLuner(sub_pfStartYear, sub_pfDays: Integer);
  var
    AshSubBitStr: string;
    AshSubLeapIndex: Integer;
  begin
    Result := True;
    AshEnDays := AshEnDays - sub_pfDays;
    pfluYear := sub_pfStartYear;
    while Sub_CheckDays(LunDays[StrToInt(LunData[pfluYear, 1])]) do
      Inc(pfluYear);
    AshSubBitStr := LunarHexToBin(LunData[pfluYear]);
    pfluMonth := 1;
    while Sub_CheckDays(29 + Ord(AshSubBitStr[pfluMonth])) do
      Inc(pfluMonth);
    pfluDay := AshEnDays;
    pfIsLarge := AshSubBitStr[pfluMonth] = #1;
    AshSubLeapIndex := Ord(UpCase(LunData[pfluYear, 2])) - 64;
    pfIsLeap := pfluMonth = AshSubLeapIndex;
    if (AshSubLeapIndex > 0) and (AshSubLeapIndex <= pfluMonth) then
      Dec(pfluMonth);
  end;

begin
  Result := False;
  try
    AshEnDays := Trunc(EnCodeDate(pfsoYear, pfsoMonth, pfsoDay));
  except
    pfErrMsg := '�Էµ� ���ڰ� �ùٸ��� �ʽ��ϴ�.';
  end;
  if (AshEnDays < -6909) or (AshEnDays > 55194) then // EnCodeDate(1881, 1, 30), EnCodeDate(2051, 2, 10)
    pfErrMsg := '����� �Է¹����� 1881-01-30 ~ 2051-02-10 �Դϴ�.'
  else
  begin
    if AshEnDays > 24128 then
      DoLuner(1966, 24128)
    else
      DoLuner(1881, -6909);
  end;
end;

function Lunar2Solar(pfluYear, pfluMonth, pfluDay: Word; pfIsLeap: Boolean; var pfsoYear, pfsoMonth, pfsoDay: Word;
  var pfErrMsg: string): Boolean;
var
  AshLeapIndex: Integer;
  AshBitStr: string;

  procedure DoSolar(sub_pfStartYear, sub_pfDays: Integer);
  var
    Ashsub_i: Integer;
  begin
    Result := True;
    sub_pfDays := pfluDay + sub_pfDays;
    for Ashsub_i := sub_pfStartYear to pfluYear - 1 do
      sub_pfDays := sub_pfDays + LunDays[StrToInt(LunData[Ashsub_i, 1])];
    if pfIsLeap or (AshLeapIndex > 0) and (AshLeapIndex <= pfluMonth) then
      Inc(pfluMonth);
    for Ashsub_i := 1 to pfluMonth - 1 do
      sub_pfDays := sub_pfDays + 29 + Ord(AshBitStr[Ashsub_i]);
    DeCodeDate(sub_pfDays, pfsoYear, pfsoMonth, pfsoDay);
  end;

begin
  Result := False;
  if ((pfluYear < pjws_Year) or (pfluYear > pjwe_Year)) then
    pfErrMsg := '������ �Է¹����� 1881�� ~ 2050�� �Դϴ�.'
  else
  begin
    AshBitStr := LunarHexToBin(LunData[pfluYear]);
    AshLeapIndex := Ord(UpCase(LunData[pfluYear, 2])) - 64;
    if pfIsLeap then
    begin
      if (AshLeapIndex <> (pfluMonth + 1)) then
        pfErrMsg := IntToStr(pfluYear) + '-' + IntToStr(pfluMonth) + '���� ������ �����ϴ�'
    end
    else
    begin
      if (pfluDay > (29 + Ord(AshBitStr[pfluMonth]))) then
        pfErrMsg := IntToStr(pfluYear) + '-' + IntToStr(pfluMonth) + '���� ' + IntToStr(29 + Ord(AshBitStr[pfluMonth])) +
          '�� ���� �Դϴ�.'
      else
      begin
        if pfluYear > 1965 then
          DoSolar(1966, 24128)
        else
          DoSolar(1881, -6909);
      end;
    end;
  end;
end;

function CompDbData(pfDataSet: TDataSet; pfField: string; pfValue: string; pfType: Integer): string;
begin
  Result := '';
  case pfType of
    1: // String.
      begin
        if pfDataSet.FieldByName(pfField).AsString <> pfValue then
          Result := ',' + pfField + '="' + pfValue + '"';
      end;
    2: // Date.
      begin
        if FormatDateTime('yyyy-mm-dd', pfDataSet.FieldByName(pfField).AsDateTime) <> pfValue then
          Result := ',' + pfField + '="' + pfValue + '"';
      end;
    3: // DateTime.
      begin
        if FormatDateTime('yyyy-mm-dd hh:mm:ss', pfDataSet.FieldByName(pfField).AsDateTime) <> pfValue then
          Result := ',' + pfField + '="' + pfValue + '"';
      end;
  else
    begin
      if pfDataSet.FieldByName(pfField).AsString <> pfValue then
        Result := ',' + pfField + '=' + pfValue;
    end;
  end;
end;

function DelBlank(pfStr: string): string;
begin
  while Pos(' ', pfStr) <> 0 do
    System.Delete(pfStr, Pos(' ', pfStr), 1);

  Result := pfStr;
end;

procedure Set_MainPosition(app_main: TForm);
begin
  if (Screen.Width - app_main.Width) >= 0 then
  begin
    app_main.Left := (Screen.Width - app_main.Width) div 2;
    app_main.Top := 0;
  end
  else
    app_main.Position := poScreenCenter;
end;

function CheckJumin(str: string): Boolean;
const
  n: packed array [1 .. 12] of Integer = (2, 3, 4, 5, 6, 7, 8, 9, 2, 3, 4, 5);
var
  I, j, k: Integer;
begin
  str := Trim(str);
  if Length(str) <> 13 then
  begin
    Result := False;
    Exit;
  end;

  try
    j := 0;
    for I := 1 to 12 do
      j := j + StrToInt(str[I]) * n[I];
    k := 11 - (j mod 11);
    if k = 11 then
      k := 1;
    if k = 10 then
      k := 0;

    Result := Char(k + 48) = str[13];
  except
    Result := False;
  end;
end;

// �ֹε�Ϲ�ȣ ���ڸ� ���ϱ�.

function MakeJuminCRC(str: string): Char;
const
  n: packed array [1 .. 12] of Integer = (2, 3, 4, 5, 6, 7, 8, 9, 2, 3, 4, 5);
var
  I, j, k: Integer;
begin
  str := Trim(str);
  if Length(str) <> 12 then
  begin
    Result := '*';
    Exit;
  end;

  try
    j := 0;
    for I := 1 to 12 do
      j := j + StrToInt(str[I]) * n[I];
    k := 11 - (j mod 11);
    if k = 11 then
      k := 1;
    if k = 10 then
      k := 0;

    Result := Char(k + 48);
  except
    Result := '*';
  end;
end;

function SQLToHistory(my_sql: string): string;
var
  AshStr: string;
  AshPosInt: Integer;
begin
  my_sql := Trim(my_sql);
  AshStr := UpperCase(my_sql);
  while Pos('NOW()', AshStr) <> 0 do
  begin
    AshPosInt := Pos('NOW()', AshStr);
    System.Delete(my_sql, AshPosInt, 5);
    System.Insert('"' + FormatDateTime('yyyy-mm-dd hh:mm:ss', Now) + '"', my_sql, AshPosInt);
    AshStr := UpperCase(my_sql);
  end;

  while Pos('"', my_sql) <> 0 do
  begin
    AshPosInt := Pos('"', my_sql);
    System.Delete(my_sql, AshPosInt, 1);
    System.Insert('��', my_sql, AshPosInt);
  end;
  my_sql := mpst_name + '[' + mpst_code + ']-(' + FormatDateTime('yyyy-mm-dd hh:mm:ss', Now) + ')' + #13#10 +
    my_sql + #13#10;
  Result := my_sql;
end;

function MySQL_OpenExecute(my_dataset: TZQuery; my_sql: string): string;
var
  AshClauseStr: string;
begin
  my_sql := Trim(my_sql);
  AshClauseStr := UpperCase(Copy(my_sql, 1, 6));
  my_dataset.Close;
  my_dataset.SQL.Clear;
  my_dataset.SQL.Add(my_sql);
  if AshClauseStr = 'SELECT' then
  begin
    try
      try
        my_dataset.Open;
      except
        try
          my_dataset.Open;
        except
          my_dataset.Open;
        end;
      end;
    except
      on E: Exception do
      begin
        if (PromptStr = 'Z') then
          InputQuery(my_dataset.Name, 'Open_Error', my_sql);
        Result := E.Message;
        Exit;
      end;
    end;
  end
  else if ((AshClauseStr = 'INSERT') or (AshClauseStr = 'UPDATE') or (AshClauseStr = 'DELETE')) then
  begin
    try
      my_dataset.ExecSQL;
    except
      on E: Exception do
      begin
        if (PromptStr = 'Z') then
          InputQuery(my_dataset.Name, 'Open_Error', my_sql);
        Result := E.Message;
        Exit;
      end;
    end;
  end
  else
  begin
    if (PromptStr = 'Z') then
      InputQuery(my_dataset.Name, 'Open_Error', my_sql);
    Result := 'Error(3): ' + my_sql;
    Exit;
  end;
  Result := '';
end;

function MySQL_OpenAssign(my_dataset: TZQuery; my_sql: string; my_virtual: TVirtualTable): string;
var
  I, AshSize: Integer;
  AshSQL, AshClauseStr, AshVersion: string;
begin
  my_sql := Trim(my_sql);
  AshClauseStr := UpperCase(Copy(my_sql, 1, 6));
  if AshClauseStr = 'SELECT' then
  begin
    AshSQL := 'Select Version()';
    MySQL_OpenExecute(my_dataset, AshSQL);
    try
      AshVersion := Copy(my_dataset.Fields.Fields[0].AsString, 1, 1);
    except
      AshVersion := '4';
    end;

    my_dataset.Close;
    my_dataset.SQL.Clear;
    my_dataset.SQL.Add(my_sql);
    try
      try
        my_dataset.Open;
      except
        try
          my_dataset.Open;
        except
          my_dataset.Open;
        end;
      end;
      my_virtual.Clear;
      my_virtual.Assign(my_dataset);
      my_dataset.Close;
      my_virtual.Open;

      if AshVersion <> '4' then
      begin
        for I := 0 to my_virtual.Fields.Count - 1 do
        begin
          if my_virtual.Fields.Fields[I].DataType = ftString then
          begin
            if my_virtual.Fields.Fields[I].DataSize = my_virtual.Fields.Fields[I].DisplayWidth then
              AshSize := Round((my_virtual.Fields.Fields[I].DataSize) / 3)
            else
              AshSize := Round((my_virtual.Fields.Fields[I].DataSize - 1) / 3);
            my_virtual.Fields.Fields[I].DisplayWidth := AshSize;
          end;
        end;
      end;
    except
      on E: Exception do
      begin
        if (PromptStr = 'Z') then
          InputQuery(my_dataset.Name, 'Open_Error', my_sql);
        Result := E.Message;
        Exit;
      end;
    end;
    Result := '';
  end
  else
  begin
    Result := 'No Select Query';
  end;
end;

// 20150115 �޺��ڽ����� ������ ���� ��, ������ row���� ���ϴ� �ʵ尪 ����.
procedure GetComboFieldValue(pfcombo: TComboBox; my_virtual: TVirtualTable; compareStr: String; getfieldStr: String);
begin
  pfcombo.Hint := '';
  if Trim(pfcombo.Text) = '' then
    Exit;

  if my_virtual.Locate(compareStr, pfcombo.Text, []) then
  begin
    pfcombo.Hint := my_virtual.FieldByName(getfieldStr).AsString;
  end;
end;

procedure mainClose(my_virtual: TVirtualTable);
begin
  if my_virtual.Active then
    my_virtual.Close;
end;

function DataSet_ReAssign(my_dataset: TDataSet; my_virtual: TVirtualTable): string;
var
  I: Integer;
begin
  try
    my_virtual.Clear;
    my_virtual.Assign(my_dataset);
    my_virtual.Open;

    for I := 0 to my_dataset.Fields.Count - 1 do
    begin
      if my_dataset.Fields.Fields[I].DataType = ftString then
        my_virtual.Fields.Fields[I].DisplayWidth := my_dataset.Fields.Fields[I].DisplayWidth;
    end;
  except
    Result := 'Error!!!';
    Exit;
  end;
  Result := '';
end;

function DataSet_FieldsAssign(my_dataset: TDataSet; my_virtual: TVirtualTable; my_keyfields: string): string;
var
  I: Integer;
begin
  try
    if my_virtual.Fields.Count = 0 then
    begin
      for I := 0 to my_dataset.Fields.Count - 1 do
      begin
        { Count()�� ftLargeint.
          case my_dataset.Fields.Fields[i].DataType of
          ftUnknown: ShowMessage('1');
          ftString: ShowMessage('2');
          ftSmallint: ShowMessage('3');
          ftInteger: ShowMessage('4');
          ftWord: ShowMessage('5');
          ftBoolean: ShowMessage('6');
          ftFloat: ShowMessage('7');
          ftCurrency: ShowMessage('8');
          ftBCD: ShowMessage('9');
          ftDate: ShowMessage('11');
          ftTime: ShowMessage('12');
          ftDateTime: ShowMessage('13');
          ftBytes: ShowMessage('14');
          ftVarBytes: ShowMessage('15');
          ftAutoInc: ShowMessage('16');
          ftBlob: ShowMessage('17');
          ftMemo: ShowMessage('18');
          ftGraphic: ShowMessage('19');
          ftFmtMemo: ShowMessage('20');
          ftParadoxOle: ShowMessage('21');
          ftDBaseOle: ShowMessage('22');
          ftTypedBinary: ShowMessage('23');
          ftCursor: ShowMessage('24');
          ftFixedChar: ShowMessage('25');
          ftWideString: ShowMessage('26');
          ftLargeint: ShowMessage('27');
          ftADT: ShowMessage('28');
          ftArray: ShowMessage('29');
          ftReference: ShowMessage('30');
          ftDataSet: ShowMessage('31');
          ftOraBlob: ShowMessage('32');
          ftOraClob: ShowMessage('33');
          ftVariant: ShowMessage('34');
          ftInterface: ShowMessage('35');
          ftIDispatch: ShowMessage('36');
          ftGuid: ShowMessage('37');
          ftTimeStamp: ShowMessage('38');
          ftFMTBcd: ShowMessage('39');
          end;
        }
        if ((my_dataset.Fields.Fields[I].DataType = ftString) or (my_dataset.Fields.Fields[I].DataType = ftFixedChar) or
          (my_dataset.Fields.Fields[I].DataType = ftWideString)) then
          my_virtual.AddField(my_dataset.Fields.Fields[I].fieldname, my_dataset.Fields.Fields[I].DataType,
            my_dataset.Fields.Fields[I].DataSize, False)
        else
          my_virtual.AddField(my_dataset.Fields.Fields[I].fieldname, my_dataset.Fields.Fields[I].DataType, 0, False);
      end;
    end;

    my_dataset.First;
    while not my_dataset.Eof do
    begin
      if ((my_keyfields <> '') and (my_keyfields <> '.')) then
      begin
        if my_virtual.Locate(my_keyfields, my_dataset.FieldByName(my_keyfields).AsString, []) then
        begin
          my_virtual.Edit;
          for I := 0 to my_dataset.Fields.Count - 1 do
          begin
            if Pos(my_dataset.Fields.Fields[I].fieldname, '[' + my_keyfields + ']') = 0 then
            begin
              if my_dataset.Fields.Fields[I].DataType = ftLargeint then
                my_virtual.Fields.Fields[I].AsInteger := my_dataset.Fields.Fields[I].AsInteger
              else
                my_virtual.Fields.Fields[I].AsVariant := my_dataset.Fields.Fields[I].AsVariant;
            end;
          end;
          my_virtual.Post;
        end
        else
        begin
          my_virtual.Append;
          for I := 0 to my_dataset.Fields.Count - 1 do
          begin
            if my_dataset.Fields.Fields[I].DataType = ftLargeint then
              my_virtual.Fields.Fields[I].AsInteger := my_dataset.Fields.Fields[I].AsInteger
            else
              my_virtual.Fields.Fields[I].AsVariant := my_dataset.Fields.Fields[I].AsVariant;
          end;
          my_virtual.Post;
        end;
      end
      else
      begin
        my_virtual.Append;
        for I := 0 to my_dataset.Fields.Count - 1 do
        begin
          if my_dataset.Fields.Fields[I].DataType = ftLargeint then
            my_virtual.Fields.Fields[I].AsInteger := my_dataset.Fields.Fields[I].AsInteger
          else
            my_virtual.Fields.Fields[I].AsVariant := my_dataset.Fields.Fields[I].AsVariant;
        end;
        my_virtual.Post;
      end;
      my_dataset.Next;
    end;
  except
    Result := 'Error!!!';
    Exit;
  end;
  Result := '';
end;

function SetFTPID(checkInt : Integer): String;
begin
  if checkInt = 1 then
  begin
    Result := 'icoop_transfer';
  end
  else
  begin
    Result := '���ٱ����� �����ϴ�.';
  end;
end;

function SetFTPPassword(ftpID : string; checkInt : Integer): String;
begin

  if ftpID = 'icoop_transfer' then
  begin
    if checkInt = 1 then
    begin
      Result := 'icooptran3178!@#';
    end
    else
    begin
      Result := '���ٱ����� �����ϴ�.';
    end;
  end
  else
  begin
    Result := '���ٱ����� �����ϴ�.';
  end;

end;

function GetComboText(pfStr: string; pfcombo: TComboBox): string;
var
  AshStr: string;
  AshInt: Integer;
begin
  AshStr := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  AshInt := Pos(pfStr, AshStr) - 1;
  AshStr := pfcombo.Items.Strings[AshInt];
  if AshStr = '' then
    Result := pfcombo.Items.Strings[pfcombo.Items.Count - 1]
  else
    Result := AshStr;
end;

// Data Value -> ComboBox.ItemIndex

function ReturnItemIndex(pfStr: string): Integer;
var
  AshStr: string;
begin
  AshStr := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  Result := Pos(pfStr, AshStr) - 1;
end;

function NEWReturnItemIndex(pfStr: string): Integer;
var
  AshStr: string;
begin
  AshStr := ' ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  Result := Pos(pfStr, AshStr) - 2;
end;

// ComboBox.ItemIndex -> Data Value

function ReturnABC(pfint: Integer): string;
var
  AshInt: Integer;
  AshStr: string;
begin
  AshStr := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  AshInt := pfint + 1;
  Result := Copy(AshStr, AshInt, 1);
end;

procedure Error(const Msg: string);
begin
  raise Exception.Create(Msg);
end;

function ExtractFileNameNoExt(const fileName: string): string;
var
  I, j: Integer;
begin
  Result := '';
  I := LastDelimiter('.', fileName);
  j := LastDelimiter('\:', fileName);
  if I < j then
    Exit
  else if I > 0 then
    Result := Copy(fileName, j + 1, I - j - 1)
  else
    Result := Copy(fileName, j + 1, MaxInt);
end;

procedure StrToSaveToFile(var s: string; const fileName: string);
begin
  with TFileStream.Create(fileName, fmCreate) do
  begin
    Write(Pointer(s)^, Length(s));
    Free;
  end;
end;

procedure StrToSaveToFile(s1: PChar; len: Integer; const fileName: string);
begin
  with TFileStream.Create(fileName, fmCreate) do
  begin
    Write(s1^, len);
    Free;
  end;
end;

// Byte�� ������ �����͸� HexaDecimal ���ڿ��� ��ȯ

function ValueToHex(const s: string): string;
var
  I: Integer;
begin
  SetLength(Result, Length(s) * 2);
  for I := 0 to Length(s) - 1 do
  begin
    Result[(I * 2) + 1] := HexaChar[Integer(s[I + 1]) shr 4];
    Result[(I * 2) + 2] := HexaChar[Integer(s[I + 1]) and $0F];
  end;
end;

// HexaDecimal�� ������ ���ڿ��� Byte �����ͷ� ��ȯ

function HexToValue(const s: string): string;
var
  I: Integer;
begin
  SetLength(Result, Length(s) div 2);
  for I := 0 to (Length(s) div 2) - 1 do
  begin
    Result[I + 1] := Char(StrToInt('$' + Copy(s, (I * 2) + 1, 2)));
  end;
end;

// ��ȣ�ɱ�

function Encrypt(const s: string; Key: Word): string;
var
  I: Byte;
  FirstResult: string;
begin
  SetLength(FirstResult, Length(s)); // ���ڿ��� ũ�⸦ ����
  for I := 1 to Length(s) do
  begin
    FirstResult[I] := Char(Byte(s[I]) xor (Key shr 8));
    Key := (Byte(FirstResult[I]) + Key) * pjwC1 + pjwC2;
  end;
  Result := ValueToHex(FirstResult);
end;

// ��ȣǮ��

function Decrypt(const s: string; Key: Word): string;
var
  I: Byte;
  FirstResult: string;
begin
  FirstResult := HexToValue(s);
  SetLength(Result, Length(FirstResult));
  for I := 1 to Length(FirstResult) do
  begin
    Result[I] := Char(Byte(FirstResult[I]) xor (Key shr 8));
    Key := (Byte(FirstResult[I]) + Key) * pjwC1 + pjwC2;
  end;
end;

procedure syslog(strlog: string);
var
  fPath, strPath, fExeFileName, strExeFileName, sLogName: string;
  tLog: TEXTFILE;
begin
  if mpst_code = 'H11074064' then
  begin
    // �ش� ���� ���� ��� ����
    fPath := ExtractFilePath(Application.ExeName);
    fExeFileName := ExtractFileName(Application.ExeName);
    strExeFileName := Copy(fExeFileName, 1, Pos('.exe', fExeFileName) - 1);

    strPath := 'D:\������Ʈ_�������׷��̵�\logs\' + FormatDateTime('yyyy', Now) + '��' + FormatDateTime('mm', Now) + '��' +
      FormatDateTime('dd', Now) + '��' + '\' + strExeFileName;
    if not DirectoryExists(strPath) then
    begin
      ForceDirectories(strPath);
    end;

    // �α����� ����
    sLogName := strPath + '\' + strExeFileName + '_' + FormatDateTime('yyyy-mm-dd', Now) + '.log';

    try
      AssignFile(tLog, sLogName);

      if FileExists(sLogName) then
      begin
        Append(tLog);
        WriteLn(tLog, Format('[%s] %s', [FormatDateTime('YYYY-MM-DD hh:mm:ss', Now), strlog]));
        closeFile(tLog);
      end
      else
      begin
        Rewrite(tLog);
        WriteLn(tLog, Format('[%s] %s', [FormatDateTime('YYYY-MM-DD hh:mm:ss', Now), strlog]));
        closeFile(tLog);
      end;
    except
    end;
  end;
end;

// 20110530 ��ΰ� �߰�
// FUND, PAY, UNION_DUES���̺��� PATH�� �ش� ���ڿ��� �����ϱ�

function PathToDetail(path: string): string;
begin
  if path = '' then
  begin
    Result := '';
    Exit;
  end;

  {
    case strToInt(path) of
    21 : Result := '(��)';//���ݰ���
    22 : Result := '(ī)';//ī�����
    23 : Result := '(��)';//������
    24 : Result := '(C )';//CMS
    28 : Result := '(��)';//��������
    29 : Result := '(��)';//���⿡����
    30 : Result := '(��)';//��ü
    31 : Result := '(��)';//������ü
    32 : Result := '(��)';//�̵���ü
    33 : Result := '(��)';//���ڴ�ü
    34 : Result := '(��)';//���պ��ü
    35 : Result := '(ȸ)';//ȸ���ü
    36 : Result := '(��)';//��ݴ�ü
    37 : Result := '(��)';//����Ʈ
    38 : Result := '(��)';//�ܻ��ݴ�ü
    39 : Result := '(Ÿ)';//��Ÿ��ü
    40 : Result := '(e )';//e����(����Ʈ)
    41 : Result := '(��)';//������
    42 : Result := '(��)';//��ս�
    45 : Result := '(e1)';//e��������(10��)
    46 : Result := '(e2)';//e��������(5��)
    50 : Result := '(��)';//�����̿����ڴ�ü
    51 : Result := '(��)';//����Ʈ������
    else
    Result := '(  )';
    end;
  }
  case StrToInt(path) of
    21:
      Result := '���ݰ���'; // ���ݰ���
    22:
      Result := 'ī�����'; // ī�����
    23:
      Result := '������'; // ������
    24:
      Result := 'CMS '; // CMS
    28:
      Result := '��������'; // ��������
    29:
      Result := '���⿡����'; // ���⿡����
    30:
      Result := '��ü'; // ��ü
    31:
      Result := '������ü'; // ������ü
    32:
      Result := '�̵���ü'; // �̵���ü
    33:
      Result := '���ڴ�ü'; // ���ڴ�ü
    34:
      Result := '���պ��ü'; // ���պ��ü
    35:
      Result := 'ȸ���ü'; // ȸ���ü
    36:
      Result := '��ݴ�ü'; // ��ݴ�ü
    37:
      Result := '����Ʈ'; // ����Ʈ
    38:
      Result := '�ܻ��ݴ�ü'; // �ܻ��ݴ�ü
    39:
      Result := '��Ÿ��ü'; // ��Ÿ��ü
    40:
      Result := 'e��������Ʈ '; // e��������Ʈ
    41:
      Result := '������'; // ������
    42:
      Result := '��ս�'; // ��ս�
    45:
      Result := 'e��������10��'; // e��������10��
    46:
      Result := 'e��������5��'; // e��������5��
    50:
      Result := '�����̿����ڴ�ü'; // �����̿����ڴ�ü
    51:
      Result := '����Ʈ������'; // ����Ʈ������
  else
    Result := '';
  end;

end;


function johapreturn(my_db: TZConnection; my_dataset: TZQuery; my_virtual: TVirtualTable; jcode: string) : TArray<string>;
var
  AshSQL, Ashchk: string;
  AshInt: Integer;
begin
  SetLength(Result, 4);
  Result[0] := '0'; // ��ȸ�� ����
  Result[1] := ''; // �Ҽ� o_code ����
  Result[2] := ''; // �Ҽ� c_code ����
  Result[3] := 'N'; // ���չ��ο���..

  case Length(jcode) of
    4:
      begin
        AshSQL := 'SELECT a.o_code, IFNULL((SELECT b.c_code FROM center_branch_matching AS b where b.j_code="' + jcode +
          '"), "") AS c_code,' +
          ' (SELECT CASE b.icoop_ab WHEN "A" THEN "N" WHEN "B" THEN "Y" ELSE "N" END AS icoop_ab FROM org AS b WHERE a.j_code=b.o_code) AS icoop_ab'
          + ' FROM johap AS a where a.j_code="' + jcode + '"';
        Ashchk := MySQL_Assign(my_db, my_dataset, AshSQL, my_virtual);

        try
          AshInt := StrToInt(Ashchk);
          if AshInt = 1 then
          begin
            Result[0] := IntToStr(my_virtual.RecordCount);
            Result[1] := Trim(my_virtual.FieldByName('o_code').AsString);
            Result[2] := Trim(my_virtual.FieldByName('c_code').AsString);
            Result[3] := Trim(my_virtual.FieldByName('icoop_ab').AsString);
          end
          else if (AshInt <> 1) and (AshInt <> 0) then
          begin
            Result[0] := '�ټ���ȸ!';
            Result[1] := ''; // �Ҽ� o_code ����
            Result[2] := ''; // �Ҽ� c_code ����
            Result[3] := 'N'; // ���չ��ο���..
          end;
        except
          Result[0] := '��ȸ����!';
          Result[1] := ''; // �Ҽ� o_code ����
          Result[2] := ''; // �Ҽ� c_code ����
          Result[3] := 'N'; // ���չ��ο���..
        end;
      end;
  else
    begin
      Result[0] := '�ڸ�����!';
      Result[1] := ''; // �Ҽ� o_code ����
      Result[2] := ''; // �Ҽ� c_code ����
      Result[3] := 'N'; // ���չ��ο���..
    end;
  end;
end;

function SendSMSToManager(my_db: TZConnection; my_dataset: TZQuery; my_virtual: TVirtualTable;
 send_time: string; mCode: string; mTel: string; sTel: string; msg: string; smCode: string; oCode: string; jCode: string; smsGubun: string) : string;
var
  AshSQL, Ashchk : string;
  Ashint : Integer;
begin
  AshSQL := 'CALL sp_sms_send("'+send_time+'","'+mCode+'","'+mTel+'", "'+sTel+'", "'+msg+'", "342488533", "'+oCode+'", "'+jCode+'", "Y")';

  Ashchk := MySQL_Assign(my_db, my_dataset, AshSQL, my_virtual);

  Result := my_virtual.FieldByName('rslt').AsString;


end;

end.
