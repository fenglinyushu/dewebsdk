object Form_StockOutQuery: TForm_StockOutQuery
  Left = 0
  Top = 0
  HelpType = htKeyword
  HelpKeyword = 'embed'
  Caption = 'Form_StockOutQuery'
  ClientHeight = 619
  ClientWidth = 883
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 20
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 883
    Height = 53
    Hint = '{"dwstyle":"border-bottom:solid 1px #ed6d00;"}'
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object Edit_Search: TEdit
      AlignWithMargins = True
      Left = 10
      Top = 11
      Width = 503
      Height = 30
      Hint = '{"placeholder":"'#35831#36755#20837#26597#35810#20851#38190#23383'"}'
      Margins.Left = 10
      Margins.Top = 11
      Margins.Bottom = 12
      Align = alLeft
      TabOrder = 0
      ExplicitHeight = 28
    end
    object Button_Search: TButton
      AlignWithMargins = True
      Left = 519
      Top = 10
      Width = 78
      Height = 33
      Hint = '{"type":"primary","icon":"el-icon-search"}'
      Margins.Top = 10
      Margins.Bottom = 10
      Align = alLeft
      Caption = #26597#35810
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = Button_SearchClick
    end
  end
  object StringGrid1: TStringGrid
    AlignWithMargins = True
    Left = 10
    Top = 63
    Width = 863
    Height = 330
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alTop
    ColCount = 10
    DefaultColWidth = 150
    DefaultRowHeight = 30
    RowCount = 11
    TabOrder = 1
    OnGetEditMask = StringGrid1GetEditMask
    RowHeights = (
      30
      30
      30
      30
      30
      30
      30
      30
      30
      30
      30)
  end
  object TrackBar1: TTrackBar
    AlignWithMargins = True
    Left = 10
    Top = 393
    Width = 863
    Height = 45
    HelpType = htKeyword
    HelpKeyword = 'page'
    Margins.Left = 10
    Margins.Top = 0
    Margins.Right = 10
    Margins.Bottom = 20
    Align = alTop
    TabOrder = 2
    OnChange = TrackBar1Change
  end
  object FDQuery1: TFDQuery
    Left = 280
    Top = 125
  end
end
