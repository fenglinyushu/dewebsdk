object Form_Stat: TForm_Stat
  Left = 0
  Top = 0
  HelpType = htKeyword
  HelpKeyword = 'embed'
  Caption = #25968#25454#32479#35745
  ClientHeight = 657
  ClientWidth = 931
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnMouseDown = FormMouseDown
  OnShow = FormShow
  TextHeight = 20
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 931
    Height = 657
    HelpType = htKeyword
    HelpKeyword = 'echarts'
    Align = alClient
    Lines.Strings = (
      'option = {'
      '  title: {'
      '    top: 20,'
      '    left:100,'
      '    text: '#39#26085#24120#26679#26412'TAT'#36127#36733#39
      '  },'
      '  tooltip: {'
      '    trigger: '#39'axis'#39','
      '    axisPointer: {'
      '      animation: false'
      '    }'
      '  },'
      '  legend: {'
      '    top: 20,'
      '    data: ['#39#36827#26679#39', '#39#27979#35797#39',"'#23436#25104'"],'
      '     right: 50'
      '  },'
      '  axisPointer: {'
      '    link: ['
      '      {'
      '        xAxisIndex: '#39'all'#39
      '      }'
      '    ]'
      '  },'
      '  grid: ['
      '    {'
      '      top: 100,'
      '      left: 50,'
      '      right: 50,'
      '      height: '#39'30%'#39
      '    },'
      '    {'
      '      top: 100,'
      '      left: 50,'
      '      right: 50,'
      '      top: '#39'55%'#39','
      '      height: '#39'30%'#39
      '    }'
      '  ],'
      '  xAxis: ['
      '    {'
      '      type: '#39'category'#39','
      
        '      data:  ['#39'2:00'#39', '#39'3:00'#39', '#39'4:00'#39', '#39'5:00'#39','#39'6:00'#39','#39'7:00'#39','#39'8:00' +
        #39'],'
      '      show:false'
      '    },'
      '    {'
      '      gridIndex: 1,'
      '      type: '#39'category'#39','
      
        '      data:  ['#39'2:00'#39', '#39'3:00'#39', '#39'4:00'#39', '#39'5:00'#39','#39'6:00'#39','#39'7:00'#39','#39'8:00' +
        #39'],'
      '    }'
      '  ],'
      '  yAxis: ['
      '    {'
      '      name: '#39'TAT'#39','
      '      type: '#39'value'#39','
      '    },'
      '    {'
      '      gridIndex: 1,'
      '      name: '#39#26679#26412#25968#37327#39','
      '      type: '#39'value'#39
      '    }'
      '  ],'
      '  series: ['
      '    {'
      '      name: '#39#36827#26679#39','
      '      xAxisIndex:0,'
      '      yAxisIndex:0,'
      '      type: '#39'line'#39','
      '      symbolSize: 8,'
      '      data: [97,80,85,65,25,38,88]'
      '    },'
      '    {'
      '      name: '#39#27979#35797#39','
      '      yAxisIndex:0,'
      '      type: '#39'line'#39','
      '      symbolSize: 8,'
      '      data: [57,50,25,45,25,48,75]'
      '    },'
      '    {'
      '      name: '#39#23436#25104#39','
      '      yAxisIndex:0,'
      '      type: '#39'line'#39','
      '      symbolSize: 8,'
      '      data: [47,30,85,55,58,90,52]'
      '    },'
      '    {'
      '      name: '#39#36827#26679#39','
      '      type: '#39'bar'#39','
      '      xAxisIndex: 1,'
      '      yAxisIndex: 1,'
      '      symbolSize: 8,'
      '      data: [80,25,75,65,45,25,84]'
      '    },'
      '     {'
      '      name: '#39#27979#35797#39','
      '      type: '#39'bar'#39','
      '      xAxisIndex: 1,'
      '      yAxisIndex: 1,'
      '      symbolSize: 8,'
      '      data: [80,25,75,65,59,87,84]'
      '    },'
      '     {'
      '      name: '#39#23436#25104#39','
      '      type: '#39'bar'#39','
      '      xAxisIndex: 1,'
      '      yAxisIndex: 1,'
      '      symbolSize: 8,'
      '      data: [50,65,55,55,98,48,59]'
      '    }'
      '  ]'
      '};')
    TabOrder = 0
  end
  object FDQuery1: TFDQuery
    Left = 104
    Top = 157
  end
end
