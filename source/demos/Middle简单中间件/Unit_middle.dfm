object Form_Middle: TForm_Middle
  Left = 0
  Top = 0
  Caption = 'Form_Middle'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object FDConnection1: TFDConnection
    Left = 80
    Top = 64
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 80
    Top = 128
  end
  object FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink
    Left = 80
    Top = 192
  end
  object FDStanStorageJSONLink1: TFDStanStorageJSONLink
    Left = 80
    Top = 256
  end
end
