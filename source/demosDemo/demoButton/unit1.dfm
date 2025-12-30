object Form1: TForm1
  Left = 191
  Top = 60
  HelpType = htKeyword
  BorderStyle = bsNone
  Caption = 'Demo of dwVcl'
  ClientHeight = 603
  ClientWidth = 1083
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  TextHeight = 20
  object Pn1: TPanel
    Left = 0
    Top = 0
    Width = 1083
    Height = 45
    Hint = '{"onexit":"console.log('#39'js exit'#39');"}'
    Align = alTop
    BevelOuter = bvNone
    Color = 14511788
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object Label2: TLabel
      AlignWithMargins = True
      Left = 15
      Top = 3
      Width = 306
      Height = 39
      Margins.Left = 15
      Align = alLeft
      AutoSize = False
      Caption = 'Demo of TButton'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -17
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitTop = 1
    end
  end
  object Pn2: TPanel
    Left = 0
    Top = 45
    Width = 1083
    Height = 45
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Pn1'
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    object BtLTWH: TButton
      AlignWithMargins = True
      Left = 3
      Top = 8
      Width = 70
      Height = 30
      Hint = '{"type":"primary"}'
      Margins.Top = 8
      Margins.Bottom = 7
      Align = alLeft
      Caption = 'LTWH'
      TabOrder = 0
      OnClick = BtLTWHClick
    end
    object BtFont: TButton
      AlignWithMargins = True
      Left = 155
      Top = 8
      Width = 70
      Height = 30
      Margins.Top = 8
      Margins.Bottom = 7
      Align = alLeft
      Caption = 'Font'
      TabOrder = 1
      OnClick = BtFontClick
    end
    object BtVisible: TButton
      AlignWithMargins = True
      Left = 79
      Top = 8
      Width = 70
      Height = 30
      Hint = '{"type":"success"}'
      Margins.Top = 8
      Margins.Bottom = 7
      Align = alLeft
      Caption = 'Visible'
      TabOrder = 2
      OnClick = BtVisibleClick
    end
    object BtEnabled: TButton
      AlignWithMargins = True
      Left = 231
      Top = 8
      Width = 70
      Height = 30
      Margins.Top = 8
      Margins.Bottom = 7
      Align = alLeft
      Caption = 'Enabled'
      TabOrder = 3
      OnClick = BtEnabledClick
    end
    object BtRadius: TButton
      AlignWithMargins = True
      Left = 307
      Top = 8
      Width = 70
      Height = 30
      Margins.Top = 8
      Margins.Bottom = 7
      Align = alLeft
      Caption = 'Radius'
      TabOrder = 4
      OnClick = BtRadiusClick
    end
    object BtdwStyle: TButton
      AlignWithMargins = True
      Left = 383
      Top = 8
      Width = 70
      Height = 30
      Margins.Top = 8
      Margins.Bottom = 7
      Align = alLeft
      Caption = 'dwStyle'
      TabOrder = 5
      OnClick = BtdwStyleClick
    end
    object BtText: TButton
      AlignWithMargins = True
      Left = 459
      Top = 8
      Width = 70
      Height = 30
      Margins.Top = 8
      Margins.Bottom = 7
      Align = alLeft
      Caption = 'Text'
      TabOrder = 6
      OnClick = BtTextClick
    end
    object BtType: TButton
      AlignWithMargins = True
      Left = 535
      Top = 8
      Width = 70
      Height = 30
      Margins.Top = 8
      Margins.Bottom = 7
      Align = alLeft
      Caption = 'Type'
      TabOrder = 7
      OnClick = BtTypeClick
    end
    object BtStyle: TButton
      AlignWithMargins = True
      Left = 611
      Top = 8
      Width = 70
      Height = 30
      Margins.Top = 8
      Margins.Bottom = 7
      Align = alLeft
      Caption = 'Style'
      TabOrder = 8
      OnClick = BtStyleClick
    end
    object BtIcon: TButton
      AlignWithMargins = True
      Left = 687
      Top = 8
      Width = 70
      Height = 30
      Margins.Top = 8
      Margins.Bottom = 7
      Align = alLeft
      Caption = 'Icon'
      TabOrder = 9
      OnClick = BtIconClick
    end
    object BtRIcon: TButton
      AlignWithMargins = True
      Left = 763
      Top = 8
      Width = 70
      Height = 30
      Margins.Top = 8
      Margins.Bottom = 7
      Align = alLeft
      Caption = 'R Icon'
      TabOrder = 10
      OnClick = BtRIconClick
    end
  end
  object Button1: TButton
    Left = 216
    Top = 248
    Width = 105
    Height = 41
    Hint = 
      '{"type":"primary","style":"plain circle","icon":"el-icon-setting' +
      '"}'
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
end
