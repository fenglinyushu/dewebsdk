object Form_Password: TForm_Password
  Left = 0
  Top = 0
  HelpKeyword = 'embed'
  Caption = #26356#25913#23494#30721
  ClientHeight = 619
  ClientWidth = 883
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clGray
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 20
  object Label1: TLabel
    Left = 48
    Top = 43
    Width = 100
    Height = 20
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Name'
  end
  object Label2: TLabel
    Left = 48
    Top = 96
    Width = 100
    Height = 20
    Alignment = taRightJustify
    AutoSize = False
    Caption = #26087#23494#30721
  end
  object Label3: TLabel
    Left = 48
    Top = 152
    Width = 100
    Height = 20
    Alignment = taRightJustify
    AutoSize = False
    Caption = #26032#23494#30721
  end
  object Label4: TLabel
    Left = 48
    Top = 209
    Width = 100
    Height = 20
    Alignment = taRightJustify
    AutoSize = False
    Caption = #30830#35748#23494#30721
  end
  object Label5: TLabel
    Left = 487
    Top = 152
    Width = 114
    Height = 20
    AutoSize = False
    Caption = #65288#33267#23569'6'#20010#23383#31526#65289
  end
  object Edit_AName: TEdit
    Left = 168
    Top = 40
    Width = 121
    Height = 28
    ReadOnly = True
    TabOrder = 0
  end
  object Edit_OldPassword: TEdit
    Left = 168
    Top = 93
    Width = 297
    Height = 28
    PasswordChar = '*'
    TabOrder = 1
  end
  object B_Cancel: TButton
    Left = 168
    Top = 264
    Width = 97
    Height = 33
    Caption = #21462#28040
    TabOrder = 2
    OnClick = B_CancelClick
  end
  object B_OK: TButton
    Left = 279
    Top = 264
    Width = 97
    Height = 33
    Hint = '{"type":"primary"}'
    Caption = #30830#23450
    TabOrder = 3
    OnClick = B_OKClick
  end
  object Edit_NewPassword: TEdit
    Left = 168
    Top = 149
    Width = 297
    Height = 28
    PasswordChar = '*'
    TabOrder = 4
  end
  object Edit_ConfirmPassword: TEdit
    Left = 168
    Top = 206
    Width = 297
    Height = 28
    PasswordChar = '*'
    TabOrder = 5
  end
  object FDQuery1: TFDQuery
    Left = 34
    Top = 25
  end
end
