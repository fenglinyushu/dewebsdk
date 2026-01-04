object Form_dem_DBHello: TForm_dem_DBHello
  Left = 0
  Top = 0
  Hint = '{"hidefoot":1}'
  HelpKeyword = 'embed'
  BorderStyle = bsNone
  Caption = 'DataBase Hello'
  ClientHeight = 658
  ClientWidth = 400
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clGray
  Font.Height = -17
  Font.Name = #24605#28304#40657#20307' CN'
  Font.Style = []
  Position = poDesigned
  OnShow = FormShow
  TextHeight = 25
  object LaTitle: TLabel
    AlignWithMargins = True
    Left = 30
    Top = 190
    Width = 340
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
  object Label1: TLabel
    AlignWithMargins = True
    Left = 20
    Top = 20
    Width = 360
    Height = 100
    Hint = '{'#13#10'"dwstyle":"border-radius:8px;"'#13#10'}'
    Margins.Left = 20
    Margins.Top = 20
    Margins.Right = 20
    Margins.Bottom = 20
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'Hello, World!'
    Color = 5685511
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -20
    Font.Name = #24605#28304#40657#20307' CN'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = False
    Layout = tlCenter
    ExplicitLeft = 25
    ExplicitTop = -23
  end
  object EtValue: TEdit
    AlignWithMargins = True
    Left = 30
    Top = 253
    Width = 340
    Height = 40
    Margins.Left = 30
    Margins.Top = 20
    Margins.Right = 30
    Align = alTop
    AutoSize = False
    TabOrder = 0
    Text = 'EtValue'
    ExplicitTop = 113
  end
  object Panel4: TPanel
    AlignWithMargins = True
    Left = 30
    Top = 326
    Width = 340
    Height = 50
    Margins.Left = 30
    Margins.Top = 30
    Margins.Right = 30
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 1
    ExplicitTop = 186
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
    Left = 40
    Top = 312
  end
end
