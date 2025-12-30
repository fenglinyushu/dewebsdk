object Form1: TForm1
  Left = 191
  Top = 60
  HelpType = htKeyword
  BorderStyle = bsNone
  Caption = 'Demo of dwVcl'
  ClientHeight = 748
  ClientWidth = 836
  Color = clWhite
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
    Align = alTop
    BevelOuter = bvNone
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
      Caption = 'Demo of TDateTimePicker'
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
  object Pn2: TPanel
    Left = 0
    Top = 45
    Width = 836
    Height = 45
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    object BtLTWH: TButton
      AlignWithMargins = True
      Left = 3
      Top = 8
      Width = 89
      Height = 30
      Margins.Top = 8
      Margins.Bottom = 7
      Align = alLeft
      Caption = 'Set'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object BtVisible: TButton
      AlignWithMargins = True
      Left = 98
      Top = 8
      Width = 89
      Height = 30
      Margins.Top = 8
      Margins.Bottom = 7
      Align = alLeft
      Caption = 'Get'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object TreeView1: TTreeView
    Left = 320
    Top = 184
    Width = 345
    Height = 281
    Enabled = False
    Indent = 19
    TabOrder = 2
    Items.NodeData = {
      070100000009540054007200650065004E006F00640065002500000000000000
      00000000FFFFFFFFFFFFFFFF0000000000000000000400000001034200530044
      000000210000000000000000000000FFFFFFFFFFFFFFFF000000000000000000
      00000000010141000000210000000000000000000000FFFFFFFFFFFFFFFF0000
      0000000000000000000000010142000000210000000000000000000000FFFFFF
      FFFFFFFFFF000000000000000000000000000101430000002100000000000000
      00000000FFFFFFFFFFFFFFFF0000000000000000000000000001014400}
  end
  object Panel1: TPanel
    Left = 33
    Top = 152
    Width = 281
    Height = 345
    Caption = 'Panel1'
    Enabled = False
    TabOrder = 3
    object TV1: TTreeView
      Left = 24
      Top = 24
      Width = 217
      Height = 185
      Indent = 19
      TabOrder = 0
      Items.NodeData = {
        070200000009540054007200650065004E006F00640065002500000000000000
        00000000FFFFFFFFFFFFFFFF0000000000000000000000000001034100410041
        000000250000000000000000000000FFFFFFFFFFFFFFFF000000000000000000
        0300000001034200420042000000250000000000000000000000FFFFFFFFFFFF
        FFFF000000000000000000000000000103420042004100000025000000000000
        0000000000FFFFFFFFFFFFFFFF00000000000000000000000000010342004200
        42000000250000000000000000000000FFFFFFFFFFFFFFFF0000000000000000
        0001000000010343004300430000002B0000000000000000000000FFFFFFFFFF
        FFFFFF000000000000000000000000000106530044004600530044004600}
    end
    object Button1: TButton
      AlignWithMargins = True
      Left = 24
      Top = 220
      Width = 89
      Height = 30
      Margins.Top = 8
      Margins.Bottom = 7
      Caption = 'Get'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
end
