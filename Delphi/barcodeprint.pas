unit barcodeprint;

interface
uses
SysUtils, Dialogs, Math, XMLIntf,  XMLDoc,  ComObj,  MSXML2_TLB, Classes;

{#########설정 xml파일 존재여부 확인###########
 param  : filename (String)  파일명
 return : Result (Boolean) 존재여부
}
function isExist(filename:String): Boolean;

{#########바코드 출력##########################
 param : printtype (String)  바코드종류
                             일반물품='goods'/소포장='pack'/바코드='box'/대차='car'
         code      (String)  출력 바코드
         name      (String)  출력명칭(물품명/매장명)
         cnt       (Integer) 출력장수
}
procedure printbarcode(printtype, code, name:String; cnt:Integer);

{#########XML 값불러서 세팅##########################
 param : printtype (String)  바코드종류
                             일반물품='goods'/소포장='pack'/바코드='box'/대차='car'
}
procedure printbarcode2(printtype, code, name:String; cnt, No:Integer);

{#########XML 값불러서 세팅##########################
 param : printtype (String)  바코드종류
                             일반물품='goods'/소포장='pack'/바코드='box'/대차='car'
}
procedure setXMLbarcode(printtype:String);

{#########라벨 출력##########################
 param : lblX / lblY / lblsize         (String)  X축 / Y축 / 사이즈,
         lblrota / lblstyle / lblunder (Integer) 회전 / 스타일 / 밑줄,
         lblface / lblvalue            (String)  글자폰트 / 출력명칭
}
procedure labelprint(lblX, lblY, lblsize:String; lblrota, lblstyle, lblunder:Integer; lblface, lblvalue: String);

{}
//procedure locationPrint(p_location:String);
procedure locationPrint(p_basicset, p_location:String; num:Variant);

{}

procedure pulmuBarcode(p_printer,p_bar, p_gcode, p_gname, p_bccode, p_jip,p_amount,p_day,p_cnt:String);
procedure FarmerBarcode(p_bar, p_mname, p_cnt:String;p_side:Integer);


{냉동 박스바코드-코스명 추가}
procedure freBoxPrint(printtype, code, name, coname:String; cnt:Integer);

var
  //xml
  filename: String;
  Doc: IXMLDOMDocument;
  Element: IXMLDOMElement;
  List: IXMLDOMNodeList;
  Loop : Integer;
  node : IXMLDOMNode;
  //바코드세팅값
  pagewidth, pageheight, pagespeed, pagedensity, pagesensor, pagevergap, pagesftdist, pageprint: String;
  dayX, dayY, daysize, dayrotate, dayoption, dayunderline: Integer; dayface, daychk: String;
  nameX, nameY, namesize, namerotate, nameoption, nameunderline: Integer; nameface, namechk: String;
  numX, numY, numsize, numrotate, numoption, numunderline: Integer; numface, numchk: String;
  barX, barY, bartype, barheight, barnarrow, barwide, barprintcnt, barrotate, barchk: String;
  //코스
  coX, coY, cosize, corotate, cooption, counderline: Integer; coface, cochk: String;

//바코드프린트 기본프로시져
procedure openport(PrinterName:pchar);stdcall;far;external 'tsclib.dll';
procedure closeport; external 'tsclib.dll';
procedure sendcommand(Command:pchar);stdcall;far;external 'tsclib.dll';
procedure setup(LabelWidth, LabelHeight, Speed, Density, Sensor, Vertical, Offset:String);stdcall; far; external 'tsclib.dll';
procedure downloadpcx(Filename,ImageName:pchar);stdcall;far; external 'tsclib.dll';
procedure barcode(X, Y, CodeType, Height, Readable, Rotation, Narrow, Wide, Code :pchar); stdcall; far; external 'tsclib.dll';
procedure printerfont(X, Y, FontName, Rotation, Xmul, Ymul, Content:pchar); stdcall;far; external 'tsclib.dll';
procedure clearbuffer; external 'tsclib.dll';
procedure printlabel(NumberOfSet, NumberOfCopoy:pchar);stdcall; far; external 'tsclib.dll';
procedure formfeed; external 'tsclib.dll';
procedure nobackfeed; external 'tsclib.dll';
procedure windowsfont (X, Y, FontHeight, Rotation, FontStyle, FontUnderline : integer; FaceName, TextContect:pchar);stdcall;far;external 'tsclib.dll';

implementation

uses Unit1;

{파일존재여부 확인}
function isExist(filename:String): Boolean;
begin
  if Not FileExists(filename) then
  begin
    Result := false;
    exit;
  end;
  Result := true;
end;

{XML값불러서 세팅}
procedure setXMLbarcode(printtype:String);
var
    imsiElement: IXMLDOMElement;
    subname: String;
    f_version: String;
begin
  daychk := '0';
  namechk := '0';
  numchk := '0';
  cochk := '0';

    //xml 로드
  Doc := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
  Doc.load(filename);

  List := Doc.getElementsByTagName('set');

  Element := List.item[0] As IXMLDOMElement;

  //XML 버전확인
  f_version := Element.getAttribute('ver');
  if not(f_version = '20090907') then
  begin
    ShowMessage('설정이 변경되었습니다. 바코드프린터 설정프로그램에서 재설정 하십시오.');
    Form1.Close();
    exit;
  end;

  //기본용지설정값 로드
  //굳이 루프 안돌려도 상관없음.. 첫값이 페이지세팅값.
  for Loop := 0 to Element.childNodes.length -1 do  // 파라미터값.
  begin
    imsiElement := Element.childNodes.item[Loop] As IXMLDOMElement;
    if imsiElement.attributes.item[0].text = 'page' then
    begin
      pagewidth := imsiElement.childNodes.item[0].childNodes.item[0].text;
      pageheight := imsiElement.childNodes.item[1].childNodes.item[0].text;
      pagespeed := imsiElement.childNodes.item[2].childNodes.item[0].text;
      pagedensity := imsiElement.childNodes.item[3].childNodes.item[0].text;
      pagesensor := imsiElement.childNodes.item[4].childNodes.item[0].text;
      pagevergap := imsiElement.childNodes.item[5].childNodes.item[0].text;
      pagesftdist := imsiElement.childNodes.item[6].childNodes.item[0].text;
      pageprint := imsiElement.childNodes.item[8].childNodes.item[0].text;
    end;
  end;

  //기본용지 적용
  //openport('TSC TTP-246M Plus');
  openport(PChar(pageprint));
  clearbuffer;
  setup(pagewidth, pageheight, pagespeed, pagedensity, pagesensor, pagevergap, pagesftdist);  //용지 설정
  closeport;


  //바코드 출력 타입(물품/소포장/박스/대차)에 따라 설정값 호출
  for Loop := 0 to Element.childNodes.length -1 do  // 파라미터값.
  begin
    imsiElement := Element.childNodes.item[Loop] As IXMLDOMElement;

    if imsiElement.attributes.item[1].text = printtype then
    begin
      subname := imsiElement.attributes.item[0].text;
      delete(subname,1,2);
      //짤라서 구분함
      if subname = 'bar' then
      begin
        barX := imsiElement.childNodes.item[0].childNodes.item[0].text;
        barY := imsiElement.childNodes.item[1].childNodes.item[0].text;
        bartype := imsiElement.childNodes.item[2].childNodes.item[0].text;
        barheight := imsiElement.childNodes.item[3].childNodes.item[0].text;
        barnarrow := imsiElement.childNodes.item[4].childNodes.item[0].text;
        barwide := imsiElement.childNodes.item[5].childNodes.item[0].text;
        barprintcnt := imsiElement.childNodes.item[6].childNodes.item[0].text;
        barrotate := imsiElement.childNodes.item[7].childNodes.item[0].text;
        case StrToInt(imsiElement.childNodes.item[7].childNodes.item[0].text) of
          0 : barrotate := '0';
          1 : barrotate := '90';
          2 : barrotate := '180';
          3 : barrotate := '270';
        end;
        barchk := imsiElement.childNodes.item[8].childNodes.item[0].text;
      end
      else if subname = 'name' then
      begin
        nameX := StrToInt(imsiElement.childNodes.item[0].childNodes.item[0].text);
        nameY := StrToInt(imsiElement.childNodes.item[1].childNodes.item[0].text);
        namesize := StrToInt(imsiElement.childNodes.item[2].childNodes.item[0].text);
        nameoption := StrToInt(imsiElement.childNodes.item[3].childNodes.item[0].text);
        nameunderline := StrToInt(imsiElement.childNodes.item[4].childNodes.item[0].text);
        namerotate := StrToInt(imsiElement.childNodes.item[5].childNodes.item[0].text);
        nameface := imsiElement.childNodes.item[6].childNodes.item[0].text;
        namechk := imsiElement.childNodes.item[7].childNodes.item[0].text;
      end
      else if subname = 'day' then
      begin
        dayX := StrToInt(imsiElement.childNodes.item[0].childNodes.item[0].text);
        dayY := StrToInt(imsiElement.childNodes.item[1].childNodes.item[0].text);
        daysize := StrToInt(imsiElement.childNodes.item[2].childNodes.item[0].text);
        dayoption := StrToInt(imsiElement.childNodes.item[3].childNodes.item[0].text);
        dayunderline := StrToInt(imsiElement.childNodes.item[4].childNodes.item[0].text);
        dayrotate := StrToInt(imsiElement.childNodes.item[5].childNodes.item[0].text);
        dayface := imsiElement.childNodes.item[6].childNodes.item[0].text;
        daychk := imsiElement.childNodes.item[7].childNodes.item[0].text;
      end
      else if subname = 'num' then
      begin
        numX := StrToInt(imsiElement.childNodes.item[0].childNodes.item[0].text);
        numY := StrToInt(imsiElement.childNodes.item[1].childNodes.item[0].text);
        numsize := StrToInt(imsiElement.childNodes.item[2].childNodes.item[0].text);
        numoption := StrToInt(imsiElement.childNodes.item[3].childNodes.item[0].text);
        numunderline := StrToInt(imsiElement.childNodes.item[4].childNodes.item[0].text);
        numrotate := StrToInt(imsiElement.childNodes.item[5].childNodes.item[0].text);
        numface := imsiElement.childNodes.item[6].childNodes.item[0].text;
        numchk := imsiElement.childNodes.item[7].childNodes.item[0].text;
      end
      else if subname = 'co' then
      begin
        coX := StrToInt(imsiElement.childNodes.item[0].childNodes.item[0].text);
        coY := StrToInt(imsiElement.childNodes.item[1].childNodes.item[0].text);
        cosize := StrToInt(imsiElement.childNodes.item[2].childNodes.item[0].text);
        cooption := StrToInt(imsiElement.childNodes.item[3].childNodes.item[0].text);
        counderline := StrToInt(imsiElement.childNodes.item[4].childNodes.item[0].text);
        corotate := StrToInt(imsiElement.childNodes.item[5].childNodes.item[0].text);
        coface := imsiElement.childNodes.item[6].childNodes.item[0].text;
        cochk := imsiElement.childNodes.item[7].childNodes.item[0].text;
      end;
    end;
  end;
end;

procedure printbarcode(printtype, code, name:String; cnt:Integer);
var
    count: Integer;
begin
  //파일명 설정
  filename := 'barcodeprint.xml';

  //설정파일 존재여부 체크
  if not isExist(filename) then
  begin
    ShowMessage('[WMS바코드 프린트 설정] 프로그램을 이용하여 출력설정을 해주십시오.');
    exit;
  end;

  //XML값 불러와 세팅
  setXMLbarcode(printtype);

  //출력
  for count:=1 to cnt do
  begin
    //openport('TSC TTP-246M Plus');  //프린터 설정 TSC TTP-246M Plus
    //openport('TSC TDP-245');
    openport(PChar(pageprint));
    clearbuffer;

    //일자출력
    if daychk = '1' then
    begin
      labelprint(IntToStr(dayX), IntToStr(dayY), IntToStr(daysize), dayrotate, dayoption, dayunderline, dayface, FormatDateTime('yyyy/mm/dd hh:mm AM/PM',Now()));
    end;
    //명칭출력
    if namechk = '1' then
    begin
      labelprint(IntToStr(nameX), IntToStr(nameY), IntToStr(namesize), namerotate, nameoption, nameunderline, nameface, name);
    end;
    //넘버링출력
    if numchk = '1' then
    begin
      labelprint(IntToStr(numX), IntToStr(numY), IntToStr(numsize), numrotate, numoption, numunderline, numface, IntToStr(count));
    end;

    barcode(PChar(barX), PChar(barY), PChar(bartype), PChar(barheight), PChar(barchk), PChar(barrotate), PChar(barnarrow), PChar(barwide), PChar(code));

    printlabel('1',PChar(barprintcnt));
    closeport;
  end;

end;

procedure printbarcode2(printtype, code, name:String; cnt, No:Integer);
var
    count: Integer;
begin
  //파일명 설정
  filename := 'barcodeprint.xml';

  //설정파일 존재여부 체크
  if not isExist(filename) then
  begin
    ShowMessage('[WMS바코드 프린트 설정] 프로그램을 이용하여 출력설정을 해주십시오.');
    exit;
  end;

  //XML값 불러와 세팅
  setXMLbarcode(printtype);

  //출력
  for count:=1 to cnt do
  begin
    //openport('TSC TTP-246M Plus');  //프린터 설정 TSC TTP-246M Plus
    //openport('TSC TDP-245');
    openport(PChar(pageprint));
    clearbuffer;

    //일자출력
    if daychk = '1' then
    begin
      labelprint(IntToStr(dayX), IntToStr(dayY), IntToStr(daysize), dayrotate, dayoption, dayunderline, dayface, FormatDateTime('yyyy/mm/dd hh:mm AM/PM',Now()));
    end;
    //명칭출력
    if namechk = '1' then
    begin
      labelprint(IntToStr(nameX), IntToStr(nameY), IntToStr(namesize), namerotate, nameoption, nameunderline, nameface, name);
    end;
    //넘버링출력
    if numchk = '1' then
    begin
//      labelprint(IntToStr(numX), IntToStr(numY), IntToStr(numsize), numrotate, numoption, numunderline, numface, IntToStr(count));
      labelprint(IntToStr(numX), IntToStr(numY), IntToStr(numsize), numrotate, numoption, numunderline, numface, IntToStr(No));
    end;

    barcode(PChar(barX), PChar(barY), PChar(bartype), PChar(barheight), PChar(barchk), PChar(barrotate), PChar(barnarrow), PChar(barwide), PChar(code));

    printlabel('1',PChar(barprintcnt));
    closeport;
  end;

end;


procedure freBoxPrint(printtype, code, name, coname:String; cnt:Integer);
var
    count: Integer;
    f_version: String;
begin
  //파일명 설정
  filename := 'barcodeprint.xml';

  //설정파일 존재여부 체크
  if not isExist(filename) then
  begin
    ShowMessage('[WMS바코드 프린트 설정] 프로그램을 이용하여 출력설정을 해주십시오.');
    exit;
  end;

  //XML값 불러와 세팅
  setXMLbarcode(printtype);

  //출력
  for count:=1 to cnt do
  begin
    //openport('TSC TTP-246M Plus');  //프린터 설정 TSC TTP-246M Plus
    //openport('TSC TDP-245');
    openport(PChar(pageprint));
    clearbuffer;

    //일자출력
    if daychk = '1' then
    begin
      labelprint(IntToStr(dayX), IntToStr(dayY), IntToStr(daysize), dayrotate, dayoption, dayunderline, dayface, FormatDateTime('yyyy/mm/dd hh:mm AM/PM',Now()));
    end;
    //명칭출력
    if namechk = '1' then
    begin
      labelprint(IntToStr(nameX), IntToStr(nameY), IntToStr(namesize), namerotate, nameoption, nameunderline, nameface, name);
    end;
    //넘버링출력
    if numchk = '1' then
    begin
      labelprint(IntToStr(numX), IntToStr(numY), IntToStr(numsize), numrotate, numoption, numunderline, numface, IntToStr(count));
    end;
    //코스명출력
    if cochk = '1' then
    begin
      labelprint(IntToStr(coX), IntToStr(coY), IntToStr(cosize), corotate, cooption, counderline, coface, coname);
    end;

    barcode(PChar(barX), PChar(barY), PChar(bartype), PChar(barheight), PChar(barchk), PChar(barrotate), PChar(barnarrow), PChar(barwide), PChar(code));

    printlabel('1',PChar(barprintcnt));
    closeport;
  end;
end;

{라벨프린트 - 일자/명칭/넘버링}
procedure labelprint(lblX, lblY, lblsize:String; lblrota, lblstyle, lblunder:Integer; lblface, lblvalue: String);
var
    rotate:Integer;
begin
 case lblrota of
    0 : rotate := 0;
    1 : rotate := 90;
    2 : rotate := 180;
    3 : rotate := 270;
 end;
 windowsfont(StrToInt(lblX), StrToInt(lblY), StrToInt(lblsize), rotate, lblstyle, lblunder, PChar(lblface), PChar(lblvalue));
end;


procedure locationPrint(p_basicset, p_location:String; num:Variant);
var
  lblx,lbly,lblsize,lblrotate,lbloption,lblunderline,lblface,lblCode: String;
  locax,locay,locatype,locaheight,locachk,locarotate,locanarrow,locawide,locaCode: String;
begin
  //파일명 설정
  filename := 'barcodeprint.xml';

  //설정파일 존재여부 체크
  if not isExist(filename) then
  begin
    ShowMessage('[WMS바코드 프린트 설정] 프로그램을 이용하여 출력설정을 해주십시오.');
    exit;
  end;

  //XML값 불러와 세팅
  setXMLbarcode(p_basicset);

  //명칭세팅
  lblx := '330';
  lbly := '90';
  lblsize := '100';
  lblrotate := '0';
  lbloption := '2';
  lblunderline := '0';
  lblface := 'HY견고딕';
//  lblCode := p_loca + '-' + p_rack + '-' + p_step;
  lblCode := p_location;
  //바코드세팅
  locax := '20';
  locay := '70';
  locatype := '128';
  locaheight := '150';
  locachk := '0';
  locarotate := '0';
  locanarrow := '3';
  locawide := '10';
  locaCode := lblCode;

  //출력
  openport(PChar(pageprint));
  clearbuffer;

  //명칭출력
  labelprint(lblx, lbly, lblsize, StrToInt(lblrotate), StrToInt(lbloption), StrToInt(lblunderline), lblface, lblCode);
  //바코드출력
  barcode(PChar(locax), PChar(locay), PChar(locatype), PChar(locaheight), PChar(locachk), PChar(locarotate), PChar(locanarrow), PChar(locawide), PChar(locaCode));

  printlabel('1',PChar(IntToStr(num)));
  closeport;

end;


//풀무바코드 출력
procedure pulmuBarcode(p_printer, p_bar, p_gcode, p_gname, p_bccode, p_jip,p_amount,p_day,p_cnt:String);
var
    pulwidth, pulheight, pulspeed, puldensity, pulsensor, pulvergap, pulsftdist, pulprint:String;
    bx, by, bt, bh,bc, br,bn,bw, bcode:string;
begin
  //전용 용지세팅
  pulwidth := '83';
  pulheight := '56';
  pulspeed := '3';
  puldensity := '3';
  pulsensor := '0';
  pulvergap := '2';
  pulsftdist := '0';
  //바코드프린터 입력하도록
  pulprint := p_printer;

  //openport('TSC TTP-246M Plus');
  openport(PChar(pulprint));

  clearbuffer;

  setup(pulwidth, pulheight, pulspeed, puldensity, pulsensor, pulvergap, pulsftdist);  //용지 설정

  //출력
  //바코드출력
  bx := '15';
  by := '50';
  bt := '128';
  bh := '100';
  bc := '1';
  br := '0';
  bn := '2';
  bw := '10';
  //입력바코드
  bcode := p_bar;

  barcode(PChar(bx), PChar(by), PChar(bt), PChar(bh), PChar(bc), PChar(br), PChar(bn), PChar(bw), PChar(bcode));

//  labelprint(lblX, lblY, lblsize:String; lblrota, lblstyle, lblunder:Integer; lblface, lblvalue: String);
  //물품코드 라벨
  labelprint('15', '180', '20', 0, 0, 0, 'HY견고딕', p_gcode); //  ('15', '170', '20', 0, 0, 0, 'HY견고딕', p_gcode);
  //물품명 라벨
  labelprint('15', '200', '40', 0, 0, 0, 'HY견고딕', p_gname); //('15', '200', '20', 0, 0, 0, 'HY견고딕', p_gname);
  //권역명칭 라벨
  labelprint('390', '70', '70', 0, 2, 0, 'HY견고딕', p_bccode);//('300', '40', '30', 0, 2, 0, 'HY견고딕', p_bccode);
  //집품군 라벨
  labelprint('15', '280', '25', 0, 0, 0, 'HY견고딕', '집품군 : ' + p_jip);//('15', '250', '20', 0, 0, 0, 'HY견고딕', p_jip);
  //수량 라벨
  labelprint('15', '320', '30', 0, 0, 0, 'HY견고딕', '수량');//('15', '300', '30', 0, 2, 0, 'HY견고딕', p_amount);
  labelprint('15', '350', '70', 0, 2, 0, 'HY견고딕', p_amount);//('15', '300', '30', 0, 2, 0, 'HY견고딕', p_amount);
  //일자 라벨
  labelprint('300', '320', '30', 0, 0, 0, 'HY견고딕', '일자');//('15', '300', '30', 0, 2, 0, 'HY견고딕', p_amount);
  labelprint('300', '350', '70', 0, 2, 0, 'HY견고딕', p_day);//('300', '300', '30', 0, 2, 0, 'HY견고딕', p_day);



  //  barcode(PChar('10'), PChar('10'), PChar('128'), PChar('50'), PChar('0'), PChar('0'), PChar('1'), PChar('10'), PChar('12345'));
  //명칭출력
//  labelprint(lblx, lbly, lblsize, StrToInt(lblrotate), StrToInt(lbloption), StrToInt(lblunderline), lblface, lblCode);

  printlabel('1',PChar(p_cnt));

  closeport;

end;

//풀무 생산자 라벨 출력
procedure FarmerBarcode(p_bar, p_mname, p_cnt:String;p_side:Integer);
var
    pulwidth, pulheight, pulspeed, puldensity, pulsensor, pulvergap, pulsftdist, pulprint:String;
    bxL,bxR, by, bt, bh,bc, br,bn,bw, bcode:string;
begin
  //전용 용지세팅
  pulwidth := '100';
  pulheight := '23';
  pulspeed := '3';
  puldensity := '3';
  pulsensor := '0';
  pulvergap := '2';
  pulsftdist := '0';

  //바코드프린터 입력하도록
  pulprint := 'TSC TDP-245 Plus';

  openport(PChar(pulprint));

  clearbuffer;

  setup(pulwidth, pulheight, pulspeed, puldensity, pulsensor, pulvergap, pulsftdist);  //용지 설정

  //출력
  //바코드출력
  bxL := '80';
  bxR := '480';
  by := '20';
  bt := '128';
  bh := '72';
  bc := '1';
  br := '0';
  bn := '2';
  bw := '10';

  case p_side of
    0:
      begin
        barcode(PChar(bxL), PChar(by), PChar(bt), PChar(bh), PChar(bc), PChar(br), PChar(bn), PChar(bw), PChar(p_bar)); //입력바코드
        labelprint(PChar(bxL), '120', '30', 0, 0, 0, 'HY견고딕', p_mname); //생산자명
        barcode(PChar(bxR), PChar(by), PChar(bt), PChar(bh), PChar(bc), PChar(br), PChar(bn), PChar(bw), PChar(p_bar)); //입력바코드
        labelprint(PChar(bxR), '120', '30', 0, 0, 0, 'HY견고딕', p_mname); //생산자명
        printlabel('1',PChar(p_cnt));

      end;
    1:
      begin
        barcode(PChar(bxL), PChar(by), PChar(bt), PChar(bh), PChar(bc), PChar(br), PChar(bn), PChar(bw), PChar(p_bar)); //입력바코드
        labelprint(PChar(bxL), '120', '30', 0, 0, 0, 'HY견고딕', p_mname); //생산자명
        printlabel('1',PChar(p_cnt));
      end;
    2:
      begin
        barcode(PChar(bxR), PChar(by), PChar(bt), PChar(bh), PChar(bc), PChar(br), PChar(bn), PChar(bw), PChar(p_bar)); //입력바코드
        labelprint(PChar(bxR), '120', '30', 0, 0, 0, 'HY견고딕', p_mname); //생산자명
        printlabel('1',PChar(p_cnt));
      end;
  end;    
  closeport;
end;
end.
