object Form_DataV: TForm_DataV
  Left = 0
  Top = 0
  HelpType = htKeyword
  Margins.Top = 20
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = #25968#25454#30475#26495
  ClientHeight = 800
  ClientWidth = 1440
  Color = 3935232
  TransparentColorValue = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnMouseDown = FormMouseDown
  OnMouseUp = FormMouseUp
  TextHeight = 23
  object Panel_Full: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 1434
    Height = 794
    HelpKeyword = 'dvbox'
    HelpContext = 11
    Align = alClient
    Caption = #36808#21326#26234#24935#25968#25454#31995#32479
    Color = 3544832
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -17
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object Panel_Inner: TPanel
      AlignWithMargins = True
      Left = 21
      Top = 61
      Width = 1392
      Height = 712
      Margins.Left = 20
      Margins.Top = 60
      Margins.Right = 20
      Margins.Bottom = 20
      Align = alClient
      Caption = 'Panel_Inner'
      Color = clNone
      ParentBackground = False
      TabOrder = 0
      object Panel_L: TPanel
        AlignWithMargins = True
        Left = 11
        Top = 11
        Width = 400
        Height = 690
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alLeft
        Color = clNone
        ParentBackground = False
        TabOrder = 0
        object Panel7: TPanel
          AlignWithMargins = True
          Left = 21
          Top = 295
          Width = 358
          Height = 374
          HelpKeyword = 'dvbox'
          HelpContext = 10
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Margins.Bottom = 20
          Align = alClient
          Color = clNone
          ParentBackground = False
          TabOrder = 0
          object Memo3: TMemo
            AlignWithMargins = True
            Left = 21
            Top = 21
            Width = 316
            Height = 332
            HelpType = htKeyword
            HelpKeyword = 'echarts'
            Margins.Left = 20
            Margins.Top = 20
            Margins.Right = 20
            Margins.Bottom = 20
            Align = alClient
            Lines.Strings = (
              '{'
              
                '  color: ['#39'#80FFA5'#39', '#39'#00DDFF'#39', '#39'#37A2FF'#39', '#39'#FF0087'#39', '#39'#FFBF00'#39']' +
                ','
              '  title: {'
              '    text: '#39'Gradient Stacked Area Chart'#39
              '  },'
              '  tooltip: {'
              '    trigger: '#39'axis'#39','
              '    axisPointer: {'
              '      type: '#39'cross'#39','
              '      label: {'
              '        backgroundColor: '#39'#6a7985'#39
              '      }'
              '    }'
              '  },'
              '  legend: {'
              '    data: ['#39'Line 1'#39', '#39'Line 2'#39', '#39'Line 3'#39', '#39'Line 4'#39', '#39'Line 5'#39']'
              '  },'
              '  toolbox: {'
              '    feature: {'
              '      saveAsImage: {}'
              '    }'
              '  },'
              '  grid: {'
              '    left: '#39'3%'#39','
              '    right: '#39'4%'#39','
              '    bottom: '#39'3%'#39','
              '    containLabel: true'
              '  },'
              '  xAxis: ['
              '    {'
              '      type: '#39'category'#39','
              '      boundaryGap: false,'
              '      data: ['#39'Mon'#39', '#39'Tue'#39', '#39'Wed'#39', '#39'Thu'#39', '#39'Fri'#39', '#39'Sat'#39', '#39'Sun'#39']'
              '    }'
              '  ],'
              '  yAxis: ['
              '    {'
              '      type: '#39'value'#39
              '    }'
              '  ],'
              '  series: ['
              '    {'
              '      name: '#39'Line 1'#39','
              '      type: '#39'line'#39','
              '      stack: '#39'Total'#39','
              '      smooth: true,'
              '      lineStyle: {'
              '        width: 0'
              '      },'
              '      showSymbol: false,'
              '      areaStyle: {'
              '        opacity: 0.8,'
              '        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, ['
              '          {'
              '            offset: 0,'
              '            color: '#39'rgb(128, 255, 165)'#39
              '          },'
              '          {'
              '            offset: 1,'
              '            color: '#39'rgb(1, 191, 236)'#39
              '          }'
              '        ])'
              '      },'
              '      emphasis: {'
              '        focus: '#39'series'#39
              '      },'
              '      data: [140, 232, 101, 264, 90, 340, 250]'
              '    },'
              '    {'
              '      name: '#39'Line 2'#39','
              '      type: '#39'line'#39','
              '      stack: '#39'Total'#39','
              '      smooth: true,'
              '      lineStyle: {'
              '        width: 0'
              '      },'
              '      showSymbol: false,'
              '      areaStyle: {'
              '        opacity: 0.8,'
              '        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, ['
              '          {'
              '            offset: 0,'
              '            color: '#39'rgb(0, 221, 255)'#39
              '          },'
              '          {'
              '            offset: 1,'
              '            color: '#39'rgb(77, 119, 255)'#39
              '          }'
              '        ])'
              '      },'
              '      emphasis: {'
              '        focus: '#39'series'#39
              '      },'
              '      data: [120, 282, 111, 234, 220, 340, 310]'
              '    },'
              '    {'
              '      name: '#39'Line 3'#39','
              '      type: '#39'line'#39','
              '      stack: '#39'Total'#39','
              '      smooth: true,'
              '      lineStyle: {'
              '        width: 0'
              '      },'
              '      showSymbol: false,'
              '      areaStyle: {'
              '        opacity: 0.8,'
              '        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, ['
              '          {'
              '            offset: 0,'
              '            color: '#39'rgb(55, 162, 255)'#39
              '          },'
              '          {'
              '            offset: 1,'
              '            color: '#39'rgb(116, 21, 219)'#39
              '          }'
              '        ])'
              '      },'
              '      emphasis: {'
              '        focus: '#39'series'#39
              '      },'
              '      data: [320, 132, 201, 334, 190, 130, 220]'
              '    },'
              '    {'
              '      name: '#39'Line 4'#39','
              '      type: '#39'line'#39','
              '      stack: '#39'Total'#39','
              '      smooth: true,'
              '      lineStyle: {'
              '        width: 0'
              '      },'
              '      showSymbol: false,'
              '      areaStyle: {'
              '        opacity: 0.8,'
              '        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, ['
              '          {'
              '            offset: 0,'
              '            color: '#39'rgb(255, 0, 135)'#39
              '          },'
              '          {'
              '            offset: 1,'
              '            color: '#39'rgb(135, 0, 157)'#39
              '          }'
              '        ])'
              '      },'
              '      emphasis: {'
              '        focus: '#39'series'#39
              '      },'
              '      data: [220, 402, 231, 134, 190, 230, 120]'
              '    },'
              '    {'
              '      name: '#39'Line 5'#39','
              '      type: '#39'line'#39','
              '      stack: '#39'Total'#39','
              '      smooth: true,'
              '      lineStyle: {'
              '        width: 0'
              '      },'
              '      showSymbol: false,'
              '      label: {'
              '        show: true,'
              '        position: '#39'top'#39
              '      },'
              '      areaStyle: {'
              '        opacity: 0.8,'
              '        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, ['
              '          {'
              '            offset: 0,'
              '            color: '#39'rgb(255, 191, 0)'#39
              '          },'
              '          {'
              '            offset: 1,'
              '            color: '#39'rgb(224, 62, 76)'#39
              '          }'
              '        ])'
              '      },'
              '      emphasis: {'
              '        focus: '#39'series'#39
              '      },'
              '      data: [220, 302, 181, 234, 210, 290, 150]'
              '    }'
              '  ]'
              '}')
            ScrollBars = ssBoth
            TabOrder = 0
          end
        end
        object Panel1: TPanel
          AlignWithMargins = True
          Left = 21
          Top = 21
          Width = 358
          Height = 234
          HelpKeyword = 'dvbox'
          HelpContext = 12
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Margins.Bottom = 20
          Align = alTop
          Color = clNone
          ParentBackground = False
          TabOrder = 1
          object Label5: TLabel
            Left = 51
            Top = 30
            Width = 300
            Height = 30
            AutoSize = False
            Caption = #22312#29992#31995#32479#65306
            Font.Charset = ANSI_CHARSET
            Font.Color = clWhite
            Font.Height = -23
            Font.Name = #24494#36719#38597#40657
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label6: TLabel
            Left = 200
            Top = 22
            Width = 100
            Height = 46
            Alignment = taRightJustify
            AutoSize = False
            Caption = '321'
            Font.Charset = ANSI_CHARSET
            Font.Color = clLime
            Font.Height = -36
            Font.Name = #24494#36719#38597#40657
            Font.Style = [fsItalic]
            ParentFont = False
          end
          object Label7: TLabel
            Left = 51
            Top = 80
            Width = 300
            Height = 30
            AutoSize = False
            Caption = #22312#32447#29992#25143#65306
            Font.Charset = ANSI_CHARSET
            Font.Color = clWhite
            Font.Height = -23
            Font.Name = #24494#36719#38597#40657
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label8: TLabel
            Left = 51
            Top = 130
            Width = 300
            Height = 30
            AutoSize = False
            Caption = #37096#32626#24212#29992#65306
            Font.Charset = ANSI_CHARSET
            Font.Color = clWhite
            Font.Height = -23
            Font.Name = #24494#36719#38597#40657
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label9: TLabel
            Left = 51
            Top = 180
            Width = 300
            Height = 30
            AutoSize = False
            Caption = #20135#29983#25928#30410#65306
            Font.Charset = ANSI_CHARSET
            Font.Color = clWhite
            Font.Height = -23
            Font.Name = #24494#36719#38597#40657
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label10: TLabel
            Left = 200
            Top = 74
            Width = 100
            Height = 46
            Alignment = taRightJustify
            AutoSize = False
            Caption = '1,321'
            Font.Charset = ANSI_CHARSET
            Font.Color = clLime
            Font.Height = -36
            Font.Name = #24494#36719#38597#40657
            Font.Style = [fsItalic]
            ParentFont = False
          end
          object Label11: TLabel
            Left = 200
            Top = 126
            Width = 100
            Height = 46
            Alignment = taRightJustify
            AutoSize = False
            Caption = '321'
            Font.Charset = ANSI_CHARSET
            Font.Color = clLime
            Font.Height = -36
            Font.Name = #24494#36719#38597#40657
            Font.Style = [fsItalic]
            ParentFont = False
          end
          object Label12: TLabel
            Left = 200
            Top = 174
            Width = 100
            Height = 46
            Alignment = taRightJustify
            AutoSize = False
            Caption = '321'
            Font.Charset = ANSI_CHARSET
            Font.Color = clLime
            Font.Height = -36
            Font.Name = #24494#36719#38597#40657
            Font.Style = [fsItalic]
            ParentFont = False
          end
        end
      end
      object Panel_R: TPanel
        AlignWithMargins = True
        Left = 981
        Top = 11
        Width = 400
        Height = 690
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alRight
        Color = clNone
        ParentBackground = False
        TabOrder = 1
        object Panel2: TPanel
          AlignWithMargins = True
          Left = 21
          Top = 21
          Width = 358
          Height = 234
          HelpKeyword = 'dvbox'
          HelpContext = 12
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Margins.Bottom = 20
          Align = alTop
          Color = clNone
          ParentBackground = False
          TabOrder = 0
          object Label1: TLabel
            Left = 64
            Top = 30
            Width = 138
            Height = 31
            Caption = #26234#33021#31649#29702#31995#32479
            Font.Charset = ANSI_CHARSET
            Font.Color = clWhite
            Font.Height = -23
            Font.Name = #24494#36719#38597#40657
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label2: TLabel
            Left = 64
            Top = 80
            Width = 138
            Height = 31
            Caption = #25968#25454#30417#25511#35013#32622
            Font.Charset = ANSI_CHARSET
            Font.Color = clWhite
            Font.Height = -23
            Font.Name = #24494#36719#38597#40657
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label3: TLabel
            Left = 64
            Top = 130
            Width = 138
            Height = 31
            Caption = #25935#25463#21046#21160#35774#32622
            Font.Charset = ANSI_CHARSET
            Font.Color = clWhite
            Font.Height = -23
            Font.Name = #24494#36719#38597#40657
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label4: TLabel
            Left = 64
            Top = 180
            Width = 138
            Height = 31
            Caption = #24212#24613#22788#29702#24320#20851
            Font.Charset = ANSI_CHARSET
            Font.Color = clWhite
            Font.Height = -23
            Font.Name = #24494#36719#38597#40657
            Font.Style = [fsBold]
            ParentFont = False
          end
          object ToggleSwitch1: TToggleSwitch
            Left = 240
            Top = 27
            Width = 100
            Height = 40
            AutoSize = False
            DisabledColor = clActiveCaption
            StateCaptions.CaptionOn = ' '
            StateCaptions.CaptionOff = ' '
            TabOrder = 0
            ThumbColor = clLime
          end
          object ToggleSwitch2: TToggleSwitch
            Left = 240
            Top = 77
            Width = 100
            Height = 40
            AutoSize = False
            State = tssOn
            StateCaptions.CaptionOn = ' '
            StateCaptions.CaptionOff = ' '
            TabOrder = 1
            ThumbColor = clBlue
          end
          object ToggleSwitch3: TToggleSwitch
            Left = 240
            Top = 127
            Width = 100
            Height = 40
            AutoSize = False
            StateCaptions.CaptionOn = ' '
            StateCaptions.CaptionOff = ' '
            TabOrder = 2
            ThumbColor = clLime
          end
          object ToggleSwitch4: TToggleSwitch
            Left = 240
            Top = 177
            Width = 100
            Height = 40
            AutoSize = False
            State = tssOn
            StateCaptions.CaptionOn = ' '
            StateCaptions.CaptionOff = ' '
            TabOrder = 3
            ThumbColor = clLime
          end
        end
        object Panel3: TPanel
          AlignWithMargins = True
          Left = 21
          Top = 295
          Width = 358
          Height = 374
          HelpKeyword = 'dvbox'
          HelpContext = 10
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Margins.Bottom = 20
          Align = alClient
          Color = clNone
          ParentBackground = False
          TabOrder = 1
          object Memo2: TMemo
            AlignWithMargins = True
            Left = 21
            Top = 21
            Width = 316
            Height = 332
            HelpType = htKeyword
            HelpKeyword = 'echarts'
            Margins.Left = 20
            Margins.Top = 20
            Margins.Right = 20
            Margins.Bottom = 20
            Align = alClient
            Lines.Strings = (
              '{'
              '  tooltip: {'
              '    trigger: '#39'axis'#39','
              '    axisPointer: {'
              '      // Use axis to trigger tooltip'
              
                '      type: '#39'shadow'#39' // '#39'shadow'#39' as default; can also be '#39'line'#39' ' +
                'or '#39'shadow'#39
              '    }'
              '  },'
              '  legend: {},'
              '  grid: {'
              '    left: '#39'3%'#39','
              '    right: '#39'4%'#39','
              '    bottom: '#39'3%'#39','
              '    containLabel: true'
              '  },'
              '  xAxis: {'
              '    type: '#39'value'#39
              '  },'
              '  yAxis: {'
              '    type: '#39'category'#39','
              '    data: ['#39'Mon'#39', '#39'Tue'#39', '#39'Wed'#39', '#39'Thu'#39', '#39'Fri'#39', '#39'Sat'#39', '#39'Sun'#39']'
              '  },'
              '  series: ['
              '    {'
              '      name: '#39'Direct'#39','
              '      type: '#39'bar'#39','
              '      stack: '#39'total'#39','
              '      label: {'
              '        show: true'
              '      },'
              '      emphasis: {'
              '        focus: '#39'series'#39
              '      },'
              '      data: [320, 302, 301, 334, 390, 330, 320]'
              '    },'
              '    {'
              '      name: '#39'Mail Ad'#39','
              '      type: '#39'bar'#39','
              '      stack: '#39'total'#39','
              '      label: {'
              '        show: true'
              '      },'
              '      emphasis: {'
              '        focus: '#39'series'#39
              '      },'
              '      data: [120, 132, 101, 134, 90, 230, 210]'
              '    },'
              '    {'
              '      name: '#39'Affiliate Ad'#39','
              '      type: '#39'bar'#39','
              '      stack: '#39'total'#39','
              '      label: {'
              '        show: true'
              '      },'
              '      emphasis: {'
              '        focus: '#39'series'#39
              '      },'
              '      data: [220, 182, 191, 234, 290, 330, 310]'
              '    },'
              '    {'
              '      name: '#39'Video Ad'#39','
              '      type: '#39'bar'#39','
              '      stack: '#39'total'#39','
              '      label: {'
              '        show: true'
              '      },'
              '      emphasis: {'
              '        focus: '#39'series'#39
              '      },'
              '      data: [150, 212, 201, 154, 190, 330, 410]'
              '    },'
              '    {'
              '      name: '#39'Search Engine'#39','
              '      type: '#39'bar'#39','
              '      stack: '#39'total'#39','
              '      label: {'
              '        show: true'
              '      },'
              '      emphasis: {'
              '        focus: '#39'series'#39
              '      },'
              '      data: [820, 832, 901, 934, 1290, 1330, 1320]'
              '    }'
              '  ]'
              '}')
            ScrollBars = ssBoth
            TabOrder = 0
          end
        end
      end
      object Panel_C: TPanel
        AlignWithMargins = True
        Left = 431
        Top = 11
        Width = 530
        Height = 690
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alClient
        Color = clNone
        ParentBackground = False
        TabOrder = 2
        object Memo1: TMemo
          AlignWithMargins = True
          Left = 21
          Top = 61
          Width = 488
          Height = 517
          HelpType = htKeyword
          HelpKeyword = 'dvflyline'
          Margins.Left = 20
          Margins.Top = 60
          Margins.Right = 20
          Margins.Bottom = 20
          Align = alClient
          Lines.Strings = (
            '{'
            '  points: ['
            '    {'
            '      name: '#39#35140#38451#39','
            '      coordinate: '
            '[0.48, 0.35],'
            '      halo: {'
            '        show: true,'
            '      },'
            '      icon: {'
            '        src: '#39'media/images/datav/mapCenterPoint.png'#39','
            '        width: 30,'
            '        height: 30'
            '      },'
            '      text: {'
            '        show: false'
            '      }'
            '    },'
            '    {'
            '      name: '#39#26032#20065#39','
            '      coordinate: [0.52, 0.23]'
            '    },'
            '    {'
            '      name: '#39#28966#20316#39','
            '      coordinate: '
            '[0.43, 0.29]'
            '    },'
            '    {'
            '      name: '#39#24320#23553#39','
            '      coordinate: '
            '[0.59, 0.35]'
            '    },'
            '    {'
            '      name: '#39#35768#26124#39','
            '      coordinate: '
            '[0.53, 0.47]'
            '    },'
            '    {'
            '      name: '#39#24179#39030#23665#39','
            '      coordinate: '
            '[0.45, 0.54]'
            '    },'
            '    {'
            '      name: '#39#27931#38451#39','
            '      coordinate: '
            '[0.36, 0.38]'
            '    },'
            '    {'
            '      name: '#39#21608#21475#39','
            '      coordinate: '
            '[0.62, 0.55],'
            '      halo: {'
            '        show: true,'
            '        color: '
            #39'#8378ea'#39
            '      }'
            '    },'
            '    {'
            '      name: '#39#28463#27827#39','
            '      coordinate: '
            '[0.56, 0.56]'
            '    },'
            '    {'
            '      name: '#39#21335#38451#39','
            '      coordinate: '
            '[0.37, 0.66],'
            '      halo: {'
            '        show: true,'
            '        color: '
            #39'#37a2da'#39
            '      }'
            '    },'
            '    {'
            '      name: '#39#20449#38451#39','
            '      coordinate: '
            '[0.55, 0.81]'
            '    },'
            '    {'
            '      name: '#39#39547#39532#24215#39','
            '      coordinate: '
            '[0.55, 0.67]'
            '    },'
            '    {'
            '      name: '#39#27982#28304#39','
            '      coordinate: '
            '[0.37, 0.29]'
            '    },'
            '    {'
            '      name: '#39#19977#38376#23777#39','
            '      coordinate: '
            '[0.20, 0.36]'
            '    },'
            '    {'
            '      name: '#39#21830#19992#39','
            '      coordinate: '
            '[0.76, 0.41]'
            '    },'
            '    {'
            '      name: '#39#40548#22721#39','
            '      coordinate: '
            '[0.59, 0.18]'
            '    },'
            '    {'
            '      name: '#39#28654#38451#39','
            '      coordinate: '
            '[0.68, 0.17]'
            '    },'
            '    {'
            '      name: '#39#23433#38451#39','
            '      coordinate: '
            '[0.59, 0.10]'
            '    }'
            '  ],'
            '  lines: ['
            '    {'
            '      source: '#39#26032#20065#39','
            '      target: '#39#35140#38451#39
            '    },'
            '    {'
            '      source: '#39#28966#20316#39','
            '      target: '#39#35140#38451#39
            '    },'
            '    {'
            '      source: '#39#24320#23553#39','
            '      target: '#39#35140#38451#39
            '    },'
            '    {'
            '      source: '#39#21608#21475#39','
            '      target: '#39#35140#38451#39','
            '      color: '
            #39'#fb7293'#39','
            '      width: 2'
            '    },'
            '    {'
            '      source: '#39#21335#38451#39','
            '      target: '#39#35140#38451#39','
            '      color: '
            #39'#fb7293'#39','
            '      width: 2'
            '    },'
            '    {'
            '      source: '#39#27982#28304#39','
            '      target: '#39#35140#38451#39
            '    },'
            '    {'
            '      source: '#39#19977#38376#23777#39','
            '      target: '#39#35140#38451#39
            '    },'
            '    {'
            '      source: '#39#21830#19992#39','
            '      target: '#39#35140#38451#39
            '    },'
            '    {'
            '      source: '#39#40548#22721#39','
            '      target: '#39#35140#38451#39
            '    },'
            '    {'
            '      source: '#39#28654#38451#39','
            '      target: '#39#35140#38451#39
            '    },'
            '    {'
            '      source: '#39#23433#38451#39','
            '      target: '#39#35140#38451#39
            '    },'
            '    {'
            '      source: '#39#35768#26124#39','
            '      target: '#39#21335#38451#39','
            '      color: '
            #39'#37a2da'#39
            '    },'
            '    {'
            '      source: '#39#24179#39030#23665#39','
            '      target: '#39#21335#38451#39','
            '      color: '
            #39'#37a2da'#39
            '    },'
            '    {'
            '      source: '#39#27931#38451#39','
            '      target: '#39#21335#38451#39','
            '      color: '
            #39'#37a2da'#39
            '    },'
            '    {'
            '      source: '#39#39547#39532#24215#39','
            '      target: '#39#21608#21475#39','
            '      color: '
            #39'#8378ea'#39
            '    },'
            '    {'
            '      source: '#39#20449#38451#39','
            '      target: '#39#21608#21475#39','
            '      color: '
            #39'#8378ea'#39
            '    },'
            '    {'
            '      source: '#39#28463#27827#39','
            '      target: '#39#21608#21475#39','
            '      color: '
            #39'#8378ea'#39
            '    }'
            '  ],'
            '  icon: {'
            '    show: true,'
            '    src: '
            #39'media/images/datav/mapPoint.png'#39
            '  },'
            '  text: {'
            '    show: true,'
            '  },'
            '  k: 0.5,'
            '  bgImgSrc: '
            #39'media/images/datav/map.jpg'#39
            '}')
          ScrollBars = ssBoth
          TabOrder = 0
        end
        object ProgressBar2: TProgressBar
          AlignWithMargins = True
          Left = 31
          Top = 608
          Width = 468
          Height = 78
          HelpType = htKeyword
          HelpKeyword = 'dvpond'
          Margins.Left = 30
          Margins.Top = 10
          Margins.Right = 30
          Align = alBottom
          Position = 75
          TabOrder = 1
        end
      end
    end
  end
end
