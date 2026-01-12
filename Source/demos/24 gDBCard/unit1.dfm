object Form1: TForm1
  Left = 0
  Top = 0
  HelpType = htKeyword
  Margins.Top = 20
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'DeWeb DBCard'
  ClientHeight = 515
  ClientWidth = 933
  Color = clBtnFace
  TransparentColor = True
  TransparentColorValue = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnMouseUp = FormMouseUp
  OnShow = FormShow
  TextHeight = 23
  object LaInfo: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 59
    Width = 927
    Height = 80
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = '.....'
    Layout = tlCenter
    ExplicitTop = 3
  end
  object Panel1: TPanel
    Left = 0
    Top = 142
    Width = 933
    Height = 373
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clGray
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    OnDragOver = Panel1DragOver
  end
  object Button2: TButton
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 927
    Height = 50
    Hint = '{"type":"primary"}'
    Align = alTop
    Caption = #27979#35797
    TabOrder = 1
    Visible = False
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=MSAcc')
    Left = 168
    Top = 96
  end
  object FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink
    Left = 168
    Top = 152
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 168
    Top = 216
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 168
    Top = 280
  end
  object FDPhysODBCDriverLink1: TFDPhysODBCDriverLink
    Left = 168
    Top = 336
  end
  object FDPhysOracleDriverLink1: TFDPhysOracleDriverLink
    Left = 168
    Top = 40
  end
  object FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink
    Left = 168
    Top = 392
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    Left = 168
    Top = 446
  end
end
