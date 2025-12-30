object Form_sys_ClassStudent: TForm_sys_ClassStudent
  Left = 0
  Top = 0
  HelpType = htKeyword
  HelpKeyword = 'embed'
  Caption = #23398#29983#31649#29702
  ClientHeight = 499
  ClientWidth = 931
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  StyleName = 
    '{"table":"dwUser","margin":0,"radius":0,"border":0,"print":0,"pa' +
    'gesize":10,"defaultquerymode":1,"rowheight":40,"fields":[{"name"' +
    ':"uName","caption":"'#29992#25143#21517'","query":1,"sort":1,"width":100},{"name"' +
    ':"uRealName","caption":"'#22995#21517'","query":1,"sort":1,"width":100},{"na' +
    'me":"uSex","type":"boolean","caption":"'#24615#21035'","query":1,"sort":1,"l' +
    'ist":["'#22899'","'#30007'"],"width":80},{"name":"uAge","type":"integer","capt' +
    'ion":"'#24180#40836'","query":1,"sort":1,"max":65,"min":22,"width":80},{"nam' +
    'e":"uDepartment","caption":"'#37096#38376'","type":"combopair","width":0,"li' +
    'st":[]},{"name":"uPhone","caption":"'#30005#35805'","sort":1,"query":1,"widt' +
    'h":180},{"name":"uRemark","caption":"'#22791#27880'","query":1,"sort":1,"wid' +
    'th":100}]}'
  OnShow = FormShow
  TextHeight = 20
  object P_L: TPanel
    Left = 0
    Top = 0
    Width = 240
    Height = 499
    HelpType = htKeyword
    HelpKeyword = 'simple'
    Align = alLeft
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 0
    object TV: TTreeView
      AlignWithMargins = True
      Left = 3
      Top = 12
      Width = 234
      Height = 484
      Hint = 
        '{"lineheight":40,"selected":"#E6E6E6","dwstyle":"border-right:so' +
        'lid 1px #f0f0f0;"}'
      Margins.Top = 12
      Align = alClient
      Indent = 19
      TabOrder = 0
      OnChange = TVChange
      Items.NodeData = {
        070100000009540054007200650065004E006F00640065002300000000000000
        00000000FFFFFFFFFFFFFFFF0000000000000000000200000001026851E89000
        00290000000000000000000000FFFFFFFFFFFFFFFF0000000000000000000400
        000001057F89895B3B606C51F8530000250000000000000000000000FFFFFFFF
        FFFFFFFF0000000000000000000000000001031478D153E89000002500000000
        00000000000000FFFFFFFFFFFFFFFF0000000000000000000000000001030095
        2E55E8900000250000000000000000000000FFFFFFFFFFFFFFFF000000000000
        000000000000000103228DA152E8900000250000000000000000000000FFFFFF
        FFFFFFFFFF000000000000000000000000000103025E3A57E890000029000000
        0000000000000000FFFFFFFFFFFFFFFF00000000000000000002000000010517
        53AC4E06526C51F8530000250000000000000000000000FFFFFFFFFFFFFFFF00
        000000000000000000000000010300952E55E890000029000000000000000000
        0000FFFFFFFFFFFFFFFF0000000000000000000000000001052E550E540D67A1
        52E890}
    end
  end
  object Pn1: TPanel
    Left = 240
    Top = 0
    Width = 691
    Height = 499
    Hint = 
      '{"table":"sys_Student","defaultquerymode":1,"select":40,"visible' +
      'col":2,"import":1,"export":1,"oneline":1,"defaulteditmax":0,"fie' +
      'lds":[{"name":"sName","caption":"'#22995#21517'","query":1,"sort":1,"must":1' +
      ',"width":100},{"name":"sRegisterNum","caption":"'#23398#31821#21495'","query":1,"' +
      'sort":1,"align":"center","width":200},{"name":"sEthnicity","type' +
      '":"combo","caption":"'#27665#26063'","query":1,"sort":1,"dbfilter":1,"align"' +
      ':"center","list":["'#27721#26063'","'#33945#26063'","'#22238#26063'","'#34255#26063'","'#32500#21566#23572#26063'","'#33495#26063'","'#24413#26063'","'#22766#26063'","'#24067#20381#26063 +
      '","'#26397#40092#26063'","'#28385#26063'","'#20375#26063'","'#29814#26063'","'#30333#26063'","'#22303#23478#26063'","'#21704#23612#26063'","'#21704#33832#20811#26063'","'#20643#26063'","'#40654#26063'","'#20616#20723#26063'","' +
      #20324#26063'","'#30066#26063'","'#39640#23665#26063'","'#25289#31068#26063'","'#27700#26063'","'#19996#20065#26063'","'#32435#35199#26063'","'#26223#39047#26063'","'#26607#23572#20811#23388#26063'","'#22303#26063'","'#36798#26017#23572#26063'",' +
      '"'#20203#20332#26063'","'#32652#26063'","'#24067#26391#26063'","'#25746#25289#26063'","'#27611#21335#26063'","'#20193#20332#26063'","'#38177#20271#26063'","'#38463#26124#26063'","'#26222#31859#26063'","'#22612#21513#20811#26063'","'#24594#26063'"' +
      ',"'#20044#23388#21035#20811#26063'","'#20420#32599#26031#26063'","'#37122#28201#20811#26063'","'#24503#26114#26063'","'#20445#23433#26063'","'#35029#22266#26063'","'#20140#26063'","'#22612#22612#23572#26063'","'#29420#40857#26063'","'#37122#20262#26149#26063 +
      '","'#36203#21746#26063'","'#38376#24052#26063'","'#29662#24052#26063'"],"default":"'#27721#26063'","width":80},{"name":"sGender' +
      '","type":"combo","caption":"'#24615#21035'","query":1,"sort":1,"align":"cent' +
      'er","list":["'#30007'","'#22899'"],"width":80},{"name":"sBirthday","caption":"' +
      #20986#29983#26085#26399'","type":"date","sort":1,"width":100,"align":"center"},{"nam' +
      'e":"sSource","caption":"'#23398#29983#26469#28304'","sort":1,"query":1,"width":120},{"' +
      'name":"sRemark","caption":"'#22791#27880'","query":1,"sort":1,"width":80},{"' +
      'name":"sGradeNum","view":2},{"name":"sClassNum","view":2}]}'
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Pn1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    OnDragOver = Pn1DragOver
  end
  object FDQuery1: TFDQuery
    Left = 280
    Top = 125
  end
end
