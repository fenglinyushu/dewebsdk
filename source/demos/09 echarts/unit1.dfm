object Form1: TForm1
  Left = 0
  Top = 0
  HelpType = htKeyword
  Margins.Top = 20
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'Echarts'
  ClientHeight = 690
  ClientWidth = 1346
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnMouseUp = FormMouseUp
  TextHeight = 23
  object PageControl1: TPageControl
    Left = 0
    Top = 50
    Width = 1346
    Height = 640
    Margins.Left = 20
    ActivePage = TabSheet8
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 844
    ExplicitHeight = 634
    object TabSheet1: TTabSheet
      Caption = #25240#32447#22270
      ImageIndex = 38
      object Memo1: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 1332
        Height = 596
        HelpType = htKeyword
        HelpKeyword = 'echarts'
        Align = alClient
        Lines.Strings = (
          'option = {'
          '  xAxis: {'
          '    type: '#39'category'#39','
          '    data: ['#39'Mon'#39', '#39'Tue'#39', '#39'Wed'#39', '#39'Thu'#39', '#39'Fri'#39', '#39'Sat'#39', '#39'Sun'#39']'
          '  },'
          '  yAxis: {'
          '    type: '#39'value'#39
          '  },'
          '  series: ['
          '    {'
          '      data: [150, 230, 224, 218, 135, 147, 260],'
          '      type: '#39'line'#39
          '    }'
          '  ]'
          '};')
        ScrollBars = ssBoth
        TabOrder = 0
        OnMouseUp = Memo1MouseUp
        ExplicitHeight = 849
      end
    end
    object TabSheet2: TTabSheet
      Caption = #38754#31215#22270
      ImageIndex = 1
      object Memo2: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 1332
        Height = 596
        HelpType = htKeyword
        HelpKeyword = 'echarts'
        Align = alClient
        Lines.Strings = (
          'option = {'
          
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
          '};')
        ScrollBars = ssBoth
        TabOrder = 0
        OnMouseUp = Memo1MouseUp
        ExplicitHeight = 849
      end
    end
    object TabSheet3: TTabSheet
      Caption = #29611#29808#22270
      ImageIndex = 2
      object Memo3: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 1332
        Height = 596
        HelpType = htKeyword
        HelpKeyword = 'echarts'
        Align = alClient
        Lines.Strings = (
          'option = {'
          '  legend: {'
          '    top: '#39'bottom'#39
          '  },'
          '  toolbox: {'
          '    show: true,'
          '    feature: {'
          '      mark: { show: true },'
          '      dataView: { show: true, readOnly: false },'
          '      restore: { show: true },'
          '      saveAsImage: { show: true }'
          '    }'
          '  },'
          '  series: ['
          '    {'
          '      name: '#39'Nightingale Chart'#39','
          '      type: '#39'pie'#39','
          '      radius: ['#39'10%'#39', '#39'45%'#39'],'
          '      center: ['#39'50%'#39', '#39'50%'#39'],'
          '      roseType: '#39'area'#39','
          '      itemStyle: {'
          '        borderRadius: 8'
          '      },'
          '      data: ['
          '        { value: 40, name: '#39'rose 1'#39' },'
          '        { value: 38, name: '#39'rose 2'#39' },'
          '        { value: 32, name: '#39'rose 3'#39' },'
          '        { value: 30, name: '#39'rose 4'#39' },'
          '        { value: 28, name: '#39'rose 5'#39' },'
          '        { value: 26, name: '#39'rose 6'#39' },'
          '        { value: 22, name: '#39'rose 7'#39' },'
          '        { value: 18, name: '#39'rose 8'#39' }'
          '      ]'
          '    }'
          '  ]'
          '};')
        ScrollBars = ssBoth
        TabOrder = 0
        OnMouseUp = Memo1MouseUp
        ExplicitHeight = 849
      end
    end
    object TabSheet4: TTabSheet
      Caption = #26609#29366#22270
      ImageIndex = 3
      object Memo4: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 1332
        Height = 596
        HelpType = htKeyword
        HelpKeyword = 'echarts'
        Align = alClient
        Lines.Strings = (
          'option = {'
          '  xAxis: {'
          '    type: '#39'category'#39','
          '    data: ['#39'Mon'#39', '#39'Tue'#39', '#39'Wed'#39', '#39'Thu'#39', '#39'Fri'#39', '#39'Sat'#39', '#39'Sun'#39']'
          '  },'
          '  yAxis: {'
          '    type: '#39'value'#39
          '  },'
          '  series: ['
          '    {'
          '      data: [120, 200, 150, 80, 70, 110, 130],'
          '      type: '#39'bar'#39','
          '      showBackground: true,'
          '      backgroundStyle: {'
          '        color: '#39'rgba(180, 180, 180, 0.2)'#39
          '      }'
          '    }'
          '  ]'
          '};')
        ScrollBars = ssBoth
        TabOrder = 0
        OnMouseUp = Memo1MouseUp
        ExplicitHeight = 849
      end
    end
    object TabSheet5: TTabSheet
      Caption = #39292#22270
      ImageIndex = 4
      object Memo5: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 1332
        Height = 596
        HelpType = htKeyword
        HelpKeyword = 'echarts'
        Align = alClient
        Lines.Strings = (
          'option = {'
          '  title: {'
          '    text: '#39'Referer of a Website'#39','
          '    subtext: '#39'Fake Data'#39','
          '    left: '#39'center'#39
          '  },'
          '  tooltip: {'
          '    trigger: '#39'item'#39
          '  },'
          '  legend: {'
          '    orient: '#39'vertical'#39','
          '    left: '#39'left'#39
          '  },'
          '  series: ['
          '    {'
          '      name: '#39'Access From'#39','
          '      type: '#39'pie'#39','
          '      radius: '#39'50%'#39','
          '      data: ['
          '        { value: 1048, name: '#39'Search Engine'#39' },'
          '        { value: 735, name: '#39'Direct'#39' },'
          '        { value: 580, name: '#39'Email'#39' },'
          '        { value: 484, name: '#39'Union Ads'#39' },'
          '        { value: 300, name: '#39'Video Ads'#39' }'
          '      ],'
          '      emphasis: {'
          '        itemStyle: {'
          '          shadowBlur: 10,'
          '          shadowOffsetX: 0,'
          '          shadowColor: '#39'rgba(0, 0, 0, 0.5)'#39
          '        }'
          '      }'
          '    }'
          '  ]'
          '};')
        ScrollBars = ssBoth
        TabOrder = 0
        OnMouseUp = Memo1MouseUp
        ExplicitWidth = 830
        ExplicitHeight = 590
      end
    end
    object TabSheet6: TTabSheet
      Caption = #25955#28857#22270
      ImageIndex = 5
      object Memo6: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 1332
        Height = 596
        HelpType = htKeyword
        HelpKeyword = 'echarts'
        Align = alClient
        Lines.Strings = (
          'option = {'
          '  xAxis: {},'
          '  yAxis: {},'
          '  series: ['
          '    {'
          '      symbolSize: 20,'
          '      data: ['
          '        [10.0, 8.04],'
          '        [8.07, 6.95],'
          '        [13.0, 7.58],'
          '        [9.05, 8.81],'
          '        [11.0, 8.33],'
          '        [14.0, 7.66],'
          '        [13.4, 6.81],'
          '        [10.0, 6.33],'
          '        [14.0, 8.96],'
          '        [12.5, 6.82],'
          '        [9.15, 7.2],'
          '        [11.5, 7.2],'
          '        [3.03, 4.23],'
          '        [12.2, 7.83],'
          '        [2.02, 4.47],'
          '        [1.05, 3.33],'
          '        [4.05, 4.96],'
          '        [6.03, 7.24],'
          '        [12.0, 6.26],'
          '        [12.0, 8.84],'
          '        [7.08, 5.82],'
          '        [5.02, 5.68]'
          '      ],'
          '      type: '#39'scatter'#39
          '    }'
          '  ]'
          '};')
        ScrollBars = ssBoth
        TabOrder = 0
        OnMouseUp = Memo1MouseUp
        ExplicitHeight = 849
      end
    end
    object TabSheet7: TTabSheet
      Caption = #38647#36798#22270
      ImageIndex = 6
      object Memo7: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 1332
        Height = 596
        HelpType = htKeyword
        HelpKeyword = 'echarts'
        Align = alClient
        Lines.Strings = (
          'option = {'
          '  title: {'
          '    text: '#39'Basic Radar Chart'#39
          '  },'
          '  legend: {'
          '    data: ['#39'Allocated Budget'#39', '#39'Actual Spending'#39']'
          '  },'
          '  radar: {'
          '    // shape: '#39'circle'#39','
          '    indicator: ['
          '      { name: '#39'Sales'#39', max: 6500 },'
          '      { name: '#39'Administration'#39', max: 16000 },'
          '      { name: '#39'Information Technology'#39', max: 30000 },'
          '      { name: '#39'Customer Support'#39', max: 38000 },'
          '      { name: '#39'Development'#39', max: 52000 },'
          '      { name: '#39'Marketing'#39', max: 25000 }'
          '    ]'
          '  },'
          '  series: ['
          '    {'
          '      name: '#39'Budget vs spending'#39','
          '      type: '#39'radar'#39','
          '      data: ['
          '        {'
          '          value: [4200, 3000, 20000, 35000, 50000, 18000],'
          '          name: '#39'Allocated Budget'#39
          '        },'
          '        {'
          '          value: [5000, 14000, 28000, 26000, 42000, 21000],'
          '          name: '#39'Actual Spending'#39
          '        }'
          '      ]'
          '    }'
          '  ]'
          '};')
        ScrollBars = ssBoth
        TabOrder = 0
        OnMouseUp = Memo1MouseUp
        ExplicitHeight = 849
      end
    end
    object TabSheet8: TTabSheet
      Caption = #21160#24577#25511#21046
      ImageIndex = 7
      object Memo8: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 1332
        Height = 596
        HelpType = htKeyword
        HelpKeyword = 'echarts'
        Align = alClient
        Lines.Strings = (
          'this.value0 = [150, 230, 224, 218, 135, 147, 260];'
          '//====='
          'option = {'
          '  xAxis: {'
          '    type: '#39'category'#39','
          '    data: ['#39'Mon'#39', '#39'Tue'#39', '#39'Wed'#39', '#39'Thu'#39', '#39'Fri'#39', '#39'Sat'#39', '#39'Sun'#39']'
          '  },'
          '  yAxis: {'
          '    type: '#39'value'#39
          '  },'
          '  series: ['
          '    {'
          '      data: this.value0,'
          '      type: '#39'line'#39
          '    }'
          '  ]'
          '};')
        ScrollBars = ssBoth
        TabOrder = 0
        OnMouseUp = Memo1MouseUp
        ExplicitHeight = 849
      end
      object Button1: TButton
        AlignWithMargins = True
        Left = 12
        Top = 13
        Width = 109
        Height = 40
        Hint = '{"type":"success"}'
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = #26356#26032#25968#25454
        TabOrder = 1
        OnClick = Button1Click
      end
    end
    object TabSheet9: TTabSheet
      Caption = #20351#29992#25351#21335
      ImageIndex = 8
      object ScrollBox1: TScrollBox
        Left = 0
        Top = 0
        Width = 1338
        Height = 602
        VertScrollBar.Visible = False
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        TabOrder = 0
        ExplicitHeight = 855
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 1338
          Height = 2000
          Align = alTop
          Caption = 'Panel1'
          Color = clWhite
          ParentBackground = False
          TabOrder = 0
          object Memo9: TMemo
            AlignWithMargins = True
            Left = 21
            Top = 4
            Width = 1313
            Height = 1992
            HelpType = htKeyword
            HelpKeyword = 'html'
            Margins.Left = 20
            Align = alClient
            Lines.Strings = (
              '<h1 >Mqtt'#20351#29992#25351#21335
              '</h1>'
              '<p >'#30887#26641#35199#39118'</p>'
              '<h2>'#19968#12289#35828#26126'</h2>'
              '<p>'#26412#25991#26723#20165#36866#29992#20110#22312'DeWeb'#24320#21457#24179#21488#20013#24341#20837'Mqtt'#26102#20351#29992#12290
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
              '  <li>'#20351#29992'dwMqttConnect'
              '</ol>'
              ''
              '<h2>'#19977#12289#20027#35201#20989#25968'</h2>'
              '<ol>'
              '  <li>dwMqttConnect'#36830#25509#26381#21153#22120
              'AMqtt:TMemo '#20026'Mqtt'#25511#20214#65288'TMemo,'#35774#32622'HelpKeyword=mqtt'#65289',AUrl'#20026#26381#21153#22120'URL'
              'procedure dwMqttConnect(AMqtt:TMemo;AUrl:String); </li>'
              '</li>'
              '<li>dwMqttSubscribe'#35746#38405#28040#24687
              
                'AMqtt:TMemo '#20026'Mqtt'#25511#20214#65288'TMemo,'#35774#32622'HelpKeyword=mqtt'#65289',ATopic '#20026#28040#24687#20027#39064', AQos' +
                #20026#26381#21153#36136
              #37327
              
                'procedure dwMqttSubscribe(AMqtt:TMemo;ATopic:String;AQos:Integer' +
                ');</li>'
              ''
              '<li>dwMqttUnsubscribe'#21462#28040#35746#38405#28040#24687
              'AMqtt:TMemo '#20026'Mqtt'#25511#20214#65288'TMemo,'#35774#32622'HelpKeyword=mqtt'#65289',ATopic '#20026#28040#24687#20027#39064
              'procedure dwMqttUnsubscribe(AMqtt:TMemo;ATopic:String);</li>'
              ''
              '<li>dwMqttPublish'#21457#24067#28040#24687
              
                'AMqtt:TMemo '#20026'Mqtt'#25511#20214#65288'TMemo,'#35774#32622'HelpKeyword=mqtt'#65289',ATopic '#20026#28040#24687#20027#39064#65292'AText' +
                #20026#28040#24687
              #20869
              #23481
              'procedure dwMqttPublish(AMqtt:TMemo;ATopic,AText:String); </li>'
              ''
              '<li>dwMqttEnd'#20572#27490
              'AMqtt:TMemo '#20026'Mqtt'#25511#20214#65288'TMemo,'#35774#32622'HelpKeyword=mqtt'#65289
              'procedure dwMqttEnd(AMqtt:TMemo);  </li>'
              '</ol>'
              ''
              ''
              '<h2>'#22235#12289#25511#20214#20107#20214'</h2>'
              ''
              '<ol>'
              '  <li>'#8226#9#23558'Memo1'#30340'Lines'#20013#25991#26412#20013#38656
              #35201#21160#24577#26356#26032#30340#37096#20998#25913#20026#19968#20010#25110#22810#20010#21464#37327#12290
              '<br/>'#22312#19978#36848#20363#23376#20013#65292#38656
              #35201
              #26356#26032'series'#30340'data'#37096#20998#65292#25152#20197#38656#35201#25913#20026
              '<br/>'
              'this.value0 =  [150, 230, 224, 218, 135, '
              '147, 260];<br/>'
              '//=====<br/>'
              'option = {<br/>'
              '  &emsp;xAxis: {<br/>'
              '    &emsp;&emsp;type:'
              #39'category'#39',<br/>'
              '    &emsp;&emsp;data: ['#39'Mon'#39', '#39'Tue'#39','
              #39'Wed'#39', '#39'Thu'#39', '#39'Fri'#39', '#39'Sat'#39', '#39'Sun'#39']<br/>'
              '  &emsp;},<br/>'
              '  &emsp;yAxis: {<br/>'
              '    &emsp;&emsp;type: '#39'value'#39'<br/>'
              '  &emsp;},<br/>'
              '  &emsp;series: [<br/>'
              '    &emsp;&emsp;{<br/>'
              ''
              '&emsp;&emsp;&emsp;data:this.value0,'
              '<br/>'
              '      &emsp;&emsp;&emsp;type:'
              #39'line'#39'<br/>'
              '    &emsp;&emsp;}<br/>'
              '  &emsp;]<br/>'
              '};<br/>'
              #20063#23601#26159#23558'series'#30340'data'#37096#20998#25913#20026#21464#37327
              'this.value0<br/>'
              #21516#26102#65292#22312#20195#30721#22836#37096#22686#21152#21464#37327#30340#21021#22987#20540#65292
              '<br/>'#20197#21450#20998#38548#31526#65288'//======'#65289#65292#20063#23601
              #26159#21452#26012#32447'+5'#20010#31561#21495#65292#24182#21333
              #29420
              #25104#19968#34892
              ''
              '</li>'
              '<li>'#38656#35201#21160#24577#26356#26032#26102#65292#21487#20197#21160#24577#29983#25104#25968#25454
              #23383#31526#20018#65292#22914'<br/>'
              'sJS := '#39'this.value0 =  [1, 23, 45, 67, 89,'
              '90, 11];'#39';<br/>'
              #28982#21518'<br/>'
              'dwRunJS(sJS,self);<br/>'
              'dwEcharts(Memo1);<br/>'
              #36825#26679#21363#21487#20197#26356#26032#22270#34920'<br/>'
              '</li>'
              '</ol>'
              '<h2>'#20116#12289#9#33258#36866#24212#22823#23567'</h2>'
              '<p>Memo1'#22823#23567#25913#21464#26102#20250#33258#21160#28608#27963#35813#25511#20214
              #30340'OnMouseUp'#20107#20214#65292'<br/>'
              #22914#26524#38656#35201#37325#32472#20197#33258#36866#24212#22823#23567#65292'<br/>'
              #21487#20197'Memo1'#30340'OnMouseUp'#20107#20214#20013#21152#20837
              '<br/>'
              'dwEcharts(Memo1);<br/>'
              #21363#21487'<br/>'
              '</p>')
            TabOrder = 0
          end
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 1346
    Height = 50
    Hint = '{"dwstyle":"border-bottom:solid 1px #dcdfe6;"}'
    Align = alTop
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    ExplicitWidth = 844
    object Label1: TLabel
      AlignWithMargins = True
      Left = 16
      Top = 4
      Width = 1326
      Height = 42
      Margins.Left = 15
      Align = alClient
      Caption = 'ECharts '#25968#25454#21487#35270#21270#22270#34920
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -19
      Font.Name = #24494#36719#38597#40657
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 211
      ExplicitHeight = 26
    end
  end
end
