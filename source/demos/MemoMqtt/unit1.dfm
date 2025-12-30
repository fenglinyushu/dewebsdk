object Form1: TForm1
  Left = 0
  Top = 0
  HelpType = htKeyword
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'DeWeb'
  ClientHeight = 677
  ClientWidth = 360
  Color = clBtnFace
  TransparentColor = True
  TransparentColorValue = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnMouseUp = FormMouseUp
  TextHeight = 21
  object Pn0: TPanel
    Left = 0
    Top = 0
    Width = 360
    Height = 50
    HelpType = htKeyword
    HelpKeyword = 'simple'
    Align = alTop
    BevelOuter = bvNone
    Color = 16756482
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object L_Title: TLabel
      AlignWithMargins = True
      Left = 48
      Top = 3
      Width = 264
      Height = 42
      Margins.Left = 48
      Margins.Right = 48
      Margins.Bottom = 5
      Align = alClient
      Alignment = taCenter
      AutoSize = False
      Caption = 'DeWeb MQTT'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindow
      Font.Height = -23
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitLeft = 11
      ExplicitTop = -6
      ExplicitWidth = 343
      ExplicitHeight = 32
    end
  end
  object PageControl1: TPageControl
    AlignWithMargins = True
    Left = 10
    Top = 60
    Width = 340
    Height = 607
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    ExplicitHeight = 525
    object TabSheet1: TTabSheet
      Caption = #22312#32447#28436#31034
      object BtC: TButton
        AlignWithMargins = True
        Left = 20
        Top = 52
        Width = 292
        Height = 35
        Hint = '{"type":"success"}'
        Margins.Left = 20
        Margins.Top = 0
        Margins.Right = 20
        Margins.Bottom = 0
        Align = alTop
        Caption = #36830#25509' connect'
        TabOrder = 0
        OnClick = BtCClick
      end
      object BtE: TButton
        AlignWithMargins = True
        Left = 20
        Top = 319
        Width = 292
        Height = 35
        Hint = '{"type":"success"}'
        Margins.Left = 20
        Margins.Top = 20
        Margins.Right = 20
        Margins.Bottom = 0
        Align = alTop
        Caption = #32456#27490' end'
        Enabled = False
        TabOrder = 1
        OnClick = BtEClick
      end
      object BtP: TButton
        AlignWithMargins = True
        Left = 20
        Top = 264
        Width = 292
        Height = 35
        Hint = '{"type":"success"}'
        Margins.Left = 20
        Margins.Top = 0
        Margins.Right = 20
        Margins.Bottom = 0
        Align = alTop
        Caption = #21457#24067#28040#24687' publish'
        Enabled = False
        TabOrder = 2
        OnClick = BtPClick
      end
      object BtS: TButton
        AlignWithMargins = True
        Left = 20
        Top = 139
        Width = 292
        Height = 35
        Hint = '{"type":"success"}'
        Margins.Left = 20
        Margins.Top = 0
        Margins.Right = 20
        Margins.Bottom = 0
        Align = alTop
        Caption = #35746#38405#20027#39064' subscribe'
        Enabled = False
        TabOrder = 3
        OnClick = BtSClick
      end
      object BtU: TButton
        AlignWithMargins = True
        Left = 20
        Top = 177
        Width = 292
        Height = 35
        Hint = '{"type":"success"}'
        Margins.Left = 20
        Margins.Right = 20
        Margins.Bottom = 0
        Align = alTop
        Caption = #21462#28040#35746#38405'  unsubscribe'
        Enabled = False
        TabOrder = 4
        OnClick = BtUClick
      end
      object Edit_Server: TEdit
        AlignWithMargins = True
        Left = 20
        Top = 20
        Width = 292
        Height = 29
        Margins.Left = 20
        Margins.Top = 20
        Margins.Right = 20
        Align = alTop
        TabOrder = 5
        Text = 'ws://broker.emqx.io:8083/mqtt'
        ExplicitTop = -8
      end
      object Edit_Topic: TEdit
        AlignWithMargins = True
        Left = 20
        Top = 107
        Width = 292
        Height = 29
        Margins.Left = 20
        Margins.Top = 20
        Margins.Right = 20
        Align = alTop
        TabOrder = 6
        Text = 'testtopic/test'
        ExplicitTop = 88
      end
      object EtM: TEdit
        AlignWithMargins = True
        Left = 20
        Top = 232
        Width = 292
        Height = 29
        Margins.Left = 20
        Margins.Top = 20
        Margins.Right = 20
        Align = alTop
        TabOrder = 7
        Text = 'MyMessage'
        ExplicitTop = 227
      end
      object MMg: TMemo
        AlignWithMargins = True
        Left = 20
        Top = 374
        Width = 292
        Height = 177
        Margins.Left = 20
        Margins.Top = 20
        Margins.Right = 20
        Margins.Bottom = 20
        Align = alClient
        Lines.Strings = (
          'MMg')
        TabOrder = 8
        ExplicitTop = 472
        ExplicitHeight = 79
      end
      object MmMqtt: TMemo
        Left = 168
        Top = 437
        Width = 280
        Height = 89
        HelpType = htKeyword
        HelpKeyword = 'mqtt'
        Lines.Strings = (
          'MmMqtt')
        TabOrder = 9
        OnEnter = MmMqttEnter
        OnKeyPress = MmMqttKeyPress
      end
    end
    object TabSheet2: TTabSheet
      Caption = #20351#29992#35828#26126
      ImageIndex = 1
      object Memo9: TMemo
        AlignWithMargins = True
        Left = 20
        Top = 3
        Width = 309
        Height = 565
        Hint = '{"dwstyle":"overflow:scroll;"}'
        HelpType = htKeyword
        HelpKeyword = 'html'
        Margins.Left = 20
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -16
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        Lines.Strings = (
          '<h1 >Mqtt'#20351#29992#25351#21335
          '</h1>'
          '<p >'#30887#26641#35199#39118'</p>'
          '<h2>'#19968#12289#35828#26126'</h2>'
          '<p>'#26412#25991#26723#20165#36866#29992#20110#22312'DeWeb'#24320#21457#24179#21488#20013
          #24341#20837'Mqtt'#26102#20351#29992#12290
          '<br/>'#20219#20309#38382#39064#27426#36814#32852#31995'QQ'#65306'45300355'
          '</p>'
          ''
          '<h2>'#20108#12289#25511#20214#35774#32622'</h2>'
          '<ol>'
          '  <li>'#25171#24320#19968#20010'DeWeb'#31034#20363#31243#24207#65292#22914'hello</li>'
          '  <li>'#22312'DeWeb'#30340'Form'#30028#38754#19978#25918#32622#19968#20010'TMemo'#25511#20214#65292#20363#22914'Name'#20026'Memo1</li>'
          '  <li>'#20462#25913'Memo1'#30340'HelpKeyword'#23646#24615#20026'mqtt</li>'
          '  <li>'#20462#25913'Memo1'#30340'ScrollBars'#20026'ssBoth</li>'
          '  <li>'#22312'uses'#20013#21152#20837'dwMqtt</li>'
          '</ol>'
          ''
          '<h2>'#19977#12289#20027#35201#20989#25968'</h2>'
          '<ol>'
          '  <li>dwMqttConnect'#36830#25509#26381#21153#22120'<br>'
          'AMqtt:TMemo '#20026'Mqtt'#25511#20214#65288'TMemo,'#35774#32622'HelpKeyword=mqtt'#65289',AUrl'#20026#26381#21153#22120'URL<br>'
          'procedure dwMqttConnect(AMqtt:TMemo;AUrl:String); </li>'
          '<li>dwMqttSubscribe'#35746#38405#28040#24687'<br>'
          
            'AMqtt:TMemo '#20026'Mqtt'#25511#20214#65288'TMemo,'#35774#32622'HelpKeyword=mqtt'#65289',ATopic '#20026#28040#24687#20027#39064', AQos' +
            #20026#26381#21153#36136#37327' <br>'
          
            'procedure dwMqttSubscribe(AMqtt:TMemo;ATopic:String;AQos:Integer' +
            ');</li>'
          ''
          '<li>dwMqttUnsubscribe'#21462#28040#35746#38405#28040#24687'<br>'
          'AMqtt:TMemo '#20026'Mqtt'#25511#20214#65288'TMemo,'#35774#32622'HelpKeyword=mqtt'#65289',ATopic '#20026#28040#24687#20027#39064'<br>'
          'procedure dwMqttUnsubscribe(AMqtt:TMemo;ATopic:String);</li>'
          ''
          '<li>dwMqttPublish'#21457#24067#28040#24687'<br>'
          
            'AMqtt:TMemo '#20026'Mqtt'#25511#20214#65288'TMemo,'#35774#32622'HelpKeyword=mqtt'#65289',ATopic '#20026#28040#24687#20027#39064#65292'AText' +
            #20026#28040#24687#20869#23481' <br>'
          'procedure dwMqttPublish(AMqtt:TMemo;ATopic,AText:String);</li>'
          ''
          '<li>dwMqttEnd'#20572#27490'<br>'
          'AMqtt:TMemo '#20026'Mqtt'#25511#20214#65288'TMemo,'#35774#32622'HelpKeyword=mqtt'#65289'<br>'
          'procedure dwMqttEnd(AMqtt:TMemo);  </li>'
          '</ol>'
          ''
          ''
          '<h2>'#22235#12289#25511#20214#20107#20214'</h2>'
          ''
          '<ol>'
          '  <li>'#24403#25511#20214#25509#25910#21040#28040#24687#26102#28608#27963'OnEnter'#20107#20214#65292#28040#24687#20869#23481#20026'Memo.Text</li>'
          '  <li>'#24403#25511#20214#29366#24577#25913#21464#26102#28608#27963'OnKeypress'#20107#20214','#20854#20013':<br>'
          '  Key'#20026'c'#26102#34920#31034#36830#25509#25104#21151#65292#20026'C'#26102#34920#31034#36830#25509#19981#25104#21151#65307'<br>'
          '  Key'#20026's'#26102#34920#31034#35746#38405#25104#21151#65292#20026'S'#26102#34920#31034#35746#38405#19981#25104#21151#65307' <br>'
          '  Key'#20026'u'#26102#34920#31034#21462#28040#35746#38405#25104#21151#65292#20026'U'#26102#34920#31034#21462#28040#35746#38405#19981#25104#21151#65307'<br>'
          '  Key'#20026'p'#26102#34920#31034#21457#36865#25104#21151#65292#20026'P'#26102#34920#31034#21457#36865#28040#24687#19981#25104#21151#65307'<br>'
          '  Key'#20026'e'#26102#34920#31034#20572#27490#25104#21151#65292#20026'E'#26102#34920#31034#20572#27490#19981#25104#21151#65307'<br>'
          ''
          '  </li>'
          '</ol>'
          '<br>'
          '<br>'
          '<br>'
          '')
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
        ExplicitHeight = 483
      end
    end
  end
end
