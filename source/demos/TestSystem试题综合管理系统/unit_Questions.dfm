object Form_Questions: TForm_Questions
  Left = 0
  Top = 0
  HelpKeyword = 'embed'
  Caption = #35797#39064#31649#29702
  ClientHeight = 499
  ClientWidth = 975
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clGray
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnCreate = FormCreate
  OnEndDock = FormEndDock
  TextHeight = 20
  object Label_Data: TLabel
    Left = 364
    Top = 0
    Width = 611
    Height = 449
    Hint = '{"dwstyle":"overflow-y:auto;"}'
    Align = alClient
    ExplicitWidth = 4
    ExplicitHeight = 20
  end
  object P_Bottom: TPanel
    Left = 0
    Top = 449
    Width = 975
    Height = 50
    Align = alBottom
    BevelKind = bkSoft
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object Button5: TButton
      AlignWithMargins = True
      Left = 888
      Top = 11
      Width = 80
      Height = 35
      Hint = '{"icon":"el-icon-delete","type":"danger"}'
      Margins.Top = 11
      Margins.Bottom = 0
      Align = alRight
      Caption = #21024#38500
      TabOrder = 0
      OnClick = Button5Click
    end
    object B_Import: TButton
      AlignWithMargins = True
      Left = 20
      Top = 11
      Width = 80
      Height = 35
      Hint = '{"icon":"el-icon-document-add","type":"success"}'
      Margins.Left = 20
      Margins.Top = 11
      Margins.Bottom = 0
      Align = alLeft
      Caption = #23548#20837
      TabOrder = 1
      OnClick = B_ImportClick
    end
  end
  object SC: TScrollBox
    AlignWithMargins = True
    Left = 1
    Top = 1
    Width = 360
    Height = 447
    Margins.Left = 1
    Margins.Top = 1
    Margins.Bottom = 1
    HorzScrollBar.Visible = False
    VertScrollBar.Visible = False
    Align = alLeft
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clWhite
    ParentColor = False
    TabOrder = 2
    object P_Left: TPanel
      Left = 0
      Top = 0
      Width = 360
      Height = 41
      Margins.Right = 0
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Caption = 'P_Left'
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object Button1: TButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 351
        Height = 35
        Hint = '{"type":"default"}'
        Margins.Right = 6
        Align = alTop
        Caption = 'Button1'
        TabOrder = 0
        Visible = False
        OnClick = Button1Click
      end
    end
  end
  object P_DeleteConfirm: TPanel
    Left = 184
    Top = 120
    Width = 340
    Height = 200
    Hint = '{"radius":"10px"}'
    HelpType = htKeyword
    HelpKeyword = 'modal'
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    Visible = False
    object L_DeleteName: TLabel
      Left = 10
      Top = 10
      Width = 320
      Height = 130
      Alignment = taCenter
      AutoSize = False
      Caption = 'L_DeleteName'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -17
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object B_DeleteOK: TButton
      Left = 170
      Top = 150
      Width = 170
      Height = 50
      Hint = 
        '{"type":"primary","dwstyle":"border-top:solid 1px #dcdfd6;border' +
        '-right:0px;","radius":"0px"}'
      Caption = #21024#38500
      TabOrder = 0
      OnClick = B_DeleteOKClick
    end
    object B_DeleteCance: TButton
      Left = 0
      Top = 150
      Width = 170
      Height = 50
      Hint = 
        '{"dwstyle":"background:#FFF;border:solid 1px #dcdfd6;","radius":' +
        '"0px"}'
      Caption = #21462#28040
      TabOrder = 1
      OnClick = B_DeleteCanceClick
    end
  end
  object FDQuery_Paper: TFDQuery
    Left = 394
    Top = 57
  end
  object FDQuery_Topic: TFDQuery
    Left = 394
    Top = 113
  end
  object FDQuery_Question: TFDQuery
    Left = 394
    Top = 169
  end
  object FDQuery_Tmp: TFDQuery
    Left = 394
    Top = 225
  end
end
