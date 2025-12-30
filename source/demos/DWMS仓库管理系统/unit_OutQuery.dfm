object Form_OutQuery: TForm_OutQuery
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #20986#24211#26597#35810
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
      '{"account":"dwERP","defaultquerymode":1,"defaultempty":1,"table"' +
      ':"eOutboundOrder","defaultorder":"oDate DESC","pagesize":10,"sla' +
      've":[{"panel":"PnS","masterfield":"oId","slavefield":"dOrderID"}' +
      '],"fields":[{"name":"oId","view":2},{"name":"oNo","caption":"'#21333#25454#32534 +
      #21495'","sort":1,"query":1,"align":"center","width":200},{"name":"oDa' +
      'te","caption":"'#26085#26399'","type":"date","align":"center","sort":1,"widt' +
      'h":120,"query":1},{"name":"oReceiveUnitID","caption":"'#39046#26009#21333#20301'","sor' +
      't":1,"width":120,"query":1,"dbfilter":1,"table":"eReceiveUnit","' +
      'type":"dbcombopair","datafield":"rId","viewfield":"rName"},{"nam' +
      'e":"oHandlerId","caption":"'#32463#25163#20154'","sort":1,"width":100,"query":1,"' +
      'dbfilter":1,"align":"center","table":"eUser","type":"dbcombopair' +
      '","datafield":"uId","viewfield":"uName"},{"name":"oVerifierId","' +
      'caption":"'#26680#21333#20154'","sort":1,"width":100,"query":1,"dbfilter":1,"alig' +
      'n":"center","table":"eUser","type":"dbcombopair","datafield":"uI' +
      'd","viewfield":"uName"},{"name":"oRemark","caption":"'#22791#27880'","sort":' +
      '1,"query":1,"width":100}]}'
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
    ExplicitLeft = -6
  end
  object PnS: TPanel
    Left = 1045
    Top = 0
    Width = 355
    Height = 644
    Hint = 
      '{"account":"dwERP","defaultquerymode":1,"table":"eOutboundOrderD' +
      'etail","pagesize":10,"buttoncaption":0,"prefix":"_s","master":{"' +
      'panel":"PnM","masterfield":"oId","slavefield":"dOrderId"},"field' +
      's":[{"name":"dOrderId","view":2},{"name":"dGoodsId","caption":"'#21830 +
      #21697#21517#31216'","sort":1,"width":120,"query":1,"dbfilter":1,"type":"dbcombo' +
      'pair","table":"eGoods","datafield":"gId","viewfield":"gName"},{"' +
      'name":"dQuantity","caption":"'#25968#37327'","sort":1,"width":70,"align":"ri' +
      'ght","type":"integer"},{"name":"dPrice","caption":"'#21333#20215'","sort":1,' +
      '"width":80,"align":"right","type":"money"},{"name":"dAmount","ca' +
      'ption":"'#37329#39069'","sort":1,"width":80,"align":"right","type":"money"}]' +
      ',"dwstyle":"border-left:solid 1px #ccc;"}'
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
