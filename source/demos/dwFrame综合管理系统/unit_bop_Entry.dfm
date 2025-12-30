object Form_bop_Entry: TForm_bop_Entry
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #27979#35797#25104#32489
  ClientHeight = 540
  ClientWidth = 400
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OnShow = FormShow
  TextHeight = 23
  object Fp: TFlowPanel
    AlignWithMargins = True
    Left = 3
    Top = 20
    Width = 394
    Height = 444
    Margins.Top = 20
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object PnDemo: TPanel
      AlignWithMargins = True
      Left = 20
      Top = 0
      Width = 320
      Height = 40
      Margins.Left = 20
      Margins.Top = 0
      Margins.Right = 20
      Margins.Bottom = 0
      BevelOuter = bvNone
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      object LaName: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 80
        Height = 34
        Align = alLeft
        AutoSize = False
        Caption = #24352#20116#26446#36213
        Layout = tlCenter
      end
      object LaUnit: TLabel
        AlignWithMargins = True
        Left = 155
        Top = 3
        Width = 80
        Height = 34
        Align = alLeft
        AutoSize = False
        Caption = #31186
        Layout = tlCenter
      end
      object EtScore: TEdit
        AlignWithMargins = True
        Left = 89
        Top = 5
        Width = 60
        Height = 30
        Hint = '{"dwattr":"type=\"number\""}'
        Margins.Top = 5
        Margins.Bottom = 5
        Align = alLeft
        Alignment = taRightJustify
        TabOrder = 0
        OnChange = EtScoreChange
        ExplicitHeight = 28
      end
      object CbRemark: TComboBox
        AlignWithMargins = True
        Left = 241
        Top = 5
        Width = 76
        Height = 29
        Hint = '{"height":30,"dwstyle":"border:none;"}'
        Margins.Top = 5
        Margins.Bottom = 5
        Align = alClient
        Style = csDropDownList
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -16
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ItemIndex = 0
        ParentFont = False
        TabOrder = 1
        OnChange = EtScoreChange
        Items.Strings = (
          ''
          #29983#30149
          #21463#20260
          #20813#32771
          #29983#29702#26399
          #20241#23398
          #32570#32771
          #29359#35268
          #36716#23398)
      end
    end
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 470
    Width = 394
    Height = 50
    Margins.Bottom = 20
    Align = alBottom
    BevelKind = bkSoft
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object BtNext: TButton
      AlignWithMargins = True
      Left = 220
      Top = 3
      Width = 110
      Height = 40
      Margins.Right = 60
      Align = alRight
      Caption = #19979#19968#32452
      TabOrder = 0
      OnClick = BtNextClick
    end
    object BtPrev: TButton
      AlignWithMargins = True
      Left = 60
      Top = 3
      Width = 110
      Height = 40
      Margins.Left = 60
      Align = alLeft
      Caption = #19978#19968#32452
      TabOrder = 1
      OnClick = BtPrevClick
    end
  end
  object FDQuery2: TFDQuery
    Left = 128
    Top = 216
  end
  object FDQuery_Standard: TFDQuery
    Left = 128
    Top = 280
  end
  object FDQuery1: TFDQuery
    Left = 128
    Top = 152
  end
end
