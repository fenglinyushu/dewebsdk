object Form1: TForm1
  Left = 0
  Top = 0
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'DeWeb'
  ClientHeight = 663
  ClientWidth = 400
  Color = clDarkmagenta
  TransparentColor = True
  TransparentColorValue = 16448250
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  DesignSize = (
    400
    663)
  TextHeight = 20
  object Shape1: TShape
    Left = 140
    Top = 96
    Width = 120
    Height = 120
    Hint = '{"data":"56,32,18"}'
    HelpType = htKeyword
    HelpKeyword = 'dvwater'
    Anchors = [akTop]
    Shape = stEllipse
  end
  object Button1: TButton
    Left = 140
    Top = 304
    Width = 120
    Height = 57
    Hint = '{"type":"success"}'
    Anchors = [akTop]
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
end
