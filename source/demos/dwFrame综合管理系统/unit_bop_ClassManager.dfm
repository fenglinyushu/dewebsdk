object Form_bop_ClassManager: TForm_bop_ClassManager
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #29677#32423#36127#36131#20154
  ClientHeight = 540
  ClientWidth = 627
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OnShow = FormShow
  TextHeight = 20
  object Pn1: TPanel
    Left = 0
    Top = 0
    Width = 627
    Height = 540
    Hint = 
      '{"account":"dwGMS","table":"sys_Department","visiblecol":1,"defa' +
      'ultorder":"dNo","defaulteditmax":0,"new":0,"delete":0,"fields":[' +
      '{"name":"dNo","view":2},{"name":"dId","view":2},{"name":"dNumber' +
      '","caption":"'#29677#32423#32534#21495'","readonly":1,"align":"center","width":100},{"' +
      'name":"dName","caption":"'#29677#32423#21517#31216'","readonly":1,"align":"center","wi' +
      'dth":100},{"name":"dManager","caption":"'#36127#36131#20154'","align":"center","t' +
      'ype":"dbcombo","table":"sys_User","datafield":"uName","width":10' +
      '0},{"name":"dRemark","caption":"'#22791#27880'","width":80}]}'
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Pn1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
  end
end
