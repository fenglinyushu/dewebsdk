object Form_Product: TForm_Product
  Left = 0
  Top = 0
  HelpType = htKeyword
  HelpKeyword = 'embed'
  Caption = #21830#21697#20449#24687
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
    Top = 497
    Width = 911
    Height = 150
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
      Left = 470
      Top = 22
      Width = 61
      Height = 20
      AutoSize = False
      Caption = #21333#20301
    end
    object Label4: TLabel
      Left = 223
      Top = 22
      Width = 44
      Height = 20
      AutoSize = False
      Caption = #22411#21495
    end
    object Label6: TLabel
      Left = 15
      Top = 57
      Width = 44
      Height = 20
      AutoSize = False
      Caption = #21333#20215
    end
    object Label1: TLabel
      Left = 223
      Top = 57
      Width = 61
      Height = 20
      AutoSize = False
      Caption = #22791#27880
    end
    object ComboBox_Group: TComboBox
      Left = 520
      Top = 20
      Width = 127
      Height = 28
      TabOrder = 0
      Text = #20010
      Items.Strings = (
        #20010
        #37096
        #31859
        #21488
        #21452
        #23545
        #22871
        #24352
        #30418
        #36742)
    end
    object Edit_Name: TEdit
      Left = 69
      Top = 20
      Width = 127
      Height = 28
      TabOrder = 1
    end
    object Button_Save: TButton
      Left = 12
      Top = 105
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
      TabOrder = 2
      OnClick = Button_SaveClick
    end
    object SpinEdit_1: TSpinEdit
      Left = 69
      Top = 55
      Width = 127
      Height = 30
      Hint = '{"dwstyle":"border:solid 1px #ddd;border-radius:2px"}'
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      MaxLength = 12
      MaxValue = 99
      MinValue = 0
      ParentFont = False
      TabOrder = 3
      Value = 25
    end
    object Edit_1: TEdit
      Left = 277
      Top = 20
      Width = 127
      Height = 28
      TabOrder = 4
    end
    object Button_Add: TButton
      Left = 113
      Top = 105
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
      TabOrder = 5
      OnClick = Button_AddClick
    end
    object Button_Delete: TButton
      Left = 214
      Top = 105
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
      TabOrder = 6
      OnClick = Button_DeleteClick
    end
    object Edit_Memo: TEdit
      Left = 277
      Top = 55
      Width = 370
      Height = 28
      TabOrder = 7
    end
  end
  object StringGrid1: TStringGrid
    AlignWithMargins = True
    Left = 10
    Top = 63
    Width = 911
    Height = 384
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alClient
    ColCount = 6
    DefaultColWidth = 150
    DefaultRowHeight = 40
    FixedCols = 0
    RowCount = 11
    TabOrder = 1
    OnClick = StringGrid1Click
  end
  object TrackBar1: TTrackBar
    AlignWithMargins = True
    Left = 10
    Top = 457
    Width = 911
    Height = 30
    Hint = '{"dwattr":"background"}'
    HelpType = htKeyword
    HelpKeyword = 'page'
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alBottom
    TabOrder = 2
    OnChange = TrackBar1Change
    ExplicitTop = 403
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
    Left = 80
    Top = 381
  end
end
