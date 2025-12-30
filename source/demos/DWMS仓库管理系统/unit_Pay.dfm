object Form_Pay: TForm_Pay
  Left = 0
  Top = 0
  HelpType = htKeyword
  HelpKeyword = 'embed'
  BorderStyle = bsNone
  Caption = #36164#26009#31649#29702
  ClientHeight = 657
  ClientWidth = 1063
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnShow = FormShow
  TextHeight = 20
  object Pn1: TPanel
    Left = 0
    Top = 0
    Width = 1063
    Height = 657
    Hint = 
      '{"table":"ePay","fields":[{"name":"pID","type":"index","caption"' +
      ':"'#24207#21495'","align":"center","width":50},{"name":"pName","caption":"'#39033#30446 +
      #21517#31216'","query":1,"sort":1,"width":300},{"name":"pAmount","caption":' +
      '"'#37329#39069'","type":"money","align":"right","sort":1,"width":120},{"name' +
      '":"pMode","type":"combo","caption":"'#31867#22411'","align":"center","query"' +
      ':1,"sort":1,"dbfilter":1,"list":["'#24050#23436#25104'","'#25105#26041#26410#20184#27454'","'#23545#26041#26410#20184#27454'"],"width":' +
      '100},{"name":"pUserId","caption":"'#36127#36131#20154'","align":"center","sort":1' +
      ',"width":120,"query":1,"dbfilter":1,"type":"dbcombopair","table"' +
      ':"eUser","datafield":"uId","viewfield":"uName"},{"name":"pSuppli' +
      'erId","caption":"'#20379#24212#21830'","sort":1,"width":150,"query":1,"dbfilter":' +
      '1,"type":"dbcombopair","table":"eSupplier","datafield":"sId","vi' +
      'ewfield":"sName"},{"name":"pReceiveUnitId","caption":"'#39046#26009#21333#20301'","sor' +
      't":1,"width":120,"query":1,"dbfilter":1,"type":"dbcombopair","ta' +
      'ble":"eReceiveUnit","datafield":"rId","viewfield":"rName"},{"nam' +
      'e":"pDate","type":"date","caption":"'#26085#26399'","sort":1,"width":180},{"' +
      'name":"pRemark","caption":"'#22791#27880'","query":1,"sort":1,"width":100}]}'
    Align = alClient
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    ExplicitLeft = 248
    ExplicitTop = 288
    ExplicitWidth = 185
    ExplicitHeight = 41
  end
end
