unit excel_monacnt;

interface


uses
   SysUtils, ExtCtrls,ComObj,QDialogs;

var
  ltExcelApp: Variant;
  ltExcelBook: Variant;
  ltExcelSheet, ltExcelSheetSource: Variant;
  ColumnRange: Variant;
  Range : Variant;
 

const
        xlLeft = -4131;    xlRight = -4152;    xlTop = -4160;        xlBottom = -4107;
        xlThin = 2;        xlNone  = 0;        xlCenter = -4108;     xlDash = $FFFFEFED;
        xlDiagonalDown = 5;	xlDiagonalUp = 6;	xlEdgeLeft = 7;	xlEdgeTop = 8;
        xlEdgeBottom = 9;	xlEdgeRight = 10;	xlInsideVertical = 11;	xlInsideHorizontal = 12;
        xlContinuous=1;        xlMedium = -4138;	xlAutomatic = -4105;	xlUnderlineStyleNone = -4142;
        xlContext = -5002;	

//procedure Function_Print_Send;
procedure Function_Excel_Format;
//procedure Function_Print_Recv;
//procedure Function_Print_Copy;
//procedure Function_Print(mDate:TDateTime;mRegid:String;mReg_name: String;mM_name:String;mAddr:String;mBusiness:String;mItem:String;mApplytax:Double;mTax:Double;mNotax:Double);

implementation

uses Unit1;

procedure Function_Excel_Format;    //수지 양식
begin
Showmessage('1234567');
//Showmessage('AshLine ::'+ inttostr(AshLine));
  ltExcelSheet.Range['D5:G5'].Merge;
  ltExcelSheet.Range['J5:L5'].Merge;
{    ltExcelSheet.Range['A5:L'+inttostr(AshLine)+''].Borders[xlEdgeTop].Weight := xlThin;
    ltExcelSheet.Range['A5:L'+inttostr(AshLine)+''].Borders[xlEdgeBottom].Weight := xlThin;
    ltExcelSheet.Range['A5:L'+inttostr(AshLine)+''].Borders[xlEdgeRight].Weight := xlThin;
    ltExcelSheet.Range['A5:L'+inttostr(AshLine)+''].Borders[xlInsideVertical].Weight := xlThin;
    ltExcelSheet.Range['A5:L'+inttostr(AshLine)+''].Borders[xlInsideHorizontal].Weight := xlThin;
}    
end;
{
procedure Function_Print(mDate:TDateTime;mRegid:String;mReg_name: String;mM_name:String;mAddr:String;mBusiness:String;mItem:String;mApplytax:Double;mTax:Double;mNotax:Double);
var
   k : Integer;
   mCurDateStr : String;
begin

   mCurDateStr := FormatDateTime('yyyy-mm-dd',mDate);

   ltExcelSheet.Cells[6,21]  := mReg_name;   //상호
   ltExcelSheet.Cells[30,21] := mReg_name;
   ltExcelSheet.Cells[6,28]  := mM_name;     // 성명
   ltExcelSheet.Cells[30,28] := mM_name;
   ltExcelSheet.Cells[8,21]  := mAddr;       //주소
   ltExcelSheet.Cells[32,21] := mAddr;
   ltExcelSheet.Cells[10,21] := mBusiness;   //업종
   ltExcelSheet.Cells[34,21] := mBusiness;
   ltExcelSheet.Cells[10,28] := mItem;       //종목
   ltExcelSheet.Cells[34,28] := mItem;

   for k:=1 to Length(mRegid) do
   begin
      ltExcelSheet.Cells[4,k+20]  := Copy(mRegid,k,1);
   end;
   ltExcelSheet.Cells[14,1]  := Copy(mCurDateStr,1,4);
   ltExcelSheet.Cells[14,3]  := Copy(mCurDateStr,6,2);
   ltExcelSheet.Cells[14,4]  := Copy(mCurDateStr,9,2);
   ltExcelSheet.Cells[16,1]  := Copy(mCurDateStr,6,2);
   ltExcelSheet.Cells[16,2]  := Copy(mCurDateStr,9,2);


   for k:=1 to Length(mRegid) do
   begin
      ltExcelSheet.Cells[28,k+20]  := Copy(mRegid,k,1);
   end;

   ltExcelSheet.Cells[38,1]  := Copy(mCurDateStr,1,4);
   ltExcelSheet.Cells[38,3]  := Copy(mCurDateStr,6,2);
   ltExcelSheet.Cells[38,4]  := Copy(mCurDateStr,9,2);
   ltExcelSheet.Cells[40,1]  := Copy(mCurDateStr,6,2);
   ltExcelSheet.Cells[40,2]  := Copy(mCurDateStr,9,2);


   ltExcelSheet.Cells[52,21] := mReg_name;  //상호
   ltExcelSheet.Cells[76,21] := mReg_name;
   ltExcelSheet.Cells[52,28] := mM_name;    // 성명
   ltExcelSheet.Cells[76,28] := mM_name;
   ltExcelSheet.Cells[54,21] := mAddr;      //주소
   ltExcelSheet.Cells[78,21] := mAddr;
   ltExcelSheet.Cells[56,21] := mBusiness;  //업종
   ltExcelSheet.Cells[80,21] := mBusiness;
   ltExcelSheet.Cells[56,28] := mItem;      //업종
   ltExcelSheet.Cells[80,28] := mItem;

   for k:=1 to Length(mRegid) do
   begin
      ltExcelSheet.Cells[50,k+20]  := Copy(mRegid,k,1);
   end;
   ltExcelSheet.Cells[60,1]  := Copy(mCurDateStr,1,4);
   ltExcelSheet.Cells[60,3]  := Copy(mCurDateStr,6,2);
   ltExcelSheet.Cells[60,4]  := Copy(mCurDateStr,9,2);
   ltExcelSheet.Cells[62,1]  := Copy(mCurDateStr,6,2);
   ltExcelSheet.Cells[62,2]  := Copy(mCurDateStr,9,2);


   for k:=1 to Length(mRegid) do
   begin
      ltExcelSheet.Cells[74,k+20]  := Copy(mRegid,k,1);
   end;

   ltExcelSheet.Cells[84,1]  := Copy(mCurDateStr,1,4);
   ltExcelSheet.Cells[84,3]  := Copy(mCurDateStr,6,2);
   ltExcelSheet.Cells[84,4]  := Copy(mCurDateStr,9,2);
   ltExcelSheet.Cells[86,1]  := Copy(mCurDateStr,6,2);                                                            
   ltExcelSheet.Cells[86,2]  := Copy(mCurDateStr,9,2);

   // 세금 계산서(공급받는자)
   ltExcelSheet.Cells[16,3]  := '가공품외 과세분';
   ltExcelSheet.Cells[16,20] := FormatFloat('0',mApplytax);
   ltExcelSheet.Cells[16,26] := FormatFloat('0',mTax);
   ltExcelSheet.Cells[21,1]  := FloatToStr(mApplytax + mTax);

   ltExcelSheet.Cells[14,5]  := IntToStr(11 - Length(FormatFloat('0',mApplytax)));

   for k:=1 to Length(FormatFloat('0',mApplytax)) do
   begin
      ltExcelSheet.Cells[14,k+6+11-Length(FormatFloat('0',mApplytax))] := Copy(FormatFloat('0',mApplytax),k,1);
   end;

   for k:=1 to Length(FormatFloat('0',mTax)) do
   begin
      ltExcelSheet.Cells[14,k+17+10-Length(FormatFloat('0',mTax))] := Copy(FormatFloat('0',mTax),k,1);
   end;

   // 세금 계산서(공급자)
   ltExcelSheet.Cells[40,3]  := '가공품외 과세분';
   ltExcelSheet.Cells[40,20] := FormatFloat('0',mApplytax);
   ltExcelSheet.Cells[40,26] := FormatFloat('0',mTax);
   ltExcelSheet.Cells[45,1]  := FloatToStr(mapplytax + mtax);

   ltExcelSheet.Cells[38,5]  := IntToStr(11 - Length(FormatFloat('0',mApplytax)));
   for k:=1 to Length(FormatFloat('0',mApplytax)) do
   begin
      ltExcelSheet.Cells[38,k+6+11-Length(FormatFloat('0',mApplytax))] := Copy(FormatFloat('0',mApplytax),k,1);
   end;

   for k:=1 to Length(FormatFloat('0',mTax)) do
   begin
      ltExcelSheet.Cells[38,k+17+10-Length(FormatFloat('0',mTax))] := Copy(FormatFloat('0',mTax),k,1);
   end;

   // 계산서(공급받는자)
   ltExcelSheet.Cells[62,3]  :=  '야채외 면세분';
   ltExcelSheet.Cells[62,20] := FormatFloat('0',mNotax);
   ltExcelSheet.Cells[67,1]  := FormatFloat('0',mNotax);

   ltExcelSheet.Cells[60,5]  := IntToStr(11 - Length(FormatFloat('0',mNotax)));
   for k:=1 to Length(FormatFloat('0',mNotax)) do
   begin
      ltExcelSheet.Cells[60,k+6+11-Length(FormatFloat('0',mNotax))] := Copy(FormatFloat('0',mNotax),k,1);
   end;

   // 계산서(공급자)
   ltExcelSheet.Cells[86,3]  :=  '야채외 면세분';
   ltExcelSheet.Cells[86,20] := FormatFloat('0',mNotax);
   ltExcelSheet.Cells[91,1]  := FormatFloat('0',mNotax);

   ltExcelSheet.Cells[84,5]  := IntToStr(11 - Length(FormatFloat('0',mNotax)));
   for k:=1 to Length(FormatFloat('0',mNotax)) do
   begin
      ltExcelSheet.Cells[84,k+6+11-Length(FormatFloat('0',mNotax))] := Copy(FormatFloat('0',mNotax),k,1);
   end;
end;

procedure Function_Print_Send;    // 공급자 양식 만들기
begin
    ltExcelSheet.Range['A25:AF46'].Font.ColorIndex := 3; //폰트
    ltExcelSheet.Cells[26,17] := '공  급  자';

    ltExcelSheet.Range['A26:AF45'].Borders[xlEdgeTop].Weight := xlMedium;
    ltExcelSheet.Range['A26:AF45'].Borders[xlEdgeTop].ColorIndex := 3;

    ltExcelSheet.Range['A26:AF45'].Borders[xlEdgeBottom].Weight := xlMedium;
    ltExcelSheet.Range['A26:AF45'].Borders[xlEdgeBottom].ColorIndex := 3;

    ltExcelSheet.Range['A26:AF45'].Borders[xlEdgeLeft].Weight := xlMedium;
    ltExcelSheet.Range['A26:AF45'].Borders[xlEdgeLeft].ColorIndex := 3;
    ltExcelSheet.Range['A26:AF45'].Borders[xlEdgeRight].Weight := xlMedium;
    ltExcelSheet.Range['A26:AF45'].Borders[xlEdgeRight].ColorIndex := 3;

    ltExcelSheet.Range['A26:AF45'].Borders[xlInsideVertical].Weight := xlThin;
    ltExcelSheet.Range['A26:AF45'].Borders[xlInsideVertical].ColorIndex := 3;

    ltExcelSheet.Range['A26:AF45'].Borders[xlInsideHorizontal].Weight := xlThin;
    ltExcelSheet.Range['A26:AF45'].Borders[xlInsideHorizontal].ColorIndex := 3;

    ltExcelSheet.Range['P26:P27'].Borders[xlEdgeTop].Weight := xlMedium;
    ltExcelSheet.Range['P26:P27'].Borders[xlEdgeTop].ColorIndex := 3;

    ltExcelSheet.Range['P26:P27'].Borders[xlEdgeBottom].Weight := xlThin;
    ltExcelSheet.Range['P26:P27'].Borders[xlEdgeBottom].ColorIndex := 3;

    ltExcelSheet.Range['Q26:U26'].Borders[xlEdgeTop].Weight := xlMedium;
    ltExcelSheet.Range['Q26:U26'].Borders[xlEdgeTop].ColorIndex := 3;

    ltExcelSheet.Range['Q26:U26'].Borders[xlInsideVertical].ColorIndex := 3;

    ltExcelSheet.Range['V26:V27'].Borders[xlEdgeTop].Weight := xlMedium;
    ltExcelSheet.Range['V26:V27'].Borders[xlEdgeTop].ColorIndex := 3;

    ltExcelSheet.Range['V26:V27'].Borders[xlEdgeBottom].ColorIndex := 3;

    ltExcelSheet.Range['V26:V27'].Borders[xlEdgeRight].ColorIndex := 3;

    ltExcelSheet.Range['V26:V27'].Borders[xlInsideHorizontal].ColorIndex := 3;

    ltExcelSheet.Range['P30:P31'].Borders[xlEdgeTop].ColorIndex := 3;
    ltExcelSheet.Range['P30:P31'].Borders[xlEdgeBottom].ColorIndex := 3;
    ltExcelSheet.Range['P30:P31'].Borders[xlEdgeRight].ColorIndex := 3;
    ltExcelSheet.Range['P30:P31'].Borders[xlInsideHorizontal].ColorIndex := 3;

    ltExcelSheet.Range['AF30:AF31'].Borders[xlEdgeTop].ColorIndex := 3;
    ltExcelSheet.Range['AF30:AF31'].Borders[xlEdgeBottom].ColorIndex := 3;
    ltExcelSheet.Range['AF30:AF31'].Borders[xlEdgeRight].Weight := xlMedium;
    ltExcelSheet.Range['AF30:AF31'].Borders[xlEdgeRight].ColorIndex := 3;
    ltExcelSheet.Range['AF30:AF31'].Borders[xlInsideHorizontal].ColorIndex := 3;

    ltExcelSheet.Range['E28:P31'].Borders[xlEdgeTop].Weight := xlMedium;
    ltExcelSheet.Range['E28:P31'].Borders[xlEdgeTop].ColorIndex := 3;
    ltExcelSheet.Range['E28:P31'].Borders[xlEdgeBottom].Weight := xlMedium;
    ltExcelSheet.Range['E28:P31'].Borders[xlEdgeBottom].ColorIndex := 3;
    ltExcelSheet.Range['E28:P31'].Borders[xlEdgeLeft].Weight := xlMedium;
    ltExcelSheet.Range['E28:P31'].Borders[xlEdgeLeft].ColorIndex := 3;
    ltExcelSheet.Range['E28:P31'].Borders[xlEdgeRight].Weight := xlMedium;
    ltExcelSheet.Range['E28:P31'].Borders[xlEdgeRight].ColorIndex := 3;
    ltExcelSheet.Range['E28:P31'].Borders[xlInsideHorizontal].ColorIndex := 3;

    ltExcelSheet.Range['U28:AF29'].Borders[xlEdgeTop].Weight := xlMedium;
    ltExcelSheet.Range['U28:AF29'].Borders[xlEdgeTop].ColorIndex := 3;
    ltExcelSheet.Range['U28:AF29'].Borders[xlEdgeBottom].Weight := xlMedium;
    ltExcelSheet.Range['U28:AF29'].Borders[xlEdgeBottom].ColorIndex := 3;
    ltExcelSheet.Range['U28:AF29'].Borders[xlEdgeLeft].Weight := xlMedium;
    ltExcelSheet.Range['U28:AF29'].Borders[xlEdgeLeft].ColorIndex := 3;
    ltExcelSheet.Range['U28:AF29'].Borders[xlEdgeRight].Weight := xlMedium;
    ltExcelSheet.Range['U28:AF29'].Borders[xlEdgeRight].ColorIndex := 3;
    ltExcelSheet.Range['U28:AF29'].Borders[xlInsideHorizontal].Weight := xlThin;
    ltExcelSheet.Range['U28:AF29'].Borders[xlInsideVertical].ColorIndex := 3;

    ltExcelSheet.Range['A36:AF38'].Borders[xlEdgeTop].Weight := xlMedium;
    ltExcelSheet.Range['A36:AF38'].Borders[xlEdgeTop].ColorIndex := 3;
    ltExcelSheet.Range['A36:AF38'].Borders[xlEdgeBottom].Weight := xlMedium;
    ltExcelSheet.Range['A36:AF38'].Borders[xlEdgeBottom].ColorIndex := 3;
    ltExcelSheet.Range['A36:AF38'].Borders[xlEdgeLeft].Weight := xlMedium;
    ltExcelSheet.Range['A36:AF38'].Borders[xlEdgeLeft].ColorIndex := 3;
    ltExcelSheet.Range['A36:AF38'].Borders[xlEdgeRight].Weight := xlMedium;
    ltExcelSheet.Range['A36:AF38'].Borders[xlEdgeRight].ColorIndex := 3;
    ltExcelSheet.Range['A36:AF38'].Borders[xlInsideHorizontal].ColorIndex := 3;
    ltExcelSheet.Range['A36:AF38'].Borders[xlInsideVertical].ColorIndex := 3;

    ltExcelSheet.Range['AD44:AE45'].Borders[xlEdgeTop].ColorIndex := 3;
    ltExcelSheet.Range['AD44:AE45'].Borders[xlInsideHorizontal].ColorIndex := 3;

   // 수기입력 부분(검은색)
   ltExcelSheet.Range['E28:P29,U28:AF29'].Font.ColorIndex := 1;
   ltExcelSheet.Range['E30:J31,L30:O31,E32:P33,E34:J35,L34:P35,U30:Z31,AB30:AE31,U32:AF33,U34:Z35,AB34:AF35'].Font.ColorIndex := 1;
   ltExcelSheet.Range['A38:F38'].Font.ColorIndex := 1;
   ltExcelSheet.Range['G38:AA38,A45:Y45'].Font.ColorIndex := 1;
   ltExcelSheet.Range['A40:N43'].Font.ColorIndex := 1;

   ltExcelSheet.Range['O40:AD43'].Font.ColorIndex := 1;

   ltExcelSheet.Range['AE40:AF43'].Font.ColorIndex := 1;

end;

procedure Function_Print_Recv;     // 공급받는자 양식
var
   i : Integer;
begin
   ltExcelSheet.Range['A1:AF22'].Font.ColorIndex := 5; //폰트
   ltExcelSheet.Range['A1:AF22'].Font.Name := '굴림';

   //높이
   ltExcelSheet.Range['A1:AF1'].RowHeight := 1*13.5;
   ltExcelSheet.Range['A2:AF2'].RowHeight := 20;
   ltExcelSheet.Range['A3:AF3'].RowHeight := 20;
   ltExcelSheet.Range['A4:AF13'].RowHeight := 1*13.5;
   ltExcelSheet.Range['A14:AF14'].RowHeight := 20;
   ltExcelSheet.Range['A15:AF15'].RowHeight := 1*13.5;
   ltExcelSheet.Range['A16:AF19'].RowHeight := 20;
   ltExcelSheet.Range['A20:AF20'].RowHeight := 1*13.5;
   ltExcelSheet.Range['A21:AF21'].RowHeight := 20;
   ltExcelSheet.Range['A22:AF23'].RowHeight := 1*13.5;

   // 셀 병합
   ltExcelSheet.Range['A1:AF1'].Merge;
   ltExcelSheet.Range['A1:AF1'].Font.Size := 8;
   ltExcelSheet.Cells[1,1] := '[별지 제11호 서식]';

   ltExcelSheet.Range['A2:O3'].Merge;
   ltExcelSheet.Range['A2:O3'].Font.Size := 20;
   ltExcelSheet.Range['A2:O3'].Font.Bold := True;
   ltExcelSheet.Range['A2:O3'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Cells[2,1] := '세 금 계 산 서';

   ltExcelSheet.Range['P2:P3'].Merge;
   ltExcelSheet.Cells[2,16] := '(';

   ltExcelSheet.Range['Q2:U2'].Merge;
   ltExcelSheet.Range['Q3:U3'].Merge;
   ltExcelSheet.Range['Q2:U3'].Font.Size := 10;
   ltExcelSheet.Range['Q2:U3'].Font.Bold := True;
   ltExcelSheet.Range['Q2:U3'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Cells[2,17] := '공 급 받 는 자';
   ltExcelSheet.Cells[3,17] := '보  관  용';


   ltExcelSheet.Range['V2:V3'].Merge;
   ltExcelSheet.Cells[2,22] := ')';

   ltExcelSheet.Range['W2:Z2'].Merge;
   ltExcelSheet.Range['W2:Z3'].Font.Size := 9;
   ltExcelSheet.Range['W2:Z3'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Cells[2,23] := '책   번   호';

   ltExcelSheet.Range['W3:Z3'].Merge;
   ltExcelSheet.Cells[3,23] := '일 련 번 호';

   ltExcelSheet.Range['AA2:AC2'].Merge;
   ltExcelSheet.Range['AA2:AC2'].Font.Size := 9;
   ltExcelSheet.Range['AA2:AC2'].HorizontalAlignment := xlRight;
   ltExcelSheet.Cells[2,27] := '권';

   ltExcelSheet.Range['AD2:AF2'].Merge;
   ltExcelSheet.Range['AD2:AF2'].Font.Size := 9;
   ltExcelSheet.Range['AD2:AF2'].HorizontalAlignment := xlRight;
   ltExcelSheet.Cells[2,30] := '호';

   ltExcelSheet.Range['A4:A11'].Merge;
   ltExcelSheet.Range['A4:A11'].Font.Size := 11;
   ltExcelSheet.Range['A4:A11'].HorizontalAlignment := xlLeft;
   ltExcelSheet.Range['A4:A11'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['A4:A11'].WrapText := True;
   ltExcelSheet.Range['A4:A11'].Orientation := 0;
   ltExcelSheet.Range['A4:A11'].AddIndent := False;
   ltExcelSheet.Range['A4:A11'].IndentLevel := 0;
   ltExcelSheet.Range['A4:A11'].ShrinkToFit := False;
   ltExcelSheet.Cells[4,1] := '공  급  자';

   ltExcelSheet.Range['B4:D5'].Merge;
   ltExcelSheet.Range['B4:D5'].Font.Size := 9;
   ltExcelSheet.Range['B4:D5'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Cells[4,2] := '등록번호';

   ltExcelSheet.Range['E4:E5'].Merge;
   ltExcelSheet.Range['F4:F5'].Merge;
   ltExcelSheet.Range['G4:G5'].Merge;
   ltExcelSheet.Range['H4:H5'].Merge;
   ltExcelSheet.Range['I4:I5'].Merge;
   ltExcelSheet.Range['J4:J5'].Merge;
   ltExcelSheet.Range['K4:K5'].Merge;
   ltExcelSheet.Range['L4:L5'].Merge;
   ltExcelSheet.Range['M4:M5'].Merge;
   ltExcelSheet.Range['N4:N5'].Merge;
   ltExcelSheet.Range['O4:O5'].Merge;
   ltExcelSheet.Range['P4:P5'].Merge;

   ltExcelSheet.Range['B6:D6'].Merge;
   ltExcelSheet.Range['B6:D6'].Font.Size := 9;
   ltExcelSheet.Range['B6:D6'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Cells[6,2] := '상   호';

   ltExcelSheet.Range['B7:D7'].Merge;
   ltExcelSheet.Range['B7:D7'].Font.Size := 9;
   ltExcelSheet.Range['B7:D7'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Cells[7,2] := '(법인명)';

   ltExcelSheet.Range['B8:D8'].Merge;
   ltExcelSheet.Range['B8:D8'].Font.Size := 9;
   ltExcelSheet.Range['B8:D8'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Cells[8,2] := '사 업 장';

   ltExcelSheet.Range['B9:D9'].Merge;
   ltExcelSheet.Range['B9:D9'].Font.Size := 9;
   ltExcelSheet.Range['B9:D9'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Cells[9,2] := '주   소';

   ltExcelSheet.Range['B10:D11'].Merge;
   ltExcelSheet.Range['B10:D11'].Font.Size := 9;
   ltExcelSheet.Range['B10:D11'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Cells[10,2] := '업   태';

   ltExcelSheet.Range['E6:J7'].Merge;

   ltExcelSheet.Range['K6:K7'].Merge;
   ltExcelSheet.Range['K6:K7'].Font.Size := 9;
   ltExcelSheet.Range['K6:K7'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Range['K6:K7'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['K6:K7'].WrapText := True;
   ltExcelSheet.Range['K6:K7'].Orientation := 0;
   ltExcelSheet.Range['K6:K7'].AddIndent := False;
   ltExcelSheet.Range['K6:K7'].IndentLevel := 0;
   ltExcelSheet.Range['K6:K7'].ShrinkToFit := False;
   ltExcelSheet.Cells[6,11] := '성명';

   ltExcelSheet.Range['L6:O7'].Merge;

   ltExcelSheet.Range['P6:P7'].Merge;
   ltExcelSheet.Range['P6:P7'].Font.Size := 8;
   ltExcelSheet.Range['P6:P7'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Cells[6,16] := '인';

   ltExcelSheet.Range['E8:P9'].Merge;
   ltExcelSheet.Range['E10:J11'].Merge;

   ltExcelSheet.Range['K10:K11'].Merge;
   ltExcelSheet.Range['K10:K11'].Font.Size := 9;
   ltExcelSheet.Range['K10:K11'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Range['K10:K11'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['K10:K11'].WrapText := True;
   ltExcelSheet.Range['K10:K11'].Orientation := 0;
   ltExcelSheet.Range['K10:K11'].AddIndent := False;
   ltExcelSheet.Range['K10:K11'].IndentLevel := 0;
   ltExcelSheet.Range['K10:K11'].ShrinkToFit := False;
   ltExcelSheet.Cells[10,11] := '종목';

   ltExcelSheet.Range['L10:P11'].Merge;

   ltExcelSheet.Range['Q4:Q11'].Merge;
   ltExcelSheet.Range['Q4:Q11'].Font.Size := 11;
   ltExcelSheet.Range['Q4:Q11'].HorizontalAlignment := xlLeft;
   ltExcelSheet.Range['Q4:Q11'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['Q4:Q11'].WrapText := True;
   ltExcelSheet.Range['Q4:Q11'].Orientation := 0;
   ltExcelSheet.Range['Q4:Q11'].AddIndent := False;
   ltExcelSheet.Range['Q4:Q11'].IndentLevel := 0;
   ltExcelSheet.Range['Q4:Q11'].ShrinkToFit := False;
   ltExcelSheet.Range['Q4:Q11'].MergeCells := True;
   ltExcelSheet.Cells[4,17] := '공 급 받 는 자';

   ltExcelSheet.Range['R4:T5'].Merge;
   ltExcelSheet.Range['R4:T5'].Font.Size := 9;
   ltExcelSheet.Range['R4:T5'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Cells[4,18] := '등록번호';

   ltExcelSheet.Range['R6:T6'].Merge;
   ltExcelSheet.Range['R6:T6'].Font.Size := 9;
   ltExcelSheet.Range['R6:T6'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Cells[6,18] := '상   호';

   ltExcelSheet.Range['R7:T7'].Merge;
   ltExcelSheet.Range['R7:T7'].Font.Size := 9;
   ltExcelSheet.Range['R7:T7'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Cells[7,18] := '(법인명)';

   ltExcelSheet.Range['R8:T8'].Merge;
   ltExcelSheet.Range['R8:T8'].Font.Size := 9;
   ltExcelSheet.Range['R8:T8'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Cells[8,18] := '사 업 장';

   ltExcelSheet.Range['R9:T9'].Merge;
   ltExcelSheet.Range['R9:T9'].Font.Size := 9;
   ltExcelSheet.Range['R9:T9'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Cells[9,18] := '주   소';

   ltExcelSheet.Range['R10:T11'].Merge;
   ltExcelSheet.Range['R10:T11'].Font.Size := 9;
   ltExcelSheet.Range['R10:T11'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Cells[10,18] := '업   태';

   ltExcelSheet.Range['U4:U5'].Merge;
   ltExcelSheet.Range['V4:V5'].Merge;
   ltExcelSheet.Range['W4:W5'].Merge;
   ltExcelSheet.Range['X4:X5'].Merge;
   ltExcelSheet.Range['Y4:Y5'].Merge;
   ltExcelSheet.Range['Z4:Z5'].Merge;
   ltExcelSheet.Range['AA4:AA5'].Merge;
   ltExcelSheet.Range['AB4:AB5'].Merge;
   ltExcelSheet.Range['AC4:AC5'].Merge;
   ltExcelSheet.Range['AD4:AD5'].Merge;
   ltExcelSheet.Range['AE4:AE5'].Merge;
   ltExcelSheet.Range['AF4:AF5'].Merge;

   ltExcelSheet.Range['U6:Z7'].Merge;

   ltExcelSheet.Range['AA6:AA7'].Merge;
   ltExcelSheet.Range['AA6:AA7'].Font.Size := 9;
   ltExcelSheet.Range['AA6:AA7'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Range['AA6:AA7'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['AA6:AA7'].WrapText := True;
   ltExcelSheet.Range['AA6:AA7'].Orientation := 0;
   ltExcelSheet.Range['AA6:AA7'].AddIndent := False;
   ltExcelSheet.Range['AA6:AA7'].IndentLevel := 0;
   ltExcelSheet.Range['AA6:AA7'].ShrinkToFit := False;
   ltExcelSheet.Cells[6,27] := '성명';

   ltExcelSheet.Range['AB6:AE7'].Merge;

   ltExcelSheet.Range['AF6:AF7'].Merge;
   ltExcelSheet.Range['AF6:AF7'].Font.Size := 8;
   ltExcelSheet.Range['AF6:AF7'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Cells[6,32] := '인';

   ltExcelSheet.Range['U8:AF9'].Merge;
   ltExcelSheet.Range['U10:Z11'].Merge;
   ltExcelSheet.Range['AA10:AA11'].Merge;
   ltExcelSheet.Range['AA10:AA11'].Font.Size := 9;
   ltExcelSheet.Range['AA10:AA11'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Range['AA10:AA11'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['AA10:AA11'].WrapText := True;
   ltExcelSheet.Range['AA10:AA11'].Orientation := 0;
   ltExcelSheet.Range['AA10:AA11'].AddIndent := False;
   ltExcelSheet.Range['AA10:AA11'].IndentLevel := 0;
   ltExcelSheet.Range['AA10:AA11'].ShrinkToFit := False;
   ltExcelSheet.Cells[10,27] := '종목';

   ltExcelSheet.Range['AB10:AF11'].Merge;

   ltExcelSheet.Range['A12:AF13'].Font.Size := 10;
   ltExcelSheet.Range['A12:AF13'].HorizontalAlignment := xlCenter;

   ltExcelSheet.Range['A12:D12'].Merge;
   ltExcelSheet.Cells[12,1] := '작     성';

   ltExcelSheet.Range['E12:Q12'].Merge;
   ltExcelSheet.Cells[12,5] := '공      급      가      액';

   ltExcelSheet.Range['R12:AA12'].Merge;
   ltExcelSheet.Cells[12,18] := '세               액';

   ltExcelSheet.Range['AB12:AF12'].Merge;
   ltExcelSheet.Cells[12,28] := '비      고';

   ltExcelSheet.Range['A13:B13'].Merge;
   ltExcelSheet.Cells[13,1] := '년';
   ltExcelSheet.Cells[13,3] := '월';
   ltExcelSheet.Cells[13,4] := '일';
   ltExcelSheet.Cells[13,5] := '공란수';
   ltExcelSheet.Range['E13:F13'].Merge;

   ltExcelSheet.Cells[13,7] := '백';
   ltExcelSheet.Cells[13,8] := '십';
   ltExcelSheet.Cells[13,9] := '억';
   ltExcelSheet.Cells[13,10] := '천';
   ltExcelSheet.Cells[13,11] := '백';
   ltExcelSheet.Cells[13,12] := '십';
   ltExcelSheet.Cells[13,13] := '만';
   ltExcelSheet.Cells[13,14] := '천';
   ltExcelSheet.Cells[13,15] := '백';
   ltExcelSheet.Cells[13,16] := '십';
   ltExcelSheet.Cells[13,17] := '일';

   ltExcelSheet.Cells[13,18] := '십';
   ltExcelSheet.Cells[13,19] := '억';
   ltExcelSheet.Cells[13,20] := '천';
   ltExcelSheet.Cells[13,21] := '백';
   ltExcelSheet.Cells[13,22] := '십';
   ltExcelSheet.Cells[13,23] := '만';
   ltExcelSheet.Cells[13,24] := '천';
   ltExcelSheet.Cells[13,25] := '백';
   ltExcelSheet.Cells[13,26] := '십';
   ltExcelSheet.Cells[13,27] := '일';

   ltExcelSheet.Range['AB13:AF14'].Merge;

   ltExcelSheet.Range['A14:B14'].Merge;
   ltExcelSheet.Range['E14:F14'].Merge;
   ltExcelSheet.Range['A15:AF15'].Font.Size := 10;
   ltExcelSheet.Range['A15:AF15'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Cells[15,1] := '월';
   ltExcelSheet.Cells[15,2] := '일';
   ltExcelSheet.Cells[15,3] := '품          목';
   ltExcelSheet.Cells[15,9] := '규격';
   ltExcelSheet.Cells[15,12] := '수량';
   ltExcelSheet.Cells[15,15] := '단      가';
   ltExcelSheet.Cells[15,20] := '공  급  가  액';
   ltExcelSheet.Cells[15,26] := '세        액';
   ltExcelSheet.Cells[15,31] := '비고';

   for i:=15 to 19 do
   begin
      ltExcelSheet.Range['C'+IntToStr(i)+':H'+IntToStr(i)].Merge;
      ltExcelSheet.Range['I'+IntToStr(i)+':K'+IntToStr(i)].Merge;
      ltExcelSheet.Range['L'+IntToStr(i)+':N'+IntToStr(i)].Merge;
      ltExcelSheet.Range['O'+IntToStr(i)+':S'+IntToStr(i)].Merge;
      ltExcelSheet.Range['T'+IntToStr(i)+':Y'+IntToStr(i)].Merge;
      ltExcelSheet.Range['Z'+IntToStr(i)+':AD'+IntToStr(i)].Merge;
      ltExcelSheet.Range['AE'+IntToStr(i)+':AF'+IntToStr(i)].Merge;
   end;
   ltExcelSheet.Range['A20:AF21'].Font.Size := 10;
   ltExcelSheet.Range['A20:AF21'].HorizontalAlignment := xlCenter;

   ltExcelSheet.Range['A20:E20'].Merge;
   ltExcelSheet.Range['F20:J20'].Merge;
   ltExcelSheet.Range['K20:O20'].Merge;
   ltExcelSheet.Range['P20:T20'].Merge;
   ltExcelSheet.Range['U20:Y20'].Merge;
   ltExcelSheet.Cells[20,1] := '합계금액';
   ltExcelSheet.Cells[20,6] := '현  금';
   ltExcelSheet.Cells[20,11] := '수  표';
   ltExcelSheet.Cells[20,16] := '어  금';
   ltExcelSheet.Cells[20,21] := '외상미수금';

   ltExcelSheet.Cells[20,26] := '이 금액을';
   ltExcelSheet.Range['AD20:AE21'].Font.Bold := True;
   ltExcelSheet.Cells[20,30] := '청구';
   ltExcelSheet.Cells[20,32] := '함';

   ltExcelSheet.Range['A21:E21'].Merge;
   ltExcelSheet.Range['F21:J21'].Merge;
   ltExcelSheet.Range['K21:O21'].Merge;
   ltExcelSheet.Range['P21:T21'].Merge;
   ltExcelSheet.Range['U21:Y21'].Merge;

   ltExcelSheet.Range['Z20:AC21'].Merge;
   ltExcelSheet.Range['AD20:AE21'].Merge;
   ltExcelSheet.Range['AF20:AF21'].Merge;

   ltExcelSheet.Range['A22:AF22'].Font.Size := 8;
   ltExcelSheet.Range['A22:AF22'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Range['A22:H22'].Merge;
   ltExcelSheet.Cells[22,1] := '22226-28131일 ''''96.3.27승인';
   ltExcelSheet.Range['W22:AF22'].Merge;
   ltExcelSheet.Cells[22,23] := '인쇄용지(특급)34g/m2 182mmx128mm';

   ltExcelSheet.Range['A2:AF21'].Borders[xlDiagonalDown].LineStyle := xlNone;
   ltExcelSheet.Range['A2:AF21'].Borders[xlDiagonalUp].LineStyle := xlNone;
   ltExcelSheet.Range['A2:AF21'].Borders[xlEdgeLeft].LineStyle := xlContinuous;
   ltExcelSheet.Range['A2:AF21'].Borders[xlEdgeLeft].Weight := xlMedium;
   ltExcelSheet.Range['A2:AF21'].Borders[xlEdgeLeft].ColorIndex := 5;
   ltExcelSheet.Range['A2:AF21'].Borders[xlEdgeTop].LineStyle := xlContinuous;
   ltExcelSheet.Range['A2:AF21'].Borders[xlEdgeTop].Weight := xlMedium;
   ltExcelSheet.Range['A2:AF21'].Borders[xlEdgeTop].ColorIndex := 5;
   ltExcelSheet.Range['A2:AF21'].Borders[xlEdgeBottom].LineStyle := xlContinuous;
   ltExcelSheet.Range['A2:AF21'].Borders[xlEdgeBottom].Weight := xlMedium;
   ltExcelSheet.Range['A2:AF21'].Borders[xlEdgeBottom].ColorIndex := 5;
   ltExcelSheet.Range['A2:AF21'].Borders[xlEdgeRight].LineStyle := xlContinuous;
   ltExcelSheet.Range['A2:AF21'].Borders[xlEdgeRight].Weight := xlMedium;
   ltExcelSheet.Range['A2:AF21'].Borders[xlEdgeRight].ColorIndex := 5;
   ltExcelSheet.Range['A2:AF21'].Borders[xlInsideVertical].LineStyle := xlContinuous;
   ltExcelSheet.Range['A2:AF21'].Borders[xlInsideVertical].Weight := xlThin;
   ltExcelSheet.Range['A2:AF21'].Borders[xlInsideVertical].ColorIndex := 5;
   ltExcelSheet.Range['A2:AF21'].Borders[xlInsideHorizontal].LineStyle := xlContinuous;
   ltExcelSheet.Range['A2:AF21'].Borders[xlInsideHorizontal].Weight := xlThin;
   ltExcelSheet.Range['A2:AF21'].Borders[xlInsideHorizontal].ColorIndex := 5;

   ltExcelSheet.Range['P2:P3'].Borders[xlDiagonalDown].LineStyle := xlNone;
   ltExcelSheet.Range['P2:P3'].Borders[xlDiagonalUp].LineStyle := xlNone;
   ltExcelSheet.Range['P2:P3'].Borders[xlEdgeLeft].LineStyle := xlNone;
   ltExcelSheet.Range['P2:P3'].Borders[xlEdgeTop].LineStyle := xlContinuous;
   ltExcelSheet.Range['P2:P3'].Borders[xlEdgeTop].Weight := xlMedium;
   ltExcelSheet.Range['P2:P3'].Borders[xlEdgeTop].ColorIndex := 5;
   ltExcelSheet.Range['P2:P3'].Borders[xlEdgeBottom].LineStyle := xlContinuous;
   ltExcelSheet.Range['P2:P3'].Borders[xlEdgeBottom].Weight := xlThin;
   ltExcelSheet.Range['P2:P3'].Borders[xlEdgeBottom].ColorIndex := 5;
   ltExcelSheet.Range['P2:P3'].Borders[xlEdgeRight].LineStyle := xlNone;
   ltExcelSheet.Range['P2:P3'].Borders[xlInsideHorizontal].LineStyle := xlContinuous;
   ltExcelSheet.Range['P2:P3'].Borders[xlInsideHorizontal].Weight := xlThin;
   ltExcelSheet.Range['P2:P3'].Borders[xlInsideHorizontal].ColorIndex := 5;

   ltExcelSheet.Range['Q2:U2'].Borders[xlDiagonalDown].LineStyle := xlNone;
   ltExcelSheet.Range['Q2:U2'].Borders[xlDiagonalUp].LineStyle := xlNone;
   ltExcelSheet.Range['Q2:U2'].Borders[xlEdgeLeft].LineStyle := xlNone;
   ltExcelSheet.Range['Q2:U2'].Borders[xlEdgeRight].LineStyle := xlNone;
   ltExcelSheet.Range['Q2:U2'].Borders[xlEdgeBottom].LineStyle := xlNone;
   ltExcelSheet.Range['Q2:U2'].Borders[xlEdgeTop].LineStyle := xlContinuous;
   ltExcelSheet.Range['Q2:U2'].Borders[xlEdgeTop].Weight := xlMedium;
   ltExcelSheet.Range['Q2:U2'].Borders[xlEdgeTop].ColorIndex := 5;
   ltExcelSheet.Range['Q2:U2'].Borders[xlInsideVertical].LineStyle := xlContinuous;
   ltExcelSheet.Range['Q2:U2'].Borders[xlInsideVertical].Weight := xlThin;
   ltExcelSheet.Range['Q2:U2'].Borders[xlInsideVertical].ColorIndex := 5;

   ltExcelSheet.Range['V2:V3'].Borders[xlDiagonalDown].LineStyle := xlNone;
   ltExcelSheet.Range['V2:V3'].Borders[xlDiagonalUp].LineStyle := xlNone;
   ltExcelSheet.Range['V2:V3'].Borders[xlEdgeLeft].LineStyle := xlNone;
   ltExcelSheet.Range['V2:V3'].Borders[xlEdgeTop].LineStyle := xlContinuous;
   ltExcelSheet.Range['V2:V3'].Borders[xlEdgeTop].Weight := xlMedium;
   ltExcelSheet.Range['V2:V3'].Borders[xlEdgeTop].ColorIndex := 5;
   ltExcelSheet.Range['V2:V3'].Borders[xlEdgeBottom].LineStyle := xlContinuous;
   ltExcelSheet.Range['V2:V3'].Borders[xlEdgeBottom].Weight := xlThin;
   ltExcelSheet.Range['V2:V3'].Borders[xlEdgeBottom].ColorIndex := 5;
   ltExcelSheet.Range['V2:V3'].Borders[xlEdgeRight].LineStyle := xlContinuous;
   ltExcelSheet.Range['V2:V3'].Borders[xlEdgeRight].Weight := xlThin;
   ltExcelSheet.Range['V2:V3'].Borders[xlEdgeRight].ColorIndex := 5;
   ltExcelSheet.Range['V2:V3'].Borders[xlInsideHorizontal].LineStyle := xlContinuous;
   ltExcelSheet.Range['V2:V3'].Borders[xlInsideHorizontal].Weight := xlThin;
   ltExcelSheet.Range['V2:V3'].Borders[xlInsideHorizontal].ColorIndex := 5;

   ltExcelSheet.Range['U4:AF5'].Borders[xlDiagonalDown].LineStyle := xlNone;
   ltExcelSheet.Range['U4:AF5'].Borders[xlDiagonalUp].LineStyle := xlNone;
   ltExcelSheet.Range['U4:AF5'].Borders[xlEdgeTop].LineStyle := xlContinuous;
   ltExcelSheet.Range['U4:AF5'].Borders[xlEdgeTop].Weight := xlMedium;
   ltExcelSheet.Range['U4:AF5'].Borders[xlEdgeTop].ColorIndex := 5;
   ltExcelSheet.Range['U4:AF5'].Borders[xlEdgeBottom].LineStyle := xlContinuous;
   ltExcelSheet.Range['U4:AF5'].Borders[xlEdgeBottom].Weight := xlMedium;
   ltExcelSheet.Range['U4:AF5'].Borders[xlEdgeBottom].ColorIndex := 5;
   ltExcelSheet.Range['U4:AF5'].Borders[xlEdgeRight].LineStyle := xlContinuous;
   ltExcelSheet.Range['U4:AF5'].Borders[xlEdgeRight].Weight := xlMedium;
   ltExcelSheet.Range['U4:AF5'].Borders[xlEdgeRight].ColorIndex := 5;
   ltExcelSheet.Range['U4:AF5'].Borders[xlEdgeLeft].LineStyle := xlContinuous;
   ltExcelSheet.Range['U4:AF5'].Borders[xlEdgeLeft].Weight := xlMedium;
   ltExcelSheet.Range['U4:AF5'].Borders[xlEdgeLeft].ColorIndex := 5;
   ltExcelSheet.Range['U4:AF5'].Borders[xlInsideVertical].LineStyle := xlContinuous;
   ltExcelSheet.Range['U4:AF5'].Borders[xlInsideVertical].Weight := xlThin;
   ltExcelSheet.Range['U4:AF5'].Borders[xlInsideVertical].ColorIndex := 5;
   ltExcelSheet.Range['U4:AF5'].Borders[xlInsideHorizontal].LineStyle := xlContinuous;
   ltExcelSheet.Range['U4:AF5'].Borders[xlInsideHorizontal].Weight := xlThin;
   ltExcelSheet.Range['U4:AF5'].Borders[xlInsideHorizontal].ColorIndex := 5;

   ltExcelSheet.Range['E4:P7'].Borders[xlDiagonalDown].LineStyle := xlNone;
   ltExcelSheet.Range['E4:P7'].Borders[xlDiagonalUp].LineStyle := xlNone;
   ltExcelSheet.Range['E4:P7'].Borders[xlEdgeTop].LineStyle := xlContinuous;
   ltExcelSheet.Range['E4:P7'].Borders[xlEdgeTop].Weight := xlMedium;
   ltExcelSheet.Range['E4:P7'].Borders[xlEdgeTop].ColorIndex := 5;
   ltExcelSheet.Range['E4:P7'].Borders[xlEdgeBottom].LineStyle := xlContinuous;
   ltExcelSheet.Range['E4:P7'].Borders[xlEdgeBottom].Weight := xlMedium;
   ltExcelSheet.Range['E4:P7'].Borders[xlEdgeBottom].ColorIndex := 5;
   ltExcelSheet.Range['E4:P7'].Borders[xlEdgeRight].LineStyle := xlContinuous;
   ltExcelSheet.Range['E4:P7'].Borders[xlEdgeRight].Weight := xlMedium;
   ltExcelSheet.Range['E4:P7'].Borders[xlEdgeRight].ColorIndex := 5;
   ltExcelSheet.Range['E4:P7'].Borders[xlEdgeLeft].LineStyle := xlContinuous;
   ltExcelSheet.Range['E4:P7'].Borders[xlEdgeLeft].Weight := xlMedium;
   ltExcelSheet.Range['E4:P7'].Borders[xlEdgeLeft].ColorIndex := 5;
   ltExcelSheet.Range['E4:P7'].Borders[xlInsideVertical].LineStyle := xlContinuous;
   ltExcelSheet.Range['E4:P7'].Borders[xlInsideVertical].Weight := xlThin;
   ltExcelSheet.Range['E4:P7'].Borders[xlInsideVertical].ColorIndex := 5;
   ltExcelSheet.Range['E4:P7'].Borders[xlInsideHorizontal].LineStyle := xlContinuous;
   ltExcelSheet.Range['E4:P7'].Borders[xlInsideHorizontal].Weight := xlThin;
   ltExcelSheet.Range['E4:P7'].Borders[xlInsideHorizontal].ColorIndex := 5;

   ltExcelSheet.Range['P6:P7'].Borders[xlDiagonalDown].LineStyle := xlNone;
   ltExcelSheet.Range['P6:P7'].Borders[xlDiagonalUp].LineStyle := xlNone;
   ltExcelSheet.Range['P6:P7'].Borders[xlEdgeLeft].LineStyle := xlNone;
   ltExcelSheet.Range['P6:P7'].Borders[xlEdgeTop].LineStyle := xlContinuous;
   ltExcelSheet.Range['P6:P7'].Borders[xlEdgeTop].Weight := xlThin;
   ltExcelSheet.Range['P6:P7'].Borders[xlEdgeTop].ColorIndex := 5;
   ltExcelSheet.Range['P6:P7'].Borders[xlEdgeBottom].LineStyle := xlContinuous;
   ltExcelSheet.Range['P6:P7'].Borders[xlEdgeBottom].Weight := xlMedium;
   ltExcelSheet.Range['P6:P7'].Borders[xlEdgeBottom].ColorIndex := 5;
   ltExcelSheet.Range['P6:P7'].Borders[xlEdgeRight].LineStyle := xlContinuous;
   ltExcelSheet.Range['P6:P7'].Borders[xlEdgeRight].Weight := xlMedium;
   ltExcelSheet.Range['P6:P7'].Borders[xlEdgeRight].ColorIndex := 5;
   ltExcelSheet.Range['P6:P7'].Borders[xlInsideHorizontal].LineStyle := xlContinuous;
   ltExcelSheet.Range['P6:P7'].Borders[xlInsideHorizontal].Weight := xlThin;
   ltExcelSheet.Range['P6:P7'].Borders[xlInsideHorizontal].ColorIndex := 5;

   ltExcelSheet.Range['AF6:AF7'].Borders[xlDiagonalDown].LineStyle := xlNone;
   ltExcelSheet.Range['AF6:AF7'].Borders[xlDiagonalUp].LineStyle := xlNone;
   ltExcelSheet.Range['AF6:AF7'].Borders[xlEdgeLeft].LineStyle := xlNone;
   ltExcelSheet.Range['AF6:AF7'].Borders[xlEdgeTop].LineStyle := xlContinuous;
   ltExcelSheet.Range['AF6:AF7'].Borders[xlEdgeTop].Weight := xlMedium;
   ltExcelSheet.Range['AF6:AF7'].Borders[xlEdgeTop].ColorIndex := 5;
   ltExcelSheet.Range['AF6:AF7'].Borders[xlEdgeBottom].LineStyle := xlContinuous;
   ltExcelSheet.Range['AF6:AF7'].Borders[xlEdgeBottom].Weight := xlThin;
   ltExcelSheet.Range['AF6:AF7'].Borders[xlEdgeBottom].ColorIndex := 5;
   ltExcelSheet.Range['AF6:AF7'].Borders[xlEdgeRight].LineStyle := xlContinuous;
   ltExcelSheet.Range['AF6:AF7'].Borders[xlEdgeRight].Weight := xlMedium;
   ltExcelSheet.Range['AF6:AF7'].Borders[xlEdgeRight].ColorIndex := 5;
   ltExcelSheet.Range['AF6:AF7'].Borders[xlInsideHorizontal].LineStyle := xlContinuous;
   ltExcelSheet.Range['AF6:AF7'].Borders[xlInsideHorizontal].Weight := xlThin;
   ltExcelSheet.Range['AF6:AF7'].Borders[xlInsideHorizontal].ColorIndex := 5;

   ltExcelSheet.Range['A1:AF22'].Borders[xlDiagonalDown].LineStyle := xlNone;
   ltExcelSheet.Range['A1:AF22'].Borders[xlDiagonalUp].LineStyle := xlNone;
   ltExcelSheet.Range['A1:AF22'].Borders[xlEdgeTop].LineStyle := xlNone;
   ltExcelSheet.Range['A1:AF22'].Borders[xlEdgeBottom].LineStyle := xlNone;

   ltExcelSheet.Range['A12:AF14'].Borders[xlDiagonalDown].LineStyle := xlNone;
   ltExcelSheet.Range['A12:AF14'].Borders[xlDiagonalUp].LineStyle := xlNone;
   ltExcelSheet.Range['A12:AF14'].Borders[xlEdgeTop].LineStyle := xlContinuous;
   ltExcelSheet.Range['A12:AF14'].Borders[xlEdgeTop].Weight := xlMedium;
   ltExcelSheet.Range['A12:AF14'].Borders[xlEdgeTop].ColorIndex := 5;
   ltExcelSheet.Range['A12:AF14'].Borders[xlEdgeBottom].LineStyle := xlContinuous;
   ltExcelSheet.Range['A12:AF14'].Borders[xlEdgeBottom].Weight := xlMedium;
   ltExcelSheet.Range['A12:AF14'].Borders[xlEdgeBottom].ColorIndex := 5;
   ltExcelSheet.Range['A12:AF14'].Borders[xlEdgeRight].LineStyle := xlContinuous;
   ltExcelSheet.Range['A12:AF14'].Borders[xlEdgeRight].Weight := xlMedium;
   ltExcelSheet.Range['A12:AF14'].Borders[xlEdgeRight].ColorIndex := 5;
   ltExcelSheet.Range['A12:AF14'].Borders[xlEdgeLeft].LineStyle := xlContinuous;
   ltExcelSheet.Range['A12:AF14'].Borders[xlEdgeLeft].Weight := xlMedium;
   ltExcelSheet.Range['A12:AF14'].Borders[xlEdgeLeft].ColorIndex := 5;
   ltExcelSheet.Range['A12:AF14'].Borders[xlInsideHorizontal].LineStyle := xlContinuous;
   ltExcelSheet.Range['A12:AF14'].Borders[xlInsideHorizontal].Weight := xlThin;
   ltExcelSheet.Range['A12:AF14'].Borders[xlInsideHorizontal].ColorIndex := 5;
   ltExcelSheet.Range['A12:AF14'].Borders[xlInsideVertical].LineStyle := xlContinuous;
   ltExcelSheet.Range['A12:AF14'].Borders[xlInsideVertical].Weight := xlThin;
   ltExcelSheet.Range['A12:AF14'].Borders[xlInsideVertical].ColorIndex := 5;

   ltExcelSheet.Range['AD20:AE21'].Borders[xlDiagonalDown].LineStyle := xlNone;
   ltExcelSheet.Range['AD20:AE21'].Borders[xlDiagonalUp].LineStyle := xlNone;
   ltExcelSheet.Range['AD20:AE21'].Borders[xlEdgeLeft].LineStyle := xlNone;
   ltExcelSheet.Range['AD20:AE21'].Borders[xlEdgeRight].LineStyle := xlNone;
   ltExcelSheet.Range['AD20:AE21'].Borders[xlEdgeTop].LineStyle := xlContinuous;
   ltExcelSheet.Range['AD20:AE21'].Borders[xlEdgeTop].Weight := xlThin;
   ltExcelSheet.Range['AD20:AE21'].Borders[xlEdgeTop].ColorIndex := 5;
   ltExcelSheet.Range['AD20:AE21'].Borders[xlInsideHorizontal].LineStyle := xlContinuous;
   ltExcelSheet.Range['AD20:AE21'].Borders[xlInsideHorizontal].Weight := xlThin;
   ltExcelSheet.Range['AD20:AE21'].Borders[xlInsideHorizontal].ColorIndex := 5;

   // 수기입력 부분(검은색)
   ltExcelSheet.Range['E4:P5'].Font.ColorIndex := 1;
   ltExcelSheet.Range['E4:P5'].Font.Name := '굴림';
   ltExcelSheet.Range['E4:P5'].Font.Size := 12;
   ltExcelSheet.Range['E4:P5'].Font.Strikethrough := False;
   ltExcelSheet.Range['E4:P5'].Font.Superscript := False;
   ltExcelSheet.Range['E4:P5'].Font.Subscript := False;
   ltExcelSheet.Range['E4:P5'].Font.OutlineFont := False;
   ltExcelSheet.Range['E4:P5'].Font.Shadow := False;
   ltExcelSheet.Range['E4:P5'].Font.Underline := xlUnderlineStyleNone;
   ltExcelSheet.Range['E4:P5'].Font.Bold := True;
   ltExcelSheet.Range['E4:P5'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Range['E4:P5'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['E4:P5'].WrapText := False;
   ltExcelSheet.Range['E4:P5'].Orientation := 0;
   ltExcelSheet.Range['E4:P5'].AddIndent := False;
   ltExcelSheet.Range['E4:P5'].IndentLevel := 0;
   ltExcelSheet.Range['E4:P5'].ShrinkToFit := False;
   ltExcelSheet.Range['E4:P5'].ReadingOrder := xlContext;

   ltExcelSheet.Range['U4:AF5'].Font.ColorIndex := 1;
   ltExcelSheet.Range['U4:AF5'].Font.Name := '굴림';
   ltExcelSheet.Range['U4:AF5'].Font.Size := 12;
   ltExcelSheet.Range['U4:AF5'].Font.Strikethrough := False;
   ltExcelSheet.Range['U4:AF5'].Font.Superscript := False;
   ltExcelSheet.Range['U4:AF5'].Font.Subscript := False;
   ltExcelSheet.Range['U4:AF5'].Font.OutlineFont := False;
   ltExcelSheet.Range['U4:AF5'].Font.Shadow := False;
   ltExcelSheet.Range['U4:AF5'].Font.Underline := xlUnderlineStyleNone;
   ltExcelSheet.Range['U4:AF5'].Font.Bold := True;
   ltExcelSheet.Range['U4:AF5'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Range['U4:AF5'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['U4:AF5'].WrapText := False;
   ltExcelSheet.Range['U4:AF5'].Orientation := 0;
   ltExcelSheet.Range['U4:AF5'].AddIndent := False;
   ltExcelSheet.Range['U4:AF5'].IndentLevel := 0;
   ltExcelSheet.Range['U4:AF5'].ShrinkToFit := False;
   ltExcelSheet.Range['U4:AF5'].ReadingOrder := xlContext;

   ltExcelSheet.Range['E6:J7,L6:O7,E10:J11,L10:P11,U6:Z7,AB6:AE7,U10:Z11,AB10:AF11'].Font.Name := '굴림';
   ltExcelSheet.Range['E6:J7,L6:O7,E10:J11,L10:P11,U6:Z7,AB6:AE7,U10:Z11,AB10:AF11'].Font.Size := 9;
   ltExcelSheet.Range['E6:J7,L6:O7,E10:J11,L10:P11,U6:Z7,AB6:AE7,U10:Z11,AB10:AF11'].Font.Strikethrough := False;
   ltExcelSheet.Range['E6:J7,L6:O7,E10:J11,L10:P11,U6:Z7,AB6:AE7,U10:Z11,AB10:AF11'].Font.Superscript := False;
   ltExcelSheet.Range['E6:J7,L6:O7,E10:J11,L10:P11,U6:Z7,AB6:AE7,U10:Z11,AB10:AF11'].Font.Subscript := False;
   ltExcelSheet.Range['E6:J7,L6:O7,E10:J11,L10:P11,U6:Z7,AB6:AE7,U10:Z11,AB10:AF11'].Font.OutlineFont := False;
   ltExcelSheet.Range['E6:J7,L6:O7,E10:J11,L10:P11,U6:Z7,AB6:AE7,U10:Z11,AB10:AF11'].Font.Shadow := False;
   ltExcelSheet.Range['E6:J7,L6:O7,E10:J11,L10:P11,U6:Z7,AB6:AE7,U10:Z11,AB10:AF11'].Font.Underline := xlUnderlineStyleNone;
   ltExcelSheet.Range['E6:J7,L6:O7,E10:J11,L10:P11,U6:Z7,AB6:AE7,U10:Z11,AB10:AF11'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Range['E6:J7,L6:O7,E10:J11,L10:P11,U6:Z7,AB6:AE7,U10:Z11,AB10:AF11'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['L6:O7,E10:J11,AB6:AE7,U10:Z11'].WrapText := False;
   ltExcelSheet.Range['E6:J7,U6:Z7,L10:P11,AB10:AF11'].WrapText := True;
   ltExcelSheet.Range['E6:J7,L6:O7,E10:J11,L10:P11,U6:Z7,AB6:AE7,U10:Z11,AB10:AF11'].Orientation := 0;
   ltExcelSheet.Range['E6:J7,L6:O7,E10:J11,L10:P11,U6:Z7,AB6:AE7,U10:Z11,AB10:AF11'].AddIndent := False;
   ltExcelSheet.Range['E6:J7,L6:O7,E10:J11,L10:P11,U6:Z7,AB6:AE7,U10:Z11,AB10:AF11'].IndentLevel := 0;
   ltExcelSheet.Range['E6:J7,L6:O7,E10:J11,L10:P11,U6:Z7,AB6:AE7,U10:Z11,AB10:AF11'].ShrinkToFit := False;
   ltExcelSheet.Range['E6:J7,L6:O7,E10:J11,L10:P11,U6:Z7,AB6:AE7,U10:Z11,AB10:AF11'].ReadingOrder := xlContext;
   ltExcelSheet.Range['E6:J7,L6:O7,E10:J11,L10:P11,U6:Z7,AB6:AE7,U10:Z11,AB10:AF11'].Font.ColorIndex := 1;

   ltExcelSheet.Range['E8:P9,U8:AF9'].Font.Name := '굴림';
   ltExcelSheet.Range['E8:P9,U8:AF9'].Font.Size := 8;
   ltExcelSheet.Range['E8:P9,U8:AF9'].Font.Strikethrough := False;
   ltExcelSheet.Range['E8:P9,U8:AF9'].Font.Superscript := False;
   ltExcelSheet.Range['E8:P9,U8:AF9'].Font.Subscript := False;
   ltExcelSheet.Range['E8:P9,U8:AF9'].Font.OutlineFont := False;
   ltExcelSheet.Range['E8:P9,U8:AF9'].Font.Shadow := False;
   ltExcelSheet.Range['E8:P9,U8:AF9'].Font.Underline := xlUnderlineStyleNone;
   ltExcelSheet.Range['E8:P9,U8:AF9'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Range['E8:P9,U8:AF9'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['E8:P9,U8:AF9'].WrapText := True;
   ltExcelSheet.Range['E8:P9,U8:AF9'].Orientation := 0;
   ltExcelSheet.Range['E8:P9,U8:AF9'].AddIndent := False;
   ltExcelSheet.Range['E8:P9,U8:AF9'].IndentLevel := 0;
   ltExcelSheet.Range['E8:P9,U8:AF9'].ShrinkToFit := False;
   ltExcelSheet.Range['E8:P9,U8:AF9'].ReadingOrder := xlContext;
   ltExcelSheet.Range['E8:P9,U8:AF9'].Font.ColorIndex := 1;

   ltExcelSheet.Range['A14:F14'].Font.ColorIndex := 1;
   ltExcelSheet.Range['A14:F14'].Font.Name := '굴림';
   ltExcelSheet.Range['A14:F14'].Font.Size := 10;
   ltExcelSheet.Range['A14:F14'].Font.Strikethrough := False;
   ltExcelSheet.Range['A14:F14'].Font.Superscript := False;
   ltExcelSheet.Range['A14:F14'].Font.Subscript := False;
   ltExcelSheet.Range['A14:F14'].Font.OutlineFont := False;
   ltExcelSheet.Range['A14:F14'].Font.Shadow := False;
   ltExcelSheet.Range['A14:F14'].Font.Underline := xlUnderlineStyleNone;
   ltExcelSheet.Range['A14:F14'].Font.Bold := False;
   ltExcelSheet.Range['A14:F14'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Range['A14:F14'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['A14:F14'].WrapText := False;
   ltExcelSheet.Range['A14:F14'].Orientation := 0;
   ltExcelSheet.Range['A14:F14'].AddIndent := False;
   ltExcelSheet.Range['A14:F14'].IndentLevel := 0;
   ltExcelSheet.Range['A14:F14'].ShrinkToFit := False;
   ltExcelSheet.Range['A14:F14'].ReadingOrder := xlContext;

   ltExcelSheet.Range['G14:AA14,A21:Y21'].Font.ColorIndex := 1;
   ltExcelSheet.Range['G14:AA14,A21:Y21'].Font.Name := '굴림';
   ltExcelSheet.Range['G14:AA14,A21:Y21'].Font.Size := 10;
   ltExcelSheet.Range['G14:AA14,A21:Y21'].Font.Strikethrough := False;
   ltExcelSheet.Range['G14:AA14,A21:Y21'].Font.Superscript := False;
   ltExcelSheet.Range['G14:AA14,A21:Y21'].Font.Subscript := False;
   ltExcelSheet.Range['G14:AA14,A21:Y21'].Font.OutlineFont := False;
   ltExcelSheet.Range['G14:AA14,A21:Y21'].Font.Shadow := False;
   ltExcelSheet.Range['G14:AA14,A21:Y21'].Font.Underline := xlUnderlineStyleNone;
   ltExcelSheet.Range['G14:AA14,A21:Y21'].Font.Bold := True;
   ltExcelSheet.Range['G14:AA14,A21:Y21'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Range['G14:AA14,A21:Y21'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['G14:AA14,A21:Y21'].WrapText := False;
   ltExcelSheet.Range['G14:AA14,A21:Y21'].Orientation := 0;
   ltExcelSheet.Range['G14:AA14,A21:Y21'].AddIndent := False;
   ltExcelSheet.Range['G14:AA14,A21:Y21'].IndentLevel := 0;
   ltExcelSheet.Range['G14:AA14,A21:Y21'].ShrinkToFit := False;
   ltExcelSheet.Range['G14:AA14,A21:Y21'].ReadingOrder := xlContext;

   ltExcelSheet.Range['A16:N19'].Font.ColorIndex := 1;
   ltExcelSheet.Range['A16:N19'].Font.Name := '굴림';
   ltExcelSheet.Range['A16:N19'].Font.Size := 10;
   ltExcelSheet.Range['A16:N19'].Font.Strikethrough := False;
   ltExcelSheet.Range['A16:N19'].Font.Superscript := False;
   ltExcelSheet.Range['A16:N19'].Font.Subscript := False;
   ltExcelSheet.Range['A16:N19'].Font.OutlineFont := False;
   ltExcelSheet.Range['A16:N19'].Font.Shadow := False;
   ltExcelSheet.Range['A16:N19'].Font.Underline := xlUnderlineStyleNone;
   ltExcelSheet.Range['A16:N19'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Range['A16:N19'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['A16:N19'].WrapText := False;
   ltExcelSheet.Range['A16:N19'].Orientation := 0;
   ltExcelSheet.Range['A16:N19'].AddIndent := False;
   ltExcelSheet.Range['A16:N19'].IndentLevel := 0;
   ltExcelSheet.Range['A16:N19'].ShrinkToFit := False;
   ltExcelSheet.Range['A16:N19'].ReadingOrder := xlContext;

   ltExcelSheet.Range['O16:AD19'].Font.ColorIndex := 1;
   ltExcelSheet.Range['O16:AD19'].Font.Name := '굴림';
   ltExcelSheet.Range['O16:AD19'].Font.Size := 10;
   ltExcelSheet.Range['O16:AD19'].Font.Strikethrough := False;
   ltExcelSheet.Range['O16:AD19'].Font.Superscript := False;
   ltExcelSheet.Range['O16:AD19'].Font.Subscript := False;
   ltExcelSheet.Range['O16:AD19'].Font.OutlineFont := False;
   ltExcelSheet.Range['O16:AD19'].Font.Shadow := False;
   ltExcelSheet.Range['O16:AD19'].Font.Underline := xlUnderlineStyleNone;
   ltExcelSheet.Range['O16:AD19'].HorizontalAlignment := xlRight;
   ltExcelSheet.Range['O16:AD19'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['O16:AD19'].WrapText := False;
   ltExcelSheet.Range['O16:AD19'].Orientation := 0;
   ltExcelSheet.Range['O16:AD19'].AddIndent := False;
   ltExcelSheet.Range['O16:AD19'].IndentLevel := 0;
   ltExcelSheet.Range['O16:AD19'].ShrinkToFit := False;
   ltExcelSheet.Range['O16:AD19'].ReadingOrder := xlContext;

   ltExcelSheet.Range['AE16:AF19'].Font.ColorIndex := 1;
   ltExcelSheet.Range['AE16:AF19'].Font.Name := '굴림';
   ltExcelSheet.Range['AE16:AF19'].Font.Size := 10;
   ltExcelSheet.Range['AE16:AF19'].Font.Strikethrough := False;
   ltExcelSheet.Range['AE16:AF19'].Font.Superscript := False;
   ltExcelSheet.Range['AE16:AF19'].Font.Subscript := False;
   ltExcelSheet.Range['AE16:AF19'].Font.OutlineFont := False;
   ltExcelSheet.Range['AE16:AF19'].Font.Shadow := False;
   ltExcelSheet.Range['AE16:AF19'].Font.Underline := xlUnderlineStyleNone;


   ltExcelSheet.Range['E8:P9,U8:AF9'].Font.Underline := xlUnderlineStyleNone;

   ltExcelSheet.Range['I16:AD19'].NumberFormatLocal := '#,##0';
   ltExcelSheet.Range['A21:Y21'].NumberFormatLocal := '#,##0';
End;

procedure Function_Print_Copy;
begin
   ltExcelSheet.Cells[48,1] := '계    산    서';
   ltExcelSheet.Range['R59:AA60'].ClearContents;
   ltExcelSheet.Range['R59:AF60'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['R59:AF60'].WrapText := False;
   ltExcelSheet.Range['R59:AF60'].Orientation := 0;
   ltExcelSheet.Range['R59:AF60'].AddIndent := False;
   ltExcelSheet.Range['R59:AF60'].ShrinkToFit := False;
   ltExcelSheet.Range['R59:AF60'].ReadingOrder := xlContext;
   ltExcelSheet.Range['R59:AF60'].MergeCells := True;
   ltExcelSheet.Range['R59:AF60'].Borders[xlDiagonalDown].LineStyle := xlNone;
   ltExcelSheet.Range['R59:AF60'].Borders[xlDiagonalUp].LineStyle := xlNone;
   ltExcelSheet.Range['R59:AF60'].Borders[xlEdgeLeft].LineStyle := xlContinuous;
   ltExcelSheet.Range['R59:AF60'].Borders[xlEdgeLeft].Weight := xlMedium;
   ltExcelSheet.Range['R59:AF60'].Borders[xlEdgeLeft].ColorIndex := 5;
   ltExcelSheet.Range['R59:AF60'].Borders[xlEdgeTop].LineStyle := xlContinuous;
   ltExcelSheet.Range['R59:AF60'].Borders[xlEdgeTop].Weight := xlThin;
   ltExcelSheet.Range['R59:AF60'].Borders[xlEdgeTop].ColorIndex := 5;
   ltExcelSheet.Range['R59:AF60'].Borders[xlEdgeBottom].LineStyle := xlContinuous;
   ltExcelSheet.Range['R59:AF60'].Borders[xlEdgeBottom].Weight := xlMedium;
   ltExcelSheet.Range['R59:AF60'].Borders[xlEdgeBottom].ColorIndex := 5;
   ltExcelSheet.Range['R59:AF60'].Borders[xlEdgeRight].LineStyle := xlContinuous;
   ltExcelSheet.Range['R59:AF60'].Borders[xlEdgeRight].Weight := xlMedium;
   ltExcelSheet.Range['R59:AF60'].Borders[xlEdgeRight].ColorIndex := 5;

   ltExcelSheet.Range['R58:AA58'].ClearContents;
   ltExcelSheet.Range['R58:AF58'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Range['R58:AF58'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['R58:AF58'].WrapText := False;
   ltExcelSheet.Range['R58:AF58'].Orientation := 0;
   ltExcelSheet.Range['R58:AF58'].AddIndent := False;
   ltExcelSheet.Range['R58:AF58'].IndentLevel := False;
   ltExcelSheet.Range['R58:AF58'].ShrinkToFit := False;
   ltExcelSheet.Range['R58:AF58'].ReadingOrder := xlContext;
   ltExcelSheet.Range['R58:AF58'].MergeCells := True;
   ltExcelSheet.Range['R58:AF58'].Borders[xlDiagonalDown].LineStyle := xlNone;
   ltExcelSheet.Range['R58:AF58'].Borders[xlDiagonalUp].LineStyle := xlNone;
   ltExcelSheet.Range['R58:AF58'].Borders[xlEdgeLeft].LineStyle := xlContinuous;
   ltExcelSheet.Range['R58:AF58'].Borders[xlEdgeLeft].Weight := xlMedium;
   ltExcelSheet.Range['R58:AF58'].Borders[xlEdgeLeft].ColorIndex := 5;
   ltExcelSheet.Range['R58:AF58'].Borders[xlEdgeTop].LineStyle := xlContinuous;
   ltExcelSheet.Range['R58:AF58'].Borders[xlEdgeTop].Weight := xlMedium;
   ltExcelSheet.Range['R58:AF58'].Borders[xlEdgeTop].ColorIndex := 5;
   ltExcelSheet.Range['R58:AF58'].Borders[xlEdgeBottom].LineStyle := xlContinuous;
   ltExcelSheet.Range['R58:AF58'].Borders[xlEdgeBottom].Weight := xlThin;
   ltExcelSheet.Range['R58:AF58'].Borders[xlEdgeBottom].ColorIndex := 5;
   ltExcelSheet.Range['R58:AF58'].Borders[xlEdgeRight].LineStyle := xlContinuous;
   ltExcelSheet.Range['R58:AF58'].Borders[xlEdgeRight].Weight := xlMedium;
   ltExcelSheet.Range['R58:AF58'].Borders[xlEdgeRight].ColorIndex := 5;
   ltExcelSheet.Range['R58:AF58'].Borders[xlInsideVertical].LineStyle := xlContinuous;
   ltExcelSheet.Range['R58:AF58'].Borders[xlInsideVertical].Weight := xlThin;
   ltExcelSheet.Range['R58:AF58'].Borders[xlInsideVertical].ColorIndex := 5;

   ltExcelSheet.Range['Z61:AD61'].ClearContents;
   ltExcelSheet.Range['Z61:AF61'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Range['Z61:AF61'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['Z61:AF61'].WrapText := False;
   ltExcelSheet.Range['Z61:AF61'].Orientation := 0;
   ltExcelSheet.Range['Z61:AF61'].AddIndent := False;
   ltExcelSheet.Range['Z61:AF61'].IndentLevel := 0;
   ltExcelSheet.Range['Z61:AF61'].ShrinkToFit := False;
   ltExcelSheet.Range['Z61:AF61'].ReadingOrder := xlContext;
   ltExcelSheet.Range['Z61:AF61'].MergeCells := True;

   ltExcelSheet.Range['Z62:AF62'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['Z62:AF62'].WrapText := False;
   ltExcelSheet.Range['Z62:AF62'].Orientation := 0;
   ltExcelSheet.Range['Z62:AF62'].AddIndent := False;
   ltExcelSheet.Range['Z62:AF62'].ShrinkToFit := False;
   ltExcelSheet.Range['Z62:AF62'].ReadingOrder := xlContext;
   ltExcelSheet.Range['Z62:AF62'].MergeCells := True;

   ltExcelSheet.Range['Z63:AF63'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['Z63:AF63'].WrapText := False;
   ltExcelSheet.Range['Z63:AF63'].Orientation := 0;
   ltExcelSheet.Range['Z63:AF63'].AddIndent := False;
   ltExcelSheet.Range['Z63:AF63'].ShrinkToFit := False;
   ltExcelSheet.Range['Z63:AF63'].ReadingOrder := xlContext;
   ltExcelSheet.Range['Z63:AF63'].MergeCells := True;

   ltExcelSheet.Range['Z64:AF64'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['Z64:AF64'].WrapText := False;
   ltExcelSheet.Range['Z64:AF64'].Orientation := 0;
   ltExcelSheet.Range['Z64:AF64'].AddIndent := False;
   ltExcelSheet.Range['Z64:AF64'].ShrinkToFit := False;
   ltExcelSheet.Range['Z64:AF64'].ReadingOrder := xlContext;
   ltExcelSheet.Range['Z64:AF64'].MergeCells := True;

   ltExcelSheet.Range['Z65:AF65'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['Z65:AF65'].WrapText := False;
   ltExcelSheet.Range['Z65:AF65'].Orientation := 0;
   ltExcelSheet.Range['Z65:AF65'].AddIndent := False;
   ltExcelSheet.Range['Z65:AF65'].ShrinkToFit := False;
   ltExcelSheet.Range['Z65:AF65'].ReadingOrder := xlContext;
   ltExcelSheet.Range['Z65:AF65'].MergeCells := True;



   ltExcelSheet.Cells[72,1] := '계    산    서';
   ltExcelSheet.Range['R83:AA84'].ClearContents;
   ltExcelSheet.Range['R83:AF84'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['R83:AF84'].WrapText := False;
   ltExcelSheet.Range['R83:AF84'].Orientation := 0;
   ltExcelSheet.Range['R83:AF84'].AddIndent := False;
   ltExcelSheet.Range['R83:AF84'].ShrinkToFit := False;
   ltExcelSheet.Range['R83:AF84'].ReadingOrder := xlContext;
   ltExcelSheet.Range['R83:AF84'].MergeCells := True;
   ltExcelSheet.Range['R83:AF84'].Borders[xlDiagonalDown].LineStyle := xlNone;
   ltExcelSheet.Range['R83:AF84'].Borders[xlDiagonalUp].LineStyle := xlNone;
   ltExcelSheet.Range['R83:AF84'].Borders[xlEdgeLeft].LineStyle := xlContinuous;
   ltExcelSheet.Range['R83:AF84'].Borders[xlEdgeLeft].Weight := xlMedium;
   ltExcelSheet.Range['R83:AF84'].Borders[xlEdgeLeft].ColorIndex := 3;
   ltExcelSheet.Range['R83:AF84'].Borders[xlEdgeTop].LineStyle := xlContinuous;
   ltExcelSheet.Range['R83:AF84'].Borders[xlEdgeTop].Weight := xlThin;
   ltExcelSheet.Range['R83:AF84'].Borders[xlEdgeTop].ColorIndex := 3;
   ltExcelSheet.Range['R83:AF84'].Borders[xlEdgeBottom].LineStyle := xlContinuous;
   ltExcelSheet.Range['R83:AF84'].Borders[xlEdgeBottom].Weight := xlMedium;
   ltExcelSheet.Range['R83:AF84'].Borders[xlEdgeBottom].ColorIndex := 3;
   ltExcelSheet.Range['R83:AF84'].Borders[xlEdgeRight].LineStyle := xlContinuous;
   ltExcelSheet.Range['R83:AF84'].Borders[xlEdgeRight].Weight := xlMedium;
   ltExcelSheet.Range['R83:AF84'].Borders[xlEdgeRight].ColorIndex := 3;

   ltExcelSheet.Range['R82:AA82'].ClearContents;
   ltExcelSheet.Range['R82:AF82'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Range['R82:AF82'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['R82:AF82'].WrapText := False;
   ltExcelSheet.Range['R82:AF82'].Orientation := 0;
   ltExcelSheet.Range['R82:AF82'].AddIndent := False;
   ltExcelSheet.Range['R82:AF82'].IndentLevel := False;
   ltExcelSheet.Range['R82:AF82'].ShrinkToFit := False;
   ltExcelSheet.Range['R82:AF82'].ReadingOrder := xlContext;
   ltExcelSheet.Range['R82:AF82'].MergeCells := True;
   ltExcelSheet.Range['R82:AF82'].Borders[xlDiagonalDown].LineStyle := xlNone;
   ltExcelSheet.Range['R82:AF82'].Borders[xlDiagonalUp].LineStyle := xlNone;
   ltExcelSheet.Range['R82:AF82'].Borders[xlEdgeLeft].LineStyle := xlContinuous;
   ltExcelSheet.Range['R82:AF82'].Borders[xlEdgeLeft].Weight := xlMedium;
   ltExcelSheet.Range['R82:AF82'].Borders[xlEdgeLeft].ColorIndex := 3;
   ltExcelSheet.Range['R82:AF82'].Borders[xlEdgeTop].LineStyle := xlContinuous;
   ltExcelSheet.Range['R82:AF82'].Borders[xlEdgeTop].Weight := xlMedium;
   ltExcelSheet.Range['R82:AF82'].Borders[xlEdgeTop].ColorIndex := 3;
   ltExcelSheet.Range['R82:AF82'].Borders[xlEdgeBottom].LineStyle := xlContinuous;
   ltExcelSheet.Range['R82:AF82'].Borders[xlEdgeBottom].Weight := xlThin;
   ltExcelSheet.Range['R82:AF82'].Borders[xlEdgeBottom].ColorIndex := 3;
   ltExcelSheet.Range['R82:AF82'].Borders[xlEdgeRight].LineStyle := xlContinuous;
   ltExcelSheet.Range['R82:AF82'].Borders[xlEdgeRight].Weight := xlMedium;
   ltExcelSheet.Range['R82:AF82'].Borders[xlEdgeRight].ColorIndex := 3;
   ltExcelSheet.Range['R82:AF82'].Borders[xlInsideVertical].LineStyle := xlContinuous;
   ltExcelSheet.Range['R82:AF82'].Borders[xlInsideVertical].Weight := xlThin;
   ltExcelSheet.Range['R82:AF82'].Borders[xlInsideVertical].ColorIndex := 3;

   ltExcelSheet.Range['Z85:AD85'].ClearContents;
   ltExcelSheet.Range['Z85:AF85'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Range['Z85:AF85'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['Z85:AF85'].WrapText := False;
   ltExcelSheet.Range['Z85:AF85'].Orientation := 0;
   ltExcelSheet.Range['Z85:AF85'].AddIndent := False;
   ltExcelSheet.Range['Z85:AF85'].IndentLevel := 0;
   ltExcelSheet.Range['Z85:AF85'].ShrinkToFit := False;
   ltExcelSheet.Range['Z85:AF85'].ReadingOrder := xlContext;
   ltExcelSheet.Range['Z85:AF85'].MergeCells := True;

   ltExcelSheet.Range['Z86:AF86'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['Z86:AF86'].WrapText := False;
   ltExcelSheet.Range['Z86:AF86'].Orientation := 0;
   ltExcelSheet.Range['Z86:AF86'].AddIndent := False;
   ltExcelSheet.Range['Z86:AF86'].ShrinkToFit := False;
   ltExcelSheet.Range['Z86:AF86'].ReadingOrder := xlContext;
   ltExcelSheet.Range['Z86:AF86'].MergeCells := True;

   ltExcelSheet.Range['Z87:AF87'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['Z87:AF87'].WrapText := False;
   ltExcelSheet.Range['Z87:AF87'].Orientation := 0;
   ltExcelSheet.Range['Z87:AF87'].AddIndent := False;
   ltExcelSheet.Range['Z87:AF87'].ShrinkToFit := False;
   ltExcelSheet.Range['Z87:AF87'].ReadingOrder := xlContext;
   ltExcelSheet.Range['Z87:AF87'].MergeCells := True;

   ltExcelSheet.Range['Z88:AF88'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['Z88:AF88'].WrapText := False;
   ltExcelSheet.Range['Z88:AF88'].Orientation := 0;
   ltExcelSheet.Range['Z88:AF88'].AddIndent := False;
   ltExcelSheet.Range['Z88:AF88'].ShrinkToFit := False;
   ltExcelSheet.Range['Z88:AF88'].ReadingOrder := xlContext;
   ltExcelSheet.Range['Z88:AF88'].MergeCells := True;

   ltExcelSheet.Range['Z89:AF89'].VerticalAlignment := xlCenter;
   ltExcelSheet.Range['Z89:AF89'].WrapText := False;
   ltExcelSheet.Range['Z89:AF89'].Orientation := 0;
   ltExcelSheet.Range['Z89:AF89'].AddIndent := False;
   ltExcelSheet.Range['Z89:AF89'].ShrinkToFit := False;
   ltExcelSheet.Range['Z89:AF89'].ReadingOrder := xlContext;
   ltExcelSheet.Range['Z89:AF89'].MergeCells := True;
end;
}

end.
