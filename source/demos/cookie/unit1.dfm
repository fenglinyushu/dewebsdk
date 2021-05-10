object Form1: TForm1
  Left = 0
  Top = 0
  Hint = '{"type":"success"}'
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'DeWeb'
  ClientHeight = 480
  ClientWidth = 360
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = 16448250
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  PixelsPerInch = 96
  TextHeight = 20
  object Button1: TButton
    Left = 24
    Top = 56
    Width = 100
    Height = 30
    Hint = '{"type":"success"}'
    Caption = 'Set Cookie'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 24
    Top = 104
    Width = 100
    Height = 30
    Hint = '{"type":"success"}'
    Caption = 'Get Cookie'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Edit_Name: TEdit
    Left = 138
    Top = 56
    Width = 79
    Height = 28
    TabOrder = 2
    Text = 'Name'
  end
  object Edit_GetName: TEdit
    Left = 138
    Top = 104
    Width = 79
    Height = 28
    TabOrder = 3
    Text = 'Name'
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 360
    Height = 41
    Hint = '{"dwstyle":"border-bottom:solid 1px #aaa;"}'
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 4
    object Label1: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 354
      Height = 35
      Align = alClient
      Alignment = taCenter
      Caption = 'Cookie'
      Layout = tlCenter
      ExplicitWidth = 51
      ExplicitHeight = 20
    end
  end
  object Edit_Value: TEdit
    Left = 223
    Top = 56
    Width = 79
    Height = 28
    TabOrder = 5
    Text = '36S107'
  end
end
