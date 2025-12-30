object Form_Test: TForm_Test
  Left = 0
  Top = 0
  HelpKeyword = 'embed'
  Caption = #33258#20027#32771#35797
  ClientHeight = 619
  ClientWidth = 883
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clGray
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnShow = FormShow
  TextHeight = 20
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 883
    Height = 40
    Hint = '{"dwstyle":"border-bottom:solid 1px #dcdfe6;"}'
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = #28857#20987#19979#26041#25353#38062#24320#22987#31572#21367
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
    ExplicitLeft = -5
    ExplicitTop = 45
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
        end>
      HorizontalPositioning = sphpCenter
      ParentBackground = False
      TabOrder = 0
      object B_Test: TButton
        AlignWithMargins = True
        Left = 288
        Top = 3
        Width = 300
        Height = 35
        Hint = '{"type":"success","icon":"el-icon-takeaway-box"}'
        Caption = 'Test'
        HotImageIndex = 0
        TabOrder = 0
        Visible = False
        OnClick = B_TestClick
      end
    end
    object P_SubmitConfirm: TPanel
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
      object L_SubmitTitle: TLabel
        Left = 10
        Top = 14
        Width = 320
        Height = 130
        Alignment = taCenter
        AutoSize = False
        Caption = 'L_SubmitTitle'
        Font.Charset = ANSI_CHARSET
        Font.Color = clGray
        Font.Height = -17
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
      end
      object B_SubmitOK: TButton
        Left = 170
        Top = 150
        Width = 170
        Height = 50
        Hint = 
          '{"type":"primary","dwstyle":"border-top:solid 1px #dcdfd6;border' +
          '-right:0px;","radius":"0px"}'
        Caption = #30830#23450
        TabOrder = 0
        OnClick = B_SubmitOKClick
      end
      object B_SubmitCance: TButton
        Left = 0
        Top = 150
        Width = 170
        Height = 50
        Hint = 
          '{"dwstyle":"background:#FFF;border:solid 1px #dcdfd6;","radius":' +
          '"0px"}'
        Caption = #21462#28040
        TabOrder = 1
        OnClick = B_SubmitCanceClick
      end
    end
  end
  object P_Test: TPanel
    Left = 520
    Top = 26
    Width = 340
    Height = 320
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
      Height = 60
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
      WordWrap = True
    end
    object PC: TPageControl
      AlignWithMargins = True
      Left = 20
      Top = 60
      Width = 300
      Height = 210
      Margins.Left = 20
      Margins.Top = 0
      Margins.Right = 20
      Margins.Bottom = 0
      ActivePage = TS_DX
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
        object RB_A: TRadioButton
          AlignWithMargins = True
          Left = 20
          Top = 130
          Width = 252
          Height = 17
          Margins.Left = 20
          Margins.Top = 10
          Margins.Right = 20
          Margins.Bottom = 10
          Align = alTop
          Caption = 'RB_A'
          TabOrder = 0
        end
        object RB_B: TRadioButton
          AlignWithMargins = True
          Left = 20
          Top = 167
          Width = 252
          Height = 17
          Margins.Left = 20
          Margins.Top = 10
          Margins.Right = 20
          Margins.Bottom = 10
          Align = alTop
          Caption = 'RadioButton1'
          TabOrder = 1
        end
        object RB_C: TRadioButton
          AlignWithMargins = True
          Left = 20
          Top = 204
          Width = 252
          Height = 17
          Margins.Left = 20
          Margins.Top = 10
          Margins.Right = 20
          Margins.Bottom = 10
          Align = alTop
          Caption = 'RadioButton1'
          TabOrder = 2
        end
        object RB_D: TRadioButton
          AlignWithMargins = True
          Left = 20
          Top = 241
          Width = 252
          Height = 17
          Margins.Left = 20
          Margins.Top = 10
          Margins.Right = 20
          Margins.Bottom = 10
          Align = alTop
          Caption = 'RadioButton1'
          TabOrder = 3
        end
        object RB_E: TRadioButton
          AlignWithMargins = True
          Left = 20
          Top = 278
          Width = 252
          Height = 17
          Margins.Left = 20
          Margins.Top = 10
          Margins.Right = 20
          Margins.Bottom = 10
          Align = alTop
          Caption = 'RadioButton1'
          TabOrder = 4
        end
        object RB_F: TRadioButton
          AlignWithMargins = True
          Left = 20
          Top = 315
          Width = 252
          Height = 17
          Margins.Left = 20
          Margins.Top = 10
          Margins.Right = 20
          Margins.Bottom = 10
          Align = alTop
          Caption = 'RadioButton1'
          TabOrder = 5
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
        object CK_A: TCheckBox
          AlignWithMargins = True
          Left = 20
          Top = 130
          Width = 252
          Height = 17
          Margins.Left = 20
          Margins.Top = 10
          Margins.Right = 20
          Margins.Bottom = 10
          Align = alTop
          Caption = 'CK_A'
          TabOrder = 0
        end
        object CK_B: TCheckBox
          AlignWithMargins = True
          Left = 20
          Top = 167
          Width = 252
          Height = 17
          Margins.Left = 20
          Margins.Top = 10
          Margins.Right = 20
          Margins.Bottom = 10
          Align = alTop
          Caption = 'CheckBox1'
          TabOrder = 1
        end
        object CK_C: TCheckBox
          AlignWithMargins = True
          Left = 20
          Top = 204
          Width = 252
          Height = 17
          Margins.Left = 20
          Margins.Top = 10
          Margins.Right = 20
          Margins.Bottom = 10
          Align = alTop
          Caption = 'CheckBox1'
          TabOrder = 2
        end
        object CK_D: TCheckBox
          AlignWithMargins = True
          Left = 20
          Top = 241
          Width = 252
          Height = 17
          Margins.Left = 20
          Margins.Top = 10
          Margins.Right = 20
          Margins.Bottom = 10
          Align = alTop
          Caption = 'CheckBox1'
          TabOrder = 3
        end
        object CK_E: TCheckBox
          AlignWithMargins = True
          Left = 20
          Top = 278
          Width = 252
          Height = 17
          Margins.Left = 20
          Margins.Top = 10
          Margins.Right = 20
          Margins.Bottom = 10
          Align = alTop
          Caption = 'CheckBox1'
          TabOrder = 4
        end
        object CK_F: TCheckBox
          AlignWithMargins = True
          Left = 20
          Top = 315
          Width = 252
          Height = 17
          Margins.Left = 20
          Margins.Top = 10
          Margins.Right = 20
          Margins.Bottom = 10
          Align = alTop
          Caption = 'CheckBox1'
          TabOrder = 5
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
        object E_TK: TEdit
          AlignWithMargins = True
          Left = 20
          Top = 140
          Width = 252
          Height = 28
          Hint = '{"placeholder":"'#35831#36755#20837#31572#26696'"}'
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Margins.Bottom = 10
          Align = alTop
          TabOrder = 0
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
        object RB_True: TRadioButton
          AlignWithMargins = True
          Left = 20
          Top = 130
          Width = 252
          Height = 17
          Margins.Left = 20
          Margins.Top = 10
          Margins.Right = 20
          Margins.Bottom = 10
          Align = alTop
          Caption = #27491#30830
          TabOrder = 0
        end
        object RB_False: TRadioButton
          AlignWithMargins = True
          Left = 20
          Top = 167
          Width = 252
          Height = 17
          Margins.Left = 20
          Margins.Top = 10
          Margins.Right = 20
          Margins.Bottom = 10
          Align = alTop
          Caption = #38169#35823
          TabOrder = 1
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
          Height = 20
          Hint = '{"placeholder":"'#35831#36755#20837#31572#26696'"}'
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 20
          Align = alClient
          Lines.Strings = (
            'M_JS')
          TabOrder = 0
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
          Height = 20
          Hint = '{"placeholder":"'#35831#36755#20837#31572#26696'"}'
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 20
          Align = alClient
          Lines.Strings = (
            'Memo1')
          TabOrder = 0
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
          Height = 20
          Hint = '{"placeholder":"'#35831#36755#20837#31572#26696'"}'
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 20
          Align = alClient
          Lines.Strings = (
            'Memo1')
          TabOrder = 0
        end
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 270
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
        Caption = #20132#21367
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
      Visible = False
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
