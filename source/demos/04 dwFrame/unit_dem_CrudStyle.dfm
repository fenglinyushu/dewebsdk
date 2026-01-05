object Form_dem_CrudStyle: TForm_dem_CrudStyle
  Left = 0
  Top = 0
  HelpType = htKeyword
  Margins.Top = 20
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'Crud Style'
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
  Position = poDesigned
  OnMouseUp = FormMouseUp
  OnShow = FormShow
  TextHeight = 23
  object Panel1: TPanel
    Left = 217
    Top = 0
    Width = 1320
    Height = 750
    Hint = 
      '{"account":"dwFrame","deletecols":[3,4],"batch":0,"import":0,"ex' +
      'port":1,"rowheight":40,"select":40,"pagesize":10,"table":"bop_co' +
      'ntract","visiblecol":1,"defaultorder":"cid DESC","dwstyle":"user' +
      '-select: text;","fields":[{"name":"cUserID","caption":"'#19994#21153#21592'","typ' +
      'e":"dbcombopair","sort":1,"view":3,"readonly":1,"query":1,"width' +
      '":100,"dbfilter":1,"align":"center","table":"sys_user","datafiel' +
      'd":"uid","viewfield":"uname"},{"name":"cProductionSupervisorId",' +
      '"caption":"'#29983#20135#20027#31649'","type":"dbcombopair","sort":1,"query":1,"width"' +
      ':120,"dbfilter":1,"align":"center","table":"sys_user","datafield' +
      '":"uId","viewfield":"uName","viewdefault":"-"},{"name":"cPI_NO",' +
      '"caption":"PI'#21495'","sort":1,"query":1,"view":3,"width":160},{"name"' +
      ':"cOrderStatus","caption":"'#35746#21333#29366#24577'","align":"center","dbfilter":1,"' +
      'type":"combo","list":["'#24050#23436#32467'","'#24050#25237#20135'","'#31561#24453#23450#37329'","'#21487#29305#27530#20808#34892'","'#24322#24120#29366#24577'"],"defaul' +
      't":"'#31561#24453#23450#37329'","sort":1,"width":120,"query":1},{"name":"cDetail","cap' +
      'tion":"'#20135#21697#28165#21333'","sort":1,"query":1,"view":2,"width":150},{"name":"c' +
      'CustomerId","caption":"'#23458#25143'","sort":1,"dbfilter":1,"width":160,"ty' +
      'pe":"dbcombopair","table":"dic_customer","datafield":"cId","view' +
      'field":"cName"},{"name":"cEntryDate","caption":"'#24405#20837#26085#26399'","type":"da' +
      'te","align":"center","width":100,"sort":1},{"name":"cETD","capti' +
      'on":"'#20132#26399'ETD","type":"date","align":"center","width":100,"sort":1}' +
      ',{"name":"cRemark","caption":"'#22791#27880'","sort":1,"width":70,"query":1}' +
      ']}'
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
end
