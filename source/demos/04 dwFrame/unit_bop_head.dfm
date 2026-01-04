object Form_bop_Head: TForm_bop_Head
  Left = 0
  Top = 0
  Hint = '{"hidehead":0,"hidefoot":1}'
  BorderStyle = bsNone
  Caption = 'Hide Nav'
  ClientHeight = 540
  ClientWidth = 627
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  TextHeight = 23
  object Label1: TLabel
    AlignWithMargins = True
    Left = 20
    Top = 20
    Width = 587
    Height = 100
    Hint = '{'#13#10'"dwstyle":"border-radius:8px;"'#13#10'}'
    Margins.Left = 20
    Margins.Top = 20
    Margins.Right = 20
    Margins.Bottom = 20
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'A demo of hide nav bar'
    Color = 5685511
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -20
    Font.Name = #24605#28304#40657#20307' CN'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = False
    Layout = tlCenter
  end
  object Label2: TLabel
    AlignWithMargins = True
    Left = 20
    Top = 140
    Width = 587
    Height = 23
    Margins.Left = 20
    Margins.Top = 0
    Margins.Right = 20
    Margins.Bottom = 0
    Align = alTop
    Caption = 'Hint'
    ExplicitWidth = 34
  end
  object Memo1: TMemo
    AlignWithMargins = True
    Left = 20
    Top = 183
    Width = 587
    Height = 337
    Margins.Left = 20
    Margins.Top = 20
    Margins.Right = 20
    Margins.Bottom = 20
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = #24605#28304#40657#20307' CN'
    Font.Style = []
    Lines.Strings = (
      '{'
      #9'"hidehead": 0,'
      #9'"hidefoot": 1'
      '}')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
end
