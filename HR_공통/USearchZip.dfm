object fmSearchZip: TfmSearchZip
  Left = 885
  Top = 114
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #50864#54200#48264#54840#44160#49353
  ClientHeight = 562
  ClientWidth = 634
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #44404#47548
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
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
    ButtonWidth = 57
    Caption = 'ToolBar1'
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
  object StatusBar1: TStatusBar
    Left = 0
    Top = 543
    Width = 634
    Height = 19
    Panels = <
      item
        Text = 'F1-'#46020#50880#47568', F9-'#51312#54924
        Width = 50
      end>
  end
  object PageControl1: TPageControl
    Left = 2
    Top = 32
    Width = 632
    Height = 512
    ActivePage = TabSheet1
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #44404#47548
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = ' '#46020#47196#47749#51452#49548' '
      object gb_cd_save: TGroupBox
        Left = 3
        Top = 2
        Width = 617
        Height = 77
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #44404#47548
        Font.Style = []
        ParentFont = False
        TabOrder = 0
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
          Left = 314
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
          Left = 324
          Top = 23
          Width = 45
          Height = 13
          Caption = #49884#183#44400#183#44396
        end
        object Image2: TImage
          Left = 11
          Top = 50
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
        object Label2: TLabel
          Left = 21
          Top = 47
          Width = 39
          Height = 13
          Caption = #46020#47196#47749
        end
        object Label3: TLabel
          Left = 21
          Top = 23
          Width = 29
          Height = 13
          Caption = #49884#183#46020
        end
        object Image3: TImage
          Left = 314
          Top = 50
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
        object Label4: TLabel
          Left = 324
          Top = 47
          Width = 97
          Height = 13
          Caption = #49884#183#44400#183#44396'('#51021#183#47732')'#47749
        end
        object edtZip1Addr2: TEdit
          Left = 65
          Top = 43
          Width = 235
          Height = 21
          Hint = #46020#47196#47749'+'#44148#47932#48264#54840
          Color = 13827839
          ImeMode = imSHanguel
          ImeName = 'Microsoft IME 2010'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnKeyPress = edtZip1Addr2KeyPress
        end
        object cbCityNm: TComboBox
          Left = 65
          Top = 19
          Width = 235
          Height = 21
          Style = csDropDownList
          Color = clWhite
          ImeMode = imSHanguel
          ImeName = 'Microsoft IME 2010'
          TabOrder = 0
          OnChange = cbCityNmChange
        end
        object cbSigunguCode: TComboBox
          Left = 376
          Top = 19
          Width = 232
          Height = 21
          Style = csDropDownList
          Color = clWhite
          ImeMode = imSHanguel
          ImeName = 'Microsoft IME 2010'
          TabOrder = 1
        end
        object cbCityCd: TComboBox
          Left = 23
          Top = 3
          Width = 50
          Height = 21
          Style = csDropDownList
          Color = clWhite
          ImeMode = imSHanguel
          ImeName = 'Microsoft IME 2010'
          TabOrder = 4
          Visible = False
          OnChange = cbCityNmChange
        end
        object edtZip1Addr1: TEdit
          Left = 427
          Top = 43
          Width = 181
          Height = 21
          Color = clWhite
          ImeMode = imSHanguel
          ImeName = 'Microsoft IME 2010'
          TabOrder = 3
        end
        object cbCitySortSeq: TComboBox
          Left = 74
          Top = 3
          Width = 50
          Height = 21
          Style = csDropDownList
          Color = clWhite
          ImeMode = imSHanguel
          ImeName = 'Microsoft IME 2010'
          TabOrder = 5
          Visible = False
          OnChange = cbCityNmChange
        end
      end
      object grdZip1: TcxGrid
        Left = 3
        Top = 82
        Width = 617
        Height = 397
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #44404#47548
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        LookAndFeel.NativeStyle = False
        object grdviZip1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          FindPanel.DisplayMode = fpdmManual
          OnCellDblClick = grdviZip1CellDblClick
          DataController.DataSource = dsZip1
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
          object grdcolZip1Code: TcxGridDBColumn
            Caption = #50864#54200#48264#54840
            DataBinding.FieldName = 'zip_code'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.Alignment.Horz = taCenter
            HeaderAlignmentHorz = taCenter
            Width = 70
          end
          object grdcolZip1Addr1: TcxGridDBColumn
            Caption = #49884#183#44400#183#44396'('#51021#183#47732')'#47749
            DataBinding.FieldName = 'addr1'
            PropertiesClassName = 'TcxTextEditProperties'
            HeaderAlignmentHorz = taCenter
            Width = 195
          end
          object grdcolZip1Addr2: TcxGridDBColumn
            Caption = #46020#47196#47749#51452#49548
            DataBinding.FieldName = 'addr2'
            PropertiesClassName = 'TcxTextEditProperties'
            HeaderAlignmentHorz = taCenter
            Width = 320
          end
        end
        object grdlvZip1: TcxGridLevel
          GridView = grdviZip1
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = ' '#51648#48264#51452#49548' '
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox1: TGroupBox
        Left = 3
        Top = 2
        Width = 617
        Height = 77
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #44404#47548
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object Image4: TImage
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
        object Image5: TImage
          Left = 312
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
        object Label5: TLabel
          Left = 322
          Top = 23
          Width = 45
          Height = 13
          Caption = #49884#183#44400#183#44396
        end
        object Image6: TImage
          Left = 11
          Top = 50
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
        object Label6: TLabel
          Left = 21
          Top = 47
          Width = 39
          Height = 13
          Caption = #44160#49353#50612
        end
        object Label7: TLabel
          Left = 21
          Top = 23
          Width = 29
          Height = 13
          Caption = #49884#183#46020
        end
        object cbSigunguCode2: TComboBox
          Left = 374
          Top = 19
          Width = 234
          Height = 21
          Style = csDropDownList
          Color = clWhite
          ImeMode = imSHanguel
          ImeName = 'Microsoft IME 2010'
          TabOrder = 1
        end
        object cbCityNm2: TComboBox
          Left = 65
          Top = 19
          Width = 234
          Height = 21
          Style = csDropDownList
          Color = clWhite
          ImeMode = imSHanguel
          ImeName = 'Microsoft IME 2010'
          TabOrder = 0
          OnChange = cbCityNmChange
        end
        object edtZipAddr: TEdit
          Left = 65
          Top = 43
          Width = 543
          Height = 21
          Color = 13827839
          ImeMode = imSHanguel
          ImeName = 'Microsoft IME 2010'
          TabOrder = 2
          OnKeyPress = edtZip1Addr2KeyPress
        end
        object cbCityCd2: TComboBox
          Left = 65
          Top = 19
          Width = 50
          Height = 21
          Style = csDropDownList
          Color = clWhite
          ImeMode = imSHanguel
          ImeName = 'Microsoft IME 2010'
          TabOrder = 3
          Visible = False
          OnChange = cbCityNmChange
        end
      end
      object grdZip: TcxGrid
        Left = 3
        Top = 82
        Width = 617
        Height = 397
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #44404#47548
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        LookAndFeel.NativeStyle = False
        object grdviZipDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          FindPanel.DisplayMode = fpdmManual
          OnCellDblClick = grdviZip1CellDblClick
          DataController.DataSource = dsZip
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
          object grdcolZipCode: TcxGridDBColumn
            Caption = #50864#54200#48264#54840
            DataBinding.FieldName = 'zip_code'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.Alignment.Horz = taCenter
            HeaderAlignmentHorz = taCenter
            Width = 70
          end
          object grdcolAddr1: TcxGridDBColumn
            Caption = #51452#49548
            DataBinding.FieldName = 'addr1'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.Alignment.Horz = taLeftJustify
            HeaderAlignmentHorz = taCenter
            Width = 250
          end
          object grdcolAddr2: TcxGridDBColumn
            Caption = #49345#49464#51452#49548
            DataBinding.FieldName = 'addr2'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.Alignment.Horz = taLeftJustify
            HeaderAlignmentHorz = taCenter
            Width = 250
          end
        end
        object grdlvZipLevel1: TcxGridLevel
          GridView = grdviZipDBTableView1
        end
      end
    end
  end
  object Memo1: TMemo
    Left = 145
    Top = 464
    Width = 271
    Height = 57
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #44404#47548
    Font.Style = []
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    TabOrder = 3
    Visible = False
  end
  object vtZip: TVirtualTable
    Options = [voPersistentData, voStored, voSkipUnSupportedFieldTypes]
    Left = 37
    Top = 480
    Data = {03000000000000000000}
  end
  object dsZip: TDataSource
    DataSet = vtZip
    Left = 80
    Top = 480
  end
  object vtZip1: TVirtualTable
    Options = [voPersistentData, voStored, voSkipUnSupportedFieldTypes]
    Left = 37
    Top = 416
    Data = {03000000000000000000}
  end
  object dsZip1: TDataSource
    DataSet = vtZip1
    Left = 80
    Top = 416
  end
end
