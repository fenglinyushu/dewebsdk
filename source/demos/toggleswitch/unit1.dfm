object Form1: TForm1
  Left = 0
  Top = 0
  Hint = '{"type":"primary"}'
  BorderStyle = bsNone
  Caption = 'DeWeb - TToggleSwitch'
  ClientHeight = 720
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
  object Label1: TLabel
    Left = 56
    Top = 152
    Width = 48
    Height = 20
    Caption = 'Label1'
  end
  object ToggleSwitch2: TToggleSwitch
    Left = 56
    Top = 72
    Width = 225
    Height = 33
    AutoSize = False
    State = tssOn
    StateCaptions.CaptionOn = #24613#35786#38376#35786
    StateCaptions.CaptionOff = #26222#36890#38376#35786
    SwitchHeight = 30
    SwitchWidth = 40
    TabOrder = 0
    ThumbColor = clFuchsia
    ThumbWidth = 30
    OnClick = ToggleSwitch2Click
  end
end
