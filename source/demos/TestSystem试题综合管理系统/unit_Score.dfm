object Form_Score: TForm_Score
  Left = 0
  Top = 0
  HelpKeyword = 'embed'
  Caption = #25104#32489#26597#35810
  ClientHeight = 619
  ClientWidth = 883
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clGray
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  StyleName = 
    '{"table":"zh_Score","edit":0,"new":0,"delete":0,"print":0,"hide"' +
    ':0,"fields":[{"name":"id","caption":"id","width":50,"align":"cen' +
    'ter","type":"auto"},{"name":"apapername","caption":"'#35797#21367#21517#31216'","width' +
    '":180,"type":"string","query":1,"must":1,"sort":1},{"name":"ause' +
    'r","caption":"'#31572#39064#20154'","width":90,"type":"string","query":1,"must":1' +
    ',"sort":1},{"name":"auserno","caption":"'#31572#39064#20154#24037#21495'","width":120,"type' +
    '":"string","query":1,"must":1,"sort":1},{"name":"areviewer","cap' +
    'tion":"'#35780#38405#20154'","width":90,"query":1,"must":1,"sort":1},{"name":"are' +
    'viewerno","caption":"'#35780#38405#20154#24037#21495'","width":120,"query":1,"must":1,"sort' +
    '":1},{"name":"adatetime","caption":"'#32771#35797#26102#38388'","type":"datetime","sor' +
    't":1,"width":165},{"name":"areviewdatetime","caption":"'#35780#38405#26102#38388'","ty' +
    'pe":"datetime","sort":1,"width":165},{"name":"adetail","caption"' +
    ':"'#35814#24773'","width":0},{"name":"atotal","caption":"'#20998#25968'","type":"integer' +
    '","query":1,"readonly":1,"sort":1,"width":80}]}'
  OnShow = FormShow
  TextHeight = 20
  object B_ToXls: TButton
    Left = 680
    Top = 160
    Width = 70
    Height = 33
    Caption = #23548#20986
    TabOrder = 0
    OnClick = B_ToXlsClick
  end
  object B_Detail: TButton
    Left = 680
    Top = 208
    Width = 70
    Height = 33
    Caption = #35814#24773
    TabOrder = 1
    OnClick = B_DetailClick
  end
  object P_Detail: TPanel
    Left = 88
    Top = -6
    Width = 340
    Height = 585
    Hint = '{"radius":"10px"}'
    HelpType = htKeyword
    HelpKeyword = 'modal'
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    Visible = False
    object L_PaperName: TLabel
      Left = 0
      Top = 0
      Width = 340
      Height = 60
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #25105#30340#35797#21367
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -17
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      Layout = tlCenter
      WordWrap = True
      ExplicitTop = -2
    end
    object P_DButtons: TPanel
      Left = 0
      Top = 535
      Width = 340
      Height = 50
      Align = alBottom
      BevelOuter = bvNone
      Color = clNone
      ParentBackground = False
      TabOrder = 0
      object B_Close: TButton
        Left = 0
        Top = 0
        Width = 340
        Height = 50
        Hint = '{"radius":"0px","type":"primary"}'
        Align = alClient
        Caption = #20851#38381
        TabOrder = 0
        OnClick = B_CloseClick
      end
    end
    object M_Detail: TMemo
      AlignWithMargins = True
      Left = 0
      Top = 60
      Width = 340
      Height = 475
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alClient
      BorderStyle = bsNone
      TabOrder = 1
    end
  end
end
