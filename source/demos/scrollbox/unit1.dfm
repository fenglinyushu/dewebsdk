object Form1: TForm1
  Left = 0
  Top = 0
  Hint = '{"type":"primary"}'
  BorderStyle = bsNone
  Caption = 'Hello,World!'
  ClientHeight = 564
  ClientWidth = 360
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  OnMouseUp = FormMouseUp
  PixelsPerInch = 96
  TextHeight = 20
  object Label1: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 354
    Height = 50
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'Label1'
    Layout = tlCenter
  end
  object Label2: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 459
    Width = 354
    Height = 50
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'TScrollBox '#26080#38480#24490#29615
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #24494#36719#38597#40657
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
    ExplicitLeft = -13
    ExplicitTop = 547
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 56
    Width = 360
    Height = 400
    VertScrollBar.Visible = False
    Align = alTop
    TabOrder = 0
    OnEndDock = ScrollBox1EndDock
    ExplicitTop = 26
    ExplicitWidth = 382
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 356
      Height = 1000
      Align = alTop
      Caption = 'Panel1'
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      ExplicitLeft = -1
      ExplicitTop = 1
      ExplicitWidth = 378
      DesignSize = (
        356
        1000)
      object Button1: TButton
        AlignWithMargins = True
        Left = 10
        Top = 10
        Width = 334
        Height = 235
        Hint = '{"type":"success"}'
        Margins.Left = 9
        Margins.Top = 9
        Margins.Right = 9
        Margins.Bottom = 9
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Button1'
        TabOrder = 0
      end
      object Button2: TButton
        AlignWithMargins = True
        Left = 10
        Top = 260
        Width = 334
        Height = 235
        Hint = '{"type":"primary"}'
        Margins.Left = 9
        Margins.Top = 9
        Margins.Right = 9
        Margins.Bottom = 9
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Button2'
        TabOrder = 1
      end
      object Button3: TButton
        AlignWithMargins = True
        Left = 10
        Top = 510
        Width = 334
        Height = 235
        Hint = '{"type":"info"}'
        Margins.Left = 9
        Margins.Top = 9
        Margins.Right = 9
        Margins.Bottom = 9
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Button3'
        TabOrder = 2
      end
      object Button4: TButton
        AlignWithMargins = True
        Left = 10
        Top = 760
        Width = 334
        Height = 235
        Hint = '{"type":"danger"}'
        Margins.Left = 9
        Margins.Top = 9
        Margins.Right = 9
        Margins.Bottom = 9
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Button4'
        TabOrder = 3
      end
    end
  end
end
