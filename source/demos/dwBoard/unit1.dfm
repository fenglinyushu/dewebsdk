object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'DeWeb'
  ClientHeight = 540
  ClientWidth = 360
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OnMouseUp = FormMouseUp
  OnShow = FormShow
  TextHeight = 20
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 360
    Height = 540
    Hint = 
      '{"_m_":"root","caption":"dwBoard'#22823#23631#30475#26495#31995#32479'","image":"media/images/bo' +
      'ard/bk003.jpg","color":[200,200,200]}'
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
  end
  object FDConnection1: TFDConnection
    Left = 160
    Top = 312
  end
end
