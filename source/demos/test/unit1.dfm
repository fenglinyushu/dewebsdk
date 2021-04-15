object Form1: TForm1
  Left = 0
  Top = 0
  Hint = '{"dwstring":"border stripe"}'
  VertScrollBar.Visible = False
  BorderStyle = bsNone
  BorderWidth = 5
  Caption = 'DeWeb'
  ClientHeight = 790
  ClientWidth = 590
  Color = clWhite
  TransparentColorValue = 16448250
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 20
  object SG1: TStringGrid
    Left = 16
    Top = 32
    Width = 433
    Height = 175
    DefaultRowHeight = 35
    TabOrder = 0
  end
  object SG2: TStringGrid
    Left = 16
    Top = 264
    Width = 433
    Height = 330
    Hint = '{"dwstyle":"border stripe show-summary"}'
    DefaultRowHeight = 30
    RowCount = 10
    TabOrder = 1
  end
end
