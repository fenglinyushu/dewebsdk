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
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  TextHeight = 20
  object Label1: TLabel
    Left = 72
    Top = 64
    Width = 513
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
  object Button2: TButton
    Left = 48
    Top = 248
    Width = 137
    Height = 33
    Hint = '{"type":"primary"}'
    Caption = 'Play/Pause'
    TabOrder = 0
    OnClick = Button2Click
  end
  object Timer2: TTimer
    OnTimer = Timer2Timer
    Left = 272
    Top = 256
  end
end
