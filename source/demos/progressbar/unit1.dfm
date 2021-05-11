object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'DeWeb - TProgressBar'
  ClientHeight = 640
  ClientWidth = 360
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
  object ProgressBar1: TProgressBar
    Left = 30
    Top = 96
    Width = 300
    Height = 23
    ParentShowHint = False
    Position = 35
    BarColor = clFuchsia
    BackgroundColor = clBlue
    SmoothReverse = True
    Step = 1
    ShowHint = True
    TabOrder = 0
    TabStop = True
  end
  object ProgressBar2: TProgressBar
    Left = 72
    Top = 216
    Width = 200
    Height = 153
    ParentShowHint = False
    Position = 75
    BarColor = clLime
    BackgroundColor = clBlue
    SmoothReverse = True
    Step = 1
    State = pbsError
    ShowHint = True
    TabOrder = 1
  end
  object ProgressBar3: TProgressBar
    Left = 72
    Top = 392
    Width = 200
    Height = 153
    Max = 200
    ParentShowHint = False
    Position = 75
    BarColor = clLime
    BackgroundColor = clBlue
    SmoothReverse = True
    Step = 1
    State = pbsPaused
    ShowHint = True
    TabOrder = 2
  end
  object ProgressBar4: TProgressBar
    Left = 30
    Top = 144
    Width = 300
    Height = 15
    ParentShowHint = False
    Position = 35
    BarColor = clRed
    BackgroundColor = clBlue
    Step = 1
    ShowHint = True
    TabOrder = 3
    TabStop = True
  end
  object ProgressBar5: TProgressBar
    Left = 30
    Top = 184
    Width = 300
    Height = 15
    ParentShowHint = False
    Position = 35
    BarColor = clGreen
    BackgroundColor = clBlue
    Step = 1
    ShowHint = False
    TabOrder = 4
    TabStop = True
  end
  object Button1: TButton
    Left = 30
    Top = 32
    Width = 139
    Height = 35
    Hint = '{"type":"primary"}'
    Caption = 'Start/Pause'
    TabOrder = 5
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 192
    Top = 32
    Width = 138
    Height = 35
    Hint = '{"type":"primary"}'
    Caption = 'Reset'
    TabOrder = 6
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 72
    Top = 551
    Width = 200
    Height = 35
    Hint = 
      '{"type":"success","onclick":"window.clearInterval(Timer1__tmr);"' +
      '}'
    Caption = 'JavaScripte Pause'
    TabOrder = 7
  end
  object Timer1: TTimer
    Interval = 200
    OnTimer = Timer1Timer
    Left = 288
    Top = 96
  end
end
