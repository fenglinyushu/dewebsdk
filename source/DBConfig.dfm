object Form_DBConfig: TForm_DBConfig
  Left = 0
  Top = 0
  Caption = 'DataBase Config'
  ClientHeight = 297
  ClientWidth = 453
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 447
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 100
      Height = 34
      Margins.Right = 15
      Align = alLeft
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'DriverID'
      Layout = tlCenter
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitHeight = 40
    end
    object ComboBox_DriverID: TComboBox
      AlignWithMargins = True
      Left = 121
      Top = 5
      Width = 280
      Height = 24
      Margins.Top = 5
      Align = alLeft
      ItemIndex = 10
      TabOrder = 0
      Text = 'MSSQL'
      Items.Strings = (
        'ADS'
        'ASA'
        'DB2'
        'DS'
        'FB'
        'IB'
        'IBLite'
        'Infx'
        'Mongo'
        'MSAcc'
        'MSSQL'
        'MySQL'
        'ODBC'
        'Ora'
        'PG'
        'SQLite'
        'TData'
        'TDBX')
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 49
    Width = 447
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Label2: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 100
      Height = 34
      Margins.Right = 15
      Align = alLeft
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'DataBase'
      Layout = tlCenter
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitHeight = 40
    end
    object Edit_DataBase: TEdit
      AlignWithMargins = True
      Left = 121
      Top = 5
      Width = 280
      Height = 30
      Margins.Top = 5
      Margins.Bottom = 5
      Align = alLeft
      TabOrder = 0
      Text = 'Master'
      ExplicitHeight = 24
    end
  end
  object Panel3: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 95
    Width = 447
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Label3: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 100
      Height = 34
      Margins.Right = 15
      Align = alLeft
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'UserName'
      Layout = tlCenter
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitHeight = 40
    end
    object Edit_User_Name: TEdit
      AlignWithMargins = True
      Left = 121
      Top = 5
      Width = 280
      Height = 30
      Margins.Top = 5
      Margins.Bottom = 5
      Align = alLeft
      TabOrder = 0
      Text = 'sa'
      ExplicitHeight = 24
    end
  end
  object Panel4: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 141
    Width = 447
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object Label4: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 100
      Height = 34
      Margins.Right = 15
      Align = alLeft
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Password'
      Layout = tlCenter
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitHeight = 40
    end
    object Edit_Password: TEdit
      AlignWithMargins = True
      Left = 121
      Top = 5
      Width = 280
      Height = 30
      Margins.Top = 5
      Margins.Bottom = 5
      Align = alLeft
      TabOrder = 0
      ExplicitHeight = 24
    end
  end
  object Panel5: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 187
    Width = 447
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    object Label5: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 100
      Height = 34
      Margins.Right = 15
      Align = alLeft
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Server'
      Layout = tlCenter
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitHeight = 40
    end
    object Edit_Server: TEdit
      AlignWithMargins = True
      Left = 121
      Top = 5
      Width = 280
      Height = 30
      Margins.Top = 5
      Margins.Bottom = 5
      Align = alLeft
      TabOrder = 0
      Text = '127.0.0.1'
      ExplicitHeight = 24
    end
  end
  object Panel6: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 254
    Width = 447
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 5
    object Button_Test: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 75
      Height = 34
      Align = alLeft
      Caption = 'Test'
      TabOrder = 0
      OnClick = Button_TestClick
    end
    object Button_OK: TButton
      AlignWithMargins = True
      Left = 288
      Top = 3
      Width = 75
      Height = 34
      Align = alRight
      Caption = 'OK'
      TabOrder = 1
      OnClick = Button_OKClick
    end
    object Button_Cancel: TButton
      AlignWithMargins = True
      Left = 369
      Top = 3
      Width = 75
      Height = 34
      Align = alRight
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = Button_CancelClick
    end
  end
end
