unit barcodeprint;

interface
uses
  SysUtils, Dialogs, Math, XMLIntf, XMLDoc, ComObj, MSXML2_TLB, Classes;

{#########���� xml���� ���翩�� Ȯ��###########
 param  : filename (String)  ���ϸ�
 return : Result (Boolean) ���翩��
}
function isExist(filename: string): Boolean;

{#########���ڵ� ���##########################
 param : printtype (String)  ���ڵ�����
                             �Ϲݹ�ǰ='goods'/������='pack'/���ڵ�='box'/����='car'
         code      (String)  ��� ���ڵ�
         name      (String)  ��¸�Ī(��ǰ��/�����)
         cnt       (Integer) ������
}
procedure printbarcode(printtype, code, name: string; cnt: Integer);

{#########XML ���ҷ��� ����##########################
 param : printtype (String)  ���ڵ�����
                             �Ϲݹ�ǰ='goods'/������='pack'/���ڵ�='box'/����='car'
}
procedure printbarcode2(printtype, code, name: string; cnt, No: Integer);

{#########XML ���ҷ��� ����##########################
 param : printtype (String)  ���ڵ�����
                             �Ϲݹ�ǰ='goods'/������='pack'/���ڵ�='box'/����='car'
}
procedure printbarcode3(printtype, mBarcode, mName, mKiftName: string; cnt, No: Integer);
// �ڽ����ڵ忡 �ǿ���Ī�� �߰��� �Լ� (name1:�����, name2:�ǿ���
{#########XML ���ҷ��� ����##########################
 param : printtype (String)  ���ڵ�����
                             �Ϲݹ�ǰ='goods'/������='pack'/���ڵ�='box'/����='car'
}

{��ǰ���ڵ�}
procedure printbarcode4(printtype, code, name: string; cnt: Integer);



procedure setXMLbarcode(printtype: string);

{#########�� ���##########################
 param : lblX / lblY / lblsize         (String)  X�� / Y�� / ������,
         lblrota / lblstyle / lblunder (Integer) ȸ�� / ��Ÿ�� / ����,
         lblface / lblvalue            (String)  ������Ʈ / ��¸�Ī
}

procedure setXMLbarcode2(printtype: string);

{#########�� ���##########################
 param : lblX / lblY / lblsize         (String)  X�� / Y�� / ������,
         lblrota / lblstyle / lblunder (Integer) ȸ�� / ��Ÿ�� / ����,
         lblface / lblvalue            (String)  ������Ʈ / ��¸�Ī
}


procedure labelprint(lblX, lblY, lblsize: string; lblrota, lblstyle, lblunder: Integer; lblface, lblvalue: string);

{}
//procedure locationPrint(p_location:String);
procedure locationPrint(p_basicset, p_location: string; num: Variant);

{}

procedure pulmuBarcode(p_printer, p_bar, p_gcode, p_gname, p_bccode, p_jip, p_amount, p_day, p_cnt: string);
procedure FarmerBarcode(p_printer, p_bar, p_mname: string; p_side: Integer);

{�õ� �ڽ����ڵ�-�ڽ��� �߰�}
procedure freBoxPrint(printtype, code, name, coname: string; cnt: Integer);
{�õ� �����ڽ����ڵ� �߰�}
procedure freBoxPrint2(printtype, code, name, mS_day, TotalNum, CurNum: string; cnt: Integer);

{�԰�Ȯ�μ� �ӽ�}
procedure IpgoFarmBarcode(printtype, mG_name, mG_code, mE_day, mFc_name, mAmount, mBoxunit, mBarcode, mM_name, mLocation, mCount: string);
//ocedure IpgoFarmBarcode(printtype: String);

{������ŷ���ڵ�}
procedure NorPaletteBarcode(printtype, mBarcode, mB_name, mB_day, mB_num: string);

{��ǰ���ڵ�}
procedure GoodsBarcode(printtype, mBarcode, mB_name, mB_day, mB_num: string);

{�������ڵ�}
procedure cartBarcode(printtype, p_bar, p_name: string);

var
  //xml
  filename: string;
  Doc: IXMLDOMDocument;
  Element: IXMLDOMElement;
  List: IXMLDOMNodeList;
  Loop: Integer;
  node: IXMLDOMNode;
  //���ڵ弼�ð�
  pagewidth, pageheight, pagespeed, pagedensity, pagesensor, pagevergap, pagesftdist, pageprint: string;
  dayX, dayY, daysize, dayrotate, dayoption, dayunderline: Integer; dayface, daychk: string;
  nameX, nameY, namesize, namerotate, nameoption, nameunderline: Integer; nameface, namechk: string;
  numX, numY, numsize, numrotate, numoption, numunderline: Integer; numface, numchk: string;
  barX, barY, bartype, barheight, barnarrow, barwide, barprintcnt, barrotate, barchk: string;
  //�ڽ�
  coX, coY, cosize, corotate, cooption, counderline: Integer; coface, cochk: string;

//���ڵ�����Ʈ �⺻���ν���
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

{�������翩�� Ȯ��}

function isExist(filename: string): Boolean;
begin
  if not FileExists(filename) then
  begin
    Result := false;
    exit;
  end;
  Result := true;
end;

{XML���ҷ��� ����}

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

    //xml �ε�
  Doc := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
  Doc.load(filename);

  List := Doc.getElementsByTagName('set');

  Element := List.item[0] as IXMLDOMElement;

  //XML ����Ȯ��
  f_version := Element.getAttribute('ver');
  if not (f_version = '201001151') then
  begin
    ShowMessage('������ ����Ǿ����ϴ�. ���ڵ������� �������α׷����� �缳�� �Ͻʽÿ�.');
    Form1.Close();
    exit;
  end;

  //�⺻���������� �ε�
  //���� ���� �ȵ����� �������.. ù���� ���������ð�.
  for Loop := 0 to Element.childNodes.length - 1 do // �Ķ���Ͱ�.
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

  //�⺻���� ����
  //openport('TSC TTP-246M Plus');
  openport(PChar(pageprint));
  clearbuffer;
  setup(pagewidth, pageheight, pagespeed, pagedensity, pagesensor, pagevergap, pagesftdist); //���� ����
  closeport;


  //���ڵ� ��� Ÿ��(��ǰ/������/�ڽ�/����)�� ���� ������ ȣ��
  for Loop := 0 to Element.childNodes.length - 1 do // �Ķ���Ͱ�.
  begin
    imsiElement := Element.childNodes.item[Loop] as IXMLDOMElement;
    if (imsiElement.attributes.length > 1) then
    begin
      if imsiElement.attributes.item[1].text = printtype then
      begin
        subname := imsiElement.attributes.item[0].text;
        delete(subname, 1, 2);
        //©�� ������
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


{XML���ҷ��� ����}

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

    //xml �ε�
  Doc := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
  Doc.load(filename);

  List := Doc.getElementsByTagName('set');

  Element := List.item[0] as IXMLDOMElement;

  //XML ����Ȯ��
  f_version := Element.getAttribute('ver');
  if not (f_version = '201001151') then
  begin
    ShowMessage('������ ����Ǿ����ϴ�. ���ڵ������� �������α׷����� �缳�� �Ͻʽÿ�.');
    Form1.Close();
    exit;
  end;

  //�⺻���������� �ε�
  //���� ���� �ȵ����� �������.. ù���� ���������ð�.
  for Loop := 0 to Element.childNodes.length - 1 do // �Ķ���Ͱ�.
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


  //�⺻���� ����
  openport(PChar(pageprint));
  clearbuffer;
  setup(pagewidth, pageheight, pagespeed, pagedensity, pagesensor, pagevergap, pagesftdist); //���� ����
  closeport;

  List := Doc.getElementsByTagName(printtype);
  if List.length = 0 then
  begin
    ShowMessage('[WMS���ڵ� ����Ʈ ����] ���α׷��� �̿��Ͽ� ��¼����� ���ֽʽÿ�.');
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
  //���ϸ� ����
  filename := 'barcodeprint.xml';

  //�������� ���翩�� üũ
  if not isExist(filename) then
  begin
    ShowMessage('[WMS���ڵ� ����Ʈ ����] ���α׷��� �̿��Ͽ� ��¼����� ���ֽʽÿ�.');
    exit;
  end;

  //XML�� �ҷ��� ����
  setXMLbarcode2(printtype);

  //��Ī����
  nameX := 20;
  nameY := 250;
  namesize := 30;
  namerotate := 0;
  nameoption := 2;
  nameunderline := 0;
  nameface := 'HY�߰��';

  //���ڵ弼��
  barX := '20';
  barY := '70';
  bartype := '128';
  barheight := '150';
  barchk := '1';
  barrotate := '0';
  barnarrow := '3';
  barwide := '6';

  //���
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
  //���ϸ� ����
  filename := 'barcodeprint.xml';

  //�������� ���翩�� üũ
  if not isExist(filename) then
  begin
    ShowMessage('[WMS���ڵ� ����Ʈ ����] ���α׷��� �̿��Ͽ� ��¼����� ���ֽʽÿ�.');
    exit;
  end;

  //XML�� �ҷ��� ����
  setXMLbarcode(printtype);

  //���
  for count := 1 to cnt do
  begin
    //openport('TSC TTP-246M Plus');  //������ ���� TSC TTP-246M Plus
    //openport('TSC TDP-245');
    openport(PChar(pageprint));
    clearbuffer;

    //�������
    if daychk = '1' then
    begin
      labelprint(IntToStr(dayX), IntToStr(dayY), IntToStr(daysize), dayrotate, dayoption, dayunderline, dayface, FormatDateTime('yyyy/mm/dd hh:mm AM/PM', Now()));
    end;
    //�����Ī���
    if namechk = '1' then
    begin
      labelprint(IntToStr(nameX), IntToStr(nameY), IntToStr(namesize), namerotate, nameoption, nameunderline, nameface, name);
    end;
    //�ѹ������
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

  //���ϸ� ����
  filename := 'barcodeprint.xml';

  //�������� ���翩�� üũ
  if not isExist(filename) then
  begin
    ShowMessage('[WMS���ڵ� ����Ʈ ����] ���α׷��� �̿��Ͽ� ��¼����� ���ֽʽÿ�.');
    exit;
  end;

  //XML�� �ҷ��� ����
  setXMLbarcode(printtype);
  openport(PChar(pageprint));
  clearbuffer;

  //xml �ε�
  Doc := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
  Doc.load(filename);
  List := Doc.getElementsByTagName(printtype);
  if List.length = 0 then
  begin
    ShowMessage('[WMS���ڵ� ����Ʈ ����] ���α׷��� �̿��Ͽ� ��¼����� ���ֽʽÿ�.');
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
          windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY�߰��', PCHAR(mName));
          windowsfont(170, 100, 20, 0, 0, 0, 'HY�߰��', PCHAR(mName));
        end
{
        else if (Element.childNodes[Loop].nodeName = 'b_day') then
          windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY�߰��',PCHAR(FormatDateTime('yyyy/mm/dd hh:mm AM/PM',Now())))
         }
        else if (Element.childNodes[Loop].nodeName = 'b_kift') then
          windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY�߰��', PCHAR(mKiftName))
        else if (Element.childNodes[Loop].nodeName = 'b_num') then
          windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY�߰��', PCHAR(IntToStr(No)));
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
  //���ϸ� ����
  filename := 'barcodeprint.xml';

  //�������� ���翩�� üũ
  if not isExist(filename) then
  begin
    ShowMessage('[WMS���ڵ� ����Ʈ ����] ���α׷��� �̿��Ͽ� ��¼����� ���ֽʽÿ�.');
    exit;
  end;

  //XML�� �ҷ��� ����
  setXMLbarcode2(printtype);

  //���
  for count := 1 to cnt do
  begin
    openport(PChar(pageprint));
    clearbuffer;

    //�������
    if daychk = '1' then
    begin
      labelprint(IntToStr(dayX), IntToStr(dayY), IntToStr(daysize), dayrotate, dayoption, dayunderline, dayface, FormatDateTime('yyyy/mm/dd hh:mm AM/PM', Now()));
    end;
    //�����Ī���
    if namechk = '1' then
    begin
      labelprint(IntToStr(nameX), IntToStr(nameY), IntToStr(namesize), namerotate, nameoption, nameunderline, nameface, name);
    end;
{    //�ѹ������
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
  //���ϸ� ����
  filename := 'barcodeprint.xml';

  //�������� ���翩�� üũ
  if not isExist(filename) then
  begin
    ShowMessage('[WMS���ڵ� ����Ʈ ����] ���α׷��� �̿��Ͽ� ��¼����� ���ֽʽÿ�.');
    exit;
  end;

  //XML�� �ҷ��� ����
  setXMLbarcode(printtype);

  //���
  for count := 1 to cnt do
  begin
    openport(PChar(pageprint));
    clearbuffer;

    //�������
    if daychk = '1' then
    begin
      labelprint(IntToStr(dayX), IntToStr(dayY), IntToStr(daysize), dayrotate, dayoption, dayunderline, dayface, FormatDateTime('yyyy/mm/dd hh:mm AM/PM', Now()));
    end;
    //��Ī���
//    if namechk = '1' then
    if ((namechk = '1') and (name <> '')) then
    begin
      labelprint(IntToStr(nameX), IntToStr(nameY), IntToStr(namesize), namerotate, nameoption, nameunderline, nameface, name);
    end;
    //�ѹ������
    if numchk = '1' then
    begin
      labelprint(IntToStr(numX), IntToStr(numY), IntToStr(numsize), numrotate, numoption, numunderline, numface, IntToStr(count));
    end;
    //�ڽ������
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
  //���ϸ� ����
  filename := 'barcodeprint.xml';

  //�������� ���翩�� üũ
  if not isExist(filename) then
  begin
    ShowMessage('[WMS���ڵ� ����Ʈ ����] ���α׷��� �̿��Ͽ� ��¼����� ���ֽʽÿ�.');
    exit;
  end;

  //XML�� �ҷ��� ����
  setXMLbarcode(printtype);

  //���
  //�����
  //�ڽ����ڵ�
  //�������� / ������
  //���庰 ����ǰ����
  //��Ʈ�� ���� (1-1,1-2,... ) ����ǰ���� /20 = ��Ʈ�����(�ø�)

  //���ڵ����
  bx := '25';
  by := '10';
  bt := '128';
  bh := '120';
  bc := '1';
  br := '0';
  bn := '2';
  bw := '10';
  //�Է¹��ڵ�
  bcode := code;

  openport(PChar(pageprint));
  clearbuffer;

  barcode(PChar(bx), PChar(by), PChar(bt), PChar(bh), PChar(bc), PChar(br), PChar(bn), PChar(bw), PChar(bcode));
  //�����
  labelprint('25', '190', '60', 0, 0, 0, 'HY�߰��', name);
  //��������
  labelprint('530', '20', '20', 0, 0, 0, 'HY�߰��', '������');
  labelprint('530', '40', '30', 0, 0, 0, 'HY�߰��', mS_day);
  //����
  labelprint('530', '90', '20', 0, 0, 0, 'HY�߰��', '��������ǰ��');
  labelprint('530', '110', '60', 0, 2, 0, 'HY�߰��', TotalNum);
  //�����
  labelprint('450', '280', '30', 0, 0, 0, 'HY�߰��', 'ó����:' + mpst_name);
  //����
  labelprint('30', '280', '20', 0, 0, 0, 'HY�߰��', '����');
  labelprint('80', '260', '60', 0, 2, 0, 'HY�߰��', CurNum);

  printlabel('1', PChar(barprintcnt));
  closeport;

end;


{������Ʈ - ����/��Ī/�ѹ���}

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
  //���ϸ� ����
  filename := 'barcodeprint.xml';

  //�������� ���翩�� üũ
  if not isExist(filename) then
  begin
    ShowMessage('[WMS���ڵ� ����Ʈ ����] ���α׷��� �̿��Ͽ� ��¼����� ���ֽʽÿ�.');
    exit;
  end;

  //XML�� �ҷ��� ����
  setXMLbarcode(p_basicset);

  //��Ī����
  lblx := '330';
  lbly := '90';
  lblsize := '100';
  lblrotate := '0';
  lbloption := '2';
  lblunderline := '0';
  lblface := 'HY�߰��';
//  lblCode := p_loca + '-' + p_rack + '-' + p_step;
  lblCode := p_location;
  //���ڵ弼��
  locax := '20';
  locay := '70';
  locatype := '128';
  locaheight := '150';
  locachk := '0';
  locarotate := '0';
  locanarrow := '3';
  locawide := '10';
  locaCode := lblCode;

  //���
  openport(PChar(pageprint));
  clearbuffer;

  //��Ī���
  labelprint(lblx, lbly, lblsize, StrToInt(lblrotate), StrToInt(lbloption), StrToInt(lblunderline), lblface, lblCode);
  //���ڵ����
  barcode(PChar(locax), PChar(locay), PChar(locatype), PChar(locaheight), PChar(locachk), PChar(locarotate), PChar(locanarrow), PChar(locawide), PChar(locaCode));

  printlabel('1', PChar(IntToStr(num)));
  closeport;

end;


//Ǯ�����ڵ� ���

procedure pulmuBarcode(p_printer, p_bar, p_gcode, p_gname, p_bccode, p_jip, p_amount, p_day, p_cnt: string);
var
  pulwidth, pulheight, pulspeed, puldensity, pulsensor, pulvergap, pulsftdist, pulprint: string;
  bx, by, bt, bh, bc, br, bn, bw, bcode: string;
begin
  //���� ��������
  pulwidth := '100';
  pulheight := '40';
  pulspeed := '3';
  puldensity := '3';
  pulsensor := '0';
  pulvergap := '2';
  pulsftdist := '0';

  //���ڵ������� �Է��ϵ���
  pulprint := p_printer;

  //openport('TSC TTP-246M Plus');
  openport(PChar(pulprint));

  clearbuffer;

  setup(pulwidth, pulheight, pulspeed, puldensity, pulsensor, pulvergap, pulsftdist); //���� ����

  //���
  //���ڵ����
  bx := '25';
  by := '10';
  bt := '128';
  bh := '90';
  bc := '1';
  br := '0';
  bn := '2';
  bw := '10';
  //�Է¹��ڵ�
  bcode := p_bar;

  barcode(PChar(bx), PChar(by), PChar(bt), PChar(bh), PChar(bc), PChar(br), PChar(bn), PChar(bw), PChar(bcode));

  // 3�� ������ 2009.10.21 => 22�Ϻ��� ��µ� �󺧿� �����

  //��ǰ�ڵ� ��
  labelprint('25', '125', '20', 0, 0, 0, 'HY�߰��', p_gcode); //  ('15', '170', '20', 0, 0, 0, 'HY�߰��', p_gcode);
  //��ǰ�� ��
  labelprint('25', '155', '40', 0, 0, 0, 'HY�߰��', p_gname); //('15', '200', '20', 0, 0, 0, 'HY�߰��', p_gname);
  //�ǿ���Ī ��
  labelprint('400', '20', '70', 0, 2, 0, 'HY�߰��', p_bccode); //('300', '40', '30', 0, 2, 0, 'HY�߰��', p_bccode);
  //��ǰ�� ��
  labelprint('25', '200', '20', 0, 0, 0, 'HY�߰��', '��ǰ�� : ' + p_jip); //('15', '250', '20', 0, 0, 0, 'HY�߰��', p_jip);
  //���� ��
  labelprint('25', '230', '30', 0, 0, 0, 'HY�߰��', '����'); //('15', '300', '30', 0, 2, 0, 'HY�߰��', p_amount);
  labelprint('115', '230', '70', 0, 2, 0, 'HY�߰��', p_amount); //('15', '300', '30', 0, 2, 0, 'HY�߰��', p_amount);
  //���� ��
  labelprint('355', '230', '30', 0, 0, 0, 'HY�߰��', '������'); //('15', '300', '30', 0, 2, 0, 'HY�߰��', p_amount);
  labelprint('460', '230', '70', 0, 2, 0, 'HY�߰��', p_day); //('300', '300', '30', 0, 2, 0, 'HY�߰��', p_day);




  //  barcode(PChar('10'), PChar('10'), PChar('128'), PChar('50'), PChar('0'), PChar('0'), PChar('1'), PChar('10'), PChar('12345'));
  //��Ī���
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
  //���� ��������
  pulwidth := '83';
  pulheight := '53';
  pulspeed := '3';
  puldensity := '3';
  pulsensor := '0';
  pulvergap := '2';
  pulsftdist := '0';
  //���ڵ������� �Է��ϵ���
  pulprint := p_printer;

  //openport('TSC TTP-246M Plus');
  openport(PChar(pulprint));

  clearbuffer;

  setup(pulwidth, pulheight, pulspeed, puldensity, pulsensor, pulvergap, pulsftdist);  //���� ����

  //���
  //���ڵ����
  bx := '25';
  by := '40';
  bt := '128';
  bh := '100';
  bc := '1';
  br := '0';
  bn := '2';
  bw := '10';
  //�Է¹��ڵ�
  bcode := p_bar;

  barcode(PChar(bx), PChar(by), PChar(bt), PChar(bh), PChar(bc), PChar(br), PChar(bn), PChar(bw), PChar(bcode));

  // 3�� ������ 2009.10.21 => 22�Ϻ��� ��µ� �󺧿� �����

  //��ǰ�ڵ� ��
  labelprint('25', '170', '20', 0, 0, 0, 'HY�߰��', p_gcode); //  ('15', '170', '20', 0, 0, 0, 'HY�߰��', p_gcode);
  //��ǰ�� ��
  labelprint('25', '195', '40', 0, 0, 0, 'HY�߰��', p_gname); //('15', '200', '20', 0, 0, 0, 'HY�߰��', p_gname);
  //�ǿ���Ī ��
  labelprint('400', '60', '70', 0, 2, 0, 'HY�߰��', p_bccode);//('300', '40', '30', 0, 2, 0, 'HY�߰��', p_bccode);
  //��ǰ�� ��
  labelprint('25', '250', '25', 0, 0, 0, 'HY�߰��', '��ǰ�� : ' + p_jip);//('15', '250', '20', 0, 0, 0, 'HY�߰��', p_jip);
  //���� ��
  labelprint('25', '290', '30', 0, 0, 0, 'HY�߰��', '����');//('15', '300', '30', 0, 2, 0, 'HY�߰��', p_amount);
  labelprint('25', '320', '70', 0, 2, 0, 'HY�߰��', p_amount);//('15', '300', '30', 0, 2, 0, 'HY�߰��', p_amount);
  //���� ��
  labelprint('315', '290', '30', 0, 0, 0, 'HY�߰��', '����');//('15', '300', '30', 0, 2, 0, 'HY�߰��', p_amount);
  labelprint('315', '320', '70', 0, 2, 0, 'HY�߰��', p_day);//('300', '300', '30', 0, 2, 0, 'HY�߰��', p_day);




  //  barcode(PChar('10'), PChar('10'), PChar('128'), PChar('50'), PChar('0'), PChar('0'), PChar('1'), PChar('10'), PChar('12345'));
  //��Ī���
//  labelprint(lblx, lbly, lblsize, StrToInt(lblrotate), StrToInt(lbloption), StrToInt(lblunderline), lblface, lblCode);

  printlabel('1',PChar(p_cnt));

  closeport;

end;
}

//Ǯ�� ������ �� ���

procedure FarmerBarcode(p_printer, p_bar, p_mname: string; p_side: Integer);
var
  pulwidth, pulheight, pulspeed, puldensity, pulsensor, pulvergap, pulsftdist, pulprint: string;
  bxL, bxR, by, bt, bh, bc, br, bn, bw: string;
begin
  //���� ��������
  pulwidth := '100';
  pulheight := '23';
  pulspeed := '3';
  puldensity := '3';
  pulsensor := '0';
  pulvergap := '2';
  pulsftdist := '0';

  //���ڵ������� �Է��ϵ���
  pulprint := p_printer;
//  pulprint := 'TSC TDP-245 Plus';
  openport(PChar(pulprint));

  clearbuffer;
  setup(pulwidth, pulheight, pulspeed, puldensity, pulsensor, pulvergap, pulsftdist); //���� ����
  //���
  //���ڵ����
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
        barcode(PChar(bxL), PChar(by), PChar(bt), PChar(bh), PChar(bc), PChar(br), PChar(bn), PChar(bw), PChar(p_bar)); //�Է¹��ڵ�
        labelprint(PChar(bxL), '120', '30', 0, 0, 0, 'HY�߰��', p_mname); //�����ڸ�
        barcode(PChar(bxR), PChar(by), PChar(bt), PChar(bh), PChar(bc), PChar(br), PChar(bn), PChar(bw), PChar(p_bar)); //�Է¹��ڵ�
        labelprint(PChar(bxR), '120', '30', 0, 0, 0, 'HY�߰��', p_mname); //�����ڸ�
        printlabel('1', PChar(IntToStr(1)));

      end;
    1:
      begin
        barcode(PChar(bxL), PChar(by), PChar(bt), PChar(bh), PChar(bc), PChar(br), PChar(bn), PChar(bw), PChar(p_bar)); //�Է¹��ڵ�
        labelprint(PChar(bxL), '120', '30', 0, 0, 0, 'HY�߰��', p_mname); //�����ڸ�
        printlabel('1', PChar(IntToStr(1)));
      end;
    2:
      begin
        barcode(PChar(bxR), PChar(by), PChar(bt), PChar(bh), PChar(bc), PChar(br), PChar(bn), PChar(bw), PChar(p_bar)); //�Է¹��ڵ�
        labelprint(PChar(bxR), '120', '30', 0, 0, 0, 'HY�߰��', p_mname); //�����ڸ�
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
  //���ϸ� ����
  filename := 'barcodeprint.xml';

  //�������� ���翩�� üũ
  if not isExist(filename) then
  begin
    ShowMessage('[WMS���ڵ� ����Ʈ ����] ���α׷��� �̿��Ͽ� ��¼����� ���ֽʽÿ�.');
    exit;
  end;

  //XML�� �ҷ��� ����
  setXMLbarcode(printtype);
  openport(PChar(pageprint));
  clearbuffer;

  //xml �ε�
  Doc := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
  Doc.load(filename);
  List := Doc.getElementsByTagName(printtype);
  if List.length = 0 then
  begin
    ShowMessage('[WMS���ڵ� ����Ʈ ����] ���α׷��� �̿��Ͽ� ��¼����� ���ֽʽÿ�.');
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
      windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY�߰��', PCHAR(mG_name));
    end
    else if Element.childNodes[Loop].nodeName = 'g_code' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY�߰��', PCHAR('(' + mG_code + ')'));
    end
    else if Element.childNodes[Loop].nodeName = 'enf_day' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      windowsfont(mX, mY, 20, 0, mFontOption, 0, 'HY�߰��', PCHAR('�԰���'));
      windowsfont(mX + 20, mY + 20, mSize, 0, mFontOption, 0, 'HY�߰��', PCHAR(mE_day));
    end
    else if Element.childNodes[Loop].nodeName = 'fc_name' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      windowsfont(mX, mY, mSize, 0, mFontOption, 0, '����', PCHAR('�� �� ��:'));
      windowsfont(mX + 110, mY, mSize, 0, mFontOption, 0, 'HY�߰��', PCHAR(mFc_name));
    end
    else if Element.childNodes[Loop].nodeName = 'amount' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      windowsfont(mX, mY, 20, 0, mFontOption, 0, 'HY�߰��', PCHAR('�԰����'));
      windowsfont(mX, mY + 20, mSize, 0, mFontOption, 0, 'HY�߰��', PCHAR(mAmount));
    end
    else if Element.childNodes[Loop].nodeName = 'boxunit' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      windowsfont(mX, mY, mSize, 0, 0, 0, '����', PCHAR('�ڽ��Լ�'));
      windowsfont(mX + 110, mY, mSize, 0, mFontOption, 0, 'HY�߰��', PCHAR(mBoxunit));
    end
    else if Element.childNodes[Loop].nodeName = 'location' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      windowsfont(mX, mY, mSize, 0, 0, 0, '����', PCHAR('�����̼�:'));
      windowsfont(mX + 110, mY, mSize, 0, mFontOption, 0, 'HY�߰��', PCHAR(mLocation));
    end
    else if Element.childNodes[Loop].nodeName = 'mpst_name' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      windowsfont(mX, mY, 25, 0, 0, 0, '����', PCHAR('�˼���'));
      windowsfont(mX, mY + 25, mSize, 0, mFontOption, 0, 'HY�߰��', PCHAR(mM_name));
    end
    else if Element.childNodes[Loop].nodeName = 'title' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY�߰��', PCHAR('�԰�Ȯ�μ�'));
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
  //���ϸ� ����
  filename := 'barcodeprint.xml';

  //�������� ���翩�� üũ
  if not isExist(filename) then
  begin
    ShowMessage('[WMS���ڵ� ����Ʈ ����] ���α׷��� �̿��Ͽ� ��¼����� ���ֽʽÿ�.');
    exit;
  end;

  //XML�� �ҷ��� ����
  setXMLbarcode(printtype);
  openport(PChar(pageprint));
  clearbuffer;

  //xml �ε�
  Doc := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
  Doc.load(filename);
  List := Doc.getElementsByTagName(printtype);
  if List.length = 0 then
  begin
    ShowMessage('[WMS���ڵ� ����Ʈ ����] ���α׷��� �̿��Ͽ� ��¼����� ���ֽʽÿ�.');
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
        windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY�߰��', PCHAR(mB_name));
    end
    else if Element.childNodes[Loop].nodeName = 'g_day' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      mcheck := Element.childNodes[Loop].childNodes.item[4].text;
      if (mcheck = '1') then
        windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY�߰��', PCHAR('������:' + mB_day));
    end
    else if Element.childNodes[Loop].nodeName = 'g_num' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := 0;
      mcheck := Element.childNodes[Loop].childNodes.item[3].text;
      if (mcheck = '1') then
        windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY�߰��', PCHAR(mB_num));
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
  //���ϸ� ����
  filename := 'barcodeprint.xml';

  //�������� ���翩�� üũ
  if not isExist(filename) then
  begin
    ShowMessage('[WMS���ڵ� ����Ʈ ����] ���α׷��� �̿��Ͽ� ��¼����� ���ֽʽÿ�.');
    exit;
  end;

  //XML�� �ҷ��� ����
  setXMLbarcode(printtype);
  openport(PChar(pageprint));
  clearbuffer;

  //xml �ε�
  Doc := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
  Doc.load(filename);
  List := Doc.getElementsByTagName(printtype);
  if List.length = 0 then
  begin
    ShowMessage('[WMS���ڵ� ����Ʈ ����] ���α׷��� �̿��Ͽ� ��¼����� ���ֽʽÿ�.');
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
        windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY�߰��', PCHAR(mB_name));
    end
    else if Element.childNodes[Loop].nodeName = 'b_day' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := StrToInt(Element.childNodes[Loop].childNodes.item[3].text);
      mcheck := Element.childNodes[Loop].childNodes.item[4].text;
      if (mcheck = '1') then
        windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY�߰��', PCHAR('������:' + mB_day));
    end
    else if Element.childNodes[Loop].nodeName = 'b_num' then
    begin
      mX := StrToInt(Element.childNodes[Loop].childNodes.item[0].text);
      mY := StrToInt(Element.childNodes[Loop].childNodes.item[1].text);
      mSize := StrToInt(Element.childNodes[Loop].childNodes.item[2].text);
      mFontOption := 0;
      mcheck := Element.childNodes[Loop].childNodes.item[3].text;
      if (mcheck = '1') then
        windowsfont(mX, mY, mSize, 0, mFontOption, 0, 'HY�߰��', PCHAR(mB_num));
    end
  end;
  Doc := nil;
  printlabel('1', PChar(mCnt));
  closeport;

end;

//���� ���ڵ� ���

procedure cartBarcode(printtype, p_bar, p_name: string);
var
  bx, by, bt, bh, bc, br, bn, bw, bcode: string;
  count: Integer;
begin

  //���ϸ� ����
  filename := 'barcodeprint.xml';

  //�������� ���翩�� üũ
  if not isExist(filename) then
  begin
    ShowMessage('[WMS���ڵ� ����Ʈ ����] ���α׷��� �̿��Ͽ� ��¼����� ���ֽʽÿ�.');
    exit;
  end;

  //XML�� �ҷ��� ����
  setXMLbarcode(printtype);
  openport(PChar(pageprint));
  clearbuffer;


  //���
  //���ڵ����
  bx := '150';
  by := '30';
  bt := '128'; //barcode type
  bh := '100'; //barcode height
  bc := '1'; //barcode Readable
  br := '0'; //barcode rotate
  bn := '2'; //barcode Narrow
  bw := '10'; //barcode Wide

  //�Է¹��ڵ�
  bcode := p_bar;

  barcode(PChar(bx), PChar(by), PChar(bt), PChar(bh), PChar(bc), PChar(br), PChar(bn), PChar(bw), PChar(bcode));
  barcode(PChar(IntToStr(100)), PChar(IntToStr(30)), PChar(bt), PChar(IntToStr(80)), PChar(bc), PChar(IntToStr(90)), PChar(FloatToStr(1)), PChar(IntToStr(1)), PChar(bcode));

  //��Ī���
  labelprint('150', '200', '60', 0, 0, 0, 'HY�߰��', p_name);
  labelprint('640', '290', '20', 0, 1, 0, 'HY�߰��', '�������ڵ�');

  printlabel('1', PChar(IntToStr(1)));

  closeport;

end;

end.
