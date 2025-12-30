object Form1: TForm1
  Left = 191
  Top = 60
  HelpType = htKeyword
  BorderStyle = bsNone
  Caption = 'DeWeb'
  ClientHeight = 638
  ClientWidth = 963
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = True
  OnMouseUp = FormMouseUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 20
  object PBanner: TPanel
    Left = 0
    Top = 0
    Width = 963
    Height = 50
    HelpType = htKeyword
    HelpKeyword = 'simple'
    Align = alTop
    BevelOuter = bvNone
    Color = 16742167
    ParentBackground = False
    TabOrder = 0
    object Label2: TLabel
      AlignWithMargins = True
      Left = 71
      Top = 3
      Width = 310
      Height = 42
      Margins.Left = 10
      Margins.Bottom = 5
      Align = alLeft
      AutoSize = False
      Caption = 'DeWeb CrudPanel'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindow
      Font.Height = -25
      Font.Name = #24494#36719#38597#40657
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitTop = 0
    end
    object Im: TImage
      AlignWithMargins = True
      Left = 10
      Top = 3
      Width = 48
      Height = 44
      Hint = '{"src":"media/images/32/a (78).png"}'
      Margins.Left = 10
      Align = alLeft
    end
    object Button1: TButton
      Left = 488
      Top = 14
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object PClient: TPanel
    Left = 0
    Top = 50
    Width = 719
    Height = 588
    Align = alClient
    BevelOuter = bvNone
    Caption = 'PClient'
    TabOrder = 1
    object PMaster: TPanel
      Left = 0
      Top = 0
      Width = 719
      Height = 588
      Hint = '{"table":"dwf_goods"}'
      HelpType = htKeyword
      Align = alClient
      BevelKind = bkSoft
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      OnDragOver = PMasterDragOver
    end
  end
  object Memo1: TMemo
    AlignWithMargins = True
    Left = 722
    Top = 53
    Width = 238
    Height = 582
    Align = alRight
    Lines.Strings = (
      '')
    TabOrder = 2
  end
  object FDConnection1: TFDConnection
    Left = 104
    Top = 128
  end
  object FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink
    Left = 104
    Top = 192
  end
end
