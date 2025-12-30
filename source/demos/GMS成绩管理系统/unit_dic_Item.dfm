object Form_dic_Item: TForm_dic_Item
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #39033#30446#26631#20934
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
    Width = 589
    Height = 540
    Hint = 
      '{"account":"dwGMS","table":"dic_Item","select":40,"visiblecol":1' +
      ',"import":0,"export":0,"oneline":0,"defaulteditmax":0,"deletecol' +
      's":[1],"slave":[{"panel":"Pn2","masterfield":"iId","slavefield":' +
      '"sItemId"}],"fields":[{"name":"iId","view":2},{"name":"iGrade","' +
      'caption":"'#24180#32423'","type":"combo","sort":1,"query":1,"must":1,"align"' +
      ':"center","list":["'#23567#23398#19968#24180#32423'","'#23567#23398#20108#24180#32423'","'#23567#23398#19977#24180#32423'","'#23567#23398#22235#24180#32423'","'#23567#23398#20116#24180#32423'","'#23567#23398#20845#24180#32423 +
      '","'#21021#20013#19968#24180#32423'","'#21021#20013#20108#24180#32423'","'#21021#20013#19977#24180#32423'","'#39640#20013#19968#24180#32423'","'#39640#20013#20108#24180#32423'","'#39640#20013#19977#24180#32423'"],"dbfilter":1,' +
      '"width":100},{"name":"iGender","caption":"'#24615#21035'","type":"combo","so' +
      'rt":1,"query":1,"align":"center","list":["'#30007'","'#22899'"],"dbfilter":1,"' +
      'width":80},{"name":"iName","caption":"'#21517#31216'","sort":1,"query":1,"mu' +
      'st":1,"dbfilter":1,"align":"center","width":100},{"name":"iUnit"' +
      ',"caption":"'#21333#20301'","type":"combo","align":"center","list":["'#21400#31859'","'#20844#26020 +
      '","'#27627#21319'","'#20998#183#31186'","'#31186'","'#27425'"],"width":60,"query":1},{"name":"iTimes","ca' +
      'ption":"'#27425#25968'","type":"int","query":1,"min":1,"align":"center","def' +
      'ault":1,"width":60},{"name":"iRemark","caption":"'#22791#27880'","width":60}' +
      ']}'
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Pn1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object BtStd: TButton
      Left = 100
      Top = 272
      Width = 75
      Height = 33
      Hint = '{"icon":"el-icon-setting","type":"primary"}'
      Caption = #26631#20934
      TabOrder = 0
      OnClick = BtStdClick
    end
  end
  object Pn2: TPanel
    Left = 589
    Top = 0
    Width = 400
    Height = 540
    Hint = 
      '{"account":"dwGMS","table":"dic_ItemStandard","select":40,"visib' +
      'lecol":1,"oneline":0,"defaulteditmax":0,"import":1,"export":0,"d' +
      'eletecols":[1],"prefix":"x","master":{"panel":"Pn1","masterfield' +
      '":"iId","slavefield":"sItemId"},"fields":[{"name":"sItemId","vie' +
      'w":2},{"name":"sId","view":2},{"name":"sValue","caption":"'#27979#35797#25968#25454'",' +
      '"sort":1,"must":1,"align":"center","width":180},{"name":"sScore"' +
      ',"caption":"'#20998#25968'","sort":1,"align":"center","width":100}]}'
    Align = alRight
    BevelOuter = bvNone
    Caption = 'Pn2'
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
  end
end
