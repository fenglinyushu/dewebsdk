object Form_Item: TForm_Item
  Left = 0
  Top = 0
  HelpType = htKeyword
  HelpKeyword = 'embed'
  Caption = '[*caption*]'
  ClientHeight = 657
  ClientWidth = 931
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnMouseDown = FormMouseDown
  OnShow = FormShow
  PixelsPerInch = 96
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
      '{'
      '  tooltip: {'
      '    trigger: '#39'item'#39','
      '    formatter: '#39'{a} <br/>{b}: {c} ({d}%)'#39
      '  },'
      '  legend: {'
      '    data: ['
      '      '#39'Direct'#39','
      '      '#39'Marketing'#39','
      '      '#39'Search Engine'#39','
      '      '#39'Email'#39','
      '      '#39'Union Ads'#39','
      '      '#39'Video Ads'#39','
      '      '#39'Baidu'#39','
      '      '#39'Google'#39','
      '      '#39'Bing'#39','
      '      '#39'Others'#39
      '    ]'
      '  },'
      '  series: ['
      '    {'
      '      name: '#39'Access From'#39','
      '      type: '#39'pie'#39','
      '      selectedMode: '#39'single'#39','
      '      radius: [0, '#39'30%'#39'],'
      '      label: {'
      '        position: '#39'inner'#39','
      '        fontSize: 14'
      '      },'
      '      labelLine: {'
      '        show: false'
      '      },'
      '      data: this.value0'
      '    },'
      '    {'
      '      name: '#39'Access From'#39','
      '      type: '#39'pie'#39','
      '      radius: ['#39'45%'#39', '#39'60%'#39'],'
      '      labelLine: {'
      '        length: 30'
      '      },'
      '      label: {'
      
        '        formatter: '#39'{a|{a}}{abg|}\n{hr|}\n  {b|{b}'#65306'}{c}  {per|{d' +
        '}%}  '#39','
      '        backgroundColor: '#39'#F6F8FC'#39','
      '        borderColor: '#39'#8C8D8E'#39','
      '        borderWidth: 1,'
      '        borderRadius: 4,'
      '        rich: {'
      '          a: {'
      '            color: '#39'#6E7079'#39','
      '            lineHeight: 22,'
      '            align: '#39'center'#39
      '          },'
      '          hr: {'
      '            borderColor: '#39'#8C8D8E'#39','
      '            width: '#39'100%'#39','
      '            borderWidth: 1,'
      '            height: 0'
      '          },'
      '          b: {'
      '            color: '#39'#4C5058'#39','
      '            fontSize: 14,'
      '            fontWeight: '#39'bold'#39','
      '            lineHeight: 33'
      '          },'
      '          per: {'
      '            color: '#39'#fff'#39','
      '            backgroundColor: '#39'#4C5058'#39','
      '            padding: [3, 4],'
      '            borderRadius: 4'
      '          }'
      '        }'
      '      },'
      '      data: this.value1'
      '    }'
      '  ]'
      '}')
    TabOrder = 0
  end
  object FDQuery1: TFDQuery
    Left = 104
    Top = 157
  end
end
