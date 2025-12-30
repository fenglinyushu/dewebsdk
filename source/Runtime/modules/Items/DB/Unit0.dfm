object Form_Item: TForm_Item
  Left = 0
  Top = 0
  HelpKeyword = 'embed'
  Caption = '[*caption*]'
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
    Left = 128
    Top = 83
    Width = 43
    Height = 20
    Caption = 'Name'
  end
  object Label2: TLabel
    Left = 128
    Top = 136
    Width = 60
    Height = 20
    Caption = 'Address'
  end
  object Edit1: TEdit
    Left = 200
    Top = 80
    Width = 121
    Height = 28
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 200
    Top = 133
    Width = 297
    Height = 28
    TabOrder = 1
  end
  object Button1: TButton
    Left = 136
    Top = 192
    Width = 97
    Height = 33
    Hint = '{"type":"primary"}'
    Caption = 'Prev'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 248
    Top = 192
    Width = 97
    Height = 33
    Hint = '{"type":"primary"}'
    Caption = 'Next'
    TabOrder = 3
    OnClick = Button2Click
  end
  object FDQuery1: TFDQuery
    AfterScroll = FDQuery1AfterScroll
    Left = 90
    Top = 281
  end
  object FDPhysODBCDriverLink1: TFDPhysODBCDriverLink
    Left = 90
    Top = 337
  end
  object FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink
    Left = 90
    Top = 393
  end
end
