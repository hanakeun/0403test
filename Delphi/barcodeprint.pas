unit barcodeprint;

interface
uses
SysUtils, Dialogs, Math, XMLIntf,  XMLDoc,  ComObj,  MSXML2_TLB, Classes;

{#########���� xml���� ���翩�� Ȯ��###########
 param  : filename (String)  ���ϸ�
 return : Result (Boolean) ���翩��
}
function isExist(filename:String): Boolean;

{#########���ڵ� ���##########################
 param : printtype (String)  ���ڵ�����
                             �Ϲݹ�ǰ='goods'/������='pack'/���ڵ�='box'/����='car'
         code      (String)  ��� ���ڵ�
         name      (String)  ��¸�Ī(��ǰ��/�����)
         cnt       (Integer) ������
}
procedure printbarcode(printtype, code, name:String; cnt:Integer);

{#########XML ���ҷ��� ����##########################
 param : printtype (String)  ���ڵ�����
                             �Ϲݹ�ǰ='goods'/������='pack'/���ڵ�='box'/����='car'
}
procedure printbarcode2(printtype, code, name:String; cnt, No:Integer);

{#########XML ���ҷ��� ����##########################
 param : printtype (String)  ���ڵ�����
                             �Ϲݹ�ǰ='goods'/������='pack'/���ڵ�='box'/����='car'
}
procedure setXMLbarcode(printtype:String);

{#########�� ���##########################
 param : lblX / lblY / lblsize         (String)  X�� / Y�� / ������,
         lblrota / lblstyle / lblunder (Integer) ȸ�� / ��Ÿ�� / ����,
         lblface / lblvalue            (String)  ������Ʈ / ��¸�Ī
}
procedure labelprint(lblX, lblY, lblsize:String; lblrota, lblstyle, lblunder:Integer; lblface, lblvalue: String);

{}
//procedure locationPrint(p_location:String);
procedure locationPrint(p_basicset, p_location:String; num:Variant);

{}

procedure pulmuBarcode(p_printer,p_bar, p_gcode, p_gname, p_bccode, p_jip,p_amount,p_day,p_cnt:String);
procedure FarmerBarcode(p_bar, p_mname, p_cnt:String;p_side:Integer);


{�õ� �ڽ����ڵ�-�ڽ��� �߰�}
procedure freBoxPrint(printtype, code, name, coname:String; cnt:Integer);

var
  //xml
  filename: String;
  Doc: IXMLDOMDocument;
  Element: IXMLDOMElement;
  List: IXMLDOMNodeList;
  Loop : Integer;
  node : IXMLDOMNode;
  //���ڵ弼�ð�
  pagewidth, pageheight, pagespeed, pagedensity, pagesensor, pagevergap, pagesftdist, pageprint: String;
  dayX, dayY, daysize, dayrotate, dayoption, dayunderline: Integer; dayface, daychk: String;
  nameX, nameY, namesize, namerotate, nameoption, nameunderline: Integer; nameface, namechk: String;
  numX, numY, numsize, numrotate, numoption, numunderline: Integer; numface, numchk: String;
  barX, barY, bartype, barheight, barnarrow, barwide, barprintcnt, barrotate, barchk: String;
  //�ڽ�
  coX, coY, cosize, corotate, cooption, counderline: Integer; coface, cochk: String;

//���ڵ�����Ʈ �⺻���ν���
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

{�������翩�� Ȯ��}
function isExist(filename:String): Boolean;
begin
  if Not FileExists(filename) then
  begin
    Result := false;
    exit;
  end;
  Result := true;
end;

{XML���ҷ��� ����}
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

    //xml �ε�
  Doc := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
  Doc.load(filename);

  List := Doc.getElementsByTagName('set');

  Element := List.item[0] As IXMLDOMElement;

  //XML ����Ȯ��
  f_version := Element.getAttribute('ver');
  if not(f_version = '20090907') then
  begin
    ShowMessage('������ ����Ǿ����ϴ�. ���ڵ������� �������α׷����� �缳�� �Ͻʽÿ�.');
    Form1.Close();
    exit;
  end;

  //�⺻���������� �ε�
  //���� ���� �ȵ����� �������.. ù���� ���������ð�.
  for Loop := 0 to Element.childNodes.length -1 do  // �Ķ���Ͱ�.
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

  //�⺻���� ����
  //openport('TSC TTP-246M Plus');
  openport(PChar(pageprint));
  clearbuffer;
  setup(pagewidth, pageheight, pagespeed, pagedensity, pagesensor, pagevergap, pagesftdist);  //���� ����
  closeport;


  //���ڵ� ��� Ÿ��(��ǰ/������/�ڽ�/����)�� ���� ������ ȣ��
  for Loop := 0 to Element.childNodes.length -1 do  // �Ķ���Ͱ�.
  begin
    imsiElement := Element.childNodes.item[Loop] As IXMLDOMElement;

    if imsiElement.attributes.item[1].text = printtype then
    begin
      subname := imsiElement.attributes.item[0].text;
      delete(subname,1,2);
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
  for count:=1 to cnt do
  begin
    //openport('TSC TTP-246M Plus');  //������ ���� TSC TTP-246M Plus
    //openport('TSC TDP-245');
    openport(PChar(pageprint));
    clearbuffer;

    //�������
    if daychk = '1' then
    begin
      labelprint(IntToStr(dayX), IntToStr(dayY), IntToStr(daysize), dayrotate, dayoption, dayunderline, dayface, FormatDateTime('yyyy/mm/dd hh:mm AM/PM',Now()));
    end;
    //��Ī���
    if namechk = '1' then
    begin
      labelprint(IntToStr(nameX), IntToStr(nameY), IntToStr(namesize), namerotate, nameoption, nameunderline, nameface, name);
    end;
    //�ѹ������
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
  for count:=1 to cnt do
  begin
    //openport('TSC TTP-246M Plus');  //������ ���� TSC TTP-246M Plus
    //openport('TSC TDP-245');
    openport(PChar(pageprint));
    clearbuffer;

    //�������
    if daychk = '1' then
    begin
      labelprint(IntToStr(dayX), IntToStr(dayY), IntToStr(daysize), dayrotate, dayoption, dayunderline, dayface, FormatDateTime('yyyy/mm/dd hh:mm AM/PM',Now()));
    end;
    //��Ī���
    if namechk = '1' then
    begin
      labelprint(IntToStr(nameX), IntToStr(nameY), IntToStr(namesize), namerotate, nameoption, nameunderline, nameface, name);
    end;
    //�ѹ������
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
  for count:=1 to cnt do
  begin
    //openport('TSC TTP-246M Plus');  //������ ���� TSC TTP-246M Plus
    //openport('TSC TDP-245');
    openport(PChar(pageprint));
    clearbuffer;

    //�������
    if daychk = '1' then
    begin
      labelprint(IntToStr(dayX), IntToStr(dayY), IntToStr(daysize), dayrotate, dayoption, dayunderline, dayface, FormatDateTime('yyyy/mm/dd hh:mm AM/PM',Now()));
    end;
    //��Ī���
    if namechk = '1' then
    begin
      labelprint(IntToStr(nameX), IntToStr(nameY), IntToStr(namesize), namerotate, nameoption, nameunderline, nameface, name);
    end;
    //�ѹ������
    if numchk = '1' then
    begin
      labelprint(IntToStr(numX), IntToStr(numY), IntToStr(numsize), numrotate, numoption, numunderline, numface, IntToStr(count));
    end;
    //�ڽ������
    if cochk = '1' then
    begin
      labelprint(IntToStr(coX), IntToStr(coY), IntToStr(cosize), corotate, cooption, counderline, coface, coname);
    end;

    barcode(PChar(barX), PChar(barY), PChar(bartype), PChar(barheight), PChar(barchk), PChar(barrotate), PChar(barnarrow), PChar(barwide), PChar(code));

    printlabel('1',PChar(barprintcnt));
    closeport;
  end;
end;

{������Ʈ - ����/��Ī/�ѹ���}
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

  printlabel('1',PChar(IntToStr(num)));
  closeport;

end;


//Ǯ�����ڵ� ���
procedure pulmuBarcode(p_printer, p_bar, p_gcode, p_gname, p_bccode, p_jip,p_amount,p_day,p_cnt:String);
var
    pulwidth, pulheight, pulspeed, puldensity, pulsensor, pulvergap, pulsftdist, pulprint:String;
    bx, by, bt, bh,bc, br,bn,bw, bcode:string;
begin
  //���� ��������
  pulwidth := '83';
  pulheight := '56';
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
  bx := '15';
  by := '50';
  bt := '128';
  bh := '100';
  bc := '1';
  br := '0';
  bn := '2';
  bw := '10';
  //�Է¹��ڵ�
  bcode := p_bar;

  barcode(PChar(bx), PChar(by), PChar(bt), PChar(bh), PChar(bc), PChar(br), PChar(bn), PChar(bw), PChar(bcode));

//  labelprint(lblX, lblY, lblsize:String; lblrota, lblstyle, lblunder:Integer; lblface, lblvalue: String);
  //��ǰ�ڵ� ��
  labelprint('15', '180', '20', 0, 0, 0, 'HY�߰��', p_gcode); //  ('15', '170', '20', 0, 0, 0, 'HY�߰��', p_gcode);
  //��ǰ�� ��
  labelprint('15', '200', '40', 0, 0, 0, 'HY�߰��', p_gname); //('15', '200', '20', 0, 0, 0, 'HY�߰��', p_gname);
  //�ǿ���Ī ��
  labelprint('390', '70', '70', 0, 2, 0, 'HY�߰��', p_bccode);//('300', '40', '30', 0, 2, 0, 'HY�߰��', p_bccode);
  //��ǰ�� ��
  labelprint('15', '280', '25', 0, 0, 0, 'HY�߰��', '��ǰ�� : ' + p_jip);//('15', '250', '20', 0, 0, 0, 'HY�߰��', p_jip);
  //���� ��
  labelprint('15', '320', '30', 0, 0, 0, 'HY�߰��', '����');//('15', '300', '30', 0, 2, 0, 'HY�߰��', p_amount);
  labelprint('15', '350', '70', 0, 2, 0, 'HY�߰��', p_amount);//('15', '300', '30', 0, 2, 0, 'HY�߰��', p_amount);
  //���� ��
  labelprint('300', '320', '30', 0, 0, 0, 'HY�߰��', '����');//('15', '300', '30', 0, 2, 0, 'HY�߰��', p_amount);
  labelprint('300', '350', '70', 0, 2, 0, 'HY�߰��', p_day);//('300', '300', '30', 0, 2, 0, 'HY�߰��', p_day);



  //  barcode(PChar('10'), PChar('10'), PChar('128'), PChar('50'), PChar('0'), PChar('0'), PChar('1'), PChar('10'), PChar('12345'));
  //��Ī���
//  labelprint(lblx, lbly, lblsize, StrToInt(lblrotate), StrToInt(lbloption), StrToInt(lblunderline), lblface, lblCode);

  printlabel('1',PChar(p_cnt));

  closeport;

end;

//Ǯ�� ������ �� ���
procedure FarmerBarcode(p_bar, p_mname, p_cnt:String;p_side:Integer);
var
    pulwidth, pulheight, pulspeed, puldensity, pulsensor, pulvergap, pulsftdist, pulprint:String;
    bxL,bxR, by, bt, bh,bc, br,bn,bw, bcode:string;
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
  pulprint := 'TSC TDP-245 Plus';

  openport(PChar(pulprint));

  clearbuffer;

  setup(pulwidth, pulheight, pulspeed, puldensity, pulsensor, pulvergap, pulsftdist);  //���� ����

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
        printlabel('1',PChar(p_cnt));

      end;
    1:
      begin
        barcode(PChar(bxL), PChar(by), PChar(bt), PChar(bh), PChar(bc), PChar(br), PChar(bn), PChar(bw), PChar(p_bar)); //�Է¹��ڵ�
        labelprint(PChar(bxL), '120', '30', 0, 0, 0, 'HY�߰��', p_mname); //�����ڸ�
        printlabel('1',PChar(p_cnt));
      end;
    2:
      begin
        barcode(PChar(bxR), PChar(by), PChar(bt), PChar(bh), PChar(bc), PChar(br), PChar(bn), PChar(bw), PChar(p_bar)); //�Է¹��ڵ�
        labelprint(PChar(bxR), '120', '30', 0, 0, 0, 'HY�߰��', p_mname); //�����ڸ�
        printlabel('1',PChar(p_cnt));
      end;
  end;    
  closeport;
end;
end.
