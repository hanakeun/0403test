object fmSearchEmp: TfmSearchEmp
  Left = 494
  Top = 114
  Caption = #49324#50896#44160#49353
  ClientHeight = 707
  ClientWidth = 1008
  Color = clBtnFace
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #44404#47548
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesigned
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 1008
    Height = 29
    ButtonHeight = 21
    ButtonWidth = 57
    Caption = 'ToolBar1'
    EdgeBorders = [ebTop, ebBottom]
    ShowCaptions = True
    TabOrder = 0
    OnDblClick = ToolBar1DblClick
    ExplicitTop = -6
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
    object btnExcel: TToolButton
      Left = 114
      Top = 0
      Caption = #50641#49472
      ImageIndex = 3
      OnClick = btnExcelClick
    end
  end
  object gb_cd_save: TGroupBox
    Left = 0
    Top = 29
    Width = 1008
    Height = 77
    Align = alTop
    TabOrder = 1
    object Label6: TLabel
      Left = 375
      Top = 47
      Width = 26
      Height = 13
      Caption = #48512#49436
    end
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
    object Image3: TImage
      Left = 364
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
    object Image30: TImage
      Left = 364
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
      Left = 374
      Top = 23
      Width = 26
      Height = 13
      Caption = #49548#49549
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
      Caption = #49324#50629#51109
    end
    object btnPostSearch: TSpeedButton
      Left = 643
      Top = 42
      Width = 22
      Height = 22
      Flat = True
      Glyph.Data = {
        96090000424D9609000000000000360000002800000028000000140000000100
        18000000000060090000C40E0000C40E00000000000000000000FFFFFFBFBFBF
        BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
        BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFFFFFFFFFFFFFD7D7D7D7D7D7D7
        D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7
        D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7FFFFFFBFBFBFD5D5D5E1E1E1E1E1E1E1E1
        E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E2E1E1E1E1E1E1E1E1E1E1E1E1E1E1
        E1E1E1E1E1E1E1E1D5D5D5BFBFBFD7D7D7E0E0E0E6E6E6E6E6E6E6E6E6E6E6E6
        E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6
        E6E6E6E6E0E0E0D7D7D7BFBFBFFFFFFFE3E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2
        E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E3E3E2E3E3E2E3E3
        E3E3E2BFBFBFD7D7D7F3F3F3E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7
        E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7D7
        D7D7BFBFBFFFFFFFE4E5E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4
        E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4BFBFBFD7D7
        D7F3F3F3E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
        E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8D7D7D7BFBFBFFFFFFF
        FFFFFFE4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4FFFF
        FFFFFFFFFFFFFFE4E4E4E4E4E4E4E4E4E4E4E4BFBFBFD7D7D7F3F3F3F3F3F3E8
        E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8F3F3F3F3F3F3
        F3F3F3E8E8E8E8E8E8E8E8E8E8E8E8D7D7D7BFBFBFFFFFFFFFFFFFE4E4E4E4E4
        E4E4E4E4E4E4E4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDDBF96B7874372
        5227E4E4E4E4E4E4E4E4E4BFBFBFD7D7D7F3F3F3F3F3F3E8E8E8E8E8E8E8E8E8
        E8E8E8F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3D5D5D5BBBBBBA5A5A5E8E8
        E8E8E8E8E8E8E8D7D7D7BFBFBFFFFFFFFFFFFFE4E4E4E4E4E4FFFFFFFFFFFFFF
        FFFFE6E1DBE3DFDBE5E0DBEBE7E2DFC298B68542714F23795E3AE4E4E4E4E4E4
        E4E4E4BFBFBFD7D7D7F3F3F3F3F3F3E8E8E8E8E8E8F3F3F3F3F3F3F3F3F3E6E6
        E6E5E5E5E6E6E6E9E9E9D6D6D6BBBBBBA4A4A4ABABABE8E8E8E8E8E8E8E8E8D7
        D7D7BFBFBFFFFFFFFFFFFFE4E4E4FFFFFFFFFFFFE0CCB0CDA266A4773A8C6937
        9D7033C19A62B38441714F227C623EEEEEEFE4E4E4E4E4E4E4E4E4BFBFBFD7D7
        D7F3F3F3F3F3F3E8E8E8F3F3F3F3F3F3DBDBDBC7C7C7B4B4B4AFAFAFB1B1B1C4
        C4C4BABABAA4A4A4ADADADECECECE8E8E8E8E8E8E8E8E8D7D7D7BFBFBFFFFFFF
        FFFFFFE5E6E6FFFFFFE4D4BDC89754D3AC74E4C9A4EAD1AFE4C294A57E487351
        2287704FE5E6E6E6E6E6E6E6E6E6E6E6E5E6E6BFBFBFD7D7D7F3F3F3F3F3F3E8
        E8E8F3F3F3DFDFDFC2C2C2CBCBCBD9D9D9DDDDDDD6D6D6B8B8B8A4A4A4B2B2B2
        E8E8E8E9E9E9E9E9E9E9E9E9E8E8E8D7D7D7BFBFBFFFFFFFFFFFFFE5E6E6FFFF
        FFD5AF7BDFC299F3EADBE9D6BAF2E8D9F6EFE6F3DFC1AC8651CCC1B1E5E6E6E6
        E6E6E6E6E6E6E6E6E5E6E6BFBFBFD7D7D7F3F3F3F3F3F3E8E8E8F3F3F3CDCDCD
        D6D6D6E9E9E9DFDFDFE8E8E8ECECECE3E3E3BBBBBBD6D6D6E8E8E8E9E9E9E9E9
        E9E9E9E9E8E8E8D7D7D7BFBFBFFFFFFFFFFFFFE8E8E8FFFFFFD6B07BF5EDE0F4
        EADBF0E1CEEDDEC8F6EEE3FAF8F2E5C497A7793AE8E8E8E8E8E8E8E8E8E8E8E8
        E8E8E8BFBFBFD7D7D7F3F3F3F3F3F3E9E9E9F3F3F3CDCDCDEAEAEAE9E9E9E5E5
        E5E3E3E3EBEBEBEFEFEFD6D6D6B5B5B5E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9D7
        D7D7BFBFBFFFFFFFFFFFFFEAEAEAFFFFFFDAB98BFEFDFDF6EEE4F2E8D9F0E4D1
        EEDEC9EEE0CCE9CFAB8C6938EAEAEAEAEAEAEAEAEAEAEAEAEAEAEABFBFBFD7D7
        D7F3F3F3F3F3F3EAEAEAF3F3F3D2D2D2F2F2F2EBEBEBE8E8E8E6E6E6E3E3E3E4
        E4E4DCDCDCAFAFAFEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAD7D7D7BFBFBFFFFFFF
        FFFFFFECECECFFFFFFDFC299FDFCFAFAF5F0F5EEE3F2E8D8EFE2CEEAD9BFE5CA
        A5A27639ECECECEDECECEDECECEDECECECECECBFBFBFD7D7D7F3F3F3F3F3F3EB
        EBEBF3F3F3D6D6D6F2F2F2EFEFEFEBEBEBE8E8E8E5E5E5E0E0E0DADADAB3B3B3
        EBEBEBEBEBEBEBEBEBEBEBEBEBEBEBD7D7D7BFBFBFFFFFFFFFFFFFEEEEEEFFFF
        FFE4CBA7F6EDE2FFFFFFFAF5EFF6EEE3F3E9DBF6EFE4D4AD77CCA266EEEEEEEE
        EEEEEEEEEEEEEEEEEEEEEEBFBFBFD7D7D7F3F3F3F3F3F3ECECECF3F3F3DADADA
        EBEBEBF3F3F3EEEEEEEBEBEBE9E9E9EBEBEBCCCCCCC7C7C7ECECECECECECECEC
        ECECECECECECECD7D7D7BFBFBFFFFFFFFFFFFFF0F0F0FFFFFFE9DAC6E6D0B1F5
        ECDFFEFDFCFFFFFFF7F0E7E0C39CC99955E6D6C0F0F0F0F0F0F0F0F0F0F0F0F0
        F0EFF0BFBFBFD7D7D7F3F3F3F3F3F3EDEDEDF3F3F3E1E1E1DDDDDDEAEAEAF2F2
        F2F3F3F3ECECECD6D6D6C3C3C3E0E0E0EDEDEDEDEDEDEDEDEDEDEDEDECECECD7
        D7D7BFBFBFFFFFFFFFFFFFF2F2F1F2F2F1EEEDECE7D6BFE4CCA9DFC39BDABA8D
        D6B17ED7B381E0CBB0EFEFF0F2F2F1F2F2F1F2F2F1F2F2F1F2F1F1BFBFBFD7D7
        D7F3F3F3F3F3F3EDEDEDEDEDEDEBEBEBE0E0E0DADADAD6D6D6D2D2D2CECECECF
        CFCFDBDBDBECECECEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDD7D7D7BFBFBFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFF2F2F1F2F2F1F2F2F1F2F2F1F2F2F1F2F1F1BFBFBFD7D7D7F3F3F3F3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3EDEDED
        EDEDEDEDEDEDEDEDEDEDEDEDEDEDEDD7D7D7BFBFBFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2F2F1F2F2F1F2
        F2F1F2F2F1F2F2F1F2F1F1BFBFBFD7D7D7F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3EDEDEDEDEDEDEDEDEDEDED
        EDEDEDEDEDEDEDD7D7D7BFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        DCDCDCBFBFBFD7D7D7F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3E4E4E4D7
        D7D7FFFFFFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
        BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFFFFFFFFFFF
        FFD7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7
        D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7FFFFFF}
      Margin = 0
      NumGlyphs = 2
      Spacing = 0
      OnClick = btnPostSearchClick
    end
    object Image4: TImage
      Left = 788
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
    object Label3: TLabel
      Left = 798
      Top = 23
      Width = 26
      Height = 13
      Caption = #49345#53468
    end
    object Image5: TImage
      Left = 677
      Top = 51
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
    object edtCond: TEdit
      Left = 125
      Top = 19
      Width = 224
      Height = 21
      Color = clWhite
      ImeMode = imSHanguel
      ImeName = 'Microsoft IME 2010'
      TabOrder = 1
      OnKeyPress = edtCondKeyPress
    end
    object cbEmpAb: TComboBox
      Left = 829
      Top = 19
      Width = 169
      Height = 21
      Style = csDropDownList
      Color = clWhite
      ImeMode = imSHanguel
      ImeName = 'Microsoft IME 2010'
      TabOrder = 3
    end
    object cbAb: TComboBox
      Left = 23
      Top = 19
      Width = 100
      Height = 21
      Style = csDropDownList
      Color = clWhite
      ImeMode = imSHanguel
      ImeName = 'Microsoft IME 2010'
      ItemIndex = 0
      TabOrder = 0
      Text = #49324#50896#47749
      Items.Strings = (
        #49324#50896#47749
        #49324#50896#48264#54840)
    end
    object cbOCode: TComboBox
      Left = 406
      Top = 19
      Width = 365
      Height = 21
      Style = csDropDownList
      Color = clWhite
      ImeMode = imSHanguel
      ImeName = 'Microsoft IME 2010'
      TabOrder = 2
      OnChange = cbOCodeChange
    end
    object cbBCode: TComboBox
      Left = 66
      Top = 43
      Width = 283
      Height = 21
      Style = csDropDownList
      Color = clWhite
      ImeMode = imSHanguel
      ImeName = 'Microsoft IME 2010'
      TabOrder = 4
    end
    object edtPostName: TEdit
      Left = 406
      Top = 43
      Width = 185
      Height = 21
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #44404#47548
      Font.Style = []
      ImeMode = imSHanguel
      ImeName = 'Microsoft IME 2010'
      ParentFont = False
      TabOrder = 5
      OnEnter = edtPostNameEnter
      OnExit = edtPostNameEnter
      OnKeyPress = edtPostNameKeyPress
    end
    object edtPostCode: TEdit
      Left = 592
      Top = 43
      Width = 50
      Height = 21
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #44404#47548
      Font.Style = []
      ImeMode = imSHanguel
      ImeName = 'Microsoft IME 2010'
      MaxLength = 4
      ParentFont = False
      TabOrder = 6
    end
    object rbNewEmp: TRadioButton
      Left = 689
      Top = 47
      Width = 108
      Height = 17
      Alignment = taLeftJustify
      Caption = #52292#50857#50672#46041#51077#49324#51088
      TabOrder = 7
    end
    object rbActiveGroupHis: TRadioButton
      Left = 805
      Top = 47
      Width = 154
      Height = 17
      Alignment = taLeftJustify
      Caption = #51064#49324#48156#47161' '#50976#54952#54620' '#53748#49324#51088
      TabOrder = 8
    end
    object btnCancel: TButton
      Left = 964
      Top = 42
      Width = 35
      Height = 25
      Caption = #54644#51228
      TabOrder = 9
      OnClick = btnCancelClick
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 688
    Width = 1008
    Height = 19
    Panels = <
      item
        Text = 'F1-'#46020#50880#47568', F9-'#51312#54924
        Width = 50
      end>
  end
  object cxMember: TcxGrid
    Left = 0
    Top = 106
    Width = 1008
    Height = 582
    Align = alClient
    TabOrder = 2
    LookAndFeel.NativeStyle = False
    object cxviMember: TcxGridDBTableView
      OnKeyDown = cxviMemberKeyDown
      OnMouseWheel = cxviMemberMouseWheel
      Navigator.Buttons.CustomButtons = <>
      OnCellDblClick = cxviMemberCellDblClick
      DataController.DataSource = dsMember
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
      Styles.Content = Form1.cxContent
      Styles.Header = Form1.cxHeader
      object grdcolNo: TcxGridDBColumn
        Caption = 'No'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        OnGetDisplayText = grdcolNoGetDisplayText
        HeaderAlignmentHorz = taCenter
        Width = 35
      end
      object grdcolMName: TcxGridDBColumn
        Caption = #49324#50896#47749
        DataBinding.FieldName = 'hr_m_name'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        HeaderAlignmentHorz = taCenter
        Width = 80
      end
      object grdcolMCode: TcxGridDBColumn
        Caption = #49324#50896#48264#54840
        DataBinding.FieldName = 'hr_m_code'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        HeaderAlignmentHorz = taCenter
        Width = 80
      end
      object grdcolErpMCode: TcxGridDBColumn
        Caption = #51312#54633#50896#53076#46300
        DataBinding.FieldName = 'm_code'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        HeaderAlignmentHorz = taCenter
        Width = 80
      end
      object grdcolOCode: TcxGridDBColumn
        DataBinding.FieldName = 'hr_o_code'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        Visible = False
        HeaderAlignmentHorz = taCenter
      end
      object grdcolOName: TcxGridDBColumn
        Caption = #49548#49549#48277#51064
        DataBinding.FieldName = 'hr_o_name'
        PropertiesClassName = 'TcxTextEditProperties'
        HeaderAlignmentHorz = taCenter
        Width = 210
      end
      object grdcolBCode: TcxGridDBColumn
        DataBinding.FieldName = 'hr_b_code'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        Visible = False
        HeaderAlignmentHorz = taCenter
      end
      object grdcolBName: TcxGridDBColumn
        Caption = #49324#50629#51109
        DataBinding.FieldName = 'hr_b_name'
        PropertiesClassName = 'TcxTextEditProperties'
        HeaderAlignmentHorz = taCenter
        Width = 210
      end
      object grdcolPostCode: TcxGridDBColumn
        DataBinding.FieldName = 'hr_post_code'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        Visible = False
        HeaderAlignmentHorz = taCenter
      end
      object grdcolPostName: TcxGridDBColumn
        Caption = #48512#49436
        DataBinding.FieldName = 'hr_post_name'
        PropertiesClassName = 'TcxTextEditProperties'
        HeaderAlignmentHorz = taCenter
        Width = 140
      end
      object grdcolSalTypeAbVal: TcxGridDBColumn
        Caption = #44553#50668#54805#53468
        DataBinding.FieldName = 'hr_sal_type_ab_val'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        HeaderAlignmentHorz = taCenter
        Width = 65
      end
      object grdcolEmpAb: TcxGridDBColumn
        DataBinding.FieldName = 'hr_emp_ab'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        Visible = False
        HeaderAlignmentHorz = taCenter
      end
      object grdcolEmpAbVal: TcxGridDBColumn
        Caption = #49345#53468
        DataBinding.FieldName = 'hr_emp_ab_val'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        HeaderAlignmentHorz = taCenter
        Width = 95
      end
    end
    object cxlvMember: TcxGridLevel
      GridView = cxviMember
    end
  end
  object Memo1: TMemo
    Left = 289
    Top = 541
    Width = 457
    Height = 89
    Lines.Strings = (
      'Memo1')
    TabOrder = 4
    Visible = False
  end
  object vtMember: TVirtualTable
    Options = [voPersistentData, voStored, voSkipUnSupportedFieldTypes]
    Left = 54
    Top = 618
    Data = {03000000000000000000}
  end
  object dsMember: TDataSource
    DataSet = vtMember
    Left = 112
    Top = 618
  end
  object vtCompany: TVirtualTable
    Options = [voPersistentData, voStored, voSkipUnSupportedFieldTypes]
    Left = 54
    Top = 538
    Data = {03000000000000000000}
  end
  object Excel1: TExcel
    ExeName = 'Excel'
    ExecLimit = 99
    Decimals = 2
    BatchMin = 200
    BatchMax = 250
    Left = 52
    Top = 168
  end
  object dlgSave1: TSaveDialog
    Left = 56
    Top = 284
  end
end
