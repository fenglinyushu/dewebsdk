object Form_InQuery: TForm_InQuery
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #20837#24211#26597#35810
  ClientHeight = 644
  ClientWidth = 1400
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OnShow = FormShow
  TextHeight = 23
  object PnM: TPanel
    Left = 0
    Top = 0
    Width = 1045
    Height = 644
    Hint = 
      '{"account":"dwERP","defaultquerymode":1,"table":"eInboundOrder",' +
      '"defaultorder":"iDate DESC","pagesize":10,"slave":[{"panel":"PnS' +
      '","masterfield":"iId","slavefield":"dOrderID"}],"fields":[{"name' +
      '":"iId","view":2},{"name":"iNo","caption":"'#21333#25454#32534#21495'","sort":1,"query' +
      '":1,"align":"center","width":200},{"name":"iDate","caption":"'#26085#26399'"' +
      ',"type":"date","align":"center","sort":1,"width":120,"query":1},' +
      '{"name":"iSupplierId","caption":"'#20379#24212#21830'","sort":1,"width":120,"quer' +
      'y":1,"dbfilter":1,"table":"eSupplier","type":"dbcombopair","data' +
      'field":"sId","viewfield":"sName"},{"name":"iWareHouseId","captio' +
      'n":"'#20179#24211'","sort":1,"width":100,"query":1,"dbfilter":1,"table":"eWa' +
      'reHouse","type":"dbcombopair","datafield":"wId","viewfield":"wNa' +
      'me"},{"name":"iHandlerId","caption":"'#32463#25163#20154'","sort":1,"width":100,"' +
      'query":1,"dbfilter":1,"align":"center","table":"eUser","type":"d' +
      'bcombopair","datafield":"uId","viewfield":"uName"},{"name":"iVer' +
      'ifierId","caption":"'#26680#21333#20154'","sort":1,"width":100,"query":1,"dbfilte' +
      'r":1,"align":"center","table":"eUser","type":"dbcombopair","data' +
      'field":"uId","viewfield":"uName"},{"name":"iRemark","caption":"'#22791 +
      #27880'","sort":1,"query":1,"width":100}]}'
    Align = alClient
    BevelKind = bkFlat
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
  object PnS: TPanel
    Left = 1045
    Top = 0
    Width = 355
    Height = 644
    Hint = 
      '{"account":"dwERP","defaultquerymode":1,"table":"eInboundOrderDe' +
      'tail","pagesize":10,"buttoncaption":0,"prefix":"_s","master":{"p' +
      'anel":"PnM","masterfield":"iId","slavefield":"dOrderId"},"fields' +
      '":[{"name":"dOrderId","view":2},{"name":"dGoodsId","caption":"'#21830#21697 +
      #21517#31216'","sort":1,"width":120,"query":1,"dbfilter":1,"type":"dbcombop' +
      'air","table":"eGoods","datafield":"gId","viewfield":"gName"},{"n' +
      'ame":"dQuantity","caption":"'#25968#37327'","sort":1,"width":70,"align":"rig' +
      'ht","type":"integer"},{"name":"dPrice","caption":"'#21333#20215'","sort":1,"' +
      'width":80,"align":"right","type":"money"},{"name":"dAmount","cap' +
      'tion":"'#37329#39069'","sort":1,"width":80,"align":"right","type":"money"}]}'
    Align = alRight
    BevelKind = bkFlat
    BevelOuter = bvNone
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
  end
end
