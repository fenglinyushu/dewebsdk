object Form_bop_ScoreEvery: TForm_bop_ScoreEvery
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #36880#27425#25104#32489
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
  object Pn1: TPanel
    Left = 0
    Top = 0
    Width = 989
    Height = 540
    Hint = 
      '{"account":"dwGMS","table":"bop_Score","select":40,"visiblecol":' +
      '1,"import":0,"export":1,"new":0,"oneline":1,"defaulteditmax":0,"' +
      'defaultorder":"sId DESC","deletecols":[2],"fields":[{"name":"sId' +
      '","caption":"id","align":"center","width":60,"sort":1,"type":"au' +
      'to"},{"name":"sStudentName","caption":"'#22995#21517'","sort":1,"view":3,"al' +
      'ign":"center","width":70},{"name":"sGradeNum","caption":"'#24180#32423'","so' +
      'rt":1,"view":3,"align":"center","dbfilter":1,"width":80},{"name"' +
      ':"sClassName","caption":"'#29677#32423#21517#31216'","sort":1,"view":3,"align":"center' +
      '","dbfilter":1,"width":130},{"name":"sStudentGender","caption":"' +
      #24615#21035'","type":"combo","dbfilter":1,"align":"center","list":["'#30007'","'#22899'"' +
      '],"sort":1,"view":3,"width":90,"query":1},{"name":"sStudentRegis' +
      'terNum","caption":"'#23398#31821#21495'","sort":1,"view":3,"align":"center","widt' +
      'h":180},{"name":"sTestDate","caption":"'#27979#35797#26102#38388'","type":"datetime","' +
      'align":"center","sort":1,"view":3,"width":160},{"name":"sItemNam' +
      'e","caption":"'#39033#30446'","sort":1,"view":3,"align":"center","dbfilter":' +
      '1,"width":100},{"name":"sTestName","caption":"'#27979#35797#21517#31216'","sort":1,"vi' +
      'ew":3,"dbfilter":1,"width":120},{"name":"sLocation","caption":"'#22320 +
      #28857'","sort":1,"view":3,"dbfilter":1,"width":100},{"name":"sManager' +
      '","caption":"'#36127#36131#20154'","sort":1,"view":3,"align":"center","dbfilter":' +
      '1,"width":100},{"name":"sOnsiteScore","caption":"'#25104#32489'","sort":1,"a' +
      'lign":"center","format":"field","formatdata":{"field":"sItemUnit' +
      '","list":[["%.2f"],["'#20998'.'#31186'","seconds"],["'#27425'","%d"],["'#27627#21319'","%d"],["'#21400#31859 +
      '","%.1f"],["'#20844#26020'","%.1f"]]},"width":70},{"name":"sItemUnit","capti' +
      'on":"'#21333#20301'","view":3,"align":"center","width":70},{"name":"sScore",' +
      '"caption":"'#24471#20998'","sort":1,"align":"center","width":70},{"name":"sR' +
      'emark","caption":"'#22791#27880'","width":60,"query":1}]}'
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Pn1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
  end
end
