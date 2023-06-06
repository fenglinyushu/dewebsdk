object Form1: TForm1
  Left = 0
  Top = 0
  HelpType = htKeyword
  Margins.Top = 20
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'DBGrid - WestWind'
  ClientHeight = 725
  ClientWidth = 1201
  Color = clWindow
  TransparentColor = True
  TransparentColorValue = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnMouseUp = FormMouseUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 23
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 1201
    Height = 725
    Hint = 
      '{"dataset":"FDQuery1","module":[1,1,0,1,1,1],"merge":[[3,5,8,"'#22522#26412 +
      '<br/>'#20449#24687'"],[2,7,8,"'#36890#20449#22320#22336'"]],"summary":["'#27719#24635'",[6,"sum","'#21512#35745#65306'%.0f"],[6' +
      ',"avg","'#24179#22343#65306'%.0f"],[9,"max","'#26368#22823#65306'%.0f%%"],[9,"min","'#26368#23567#65306'%.0f%%"]]}'
    HelpType = htKeyword
    HelpKeyword = 'crud'
    Align = alClient
    Columns = <
      item
        Caption = '{"type":"check"}'
        Width = 30
      end
      item
        Alignment = taCenter
        Caption = '{"type":"index","caption":"'#24207#21495'"}'
      end
      item
        Caption = 
          '{"type":"image","caption":"'#30456#29255'","fieldname":"photo","format":"med' +
          'ia/images/mm/%s.jpg","dwstyle":"border:solid 1px #ddd;border-rad' +
          'ius:8px;width:32px;height:32px;fill:fill;"}'
      end
      item
        Caption = '{"fieldname":"aname","caption":"'#22995#21517'"}'
      end
      item
        Caption = 
          '{"caption":"'#24615#21035'","type":"boolean","list":["'#24069#21733'","'#32654#22899'"],"fieldname":' +
          '"sex"}'
      end
      item
        Alignment = taCenter
        Caption = 
          '{"caption":"'#20986#29983#26085#26399'","fieldname":"birthday","type":"date","format":' +
          '"yyyy-MM-dd"}'
        Width = 120
      end
      item
        Caption = 
          '{"type":"integer","format":"%n","caption":"'#24037#36164'","fieldname":"sala' +
          'ry","minvalue":"2000","maxvalue":"80000","sort":1,"align":"right' +
          '"}'
        Width = 160
      end
      item
        Alignment = taCenter
        Caption = 
          '{"caption":"'#30465#20221'","fieldname":"province","color":"#88c","bkcolor":' +
          '"#fafafa","type":"combo","list":["'#21271#20140'","'#19978#28023'","'#22825#27941'","'#28246#21271'","'#27827#21271'","'#24191#19996'","' +
          #23665#19996'","'#38485#35199'","'#28246#21335'","'#24191#35199'"]}'
      end
      item
        Caption = '{"caption":"'#35814#32454#22320#22336'","fieldname":"addr","align":"left"}'
        Width = 200
      end
      item
        Caption = 
          '{"type":"progress","caption":"'#26368#26032'<br/>'#24037#20316'<br/>'#36827#24230'","fieldname":"pro' +
          'gress","total":100,"readonly":1,"sort":1,"maxvalue":500}'
      end
      item
        Caption = 
          '{"type":"button","caption":"'#25805#20316'","list":[["'#23457#26680'","primary"],["'#26597#30475'","' +
          'success"],["'#21024#38500'","danger"]]}'
        Width = 180
      end>
    Font.Charset = ANSI_CHARSET
    Font.Color = 6709856
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    ViewStyle = vsReport
  end
  object FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink
    Left = 258
    Top = 273
  end
  object FDPhysODBCDriverLink1: TFDPhysODBCDriverLink
    Left = 258
    Top = 217
  end
  object FDConnection1: TFDConnection
    Left = 258
    Top = 161
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 258
    Top = 97
  end
  object FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink
    Left = 256
    Top = 344
  end
end
