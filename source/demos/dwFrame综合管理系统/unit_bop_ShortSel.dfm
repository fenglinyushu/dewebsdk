object Form_bop_ShortSel: TForm_bop_ShortSel
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #31616#31572#39064#23457#36873
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
    Width = 989
    Height = 540
    Hint = 
      '{"account":"dwQBank","table":"bop_Question","select":40,"visible' +
      'col":1,"oneline":0,"export":1,"import":0,"new":0,"edit":1,"editc' +
      'aption":"'#26597#30475'","delete":0,"defaulteditmax":1,"where":"qType='#39#36873#25321#39064#39'"' +
      ',"defaultorder":"qCreateDateTime DESC","fields":[{"name":"qId","' +
      'caption":"'#32534#21495'","type":"auto","align":"center","width":50},{"name"' +
      ':"qCreatorId","caption":"'#22995#21517'","sort":1,"width":100,"dbfilter":1,"' +
      'readonly":1,"align":"center","type":"dbcombopair","table":"sys_U' +
      'ser","datafield":"uId","viewfield":"uName","viewdefault":""},{"n' +
      'ame":"qCreateDatetime","caption":"'#26102#38388'","type":"datetime","align":' +
      '"center","width":160,"sort":1,"view":2,"readonly":1,"default":0}' +
      ',{"name":"qStatus","caption":"'#29366#24577'","type":"combopair","readonly":' +
      '1,"sort":1,"dbfilter":1,"align":"center","list":[[0,""],[1,"'#36873'"]]' +
      ',"width":80,"renders":[{"data":"'#36873'","background":[223,240,216],"c' +
      'olor":[82,138,66]}]},{"name":"qTitle","caption":"'#39064#24178'","editwidth"' +
      ':720,"sort":1,"must":1,"readonly":1,"width":340},{"name":"qAnswe' +
      'r","caption":"'#31572#26696'","sort":1,"must":1,"readonly":1,"width":200,"he' +
      'ight":200,"type":"memo"},{"name":"qChapter","caption":"'#31456'","reado' +
      'nly":1,"sort":1,"must":1,"width":65,"type":"combo","align":"cent' +
      'er","dbfilter":1,"list":["'#19968'","'#20108'","'#19977'","'#22235'","'#20116'","'#20845'",""]},{"name":"q' +
      'Section","caption":"'#33410'","readonly":1,"sort":1,"must":1,"width":65' +
      ',"type":"combo","align":"center","dbfilter":1,"list":["1","2","3' +
      '","4","5","6","7","8","9"]},{"name":"qPageNo","caption":"'#39029#30721'","re' +
      'adonly":1,"sort":1,"must":1,"width":65,"type":"integer","align":' +
      '"center"},{"name":"qPosition","caption":"'#20301#32622'","readonly":1,"sort"' +
      ':1,"must":1,"width":65,"type":"combo","align":"center","list":["' +
      #39030#37096'","'#20013#19978#37096'","'#20013#37096'","'#20013#19979#37096'","'#24213#37096'"]},{"name":"qDifficulty","caption":"'#38590#24230'"' +
      ',"readonly":1,"sort":1,"must":1,"width":65,"type":"combo","align' +
      '":"center","list":["'#23481#26131'","'#20013#31561'","'#36739#38590'"]},{"name":"qMastery","caption"' +
      ':"'#30446#26631'","readonly":1,"sort":1,"must":1,"width":65,"type":"combo","' +
      'align":"center","list":["'#35782#35760'","'#29702#35299'","'#36816#29992'"]},{"name":"qRemark","read' +
      'only":1,"caption":"'#22791#27880'","sort":1},{"name":"qType","view":4,"defau' +
      'lt":"'#21028#26029#39064'"}]}'
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Pn1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object BtRemove: TButton
      Left = 831
      Top = 232
      Width = 70
      Height = 33
      Hint = '{"type":"primary","icon":"el-icon-remove-outline"}'
      Caption = #31227#38500
      TabOrder = 0
      OnClick = BtRemoveClick
    end
  end
  object BtSel: TButton
    Left = 728
    Top = 232
    Width = 70
    Height = 33
    Hint = '{"type":"primary","icon":"el-icon-circle-plus-outline"}'
    Caption = #36873#25321
    TabOrder = 1
    OnClick = BtSelClick
  end
end
