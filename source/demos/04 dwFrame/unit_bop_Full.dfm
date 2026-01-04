object Form_bop_Full: TForm_bop_Full
  Left = 0
  Top = 0
  Hint = '{"hidehead":1,"hidefoot":1}'
  BorderStyle = bsNone
  Caption = 'Full Screen'
  ClientHeight = 540
  ClientWidth = 627
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = #24605#28304#40657#20307' CN'
  Font.Style = []
  TextHeight = 25
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
    Caption = 'A demo of full screen'
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
    Height = 25
    Margins.Left = 20
    Margins.Top = 0
    Margins.Right = 20
    Margins.Bottom = 0
    Align = alTop
    Caption = 'Hint'
    ExplicitWidth = 33
  end
  object Memo1: TMemo
    AlignWithMargins = True
    Left = 20
    Top = 185
    Width = 587
    Height = 335
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
      #9'"hidehead": 1,'
      #9'"hidefoot": 1'
      '}')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
end
