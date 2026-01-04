object Form1: TForm1
  Left = 0
  Top = 0
  HelpType = htKeyword
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'EditTree'
  ClientHeight = 721
  ClientWidth = 1062
  Color = clBtnFace
  TransparentColor = True
  TransparentColorValue = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnMouseUp = FormMouseUp
  PixelsPerInch = 96
  TextHeight = 21
  object Edit1: TEdit
    Left = 128
    Top = 48
    Width = 225
    Height = 29
    Hint = 
      '{"disablebranchnodes":1,"options":"[{id:'#39'a'#39',label:'#39'a'#39',children:[' +
      '{id:'#39'aa'#39',label:'#39'aa'#39'}, {id:'#39'ab'#39',label:'#39'ab'#39'}]}, {id:'#39'b'#39',label:'#39'b'#39'}' +
      ', {id:'#39'c'#39',label:'#39'c'#39'}]"}'
    HelpType = htKeyword
    HelpKeyword = 'tree'
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 112
    Top = 152
    Width = 257
    Height = 41
    Hint = '{"dwstyle":"overflow:visible;"}'
    HelpType = htKeyword
    HelpKeyword = 'simple'
    Caption = 'Panel1'
    TabOrder = 1
    object Edit2: TEdit
      Left = 16
      Top = 4
      Width = 225
      Height = 29
      Hint = 
        '{"disablebranchnodes":1,"options":"[{id:'#39'a'#39',label:'#39'a'#39',children:[' +
        '{id:'#39'aa'#39',label:'#39'aa'#39'}, {id:'#39'ab'#39',label:'#39'ab'#39'}]}, {id:'#39'b'#39',label:'#39'b'#39'}' +
        ', {id:'#39'c'#39',label:'#39'c'#39'}]"}'
      HelpType = htKeyword
      HelpKeyword = 'tree'
      TabOrder = 0
      Text = 'ab'
    end
  end
  object Button1: TButton
    Left = 264
    Top = 288
    Width = 145
    Height = 57
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
end
