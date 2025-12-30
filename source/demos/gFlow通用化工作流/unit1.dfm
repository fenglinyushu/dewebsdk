object Form1: TForm1
  Left = 0
  Top = 0
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'DeWeb'
  ClientHeight = 640
  ClientWidth = 1000
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnMouseUp = FormMouseUp
  OnShow = FormShow
  TextHeight = 21
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1000
    Height = 640
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
  end
  object FDConnection1: TFDConnection
    Left = 96
    Top = 88
  end
  object FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink
    Left = 96
    Top = 464
  end
  object FDPhysOracleDriverLink1: TFDPhysOracleDriverLink
    Left = 96
    Top = 152
  end
  object FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink
    Left = 96
    Top = 216
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 96
    Top = 280
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 96
    Top = 344
  end
  object FDPhysODBCDriverLink1: TFDPhysODBCDriverLink
    Left = 96
    Top = 400
  end
end
