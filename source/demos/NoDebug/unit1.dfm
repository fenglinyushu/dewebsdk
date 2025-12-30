object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'DeWeb'
  ClientHeight = 540
  ClientWidth = 360
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  TextHeight = 20
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 360
    Height = 137
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'No Debug'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -37
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
    ExplicitWidth = 305
  end
  object Button1: TButton
    AlignWithMargins = True
    Left = 30
    Top = 167
    Width = 300
    Height = 45
    Hint = '{"type":"success"}'
    Margins.Left = 30
    Margins.Top = 30
    Margins.Right = 30
    Align = alTop
    Caption = 'OK'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object MUses: TMemo
    Left = 30
    Top = 264
    Width = 300
    Height = 59
    HelpType = htKeyword
    HelpKeyword = 'uses'
    Lines.Strings = (
      
        '<script type="text/javascript" src="dist/_devtool/devtool.js"></' +
        'script>')
    ScrollBars = ssBoth
    TabOrder = 1
  end
end
