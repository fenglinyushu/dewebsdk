object Form1: TForm1
  Left = 0
  Top = 0
  HelpType = htKeyword
  Margins.Top = 20
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'Echarts'
  ClientHeight = 684
  ClientWidth = 844
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnMouseDown = FormMouseDown
  OnMouseUp = FormMouseUp
  DesignSize = (
    844
    684)
  TextHeight = 23
  object Memo1: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 838
    Height = 678
    Hint = '{"geojson":"media/geojson/420000_full.json"}'
    HelpType = htKeyword
    HelpKeyword = 'echartsmap'
    Align = alClient
    ImeName = '123'
    Lines.Strings = (
      'option = {'
      #9'title: {'
      #9#9'text: '#39'Echarts Map'#39','
      #9#9'x:'#39'center'#39
      #9'},'
      #9'dataRange:{'
      #9#9'min:0,'
      #9#9'max:500,'
      #9#9'text:['#39#39640#39','#39#20302#39'],'
      #9#9'realtime:true,'
      #9#9'calculable:true,'
      #9#9'color:['#39'orangered'#39','#39'yellow'#39','#39'green'#39']'
      #9'},'
      #9'series:['
      #9#9'{'
      #9#9#9'name:'#39#28216#23458#25968#37327#39','
      #9#9#9'type:'#39'map'#39','
      #9#9#9'map:'#39'MAP'#39','
      '             left: '#39'center'#39','
      '              layoutCenter: ['#39'50%'#39', '#39'50%'#39'],'
      #9#9#9'mapLocation:{'
      #9#9#9#9'y:60'
      #9#9#9'},'
      '                                          label:{show:true},'
      #9#9#9'itemSytle:{'
      #9#9#9#9'emphasis:{label:{show:true}}'
      #9#9#9'},'
      #9#9#9'label:{show:true},'
      #9#9#9'data:['
      #9#9#9#9'{name:'#39#21313#22576#24066#39',value:250},'
      #9#9#9#9'{name:'#39#31070#20892#26550#26519#21306#39',value:350},'
      #9#9#9#9'{name:'#39#24681#26045#22303#23478#26063#33495#26063#33258#27835#24030#39',value:500},'
      #9#9#9#9'{name:'#39#23452#26124#24066#39',value:400},'
      #9#9#9#9'{name:'#39#35140#38451#24066#39',value:230},'
      #9#9#9#9'{name:'#39#33606#38376#24066#39',value:300},'
      #9#9#9#9'{name:'#39#22825#38376#24066#39',value:600},'
      #9#9#9#9'{name:'#39#28508#27743#24066#39',value:700},'
      #9#9#9#9'{name:'#39#33606#24030#24066#39',value:260},'
      #9#9#9#9'{name:'#39#20185#26691#24066#39',value:320},'
      #9#9#9#9'{name:'#39#23389#24863#24066#39',value:550},'
      #9#9#9#9'{name:'#39#27494#27721#24066#39',value:230},'
      #9#9#9#9'{name:'#39#21688#23425#24066#39',value:430},'
      #9#9#9#9'{name:'#39#37122#24030#24066#39',value:330},'
      #9#9#9#9'{name:'#39#38543#24030#24066#39',value:330},'
      
        '                                                                ' +
        '{name:'#39#40644#20872#24066#39',value:120},'
      #9#9#9#9'{name:'#39#40644#30707#24066#39',value:100}'
      #9#9#9']'
      #9#9'}'
      #9'],'
      #9
      '};')
    ScrollBars = ssBoth
    TabOrder = 0
    OnClick = Memo1Click
    ExplicitLeft = 8
    ExplicitTop = -2
  end
  object Button1: TButton
    Left = 696
    Top = 16
    Width = 113
    Height = 41
    Hint = '{"type":"primary"}'
    Anchors = [akTop, akRight]
    Caption = #21047#26032#25968#25454
    TabOrder = 1
    OnClick = Button1Click
  end
end
