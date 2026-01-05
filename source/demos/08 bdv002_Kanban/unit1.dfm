object Form1: TForm1
  Left = 0
  Top = 0
  HelpType = htKeyword
  Margins.Top = 20
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'DeWeb DataView 002'
  ClientHeight = 800
  ClientWidth = 1440
  Color = 6238733
  TransparentColorValue = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = 15852561
  Font.Height = -17
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  OnMouseUp = FormMouseUp
  TextHeight = 23
  object P_2: TPanel
    AlignWithMargins = True
    Left = 1140
    Top = 3
    Width = 300
    Height = 794
    HelpType = htKeyword
    Margins.Right = 0
    Align = alRight
    BevelOuter = bvNone
    Color = 5581581
    ParentBackground = False
    TabOrder = 0
    object Label25: TLabel
      Left = 0
      Top = 0
      Width = 300
      Height = 70
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 5
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = '2023'#24180'05'#26376'10'#26085' 18'#26102'48'#20998'26'#31186' '#26143#26399#19977
      Color = 6238733
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -17
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object Panel1: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 73
      Width = 294
      Height = 200
      Align = alTop
      Color = clNone
      ParentBackground = False
      TabOrder = 0
      object Panel3: TPanel
        AlignWithMargins = True
        Left = 11
        Top = 1
        Width = 212
        Height = 20
        Hint = '{"dwstyle":"border-left:Solid 6px #19CA88;"}'
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 70
        Align = alTop
        Alignment = taLeftJustify
        Color = clNone
        Font.Charset = ANSI_CHARSET
        Font.Color = clNone
        Font.Height = -17
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
        object Label6: TLabel
          AlignWithMargins = True
          Left = 11
          Top = 1
          Width = 200
          Height = 16
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 2
          Align = alClient
          Caption = #27700#36136#27745#26579#25490#34892#27036
          Color = 13924904
          Font.Charset = ANSI_CHARSET
          Font.Color = 15852561
          Font.Height = -17
          Font.Name = #24494#36719#38597#40657
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          Layout = tlCenter
          ExplicitWidth = 119
          ExplicitHeight = 23
        end
      end
      object StringGrid1: TStringGrid
        AlignWithMargins = True
        Left = 1
        Top = 34
        Width = 292
        Height = 165
        HelpType = htKeyword
        HelpKeyword = 'dvscroll'
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        ColCount = 4
        RowCount = 10
        FixedRows = 0
        TabOrder = 1
        RowHeights = (
          24
          24
          24
          24
          24
          24
          24
          24
          24
          24)
      end
    end
    object Panel4: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 279
      Width = 294
      Height = 200
      Align = alTop
      Color = clNone
      ParentBackground = False
      TabOrder = 1
      object Panel6: TPanel
        AlignWithMargins = True
        Left = 11
        Top = 1
        Width = 212
        Height = 20
        Hint = '{"dwstyle":"border-left:Solid 6px #19CA88;"}'
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 70
        Align = alTop
        Alignment = taLeftJustify
        Color = clNone
        Font.Charset = ANSI_CHARSET
        Font.Color = clNone
        Font.Height = -17
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
        object Label7: TLabel
          AlignWithMargins = True
          Left = 11
          Top = 1
          Width = 200
          Height = 16
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 2
          Align = alClient
          Caption = #27700#36136#31867#21035#21344#27604
          Color = 13924904
          Font.Charset = ANSI_CHARSET
          Font.Color = 15852561
          Font.Height = -17
          Font.Name = #24494#36719#38597#40657
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          Layout = tlCenter
          ExplicitWidth = 102
          ExplicitHeight = 23
        end
      end
      object Memo7: TMemo
        AlignWithMargins = True
        Left = 4
        Top = 24
        Width = 143
        Height = 172
        HelpType = htKeyword
        HelpKeyword = 'echarts'
        Margins.Top = 0
        Align = alLeft
        ImeName = '123'
        Lines.Strings = (
          'option = {'
          '  tooltip: {'
          '    trigger: '#39'item'#39
          '  },'
          '  graphic: ['
          '    {'
          '      //'#29615#24418#22270#20013#38388#28155#21152#25991#23383
          '      type: '#39'text'#39', //'#36890#36807#19981#21516'top'#20540#21487#20197#35774#32622#19978#19979#26174#31034
          '      left: '#39'center'#39','
          '      top: '#39'40%'#39','
          '      style: {'
          '        text: '#39#39278#29992#27700#36136#39' + '#39'\n'#39' + '#39'25'#20010#39'+ '#39'\n'#39' + '#39#22686#21152'2%'#39','
          '        textAlign: '#39'center'#39','
          '        fill: '#39'#eee'#39', //'#25991#23383#30340#39068#33394
          '        width: 30,'
          '        height: 30,'
          '        fontSize: 12,'
          '        fontFamily: '#39'Microsoft YaHei'#39
          '      }'
          '    }'
          '  ],'
          ''
          '  series: ['
          '    {'
          '      name: '#39#39278#29992#27700#36136#39','
          '      type: '#39'pie'#39','
          '      radius: ['#39'55%'#39', '#39'80%'#39'],'
          '      avoidLabelOverlap: false,'
          '      itemStyle: {'
          '        borderRadius: 0,'
          '        borderColor: '#39'#eee'#39','
          '        borderWidth: 1'
          '      },'
          '      label: {'
          '        show: false,'
          '        position: '#39'center'#39
          '      },'
          '      labelLine: {'
          '        show: true'
          '      },'
          '      data: [{ value: 1048 }, { value: 300 }]'
          '    }'
          '  ]'
          '};')
        ScrollBars = ssBoth
        TabOrder = 1
      end
      object Memo8: TMemo
        AlignWithMargins = True
        Left = 153
        Top = 24
        Width = 137
        Height = 172
        HelpType = htKeyword
        HelpKeyword = 'echarts'
        Margins.Top = 0
        Align = alClient
        ImeName = '123'
        Lines.Strings = (
          'option = {'
          '  tooltip: {'
          '    trigger: '#39'item'#39
          '  },'
          '  graphic: ['
          '    {'
          '      //'#29615#24418#22270#20013#38388#28155#21152#25991#23383
          '      type: '#39'text'#39', //'#36890#36807#19981#21516'top'#20540#21487#20197#35774#32622#19978#19979#26174#31034
          '      left: '#39'center'#39','
          '      top: '#39'40%'#39','
          '      style: {'
          '        text: '#39#29983#27963#29992#27700#39' + '#39'\n'#39' + '#39'50'#20010#39'+ '#39'\n'#39' + '#39#22686#21152'8%'#39','
          '        textAlign: '#39'center'#39','
          '        fill: '#39'#eee'#39', //'#25991#23383#30340#39068#33394
          '        width: 30,'
          '        height: 30,'
          '        fontSize: 12,'
          '        fontFamily: '#39'Microsoft YaHei'#39
          '      }'
          '    }'
          '  ],'
          ''
          '  series: ['
          '    {'
          '      name: '#39#29983#27963#29992#27700#39','
          '      type: '#39'pie'#39','
          '      radius: ['#39'55%'#39', '#39'80%'#39'],'
          '      avoidLabelOverlap: false,'
          '      itemStyle: {'
          '        borderRadius: 0,'
          '        borderColor: '#39'#eee'#39','
          '        borderWidth: 1'
          '      },'
          '      label: {'
          '        show: false,'
          '        position: '#39'center'#39
          '      },'
          '      labelLine: {'
          '        show: true'
          '      },'
          '      data: [{ value: 548 }, { value: 300 }]'
          '    }'
          '  ]'
          '};')
        ScrollBars = ssBoth
        TabOrder = 2
      end
    end
    object Panel7: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 485
      Width = 294
      Height = 306
      Align = alClient
      Color = clNone
      ParentBackground = False
      TabOrder = 2
      object Panel8: TPanel
        AlignWithMargins = True
        Left = 11
        Top = 1
        Width = 212
        Height = 20
        Hint = '{"dwstyle":"border-left:Solid 6px #19CA88;"}'
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 70
        Align = alTop
        Alignment = taLeftJustify
        Color = clNone
        Font.Charset = ANSI_CHARSET
        Font.Color = clNone
        Font.Height = -17
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
        object Label8: TLabel
          AlignWithMargins = True
          Left = 11
          Top = 1
          Width = 200
          Height = 16
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 2
          Align = alClient
          Caption = #20027#35201#22320#21306#27700#27969#37327
          Color = 13924904
          Font.Charset = ANSI_CHARSET
          Font.Color = 15852561
          Font.Height = -17
          Font.Name = #24494#36719#38597#40657
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          Layout = tlCenter
          ExplicitWidth = 119
          ExplicitHeight = 23
        end
      end
      object Memo10: TMemo
        AlignWithMargins = True
        Left = 4
        Top = 34
        Width = 286
        Height = 268
        HelpType = htKeyword
        HelpKeyword = 'echarts'
        Margins.Top = 10
        Align = alClient
        ImeName = '123'
        Lines.Strings = (
          'option = {'
          '  tooltip: {'
          '    trigger: '#39'axis'#39
          '  },'
          '  legend: {'
          '    data: ['#39#19978#28216#27969#36895#39', '#39#19979#28216#27969#36895#39', '#39#24179#22343#27969#36895#39'],'
          '    textStyle: {'
          '      fontSize: 12,'
          '      color: '#39'#eee'#39
          '    }'
          '  },'
          '  grid: {'
          '    left: '#39'35px'#39','
          '    right: '#39'20px'#39','
          '    bottom: '#39'20px'#39','
          '    containLabel: false'
          '  },'
          '  xAxis: {'
          '    type: '#39'category'#39','
          '    boundaryGap: false,'
          '    axisLine: { show: true },'
          
            '    data: ['#39'2016'#39', '#39'2017'#39', '#39'2018'#39', '#39'2019'#39', '#39'2020'#39', '#39'2021'#39', '#39'2022' +
            #39']'
          '  },'
          '  yAxis: {'
          '    axisLine: { show: true },'
          '    splitLine: { show: false },'
          '    type: '#39'value'#39
          '  },'
          '  series: ['
          '    {'
          '      name: '#39#19978#28216#27969#36895#39','
          '      type: '#39'line'#39','
          '      smooth: true,'
          '      data: [120, 132, 161, 134, 90, 230, 210]'
          '    },'
          '    {'
          '      name: '#39#19979#28216#27969#36895#39','
          '      type: '#39'line'#39','
          '      smooth: true,'
          '      data: [200, 212, 191, 234, 260, 280, 275]'
          '    },'
          '    {'
          '      name: '#39#24179#22343#27969#36895#39','
          '      type: '#39'line'#39','
          '      smooth: true,'
          '      data: [140, 132, 91, 100, 190, 130, 120]'
          '    }'
          '  ]'
          '};')
        ScrollBars = ssBoth
        TabOrder = 1
      end
    end
  end
  object P_1: TPanel
    AlignWithMargins = True
    Left = 306
    Top = 3
    Width = 828
    Height = 794
    Align = alClient
    Color = clNone
    ParentBackground = False
    TabOrder = 1
    object Memo1: TMemo
      AlignWithMargins = True
      Left = 4
      Top = 21
      Width = 820
      Height = 772
      Hint = '{"geojson":"media/geojson/100000_full.json"}'
      HelpType = htKeyword
      HelpKeyword = 'echartsmap'
      Margins.Top = 20
      Margins.Bottom = 0
      Align = alClient
      ImeName = '123'
      Lines.Strings = (
        'option = {'
        '    grid: {'
        '        left: '#39'10%'#39','
        '        right: '#39'10%'#39','
        '        bottom: '#39'15%'#39','
        '        top: '#39'15%'#39','
        '        containLabel: true'
        '    },'
        #9'series:['
        #9#9'{'
        #9#9#9'name:'#39#28216#23458#25968#37327#39','
        #9#9#9'type:'#39'map'#39','
        #9#9#9'map:'#39'MAP'#39','
        #9#9#9'label: {show: false},'
        #9#9#9'itemStyle: {'
        #9#9#9#9'normal: {'
        #9#9#9#9#9'borderWidth: 0,//'#36793#38469#32447#22823#23567
        #9#9#9#9#9'borderColor:'#39'#00ffff'#39',//'#36793#30028#32447#39068#33394
        #9#9#9#9#9'areaColor:'#39'#1A5196'#39'//'#40664#35748#21306#22495#39068#33394
        #9#9#9#9'},'
        #9#9#9#9'emphasis: {'
        #9#9#9#9#9'show: true,'
        #9#9#9#9#9'areaColor: '#39'#02102B'#39',//'#40736#26631#28369#36807#21306#22495#39068#33394
        #9#9#9#9#9'label: {'
        #9#9#9#9#9#9'show: true,'
        #9#9#9#9#9#9'textStyle: {'
        #9#9#9#9#9#9#9'color: '#39'#fff'#39
        #9#9#9#9#9#9'}'
        #9#9#9#9#9'}'
        #9#9#9#9'}'
        ''
        #9#9#9'},'
        #9#9'}'
        #9'],'
        #9
        '};')
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object Memo2: TMemo
      AlignWithMargins = True
      Left = 4
      Top = 1
      Width = 820
      Height = 772
      Hint = '{"geojson":"media/geojson/100000_full.json"}'
      HelpType = htKeyword
      HelpKeyword = 'echartsmap'
      Margins.Top = 0
      Margins.Bottom = 20
      Align = alClient
      ImeName = '123'
      Lines.Strings = (
        'option = {'
        '  grid: {'
        '    left: '#39'10%'#39','
        '    right: '#39'10%'#39','
        '    bottom: '#39'15%'#39','
        '    top: '#39'15%'#39','
        '    containLabel: true'
        '  },'
        '  series: ['
        '    {'
        '      name: '#39#28216#23458#25968#37327#39','
        '      type: '#39'map'#39','
        '      map: '#39'MAP'#39','
        '      label: { show: false },'
        '      itemStyle: {'
        '        normal: {'
        '          borderWidth: 2, //'#36793#38469#32447#22823#23567
        '          borderColor: '#39'#00ffff'#39', //'#36793#30028#32447#39068#33394
        '          areaColor: '#39'#0C274B'#39' //'#40664#35748#21306#22495#39068#33394
        '        },'
        '        emphasis: {'
        '          show: true,'
        '          areaColor: '#39'#02102B'#39', //'#40736#26631#28369#36807#21306#22495#39068#33394
        '          label: {'
        '            show: true,'
        '            textStyle: {'
        '              color: '#39'#fff'#39
        '            }'
        '          }'
        '        }'
        '      }'
        '    }'
        '  ]'
        '};'
        '')
      ScrollBars = ssBoth
      TabOrder = 1
    end
  end
  object P_0: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 3
    Width = 300
    Height = 794
    HelpType = htKeyword
    Margins.Left = 0
    Align = alLeft
    BevelOuter = bvNone
    Color = 5581581
    ParentBackground = False
    TabOrder = 2
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 300
      Height = 70
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #27700#36136#23454#26102#30417#27979#39044#35686#31995#32479
      Color = 6238733
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -28
      Font.Name = #24494#36719#38597#40657
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object P_00: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 73
      Width = 294
      Height = 168
      Align = alTop
      Color = clNone
      ParentBackground = False
      TabOrder = 0
      object P_000: TPanel
        AlignWithMargins = True
        Left = 11
        Top = 1
        Width = 212
        Height = 20
        Hint = '{"dwstyle":"border-left:Solid 6px #19CA88;"}'
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 70
        Align = alTop
        Alignment = taLeftJustify
        Color = clNone
        Font.Charset = ANSI_CHARSET
        Font.Color = clNone
        Font.Height = -17
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
        object Label37: TLabel
          AlignWithMargins = True
          Left = 11
          Top = 1
          Width = 200
          Height = 16
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 2
          Align = alClient
          Caption = #37325#28857#27700#36136#37327#26816#27979#21306
          Color = 13924904
          Font.Charset = ANSI_CHARSET
          Font.Color = 15852561
          Font.Height = -17
          Font.Name = #24494#36719#38597#40657
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          Layout = tlCenter
          ExplicitWidth = 136
          ExplicitHeight = 23
        end
      end
      object P_001: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 24
        Width = 140
        Height = 143
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alLeft
        Color = clNone
        ParentBackground = False
        TabOrder = 1
        object L_302: TLabel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 132
          Height = 19
          Align = alTop
          Caption = #27969#27700#37327
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -13
          Font.Name = #24494#36719#38597#40657
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          ExplicitWidth = 39
        end
        object Label2: TLabel
          AlignWithMargins = True
          Left = 4
          Top = 29
          Width = 132
          Height = 40
          Hint = '{"dwstyle":"white-space:nowrap;overflow:hidden;"}'
          Align = alTop
          AutoSize = False
          Caption = '<font size="6">1756</font>m<sup>3</sup>/h'
          Font.Charset = ANSI_CHARSET
          Font.Color = 15836202
          Font.Height = -17
          Font.Name = #24494#36719#38597#40657
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Memo3: TMemo
          AlignWithMargins = True
          Left = 4
          Top = 72
          Width = 132
          Height = 67
          HelpType = htKeyword
          HelpKeyword = 'echarts'
          Margins.Top = 0
          Align = alClient
          ImeName = '123'
          Lines.Strings = (
            'option = {'
            '    grid: {'
            '        left: '#39'0%'#39','
            '        right: '#39'0%'#39','
            '        bottom: '#39'0%'#39','
            '        top: '#39'0%'#39
            '    },'
            '  xAxis: {'
            '    type: '#39'category'#39','
            '    splitLine : {show:false},'
            '    axisLine : {show:false},'
            '    axisLabel : {show:false},'
            '    axisTick : {show:false},'
            '    boundaryGap: false'
            '  },'
            '  yAxis: {'
            '    splitLine : {show:false},'
            '    axisLine : {show:false},'
            '    axisLabel : {show:false},'
            '    axisTick : {show:false},'
            '    type: '#39'value'#39
            '  },'
            '  series: ['
            '    {'
            '      data: [20, 32, 61, 14, 59, 43, 72, 82, 21, 14, '
            '      19, 13, 32, 41, 24, 59, 43, 72, 52, 21, 14, '
            '      19, 13, 32, 14, 39, 23],'
            '      type: '#39'line'#39','
            '      symbol: '#39'none'#39','
            '      itemStyle: {'
            '        color: '#39'#22847B'#39
            '      },'
            '      areaStyle: {'
            '        color: '#39'#22847B'#39
            '      }'
            '    }'
            '  ]'
            '};')
          ScrollBars = ssBoth
          TabOrder = 0
        end
      end
      object P_002: TPanel
        AlignWithMargins = True
        Left = 156
        Top = 24
        Width = 127
        Height = 143
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alClient
        Color = clNone
        ParentBackground = False
        TabOrder = 2
        object L_300: TLabel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 119
          Height = 19
          Align = alTop
          Caption = #27844#27700#37327
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -13
          Font.Name = #24494#36719#38597#40657
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          ExplicitWidth = 39
        end
        object Label3: TLabel
          AlignWithMargins = True
          Left = 4
          Top = 29
          Width = 119
          Height = 40
          Hint = '{"dwstyle":"white-space:nowrap;overflow:hidden;"}'
          Align = alTop
          AutoSize = False
          Caption = '<font size="6">2138</font>m<sup>3</sup>/h'
          Font.Charset = ANSI_CHARSET
          Font.Color = 15836202
          Font.Height = -17
          Font.Name = #24494#36719#38597#40657
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitLeft = 8
          ExplicitTop = 37
          ExplicitWidth = 114
        end
        object Memo4: TMemo
          AlignWithMargins = True
          Left = 4
          Top = 72
          Width = 119
          Height = 67
          HelpType = htKeyword
          HelpKeyword = 'echarts'
          Margins.Top = 0
          Align = alClient
          ImeName = '123'
          Lines.Strings = (
            'option = {'
            '    grid: {'
            '        left: '#39'0%'#39','
            '        right: '#39'0%'#39','
            '        bottom: '#39'0%'#39','
            '        top: '#39'0%'#39
            '    },'
            '  xAxis: {'
            '    type: '#39'category'#39','
            '    splitLine : {show:false},'
            '    axisLine : {show:false},'
            '    axisLabel : {show:false},'
            '    axisTick : {show:false},'
            '    boundaryGap: false'
            '  },'
            '  yAxis: {'
            '    splitLine : {show:false},'
            '    axisLine : {show:false},'
            '    axisLabel : {show:false},'
            '    axisTick : {show:false},'
            '    type: '#39'value'#39
            '  },'
            '  series: ['
            '    {'
            '      data: [14, 19, 13, 32, 41, 20, 32, 41, '
            
              '      24, 50, 43, 12, 15, 32, 14, 32, 52, 51, 21, 14, 54, 49, 52' +
              ', 52, 23, 14, '
            '      23],'
            '      type: '#39'line'#39','
            '      symbol: '#39'none'#39','
            '      itemStyle: {'
            '        color: '#39'#22847B'#39
            '      },'
            '      areaStyle: {'
            '        color: '#39'#22847B'#39
            '      }'
            '    }'
            '  ]'
            '};')
          ScrollBars = ssBoth
          TabOrder = 0
        end
      end
    end
    object P_02: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 252
      Width = 294
      Height = 340
      Align = alTop
      Color = clNone
      ParentBackground = False
      TabOrder = 1
      object Panel2: TPanel
        AlignWithMargins = True
        Left = 11
        Top = 1
        Width = 212
        Height = 20
        Hint = '{"dwstyle":"border-left:Solid 6px #19CA88;"}'
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 70
        Align = alTop
        Alignment = taLeftJustify
        Color = clNone
        Font.Charset = ANSI_CHARSET
        Font.Color = clNone
        Font.Height = -17
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
        object Label4: TLabel
          AlignWithMargins = True
          Left = 11
          Top = 1
          Width = 200
          Height = 16
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 2
          Align = alClient
          Caption = #27700#36136#37327#20998#24067#24773#20917
          Color = 13924904
          Font.Charset = ANSI_CHARSET
          Font.Color = 15852561
          Font.Height = -17
          Font.Name = #24494#36719#38597#40657
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          Layout = tlCenter
          ExplicitWidth = 119
          ExplicitHeight = 23
        end
      end
      object Memo5: TMemo
        AlignWithMargins = True
        Left = 4
        Top = 24
        Width = 286
        Height = 312
        HelpType = htKeyword
        HelpKeyword = 'echarts'
        Margins.Top = 0
        Align = alClient
        ImeName = '123'
        Lines.Strings = (
          'option = {'
          '   // '#22270#20363
          '   "legend": {'
          '      "show": true,'
          '      "bottom": 8,'
          '      "left": "center",'
          '      "icon": "circle",'
          '      "data": ['
          '         { "name": "2021" },'
          '         { "name": "2022" },'
          '         { "name": "2023" }'
          '      ],'
          '      textStyle:{'
          '         color: '#39'#eee'#39'//'#23383#20307#39068#33394
          '      },'
          '      "selectedMode": false'
          '   },'
          '   "tooltip": {},'
          '   "color": ['
          '      "rgba(255, 41, 55, 0.83)", '
          '       "rgba(31, 255, 08, 0.83)",'
          '       "rgba(71, 141, 255, 0.83)" '
          '      ],'
          '   "radar": ['
          '      {'
          '         "shape": "radar",'
          '         "radius": "65%",'
          '         // '#38647#36798#22270#25351#26631#21517#31216#65292#29992'%'#25340#25509#65292#20998#21106#20351#29992
          '         "indicator": ['
          '            { "name": "'#35199#23433'" },'
          '            { "name": "'#21271#20140'" },'
          '            { "name": "'#19978#28023'" },'
          '            { "name": "'#24191#24030'" },'
          '            { "name": "'#28145#22323'" }'
          '         ],'
          '         "splitArea": {'
          '            "areaStyle": {'
          '               "color": ['
          '                  "#aaa", '
          '               "#888", '
          '               "#666", '
          '               "#444", "#222"]'
          '            }'
          '         },'
          '         "splitLine": {'
          '            "lineStyle": {'
          '               "color": "#969696",'
          '               "type": "dotted",'
          '               "width": 2'
          '            }'
          '         },'
          '         "axisLine": {'
          '            "lineStyle": {'
          '               "color": "#9EC3FF"'
          '            }'
          '         },'
          '         "axisName": {'
          '            "show": true,'
          '            '
          '             "color": "#eee"'
          '         }'
          '      },'
          '      {'
          '         "shape": "radar",'
          '         "radius": "65%",'
          '         "indicator": ['
          '            { "name": "'#35199#23433'" },'
          '            { "name": "'#21271#20140'" },'
          '            { "name": "'#19978#28023'" },'
          '            { "name": "'#24191#24030'" },'
          '            { "name": "'#28145#22323'" }'
          '         ],'
          '         "axisLine": {'
          '            "lineStyle": {'
          '               "color": "transparent"'
          '            }'
          '         }'
          '      }'
          '   ],'
          '   "series": ['
          '      {'
          '         "name": "'#26174#31034#22270#24418'",'
          '         "type": "radar",'
          '         "radarIndex": 0,'
          '         "tooltip": {'
          '            "show": false'
          '         },'
          '         "areaStyle": {'
          '            "opacity": 0.5'
          '         },'
          '         "itemStyle": {'
          '            "borderColor": "#fff",'
          '            "borderWidth": 1'
          '         },'
          '         "label": {'
          '            "show": false'
          '         },'
          '         "data": ['
          '            {'
          
            '               "value": [ "13.42", "33.94", "15.68", "18.12", "1' +
            '7.83"],'
          '               "name": "2021"'
          '            },'
          '            {'
          
            '               "value": [ "23.42", "30.94", "10.68", "22.12", "1' +
            '2.83"],'
          '               "name": "2022"'
          '            },'
          '            {'
          
            '               "value": [ "48.57", "13.31", "3.14", "14.07", "20' +
            '.92"],'
          '               "name": "2023"'
          '            }'
          '         ]'
          '      },'
          '      {'
          '         "name": "'#26174#31034#25552#31034'",'
          '         "type": "radar",'
          '         "symbol": "none",'
          '         "lineStyle": {'
          '            "color": "transparent"'
          '         },'
          '         "radarIndex": 1,'
          '         "zlevel": 2,'
          '         "tooltip": {'
          '            show: true,'
          
            '            // '#33258#23450#20041#26174#31034'x'#36724#25552#31034#65292#20027#35201#22312#31532#20108#20010#38647#36798#22270#20013#23454#29616#65292'echarts'#23448#26041'tootips'#35774#32622'trigger'#65306 +
            'axis'#19981#29983#25928#12290
          '            formatter: (params) => {'
          '               let { data } = params.data;'
          
            '               return `${params.name}<br />'#39033#30446#25968#65306' ${data[0]}'#20010'<br /' +
            '>'#25237#36164#39069#65306' ${data[1]}'#20803'<br/>`;'
          '            }'
          '         },'
          '         "data": ['
          '            {'
          '               "value": [100, 0, 0, 0, 0],'
          '               "data": [ 2335, 54602.95],'
          '                "name": "'#35199#23433'"'
          '            },'
          '            {'
          '               "value": [0, 100, 0, 0, 0],'
          '               "data": [3084, 14959.8],'
          '               "name": "'#21271#20140'"'
          '            },'
          '            {'
          '               "value": [0, 0, 100, 0, 0],'
          '               "data": [1065, 3530.6],'
          '               "name": "'#19978#28023'"'
          '            },'
          '            {'
          '               "value": [0, 0, 0, 100, 0],'
          '               "data": [ 2205, 15816.09],'
          '               "name": "'#24191#24030'"'
          '            },'
          '            {'
          '               "value": [0, 0, 0, 0, 100],'
          '               "data": [1279, 23519.3],'
          '               "name": "'#28145#22323'"'
          '            }'
          '         ]'
          '      }'
          '   ]'
          '};')
        ScrollBars = ssBoth
        TabOrder = 1
      end
    end
    object P_01: TPanel
      Left = 0
      Top = 244
      Width = 300
      Height = 5
      Align = alTop
      BevelOuter = bvNone
      Color = 6238733
      ParentBackground = False
      TabOrder = 2
    end
    object P_04: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 603
      Width = 294
      Height = 188
      Align = alClient
      Color = clNone
      ParentBackground = False
      TabOrder = 3
      object Panel5: TPanel
        AlignWithMargins = True
        Left = 11
        Top = 1
        Width = 212
        Height = 20
        Hint = '{"dwstyle":"border-left:Solid 6px #19CA88;"}'
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 70
        Align = alTop
        Alignment = taLeftJustify
        Color = clNone
        Font.Charset = ANSI_CHARSET
        Font.Color = clNone
        Font.Height = -17
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
        object Label5: TLabel
          AlignWithMargins = True
          Left = 11
          Top = 1
          Width = 200
          Height = 16
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 2
          Align = alClient
          Caption = #20225#19994#27745#26579#25490#25918#24773#20917
          Color = 13924904
          Font.Charset = ANSI_CHARSET
          Font.Color = 15852561
          Font.Height = -17
          Font.Name = #24494#36719#38597#40657
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Transparent = True
          Layout = tlCenter
          ExplicitWidth = 136
          ExplicitHeight = 23
        end
      end
      object Memo6: TMemo
        AlignWithMargins = True
        Left = 4
        Top = 24
        Width = 286
        Height = 160
        HelpType = htKeyword
        HelpKeyword = 'echarts'
        Margins.Top = 0
        Align = alClient
        ImeName = '123'
        Lines.Strings = (
          'option = {'
          '  grid: {'
          '    left: '#39'3%'#39','
          '    right: '#39'3%'#39','
          '    top: '#39'10%'#39','
          '    bottom: '#39'-10%'#39','
          '    containLabel: true'
          '  },'
          '  xAxis: {'
          '    show: false,'
          '    type: '#39'value'#39
          '  },'
          '  yAxis: {'
          '    type: '#39'category'#39','
          '    axisLabel:{'
          '      textStyle:{'
          '        color:'#39'#eee'#39
          '      }'
          '    },'
          '    data: ['#39#38124#27745#26579#39', '#39#38085#27745#26579#39', '#39#24223#27700#20225#19994#39', '#39#24223#27668#20225#19994#39', '#39#20225#19994#24635#25968#39']'
          '  },'
          '  series: ['
          '    {'
          '      label: {'
          '        normal: {'
          '          show: true,'
          '          position: '#39'right'#39','
          '          formatter: function (data) {'
          '            return '#39'{a0|'#39' + data.value + '#39'}'#39';'
          '          },'
          '          rich: {'
          '            a0: {'
          '              color: '#39'#8FCEFF'#39','
          '              fontSize: 12'
          '            }'
          '          }'
          '        }'
          '      },'
          '      itemStyle: {'
          '        barBorderRadius: [50, 50, 50, 50],'
          '        color: {'
          '          type: '#39'linear'#39','
          '          x: 1, //'#21491
          '          y: 0, //'#19979
          '          x2: 0, //'#24038
          '          y2: 1, //'#19978
          '          colorStops: ['
          '            {'
          '              offset: 0.1,'
          '              color: '#39'#13D5FC'#39' // 0% '#22788#30340#39068#33394
          '            },'
          '            {'
          '              offset: 1,'
          '              color: '#39'#2059B8'#39' // 100% '#22788#30340#39068#33394
          '            }'
          '          ]'
          '        }'
          '      },'
          '      type: '#39'bar'#39','
          '      barWidth: '#39'40%'#39','
          '      data: [182, 234, 390, 1049, 1317]'
          '    }'
          '  ]'
          '};')
        ScrollBars = ssBoth
        TabOrder = 1
      end
    end
    object P_03: TPanel
      Left = 0
      Top = 595
      Width = 300
      Height = 5
      Align = alTop
      BevelOuter = bvNone
      Color = 6238733
      ParentBackground = False
      TabOrder = 4
    end
  end
  object Timer1: TTimer
    Interval = 3000
    OnTimer = Timer1Timer
    Left = 331
    Top = 387
  end
end
