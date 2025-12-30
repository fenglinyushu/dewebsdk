object Form2: TForm2
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Pretty Girl'
  ClientHeight = 480
  ClientWidth = 320
  Color = 15660543
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 320
    Height = 406
    Hint = '{"src":"media/images/hrd/1.jpg"}'
    Align = alClient
    ExplicitHeight = 401
  end
  object Button1: TButton
    AlignWithMargins = True
    Left = 80
    Top = 426
    Width = 160
    Height = 34
    Hint = '{"type":"success"}'
    Margins.Left = 80
    Margins.Top = 20
    Margins.Right = 80
    Margins.Bottom = 20
    Align = alBottom
    Caption = 'OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
end
