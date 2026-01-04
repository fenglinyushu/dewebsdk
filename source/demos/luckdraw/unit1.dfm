object Form1: TForm1
  Left = 0
  Top = 0
  Hint = 
    '{"dwattr":":fetch-suggestions=\"[{\\\"value\\\":\\\"aaa\\\"}]\""' +
    '}'
  Margins.Left = 20
  Margins.Top = 20
  Margins.Right = 20
  Margins.Bottom = 20
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'DeWeb '
  ClientHeight = 708
  ClientWidth = 449
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnMouseUp = FormMouseUp
  PixelsPerInch = 96
  TextHeight = 20
  object SG: TStringGrid
    AlignWithMargins = True
    Left = 20
    Top = 20
    Width = 409
    Height = 369
    HelpType = htKeyword
    HelpKeyword = 'luck'
    Margins.Left = 20
    Margins.Top = 20
    Margins.Right = 20
    Margins.Bottom = 20
    Align = alTop
    ColCount = 8
    RowCount = 8
    Font.Charset = ANSI_CHARSET
    Font.Color = 3622870
    Font.Height = -19
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnEndDock = SGEndDock
    ExplicitLeft = 15
    ExplicitTop = 25
  end
end
