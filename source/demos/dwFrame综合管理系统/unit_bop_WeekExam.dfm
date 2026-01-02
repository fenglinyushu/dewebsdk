object Form_bop_WeekExam: TForm_bop_WeekExam
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #27599#21608#25968#25454
  ClientHeight = 540
  ClientWidth = 989
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
  object LaDate: TLabel
    AlignWithMargins = True
    Left = 20
    Top = 497
    Width = 949
    Height = 23
    Margins.Left = 20
    Margins.Top = 0
    Margins.Right = 20
    Margins.Bottom = 20
    Align = alBottom
    Caption = 'LaDate'
    ExplicitTop = 507
    ExplicitWidth = 56
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 989
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object EtKey: TEdit
      AlignWithMargins = True
      Left = 10
      Top = 15
      Width = 150
      Height = 30
      Margins.Left = 10
      Margins.Top = 15
      Margins.Right = 15
      Margins.Bottom = 15
      Align = alLeft
      TabOrder = 0
      OnChange = EtKeyChange
      ExplicitHeight = 31
    end
    object Button1: TButton
      AlignWithMargins = True
      Left = 848
      Top = 15
      Width = 65
      Height = 30
      Hint = '{"icon":"el-icon-arrow-left","radius":"3px 0 0 3px"}'
      Margins.Left = 0
      Margins.Top = 15
      Margins.Right = 0
      Margins.Bottom = 15
      Align = alRight
      Caption = #19978#21608
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      AlignWithMargins = True
      Left = 914
      Top = 15
      Width = 65
      Height = 30
      Hint = '{"righticon":"el-icon-arrow-right","radius":"0 3px 3px 0"}'
      Margins.Left = 1
      Margins.Top = 15
      Margins.Right = 10
      Margins.Bottom = 15
      Align = alRight
      Caption = #19979#21608
      TabOrder = 2
      OnClick = Button2Click
    end
  end
  object Fp1: TFlowPanel
    AlignWithMargins = True
    Left = 10
    Top = 60
    Width = 969
    Height = 432
    Hint = 
      '{"dwstyle":"border:solid 1px #ddd;border-radius:3px;overflow-y:a' +
      'uto;"}'
    Margins.Left = 10
    Margins.Top = 0
    Margins.Right = 10
    Margins.Bottom = 5
    Align = alClient
    AutoSize = True
    BevelOuter = bvNone
    Caption = 'Fp1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    ExplicitHeight = 470
    object BtTimes: TButton
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 80
      Height = 25
      Hint = '{"type":"success","style":"plain"}'
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 0
      Margins.Bottom = 0
      Caption = 'BtTimes'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Visible = False
    end
  end
  object FDQuery1: TFDQuery
    FetchOptions.AssignedValues = [evMode, evRecordCountMode]
    FetchOptions.Mode = fmAll
    FetchOptions.RecordCountMode = cmTotal
    Left = 122
    Top = 172
  end
end
