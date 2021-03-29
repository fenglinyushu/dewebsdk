object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'DeWeb Check in'
  ClientHeight = 347
  ClientWidth = 304
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 20
  object Label2: TLabel
    Left = 24
    Top = 0
    Width = 100
    Height = 33
    AutoSize = False
    Caption = 'User'
    Layout = tlCenter
  end
  object Label3: TLabel
    Left = 24
    Top = 78
    Width = 100
    Height = 33
    AutoSize = False
    Caption = 'Password'
    Layout = tlCenter
  end
  object Label4: TLabel
    Left = 24
    Top = 159
    Width = 100
    Height = 33
    AutoSize = False
    Caption = 'Memo'
    Layout = tlCenter
  end
  object Button1: TButton
    Left = 80
    Top = 265
    Width = 145
    Height = 41
    Hint = '{"type":"success"}'
    Caption = 'Check in'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 24
    Top = 39
    Width = 265
    Height = 33
    AutoSize = False
    TabOrder = 1
    Text = 'admin'
  end
  object Edit2: TEdit
    Left = 24
    Top = 117
    Width = 265
    Height = 33
    AutoSize = False
    PasswordChar = '*'
    TabOrder = 2
    Text = '12345'
  end
  object Edit3: TEdit
    Left = 24
    Top = 198
    Width = 265
    Height = 33
    AutoSize = False
    TabOrder = 3
  end
end
