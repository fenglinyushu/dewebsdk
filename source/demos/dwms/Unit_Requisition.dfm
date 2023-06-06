object Form_Requisition: TForm_Requisition
  Left = 0
  Top = 0
  HelpType = htKeyword
  HelpKeyword = 'embed'
  ClientHeight = 657
  ClientWidth = 931
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnStartDock = FormStartDock
  PixelsPerInch = 96
  TextHeight = 20
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 10
    Top = 443
    Width = 911
    Height = 118
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alTop
    Color = clBtnFace
    Enabled = False
    ParentBackground = False
    ParentColor = False
    TabOrder = 0
    object Label9: TLabel
      Left = 15
      Top = 22
      Width = 44
      Height = 20
      AutoSize = False
      Caption = #21517#31216
    end
    object Label1: TLabel
      Left = 300
      Top = 21
      Width = 61
      Height = 20
      AutoSize = False
      Caption = #22791#27880
    end
    object Edit_Name: TEdit
      Left = 65
      Top = 20
      Width = 216
      Height = 28
      TabOrder = 0
    end
    object Button_Save: TButton
      Left = 12
      Top = 73
      Width = 100
      Height = 30
      Hint = '{"type":"primary","radius":"5px 0 0 5px"}'
      Caption = #20445#23384
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = Button_SaveClick
    end
    object Button_Add: TButton
      Left = 113
      Top = 73
      Width = 100
      Height = 30
      Hint = '{"type":"primary","radius":"0"}'
      Caption = #22686#21152
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = Button_AddClick
    end
    object Button_Delete: TButton
      Left = 214
      Top = 73
      Width = 100
      Height = 30
      Hint = '{"type":"primary","radius":"0 5px 5px 0"}'
      Caption = #21024#38500
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Button_DeleteClick
    end
    object Edit_Memo: TEdit
      Left = 354
      Top = 19
      Width = 252
      Height = 28
      TabOrder = 4
    end
  end
  object StringGrid1: TStringGrid
    AlignWithMargins = True
    Left = 10
    Top = 63
    Width = 911
    Height = 330
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alTop
    ColCount = 3
    DefaultColWidth = 150
    DefaultRowHeight = 30
    FixedCols = 0
    RowCount = 11
    TabOrder = 1
    OnClick = StringGrid1Click
    RowHeights = (
      30
      30
      31
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
    Top = 403
    Width = 911
    Height = 30
    HelpType = htKeyword
    HelpKeyword = 'page'
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alTop
    TabOrder = 2
    OnChange = TrackBar1Change
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 931
    Height = 53
    Hint = '{"dwstyle":"border-bottom:solid 1px #ed6d00;"}'
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 3
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
      Height = 32
      Hint = '{"type":"primary","icon":"el-icon-search"}'
      Margins.Top = 10
      Margins.Bottom = 11
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
  object FDQuery1: TFDQuery
    Left = 280
    Top = 125
  end
end
