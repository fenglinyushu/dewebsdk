object Form_Show: TForm_Show
  Left = 0
  Top = 70
  Caption = #26032#20379#24212#21830#24773#20917
  ClientHeight = 291
  ClientWidth = 487
  Color = clBtnFace
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
    Left = 26
    Top = 40
    Width = 199
    Height = 28
    TabOrder = 0
    Text = 'Edit1'
  end
  object Panel1: TPanel
    Left = 0
    Top = 232
    Width = 487
    Height = 59
    Hint = '{"dwstyle":"border-top:dashed 1px #aaa;"}'
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Button1: TButton
      AlignWithMargins = True
      Left = 387
      Top = 10
      Width = 90
      Height = 35
      Hint = '{"type":"primary"}'
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 14
      Align = alRight
      Caption = #30830#23450
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      AlignWithMargins = True
      Left = 291
      Top = 10
      Width = 90
      Height = 35
      Hint = '{"type":"primary"}'
      Margins.Top = 10
      Margins.Bottom = 14
      Align = alRight
      Caption = #21462#28040
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object CheckBox1: TCheckBox
    Left = 26
    Top = 88
    Width = 97
    Height = 17
    Caption = 'CheckBox1'
    TabOrder = 2
  end
  object Memo1: TMemo
    Left = 26
    Top = 128
    Width = 303
    Height = 73
    Lines.Strings = (
      'Memo1')
    TabOrder = 3
  end
end
