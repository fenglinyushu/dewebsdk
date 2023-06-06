object Form_User: TForm_User
  Left = 0
  Top = 0
  HelpType = htKeyword
  HelpKeyword = 'embed'
  Caption = 'Form_User'
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
    Height = 180
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
      Top = 21
      Width = 44
      Height = 20
      AutoSize = False
      Caption = #29992#25143#21517
    end
    object Label2: TLabel
      Left = 215
      Top = 21
      Width = 61
      Height = 20
      AutoSize = False
      Caption = #29992#25143#32452
    end
    object Label3: TLabel
      Left = 480
      Top = 21
      Width = 44
      Height = 20
      AutoSize = False
      Caption = #37096#38376
    end
    object Label4: TLabel
      Left = 15
      Top = 55
      Width = 44
      Height = 20
      AutoSize = False
      Caption = #32844#21153
    end
    object Label5: TLabel
      Left = 215
      Top = 55
      Width = 61
      Height = 20
      AutoSize = False
      Caption = #24615#21035
    end
    object Label6: TLabel
      Left = 339
      Top = 53
      Width = 44
      Height = 20
      AutoSize = False
      Caption = #24180#40836
    end
    object Label7: TLabel
      Left = 480
      Top = 56
      Width = 44
      Height = 20
      AutoSize = False
      Caption = #30005#35805
    end
    object Label8: TLabel
      Left = 15
      Top = 89
      Width = 61
      Height = 20
      AutoSize = False
      Caption = #22320#22336
    end
    object Label1: TLabel
      Left = 480
      Top = 90
      Width = 61
      Height = 20
      AutoSize = False
      Caption = #22791#27880
    end
    object ComboBox_UserGroup: TComboBox
      Left = 265
      Top = 19
      Width = 180
      Height = 28
      TabOrder = 0
    end
    object Edit_User: TEdit
      Left = 69
      Top = 19
      Width = 127
      Height = 28
      TabOrder = 1
    end
    object Button_Save: TButton
      Left = 12
      Top = 130
      Width = 100
      Height = 35
      Hint = '{"type":"primary","radius":"5px 0 0 5px"}'
      Caption = #20445#23384#20462#25913
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = Button_SaveClick
    end
    object SpinEdit_Age: TSpinEdit
      Left = 386
      Top = 52
      Width = 59
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
    object Edit_Partment: TEdit
      Left = 520
      Top = 19
      Width = 127
      Height = 28
      TabOrder = 4
    end
    object Edit_Title: TEdit
      Left = 69
      Top = 54
      Width = 127
      Height = 28
      TabOrder = 5
    end
    object ComboBox_Sex: TComboBox
      Left = 265
      Top = 54
      Width = 60
      Height = 28
      ItemIndex = 0
      TabOrder = 6
      Text = #30007
      Items.Strings = (
        #30007
        #22899)
    end
    object Edit_Phone: TEdit
      Left = 520
      Top = 54
      Width = 127
      Height = 28
      TabOrder = 7
    end
    object Button_Add: TButton
      Left = 113
      Top = 130
      Width = 100
      Height = 35
      Hint = '{"type":"primary","radius":"0"}'
      Caption = #22686#21152#26032#29992#25143
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      OnClick = Button_AddClick
    end
    object Button_Delete: TButton
      Left = 214
      Top = 130
      Width = 100
      Height = 35
      Hint = '{"type":"primary","radius":"0"}'
      Caption = #21024#38500#29992#25143
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      OnClick = Button_DeleteClick
    end
    object Button_ResetPsd: TButton
      Left = 315
      Top = 130
      Width = 100
      Height = 35
      Hint = '{"type":"primary","radius":"0 5px 5px 0"}'
      Caption = #37325#32622#23494#30721
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 10
    end
    object Edit_Addr: TEdit
      Left = 69
      Top = 88
      Width = 376
      Height = 28
      TabOrder = 11
    end
    object Edit_Memo: TEdit
      Left = 520
      Top = 88
      Width = 127
      Height = 28
      TabOrder = 12
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
    ColCount = 10
    DefaultColWidth = 150
    DefaultRowHeight = 30
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
