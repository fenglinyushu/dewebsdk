object Form1: TForm1
  Left = 0
  Top = 0
  VertScrollBar.Visible = False
  BorderStyle = bsNone
  BorderWidth = 5
  Caption = 'DeWeb'
  ClientHeight = 485
  ClientWidth = 498
  Color = clWhite
  TransparentColor = True
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
  object cbb: TComboBox
    Left = 24
    Top = 32
    Width = 145
    Height = 28
    TabOrder = 0
    Text = 'cbb'
  end
  object Button1: TButton
    Left = 24
    Top = 80
    Width = 145
    Height = 33
    Caption = 'Add Items'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 24
    Top = 119
    Width = 145
    Height = 33
    Caption = 'Get Text'
    TabOrder = 2
    OnClick = Button2Click
  end
end
