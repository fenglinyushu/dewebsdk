object Form1: TForm1
  Left = 0
  Top = 0
  HelpType = htKeyword
  Margins.Top = 20
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'CRUD Panel'
  ClientHeight = 750
  ClientWidth = 1537
  Color = clBtnFace
  TransparentColor = True
  TransparentColorValue = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = True
  Position = poDesigned
  OnMouseUp = FormMouseUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 23
  object Panel1: TPanel
    Left = 217
    Top = 0
    Width = 1320
    Height = 750
    Hint = 
      '{"account":"dwERP","table":"eGoods","where":"","pagesize":10,"ro' +
      'wheight":45,"defaultquerymode":1,"defaultwhere":"gId>50","edit":' +
      '1,"new":1,"delete":1,"query":1,"switch":1,"buttons":1,"border":1' +
      ',"fixed":[1,2],"fields":[{"name":"gId","caption":"'#24207#21495'","sort":1,"' +
      'width":"80","type":"integer","align":"center","fuzzy":1,"query":' +
      '1,"full":1,"datatype":14},{"name":"gName","caption":"'#21517#31216'","sort":' +
      '1,"width":"180","align":"center","fuzzy":1,"query":0,"datatype":' +
      '14},{"name":"gActive","caption":"'#22312#29992'","sort":1,"width":"120","typ' +
      'e":"boolean","align":"center","fuzzy":1,"query":0,"datatype":5},' +
      '{"name":"gCode","caption":"'#32534#30721'","sort":1,"width":"150","type":"st' +
      'ring","query":1,"fuzzy":1,"align":"left","datatype":24},{"name":' +
      '"gCreateTime","caption":"'#21019#24314#26102#38388'","sort":1,"width":"150","type":"da' +
      'tetime","query":1,"fuzzy":1,"align":"center"},{"name":"gCategory' +
      'id","caption":"'#31867#21035'","sort":1,"width":"120","type":"dbtreepair","a' +
      'lign":"center","fuzzy":1,"query":0,"table":"eCategory","datafiel' +
      'd":"cNo","viewfield":"cName","datatype":3},{"name":"gDescription' +
      '","caption":"'#25805#20316'","sort":1,"width":"270","type":"button","query":' +
      '1,"fuzzy":1,"align":"left","list":[{"caption":"'#26032#22686'","type":"info"' +
      ',"width":60,"image":"el-icon-circle-plus-outline","method":"new"' +
      '},{"caption":"'#21024#38500'","type":"danger","width":60,"image":"el-icon-de' +
      'lete","method":"delete"},{"caption":"'#32534#36753'","type":"primary","width' +
      '":60,"image":"el-icon-edit","dwstyle":"","dwattr":"","method":"e' +
      'dit"},{"caption":"'#35780#20272'","type":"success","width":60,"image":"el-ic' +
      'on-user","method":"custom"}]}],"margin":10,"radiborderradiusus":' +
      '0,"defaulteditmax":0,"editwidth":360,"buttoncaption":1,"database' +
      '":"mssql"}'
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
  end
  object Pn1: TPanel
    Left = 0
    Top = 0
    Width = 217
    Height = 750
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object Bt1: TButton
      AlignWithMargins = True
      Left = 3
      Top = 95
      Width = 211
      Height = 35
      Hint = '{"type":"primary"}'
      Margins.Top = 95
      Align = alTop
      Caption = #35774#32622#21333#20803#26684#32972#26223#33394
      TabOrder = 0
      OnClick = Bt1Click
    end
    object Bt2: TButton
      AlignWithMargins = True
      Left = 3
      Top = 136
      Width = 211
      Height = 35
      Hint = '{"type":"primary"}'
      Align = alTop
      Caption = #35774#32622#21333#20803#26684#23383#20307#22823#23567
      TabOrder = 1
      OnClick = Bt2Click
    end
    object Bt3: TButton
      AlignWithMargins = True
      Left = 3
      Top = 177
      Width = 211
      Height = 35
      Hint = '{"type":"primary"}'
      Align = alTop
      Caption = #35774#32622#21333#20803#26684#23383#20307#39068#33394
      TabOrder = 2
      OnClick = Bt3Click
    end
    object Bt4: TButton
      AlignWithMargins = True
      Left = 3
      Top = 218
      Width = 211
      Height = 35
      Hint = '{"type":"primary"}'
      Align = alTop
      Caption = #35774#32622#21333#20803#26684#23383#20307#31895#20307
      TabOrder = 3
      OnClick = Bt4Click
    end
    object Bt5: TButton
      AlignWithMargins = True
      Left = 3
      Top = 259
      Width = 211
      Height = 35
      Hint = '{"type":"primary"}'
      Align = alTop
      Caption = #35774#32622#21333#20803#26684#23383#20307#26012#20307
      TabOrder = 4
      OnClick = Bt5Click
    end
    object Bt6: TButton
      AlignWithMargins = True
      Left = 3
      Top = 300
      Width = 211
      Height = 35
      Hint = '{"type":"primary"}'
      Align = alTop
      Caption = #35774#32622#21333#20803#26684#23383#20307#19979#21010#32447
      TabOrder = 5
      OnClick = Bt6Click
    end
    object Bt7: TButton
      AlignWithMargins = True
      Left = 3
      Top = 341
      Width = 211
      Height = 35
      Hint = '{"type":"primary"}'
      Align = alTop
      Caption = #35774#32622#21333#20803#26684#23383#20307#21024#38500#32447
      TabOrder = 6
      OnClick = Bt7Click
    end
    object Bt8: TButton
      AlignWithMargins = True
      Left = 3
      Top = 382
      Width = 211
      Height = 35
      Hint = '{"type":"primary"}'
      Align = alTop
      Caption = #35774#32622#21333#20803#26684#26174#31034'/'#38544#34255
      TabOrder = 7
      OnClick = Bt8Click
    end
    object Bt9: TButton
      AlignWithMargins = True
      Left = 3
      Top = 423
      Width = 211
      Height = 35
      Hint = '{"type":"primary"}'
      Align = alTop
      Caption = #35774#32622#21333#20803#26684#25353#38062#26174#31034'/'#38544#34255
      TabOrder = 8
      OnClick = Bt9Click
    end
    object Bt10: TButton
      AlignWithMargins = True
      Left = 3
      Top = 464
      Width = 211
      Height = 35
      Hint = '{"type":"primary"}'
      Align = alTop
      Caption = #35774#32622#21333#20803#26684#25353#38062#31105#29992
      TabOrder = 9
      OnClick = Bt10Click
    end
    object Bt11: TButton
      AlignWithMargins = True
      Left = 3
      Top = 505
      Width = 211
      Height = 35
      Hint = '{"type":"primary"}'
      Align = alTop
      Caption = #21512#24182#21333#20803#26684'-'
      TabOrder = 10
      OnClick = Bt11Click
    end
    object Bt12: TButton
      AlignWithMargins = True
      Left = 3
      Top = 546
      Width = 211
      Height = 35
      Hint = '{"type":"primary"}'
      Align = alTop
      Caption = #35774#32622#21333#20803#26684#22797#26434#26684#24335
      TabOrder = 11
      OnClick = Bt12Click
    end
    object Bt13: TButton
      AlignWithMargins = True
      Left = 3
      Top = 587
      Width = 211
      Height = 35
      Hint = '{"type":"primary"}'
      Align = alTop
      Caption = #35774#32622#26631#39064#26639#39068#33394
      TabOrder = 12
      OnClick = Bt13Click
    end
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
end
