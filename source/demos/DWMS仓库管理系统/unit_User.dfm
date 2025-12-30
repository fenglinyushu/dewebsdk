object Form_User: TForm_User
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
      '{"table":"eUser","margin":0,"print":0,"pagesize":10,"defaultquer' +
      'ymode":1,"fields":[{"name":"uAvatar","caption":"'#22836#20687'","type":"imag' +
      'e","imgdir":"media/images/dwERP/","imgtype":["jpg","png","gif"],' +
      '"imgheight":40,"imgwidth":50,"width":60},{"name":"uName","captio' +
      'n":"'#29992#25143#21517'","query":1,"sort":1,"width":100},{"name":"uRealName","ca' +
      'ption":"'#22995#21517'","query":1,"sort":1,"width":100},{"name":"uSex","type' +
      '":"boolean","caption":"'#24615#21035'","query":1,"sort":1,"list":["'#22899'","'#30007'"],"' +
      'width":80},{"name":"uAge","type":"integer","caption":"'#24180#40836'","query' +
      '":1,"sort":1,"max":65,"min":22,"width":80},{"name":"uDepartment"' +
      ',"caption":"'#37096#38376'","type":"dbtreepair","width":0,"table":"eDepartme' +
      'nt","datafield":"dId","viewfield":"dName"},{"name":"uPhone","cap' +
      'tion":"'#30005#35805'","sort":1,"query":1,"width":180},{"name":"uRemark","ca' +
      'ption":"'#22791#27880'","query":1,"sort":1,"width":100}]}'
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    OnDragOver = Pn1DragOver
  end
  object FQ1: TFDQuery
    Left = 280
    Top = 125
  end
end
