object Form1: TForm1
  Left = 0
  Top = 0
  VertScrollBar.Visible = False
  BorderStyle = bsNone
  Caption = 'DeWeb FlowCard'
  ClientHeight = 770
  ClientWidth = 1107
  Color = clBtnFace
  CustomTitleBar.CaptionAlignment = taCenter
  TransparentColor = True
  TransparentColorValue = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = True
  OnMouseUp = FormMouseUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 23
  object Label1: TLabel
    AlignWithMargins = True
    Left = 10
    Top = 10
    Width = 1087
    Height = 40
    Hint = '{"dwstyle":"border-radius:10px;border:solid 1px #ddd;"}'
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'FlowCardList '#28436#31034
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Verdana'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = False
    Layout = tlCenter
  end
  object ScrollBox: TScrollBox
    Left = 0
    Top = 60
    Width = 1107
    Height = 710
    HorzScrollBar.Visible = False
    VertScrollBar.Visible = False
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 0
    object fp_background: TFlowPanel
      Left = 0
      Top = 0
      Width = 1107
      Height = 180
      HelpKeyword = 'auto'
      HelpContext = -300
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 0
      object p_Card: TPanel
        AlignWithMargins = True
        Left = 10
        Top = 10
        Width = 320
        Height = 160
        Hint = '{"radius":"10px","dwstyle":"border:solid 1px #ddd;"}'
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        BevelOuter = bvNone
        Color = clWhite
        Padding.Left = 10
        Padding.Top = 10
        Padding.Right = 10
        Padding.Bottom = 10
        ParentBackground = False
        TabOrder = 0
        Visible = False
        object lb_ShiJian: TLabel
          Left = 115
          Top = 11
          Width = 193
          Height = 23
          Alignment = taCenter
          AutoSize = False
          Caption = '8:00-9:00'
        end
        object lb_ZhiWu: TLabel
          Left = 11
          Top = 51
          Width = 118
          Height = 23
          AutoSize = False
          Caption = #38144#21806#37096#21161#29702
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = #40657#20307
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lb_XingMing: TLabel
          Left = 211
          Top = 51
          Width = 89
          Height = 23
          Alignment = taCenter
          AutoSize = False
          Caption = #24352#19977
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = #40657#20307
          Font.Style = [fsBold]
          ParentFont = False
        end
        object L_Detail: TLabel
          AlignWithMargins = True
          Left = 20
          Top = 87
          Width = 280
          Height = 53
          Margins.Left = 10
          Margins.Top = 10
          Margins.Right = 10
          Margins.Bottom = 10
          Align = alBottom
          AutoSize = False
          Caption = 'L_Detail'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -15
          Font.Name = #24494#36719#38597#40657
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object btn_ZhuangTai: TButton
          Left = 20
          Top = 11
          Width = 100
          Height = 25
          Hint = '{"type":"primary"}'
          Caption = #24453#39044#32422
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = #24494#36719#38597#40657
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
      end
    end
  end
  object FDConnection1: TFDConnection
    Left = 40
    Top = 248
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 40
    Top = 312
  end
  object FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink
    Left = 240
    Top = 256
  end
  object FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink
    Left = 240
    Top = 320
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 240
    Top = 384
  end
end
