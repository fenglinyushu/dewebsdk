object Form1: TForm1
  Left = 0
  Top = 0
  Hint = '{"type":"primary"}'
  BorderStyle = bsNone
  BorderWidth = 5
  Caption = 'DeWeb'
  ClientHeight = 554
  ClientWidth = 522
  Color = clWhite
  TransparentColorValue = 16448250
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  PixelsPerInch = 96
  TextHeight = 20
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 185
    Height = 353
    Lines.Strings = (
      '"'
      '>'
      '<'
      '\')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 224
    Top = 42
    Width = 81
    Height = 33
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 224
    Top = 8
    Width = 121
    Height = 28
    TabOrder = 2
    Text = '>'
  end
end
