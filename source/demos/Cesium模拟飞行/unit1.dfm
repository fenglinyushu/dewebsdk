object Form1: TForm1
  Left = 0
  Top = 0
  HelpType = htKeyword
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'Cesium'
  ClientHeight = 900
  ClientWidth = 847
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnMouseUp = FormMouseUp
  TextHeight = 21
  object Pn1: TPanel
    Left = 0
    Top = 0
    Width = 847
    Height = 900
    Hint = 
      '{"token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI1ODg2O' +
      'WYzZS02YTA3LTRkMWMtYmVmMi02NTgyODA2MmRmYWQiLCJpZCI6MjA3Mjc4LCJpY' +
      'XQiOjE3MTM0MDE4ODV9.__qt1kwJNGeAtuK3EgPNr9oBkDimk7hRyUfNWzEEopo"' +
      '}'
    HelpType = htKeyword
    HelpKeyword = 'cesium'
    Align = alClient
    Caption = 'Pn1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object Panel1: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 839
      Height = 35
      Hint = '{"dwstyle":"z-index:1;"}'
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Panel1'
      Color = clNone
      ParentBackground = False
      TabOrder = 0
      object Button_Open: TButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 75
        Height = 29
        Hint = '{"type":"primary"}'
        Align = alLeft
        Caption = 'Open'
        TabOrder = 0
        OnClick = Button_OpenClick
      end
      object Button_Play: TButton
        AlignWithMargins = True
        Left = 84
        Top = 3
        Width = 75
        Height = 29
        Hint = '{"type":"success"}'
        Align = alLeft
        Caption = 'Play'
        Enabled = False
        TabOrder = 1
        OnClick = Button_PlayClick
      end
      object Button_Pause: TButton
        AlignWithMargins = True
        Left = 165
        Top = 3
        Width = 75
        Height = 29
        Hint = '{"type":"info"}'
        Align = alLeft
        Caption = 'Pause'
        Enabled = False
        TabOrder = 2
        OnClick = Button_PauseClick
      end
      object Button_Left: TButton
        AlignWithMargins = True
        Left = 246
        Top = 3
        Width = 75
        Height = 29
        Hint = '{"type":"info"}'
        Align = alLeft
        Caption = 'Left'
        Enabled = False
        TabOrder = 3
        OnClick = Button_LeftClick
      end
      object Button_Right: TButton
        AlignWithMargins = True
        Left = 327
        Top = 3
        Width = 75
        Height = 29
        Hint = '{"type":"info"}'
        Align = alLeft
        Caption = 'Right'
        Enabled = False
        TabOrder = 4
        OnClick = Button_RightClick
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 232
    Top = 200
  end
end
