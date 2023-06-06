object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'DBGrid Mobile'
  ClientHeight = 564
  ClientWidth = 360
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnMouseUp = FormMouseUp
  PixelsPerInch = 96
  TextHeight = 20
  object LV: TListView
    Left = 0
    Top = 0
    Width = 360
    Height = 564
    HelpType = htKeyword
    HelpKeyword = 'mobile'
    Align = alClient
    Columns = <
      item
        Caption = 
          '{"caption":"'#21517#31216'","left":120,"top":20,"fontbold":"bold","fontsize"' +
          ':20}'
        Width = 240
      end
      item
        Caption = '{"caption":"'#22411#21495'"}'
        Width = 240
      end
      item
        Caption = '{"caption":"'#21333#20301'"}'
        Width = 240
      end
      item
        Caption = 
          '{"fontcolor":"#f00","fontsize":20,"type":"integer","caption":"'#20215#26684 +
          '","format":"'#165'%n"}'
        Width = 240
      end
      item
        Caption = '{"caption":"'#29983#20135#21378#21830'"}'
        Width = 240
      end
      item
        Caption = 
          '{"caption":"'#30456#29255'","type":"image","left":20,"top":20,"width":80,"he' +
          'ight":80,"format":"media/images/wmp/%s.png","dwstyle":"border-ra' +
          'dius:5px;"}'
        Width = 240
      end
      item
        Caption = 
          '{"type":"button","left":40,"top":105,"width":40,"dwattr":"type='#39 +
          'success'#39'","caption":"+"}'
      end
      item
      end>
    Font.Charset = ANSI_CHARSET
    Font.Color = 6579300
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnEndDrag = LVEndDrag
  end
end
