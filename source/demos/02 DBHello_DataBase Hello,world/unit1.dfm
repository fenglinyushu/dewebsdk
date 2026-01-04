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
    Caption = 'DataBase Hello,world!'
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
  object LaTitle: TLabel
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
    ExplicitLeft = 20
    ExplicitTop = 190
    ExplicitWidth = 340
  end
  object EtValue: TEdit
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
    Text = 'EtValue'
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
    object BtPrev: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 120
      Height = 44
      Hint = '{"type":"primary","icon":"el-icon-back"}'
      Align = alLeft
      Caption = 'Prior'
      TabOrder = 0
      OnClick = BtPrevClick
    end
    object BtNext: TButton
      AlignWithMargins = True
      Left = 129
      Top = 3
      Width = 120
      Height = 44
      Hint = '{"type":"primary","righticon":"el-icon-right"}'
      Align = alLeft
      Caption = 'Next'
      TabOrder = 1
      OnClick = BtNextClick
    end
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 72
    Top = 312
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=PG')
    Left = 72
    Top = 432
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    Left = 72
    Top = 376
  end
end
