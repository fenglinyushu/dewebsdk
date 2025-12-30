object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'QRcode Creator'
  ClientHeight = 674
  ClientWidth = 360
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  OnMouseUp = FormMouseUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 20
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 360
    Height = 65
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'QRcode Creator '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -31
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
    ExplicitLeft = -8
    ExplicitTop = -40
  end
  object Image_qrcode: TImage
    Left = 0
    Top = 65
    Width = 360
    Height = 352
    Align = alTop
    ExplicitLeft = 2
    ExplicitTop = -6
    ExplicitWidth = 358
  end
  object Button1: TButton
    AlignWithMargins = True
    Left = 30
    Top = 536
    Width = 300
    Height = 45
    Hint = '{"type":"success"}'
    Margins.Left = 30
    Margins.Top = 30
    Margins.Right = 30
    Align = alTop
    Caption = 'Create'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 0
    Top = 417
    Width = 360
    Height = 89
    Align = alTop
    Lines.Strings = (
      'https://delphibbs.com/workrate?id=9527')
    TabOrder = 1
  end
end
