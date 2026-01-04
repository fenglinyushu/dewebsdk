object Form1: TForm1
  Left = 0
  Top = 0
  Hint = '{"type":"primary"}'
  BorderStyle = bsNone
  Caption = 'login '
  ClientHeight = 728
  ClientWidth = 1012
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = 15790320
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24605#28304#40657#20307' CN'
  Font.Style = []
  Position = poDesigned
  OnMouseUp = FormMouseUp
  OnShow = FormShow
  DesignSize = (
    1012
    728)
  TextHeight = 22
  object Imbg: TImage
    Left = 462
    Top = 62
    Width = 296
    Height = 395
    Margins.Top = 4
    Stretch = True
  end
  object LaError: TLabel
    Left = 0
    Top = 0
    Width = 1012
    Height = 60
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'LaError'
    Color = clRed
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -15
    Font.Name = #24605#28304#40657#20307' CN'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = False
    Layout = tlCenter
    Visible = False
  end
  object PnLogin: TPanel
    Left = 37
    Top = 8
    Width = 360
    Height = 697
    Hint = '{"radius":"5px"}'
    Anchors = [akTop]
    BevelOuter = bvNone
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clGray
    Font.Height = -17
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    Visible = False
    object ImLogo: TImage
      AlignWithMargins = True
      Left = 30
      Top = 3
      Width = 300
      Height = 150
      Hint = '{"src":"image/dwframe/login.jpg"}'
      Margins.Left = 30
      Margins.Right = 30
      Align = alTop
      Center = True
      ExplicitLeft = 10
      ExplicitWidth = 320
    end
    object EtPassword: TEdit
      AlignWithMargins = True
      Left = 30
      Top = 313
      Width = 300
      Height = 39
      Hint = '{"prefix-icon":"el-icon-lock","placeholder":"'#35831#36755#20837#30331#24405#23494#30721'"}'
      Margins.Left = 30
      Margins.Top = 15
      Margins.Right = 30
      Margins.Bottom = 20
      Align = alTop
      AutoSize = False
      Color = clWhite
      DoubleBuffered = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -17
      Font.Name = #24605#28304#40657#20307' CN'
      Font.Style = []
      ParentDoubleBuffered = False
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 0
    end
    object PnCaptcha: TPanel
      AlignWithMargins = True
      Left = 30
      Top = 387
      Width = 300
      Height = 45
      Hint = '{"radius":"4px","dwstyle":"border:solid 1px rgb(220,223,230);"}'
      Margins.Left = 30
      Margins.Top = 15
      Margins.Right = 30
      Margins.Bottom = 20
      Align = alTop
      BevelKind = bkSoft
      BevelOuter = bvNone
      Caption = 'PnCaptcha'
      Color = clWhite
      ParentBackground = False
      TabOrder = 1
      object LaCaptcha: TLabel
        Left = 196
        Top = 0
        Width = 100
        Height = 41
        HelpType = htKeyword
        HelpKeyword = 'captcha'
        Align = alRight
        AutoSize = False
        Caption = 'LaCaptcha'
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -17
        Font.Name = #24605#28304#40657#20307' CN'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        ExplicitLeft = 192
      end
      object EtCaptcha: TEdit
        AlignWithMargins = True
        Left = 5
        Top = 5
        Width = 186
        Height = 31
        Hint = 
          '{"prefix-icon":"el-icon-circle-check","placeholder":"'#35831#36755#20837#39564#35777#30721'","dw' +
          'style":"border-right:solid 1px #dcdfe6;"}'
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        AutoSize = False
        BorderStyle = bsNone
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -17
        Font.Name = #24605#28304#40657#20307' CN'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
    end
    object PnRemember: TPanel
      AlignWithMargins = True
      Left = 30
      Top = 452
      Width = 300
      Height = 28
      Margins.Left = 30
      Margins.Top = 0
      Margins.Right = 30
      Margins.Bottom = 20
      Align = alTop
      BevelKind = bkSoft
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 2
      object CKRemember: TCheckBox
        AlignWithMargins = True
        Left = 0
        Top = 3
        Width = 97
        Height = 18
        Margins.Left = 0
        Align = alLeft
        Caption = #35760#20303#23494#30721
        Checked = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -17
        Font.Name = #24605#28304#40657#20307' CN'
        Font.Style = []
        ParentFont = False
        State = cbChecked
        TabOrder = 0
      end
    end
    object BtLogin: TButton
      AlignWithMargins = True
      Left = 30
      Top = 500
      Width = 300
      Height = 40
      Hint = '{"type":"primary"}'
      Margins.Left = 30
      Margins.Top = 0
      Margins.Right = 30
      Margins.Bottom = 20
      Align = alTop
      Caption = #30331' '#24405
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -17
      Font.Name = #24605#28304#40657#20307' CN'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = BtLoginClick
    end
    object CbUser: TComboBox
      AlignWithMargins = True
      Left = 30
      Top = 245
      Width = 300
      Height = 33
      Margins.Left = 30
      Margins.Top = 15
      Margins.Right = 30
      Margins.Bottom = 20
      Align = alTop
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -17
      Font.Name = #24605#28304#40657#20307' CN'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      Text = 'CbUser'
      Visible = False
    end
    object EtUser: TEdit
      AlignWithMargins = True
      Left = 30
      Top = 171
      Width = 300
      Height = 39
      Hint = 
        '{"prefix-icon":"el-icon-user","placeholder":"'#35831#36755#20837#30331#24405#36134#21495'","dwattr":"' +
        'readonly onFocus=\"this.removeAttribute('#39'readonly'#39');\""}'
      Margins.Left = 30
      Margins.Top = 15
      Margins.Right = 30
      Margins.Bottom = 20
      Align = alTop
      AutoSize = False
      Color = clWhite
      DoubleBuffered = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -17
      Font.Name = #24605#28304#40657#20307' CN'
      Font.Style = []
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 5
    end
  end
  object FDConnection1: TFDConnection
    Left = 872
    Top = 192
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    Left = 872
    Top = 248
  end
  object FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink
    Left = 872
    Top = 304
  end
  object FDPhysODBCDriverLink1: TFDPhysODBCDriverLink
    Left = 872
    Top = 352
  end
  object FDPhysTDataDriverLink1: TFDPhysTDataDriverLink
    Left = 872
    Top = 400
  end
  object FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink
    Left = 872
    Top = 456
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 872
    Top = 504
  end
  object FDPhysOracleDriverLink1: TFDPhysOracleDriverLink
    Left = 872
    Top = 568
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    Left = 872
    Top = 632
  end
end
