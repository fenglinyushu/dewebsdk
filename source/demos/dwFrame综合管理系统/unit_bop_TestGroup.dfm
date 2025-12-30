object Form_bop_TestGroup: TForm_bop_TestGroup
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #20307#27979#20998#32452
  ClientHeight = 628
  ClientWidth = 944
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 23
  object SlR: TSplitter
    Left = 534
    Top = 0
    Width = 10
    Height = 628
    Hint = '{"link":"PnS"}'
    Align = alRight
    ExplicitLeft = 333
    ExplicitHeight = 540
  end
  object Pn1: TPanel
    Left = 0
    Top = 0
    Width = 534
    Height = 628
    Hint = 
      '{"account":"dwGMS","table":"bop_Test","defaulteditmax":1,"select' +
      '":40,"visiblecol":1,"export":0,"import":0,"defaulteditmax":0,"de' +
      'letecols":[2,3],"slave":[{"panel":"PnS","masterfield":"tId","sla' +
      'vefield":"rTestId"}],"fields":[{"name":"tId","caption":"'#32534#21495'","ali' +
      'gn":"center","width":60,"type":"auto"},{"name":"tName","caption"' +
      ':"'#21517#31216'","query":1,"sort":1,"must":1,"width":220},{"name":"tStatus"' +
      ',"caption":"'#29366#24577'","type":"combopair","align":"center","dbfilter":1' +
      ',"list":[["0","'#24320#25918'"],["1","'#20851#38381'"]],"sort":1,"width":80,"query":1},{' +
      '"name":"tDate","caption":"'#26085#26399'","type":"datetime","width":160,"sor' +
      't":1,"align":"center","dbfilter":1,"query":1},{"name":"tManager"' +
      ',"caption":"'#36127#36131#20154'","sort":1,"width":100,"dbfilter":1,"align":"cent' +
      'er"},{"name":"tItemName","caption":"'#39033#30446'","sort":1,"width":100,"db' +
      'filter":1,"align":"center"},{"name":"tLocation","type":"dbcombo"' +
      ',"query":1,"caption":"'#22320#28857'","align":"center","width":160,"dbfilter' +
      '":1,"table":"dic_Location","datafield":"lName","sort":1},{"name"' +
      ':"tGender","caption":"","type":"combo","align":"center","dbfilte' +
      'r":1,"list":["'#30007'","'#22899'"],"sort":1,"width":50,"query":1},{"name":"tR' +
      'emark","caption":"'#22791#27880'","sort":1,"width":80,"query":1},{"name":"tM' +
      'anagerid","view":2}]}'
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Pn1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object BtMember: TButton
      Left = 100
      Top = 272
      Width = 45
      Height = 33
      Hint = '{"type":"success"}'
      Caption = #23398#29983
      TabOrder = 0
      OnClick = BtMemberClick
    end
    object BtBat: TButton
      Left = 100
      Top = 324
      Width = 45
      Height = 33
      Hint = '{"type":"info"}'
      Caption = #25209#37327
      TabOrder = 1
      OnClick = BtBatClick
    end
    object BtClose: TButton
      Left = 100
      Top = 369
      Width = 45
      Height = 33
      Hint = '{"type":"warning"}'
      Caption = #29366#24577
      TabOrder = 2
      OnClick = BtCloseClick
    end
  end
  object PnS: TPanel
    AlignWithMargins = True
    Left = 544
    Top = 0
    Width = 400
    Height = 628
    Hint = 
      '{"account":"dwGMS","table":"bop_TestRoster","export":0,"import":' +
      '0,"switch":0,"prefix":"x","visiblecol":1,"defaulteditmax":0,"sel' +
      'ect":40,"master":{"panel":"Pn1","masterfield":"tId","slavefield"' +
      ':"rTestId"},"fields":[{"name":"rId","view":2},{"name":"rTestId",' +
      '"view":2},{"name":"rName","caption":"'#22995#21517'","type":"dbcombo","sort"' +
      ':1,"width":80,"align":"center","table":"sys_Student","datafield"' +
      ':"sName"},{"name":"rRegisterNum","caption":"'#23398#31821#21495'","view":3,"width' +
      '":170,"align":"center"},{"name":"rRemark","caption":"'#22791#27880'","width"' +
      ':40,"query":1}]}'
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alRight
    BevelOuter = bvNone
    Caption = 'PnS'
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
  end
  object BtGroup: TButton
    Left = 100
    Top = 224
    Width = 45
    Height = 33
    Hint = '{"type":"primary"}'
    Caption = #20998#32452
    TabOrder = 2
    OnClick = BtGroupClick
  end
  object PnBat: TPanel
    Left = 347
    Top = 108
    Width = 360
    Height = 260
    HelpType = htKeyword
    HelpKeyword = 'ok'
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'PnBat'
    Color = clWhite
    ParentBackground = False
    TabOrder = 4
    Visible = False
    OnEnter = PnBatEnter
    object Panel2: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 30
      Width = 350
      Height = 42
      Margins.Top = 30
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      object Label2: TLabel
        AlignWithMargins = True
        Left = 30
        Top = 10
        Width = 60
        Height = 29
        Margins.Left = 30
        Margins.Top = 10
        Align = alLeft
        Alignment = taRightJustify
        AutoSize = False
        Caption = #36127#36131#20154#65306
        Layout = tlCenter
        ExplicitTop = 3
        ExplicitHeight = 44
      end
      object CbManager: TComboBox
        AlignWithMargins = True
        Left = 96
        Top = 10
        Width = 200
        Height = 28
        Hint = '{"height":30}'
        Margins.Top = 10
        Align = alLeft
        Style = csDropDownList
        TabOrder = 0
      end
    end
    object Panel1: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 75
      Width = 350
      Height = 42
      Align = alTop
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
      object Label1: TLabel
        AlignWithMargins = True
        Left = 30
        Top = 10
        Width = 60
        Height = 29
        Margins.Left = 30
        Margins.Top = 10
        Align = alLeft
        Alignment = taRightJustify
        AutoSize = False
        Caption = #22320#28857#65306
        Layout = tlCenter
        ExplicitTop = 3
        ExplicitHeight = 44
      end
      object CbLocation: TComboBox
        AlignWithMargins = True
        Left = 96
        Top = 10
        Width = 200
        Height = 28
        Hint = '{"height":30}'
        Margins.Top = 10
        Align = alLeft
        Style = csDropDownList
        TabOrder = 0
      end
    end
    object Panel3: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 120
      Width = 350
      Height = 50
      Margins.Top = 0
      Align = alTop
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
      object Label3: TLabel
        AlignWithMargins = True
        Left = 30
        Top = 3
        Width = 60
        Height = 44
        Margins.Left = 30
        Align = alLeft
        Alignment = taRightJustify
        AutoSize = False
        Caption = #22791#27880#65306
        Layout = tlCenter
      end
      object EtRemark: TEdit
        AlignWithMargins = True
        Left = 96
        Top = 10
        Width = 200
        Height = 30
        Margins.Top = 10
        Margins.Bottom = 10
        Align = alLeft
        TabOrder = 0
        ExplicitHeight = 28
      end
    end
  end
  object PnStatus: TPanel
    Left = 342
    Top = 146
    Width = 360
    Height = 260
    HelpType = htKeyword
    HelpKeyword = 'ok'
    BevelKind = bkFlat
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 5
    Visible = False
    OnEnter = PnStatusEnter
    object LaStatus: TLabel
      AlignWithMargins = True
      Left = 30
      Top = 30
      Width = 296
      Height = 60
      Margins.Left = 30
      Margins.Top = 30
      Margins.Right = 30
      Align = alTop
      AutoSize = False
      Caption = #30830#23450#35201#23558#24403#21069#27979#35797#29366#24577#32622#20026#20197#19979#29366#24577#21527'?'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -17
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitLeft = 6
      ExplicitTop = 5
      ExplicitWidth = 323
    end
    object CbStatus: TComboBox
      AlignWithMargins = True
      Left = 30
      Top = 103
      Width = 126
      Height = 31
      Hint = '{"height":30}'
      Margins.Left = 30
      Margins.Top = 10
      Margins.Right = 200
      Align = alTop
      Style = csDropDownList
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -17
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ItemIndex = 1
      ParentFont = False
      TabOrder = 0
      Text = #20851#38381
      Items.Strings = (
        #24320#25918
        #20851#38381)
    end
  end
  object PnAuto: TPanel
    Left = 408
    Top = 70
    Width = 513
    Height = 540
    HelpType = htKeyword
    HelpKeyword = 'ok'
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'PnAuto'
    Color = clWhite
    ParentBackground = False
    TabOrder = 3
    Visible = False
    OnEnter = PnAutoEnter
    OnExit = PnAutoExit
    object LaAuto: TLabel
      Left = 0
      Top = 0
      Width = 509
      Height = 40
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #33258#21160#20998#32452
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -20
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      Layout = tlCenter
      ExplicitWidth = 356
    end
    object PnItem: TPanel
      Left = 0
      Top = 40
      Width = 509
      Height = 50
      Align = alTop
      BevelOuter = bvNone
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      ExplicitWidth = 416
      object LaItem: TLabel
        AlignWithMargins = True
        Left = 10
        Top = 3
        Width = 45
        Height = 44
        Margins.Left = 10
        Margins.Right = 0
        Align = alLeft
        AutoSize = False
        Caption = #39033#30446#65306
        Layout = tlCenter
      end
      object CbItem: TComboBox
        AlignWithMargins = True
        Left = 55
        Top = 10
        Width = 138
        Height = 28
        Hint = '{"height":30}'
        Margins.Left = 0
        Margins.Top = 10
        Align = alLeft
        Style = csDropDownList
        TabOrder = 0
      end
      object CbGender: TComboBox
        AlignWithMargins = True
        Left = 199
        Top = 10
        Width = 78
        Height = 28
        Hint = '{"height":30}'
        Margins.Top = 10
        Margins.Bottom = 10
        Align = alLeft
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 1
        Text = #20840#37096
        Items.Strings = (
          #20840#37096
          #30007
          #22899)
      end
      object SECount: TSpinEdit
        AlignWithMargins = True
        Left = 283
        Top = 10
        Width = 55
        Height = 30
        Hint = '{"dwstyle":"border:solid 1px #ddd;border-radius:2px;"}'
        Margins.Top = 10
        Margins.Bottom = 10
        Align = alLeft
        MaxValue = 1000
        MinValue = 1
        TabOrder = 2
        Value = 10
      end
      object SEFirst: TSpinEdit
        AlignWithMargins = True
        Left = 344
        Top = 10
        Width = 55
        Height = 30
        Hint = '{"dwstyle":"border:solid 1px #ddd;border-radius:2px;"}'
        Margins.Top = 10
        Margins.Bottom = 10
        Align = alLeft
        MaxValue = 1000
        MinValue = 1
        TabOrder = 3
        Value = 1
      end
      object EtGRemark: TEdit
        AlignWithMargins = True
        Left = 405
        Top = 10
        Width = 94
        Height = 30
        Hint = '{"placeholder":"'#22791#27880'"}'
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alClient
        TabOrder = 4
        ExplicitLeft = 416
        ExplicitTop = 16
        ExplicitWidth = 121
        ExplicitHeight = 28
      end
    end
    object PnClass: TPanel
      AlignWithMargins = True
      Left = 0
      Top = 90
      Width = 509
      Height = 394
      Hint = 
        '{"table":"(select dGradeNum,dNumber,dName,dManager FROM sys_Depa' +
        'rtment where LEN(dNumber)>=6) as dclass","pagesize":200,"select"' +
        ':40,"buttons":0,"defaultquerymode":0,"prefix":"y","border":0,"vi' +
        'siblecol":1,"fields":[{"name":"dGradeNum","caption":"'#24180#32423'","align"' +
        ':"center","dbfilter":1,"type":"combopair","list":[["11","'#23567#23398#19968#24180#32423'"]' +
        ',["12","'#23567#23398#20108#24180#32423'"],["13","'#23567#23398#19977#24180#32423'"],["14","'#23567#23398#22235#24180#32423'"],["15","'#23567#23398#20116#24180#32423'"],["1' +
        '6","'#23567#23398#20845#24180#32423'"],["21","'#21021#20013#19968#24180#32423'"],["22","'#21021#20013#20108#24180#32423'"],["23","'#21021#20013#19977#24180#32423'"],["31","' +
        #39640#20013#19968#24180#32423'"],["32","'#39640#20013#20108#24180#32423'"],["33","'#39640#20013#19977#24180#32423'"]]},{"name":"dNumber","align' +
        '":"center","caption":"'#29677#32423#32534#21495'"},{"name":"dName","align":"center","c' +
        'aption":"'#29677#32423#21517#31216'"},{"name":"dManager","view":2}]}'
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 52
      Align = alClient
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 1
      ExplicitWidth = 416
    end
  end
  object FDQuery1: TFDQuery
    Left = 48
    Top = 88
  end
  object FDQuery2: TFDQuery
    Left = 48
    Top = 152
  end
end
