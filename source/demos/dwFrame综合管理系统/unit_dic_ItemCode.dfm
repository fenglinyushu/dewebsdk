object Form_dic_ItemCode: TForm_dic_ItemCode
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #39033#30446#32534#30721
  ClientHeight = 540
  ClientWidth = 989
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
  object LaNote: TLabel
    AlignWithMargins = True
    Left = 20
    Top = 503
    Width = 949
    Height = 34
    Margins.Left = 20
    Margins.Right = 20
    Align = alBottom
    AutoSize = False
    Caption = '<p><b>'#27880#65306'</b>100~200'#20026#20307#36136#20581#24247','#35831#23613#37327#19981#35201#20462#25913#65281#65281#65281' 200'#20197#19978#20026#20854#20182'</p>'
    Font.Charset = ANSI_CHARSET
    Font.Color = clGray
    Font.Height = -12
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
    ExplicitLeft = 15
    ExplicitTop = 506
  end
  object Pn1: TPanel
    Left = 0
    Top = 0
    Width = 989
    Height = 500
    Hint = 
      '{"account":"dwGMS","table":"dic_ItemCode","select":40,"import":1' +
      ',"visiblecol":1,"defaulteditmax":0,"defaultorder":"cCode","delet' +
      'ecols":[2],"fields":[{"name":"cId","view":2},{"name":"cName","ca' +
      'ption":"'#21517#31216'","sort":1,"must":1,"unique":1,"align":"center","width' +
      '":120},{"name":"cCode","caption":"'#32534#30721'","type":"int","sort":1,"mus' +
      't":1,"unique":1,"align":"center","width":80},{"name":"cUnit","ca' +
      'ption":"'#21333#20301'","type":"combo","align":"center","list":["","'#21400#31859'","'#20844#26020'"' +
      ',"'#27627#21319'","'#20998'.'#31186'","'#31186'","'#27425'"],"width":60,"query":1},{"name":"cDirection",' +
      '"caption":"'#26041#21521'","type":"combopair","sort":1,"query":1,"align":"ce' +
      'nter","list":[["0","'#27491#21521'"],["1","'#21453#21521'"]],"dbfilter":1,"width":80},{"' +
      'name":"cDefaultLocation","caption":"'#40664#35748#22330#22320'","sort":1,"align":"cent' +
      'er","type":"dbcombo","table":"dic_Location","datafield":"lName",' +
      '"width":100},{"name":"cMin","caption":"'#26368#23567#20540'","sort":1,"width":100' +
      ',"type":"float","align":"right"},{"name":"cMax","caption":"'#26368#22823#20540'",' +
      '"sort":1,"width":100,"type":"float","align":"right"},{"name":"cR' +
      'emark","caption":"'#22791#27880'","width":60}]}'
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Pn1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
  end
end
