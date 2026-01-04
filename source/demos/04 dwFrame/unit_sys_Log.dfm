object Form_sys_Log: TForm_sys_Log
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #31995#32479#26085#24535
  ClientHeight = 540
  ClientWidth = 627
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
    Width = 627
    Height = 540
    Hint = 
      '{"account":"dwFrame","table":"sys_log","select":40,"visiblecol":' +
      '1,"deletecols":[2,1],"defaultorder":"lid DESC","fields":[{"name"' +
      ':"lid","caption":"'#32534#21495'","align":"center","width":60},{"name":"lmod' +
      'e","caption":"'#25805#20316'","sort":1,"dbfilter":1,"query":1,"width":180},{' +
      '"name":"lusername","caption":"'#29992#25143#21517'","sort":1,"align":"center","db' +
      'filter":1,"query":1,"width":100},{"name":"ldate","caption":"'#26085#26399'",' +
      '"align":"center","type":"datetime","align":"center","width":160,' +
      '"sort":1},{"name":"lcanvasid","caption":"'#35774#22791#26631#35782'","sort":1,"dbfilte' +
      'r":1,"align":"center","query":1,"width":280},{"name":"lremark","' +
      'caption":"'#22791#27880'","sort":1,"width":80,"query":1}]}'
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Pn1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
  end
end
