object Form1: TForm1
  Left = 191
  Top = 60
  HelpType = htKeyword
  BorderStyle = bsNone
  Caption = 'Demo of dwVcl'
  ClientHeight = 603
  ClientWidth = 836
  Color = clAqua
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OnMouseUp = FormMouseUp
  TextHeight = 20
  object Pn1: TPanel
    Left = 0
    Top = 0
    Width = 836
    Height = 45
    Hint = '{"onexit":"console.log('#39'js exit'#39');"}'
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Pn1'
    Color = 14511788
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object Label2: TLabel
      AlignWithMargins = True
      Left = 15
      Top = 3
      Width = 306
      Height = 39
      Margins.Left = 15
      Align = alLeft
      AutoSize = False
      Caption = 'Demo of TProgressbar'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -17
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitTop = 1
    end
  end
  object ProgressBar1: TProgressBar
    Left = 96
    Top = 152
    Width = 393
    Height = 49
    ParentShowHint = False
    Position = 75
    ShowHint = True
    TabOrder = 1
  end
  object ProgressBar2: TProgressBar
    Left = 96
    Top = 248
    Width = 150
    Height = 153
    ParentShowHint = False
    Position = 75
    State = pbsError
    ShowHint = True
    TabOrder = 2
  end
  object ProgressBar3: TProgressBar
    Left = 339
    Top = 248
    Width = 310
    Height = 281
    Hint = '{"textcolor":"#00f"}'
    ParentShowHint = False
    Position = 75
    State = pbsPaused
    ShowHint = True
    TabOrder = 3
  end
end
