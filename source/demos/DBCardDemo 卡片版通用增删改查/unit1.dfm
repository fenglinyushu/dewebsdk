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
    Top = 57
    Width = 400
    Height = 458
    Hint = 
      '{"account":"dwDeWeb","table":"(SELECT tEmployeeID, SUM(tprice*tq' +
      'uantity) AS tTotalSales FROM ttSales WHERE tSaleDate >= '#39'2025-08' +
      '-01'#39' AND tSaleDate < '#39'2025-09-01'#39' GROUP BY tEmployeeID) as A000"' +
      ',"margins":[0,5,8,10],"cardheight":148,"defaultquerymode":0,"car' +
      'dstyle":"border:solid 1px #ddd;overflow:hidden;border-radius:5px' +
      ';background-image: linear-gradient(to top, #f3e7e9 0%, #e3eeff 9' +
      '9%, #e3eeff 100%);","fields":[{"name":"tEmployeeID"},{"name":"tT' +
      'otalSales"}]}'
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
    ExplicitTop = 142
    ExplicitWidth = 933
    ExplicitHeight = 373
  end
  object Panel0: TPanel
    Left = 0
    Top = 0
    Width = 400
    Height = 57
    Align = alTop
    Caption = 'Panel0'
    TabOrder = 1
    object DateTimePicker1: TDateTimePicker
      Left = 8
      Top = 8
      Width = 145
      Height = 31
      Date = 45884.000000000000000000
      Time = 0.544837881941930400
      TabOrder = 0
      OnChange = DateTimePicker1Change
    end
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=MSAcc')
    Left = 168
    Top = 96
  end
  object FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink
    Left = 168
    Top = 160
  end
end
