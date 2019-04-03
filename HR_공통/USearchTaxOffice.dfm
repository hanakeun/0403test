object fmSearchTaxOffice: TfmSearchTaxOffice
  Left = 235
  Top = 139
  Caption = #49464#47924#49436#44160#49353
  ClientHeight = 562
  ClientWidth = 634
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #44404#47548
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 634
    Height = 29
    ButtonHeight = 21
    ButtonWidth = 72
    Caption = 'ToolBar1'
    EdgeBorders = [ebTop, ebBottom]
    ShowCaptions = True
    TabOrder = 0
    OnDblClick = ToolBar1DblClick
    object btnInquiry: TToolButton
      Left = 0
      Top = 0
      Caption = #51312#54924'(F9)'
      ImageIndex = 0
      OnClick = btnInquiryClick
    end
    object btnClose: TToolButton
      Left = 72
      Top = 0
      Caption = #51333#47308
      ImageIndex = 2
      OnClick = btnCloseClick
    end
    object btn1: TToolButton
      Left = 144
      Top = 0
      Width = 200
      Caption = 'btn1'
      ImageIndex = 3
      Style = tbsSeparator
    end
    object btnExcelUp: TToolButton
      Left = 344
      Top = 0
      Caption = #50641#49472#50629#47196#46300
      ImageIndex = 3
      Visible = False
      OnClick = btnExcelUpClick
    end
    object btnSave: TToolButton
      Left = 416
      Top = 0
      Caption = #51200#51109
      ImageIndex = 4
      Visible = False
      OnClick = btnSaveClick
    end
  end
  object gb_cd_save: TGroupBox
    Left = 0
    Top = 29
    Width = 634
    Height = 59
    Align = alTop
    TabOrder = 1
    object Image1: TImage
      Left = 11
      Top = 26
      Width = 6
      Height = 6
      Picture.Data = {
        07544269746D6170AE000000424DAE0000000000000036000000280000000600
        000006000000010018000000000078000000C40E0000C40E0000000000000000
        0000FBEED1F2C25BF2C25BF2C25BF2C25BFCF2DC0000DAA92EDAA92EDAA92EDA
        A92EDAA92EDCAE3A0000CD9C16CD9C16CD9C16CD9C16CD9C16D0A2240000D7A5
        32D7A532D7A532D7A532D7A532D9AA3E0000DAA93DDAA93DDAA93DDAA93DDAA9
        3DDCAE480000F3E1BEDEAE4EDEAE4EDEAE4EDEAE4EF6E9CF0000}
    end
    object Image30: TImage
      Left = 303
      Top = 26
      Width = 6
      Height = 6
      Picture.Data = {
        07544269746D6170AE000000424DAE0000000000000036000000280000000600
        000006000000010018000000000078000000C40E0000C40E0000000000000000
        0000FBEED1F2C25BF2C25BF2C25BF2C25BFCF2DC0000DAA92EDAA92EDAA92EDA
        A92EDAA92EDCAE3A0000CD9C16CD9C16CD9C16CD9C16CD9C16D0A2240000D7A5
        32D7A532D7A532D7A532D7A532D9AA3E0000DAA93DDAA93DDAA93DDAA93DDAA9
        3DDCAE480000F3E1BEDEAE4EDEAE4EDEAE4EDEAE4EF6E9CF0000}
    end
    object Label1: TLabel
      Left = 313
      Top = 23
      Width = 52
      Height = 13
      Caption = #44288#54624#44396#50669
    end
    object Label2: TLabel
      Left = 21
      Top = 23
      Width = 101
      Height = 13
      Caption = #52397#49436#47749'('#52397#49436#53076#46300')'
    end
    object edtTaxOffice: TEdit
      Left = 130
      Top = 19
      Width = 161
      Height = 21
      Color = clWhite
      ImeMode = imSHanguel
      ImeName = 'Microsoft IME 2010'
      TabOrder = 0
      OnKeyPress = edtTaxOfficeKeyPress
    end
    object edtZone: TEdit
      Left = 370
      Top = 19
      Width = 251
      Height = 21
      Color = clWhite
      ImeMode = imSHanguel
      ImeName = 'Microsoft IME 2010'
      TabOrder = 1
      OnKeyPress = edtZoneKeyPress
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 543
    Width = 634
    Height = 19
    Panels = <
      item
        Text = 'Ctrl+F '#52286#44592
        Width = 450
      end
      item
        BiDiMode = bdLeftToRight
        ParentBiDiMode = False
        Text = #50629#45936#51060#53944#51068#51088' : 2017-07-25'
        Width = 150
      end>
  end
  object grdTaxOffice: TcxGrid
    Left = 0
    Top = 88
    Width = 634
    Height = 455
    Align = alClient
    TabOrder = 3
    LookAndFeel.NativeStyle = False
    object grdviTaxOffice: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      FindPanel.DisplayMode = fpdmManual
      OnCellDblClick = grdviTaxOfficeCellDblClick
      DataController.DataSource = dsTaxOffice
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.Deleting = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.CellSelect = False
      OptionsView.NoDataToDisplayInfoText = ' '
      OptionsView.GroupByBox = False
      OptionsView.Indicator = True
      Styles.Content = Form1.cxstylGrdCont
      Styles.OnGetContentStyle = grdviTaxOfficeStylesGetContentStyle
      Styles.Header = Form1.cxstylGrdTitle
      object grdcolTaxOfficeCode: TcxGridDBColumn
        Caption = #52397#49436#53076#46300
        DataBinding.FieldName = 'hr_tax_office_code'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        HeaderAlignmentHorz = taCenter
        Width = 60
      end
      object grdcolTaxOfficeName: TcxGridDBColumn
        Caption = #52397#49436#47749
        DataBinding.FieldName = 'hr_tax_office_name'
        PropertiesClassName = 'TcxTextEditProperties'
        HeaderAlignmentHorz = taCenter
        Width = 85
      end
      object grdcolAcctNo: TcxGridDBColumn
        Caption = #44228#51340#48264#54840
        DataBinding.FieldName = 'hr_acct_no'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        HeaderAlignmentHorz = taCenter
        Width = 60
      end
      object grdcolZone: TcxGridDBColumn
        Caption = #44288#54624#44396#50669
        DataBinding.FieldName = 'hr_zone'
        PropertiesClassName = 'TcxTextEditProperties'
        HeaderAlignmentHorz = taCenter
        Width = 400
      end
      object grdcolZip: TcxGridDBColumn
        Caption = #50864#54200#48264#54840
        DataBinding.FieldName = 'hr_zip'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        HeaderAlignmentHorz = taCenter
        Width = 65
      end
      object grdcolAddr: TcxGridDBColumn
        Caption = #51452#49548
        DataBinding.FieldName = 'hr_addr1'
        PropertiesClassName = 'TcxTextEditProperties'
        HeaderAlignmentHorz = taCenter
        Width = 250
      end
      object grdcolTelNo: TcxGridDBColumn
        Caption = #51204#54868#48264#54840
        DataBinding.FieldName = 'hr_tel_no'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        HeaderAlignmentHorz = taCenter
        Width = 100
      end
      object grdcolFaxNo: TcxGridDBColumn
        Caption = #54057#49828#48264#54840
        DataBinding.FieldName = 'hr_fax_no'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        HeaderAlignmentHorz = taCenter
        Width = 100
      end
      object grdcolMpstCode: TcxGridDBColumn
        Caption = #52572#51333#48320#44221#49324#50896
        DataBinding.FieldName = 'mpst_code'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        HeaderAlignmentHorz = taCenter
        Width = 90
      end
      object grdcolPday: TcxGridDBColumn
        Caption = #52572#51333#48320#44221#51068#49884
        DataBinding.FieldName = 'p_day'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        HeaderAlignmentHorz = taCenter
        Width = 135
      end
      object grdcolGroupAb: TcxGridDBColumn
        DataBinding.FieldName = 'hr_group_ab'
        Visible = False
      end
    end
    object grdlvTaxOffice: TcxGridLevel
      GridView = grdviTaxOffice
    end
  end
  object dsTaxOffice: TDataSource
    DataSet = vtTaxOffice
    Left = 95
    Top = 466
  end
  object vtTaxOffice: TVirtualTable
    Options = [voPersistentData, voStored, voSkipUnSupportedFieldTypes]
    Left = 30
    Top = 466
    Data = {03000000000000000000}
    object strngfldTaxOfficehr_group_ab: TStringField
      FieldName = 'hr_group_ab'
      Size = 3
    end
  end
  object Excel1: TExcel
    ExeName = 'Excel'
    ExecLimit = 99
    Decimals = 2
    BatchMin = 200
    BatchMax = 250
    Left = 33
    Top = 400
  end
  object OpenDialog1: TOpenDialog
    Left = 98
    Top = 400
  end
end
