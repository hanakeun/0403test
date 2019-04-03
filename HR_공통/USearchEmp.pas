unit USearchEmp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, ComCtrls, ToolWin,
  DB, MemDS, VirtualTable, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  ZConnection, Excels, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, cxDBData,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxTextEdit, cxGridExportLink, ShellApi,
  Comobj;

type
  TfmSearchEmp = class(TForm)
    ToolBar1: TToolBar;
    btnInquiry: TToolButton;
    btnClose: TToolButton;
    gb_cd_save: TGroupBox;
    Label6: TLabel;
    Image1: TImage;
    Image3: TImage;
    Image30: TImage;
    edtCond: TEdit;
    cbEmpAb: TComboBox;
    StatusBar1: TStatusBar;
    Label1: TLabel;
    vtMember: TVirtualTable;
    dsMember: TDataSource;
    cbAb: TComboBox;
    vtCompany: TVirtualTable;
    cbOCode: TComboBox;
    Image2: TImage;
    Label2: TLabel;
    cbBCode: TComboBox;
    edtPostName: TEdit;
    edtPostCode: TEdit;
    btnPostSearch: TSpeedButton;
    btnExcel: TToolButton;
    Image4: TImage;
    Label3: TLabel;
    Image5: TImage;
    rbNewEmp: TRadioButton;
    rbActiveGroupHis: TRadioButton;
    btnCancel: TButton;
    cxviMember: TcxGridDBTableView;
    cxlvMember: TcxGridLevel;
    cxMember: TcxGrid;
    Excel1: TExcel;
    grdcolNo: TcxGridDBColumn;
    grdcolMName: TcxGridDBColumn;
    grdcolMCode: TcxGridDBColumn;
    grdcolErpMCode: TcxGridDBColumn;
    grdcolOCode: TcxGridDBColumn;
    grdcolOName: TcxGridDBColumn;
    grdcolBCode: TcxGridDBColumn;
    grdcolBName: TcxGridDBColumn;
    grdcolPostCode: TcxGridDBColumn;
    grdcolPostName: TcxGridDBColumn;
    grdcolSalTypeAbVal: TcxGridDBColumn;
    grdcolEmpAb: TcxGridDBColumn;
    grdcolEmpAbVal: TcxGridDBColumn;
    Memo1: TMemo;
    dlgSave1: TSaveDialog;

    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnInquiryClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtCondKeyPress(Sender: TObject; var Key: Char);
    procedure btnPostSearchClick(Sender: TObject);
    procedure cbOCodeChange(Sender: TObject);
    procedure btnExcelClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cxviMemberKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cxviMemberCellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure grdcolNoGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: string);
    procedure cxviMemberMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure edtPostNameEnter(Sender: TObject);
    procedure edtPostNameKeyPress(Sender: TObject; var Key: Char);
    procedure ToolBar1DblClick(Sender: TObject);

  private
    ashSql, ashStr: String;
    minSize, maxSize: TPoint; // 최소, 최대크기 제한
    procedure WMGetMinMAXInfo(var msg: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
    procedure sendMInfo;

  end;
  
var
  fmSearchEmp: TfmSearchEmp;
  arrEmpInfo: array[0..10] of String;
  isScroll: Boolean;
  searchYn: Boolean = False;
  inquiryYn: Boolean = False;
  rNo: Integer = 1;
  empNm: String;
  authAllYn: Boolean = False; // 권한 상관없이 전체 법인의 근로자 조회

implementation

uses coophr_utils, coop_sql_updel, Unit1, USearchPost;

{$R *.dfm}

// 폼 크기 제한
procedure TfmSearchEmp.WMGetMinMAXInfo(var msg: TWMGetMinMaxInfo);
begin
  if Visible then
  begin
    msg.MinMaxInfo^.ptMinTrackSize := minSize;
    msg.MinMaxInfo^.ptMaxTrackSize := maxSize;
  end;
end;

procedure TfmSearchEmp.FormCreate(Sender: TObject);
begin
  // 재직상태코드 콤보박스에 세팅
  setCbCommCode(Form1.qrysql, Form1.vtTemp, 'hr_emp_ab', 'A', cbEmpAb);
  cbAb.ItemIndex := 0;

  // 사용자의 권한 있는 소속, 부서 콤보박스에 세팅
  setCbCode(Form1.db_coophr, Form1.qrysql, 'o_code' , 'A', cbOCode); // 소속
  setCbCode(Form1.db_coophr, Form1.qrysql, 'b_code', 'A', cbBCode); // 사업장

  // 사원상태 초기값 - 재직자
  cbEmpAb.ItemIndex := 1;

  showCtrl(Memo1);
end;

procedure TfmSearchEmp.FormShow(Sender: TObject);
begin
  // 폼 최소크기 제한 1024 * 745
  minSize.X := 1024;
  minSize.Y := 745;
  // 폼 최대크기 제한
  maxSize.X := GetSystemMetrics(SM_CXSCREEN); // 모니터해상도
  maxSize.Y := GetSystemMetrics(SM_CYSCREEN);

  // ShowMessage 숨김현상 방지
  Screen.OnActiveFormChange := Form1.OnScreenActiveFormChange;

  ToolBar1DblClick(ToolBar1);
end;

procedure TfmSearchEmp.ToolBar1DblClick(Sender: TObject);
begin
  showCtrl(Memo1);
end;

procedure TfmSearchEmp.FormActivate(Sender: TObject);
begin
  // 사원입력 확인
  if isEmpty(empNm) then
  begin
    edtCond.Text := empNm;
    try
      StrToInt(empNm);
      cbAb.ItemIndex := 1;
    except
      cbAb.ItemIndex := 0;
    end;
  end;

  if searchYn then
  begin
    btnInquiryClick(btnInquiry);
    cxMember.SetFocus;
    vtMember.RecNo := rNo;
    searchYn := False;
  end
  else
    edtCond.SetFocus;

  empNm := '';
end;

// 조회
procedure TfmSearchEmp.btnInquiryClick(Sender: TObject);
var
  empCond, oCodeCond, bCodeCond: String; // 조회조건
  subSqlEmpCond, subSqlOCode, subSqlBCode, subSqlPostCode, subSqlEmpAb, subSqlAb: String;
  i: Integer;
  pDt: TDateTime;
begin
  // 조회조건 쿼리 *************************************************************
  empCond := Trim(edtCond.Text);
  oCodeCond := ''; bCodeCond := '';
  subSqlEmpCond := ''; subSqlOCode := ''; subSqlBCode := ''; subSqlPostCode := ''; subSqlEmpAb := ''; subSqlAb := '';

  if (not rbNewEmp.Checked) and (not rbActiveGroupHis.Checked) then
  begin
    // 조회조건에서 소속, 사업장, 부서, 사원(사원명 2글자이상) 중 하나이상 선택 필수
    if (cbOCode.ItemIndex = 0) and (cbBCode.ItemIndex = 0) and (not isEmpty(edtPostCode.Text)) and (Length(empCond) < 2) then
    begin
      ShowMessage('소속, 사업장, 부서, 사원 중 하나이상은 필수 선택 조건입니다.');
      edtCond.SetFocus;
      {if cbOCode.ItemIndex = 0 then
      begin
        cbOCode.SetFocus;
        SendMessage(cbOCode.Handle, CB_SHOWDROPDOWN, Integer(true), 0);
      end;
      }
      Exit;
    end;
  end;

  // 사원명 또는 사원번호
  if (cbAb.ItemIndex = 0) and isEmpty(empCond) then // 사원명
  begin
    subSqlEmpCond := ' AND hr_members.hr_m_name LIKE "%' + empCond + '%"';
  end
  else if (cbAb.ItemIndex = 1) and isEmpty(empCond) then  // 사원번호
    subSqlEmpCond := ' AND hr_members.hr_m_code LIKE "%' + empCond + '%"';

  // 사업장 선택 시
  if cbBCode.ItemIndex <> 0 then
  begin
    subSqlBCode := ' AND (hr_group_his.hr_b_code = "' + copy(cbBCode.Text, 6, 3) + '")'
  end
  // 사업장 전체
  else
  begin
    // 소속법인 전체
    if cbOCode.ItemIndex = 0 then
    begin
      if (not authAllYn) and (cbBCode.Items.Count > 1) then
      begin
        for i := 1 to cbBCode.Items.Count - 1 do
        begin
          if bCodeCond = '' then
            bCodeCond:= '"' + copy(cbBCode.Items[i], 6, 3) + '"'
          else bCodeCond :=  bCodeCond + ',"' + copy(cbBCode.Items[i], 6, 3) + '"';
        end;

        subSqlBCode := ' AND hr_group_his.hr_B_code IN (' + bCodeCond  + ')';
      end;
    end
    // 소속법인 선택 시
    else
    begin
      subSqlOCode := ' AND hr_group_his.hr_o_code = "' + copy(cbOCode.Text, 1, 4) + '"';
    end;
  end;

  // 부서 선택 시
  if Length(Trim(edtPostCode.Text)) = 4 then
  begin
    subSqlPostCode := ' AND hr_post_code = "' + Trim(edtPostCode.Text) + '"';
  end;

  {
  if cbPostCode.Items.Count > 1 then // 조회권한 부서 하나 이상이면
  begin
    if cbPostCode.ItemIndex = 0 then // 전체
    begin
      for i := 1 to cbPostCode.Items.Count - 1 do
      begin
        if postCodeCond = '' then
          postCodeCond := '"' + subStr(cbPostCode.Items[i], 1, ' ') + '"'
        else postCodeCond :=  postCodeCond + ',"' + subStr(cbPostCode.Items[i], 1, ' ')+ '"';
      end;

      if cbOCode.Items.Count > 1 then
        if cbOCode.ItemIndex > 0 then
          subSqlPostCode := ' AND hr_group_his.hr_post_code IN (' + postCodeCond + '))'
        else
          subSqlPostCode := ' OR hr_group_his.hr_post_code IN (' + postCodeCond + '))'
      else
        subSqlPostCode := ' AND hr_group_his.hr_post_code IN (' + postCodeCond + ')';
    end
    else
    begin
      subSqlPostCode := ' AND hr_group_his.hr_post_code = "' + subStr(cbPostCode.Text, 1, ' ') + '")';
    end;
  end;
  }

  Screen.Cursor := crHourGlass;
pDt := Now;
  // 채용연동 신규입사자 조회
  if rbNewEmp.Checked then
  begin
    ashSql := 'SELECT hr_m_name'
            + ', hr_m_code'
            + ', m_code'
            + ', hr_o_code'
            + ', "" hr_o_name'
            + ', "" hr_b_code'
            + ', "" hr_b_name'
            + ', "" hr_post_code'
            + ', "" AS hr_post_name'
            + ', "" AS hr_sal_type_ab_val'
            + ', hr_emp_ab'
            + ', (SELECT hr_code_value_name FROM hr_common_code_value WHERE hr_code_id = "hr_emp_ab" AND hr_code_value = MEMB.hr_emp_ab AND hr_use_yn = "Y") AS hr_emp_ab_val'
            + ', hr_ab'
            + ' FROM (SELECT hr_ab, hr_m_name, hr_members.hr_m_code, m_code, hr_members.hr_emp_ab, hr_o_code'
                  + ' FROM hr_members'
                  + ' LEFT OUTER JOIN hr_group_his'
                  + ' ON hr_members.hr_m_code = hr_group_his.hr_m_code'
                  + ' AND hr_update_yn = "N"'
                  + ' WHERE ((history LIKE "채용연동%" AND hr_group_his.hr_o_code IS NULL)'
                  // 2015-03-30 채용연동 재입사자 조회되게 (인사지원팀 요청)
                  + ' OR (history LIKE "%채용연동%" AND hr_emp_ab = "3"))'
                  + subSqlEmpCond
                  + ' ORDER BY hr_changeday DESC, hr_seq_no DESC'
            + ') MEMB'
            + ' GROUP BY hr_m_code'
            + ' HAVING (hr_emp_ab = "3" AND hr_ab = "B")'   // 재입사자 마지막 인사발령이 퇴사인 경우
            + ' OR (hr_emp_ab = "3" AND hr_o_code IS NULL)' // 채용연동에서 전송을 2번이상 할 경우 재입사자로 전송
            + ' OR hr_emp_ab = "1"';                        // 신규입사자
  end

  // 유효한 인사발령이 있는 퇴사자
  else if rbActiveGroupHis.Checked then
  begin
    ashSql := 'SELECT hr_m_name, hr_m_code, m_code'
            + ', IFNULL(hr_o_code, "") hr_o_code'
            + ', IFNULL((SELECT hr_o_name FROM hr_company WHERE hr_o_code = EMP.hr_o_code), "") hr_o_name'
            + ', IFNULL(hr_b_code, "") hr_b_code'
            + ', IFNULL((SELECT hr_b_name FROM hr_branch WHERE hr_b_code = EMP.hr_b_code), "") hr_b_name'
            + ', hr_post_code'
            + ', hr_post_name'
            + ', (SELECT hr_code_value_name FROM hr_common_code_value'
            +     ' WHERE hr_code_id = "hr_sal_type_ab" AND hr_code_value = EMP.hr_sal_type_ab) AS hr_sal_type_ab_val'
            + ', hr_emp_ab'
            + ', (SELECT hr_code_value_name FROM hr_common_code_value'
            +     ' WHERE hr_code_id = "hr_emp_ab" AND hr_code_value = EMP.hr_emp_ab) AS hr_emp_ab_val'
            + ', hr_ab'
            + ' FROM ('
                    + 'SELECT hr_members.hr_m_code, hr_members.hr_m_name, hr_members.m_code, hr_emp_ab'
                    + ', hr_o_code, hr_b_code, hr_post_code, hr_post_name, hr_sal_type_ab, hr_changeday, hr_seq_no, hr_ab, hr_update_yn'
                    + ' FROM hr_members'
                    + ' INNER JOIN hr_group_his'
                    + ' ON hr_members.hr_m_code = hr_group_his.hr_m_code'
                    + ' WHERE hr_members.hr_emp_ab = "2"'
                    + subSqlEmpCond
                    + subSqlOCode
                    + subSqlBCode
                    + ' AND hr_update_yn = "N"'
                    + ' ORDER BY hr_changeday DESC, hr_seq_no DESC'
            + ') EMP'
            + ' GROUP BY hr_o_code, hr_b_code, hr_m_code'
            + ' HAVING hr_ab NOT IN ("B", "E")';
  end

  {
  // 인사이력없음
  else if rbNoExistGroupHis.Checked then
  begin
    if (cbEmpAb.ItemIndex = 1) then // 1:재직자 선택 시 재입사자 같이 조회
      subSqlEmpAb := ' AND hr_emp_ab IN ("1", "3")'  // 1:재직자, 3:재입사자

    else if (cbEmpAb.ItemIndex in [2,4]) then  // 2:퇴사자, 4:재입사금지대상
      subSqlEmpAb := ' AND hr_emp_ab = "' + subStr(cbEmpAb.Text, 1, ' ') + '"'

    else if (cbEmpAb.ItemIndex = 3) then  // 3:재입사자
      subSqlEmpAb := ' AND hr_emp_ab = "' + subStr(cbEmpAb.Text, 1, ' ') + '"'
    else
      subSqlEmpAb := '';

    subSqlOCode := '';
    if cbOCode.ItemIndex <> 0 then
    begin
      subSqlOCode := ' AND hr_members.hr_m_code LIKE "' + copy(cbOCode.Text, 3, 2) + '%"';
    end;

    ashSql := 'SELECT hr_m_name'
            + ', hr_members.hr_m_code'
            + ', m_code'
            + ', "" hr_o_code'
            + ', "" hr_o_name'
            + ', "" hr_b_code'
            + ', "" hr_b_name'
            + ', "" hr_post_code'
            + ', "" AS hr_post_name'
            + ', "" AS hr_sal_type_ab_val'
            + ', hr_members.hr_emp_ab'
            + ', (SELECT hr_code_value_name FROM hr_common_code_value WHERE hr_code_id = "hr_emp_ab" AND hr_code_value = hr_members.hr_emp_ab AND hr_use_yn = "Y") AS hr_emp_ab_val'
            + ' FROM hr_members'
            + ' LEFT OUTER JOIN hr_group_his'
            + ' ON hr_members.hr_m_code = hr_group_his.hr_m_code'
            + ' AND hr_group_his.hr_update_yn = "N"'
            + ' WHERE 1=1'
            + subSqlEmpCond
            + subSqlEmpAb
            + ' AND hr_group_his.hr_o_code IS NULL';
  end
  }
  else
  begin
    // 상태코드
    if (cbEmpAb.ItemIndex = 0) then
    begin
      //subSqlEmpAb := ' AND hr_group_his.hr_ab <> "B"'; // 구분코드 - B:퇴사 (2:퇴사자, 4:재입사금지대상, 소속법인변동 포함)
      subSqlAb    := ' HAVING 1=1';
    end

    else if (cbEmpAb.ItemIndex = 1) then // 1:재직자 선택 시 재입사자 같이 조회
    begin
      subSqlEmpAb := ' AND hr_members.hr_emp_ab IN ("1", "3")';  // 1:재직자, 3:재입사자
      subSqlAb    := ' HAVING hr_ab NOT IN ("B", "E")';
    end

    else if (cbEmpAb.ItemIndex in [2,4]) then  // 2:퇴사자, 4:재입사금지대상
    begin
      subSqlEmpAb := ' AND hr_members.hr_emp_ab = "' + subStr(cbEmpAb.Text, 1, ' ') + '"';
      subSqlAb    := ' HAVING 1=1';
    end

    else if (cbEmpAb.ItemIndex = 3) then  // 3:재입사자
    begin
      subSqlEmpAb := ' AND hr_members.hr_emp_ab = "' + subStr(cbEmpAb.Text, 1, ' ') + '"';
      subSqlAb    := ' HAVING hr_ab NOT IN ("B", "E")';
    end

    else
      subSqlEmpAb := '';

    // *************************************************************************
    // 쿼리 수정
    // 2. 2015-10-01 입사일자와 퇴사일자가 같은 일용직의 경우 발령일자 기준 조회 시
    //   입사이력이 위로 조회되어 이중세무소속으로 조회되는 경우 발생하여 발령일자, 일련번호 기준으로 수정

    // 1. 2015-08-04 세무소속변경발령 이후 퇴사한 소속의 변경내역 발생하여 등록할 경우(MAX(일련번호)로 입력)
    //    - 세무소속변경 후 직급조정 결과가 이후에 나는 경우 등
    //   이중소속으로 조회되는 경우 발생하여 일련번호 기준 조회에서 발령일자 기준으로 변경

    ashSql := 'SELECT hr_m_name, hr_m_code, m_code'
            + ', IFNULL(hr_o_code, "") hr_o_code'
            + ', IFNULL((SELECT hr_o_name FROM hr_company WHERE hr_o_code = EMP.hr_o_code), "") hr_o_name'
            + ', IFNULL(hr_b_code, "") hr_b_code'
            + ', IFNULL((SELECT hr_b_name FROM hr_branch WHERE hr_b_code = EMP.hr_b_code), "") hr_b_name'
            + ', hr_post_code'
            + ', hr_post_name'
            + ', (SELECT hr_code_value_name FROM hr_common_code_value'
            +     ' WHERE hr_code_id = "hr_sal_type_ab" AND hr_code_value = EMP.hr_sal_type_ab) AS hr_sal_type_ab_val'
            + ', hr_emp_ab'
            + ', (SELECT hr_code_value_name FROM hr_common_code_value'
            +     ' WHERE hr_code_id = "hr_emp_ab" AND hr_code_value = EMP.hr_emp_ab) AS hr_emp_ab_val'
            + ', hr_ab'
            + ' FROM ('
                    + 'SELECT hr_members.hr_m_code, hr_members.hr_m_name, hr_members.m_code, hr_emp_ab'
                    + ', hr_o_code, hr_b_code, hr_post_code, hr_post_name, hr_sal_type_ab, hr_changeday, hr_seq_no, hr_ab, hr_update_yn'
                    + ' FROM hr_members'
                    + ' INNER JOIN hr_group_his'
                    + ' ON hr_members.hr_m_code = hr_group_his.hr_m_code'
                    + ' WHERE TRUE'
                    + subSqlEmpCond
                    + subSqlEmpAb
                    + subSqlOCode
                    + subSqlBCode
                    + ' AND hr_update_yn = "N"'
                    + ' ORDER BY hr_changeday DESC, hr_seq_no DESC'
            + ') EMP'
            + ' GROUP BY hr_o_code, hr_b_code, hr_m_code'
            + subSqlAb
            + subSqlPostCode;
    {
    ashSql := 'SELECT'
            + ' hr_members.hr_m_name'
            + ', hr_members.hr_m_code'
            + ', hr_members.m_code'
            //+ ', hr_group_his.hr_o_code'
            + ', IFNULL(hr_group_his.hr_o_code, "") hr_o_code'
            + ', IFNULL((SELECT hr_o_name FROM hr_company WHERE hr_o_code = hr_group_his.hr_o_code), "") hr_o_name'
            //+ ', hr_group_his.hr_b_code'
            + ', IFNULL(hr_group_his.hr_b_code, "") hr_b_code'
            + ', IFNULL((SELECT hr_b_name FROM hr_branch WHERE hr_b_code = hr_group_his.hr_b_code), "") hr_b_name'
            + ', hr_group_his.hr_post_code'
            + ', "                              " AS hr_post_name'
            //+ ', IFNULL((SELECT post_name FROM admin_post WHERE post_code = hr_group_his.hr_post_code), "") hr_post_name'
            //+ ', hr_group_his.hr_sal_type_ab'
            + ', (SELECT hr_code_value_name FROM hr_common_code_value'
            +     ' WHERE hr_code_id = "hr_sal_type_ab" AND hr_code_value = hr_group_his.hr_sal_type_ab'
            +     ' AND hr_use_yn = "Y") AS hr_sal_type_ab_val'
            + ', hr_members.hr_emp_ab'
            + ', (SELECT hr_code_value_name FROM hr_common_code_value'
            +     ' WHERE hr_code_id = "hr_emp_ab" AND hr_code_value = hr_members.hr_emp_ab'
            +     ' AND hr_use_yn = "Y") AS hr_emp_ab_val'
            + ' FROM hr_members'
            + ' INNER JOIN hr_group_his'
            + ' ON hr_members.hr_m_code = hr_group_his.hr_m_code'
            + ' WHERE 1=1'
            + subSqlEmpCond
            + subSqlEmpAb
            + subSqlOCode
            + subSqlBCode
            + subSqlPostCode
            // 2015-08-04 세무소속변경발령 이후 퇴사한 소속의 변경내역 발생하여 등록할 경우(MAX(일련번호)로 입력)
            //  - 세무소속변경 후 직급조정 결과가 이후에 나는 경우 등
            // 이중소속으로 조회되는 경우 발생하여 일련번호 기준 조회에서 발령일자 기준으로 변경
            //+ ' AND (hr_o_code, hr_b_code, hr_seq_no) IN (SELECT hr_o_code, hr_b_code, MAX(hr_seq_no) FROM hr_group_his'
            + ' AND (hr_o_code, hr_b_code, hr_changeday) IN (SELECT hr_o_code, hr_b_code, MAX(hr_changeday) FROM hr_group_his'
                                              + ' WHERE hr_m_code = hr_members.hr_m_code'
                                              //+ subSqlOCode
                                              //+ subSqlBCode
                                              //+ subSqlPostCode
                                              + ' AND hr_update_yn = "N"'
                                              + ' GROUP BY hr_o_code, hr_b_code, hr_m_code)'
            + ' AND hr_update_yn = "N"'
            + ' GROUP BY hr_o_code, hr_b_code, hr_m_code';
            }
  end;

  Memo1.Lines.Add(ashSql);
  ashStr := MySQL_Assign(Form1.db_coophr, Form1.qrysql, ashSql, vtMember);
  try
    StrToInt(ashStr);
  except
    ShowMessage('오류가 발생하였습니다.[' + ashStr + '](ERR:사원조회)');
    Screen.Cursor := crDefault;
    Exit;
  end;

  Screen.Cursor := crDefault;
Memo1.Lines.Add(FormatDateTime('hhmmss', Now - pDt));

  if vtMember.RecordCount = 1 then // 검색사원이 1명이면
  begin
   //grdMemberDblClick(grdMember);
  end
  else if vtMember.RecordCount < 1 then
  begin
    //Application.Title := '사원검색';
    ShowMessage('조회권한이 없거나 검색결과가 없습니다.');
  end;
end;

// 종료버튼 클릭 시
procedure TfmSearchEmp.btnCloseClick(Sender: TObject);
begin
  cbAb.ItemIndex := 0;
  edtCond.Text := '';
  cbOCode.ItemIndex := 0;
  cbBCode.ItemIndex := 0;
  cbEmpAb.ItemHeight := 1;
  edtPostName.Text := '';
  edtPostCode.Text := '';
  rbNewEmp.Checked := False;
  rbActiveGroupHis.Checked := False;
  Close;
end;

 // 모달리스 창으로 사원정보 전달
procedure TfmSearchEmp.sendMInfo;
{var
  oCodeStaffYn, postCodeStaffYn: String; // 법인권한유무, 부서권한유무
  }
begin
  if vtMember.RecordCount > 0 then
  begin
      {
      [0] 사원번호
      [1] 사원명
      [2] 조합원코드
      [3] 법인코드
      [4] 법인명
      [5] 사업장코드
      [6] 사업장명
      [7] 부서코드
      [8] 부서명
      [9] 상태코드
      [10] 상태코드값
      }
      arrEmpInfo[0] := vtMember.FieldByName('hr_m_code').AsString;
      arrEmpInfo[1] := vtMember.FieldByName('hr_m_name').AsString;
      arrEmpInfo[2] := vtMember.FieldByName('m_code').AsString;
      arrEmpInfo[3] := vtMember.FieldByName('hr_o_code').AsString;
      arrEmpInfo[4] := vtMember.FieldByName('hr_o_name').AsString;
      arrEmpInfo[5] := vtMember.FieldByName('hr_b_code').AsString;
      arrEmpInfo[6] := vtMember.FieldByName('hr_b_name').AsString;
      arrEmpInfo[7] := vtMember.FieldByName('hr_post_code').AsString;
      arrEmpInfo[8] := vtMember.FieldByName('hr_post_name').AsString;
      arrEmpInfo[9] := vtMember.FieldByName('hr_emp_ab').AsString;
      arrEmpInfo[10] := vtMember.FieldByName('hr_emp_ab_val').AsString;

      inquiryYn := True;
      rNo := vtMember.RecNo;
      Form1.btnEmpSearchClick(Form1.btnEmpSearch);
      //SetWindowPos(Form1.Handle, HWND_TOP, 0,0,0,0, SWP_NOMOVE or SWP_NOSIZE);
      //Form1.edtMName.SetFocus;

      //ModalResult := mrOk;
    {end
    else
    begin
      //Application.Title := '사원검색';
      ShowMessage('선택한 사원의 조회권한이 없습니다.');
      Exit;
    end;
    }
  end;                                                                                 
end;

// 셀 더블클릭 시 모달리스 창으로 사원정보 전달
procedure TfmSearchEmp.cxviMemberCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  sendMInfo;
end;

procedure TfmSearchEmp.cxviMemberKeyDown(Sender: TObject; var Key: Word;
Shift: TShiftState);
begin
  if Key = VK_RETURN then
    sendMInfo;
end;

procedure TfmSearchEmp.cxviMemberMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  Handled := True;

  with TcxGridTableView(cxMember.FocusedView) do
  begin
    if WheelDelta < 0 then
    begin
      Controller.FocusedRow.Selected := False;
      DataController.GotoNext;
      DataController.MakeRecordVisible(DataController.FocusedRecordIndex);
      Controller.FocusedRow.Selected := True;
    end
    else
    begin
      Controller.FocusedRow.Selected := False;
      DataController.GotoPrev;
      DataController.MakeRecordVisible(DataController.FocusedRecordIndex);
      Controller.FocusedRow.Selected := True;
    end;
  end;
end;

procedure TfmSearchEmp.FormKeyDown(Sender: TObject; var Key: Word;
Shift: TShiftState);
begin
  if (Shift = [ssAlt]) or (Shift = [ssCtrl]) then
    Exit;

  case Key of
    VK_LEFT: // 왼쪽커서이동키로 사원검색 창간 이동
      begin
        Form1.Show;
      end;
    VK_RIGHT: // 오른쪽커서이동키
      begin
        SelectNext(ActiveControl, True, True);
        key := 0;
      end;
    {VK_RETURN:
      begin
        SelectNext(ActiveControl, True, True);
        key := 0;
      end;
    }
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

// FormClose
procedure TfmSearchEmp.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  vtMember.Close;
  Form1.db_coophr.Disconnect;
  //Action := caFree;
end;

// 조회조건 사원명 edit에서 엔터 키로 조회
procedure TfmSearchEmp.edtCondKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    btnInquiryClick(btnInquiry);
  end;
end;

procedure TfmSearchEmp.edtPostNameEnter(Sender: TObject);
begin
  if edtPostName.Text = '' then
    edtPostCode.Text := '';
end;

procedure TfmSearchEmp.edtPostNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btnPostSearchClick(btnPostSearch)
  else
    edtPostCode.Text := '';
end;

// 부서검색 창 출력
procedure TfmSearchEmp.btnPostSearchClick(Sender: TObject);
begin
  SearchPostName := Trim(edtPostName.Text);
  with TfmSearchPost.Create(Application) do
  begin
    if ShowModal = mrOK then
    begin
      edtPostCode.Text := arrPostInfo[0];
      edtPostName.Text := arrPostInfo[1];
    end;
    Free;
  end;
end;

// 소속 법인 콤보박스 선택 시
procedure TfmSearchEmp.cbOCodeChange(Sender: TObject);
begin
  if cbOCode.ItemIndex = 0 then
  begin
    setCbCode(Form1.db_coophr, Form1.qrysql, 'b_code', 'S', cbBCode); // 사용자의 법인 권한있는 사업장 조회
  end
  else
  begin
    setCbCode(Form1.db_coophr, Form1.qrysql, 'b_code', 'S', cbBCode, getCommCodeVal(cbOCode)); // 선택 법인의 사업장 조회
  end;
end;

//No 필드
procedure TfmSearchEmp.grdcolNoGetDisplayText(Sender: TcxCustomGridTableItem;
  ARecord: TcxCustomGridRecord; var AText: string);
begin
  AText := IntToStr(Arecord.Index + 1);
end;

// 엑셀 다운로드
procedure TfmSearchEmp.btnExcelClick(Sender: TObject);
var
  xl        :  Variant;
  xlbook    :  Variant;
  xlsheet1  :  Variant;
begin
  xl := CreateOleObject('Excel.Application');  // 엑셀설치

  if (not vtMember.Active) then
  begin
    ShowMessage('조회 후 사용하세요.');
    Exit;
  end
  else if (vtMember.RecordCount = 0) then
  begin
    ShowMessage('조회내역이 없습니다.');
    Exit;
  end;

  Screen.Cursor := crHourGlass;

  ExportGridToExcel('사원검색.xls', cxMember);
  xlbook := xl.WorkBooks.Add(ExtractFilePath(Application.ExeName)+'사원검색.xls');

  xl.DisplayAlerts := False;
  xl.Visible := true;

  try
  except
    xlbook.Close;
    xl.Quit;
    xl := UnAssigned;
  end;

  Screen.Cursor := crDefault;
end;

procedure TfmSearchEmp.btnCancelClick(Sender: TObject);
begin
  rbNewEmp.Checked := False;
  rbActiveGroupHis.Checked := False;
end;

end.
