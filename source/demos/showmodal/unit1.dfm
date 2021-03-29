object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsNone
  BorderWidth = 5
  Caption = 'DeWeb'
  ClientHeight = 395
  ClientWidth = 310
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
  object Label1: TLabel
    Left = 24
    Top = 64
    Width = 257
    Height = 33
    Alignment = taCenter
    AutoSize = False
    Caption = 'DeWeb Multi Forms'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGray
    Font.Height = -19
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 24
    Top = 144
    Width = 257
    Height = 49
    Hint = '{"type":"success"}'
    Caption = 'Show Modal Form2'
    TabOrder = 0
    OnClick = Button1Click
  end
end
