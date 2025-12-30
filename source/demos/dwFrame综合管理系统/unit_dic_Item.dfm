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
  object Sl1: TSplitter
    Left = 581
    Top = 0
    Width = 8
    Height = 540
    Hint = '{"link":"Pn2"}'
    Align = alRight
    ExplicitLeft = 586
  end
  object Pn1: TPanel
    Left = 0
    Top = 0
    Width = 581
    Height = 540
    Hint = 
      '{"account":"dwGMS","table":"dic_Item","select":40,"visiblecol":1' +
      ',"import":0,"export":0,"oneline":0,"defaulteditmax":0,"deletecol' +
      's":[1],"slave":[{"panel":"Pn2","masterfield":"iId","slavefield":' +
      '"sItemId"}],"fields":[{"name":"iId","view":2},{"name":"iGradeNum' +
      '","caption":"'#24180#32423'","type":"combopair","sort":1,"query":1,"must":1,' +
      '"align":"center","list":[["11","'#23567#23398#19968#24180#32423'"],["12","'#23567#23398#20108#24180#32423'"],["13","'#23567#23398 +
      #19977#24180#32423'"],["14","'#23567#23398#22235#24180#32423'"],["15","'#23567#23398#20116#24180#32423'"],["16","'#23567#23398#20845#24180#32423'"],["21","'#21021#20013#19968#24180#32423'"' +
      '],["22","'#21021#20013#20108#24180#32423'"],["23","'#21021#20013#19977#24180#32423'"],["31","'#39640#20013#19968#24180#32423'"],["32","'#39640#20013#20108#24180#32423'"],["' +
      '33","'#39640#20013#19977#24180#32423'"]],"dbfilter":1,"width":100},{"name":"iGender","capti' +
      'on":"'#24615#21035'","type":"combopair","sort":1,"query":1,"align":"center",' +
      '"list":[["1","'#30007'"],["2","'#22899'"]],"dbfilter":1,"width":80},{"name":"i' +
      'ItemCode","caption":"'#21517#31216'","type":"dbcombopair","sort":1,"query":1' +
      ',"must":1,"dbfilter":1,"align":"center","table":"dic_ItemCode","' +
      'datafield":"cCode","viewfield":"cName","viewdefault":"","width":' +
      '120},{"name":"iItemCode as dw","caption":"'#21333#20301'","view":3,"type":"d' +
      'bcombopair","sort":1,"query":1,"must":1,"dbfilter":1,"align":"ce' +
      'nter","table":"dic_ItemCode","datafield":"cCode","viewfield":"cU' +
      'nit","viewdefault":"","width":120},{"name":"iRemark","caption":"' +
      #22791#27880'","width":60}]}'
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Pn1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    OnDragOver = Pn1DragOver
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
      'efaultorder":"sValue DESC","deletecols":[1],"prefix":"x","master' +
      '":{"panel":"Pn1","masterfield":"iId","slavefield":"sItemId"},"fi' +
      'elds":[{"name":"sItemId","view":2},{"name":"sId","view":2},{"nam' +
      'e":"sValue","caption":"'#25104#32489'","sort":1,"must":1,"align":"center","w' +
      'idth":120},{"name":"sScore","caption":"'#24471#20998'","sort":1,"align":"cen' +
      'ter","width":100}]}'
    Align = alRight
    BevelOuter = bvNone
    Caption = 'Pn2'
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
  end
end
