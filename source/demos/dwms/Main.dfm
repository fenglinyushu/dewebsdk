object Form1: TForm1
  Left = 0
  Top = 0
  Hint = 
    '{"dwattr":":fetch-suggestions=\"[{\\\"value\\\":\\\"aaa\\\"}]\""' +
    '}'
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'DeWeb'
  ClientHeight = 728
  ClientWidth = 1083
  Color = clBtnFace
  TransparentColorValue = 16448250
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnMouseUp = FormMouseUp
  PixelsPerInch = 96
  TextHeight = 20
  object Panel_Client: TPanel
    Left = 200
    Top = 50
    Width = 883
    Height = 678
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 5807363
    Font.Height = -13
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object PageControl1: TPageControl
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 877
      Height = 672
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 0
      OnChange = PageControl1Change
      OnEndDock = PageControl1EndDock
      object TabSheet1: TTabSheet
        Hint = '{"type":"primary"}'
        Caption = #39318#39029
        object Panel5: TPanel
          Left = 0
          Top = 0
          Width = 869
          Height = 638
          Align = alClient
          BevelOuter = bvNone
          Color = clWhite
          ParentBackground = False
          TabOrder = 0
          object Panel_Buttons: TPanel
            Left = 0
            Top = 125
            Width = 869
            Height = 110
            Hint = '{"radius":"5px"}'
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 5
            Align = alTop
            BevelOuter = bvNone
            ParentBackground = False
            ParentColor = True
            TabOrder = 1
            object Panel11: TPanel
              AlignWithMargins = True
              Left = 820
              Top = 10
              Width = 100
              Height = 95
              Hint = '{"radius":"5px"}'
              Margins.Left = 7
              Margins.Top = 10
              Margins.Right = 7
              Margins.Bottom = 5
              Align = alLeft
              BevelOuter = bvNone
              Color = clWhite
              ParentBackground = False
              TabOrder = 0
              object SpeedButton_StockOutQuery: TSpeedButton
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 94
                Height = 89
                Hint = '{"src":"media/images/dws/pz.jpg"}'
                Align = alClient
                Caption = #26597#35810#20986#24211#21333
                OnClick = SpeedButton_StockOutQueryClick
                ExplicitLeft = 500
                ExplicitTop = 0
                ExplicitWidth = 100
                ExplicitHeight = 110
              end
            end
            object Panel12: TPanel
              AlignWithMargins = True
              Left = 700
              Top = 10
              Width = 106
              Height = 95
              Hint = '{"radius":"5px"}'
              Margins.Left = 7
              Margins.Top = 10
              Margins.Right = 7
              Margins.Bottom = 5
              Align = alLeft
              BevelOuter = bvNone
              Color = clWhite
              ParentBackground = False
              TabOrder = 1
              object SpeedButton_StockInQuery: TSpeedButton
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 100
                Height = 89
                Hint = '{"src":"media/images/dws/bq.jpg"}'
                Align = alClient
                Caption = #26597#35810#20837#24211#21333
                OnClick = SpeedButton_StockInQueryClick
                ExplicitLeft = 400
                ExplicitTop = 0
                ExplicitHeight = 110
              end
            end
            object Panel13: TPanel
              AlignWithMargins = True
              Left = 466
              Top = 10
              Width = 106
              Height = 95
              Hint = '{"radius":"5px"}'
              Margins.Left = 7
              Margins.Top = 10
              Margins.Right = 7
              Margins.Bottom = 5
              Align = alLeft
              BevelOuter = bvNone
              Color = clWhite
              ParentBackground = False
              TabOrder = 2
              object SpeedButton24: TSpeedButton
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 100
                Height = 89
                Hint = '{"src":"media/images/dws/pj.jpg"}'
                Align = alClient
                Caption = #24037#31243#20449#24687#31649#29702
                ExplicitLeft = 400
                ExplicitTop = 0
                ExplicitHeight = 110
              end
            end
            object Panel14: TPanel
              AlignWithMargins = True
              Left = 235
              Top = 10
              Width = 100
              Height = 95
              Hint = '{"radius":"5px"}'
              Margins.Left = 7
              Margins.Top = 10
              Margins.Right = 7
              Margins.Bottom = 5
              Align = alLeft
              BevelOuter = bvNone
              Color = clWhite
              ParentBackground = False
              TabOrder = 3
              object SpeedButton31: TSpeedButton
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 94
                Height = 89
                Hint = '{"src":"media/images/dws/dd.jpg"}'
                Align = alClient
                Caption = #20135#21697#20986#24211
                OnClick = SpeedButton31Click
                ExplicitLeft = 300
                ExplicitTop = 0
                ExplicitWidth = 100
                ExplicitHeight = 110
              end
            end
            object Panel15: TPanel
              AlignWithMargins = True
              Left = 7
              Top = 10
              Width = 100
              Height = 95
              Hint = '{"radius":"5px"}'
              Margins.Left = 7
              Margins.Top = 10
              Margins.Right = 7
              Margins.Bottom = 5
              Align = alLeft
              BevelOuter = bvNone
              Color = clWhite
              ParentBackground = False
              TabOrder = 4
              object SpeedButton38: TSpeedButton
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 94
                Height = 89
                Hint = '{"src":"media/images/dws/sp.jpg"}'
                Align = alClient
                Caption = #24211#23384#26597#35810
                OnClick = SpeedButton38Click
                ExplicitLeft = -4
                ExplicitTop = 8
              end
            end
            object Panel16: TPanel
              AlignWithMargins = True
              Left = 121
              Top = 10
              Width = 100
              Height = 95
              Hint = '{"radius":"5px"}'
              Margins.Left = 7
              Margins.Top = 10
              Margins.Right = 7
              Margins.Bottom = 5
              Align = alLeft
              BevelOuter = bvNone
              Color = clWhite
              ParentBackground = False
              TabOrder = 5
              object SpeedButton44: TSpeedButton
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 94
                Height = 89
                Hint = '{"src":"media/images/dws/fx.jpg"}'
                Align = alClient
                Caption = #20135#21697#20837#24211
                OnClick = SpeedButton44Click
                ExplicitLeft = 100
                ExplicitTop = 0
                ExplicitWidth = 100
                ExplicitHeight = 110
              end
            end
            object Panel17: TPanel
              AlignWithMargins = True
              Left = 352
              Top = 10
              Width = 100
              Height = 95
              Hint = '{"radius":"5px"}'
              Margins.Left = 10
              Margins.Top = 10
              Margins.Right = 7
              Margins.Bottom = 5
              Align = alLeft
              BevelOuter = bvNone
              Color = clWhite
              ParentBackground = False
              TabOrder = 6
              object SpeedButton53: TSpeedButton
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 94
                Height = 89
                Hint = '{"src":"media/images/dws/yh.jpg"}'
                Align = alClient
                Caption = #29992#25143#31649#29702
                ExplicitLeft = 0
                ExplicitTop = 0
                ExplicitWidth = 100
                ExplicitHeight = 110
              end
            end
            object Panel18: TPanel
              AlignWithMargins = True
              Left = 586
              Top = 10
              Width = 100
              Height = 95
              Hint = '{"radius":"5px"}'
              Margins.Left = 7
              Margins.Top = 10
              Margins.Right = 7
              Margins.Bottom = 5
              Align = alLeft
              BevelOuter = bvNone
              Color = clWhite
              ParentBackground = False
              TabOrder = 7
              object SpeedButton1: TSpeedButton
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 94
                Height = 89
                Hint = '{"src":"media/images/dws/xx.jpg"}'
                Align = alClient
                Caption = #20379#24212#21830#31649#29702
                ExplicitLeft = 500
                ExplicitTop = 0
                ExplicitWidth = 100
                ExplicitHeight = 110
              end
            end
          end
          object Panel6: TPanel
            AlignWithMargins = True
            Left = 10
            Top = 10
            Width = 849
            Height = 110
            Hint = '{"radius":"5px"}'
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 5
            Align = alTop
            BevelOuter = bvNone
            ParentBackground = False
            TabOrder = 0
            object Image1: TImage
              AlignWithMargins = True
              Left = 20
              Top = 23
              Width = 64
              Height = 64
              Hint = '{"src":"media/images/dws/avatar.jpg","radius":"50%"}'
              Margins.Left = 20
              Margins.Top = 23
              Margins.Bottom = 23
              Align = alLeft
              Stretch = True
            end
            object Label2: TLabel
              Left = 112
              Top = 16
              Width = 369
              Height = 41
              AutoSize = False
              Caption = #26089#23433#65292#31649#29702#21592#65292#24320#22987#24744#19968#22825#30340#24037#20316#21543#65281
              Font.Charset = ANSI_CHARSET
              Font.Color = 3289650
              Font.Height = -21
              Font.Name = #24494#36719#38597#40657
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
            end
            object Label4: TLabel
              Left = 152
              Top = 56
              Width = 345
              Height = 19
              AutoSize = False
              Caption = #20170#26085#38452#36716#23567#38632#65292'22'#8451' - 32'#8451#65292#20986#38376#35760#24471#24102#20254#21734#12290
              Font.Charset = ANSI_CHARSET
              Font.Color = 6579300
              Font.Height = -13
              Font.Name = #24494#36719#38597#40657
              Font.Style = []
              ParentFont = False
            end
            object Image2: TImage
              AlignWithMargins = True
              Left = 116
              Top = 51
              Width = 28
              Height = 28
              Hint = '{"src":"media/images/dws/rain.png"}'
              Margins.Left = 20
              Margins.Top = 23
              Margins.Bottom = 23
            end
            object Panel8: TPanel
              AlignWithMargins = True
              Left = 719
              Top = 10
              Width = 120
              Height = 90
              Hint = '{"radius":"5px"}'
              Margins.Left = 10
              Margins.Top = 10
              Margins.Right = 10
              Margins.Bottom = 10
              Align = alRight
              BevelKind = bkFlat
              BevelOuter = bvNone
              Color = clWhite
              ParentBackground = False
              TabOrder = 0
              object Label7: TLabel
                Left = 47
                Top = 13
                Width = 58
                Height = 24
                AutoSize = False
                Caption = #28040#24687
                Font.Charset = ANSI_CHARSET
                Font.Color = 6579300
                Font.Height = -15
                Font.Name = #24494#36719#38597#40657
                Font.Style = [fsBold]
                ParentFont = False
                Layout = tlCenter
              end
              object Label8: TLabel
                Left = 8
                Top = 43
                Width = 81
                Height = 31
                Alignment = taCenter
                AutoSize = False
                Caption = '1,298'
                Font.Charset = ANSI_CHARSET
                Font.Color = 6579300
                Font.Height = -24
                Font.Name = #24494#36719#38597#40657
                Font.Style = []
                ParentFont = False
                Layout = tlCenter
              end
              object Label9: TLabel
                Left = 16
                Top = 95
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
              object Button7: TButton
                Left = 12
                Top = 13
                Width = 24
                Height = 24
                Hint = '{"icon":"el-icon-bell","type":"info","dwattr":"plain circle"}'
                TabOrder = 0
              end
            end
            object Panel9: TPanel
              AlignWithMargins = True
              Left = 589
              Top = 10
              Width = 120
              Height = 90
              Hint = '{"radius":"5px"}'
              Margins.Left = 10
              Margins.Top = 10
              Margins.Right = 0
              Margins.Bottom = 10
              Align = alRight
              BevelKind = bkFlat
              BevelOuter = bvNone
              Color = clWhite
              ParentBackground = False
              TabOrder = 1
              object Label16: TLabel
                Left = 47
                Top = 13
                Width = 58
                Height = 24
                AutoSize = False
                Caption = #24453#21150#25968
                Font.Charset = ANSI_CHARSET
                Font.Color = 6579300
                Font.Height = -15
                Font.Name = #24494#36719#38597#40657
                Font.Style = [fsBold]
                ParentFont = False
                Layout = tlCenter
              end
              object Label17: TLabel
                Left = 8
                Top = 43
                Width = 81
                Height = 31
                Alignment = taRightJustify
                AutoSize = False
                Caption = '6 / 18'
                Font.Charset = ANSI_CHARSET
                Font.Color = 6579300
                Font.Height = -24
                Font.Name = #24494#36719#38597#40657
                Font.Style = []
                ParentFont = False
                Layout = tlCenter
              end
              object Label18: TLabel
                Left = 16
                Top = 95
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
              object Button8: TButton
                Left = 12
                Top = 13
                Width = 24
                Height = 24
                Hint = 
                  '{"icon":"el-icon-finished","type":"info","dwattr":"plain circle"' +
                  '}'
                TabOrder = 0
              end
            end
            object Panel10: TPanel
              AlignWithMargins = True
              Left = 459
              Top = 10
              Width = 120
              Height = 90
              Hint = '{"radius":"5px"}'
              Margins.Left = 10
              Margins.Top = 10
              Margins.Right = 0
              Margins.Bottom = 10
              Align = alRight
              BevelKind = bkFlat
              BevelOuter = bvNone
              Color = clWhite
              ParentBackground = False
              TabOrder = 2
              object Label19: TLabel
                Left = 47
                Top = 13
                Width = 58
                Height = 24
                AutoSize = False
                Caption = #39033#30446#25968
                Font.Charset = ANSI_CHARSET
                Font.Color = 6579300
                Font.Height = -15
                Font.Name = #24494#36719#38597#40657
                Font.Style = [fsBold]
                ParentFont = False
                Layout = tlCenter
              end
              object Label20: TLabel
                Left = 8
                Top = 43
                Width = 81
                Height = 31
                Alignment = taRightJustify
                AutoSize = False
                Caption = '6'
                Font.Charset = ANSI_CHARSET
                Font.Color = 6579300
                Font.Height = -24
                Font.Name = #24494#36719#38597#40657
                Font.Style = []
                ParentFont = False
                Layout = tlCenter
              end
              object Label21: TLabel
                Left = 16
                Top = 95
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
              object Button9: TButton
                Left = 12
                Top = 13
                Width = 24
                Height = 24
                Hint = '{"icon":"el-icon-menu","type":"success","dwattr":"plain circle"}'
                TabOrder = 0
              end
            end
          end
          object Panel7: TPanel
            AlignWithMargins = True
            Left = 10
            Top = 245
            Width = 849
            Height = 160
            Hint = '{"radius":"5px"}'
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 5
            Align = alTop
            BevelOuter = bvNone
            ParentBackground = False
            ParentColor = True
            TabOrder = 2
            object Panel21: TPanel
              AlignWithMargins = True
              Left = 0
              Top = 0
              Width = 300
              Height = 160
              Hint = '{"radius":"5px"}'
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              Align = alLeft
              BevelOuter = bvNone
              Color = 5196610
              ParentBackground = False
              TabOrder = 0
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
              object Button10: TButton
                AlignWithMargins = True
                Left = 16
                Top = 92
                Width = 121
                Height = 36
                Hint = 
                  '{"radius":"0px","backgroundcolor":"#424B4f","icon":"el-icon-s-to' +
                  'ols"}'
                Margins.Top = 40
                Margins.Right = 30
                Margins.Bottom = 40
                Caption = #26356#22810#26376#20221
                TabOrder = 0
              end
            end
            object Panel22: TPanel
              AlignWithMargins = True
              Left = 310
              Top = 0
              Width = 280
              Height = 160
              Hint = '{"radius":"5px"}'
              Margins.Left = 10
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              Align = alLeft
              BevelOuter = bvNone
              Color = 10049400
              ParentBackground = False
              TabOrder = 1
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
            object Panel23: TPanel
              AlignWithMargins = True
              Left = 600
              Top = 0
              Width = 300
              Height = 160
              Hint = '{"radius":"5px"}'
              Margins.Left = 10
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              Align = alLeft
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
                Top = 95
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
          end
        end
      end
      object TabSheet2: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #24211#23384#26597#35810
        ImageIndex = 1
        TabVisible = False
      end
      object TabSheet3: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #20135#21697#20837#24211
        ImageIndex = 2
        TabVisible = False
      end
      object TabSheet4: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #20135#21697#20986#24211
        ImageIndex = 3
        TabVisible = False
      end
      object TabSheet5: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #29992#25143#31649#29702
        ImageIndex = 4
        TabVisible = False
      end
      object TabSheet6: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #24037#31243#20449#24687#31649#29702
        ImageIndex = 5
        TabVisible = False
      end
      object TabSheet7: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #20379#24212#21830#20449#24687#31649#29702
        ImageIndex = 6
        TabVisible = False
      end
      object TabSheet8: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #39046#26009#21333#20301#31649#29702
        ImageIndex = 7
        TabVisible = False
      end
      object TabSheet9: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #20179#24211#20449#24687#31649#29702
        ImageIndex = 8
        TabVisible = False
      end
      object TabSheet10: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #31867#21035#20449#24687#31649#29702
        ImageIndex = 9
        TabVisible = False
      end
      object TabSheet11: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #20135#21697#20449#24687#31649#29702
        ImageIndex = 10
        TabVisible = False
      end
      object TabSheet_StockIn: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #26597#35810#20837#24211#21333
        ImageIndex = 38
        TabVisible = False
      end
      object TabSheet_StockOut: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #26597#35810#20986#24211#21333
        ImageIndex = 37
        TabVisible = False
      end
      object TabSheet14: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #20998#31867#32479#35745
        ImageIndex = 13
        TabVisible = False
      end
    end
  end
  object Panel_0_Banner: TPanel
    Left = 0
    Top = 0
    Width = 1083
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    Color = 6577236
    ParentBackground = False
    TabOrder = 1
    object Label3: TLabel
      AlignWithMargins = True
      Left = 220
      Top = 3
      Width = 319
      Height = 18
      Margins.Left = 20
      Align = alClient
      Caption = ' DeWeb Warehouse Manage System'
      Color = 4210752
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
    end
    object Panel36: TPanel
      Left = 0
      Top = 0
      Width = 200
      Height = 50
      Align = alLeft
      BevelOuter = bvNone
      Color = 28141
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -29
      Font.Name = 'Verdana'
      Font.Style = [fsBold, fsItalic]
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 114
        Height = 29
        Align = alClient
        Alignment = taCenter
        Caption = 'D.W.M.S'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -24
        Font.Name = 'Verdana'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        Layout = tlCenter
      end
    end
  end
  object Panel_Menu: TPanel
    Left = 0
    Top = 50
    Width = 200
    Height = 678
    Align = alLeft
    BevelOuter = bvNone
    Color = 6577236
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -19
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 2
    object Button4: TButton
      AlignWithMargins = True
      Left = 0
      Top = 637
      Width = 200
      Height = 40
      Hint = '{"type":"primary","radius":"0px"}'
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 1
      Align = alBottom
      Caption = #31995#32479#35774#32622
      TabOrder = 0
    end
  end
  object MainMenu: TMainMenu
    AutoHotkeys = maManual
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    Left = 319
    Top = 59
    object MenuItem_Home: TMenuItem
      Caption = #39318#39029
      Hint = '{"dwattr":"unique-opened"}'
      ImageIndex = 55
      OnClick = MenuItem_HomeClick
    end
    object MenuItem_Inventory: TMenuItem
      Caption = #24211#23384#26597#35810
      ImageIndex = 59
      OnClick = MenuItem_InventoryClick
    end
    object MenuItem_StockIn: TMenuItem
      Caption = #20135#21697#20837#24211
      ImageIndex = 60
      OnClick = MenuItem_StockInClick
    end
    object MenuItem_StockOut: TMenuItem
      Caption = #20135#21697#20986#24211
      ImageIndex = 61
      OnClick = MenuItem_StockOutClick
    end
    object N4: TMenuItem
      Caption = #29992#25143#31649#29702
      ImageIndex = 62
      object N16: TMenuItem
        Caption = #29992#25143#20449#24687#31649#29702
      end
      object N17: TMenuItem
        Caption = #35282#33394#26435#38480#31649#29702
      end
      object N18: TMenuItem
        Caption = #35282#33394#31649#29702
      end
    end
    object N14: TMenuItem
      Caption = #20449#24687#31649#29702
      ImageIndex = 63
      object N10: TMenuItem
        Caption = #20135#21697#20449#24687#31649#29702
        ImageIndex = 68
      end
      object N8: TMenuItem
        Caption = #20179#24211#20449#24687#31649#29702
        ImageIndex = 66
      end
      object N6: TMenuItem
        Caption = #20379#24212#21830#20449#24687#31649#29702
        ImageIndex = 64
      end
      object N7: TMenuItem
        Caption = #39046#26009#21333#20301#20449#24687#31649#29702
        ImageIndex = 65
      end
    end
    object MenuItem_StockInQuery: TMenuItem
      Caption = #26597#35810#20837#24211
      ImageIndex = 69
      OnClick = MenuItem_StockInQueryClick
    end
    object MenuItem_StockOutQuery: TMenuItem
      Caption = #26597#35810#20986#24211
      ImageIndex = 70
      OnClick = MenuItem_StockOutQueryClick
    end
    object N13: TMenuItem
      Caption = #20998#31867#32479#35745
      ImageIndex = 71
    end
    object N1: TMenuItem
      Caption = #31995#32479#35774#32622
      ImageIndex = 68
    end
  end
end
