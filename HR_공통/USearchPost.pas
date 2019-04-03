unit USearchPost;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, ExtCtrls, ComCtrls, ToolWin, DB,
  MemDS, VirtualTable, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  ZConnection, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, cxDBData, cxTextEdit,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridLevel,
  cxClasses, cxGridCustomView, cxGrid;

type
  TfmSearchPost = class(TForm)
    ToolBar1: TToolBar;
    btnInquiry: TToolButton;
    btnClose: TToolButton;
    gb_cd_save: TGroupBox;
    Image1: TImage;
    Label3: TLabel;
    edtPost: TEdit;
    StatusBar1: TStatusBar;
    vtSearchPost: TVirtualTable;
    dsSearchPost: TDataSource;
    vtPost: TVirtualTable;
    cxviPost: TcxGridDBTableView;
    cxlvPost: TcxGridLevel;
    cxPost: TcxGrid;
    grdcolNo: TcxGridDBColumn;
    grdcolPostCode: TcxGridDBColumn;
    grdcolPostName: TcxGridDBColumn;
    grdcolMngName: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnInquiryClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure edtPostKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cxviPostCellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure grdcolNoGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: string);
    //procedure edtPostKeyPress(Sender: TObject; var Key: Char);

  private
    ashSql, ashStr: String;

  end;

var
  fmSearchPost: TfmSearchPost;
  arrPostInfo: array[0..3] of String;
  SearchPostName: string;

implementation

uses coophr_utils, coop_sql_updel, Unit1, USearchEmp;

{$R *.dfm}

var colIdx0: Integer; titleCaption0: String;

procedure TfmSearchPost.FormCreate(Sender: TObject);
begin
  // ShowMessage 숨김현상 방지
  Screen.OnActiveFormChange := Form1.OnScreenActiveFormChange; // http://www.delmadang.com/community/bbs_view.asp?bbsNo=17&bbsCat=41&indx=408162&keyword1=OnScreenActiveFormChange&keyword2= , 2018/05/04 dbsdlf11

  // 부서입력 확인
  //edtPost.Text := (Parent.FindComponent('edtPostName') as TEdit).Text;
  //ShowMessage(TEdit(userForm.FindComponent('edtPostName')).Text);
  //ShowMessage((TForm(Parent).FindComponent('edtPostName') as TEdit).Text);

  {
  try
    edtPost.Text := fmSearchEmp.edtPostName.Text;
  except
    edtPost.Text := Form1.edtPostName.Text;
  end;
  }
  if SearchPostName <> '' then
    edtPost.Text := SearchPostName;

  if isEmpty(edtPost.Text) then
    btnInquiryClick(btnInquiry);
end;

// 조회
procedure TfmSearchPost.btnInquiryClick(Sender: TObject);
begin
  ashSql := 'SELECT'
          + ' A.post_code'
	        + ', A.post_name'
	        + ', A.mng_post'
	        + ', (SELECT post_name FROM admin_post WHERE post_code = A.mng_post) AS mng_name'
          + ' FROM admin_post A'
          + ' WHERE post_code LIKE "%' + Trim(edtPost.Text) + '%"'
          + ' OR post_name LIKE "%' + Trim(edtPost.Text) + '%"'
          + ' AND use_ab = "Y"';

  ashStr := MySQL_Assign(Form1.db_cupg, Form1.qrysql, ashSql, vtSearchPost);
  try
    StrToInt(ashStr);
  except
    ShowMessage('오류가 발생하였습니다.[' + ashStr + '](ERR:108)');
    Exit;
  end;

  if vtSearchPost.RecordCount < 1 then
  begin
    ShowMessage('검색결과가 없습니다.');
  end;
end;

// No필드
procedure TfmSearchPost.grdcolNoGetDisplayText(Sender: TcxCustomGridTableItem;
  ARecord: TcxCustomGridRecord; var AText: string);
begin
  AText := IntToStr(Arecord.Index + 1);
end;

// 부서 그리드 더블클릭 시 모달리스 창으로 부서정보 전달
procedure TfmSearchPost.cxviPostCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  if vtSearchPost.RecordCount > 0 then
  begin
    arrPostInfo[0] := vtSearchPost.fieldByName('post_code').AsString;
    arrPostInfo[1] := vtSearchPost.fieldByName('post_name').AsString;
    arrPostInfo[2] := vtSearchPost.fieldByName('mng_post').AsString;
    arrPostInfo[3] := vtSearchPost.fieldByName('mng_name').AsString;

    ModalResult := mrOk;
  end;
end;

// 종료
procedure TfmSearchPost.btnCloseClick(Sender: TObject);
begin
  Close;
end;

// FormClose
procedure TfmSearchPost.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  vtSearchPost.Close;
  Action := caFree;
end;

// 조회조건 부서 edit에서 엔터 키로 조회
procedure TfmSearchPost.edtPostKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btnInquiryClick(btnInquiry);
end;

procedure TfmSearchPost.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssAlt]) or (Shift = [ssCtrl]) then
    Exit;

  case Key of
    VK_RIGHT: // VK_RIGHT 오른쪽커서 이동키
      begin
        SelectNext(ActiveControl, True, True);
        key := 0;
      end;
    VK_RETURN:
      begin
        SelectNext(ActiveControl, True, True);
        key := 0;
      end;
    VK_F1:
      begin
        ShowMessage('F1');
        Key := 0;
      end;
    VK_F9:
      begin
        if btnInquiry.Enabled then
          btnInquiryClick(btnInquiry);
        Key := 0;
      end;
    VK_ESCAPE: // ESC 키
      begin
        if btnClose.Enabled then
          btnCloseClick(btnClose);
        Key := 0;
      end;
  end;
end;

end.
