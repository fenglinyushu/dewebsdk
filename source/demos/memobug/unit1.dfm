object Form1: TForm1
  Left = 0
  Top = 0
  Hint = '{"type":"primary"}'
  Caption = 'Hello,World!'
  ClientHeight = 617
  ClientWidth = 382
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 20
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 382
    Height = 177
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'Hello, DeWeb!'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -37
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
    ExplicitWidth = 441
  end
  object Memo1: TMemo
    Left = 32
    Top = 161
    Width = 313
    Height = 80
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object Memo2: TMemo
    Left = 32
    Top = 304
    Width = 313
    Height = 81
    Lines.Strings = (
      'Memo2')
    TabOrder = 1
  end
  object Button1: TButton
    Left = 144
    Top = 247
    Width = 81
    Height = 34
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Memo3: TMemo
    Left = 32
    Top = 40
    Width = 313
    Height = 105
    Lines.Strings = (
      #22797#21046#25105#21040#19979#38754#24471' memo1 '#28982#21518#28857#20987' '#25353#38062
      'Memo1"1234567890')
    TabOrder = 3
  end
  object Edit1: TEdit
    Left = 32
    Top = 424
    Width = 121
    Height = 28
    TabOrder = 4
    Text = 'Memo1"123'
  end
  object Edit2: TEdit
    Left = 184
    Top = 424
    Width = 121
    Height = 28
    TabOrder = 5
    Text = 'Edit2'
  end
  object Edit3: TEdit
    Left = 32
    Top = 503
    Width = 121
    Height = 28
    TabOrder = 6
    Text = 'Edit3'
  end
  object Button2: TButton
    Left = 32
    Top = 458
    Width = 273
    Height = 39
    Caption = 'Button"1'#39'2<3>4'
    TabOrder = 7
    OnClick = Button2Click
  end
end
