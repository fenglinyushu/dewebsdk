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
  OnEndDock = FormEndDock
  TextHeight = 20
  object Label1: TLabel
    Left = 272
    Top = 184
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
    Left = 8
    Top = 8
    Width = 100
    Height = 35
    Hint = '{"type":"primary"}'
    Caption = 'Play'
    TabOrder = 0
    OnClick = Button3Click
  end
  object Button1: TButton
    AlignWithMargins = True
    Left = 114
    Top = 8
    Width = 100
    Height = 35
    Hint = '{"type":"primary"}'
    Caption = 'Pause'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 96
    Width = 209
    Height = 35
    Hint = '{"type":"primary"}'
    Caption = #23376#31383#20307#20013#24377#26694
    TabOrder = 2
    OnClick = Button2Click
  end
  object B_Upload: TButton
    Left = 8
    Top = 152
    Width = 209
    Height = 35
    Hint = '{"type":"primary"}'
    Caption = #23376#31383#20307#20013#19978#20256#25991#20214
    TabOrder = 3
    OnClick = B_UploadClick
  end
  object Timer1: TTimer
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 272
    Top = 256
  end
end
