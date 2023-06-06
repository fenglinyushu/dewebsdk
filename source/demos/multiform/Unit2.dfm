object Form2: TForm2
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Form2'
  ClientHeight = 559
  ClientWidth = 1093
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 176
    Top = 128
    Width = 281
    Height = 65
    AutoSize = False
    Caption = #40664#35748#21152#36733#30340#31383#20307
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
  end
  object Button3: TButton
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 100
    Height = 27
    Hint = '{"type":"primary"}'
    Caption = 'Play'
    TabOrder = 0
    OnClick = Button3Click
  end
  object Button1: TButton
    AlignWithMargins = True
    Left = 109
    Top = 3
    Width = 100
    Height = 27
    Hint = '{"type":"primary"}'
    Caption = 'Pause'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 272
    Top = 256
  end
end
