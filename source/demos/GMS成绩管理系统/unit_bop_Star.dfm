object Form_bop_TestGroup: TForm_bop_TestGroup
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #20307#27979#20998#32452
  ClientHeight = 671
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
    Height = 671
    Hint = '{"link":"PnS"}'
    Align = alRight
    ExplicitLeft = 333
    ExplicitHeight = 540
  end
  object Pn1: TPanel
    Left = 0
    Top = 0
    Width = 534
    Height = 671
    Hint = 
      '{"account":"dwGMS","table":"bop_Test","defaulteditmax":1,"select' +
      '":40,"visiblecol":1,"export":0,"import":0,"defaulteditmax":0,"de' +
      'letecols":[2,3],"slave":[{"panel":"PnS","masterfield":"tId","sla' +
      'vefield":"rTestId"}],"fields":[{"name":"tId","caption":"'#32534#21495'","ali' +
      'gn":"center","width":40,"type":"auto"},{"name":"tName","caption"' +
      ':"'#21517#31216'","query":1,"sort":1,"must":1,"width":140},{"name":"tDate","' +
      'caption":"'#26085#26399'","type":"date","width":120,"sort":1,"align":"center' +
      '","dbfilter":1,"query":1},{"name":"tManagerId","caption":"'#36127#36131#20154'","' +
      'sort":1,"width":100,"align":"center","type":"dbcombopair","table' +
      '":"sys_User","datafield":"uId","viewfield":"uName","viewdefault"' +
      ':""},{"name":"tLocation","type":"dbcombo","query":1,"caption":"'#22320 +
      #28857'","align":"center","width":160,"table":"dic_Location","datafiel' +
      'd":"lName","sort":1},{"name":"tGender","caption":"'#24615#21035'","type":"co' +
      'mbo","align":"center","dbfilter":1,"list":["'#30007'","'#22899'"],"sort":1,"wi' +
      'dth":80,"query":1},{"name":"tRemark","caption":"'#22791#27880'","sort":1,"wi' +
      'dth":80,"query":1}]}'
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Pn1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object BtMember: TButton
      Left = 100
      Top = 272
      Width = 75
      Height = 33
      Hint = '{"type":"success","icon":"el-icon-user"}'
      Caption = #23398#29983
      TabOrder = 0
      Visible = False
      OnClick = BtMemberClick
    end
  end
  object PnS: TPanel
    AlignWithMargins = True
    Left = 544
    Top = 0
    Width = 400
    Height = 671
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
    Width = 75
    Height = 33
    Hint = '{"type":"primary"}'
    Caption = #33258#21160#20998#32452
    TabOrder = 2
    OnClick = BtGroupClick
  end
  object PnAuto: TPanel
    Left = 240
    Top = 50
    Width = 360
    Height = 540
    Hint = '{"radius":"7px"}'
    HelpType = htKeyword
    HelpKeyword = 'modal'
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'PnAuto'
    Color = clWhite
    ParentBackground = False
    TabOrder = 3
    Visible = False
    object LaAuto: TLabel
      Left = 0
      Top = 0
      Width = 356
      Height = 50
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #33258#21160#20998#32452
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -23
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      Layout = tlCenter
      ExplicitWidth = 541
    end
    object PnItem: TPanel
      Left = 0
      Top = 50
      Width = 356
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
      object LaItem: TLabel
        AlignWithMargins = True
        Left = 30
        Top = 3
        Width = 45
        Height = 44
        Margins.Left = 30
        Align = alLeft
        AutoSize = False
        Caption = #39033#30446#65306
        Layout = tlCenter
      end
      object CbItem: TComboBox
        AlignWithMargins = True
        Left = 81
        Top = 10
        Width = 130
        Height = 28
        Hint = '{"height":30}'
        Margins.Top = 10
        Align = alLeft
        Style = csDropDownList
        TabOrder = 0
      end
      object CbGender: TComboBox
        AlignWithMargins = True
        Left = 217
        Top = 10
        Width = 50
        Height = 28
        Hint = '{"height":30}'
        Margins.Top = 10
        Margins.Bottom = 10
        Align = alLeft
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 1
        Text = #30007
        Items.Strings = (
          #30007
          #22899)
      end
      object SECount: TSpinEdit
        AlignWithMargins = True
        Left = 273
        Top = 10
        Width = 66
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
    end
    object PnBtn: TPanel
      Left = 0
      Top = 482
      Width = 356
      Height = 54
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object BtCancel: TButton
        AlignWithMargins = True
        Left = 136
        Top = 12
        Width = 75
        Height = 30
        Hint = '{"type":"primary"}'
        Margins.Top = 12
        Margins.Bottom = 12
        Align = alLeft
        Caption = #21462#28040
        TabOrder = 0
        OnClick = BtCancelClick
      end
      object BtOK: TButton
        AlignWithMargins = True
        Left = 30
        Top = 12
        Width = 100
        Height = 30
        Hint = '{"type":"primary"}'
        Margins.Left = 30
        Margins.Top = 12
        Margins.Bottom = 12
        Align = alLeft
        Caption = #30830#23450
        TabOrder = 1
        OnClick = BtOKClick
      end
    end
    object PnClass: TPanel
      AlignWithMargins = True
      Left = 20
      Top = 103
      Width = 316
      Height = 369
      Hint = 
        '{"table":"(select dNumber,dName FROM sys_Department where LEN(dN' +
        'umber)=7) as dclass","pagesize":200,"select":40,"buttons":0,"def' +
        'aultquerymode":0,"prefix":"y","visiblecol":1,"fields":[{"name":"' +
        'dNumber","align":"center","caption":"'#29677#32423#32534#21495'"},{"name":"dName","ali' +
        'gn":"center","caption":"'#29677#32423#21517#31216'"}]}'
      Margins.Left = 20
      Margins.Right = 20
      Margins.Bottom = 10
      Align = alClient
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 2
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
