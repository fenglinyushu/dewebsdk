object Form_bop_GetGroup: TForm_bop_GetGroup
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #23398#29983#32452#21035
  ClientHeight = 628
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
  object Pn1: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 0
    Width = 944
    Height = 628
    Hint = 
      '{"account":"dwGMS","table":"bop_TestRoster","export":1,"new":0,"' +
      'edit":0,"delete":0,"import":0,"switch":0,"oneline":1,"visiblecol' +
      '":1,"defaultorder":"rName","fields":[{"name":"rId","view":2},{"n' +
      'ame":"rName","caption":"'#22995#21517'","sort":1,"width":80,"align":"center"' +
      '},{"name":"rTestId","caption":"'#20998#32452#21517#31216'","sort":1,"dbfilter":1,"widt' +
      'h":140,"align":"center","type":"dbcombopair","table":"bop_Test",' +
      '"datafield":"tId","viewfield":"tName","viewdefault":""},{"name":' +
      '"rTestId as a1","caption":"'#27979#35797#22320#28857'","sort":1,"dbfilter":0,"width":1' +
      '40,"align":"center","type":"dbcombopair","table":"bop_Test","dat' +
      'afield":"tId","viewfield":"tLocation","viewdefault":""},{"name":' +
      '"rTestId as a2","caption":"'#36127#36131#20154'","sort":1,"dbfilter":0,"width":14' +
      '0,"align":"center","type":"dbcombopair","table":"bop_Test","data' +
      'field":"tId","viewfield":"tManager","viewdefault":""},{"name":"r' +
      'RegisterNum","caption":"'#23398#31821#21495'","view":3,"width":170,"align":"cente' +
      'r"},{"name":"rRemark","caption":"'#22791#27880'","width":40,"query":1}]}'
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Pn1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    ExplicitLeft = 544
    ExplicitWidth = 400
  end
end
