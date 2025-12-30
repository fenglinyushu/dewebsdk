object Form_sys_Notice: TForm_sys_Notice
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #21457#24067#36890#30693
  ClientHeight = 540
  ClientWidth = 360
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
    Width = 360
    Height = 540
    Hint = 
      '{"table":"sys_Notice","defaultquerymode":1,"rowheight":40,"selec' +
      't":40,"defaultorder":"nDatetime DESC","fields":[{"name":"nId","c' +
      'aption":"'#32534#21495'","align":"center","width":60,"type":"auto"},{"name":' +
      '"nDateTime","caption":"'#26085#26399'","type":"datetime","align":"center","w' +
      'idth":160,"sort":1},{"name":"nCreatorId","caption":"'#21457#24067'","type":"' +
      'dbcombopair","sort":1,"view":3,"width":100,"align":"center","tab' +
      'le":"sys_User","datafield":"uId","viewfield":"uName","viewdefaul' +
      't":""},{"name":"nTitle","caption":"'#26631#39064'","sort":1,"align":"center"' +
      ',"width":200},{"name":"nMessage","caption":"'#20869#23481'","sort":1,"width"' +
      ':200}]}'
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Pn1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    OnDragOver = Pn1DragOver
  end
end
