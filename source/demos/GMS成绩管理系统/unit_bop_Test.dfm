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
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 23
  object Pn1: TPanel
    Left = 0
    Top = 0
    Width = 596
    Height = 540
    Hint = 
      '{"account":"dwGMS","table":"bop_Test","defaulteditmax":0,"margin' +
      's":[0,10,13,10],"cardheight":180,"new":0,"edit":0,"delete":0,"to' +
      'talfirst":1,"mobile":1,"cardstyle":"border-radius:5px;background' +
      '-image: linear-gradient(to top, #f3e7e9 0%, #e3eeff 99%, #e3eeff' +
      ' 100%);","fields":[{"name":"tName","caption":"'#21517#31216'","sort":1,"left' +
      '":20,"top":10,"height":30,"right":10,"must":1,"font":{"size":20,' +
      '"color":[0,0,0]},"query":1},{"name":"tManagerId","caption":"'#36127#36131#20154'"' +
      ',"width":100,"type":"dbcombopair","table":"sys_User","datafield"' +
      ':"uId","viewfield":"uName","viewdefault":""},{"name":"tGender","' +
      'caption":"'#24615#21035'","type":"combo","list":["'#30007'","'#22899'"],"dbfilter":1,"righ' +
      't":10,"query":1},{"name":"tDate","caption":"'#26085#26399'","type":"date","w' +
      'idth":100,"sort":1},{"name":"tLocation","caption":"'#22320#28857'","right":1' +
      '0},{"name":"tStatus","caption":"'#29366#24577'","type":"combopair","dbfilter' +
      '":1,"list":[[0,"'#24453#24405#20837'"],[1,"'#24050#23436#25104'"]],"right":10,"query":1},{"name":"' +
      'tCount","caption":"'#20154#25968'","format":"'#29983#65292#20154#25968#65306'%s","top":70,"left":35,"so' +
      'rt":1,"right":10,"query":1},{"name":"tRemark","caption":"","type' +
      '":"button","dwattr":"type='#39'primary'#39' circle icon='#39'el-icon-edit-ou' +
      'tline'#39'","top":10,"right":17,"width":36,"height":36,"font":{"size' +
      '":15,"color":[255]},"query":1},{"name":"tId","view":2}]}'
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
    OnDragOver = Pn1DragOver
  end
end
