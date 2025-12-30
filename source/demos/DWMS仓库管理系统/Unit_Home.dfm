object Form_Home: TForm_Home
  Left = 0
  Top = 0
  HelpContext = 56
  VertScrollBar.Visible = False
  BorderStyle = bsNone
  Caption = #39318#39029
  ClientHeight = 629
  ClientWidth = 900
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnResize = FormResize
  OnShow = FormShow
  TextHeight = 21
  object P0: TPanel
    AlignWithMargins = True
    Left = 20
    Top = 20
    Width = 860
    Height = 110
    Hint = 
      '{"radius":"10px","dwstyle":"box-shadow: rgba(0, 0, 0, 0.35) 0px ' +
      '5px 15px;box-shadow: rgba(0, 0, 0, 0.07) 0px 1px 2px, rgba(0, 0,' +
      ' 0, 0.07) 0px 2px 4px, rgba(0, 0, 0, 0.07) 0px 4px 8px, rgba(0, ' +
      '0, 0, 0.07) 0px 8px 16px, rgba(0, 0, 0, 0.07) 0px 16px 32px, rgb' +
      'a(0, 0, 0, 0.07) 0px 32px 64px;"}'
    Margins.Left = 20
    Margins.Top = 20
    Margins.Right = 20
    Margins.Bottom = 5
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    ExplicitLeft = 15
    object L01: TLabel
      AlignWithMargins = True
      Left = 20
      Top = 10
      Width = 820
      Height = 30
      Margins.Left = 20
      Margins.Top = 10
      Margins.Right = 20
      Margins.Bottom = 10
      Align = alTop
      AutoSize = False
      Caption = 'Hi! DWMS'
      Font.Charset = ANSI_CHARSET
      Font.Color = 6579300
      Font.Height = -23
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitLeft = 10
      ExplicitTop = 3
      ExplicitWidth = 349
    end
    object L02: TLabel
      AlignWithMargins = True
      Left = 20
      Top = 50
      Width = 820
      Height = 50
      Margins.Left = 20
      Margins.Top = 0
      Margins.Right = 20
      Margins.Bottom = 10
      Align = alClient
      AutoSize = False
      Caption = 
        '<b>DWMS</b>'#26159#19968#20010#22522#20110'DeWeb'#30340#20179#24211#31649#29702#22522#30784#26694#26550#65292#20869#32622#24120#29992#22522#26412#27169#22359#65292#21253#25324#65306#22686#21024#25913#26597#12289#20027#20174#34920#12289#29992#25143#27880#20876'/'#30331#24405'/'#36864#20986#12289#20986 +
        #20837#24211#21333#12289#29992#25143#31649#29702#12289#35282#33394#31649#29702#12289#36164#26009#31649#29702#31561
      Font.Charset = ANSI_CHARSET
      Font.Color = 6579300
      Font.Height = -13
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      WordWrap = True
      ExplicitLeft = 67
      ExplicitWidth = 345
      ExplicitHeight = 19
    end
  end
  object P1: TPanel
    AlignWithMargins = True
    Left = 10
    Top = 140
    Width = 880
    Height = 110
    Hint = '{"radius":"5px"}'
    Margins.Left = 10
    Margins.Top = 5
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 1
    object P12: TPanel
      AlignWithMargins = True
      Left = 210
      Top = 10
      Width = 80
      Height = 90
      Hint = 
        '{"radius":"5px","src":"image/32/sun_fill_32x32.png","dwstyle":"b' +
        'order:solid 1px #eee;"}'
      HelpType = htKeyword
      HelpKeyword = 'button'
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alLeft
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Caption = #23458#25143#20449#24687
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = 6579300
      Font.Height = -16
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 2
      OnClick = P10Click
    end
    object P13: TPanel
      AlignWithMargins = True
      Left = 310
      Top = 10
      Width = 80
      Height = 90
      Hint = 
        '{"radius":"5px","src":"image/32/box_32x32.png","dwstyle":"border' +
        ':solid 1px #eee;"}'
      HelpType = htKeyword
      HelpKeyword = 'button'
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alLeft
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Caption = #36827#24211#21333
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = 6579300
      Font.Height = -16
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 3
      OnClick = P10Click
    end
    object P11: TPanel
      AlignWithMargins = True
      Left = 110
      Top = 10
      Width = 80
      Height = 90
      Hint = 
        '{"radius":"5px","src":"image/32/share_32x32.png","dwstyle":"bord' +
        'er:solid 1px #eee;"}'
      HelpType = htKeyword
      HelpKeyword = 'button'
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alLeft
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Caption = #36135#21697#20449#24687
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = 6579300
      Font.Height = -16
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
      OnClick = P10Click
    end
    object P14: TPanel
      AlignWithMargins = True
      Left = 410
      Top = 10
      Width = 80
      Height = 90
      Hint = 
        '{"radius":"5px","src":"image/32/chart_32x32.png","dwstyle":"bord' +
        'er:solid 1px #eee;"}'
      HelpType = htKeyword
      HelpKeyword = 'button'
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alLeft
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Caption = #32479#35745#22270#34920
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = 6579300
      Font.Height = -16
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 4
      OnClick = P10Click
    end
    object P16: TPanel
      AlignWithMargins = True
      Left = 610
      Top = 10
      Width = 80
      Height = 90
      Hint = 
        '{"radius":"5px","src":"image/32/target_32x32.png","dwstyle":"bor' +
        'der:solid 1px #eee;"}'
      HelpType = htKeyword
      HelpKeyword = 'button'
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alLeft
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Caption = #24377#31383#31034#20363
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = 6579300
      Font.Height = -16
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 6
      OnClick = P10Click
    end
    object P17: TPanel
      AlignWithMargins = True
      Left = 710
      Top = 10
      Width = 80
      Height = 90
      Hint = 
        '{"radius":"5px","src":"image/32/sun_fill_32x32.png","dwstyle":"b' +
        'order:solid 1px #eee;"}'
      HelpType = htKeyword
      HelpKeyword = 'button'
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alLeft
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Caption = #31354#30333#27169#22359
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = 6579300
      Font.Height = -16
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 7
      OnClick = P10Click
    end
    object P15: TPanel
      AlignWithMargins = True
      Left = 510
      Top = 10
      Width = 80
      Height = 90
      Hint = 
        '{"radius":"5px","src":"image/32/document_stroke_32x32.png","dwst' +
        'yle":"border:solid 1px #eee;"}'
      HelpType = htKeyword
      HelpKeyword = 'button'
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alLeft
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Caption = #36164#26009#31649#29702
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = 6579300
      Font.Height = -16
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 5
      OnClick = P10Click
    end
    object P10: TPanel
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 80
      Height = 90
      Hint = 
        '{"radius":"5px","src":"image/32/aperture_32x32.png","dwstyle":"b' +
        'order:solid 1px #eee;"}'
      HelpType = htKeyword
      HelpKeyword = 'button'
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alLeft
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Caption = #20379#24212#21830#20449#24687
      Color = clWhite
      Font.Charset = ANSI_CHARSET
      Font.Color = 6579300
      Font.Height = -16
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      OnClick = P10Click
    end
  end
  object P2: TPanel
    AlignWithMargins = True
    Left = 10
    Top = 250
    Width = 880
    Height = 130
    Hint = '{"radius":"5px"}'
    Margins.Left = 10
    Margins.Top = 0
    Margins.Right = 10
    Margins.Bottom = 5
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 2
    object P20: TPanel
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 300
      Height = 110
      Hint = '{"radius":"5px"}'
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alLeft
      BevelOuter = bvNone
      Color = 5196610
      ParentBackground = False
      TabOrder = 0
      object L200: TLabel
        AlignWithMargins = True
        Left = 20
        Top = 5
        Width = 277
        Height = 41
        Margins.Left = 20
        Margins.Top = 5
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = #24211#23384#25968#25454
        Font.Charset = ANSI_CHARSET
        Font.Color = 13158600
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        ExplicitLeft = 16
        ExplicitTop = 8
        ExplicitWidth = 137
      end
      object L201: TLabel
        AlignWithMargins = True
        Left = 20
        Top = 46
        Width = 260
        Height = 61
        Margins.Left = 20
        Margins.Top = 0
        Margins.Right = 20
        Align = alClient
        AutoSize = False
        Caption = 'DeWeb'#26159#19968#20010#21487#20197#30452#25509#23558'Delphi'#31243#24207
        Font.Charset = ANSI_CHARSET
        Font.Color = 13158600
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        WordWrap = True
        ExplicitLeft = 16
        ExplicitTop = 40
        ExplicitWidth = 257
        ExplicitHeight = 41
      end
    end
    object P21: TPanel
      AlignWithMargins = True
      Left = 330
      Top = 10
      Width = 280
      Height = 110
      Hint = '{"radius":"5px"}'
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alLeft
      BevelOuter = bvNone
      Color = 10049400
      ParentBackground = False
      TabOrder = 1
      object L210: TLabel
        AlignWithMargins = True
        Left = 20
        Top = 5
        Width = 257
        Height = 41
        Margins.Left = 20
        Margins.Top = 5
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = #20837#24211#25968#25454
        Font.Charset = ANSI_CHARSET
        Font.Color = 13158600
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        ExplicitLeft = 10
        ExplicitTop = 8
        ExplicitWidth = 137
      end
      object L211: TLabel
        AlignWithMargins = True
        Left = 20
        Top = 46
        Width = 240
        Height = 61
        Margins.Left = 20
        Margins.Top = 0
        Margins.Right = 20
        Align = alClient
        AutoSize = False
        Caption = 'DeWeb'#26159#19968#20010#21487#20197#30452#25509#23558'Delphi'#31243#24207
        Font.Charset = ANSI_CHARSET
        Font.Color = 13158600
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        WordWrap = True
        ExplicitLeft = 16
        ExplicitTop = 40
        ExplicitWidth = 257
        ExplicitHeight = 41
      end
    end
    object P22: TPanel
      AlignWithMargins = True
      Left = 630
      Top = 10
      Width = 171
      Height = 110
      Hint = '{"radius":"5px"}'
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alLeft
      BevelOuter = bvNone
      Color = 11175447
      ParentBackground = False
      TabOrder = 2
      object L220: TLabel
        AlignWithMargins = True
        Left = 20
        Top = 5
        Width = 148
        Height = 41
        Margins.Left = 20
        Margins.Top = 5
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        Caption = #20986#24211#25968#25454
        Font.Charset = ANSI_CHARSET
        Font.Color = 13158600
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        ExplicitLeft = 16
        ExplicitTop = 8
        ExplicitWidth = 137
      end
      object L221: TLabel
        AlignWithMargins = True
        Left = 20
        Top = 46
        Width = 131
        Height = 61
        Margins.Left = 20
        Margins.Top = 0
        Margins.Right = 20
        Align = alClient
        AutoSize = False
        Caption = 'DeWeb'#26159#19968#20010#21487#20197#30452#25509#23558'Delphi'#31243#24207
        Font.Charset = ANSI_CHARSET
        Font.Color = 13158600
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        WordWrap = True
        ExplicitLeft = 19
        ExplicitTop = 48
        ExplicitWidth = 257
        ExplicitHeight = 41
      end
    end
  end
  object P3: TPanel
    AlignWithMargins = True
    Left = 10
    Top = 390
    Width = 880
    Height = 234
    Hint = '{"radius":"5px"}'
    Margins.Left = 10
    Margins.Top = 5
    Margins.Right = 10
    Margins.Bottom = 5
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 3
    object Mm: TMemo
      Left = 0
      Top = 0
      Width = 880
      Height = 234
      HelpType = htKeyword
      HelpKeyword = 'echarts'
      Align = alClient
      Lines.Strings = (
        'this.value = ['#39'2020'#39', '#39'2021'#39', '#39'2022'#39', '#39'2023'#39', '#39'2024'#39'];'
        'this.value0 = [320, 332, 301, 334, 390];'
        'this.value1 = [220, 312, 321, 134, 290];'
        'this.value2 = [356, 352, 371, 534, 490];'
        'this.value3 = [366, 232, 601, 234, 660];'
        'const labelOption = {'
        '  show: true,'
        '  position: '#39'insideBottom'#39','
        '  distance: 15,'
        '  align: '#39'left'#39','
        '  verticalAlign: '#39'middle'#39','
        '  rotate: 90,'
        '  formatter: '#39'{name|{a}} \n{c}'#30334#20803#39','
        '  fontSize: 16,'
        '  rich: {'
        '    name: {}'
        '  }'
        '};'
        'option = {'
        '  grid: {'
        '    x: 50,'
        '    y: 10,'
        '    x2: 10,'
        '    y2: 20'
        '  },'
        '  tooltip: {'
        '    trigger: '#39'axis'#39','
        '    axisPointer: {'
        '      type: '#39'shadow'#39
        '    }'
        '  },'
        '  legend: {'
        '    data: this.value'
        '  },'
        '  toolbox: {'
        '    show: false'
        '  },'
        '  xAxis: ['
        '    {'
        '      type: '#39'category'#39','
        '      axisTick: { show: false },'
        '      data: this.value'
        '    }'
        '  ],'
        '  yAxis: ['
        '    {'
        '      type: '#39'value'#39
        '    }'
        '  ],'
        '  series: ['
        '    {'
        '      name: '#39#20986#24211#25968#37327#39','
        '      type: '#39'bar'#39','
        '      barGap: 0,'
        '      label: labelOption,'
        '      emphasis: {'
        '        focus: '#39'series'#39
        '      },'
        '      data: this.value0'
        '    },'
        '    {'
        '      name: '#39#20986#24211#37329#39069#39','
        '      type: '#39'bar'#39','
        '      label: labelOption,'
        '      emphasis: {'
        '        focus: '#39'series'#39
        '      },'
        '      data: this.value1'
        '    },'
        '    {'
        '      name: '#39#20837#24211#25968#37327#39','
        '      type: '#39'bar'#39','
        '      barGap: 0,'
        '      label: labelOption,'
        '      emphasis: {'
        '        focus: '#39'series'#39
        '      },'
        '      data: this.value2'
        '    },'
        '    {'
        '      name: '#39#20837#24211#37329#39069#39','
        '      type: '#39'bar'#39','
        '      label: labelOption,'
        '      emphasis: {'
        '        focus: '#39'series'#39
        '      },'
        '      data: this.value3'
        '    }'
        '  ]'
        '};')
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object FDQuery1: TFDQuery
    Left = 496
    Top = 24
  end
end
