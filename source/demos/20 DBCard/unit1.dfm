object Form1: TForm1
  Left = 0
  Top = 0
  HelpType = htKeyword
  Margins.Top = 20
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'DeWeb DBCard'
  ClientHeight = 515
  ClientWidth = 400
  Color = clBtnFace
  TransparentColor = True
  TransparentColorValue = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnMouseUp = FormMouseUp
  OnShow = FormShow
  TextHeight = 23
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 400
    Height = 515
    Hint = 
      '{"account":"dwDemo","table":"dwgoods","margins":[0,5,8,10],"card' +
      'height":148,"defaultquerymode":0,"cardstyle":"border:solid 1px #' +
      'ddd;overflow:hidden;border-radius:5px;background-image: linear-g' +
      'radient(to top, #f3e7e9 0%, #e3eeff 99%, #e3eeff 100%);","fields' +
      '":[{"name":"goodsname"},{"name":"goodscode"},{"name":"provider"}' +
      ',{"name":"price"}]}'
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clGray
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=MSAcc')
    Left = 168
    Top = 96
  end
  object FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink
    Left = 168
    Top = 153
  end
end
