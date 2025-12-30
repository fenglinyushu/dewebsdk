object Form_sys_User: TForm_sys_User
  Left = 0
  Top = 0
  HelpType = htKeyword
  HelpKeyword = 'embed'
  Caption = #29992#25143#31649#29702
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
      OnClick = TVClick
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
      '{"table":"sys_User","defaultquerymode":1,"rowheight":60,"select"' +
      ':40,"visiblecol":2,"fields":[{"name":"uAvatar","caption":"'#30456#29255'","t' +
      'ype":"image","imgdir":"media/images/dwFrame/","imgtype":["jpg","' +
      'png","gif"],"imgheight":45,"imgwidth":45,"preview":1,"align":"ce' +
      'nter","width":55},{"name":"uName","caption":"'#29992#25143#21517'","query":1,"sor' +
      't":1,"must":1,"width":100},{"name":"uRealName","caption":"'#22995#21517'","q' +
      'uery":1,"sort":1,"width":100},{"name":"uSex","type":"boolean","c' +
      'aption":"'#24615#21035'","query":1,"sort":1,"dbfilter":1,"align":"center","l' +
      'ist":["'#22899'","'#30007'"],"width":80},{"name":"uAge","type":"integer","capt' +
      'ion":"'#24180#40836'","query":1,"sort":1,"align":"center","width":80},{"name' +
      '":"uDepartmentNo","caption":"'#37096#38376'","type":"dbtreepair","sort":1,"w' +
      'idth":200,"table":"sys_Department","datafield":"dNo","viewfield"' +
      ':"dName"},{"name":"uRole","caption":"'#35282#33394'","type":"dbcombo","sort"' +
      ':1,"width":100,"align":"center","table":"sys_Role","datafield":"' +
      'rName"},{"name":"uPhone","caption":"'#30005#35805'","sort":1,"query":1,"widt' +
      'h":120},{"name":"uRemark","caption":"'#22791#27880'","query":1,"sort":1,"wid' +
      'th":80},{"name":"uId","view":2},{"name":"uDepartmentId","view":2' +
      '}]}'
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Pn1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    OnDragOver = Pn1DragOver
    object BtConv: TButton
      Left = 560
      Top = 224
      Width = 130
      Height = 33
      Hint = '{"type":"primary","icon":"el-icon-box"}'
      Caption = #25209#37327#35774#32622#37096#38376
      TabOrder = 0
      OnClick = BtConvClick
    end
    object PnHint: TPanel
      Left = 3
      Top = 96
      Width = 600
      Height = 100
      Hint = 
        '{"radius":"7px","dwstyle":"z-index:9;border:solid 1px #ddd;backg' +
        'round-image: linear-gradient(25deg, #445543, #5c7346, #739348, #' +
        '8bb448);"}'
      HelpType = htKeyword
      BevelOuter = bvNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -25
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Visible = False
      object Label1: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 50
        Width = 594
        Height = 0
        Margins.Top = 50
        Margins.Bottom = 50
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        Caption = '<--- '#35831#28857#20987#25311#35774#32622#30340#37096#38376#33410#28857
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -20
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        ExplicitLeft = 48
        ExplicitTop = 80
        ExplicitWidth = 48
        ExplicitHeight = 20
      end
      object BtClose: TButton
        Left = 557
        Top = 10
        Width = 32
        Height = 32
        Hint = '{"type":"text","icon":"el-icon-close"}'
        Cancel = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -25
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = BtCloseClick
      end
    end
  end
  object FDQuery1: TFDQuery
    Left = 280
    Top = 125
  end
end
