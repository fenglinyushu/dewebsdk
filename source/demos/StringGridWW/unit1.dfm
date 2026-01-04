object Form1: TForm1
  Left = 0
  Top = 0
  Hint = 
    '{"borders":[{"start":[2,0],"end":[16,14],"position":"all","style' +
    '":"solid 2px #333;"}]}'
  VertScrollBar.Visible = False
  BorderStyle = bsNone
  Caption = #36229#24378'StringGrid'#21151#33021#28436#31034
  ClientHeight = 830
  ClientWidth = 1000
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  OnMouseUp = FormMouseUp
  PixelsPerInch = 96
  TextHeight = 20
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 791
    Width = 994
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object Button_Set: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 75
      Height = 30
      Hint = '{"type":"primary"}'
      Align = alLeft
      Caption = #20889'Cell'
      TabOrder = 0
      OnClick = Button_SetClick
    end
    object SpinEdit_ColSet: TSpinEdit
      AlignWithMargins = True
      Left = 84
      Top = 3
      Width = 69
      Height = 30
      Hint = '{"dwstyle":"border:solid 1px #eee;border-radius:2px"}'
      Align = alLeft
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 1
    end
    object SpinEdit_RowSet: TSpinEdit
      AlignWithMargins = True
      Left = 159
      Top = 3
      Width = 69
      Height = 30
      Hint = '{"dwstyle":"border:solid 1px #eee;border-radius:2px"}'
      Align = alLeft
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 1
    end
    object Edit_Set: TEdit
      AlignWithMargins = True
      Left = 234
      Top = 3
      Width = 121
      Height = 30
      Align = alLeft
      TabOrder = 3
      Text = 'Edit_Set'
      ExplicitHeight = 28
    end
    object B_ToExcel: TButton
      AlignWithMargins = True
      Left = 388
      Top = 3
      Width = 90
      Height = 30
      Hint = '{"type":"primary"}'
      Margins.Left = 30
      Align = alLeft
      Caption = #23548#20986'Excel'
      TabOrder = 4
      OnClick = B_ToExcelClick
    end
    object B_Download: TButton
      AlignWithMargins = True
      Left = 484
      Top = 3
      Width = 90
      Height = 30
      Hint = '{"type":"primary"}'
      Align = alLeft
      Caption = #19979#36733'Excel'
      Enabled = False
      TabOrder = 5
      OnClick = B_DownloadClick
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 749
    Width = 994
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object Button_Get: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 75
      Height = 30
      Hint = '{"type":"primary"}'
      Align = alLeft
      Caption = #35835'Cell'
      TabOrder = 0
      OnClick = Button_GetClick
    end
    object SpinEdit_ColGet: TSpinEdit
      AlignWithMargins = True
      Left = 84
      Top = 3
      Width = 69
      Height = 30
      Hint = '{"dwstyle":"border:solid 1px #eee;border-radius:2px"}'
      Align = alLeft
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 1
    end
    object SpinEdit_RowGet: TSpinEdit
      AlignWithMargins = True
      Left = 159
      Top = 3
      Width = 69
      Height = 30
      Hint = '{"dwstyle":"border:solid 1px #eee;border-radius:2px"}'
      Align = alLeft
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 1
    end
    object Edit_Get: TEdit
      AlignWithMargins = True
      Left = 234
      Top = 3
      Width = 121
      Height = 30
      Align = alLeft
      TabOrder = 3
      ExplicitHeight = 28
    end
    object Button_SaveToFile: TButton
      AlignWithMargins = True
      Left = 388
      Top = 3
      Width = 90
      Height = 30
      Hint = '{"type":"primary"}'
      Margins.Left = 30
      Align = alLeft
      Caption = #23548#20986'JSON'
      TabOrder = 4
      OnClick = Button_SaveToFileClick
    end
    object Button_LoadFromFile: TButton
      AlignWithMargins = True
      Left = 484
      Top = 3
      Width = 90
      Height = 30
      Hint = '{"type":"primary"}'
      Align = alLeft
      Caption = #23548#20837'JSON'
      TabOrder = 5
      OnClick = Button_LoadFromFileClick
    end
    object Button1: TButton
      Left = 632
      Top = 0
      Width = 75
      Height = 25
      Caption = #27979#35797
      TabOrder = 6
      OnClick = Button1Click
    end
  end
  object Panel3: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 707
    Width = 994
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    object Label_Event: TLabel
      AlignWithMargins = True
      Left = 207
      Top = 3
      Width = 784
      Height = 30
      Align = alClient
      AutoSize = False
      Caption = '...'
      Layout = tlCenter
      ExplicitWidth = 12
      ExplicitHeight = 20
    end
    object Label2: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 198
      Height = 30
      Align = alLeft
      Alignment = taRightJustify
      AutoSize = False
      Caption = #20107#20214#65288'OnGetEditMask'#65289#65306
      Layout = tlCenter
    end
  end
  object SG: TStringGrid
    AlignWithMargins = True
    Left = 5
    Top = 5
    Width = 990
    Height = 694
    Hint = 
      '{"borders":[{"start":[0,7],"end":[6,14],"style":"border:solid 2p' +
      'x #000;"}]}'
    HelpType = htKeyword
    HelpKeyword = 'ww'
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    ColCount = 7
    DefaultColWidth = 90
    DefaultRowHeight = 60
    RowCount = 15
    Font.Charset = ANSI_CHARSET
    Font.Color = 6579300
    Font.Height = -17
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    GradientEndColor = 9868950
    ParentFont = False
    TabOrder = 3
    OnDragDrop = SGDragDrop
    OnGetEditMask = SGGetEditMask
    RowHeights = (
      60
      60
      60
      60
      60
      60
      60
      60
      60
      60
      60
      60
      60
      60
      60)
  end
end
