object Form_sys_User: TForm_sys_User
  Left = 0
  Top = 0
  HelpType = htKeyword
  HelpKeyword = 'embed'
  Caption = #29992#25143#31649#29702
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
      '{"table":"sys_User","defaultquerymode":1,"select":40,"visiblecol' +
      '":2,"defaulteditmax":0,"deletecols":[2],"fields":[{"name":"uAvat' +
      'ar","caption":"'#30456#29255'","type":"image","imgdir":"media/system/qbank/"' +
      ',"imgtype":["jpg","png","gif"],"imgheight":45,"imgwidth":45,"pre' +
      'view":1,"align":"center","default":"00.jpg","width":55},{"name":' +
      '"uName","caption":"'#29992#25143#21517'","query":1,"sort":1,"must":1,"width":100}' +
      ',{"name":"uRole","caption":"'#35282#33394'","type":"dbcombo","sort":1,"width' +
      '":100,"align":"center","table":"sys_Role","datafield":"rName","d' +
      'efault":"'#21629#39064#21592'"},{"name":"uRemark","caption":"'#22791#27880'","query":1,"sort"' +
      ':1,"width":80},{"name":"uId","view":2},{"name":"uDepartmentId","' +
      'view":2},{"name":"uPassword","default":"123456","view":4}]}'
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Pn1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
  end
end
