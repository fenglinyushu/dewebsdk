object Form1: TForm1
  Left = 0
  Top = 0
  Hint = '{"type":"primary"}'
  BorderStyle = bsNone
  Caption = 'login '
  ClientHeight = 728
  ClientWidth = 400
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = 15790320
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnMouseUp = FormMouseUp
  TextHeight = 20
  object E_User: TEdit
    AlignWithMargins = True
    Left = 30
    Top = 100
    Width = 340
    Height = 39
    Hint = 
      '{"prefix-icon":"el-icon-user","placeholder":"'#35831#36755#20837#30331#24405#36134#21495'","dwattr":"' +
      'name=\"Username\" "}'
    Margins.Left = 30
    Margins.Top = 50
    Margins.Right = 30
    Margins.Bottom = 10
    Align = alTop
    AutoSize = False
    Color = clWhite
    TabOrder = 0
    Text = 'superadmin'
  end
  object E_Password: TEdit
    AlignWithMargins = True
    Left = 30
    Top = 159
    Width = 340
    Height = 39
    Hint = 
      '{"prefix-icon":"el-icon-lock","placeholder":"'#35831#36755#20837#30331#24405#23494#30721'","dwattr":"' +
      'name=\"Password\" "}'
    Margins.Left = 30
    Margins.Top = 10
    Margins.Right = 30
    Margins.Bottom = 10
    Align = alTop
    AutoSize = False
    Color = clWhite
    PasswordChar = '*'
    TabOrder = 1
  end
  object BtAdd: TButton
    AlignWithMargins = True
    Left = 30
    Top = 228
    Width = 340
    Height = 40
    Hint = '{"type":"primary"}'
    Margins.Left = 30
    Margins.Top = 20
    Margins.Right = 30
    Margins.Bottom = 10
    Align = alTop
    Caption = #28155#21152
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindow
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = BtAddClick
  end
  object P0: TPanel
    Left = 0
    Top = 0
    Width = 400
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    Color = 16359209
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 3
    object L0: TLabel
      AlignWithMargins = True
      Left = 50
      Top = 3
      Width = 300
      Height = 44
      Margins.Left = 50
      Margins.Right = 50
      Align = alClient
      Alignment = taCenter
      Caption = 'gLogin '#28155#21152#29992#25143
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -20
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 152
      ExplicitHeight = 27
    end
  end
  object FDConnection1: TFDConnection
    Left = 128
    Top = 208
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 128
    Top = 264
  end
  object FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink
    Left = 128
    Top = 320
  end
  object FDPhysODBCDriverLink1: TFDPhysODBCDriverLink
    Left = 128
    Top = 368
  end
  object FDPhysTDataDriverLink1: TFDPhysTDataDriverLink
    Left = 128
    Top = 416
  end
  object FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink
    Left = 128
    Top = 472
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 128
    Top = 520
  end
  object FDPhysOracleDriverLink1: TFDPhysOracleDriverLink
    Left = 128
    Top = 584
  end
end
