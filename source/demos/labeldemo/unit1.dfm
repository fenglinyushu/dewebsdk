object Form1: TForm1
  Left = 0
  Top = 0
  Hint = '{"type":"primary"}'
  VertScrollBar.Visible = False
  BorderStyle = bsNone
  Caption = 'Hello,World!'
  ClientHeight = 564
  ClientWidth = 320
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
    Left = 0
    Top = 0
    Width = 320
    Height = 81
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'Label'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -37
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
    ExplicitWidth = 382
  end
  object Label2: TLabel
    Left = 0
    Top = 81
    Width = 320
    Height = 56
    HelpType = htKeyword
    HelpKeyword = 'rich'
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'Rich Label'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -37
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
    ExplicitWidth = 382
  end
  object Label3: TLabel
    Left = 0
    Top = 137
    Width = 320
    Height = 40
    HelpType = htKeyword
    HelpKeyword = 'rich'
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'Rich Label'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -37
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
    ExplicitWidth = 382
  end
  object Label4: TLabel
    Left = 0
    Top = 177
    Width = 320
    Height = 40
    HelpType = htKeyword
    HelpKeyword = 'rich'
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'Rich Label'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -37
    Font.Name = 'Verdana'
    Font.Style = [fsItalic]
    ParentFont = False
    Layout = tlCenter
    ExplicitTop = 145
    ExplicitWidth = 382
  end
  object Label5: TLabel
    Left = 0
    Top = 217
    Width = 320
    Height = 56
    HelpType = htKeyword
    HelpKeyword = 'rich'
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'Rich Label'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -37
    Font.Name = 'Verdana'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    Layout = tlCenter
    ExplicitWidth = 382
  end
  object Label6: TLabel
    Left = 0
    Top = 273
    Width = 320
    Height = 40
    HelpType = htKeyword
    HelpKeyword = 'rich'
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'Rich Label'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -37
    Font.Name = 'Verdana'
    Font.Style = [fsBold, fsStrikeOut]
    ParentFont = False
    Layout = tlCenter
    ExplicitLeft = -24
    ExplicitTop = 337
    ExplicitWidth = 382
  end
  object Label7: TLabel
    Left = 0
    Top = 313
    Width = 320
    Height = 40
    HelpType = htKeyword
    HelpKeyword = 'rich'
    Align = alTop
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Rich Label'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -37
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
    ExplicitTop = 385
    ExplicitWidth = 382
  end
  object Label8: TLabel
    Left = 0
    Top = 353
    Width = 320
    Height = 40
    HelpType = htKeyword
    HelpKeyword = 'rich'
    Align = alTop
    AutoSize = False
    Caption = 'Rich Label'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -37
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
    ExplicitTop = 321
    ExplicitWidth = 382
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 408
    Width = 320
    Height = 45
    Margins.Left = 0
    Margins.Top = 15
    Margins.Right = 0
    Align = alTop
    BevelKind = bkTile
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    ExplicitLeft = -5
    ExplicitTop = 411
    object Button2: TButton
      AlignWithMargins = True
      Left = 237
      Top = 3
      Width = 72
      Height = 35
      Hint = '{"borderradius":"0"}'
      Align = alLeft
      Caption = 'S'
      TabOrder = 0
      OnClick = Button2Click
    end
    object Button3: TButton
      AlignWithMargins = True
      Left = 159
      Top = 3
      Width = 72
      Height = 35
      Hint = '{"borderradius":"0"}'
      Align = alLeft
      Caption = 'U'
      TabOrder = 1
      OnClick = Button3Click
      ExplicitLeft = 162
    end
    object Button4: TButton
      AlignWithMargins = True
      Left = 81
      Top = 3
      Width = 72
      Height = 35
      Hint = '{"borderradius":"0"}'
      Align = alLeft
      Caption = 'I'
      TabOrder = 2
      OnClick = Button4Click
    end
    object Button5: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 72
      Height = 35
      Hint = '{"borderradius":"0"}'
      Align = alLeft
      Caption = 'B'
      TabOrder = 3
      OnClick = Button5Click
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 471
    Width = 320
    Height = 45
    Margins.Left = 0
    Margins.Top = 15
    Margins.Right = 0
    Align = alTop
    BevelKind = bkTile
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    ExplicitTop = 416
    object Button9: TButton
      AlignWithMargins = True
      Left = 159
      Top = 3
      Width = 72
      Height = 35
      Hint = '{"borderradius":"0"}'
      Align = alLeft
      Caption = 'Align'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button14: TButton
      AlignWithMargins = True
      Left = 81
      Top = 3
      Width = 72
      Height = 35
      Hint = '{"borderradius":"0"}'
      Align = alLeft
      Caption = 'Size'
      TabOrder = 1
      OnClick = Button6Click
    end
    object Button15: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 72
      Height = 35
      Hint = '{"borderradius":"3px 0 0 3px"}'
      Align = alLeft
      Caption = 'Color'
      TabOrder = 2
      OnClick = Button7Click
    end
    object Button16: TButton
      AlignWithMargins = True
      Left = 237
      Top = 3
      Width = 72
      Height = 35
      Hint = '{"borderradius":"0 3px 3px 0"}'
      Align = alLeft
      Caption = 'Name'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Georgia'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Button8Click
    end
  end
end