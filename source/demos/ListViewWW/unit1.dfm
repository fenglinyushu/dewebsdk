object Form1: TForm1
  Left = 0
  Top = 0
  HelpType = htKeyword
  Margins.Top = 20
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'ListView- WestWind'
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
  object Panel_0_Banner: TPanel
    Left = 0
    Top = 0
    Width = 1201
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    Color = 4271650
    ParentBackground = False
    TabOrder = 0
    object Label_Name: TLabel
      AlignWithMargins = True
      Left = 147
      Top = 3
      Width = 183
      Height = 44
      Margins.Left = 10
      Align = alLeft
      AutoSize = False
      Caption = 'ListView - WestWind'
      Color = 4210752
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
      ExplicitLeft = 210
    end
    object Panel_Title: TPanel
      Left = 0
      Top = 0
      Width = 137
      Height = 50
      Align = alLeft
      BevelOuter = bvNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -29
      Font.Name = 'Verdana'
      Font.Style = [fsBold, fsItalic]
      ParentBackground = False
      ParentColor = True
      ParentFont = False
      TabOrder = 0
      object Label_Title: TLabel
        Left = 0
        Top = 0
        Width = 137
        Height = 50
        HelpType = htKeyword
        Align = alClient
        Alignment = taCenter
        Caption = 'DeWeb'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -24
        Font.Name = 'Verdana'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        Layout = tlCenter
        WordWrap = True
        ExplicitWidth = 96
        ExplicitHeight = 29
      end
    end
    object Edit_Search: TEdit
      AlignWithMargins = True
      Left = 343
      Top = 11
      Width = 287
      Height = 27
      Hint = 
        '{"placeholder":"'#35831#36755#20837#26597#35810#20851#38190#23383'","radius":"15px","suffix-icon":"el-icon' +
        '-search","dwstyle":"padding-left:10px;"}'
      Margins.Left = 10
      Margins.Top = 11
      Margins.Right = 1
      Margins.Bottom = 12
      Align = alLeft
      TabOrder = 1
      OnChange = Edit_SearchChange
      ExplicitHeight = 31
    end
    object Button_ToExcel: TButton
      AlignWithMargins = True
      Left = 1098
      Top = 10
      Width = 93
      Height = 30
      Hint = 
        '{"type":"primary","icon":"el-icon-right","onclick":"this.dwloadi' +
        'ng=true;"}'
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alRight
      Caption = 'Excel'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Visible = False
    end
    object Button_Print: TButton
      AlignWithMargins = True
      Left = 886
      Top = 10
      Width = 93
      Height = 30
      Hint = '{"type":"primary","icon":"el-icon-printer"}'
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alRight
      Caption = 'Print'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Button_PrintClick
    end
    object Button_Edit: TButton
      AlignWithMargins = True
      Left = 992
      Top = 10
      Width = 93
      Height = 30
      Hint = '{"type":"primary","icon":"el-icon-edit-outline"}'
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alRight
      Caption = 'Edit'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = Button_EditClick
    end
  end
  object ListView1: TListView
    Left = 0
    Top = 50
    Width = 1201
    Height = 675
    Hint = 
      '{"dataset":"FDQuery1","merge":[[3,5,8,"'#22522#26412'<br/>'#20449#24687'"],[2,7,8,"'#36890#20449#22320#22336'"' +
      ']],"rowheight":40,"headerheight":40,"summary":["'#27719#24635'",[6,"sum","'#21512#35745 +
      #65306'%.0f"],[6,"avg","'#24179#22343#65306'%.0f"],[9,"max","'#26368#22823#65306'%.0f%%"],[9,"min","'#26368#23567#65306'%' +
      '.0f%%"]]}'
    HelpType = htKeyword
    HelpKeyword = 'ww'
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
        Alignment = taCenter
        Caption = 
          '{"type":"image","caption":"'#30456#29255'","fieldname":"photo","format":"med' +
          'ia/images/mm/%s.jpg","dwstyle":"border:solid 1px #ddd;border-rad' +
          'ius:8px;width:32px;height:32px;fill:fill;"}'
      end
      item
        Alignment = taCenter
        Caption = '{"fieldname":"aname","caption":"'#22995#21517'"}'
        Width = 80
      end
      item
        Alignment = taCenter
        Caption = 
          '{"caption":"'#24615#21035'","type":"boolean","list":["'#27721#23376'","'#32654#22899'"],"fieldname":' +
          '"sex"}'
        Width = 80
      end
      item
        Alignment = taCenter
        Caption = 
          '{"caption":"'#20986#29983#26085#26399'","fieldname":"birthday","type":"date","format":' +
          '"yyyy-MM-dd"}'
        Width = 150
      end
      item
        Alignment = taCenter
        Caption = 
          '{"type":"float","format":"%n","caption":"'#24037#36164'","fieldname":"salary' +
          '","sort":1,"align":"right"}'
        Width = 150
      end
      item
        Alignment = taCenter
        Caption = 
          '{"caption":"'#30465#20221'","fieldname":"province","color":"#88c","bkcolor":' +
          '"#fafafa","list":["'#21271#20140'","'#19978#28023'","'#22825#27941'","'#28246#21271'","'#27827#21271'","'#24191#19996'","'#23665#19996'","'#38485#35199'","'#28246#21335'","' +
          #24191#35199'"]}'
        Width = 80
      end
      item
        Caption = '{"caption":"'#35814#32454#22320#22336'","fieldname":"addr","align":"left"}'
        Width = 200
      end
      item
        Caption = 
          '{"type":"progress","caption":"'#26368#26032'<br/>'#24037#20316'<br/>'#36827#24230'","fieldname":"pro' +
          'gress","total":100,"maxvalue":500}'
        Width = 100
      end
      item
        Caption = 
          '{"type":"button","caption":"'#25805#20316'","list":[["'#23457#26680'","primary"],["'#26597#30475'","' +
          'success"],["'#21024#38500'","danger"]]}'
        Width = 160
      end>
    Font.Charset = ANSI_CHARSET
    Font.Color = 9868950
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ReadOnly = True
    ParentFont = False
    TabOrder = 1
    OnEndDock = ListView1EndDock
  end
  object Panel1: TPanel
    Left = 328
    Top = 360
    Width = 185
    Height = 25
    HelpType = htKeyword
    HelpKeyword = 'hint'
    Caption = 'Panel1'
    Color = 3684408
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindow
    Font.Height = -13
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 2
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 186
    Top = 153
  end
  object FDConnection1: TFDConnection
    Left = 186
    Top = 217
  end
  object FDPhysODBCDriverLink1: TFDPhysODBCDriverLink
    Left = 186
    Top = 273
  end
  object FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink
    Left = 186
    Top = 329
  end
end