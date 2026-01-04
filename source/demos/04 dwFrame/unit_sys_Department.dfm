object Form_sys_Department: TForm_sys_Department
  Left = 0
  Top = 0
  HelpType = htKeyword
  HelpKeyword = 'embed'
  BorderStyle = bsNone
  Caption = 'Department'
  ClientHeight = 538
  ClientWidth = 947
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24605#28304#40657#20307' CN'
  Font.Style = []
  Position = poDesigned
  OnShow = FormShow
  TextHeight = 22
  object Pn1: TPanel
    AlignWithMargins = True
    Left = 584
    Top = 12
    Width = 360
    Height = 523
    Hint = 
      '{"account":"dwFrame","table":"sys_department","editwidth":4000,"' +
      'buttonattop":1,"fields":[{"name":"did","caption":"'#32534#21495'","align":"c' +
      'enter","width":60,"type":"auto"},{"name":"dname","caption":"'#21517#31216'",' +
      '"must":1,"width":200},{"name":"dcode","caption":"'#32534#30721'","readonly":' +
      '1,"view":2,"width":200},{"name":"dmanagerid","caption":"'#36127#36131#20154'","ty' +
      'pe":"dbcombopair","sort":1,"align":"center","table":"sys_user","' +
      'datafield":"uid","viewfield":"uname","viewdefault":"","width":20' +
      '0},{"name":"dphone","caption":"'#30005#35805'","width":200},{"name":"daddres' +
      's","caption":"'#22320#22336'","width":200},{"name":"dstatus","caption":"'#29366#24577'",' +
      '"type":"combo","align":"center","onlylist":1,"list":["'#27491#24120'","'#26242#20572'"],' +
      '"query":1,"width":200},{"name":"dcreatetime","caption":"'#21019#24314#26102#38388'","t' +
      'ype":"datetime","align":"center","width":200,"readonly":1},{"nam' +
      'e":"dremark","caption":"'#22791#27880'","type":"memo","fullheight":100,"widt' +
      'h":200}]}'
    Margins.Top = 12
    Align = alRight
    BevelKind = bkSoft
    BevelOuter = bvNone
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clGray
    Font.Height = -15
    Font.Name = #24605#28304#40657#20307' CN'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 2
    OnDragOver = Pn1DragOver
    ExplicitTop = 7
  end
  object PnL: TPanel
    Left = 0
    Top = 0
    Width = 581
    Height = 538
    HelpType = htKeyword
    Align = alClient
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 0
    object TV: TTreeView
      AlignWithMargins = True
      Left = 3
      Top = 73
      Width = 575
      Height = 372
      Hint = '{"lineheight":35,"selected":"#E6E6E6"}'
      Margins.Top = 12
      Align = alClient
      Indent = 19
      TabOrder = 0
      OnChange = TVChange
    end
    object PnTT: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 13
      Width = 575
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
      Font.Name = #24605#28304#40657#20307' CN'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
      object BtDAdd: TButton
        AlignWithMargins = True
        Left = 3
        Top = 7
        Width = 50
        Height = 30
        Hint = '{"type":"primary","radius":"4px 0 0 4px"}'
        Margins.Top = 7
        Margins.Right = 1
        Margins.Bottom = 4
        Align = alLeft
        Caption = 'New'
        TabOrder = 0
        OnClick = BtDAddClick
      end
      object BtDDelete: TButton
        AlignWithMargins = True
        Left = 105
        Top = 7
        Width = 50
        Height = 30
        Hint = '{"type":"primary","radius":"0 4px 4px 0"}'
        Margins.Left = 0
        Margins.Top = 7
        Margins.Right = 1
        Margins.Bottom = 4
        Align = alLeft
        Caption = 'Delete'
        TabOrder = 1
        OnClick = BtDDeleteClick
      end
      object BtDChild: TButton
        AlignWithMargins = True
        Left = 54
        Top = 7
        Width = 50
        Height = 30
        Hint = '{"type":"primary","radius":"0"}'
        Margins.Left = 0
        Margins.Top = 7
        Margins.Right = 1
        Margins.Bottom = 4
        Align = alLeft
        Caption = 'Child'
        TabOrder = 2
        OnClick = BtDChildClick
      end
      object BtMoveUp: TButton
        AlignWithMargins = True
        Left = 358
        Top = 7
        Width = 80
        Height = 30
        Hint = '{"type":"primary","radius":"4px 0 0 4px"}'
        Margins.Left = 0
        Margins.Top = 7
        Margins.Right = 1
        Margins.Bottom = 4
        Align = alRight
        Caption = 'MoveUp'
        TabOrder = 3
        OnClick = BtMoveUpClick
        ExplicitLeft = 378
      end
      object BtMoveDown: TButton
        AlignWithMargins = True
        Left = 490
        Top = 7
        Width = 80
        Height = 30
        Hint = '{"type":"primary","radius":"0 4px 4px 0"}'
        Margins.Left = 0
        Margins.Top = 7
        Margins.Right = 1
        Margins.Bottom = 4
        Align = alRight
        Caption = 'MoveDown'
        TabOrder = 4
        OnClick = BtMoveDownClick
        ExplicitLeft = 500
      end
      object BtEdit: TButton
        AlignWithMargins = True
        Left = 439
        Top = 7
        Width = 50
        Height = 30
        Hint = '{"type":"primary","radius":"0"}'
        Margins.Left = 0
        Margins.Top = 7
        Margins.Right = 1
        Margins.Bottom = 4
        Align = alRight
        Caption = 'Edit'
        TabOrder = 5
        OnClick = BtEditClick
        ExplicitLeft = 469
      end
    end
    object PnSimple: TPanel
      AlignWithMargins = True
      Left = 10
      Top = 458
      Width = 561
      Height = 70
      Hint = '{"dwstyle":"border-radius:5px;"}'
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      object LaSimple: TLabel
        AlignWithMargins = True
        Left = 10
        Top = 3
        Width = 541
        Height = 64
        Hint = '{"dwstyle":"line-height:22px;"}'
        Margins.Left = 10
        Margins.Right = 10
        Align = alClient
        AutoSize = False
        Caption = 'LaSimple'
        Font.Charset = ANSI_CHARSET
        Font.Color = 4473924
        Font.Height = -15
        Font.Name = #24605#28304#40657#20307' CN'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        ExplicitLeft = 0
        ExplicitTop = 464
        ExplicitWidth = 581
        ExplicitHeight = 74
      end
    end
  end
  object PnNew: TPanel
    Left = 392
    Top = 94
    Width = 360
    Height = 320
    HelpType = htKeyword
    HelpKeyword = 'ok'
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    Visible = False
    OnEnter = PnNewEnter
    object LaNewTitle: TLabel
      Left = 0
      Top = 0
      Width = 360
      Height = 50
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'New Department'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = #24605#28304#40657#20307' CN'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 318
    end
    object LaNewParent: TLabel
      AlignWithMargins = True
      Left = 30
      Top = 70
      Width = 300
      Height = 40
      Margins.Left = 30
      Margins.Top = 20
      Margins.Right = 30
      Margins.Bottom = 0
      Align = alTop
      AutoSize = False
      Caption = 'Parent Departmen'#65306
      Layout = tlCenter
      WordWrap = True
      ExplicitLeft = 20
      ExplicitTop = 73
      ExplicitWidth = 280
    end
    object LaNewName: TLabel
      AlignWithMargins = True
      Left = 30
      Top = 110
      Width = 300
      Height = 40
      Margins.Left = 30
      Margins.Top = 0
      Margins.Right = 30
      Margins.Bottom = 0
      Align = alTop
      AutoSize = False
      Caption = 'New Name'#65306
      Layout = tlCenter
      WordWrap = True
      ExplicitLeft = 20
      ExplicitTop = 250
      ExplicitWidth = 280
    end
    object EtNewName: TEdit
      AlignWithMargins = True
      Left = 30
      Top = 160
      Width = 300
      Height = 40
      Margins.Left = 30
      Margins.Top = 10
      Margins.Right = 30
      Align = alTop
      AutoSize = False
      TabOrder = 0
    end
  end
  object FDQuery1: TFDQuery
    Left = 280
    Top = 125
  end
end
