object Form_sys_Department: TForm_sys_Department
  Left = 0
  Top = 0
  HelpType = htKeyword
  HelpKeyword = 'embed'
  Caption = #37096#38376#31649#29702
  ClientHeight = 499
  ClientWidth = 931
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnShow = FormShow
  TextHeight = 20
  object Pn1: TPanel
    AlignWithMargins = True
    Left = 412
    Top = 12
    Width = 516
    Height = 484
    Hint = 
      '{"account":"dwFrame","table":"sys_Department","editwidth":4000,"' +
      'buttonattop":1,"fields":[{"name":"dId","caption":"'#32534#21495'","align":"c' +
      'enter","width":60,"type":"auto"},{"name":"dName","caption":"'#21517#31216'",' +
      '"must":1,"width":300},{"name":"dNo","caption":"'#37096#38376#32534#30721'","readonly":' +
      '1,"view":2,"width":300},{"name":"dLeaderId","caption":"'#36127#36131#20154'","typ' +
      'e":"dbcombopair","sort":1,"align":"center","table":"sys_User","d' +
      'atafield":"uId","viewfield":"uName","viewdefault":"","width":300' +
      '},{"name":"dPhone","caption":"'#30005#35805'","width":300},{"name":"dEmail",' +
      '"caption":"'#37038#31665'","width":300},{"name":"dStatus","caption":"'#29366#24577'","ty' +
      'pe":"combo","align":"center","onlylist":1,"list":["'#27491#24120'","'#20851#20572'"],"qu' +
      'ery":1,"width":300},{"name":"dCreatorId","caption":"'#21019#24314#20154'","type":' +
      '"dbcombopair","readonly":1,"align":"center","table":"sys_User","' +
      'datafield":"uId","viewfield":"uName","viewdefault":"","width":30' +
      '0},{"name":"dCreateTime","caption":"'#21019#24314#26102#38388'","type":"datetime","ali' +
      'gn":"center","width":300,"readonly":1},{"name":"dRemark","captio' +
      'n":"'#22791#27880'","type":"memo","fullheight":100,"width":300}]}'
    Margins.Top = 12
    Align = alClient
    BevelKind = bkSoft
    BevelOuter = bvNone
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clGray
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 2
    OnDragOver = Pn1DragOver
  end
  object P_L: TPanel
    Left = 0
    Top = 0
    Width = 409
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
      Top = 73
      Width = 403
      Height = 423
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
    object PnTT: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 13
      Width = 403
      Height = 45
      Hint = 
        '{"account":"dwFrame","table":"dwDepartment","editwidth":4000,"fi' +
        'elds":[{"name":"dId","caption":"'#32534#21495'","align":"center","width":60,' +
        '"type":"auto"},{"name":"dName","caption":"'#21517#31216'","width":200},{"nam' +
        'e":"dNo","caption":"'#37096#38376#32534#30721'","readonly":1,"width":100},{"name":"dLe' +
        'aderId","caption":"'#36127#36131#20154'","type":"dbcombopair","sort":1,"align":"c' +
        'enter","table":"dwUser","datafield":"uId","viewfield":"uName","v' +
        'iewdefault":"","width":200},{"name":"dPhone","caption":"'#30005#35805'","wid' +
        'th":200},{"name":"dEmail","caption":"'#37038#31665'","width":200},{"name":"d' +
        'Status","caption":"'#29366#24577'","type":"combo","align":"center","list":["' +
        #27491#24120'","'#36716#38582#20013'","'#20851#20572'"],"query":1,"width":200},{"name":"dCreatorId","cap' +
        'tion":"'#21019#24314#20154'","type":"dbcombopair","sort":1,"align":"center","tabl' +
        'e":"dwUser","datafield":"uId","viewfield":"uName","viewdefault":' +
        '"","width":200},{"name":"dCreateTime","caption":"'#21019#24314#26102#38388'","type":"d' +
        'ate","align":"center","width":200,"sort":1},{"name":"dUpdatorId"' +
        ',"caption":"'#20462#35746#20154'","type":"dbcombopair","sort":1,"align":"center",' +
        '"table":"dwUser","datafield":"uId","viewfield":"uName","viewdefa' +
        'ult":"","width":200},{"name":"dUpdateTime","caption":"'#20462#35746#26102#38388'","typ' +
        'e":"date","align":"center","width":200,"sort":1},{"name":"dRemar' +
        'k","caption":"'#22791#27880'","width":200}]}'
      Margins.Top = 13
      Align = alTop
      BevelKind = bkSoft
      BevelOuter = bvNone
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
      object B_DAdd: TButton
        AlignWithMargins = True
        Left = 3
        Top = 7
        Width = 70
        Height = 30
        Hint = 
          '{"type":"primary","style":"plain","icon":"el-icon-circle-plus-ou' +
          'tline"}'
        Margins.Top = 7
        Margins.Right = 1
        Margins.Bottom = 4
        Align = alLeft
        Caption = #22686#21152
        TabOrder = 0
        OnClick = B_DAddClick
      end
      object B_DDelete: TButton
        AlignWithMargins = True
        Left = 175
        Top = 7
        Width = 79
        Height = 30
        Hint = '{"type":"primary","style":"plain","icon":"el-icon-delete"}'
        Margins.Left = 0
        Margins.Top = 7
        Margins.Right = 1
        Margins.Bottom = 4
        Align = alLeft
        Caption = #21024#38500
        TabOrder = 1
        OnClick = B_DDeleteClick
      end
      object B_DChild: TButton
        AlignWithMargins = True
        Left = 74
        Top = 7
        Width = 100
        Height = 30
        Hint = 
          '{"type":"primary","style":"plain","icon":"el-icon-circle-plus-ou' +
          'tline"}'
        Margins.Left = 0
        Margins.Top = 7
        Margins.Right = 1
        Margins.Bottom = 4
        Align = alLeft
        Caption = #26032#23376#37096#38376
        TabOrder = 2
        OnClick = B_DChildClick
      end
      object BtMoveUp: TButton
        AlignWithMargins = True
        Left = 255
        Top = 7
        Width = 70
        Height = 30
        Hint = '{"type":"primary","style":"plain","icon":"el-icon-top"}'
        Margins.Left = 0
        Margins.Top = 7
        Margins.Right = 1
        Margins.Bottom = 4
        Align = alLeft
        Caption = #19978#31227
        TabOrder = 3
        OnClick = BtMoveUpClick
      end
      object BtMoveDown: TButton
        AlignWithMargins = True
        Left = 326
        Top = 7
        Width = 70
        Height = 30
        Hint = '{"type":"primary","style":"plain","icon":"el-icon-bottom"}'
        Margins.Left = 0
        Margins.Top = 7
        Margins.Right = 1
        Margins.Bottom = 4
        Align = alLeft
        Caption = #19979#31227
        TabOrder = 4
        OnClick = BtMoveDownClick
      end
    end
  end
  object P_New: TPanel
    Left = 392
    Top = 100
    Width = 400
    Height = 320
    Hint = '{"radius":"10px"}'
    HelpType = htKeyword
    HelpKeyword = 'modal'
    BevelOuter = bvNone
    Caption = 'P_New'
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    Visible = False
    object L_NewTitle: TLabel
      Left = 0
      Top = 0
      Width = 400
      Height = 50
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #22686#21152#37096#38376
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 318
    end
    object L_NewParent: TLabel
      AlignWithMargins = True
      Left = 30
      Top = 70
      Width = 340
      Height = 40
      Margins.Left = 30
      Margins.Top = 20
      Margins.Right = 30
      Margins.Bottom = 0
      Align = alTop
      AutoSize = False
      Caption = #29238#32423#37096#38376#65306
      Layout = tlCenter
      WordWrap = True
      ExplicitLeft = 20
      ExplicitTop = 73
      ExplicitWidth = 280
    end
    object L_NewName: TLabel
      AlignWithMargins = True
      Left = 30
      Top = 110
      Width = 340
      Height = 40
      Margins.Left = 30
      Margins.Top = 0
      Margins.Right = 30
      Margins.Bottom = 0
      Align = alTop
      AutoSize = False
      Caption = #26032#37096#38376#21517#31216#65306
      Layout = tlCenter
      WordWrap = True
      ExplicitLeft = 20
      ExplicitTop = 250
      ExplicitWidth = 280
    end
    object Panel2: TPanel
      Left = 0
      Top = 270
      Width = 400
      Height = 50
      Align = alBottom
      BevelOuter = bvNone
      Color = clNone
      ParentBackground = False
      TabOrder = 0
      object B_DPCancel: TButton
        Left = 0
        Top = 0
        Width = 200
        Height = 50
        Hint = '{"radius":"0px"}'
        Align = alLeft
        Caption = #21462#28040
        TabOrder = 0
        OnClick = B_DPCancelClick
      end
      object B_DPOK: TButton
        Left = 200
        Top = 0
        Width = 200
        Height = 50
        Hint = '{"radius":"0px","type":"primary"}'
        Align = alClient
        Caption = #30830#23450
        TabOrder = 1
        OnClick = B_DPOKClick
      end
    end
    object E_NewName: TEdit
      AlignWithMargins = True
      Left = 30
      Top = 160
      Width = 340
      Height = 40
      Margins.Left = 30
      Margins.Top = 10
      Margins.Right = 30
      Align = alTop
      AutoSize = False
      TabOrder = 1
    end
  end
  object FDQuery1: TFDQuery
    Left = 280
    Top = 125
  end
end
