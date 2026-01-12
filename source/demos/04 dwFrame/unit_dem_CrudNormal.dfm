object Form_dem_CrudNormal: TForm_dem_CrudNormal
  Left = 0
  Top = 0
  HelpType = htKeyword
  HelpKeyword = 'embed'
  Caption = 'Crud Normal'
  ClientHeight = 499
  ClientWidth = 931
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  StyleName = 
    '{"table":"dwUser","margin":0,"radius":0,"border":0,"print":0,"pa' +
    'gesize":10,"defaultquerymode":1,"rowheight":40,"fields":[{"name"' +
    ':"uName","caption":"'#29992#25143#21517'","query":1,"sort":1,"width":100},{"name"' +
    ':"uRealName","caption":"'#22995#21517'","query":1,"sort":1,"width":100},{"na' +
    'me":"uSex","type":"boolean","caption":"'#24615#21035'","query":1,"sort":1,"l' +
    'ist":["'#22899'","'#30007'"],"width":80},{"name":"uAge","type":"integer","capt' +
    'ion":"'#24180#40836'","query":1,"sort":1,"max":65,"min":22,"width":80},{"nam' +
    'e":"uDepartment","caption":"'#37096#38376'","type":"combopair","width":0,"li' +
    'st":[]},{"name":"uPhone","caption":"'#30005#35805'","sort":1,"query":1,"widt' +
    'h":180},{"name":"uRemark","caption":"'#22791#27880'","query":1,"sort":1,"wid' +
    'th":100}]}'
  OnShow = FormShow
  TextHeight = 20
  object Pn1: TPanel
    Left = 0
    Top = 0
    Width = 931
    Height = 499
    Hint = 
      '{"account":"dwFrame","deletecols":[3,4],"pagesizes":"[10, 20, 30' +
      ', 40]","batch":0,"import":0,"export":1,"rowheight":40,"select":4' +
      '0,"pagesize":10,"table":"bop_contract","visiblecol":1,"defaultor' +
      'der":"cid DESC","dwstyle":"user-select: text;","fields":[{"name"' +
      ':"cid","caption":"'#32534#21495'","align":"center","width":50,"type":"auto"}' +
      ',{"name":"cUserID","caption":"'#19994#21153#21592'","type":"dbcombopair","sort":1' +
      ',"view":3,"readonly":1,"query":1,"width":100,"dbfilter":1,"align' +
      '":"center","table":"sys_user","datafield":"uid","viewfield":"una' +
      'me"},{"name":"cProductionSupervisorId","caption":"'#29983#20135#20027#31649'","type":"' +
      'dbcombopair","sort":1,"query":1,"width":120,"dbfilter":1,"align"' +
      ':"center","table":"sys_user","datafield":"uId","viewfield":"uNam' +
      'e","viewdefault":"-"},{"name":"cPI_NO","caption":"PI'#21495'","sort":1,' +
      '"query":1,"view":3,"width":160},{"name":"cOrderStatus","caption"' +
      ':"'#35746#21333#29366#24577'","align":"center","dbfilter":1,"type":"combo","list":["'#24050#23436 +
      #32467'","'#24050#25237#20135'","'#31561#24453#23450#37329'","'#21487#29305#27530#20808#34892'","'#24322#24120#29366#24577'"],"default":"'#31561#24453#23450#37329'","sort":1,"width' +
      '":120,"query":1},{"name":"cDetail","caption":"'#20135#21697#28165#21333'","sort":1,"qu' +
      'ery":1,"view":2,"width":150},{"name":"cCustomerId","caption":"'#23458#25143 +
      '","sort":1,"dbfilter":1,"width":160,"type":"dbcombopair","table"' +
      ':"dic_customer","datafield":"cId","viewfield":"cName"},{"name":"' +
      'cEntryDate","caption":"'#24405#20837#26085#26399'","type":"date","align":"center","wid' +
      'th":100,"sort":1},{"name":"cETD","caption":"'#20132#26399'ETD","type":"date"' +
      ',"align":"center","width":100,"sort":1},{"name":"cRemark","capti' +
      'on":"'#22791#27880'","sort":1,"width":70,"query":1}]}'
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Pn1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
  end
end
