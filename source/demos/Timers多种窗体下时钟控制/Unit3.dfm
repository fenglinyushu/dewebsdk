object Form3: TForm3
  Left = 0
  Top = 0
  HelpType = htKeyword
  HelpKeyword = 'embed'
  Align = alClient
  BorderStyle = bsNone
  Caption = 'Form3'
  ClientHeight = 678
  ClientWidth = 1047
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 34
    Width = 479
    Height = 41
    AutoSize = False
    Caption = #21160#24577#21152#36733#30340#31383#20307
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
  end
  object Button3: TButton
    Left = 24
    Top = 248
    Width = 137
    Height = 33
    Hint = '{"type":"primary"}'
    Caption = 'Play/Pause'
    TabOrder = 0
    OnClick = Button3Click
  end
  object Timer3: TTimer
    OnTimer = Timer3Timer
    Left = 272
    Top = 256
  end
end
