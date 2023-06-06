object Form_Document: TForm_Document
  Left = 0
  Top = 0
  HelpType = htKeyword
  HelpKeyword = 'embed'
  ClientHeight = 657
  ClientWidth = 1063
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnStartDock = FormStartDock
  PixelsPerInch = 96
  TextHeight = 20
  object Panel_C: TPanel
    Left = 200
    Top = 0
    Width = 863
    Height = 657
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel_C'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object Panel_Banner: TPanel
      Left = 0
      Top = 0
      Width = 863
      Height = 53
      Hint = '{"dwstyle":"border-bottom:solid 1px #ed6d00;"}'
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object Button_Search: TButton
        AlignWithMargins = True
        Left = 312
        Top = 11
        Width = 40
        Height = 32
        Hint = 
          '{"type":"primary","icon":"el-icon-search","radius":"0 5px 5px 0"' +
          '}'
        Margins.Left = 2
        Margins.Top = 11
        Margins.Bottom = 10
        Align = alLeft
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindow
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = Button_SearchClick
      end
      object Button_Preview: TButton
        AlignWithMargins = True
        Left = 656
        Top = 11
        Width = 65
        Height = 32
        Hint = '{"type":"primary","icon":"el-icon-printer","radius":"0"}'
        Margins.Left = 1
        Margins.Top = 11
        Margins.Right = 0
        Margins.Bottom = 10
        Align = alRight
        Caption = #39044#35272
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = Button_PreviewClick
      end
      object Button_Save: TButton
        AlignWithMargins = True
        Left = 524
        Top = 11
        Width = 65
        Height = 32
        Hint = 
          '{"type":"primary","radius":"5px 0 0 5px","icon":"el-icon-s-claim' +
          '"}'
        Margins.Left = 1
        Margins.Top = 11
        Margins.Right = 0
        Margins.Bottom = 10
        Align = alRight
        Caption = #20445#23384
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = Button_SaveClick
      end
      object Button_Delete: TButton
        AlignWithMargins = True
        Left = 788
        Top = 11
        Width = 65
        Height = 32
        Hint = 
          '{"type":"primary","radius":"0 5px 5px 0","icon":"el-icon-delete"' +
          '}'
        Margins.Left = 1
        Margins.Top = 11
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alRight
        Caption = #21024#38500
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = Button_DeleteClick
      end
      object BitBtn_Upload: TBitBtn
        AlignWithMargins = True
        Left = 590
        Top = 11
        Width = 65
        Height = 32
        Hint = 
          '{"auto":1,"type":"primary","icon":"el-icon-upload","radius":"0",' +
          '"dir":"media/doc/dwms","accept":".doc,.docx.xls,.xlsx,.pdf,.ppt,' +
          '.pptx,.txt,.jpg,.png,.gif,.mp4,.mp3"}'
        Margins.Left = 1
        Margins.Top = 11
        Margins.Right = 0
        Margins.Bottom = 10
        Align = alRight
        Caption = #19978#20256
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnEndDock = BitBtn_UploadEndDock
        OnStartDock = BitBtn_UploadStartDock
      end
      object Edit_Search: TEdit
        AlignWithMargins = True
        Left = 10
        Top = 11
        Width = 300
        Height = 30
        Hint = '{"placeholder":"'#35831#36755#20837#26597#35810#20851#38190#23383'","radius":"5px 0 0 5px"}'
        Margins.Left = 10
        Margins.Top = 11
        Margins.Right = 0
        Margins.Bottom = 12
        Align = alLeft
        TabOrder = 5
        ExplicitHeight = 28
      end
      object Button_Download: TButton
        AlignWithMargins = True
        Left = 722
        Top = 11
        Width = 65
        Height = 32
        Hint = '{"type":"primary","icon":"el-icon-download","radius":"0"}'
        Margins.Left = 1
        Margins.Top = 11
        Margins.Right = 0
        Margins.Bottom = 10
        Align = alRight
        Caption = #19979#36733
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        OnClick = Button_DownloadClick
      end
    end
    object StringGrid1: TStringGrid
      AlignWithMargins = True
      Left = 10
      Top = 63
      Width = 843
      Height = 330
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 0
      Align = alTop
      DefaultColWidth = 150
      DefaultRowHeight = 30
      FixedCols = 0
      RowCount = 11
      TabOrder = 1
      OnClick = StringGrid1Click
      OnDblClick = StringGrid1DblClick
      RowHeights = (
        30
        30
        31
        30
        30
        30
        30
        30
        30
        30
        30)
    end
    object TrackBar1: TTrackBar
      AlignWithMargins = True
      Left = 10
      Top = 403
      Width = 843
      Height = 30
      HelpType = htKeyword
      HelpKeyword = 'page'
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 0
      Align = alTop
      TabOrder = 2
      OnChange = TrackBar1Change
    end
    object Panel3: TPanel
      AlignWithMargins = True
      Left = 10
      Top = 443
      Width = 843
      Height = 80
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Panel3'
      ParentBackground = False
      TabOrder = 3
      object Label1: TLabel
        Left = 530
        Top = 26
        Width = 61
        Height = 20
        AutoSize = False
        Caption = #22791#27880
      end
      object Label2: TLabel
        Left = 311
        Top = 27
        Width = 61
        Height = 20
        AutoSize = False
        Caption = #19978#20256#26102#38388
      end
      object Label9: TLabel
        Left = 15
        Top = 27
        Width = 44
        Height = 20
        AutoSize = False
        Caption = #21517#31216
      end
      object DateTimePicker1: TDateTimePicker
        Left = 384
        Top = 25
        Width = 153
        Height = 28
        Date = 44415.000000000000000000
        Time = 0.822636388889804900
        TabOrder = 0
      end
      object Edit_Memo: TEdit
        Left = 572
        Top = 24
        Width = 252
        Height = 28
        TabOrder = 1
      end
      object Edit_Name: TEdit
        Left = 65
        Top = 25
        Width = 216
        Height = 28
        TabOrder = 2
      end
    end
  end
  object Panel_L: TPanel
    Left = 0
    Top = 0
    Width = 200
    Height = 657
    Align = alLeft
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 200
      Height = 53
      Hint = '{"dwstyle":"border-bottom:solid 1px #ed6d00;"}'
      Align = alTop
      BevelKind = bkFlat
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object Label3: TLabel
        AlignWithMargins = True
        Left = 10
        Top = 3
        Width = 176
        Height = 43
        Margins.Left = 10
        Margins.Right = 10
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        Caption = #25991#26723#31867#22411
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        ExplicitLeft = 72
        ExplicitTop = 16
        ExplicitWidth = 30
        ExplicitHeight = 20
      end
    end
    object Panel_Roles: TPanel
      Left = 0
      Top = 53
      Width = 200
      Height = 604
      Align = alClient
      Color = clWhite
      ParentBackground = False
      TabOrder = 1
      object Button_AllType: TButton
        AlignWithMargins = True
        Left = 4
        Top = 10
        Width = 192
        Height = 29
        Hint = '{"type":"success","icon":"el-icon-check","radius":"0"}'
        Margins.Top = 9
        Margins.Bottom = 0
        Align = alTop
        Caption = #25152#26377#31867#22411
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = Button_AllTypeClick
      end
      object Button_Doc: TButton
        AlignWithMargins = True
        Left = 4
        Top = 40
        Width = 192
        Height = 29
        Hint = '{"radius":"0"}'
        Margins.Top = 1
        Margins.Bottom = 0
        Align = alTop
        Caption = #25991#26723'(*.doc,*.docx)'
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = Button_DocClick
      end
      object Button_Xls: TButton
        AlignWithMargins = True
        Left = 4
        Top = 70
        Width = 192
        Height = 29
        Hint = '{"radius":"0"}'
        Margins.Top = 1
        Margins.Bottom = 0
        Align = alTop
        Caption = #34920#26684'(*.xls,*.xlsx)'
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = Button_DocClick
      end
      object Button_Ppt: TButton
        AlignWithMargins = True
        Left = 4
        Top = 100
        Width = 192
        Height = 29
        Hint = '{"radius":"0"}'
        Margins.Top = 1
        Margins.Bottom = 0
        Align = alTop
        Caption = #35838#20214'(*.ppt,*.pptx)'
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = Button_DocClick
      end
      object Button_Pdf: TButton
        AlignWithMargins = True
        Left = 4
        Top = 130
        Width = 192
        Height = 29
        Hint = '{"radius":"0"}'
        Margins.Top = 1
        Margins.Bottom = 0
        Align = alTop
        Caption = #25253#21578'(*.pdf)'
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnClick = Button_DocClick
      end
      object Button_Image: TButton
        AlignWithMargins = True
        Left = 4
        Top = 160
        Width = 192
        Height = 29
        Hint = '{"radius":"0"}'
        Margins.Top = 1
        Margins.Bottom = 0
        Align = alTop
        Caption = #22270#29255'(*.jpg,*.png,..)'
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnClick = Button_DocClick
      end
      object Button_Mp4: TButton
        AlignWithMargins = True
        Left = 4
        Top = 190
        Width = 192
        Height = 29
        Hint = '{"radius":"0"}'
        Margins.Top = 1
        Margins.Bottom = 0
        Align = alTop
        Caption = #35270#39057'(*.mp4)'
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        OnClick = Button_DocClick
      end
      object Button_Mp3: TButton
        AlignWithMargins = True
        Left = 4
        Top = 220
        Width = 192
        Height = 29
        Hint = '{"radius":"0"}'
        Margins.Top = 1
        Margins.Bottom = 0
        Align = alTop
        Caption = #38899#39057'(*.mp3)'
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 7
        OnClick = Button_DocClick
      end
      object Button_Txt: TButton
        AlignWithMargins = True
        Left = 4
        Top = 250
        Width = 192
        Height = 29
        Hint = '{"radius":"0"}'
        Margins.Top = 1
        Margins.Bottom = 0
        Align = alTop
        Caption = #25991#26412'(*.txt)'
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 8
        OnClick = Button_DocClick
      end
      object Panel4: TPanel
        Left = 1
        Top = 279
        Width = 198
        Height = 53
        Hint = '{"dwstyle":"border-bottom:solid 1px #ed6d00;"}'
        Align = alTop
        BevelKind = bkFlat
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 9
        object Label4: TLabel
          AlignWithMargins = True
          Left = 10
          Top = 3
          Width = 174
          Height = 43
          Margins.Left = 10
          Margins.Right = 10
          Align = alClient
          Alignment = taCenter
          AutoSize = False
          Caption = #25991#26723#25490#24207
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = #24494#36719#38597#40657
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
          ExplicitLeft = 72
          ExplicitTop = 16
          ExplicitWidth = 30
          ExplicitHeight = 20
        end
      end
      object Panel_Order: TPanel
        Left = 1
        Top = 332
        Width = 198
        Height = 34
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        Color = clWindow
        ParentBackground = False
        TabOrder = 10
        object ComboBox_Order: TComboBox
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 117
          Height = 28
          Margins.Left = 0
          Margins.Right = 0
          Align = alClient
          ItemIndex = 0
          TabOrder = 0
          Text = 'ID'
          OnChange = ComboBox_OrderChange
          Items.Strings = (
            'ID'
            #25991#20214#21517
            #31867#22411
            #19978#20256#26102#38388
            #22791#27880)
        end
        object ComboBox_DESC: TComboBox
          AlignWithMargins = True
          Left = 117
          Top = 3
          Width = 78
          Height = 28
          Margins.Left = 0
          Align = alRight
          ItemIndex = 1
          TabOrder = 1
          Text = #38477#24207
          OnChange = ComboBox_OrderChange
          Items.Strings = (
            #21319#24207
            #38477#24207)
        end
      end
    end
  end
  object FDQuery1: TFDQuery
    Left = 80
    Top = 381
  end
end
