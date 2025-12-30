object Form_bop_Score: TForm_bop_Score
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #27979#35797#25104#32489
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
  object Sl1: TSplitter
    Left = 680
    Top = 0
    Width = 8
    Height = 540
    Hint = '{"link":"pn1"}'
    ExplicitLeft = 200
    ExplicitTop = -8
  end
  object Pn1: TPanel
    Left = 0
    Top = 0
    Width = 680
    Height = 540
    Hint = 
      '{"account":"dwGMS","table":"bop_Score","select":40,"visiblecol":' +
      '1,"import":0,"export":1,"new":0,"oneline":1,"defaulteditmax":0,"' +
      'defaultorder":"sId DESC","deletecols":[2],"slave":[{"panel":"Pn2' +
      '","masterfield":"sStudentId","slavefield":"sStudentId"}],"fields' +
      '":[{"name":"sId","caption":"id","align":"center","width":60,"sor' +
      't":1,"type":"auto"},{"name":"sStudentName","caption":"'#22995#21517'","sort"' +
      ':1,"view":3,"align":"center","width":70},{"name":"sGradeNum","ca' +
      'ption":"'#24180#32423'","sort":1,"view":3,"align":"center","dbfilter":1,"wid' +
      'th":80},{"name":"sClassName","caption":"'#29677#32423#21517#31216'","sort":1,"view":3,' +
      '"align":"center","dbfilter":1,"width":130},{"name":"sStudentGend' +
      'er","caption":"'#24615#21035'","type":"combo","dbfilter":1,"align":"center",' +
      '"list":["'#30007'","'#22899'"],"sort":1,"view":3,"width":90,"query":1},{"name"' +
      ':"sStudentRegisterNum","caption":"'#23398#31821#21495'","sort":1,"view":3,"align"' +
      ':"center","width":180},{"name":"sStudentId","view":2},{"name":"s' +
      'TestDate","caption":"'#27979#35797#26102#38388'","view":2},{"name":"sItemName","captio' +
      'n":"'#39033#30446'","view":2},{"name":"sTestName","caption":"'#27979#35797#21517#31216'","view":2}' +
      ',{"name":"sLocation","caption":"'#22320#28857'","view":2},{"name":"sManager"' +
      ',"caption":"'#36127#36131#20154'","view":2},{"name":"sOnsiteScore","caption":"'#25104#32489'"' +
      ',"view":2},{"name":"sItemUnit","caption":"'#21333#20301'","view":2},{"name":' +
      '"sScore","caption":"'#24471#20998'","view":2},{"name":"sRemark","caption":"'#22791 +
      #27880'","view":2}]}'
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'Pn1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
  end
  object Pn2: TPanel
    Left = 688
    Top = 0
    Width = 301
    Height = 540
    Hint = 
      '{"account":"dwGMS","table":"bop_Score","visiblecol":1,"new":0,"o' +
      'neline":1,"prefix":"x","defaulteditmax":0,"defaultorder":"sTestD' +
      'ate DESC","master":{"panel":"Pn1","masterfield":"sStudentId","sl' +
      'avefield":"sStudentId"},"fields":[{"name":"sStudentId","view":2}' +
      ',{"name":"sTestDate","caption":"'#27979#35797#26102#38388'","type":"datetime","align":' +
      '"center","sort":1,"view":3,"width":160},{"name":"sItemName","cap' +
      'tion":"'#39033#30446'","sort":1,"view":3,"align":"center","dbfilter":1,"widt' +
      'h":100},{"name":"sTestName","caption":"'#27979#35797#21517#31216'","sort":1,"view":3,"' +
      'dbfilter":1,"width":120},{"name":"sLocation","caption":"'#22320#28857'","sor' +
      't":1,"view":3,"dbfilter":1,"width":100},{"name":"sManager","capt' +
      'ion":"'#36127#36131#20154'","sort":1,"view":3,"align":"center","dbfilter":1,"widt' +
      'h":100},{"name":"sOnsiteScore","caption":"'#25104#32489'","sort":1,"align":"' +
      'right","format":"field","formatdata":{"field":"sItemUnit","list"' +
      ':[["%.2f"],["'#20998'.'#31186'","seconds"],["'#27425'","%d"],["'#27627#21319'","%d"],["'#21400#31859'","%.1f"' +
      '],["'#20844#26020'","%.1f"]]},"type":"seconds","width":70},{"name":"sItemUni' +
      't","caption":"'#21333#20301'","view":3,"align":"center","width":70},{"name":' +
      '"sScore","caption":"'#24471#20998'","sort":1,"align":"right","width":70},{"n' +
      'ame":"sRemark","caption":"'#22791#27880'","width":60,"query":1}]}'
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Pn2'
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
  end
end
