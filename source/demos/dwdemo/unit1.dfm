object Form1: TForm1
  Left = 0
  Top = 0
  Hint = '{"type":"primary"}'
  BorderStyle = bsNone
  Caption = 'Hello,World!'
  ClientHeight = 800
  ClientWidth = 1200
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Menu = MainMenu_Left
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 20
  object Label8: TLabel
    Left = 40
    Top = 32
    Width = 431
    Height = 41
    AutoSize = False
    Caption = #27426#36814#24744#65281
    Font.Charset = ANSI_CHARSET
    Font.Color = 13158600
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
  end
  object Panel_Full: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 1194
    Height = 794
    Align = alClient
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object Panel_1: TPanel
      Left = 0
      Top = 55
      Width = 1190
      Height = 735
      Align = alClient
      BevelOuter = bvNone
      Color = clAqua
      ParentBackground = False
      TabOrder = 0
      object Panel_1_L: TPanel
        Left = 0
        Top = 0
        Width = 240
        Height = 735
        Align = alLeft
        BevelOuter = bvNone
        Color = 3091752
        Font.Charset = ANSI_CHARSET
        Font.Color = 13158600
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
        object Panel_Head: TPanel
          Left = 0
          Top = 0
          Width = 240
          Height = 190
          Align = alTop
          BevelOuter = bvNone
          Color = 2368031
          ParentBackground = False
          TabOrder = 0
          object Image_Head: TImage
            Left = 80
            Top = 24
            Width = 80
            Height = 80
            Hint = '{"radius":"50%","src":"media/images/dwdemo/head.jpg"}'
          end
          object Label_Name: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 119
            Width = 234
            Height = 25
            Align = alBottom
            Alignment = taCenter
            AutoSize = False
            Caption = #30887#26641#35199#39118
            Color = clWhite
            Font.Charset = ANSI_CHARSET
            Font.Color = 13158600
            Font.Height = -15
            Font.Name = #24494#36719#38597#40657
            Font.Style = []
            ParentColor = False
            ParentFont = False
            Layout = tlCenter
            ExplicitLeft = 24
            ExplicitTop = 120
            ExplicitWidth = 185
          end
          object Label_Title: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 150
            Width = 234
            Height = 25
            Margins.Bottom = 15
            Align = alBottom
            Alignment = taCenter
            AutoSize = False
            Caption = #31995#32479#31649#29702#21592
            Color = clWhite
            Font.Charset = ANSI_CHARSET
            Font.Color = 13158600
            Font.Height = -15
            Font.Name = #24494#36719#38597#40657
            Font.Style = []
            ParentColor = False
            ParentFont = False
            Layout = tlCenter
            ExplicitLeft = 24
            ExplicitTop = 144
            ExplicitWidth = 185
          end
        end
        object Panel_Comp: TPanel
          Left = 0
          Top = 190
          Width = 240
          Height = 72
          Align = alTop
          BevelOuter = bvNone
          Color = 3091752
          ParentBackground = False
          TabOrder = 1
          object Label3: TLabel
            Left = 145
            Top = 0
            Width = 95
            Height = 72
            Align = alClient
            AutoSize = False
            Caption = #38468#21152#32452#20214
            Font.Charset = ANSI_CHARSET
            Font.Color = 13158600
            Font.Height = -15
            Font.Name = #24494#36719#38597#40657
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
            ExplicitLeft = 84
            ExplicitTop = 3
            ExplicitWidth = 150
          end
          object Label4: TLabel
            Left = 0
            Top = 0
            Width = 145
            Height = 72
            Align = alLeft
            Alignment = taCenter
            AutoSize = False
            Caption = 'Components'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWhite
            Font.Height = -16
            Font.Name = #24494#36719#38597#40657
            Font.Style = [fsBold]
            ParentFont = False
            Layout = tlCenter
          end
        end
        object Panel_Menu: TPanel
          Left = 0
          Top = 262
          Width = 240
          Height = 473
          Align = alClient
          BevelOuter = bvNone
          Color = 3091752
          ParentBackground = False
          TabOrder = 2
        end
      end
      object Panel_1_C: TPanel
        Left = 240
        Top = 0
        Width = 950
        Height = 735
        Align = alClient
        BevelOuter = bvNone
        Color = 4473146
        ParentBackground = False
        TabOrder = 1
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 950
          Height = 140
          Align = alTop
          BevelOuter = bvNone
          Color = 5196610
          ParentBackground = False
          TabOrder = 0
          object Label7: TLabel
            Left = 32
            Top = 24
            Width = 431
            Height = 41
            AutoSize = False
            Caption = #32508#21512#26696#20363#23637#31034
            Font.Charset = ANSI_CHARSET
            Font.Color = 13158600
            Font.Height = -21
            Font.Name = #24494#36719#38597#40657
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
          end
          object Label9: TLabel
            Left = 32
            Top = 64
            Width = 529
            Height = 41
            AutoSize = False
            Caption = 'DeWeb'#26159#19968#20010#21487#20197#30452#25509#23558'Delphi'#31243#24207#24555#36895#36716#25442#20026#32593#39029#24212#29992#30340#24037#20855#65281
            Font.Charset = ANSI_CHARSET
            Font.Color = 13158600
            Font.Height = -15
            Font.Name = #24494#36719#38597#40657
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
          end
          object Button2: TButton
            AlignWithMargins = True
            Left = 784
            Top = 40
            Width = 136
            Height = 60
            Hint = 
              '{"borderradius":"0px","backgroundcolor":"#424B4f","icon":"el-ico' +
              'n-s-tools"}'
            Margins.Top = 40
            Margins.Right = 30
            Margins.Bottom = 40
            Align = alRight
            Caption = #35774#32622
            TabOrder = 0
            ExplicitTop = 45
            ExplicitHeight = 50
          end
        end
        object Panel2: TPanel
          Left = 16
          Top = 156
          Width = 300
          Height = 140
          Hint = '{"dwstyle":"border:solid 1px #282D2F"}'
          BevelOuter = bvNone
          Color = 5196610
          ParentBackground = False
          TabOrder = 1
          object Label6: TLabel
            Left = 16
            Top = 8
            Width = 137
            Height = 41
            AutoSize = False
            Caption = #26376#24230#25910#25903#35745#21010
            Font.Charset = ANSI_CHARSET
            Font.Color = 13158600
            Font.Height = -15
            Font.Name = #24494#36719#38597#40657
            Font.Style = [fsBold]
            ParentFont = False
            Layout = tlCenter
          end
          object Label10: TLabel
            Left = 16
            Top = 40
            Width = 257
            Height = 41
            AutoSize = False
            Caption = 'DeWeb'#26159#19968#20010#21487#20197#30452#25509#23558'Delphi'#31243#24207
            Font.Charset = ANSI_CHARSET
            Font.Color = 13158600
            Font.Height = -15
            Font.Name = #24494#36719#38597#40657
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
          end
          object Button3: TButton
            AlignWithMargins = True
            Left = 16
            Top = 92
            Width = 121
            Height = 36
            Hint = 
              '{"borderradius":"0px","backgroundcolor":"#424B4f","icon":"el-ico' +
              'n-s-tools"}'
            Margins.Top = 40
            Margins.Right = 30
            Margins.Bottom = 40
            Caption = #26356#22810#26376#20221
            TabOrder = 0
          end
        end
        object Panel3: TPanel
          Left = 328
          Top = 156
          Width = 300
          Height = 140
          Hint = '{"dwstyle":"border:solid 2px #105F79"}'
          BevelOuter = bvNone
          Color = 11175447
          ParentBackground = False
          TabOrder = 2
          object Label11: TLabel
            Left = 16
            Top = 8
            Width = 137
            Height = 41
            AutoSize = False
            Caption = #26412#23395#24230#21033#28070
            Font.Charset = ANSI_CHARSET
            Font.Color = 13158600
            Font.Height = -15
            Font.Name = #24494#36719#38597#40657
            Font.Style = [fsBold]
            ParentFont = False
            Layout = tlCenter
          end
          object Label12: TLabel
            Left = 16
            Top = 40
            Width = 193
            Height = 57
            AutoSize = False
            Caption = #65509'20,298'
            Font.Charset = ANSI_CHARSET
            Font.Color = 13158600
            Font.Height = -43
            Font.Name = #24494#36719#38597#40657
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
          end
          object Label15: TLabel
            Left = 16
            Top = 87
            Width = 257
            Height = 41
            AutoSize = False
            Caption = #26412#23395#24230#27604#19978#23395#24230#22810#25910#20837' 7,298 '#20803
            Font.Charset = ANSI_CHARSET
            Font.Color = 13158600
            Font.Height = -15
            Font.Name = #24494#36719#38597#40657
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
          end
        end
        object Panel4: TPanel
          Left = 648
          Top = 156
          Width = 280
          Height = 140
          Hint = '{"dwstyle":"border:solid 2px #5C4375"}'
          BevelOuter = bvNone
          Color = 10049400
          ParentBackground = False
          TabOrder = 3
          object Label13: TLabel
            Left = 16
            Top = 8
            Width = 137
            Height = 41
            AutoSize = False
            Caption = #26376#24230#25910#25903#35745#21010
            Font.Charset = ANSI_CHARSET
            Font.Color = 13158600
            Font.Height = -15
            Font.Name = #24494#36719#38597#40657
            Font.Style = [fsBold]
            ParentFont = False
            Layout = tlCenter
          end
          object Label14: TLabel
            Left = 16
            Top = 40
            Width = 257
            Height = 41
            AutoSize = False
            Caption = 'DeWeb'#26159#19968#20010#21487#20197#30452#25509#23558'Delphi'#31243#24207
            Font.Charset = ANSI_CHARSET
            Font.Color = 13158600
            Font.Height = -15
            Font.Name = #24494#36719#38597#40657
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
          end
        end
      end
    end
    object Panel_0: TPanel
      Left = 0
      Top = 0
      Width = 1190
      Height = 55
      Align = alTop
      BevelOuter = bvNone
      Color = 3683375
      ParentBackground = False
      TabOrder = 1
      object Label5: TLabel
        Left = 952
        Top = 0
        Width = 238
        Height = 55
        Align = alRight
        AutoSize = False
        Caption = #27426#36814#24744#65281
        Font.Charset = ANSI_CHARSET
        Font.Color = 13158600
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        ExplicitLeft = 713
        ExplicitTop = -6
      end
      object Panel_0_0: TPanel
        Left = 0
        Top = 0
        Width = 240
        Height = 55
        Align = alLeft
        BevelOuter = bvNone
        Color = 3091752
        ParentBackground = False
        TabOrder = 0
        object Label1: TLabel
          Left = 90
          Top = 0
          Width = 150
          Height = 55
          Align = alRight
          AutoSize = False
          Caption = 'DeWeb'
          Font.Charset = ANSI_CHARSET
          Font.Color = 16749875
          Font.Height = -27
          Font.Name = #24494#36719#38597#40657
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
          ExplicitLeft = 84
          ExplicitTop = -6
        end
        object Image_logo: TImage
          Left = 40
          Top = 0
          Width = 50
          Height = 55
          Hint = '{"src":"media/images/dwdemo/app48.png"}'
          Align = alRight
        end
      end
      object Button1: TButton
        Left = 240
        Top = 0
        Width = 65
        Height = 55
        Hint = '{"color":"#FFF","icon":"el-icon-s-grid","type":"text"}'
        Align = alLeft
        TabOrder = 1
      end
      object Edit_Search: TEdit
        AlignWithMargins = True
        Left = 315
        Top = 12
        Width = 157
        Height = 30
        Hint = '{"prefix-icon":"el-icon-search","placeholder":"'#25628#32034#26696#20363'..."}'
        Margins.Left = 10
        Margins.Top = 12
        Margins.Bottom = 13
        Align = alLeft
        BorderStyle = bsNone
        Color = 3551789
        TabOrder = 2
      end
    end
  end
  object MainMenu_Left: TMainMenu
    AutoHotkeys = maManual
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    Left = 467
    Top = 146
    object N1: TMenuItem
      Caption = #39318#39029
      Hint = '{"background-color":"#282d2f"}'
      ImageIndex = 56
    end
    object N2: TMenuItem
      Caption = #22522#26412#25511#20214
      ImageIndex = 57
      object N6: TMenuItem
        Caption = #25353#38062' TButton'
      end
      object Edit1: TMenuItem
        Caption = #32534#36753#26694' TEdit'
      end
      object Label2: TMenuItem
        Caption = #26631#31614' TLabel'
      end
      object CheckBox1: TMenuItem
        Caption = #36873#25321#26694' TCheckBox'
      end
    end
    object N3: TMenuItem
      Caption = #32508#21512#24212#29992
      ImageIndex = 58
    end
    object N4: TMenuItem
      Caption = #25968#25454#24211
      ImageIndex = 59
    end
    object N5: TMenuItem
      Caption = #24120#35265#38382#39064
      ImageIndex = 60
    end
  end
end
