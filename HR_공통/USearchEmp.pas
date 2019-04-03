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
    minSize, maxSize: TPoint; // �ּ�, �ִ�ũ�� ����
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
  authAllYn: Boolean = False; // ���� ������� ��ü ������ �ٷ��� ��ȸ

implementation

uses coophr_utils, coop_sql_updel, Unit1, USearchPost;

{$R *.dfm}

// �� ũ�� ����
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
  // ���������ڵ� �޺��ڽ��� ����
  setCbCommCode(Form1.qrysql, Form1.vtTemp, 'hr_emp_ab', 'A', cbEmpAb);
  cbAb.ItemIndex := 0;

  // ������� ���� �ִ� �Ҽ�, �μ� �޺��ڽ��� ����
  setCbCode(Form1.db_coophr, Form1.qrysql, 'o_code' , 'A', cbOCode); // �Ҽ�
  setCbCode(Form1.db_coophr, Form1.qrysql, 'b_code', 'A', cbBCode); // �����

  // ������� �ʱⰪ - ������
  cbEmpAb.ItemIndex := 1;

  showCtrl(Memo1);
end;

procedure TfmSearchEmp.FormShow(Sender: TObject);
begin
  // �� �ּ�ũ�� ���� 1024 * 745
  minSize.X := 1024;
  minSize.Y := 745;
  // �� �ִ�ũ�� ����
  maxSize.X := GetSystemMetrics(SM_CXSCREEN); // ������ػ�
  maxSize.Y := GetSystemMetrics(SM_CYSCREEN);

  // ShowMessage �������� ����
  Screen.OnActiveFormChange := Form1.OnScreenActiveFormChange;

  ToolBar1DblClick(ToolBar1);
end;

procedure TfmSearchEmp.ToolBar1DblClick(Sender: TObject);
begin
  showCtrl(Memo1);
end;

procedure TfmSearchEmp.FormActivate(Sender: TObject);
begin
  // ����Է� Ȯ��
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

// ��ȸ
procedure TfmSearchEmp.btnInquiryClick(Sender: TObject);
var
  empCond, oCodeCond, bCodeCond: String; // ��ȸ����
  subSqlEmpCond, subSqlOCode, subSqlBCode, subSqlPostCode, subSqlEmpAb, subSqlAb: String;
  i: Integer;
  pDt: TDateTime;
begin
  // ��ȸ���� ���� *************************************************************
  empCond := Trim(edtCond.Text);
  oCodeCond := ''; bCodeCond := '';
  subSqlEmpCond := ''; subSqlOCode := ''; subSqlBCode := ''; subSqlPostCode := ''; subSqlEmpAb := ''; subSqlAb := '';

  if (not rbNewEmp.Checked) and (not rbActiveGroupHis.Checked) then
  begin
    // ��ȸ���ǿ��� �Ҽ�, �����, �μ�, ���(����� 2�����̻�) �� �ϳ��̻� ���� �ʼ�
    if (cbOCode.ItemIndex = 0) and (cbBCode.ItemIndex = 0) and (not isEmpty(edtPostCode.Text)) and (Length(empCond) < 2) then
    begin
      ShowMessage('�Ҽ�, �����, �μ�, ��� �� �ϳ��̻��� �ʼ� ���� �����Դϴ�.');
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

  // ����� �Ǵ� �����ȣ
  if (cbAb.ItemIndex = 0) and isEmpty(empCond) then // �����
  begin
    subSqlEmpCond := ' AND hr_members.hr_m_name LIKE "%' + empCond + '%"';
  end
  else if (cbAb.ItemIndex = 1) and isEmpty(empCond) then  // �����ȣ
    subSqlEmpCond := ' AND hr_members.hr_m_code LIKE "%' + empCond + '%"';

  // ����� ���� ��
  if cbBCode.ItemIndex <> 0 then
  begin
    subSqlBCode := ' AND (hr_group_his.hr_b_code = "' + copy(cbBCode.Text, 6, 3) + '")'
  end
  // ����� ��ü
  else
  begin
    // �Ҽӹ��� ��ü
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
    // �Ҽӹ��� ���� ��
    else
    begin
      subSqlOCode := ' AND hr_group_his.hr_o_code = "' + copy(cbOCode.Text, 1, 4) + '"';
    end;
  end;

  // �μ� ���� ��
  if Length(Trim(edtPostCode.Text)) = 4 then
  begin
    subSqlPostCode := ' AND hr_post_code = "' + Trim(edtPostCode.Text) + '"';
  end;

  {
  if cbPostCode.Items.Count > 1 then // ��ȸ���� �μ� �ϳ� �̻��̸�
  begin
    if cbPostCode.ItemIndex = 0 then // ��ü
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
  // ä�뿬�� �ű��Ի��� ��ȸ
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
                  + ' WHERE ((history LIKE "ä�뿬��%" AND hr_group_his.hr_o_code IS NULL)'
                  // 2015-03-30 ä�뿬�� ���Ի��� ��ȸ�ǰ� (�λ������� ��û)
                  + ' OR (history LIKE "%ä�뿬��%" AND hr_emp_ab = "3"))'
                  + subSqlEmpCond
                  + ' ORDER BY hr_changeday DESC, hr_seq_no DESC'
            + ') MEMB'
            + ' GROUP BY hr_m_code'
            + ' HAVING (hr_emp_ab = "3" AND hr_ab = "B")'   // ���Ի��� ������ �λ�߷��� ����� ���
            + ' OR (hr_emp_ab = "3" AND hr_o_code IS NULL)' // ä�뿬������ ������ 2���̻� �� ��� ���Ի��ڷ� ����
            + ' OR hr_emp_ab = "1"';                        // �ű��Ի���
  end

  // ��ȿ�� �λ�߷��� �ִ� �����
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
  // �λ��̷¾���
  else if rbNoExistGroupHis.Checked then
  begin
    if (cbEmpAb.ItemIndex = 1) then // 1:������ ���� �� ���Ի��� ���� ��ȸ
      subSqlEmpAb := ' AND hr_emp_ab IN ("1", "3")'  // 1:������, 3:���Ի���

    else if (cbEmpAb.ItemIndex in [2,4]) then  // 2:�����, 4:���Ի�������
      subSqlEmpAb := ' AND hr_emp_ab = "' + subStr(cbEmpAb.Text, 1, ' ') + '"'

    else if (cbEmpAb.ItemIndex = 3) then  // 3:���Ի���
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
    // �����ڵ�
    if (cbEmpAb.ItemIndex = 0) then
    begin
      //subSqlEmpAb := ' AND hr_group_his.hr_ab <> "B"'; // �����ڵ� - B:��� (2:�����, 4:���Ի�������, �Ҽӹ��κ��� ����)
      subSqlAb    := ' HAVING 1=1';
    end

    else if (cbEmpAb.ItemIndex = 1) then // 1:������ ���� �� ���Ի��� ���� ��ȸ
    begin
      subSqlEmpAb := ' AND hr_members.hr_emp_ab IN ("1", "3")';  // 1:������, 3:���Ի���
      subSqlAb    := ' HAVING hr_ab NOT IN ("B", "E")';
    end

    else if (cbEmpAb.ItemIndex in [2,4]) then  // 2:�����, 4:���Ի�������
    begin
      subSqlEmpAb := ' AND hr_members.hr_emp_ab = "' + subStr(cbEmpAb.Text, 1, ' ') + '"';
      subSqlAb    := ' HAVING 1=1';
    end

    else if (cbEmpAb.ItemIndex = 3) then  // 3:���Ի���
    begin
      subSqlEmpAb := ' AND hr_members.hr_emp_ab = "' + subStr(cbEmpAb.Text, 1, ' ') + '"';
      subSqlAb    := ' HAVING hr_ab NOT IN ("B", "E")';
    end

    else
      subSqlEmpAb := '';

    // *************************************************************************
    // ���� ����
    // 2. 2015-10-01 �Ի����ڿ� ������ڰ� ���� �Ͽ����� ��� �߷����� ���� ��ȸ ��
    //   �Ի��̷��� ���� ��ȸ�Ǿ� ���߼����Ҽ����� ��ȸ�Ǵ� ��� �߻��Ͽ� �߷�����, �Ϸù�ȣ �������� ����

    // 1. 2015-08-04 �����ҼӺ���߷� ���� ����� �Ҽ��� ���泻�� �߻��Ͽ� ����� ���(MAX(�Ϸù�ȣ)�� �Է�)
    //    - �����ҼӺ��� �� �������� ����� ���Ŀ� ���� ��� ��
    //   ���߼Ҽ����� ��ȸ�Ǵ� ��� �߻��Ͽ� �Ϸù�ȣ ���� ��ȸ���� �߷����� �������� ����

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
            // 2015-08-04 �����ҼӺ���߷� ���� ����� �Ҽ��� ���泻�� �߻��Ͽ� ����� ���(MAX(�Ϸù�ȣ)�� �Է�)
            //  - �����ҼӺ��� �� �������� ����� ���Ŀ� ���� ��� ��
            // ���߼Ҽ����� ��ȸ�Ǵ� ��� �߻��Ͽ� �Ϸù�ȣ ���� ��ȸ���� �߷����� �������� ����
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
    ShowMessage('������ �߻��Ͽ����ϴ�.[' + ashStr + '](ERR:�����ȸ)');
    Screen.Cursor := crDefault;
    Exit;
  end;

  Screen.Cursor := crDefault;
Memo1.Lines.Add(FormatDateTime('hhmmss', Now - pDt));

  if vtMember.RecordCount = 1 then // �˻������ 1���̸�
  begin
   //grdMemberDblClick(grdMember);
  end
  else if vtMember.RecordCount < 1 then
  begin
    //Application.Title := '����˻�';
    ShowMessage('��ȸ������ ���ų� �˻������ �����ϴ�.');
  end;
end;

// �����ư Ŭ�� ��
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

 // ��޸��� â���� ������� ����
procedure TfmSearchEmp.sendMInfo;
{var
  oCodeStaffYn, postCodeStaffYn: String; // ���α�������, �μ���������
  }
begin
  if vtMember.RecordCount > 0 then
  begin
      {
      [0] �����ȣ
      [1] �����
      [2] ���տ��ڵ�
      [3] �����ڵ�
      [4] ���θ�
      [5] ������ڵ�
      [6] ������
      [7] �μ��ڵ�
      [8] �μ���
      [9] �����ڵ�
      [10] �����ڵ尪
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
      //Application.Title := '����˻�';
      ShowMessage('������ ����� ��ȸ������ �����ϴ�.');
      Exit;
    end;
    }
  end;                                                                                 
end;

// �� ����Ŭ�� �� ��޸��� â���� ������� ����
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
    VK_LEFT: // ����Ŀ���̵�Ű�� ����˻� â�� �̵�
      begin
        Form1.Show;
      end;
    VK_RIGHT: // ������Ŀ���̵�Ű
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
    VK_ESCAPE: // ESC Ű
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

// ��ȸ���� ����� edit���� ���� Ű�� ��ȸ
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

// �μ��˻� â ���
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

// �Ҽ� ���� �޺��ڽ� ���� ��
procedure TfmSearchEmp.cbOCodeChange(Sender: TObject);
begin
  if cbOCode.ItemIndex = 0 then
  begin
    setCbCode(Form1.db_coophr, Form1.qrysql, 'b_code', 'S', cbBCode); // ������� ���� �����ִ� ����� ��ȸ
  end
  else
  begin
    setCbCode(Form1.db_coophr, Form1.qrysql, 'b_code', 'S', cbBCode, getCommCodeVal(cbOCode)); // ���� ������ ����� ��ȸ
  end;
end;

//No �ʵ�
procedure TfmSearchEmp.grdcolNoGetDisplayText(Sender: TcxCustomGridTableItem;
  ARecord: TcxCustomGridRecord; var AText: string);
begin
  AText := IntToStr(Arecord.Index + 1);
end;

// ���� �ٿ�ε�
procedure TfmSearchEmp.btnExcelClick(Sender: TObject);
var
  xl        :  Variant;
  xlbook    :  Variant;
  xlsheet1  :  Variant;
begin
  xl := CreateOleObject('Excel.Application');  // ������ġ

  if (not vtMember.Active) then
  begin
    ShowMessage('��ȸ �� ����ϼ���.');
    Exit;
  end
  else if (vtMember.RecordCount = 0) then
  begin
    ShowMessage('��ȸ������ �����ϴ�.');
    Exit;
  end;

  Screen.Cursor := crHourGlass;

  ExportGridToExcel('����˻�.xls', cxMember);
  xlbook := xl.WorkBooks.Add(ExtractFilePath(Application.ExeName)+'����˻�.xls');

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
