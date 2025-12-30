object Form_Item: TForm_Item
  Left = 0
  Top = 0
  HelpType = htKeyword
  HelpKeyword = 'embed'
  Caption = '[*caption*]'
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
  OnShow = FormShow
  OnStartDock = FormStartDock
  PixelsPerInch = 96
  TextHeight = 20
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 10
    Top = 465
    Width = 911
    Height = 182
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alBottom
    Color = clBtnFace
    Enabled = False
    ParentBackground = False
    ParentColor = False
    TabOrder = 0
    ExplicitTop = 443
    object Label9: TLabel
      Left = 15
      Top = 22
      Width = 44
      Height = 20
      AutoSize = False
      Caption = #21517#31216
    end
    object Label2: TLabel
      Left = 430
      Top = 22
      Width = 61
      Height = 20
      AutoSize = False
      Caption = #32852#31995#30005#35805
    end
    object Label4: TLabel
      Left = 223
      Top = 22
      Width = 44
      Height = 20
      AutoSize = False
      Caption = #32852#31995#20154
    end
    object Label1: TLabel
      Left = 223
      Top = 90
      Width = 61
      Height = 20
      AutoSize = False
      Caption = #22791#27880
    end
    object Label3: TLabel
      Left = 15
      Top = 56
      Width = 44
      Height = 20
      AutoSize = False
      Caption = #22320#22336
    end
    object Label5: TLabel
      Left = 430
      Top = 56
      Width = 61
      Height = 20
      AutoSize = False
      Caption = #37038#31665
    end
    object Label6: TLabel
      Left = 223
      Top = 56
      Width = 44
      Height = 20
      AutoSize = False
      Caption = #37038#32534
    end
    object Label7: TLabel
      Left = 15
      Top = 90
      Width = 82
      Height = 20
      AutoSize = False
      Caption = #24635#20307#20171#32461
    end
    object Edit_Name: TEdit
      Left = 81
      Top = 20
      Width = 127
      Height = 28
      TabOrder = 0
    end
    object Button_Save: TButton
      Left = 12
      Top = 135
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
    object Edit_1: TEdit
      Left = 277
      Top = 20
      Width = 127
      Height = 28
      TabOrder = 2
    end
    object Button_Add: TButton
      Left = 113
      Top = 135
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
      TabOrder = 3
      OnClick = Button_AddClick
    end
    object Button_Delete: TButton
      Left = 214
      Top = 135
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
      TabOrder = 4
      OnClick = Button_DeleteClick
    end
    object Edit_Memo: TEdit
      Left = 277
      Top = 88
      Width = 347
      Height = 28
      TabOrder = 5
    end
    object Edit_2: TEdit
      Left = 497
      Top = 20
      Width = 127
      Height = 28
      TabOrder = 6
    end
    object Edit_3: TEdit
      Left = 81
      Top = 54
      Width = 127
      Height = 28
      TabOrder = 7
    end
    object Edit_4: TEdit
      Left = 277
      Top = 54
      Width = 127
      Height = 28
      TabOrder = 8
    end
    object Edit_5: TEdit
      Left = 497
      Top = 54
      Width = 127
      Height = 28
      TabOrder = 9
    end
    object Edit_6: TEdit
      Left = 81
      Top = 88
      Width = 127
      Height = 28
      TabOrder = 10
    end
  end
  object StringGrid1: TStringGrid
    AlignWithMargins = True
    Left = 10
    Top = 63
    Width = 911
    Height = 352
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alClient
    ColCount = 9
    DefaultColWidth = 100
    DefaultRowHeight = 40
    FixedCols = 0
    RowCount = 11
    TabOrder = 1
    OnClick = StringGrid1Click
    ExplicitHeight = 330
  end
  object TrackBar1: TTrackBar
    AlignWithMargins = True
    Left = 10
    Top = 435
    Width = 911
    Height = 20
    Hint = '{"dwattr":"background"}'
    HelpType = htKeyword
    HelpKeyword = 'page'
    Margins.Left = 10
    Margins.Top = 20
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alBottom
    TabOrder = 2
    OnChange = TrackBar1Change
    ExplicitTop = 413
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
