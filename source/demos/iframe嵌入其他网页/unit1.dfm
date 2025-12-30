object Form1: TForm1
  Left = 0
  Top = 0
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = #30452#25509#20869#23884#32593#39029
  ClientHeight = 708
  ClientWidth = 1000
  Color = clBtnFace
  TransparentColor = True
  TransparentColorValue = 16448250
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnMouseUp = FormMouseUp
  TextHeight = 20
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 1000
    Height = 40
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'DeWeb Panel__iframe'#21151#33021#28436#31034
    Layout = tlCenter
    ExplicitLeft = -8
    ExplicitTop = -26
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 43
    Width = 994
    Height = 662
    Hint = 
      '{"src":"//player.bilibili.com/player.html?aid=375588815&bvid=BV1' +
      'so4y1m7U5&cid=339262048&page=1&high_quality=1&danmaku=0"}'
    HelpType = htKeyword
    HelpKeyword = 'iframe'
    Align = alClient
    Caption = 'Panel1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    ExplicitTop = 3
    ExplicitHeight = 457
  end
end
