object Form1: TForm1
  Left = 191
  Top = 60
  HelpType = htKeyword
  BorderStyle = bsNone
  Caption = 'Demo of dwVcl'
  ClientHeight = 748
  ClientWidth = 836
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OnMouseUp = FormMouseUp
  TextHeight = 20
  object Pn1: TPanel
    Left = 0
    Top = 0
    Width = 836
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
      Caption = 'Demo of TDateTimePicker'
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
    Width = 836
    Height = 45
    Align = alTop
    BevelOuter = bvNone
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
      Width = 89
      Height = 30
      Margins.Top = 8
      Margins.Bottom = 7
      Align = alLeft
      Caption = 'Set'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = BtLTWHClick
    end
    object BtVisible: TButton
      AlignWithMargins = True
      Left = 98
      Top = 8
      Width = 89
      Height = 30
      Margins.Top = 8
      Margins.Bottom = 7
      Align = alLeft
      Caption = 'Get'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object ComboBox1: TComboBox
    Left = 136
    Top = 168
    Width = 145
    Height = 28
    TabOrder = 2
    Text = 'ComboBox1'
    Items.Strings = (
      
        'HF000125001 - '#38463#37324#24052#24052#38598#22242', '#20415#25658#21560#23576#22120' ['#22885#32724#29031#26126#21378']: S(100), M(100), C(10), S(11' +
        ')')
  end
  object ComboBox2: TComboBox
    Left = 320
    Top = 163
    Width = 145
    Height = 35
    Hint = '{"height":20}'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    Text = 'ComboBox1'
  end
  object ComboBox3: TComboBox
    Left = 136
    Top = 243
    Width = 145
    Height = 35
    Hint = '{"height":30}'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    Text = 'ComboBox1'
  end
  object Edit1: TEdit
    Left = 136
    Top = 136
    Width = 121
    Height = 28
    TabOrder = 5
    Text = '100'
  end
end
