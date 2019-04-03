object fmSearchEarner: TfmSearchEarner
  Left = 0
  Top = 0
  Caption = #49548#46301#51088#44160#49353
  ClientHeight = 522
  ClientWidth = 724
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
    Width = 724
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
  object stat1: TStatusBar
    Left = 0
    Top = 503
    Width = 724
    Height = 19
    Panels = <
      item
        Text = 'F9-'#51312#54924', ESC-'#51333#47308
        Width = 50
      end>
  end
  object grdEarner: TcxGrid
    Left = 0
    Top = 85
    Width = 724
    Height = 418
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #44404#47548
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    LookAndFeel.NativeStyle = False
    object grdviEarner: TcxGridDBTableView
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
      OnCellDblClick = grdviEarnerCellDblClick
      DataController.DataSource = dsEarner
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.Deleting = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.CellSelect = False
      OptionsView.NoDataToDisplayInfoText = ' '
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      OptionsView.Indicator = True
      Styles.Content = Form1.cxstylGrdCont
      Styles.Header = Form1.cxstylGrdTitle
      object grdcolEarnerNo: TcxGridDBColumn
        Caption = 'No'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        OnGetDisplayText = grdcolEarnerNoGetDisplayText
        HeaderAlignmentHorz = taCenter
        Width = 35
      end
      object grdcolEarnerhr_p_check: TcxGridDBColumn
        DataBinding.FieldName = 'hr_p_check'
        Visible = False
        HeaderAlignmentHorz = taCenter
      end
      object grdcolEarnerhr_p_name: TcxGridDBColumn
        Caption = #49457#47749
        DataBinding.FieldName = 'hr_p_name'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        HeaderAlignmentHorz = taCenter
        Width = 120
      end
      object grdcolEarnerhr_p_sangho: TcxGridDBColumn
        Caption = #49345#54840
        DataBinding.FieldName = 'hr_p_sangho'
        Visible = False
        HeaderAlignmentHorz = taCenter
        Width = 120
      end
      object grdcolEarnerhr_id_no: TcxGridDBColumn
        Caption = #51452#48124#46321#47197#48264#54840
        DataBinding.FieldName = 'hr_id_no'
        PropertiesClassName = 'TcxMaskEditProperties'
        Properties.Alignment.Horz = taCenter
        Properties.AlwaysShowBlanksAndLiterals = True
        Properties.EditMask = '!000000-0000000;0;_'
        HeaderAlignmentHorz = taCenter
        Width = 120
      end
      object grdcolEarnerhr_p_no: TcxGridDBColumn
        Caption = #49324#50629#51088#46321#47197#48264#54840
        DataBinding.FieldName = 'hr_p_no'
        PropertiesClassName = 'TcxMaskEditProperties'
        Properties.Alignment.Horz = taCenter
        Properties.AlwaysShowBlanksAndLiterals = True
        Properties.EditMask = '!000-00-00000;0;_'
        Visible = False
        HeaderAlignmentHorz = taCenter
        Width = 120
      end
      object grdcolEarnerhr_p_zip3: TcxGridDBColumn
        Caption = #50864#54200#48264#54840
        DataBinding.FieldName = 'hr_p_zip3'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        HeaderAlignmentHorz = taCenter
        Width = 65
      end
      object grdcolEarnerhr_p_addr3: TcxGridDBColumn
        Caption = #51452#49548
        DataBinding.FieldName = 'hr_p_addr3'
        HeaderAlignmentHorz = taCenter
        Width = 350
      end
    end
    object grdlvEarner: TcxGridLevel
      GridView = grdviEarner
    end
  end
  object grpgb: TGroupBox
    Left = 0
    Top = 29
    Width = 724
    Height = 56
    Align = alTop
    TabOrder = 3
    object img1: TImage
      Left = 151
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
    object lbName: TLabel
      Left = 162
      Top = 23
      Width = 26
      Height = 13
      Caption = #49457#47749
    end
    object img2: TImage
      Left = 356
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
    object lbIdNo: TLabel
      Left = 367
      Top = 23
      Width = 78
      Height = 13
      Caption = #51452#48124#46321#47197#48264#54840
    end
    object shp1: TShape
      Left = 12
      Top = 17
      Width = 124
      Height = 24
      Brush.Style = bsClear
      Pen.Color = clSilver
    end
    object edtName: TEdit
      Left = 194
      Top = 19
      Width = 150
      Height = 21
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #44404#47548
      Font.Style = []
      ImeMode = imSHanguel
      ImeName = 'Microsoft IME 2010'
      ParentFont = False
      TabOrder = 1
      OnKeyPress = edtNameKeyPress
    end
    object medtIdNo: TMaskEdit
      Left = 464
      Top = 19
      Width = 146
      Height = 21
      Color = clWhite
      EditMask = '!999999-9999999;0;_'
      ImeMode = imSHanguel
      ImeName = 'Microsoft IME 2010'
      MaxLength = 14
      TabOrder = 2
      Text = ''
      OnKeyPress = edtNameKeyPress
    end
    object rgxPersonal: TcxRadioGroup
      Left = 13
      Top = 18
      Ctl3D = False
      ParentBackground = False
      ParentColor = False
      ParentCtl3D = False
      Properties.Columns = 2
      Properties.Items = <
        item
          Caption = #44060#51064
        end
        item
          Caption = #48277#51064
        end>
      ItemIndex = 0
      Style.BorderColor = clBlack
      Style.BorderStyle = ebsNone
      Style.Color = clBtnFace
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      Style.LookAndFeel.NativeStyle = False
      StyleDisabled.Color = clWhite
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 0
      OnClick = rgxPersonalClick
      Height = 22
      Width = 122
    end
  end
  object Memo1: TMemo
    Left = 224
    Top = 392
    Width = 265
    Height = 89
    Lines.Strings = (
      'Memo1')
    TabOrder = 4
    Visible = False
  end
  object vtEarner: TVirtualTable
    Options = [voPersistentData, voStored, voSkipUnSupportedFieldTypes]
    Left = 64
    Top = 408
    Data = {03000000000000000000}
    object vtEarnerhr_p_check: TStringField
      FieldName = 'hr_p_check'
      Size = 1
    end
    object vtEarnerhr_p_name: TStringField
      FieldName = 'hr_p_name'
      Size = 10
    end
    object vtEarnerhr_p_sangho: TStringField
      FieldName = 'hr_p_sangho'
      Size = 50
    end
    object vtEarnerhr_id_no: TStringField
      FieldName = 'hr_id_no'
      Size = 13
    end
    object vtEarnerhr_p_no: TStringField
      FieldName = 'hr_p_no'
      Size = 10
    end
    object vtEarnerhr_p_zip3: TStringField
      FieldName = 'hr_p_zip3'
      Size = 6
    end
    object vtEarnerhr_p_addr3: TStringField
      FieldName = 'hr_p_addr3'
      Size = 255
    end
  end
  object dsEarner: TDataSource
    DataSet = vtEarner
    Left = 136
    Top = 408
  end
end
