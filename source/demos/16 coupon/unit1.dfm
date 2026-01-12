object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #20248#24800#21048
  ClientHeight = 529
  ClientWidth = 520
  Color = clBtnFace
  TransparentColor = True
  TransparentColorValue = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OnCreate = FormCreate
  OnMouseUp = FormMouseUp
  OnShow = FormShow
  TextHeight = 20
  object SC: TScrollBox
    Left = 0
    Top = 50
    Width = 520
    Height = 431
    VertScrollBar.Visible = False
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 0
    object P_Content: TPanel
      Left = 0
      Top = 0
      Width = 520
      Height = 257
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object P_Demo: TPanel
        AlignWithMargins = True
        Left = 10
        Top = 10
        Width = 500
        Height = 110
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alTop
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 0
        DesignSize = (
          500
          110)
        object PC: TPanel
          AlignWithMargins = True
          Left = 10
          Top = 0
          Width = 480
          Height = 110
          Hint = '{"radius":"10px"}'
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 10
          Margins.Bottom = 0
          Align = alClient
          BevelOuter = bvNone
          Color = clWhite
          ParentBackground = False
          TabOrder = 0
          object P_T: TPanel
            AlignWithMargins = True
            Left = 0
            Top = 0
            Width = 480
            Height = 80
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alTop
            BevelOuter = bvNone
            Color = clWhite
            ParentBackground = False
            TabOrder = 0
            object P_TL: TPanel
              Left = 0
              Top = 0
              Width = 120
              Height = 80
              Align = alLeft
              BevelOuter = bvNone
              Color = 5650419
              ParentBackground = False
              TabOrder = 0
              object L_Amount: TLabel
                AlignWithMargins = True
                Left = 5
                Top = 3
                Width = 115
                Height = 74
                Margins.Left = 5
                Margins.Right = 0
                Align = alClient
                Alignment = taCenter
                Caption = '10'
                Font.Charset = ANSI_CHARSET
                Font.Color = cl3DLight
                Font.Height = -63
                Font.Name = #24494#36719#38597#40657
                Font.Style = [fsBold]
                ParentFont = False
                Layout = tlCenter
                ExplicitWidth = 78
                ExplicitHeight = 85
              end
              object L_RMB: TLabel
                Left = 4
                Top = 42
                Width = 15
                Height = 19
                Alignment = taCenter
                Caption = #65509
                Font.Charset = ANSI_CHARSET
                Font.Color = cl3DLight
                Font.Height = -15
                Font.Name = #24494#36719#38597#40657
                Font.Style = [fsBold]
                ParentFont = False
                Layout = tlCenter
              end
            end
            object P_TC: TPanel
              Left = 120
              Top = 0
              Width = 360
              Height = 80
              Hint = '{"dwstyle":"border-bottom:dashed 1px #ccc;"}'
              Align = alClient
              BevelOuter = bvNone
              Color = clWhite
              ParentBackground = False
              TabOrder = 1
              DesignSize = (
                360
                80)
              object L_Name: TLabel
                Left = 73
                Top = 17
                Width = 209
                Height = 20
                Alignment = taCenter
                Anchors = [akTop]
                Caption = #26032#29992#25143#19987#20139#32418#21253' - '#28436#21809#20250#20248#24800#21048
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlack
                Font.Height = -15
                Font.Name = #24494#36719#38597#40657
                Font.Style = []
                ParentFont = False
                Layout = tlCenter
                ExplicitLeft = 83
              end
              object L_Date: TLabel
                Left = 73
                Top = 43
                Width = 154
                Height = 34
                Alignment = taCenter
                Anchors = [akTop]
                AutoSize = False
                Caption = '2022.07.01 - 2022.09.01'
                Font.Charset = ANSI_CHARSET
                Font.Color = clGray
                Font.Height = -13
                Font.Name = #24494#36719#38597#40657
                Font.Style = []
                ParentFont = False
                Layout = tlCenter
                WordWrap = True
              end
              object B_Use: TButton
                Left = 281
                Top = 43
                Width = 50
                Height = 22
                Hint = '{"type":"danger","radius":"11px"}'
                Anchors = [akTop]
                Caption = #21435#20351#29992
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindow
                Font.Height = -12
                Font.Name = #24494#36719#38597#40657
                Font.Style = []
                ParentFont = False
                TabOrder = 0
                OnClick = B_UseClick
              end
            end
          end
          object P_C: TPanel
            AlignWithMargins = True
            Left = 0
            Top = 80
            Width = 480
            Height = 30
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alClient
            BevelOuter = bvNone
            Color = clWhite
            ParentBackground = False
            TabOrder = 1
            object P_CL: TPanel
              Left = 0
              Top = 0
              Width = 120
              Height = 30
              Align = alLeft
              BevelOuter = bvNone
              Color = 3742928
              ParentBackground = False
              TabOrder = 0
              object L_Limit: TLabel
                Left = 0
                Top = 0
                Width = 120
                Height = 30
                Align = alClient
                Alignment = taCenter
                Caption = #28385'100'#20803#21487#29992
                Font.Charset = ANSI_CHARSET
                Font.Color = cl3DLight
                Font.Height = -13
                Font.Name = #24494#36719#38597#40657
                Font.Style = []
                ParentFont = False
                Layout = tlCenter
                ExplicitWidth = 76
                ExplicitHeight = 19
              end
            end
          end
        end
        object PCircle0: TPanel
          Left = 0
          Top = 70
          Width = 20
          Height = 20
          Hint = '{"radius":"10px"}'
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 1
        end
        object PCircle1: TPanel
          Left = 480
          Top = 70
          Width = 20
          Height = 20
          Hint = '{"radius":"10px"}'
          Anchors = [akTop, akRight]
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 2
        end
      end
    end
  end
  object TB: TTrackBar
    AlignWithMargins = True
    Left = 3
    Top = 491
    Width = 514
    Height = 35
    Hint = '{"dwattr":"background layout=\"prev, pager, next\""}'
    HelpType = htKeyword
    HelpKeyword = 'page'
    Margins.Top = 10
    Align = alBottom
    PageSize = 10
    TabOrder = 1
    OnChange = TBChange
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 520
    Height = 50
    Align = alTop
    BevelKind = bkFlat
    BevelOuter = bvNone
    TabOrder = 2
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 348
      Height = 46
      Align = alClient
      Alignment = taCenter
      Caption = #25105#30340#20248#24800#21048
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 85
      ExplicitHeight = 23
    end
    object CB_Amount: TComboBox
      AlignWithMargins = True
      Left = 351
      Top = 10
      Width = 145
      Height = 28
      Margins.Top = 10
      Margins.Right = 20
      Align = alRight
      Style = csDropDownList
      TabOrder = 0
      OnChange = CB_AmountChange
      Items.Strings = (
        '100'
        '200'
        '400'
        '500')
    end
  end
  object FDConnection1: TFDConnection
    Left = 96
    Top = 160
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 96
    Top = 216
  end
  object FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink
    Left = 96
    Top = 290
  end
end
