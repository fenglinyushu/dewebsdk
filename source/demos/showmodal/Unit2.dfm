object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'DeWeb Check in'
  ClientHeight = 289
  ClientWidth = 554
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 20
  object Label1: TLabel
    Left = 24
    Top = 8
    Width = 233
    Height = 33
    AutoSize = False
    Caption = 'DeWeb Passport'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -16
    Font.Name = #24494#36719#38597#40657
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 24
    Top = 63
    Width = 100
    Height = 33
    AutoSize = False
    Caption = 'User'
    Layout = tlCenter
  end
  object Label3: TLabel
    Left = 24
    Top = 102
    Width = 100
    Height = 33
    AutoSize = False
    Caption = 'Password'
    Layout = tlCenter
  end
  object Label4: TLabel
    Left = 24
    Top = 141
    Width = 100
    Height = 33
    AutoSize = False
    Caption = 'Memo'
    Layout = tlCenter
  end
  object Button1: TButton
    Left = 24
    Top = 208
    Width = 249
    Height = 41
    Caption = 'Check in'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 120
    Top = 63
    Width = 153
    Height = 33
    AutoSize = False
    TabOrder = 1
    Text = 'admin'
  end
  object Edit2: TEdit
    Left = 120
    Top = 102
    Width = 153
    Height = 33
    AutoSize = False
    PasswordChar = '*'
    TabOrder = 2
    Text = '12345'
  end
  object Edit3: TEdit
    Left = 120
    Top = 141
    Width = 153
    Height = 33
    AutoSize = False
    TabOrder = 3
  end
end
