object Form_StockIn: TForm_StockIn
  Left = 0
  Top = 0
  HelpType = htKeyword
  HelpKeyword = 'embed'
  Caption = 'Form_StockIn'
  ClientHeight = 617
  ClientWidth = 931
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = True
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 20
  object StringGrid1: TStringGrid
    AlignWithMargins = True
    Left = 10
    Top = 179
    Width = 911
    Height = 330
    Hint = '{"dwstyle":"border-top:solid 1px #ddd;"}'
    Margins.Left = 10
    Margins.Top = 0
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alTop
    ColCount = 8
    DefaultColWidth = 150
    DefaultRowHeight = 30
    RowCount = 11
    TabOrder = 0
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
    Top = 529
    Width = 911
    Height = 45
    HelpType = htKeyword
    HelpKeyword = 'page'
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alTop
    TabOrder = 1
    OnChange = TrackBar1Change
  end
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 10
    Top = 10
    Width = 911
    Height = 159
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alTop
    Color = clBtnFace
    ParentBackground = False
    ParentColor = False
    TabOrder = 2
    object Label2: TLabel
      Left = 18
      Top = 22
      Width = 70
      Height = 19
      AutoSize = False
      Caption = #20135#21697#65306
    end
    object Label3: TLabel
      Left = 392
      Top = 22
      Width = 70
      Height = 19
      AutoSize = False
      Caption = #20379#24212#21830#65306
    end
    object Label6: TLabel
      Left = 395
      Top = 64
      Width = 70
      Height = 19
      AutoSize = False
      Caption = #25968#37327#65306
    end
    object Label8: TLabel
      Left = 18
      Top = 64
      Width = 49
      Height = 19
      AutoSize = False
      Caption = #20179#24211#65306
    end
    object Label9: TLabel
      Left = 560
      Top = 64
      Width = 70
      Height = 19
      AutoSize = False
      Caption = #22791#27880#65306
    end
    object Button1: TButton
      Left = 18
      Top = 108
      Width = 265
      Height = 35
      Hint = '{"type":"primary"}'
      Caption = #24320#22987#20837#24211
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = Button1Click
    end
    object ComboBox_Product: TComboBox
      Left = 96
      Top = 19
      Width = 201
      Height = 28
      TabOrder = 1
    end
    object ComboBox_Supplier: TComboBox
      Left = 452
      Top = 19
      Width = 237
      Height = 28
      TabOrder = 2
    end
    object ComboBox_WareHouse: TComboBox
      Left = 96
      Top = 61
      Width = 201
      Height = 28
      TabOrder = 3
    end
    object Edit_Memo: TEdit
      Left = 604
      Top = 61
      Width = 182
      Height = 28
      TabOrder = 4
    end
    object SpinEdit_Num: TSpinEdit
      Left = 452
      Top = 61
      Width = 75
      Height = 30
      Hint = '{"dwstyle":"border:solid 1px #ddd;border-radius:2px"}'
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      MaxValue = 99999
      MinValue = 0
      ParentFont = False
      TabOrder = 5
      Value = 0
    end
    object Button2: TButton
      Left = 303
      Top = 18
      Width = 81
      Height = 30
      Caption = #20135#21697#31649#29702
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
    object Button3: TButton
      Left = 695
      Top = 18
      Width = 91
      Height = 30
      Caption = #20379#24212#21830#31649#29702
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 7
    end
    object Button4: TButton
      Left = 303
      Top = 60
      Width = 81
      Height = 30
      Caption = #20179#24211#31649#29702
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 8
    end
  end
  object FDQuery1: TFDQuery
    Left = 192
    Top = 245
  end
end
