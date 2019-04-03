unit PrintExcel;

interface

uses
   SysUtils, ExtCtrls;

var
  ltExcelApp: Variant;
  ltExcelBook: Variant;
  ltExcelSheet, ltExcelSheetSource: Variant;
  ColumnRange: Variant;
  Range : Variant;
const
  xlNone = 0; xlDiagonalDown = 5; xlLeft = -4131;    xlRight = -4152;
  xlTop = -4160; xlEdgeTop = 8;  xlBottom = -4107; xlEdgeLeft = 7; xlEdgeRight = 10; xlContinuous = 1;
  xlEdgeBottom = 9;  xlMedium = -4138; xlAutomatic = -4105; xlCenter = -4108;
  xlInsideHorizontal = 12; xlThin = 2; xlInsideVertical = 11; xlHairline = 1;
  xlSolid = 1;

procedure Function_Print_Excel;
//procedure Function_PrintExcelData(Ashregid:String; Ashs_day:String; Asho_name:String; Ashceo:String; Ashaddr:String; Ashm_name:String; Asho_tel:String; Asho_fax:String);

implementation

uses Unit1;

//procedure Function_PrintExcelData(Ashregid:String; Ashs_day:String; Asho_name:String; Ashceo:String; Ashaddr:String; Ashm_name:String; Asho_tel:String; Asho_fax:String);
//begin
//

//end;

procedure Function_Print_Excel; //양식만들기
var
 i : integer;
begin
   ltExcelSheet.Range['A1:H52'].Font.ColorIndex := 1; //폰트
   ltExcelSheet.Range['A1:H52'].Font.Name := '굴림체';
   ltExcelSheet.Range['A1:H52'].Font.Size := 11;
   ltExcelSheet.PageSetup.LeftMargin := 0;
   ltExcelSheet.PageSetup.RightMargin := 0;
   ltExcelSheet.PageSetup.TopMargin := 29*1.9;
   ltExcelSheet.PageSetup.BottomMargin := 29*1.9;
   ltExcelSheet.PageSetup.HeaderMargin := 28*0.8;
   ltExcelSheet.PageSetup.FooterMargin := 28*0.8;
   ltExcelSheet.PageSetup.Zoom := 85;
   ltExcelSheet.PageSetup.CenterHorizontally := True;

   //너비
   ltExcelSheet.Range['A:A'].ColumnWidth := 1;
   ltExcelSheet.Range['B:B'].ColumnWidth := 30;
   ltExcelSheet.Range['C:C'].ColumnWidth := 1*5.88;
   ltExcelSheet.Range['D:D'].ColumnWidth := 1*9.75;
   ltExcelSheet.Range['E:E'].ColumnWidth := 1*17.38;
   ltExcelSheet.Range['F:F'].ColumnWidth := 1*9.13;
   ltExcelSheet.Range['G:G'].ColumnWidth := 1*7.88;
   ltExcelSheet.Range['H:H'].ColumnWidth := 1*12.00;

   //행높이
   ltExcelSheet.Range['B2:H3'].RowHeight := 1*13.75;

   ltExcelSheet.Range['B2:H3'].Merge;
   ltExcelSheet.Range['B2:H3'].Font.size := 24;
   ltExcelSheet.Range['B2:H3'].Font.Bold := True;
   ltExcelSheet.Range['B2:H3'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Cells[2,2] := '일 일 거 래 명 세 서';

   ltExcelSheet.Range['E6:H6'].Merge;
   ltExcelSheet.Range['E6:H6'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Cells[6,4] := '사업자번호';

   ltExcelSheet.Range['B7:B7'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Range['B7:B7'].Font.Bold := True;
   ltExcelSheet.Range['B7:B7'].Font.Size := 12;

   ltExcelSheet.Cells[7,4] := '회사명';
   ltExcelSheet.Cells[7,6] := '대표자';

   ltExcelSheet.Cells[8,4] := '주소';
   ltExcelSheet.Range['D8:D9'].Merge;
   ltExcelSheet.Range['D8:D9'].HorizontalAlignment := xlCenter;

   ltExcelSheet.Range['E8:H9'].Merge;
   ltExcelSheet.Range['E8:H9'].HorizontalAlignment := xlLeft;

   ltExcelSheet.Range['B9:B10'].Merge;                           //조합원명
   ltExcelSheet.Range['B9:B10'].Characters(Start:=1, Length:=12).Font.Size := 14;
   ltExcelSheet.Range['B9:B10'].Characters(Start:=13, Length:=2).Font.Size := 12;
   ltExcelSheet.Range['B9:B10'].Font.Bold := True;
   ltExcelSheet.Range['B9:B10'].HorizontalAlignment := xlCenter;

   ltExcelSheet.Cells[10,4] := '전   화';
   ltExcelSheet.Cells[10,6] := '팩   스';
   ltExcelSheet.Cells[11,2] := '  아래와 같이 공급합니다.';
   ltExcelSheet.Range['D6:D6'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Range['D7:D7'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Range['D10:D10'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Range['F7:F7'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Range['F10:F10'].HorizontalAlignment := xlCenter;

   ltExcelSheet.Range['A2:H3'].RowHeight :=1*13.75;
   ltExcelSheet.Cells[13,2] := '품  명';
   ltExcelSheet.Range['B13:B13'].HorizontalAlignment := xlCenter;

   ltExcelSheet.Cells[13,3] := '규격';
   ltExcelSheet.Range['C13:C13'].HorizontalAlignment := xlCenter;

   ltExcelSheet.Cells[13,4] := '수 량';
   ltExcelSheet.Range['D13:D13'].HorizontalAlignment := xlCenter;

   ltExcelSheet.Range['E7:E7'].HorizontalAlignment := xlCenter;

   ltExcelSheet.Range['E10:E10'].HorizontalAlignment := xlCenter;

   ltExcelSheet.Cells[13,5] := '단 가';
   ltExcelSheet.Range['E13:E13'].HorizontalAlignment := xlCenter;
      
   ltExcelSheet.Cells[13,6] := '합 계';
   ltExcelSheet.Range['F13:F13'].HorizontalAlignment := xlCenter;

   ltExcelSheet.Range['G7:H7'].Merge;
   ltExcelSheet.Range['G7:H7'].HorizontalAlignment := xlLeft;

   ltExcelSheet.Range['G10:H10'].Merge;
   ltExcelSheet.Range['G10:H10'].HorizontalAlignment := xlLeft;

   ltExcelSheet.Range['G13:H13'].Merge;
   ltExcelSheet.Range['G13:H13'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Cells[13,7] := '비고';

    For i := 14 to 48 do
     begin
     ltExcelSheet.Range['G'+inttostr(i)+':H'+inttostr(i)+''].Merge;
     end;

   ltExcelSheet.Range['B48:B48'].HorizontalAlignment := xlCenter;
   ltExcelSheet.Cells[48,2] := '총   계';

   ltExcelSheet.Range['A1:H52'].Borders[xlEdgeTop].LineStyle := xlContinuous;
   ltExcelSheet.Range['A1:H52'].Borders[xlEdgeTop].Weight := xlMedium;
   ltExcelSheet.Range['A1:H52'].Borders[xlEdgeTop].ColorIndex := xlAutomatic;

   ltExcelSheet.Range['A1:H52'].Borders[xlEdgeLeft].LineStyle := xlContinuous;
   ltExcelSheet.Range['A1:H52'].Borders[xlEdgeLeft].Weight := xlMedium;
   ltExcelSheet.Range['A1:H52'].Borders[xlEdgeLeft].ColorIndex := xlAutomatic;

   ltExcelSheet.Range['A1:H52'].Borders[xlEdgeBottom].LineStyle := xlContinuous;
   ltExcelSheet.Range['A1:H52'].Borders[xlEdgeBottom].Weight := xlMedium;
   ltExcelSheet.Range['A1:H52'].Borders[xlEdgeBottom].ColorIndex := xlAutomatic;

   ltExcelSheet.Range['A1:H52'].Borders[xlEdgeRight].LineStyle := xlContinuous;
   ltExcelSheet.Range['A1:H52'].Borders[xlEdgeRight].Weight := xlMedium;
   ltExcelSheet.Range['A1:H52'].Borders[xlEdgeRight].ColorIndex := xlAutomatic;

   ltExcelSheet.Range['D6:H10'].Borders[xlEdgeTop].LineStyle := xlContinuous;
   ltExcelSheet.Range['D6:H10'].Borders[xlEdgeTop].Weight := xlMedium;
   ltExcelSheet.Range['D6:H10'].Borders[xlEdgeTop].ColorIndex := xlAutomatic;

   ltExcelSheet.Range['D6:H10'].Borders[xlEdgeLeft].LineStyle := xlContinuous;
   ltExcelSheet.Range['D6:H10'].Borders[xlEdgeLeft].Weight := xlMedium;
   ltExcelSheet.Range['D6:H10'].Borders[xlEdgeLeft].ColorIndex := xlAutomatic;

   ltExcelSheet.Range['D6:H10'].Borders[xlEdgeBottom].LineStyle := xlContinuous;
   ltExcelSheet.Range['D6:H10'].Borders[xlEdgeBottom].Weight := xlMedium;
   ltExcelSheet.Range['D6:H10'].Borders[xlEdgeBottom].ColorIndex := xlAutomatic;

   ltExcelSheet.Range['D6:H10'].Borders[xlEdgeRight].LineStyle := xlContinuous;
   ltExcelSheet.Range['D6:H10'].Borders[xlEdgeRight].Weight := xlMedium;
   ltExcelSheet.Range['D6:H10'].Borders[xlEdgeRight].ColorIndex := xlAutomatic;

   ltExcelSheet.Range['B7:B7'].Borders[xlEdgeBottom].LineStyle := xlContinuous;
   ltExcelSheet.Range['B7:B7'].Borders[xlEdgeBottom].Weight := xlMedium;
   ltExcelSheet.Range['B7:B7'].Borders[xlEdgeBottom].ColorIndex := xlAutomatic;

   ltExcelSheet.Range['B10:B10'].Borders[xlEdgeBottom].LineStyle := xlContinuous;
   ltExcelSheet.Range['B10:B10'].Borders[xlEdgeBottom].Weight := xlMedium;
   ltExcelSheet.Range['B10:B10'].Borders[xlEdgeBottom].ColorIndex := xlAutomatic;

   ltExcelSheet.Range['D6:D10'].Borders[xlEdgeRight].LineStyle := xlContinuous;
   ltExcelSheet.Range['D6:D10'].Borders[xlEdgeRight].Weight := xlThin;
   ltExcelSheet.Range['D6:D10'].Borders[xlEdgeRight].ColorIndex := xlAutomatic;

   ltExcelSheet.Range['D6:D10'].Borders[xlInsideHorizontal].LineStyle := xlContinuous;
   ltExcelSheet.Range['D6:D10'].Borders[xlInsideHorizontal].Weight := xlThin;
   ltExcelSheet.Range['D6:D10'].Borders[xlInsideHorizontal].ColorIndex := xlAutomatic;

   ltExcelSheet.Range['E6:H6'].Borders[xlEdgeBottom].LineStyle := xlContinuous;
   ltExcelSheet.Range['E6:H6'].Borders[xlEdgeBottom].Weight := xlThin;
   ltExcelSheet.Range['E6:H6'].Borders[xlEdgeBottom].ColorIndex := xlAutomatic;

   ltExcelSheet.Range['E7:H7'].Borders[xlEdgeLeft].LineStyle := xlContinuous;
   ltExcelSheet.Range['E7:H7'].Borders[xlEdgeLeft].Weight := xlThin;
   ltExcelSheet.Range['E7:H7'].Borders[xlEdgeLeft].ColorIndex := xlAutomatic;

   ltExcelSheet.Range['E7:H7'].Borders[xlEdgeBottom].LineStyle := xlContinuous;
   ltExcelSheet.Range['E7:H7'].Borders[xlEdgeBottom].Weight := xlThin;
   ltExcelSheet.Range['E7:H7'].Borders[xlEdgeBottom].ColorIndex := xlAutomatic;

   ltExcelSheet.Range['E7:H7'].Borders[xlInsideVertical].LineStyle := xlContinuous;
   ltExcelSheet.Range['E7:H7'].Borders[xlInsideVertical].Weight := xlThin;
   ltExcelSheet.Range['E7:H7'].Borders[xlInsideVertical].ColorIndex := xlAutomatic;

   ltExcelSheet.Range['E8:H9'].Borders[xlEdgeBottom].LineStyle := xlContinuous;
   ltExcelSheet.Range['E8:H9'].Borders[xlEdgeBottom].Weight := xlThin;
   ltExcelSheet.Range['E8:H9'].Borders[xlEdgeBottom].ColorIndex := xlAutomatic;

   ltExcelSheet.Range['E10:H10'].Borders[xlInsideVertical].LineStyle := xlContinuous;
   ltExcelSheet.Range['E10:H10'].Borders[xlInsideVertical].Weight := xlThin;
   ltExcelSheet.Range['E10:H10'].Borders[xlInsideVertical].ColorIndex := xlAutomatic;

   ltExcelSheet.Range['A13:B13'].Borders[xlEdgeTop].LineStyle := xlContinuous;
   ltExcelSheet.Range['A13:B13'].Borders[xlEdgeTop].Weight := xlThin;

   ltExcelSheet.Range['A13:B13'].Borders[xlEdgeBottom].LineStyle := xlContinuous;
   ltExcelSheet.Range['A13:B13'].Borders[xlEdgeBottom].Weight := xlThin;

   ltExcelSheet.Range['B13:B13'].Borders[xlEdgeRight].LineStyle := xlContinuous;
   ltExcelSheet.Range['B13:B13'].Borders[xlEdgeRight].Weight := xlThin;

   ltExcelSheet.Range['C13:H13'].Borders[xlEdgeTop].LineStyle := xlContinuous;
   ltExcelSheet.Range['C13:H13'].Borders[xlEdgeTop].Weight := xlThin;

   ltExcelSheet.Range['C13:H13'].Borders[xlEdgeBottom].LineStyle := xlContinuous;
   ltExcelSheet.Range['C13:H13'].Borders[xlEdgeBottom].Weight := xlThin;

   ltExcelSheet.Range['C13:H13'].Borders[xlInsideVertical].LineStyle := xlContinuous;
   ltExcelSheet.Range['C13:H13'].Borders[xlInsideVertical].Weight := xlThin;

   ltExcelSheet.Range['A14:B47'].Borders[xlEdgeRight].LineStyle := xlContinuous;
   ltExcelSheet.Range['A14:B47'].Borders[xlEdgeRight].Weight := xlThin;

   ltExcelSheet.Range['A48:B48'].Borders[xlEdgeRight].LineStyle := xlContinuous;
   ltExcelSheet.Range['A48:B48'].Borders[xlEdgeRight].Weight := xlThin;

   ltExcelSheet.Range['C48:H48'].Borders[xlInsideVertical].LineStyle := xlContinuous;
   ltExcelSheet.Range['C48:H48'].Borders[xlInsideVertical].Weight := xlThin;

   ltExcelSheet.Range['C14:H47'].Borders[xlInsideVertical].LineStyle := xlContinuous;
   ltExcelSheet.Range['C14:H47'].Borders[xlInsideVertical].Weight := xlThin;

   ltExcelSheet.Range['A14:H47'].Borders[xlEdgeBottom].LineStyle := xlContinuous;
   ltExcelSheet.Range['A14:H47'].Borders[xlEdgeBottom].Weight := xlHairline;
   ltExcelSheet.Range['A14:H47'].Borders[xlEdgeBottom].ColorIndex := xlAutomatic;

   ltExcelSheet.Range['A14:H47'].Borders[xlInsideHorizontal].LineStyle := xlContinuous;
   ltExcelSheet.Range['A14:H47'].Borders[xlInsideHorizontal].Weight := xlHairline;
   ltExcelSheet.Range['A14:H47'].Borders[xlInsideHorizontal].ColorIndex := xlAutomatic;
   ltExcelSheet.Range['A14:H47'].Font.Size := 10;

   ltExcelSheet.Range['A48:H48'].Borders[xlEdgeTop].LineStyle := xlContinuous;
   ltExcelSheet.Range['A48:H48'].Borders[xlEdgeTop].Weight := xlMedium;

   ltExcelSheet.Range['A49:H52'].Borders[xlEdgeTop].LineStyle := xlContinuous;
   ltExcelSheet.Range['A49:H52'].Borders[xlEdgeTop].Weight := xlMedium;
   ltExcelSheet.Cells[50,2] := '◆ 기 타 사 항';
   ltExcelSheet.Cells[51,2] := '    월말 세금계산서 발행(거래명세서 첨부)';

   ltExcelSheet.Range['A13:H13'].Interior.ColorIndex := 40;
   ltExcelSheet.Range['A13:H13'].Interior.Pattern := xlSolid;
   ltExcelSheet.Range['A13:H13'].Interior.PatternColorIndex := xlAutomatic;


{    Rows("11:63").Select
    Selection.RowHeight = 13.5

    Rows("74:126").Select
    Selection.RowHeight = 13.5}
end;

end.
