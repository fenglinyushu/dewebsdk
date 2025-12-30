object Form_Review: TForm_Review
  Left = 0
  Top = 0
  HelpKeyword = 'embed'
  Caption = #35780#38405#35797#21367
  ClientHeight = 619
  ClientWidth = 883
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clGray
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 20
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 883
    Height = 40
    Hint = '{'#13#10#9'"dwstyle": "border-bottom:solid 1px #dcdfe6;"'#13#10'}'
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = #28857#20987#19979#26041#25353#38062#24320#22987#35780#38405
    Font.Charset = ANSI_CHARSET
    Font.Color = clGray
    Font.Height = -17
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
  end
  object SC: TScrollBox
    AlignWithMargins = True
    Left = 0
    Top = 50
    Width = 883
    Height = 569
    Margins.Left = 0
    Margins.Top = 10
    Margins.Right = 0
    Margins.Bottom = 0
    HorzScrollBar.Visible = False
    VertScrollBar.Visible = False
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 0
    object SP: TStackPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 877
      Height = 41
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Color = clWhite
      ControlCollection = <
        item
          Control = B_Test
          HorizontalPositioning = sphpFill
          VerticalPositioning = spvpTop
        end>
      HorizontalPositioning = sphpCenter
      ParentBackground = False
      TabOrder = 0
      object B_Test: TButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 871
        Height = 35
        Hint = '{"type":"primary"}'
        Align = alTop
        Caption = 'Test'
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Visible = False
        OnClick = B_TestClick
      end
    end
    object P_Confirm: TPanel
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
      object L_ConfirmTitle: TLabel
        Left = 10
        Top = 14
        Width = 320
        Height = 130
        Alignment = taCenter
        AutoSize = False
        Caption = 'L_ConfirmTitle'
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -17
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
      end
      object Panel4: TPanel
        Left = 0
        Top = 150
        Width = 340
        Height = 50
        Align = alBottom
        BevelOuter = bvNone
        Color = clNone
        ParentBackground = False
        TabOrder = 0
        object B_SubmitCance: TButton
          Left = 0
          Top = 0
          Width = 170
          Height = 50
          Hint = 
            '{"dwstyle":"background:#FFF;border:solid 1px #dcdfd6;","radius":' +
            '"0px"}'
          Align = alLeft
          Caption = #21462#28040
          TabOrder = 0
          OnClick = B_SubmitCanceClick
        end
        object B_SubmitOK: TButton
          Left = 170
          Top = 0
          Width = 170
          Height = 50
          Hint = 
            '{"type":"primary","dwstyle":"border-top:solid 1px #dcdfd6;border' +
            '-right:0px;","radius":"0px"}'
          Align = alClient
          Caption = #30830#23450
          TabOrder = 1
          OnClick = B_SubmitOKClick
        end
      end
    end
  end
  object P_Test: TPanel
    Left = 520
    Top = 26
    Width = 340
    Height = 585
    Hint = '{"radius":"10px"}'
    HelpType = htKeyword
    HelpKeyword = 'modal'
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    Visible = False
    object L_PaperName: TLabel
      Left = 0
      Top = 0
      Width = 340
      Height = 50
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #25105#30340#35797#21367
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -17
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object PC: TPageControl
      AlignWithMargins = True
      Left = 20
      Top = 50
      Width = 300
      Height = 485
      Margins.Left = 20
      Margins.Top = 0
      Margins.Right = 20
      Margins.Bottom = 0
      ActivePage = TS_LS
      Align = alClient
      BiDiMode = bdLeftToRight
      ParentBiDiMode = False
      ParentShowHint = False
      ShowHint = False
      TabHeight = 40
      TabOrder = 0
      object TS_DX: TTabSheet
        Caption = #21333#36873
        object L_NameDX: TLabel
          AlignWithMargins = True
          Left = 20
          Top = 20
          Width = 252
          Height = 80
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Margins.Bottom = 20
          Align = alTop
          Caption = '4'#12289#21516#19968#23384#27454#20154#22312#21516#19968#23478#25237#20445#26426#26500#25152#26377#34987#20445#38505#23384#27454#36134#25143#30340#23384#27454#65288'    '#65289#21512#24182#35745#31639#30340#36164#37329#25968#39069#22312#26368#39640#20607#20184#38480#39069#20197#20869#30340#65292#23454#34892#20840#39069#20607#20184#12290
          WordWrap = True
          ExplicitWidth = 249
        end
        object L_AnswerDX: TLabel
          AlignWithMargins = True
          Left = 20
          Top = 140
          Width = 252
          Height = 20
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Margins.Bottom = 20
          Align = alTop
          Caption = #31572#26696#65306
          WordWrap = True
          ExplicitWidth = 45
        end
      end
      object TS_DU: TTabSheet
        Caption = #22810#36873
        object L_NameDU: TLabel
          AlignWithMargins = True
          Left = 20
          Top = 20
          Width = 252
          Height = 80
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Margins.Bottom = 20
          Align = alTop
          Caption = '4'#12289#21516#19968#23384#27454#20154#22312#21516#19968#23478#25237#20445#26426#26500#25152#26377#34987#20445#38505#23384#27454#36134#25143#30340#23384#27454#65288'    '#65289#21512#24182#35745#31639#30340#36164#37329#25968#39069#22312#26368#39640#20607#20184#38480#39069#20197#20869#30340#65292#23454#34892#20840#39069#20607#20184#12290
          WordWrap = True
          ExplicitWidth = 249
        end
        object L_AnswerDU: TLabel
          AlignWithMargins = True
          Left = 20
          Top = 140
          Width = 252
          Height = 20
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Margins.Bottom = 20
          Align = alTop
          Caption = #31572#26696#65306
          WordWrap = True
          ExplicitWidth = 45
        end
      end
      object TS_TK: TTabSheet
        Caption = #22635#31354
        object L_NameTK: TLabel
          AlignWithMargins = True
          Left = 20
          Top = 20
          Width = 252
          Height = 80
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Margins.Bottom = 20
          Align = alTop
          Caption = '4'#12289#21516#19968#23384#27454#20154#22312#21516#19968#23478#25237#20445#26426#26500#25152#26377#34987#20445#38505#23384#27454#36134#25143#30340#23384#27454#65288'    '#65289#21512#24182#35745#31639#30340#36164#37329#25968#39069#22312#26368#39640#20607#20184#38480#39069#20197#20869#30340#65292#23454#34892#20840#39069#20607#20184#12290
          WordWrap = True
          ExplicitWidth = 249
        end
        object L_AnswerTK: TLabel
          AlignWithMargins = True
          Left = 20
          Top = 140
          Width = 252
          Height = 20
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Margins.Bottom = 20
          Align = alTop
          Caption = #31572#26696#65306
          WordWrap = True
          ExplicitWidth = 45
        end
      end
      object TS_PD: TTabSheet
        Caption = #21028#26029
        object L_NamePD: TLabel
          AlignWithMargins = True
          Left = 20
          Top = 20
          Width = 252
          Height = 80
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Margins.Bottom = 20
          Align = alTop
          Caption = '4'#12289#21516#19968#23384#27454#20154#22312#21516#19968#23478#25237#20445#26426#26500#25152#26377#34987#20445#38505#23384#27454#36134#25143#30340#23384#27454#65288'    '#65289#21512#24182#35745#31639#30340#36164#37329#25968#39069#22312#26368#39640#20607#20184#38480#39069#20197#20869#30340#65292#23454#34892#20840#39069#20607#20184#12290
          WordWrap = True
          ExplicitWidth = 249
        end
        object L_AnswerPD: TLabel
          AlignWithMargins = True
          Left = 20
          Top = 140
          Width = 252
          Height = 20
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Margins.Bottom = 20
          Align = alTop
          Caption = #31572#26696#65306
          WordWrap = True
          ExplicitWidth = 45
        end
      end
      object TS_JS: TTabSheet
        Caption = #35745#31639
        object L_NameJS: TLabel
          AlignWithMargins = True
          Left = 20
          Top = 20
          Width = 252
          Height = 80
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Margins.Bottom = 20
          Align = alTop
          Caption = '4'#12289#21516#19968#23384#27454#20154#22312#21516#19968#23478#25237#20445#26426#26500#25152#26377#34987#20445#38505#23384#27454#36134#25143#30340#23384#27454#65288'    '#65289#21512#24182#35745#31639#30340#36164#37329#25968#39069#22312#26368#39640#20607#20184#38480#39069#20197#20869#30340#65292#23454#34892#20840#39069#20607#20184#12290
          WordWrap = True
          ExplicitWidth = 249
        end
        object M_JS: TMemo
          AlignWithMargins = True
          Left = 0
          Top = 120
          Width = 292
          Height = 257
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alClient
          Lines.Strings = (
            'M_JS')
          ReadOnly = True
          TabOrder = 0
        end
        object Panel1: TPanel
          AlignWithMargins = True
          Left = 60
          Top = 380
          Width = 172
          Height = 35
          Margins.Left = 60
          Margins.Right = 60
          Margins.Bottom = 20
          Align = alBottom
          BevelOuter = bvNone
          Color = clNone
          ParentBackground = False
          TabOrder = 1
          object B_JS100: TButton
            AlignWithMargins = True
            Left = 126
            Top = 0
            Width = 46
            Height = 33
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 2
            Align = alRight
            Caption = #28385#20998
            TabOrder = 0
            OnClick = B_JS100Click
            ExplicitHeight = 35
          end
          object B_JS0: TButton
            AlignWithMargins = True
            Left = 0
            Top = 0
            Width = 46
            Height = 33
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 2
            Align = alLeft
            Caption = '0'
            TabOrder = 1
            OnClick = B_JS0Click
            ExplicitHeight = 35
          end
          object SE_JS: TSpinEdit
            AlignWithMargins = True
            Left = 56
            Top = 0
            Width = 60
            Height = 32
            Hint = '{"dwstyle":"border:solid 1px #dcdef6;border-radius:3px;"}'
            Margins.Left = 10
            Margins.Top = 0
            Margins.Right = 10
            Align = alClient
            MaxValue = 100
            MinValue = -1
            TabOrder = 2
            Value = -1
            OnChange = SE_LSChange
          end
        end
      end
      object TS_JD: TTabSheet
        Caption = #31616#31572
        object L_NameJD: TLabel
          AlignWithMargins = True
          Left = 20
          Top = 20
          Width = 252
          Height = 80
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Margins.Bottom = 20
          Align = alTop
          Caption = '4'#12289#21516#19968#23384#27454#20154#22312#21516#19968#23478#25237#20445#26426#26500#25152#26377#34987#20445#38505#23384#27454#36134#25143#30340#23384#27454#65288'    '#65289#21512#24182#35745#31639#30340#36164#37329#25968#39069#22312#26368#39640#20607#20184#38480#39069#20197#20869#30340#65292#23454#34892#20840#39069#20607#20184#12290
          WordWrap = True
          ExplicitWidth = 249
        end
        object M_JD: TMemo
          AlignWithMargins = True
          Left = 0
          Top = 120
          Width = 292
          Height = 257
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alClient
          Lines.Strings = (
            'Memo1')
          ReadOnly = True
          TabOrder = 0
        end
        object Panel2: TPanel
          AlignWithMargins = True
          Left = 60
          Top = 380
          Width = 172
          Height = 35
          Margins.Left = 60
          Margins.Right = 60
          Margins.Bottom = 20
          Align = alBottom
          BevelOuter = bvNone
          Color = clNone
          ParentBackground = False
          TabOrder = 1
          object B_JD100: TButton
            AlignWithMargins = True
            Left = 126
            Top = 0
            Width = 46
            Height = 33
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 2
            Align = alRight
            Caption = #28385#20998
            TabOrder = 0
            OnClick = B_JD100Click
            ExplicitHeight = 35
          end
          object B_JD0: TButton
            AlignWithMargins = True
            Left = 0
            Top = 0
            Width = 46
            Height = 33
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 2
            Align = alLeft
            Caption = '0'
            TabOrder = 1
            OnClick = B_JD0Click
            ExplicitHeight = 35
          end
          object SE_JD: TSpinEdit
            AlignWithMargins = True
            Left = 56
            Top = 0
            Width = 60
            Height = 32
            Hint = '{"dwstyle":"border:solid 1px #dcdef6;border-radius:3px;"}'
            Margins.Left = 10
            Margins.Top = 0
            Margins.Right = 10
            Align = alClient
            MaxValue = 100
            MinValue = -1
            TabOrder = 2
            Value = -1
            OnChange = SE_LSChange
          end
        end
      end
      object TS_LS: TTabSheet
        Caption = #35770#36848
        object L_NameLS: TLabel
          AlignWithMargins = True
          Left = 20
          Top = 20
          Width = 252
          Height = 80
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Margins.Bottom = 20
          Align = alTop
          Caption = '4'#12289#21516#19968#23384#27454#20154#22312#21516#19968#23478#25237#20445#26426#26500#25152#26377#34987#20445#38505#23384#27454#36134#25143#30340#23384#27454#65288'    '#65289#21512#24182#35745#31639#30340#36164#37329#25968#39069#22312#26368#39640#20607#20184#38480#39069#20197#20869#30340#65292#23454#34892#20840#39069#20607#20184#12290
          WordWrap = True
          ExplicitWidth = 249
        end
        object M_LS: TMemo
          AlignWithMargins = True
          Left = 0
          Top = 120
          Width = 292
          Height = 257
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alClient
          Lines.Strings = (
            'Memo1')
          ReadOnly = True
          TabOrder = 0
        end
        object Panel3: TPanel
          AlignWithMargins = True
          Left = 60
          Top = 380
          Width = 172
          Height = 35
          Margins.Left = 60
          Margins.Right = 60
          Margins.Bottom = 20
          Align = alBottom
          BevelOuter = bvNone
          Color = clNone
          ParentBackground = False
          TabOrder = 1
          object B_LS100: TButton
            AlignWithMargins = True
            Left = 126
            Top = 0
            Width = 46
            Height = 33
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 2
            Align = alRight
            Caption = #28385#20998
            TabOrder = 0
            OnClick = B_LS100Click
            ExplicitHeight = 35
          end
          object B_LS0: TButton
            AlignWithMargins = True
            Left = 0
            Top = 0
            Width = 46
            Height = 33
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 2
            Align = alLeft
            Caption = '0'
            TabOrder = 1
            OnClick = B_LS0Click
            ExplicitHeight = 35
          end
          object SE_LS: TSpinEdit
            AlignWithMargins = True
            Left = 56
            Top = 0
            Width = 60
            Height = 32
            Hint = '{"dwstyle":"border:solid 1px #dcdef6;border-radius:3px;"}'
            Margins.Left = 10
            Margins.Top = 0
            Margins.Right = 10
            Align = alClient
            MaxValue = 100
            MinValue = -1
            TabOrder = 2
            Value = -1
            OnChange = SE_LSChange
          end
        end
      end
    end
    object P_Buttons: TPanel
      Left = 0
      Top = 535
      Width = 340
      Height = 50
      Align = alBottom
      BevelOuter = bvNone
      Color = clNone
      ParentBackground = False
      TabOrder = 1
      object B_Prior: TButton
        Left = 0
        Top = 0
        Width = 120
        Height = 50
        Hint = '{"radius":"0px","type":"primary"}'
        Align = alLeft
        Caption = #19978#19968#39064
        TabOrder = 0
        OnClick = B_PriorClick
      end
      object B_Submit: TButton
        Left = 120
        Top = 0
        Width = 100
        Height = 50
        Hint = 
          '{"dwstyle":"border-right:solid 1px #dcdfd6;border-left:solid 1px' +
          ' #dcdfd6;","radius":"0px","type":"primary"}'
        Align = alClient
        Caption = #25552#20132
        TabOrder = 1
        OnClick = B_SubmitClick
      end
      object B_Next: TButton
        Left = 220
        Top = 0
        Width = 120
        Height = 50
        Hint = '{"radius":"0px","type":"primary"}'
        Align = alRight
        Caption = #19979#19968#39064
        TabOrder = 2
        OnClick = B_NextClick
      end
    end
    object B_Close: TButton
      Left = 287
      Top = 8
      Width = 46
      Height = 35
      Hint = '{"icon":"el-icon-close","type":"text"}'
      Cancel = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -17
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = B_CloseClick
    end
  end
  object FDQuery1: TFDQuery
    Left = 90
    Top = 281
  end
  object FDQuery_Tmp: TFDQuery
    Left = 90
    Top = 345
  end
end
