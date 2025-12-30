object Form_Category: TForm_Category
  Left = 0
  Top = 0
  HelpType = htKeyword
  HelpKeyword = 'embed'
  Caption = #21830#21697#31867#21035
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
    Width = 473
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
      Width = 467
      Height = 444
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
    object Panel1: TPanel
      Left = 0
      Top = 459
      Width = 473
      Height = 40
      Hint = '{"dwstyle":"border-top:solid 1px #f0f0f0;"}'
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'Panel1'
      Color = clNone
      ParentBackground = False
      TabOrder = 1
      object BRefresh: TButton
        AlignWithMargins = True
        Left = 10
        Top = 5
        Width = 75
        Height = 30
        Hint = '{"type":"primary"}'
        Margins.Left = 10
        Margins.Top = 5
        Margins.Bottom = 5
        Align = alLeft
        Caption = #21047#26032
        TabOrder = 0
        OnClick = BRefreshClick
      end
    end
  end
  object P0: TPanel
    Left = 473
    Top = 0
    Width = 458
    Height = 499
    Hint = 
      '{"table":"eCategory","defaultquerymode":1,"defaultorder":"cNo","' +
      'fields":[{"name":"cid","caption":"id","type":"auto","align":"cen' +
      'ter","sort":1,"width":80},{"name":"cNo","caption":"'#31867#22411#32534#30721'","query"' +
      ':1,"sort":1,"width":120},{"name":"cName","caption":"'#31867#22411#21517#31216'","query' +
      '":1,"sort":1,"width":200},{"name":"cRemark","caption":"'#22791#27880'","quer' +
      'y":1,"sort":1,"width":200}]}'
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
  end
  object FDQuery1: TFDQuery
    Left = 184
    Top = 24
  end
end
