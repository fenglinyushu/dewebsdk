object Form1: TForm1
  Left = 0
  Top = 0
  Hint = '{"type":"primary","resource":["AAAA","BBB"]}'
  BorderStyle = bsNone
  BorderWidth = 5
  Caption = 'DeWeb'
  ClientHeight = 554
  ClientWidth = 628
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
  object Edit1: TEdit
    Left = 112
    Top = 56
    Width = 145
    Height = 30
    Hint = '{"borderradius":"5px"}'
    AutoSize = False
    Color = clBtnFace
    TabOrder = 0
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 112
    Top = 104
    Width = 145
    Height = 30
    Hint = '{"borderradius":"15px"}'
    AutoSize = False
    BorderStyle = bsNone
    Color = clBtnFace
    TabOrder = 1
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 336
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
  end
  object ScrollBox1: TScrollBox
    Left = 64
    Top = 168
    Width = 412
    Height = 305
    TabOrder = 3
    object Panel1: TPanel
      Left = 72
      Top = 104
      Width = 185
      Height = 2000
      Caption = 'Panel1'
      TabOrder = 0
    end
  end
end
