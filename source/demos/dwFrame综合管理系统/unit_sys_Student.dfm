object Form_sys_Student: TForm_sys_Student
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
  OnEndDock = FormEndDock
  OnShow = FormShow
  TextHeight = 20
  object PnL: TPanel
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
      'col":2,"import":0,"export":0,"defaulteditmax":0,"fields":[{"name' +
      '":"sName","caption":"'#22995#21517'","query":1,"sort":1,"must":1,"width":80}' +
      ',{"name":"sRegisterNum","caption":"'#23398#31821#21495'","query":1,"sort":1,"alig' +
      'n":"center","width":180},{"name":"sEthnicity","type":"combopair"' +
      ',"caption":"'#27665#26063'","query":1,"sort":1,"dbfilter":1,"align":"center"' +
      ',"list":[[1,"'#27721#26063'"],[2,"'#33945#21476#26063'"],[3,"'#22238#26063'"],[4,"'#34255#26063'"],[5,"'#32500#21566#23572#26063'"],[6,"'#33495#26063'"' +
      '],[7,"'#24413#26063'"],[8,"'#22766#26063'"],[9,"'#24067#20381#26063'"],[10,"'#26397#40092#26063'"],[11,"'#28385#26063'"],[12,"'#20375#26063'"],[13' +
      ',"'#29814#26063'"],[14,"'#30333#26063'"],[15,"'#22303#23478#26063'"],[16,"'#21704#23612#26063'"],[17,"'#21704#33832#20811#26063'"],[18,"'#20643#26063'"],[19' +
      ',"'#40654#26063'"],[20,"'#20616#20723#26063'"],[21,"'#20324#26063'"],[22,"'#30066#26063'"],[23,"'#39640#23665#26063'"],[24,"'#25289#31068#26063'"],[25,' +
      '"'#27700#26063'"],[26,"'#19996#20065#26063'"],[27,"'#32435#35199#26063'"],[28,"'#26223#39047#26063'"],[29,"'#26607#23572#20811#23388#26063'"],[30,"'#22303#26063'"],[3' +
      '1,"'#36798#26017#23572#26063'"],[32,"'#20203#20332#26063'"],[33,"'#32652#26063'"],[34,"'#24067#26391#26063'"],[35,"'#25746#25289#26063'"],[36,"'#27611#21335#26063'"],' +
      '[37,"'#20193#20332#26063'"],[38,"'#38177#20271#26063'"],[39,"'#38463#26124#26063'"],[40,"'#26222#31859#26063'"],[41,"'#22612#21513#20811#26063'"],[42,"'#24594#26063'"' +
      '],[43,"'#20044#23388#21035#20811#26063'"],[44,"'#20420#32599#26031#26063'"],[45,"'#37122#28201#20811#26063'"],[46,"'#24503#26114#26063'"],[47,"'#20445#23433#26063'"],[48' +
      ',"'#35029#22266#26063'"],[49,"'#20140#26063'"],[50,"'#22612#22612#23572#26063'"],[51,"'#29420#40857#26063'"],[52,"'#37122#20262#26149#26063'"],[53,"'#36203#21746#26063'"],' +
      '[54,"'#38376#24052#26063'"],[55,"'#29662#24052#26063'"],[56,"'#22522#35834#26063'"],[57,"'#20854#20182'"],[81,"'#31359#38738#20154#26063'"],[58,"'#22806#22269#34880#32479 +
      '"]],"default":"'#27721#26063'","width":80},{"name":"sGender","type":"combopa' +
      'ir","caption":"'#24615#21035'","query":1,"sort":1,"dbfilter":1,"align":"cent' +
      'er","list":[[1,"'#30007'"],[2,"'#22899'"]],"width":80},{"name":"sBirthday","ca' +
      'ption":"'#20986#29983#26085#26399'","type":"date","sort":1,"width":100,"align":"center' +
      '"},{"name":"sAddress","caption":"'#23478#24237#20303#22336'","sort":1,"query":1,"width' +
      '":180},{"name":"sRemark","caption":"'#22791#27880'","query":1,"sort":1,"widt' +
      'h":80},{"name":"sId","view":2},{"name":"sGradeNum","view":2},{"n' +
      'ame":"sClassNum","view":2}]}'
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Pn1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    OnDragOver = Pn1DragOver
    object BtConv: TButton
      AlignWithMargins = True
      Left = 417
      Top = 195
      Width = 200
      Height = 33
      Hint = '{"type":"danger","icon":"el-icon-warning"}'
      Margins.Right = 10
      Caption = #37325#26032#23548#20837#29677#32423'/'#23398#29983#25968#25454
      TabOrder = 0
      OnClick = BtConvClick
    end
  end
  object PnConfirm: TPanel
    Left = 291
    Top = 100
    Width = 360
    Height = 220
    Hint = '{"radius":"10px"}'
    HelpType = htKeyword
    HelpKeyword = 'modal'
    Margins.Top = 30
    BevelKind = bkSoft
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    Visible = False
    object L_NewTitle: TLabel
      AlignWithMargins = True
      Left = 30
      Top = 30
      Width = 296
      Height = 89
      Margins.Left = 30
      Margins.Top = 30
      Margins.Right = 30
      Align = alTop
      AutoSize = False
      Caption = #37325#26032#23548#20837#29677#32423'/'#23398#29983#25968#25454#20250#28165#38500#21407#26377#30340#25968#25454#65292#19988#38656#35201#37319#29992#12298#22269#23478#23398#29983#20307#36136#20581#24247#26631#20934#25968#25454#31649#29702#19982#20998#26512#31995#32479#12299#23548#20986#30340'EXCEL'#25968#25454#65292#30830#23450#35201#36827#34892#21527#65311
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      WordWrap = True
      ExplicitTop = 40
    end
    object Panel2: TPanel
      Left = 0
      Top = 166
      Width = 356
      Height = 50
      Align = alBottom
      BevelOuter = bvNone
      Color = clNone
      ParentBackground = False
      TabOrder = 0
      object BtCancel: TButton
        Left = 0
        Top = 0
        Width = 180
        Height = 50
        Hint = '{"radius":"0px"}'
        Align = alLeft
        Caption = #21462#28040
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = BtCancelClick
      end
      object BtOK: TButton
        Left = 180
        Top = 0
        Width = 176
        Height = 50
        Hint = '{"radius":"0px","type":"primary"}'
        Align = alClient
        Caption = #30830#23450
        TabOrder = 1
        OnClick = BtOKClick
      end
    end
  end
  object FDQuery1: TFDQuery
    Left = 280
    Top = 125
  end
end
