object Form1: TForm1
  Left = 0
  Top = 0
  Hint = '{"dwattr":"background"}'
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'DeWeb '
  ClientHeight = 736
  ClientWidth = 414
  Color = clMedGray
  TransparentColor = True
  TransparentColorValue = 16448250
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnMouseUp = FormMouseUp
  OnUnDock = FormUnDock
  TextHeight = 20
  object Panel_0_Header: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 3
    Width = 414
    Height = 60
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    Color = clRed
    ParentBackground = False
    TabOrder = 0
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 414
      Height = 60
      Align = alClient
      Alignment = taCenter
      AutoSize = False
      Caption = 'Header'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindow
      Font.Height = -21
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 54
      ExplicitHeight = 20
    end
  end
  object Panel_1_Content: TPanel
    Left = 0
    Top = 63
    Width = 414
    Height = 613
    Align = alClient
    BevelOuter = bvNone
    Color = clLime
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      414
      613)
    object Button1: TButton
      AlignWithMargins = True
      Left = 30
      Top = 30
      Width = 354
      Height = 49
      Margins.Left = 30
      Margins.Top = 30
      Margins.Right = 30
      Margins.Bottom = 0
      Align = alTop
      Caption = #28857#20987#24377#26694#21518#21487#36890#36807#22238#36864#38544#34255#38754#26495#19968
      TabOrder = 0
      OnClick = Button1Click
      ExplicitLeft = 40
      ExplicitTop = 64
      ExplicitWidth = 161
    end
    object Panel1: TPanel
      Left = 30
      Top = 272
      Width = 354
      Height = 255
      Hint = 'modal'
      Anchors = [akLeft, akTop, akRight]
      Color = clWindow
      ParentBackground = False
      TabOrder = 1
      Visible = False
      DesignSize = (
        354
        255)
      object Label2: TLabel
        Left = 136
        Top = 120
        Width = 45
        Height = 20
        Caption = #38754#26495#19968
      end
      object Button3: TButton
        Left = 317
        Top = 8
        Width = 33
        Height = 25
        Hint = '{"type":"text"}'
        Anchors = [akTop, akRight]
        Caption = 'X'
        TabOrder = 0
        OnClick = Button3Click
      end
    end
    object Button2: TButton
      AlignWithMargins = True
      Left = 30
      Top = 109
      Width = 354
      Height = 49
      Margins.Left = 30
      Margins.Top = 30
      Margins.Right = 30
      Margins.Bottom = 0
      Align = alTop
      Caption = #28857#27492#24377#26694#21518#22238#36864#30452#25509#36820#22238#19978#19968'URL'
      TabOrder = 2
      OnClick = Button2Click
      ExplicitLeft = 207
      ExplicitTop = 64
      ExplicitWidth = 154
    end
  end
  object Panel_2_Footer: TPanel
    Left = 0
    Top = 676
    Width = 414
    Height = 60
    Align = alBottom
    BevelOuter = bvNone
    Color = clBlue
    ParentBackground = False
    TabOrder = 2
    object Label3: TLabel
      Left = 0
      Top = 0
      Width = 414
      Height = 60
      Align = alClient
      Alignment = taCenter
      AutoSize = False
      Caption = 'Footer'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindow
      Font.Height = -21
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 54
      ExplicitHeight = 20
    end
  end
end
