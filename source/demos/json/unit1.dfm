object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 563
  ClientWidth = 506
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Memo1: TMemo
    Left = 24
    Top = 39
    Width = 449
    Height = 186
    TabOrder = 0
  end
  object Button2: TButton
    Left = 136
    Top = 8
    Width = 177
    Height = 25
    Caption = 'TNetHTTPClient '#33719#21462'JSON'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button4: TButton
    Left = 104
    Top = 231
    Width = 155
    Height = 25
    Caption = #35835#21462'Memo1 '#35299#26512'json'
    TabOrder = 2
    OnClick = Button4Click
  end
  object Memo2: TMemo
    Left = 24
    Top = 280
    Width = 449
    Height = 257
    Lines.Strings = (
      'Memo2')
    TabOrder = 3
  end
end
