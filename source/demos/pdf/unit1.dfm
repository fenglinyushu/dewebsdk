﻿object Form1: TForm1
  Left = 0
  Top = 0
  Hint = '{"dwattr":"background"}'
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'DeWeb '
  ClientHeight = 500
  ClientWidth = 1000
  Color = 4079166
  TransparentColorValue = 16448250
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnMouseUp = FormMouseUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 20
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1000
    Height = 500
    Hint = '{"src":"/dist/pdf/web/viewer.html?file=c.pdf"}'
    HelpType = htKeyword
    HelpKeyword = 'iframe'
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    Color = clAppWorkSpace
    ParentBackground = False
    TabOrder = 0
  end
end