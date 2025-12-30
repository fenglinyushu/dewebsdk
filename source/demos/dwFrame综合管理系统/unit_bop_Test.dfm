object Form_bop_Test: TForm_bop_Test
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #20307#36136#27979#35797
  ClientHeight = 540
  ClientWidth = 596
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
    Width = 596
    Height = 540
    Hint = 
      '{"account":"dwGMS","table":"bop_Test","defaulteditmax":0,"defaul' +
      'tquerymode":1,"margins":[10,10,13,10],"cardheight":270,"cardwidt' +
      'h":300,"new":0,"edit":0,"delete":0,"totalfirst":1,"mobile":1,"ca' +
      'rdstyle":"border-radius:5px;background-image: linear-gradient(to' +
      ' top, #f3e7e9 0%, #e3eeff 99%, #e3eeff 100%);","fields":[{"name"' +
      ':"tName","caption":"'#21517#31216'","sort":1,"left":20,"top":10,"height":30,' +
      '"right":10,"must":1,"font":{"size":17,"color":[64,64,64]},"query' +
      '":1},{"name":"tManager","caption":"'#36127#36131#20154'","width":100,"top":70},{"' +
      'name":"tGender","caption":"'#24615#21035'","type":"combo","list":["'#30007'","'#22899'"],"' +
      'dbfilter":1,"right":10,"query":1},{"name":"tDate","caption":"'#26085#26399'"' +
      ',"type":"date","width":100,"sort":1},{"name":"tStatus","caption"' +
      ':"'#29366#24577'","type":"combopair","dbfilter":1,"top":120,"left":140,"list' +
      '":[[0,"'#24320#25918'"],[1,"'#20851#38381'"]],"right":10,"query":1},{"name":"tItemName",' +
      '"caption":"'#39033#30446'","dbfilter":1,"right":10},{"name":"tLocation","cap' +
      'tion":"'#22320#28857'","dbfilter":1,"right":10},{"name":"tFinished","caption' +
      '":"'#23436#25104#20154#25968'","format":"'#29983#65292#20154#25968#65306'%s / ","top":95,"left":38,"sort":1,"righ' +
      't":10,"query":1},{"name":"tCount","caption":"'#20154#25968'","format":"%s","' +
      'top":95,"left":144,"sort":1,"right":10,"query":1},{"name":"tRost' +
      'er","caption":"'#21015#34920'","sort":1,"wrap":1,"top":195,"height":60,"left' +
      '":20,"right":20,"query":1,"font":{"size":11,"color":[64,64,64]}}' +
      ',{"name":"tId","view":2},{"name":"tItemUnit","view":2},{"name":"' +
      'tGradeNum","view":2},{"name":"tClassNum","view":2}]}'
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Pn1'
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clGray
    Font.Height = -17
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    OnDblClick = Pn1DblClick
  end
end
