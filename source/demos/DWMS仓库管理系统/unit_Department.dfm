object Form_Department: TForm_Department
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
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 20
  object Pn1: TPanel
    AlignWithMargins = True
    Left = 370
    Top = 3
    Width = 558
    Height = 493
    Hint = 
      '{"table":"eUser","margin":0,"edit":0,"new":0,"border":0,"delete"' +
      ':0,"switch":0,"pagesize":10,"defaultquerymode":0,"fields":[{"nam' +
      'e":"uName","caption":"'#29992#25143#21517'","query":1,"sort":1,"width":100},{"nam' +
      'e":"uSex","type":"boolean","caption":"'#24615#21035'","query":1,"sort":1,"al' +
      'ign":"center","list":["'#22899'","'#30007'"],"width":80},{"name":"uDepartment"' +
      ',"caption":"'#37096#38376'","type":"dbtreepair","width":0,"table":"eDepartme' +
      'nt","datafield":"dId","viewfield":"dName","width":300},{"name":"' +
      'uRemark","caption":"'#22791#27880'","query":1,"sort":1,"width":100}]}'
    Margins.Left = 10
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 3
  end
  object P_L: TPanel
    Left = 0
    Top = 0
    Width = 360
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
      Width = 354
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
  object P_New: TPanel
    Left = 392
    Top = 100
    Width = 400
    Height = 320
    Hint = '{"radius":"10px"}'
    HelpType = htKeyword
    HelpKeyword = 'modal'
    BevelOuter = bvNone
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
      BiDiMode = bdLeftToRight
      ParentBiDiMode = False
      TabOrder = 1
    end
  end
  object P_LB: TPanel
    AlignWithMargins = True
    Left = 360
    Top = 25
    Width = 332
    Height = 39
    HelpType = htKeyword
    HelpKeyword = 'simple'
    Margins.Left = 0
    Margins.Right = 0
    AutoSize = True
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    object B_DAdd: TButton
      AlignWithMargins = True
      Left = 13
      Top = 5
      Width = 70
      Height = 30
      Hint = 
        '{"radius":"3px 0 0 3px","type":"primary","icon":"el-icon-circle-' +
        'plus-outline"}'
      Margins.Left = 13
      Margins.Top = 5
      Margins.Right = 1
      Margins.Bottom = 4
      Align = alLeft
      Caption = #22686#21152
      TabOrder = 0
      OnClick = B_DAddClick
    end
    object B_DEdit: TButton
      AlignWithMargins = True
      Left = 84
      Top = 5
      Width = 80
      Height = 30
      Hint = '{"radius":"0px","type":"primary","icon":"el-icon-edit"}'
      Margins.Left = 0
      Margins.Top = 5
      Margins.Right = 1
      Margins.Bottom = 4
      Align = alLeft
      Caption = #37325#21629#21517
      TabOrder = 1
      OnClick = B_DEditClick
    end
    object B_DDelete: TButton
      AlignWithMargins = True
      Left = 165
      Top = 5
      Width = 70
      Height = 30
      Hint = '{"radius":"0px","type":"primary","icon":"el-icon-delete"}'
      Margins.Left = 0
      Margins.Top = 5
      Margins.Right = 1
      Margins.Bottom = 4
      Align = alLeft
      Caption = #21024#38500
      TabOrder = 2
      OnClick = B_DDeleteClick
    end
    object B_DChild: TButton
      AlignWithMargins = True
      Left = 236
      Top = 5
      Width = 90
      Height = 30
      Hint = 
        '{"radius":"0 3px 3px 0","type":"primary","icon":"el-icon-circle-' +
        'plus-outline"}'
      Margins.Left = 0
      Margins.Top = 5
      Margins.Right = 6
      Margins.Bottom = 4
      Align = alLeft
      Caption = #26032#23376#37096#38376
      TabOrder = 3
      OnClick = B_DChildClick
    end
  end
  object FQ1: TFDQuery
    Left = 280
    Top = 125
  end
end
