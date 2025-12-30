object Form1: TForm1
  Left = 191
  Top = 60
  HelpType = htKeyword
  BorderStyle = bsNone
  Caption = 'DeWeb'
  ClientHeight = 638
  ClientWidth = 963
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = True
  OnMouseUp = FormMouseUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 20
  object PBanner: TPanel
    Left = 0
    Top = 0
    Width = 963
    Height = 50
    HelpType = htKeyword
    HelpKeyword = 'simple'
    Align = alTop
    BevelOuter = bvNone
    Color = 16742167
    ParentBackground = False
    TabOrder = 0
    object Label2: TLabel
      AlignWithMargins = True
      Left = 71
      Top = 3
      Width = 490
      Height = 42
      Margins.Left = 10
      Margins.Bottom = 5
      Align = alLeft
      AutoSize = False
      Caption = 'dwCrudPanel Master-Slave'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindow
      Font.Height = -27
      Font.Name = #24494#36719#38597#40657
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
      Layout = tlCenter
    end
    object Im: TImage
      AlignWithMargins = True
      Left = 10
      Top = 3
      Width = 48
      Height = 44
      Hint = '{"src":"media/images/32/a (78).png"}'
      Margins.Left = 10
      Align = alLeft
    end
  end
  object PClient: TPanel
    Left = 0
    Top = 50
    Width = 723
    Height = 588
    Align = alClient
    BevelOuter = bvNone
    Caption = 'PClient'
    TabOrder = 1
    object PMaster: TPanel
      Left = 0
      Top = 0
      Width = 723
      Height = 415
      Hint = 
        '{"account":"dwAccess","table":"dwf_goods","pagesize":5,"prefix":' +
        '"m0","rowheight":45,"edit":1,"new":1,"delete":1,"defaultquerymod' +
        'e":1,"switch":1,"border":1,"buttons":1,"margin":10,"editwidth":3' +
        '20,"buttoncaption":1,"editcolcount":2,"defaulteditmax":0,"select' +
        '":50,"fields":[{"name":"id","width":80,"type":"auto","view":0,"m' +
        'ust":0,"query":0,"sort":1,"readonly":0,"unique":0,"align":"cente' +
        'r"},{"name":"goodsname","caption":"'#36135#21697#21517#31216'","width":120,"type":"str' +
        'ing","view":0,"must":1,"query":1,"sort":1,"readonly":0,"unique":' +
        '0,"align":"left"},{"name":"goodscode","caption":"'#32534#30721'","width":100' +
        ',"type":"string","view":0,"must":0,"query":1,"sort":1,"readonly"' +
        ':1,"unique":1,"align":"left"},{"name":"provider","caption":"'#20379#24212#21830'"' +
        ',"width":150,"type":"combo","view":0,"must":0,"query":1,"sort":1' +
        ',"dbfilter":1,"readonly":1,"unique":0,"align":"left","list":["'#20013#20852 +
        '","'#21326#20026'","'#36808#21326'","'#32511#30005'"]},{"name":"Spec","caption":"'#35268#26684'","width":100,"ty' +
        'pe":"string","view":1,"must":0,"query":1,"sort":1,"readonly":0,"' +
        'unique":0,"align":"center"},{"name":"gclass","caption":"'#31867#21035'","wid' +
        'th":100,"type":"string","view":1,"must":0,"query":1,"sort":1,"re' +
        'adonly":0,"unique":0,"align":"center"},{"name":"Unit","width":10' +
        '0,"type":"combo","view":0,"must":0,"query":1,"sort":1,"readonly"' +
        ':0,"unique":0,"align":"center","list":["'#20010'","'#37096'","'#21488'","'#22871'"]},{"name"' +
        ':"InPrice","caption":"'#36827#20215'","width":100,"type":"money","view":0,"m' +
        'ust":0,"query":1,"sort":1,"readonly":0,"unique":0,"align":"right' +
        '","min":0,"max":100},{"name":"Price","caption":"'#20215#26684'","width":100,' +
        '"type":"money","view":0,"must":0,"query":1,"sort":1,"readonly":0' +
        ',"unique":0,"align":"right","min":0,"max":100},{"name":"UpdateTi' +
        'me","caption":"'#26356#26032#26085#26399'","width":120,"type":"date","view":0,"must":0' +
        ',"query":1,"sort":1,"readonly":0,"unique":0,"align":"center"},{"' +
        'name":"description","caption":"'#22791#27880'","width":100,"type":"string","' +
        'view":0,"must":0,"query":1,"sort":1,"readonly":0,"unique":0,"ali' +
        'gn":"left"}],"slave":[{"panel":"PSlave1","masterfield":"id","sla' +
        'vefield":"gid"}]}'
      HelpType = htKeyword
      Align = alTop
      BevelKind = bkSoft
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      OnDragOver = PMasterDragOver
    end
    object PSlaves: TPanel
      Left = 0
      Top = 415
      Width = 723
      Height = 173
      HelpType = htKeyword
      Align = alClient
      BevelKind = bkSoft
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 1
      OnDragOver = PMasterDragOver
      object PSlave1: TPanel
        Left = 0
        Top = 0
        Width = 719
        Height = 169
        Hint = 
          '{"table":"dwf_goodsEx","prefix":"s0","defaultquerymode":1,"switc' +
          'h":0,"master":{"panel":"PMaster","masterfield":"id","slavefield"' +
          ':"gid"},"fields":[{"name":"gid","width":150,"type":"auto","view"' +
          ':2,"must":0,"query":1,"sort":1,"readonly":0,"unique":0,"filter":' +
          '0,"dbfilter":0,"align":"left","defaultqv":""},{"name":"Title","c' +
          'aption":"'#23646#24615#21517#31216'","width":150,"type":"string","view":0,"must":0,"qu' +
          'ery":1,"sort":1,"readonly":0,"unique":0,"filter":1,"dbfilter":0,' +
          '"align":"center","defaultqv":"","filterlist":["'#36866#29992#27700#21387'","'#23631#24149#23610#23544'"]},{"' +
          'name":"Type","caption":"'#31867#22411'","width":150,"type":"string","view":0' +
          ',"must":0,"query":1,"sort":1,"readonly":0,"unique":0,"filter":0,' +
          '"dbfilter":0,"align":"center","defaultqv":""},{"name":"[Value]",' +
          '"caption":"'#25968#20540'","width":200,"type":"string","view":0,"must":0,"qu' +
          'ery":1,"sort":1,"readonly":0,"unique":0,"filter":0,"dbfilter":0,' +
          '"align":"left","defaultqv":""}]}'
        HelpType = htKeyword
        Align = alClient
        BevelKind = bkSoft
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 0
      end
    end
  end
  object PEvent: TPanel
    Left = 723
    Top = 50
    Width = 240
    Height = 588
    Align = alRight
    BevelOuter = bvNone
    Caption = 'PEvent'
    TabOrder = 2
    object Memo1: TMemo
      AlignWithMargins = True
      Left = 3
      Top = 43
      Width = 234
      Height = 542
      Align = alClient
      Lines.Strings = (
        '')
      TabOrder = 0
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 240
      Height = 40
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object Label1: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 187
        Height = 34
        Align = alClient
        Alignment = taCenter
        Caption = #20107#20214
        Layout = tlCenter
        ExplicitWidth = 30
        ExplicitHeight = 20
      end
      object Button1: TButton
        AlignWithMargins = True
        Left = 196
        Top = 3
        Width = 34
        Height = 34
        Hint = '{"type":"info","icon":"el-icon-close"}'
        Margins.Right = 10
        Align = alRight
        Cancel = True
        TabOrder = 0
        OnClick = Button1Click
      end
    end
  end
  object FDConnection1: TFDConnection
    Left = 104
    Top = 128
  end
  object FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink
    Left = 104
    Top = 192
  end
end
