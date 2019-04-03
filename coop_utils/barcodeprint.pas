unit barcodeprint;

interface
uses
  SysUtils, Dialogs, Math, XMLIntf, XMLDoc, ComObj, MSXML2_TLB, Classes;

{#########설정 xml파일 존재여부 확인###########
 param  : filename (String)  파일명
 return : Result (Boolean) 존재여부
}
function isExist(filename: string): Boolean;

{#########바코드 출력##########################
 param : printtype (String)  바코드종류
                             일반물품='goods'/소포장='pack'/바코드='box'/대차='car'
         code      (String)  출력 바코드
         name      (String)  출력명칭(물품명/매장명)
         cnt       (Integer) 출력장수
}
procedure printbarcode(printtype, code, name: string; cnt: Integer);

{#########XML 값불러서 세팅##########################
 param : printtype (String)  바코드종류
                             일반물품='goods'/소포장='pack'/바코드='box'/대차='car'
}
procedure printbarcode2(printtype, code, name: string; cnt, No: Integer);

{#########XML 값불러서 세팅##########################
 param : printtype (String)  바코드종류
                             일반물품='goods'/소포장='pack'/바코드='box'/대차='car'
}
procedure printbarcode3(printtype, mBarcode, mName, mKiftName: string; cnt, No: Integer);
// 박스바코드에 권역명칭이 추가된 함수 (name1:매장명, name2:권역명
{#########XML 값불러서 세팅##########################
 param : printtype (String)  바코드종류
                             일반물품='goods'/소포장='pack'/바코드='box'/대차='car'
}

{물품바코드}
procedure printbarcode4(printtype, code, name: string; cnt: Integer);



procedure setXMLbarcode(printtype: string);

{#########라벨 출력##########################
 param : lblX / lblY / lblsize         (String)  X축 / Y축 / 사이즈,
         lblrota / lblstyle / lblunder (Integer) 회전 / 스타일 / 밑줄,
         lblface / lblvalue            (String)  글자폰트 / 출력명칭
}

procedure setXMLbarcode2(printtype: string);

{#########라벨 출력##########################
 param : lblX / lblY / lblsize         (String)  X축 / Y축 / 사이즈,
         lblrota / lblstyle / lblunder (Integer) 회전 / 스타일 / 밑줄,
         lblface / lblvalue            (String)  글자폰트 / 출력명칭
}


procedure labelprint(lblX, lblY, lblsize: string; lblrota, lblstyle, lblunder: Integer; lblface, lblvalue: string);

{}
//procedure locationPrint(p_location:String);
procedure locationPrint(p_basicset, p_location: string; num: Variant);

{}

procedure pulmuBarcode(p_printer, p_bar, p_gcode, p_gname, p_bccode, p_jip, p_amount, p_day, p_cnt: string);
procedure FarmerBarcode(p_printer, p_bar, p_mname: string; p_side: Integer);

{냉동 박스바코드-코스명 추가}
procedure freBoxPrint(printtype, code, name, coname: string; cnt: Integer);
{냉동 생지박스바코드 추가}
procedure freBoxPrint2(printtype, code, name, mS_day, TotalNum, CurNum: string; cnt: Integer);

{입고확인서 임시}
procedure IpgoFarmBarcode(printtype, mG_name, mG_code, mE_day, mFc_name, mAmount, mBoxunit, mBarcode, mM_name, mLocation, mCount: string);
//ocedure IpgoFarmBarcode(printtype: String);

{센터피킹바코드}
procedure NorPaletteBarcode(printtype, mBarcode, mB_name, mB_day, mB_num: string);

{물품바코드}
procedure GoodsBarcode(printtype, mBarcode, mB_name, mB_day, mB_num: string);

{대차바코드}
procedure cartBarcode(printtype, p_bar, p_name: string);

var
  //xml
  filename: string;
  Doc: IXMLDOMDocument;
  Element: IXMLDOMElement;
  List: IXMLDOMNodeList;
  Loop: Integer;
  node: IXMLDOMNode;
  //바코드세팅값
  pagewidth, pageheight, pagespeed, pagedensity, pagesensor, pagevergap, pagesftdist, pageprint: string;
  dayX, dayY, daysize, dayrotate, dayoption, dayunderline: Integer; dayface, daychk: string;
  nameX, nameY, namesize, namerotate, nameoption, nameunderline: Integer; nameface, namechk: string;
  numX, numY, numsize, numrotate, numoption, numunderline: Integer; numface, numchk: string;
  barX, barY, bartype, barheight, barnarrow, barwide, barprintcnt, barrotate, barchk: string;
  //코스
  coX, coY, cosize, corotate, cooption, counderline: Integer; coface, cochk: string;

//바코드프린트 기본프로시져
procedure openport(PrinterName: pchar); stdcall; far; external 'tsclib.dll';
procedure closeport; external 'tsclib.dll';
procedure sendcommand(Command: pchar); stdcall; far; external 'tsclib.dll';
procedure setup(LabelWidth, LabelHeight, Speed, Density, Sensor, Vertical, Offset: string); stdcall; far; external 'tsclib.dll';
procedure downloadpcx(Filename, ImageName: pchar); stdcall; far; external 'tsclib.dll';
procedure barcode(X, Y, CodeType, Height, Readable, Rotation, Narrow, Wide, Code: pchar); stdcall; far; external 'tsclib.dll';
procedure printerfont(X, Y, FontName, Rotation, Xmul, Ymul, Content: pchar); stdcall; far; external 'tsclib.dll';
procedure clearbuffer; external 'tsclib.dll';
procedure printlabel(NumberOfSet, NumberOfCopoy: pchar); stdcall; far; external 'tsclib.dll';
procedure formfeed; external 'tsclib.dll';
procedure nobackfeed; external 'tsclib.dll';
procedure windowsfont(X, Y, FontHeight, Rotation, FontStyle, FontUnderline: integer; FaceName, TextContect: pchar); stdcall; far; external 'tsclib.dll';

implementation

uses Unit1;

{파일존재여부 확인}

function isExist(filename: string): Boolean;
begin
  if not FileExists(filename) then
  begin
    Result := false;
    exit;
  end;
  Result := true;
end;

{XML값불러서 세팅}

procedure setXMLbarcode(printtype: string);
var
  imsiElement: IXMLDOMElement;
  subname: string;
  f_version: string;
begin
  daychk := '0';
  namechk := '0';
  numchk := '0';
  cochk := '0';

    //xml 로드
  Doc := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
  Doc.load(filename);

  List := Doc.getElementsByTagName('set');

  Element := List.item[0] as IXMLDOMElement;

  //XML 버전확인
  f_version := Element.getAttribute('ver');
  if not (f_version = '201001151') then
  begin
    ShowMessage('설정이 변경되었습니다. 바코드프린터 설정프로그램에서 재설정 하십시오.');
    Form1.Close();
    exit;
  end;

  //기본용지설정값 로드
  //굳이 루프 안돌려도 상관없음.. 첫값이 페이지세팅값.
  for Loop := 0 to Element.childNodes.length - 1 do // 파라미터값.
  begin
    imsiElement := Element.childNodes.item[Loop] as IXMLDOMElement;
    if (imsiElement.attributes.length > 1) then
    begin
      if imsiElement.attributes.item[0].text = 'page' then
      begin
        pagewidth := imsiElement.childNodes.item[0].childNodes.item[0].text;
        pageheight := imsiElement.childNodes.item[1].childNodes.item[0].text;
        pagespeed := imsiElement.childNodes.item[2].childNodes.item[0].text;
        pagedensity := imsiElement.childNodes.item[3].childNodes.item[0].text;
        pagesensor := imsiElement.childNodes.item[4].childNodes.item[0].text;
        pagevergap := imsiElement.childNodes.item[5].childNodes.item[0].text;
        pagesftdist := imsiElement.childNodes.item[6].childNodes.item[0].text;
        pageprint := imsiElement.childNodes.item[7].childNodes.item[0].text;
      end;
    end;
  end;

  //기본용지 적용
  //openport('TSC TTP-246M Plus');
  openport(PChar(pageprint));
  clearbuffer;
  setup(pagewidth, pageheight, pagespeed, pagedensity, pagesensor, pagevergap, pagesftdist); //용지 설정
  closeport;


  //바코드 출력 타입(물품/소포장/박스/대차)에 따라 설정값 호출
  for Loop := 0 to Element.childNodes.length - 1 do // 파라미터값.
  begin
    imsiElement := Element.childNodes.item[Loop] as IXMLDOMElement;
    if (imsiElement.attributes.length > 1) then
    begin
      if imsiElement.attributes.item[1].text = printtype then
      begin
        subname := imsiElement.attributes.item[0].text;
        delete(subname, 1, 2);
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
            0: barrotate := '0';
            1: barrotate := '90';
            2: barrotate := '180';
            3: barrotate := '270';
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
end;


{XML값불러서 세팅}

procedure setXMLbarcode2(printtype: string);
var
  imsiElement: IXMLDOMElement;
  subname: string;
  f_version: string;
begin
  daychk := '0';
  namechk := '0';
  numchk := '0';
  cochk := '0';

    //xml 로드
  Doc := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
  Doc.load(filename);

  List := Doc.getElementsByTagName('set');

  Element := List.item[0] as IXMLDOMElement;

  //XML 버전확인
  f_version := Element.getAttribute('ver');
  if not (f_version = '201001151') then
  begin
    ShowMessage('설정이 변경되었습니다. 바코드프린터 설정프로그램에서 재설정 하십시오.');
    Form1.Close();
    exit;
  end;

  //기본용지설정값 로드
  //굳이 루프 안돌려도 상관없음.. 첫값이 페이지세팅값.
  for Loop := 0 to Element.childNodes.length - 1 do // 파라미터값.
  begin
    imsiElement := Element.childNodes.item[Loop] as IXMLDOMElement;
    if (imsiElement.attributes.length > 1) then
    begin
      if imsiElement.attributes.item[0].text = 'page' then
      begin
        pagewidth := imsiElement.childNodes.item[0].childNodes.item[0].text;
        pageheight := imsiElement.childNodes.item[1].childNodes.item[0].text;
        pagespeed := imsiElement.childNodes.item[2].childNodes.item[0].text;
        pagedensity := imsiElement.childNodes.item[3].childNodes.item[0].text;
        pagesensor := imsiElement.childNodes.item[4].childNodes.item[0].text;
        pagevergap := imsiElement.childNodes.item[5].childNodes.item[0].text;
        pagesftdist := imsiElement.childNodes.item[6].childNodes.item[0].text;
        pageprint := imsiElement.childNodes.item[7].childNodes.item[0].text;
      end;
    end;
  end;


  //기본용지 적용
  openport(PChar(pageprint));
  clearbuffer;
  setup(pagewidth, pageheight, pagespeed, pagedensity, pagesensor, pagevergap, pagesftdist); //용지 설정
  closeport;

  List := Doc.getElementsByTagName(printtype);
  if List.length = 0 then
  begin
    ShowMessage('[WMS바코드 프린트 설정] 프로그램을 이용하여 출력설정을 해주십시오.');
    Doc := nil;
    exit;
  end;

  Element := List.item[0] as IXMLDOMElement;

  for Loop := 0 to Element.childNodes.length - 1 do
  begin
    subname := Element.childNodes[Loop].nodeName;
    delete(subname, 1, 2);

    if subname = 'bar' then
    begin
      barX := Element.childNodes[Loop].childNodes.item[0].text;
      barY := Element.childNodes[Loop].childNodes.item[1].text;
      bartype := Element.childNodes[Loop].childNodes.item[2].text;
      barheight := Element.childNodes[Loop].childNodes.item[3].text;
      barnarrow := Element.childNodes[Loop].childNodes.item[4].text;
      barwide := Element.childNodes[Loop].childNodes.item[5].text;
      barprintcnt := Element.childNodes[Loop].childNodes.item[6].text;
      barrotate := Element.childNodes[Loop].childNodes.item[7].text;
      barchk := Element.childNodes[Loop].childNodes.item[8].text;
    end
    else if subname = 'name' then
    begin
      nameX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      nameY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      namesize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      nameoption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      nameunderline := StrToInt(Element.childNodes[Loop].childNodes.item[4].text);
      namerotate := StrToInt(Element.childNodes[Loop].childNodes.item[5].text);
      nameface := Element.childNodes[Loop].childNodes.item[6].text;
      namechk := Element.childNodes[Loop].childNodes.item[7].text;
    end
    else if subname = 'day' then
    begin
      dayX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      dayY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      daysize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      dayoption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      dayunderline := StrToInt(Element.childNodes[Loop].childNodes.item[4].text);
      dayrotate := StrToInt(Element.childNodes[Loop].childNodes.item[5].text);
      dayface := Element.childNodes[Loop].childNodes.item[6].text;
      daychk := Element.childNodes[Loop].childNodes.item[7].text;
    end
    else if subname = 'num' then
    begin
      numX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      numY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      numsize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      numoption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      numunderline := StrToInt(Element.childNodes[Loop].childNodes.item[4].text);
      numrotate := StrToInt(Element.childNodes[Loop].childNodes.item[5].text);
      numface := Element.childNodes[Loop].childNodes.item[6].text;
      numchk := Element.childNodes[Loop].childNodes.item[7].text;

    end
    else if subname = 'co' then
    begin
      coX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      coY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      cosize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      cooption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      counderline := StrToInt(Element.childNodes[Loop].childNodes.item[4].text);
      corotate := StrToInt(Element.childNodes[Loop].childNodes.item[5].text);
      coface := Element.childNodes[Loop].childNodes.item[6].text;
      cochk := Element.childNodes[Loop].childNodes.item[7].text;
    end;
  end;
  Doc := nil;
end;


procedure printbarcode(printtype, code, name: string; cnt: Integer);
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
  setXMLbarcode2(printtype);

  //명칭세팅
  nameX := 20;
  nameY := 250;
  namesize := 30;
  namerotate := 0;
  nameoption := 2;
  nameunderline := 0;
  nameface := 'HY견고딕';

  //바코드세팅
  barX := '20';
  barY := '70';
  bartype := '128';
  barheight := '150';
  barchk := '1';
  barrotate := '0';
  barnarrow := '3';
  barwide := '6';

  //출력
  openport(PChar(pageprint));
  clearbuffer;

  barcode(PChar(barX), PChar(barY), PChar(bartype), PChar(barheight), PChar(barchk), PChar(barrotate), PChar(barnarrow), PChar(barwide), PChar(code));
  labelprint(IntToStr(nameX), IntToStr(nameY), IntToStr(namesize), namerotate, nameoption, nameunderline, nameface, name);

  printlabel('1', PChar(IntToStr(cnt)));
  closeport;

end;

procedure printbarcode2(printtype, code, name: string; cnt, No: Integer);
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
  for count := 1 to cnt do
  begin
    //openport('TSC TTP-246M Plus');  //프린터 설정 TSC TTP-246M Plus
    //openport('TSC TDP-245');
    openport(PChar(pageprint));
    clearbuffer;

    //일자출력
    if daychk = '1' then
    begin
      labelprint(IntToStr(dayX), IntToStr(dayY), IntToStr(daysize), dayrotate, dayoption, dayunderline, dayface, FormatDateTime('yyyy/mm/dd hh:mm AM/PM', Now()));
    end;
    //매장명칭출력
    if namechk = '1' then
    begin
      labelprint(IntToStr(nameX), IntToStr(nameY), IntToStr(namesize), namerotate, nameoption, nameunderline, nameface, name);
    end;
    //넘버링출력
    if numchk = '1' then
    begin
      labelprint(IntToStr(numX), IntToStr(numY), IntToStr(numsize), numrotate, numoption, numunderline, numface, IntToStr(No));
    end;

    barcode(PChar(barX), PChar(barY), PChar(bartype), PChar(barheight), PChar(barchk), PChar(barrotate), PChar(barnarrow), PChar(barwide), PChar(code));

    printlabel('1', PChar(barprintcnt));
    closeport;
  end;

end;

procedure printbarcode3(printtype, mBarcode, mName, mKiftName: string; cnt, No: Integer);
var
  mReadable, mRotation, mNarrow, mWide, mType, mHeight, mCnt, mFace, mCheck: string;
  mX, mY, mSize, mFontOption, mRotate, mUnderline: Integer;
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
  openport(PChar(pageprint));
  clearbuffer;

  //xml 로드
  Doc := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
  Doc.load(filename);
  List := Doc.getElementsByTagName(printtype);
  if List.length = 0 then
  begin
    ShowMessage('[WMS바코드 프린트 설정] 프로그램을 이용하여 출력설정을 해주십시오.');
    Doc := nil;
    closeport;
    exit;
  end;

  Element := List.item[0] as IXMLDOMElement;

  for Loop := 0 to Element.childNodes.length - 1 do
  begin
    if Element.childNodes[Loop].nodeName = 'b_bar' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mType := Element.childNodes[Loop].childNodes.item[2].text;
      mHeight := Element.childNodes[Loop].childNodes.item[3].text;
      mNarrow := Element.childNodes[Loop].childNodes.item[4].text;
      mWide := Element.childNodes[Loop].childNodes.item[5].text;
      mCnt := Element.childNodes[Loop].childNodes.item[6].text;
      mRotation := Element.childNodes[Loop].childNodes.item[7].text;
      mReadable := Element.childNodes[Loop].childNodes.item[8].text;
      barcode(PChar(IntToStr(mX)), PChar(IntToStr(mY)), PChar(mType), PChar(mHeight), PChar(mReadable), PChar(mRotation), PChar(mNarrow), PChar(mWide), PCHAR(mBarcode));
      barcode(PChar(IntToStr(170)), PChar(IntToStr(20)), PChar(mType), PChar(IntToStr(50)), PChar(mReadable), PChar(IntToStr(0)), PChar(IntToStr(2)), PChar(IntToStr(1)), PCHAR(mBarcode));
    end
    else if ((Element.childNodes[Loop].nodeName = 'b_name') or (Element.childNodes[Loop].nodeName = 'b_day') or (Element.childNodes[Loop].nodeName = 'b_kift') or (Element.childNodes[Loop].nodeName = 'b_num')) then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      mUnderline := StrToInt(Element.childNodes[Loop].childNodes.item[4].text);
      mRotate := StrToInt(Element.childNodes[Loop].childNodes.item[5].text);
      mFace := Element.childNodes[Loop].childNodes.item[6].text;
      mCheck := Element.childNodes[Loop].childNodes.item[7].text;
      if (mcheck = '1') then
      begin
        if (Element.childNodes[Loop].nodeName = 'b_name') then
        begin
          windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY견고딕', PCHAR(mName));
          windowsfont(170, 100, 20, 0, 0, 0, 'HY견고딕', PCHAR(mName));
        end
{
        else if (Element.childNodes[Loop].nodeName = 'b_day') then
          windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY견고딕',PCHAR(FormatDateTime('yyyy/mm/dd hh:mm AM/PM',Now())))
         }
        else if (Element.childNodes[Loop].nodeName = 'b_kift') then
          windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY견고딕', PCHAR(mKiftName))
        else if (Element.childNodes[Loop].nodeName = 'b_num') then
          windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY견고딕', PCHAR(IntToStr(No)));
      end;

    end;

  end;
  Doc := nil;
  printlabel('1', PChar(mCnt));
  closeport;

end;

procedure printbarcode4(printtype, code, name: string; cnt: Integer);
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
  setXMLbarcode2(printtype);

  //출력
  for count := 1 to cnt do
  begin
    openport(PChar(pageprint));
    clearbuffer;

    //일자출력
    if daychk = '1' then
    begin
      labelprint(IntToStr(dayX), IntToStr(dayY), IntToStr(daysize), dayrotate, dayoption, dayunderline, dayface, FormatDateTime('yyyy/mm/dd hh:mm AM/PM', Now()));
    end;
    //매장명칭출력
    if namechk = '1' then
    begin
      labelprint(IntToStr(nameX), IntToStr(nameY), IntToStr(namesize), namerotate, nameoption, nameunderline, nameface, name);
    end;
{    //넘버링출력
    if numchk = '1' then
    begin
      labelprint(IntToStr(numX), IntToStr(numY), IntToStr(numsize), numrotate, numoption, numunderline, numface, IntToStr(No));
    end;
}
    barcode(PChar(barX), PChar(barY), PChar(bartype), PChar(barheight), PChar(barchk), PChar(barrotate), PChar(barnarrow), PChar(barwide), PChar(code));

    printlabel('1', PChar(barprintcnt));
    closeport;
  end;
end;




procedure freBoxPrint(printtype, code, name, coname: string; cnt: Integer);
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
  for count := 1 to cnt do
  begin
    openport(PChar(pageprint));
    clearbuffer;

    //일자출력
    if daychk = '1' then
    begin
      labelprint(IntToStr(dayX), IntToStr(dayY), IntToStr(daysize), dayrotate, dayoption, dayunderline, dayface, FormatDateTime('yyyy/mm/dd hh:mm AM/PM', Now()));
    end;
    //명칭출력
//    if namechk = '1' then
    if ((namechk = '1') and (name <> '')) then
    begin
      labelprint(IntToStr(nameX), IntToStr(nameY), IntToStr(namesize), namerotate, nameoption, nameunderline, nameface, name);
    end;
    //넘버링출력
    if numchk = '1' then
    begin
      labelprint(IntToStr(numX), IntToStr(numY), IntToStr(numsize), numrotate, numoption, numunderline, numface, IntToStr(count));
    end;
    //코스명출력
//    if cochk = '1' then
    if ((cochk = '1') and (coname <> '')) then
    begin
      labelprint(IntToStr(coX), IntToStr(coY), IntToStr(cosize), corotate, cooption, counderline, coface, coname);
    end;

    barcode(PChar(barX), PChar(barY), PChar(bartype), PChar(barheight), PChar(barchk), PChar(barrotate), PChar(barnarrow), PChar(barwide), PChar(code));

    printlabel('1', PChar(barprintcnt));
    closeport;
  end;
end;



procedure freBoxPrint2(printtype, code, name, mS_day, TotalNum, CurNum: string; cnt: Integer);
var
  count: Integer;
  bx, by, bt, bh, bc, br, bn, bw, bcode: string;
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
  //매장명
  //박스바코드
  //공급일자 / 세팅자
  //매장별 총집품수량
  //제트백 수량 (1-1,1-2,... ) 총집품수량 /20 = 제트백수량(올림)

  //바코드출력
  bx := '25';
  by := '10';
  bt := '128';
  bh := '120';
  bc := '1';
  br := '0';
  bn := '2';
  bw := '10';
  //입력바코드
  bcode := code;

  openport(PChar(pageprint));
  clearbuffer;

  barcode(PChar(bx), PChar(by), PChar(bt), PChar(bh), PChar(bc), PChar(br), PChar(bn), PChar(bw), PChar(bcode));
  //매장명
  labelprint('25', '190', '60', 0, 0, 0, 'HY견고딕', name);
  //공급일자
  labelprint('530', '20', '20', 0, 0, 0, 'HY견고딕', '공급일');
  labelprint('530', '40', '30', 0, 0, 0, 'HY견고딕', mS_day);
  //수량
  labelprint('530', '90', '20', 0, 0, 0, 'HY견고딕', '매장총집품수');
  labelprint('530', '110', '60', 0, 2, 0, 'HY견고딕', TotalNum);
  //담당자
  labelprint('450', '280', '30', 0, 0, 0, 'HY견고딕', '처리자:' + mpst_name);
  //순번
  labelprint('30', '280', '20', 0, 0, 0, 'HY견고딕', '순번');
  labelprint('80', '260', '60', 0, 2, 0, 'HY견고딕', CurNum);

  printlabel('1', PChar(barprintcnt));
  closeport;

end;


{라벨프린트 - 일자/명칭/넘버링}

procedure labelprint(lblX, lblY, lblsize: string; lblrota, lblstyle, lblunder: Integer; lblface, lblvalue: string);
var
  rotate: Integer;
begin
  rotate := 0;
  case lblrota of
    0: rotate := 0;
    1: rotate := 90;
    2: rotate := 180;
    3: rotate := 270;
  end;
  windowsfont(StrToInt(lblX), StrToInt(lblY), StrToInt(lblsize), rotate, lblstyle, lblunder, PChar(lblface), PChar(lblvalue));
end;


procedure locationPrint(p_basicset, p_location: string; num: Variant);
var
  lblx, lbly, lblsize, lblrotate, lbloption, lblunderline, lblface, lblCode: string;
  locax, locay, locatype, locaheight, locachk, locarotate, locanarrow, locawide, locaCode: string;
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

  printlabel('1', PChar(IntToStr(num)));
  closeport;

end;


//풀무바코드 출력

procedure pulmuBarcode(p_printer, p_bar, p_gcode, p_gname, p_bccode, p_jip, p_amount, p_day, p_cnt: string);
var
  pulwidth, pulheight, pulspeed, puldensity, pulsensor, pulvergap, pulsftdist, pulprint: string;
  bx, by, bt, bh, bc, br, bn, bw, bcode: string;
begin
  //전용 용지세팅
  pulwidth := '100';
  pulheight := '40';
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

  setup(pulwidth, pulheight, pulspeed, puldensity, pulsensor, pulvergap, pulsftdist); //용지 설정

  //출력
  //바코드출력
  bx := '25';
  by := '10';
  bt := '128';
  bh := '90';
  bc := '1';
  br := '0';
  bn := '2';
  bw := '10';
  //입력바코드
  bcode := p_bar;

  barcode(PChar(bx), PChar(by), PChar(bt), PChar(bh), PChar(bc), PChar(br), PChar(bn), PChar(bw), PChar(bcode));

  // 3차 수정된 2009.10.21 => 22일부터 출력된 라벨에 적용됨

  //물품코드 라벨
  labelprint('25', '125', '20', 0, 0, 0, 'HY견고딕', p_gcode); //  ('15', '170', '20', 0, 0, 0, 'HY견고딕', p_gcode);
  //물품명 라벨
  labelprint('25', '155', '40', 0, 0, 0, 'HY견고딕', p_gname); //('15', '200', '20', 0, 0, 0, 'HY견고딕', p_gname);
  //권역명칭 라벨
  labelprint('400', '20', '70', 0, 2, 0, 'HY견고딕', p_bccode); //('300', '40', '30', 0, 2, 0, 'HY견고딕', p_bccode);
  //집품군 라벨
  labelprint('25', '200', '20', 0, 0, 0, 'HY견고딕', '집품군 : ' + p_jip); //('15', '250', '20', 0, 0, 0, 'HY견고딕', p_jip);
  //수량 라벨
  labelprint('25', '230', '30', 0, 0, 0, 'HY견고딕', '수량'); //('15', '300', '30', 0, 2, 0, 'HY견고딕', p_amount);
  labelprint('115', '230', '70', 0, 2, 0, 'HY견고딕', p_amount); //('15', '300', '30', 0, 2, 0, 'HY견고딕', p_amount);
  //일자 라벨
  labelprint('355', '230', '30', 0, 0, 0, 'HY견고딕', '공급일'); //('15', '300', '30', 0, 2, 0, 'HY견고딕', p_amount);
  labelprint('460', '230', '70', 0, 2, 0, 'HY견고딕', p_day); //('300', '300', '30', 0, 2, 0, 'HY견고딕', p_day);




  //  barcode(PChar('10'), PChar('10'), PChar('128'), PChar('50'), PChar('0'), PChar('0'), PChar('1'), PChar('10'), PChar('12345'));
  //명칭출력
//  labelprint(lblx, lbly, lblsize, StrToInt(lblrotate), StrToInt(lbloption), StrToInt(lblunderline), lblface, lblCode);

  printlabel('1', PChar(p_cnt));

  closeport;

end;
{
procedure pulmuBarcode(p_printer, p_bar, p_gcode, p_gname, p_bccode, p_jip,p_amount,p_day,p_cnt:String);
var
    pulwidth, pulheight, pulspeed, puldensity, pulsensor, pulvergap, pulsftdist, pulprint:String;
    bx, by, bt, bh,bc, br,bn,bw, bcode:string;
begin
  //전용 용지세팅
  pulwidth := '83';
  pulheight := '53';
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
  bx := '25';
  by := '40';
  bt := '128';
  bh := '100';
  bc := '1';
  br := '0';
  bn := '2';
  bw := '10';
  //입력바코드
  bcode := p_bar;

  barcode(PChar(bx), PChar(by), PChar(bt), PChar(bh), PChar(bc), PChar(br), PChar(bn), PChar(bw), PChar(bcode));

  // 3차 수정된 2009.10.21 => 22일부터 출력된 라벨에 적용됨

  //물품코드 라벨
  labelprint('25', '170', '20', 0, 0, 0, 'HY견고딕', p_gcode); //  ('15', '170', '20', 0, 0, 0, 'HY견고딕', p_gcode);
  //물품명 라벨
  labelprint('25', '195', '40', 0, 0, 0, 'HY견고딕', p_gname); //('15', '200', '20', 0, 0, 0, 'HY견고딕', p_gname);
  //권역명칭 라벨
  labelprint('400', '60', '70', 0, 2, 0, 'HY견고딕', p_bccode);//('300', '40', '30', 0, 2, 0, 'HY견고딕', p_bccode);
  //집품군 라벨
  labelprint('25', '250', '25', 0, 0, 0, 'HY견고딕', '집품군 : ' + p_jip);//('15', '250', '20', 0, 0, 0, 'HY견고딕', p_jip);
  //수량 라벨
  labelprint('25', '290', '30', 0, 0, 0, 'HY견고딕', '수량');//('15', '300', '30', 0, 2, 0, 'HY견고딕', p_amount);
  labelprint('25', '320', '70', 0, 2, 0, 'HY견고딕', p_amount);//('15', '300', '30', 0, 2, 0, 'HY견고딕', p_amount);
  //일자 라벨
  labelprint('315', '290', '30', 0, 0, 0, 'HY견고딕', '일자');//('15', '300', '30', 0, 2, 0, 'HY견고딕', p_amount);
  labelprint('315', '320', '70', 0, 2, 0, 'HY견고딕', p_day);//('300', '300', '30', 0, 2, 0, 'HY견고딕', p_day);




  //  barcode(PChar('10'), PChar('10'), PChar('128'), PChar('50'), PChar('0'), PChar('0'), PChar('1'), PChar('10'), PChar('12345'));
  //명칭출력
//  labelprint(lblx, lbly, lblsize, StrToInt(lblrotate), StrToInt(lbloption), StrToInt(lblunderline), lblface, lblCode);

  printlabel('1',PChar(p_cnt));

  closeport;

end;
}

//풀무 생산자 라벨 출력

procedure FarmerBarcode(p_printer, p_bar, p_mname: string; p_side: Integer);
var
  pulwidth, pulheight, pulspeed, puldensity, pulsensor, pulvergap, pulsftdist, pulprint: string;
  bxL, bxR, by, bt, bh, bc, br, bn, bw: string;
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
  pulprint := p_printer;
//  pulprint := 'TSC TDP-245 Plus';
  openport(PChar(pulprint));

  clearbuffer;
  setup(pulwidth, pulheight, pulspeed, puldensity, pulsensor, pulvergap, pulsftdist); //용지 설정
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
        printlabel('1', PChar(IntToStr(1)));

      end;
    1:
      begin
        barcode(PChar(bxL), PChar(by), PChar(bt), PChar(bh), PChar(bc), PChar(br), PChar(bn), PChar(bw), PChar(p_bar)); //입력바코드
        labelprint(PChar(bxL), '120', '30', 0, 0, 0, 'HY견고딕', p_mname); //생산자명
        printlabel('1', PChar(IntToStr(1)));
      end;
    2:
      begin
        barcode(PChar(bxR), PChar(by), PChar(bt), PChar(bh), PChar(bc), PChar(br), PChar(bn), PChar(bw), PChar(p_bar)); //입력바코드
        labelprint(PChar(bxR), '120', '30', 0, 0, 0, 'HY견고딕', p_mname); //생산자명
        printlabel('1', PChar(IntToStr(1)));
      end;
  end;
  closeport;
end;

procedure IpgoFarmBarcode(printtype, mG_name, mG_code, mE_day, mFc_name, mAmount, mBoxunit, mBarcode, mM_name, mLocation, mCount: string);
var
  mReadable, mRotation, mNarrow, mWide, mType, mHeight: string;
  mX, mY, mSize, mFontOption: Integer;
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
  openport(PChar(pageprint));
  clearbuffer;

  //xml 로드
  Doc := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
  Doc.load(filename);
  List := Doc.getElementsByTagName(printtype);
  if List.length = 0 then
  begin
    ShowMessage('[WMS바코드 프린트 설정] 프로그램을 이용하여 출력설정을 해주십시오.');
    Doc := nil;
    closeport;
    exit;
  end;

  Element := List.item[0] as IXMLDOMElement;



  for Loop := 0 to Element.childNodes.length - 1 do
  begin
    if Element.childNodes[Loop].nodeName = 'b_bar' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mType := Element.childNodes[Loop].childNodes.item[2].text;
      mHeight := Element.childNodes[Loop].childNodes.item[3].text;
      mNarrow := Element.childNodes[Loop].childNodes.item[4].text;
      mWide := Element.childNodes[Loop].childNodes.item[5].text;
      mRotation := Element.childNodes[Loop].childNodes.item[7].text;
      mReadable := Element.childNodes[Loop].childNodes.item[8].text;
      barcode(PChar(IntToStr(mX)), PChar(IntToStr(mY)), PChar(mType), PChar(mHeight), PChar(mReadable), PChar(mRotation), PChar(mNarrow), PChar(mWide), PCHAR(mBarcode));
    end
    else if Element.childNodes[Loop].nodeName = 'g_name' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY견고딕', PCHAR(mG_name));
    end
    else if Element.childNodes[Loop].nodeName = 'g_code' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY견고딕', PCHAR('(' + mG_code + ')'));
    end
    else if Element.childNodes[Loop].nodeName = 'enf_day' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      windowsfont(mX, mY, 20, 0, mFontOption, 0, 'HY견고딕', PCHAR('입고일'));
      windowsfont(mX + 20, mY + 20, mSize, 0, mFontOption, 0, 'HY견고딕', PCHAR(mE_day));
    end
    else if Element.childNodes[Loop].nodeName = 'fc_name' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      windowsfont(mX, mY, mSize, 0, mFontOption, 0, '굴림', PCHAR('산 지 명:'));
      windowsfont(mX + 110, mY, mSize, 0, mFontOption, 0, 'HY견고딕', PCHAR(mFc_name));
    end
    else if Element.childNodes[Loop].nodeName = 'amount' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      windowsfont(mX, mY, 20, 0, mFontOption, 0, 'HY견고딕', PCHAR('입고수량'));
      windowsfont(mX, mY + 20, mSize, 0, mFontOption, 0, 'HY견고딕', PCHAR(mAmount));
    end
    else if Element.childNodes[Loop].nodeName = 'boxunit' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      windowsfont(mX, mY, mSize, 0, 0, 0, '굴림', PCHAR('박스입수'));
      windowsfont(mX + 110, mY, mSize, 0, mFontOption, 0, 'HY견고딕', PCHAR(mBoxunit));
    end
    else if Element.childNodes[Loop].nodeName = 'location' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      windowsfont(mX, mY, mSize, 0, 0, 0, '굴림', PCHAR('로케이션:'));
      windowsfont(mX + 110, mY, mSize, 0, mFontOption, 0, 'HY견고딕', PCHAR(mLocation));
    end
    else if Element.childNodes[Loop].nodeName = 'mpst_name' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      windowsfont(mX, mY, 25, 0, 0, 0, '굴림', PCHAR('검수자'));
      windowsfont(mX, mY + 25, mSize, 0, mFontOption, 0, 'HY견고딕', PCHAR(mM_name));
    end
    else if Element.childNodes[Loop].nodeName = 'title' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY견고딕', PCHAR('입고확인서'));
    end;
  end;
  Doc := nil;
  printlabel('1', PChar(mCount));
  closeport;
end;

procedure GoodsBarcode(printtype, mBarcode, mB_name, mB_day, mB_num: string);
var
  mReadable, mRotation, mNarrow, mWide, mType, mHeight, mCnt, mCheck: string;
  mX, mY, mSize, mFontOption: Integer;
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
  openport(PChar(pageprint));
  clearbuffer;

  //xml 로드
  Doc := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
  Doc.load(filename);
  List := Doc.getElementsByTagName(printtype);
  if List.length = 0 then
  begin
    ShowMessage('[WMS바코드 프린트 설정] 프로그램을 이용하여 출력설정을 해주십시오.');
    Doc := nil;
    closeport;
    exit;
  end;

  Element := List.item[0] as IXMLDOMElement;

  for Loop := 0 to Element.childNodes.length - 1 do
  begin
    if Element.childNodes[Loop].nodeName = 'g_bar' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mType := Element.childNodes[Loop].childNodes.item[2].text;
      mHeight := Element.childNodes[Loop].childNodes.item[3].text;
      mNarrow := Element.childNodes[Loop].childNodes.item[4].text;
      mWide := Element.childNodes[Loop].childNodes.item[5].text;
      mCnt := Element.childNodes[Loop].childNodes.item[6].text;
      mRotation := Element.childNodes[Loop].childNodes.item[7].text;
      mReadable := Element.childNodes[Loop].childNodes.item[8].text;
      barcode(PChar(IntToStr(mX)), PChar(IntToStr(mY)), PChar(mType), PChar(mHeight), PChar(mReadable), PChar(mRotation), PChar(mNarrow), PChar(mWide), PCHAR(mBarcode));
    end
    else if Element.childNodes[Loop].nodeName = 'g_name' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      mCheck := Element.childNodes[Loop].childNodes.item[4].text;
      if (mcheck = '1') then
        windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY견고딕', PCHAR(mB_name));
    end
    else if Element.childNodes[Loop].nodeName = 'g_day' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      mcheck := Element.childNodes[Loop].childNodes.item[4].text;
      if (mcheck = '1') then
        windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY견고딕', PCHAR('공급일:' + mB_day));
    end
    else if Element.childNodes[Loop].nodeName = 'g_num' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := 0;
      mcheck := Element.childNodes[Loop].childNodes.item[3].text;
      if (mcheck = '1') then
        windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY견고딕', PCHAR(mB_num));
    end
  end;
  Doc := nil;
  printlabel('1', PChar(mCnt));
  closeport;

end;


procedure NorPaletteBarcode(printtype, mBarcode, mB_name, mB_day, mB_num: string);
var
  mReadable, mRotation, mNarrow, mWide, mType, mHeight, mCnt, mCheck: string;
  mX, mY, mSize, mFontOption: Integer;
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
  openport(PChar(pageprint));
  clearbuffer;

  //xml 로드
  Doc := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
  Doc.load(filename);
  List := Doc.getElementsByTagName(printtype);
  if List.length = 0 then
  begin
    ShowMessage('[WMS바코드 프린트 설정] 프로그램을 이용하여 출력설정을 해주십시오.');
    Doc := nil;
    closeport;
    exit;
  end;

  Element := List.item[0] as IXMLDOMElement;

  for Loop := 0 to Element.childNodes.length - 1 do
  begin
    if Element.childNodes[Loop].nodeName = 'b_bar' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mType := Element.childNodes[Loop].childNodes.item[2].text;
      mHeight := Element.childNodes[Loop].childNodes.item[3].text;
      mNarrow := Element.childNodes[Loop].childNodes.item[4].text;
      mWide := Element.childNodes[Loop].childNodes.item[5].text;
      mCnt := Element.childNodes[Loop].childNodes.item[6].text;
      mRotation := Element.childNodes[Loop].childNodes.item[7].text;
      mReadable := Element.childNodes[Loop].childNodes.item[8].text;
      barcode(PChar(IntToStr(mX)), PChar(IntToStr(mY)), PChar(mType), PChar(mHeight), PChar(mReadable), PChar(mRotation), PChar(mNarrow), PChar(mWide), PCHAR(mBarcode));
      barcode(PChar(IntToStr(170)), PChar(IntToStr(240)), PChar(mType), PChar(IntToStr(40)), PChar(mReadable), PChar(IntToStr(0)), PChar(IntToStr(2)), PChar(mWide), PCHAR(mBarcode));
    end
    else if Element.childNodes[Loop].nodeName = 'b_name' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      mCheck := Element.childNodes[Loop].childNodes.item[4].text;
      if (mcheck = '1') then
        windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY견고딕', PCHAR(mB_name));
    end
    else if Element.childNodes[Loop].nodeName = 'b_day' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      mcheck := Element.childNodes[Loop].childNodes.item[4].text;
      if (mcheck = '1') then
        windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY견고딕', PCHAR('공급일:' + mB_day));
    end
    else if Element.childNodes[Loop].nodeName = 'b_num' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := 0;
      mcheck := Element.childNodes[Loop].childNodes.item[3].text;
      if (mcheck = '1') then
        windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY견고딕', PCHAR(mB_num));
    end
  end;
  Doc := nil;
  printlabel('1', PChar(mCnt));
  closeport;

end;

//대차 바코드 출력

procedure cartBarcode(printtype, p_bar, p_name: string);
var
  bx, by, bt, bh, bc, br, bn, bw, bcode: string;
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
  openport(PChar(pageprint));
  clearbuffer;


  //출력
  //바코드출력
  bx := '150';
  by := '30';
  bt := '128'; //barcode type
  bh := '100'; //barcode height
  bc := '1'; //barcode Readable
  br := '0'; //barcode rotate
  bn := '2'; //barcode Narrow
  bw := '10'; //barcode Wide

  //입력바코드
  bcode := p_bar;

  barcode(PChar(bx), PChar(by), PChar(bt), PChar(bh), PChar(bc), PChar(br), PChar(bn), PChar(bw), PChar(bcode));
  barcode(PChar(IntToStr(100)), PChar(IntToStr(30)), PChar(bt), PChar(IntToStr(80)), PChar(bc), PChar(IntToStr(90)), PChar(FloatToStr(1)), PChar(IntToStr(1)), PChar(bcode));

  //명칭출력
  labelprint('150', '200', '60', 0, 0, 0, 'HY견고딕', p_name);
  labelprint('640', '290', '20', 0, 1, 0, 'HY견고딕', '대차바코드');

  printlabel('1', PChar(IntToStr(1)));

  closeport;

end;

end.
