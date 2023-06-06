object Form1: TForm1
  Left = 0
  Top = 0
  Hint = 
    '{"dwattr":":fetch-suggestions=\"[{\\\"value\\\":\\\"aaa\\\"}]\""' +
    '}'
  VertScrollBar.Visible = False
  BorderStyle = bsNone
  Caption = 'DWMS'
  ClientHeight = 728
  ClientWidth = 1200
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
  OnShow = FormShow
  OnStartDock = FormStartDock
  PixelsPerInch = 96
  TextHeight = 20
  object Panel_Client: TPanel
    Left = 200
    Top = 40
    Width = 1000
    Height = 688
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
      Width = 994
      Height = 682
      Hint = '{"dwattr":"closable"}'
      ActivePage = TabSheet_Home
      Align = alClient
      TabOrder = 0
      OnChange = PageControl1Change
      OnEndDock = PageControl1EndDock
      object TabSheet_Home: TTabSheet
        Hint = '{"type":"primary"}'
        Caption = #39318#39029
        object Panel5: TPanel
          Left = 0
          Top = 0
          Width = 986
          Height = 648
          Align = alClient
          BevelOuter = bvNone
          Color = clWhite
          ParentBackground = False
          TabOrder = 0
          object Panel_Buttons: TPanel
            Left = 0
            Top = 125
            Width = 986
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
              Left = 469
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
                Hint = '{"src":"media/images/dwms/pz.jpg"}'
                Align = alClient
                Caption = #26597#35810#20986#24211#21333
                OnClick = SpeedButton_StockOutQueryClick
                ExplicitLeft = 11
                ExplicitTop = 8
              end
            end
            object Panel12: TPanel
              AlignWithMargins = True
              Left = 349
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
                Hint = '{"src":"media/images/dwms/bq.jpg"}'
                Align = alClient
                Caption = #26597#35810#20837#24211#21333
                OnClick = SpeedButton_StockInQueryClick
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
              TabOrder = 2
              object SpeedButton_StockOut: TSpeedButton
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 94
                Height = 89
                Hint = '{"src":"media/images/dwms/dd.jpg"}'
                Align = alClient
                Caption = #20135#21697#20986#24211
                OnClick = SpeedButton_StockOutClick
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
              TabOrder = 3
              object SpeedButton_Inventory: TSpeedButton
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 94
                Height = 89
                Hint = '{"src":"media/images/dwms/sp.jpg"}'
                Align = alClient
                Caption = #24211#23384#26597#35810
                OnClick = SpeedButton_InventoryClick
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
              TabOrder = 4
              object SpeedButton_StockIn: TSpeedButton
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 94
                Height = 89
                Hint = '{"src":"media/images/dwms/fx.jpg"}'
                Align = alClient
                Caption = #20135#21697#20837#24211
                OnClick = SpeedButton_StockInClick
                ExplicitLeft = 100
                ExplicitTop = 0
                ExplicitWidth = 100
                ExplicitHeight = 110
              end
            end
            object Panel17: TPanel
              AlignWithMargins = True
              Left = 586
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
              TabOrder = 5
              object SpeedButton_User: TSpeedButton
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 94
                Height = 89
                Hint = '{"src":"media/images/dwms/yh.jpg"}'
                Align = alClient
                Caption = #29992#25143#31649#29702
                OnClick = SpeedButton_UserClick
                ExplicitLeft = 0
                ExplicitTop = 0
                ExplicitWidth = 100
                ExplicitHeight = 110
              end
            end
            object Panel18: TPanel
              AlignWithMargins = True
              Left = 700
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
              TabOrder = 6
              object SpeedButton_Supplier: TSpeedButton
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 94
                Height = 89
                Hint = '{"src":"media/images/dwms/xx.jpg"}'
                Align = alClient
                Caption = #20379#24212#21830#31649#29702
                OnClick = SpeedButton_SupplierClick
                ExplicitLeft = 500
                ExplicitTop = 0
                ExplicitWidth = 100
                ExplicitHeight = 110
              end
            end
            object Panel13: TPanel
              AlignWithMargins = True
              Left = 814
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
              object SpeedButton_Requisition: TSpeedButton
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 94
                Height = 89
                Hint = '{"src":"media/images/dwms/xx.jpg"}'
                Align = alClient
                Caption = #39046#26009#21333#20301#31649#29702
                OnClick = SpeedButton_SupplierClick
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
            Width = 966
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
              Hint = '{"src":"media/images/dwms/avatar.jpg","radius":"50%"}'
              Margins.Left = 20
              Margins.Top = 23
              Margins.Bottom = 23
              Align = alLeft
              Stretch = True
            end
            object Label_Welcome: TLabel
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
              Hint = '{"src":"media/images/dwms/rain.png"}'
              Margins.Left = 20
              Margins.Top = 23
              Margins.Bottom = 23
            end
            object Panel8: TPanel
              AlignWithMargins = True
              Left = 816
              Top = 10
              Width = 140
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
                Left = 42
                Top = 13
                Width = 87
                Height = 24
                AutoSize = False
                Caption = #39046#26009#21333#20301#25968
                Font.Charset = ANSI_CHARSET
                Font.Color = 6579300
                Font.Height = -15
                Font.Name = #24494#36719#38597#40657
                Font.Style = [fsBold]
                ParentFont = False
                Layout = tlCenter
              end
              object Label8: TLabel
                Left = 42
                Top = 43
                Width = 71
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
              Left = 686
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
                Left = 42
                Top = 13
                Width = 63
                Height = 24
                AutoSize = False
                Caption = #20379#24212#21830#25968
                Font.Charset = ANSI_CHARSET
                Font.Color = 6579300
                Font.Height = -15
                Font.Name = #24494#36719#38597#40657
                Font.Style = [fsBold]
                ParentFont = False
                Layout = tlCenter
              end
              object Label17: TLabel
                Left = 42
                Top = 43
                Width = 55
                Height = 31
                Alignment = taCenter
                AutoSize = False
                Caption = '18'
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
              Left = 556
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
                Caption = #24211#23384#25968
                Font.Charset = ANSI_CHARSET
                Font.Color = 6579300
                Font.Height = -15
                Font.Name = #24494#36719#38597#40657
                Font.Style = [fsBold]
                ParentFont = False
                Layout = tlCenter
              end
              object Label20: TLabel
                Left = 48
                Top = 43
                Width = 41
                Height = 31
                Alignment = taCenter
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
            Width = 966
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
          object StringGrid1: TStringGrid
            Left = 163
            Top = 432
            Width = 120
            Height = 98
            ColCount = 1
            FixedCols = 0
            TabOrder = 3
            Visible = False
          end
        end
      end
      object TabSheet_Inventory: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #24211#23384#26597#35810
        ImageIndex = 1
        TabVisible = False
      end
      object TabSheet_StockIn: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #20135#21697#20837#24211
        ImageIndex = 2
        TabVisible = False
      end
      object TabSheet_StockOut: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #20135#21697#20986#24211
        ImageIndex = 3
        TabVisible = False
      end
      object TabSheet_User: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #29992#25143#31649#29702
        ImageIndex = 4
        TabVisible = False
      end
      object TabSheet_Supplier: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #20379#24212#21830#20449#24687#31649#29702
        ImageIndex = 6
        TabVisible = False
      end
      object TabSheet_Requisition: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #39046#26009#21333#20301#31649#29702
        ImageIndex = 7
        TabVisible = False
      end
      object TabSheet_Warehouse: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #20179#24211#20449#24687#31649#29702
        ImageIndex = 8
        TabVisible = False
      end
      object TabSheet_Product: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #20135#21697#20449#24687#31649#29702
        ImageIndex = 10
        TabVisible = False
      end
      object TabSheet_StockInQuery: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #26597#35810#20837#24211#21333
        ImageIndex = 38
        TabVisible = False
      end
      object TabSheet_StockOutQuery: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #26597#35810#20986#24211#21333
        ImageIndex = 37
        TabVisible = False
      end
      object TabSheet_Stat: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #20998#31867#32479#35745
        ImageIndex = 13
        TabVisible = False
      end
      object TabSheet_UserRole: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #35282#33394#26435#38480#31649#29702
        ImageIndex = 70
        TabVisible = False
      end
      object TabSheet_Document: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #36164#26009#31649#29702#31995#32479
        ImageIndex = 15
        TabVisible = False
      end
      object TabSheet_Card: TTabSheet
        Hint = '{"dwattr":"closable"}'
        Caption = #29992#25143#21517#29255#22841
        ImageIndex = 190
        TabVisible = False
      end
    end
  end
  object Panel_0_Banner: TPanel
    Left = 0
    Top = 0
    Width = 1200
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    Color = 4271650
    ParentBackground = False
    TabOrder = 1
    object Label3: TLabel
      AlignWithMargins = True
      Left = 256
      Top = 3
      Width = 672
      Height = 34
      Margins.Left = 10
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
      ExplicitWidth = 319
      ExplicitHeight = 18
    end
    object Label_User: TLabel
      AlignWithMargins = True
      Left = 934
      Top = 3
      Width = 76
      Height = 32
      Margins.Right = 10
      Margins.Bottom = 5
      Align = alRight
      Alignment = taRightJustify
      Caption = 'UserName'
      Font.Charset = ANSI_CHARSET
      Font.Color = 13158600
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      Visible = False
      ExplicitHeight = 20
    end
    object Panel_Title: TPanel
      Left = 0
      Top = 0
      Width = 200
      Height = 40
      Align = alLeft
      BevelOuter = bvNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -29
      Font.Name = 'Verdana'
      Font.Style = [fsBold, fsItalic]
      ParentBackground = False
      ParentColor = True
      ParentFont = False
      TabOrder = 0
      object Label_Title: TLabel
        Left = 0
        Top = 0
        Width = 200
        Height = 40
        HelpType = htKeyword
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
        WordWrap = True
        ExplicitWidth = 114
        ExplicitHeight = 29
      end
    end
    object Button_Collapse: TButton
      AlignWithMargins = True
      Left = 200
      Top = 0
      Width = 46
      Height = 40
      Hint = '{"icon":"el-icon-s-fold","type":"text","color":"#EEE"}'
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = Button_CollapseClick
    end
    object Button_Logout: TButton
      AlignWithMargins = True
      Left = 1140
      Top = 8
      Width = 50
      Height = 24
      Hint = 
        '{"type":"text","fontsize":"14px","icon":"el-icon-close","color":' +
        '"#C8C8C8"}'
      Margins.Left = 0
      Margins.Top = 8
      Margins.Right = 10
      Margins.Bottom = 8
      Align = alRight
      Caption = #36864#20986
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Visible = False
      OnClick = Button_LogoutClick
    end
    object Button_Register: TButton
      AlignWithMargins = True
      Left = 1020
      Top = 8
      Width = 50
      Height = 24
      Hint = 
        '{"type":"text","icon":"el-icon-user","fontsize":"14px","color":"' +
        '#C8C8C8"}'
      Margins.Left = 0
      Margins.Top = 8
      Margins.Right = 10
      Margins.Bottom = 8
      Align = alRight
      Caption = #27880#20876
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Button_RegisterClick
    end
    object Button_Login: TButton
      AlignWithMargins = True
      Left = 1080
      Top = 8
      Width = 50
      Height = 24
      Hint = 
        '{"type":"text","icon":"el-icon-user","fontsize":"14px","color":"' +
        '#C8C8C8"}'
      Margins.Left = 0
      Margins.Top = 8
      Margins.Right = 10
      Margins.Bottom = 8
      Align = alRight
      Caption = #30331#24405
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = Button_LoginClick
    end
  end
  object Panel_Menu: TPanel
    Left = 0
    Top = 40
    Width = 200
    Height = 688
    Align = alLeft
    BevelOuter = bvNone
    Color = 5718321
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -19
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 2
  end
  object Panel_LoginForm: TPanel
    Left = 800
    Top = 50
    Width = 1000
    Height = 576
    Hint = '{"dwstyle":"z-index:2;"}'
    BevelEdges = [beLeft, beTop]
    BevelOuter = bvNone
    Caption = 'Panel_Login'
    TabOrder = 3
    Visible = False
    DesignSize = (
      1000
      576)
    object Image_bg: TImage
      Left = 0
      Top = 0
      Width = 1000
      Height = 576
      Hint = '{"src":"media/images/dwms/bg-login.jpg"}'
      Margins.Top = 4
      Align = alClient
      Stretch = True
    end
    object Panel_Register: TPanel
      Left = 320
      Top = 50
      Width = 360
      Height = 501
      Hint = '{"radius":"5px"}'
      Anchors = [akTop]
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Color = clWhite
      ParentBackground = False
      TabOrder = 1
      object Image3: TImage
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 350
        Height = 100
        Hint = '{"src":"media/images/dwms/dwms1.png"}'
        Align = alTop
        Center = True
        Picture.Data = {
          0954506E67496D61676589504E470D0A1A0A0000000D49484452000001180000
          005A08060000006369495F000000017352474200AECE1CE90000000467414D41
          0000B18F0BFC6105000000097048597300000EC400000EC401952B0E1B00002F
          AA4944415478DAED5D079C14D5FDFFCEB6DB6B7414507A5111B0C7880D6341C1
          026A1063418962D4A81835C69AA6B1C6D8FE1A34168CBD624562104141341A51
          1010905E0EA45CBFAD33FFF79DDDB9DBDD9B999DD99DDD9330DF0FCBEEEDCEBC
          79EFCDBCEF7C7FE5BD911401B870E1C2450120B904E3C2858B42C12518172E5C
          140C2EC1B870E1A2607009C6850B1705834B302E5CB828185C8271E1C245C1B0
          13104C5CFC5B0A28EBC56B0B20EF10DF8592BF79440BCAC5AB93F8D84DBCF715
          EFBDDABAC22E5CB848E2C74730B17F03D1B7C56B962096858250584B9B65782A
          00EFC1807FA4789D2C3E0F69EB56B970B14BA2ED0946090B41F228107E5C90CA
          E264ADB4DAF9A0AA145B0CC3E6C4C49BDCF227770F08B2095E21DE47B769735D
          B8D895D0760413791F4AC3CD8254BE4CD6C42BFE0B88770B64A2928792DCC702
          146166219C201BA2F47C6159DD2EB86BCF3669BA0B17BB0A8A4E304AD3142875
          570BD3A7491CDD2F5E25B0A5509486E487A078358A5D2BD12253AC40909322F6
          931571E803C4EEFF1066D481C5EC02172E7619148D6094A6A9506A2E161FA242
          A45458571F2D551542A41A52E010485D3E4F9459733994FA478425D51109678D
          CD3AD13C9343A2CC61903ABE0978FB14A32B5CB8D86550788289AD84B2ED18C1
          2B6B21794804768945ADA6B08A7E1066CDB98208FE99F68B52FF30941D5708BE
          EA927315159A4F729D28FF2C51FE8B05ED0E172E7625149460941D570973E841
          40108B2405722F27B65914711BD0EE26FD0D421F42DE7CAC50325D91700AE778
          1CA54E753A7BBABC05948E2A54B7B870B1CBA03004235743D93858A80E61D248
          1DEC8799352824974DF0ECFE2A507646CAF79144C429B07FCB77B17590D7F712
          02A9AB38A61F2D1E5DBBC7948529B659A899F190BABEE078D7B870B12BC17982
          699C26D4C458610E754B3871738618E8D10DF0F4FC5A10C9B096AF238B216FD8
          4FFC1C134AE36F40FBC92DBF89A6286B3A25FC3B52597EED906B05599543DA73
          65D211EDC2C5CE8768348AC58B1763E3C68DA8A9A9412C1683DFEF47A74E9DD0
          AB572FECB5D75E053DBEA304A36CBF05F2F63B001FC3BFB9CA16A80A4552B643
          EA239484A75D4AF97740DE7623E0EF0DD5148AAF83547A1C3C3DA6A7ED2EAF1D
          2A94CF7AD534CB59C924EBC1CC61CF9EF305C70CCBBD9C9D148F3EFA28CACBCB
          73DAB7B1B11113274E44201070A44C0E94BDF7DE1B871F7E78F3779B366DC2DB
          6FBF8D60309875FFA6A626FCFCE73F5707D6F7DF7F8F0F3FFC102525D66E1CB2
          2CA37DFBF6183B76AC23FDFAC30F3FE08D37DEB0546F22140AE1E4934F468F1E
          3D2C6D5F555585679E7906EFBDF71EB66FDFDE7C0E482E6C0B5F842449E0F01F
          3468905AFEB9E79EDBEA7CE50BC70846D97C01E4BAD78578D82DBF72E406D55F
          E3E9B726ED7B79DD1150C20B44F9DDD1421AECA05AF1BF5F6CBF0EA9A4266F38
          154AE32C48BE6EC88B64A8A40459797A4C136653E1FD32B367CF562F645ED01A
          2A2A2A4CF7A9AFAF6FFEECF3F9D4ED3B76EC883DF7DC137DFAF4C17EFBED879F
          FEF4A7D8638F3D6CD5856574EBD60D1E8F472505AFD7D841CF8B97A4128FC7D5
          0B78F3E6CD58BD7AB55A46734F8AEF3B74E8D05C26CB2B2D2D55EFA89920A190
          14B80FCB6C6868C039E79C83BBEFBEBB799B4F3EF944EDABDD76DB4D2D832FB6
          5F03F78B44226A59AC0FFB76DF7DF7C56BAFBD865FFDEA576ADD580FBE38B058
          1723901456AC58E1C839BEEBAEBBF0FCF3CFA3ACCC5865D7D5D5A9F5E78B24C1
          3A1F7DF4D1A6E5B29D6CD7679F7DA65E3F24500E6F2A17B6F5B0C30E53AF099E
          4BF6E792254B306FDE3CF5EF70388CDADA5A1C77DC71B8FDF6DBB35E7356E108
          C1C81BCE84D230470CFE4E7995A308B520F9FBC3D3675ECB77E1A550561F0AC5
          DB5E108FFE095118FA8E6F84D46FA1D87F40CBF79B7F2B04C8C3E2BB7CE72709
          D32BB6169EEECF426A77469E65998352F69D77DE69BEBBF144DF73CF3D86279C
          E472DD75D7A9EF3C957C5FB972253EFEF863F5CEA75DC4FCCC327EF18B5FE092
          4B2E31250B0DEBD6AD5307E68E1D3BF0F7BFFF5DBDD05307B006924BEFDEBD31
          61C20474EEDC592532BE1B81E56CD8B0417D7FE18517B074E9D2349221291C70
          C00138EDB4D3D481B1FBEEBBABA424E92461B26E9F7FFE39BEFCF24BF59D8389
          6D637B39C8860F1F8E430E39043FF9C94F54724BC5D6AD5BD5BBFDB66DDBF0C5
          175FA8AAC2886438E0AFB8E20A95E4F205EB525959A9129BD1B1FEF8C73FAA6A
          8B7D6945B9B0FE5AFF6BCA8C7DC0EBE8A1871E52D59F1EE6CF9FAFB68B7DC3EB
          8744B37EFD7A957CAC2A2C33E44D30F2FAF304B9CC14E4D2218F5284128956C1
          53311252CFE79BBF55B6DE0779CB0DC224EA272E2E9E0CE3AAAAAD88AE80A7D7
          BB902A8E6FF97EC7E390375D0129D03FB1515E0EE775C25C7A09526571234C43
          870E5507981E3840162E5CA8FBDBA2458BF0A73FFD49251C5E405403BCE83808
          493437DD7413AC62EAD4A92AC9E8111DEFB22488193366D86EDB983163D4FAA4
          1217EFC403060CC03FFEF10FDBE51D73CC312AE10D1B360CFFF77FFF67793FF6
          214DBA4C12D2C0323970DF7FFF7DDB754A0549F0D24B2F55C9C30866E7540FDF
          7CF30DC68D1BA79291465AEC43920D954F36F0FA22896B04BE65CB167CFDF5D7
          79B553435E04A36CBA0E72F5F3825C3AE75A0412E4B2069E2E9321EDFE87E66F
          E5552740691226912FD524B250A7E84AA1341E84D46962CB77F573447982144A
          FA8AA3E5E11BA292890A73A9DF6C48A5C5F3C9E44A301AA812287B3515C0534E
          738617216DF57DF6D9276B1D789C134F3C115DBB76D5FD9D4AE7D34F3FB5E55F
          21D9515D64B68DF5637976061941454289CF3BEFF5D75F6FCB67F29FFFFC0797
          5D76994AA07A2A8DA099346DDA34D5ECCC1593274FC67FFFFB5F9508F44C43AD
          AFEDB47DFFFDF757C9442317F61FEB4A5567D496544C9A3409DF7DF75DB3FFC5
          EEF1CD9033C128DB9F12A6D18DC2FCE896CBEEDAE1A1445609554042382F516E
          7805941523A04815903C94F776ABC73257C3D3ED0648BB5DD7F2B5200679E981
          507C64EAEC9D6E0CFA647E8077F0B2C4ACED22205F8221E87FB8FCF2CBD34C0D
          2A0FEE7FE79D77E2D4534FCD5AC651471DA55EB07AE615EDF7DFFFFEF71835CA
          BABAA383F6B6DB6E43BB76ED5AFD565D5DAD4A7BFA8EAC82776B9A93244FFA21
          CC7C2A99E0F65416ECEB356BD6E80E7EFA8448B237DF7CB3E57233C1F269BAD1
          4C22D1E81DC7CE00FFCB5FFEA29AD4A9C44E1373F0E0C1AA43DD0A5E7FFD75D5
          B745B38D744093F1ABAFBECAB98DA9C8896094D012C8CB4608D3A5671E87166A
          20BC06DE016F0A9326111950B63C2CCC993F0001FA4C724F9853ED2086B83B4F
          84B4C76D29879411FF76B0285A108C94877DA944D537EF6067646436384130C4
          C30F3F8C7FFEF39F69039AA79F7E9FFBEFBF1F279C7082E9FE5441D3A74FD71D
          B85423471C7104EEB8E30ECBEDBAEAAAABD40B592F9A439238E59453F0BBDFFD
          CE7279540754221C28764D1912CC85175EA80E34BE38F0337D243431E9F32131
          E48237DF7C137FF8C31F70ECB1C7A24B972E6A9447AFED76CE291DF85495A9FE
          293A70CF3BEF3C9530AD804A963EAFEEDDBBAB6DE4DF73E6CCC9A98D99C88960
          E2DFEC0DC55399C37CA2249498306AABE0DD77BE50408919CDF165A70993E81B
          40280CC740BF4E97B38442BA2BEDEBD89211E2B72D8221DAE5562E2137C0537E
          A83097ECFB09ECC2298221468E1CA9DEE152A5332F013A5D3FFAE823D5163702
          FD073423522343CDDD212E4CDEE11995B00A5ED494F67ACE5BAA2B0EF07FFFFB
          DF96CB3BF8E0835562183F7EBC4A5E7640F38E3E18467818FD7AE9A59774A33C
          54562420FA7AEC827E92E5CB97E3C9279F54CD563A58F321183A62195ACEF4E7
          D0D1CF68129DBE564173926D23A886A88A9C806D82892F3F4710C11261BEE4A2
          0038A728240E1A8667D837AAE356097D0F79C94950BC348978677432EF8FFE9D
          CDF0741A0B4FEF7BD2DBB1620294DA4F2105BAE67C4C459094B7CF03903A1676
          8D192709860470E59557B622092D4782A69419E83C6558588F1468F77FF0C107
          867E9A5430F98B7759D6433258A2837E18D6D74AC874EDDAB56AD489A44487F4
          9021F61619E3712EBAE822DC7AEBADAA19C49030DB99099273FFFEFD5592B003
          46861826260152B591A8BFFDF65BDDBC13ABE7F4ADB7DE525565A68949F577FA
          E9A7E39A6BAEB15C3F3AD49F78E20995F078ADBDF8A23373F26C118CB26306E2
          2BAF16AA23FB05A4BB7FBC569DF9EC1DFA61E2EFAAC7105F274C9892DE820AF2
          3189B21C9724D3790C3C7DEE4CFB5E5EF747C855CF402AC96D5D180532A4D876
          780FFCB66075279C241882A60C2FA44C138077B06BAFBD16679D7596E1BE94DD
          1C187A775E0E2286CCCF38237B289FFE15E682F06EC94B502F644BBF0E235D56
          FC43CF3EFBAC6A0232CC9A8BFF8039357476DE70C30D2AF18D1E3D5A1DA8994E
          52D6957DCE63183969F5C008DC638F3DA626B431B24732A39AC9876068EE3EF2
          C823AD0898370B920E4D32ABA0994CBF10CBE24DE4E5975FB6DD877AB04530F1
          2FC45DC1C70430BB644025B11552C501F0EEF35CA2ACC5E3A0347C2DC88A92BC
          D02B4624954CD73305C9DC9EF68BB2F919C457DF0429D83719EBB607456E82A7
          F22078064E2958ED9D2698071E7840BD80324D009A251CA073E7CE35DC975114
          FA59F41CB3DC97660FCBCF060E342A947BEFBD5725353A3E33950CCB3BF0C003
          55FF503630B787A155AA84BFFDED6FB6FB9879432C432318F6CF7DF7DDA7FA73
          3241138404F1CB5FFED272F9544424709A5ECC49A1F962E44CB67A4E49D00F3E
          F8A06E1D1951A3196694FF522C582698F8AA5BA16C7B5B9D9F63F310E24AD998
          18DCFDEF1226D15AC4178E141C559678159C5C52EA11A982D4ED3C787BDF9AF6
          8B52F30962DF8E1724D3DBDA8A7A1950C29BE01FF62E50569893E934C1303FE6
          820B2ED0F5A530F98DF92346D11BA3D03241138B392D4CFA3203EFB024225E7A
          AC0B9DABCCD5C9BC9BF3773A55196ECD06866AB93F2359541F7641D390EA4C23
          188266965E821F8998E074032BA0AF847E2192A8E63C651E1255433E0443FFD4
          8D37DE9896F59D5A479E2B3B3EB142C01AC1C4EB10FD7C3F20C08BCAEA004CAE
          32175A036FDF5BE1E93109F2466112ADFEA33089F28D12E5014106DE3D2E85A7
          F775E9DF87D623FAD511001595DD3036338985E9E7DBDF7EA29915384D305A99
          A9C955CDDD202E4ADE6D193E368291F940F0CE4969CE89744678F7DD7771CB2D
          B7A8A1549A36667762864CE90FE07C19233087830396FE119A2E56723F324107
          37FD22A9046316E5623B592F2B9305497A0CC9D304A3F39538F3CC33D5B6E9D5
          D5EA392541312DC0C8E74522A7DAA229D5564AC612C1C4BFBB1C72F53C5B8E5D
          B5D0D02A7887BC084FC711887D730694BA059002F9CD5572A0C942716C80B7CF
          F5F0EC795946A5E3887E36540D614B1E7B33A895287363A6C2D3E1705BFB5941
          210886D124862333735AB46C5F333389763F89412FA98E1734F36D18DD30029D
          8FB366CD52DF997A4FD38139367A112C865CA9702EBEF862C3F2E8A0A47F8361
          563B7E8754508DFCFAD7BF4E231886A3795CBDAC5B46CC468C18614AC41AA8D6
          D8D78C546924AA97C1ACC1CE39A5494853D768DA01CF2733738F3FFE78B5AE66
          F39F0A81EC041313EAE5D321904ABADB28561667601DBC877D2D844A09E29F1D
          04C5530EC95B4C93C8B4D9AAA9E61D78073CDDCF6FDDE42F8E8412D92654497B
          EBF565E8DD2F54CC811F385EDB42100CCD014672F49C8CF48D309FC468B6319D
          937404EBCD37A28AE05D9D03DE08071D74903AE048325A19CCC1E11D3793F0B8
          1D8987BE0B239010389F896166ABB91F99D0231882B3B799199C3980396CA862
          162C58605A2EDBF89BDFFC0603070E4C739C527990C8F59216ED9C539AB35428
          7AEA2F153C16CD4DE6E090D8CD14A693C84A30F115B720BEF90DC06B91F9E488
          D8A91681235722BEF159C4975D0D0493CB2BFCA820A90ACB37F8EFF0EC767AAB
          5F63DF8C17AAED3361165271592499C866F80E7A1F9EF2ECA9F7765008826124
          E35FFFFA976ED21C2F44867A39F3D808F4C3D0D16B77E0D19C213931D12C35C7
          C5C8F1AC456DE8AB31EB1FFA32B83FE730E502D685261113FB52098691292DDA
          95092A104E4A3CE9A4930CCBA502A24F8A09760CA36B302254C2EE392561730E
          95918A49ED4BDE00A818796E49A68C18151259092632BBAFB833774A4E363487
          BAD482B712FE9F7E86D8D7678B01FA893089BA271E339283F3B4A050273E7AA0
          347E0FDF7E2FC0D3A575166B7CD90D88AF7F1A5229C3D8D99F5CA0C443C2443A
          14BE21CE26DF158260B20D1C1210F3418C40E722232F7A336EE9287EEEB9E774
          ED7E9A5754371CC4A9791A464963040704233A471E7964ABDFE823614487838B
          AA2B57307F8799C09904A3E5AFD0FCCA04D515673AB31F8DC081CCBA659E239A
          5724173D52B07B4EB92DD7BAE1520C92C571C6BAB35F99D3C3BEE56CF842C094
          60E4CDD3105B720D247FB699D20C03EF80A7A3185C439F42E413DEF902826CAC
          CF05694B288DABE03FE46D483AFE1379DDE3882DBB1E52B01FB22B194598565B
          103866BDA3F52B04C130A98ABE0BBD24360E2A868EE9883402A53F2714EA4530
          CCFC26BC8B3353960494990CC74C5C969739E8E8EFA0CF888EE14C90289F7AEA
          29759223B3707305A71690F0320986600488FDAC17F1E1A257CCC8D5EB478689
          99F54BA77966A8DD281789C8E59C528D528191F0B22999549068982049C77DEA
          5A3B4EC19460A25F8C81D2B042583766AB5CD1695A055FEF4990DA1F86A8502E
          52494F551DEC54685A09FFA1B3451BF66BF593B2ED43D1176700657D90358A16
          AD8177EFDBE1ED31DEB1AA158260388B9A93E1F4068615472D6114C6E545DBB3
          674FD53790D68FE252E33E543D7AA1670E6E3A97335591B6F0925E963193FA56
          AD5AA5920B1D99B9C28C6038FF8A91202332359AF7433F0B233D8F3FFEB86A52
          A682496D3431F51447AEE7947940AC0BCD25ABABF5A5B6837DCCEC60B3E92276
          6142300AC21FF4004A7830934125EED8BE813743AE5F0679E38B62FB7C6657B7
          1592E64FE34A048EFC0FA4F2D62151AA9CC8C70701C13DCCC3D872049E8A81F0
          1F3CCDB1DA15826078D7A7A962A46038D828BBCDC08B998B5265DED98D965BE0
          20A6EAA1FF81B39E3361A68A18096128393377877DA3E5D3E4034E3C6416B21E
          C110CCB3A1DF482F27867E0D6602A782C442D5459F12275266C26C1E563ECB25
          B02F1899A3039FE6A69585C552DBC26333A44ED3C90918128C5CF536A20B7F6D
          621E296A16ABAFD7458857BD2954CC16611255E0C71125CA0D0AEBDEB41A8111
          0B2195B6B649153986E887FDA0784A0D43F66A19A22F4A46563956AF42100C53
          D7A962F47C304CD1A739C26C5B3318A5AA137414F3CECD81A48166177D1DB4F9
          19CDD083912AD2233D26915169654668720127F791DC8C088673941869D2738A
          339FE5E9A79F4E7398B28DEC1F0E76B63B134679488413EBB190F038CD82CA84
          1126ABB941DA72A70CD13BB13EAF21C1C4164C427CEB2C7D3F8AA20E23783B1E
          0879DBBC840995EBCCEA1F1594C43F92CCB14B2005F5E72845661F0025B24308
          19FDD9D84A643B02073D07A98BF91AAA5651088261BA3F13DE8CA24899E4A007
          468B48147A930279619F7DF6D9EA728C1A18ED60B89473998CC0147AFA68322F
          6E4E1B603FA4AE52479F011DAC3C869DB47D3D642318AEC74B9F945E521BDBC4
          CCE75455C6BFD907546D7A6B2117E29CEA81C7FFEB5FFFAA92204D322BF3A7D8
          D7F4E53831E1D19060C233F7494CCD31200E49908A12AF171F9C5D85FCC701D1
          F0C6D528396E995032FA0B6547E69F0A79FBFCA40999D185F106787B9E03FF3E
          D993B0ACA01017237333183ED5B3D5E9F4A3B9A2379520138C86680B78A78221
          584A746DC946E6CE70862FD72F61929E117851D3219A99D7A117FEA68F83EBC7
          52D2E71B05A1EF819131928C1EC110F4F1D08CC86C2BEB46138E4B5712F42F91
          F03848697AE9A15804A3818A8404A8994ED9140D550C17A2CA35ECAF419F60A2
          F508BDDF53DCC18D171BA686C96FF9C91F339404B936916416412AEFA7BB55F4
          9BAB105FF37452E9B484B115392A88A9074A8EFAC891DA14E262D4D6FFC8BCD0
          2891698E70ED172BA0739583532F7F25D50F43938CE61407B0D9C2D90C91331C
          ADE76864F89B661D43BF1CE8344948448CE2E40B4EE2E44A75660463B62E31CD
          4AE69530439726D1CC99335593CEC8515E6C82D1402546C547956A969CC7A920
          9CC5CEFEC807BA04236FFD58DCA1CF14E224BFA704EC1C302649D5106C5C8592
          9F7D05A99D7EF25C7CC5C3882CBA0652597FC6D35AF68BEE4070F466476A5888
          8BD1685D17CA633A343937C80A7867E41C1B3DB5430263021D57F6A77A61921D
          27FB993D7180304A42A3C9C101CB39431CC0575F7DB51AF6FEF39FFF9C771FF3
          6E4D3F8B19C1102437E6C4E845CEE8047EF5D557D5BE2501D2F16C9497D25604
          A381897F340B8D54AA950C6A2BD02598D88A07115B7217247F652E65EE3450E4
          88EA4B51D3FC55A2494DA6935A92031B6A5032E25578F6D05FE7245E3503D14F
          4643AAE8DFBCBF12DA8C9213858915CC6DED9C54387D31D2C7C101AF37D0490A
          54253FFBD9CF2C97671461E15D904A8977744E6CA4C96065853AA3AC5E920E07
          04C98019B41CCCCC83C9F6BC202BB04A305CD281498146EBE19C7FFEF9CD0E5F
          B3A722B435C1103C2F547F7A7EB85C5628D4832EC144BEB804F14DC276F41577
          62545111AB87A762107C836F024ABA26A63828F104D930F358E694FC78F23B19
          4AE31AF8FA5D6418A296EB97233C633F8059BF1C68E16D081C310DDE2E47E45D
          55A72F46A310B5D5E5163241C9CD1C8CCC41A7F961984342B3884B445859658D
          F38A383B3A930053A70DD0B9CC2437FA149C00C98A77F56C0463B422A0060E4A
          AAC06C24EDC43925395011522D711E562EF92B7A6BFA6A7D9DEA57CA15BA0413
          9E7D12E4DAC5AA23B72DA0A4FC6F50ED669DA164098BEBF9891441181222089E
          BCCED97A376D40E8DD81AA635889562370E003F0F6FA45DEE53A4D30748E7220
          64FA5FE847A07392268F1D506AD34CD15B848A11162A1C26C931E26375294BA3
          AC5E9A49BCF372A9483E6EC5CC616C07AFBCF28AAA8AB2110C61F6E034ABABF2
          3B714EA9DE3495C4443FAA2BBB30BA39684F84CC67FA05A14B30A1F7F74F8461
          3DF93CDE2337A8D5096F4F46AFF4C84352558514EC22C446A3B8ED864D56A213
          178047508C3F7D56B422D48BAFFF25F00FFD93E3F50FFFEB10C8A12D42FC8801
          BCD764F807DF9877994E120CB35E69B664865BB5C7B3EA25856503950A49446F
          BE0EC1443466075B59384A83D15C275E1F7CB1AECC81C946065641938CF3AFAC
          100CC3BE34A9F4963E207153B9B02C3338714EB9721F951743FACCDEE59329ED
          82D9DCCCD7C9CC87CA65D94D3DE8124CD3346D65B73648F70FFF80D27175A69B
          30CFA4E9D52EF0763F1E25C7982FF2145DF257C4BEBD1D087468E6182526D4C5
          BEB7C0B7F7D5CE577FE6F190EB968A111B866FA020B161F93B209D2418BDD5E3
          7809D0DCE0DC995C67D7D2D94A05A417FED4CB13C90666EDFEF6B7BFD5CDEAD5
          42D6CCF130EA17BB60789CEBA55821189A0E9CFBA46792585DAAD289739AFA18
          199E3F9A3376E62111469131AB44990DFA04F34A47287ECADD62138C305DA2B5
          28FDF90EF3CD84826978CE075FBFF35032FC19D34D636B5F43E4D3F381929464
          30A1CE02C37EEF38C1284D55687AAB5FE258B106A1927E89C00177E65DAE5304
          439B9D2BAA65AA17E6BD505EE7BA960A3165CA14F562359A9DCDC43EA3EC5DB3
          76EB65BBD25744554485E31468BEB18E24352BAA882A90A1DED4C435AA40DEF9
          AD3C53C88973CAB03A4D4FAA3CABD9D79960CE11CDC34C3546338FEAE6D0430F
          CDAB5FF509E6C5722881CE96A77E3B0556458A56A3F4AC5AF3ED843A687C3E08
          5FDFF12839E205D36D636B5E4464DE446152B5ACEBA28405C1EC7F9B20982BD3
          B695EB5741DE3C5BF48A9F32499D1A9070FA8A971C4DBC9468E27BF51549FE2E
          64FBD6CF10DBF6B9EA7F61B729514130032E44E040EB776D23387131B26FB980
          369DAE998F18E56C61E670E4039A5E8C4C319A9479DC6CEBB918814E61969B99
          D5EBC4131633619760F4163FA7D9C62892B62CA6199C38A7A9C99276D30B3470
          6D1EE62BA51225499260B265BED02798E74BC55D98174AB113E94455228260CE
          CE622291609E1504D34F10CC915908669520984F2F8094A2601446780EBA1BBE
          BD2E4FDB36BEF23984669D2B4822986C7BB2FD9294FE7773083BE5774F20CD29
          4E3F8F7FC044F80FBA37EF5EC9F762E49D954B5272A06A260CF31C28F519E131
          7B4C891DD00CA2824995E93C0ED729C9C5196B94D59B9A5FE314B87C041FA1CB
          A902668980A9C8CC25E2B9609429DBEA7284130493BA2AA1D515F652C109995C
          2C2B75AA87F6103E666033B5205FE8124CC3F382957D156DB0E4428260CACF69
          30DF4C0EA3FEE920FCFDC7A1E468F344A0D8CA17109E3B0108A698488260FC87
          DC8FC05EE95EF7D8DA37109E3D4E6CDB0D794FDAA42379E0C52839B86D150CF3
          4E384B984E40920B073CE5341DB2CC8ACD96F4660794E8F49DA43A66E9DCE552
          9456076D2A584FAE9B92EAEB309AA99D2FB4E7165135310C6D05543B5C6797ED
          65BF72A05A9D74E904C130E990532534F541938D51252A192BD0C2E85A42A3A6
          36ADF8A1AC429F605E4A3C3DC0CA2A764E429D7E2008A6ECDC46F30D49304F09
          8219608160560982F9E47CA160B439435CBF662B02873E04FFA0F40591626BA6
          21FCD11942C17447BE04A3448582D9E7326122597F56732AE8B4E3C5C3F478AA
          0CA3BBA2DEC5C8E7ED70362D7D22B4A5E9C0A3CF82129ED3F029ADF55687CB17
          F43D30CF8564A6812A89B3907325B2CCC5C9D90ECE8FE18259B9826A8A6164DE
          A96982D1E462FFD20FC1E44092225509E73771ED5AFAAC98849709F63B2767B2
          6D244346BE5297C5D4401F141517DF79BEF8E2B0335A4A818A93BFF326401262
          7F52AD64FACE48309C38AADD3CAC3A66498ABC06A87C34F39326161510F377F8
          4C70A7A06F22BDBE37E4D0562160AC3FB9CE09A80413DE81B20961F30D858954
          FF2409E64C941CF38AE9A63161F684E79C9FF4C1248F2308A664F814A13026A6
          6FBBF64D84678E7188606AE11F723D0207DC6A6B3F3AEDB88892B696075FD924
          372F584293EADC87171CEF6CFC8EF9228C7AD001E854D4C5081CFCDA40E040E1
          DD3D9F07A9D3446262A0E684E4E0A7BF888978B982FE1B4EBE64DDD85746BE46
          6DA12B9A1224073D708638498F044362D7038FC56537E99FD296C9CC16EDA123
          5B7B71E0CF983143F5A1658251242E0D415F1AFB4823273A67FBF5EBD7BC562F
          B38C49A62417D657F31D9158D836E6F69004AD987776A04F30EF8E80BCFD6B71
          A5DA5B152B6FB02AD11A945F10CABA69DD14499838E35132229B0FE65584668D
          130493A260429B113C6A2A7C03D265606CDDBB08CD38195259FE26121DC9C123
          9F10C738D7D67EBC9899B8A6B7D66D3670A0703F862D79F7A3EFC3C9D5C9AC80
          791924015ED4741672AD967CD412C9939329B5FEE05D9ACB40E825F55905072D
          FBCA6A10436F06752AD4E04496B2784CBB21643BFB32F580644313955319B461
          ADB5532335DE78F81B8985D7087D305442569E279E0BF413ED669F8FD8EAD7DB
          66AA40E807949FBD2E11EA55A2AD7FF79440D9BE000DAF1F026FD7FD5136F6AB
          44C29D1E21F8CA1199FF1B44973E0AA4CEAB12C7081EFDAC18FCE97E81D8FAE9
          084D1F0594D97892800114A100CB46CF86B79BF3A6880B17D94062A662A1B2A1
          7A214931DAC4290E5C9FC60907AE15E8124C74E17D087FFE3B4881F6B9949917
          180256848AF19476134C1B6F5D618F60E0868D40B093D077D5904A3A4061C6B1
          0E1F481E2F94BA4D8230BAA4C4C3848269120473EC0BF0F54F5F3737B6610642
          EF9C28140CD93C3F82911BB7A26282303383CE39515DB8D8D9A03F9B7AE32C31
          D07ED60683431177FEEDA898947D70D73D2C0905321AA527BE63BA5D6CF95461
          225D90D616A5711B82235F81AF6FFAAAF9F10DFF46D3DBC70B82C9B7DD329448
          0D2A2E8AE7598E0B173B377409468935A16E4A19A4F2EC2B9A390AD507538DCA
          6C04234750FB5009FCFB8C45E909AF9B6E1A5DFE1C4233CF4D281ECD07D3B81D
          6527BD260826FD816BB18D1FA1F18D6344BBB56D73443C024FFBFE283FF3EBE2
          F69F0B173F32182E9959FF546775BD94624E78E42C67446A51F9AB2C833B1E46
          ED8341F8F73E15A527994FC68A2E7B06A10F260855D2123A551AAA513AFA0D41
          3063D28BDD381B0DAF8D80A722DB73A0B2B4235287C0D02B5032FC6F45EB3B17
          2E7E8C302498D0BFC621BAEA0D484574F42656E4AF43E565D9082684DAFB4BE1
          1F7C8A2098B74C375509660609468B3A50C1D4A0F4E4698260D27316E2559FA0
          E1E523E129B7F14C6A1DC84DB5281F3B13DE3DAC2FDAE4C2C5FF220C0926BAF2
          7534BD7B06A4601157B5635522F5A8FC757682A9B92F413065A3B310CCD2A968
          9A71419260922652432DCAC6BC055F9FF484A278D57C34BC78983091B46D736A
          8420B07AB4BB6AE77D7C8B19A65F2261DA1805534ECABF2C62C5038763E0E479
          C0A4F7A01815BAE2011C3E7032E6996DB32B23D93F43DE333E2F3C6FB70D5E8E
          B957E5B788B75D983ED9B1E63E490CB6B2E23D575A5D0BA611EDAECCE68309A3
          FA9E200243460B823177F292601ADF27C168B37C4930F5283FFD1DF87A8F4EDB
          36BEF973D43F7728A48A3C9EEF140BC1B7FB4F5076467E4B0D5AC6F44B208D7A
          4C7C188EFB97CF4561AF9FE9B8441A85C71C3B56B2BCE1F763F9DCAB60545C82
          845084F6150F1CF0EA69D385BDFE4D9465B68F76DEC8E3CEDD1CACC094601A5E
          3914F12D5F40F2DA4FFACA050913A929FBDD3F1646CDBD41F8F71504734A3682
          791A4DEF5D9824988482911B1A50FEF3F7E0EB95DED3F12D5FA2FE9983E1A9D0
          B6B50F39D488B2939E817F2F67E67298A3E5C22186DF5F843B94836AA259BD98
          60121FFB31AAA58D061B19D6C5EC18ECAF9B170F3419E8ADB7CFDEBFE9E72497
          3ADBEC44F57C205BDDB4F39685CC9D8629C1C496BF8C86B7CF82A7B4480FB1E7
          DAB79130DA4DCE3EB86BFE22C1BFFF58948D328F22C556BC8CC669670925D6D2
          06A5BE096567BD2F086664DAB6F1AD0B50FFE401F054E6D85E517FB9318CF6D7
          16C33C5A81070E1F88C9F31277AE41F724EE88F9DEA1CCEFACD6917530A65DF0
          83708F1894D0A9BB5A9F458941B19C9F91EBC04CF617D207586AF989EF920491
          4A005607B1E5BE9D249A3A05F9D38B760DA494D7AC68EDA150CAC6946088EA7B
          859914E49CA4224D7C0C855176DA8BF0B4EB9B587725B3C2DE00621B3F45D307
          57C2DBAEB3304566AA6BAFE8362E5089D0ECAB115B37B365DA03D76AA90FA3E2
          1733E1EB99EE8495B72D44EDE3C3205596E4266084B2F2F73F55A8AAFC9619CC
          8E7472495CF37ADFD947EB0157086877F9E4C0982EFE9E26FE4E91F9897A4CC2
          FD431661F198B9E2E25F21C6F93D428D3C96E3DDBF6D09A6995C0CEBCEFA4D00
          A6DA387749323127076B6668A190956042B32E43F8BF8F8AC15A8C05C0692409
          22132A4089196FC587494AC112285CFCA95E362503892E245F7ADDE5FA082ACE
          9B05DF9E23D2BFDFB618B553F6150A26B7B6CA7511545EFA1DBC1D0715B08F32
          0667DA6FF9938C19C164B7F5AD2161B60C6955FFE9CD0A65A0F83C411C6B5E2B
          25A43A2B45FD6E16F5B347316D453016CE89A6E6F8D93279B6268ED66D313836
          89E9B6C145219CAC04837814D57704C45DDD5BF415EE0A05B92E868A0BE6C0B7
          47FA3C21B97A196A1FDE4BA827FBB93F4A3C066FFBBEA898B8B27015B768476B
          77CB5C64AF21C1143D92A34F084E9767C724B4EDE3B2D067CD3E225B0A438738
          34D328A51CADECCCEB40FBBE183EBBEC0423D0F8F6E9882E7D0392FF7FE101F7
          82486AE3A8B8E813F87A1C9EF67D7CC732D491602AEDB753AE8BA3F2A24FE1ED
          FED382D4591B08562F0A4BE15FA3E39060A60213B4BBAA4D64AFA336401CE818
          CB03B3B80AC68A033BD9809C14A13E31B6F6C5E89F8B96FE2F7454C912C1D017
          52FD67BF5031285EC8BA90882808EC7F11CA463E9EF67568EE2D08CDB90D08DA
          6C634C1166511F4130AB9CAFABCE9DC9C6CEB6C393BA0AC692AD6F074EA813BB
          65148F6032C925BDDF5A06B7330A42872CB46BC6ECE6D2EC0C76CAE1AC0F4B04
          4334CDBC1CA1F98F70B58482C3E9188CA4F3855C0B949FF13802C32E52BF8AAE
          9886BA67C60A33C77E05E2354087EB56AA8E692791E9F3B017E1D191CF16D48C
          E1801BAE63DBE74C1045241893A80A07E49869C58B2219DD2CF24A826BA5542C
          86C953514007B0658221AA6F172333E0CC52BD994755D7CD86FA9C3478C507AF
          94F8EC9132D6DCD61E21DDAAC096EF59765CBC64F18AC98977BE948CE32A0DA2
          B89244994A93385625D21F4F6DA51D61A819C5E563DEB2BE538EB01AE1C92731
          2DF318FA8E5DE7FC23D64D090DB93A99DBC00793E5D8DA6F9A43DBBE9AC8761E
          92BF0FD1C832F3EF24B9E13D4C157FB739C144574D47FD53A3E0B1B94C8CD2FC
          5F822C481E3E412225DE2459895738EA419D5C8EADF51ED4842554453AA2B6BA
          5A7C57215EA5680829EADAAC9148489084248AF332654E2DD82B58C85F528A60
          C0878A808C4A54A3A2D48B2EED4AD0C5B3051DDA55A08B6F07827EB19D878F1F
          1104245EE138572B4B928F2751473B1620E76642104C879B8B332DA0F80493C3
          DD10F606A25144C9E976B559144955188BB2D7394569D9F3B399F55D665B5A13
          4CA1618B608886978E41F4FB8F12777E1368A55281F8C5E00DFA12641256FCD8
          DC588E95D57E2CDFE6C3DABA4A6CAF8F0852F121160D73555EB18F2CF651E011
          3B7BD4C0B5D2AC62240379A13E5234795C3E795A49AA9798E24DD445FC57515E
          860A6F13BA77F0A24FC71806B4AF47DFF621740A4620C971C404D984E209F5A3
          A410A21164611A554E9C015F9F131C3919CB962DC3A041C6216EAB04937B38D9
          AA32715AC1B41DC1E8F45E6B82C9AD612DA1E75C90CD6C312A3FADDE89B62C6A
          26AC9D806088EA3B13F68C94126CD1548AA650CAFC6213F17B4D3888EF6ACAF1
          D5C6327CB73D20148A8450380406A44ABC427D484AB31924E9394BF2427AD3E4
          2471244C2709E19884B86848A560BF3D3B0243BA8670C0EE8DE8DDAE1E7EC410
          8926558E0ED9C82151FFA167A2ECD4576CD4273F5823980C9F897A21BE8C7196
          06A5D50BF07FC74432ECBF3C08C6FC3C65AF8725B3C58A93B6D524C89D8460E4
          BA0DA8B97B4F48495389E38E264F79400C60310ABFAF6B8F8FD7966341551055
          B5323C4A54281825A14AD288A42D23522DCD567D345C8A26EE4193209D60895F
          281CE0B05E4D3864F71A74296D442C02F15B926CE25C1A388876939B8A5A63DD
          0B57F74ED6DAC16B2D029479C733C2FF8882B1AB32727086B69E7D9E598FC4DF
          2F8F2B404E4A2BF34C8F6012E71C6D3555C008D125CFA1F1A57351D9590C3661
          FE7CB7A323DE5F5181059B02A80F4551E18F0B95A2A86A26C1233B43783BF968
          5925E1A309C53C08C93E746FEFC5517D4238A657353A973420227825704DF197
          63C8258DDFD6A04CB9E35DB7CCAEB24887737E04A79032B06F5E8C818639220E
          9948A9B93E69656510CC8AE998FEEE348C9A9C7F2A42022D8AC630B377889919
          E52C722618223CE73ABCF4ECE398B3B12B6A1B22A808C454D3C7F3A350284E20
          117AA26A090965D314F7A36F653DC64CBC19C34FBBAAE8B5C98560ECEC637DB0
          B7A58994444E99AF56F67580609A9591C9748E567D6767298CD4F6189848BACA
          5587602CAC25930F72229835CBBFC1B30F5E8B2FBFF81C951515AAF993786C8B
          3542491C5249BC2B89A5325527ADA27DA724966E483A6EB581DEFC39B50129CF
          879692EF893729F9F224A638687FA3E5B33D242A1013AFA6863AD171318C1E7F
          35C65DFA27D1F6E26438DB36116C453FECD8E76D632269B0439AF6A74DE44730
          D933A8CDFB2E9F691E29953098A2A0736CAB51AE1C618B60967EF5319EB8FB72
          ACFD7E212ADA75462050D26CFE24C8411085FA34BA78F2253EF349737C577F4B
          7C47044A82E25526CA08A2A4AC02A5E595282B6F97F8AEB40C25E2DDC727137A
          F894423F3C5E1FFC7C6894389657FC1D8F455592884622E23B1931F11E8FC744
          F93144C221849B8429136A4448BC3735D48A570DA2E2FB48248CB0F89E8F4491
          A4C453F6A4E443A948143C9EC7E34DF9DBA34B466C47B8A91E4D8DF51871CA04
          4CFCED23A2CE855ED6C27E8ABDE590B1AD0B6DE72118F3F6E6B02E8599FA31F0
          77B55669E62A251F5F535682D3F33B15707E99258259F7FDB778E0A6F158B772
          11CA2B3AA8834E1DCCB1984A24FC4C94B7EB88CAF65DD0B57B2F74DEAD272A3B
          76C56EDDFBA243976EE2FBCEE8D07977B4EBB81B8265956D3E7132126E425DF5
          36546FAF42EDF6CD68A8ADC6964DABB0FD878DD8F1C3066CAB5A9FF8AD7AAB20
          C918BC82E03CEAA35CFDCD9F497A6C0709ABB1AE1AC78D9D848B6F9CD2A6EDCA
          15D36DADB5B2B39948BB069C9AEDEE244C0986A6C01D579D84CF3F9A2B148B20
          90CA0A411E7DD0A3F72074EB3910BD070E45A7DD7A89CF03D0B14BF7B66E4BC1
          D0585F8B4D6BBEC396AAD558B7621136ADFD4EFCBD0C3F6C5A83FADAED426905
          54C2894523E215C785D7DE8751675FDDD6D5DE29D0660AC64551604830FF99FD
          2666BE3E05FB0D1F89FE837F825E038622585AD1D6F5FDD181C9816B577CAB92
          CEF245F3B17AD9022C5DF0B130AF7CF8F3137345DF1DD2D65574E1A2CD905714
          C985311AEB6BF0C59CB770F0D1A7A9BE25172E7645B804E3C2858B82C1251817
          2E5C140C2EC1B870E1A2607009C6850B1705834B302E5CB828185C8271E1C245
          C1E0128C0B172E0A86FF07619A039794FE51530000000049454E44AE426082}
      end
      object Button1: TButton
        AlignWithMargins = True
        Left = 30
        Top = 391
        Width = 296
        Height = 40
        Hint = '{"type":"success","dwattr":"tabindex='#39'6'#39'"}'
        Margins.Left = 30
        Margins.Top = 0
        Margins.Right = 30
        Margins.Bottom = 10
        Align = alTop
        Caption = #27880#20876
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = Button1Click
      end
      object Edit_NewPsd: TEdit
        AlignWithMargins = True
        Left = 30
        Top = 176
        Width = 296
        Height = 39
        Hint = 
          '{"prefix-icon":"el-icon-lock","placeholder":"'#35831#36755#20837#30331#24405#23494#30721'","dwattr":"' +
          'tabindex='#39'3'#39'"}'
        Margins.Left = 30
        Margins.Top = 0
        Margins.Right = 30
        Margins.Bottom = 16
        Align = alTop
        AutoSize = False
        Color = clWhite
        PasswordChar = '*'
        TabOrder = 1
      end
      object Edit_NewUser: TEdit
        AlignWithMargins = True
        Left = 30
        Top = 121
        Width = 296
        Height = 39
        Hint = 
          '{"prefix-icon":"el-icon-user","placeholder":"'#35831#36755#20837#29992#25143#21517'","dwattr":"t' +
          'abindex='#39'1'#39'"}'
        Margins.Left = 30
        Margins.Top = 15
        Margins.Right = 30
        Margins.Bottom = 16
        Align = alTop
        AutoSize = False
        Color = clWhite
        TabOrder = 2
      end
      object Panel20: TPanel
        AlignWithMargins = True
        Left = 30
        Top = 286
        Width = 296
        Height = 45
        Hint = '{"radius":"4px","dwstyle":"border:solid 1px rgb(220,223,230);"}'
        Margins.Left = 30
        Margins.Top = 0
        Margins.Right = 30
        Margins.Bottom = 16
        Align = alTop
        BevelKind = bkSoft
        BevelOuter = bvNone
        Caption = 'Panel_User'
        Color = clWhite
        ParentBackground = False
        TabOrder = 3
        object Label_RegCaptcha: TLabel
          Left = 192
          Top = 0
          Width = 100
          Height = 41
          HelpType = htKeyword
          HelpKeyword = 'captcha'
          Align = alRight
          AutoSize = False
          Caption = 'Label_Captcha'
        end
        object Edit_RegCaptcha: TEdit
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 182
          Height = 33
          Hint = 
            '{"prefix-icon":"el-icon-circle-check","placeholder":"'#35831#36755#20837#39564#35777#30721'","dw' +
            'attr":"tabindex='#39'5'#39'"}'
          Margins.Left = 0
          Margins.Bottom = 5
          Align = alClient
          AutoSize = False
          BorderStyle = bsNone
          TabOrder = 0
        end
        object Panel24: TPanel
          AlignWithMargins = True
          Left = 188
          Top = 4
          Width = 1
          Height = 34
          Margins.Top = 4
          Align = alRight
          Color = 15130588
          ParentBackground = False
          TabOrder = 1
        end
      end
      object Edit_NewPsdConfirm: TEdit
        AlignWithMargins = True
        Left = 30
        Top = 231
        Width = 296
        Height = 39
        Hint = 
          '{"prefix-icon":"el-icon-lock","placeholder":"'#35831#20877#27425#36755#20837#23494#30721'","dwattr":"' +
          'tabindex='#39'4'#39'"}'
        Margins.Left = 30
        Margins.Top = 0
        Margins.Right = 30
        Margins.Bottom = 16
        Align = alTop
        AutoSize = False
        Color = clWhite
        PasswordChar = '*'
        TabOrder = 4
      end
      object Panel19: TPanel
        AlignWithMargins = True
        Left = 30
        Top = 347
        Width = 296
        Height = 28
        Margins.Left = 30
        Margins.Top = 0
        Margins.Right = 30
        Margins.Bottom = 16
        Align = alTop
        BevelKind = bkSoft
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 5
        object Label_ToLogin: TLabel
          AlignWithMargins = True
          Left = 184
          Top = 3
          Width = 105
          Height = 18
          Align = alRight
          Alignment = taRightJustify
          Caption = #24050#27880#20876#65292#21435#30331#24405
          Font.Charset = ANSI_CHARSET
          Font.Color = clHotLight
          Font.Height = -15
          Font.Name = #24494#36719#38597#40657
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          OnClick = Label_ToLoginClick
          ExplicitHeight = 20
        end
      end
    end
    object Panel_Login: TPanel
      Left = 20
      Top = 30
      Width = 360
      Height = 525
      Hint = '{"radius":"5px"}'
      Anchors = [akTop]
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object Image_Logo: TImage
        AlignWithMargins = True
        Left = 10
        Top = 3
        Width = 336
        Height = 166
        Hint = '{"src":"media/images/dwms/dwms1.png"}'
        Margins.Left = 10
        Margins.Right = 10
        Align = alTop
        Center = True
        Picture.Data = {
          0954506E67496D61676589504E470D0A1A0A0000000D49484452000001180000
          005A08060000006369495F000000017352474200AECE1CE90000000467414D41
          0000B18F0BFC6105000000097048597300000EC400000EC401952B0E1B00002F
          AA4944415478DAED5D079C14D5FDFFCEB6DB6B7414507A5111B0C7880D6341C1
          026A1063418962D4A81835C69AA6B1C6D8FE1A34168CBD624562104141341A51
          1010905E0EA45CBFAD33FFF79DDDB9DBDD9B999DD99DDD9330DF0FCBEEEDCEBC
          79EFCDBCEF7C7FE5BD911401B870E1C2450120B904E3C2858B42C12518172E5C
          140C2EC1B870E1A2607009C6850B1705834B302E5CB828185C8271E1C245C1B0
          13104C5CFC5B0A28EBC56B0B20EF10DF8592BF79440BCAC5AB93F8D84DBCF715
          EFBDDABAC22E5CB848E2C74730B17F03D1B7C56B962096858250584B9B65782A
          00EFC1807FA4789D2C3E0F69EB56B970B14BA2ED0946090B41F228107E5C90CA
          E264ADB4DAF9A0AA145B0CC3E6C4C49BDCF227770F08B2095E21DE47B769735D
          B8D895D0760413791F4AC3CD8254BE4CD6C42BFE0B88770B64A2928792DCC702
          146166219C201BA2F47C6159DD2EB86BCF3669BA0B17BB0A8A4E304AD3142875
          570BD3A7491CDD2F5E25B0A5509486E487A078358A5D2BD12253AC40909322F6
          931571E803C4EEFF1066D481C5EC02172E7619148D6094A6A9506A2E161FA242
          A45458571F2D551542A41A52E010485D3E4F9459733994FA478425D51109678D
          CD3AD13C9343A2CC61903ABE0978FB14A32B5CB8D86550788289AD84B2ED18C1
          2B6B21794804768945ADA6B08A7E1066CDB98208FE99F68B52FF30941D5708BE
          EA927315159A4F729D28FF2C51FE8B05ED0E172E7625149460941D570973E841
          40108B2405722F27B65914711BD0EE26FD0D421F42DE7CAC50325D91700AE778
          1CA54E753A7BBABC05948E2A54B7B870B1CBA03004235743D93858A80E61D248
          1DEC8799352824974DF0ECFE2A507646CAF79144C429B07FCB77B17590D7F712
          02A9AB38A61F2D1E5DBBC7948529B659A899F190BABEE078D7B870B12BC17982
          699C26D4C458610E754B3871738618E8D10DF0F4FC5A10C9B096AF238B216FD8
          4FFC1C134AE36F40FBC92DBF89A6286B3A25FC3B52597EED906B05599543DA73
          65D211EDC2C5CE8768348AC58B1763E3C68DA8A9A9412C1683DFEF47A74E9DD0
          AB572FECB5D75E053DBEA304A36CBF05F2F63B001FC3BFB9CA16A80A4552B643
          EA239484A75D4AF97740DE7623E0EF0DD5148AAF83547A1C3C3DA6A7ED2EAF1D
          2A94CF7AD534CB59C924EBC1CC61CF9EF305C70CCBBD9C9D148F3EFA28CACBCB
          73DAB7B1B11113274E44201070A44C0E94BDF7DE1B871F7E78F3779B366DC2DB
          6FBF8D60309875FFA6A626FCFCE73F5707D6F7DF7F8F0F3FFC102525D66E1CB2
          2CA37DFBF6183B76AC23FDFAC30F3FE08D37DEB0546F22140AE1E4934F468F1E
          3D2C6D5F555585679E7906EFBDF71EB66FDFDE7C0E482E6C0B5F842449E0F01F
          3468905AFEB9E79EDBEA7CE50BC70846D97C01E4BAD78578D82DBF72E406D55F
          E3E9B726ED7B79DD1150C20B44F9DDD1421AECA05AF1BF5F6CBF0EA9A4266F38
          154AE32C48BE6EC88B64A8A40459797A4C136653E1FD32B367CF562F645ED01A
          2A2A2A4CF7A9AFAF6FFEECF3F9D4ED3B76EC883DF7DC137DFAF4C17EFBED879F
          FEF4A7D8638F3D6CD5856574EBD60D1E8F472505AFD7D841CF8B97A4128FC7D5
          0B78F3E6CD58BD7AB55A46734F8AEF3B74E8D05C26CB2B2D2D55EFA89920A190
          14B80FCB6C6868C039E79C83BBEFBEBB799B4F3EF944EDABDD76DB4D2D832FB6
          5F03F78B44226A59AC0FFB76DF7DF7C56BAFBD865FFDEA576ADD580FBE38B058
          1723901456AC58E1C839BEEBAEBBF0FCF3CFA3ACCC5865D7D5D5A9F5E78B24C1
          3A1F7DF4D1A6E5B29D6CD7679F7DA65E3F24500E6F2A17B6F5B0C30E53AF099E
          4BF6E792254B306FDE3CF5EF70388CDADA5A1C77DC71B8FDF6DBB35E7356E108
          C1C81BCE84D230470CFE4E7995A308B520F9FBC3D3675ECB77E1A550561F0AC5
          DB5E108FFE095118FA8E6F84D46FA1D87F40CBF79B7F2B04C8C3E2BB7CE72709
          D32BB6169EEECF426A77469E65998352F69D77DE69BEBBF144DF73CF3D86279C
          E472DD75D7A9EF3C957C5FB972253EFEF863F5CEA75DC4FCCC327EF18B5FE092
          4B2E31250B0DEBD6AD5307E68E1D3BF0F7BFFF5DBDD05307B006924BEFDEBD31
          61C20474EEDC592532BE1B81E56CD8B0417D7FE18517B074E9D2349221291C70
          C00138EDB4D3D481B1FBEEBBABA424E92461B26E9F7FFE39BEFCF24BF59D8389
          6D637B39C8860F1F8E430E39043FF9C94F54724BC5D6AD5BD5BBFDB66DDBF0C5
          175FA8AAC2886438E0AFB8E20A95E4F205EB525959A9129BD1B1FEF8C73FAA6A
          8B7D6945B9B0FE5AFF6BCA8C7DC0EBE8A1871E52D59F1EE6CF9FAFB68B7DC3EB
          8744B37EFD7A957CAC2A2C33E44D30F2FAF304B9CC14E4D2218F5284128956C1
          53311252CFE79BBF55B6DE0779CB0DC224EA272E2E9E0CE3AAAAAD88AE80A7D7
          BB902A8E6FF97EC7E390375D0129D03FB1515E0EE775C25C7A09526571234C43
          870E5507981E3840162E5CA8FBDBA2458BF0A73FFD49251C5E405403BCE83808
          493437DD7413AC62EAD4A92AC9E8111DEFB22488193366D86EDB983163D4FAA4
          1217EFC403060CC03FFEF10FDBE51D73CC312AE10D1B360CFFF77FFF67793FF6
          214DBA4C12D2C0323970DF7FFF7DDB754A0549F0D24B2F55C9C30866E7540FDF
          7CF30DC68D1BA79291465AEC43920D954F36F0FA22896B04BE65CB167CFDF5D7
          79B553435E04A36CBA0E72F5F3825C3AE75A0412E4B2069E2E9321EDFE87E66F
          E5552740691226912FD524B250A7E84AA1341E84D46962CB77F573447982144A
          FA8AA3E5E11BA292890A73A9DF6C48A5C5F3C9E44A301AA812287B3515C0534E
          738617216DF57DF6D9276B1D789C134F3C115DBB76D5FD9D4AE7D34F3FB5E55F
          21D9515D64B68DF5637976061941454289CF3BEFF5D75F6FCB67F29FFFFC0797
          5D76994AA07A2A8DA099346DDA34D5ECCC1593274FC67FFFFB5F9508F44C43AD
          AFEDB47DFFFDF757C9442317F61FEB4A5567D496544C9A3409DF7DF75DB3FFC5
          EEF1CD9033C128DB9F12A6D18DC2FCE896CBEEDAE1A1445609554042382F516E
          7805941523A04815903C94F776ABC73257C3D3ED0648BB5DD7F2B5200679E981
          507C64EAEC9D6E0CFA647E8077F0B2C4ACED22205F8221E87FB8FCF2CBD34C0D
          2A0FEE7FE79D77E2D4534FCD5AC651471DA55EB07AE615EDF7DFFFFEF71835CA
          BABAA383F6B6DB6E43BB76ED5AFD565D5DAD4A7BFA8EAC82776B9A93244FFA21
          CC7C2A99E0F65416ECEB356BD6E80E7EFA8448B237DF7CB3E57233C1F269BAD1
          4C22D1E81DC7CE00FFCB5FFEA29AD4A9C44E1373F0E0C1AA43DD0A5E7FFD75D5
          B745B38D744093F1ABAFBECAB98DA9C8896094D012C8CB4608D3A5671E87166A
          20BC06DE016F0A9326111950B63C2CCC993F0001FA4C724F9853ED2086B83B4F
          84B4C76D29879411FF76B0285A108C94877DA944D537EF6067646436384130C4
          C30F3F8C7FFEF39F69039AA79F7E9FFBEFBF1F279C7082E9FE5441D3A74FD71D
          B85423471C7104EEB8E30ECBEDBAEAAAABD40B592F9A439238E59453F0BBDFFD
          CE7279540754221C28764D1912CC85175EA80E34BE38F0337D243431E9F32131
          E48237DF7C137FF8C31F70ECB1C7A24B972E6A9447AFED76CE291DF85495A9FE
          293A70CF3BEF3C9530AD804A963EAFEEDDBBAB6DE4DF73E6CCC9A98D99C88960
          E2DFEC0DC55399C37CA2249498306AABE0DD77BE50408919CDF165A70993E81B
          40280CC740BF4E97B38442BA2BEDEBD89211E2B72D8221DAE5562E2137C0537E
          A83097ECFB09ECC2298221468E1CA9DEE152A5332F013A5D3FFAE823D5163702
          FD073423522343CDDD212E4CDEE11995B00A5ED494F67ACE5BAA2B0EF07FFFFB
          DF96CB3BF8E0835562183F7EBC4A5E7640F38E3E18467818FD7AE9A59774A33C
          54562420FA7AEC827E92E5CB97E3C9279F54CD563A58F321183A62195ACEF4E7
          D0D1CF68129DBE564173926D23A886A88A9C806D82892F3F4710C11261BEE4A2
          0038A728240E1A8667D837AAE356097D0F79C94950BC348978677432EF8FFE9D
          CDF0741A0B4FEF7BD2DBB1620294DA4F2105BAE67C4C459094B7CF03903A1676
          8D192709860470E59557B622092D4782A69419E83C6558588F1468F77FF0C107
          867E9A5430F98B7759D6433258A2837E18D6D74AC874EDDAB56AD489A44487F4
          9021F61619E3712EBAE822DC7AEBADAA19C49030DB99099273FFFEFD5592B003
          46861826260152B591A8BFFDF65BDDBC13ABE7F4ADB7DE525565A68949F577FA
          E9A7E39A6BAEB15C3F3AD49F78E20995F078ADBDF8A23373F26C118CB26306E2
          2BAF16AA23FB05A4BB7FBC569DF9EC1DFA61E2EFAAC7105F274C9892DE820AF2
          3189B21C9724D3790C3C7DEE4CFB5E5EF747C855CF402AC96D5D180532A4D876
          780FFCB66075279C241882A60C2FA44C138077B06BAFBD16679D7596E1BE94DD
          1C187A775E0E2286CCCF38237B289FFE15E682F06EC94B502F644BBF0E235D56
          FC43CF3EFBAC6A0232CC9A8BFF8039357476DE70C30D2AF18D1E3D5A1DA8994E
          52D6957DCE63183969F5C008DC638F3DA626B431B24732A39AC9876068EE3EF2
          C823AD0898370B920E4D32ABA0994CBF10CBE24DE4E5975FB6DD877AB04530F1
          2FC45DC1C70430BB644025B11552C501F0EEF35CA2ACC5E3A0347C2DC88A92BC
          D02B4624954CD73305C9DC9EF68BB2F919C457DF0429D83719EBB607456E82A7
          F22078064E2958ED9D2698071E7840BD80324D009A251CA073E7CE35DC975114
          FA59F41CB3DC97660FCBCF060E342A947BEFBD5725353A3E33950CCB3BF0C003
          55FF503630B787A155AA84BFFDED6FB6FB9879432C432318F6CF7DF7DDA7FA73
          3241138404F1CB5FFED272F9544424709A5ECC49A1F962E44CB67A4E49D00F3E
          F8A06E1D1951A3196694FF522C582698F8AA5BA16C7B5B9D9F63F310E24AD998
          18DCFDEF1226D15AC4178E141C559678159C5C52EA11A982D4ED3C787BDF9AF6
          8B52F30962DF8E1724D3DBDA8A7A1950C29BE01FF62E50569893E934C1303FE6
          820B2ED0F5A530F98DF92346D11BA3D03241138B392D4CFA3203EFB024225E7A
          AC0B9DABCCD5C9BC9BF3773A55196ECD06866AB93F2359541F7641D390EA4C23
          188266965E821F8998E074032BA0AF847E2192A8E63C651E1255433E0443FFD4
          8D37DE9896F59D5A479E2B3B3EB142C01AC1C4EB10FD7C3F20C08BCAEA004CAE
          32175A036FDF5BE1E93109F2466112ADFEA33089F28D12E5014106DE3D2E85A7
          F775E9DF87D623FAD511001595DD3036338985E9E7DBDF7EA29915384D305A99
          A9C955CDDD202E4ADE6D193E368291F940F0CE4969CE89744678F7DD7771CB2D
          B7A8A1549A36667762864CE90FE07C19233087830396FE119A2E56723F324107
          37FD22A9046316E5623B592F2B9305497A0CC9D304A3F39538F3CC33D5B6E9D5
          D5EA392541312DC0C8E74522A7DAA229D5564AC612C1C4BFBB1C72F53C5B8E5D
          B5D0D02A7887BC084FC711887D730694BA059002F9CD5572A0C942716C80B7CF
          F5F0EC795946A5E3887E36540D614B1E7B33A895287363A6C2D3E1705BFB5941
          210886D124862333735AB46C5F333389763F89412FA98E1734F36D18DD30029D
          8FB366CD52DF997A4FD38139367A112C865CA9702EBEF862C3F2E8A0A47F8361
          563B7E8754508DFCFAD7BF4E231886A3795CBDAC5B46CC468C18614AC41AA8D6
          D8D78C546924AA97C1ACC1CE39A5494853D768DA01CF2733738F3FFE78B5AE66
          F39F0A81EC041313EAE5D321904ABADB28561667601DBC877D2D844A09E29F1D
          04C5530EC95B4C93C8B4D9AAA9E61D78073CDDCF6FDDE42F8E8412D92654497B
          EBF565E8DD2F54CC811F385EDB42100CCD014672F49C8CF48D309FC468B6319D
          937404EBCD37A28AE05D9D03DE08071D74903AE048325A19CCC1E11D3793F0B8
          1D8987BE0B239010389F896166ABB91F99D0231882B3B799199C3980396CA862
          162C58605A2EDBF89BDFFC0603070E4C739C527990C8F59216ED9C539AB35428
          7AEA2F153C16CD4DE6E090D8CD14A693C84A30F115B720BEF90DC06B91F9E488
          D8A91681235722BEF159C4975D0D0493CB2BFCA820A90ACB37F8EFF0EC767AAB
          5F63DF8C17AAED3361165271592499C866F80E7A1F9EF2ECA9F7765008826124
          E35FFFFA976ED21C2F44867A39F3D808F4C3D0D16B77E0D19C213931D12C35C7
          C5C8F1AC456DE8AB31EB1FFA32B83FE730E502D685261113FB52098691292DDA
          95092A104E4A3CE9A4930CCBA502A24F8A09760CA36B302254C2EE392561730E
          95918A49ED4BDE00A818796E49A68C18151259092632BBAFB833774A4E363487
          BAD482B712FE9F7E86D8D7678B01FA893089BA271E339283F3B4A050273E7AA0
          347E0FDF7E2FC0D3A575166B7CD90D88AF7F1A5229C3D8D99F5CA0C443C2443A
          14BE21CE26DF158260B20D1C1210F3418C40E722232F7A336EE9287EEEB9E774
          ED7E9A5754371CC4A9791A464963040704233A471E7964ABDFE823614487838B
          AA2B57307F8799C09904A3E5AFD0FCCA04D515673AB31F8DC081CCBA659E239A
          5724173D52B07B4EB92DD7BAE1520C92C571C6BAB35F99D3C3BEE56CF842C094
          60E4CDD3105B720D247FB699D20C03EF80A7A3185C439F42E413DEF902826CAC
          CF05694B288DABE03FE46D483AFE1379DDE3882DBB1E52B01FB22B194598565B
          103866BDA3F52B04C130A98ABE0BBD24360E2A868EE9883402A53F2714EA4530
          CCFC26BC8B3353960494990CC74C5C969739E8E8EFA0CF888EE14C90289F7AEA
          29759223B3707305A71690F0320986600488FDAC17F1E1A257CCC8D5EB478689
          99F54BA77966A8DD281789C8E59C528D528191F0B22999549068982049C77DEA
          5A3B4EC19460A25F8C81D2B042583766AB5CD1695A055FEF4990DA1F86A8502E
          52494F551DEC54685A09FFA1B3451BF66BF593B2ED43D1176700657D90358A16
          AD8177EFDBE1ED31DEB1AA158260388B9A93E1F4068615472D6114C6E545DBB3
          674FD53790D68FE252E33E543D7AA1670E6E3A97335591B6F0925E963193FA56
          AD5AA5920B1D99B9C28C6038FF8A91202332359AF7433F0B233D8F3FFEB86A52
          A682496D3431F51447AEE7947940AC0BCD25ABABF5A5B6837DCCEC60B3E92276
          6142300AC21FF4004A7830934125EED8BE813743AE5F0679E38B62FB7C6657B7
          1592E64FE34A048EFC0FA4F2D62151AA9CC8C70701C13DCCC3D872049E8A81F0
          1F3CCDB1DA15826078D7A7A962A46038D828BBCDC08B998B5265DED98D965BE0
          20A6EAA1FF81B39E3361A68A18096128393377877DA3E5D3E4034E3C6416B21E
          C110CCB3A1DF482F27867E0D6602A782C442D5459F12275266C26C1E563ECB25
          B02F1899A3039FE6A69585C552DBC26333A44ED3C90918128C5CF536A20B7F6D
          621E296A16ABAFD7458857BD2954CC16611255E0C71125CA0D0AEBDEB41A8111
          0B2195B6B649153986E887FDA0784A0D43F66A19A22F4A46563956AF42100C53
          D7A962F47C304CD1A739C26C5B3318A5AA137414F3CECD81A48166177D1DB4F9
          19CDD083912AD2233D26915169654668720127F791DC8C088673941869D2738A
          339FE5E9A79F4E7398B28DEC1F0E76B63B134679488413EBB190F038CD82CA84
          1126ABB941DA72A70CD13BB13EAF21C1C4164C427CEB2C7D3F8AA20E23783B1E
          0879DBBC840995EBCCEA1F1594C43F92CCB14B2005F5E72845661F0025B24308
          19FDD9D84A643B02073D07A98BF91AAA5651088261BA3F13DE8CA24899E4A007
          468B48147A930279619F7DF6D9EA728C1A18ED60B89473998CC0147AFA68322F
          6E4E1B603FA4AE52479F011DAC3C869DB47D3D642318AEC74B9F945E521BDBC4
          CCE75455C6BFD907546D7A6B2117E29CEA81C7FFEB5FFFAA92204D322BF3A7D8
          D7F4E53831E1D19060C233F7494CCD31200E49908A12AF171F9C5D85FCC701D1
          F0C6D528396E995032FA0B6547E69F0A79FBFCA40999D185F106787B9E03FF3E
          D993B0ACA01017237333183ED5B3D5E9F4A3B9A2379520138C86680B78A78221
          584A746DC946E6CE70862FD72F61929E117851D3219A99D7A117FEA68F83EBC7
          52D2E71B05A1EF819131928C1EC110F4F1D08CC86C2BEB46138E4B5712F42F91
          F03848697AE9A15804A3818A8404A8994ED9140D550C17A2CA35ECAF419F60A2
          F508BDDF53DCC18D171BA686C96FF9C91F339404B936916416412AEFA7BB55F4
          9BAB105FF37452E9B484B115392A88A9074A8EFAC891DA14E262D4D6FFC8BCD0
          2891698E70ED172BA0739583532F7F25D50F43938CE61407B0D9C2D90C91331C
          ADE76864F89B661D43BF1CE8344948448CE2E40B4EE2E44A75660463B62E31CD
          4AE69530439726D1CC99335593CEC8515E6C82D1402546C547956A969CC7A920
          9CC5CEFEC807BA04236FFD58DCA1CF14E224BFA704EC1C302649D5106C5C8592
          9F7D05A99D7EF25C7CC5C3882CBA0652597FC6D35AF68BEE4070F466476A5888
          8BD1685D17CA633A343937C80A7867E41C1B3DB5430263021D57F6A77A61921D
          27FB993D7180304A42A3C9C101CB39431CC0575F7DB51AF6FEF39FFF9C771FF3
          6E4D3F8B19C1102437E6C4E845CEE8047EF5D557D5BE2501D2F16C9497D25604
          A381897F340B8D54AA950C6A2BD02598D88A07115B7217247F652E65EE3450E4
          88EA4B51D3FC55A2494DA6935A92031B6A5032E25578F6D05FE7245E3503D14F
          4643AAE8DFBCBF12DA8C9213858915CC6DED9C54387D31D2C7C101AF37D0490A
          54253FFBD9CF2C97671461E15D904A8977744E6CA4C96065853AA3AC5E920E07
          04C98019B41CCCCC83C9F6BC202BB04A305CD281498146EBE19C7FFEF9CD0E5F
          B3A722B435C1103C2F547F7A7EB85C5628D4832EC144BEB804F14DC276F41577
          62545111AB87A762107C836F024ABA26A63828F104D930F358E694FC78F23B19
          4AE31AF8FA5D6418A296EB97233C633F8059BF1C68E16D081C310DDE2E47E45D
          55A72F46A310B5D5E5163241C9CD1C8CCC41A7F961984342B3884B445859658D
          F38A383B3A930053A70DD0B9CC2437FA149C00C98A77F56C0463B422A0060E4A
          AAC06C24EDC43925395011522D711E562EF92B7A6BFA6A7D9DEA57CA15BA0413
          9E7D12E4DAC5AA23B72DA0A4FC6F50ED669DA164098BEBF9891441181222089E
          BCCED97A376D40E8DD81AA635889562370E003F0F6FA45DEE53A4D30748E7220
          64FA5FE847A07392268F1D506AD34CD15B848A11162A1C26C931E26375294BA3
          AC5E9A49BCF372A9483E6EC5CC616C07AFBCF28AAA8AB2110C61F6E034ABABF2
          3B714EA9DE3495C4443FAA2BBB30BA39684F84CC67FA05A14B30A1F7F74F8461
          3DF93CDE2337A8D5096F4F46AFF4C84352558514EC22C446A3B8ED864D56A213
          178047508C3F7D56B422D48BAFFF25F00FFD93E3F50FFFEB10C8A12D42FC8801
          BCD764F807DF9877994E120CB35E69B664865BB5C7B3EA25856503950A49446F
          BE0EC1443466075B59384A83D15C275E1F7CB1AECC81C946065641938CF3AFAC
          100CC3BE34A9F4963E207153B9B02C3338714EB9721F951743FACCDEE59329ED
          82D9DCCCD7C9CC87CA65D94D3DE8124CD3346D65B73648F70FFF80D27175A69B
          30CFA4E9D52EF0763F1E25C7982FF2145DF257C4BEBD1D087468E6182526D4C5
          BEB7C0B7F7D5CE577FE6F190EB968A111B866FA020B161F93B209D2418BDD5E3
          7809D0DCE0DC995C67D7D2D94A05A417FED4CB13C90666EDFEF6B7BFD5CDEAD5
          42D6CCF130EA17BB60789CEBA55821189A0E9CFBA46792585DAAD289739AFA18
          199E3F9A3376E62111469131AB44990DFA04F34A47287ECADD62138C305DA2B5
          28FDF90EF3CD84826978CE075FBFF35032FC19D34D636B5F43E4D3F381929464
          30A1CE02C37EEF38C1284D55687AAB5FE258B106A1927E89C00177E65DAE5304
          439B9D2BAA65AA17E6BD505EE7BA960A3165CA14F562359A9DCDC43EA3EC5DB3
          76EB65BBD25744554485E31468BEB18E24352BAA882A90A1DED4C435AA40DEF9
          AD3C53C88973CAB03A4D4FAA3CABD9D79960CE11CDC34C3546338FEAE6D0430F
          CDAB5FF509E6C5722881CE96A77E3B0556458A56A3F4AC5AF3ED843A687C3E08
          5FDFF12839E205D36D636B5E4464DE446152B5ACEBA28405C1EC7F9B20982BD3
          B695EB5741DE3C5BF48A9F32499D1A9070FA8A971C4DBC9468E27BF51549FE2E
          64FBD6CF10DBF6B9EA7F61B729514130032E44E040EB776D23387131B26FB980
          369DAE998F18E56C61E670E4039A5E8C4C319A9479DC6CEBB918814E61969B99
          D5EBC4131633619760F4163FA7D9C62892B62CA6199C38A7A9C99276D30B3470
          6D1EE62BA51225499260B265BED02798E74BC55D98174AB113E94455228260CE
          CE622291609E1504D34F10CC915908669520984F2F8094A2601446780EBA1BBE
          BD2E4FDB36BEF23984669D2B4822986C7BB2FD9294FE7773083BE5774F20CD29
          4E3F8F7FC044F80FBA37EF5EC9F762E49D954B5272A06A260CF31C28F519E131
          7B4C891DD00CA2824995E93C0ED729C9C5196B94D59B9A5FE314B87C041FA1CB
          A902668980A9C8CC25E2B9609429DBEA7284130493BA2AA1D515F652C109995C
          2C2B75AA87F6103E666033B5205FE8124CC3F382957D156DB0E4428260CACF69
          30DF4C0EA3FEE920FCFDC7A1E468F344A0D8CA17109E3B0108A698488260FC87
          DC8FC05EE95EF7D8DA37109E3D4E6CDB0D794FDAA42379E0C52839B86D150CF3
          4E384B984E40920B073CE5341DB2CC8ACD96F4660794E8F49DA43A66E9DCE552
          9456076D2A584FAE9B92EAEB309AA99D2FB4E7165135310C6D05543B5C6797ED
          65BF72A05A9D74E904C130E990532534F541938D51252A192BD0C2E85A42A3A6
          36ADF8A1AC429F605E4A3C3DC0CA2A764E429D7E2008A6ECDC46F30D49304F09
          8219608160560982F9E47CA160B439435CBF662B02873E04FFA0F40591626BA6
          21FCD11942C17447BE04A3448582D9E7326122597F56732AE8B4E3C5C3F478AA
          0CA3BBA2DEC5C8E7ED70362D7D22B4A5E9C0A3CF82129ED3F029ADF55687CB17
          F43D30CF8564A6812A89B3907325B2CCC5C9D90ECE8FE18259B9826A8A6164DE
          A96982D1E462FFD20FC1E44092225509E73771ED5AFAAC98849709F63B2767B2
          6D244346BE5297C5D4401F141517DF79BEF8E2B0335A4A818A93BFF326401262
          7F52AD64FACE48309C38AADD3CAC3A66498ABC06A87C34F39326161510F377F8
          4C70A7A06F22BDBE37E4D0562160AC3FB9CE09A80413DE81B20961F30D858954
          FF2409E64C941CF38AE9A63161F684E79C9FF4C1248F2308A664F814A13026A6
          6FBBF64D84678E7188606AE11F723D0207DC6A6B3F3AEDB88892B696075FD924
          372F584293EADC87171CEF6CFC8EF9228C7AD001E854D4C5081CFCDA40E040E1
          DD3D9F07A9D3446262A0E684E4E0A7BF888978B982FE1B4EBE64DDD85746BE46
          6DA12B9A1224073D708638498F044362D7038FC56537E99FD296C9CC16EDA123
          5B7B71E0CF983143F5A1658251242E0D415F1AFB4823273A67FBF5EBD7BC562F
          B38C49A62417D657F31D9158D836E6F69004AD987776A04F30EF8E80BCFD6B71
          A5DA5B152B6FB02AD11A945F10CABA69DD14499838E35132229B0FE65584668D
          130493A260429B113C6A2A7C03D265606CDDBB08CD38195259FE26121DC9C123
          9F10C738D7D67EBC9899B8A6B7D66D3670A0703F862D79F7A3EFC3C9D5C9AC80
          791924015ED4741672AD967CD412C9939329B5FEE05D9ACB40E825F55905072D
          FBCA6A10436F06752AD4E04496B2784CBB21643BFB32F580644313955319B461
          ADB5532335DE78F81B8985D7087D305442569E279E0BF413ED669F8FD8EAD7DB
          66AA40E807949FBD2E11EA55A2AD7FF79440D9BE000DAF1F026FD7FD5136F6AB
          44C29D1E21F8CA1199FF1B44973E0AA4CEAB12C7081EFDAC18FCE97E81D8FAE9
          084D1F0594D97892800114A100CB46CF86B79BF3A6880B17D94062A662A1B2A1
          7A214931DAC4290E5C9FC60907AE15E8124C74E17D087FFE3B4881F6B9949917
          180256848AF19476134C1B6F5D618F60E0868D40B093D077D5904A3A4061C6B1
          0E1F481E2F94BA4D8230BAA4C4C3848269120473EC0BF0F54F5F3737B6610642
          EF9C28140CD93C3F82911BB7A26282303383CE39515DB8D8D9A03F9B7AE32C31
          D07ED60683431177FEEDA898947D70D73D2C0905321AA527BE63BA5D6CF95461
          225D90D616A5711B82235F81AF6FFAAAF9F10DFF46D3DBC70B82C9B7DD329448
          0D2A2E8AE7598E0B173B377409468935A16E4A19A4F2EC2B9A390AD507538DCA
          6C04234750FB5009FCFB8C45E909AF9B6E1A5DFE1C4233CF4D281ECD07D3B81D
          6527BD260826FD816BB18D1FA1F18D6344BBB56D73443C024FFBFE283FF3EBE2
          F69F0B173F32182E9959FF546775BD94624E78E42C67446A51F9AB2C833B1E46
          ED8341F8F73E15A527994FC68A2E7B06A10F260855D2123A551AAA513AFA0D41
          3063D28BDD381B0DAF8D80A722DB73A0B2B4235287C0D02B5032FC6F45EB3B17
          2E7E8C302498D0BFC621BAEA0D484574F42656E4AF43E565D9082684DAFB4BE1
          1F7C8A2098B74C375509660609468B3A50C1D4A0F4E4698260D27316E2559FA0
          E1E523E129B7F14C6A1DC84DB5281F3B13DE3DAC2FDAE4C2C5FF220C0926BAF2
          7534BD7B06A4601157B5635522F5A8FC757682A9B92F413065A3B310CCD2A968
          9A71419260922652432DCAC6BC055F9FF484A278D57C34BC78983091B46D736A
          8420B07AB4BB6AE77D7C8B19A65F2261DA1805534ECABF2C62C5038763E0E479
          C0A4F7A01815BAE2011C3E7032E6996DB32B23D93F43DE333E2F3C6FB70D5E8E
          B957E5B788B75D983ED9B1E63E490CB6B2E23D575A5D0BA611EDAECCE68309A3
          FA9E200243460B823177F292601ADF27C168B37C4930F5283FFD1DF87A8F4EDB
          36BEF973D43F7728A48A3C9EEF140BC1B7FB4F5076467E4B0D5AC6F44B208D7A
          4C7C188EFB97CF4561AF9FE9B8441A85C71C3B56B2BCE1F763F9DCAB60545C82
          845084F6150F1CF0EA69D385BDFE4D9465B68F76DEC8E3CEDD1CACC094601A5E
          3914F12D5F40F2DA4FFACA050913A929FBDD3F1646CDBD41F8F71504734A3682
          791A4DEF5D9824988482911B1A50FEF3F7E0EB95DED3F12D5FA2FE9983E1A9D0
          B6B50F39D488B2939E817F2F67E67298A3E5C22186DF5F843B94836AA259BD98
          60121FFB31AAA58D061B19D6C5EC18ECAF9B170F3419E8ADB7CFDEBFE9E72497
          3ADBEC44F57C205BDDB4F39685CC9D8629C1C496BF8C86B7CF82A7B4480FB1E7
          DAB79130DA4DCE3EB86BFE22C1BFFF58948D328F22C556BC8CC669670925D6D2
          06A5BE096567BD2F086664DAB6F1AD0B50FFE401F054E6D85E517FB9318CF6D7
          16C33C5A81070E1F88C9F31277AE41F724EE88F9DEA1CCEFACD6917530A65DF0
          83708F1894D0A9BB5A9F458941B19C9F91EBC04CF617D207586AF989EF920491
          4A005607B1E5BE9D249A3A05F9D38B760DA494D7AC68EDA150CAC6946088EA7B
          859914E49CA4224D7C0C855176DA8BF0B4EB9B587725B3C2DE00621B3F45D307
          57C2DBAEB3304566AA6BAFE8362E5089D0ECAB115B37B365DA03D76AA90FA3E2
          1733E1EB99EE8495B72D44EDE3C3205596E4266084B2F2F73F55A8AAFC9619CC
          8E7472495CF37ADFD947EB0157086877F9E4C0982EFE9E26FE4E91F9897A4CC2
          FD431661F198B9E2E25F21C6F93D428D3C96E3DDBF6D09A6995C0CEBCEFA4D00
          A6DA387749323127076B6668A190956042B32E43F8BF8F8AC15A8C05C0692409
          22132A4089196FC587494AC112285CFCA95E362503892E245F7ADDE5FA082ACE
          9B05DF9E23D2BFDFB618B553F6150A26B7B6CA7511545EFA1DBC1D0715B08F32
          0667DA6FF9938C19C164B7F5AD2161B60C6955FFE9CD0A65A0F83C411C6B5E2B
          25A43A2B45FD6E16F5B347316D453016CE89A6E6F8D93279B6268ED66D313836
          89E9B6C145219CAC04837814D57704C45DDD5BF415EE0A05B92E868A0BE6C0B7
          47FA3C21B97A196A1FDE4BA827FBB93F4A3C066FFBBEA898B8B27015B768476B
          77CB5C64AF21C1143D92A34F084E9767C724B4EDE3B2D067CD3E225B0A438738
          34D328A51CADECCCEB40FBBE183EBBEC0423D0F8F6E9882E7D0392FF7FE101F7
          82486AE3A8B8E813F87A1C9EF67D7CC732D491602AEDB753AE8BA3F2A24FE1ED
          FED382D4591B08562F0A4BE15FA3E39060A60213B4BBAA4D64AFA336401CE818
          CB03B3B80AC68A033BD9809C14A13E31B6F6C5E89F8B96FE2F7454C912C1D017
          52FD67BF5031285EC8BA90882808EC7F11CA463E9EF67568EE2D08CDB90D08DA
          6C634C1166511F4130AB9CAFABCE9DC9C6CEB6C393BA0AC692AD6F074EA813BB
          65148F6032C925BDDF5A06B7330A42872CB46BC6ECE6D2EC0C76CAE1AC0F4B04
          4334CDBC1CA1F98F70B58482C3E9188CA4F3855C0B949FF13802C32E52BF8AAE
          9886BA67C60A33C77E05E2354087EB56AA8E692791E9F3B017E1D191CF16D48C
          E1801BAE63DBE74C1045241893A80A07E49869C58B2219DD2CF24A826BA5542C
          86C953514007B0658221AA6F172333E0CC52BD994755D7CD86FA9C3478C507AF
          94F8EC9132D6DCD61E21DDAAC096EF59765CBC64F18AC98977BE948CE32A0DA2
          B89244994A93385625D21F4F6DA51D61A819C5E563DEB2BE538EB01AE1C92731
          2DF318FA8E5DE7FC23D64D090DB93A99DBC00793E5D8DA6F9A43DBBE9AC8761E
          92BF0FD1C832F3EF24B9E13D4C157FB739C144574D47FD53A3E0B1B94C8CD2FC
          5F822C481E3E412225DE2459895738EA419D5C8EADF51ED4842554453AA2B6BA
          5A7C57215EA5680829EADAAC9148489084248AF332654E2DD82B58C85F528A60
          C0878A808C4A54A3A2D48B2EED4AD0C5B3051DDA55A08B6F07827EB19D878F1F
          1104245EE138572B4B928F2751473B1620E76642104C879B8B332DA0F80493C3
          DD10F606A25144C9E976B559144955188BB2D7394569D9F3B399F55D665B5A13
          4CA1618B608886978E41F4FB8F12777E1368A55281F8C5E00DFA12641256FCD8
          DC588E95D57E2CDFE6C3DABA4A6CAF8F0852F121160D73555EB18F2CF651E011
          3B7BD4C0B5D2AC62240379A13E5234795C3E795A49AA9798E24DD445FC57515E
          860A6F13BA77F0A24FC71806B4AF47DFF621740A4620C971C404D984E209F5A3
          A410A21164611A554E9C015F9F131C3919CB962DC3A041C6216EAB04937B38D9
          AA32715AC1B41DC1E8F45E6B82C9AD612DA1E75C90CD6C312A3FADDE89B62C6A
          26AC9D806088EA3B13F68C94126CD1548AA650CAFC6213F17B4D3888EF6ACAF1
          D5C6327CB73D20148A8450380406A44ABC427D484AB31924E9394BF2427AD3E4
          2471244C2709E19884B86848A560BF3D3B0243BA8670C0EE8DE8DDAE1E7EC410
          8926558E0ED9C82151FFA167A2ECD4576CD4273F5823980C9F897A21BE8C7196
          06A5D50BF07FC74432ECBF3C08C6FC3C65AF8725B3C58A93B6D524C89D8460E4
          BA0DA8B97B4F48495389E38E264F79400C60310ABFAF6B8F8FD7966341551055
          B5323C4A54281825A14AD288A42D23522DCD567D345C8A26EE4193209D60895F
          281CE0B05E4D3864F71A74296D442C02F15B926CE25C1A388876939B8A5A63DD
          0B57F74ED6DAC16B2D029479C733C2FF8882B1AB32727086B69E7D9E598FC4DF
          2F8F2B404E4A2BF34C8F6012E71C6D3555C008D125CFA1F1A57351D9590C3661
          FE7CB7A323DE5F5181059B02A80F4551E18F0B95A2A86A26C1233B43783BF968
          5925E1A309C53C08C93E746FEFC5517D4238A657353A973420227825704DF197
          63C8258DDFD6A04CB9E35DB7CCAEB24887737E04A79032B06F5E8C818639220E
          9948A9B93E69656510CC8AE998FEEE348C9A9C7F2A42022D8AC630B377889919
          E52C722618223CE73ABCF4ECE398B3B12B6A1B22A808C454D3C7F3A350284E20
          117AA26A090965D314F7A36F653DC64CBC19C34FBBAAE8B5C98560ECEC637DB0
          B7A58994444E99AF56F67580609A9591C9748E567D6767298CD4F6189848BACA
          5587602CAC25930F72229835CBBFC1B30F5E8B2FBFF81C951515AAF993786C8B
          3542491C5249BC2B89A5325527ADA27DA724966E483A6EB581DEFC39B50129CF
          879692EF893729F9F224A638687FA3E5B33D242A1013AFA6863AD171318C1E7F
          35C65DFA27D1F6E26438DB36116C453FECD8E76D632269B0439AF6A74DE44730
          D933A8CDFB2E9F691E29953098A2A0736CAB51AE1C618B60967EF5319EB8FB72
          ACFD7E212ADA75462050D26CFE24C8411085FA34BA78F2253EF349737C577F4B
          7C47044A82E25526CA08A2A4AC02A5E595282B6F97F8AEB40C25E2DDC727137A
          F894423F3C5E1FFC7C6894389657FC1D8F455592884622E23B1931F11E8FC744
          F93144C221849B8429136A4448BC3735D48A570DA2E2FB48248CB0F89E8F4491
          A4C453F6A4E443A948143C9EC7E34DF9DBA34B466C47B8A91E4D8DF51871CA04
          4CFCED23A2CE855ED6C27E8ABDE590B1AD0B6DE72118F3F6E6B02E8599FA31F0
          77B55669E62A251F5F535682D3F33B15707E99258259F7FDB778E0A6F158B772
          11CA2B3AA8834E1DCCB1984A24FC4C94B7EB88CAF65DD0B57B2F74DEAD272A3B
          76C56EDDFBA243976EE2FBCEE8D07977B4EBB81B8265956D3E7132126E425DF5
          36546FAF42EDF6CD68A8ADC6964DABB0FD878DD8F1C3066CAB5A9FF8AD7AAB20
          C918BC82E03CEAA35CFDCD9F497A6C0709ABB1AE1AC78D9D848B6F9CD2A6EDCA
          15D36DADB5B2B39948BB069C9AEDEE244C0986A6C01D579D84CF3F9A2B148B20
          90CA0A411E7DD0A3F72074EB3910BD070E45A7DD7A89CF03D0B14BF7B66E4BC1
          D0585F8B4D6BBEC396AAD558B7621136ADFD4EFCBD0C3F6C5A83FADAED426905
          54C2894523E215C785D7DE8751675FDDD6D5DE29D0660AC64551604830FF99FD
          2666BE3E05FB0D1F89FE837F825E038622585AD1D6F5FDD181C9816B577CAB92
          CEF245F3B17AD9022C5DF0B130AF7CF8F3137345DF1DD2D65574E1A2CD905714
          C985311AEB6BF0C59CB770F0D1A7A9BE25172E7645B804E3C2858B82C1251817
          2E5C140C2EC1B870E1A2607009C6850B1705834B302E5CB828185C8271E1C245
          C1E0128C0B172E0A86FF07619A039794FE51530000000049454E44AE426082}
        ExplicitLeft = 3
        ExplicitWidth = 350
      end
      object Edit_User: TEdit
        AlignWithMargins = True
        Left = 30
        Top = 187
        Width = 296
        Height = 39
        Hint = '{"prefix-icon":"el-icon-user","placeholder":"'#35831#36755#20837#30331#24405#36134#21495'"}'
        Margins.Left = 30
        Margins.Top = 15
        Margins.Right = 30
        Margins.Bottom = 26
        Align = alTop
        AutoSize = False
        Color = clWhite
        TabOrder = 0
        Text = 'root'
      end
      object Edit_Password: TEdit
        AlignWithMargins = True
        Left = 30
        Top = 252
        Width = 296
        Height = 39
        Hint = 
          '{"prefix-icon":"el-icon-lock","placeholder":"'#35831#36755#20837#30331#24405#23494#30721','#40664#35748#65306'12345678' +
          '"}'
        Margins.Left = 30
        Margins.Top = 0
        Margins.Right = 30
        Margins.Bottom = 26
        Align = alTop
        AutoSize = False
        Color = clWhite
        PasswordChar = '*'
        TabOrder = 1
        Text = '12345678'
      end
      object Panel1: TPanel
        AlignWithMargins = True
        Left = 30
        Top = 317
        Width = 296
        Height = 45
        Hint = '{"radius":"4px","dwstyle":"border:solid 1px rgb(220,223,230);"}'
        Margins.Left = 30
        Margins.Top = 0
        Margins.Right = 30
        Margins.Bottom = 20
        Align = alTop
        BevelKind = bkSoft
        BevelOuter = bvNone
        Caption = 'Panel_User'
        Color = clWhite
        ParentBackground = False
        TabOrder = 2
        object Label_Captcha: TLabel
          Left = 192
          Top = 0
          Width = 100
          Height = 41
          HelpType = htKeyword
          HelpKeyword = 'captcha'
          Align = alRight
          AutoSize = False
          Caption = 'Label_Captcha'
        end
        object Panel2: TPanel
          AlignWithMargins = True
          Left = 188
          Top = 4
          Width = 1
          Height = 34
          Margins.Top = 4
          Align = alRight
          Color = 15130588
          ParentBackground = False
          TabOrder = 0
        end
        object Edit_Captcha: TEdit
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 182
          Height = 33
          Hint = '{"prefix-icon":"el-icon-circle-check","placeholder":"'#35831#36755#20837#39564#35777#30721'"}'
          Margins.Left = 0
          Margins.Bottom = 5
          Align = alClient
          AutoSize = False
          BorderStyle = bsNone
          TabOrder = 1
        end
      end
      object Panel3: TPanel
        AlignWithMargins = True
        Left = 30
        Top = 382
        Width = 296
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
        TabOrder = 3
        object Label_Register: TLabel
          AlignWithMargins = True
          Left = 214
          Top = 3
          Width = 75
          Height = 18
          Align = alRight
          Alignment = taRightJustify
          Caption = #27880#20876#26032#29992#25143
          Font.Charset = ANSI_CHARSET
          Font.Color = clHotLight
          Font.Height = -15
          Font.Name = #24494#36719#38597#40657
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          OnClick = Label_RegisterClick
          ExplicitHeight = 20
        end
        object CheckBox_Rem: TCheckBox
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 97
          Height = 18
          Margins.Left = 0
          Align = alLeft
          Caption = #35760#20303#23494#30721
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
      end
      object Button_Log: TButton
        AlignWithMargins = True
        Left = 30
        Top = 430
        Width = 296
        Height = 40
        Hint = '{"type":"primary"}'
        Margins.Left = 30
        Margins.Top = 0
        Margins.Right = 30
        Margins.Bottom = 10
        Align = alTop
        Caption = #30331' '#24405
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindow
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnClick = Button_LogClick
      end
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
      Hint = 
        '{"background-color":"#314157","dwattr":"unique-opened","dwstyle"' +
        ':"padding-left:1px;","dwloading":"1"}'
      ImageIndex = 55
      OnClick = MenuItem_HomeClick
    end
    object MenuItem_Inventory: TMenuItem
      Caption = #24211#23384#26597#35810
      ImageIndex = 104
      OnClick = MenuItem_InventoryClick
    end
    object MenuItem_StockIn: TMenuItem
      Caption = #20135#21697#20837#24211
      ImageIndex = 41
      OnClick = MenuItem_StockInClick
    end
    object MenuItem_StockOut: TMenuItem
      Caption = #20135#21697#20986#24211
      ImageIndex = 40
      OnClick = MenuItem_StockOutClick
    end
    object N4: TMenuItem
      Caption = #29992#25143#31649#29702
      ImageIndex = 7
      object MenuItem_User: TMenuItem
        Caption = #29992#25143#20449#24687#31649#29702
        ImageIndex = 8
        OnClick = MenuItem_UserClick
      end
      object Menu: TMenuItem
        Caption = #35282#33394#26435#38480#31649#29702
        ImageIndex = 133
        OnClick = MenuClick
      end
      object MenuItem_Card: TMenuItem
        Caption = #29992#25143#21517#29255#22841
        ImageIndex = 190
        OnClick = MenuItem_CardClick
      end
    end
    object N14: TMenuItem
      Caption = #20449#24687#31649#29702
      ImageIndex = 63
      object MenuItem_Product: TMenuItem
        Caption = #20135#21697#20449#24687#31649#29702
        ImageIndex = 68
        OnClick = MenuItem_ProductClick
      end
      object MenuItem_Warehouse: TMenuItem
        Caption = #20179#24211#20449#24687#31649#29702
        ImageIndex = 66
        OnClick = MenuItem_WarehouseClick
      end
      object MenuItem_Supplier: TMenuItem
        Caption = #20379#24212#21830#20449#24687#31649#29702
        ImageIndex = 64
        OnClick = MenuItem_SupplierClick
      end
      object MenuItem_Requisition: TMenuItem
        Caption = #39046#26009#21333#20301#20449#24687#31649#29702
        ImageIndex = 65
        OnClick = MenuItem_RequisitionClick
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
    object MenuItem_Stat: TMenuItem
      Caption = #20998#31867#32479#35745
      ImageIndex = 71
      OnClick = MenuItem_StatClick
    end
    object MenuItem_Document: TMenuItem
      Caption = #36164#26009#31649#29702
      ImageIndex = 58
      OnClick = MenuItem_DocumentClick
    end
    object MenuItem_Option: TMenuItem
      Caption = #31995#32479#35774#32622
      ImageIndex = 5
    end
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 98
    Top = 145
  end
  object FDConnection1: TFDConnection
    Left = 98
    Top = 209
  end
  object FDPhysODBCDriverLink1: TFDPhysODBCDriverLink
    Left = 98
    Top = 265
  end
  object FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink
    Left = 98
    Top = 321
  end
end
