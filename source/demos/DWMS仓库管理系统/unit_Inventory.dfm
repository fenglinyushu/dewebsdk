object Form_Inventory: TForm_Inventory
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #24211#23384#26597#35810
  ClientHeight = 540
  ClientWidth = 360
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 360
    Height = 540
    Hint = 
      '{"account":"dwERP","table":"eGoods","where":"","pagesize":10,"ro' +
      'wheight":45,"defaultquerymode":2,"edit":1,"new":1,"delete":1,"qu' +
      'ery":1,"switch":1,"buttons":1,"border":1,"fields":[{"name":"gId"' +
      ',"caption":"id","sort":1,"width":"50","type":"auto","align":"cen' +
      'ter","caption":"gId","fuzzy":1,"query":0,"datatype":14},{"name":' +
      '"gActive","caption":"'#22312#29992'","sort":1,"width":"80","type":"boolean",' +
      '"align":"center","query":0,"dbfilter":1,"list":["'#9675'","'#9679'"],"dataty' +
      'pe":5},{"name":"gName","caption":"'#21517#31216'","sort":1,"width":"100","ty' +
      'pe":"string","query":1,"fuzzy":1,"align":"left","datatype":24},{' +
      '"name":"gCode","caption":"'#32534#30721'","sort":1,"width":"80","type":"stri' +
      'ng","query":1,"fuzzy":1,"align":"left","datatype":24},{"name":"g' +
      'Categoryid","caption":"'#31867#21035'","sort":1,"width":"100","type":"dbtree' +
      'pair","align":"center","fuzzy":1,"query":0,"table":"eCategory","' +
      'datafield":"cNo","viewfield":"cName","datatype":3},{"name":"gSup' +
      'plierId","caption":"'#20379#24212#21830'","sort":1,"width":"120","type":"dbcombop' +
      'air","dbfilter":1,"query":0,"table":"eSupplier","datafield":"sID' +
      '","viewfield":"sName","datatype":3},{"name":"gBrand","caption":"' +
      #21697#29260'","sort":1,"width":"80","type":"dbcombopair","query":1,"align"' +
      ':"left","table":"eBrand","datafield":"bNo","viewfield":"bName","' +
      'datatype":24},{"name":"gSpecification","caption":"'#35268#26684'","sort":1,"' +
      'width":"80","type":"string","query":1,"fuzzy":1,"align":"left","' +
      'datatype":24},{"name":"gPhoto","caption":"'#22270#29255'","sort":1,"width":"' +
      '60","type":"image","imgdir":"media/images/gcrudpanel/","imgtype"' +
      ':["jpg","png","bmp","gif"],"imgheight":40,"imgwidth":50,"preview' +
      '":0,"dwstyle":"border-radius:5px;top:3px;","align":"center","dat' +
      'atype":24},{"name":"gUnit","caption":"'#21333#20301'","sort":1,"align":"cent' +
      'er","width":"70","type":"combo","list":["'#20010'","'#30418'","'#34955'","'#29942'","'#32592'","'#26020'",' +
      '"'#20844#26020'","'#20811'","'#21315#20811'","'#21319'","'#27627#21319'","'#22871'","'#32452'"],"datatype":24},{"name":"gInPrice' +
      '","caption":"'#36827#20215'","sort":1,"width":"80","type":"money","align":"r' +
      'ight","fuzzy":1,"query":0,"datatype":8},{"name":"gWareId","capti' +
      'on":"'#20179#24211'","sort":1,"width":"90","align":"right","type":"dbcombopa' +
      'ir","dbfilter":1,"query":0,"table":"eWareHouse","datafield":"wID' +
      '","viewfield":"wName","datatype":3},{"name":"gOutPrice","caption' +
      '":"'#21806#20215'","sort":1,"width":"80","type":"money","align":"right","fuz' +
      'zy":1,"query":0,"datatype":8},{"name":"gQuantity","caption":"'#25968#37327'"' +
      ',"sort":1,"width":"70","type":"integer","align":"right","fuzzy":' +
      '1,"query":0,"datatype":3},{"name":"gAlertQuantity","caption":"'#25253#35686 +
      #25968#37327'","sort":1,"width":"100","type":"integer","align":"right","fuz' +
      'zy":1,"query":0,"datatype":3},{"name":"gCreateTime","caption":"'#21019 +
      #24314#26102#38388'","sort":1,"width":"120","type":"date","align":"center","fuzz' +
      'y":1,"query":0,"datatype":36},{"name":"gUpdateTime","caption":"'#26356 +
      #26032#26102#38388'","sort":1,"width":"120","type":"date","align":"center","quer' +
      'y":0,"datatype":36},{"name":"gDescription","caption":"'#25551#36848'","sort"' +
      ':1,"width":"150","type":"string","query":1,"align":"left","datat' +
      'ype":16}],"margin":10,"radiborderradiusus":0,"defaulteditmax":1,' +
      '"editwidth":360,"buttoncaption":1,"database":"mssql"}'
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
end
