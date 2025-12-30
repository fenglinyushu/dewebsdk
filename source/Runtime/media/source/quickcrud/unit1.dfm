object Form1: TForm1
  Left = 0
  Top = 0
  HelpType = htKeyword
  Margins.Top = 20
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'QuickCRUD'
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
  StyleName = 
    [*stylename*]
  OnMouseUp = FormMouseUp
  OnShow = FormShow
  TextHeight = 23
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=MSAcc')
    Left = 256
    Top = 128
  end
  object FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink
    Left = 256
    Top = 184
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 256
    Top = 248
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 256
    Top = 312
  end
  object FDPhysODBCDriverLink1: TFDPhysODBCDriverLink
    Left = 256
    Top = 368
  end
  object FDPhysOracleDriverLink1: TFDPhysOracleDriverLink
    Left = 256
    Top = 72
  end
  object FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink
    Left = 256
    Top = 424
  end
end
