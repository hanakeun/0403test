unit lib_proxy;

interface

uses
  SysUtils, Classes, Windows,DBTables, VirtualTable, WinProcs,
  DB, ZAbstractRODataset, ZAbstractDataset, ZDataset, ZConnection,
  ZDbcIntfs, IdException, ComObj, MSXML2_TLB,
  Messages, Variants, Graphics, Controls, Forms, Dialogs, StdCtrls, RxMemDS, XMLIntf, XMLDoc;

type
  TProxyObject = class

    constructor Create(FORM_CODE:String);
    destructor Destroy; override;
    procedure SetOP(OP_CODE: String);
    procedure SetZConInfo(my_zconn : TZConnection; my_zqry: TZQuery);
    procedure SetProxyHost(proxyhost: String);
    function Connection_out : Boolean;
    function Connection_in : Boolean;
    procedure InputParam(Element_Name : String; Element_Value: String);
    procedure ExecuteCode;
    procedure ExecuteResult(MyDataSet: TRxMemoryData);  overload;
    procedure ExecuteResult(MyDataSet: TVirtualTable);  overload;
  private
    strSendBuffer : String;
    mForm_Code : String;
    mOp_code : String;
    mProxyHost : String;
    mPosition : Integer;
    bResult:integer;
    strResultSetKey : String;
    pStrInputMsg: PChar;
    pStrOutputMsg: PChar;
    zConn : TZConnection;
    zQry  : TZQuery;
    strString: string;

    function Open : Boolean;
    procedure SetPosition(position : Integer);
    procedure RowToTable(MyDataSet: TRxMemoryData; Element:IXMLDOMElement);  overload;
    procedure RowToTable(MyDataSet: TVirtualTable; Element:IXMLDOMElement);  overload;
    { Private declarations }
  public
    { Public declarations }

end;

var
  ProxyObject: TProxyObject;

const
  INPUT_MAX_SIZE = 1000;
  OUTPUT_MAX_SIZE = 1024 * 8;
  ZONE_IN = 1;
  ZONE_OUT = 2;


function  proxy_Open(szServerInfo:PChar) : integer; stdcall; External 'network_pc_delphi' index 1;
procedure proxy_Close(); stdcall; external 'network_pc_delphi' index 2;
function  proxy_Request(szInMsg:PChar; szOutMsg:PChar; nBufferLength:integer) : integer; stdcall; External 'network_pc_delphi' index 3;
Function  OperationToQuery(szInParam:PChar; szOutParam:PChar): Integer; stdcall; External 'wmsproxy.dll';

implementation

// Proxy�κ��� �޴� XML Return ���� �Ľ���.
{
<ROWDATA>
<ROW Country="Europe" NameOfCountry="Denmark" Capital="Copenhagen" Area="25000" Population="5000000"/>'
<ROW Country="Asia" NameOfCountry="Korea" Capital="Seoul" Area="12000" Population="5000000"/>'
<ROW Country="Asia" NameOfCountry="Japan" Capital="Tokyo" Area="23000" Population="4000000"/>'
</ROWDATA>
�׸��忡���� ROW�� ���� attribute ���� ����.
}

constructor TProxyObject.Create(FORM_CODE:String);
begin
  mForm_code   := FORM_CODE;
end;

destructor TProxyObject.Destroy;
begin
  If (mPosition = ZONE_IN) Then
  begin
    proxy_Close();
  end;
end;

procedure TProxyObject.SetZConInfo(my_zconn : TZConnection; my_zqry: TZQuery);
begin
  zConn := my_zconn;
  zQry := my_zqry;
end;

procedure TProxyObject.SetProxyHost(proxyhost: String);
begin
  mProxyHost := proxyhost;
end;

function TProxyObject.Connection_in : Boolean;
begin
  IF (Open) Then  // �α����� ���� HTTP ���ǿ���
  Begin
    SetPosition(ZONE_IN);
    Result := True;
  End Else
  Begin
    Result := False;
    Exit;
  End;
end;

function TProxyObject.Connection_out : Boolean;
begin
  try
   zConn.Protocol := 'mysql-5';
   zConn.Connect;
    except  on e:exception do
    begin
      ShowMessage('WMS ������ ������ �� �����ϴ�. ����ǿ� Ȯ�ιٶ��ϴ�.');
      Result := False;
      Exit;
    end;
  end;
  SetPosition(ZONE_OUT);
  Result := True;
end;

procedure TProxyObject.SetPosition (position : Integer);
begin
  mPosition := position;
end;

function TProxyObject.Open : Boolean;
var
  pStrOutTmp: PChar;
begin
  {
    - ������ ���� ��ΰ� �ٸ��� ����.
    - dll�� �ѹ��� ó���ϰ� .NET ���η��ӿ�ũ�� ������Ʈ �Ǿ �ֽ����� �����ϵ��� �ֱ�.
  }
    //  winexec('C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\regasm pc.dll /tlb:pc.tlb\n', SW_HIDE);

  pStrOutTmp := AllocMem(100);
  try
    bResult    := proxy_Open(PChar(mProxyHost+':8080'));
    bResult    := proxy_Request(PChar('<try>connect try!</try>'), pStrOutTmp, OUTPUT_MAX_SIZE);
   except on E:exception do
   begin
    ShowMessage('Proxy ������ ������ �����ϴ�. TProxyObject.Request() : '+E.Message);
    Result := False;
    Exit;
   end;
  end;
  If pStrOutTmp <> Nil then FreeMem(pStrOutTmp); 
  Result := True;
end;

procedure TProxyObject.SetOP(OP_CODE: String);
begin
  strSendBuffer := '';
  pStrInputMsg  := AllocMem(INPUT_MAX_SIZE);     //���������� ������ �Ұ��ΰ�?
  pStrOutputMsg := AllocMem(OUTPUT_MAX_SIZE);
  mOp_code := OP_CODE;
end;

procedure TProxyObject.InputParam(Element_Name : String; Element_Value: String);
begin
//  If (Trim(Element_Value) = '') Then
//    Element_Value := 'null';
  strSendBuffer :=  strSendBuffer + '<'+Element_Name +'>'+Element_Value+'</'+Element_Name+'>';
end;

procedure TProxyObject.ExecuteCode;
var
  Ashsql : String;
  Doc: IXMLDOMDocument;
begin
  If (mPosition = ZONE_IN) Then
  Begin
    strResultSetKey := '';
    Doc := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;

    try
      pStrOutputMsg := AllocMem(OUTPUT_MAX_SIZE);

      pStrInputMsg  := PChar('<FORM CODE="'+mForm_code+'"><OPERATION CODE="'+mOp_Code+'">'+strSendBuffer+'</OPERATION><ResultSetKey>' + strResultSetKey + '</ResultSetKey></FORM>');
      bResult       := proxy_Request(pStrInputMsg, pStrOutputMsg, OUTPUT_MAX_SIZE-1);
      strString     := StrPas(pStrOutputMsg);

      // check 1.<RequiredBufferSize>�� �����ϴ� �޼������� Ȯ��
      // check 2.<ResultSetKey>�� ������ �޼������� Ȯ��
      // check 3.<ROWDATA>�� �������� Ȯ��

      strString := '';
     except on E:exception do
     begin
      ShowMessage('Proxy ������ ������ �����ϴ�. TProxyObject.Request() : '+E.Message);
      Exit;
      end;
    end;

    If pStrOutputMsg <> Nil Then
    begin
      FreeMem(pStrOutputMsg);
    end;
    Doc := nil;
  End Else
  Begin
    pStrInputMsg  := PChar('<FORM CODE="'+mForm_code+'"><OPERATION CODE="'+mOp_Code+'">'+strSendBuffer+'</OPERATION></FORM>');
    bResult := OperationToQuery(pStrInputMsg,pStrOutputMsg);

    Ashsql := strpas(pStrOutputMsg);

    If pStrOutputMsg <> Nil Then
      FreeMem(pStrOutputMsg);

    zConn.Disconnect;
    zConn.Properties.Text := 'CLIENT_MULTI_STATEMENTS=1';
    zConn.Connect;

    zQry.Close;
    zQry.SQL.Clear;
    zQry.SQL.Add(AshsQL);
    try
      zQry.Open;
     except
      on e:EZSQLException do
        {
         Insert, Update, Delete ���� Stored Procedure�� ������� �����Ƿ�
         "CLIENT_MULTI_STATEMENTS=1" �������� �߻��� ������ ����ó�� �Ѵ�.
         }
    End;
  End;
End;

procedure TProxyObject.ExecuteResult(MyDataSet: TRxMemoryData);
var
  Ashsql : String;
  Doc: IXMLDOMDocument;
  Element: IXMLDOMElement;
  List: IXMLDOMNodeList;
  nBufferSize: integer;
  pStrInputTmp, pStrOutputTmp: PChar;
  tmpStr : String;
begin
try
  If (mPosition = ZONE_IN) Then
  Begin
    strResultSetKey := '';
    Doc := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
   repeat
    try
      pStrOutputMsg := AllocMem(OUTPUT_MAX_SIZE);

      pStrInputMsg  := PChar('<FORM CODE="'+mForm_code+'"><OPERATION CODE="'+mOp_Code+'">'+strSendBuffer+'</OPERATION><ResultSetKey>' + strResultSetKey + '</ResultSetKey></FORM>');
      bResult       := proxy_Request(pStrInputMsg, pStrOutputMsg, OUTPUT_MAX_SIZE-1);
      strString     := StrPas(pStrOutputMsg);
      Doc.loadXML(strString);

      // check 1.<RequiredBufferSize>�� �����ϴ� �޼������� Ȯ��
      List := Doc.getElementsByTagName('RequiredBufferSize');
      If List.length = 1 Then
      Begin
         Element := List.item[0] as IXMLDOMElement;
         nBufferSize := StrToInt(Element.childNodes.item[0].nodeValue);

         // ��û�� ũ���� ���۸� ���� ��.
         pStrOutputTmp := AllocMem(nBufferSize+1);

         // ���� �޼����� ������ �´�.
         tmpStr := strpas(pStrOutputMsg);
         pStrInputTmp  := PChar(tmpStr);
         bResult      := proxy_Request(pStrInputTmp, pStrOutputTmp, nBufferSize);
         strString    := StrPas(pStrOutputTmp);

         If pStrOutputTmp <> Nil Then
         begin
           FreeMem(pStrOutputTmp);
         end;
         Doc.loadXML(strString);
      End;

      // check 2.<ResultSetKey>�� ������ �޼������� Ȯ��
      List := Doc.getElementsByTagName('ResultSetKey');
      If List.length = 1 Then
      Begin
        Element := List.item[0] as IXMLDOMElement;
        If (Element.childNodes.length =0) Then
          strResultSetKey := ''
        Else
          strResultSetKey := Element.childNodes.item[0].nodeValue;
      End Else
      Begin
//        MyMemo.Lines.Add('Ű���� �����ϴ�' + strString);
        strResultSetKey := '';
      End;

      // check 3.<ROWDATA>�� �������� Ȯ��
      List := Doc.getElementsByTagName('ROWDATA');
      If List.length = 1 Then
      Begin
        Element := List.item[0] as IXMLDOMElement;
        If (Element.childNodes.length>0) Then
        Begin
          MyDataSet.EmptyTable;
          RowToTable(MyDataSet,Element);  // DataSet�� �Է��ϴ� �Լ� ȣ��.
        End;
          // DataSet�� �Է��ϴ� �Լ� ȣ��.
      End;

      strString := '';
     except on E:exception do
     begin
      ShowMessage('Proxy ������ ������ �����ϴ�. TProxyObject.Request() : '+E.Message);
      Exit;
      end;
    end;

    If pStrOutputMsg <> Nil Then
    begin
      FreeMem(pStrOutputMsg);
    end;

   until (strResultSetKey='');
    Doc := nil;
    //------
  End Else
  Begin
    pStrInputMsg  := PChar('<FORM CODE="'+mForm_code+'"><OPERATION CODE="'+mOp_Code+'">'+strSendBuffer+'</OPERATION></FORM>');
    bResult := OperationToQuery(pStrInputMsg,pStrOutputMsg);

    Ashsql := strpas(pStrOutputMsg);

    If pStrOutputMsg <> Nil Then
      FreeMem(pStrOutputMsg);

    zConn.Disconnect;
    zConn.Properties.Text := 'CLIENT_MULTI_STATEMENTS=1';
    zConn.Connect;

    zQry.Close;
    zQry.SQL.Clear;
    zQry.SQL.Add(AshsQL);
    try
      zQry.Open;
     except
      on e:EZSQLException do
        {
         Insert, Update, Delete ���� Stored Procedure�� ������� �����Ƿ�
         "CLIENT_MULTI_STATEMENTS=1" �������� �߻��� ������ ����ó�� �Ѵ�.
         }
    End;

    //�ܺδ� ���⼭ ������ ��� �̷����.
    MyDataSet.Close;
    MyDataSet.LoadFromDataSet(zqry,0, lmAppend);
    zqry.Close;

  End;
  MyDataSet.Open;
except on e:exception do showmessage(e.Message); end;
end;

procedure TProxyObject.ExecuteResult(MyDataSet: TVirtualTable);
var
  Ashsql : String;
  Doc: IXMLDOMDocument;
  Element: IXMLDOMElement;
  List: IXMLDOMNodeList;
  nBufferSize: integer;
  pStrInputTmp, pStrOutputTmp: PChar;
  tmpStr : String;
begin
  If (mPosition = ZONE_IN) Then
  Begin
    strResultSetKey := '';
    Doc := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
   repeat
    try
      pStrOutputMsg := AllocMem(OUTPUT_MAX_SIZE+1);

      pStrInputMsg  := PChar('<FORM CODE="'+mForm_code+'"><OPERATION CODE="'+mOp_Code+'">'+strSendBuffer+'</OPERATION><ResultSetKey>' + strResultSetKey + '</ResultSetKey></FORM>');
      bResult       := proxy_Request(pStrInputMsg, pStrOutputMsg, OUTPUT_MAX_SIZE);
      strString     := StrPas(pStrOutputMsg);
      Doc.loadXML(strString);

      // check 1.<RequiredBufferSize>�� �����ϴ� �޼������� Ȯ��
      List := Doc.getElementsByTagName('RequiredBufferSize');
      If List.length = 1 Then
      Begin
        Element := List.item[0] as IXMLDOMElement;
        nBufferSize := StrToInt(Element.childNodes.item[0].nodeValue);

        // ��û�� ũ���� ���۸� ���� ��.
        pStrOutputTmp := AllocMem(nBufferSize+1);

        // ���� �޼����� ������ �´�.
        tmpStr := strpas(pStrOutputMsg);
        pStrInputTmp  := PChar(tmpStr);
        bResult      := proxy_Request(pStrInputTmp, pStrOutputTmp, nBufferSize);
        strString    := StrPas(pStrOutputTmp);
        If pStrOutputTmp <> Nil Then
        begin
          FreeMem(pStrOutputTmp);
        end;
        Doc.loadXML(strString);
      End;

      // check 2.<ResultSetKey>�� ������ �޼������� Ȯ��
      List := Doc.getElementsByTagName('ResultSetKey');
      If List.length = 1 Then
      Begin
        Element := List.item[0] as IXMLDOMElement;
        If (Element.childNodes.length =0) Then
          strResultSetKey := ''
        Else
          strResultSetKey := Element.childNodes.item[0].nodeValue;
      End Else
      Begin
        strResultSetKey := '';
      End;

      // check 3.<ROWDATA>�� �������� Ȯ��

      List := Doc.getElementsByTagName('ROWDATA');
      If List.length = 1 Then
      Begin
        Element := List.item[0] as IXMLDOMElement;

        If (Element.childNodes.length>0) Then
        Begin
          MyDataSet.Clear;
          RowToTable(MyDataSet,Element);  // DataSet�� �Է��ϴ� �Լ� ȣ��.
        End;
      End;

      strString := '';
     except on E:exception do
     begin
      ShowMessage('Proxy ������ ������ �����ϴ�. TProxyObject.Request() : '+E.Message);
      Exit;
      end;
    end;

    If pStrOutputMsg <> Nil Then
    begin
      FreeMem(pStrOutputMsg);
    end;

   until (strResultSetKey='');
    Doc := nil;

  End Else
  Begin
    pStrInputMsg  := PChar('<FORM CODE="'+mForm_code+'"><OPERATION CODE="'+mOp_Code+'">'+strSendBuffer+'</OPERATION></FORM>');
    bResult := OperationToQuery(pStrInputMsg,pStrOutputMsg);

    Ashsql := strpas(pStrOutputMsg);

    If pStrOutputMsg <> Nil Then
      FreeMem(pStrOutputMsg);

    zConn.Disconnect;
    zConn.Properties.Text := 'CLIENT_MULTI_STATEMENTS=1';
    zConn.Connect;

    zQry.Close;
    zQry.SQL.Clear;
    zQry.SQL.Add(AshsQL);
    try
      zQry.Open;
     except
      on e:EZSQLException do
        {
         Insert, Update, Delete ���� Stored Procedure�� ������� �����Ƿ�
         "CLIENT_MULTI_STATEMENTS=1" �������� �߻��� ������ ����ó�� �Ѵ�.
         }
    End; 
    MyDataSet.Close;
    MyDataSet.Assign(zqry);
    zqry.Close;
  End;
  MyDataSet.Open;  
end;


procedure TProxyObject.RowToTable(MyDataSet: TRxMemoryData; Element:IXMLDOMElement);
var
  ColNum, RowNum : integer;
begin
  If (Element.childNodes.length>0) then    //Attribute �� �ִٸ�  ������ ���� ���.
  Begin
    For RowNum :=0 To Element.childNodes.length -1  Do
    Begin
      IF (Element.childNodes.item[RowNum].nodeName = 'ROW') Then               //���ڵ尪�� ROW�� ����.
      Begin
        If (Not MyDataSet.Active) Then
          MyDataSet.Open;

        MyDataSet.Append;
        For ColNum := 0 to MyDataSet.Fields.Count -1 do
        Begin
          If (Element.childNodes.item[RowNum].attributes.getNamedItem(MyDataSet.Fields.Fields[ColNum].FieldName).nodeName<>'') Then
          Begin
            MyDataSet.Fields.Fields[ColNum].AsVariant := Element.childNodes.item[RowNum].attributes.getNamedItem(MyDataSet.Fields.Fields[ColNum].FieldName).nodeValue;
          End;
        End;
        MyDataSet.Post;
      End;
    End;
  End;
end;

procedure TProxyObject.RowToTable(MyDataSet: TVirtualTable; Element:IXMLDOMElement);
var
  ColNum, RowNum : integer;
begin
  If (Element.childNodes.length>0) then    //Attribute �� �ִٸ�  ������ ���� ���.
  Begin
    For RowNum :=0 To Element.childNodes.length -1  Do
    Begin
      IF (Element.childNodes.item[RowNum].nodeName = 'ROW') Then               //���ڵ尪�� ROW�� ����.
      Begin
        If (Not MyDataSet.Active) Then
          MyDataSet.Open;
        For ColNum := 0 to Element.childNodes.item[RowNum].attributes.length -1 do  //�ʵ尪 ����.
        Begin
          If (MyDataSet.FieldDefs.IndexOf(Element.childNodes.item[RowNum].attributes.item[ColNum].nodeName)<0) Then
            MyDataSet.FieldDefs.Add(Element.childNodes.item[RowNum].attributes.item[ColNum].nodeName,ftUnknown ,0,False);

          If ColNum=0 Then
            MyDataSet.Append
          Else
            MyDataSet.Edit;

          MyDataSet.FieldByName(Element.childNodes.item[RowNum].attributes.item[ColNum].nodeName).AsVariant := Element.childNodes.item[RowNum].attributes.item[ColNum].NodeValue;
          MyDataSet.Post;
        End;
      End;
    End;
  End;
end;

end.