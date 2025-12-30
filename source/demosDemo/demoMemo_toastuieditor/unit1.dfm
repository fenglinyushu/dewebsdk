object Form1: TForm1
  Left = 0
  Top = 0
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'DeWeb'
  ClientHeight = 663
  ClientWidth = 941
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = 16448250
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnMouseUp = FormMouseUp
  TextHeight = 23
  object Button1: TButton
    AlignWithMargins = True
    Left = 3
    Top = 623
    Width = 935
    Height = 37
    Hint = '{"type":"primary"}'
    Align = alBottom
    Caption = 'Update'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 935
    Height = 614
    HelpType = htKeyword
    HelpKeyword = 'toastuieditor'
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    Lines.Strings = (
      '        # '#26356#26032#26085#24535
      '        '
      '        |  '#34920#22836'   | '#34920#22836'  |        '
      '        |  ----  | ----  |      '
      '        | '#21333#20803#26684'11  | '#21333#20803#26684'12 |   '
      '        | '#21333#20803#26684'21  | '#21333#20803#26684'22 |    '
      '             '
      '        ## 2025-03-26'
      '        ### '#26381#21153#31471)
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    ExplicitLeft = 4
    ExplicitTop = 4
    ExplicitWidth = 933
    ExplicitHeight = 612
  end
end
