object fmSearchBank: TfmSearchBank
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = #51008#54665#44160#49353
  ClientHeight = 472
  ClientWidth = 344
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #44404#47548
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object tlb1: TToolBar
    Left = 0
    Top = 0
    Width = 344
    Height = 29
    ButtonHeight = 21
    ButtonWidth = 57
    Caption = 'tlb1'
    EdgeBorders = [ebTop, ebBottom]
    ShowCaptions = True
    TabOrder = 0
    object btnInquiry: TToolButton
      Left = 0
      Top = 0
      Caption = #51312#54924'(F9)'
      ImageIndex = 0
      OnClick = btnInquiryClick
    end
    object btnClose: TToolButton
      Left = 57
      Top = 0
      Caption = #51333#47308
      ImageIndex = 2
      OnClick = btnCloseClick
    end
  end
  object grpgb: TGroupBox
    Left = 0
    Top = 29
    Width = 344
    Height = 56
    Align = alTop
    TabOrder = 1
    object img1: TImage
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
    object lb1: TLabel
      Left = 22
      Top = 23
      Width = 75
      Height = 13
      Caption = #51008#54665#47749'('#53076#46300')'
    end
    object edtBank: TEdit
      Left = 103
      Top = 19
      Width = 217
      Height = 21
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #44404#47548
      Font.Style = []
      ImeMode = imSHanguel
      ImeName = 'Microsoft IME 2010'
      ParentFont = False
      TabOrder = 0
      OnKeyPress = edtBankKeyPress
    end
  end
  object stat1: TStatusBar
    Left = 0
    Top = 453
    Width = 344
    Height = 19
    Panels = <
      item
        Text = 'F9-'#51312#54924', ESC-'#51333#47308
        Width = 50
      end>
  end
  object grdBank: TcxGrid
    Left = 0
    Top = 85
    Width = 344
    Height = 368
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #44404#47548
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    LookAndFeel.NativeStyle = False
    object grdviBank: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      Navigator.Buttons.First.Visible = True
      Navigator.Buttons.PriorPage.Visible = True
      Navigator.Buttons.Prior.Visible = True
      Navigator.Buttons.Next.Visible = True
      Navigator.Buttons.NextPage.Visible = True
      Navigator.Buttons.Last.Visible = True
      Navigator.Buttons.Insert.Visible = True
      Navigator.Buttons.Append.Visible = False
      Navigator.Buttons.Delete.Visible = True
      Navigator.Buttons.Edit.Visible = True
      Navigator.Buttons.Post.Visible = True
      Navigator.Buttons.Cancel.Visible = True
      Navigator.Buttons.Refresh.Visible = True
      Navigator.Buttons.SaveBookmark.Visible = True
      Navigator.Buttons.GotoBookmark.Visible = True
      Navigator.Buttons.Filter.Visible = True
      OnCellDblClick = grdviBankCellDblClick
      DataController.DataSource = dsBankCode
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
      Styles.Header = Form1.cxstylGrdTitle
      object grdcolBankNo: TcxGridDBColumn
        Caption = 'No'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        OnGetDisplayText = grdcolBankNoGetDisplayText
        HeaderAlignmentHorz = taCenter
        Width = 35
      end
      object grdcolBankfval: TcxGridDBColumn
        Caption = #51008#54665#53076#46300
        DataBinding.FieldName = 'fval'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        HeaderAlignmentHorz = taCenter
        Width = 65
      end
      object grdcolBankfname: TcxGridDBColumn
        Caption = #51008#54665#47749
        DataBinding.FieldName = 'fname'
        HeaderAlignmentHorz = taCenter
        Width = 210
      end
    end
    object grdlvBank: TcxGridLevel
      GridView = grdviBank
    end
  end
  object vtBankCode: TVirtualTable
    Options = [voPersistentData, voStored, voSkipUnSupportedFieldTypes]
    Left = 29
    Top = 393
    Data = {03000000000000000000}
    object vtBankCodefval: TStringField
      FieldName = 'fval'
      Size = 3
    end
    object vtBankCodefname: TStringField
      FieldName = 'fname'
      Size = 30
    end
  end
  object dsBankCode: TDataSource
    DataSet = vtBankCode
    Left = 101
    Top = 392
  end
end
