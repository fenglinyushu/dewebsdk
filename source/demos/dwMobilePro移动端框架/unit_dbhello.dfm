object Form_dbhello: TForm_dbhello
  Left = 0
  Top = 0
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
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 23
  object Label2: TLabel
    AlignWithMargins = True
    Left = 30
    Top = 100
    Width = 300
    Height = 40
    Margins.Left = 30
    Margins.Top = 50
    Margins.Right = 30
    Align = alTop
    AutoSize = False
    Caption = #29992#25143#22995#21517#65306
    Layout = tlCenter
    ExplicitLeft = 35
    ExplicitTop = 110
  end
  object DBText1: TDBText
    AlignWithMargins = True
    Left = 30
    Top = 146
    Width = 300
    Height = 37
    Margins.Left = 30
    Margins.Right = 30
    Align = alTop
    DataField = 'mName'
    DataSource = DataSource1
    ExplicitTop = 156
  end
  object Edit1: TEdit
    AlignWithMargins = True
    Left = 30
    Top = 206
    Width = 300
    Height = 40
    Margins.Left = 30
    Margins.Top = 20
    Margins.Right = 30
    Align = alTop
    AutoSize = False
    TabOrder = 0
    Text = 'Edit1'
    ExplicitTop = 216
  end
  object Panel4: TPanel
    Left = 0
    Top = 490
    Width = 360
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    Color = clNone
    ParentBackground = False
    TabOrder = 1
    object B_Prev: TButton
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 170
      Height = 50
      Hint = 
        '{"type":"primary","dwstyle":"border-top:solid 1px #dcdfd6;border' +
        '-right:0px;","radius":"0px","icon":"el-icon-back"}'
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 1
      Margins.Bottom = 0
      Align = alLeft
      Caption = #19978#19968#39033
      TabOrder = 0
      OnClick = B_PrevClick
    end
    object B_Next: TButton
      Left = 171
      Top = 0
      Width = 189
      Height = 50
      Hint = 
        '{"type":"primary","dwstyle":"border-top:solid 1px #dcdfd6;border' +
        '-right:0px;","radius":"0px","righticon":"el-icon-right"}'
      Align = alClient
      Caption = #19979#19968#39033
      TabOrder = 1
      OnClick = B_NextClick
    end
  end
  object PTitle: TPanel
    Left = 0
    Top = 0
    Width = 360
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    Color = 16359209
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 2
    ExplicitLeft = -640
    ExplicitWidth = 1000
    object LTitle: TLabel
      AlignWithMargins = True
      Left = 50
      Top = 3
      Width = 260
      Height = 44
      Margins.Left = 0
      Margins.Right = 50
      Align = alClient
      Alignment = taCenter
      Caption = #25968#25454#24211#25805#20316#20837#38376
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -20
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 140
      ExplicitHeight = 27
    end
    object B0: TButton
      Left = 0
      Top = 0
      Width = 50
      Height = 50
      Hint = 
        '{"type":"text","icon":"el-icon-arrow-left","onclick":"try{histor' +
        'y.back()}finally{};"}'
      Align = alLeft
      Cancel = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -23
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
  object FDQuery1: TFDQuery
    Left = 40
    Top = 312
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 40
    Top = 376
  end
end
