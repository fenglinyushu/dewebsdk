object Form_Item: TForm_Item
  Left = 0
  Top = 0
  HelpKeyword = 'embed'
  Caption = '[*caption*]'
  ClientHeight = 619
  ClientWidth = 883
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = 16117483
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 20
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 883
    Height = 619
    Hint = 
      '{"dataset":"FDQuery1","datastyle":"border-top:solid 1px #ed6d00;' +
      '"}'
    HelpType = htKeyword
    HelpKeyword = 'crud'
    Align = alClient
    BorderStyle = bsNone
    Columns = <
      item
        Caption = '{"type":"check"}'
      end
      item
        Caption = '{"fieldname":"'#21517#31216'","sort":1}'
        Width = 120
      end
      item
        Caption = '{"fieldname":"'#22411#21495'","sort":1}'
        Width = 120
      end
      item
        Caption = '{"fieldname":"'#31867#21035'","sort":1}'
        Width = 120
      end
      item
        Caption = '{"fieldname":"'#20379#24212#21830'","sort":1}'
        Width = 120
      end
      item
        Caption = '{"fieldname":"'#20179#24211'","sort":1}'
        Width = 120
      end
      item
        Caption = '{"fieldname":"'#21333#20301'","sort":1}'
        Width = 120
      end
      item
        Caption = '{"fieldname":"'#21333#20215'","sort":1}'
        Width = 120
      end
      item
        Caption = '{"fieldname":"'#25968#37327'","sort":1}'
        Width = 120
      end>
    Font.Charset = ANSI_CHARSET
    Font.Color = 9868950
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    ViewStyle = vsReport
  end
  object FDQuery1: TFDQuery
    Left = 96
    Top = 213
  end
end
