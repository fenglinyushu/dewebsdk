object Form_Account: TForm_Account
  Left = 0
  Top = 0
  Caption = 'Account infomation'
  ClientHeight = 501
  ClientWidth = 584
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  TextHeight = 20
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 10
    Width = 578
    Height = 40
    Margins.Top = 10
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label2: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 0
      Width = 90
      Height = 40
      Margins.Top = 0
      Margins.Right = 15
      Margins.Bottom = 0
      Align = alLeft
      Alignment = taCenter
      AutoSize = False
      Caption = 'Name'
      Layout = tlCenter
      WordWrap = True
    end
    object Edit_Name: TEdit
      AlignWithMargins = True
      Left = 111
      Top = 5
      Width = 391
      Height = 30
      Margins.Top = 5
      Margins.Right = 76
      Margins.Bottom = 5
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 71
      ExplicitWidth = 431
      ExplicitHeight = 28
    end
  end
  object Panel3: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 298
    Width = 578
    Height = 103
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 292
    object Label3: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 0
      Width = 90
      Height = 103
      Margins.Top = 0
      Margins.Right = 15
      Margins.Bottom = 0
      Align = alLeft
      Alignment = taCenter
      AutoSize = False
      Caption = 'Params'
      Layout = tlCenter
      WordWrap = True
    end
    object Memo_Params: TMemo
      AlignWithMargins = True
      Left = 111
      Top = 5
      Width = 391
      Height = 93
      Margins.Top = 5
      Margins.Right = 76
      Margins.Bottom = 5
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 71
      ExplicitWidth = 431
    end
  end
  object Panel4: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 56
    Width = 578
    Height = 140
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Label4: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 90
      Height = 134
      Margins.Right = 15
      Align = alLeft
      Alignment = taCenter
      AutoSize = False
      Caption = 'Connection String'
      Layout = tlCenter
      WordWrap = True
    end
    object Memo_String: TMemo
      AlignWithMargins = True
      Left = 111
      Top = 5
      Width = 391
      Height = 130
      Margins.Top = 5
      Margins.Bottom = 5
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 71
      ExplicitWidth = 431
    end
    object Button_Test: TButton
      AlignWithMargins = True
      Left = 508
      Top = 3
      Width = 60
      Height = 35
      Margins.Right = 10
      Margins.Bottom = 102
      Align = alRight
      Caption = 'Config'
      TabOrder = 1
      OnClick = Button_TestClick
    end
  end
  object Panel5: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 407
    Width = 578
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitTop = 401
    object Label5: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 90
      Height = 34
      Margins.Right = 15
      Align = alLeft
      Alignment = taCenter
      AutoSize = False
      Caption = 'Remark'
      Layout = tlCenter
    end
    object Edit_Remark: TEdit
      AlignWithMargins = True
      Left = 111
      Top = 5
      Width = 391
      Height = 30
      Margins.Top = 5
      Margins.Right = 76
      Margins.Bottom = 5
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 71
      ExplicitWidth = 431
      ExplicitHeight = 28
    end
  end
  object Panel6: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 458
    Width = 578
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    object Button_OK: TButton
      AlignWithMargins = True
      Left = 362
      Top = 3
      Width = 100
      Height = 34
      Align = alRight
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = Button_OKClick
    end
    object Button_Cancel: TButton
      AlignWithMargins = True
      Left = 468
      Top = 3
      Width = 100
      Height = 34
      Margins.Right = 10
      Align = alRight
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      OnClick = Button_CancelClick
    end
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 202
    Width = 578
    Height = 45
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 5
    object Label1: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 0
      Width = 90
      Height = 45
      Margins.Top = 0
      Margins.Right = 15
      Margins.Bottom = 0
      Align = alLeft
      Alignment = taCenter
      AutoSize = False
      Caption = 'Encrypt'
      Layout = tlCenter
      WordWrap = True
      ExplicitHeight = 39
    end
    object Label6: TLabel
      AlignWithMargins = True
      Left = 159
      Top = 0
      Width = 386
      Height = 45
      Margins.Top = 0
      Margins.Right = 15
      Margins.Bottom = 0
      Align = alLeft
      AutoSize = False
      Caption = 
        'Note: Once encrypted, account set information cannot be edited a' +
        'gain.'
      Layout = tlCenter
      WordWrap = True
      ExplicitHeight = 39
    end
    object CheckBox_Secret: TCheckBox
      AlignWithMargins = True
      Left = 113
      Top = 3
      Width = 40
      Height = 39
      Margins.Left = 5
      Align = alLeft
      TabOrder = 0
      ExplicitLeft = 73
      ExplicitHeight = 33
    end
  end
  object Panel7: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 253
    Width = 578
    Height = 39
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 6
    ExplicitTop = 247
    object Label7: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 0
      Width = 90
      Height = 39
      Margins.Top = 0
      Margins.Right = 15
      Margins.Bottom = 0
      Align = alLeft
      Alignment = taCenter
      AutoSize = False
      Caption = 'Disabled'
      Layout = tlCenter
      WordWrap = True
    end
    object CheckBox_Disable: TCheckBox
      AlignWithMargins = True
      Left = 113
      Top = 3
      Width = 40
      Height = 33
      Margins.Left = 5
      Align = alLeft
      TabOrder = 0
      ExplicitLeft = 73
    end
  end
  object FDConnection1: TFDConnection
    Left = 144
    Top = 128
  end
  object FDMoniCustomClientLink1: TFDMoniCustomClientLink
    Left = 72
    Top = 64
  end
  object FDMoniFlatFileClientLink1: TFDMoniFlatFileClientLink
    Left = 72
    Top = 112
  end
  object FDMoniRemoteClientLink1: TFDMoniRemoteClientLink
    Left = 72
    Top = 16
  end
  object FDPhysADSDriverLink1: TFDPhysADSDriverLink
    Left = 72
    Top = 400
  end
  object FDPhysASADriverLink1: TFDPhysASADriverLink
    Left = 256
    Top = 352
  end
  object FDPhysDB2DriverLink1: TFDPhysDB2DriverLink
    Left = 256
    Top = 160
  end
  object FDPhysDSDriverLink1: TFDPhysDSDriverLink
    Left = 256
    Top = 496
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    Left = 72
    Top = 448
  end
  object FDPhysIBDriverLink1: TFDPhysIBDriverLink
    Left = 256
    Top = 16
  end
  object FDPhysInfxDriverLink1: TFDPhysInfxDriverLink
    Left = 256
    Top = 208
  end
  object FDPhysMongoDriverLink1: TFDPhysMongoDriverLink
    Left = 256
    Top = 448
  end
  object FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink
    Left = 72
    Top = 304
  end
  object FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink
    ODBCDriver = 'SQL Server'
    Left = 256
    Top = 256
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 72
    Top = 352
  end
  object FDPhysODBCDriverLink1: TFDPhysODBCDriverLink
    Left = 256
    Top = 400
  end
  object FDPhysOracleDriverLink1: TFDPhysOracleDriverLink
    Left = 256
    Top = 112
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    Left = 72
    Top = 496
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 256
    Top = 64
  end
  object FDPhysTDataDriverLink1: TFDPhysTDataDriverLink
    Left = 256
    Top = 304
  end
  object FDPhysTDBXDriverLink1: TFDPhysTDBXDriverLink
    Left = 256
    Top = 544
  end
  object FDStanStorageBinLink1: TFDStanStorageBinLink
    Left = 72
    Top = 160
  end
  object FDStanStorageJSONLink1: TFDStanStorageJSONLink
    Left = 72
    Top = 256
  end
  object FDStanStorageXMLLink1: TFDStanStorageXMLLink
    Left = 72
    Top = 208
  end
end
