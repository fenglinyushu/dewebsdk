object Form_bop_Star2: TForm_bop_Star2
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #26143#26143#31034#20363#20108
  ClientHeight = 671
  ClientWidth = 944
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
  object SlR: TSplitter
    Left = 434
    Top = 0
    Width = 10
    Height = 671
    Hint = '{"link":"PnS"}'
    Align = alRight
    ExplicitLeft = 333
    ExplicitHeight = 540
  end
  object Pn1: TPanel
    Left = 0
    Top = 0
    Width = 434
    Height = 671
    Hint = 
      '{"account":"dwGMS","table":"bop_Test","defaulteditmax":1,"select' +
      '":40,"visiblecol":1,"export":0,"import":0,"defaulteditmax":0,"de' +
      'letecols":[2,3],"slave":[{"panel":"PnS","masterfield":"tId","sla' +
      'vefield":"rTestId"}],"fields":[{"name":"tId","caption":"'#32534#21495'","ali' +
      'gn":"center","width":40,"type":"auto"},{"name":"tName","caption"' +
      ':"'#21517#31216'","query":1,"sort":1,"must":1,"width":140},{"name":"tDate","' +
      'caption":"'#26085#26399'","type":"date","width":120,"sort":1,"align":"center' +
      '","dbfilter":1,"query":1},{"name":"tManagerId","caption":"'#36127#36131#20154'","' +
      'sort":1,"width":100,"align":"center","type":"dbcombopair","table' +
      '":"sys_User","datafield":"uId","viewfield":"uName","viewdefault"' +
      ':""},{"name":"tLocation","type":"dbcombo","query":1,"caption":"'#22320 +
      #28857'","align":"center","width":160,"table":"dic_Location","datafiel' +
      'd":"lName","sort":1},{"name":"tGender","caption":"'#24615#21035'","type":"co' +
      'mbo","align":"center","dbfilter":1,"list":["'#30007'","'#22899'"],"sort":1,"wi' +
      'dth":80,"query":1},{"name":"tRemark","caption":"'#22791#27880'","sort":1,"wi' +
      'dth":80,"query":1}]}'
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Pn1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 534
    object Bt2: TButton
      Left = 100
      Top = 272
      Width = 60
      Height = 33
      Hint = '{"type":"success"}'
      Caption = #21151#33021'B'
      TabOrder = 0
    end
  end
  object Pn2: TPanel
    AlignWithMargins = True
    Left = 444
    Top = 0
    Width = 500
    Height = 671
    Hint = 
      '{"account":"dwGMS","table":"bop_TestRoster","export":0,"import":' +
      '0,"switch":0,"prefix":"x","visiblecol":1,"defaulteditmax":0,"sel' +
      'ect":40,"master":{"panel":"Pn1","masterfield":"tId","slavefield"' +
      ':"rTestId"},"fields":[{"name":"rId","view":2},{"name":"rTestId",' +
      '"view":2},{"name":"rName","caption":"'#22995#21517'","type":"dbcombo","sort"' +
      ':1,"width":80,"align":"center","table":"sys_Student","datafield"' +
      ':"sName"},{"name":"rRegisterNum","caption":"'#23398#31821#21495'","view":3,"width' +
      '":170,"align":"center"},{"name":"rRemark","caption":"'#22791#27880'","width"' +
      ':40,"query":1}]}'
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alRight
    BevelOuter = bvNone
    Caption = 'Pn2'
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    ExplicitLeft = 544
  end
  object Bt1: TButton
    Left = 100
    Top = 224
    Width = 60
    Height = 33
    Hint = '{"type":"primary"}'
    Caption = #21151#33021'A'
    TabOrder = 2
    OnClick = Bt1Click
  end
end
