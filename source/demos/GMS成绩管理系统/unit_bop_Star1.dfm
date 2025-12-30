object Form_bop_Star1: TForm_bop_Star1
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #26143#26143#31034#20363#19968
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
    Left = 534
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
    Width = 534
    Height = 671
    Hint = 
      '{"account":"dwGMS","table":"bop_Test","defaulteditmax":1,"select' +
      '":40,"visiblecol":1,"export":0,"import":0,"defaulteditmax":0,"de' +
      'letecols":[2,3],"fields":[{"name":"tId","caption":"'#32534#21495'","align":"' +
      'center","width":40,"type":"auto"},{"name":"tName","caption":"'#21517#31216'"' +
      ',"query":1,"sort":1,"must":1,"width":140},{"name":"tDate","capti' +
      'on":"'#26085#26399'","type":"date","width":120,"sort":1,"align":"center","db' +
      'filter":1,"query":1},{"name":"tManagerId","caption":"'#36127#36131#20154'","sort"' +
      ':1,"width":100,"align":"center","type":"dbcombopair","table":"sy' +
      's_User","datafield":"uId","viewfield":"uName","viewdefault":""},' +
      '{"name":"tLocation","type":"dbcombo","query":1,"caption":"'#22320#28857'","a' +
      'lign":"center","width":160,"table":"dic_Location","datafield":"l' +
      'Name","sort":1},{"name":"tGender","caption":"'#24615#21035'","type":"combo",' +
      '"align":"center","dbfilter":1,"list":["'#30007'","'#22899'"],"sort":1,"width":' +
      '80,"query":1},{"name":"tRemark","caption":"'#22791#27880'","sort":1,"width":' +
      '80,"query":1}]}'
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Pn1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object Bt2: TButton
      Left = 100
      Top = 272
      Width = 75
      Height = 33
      Hint = '{"type":"success"}'
      Caption = #21151#33021#20108
      TabOrder = 0
    end
    object Bt3: TButton
      Left = 100
      Top = 320
      Width = 75
      Height = 33
      Hint = '{"type":"info"}'
      Caption = #21151#33021#19977
      TabOrder = 1
    end
    object Bt4: TButton
      Left = 100
      Top = 368
      Width = 75
      Height = 33
      Hint = '{"type":"info"}'
      Caption = #21151#33021#22235
      TabOrder = 2
    end
  end
  object Pn2: TPanel
    AlignWithMargins = True
    Left = 544
    Top = 0
    Width = 400
    Height = 671
    Hint = 
      '{"account":"dwGMS","table":"bop_TestRoster","export":0,"import":' +
      '0,"switch":0,"prefix":"x","visiblecol":1,"defaulteditmax":0,"sel' +
      'ect":40,"fields":[{"name":"rId","view":2},{"name":"rTestId","vie' +
      'w":2},{"name":"rName","caption":"'#22995#21517'","type":"dbcombo","sort":1,"' +
      'width":80,"align":"center","table":"sys_Student","datafield":"sN' +
      'ame"},{"name":"rRegisterNum","caption":"'#23398#31821#21495'","view":3,"width":17' +
      '0,"align":"center"},{"name":"rRemark","caption":"'#22791#27880'","width":40,' +
      '"query":1}]}'
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
  end
  object Bt1: TButton
    Left = 100
    Top = 224
    Width = 75
    Height = 33
    Hint = '{"type":"primary"}'
    Caption = #21151#33021#19968
    TabOrder = 2
    OnClick = Bt1Click
  end
end
