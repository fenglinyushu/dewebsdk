object Form1: TForm1
  Left = 0
  Top = 0
  Hint = '{"icon":"media/ico/image.png"}'
  BorderStyle = bsNone
  Caption = 'DeWeb'
  ClientHeight = 540
  ClientWidth = 360
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OnMouseUp = FormMouseUp
  OnShow = FormShow
  TextHeight = 23
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 360
    Height = 60
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = #25968#25454#24211#25805#20316#20837#38376
    Color = cl3DLight
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Verdana'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = False
    Layout = tlCenter
  end
  object Label2: TLabel
    AlignWithMargins = True
    Left = 30
    Top = 110
    Width = 300
    Height = 40
    Margins.Left = 30
    Margins.Top = 50
    Margins.Right = 30
    Align = alTop
    AutoSize = False
    Caption = 'Name'
    Layout = tlCenter
    ExplicitTop = 157
    ExplicitWidth = 310
  end
  object Edit1: TEdit
    AlignWithMargins = True
    Left = 30
    Top = 173
    Width = 300
    Height = 40
    Margins.Left = 30
    Margins.Top = 20
    Margins.Right = 30
    Align = alTop
    AutoSize = False
    TabOrder = 0
    Text = 'Edit1'
  end
  object Panel4: TPanel
    AlignWithMargins = True
    Left = 30
    Top = 246
    Width = 300
    Height = 50
    Margins.Left = 30
    Margins.Top = 30
    Margins.Right = 30
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 1
    object B_Prev: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 145
      Height = 44
      Hint = '{"type":"primary","icon":"el-icon-back"}'
      Align = alLeft
      Caption = #19978#19968#39033
      TabOrder = 0
      OnClick = B_PrevClick
    end
    object B_Next: TButton
      AlignWithMargins = True
      Left = 154
      Top = 3
      Width = 143
      Height = 44
      Hint = '{"type":"primary","righticon":"el-icon-right"}'
      Align = alClient
      Caption = #19979#19968#39033' '
      TabOrder = 1
      OnClick = B_NextClick
    end
  end
  object FDConnection1: TFDConnection
    Left = 40
    Top = 248
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 40
    Top = 312
  end
  object FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink
    Left = 240
    Top = 256
  end
  object FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink
    Left = 240
    Top = 320
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 240
    Top = 384
  end
end
