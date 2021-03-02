object Form1: TForm1
  Left = 0
  Top = 0
  Hint = '{"type":"primary"}'
  BorderStyle = bsNone
  Caption = 'Hello,World!'
  ClientHeight = 660
  ClientWidth = 360
  Color = 16479286
  TransparentColor = True
  TransparentColorValue = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWhite
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnMouseUp = FormMouseUp
  PixelsPerInch = 96
  TextHeight = 20
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 360
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 1
    ParentColor = True
    TabOrder = 0
    object Image1his: TImage
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 32
      Height = 32
      Align = alLeft
      Picture.Data = {
        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000200000
        00200806000000737A7AF4000000734944415478DA63641860C038EA8051078C
        3A60503AE0FFFFFF0780943D58011020F32900078146390C0D07D0138C3A60D4
        01B87241029092072B60646C44E653001E02CD5A40AC030E300C703900F2B102
        D4010DC87C0AC003A243809E60D401A30E18B4D970601D404F30EA8051078C3A
        000018D93F2119384EF50000000049454E44AE426082}
    end
    object Image2his: TImage
      AlignWithMargins = True
      Left = 324
      Top = 4
      Width = 32
      Height = 32
      Align = alRight
      Picture.Data = {
        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000200000
        00200806000000737A7AF40000018B4944415478DAED968171C2300C45E5099A
        4ED0740336289D009800D8800D0813944E009DA0E904F506A51B8409482748BF
        B072CDF9D2D84E93EBC1C5773AC5B12C3FD9966D45FF5CD40030005C14405114
        0BA809640489E5B786A49037A554D60B00061E43ED2A83D6951CB205C4A65300
        897A27D52324E1A8CB68D13E8562998BCD1E6DCB4E0024F277A96EE03871D8F2
        52DC8440B80038CA3BD7E0157BDE1B5A201ED147B706A84CFD118E62DF29453F
        065D93D994D3BF00F074F28E5FC2D13E0020823A49F5167DF3B6001999E9BF0F
        4D2FF4D5500FE4B10C4D00C5D9002564F0AB02289DCCE0240D04E075E74C702E
        5F13C00AEA09F202278B80C1D996B3E713FD462EFB268018EA4001392D19F041
        E6C8F6CA1ED7419490C9E95C200E8EC15F2163DFE89D00E298A3980BC416F26C
        E7B64CFB9A7E2EAB1436B34E002C88B2E8CA37471AC9F7179925E3E2757C7BA7
        985C36BC312735CDE75B92D7DC8275EE8336391E49D465C9EC540B81E8ED49E6
        0BD1EB9BD082A84DE5DE1FA50241BF1D6697F52A1E00AE12E01B2FE3BC2103B9
        E3E60000000049454E44AE426082}
      ExplicitLeft = 311
      ExplicitTop = 2
    end
    object Label2: TLabel
      Left = 39
      Top = 1
      Width = 282
      Height = 38
      Align = alClient
      Alignment = taCenter
      Caption = #38376#24613#35786#32479#35745
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindow
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 75
      ExplicitHeight = 20
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 40
    Width = 360
    Height = 31
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 1
    object ComboBox1: TComboBox
      AlignWithMargins = True
      Left = 55
      Top = 3
      Width = 73
      Height = 28
      Margins.Left = 55
      Align = alLeft
      TabOrder = 0
      Text = #37096#38376
    end
    object ComboBox2: TComboBox
      AlignWithMargins = True
      Left = 134
      Top = 3
      Width = 73
      Height = 28
      Align = alLeft
      TabOrder = 1
      Text = #31185#23460'c'
    end
    object ComboBox3: TComboBox
      AlignWithMargins = True
      Left = 213
      Top = 3
      Width = 87
      Height = 28
      Align = alLeft
      TabOrder = 2
      Text = #26102#38388#27573
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 71
    Width = 360
    Height = 66
    Align = alTop
    ParentColor = True
    TabOrder = 2
  end
  object Panel4: TPanel
    Left = 0
    Top = 169
    Width = 360
    Height = 35
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 1
    Caption = 'Panel3'
    Color = clWhite
    ParentBackground = False
    TabOrder = 3
    object Label11: TLabel
      AlignWithMargins = True
      Left = 18
      Top = 4
      Width = 86
      Height = 27
      Margins.Left = 10
      Align = alLeft
      AutoSize = False
      Caption = #29615#27604#36235#21183
      Font.Charset = ANSI_CHARSET
      Font.Color = 3289650
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitLeft = 117
      ExplicitTop = 6
    end
    object ToggleSwitch1: TToggleSwitch
      AlignWithMargins = True
      Left = 176
      Top = 6
      Width = 180
      Height = 25
      Margins.Top = 5
      Align = alRight
      AutoSize = False
      State = tssOn
      StateCaptions.CaptionOn = #19987#23478#38376#35786
      StateCaptions.CaptionOff = #26222#36890#38376#35786
      SwitchWidth = 40
      TabOrder = 0
      ThumbColor = clYellow
    end
    object Panel9: TPanel
      AlignWithMargins = True
      Left = 1
      Top = 11
      Width = 4
      Height = 13
      Margins.Left = 0
      Margins.Top = 10
      Margins.Bottom = 10
      Align = alLeft
      BevelOuter = bvNone
      Color = 16479286
      ParentBackground = False
      TabOrder = 1
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 204
    Width = 360
    Height = 196
    Align = alTop
    Caption = 'Panel3'
    Color = clWhite
    ParentBackground = False
    TabOrder = 4
    object Chart1: TChart
      Left = 1
      Top = 1
      Width = 358
      Height = 193
      BackWall.Pen.Color = clWhite
      Legend.Alignment = laBottom
      Legend.Font.Color = 6579300
      Title.Text.Strings = (
        'TChart')
      Title.Visible = False
      Frame.Color = clWhite
      View3D = False
      Align = alClient
      BevelOuter = bvNone
      Color = clWhite
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 13
      object Series1: TLineSeries
        Title = #38376#35786#24635#25968
        Brush.BackColor = clDefault
        Pointer.InflateMargins = True
        Pointer.Style = psRectangle
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
      object Series2: TLineSeries
        Title = #38376#24613#35786#24635#25968
        Brush.BackColor = clDefault
        Pointer.InflateMargins = True
        Pointer.Style = psRectangle
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
    end
    object Panel_Line0: TPanel
      Left = 1
      Top = 194
      Width = 358
      Height = 1
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
    end
  end
  object Panel6: TPanel
    Left = 0
    Top = 137
    Width = 360
    Height = 32
    Align = alTop
    Caption = 'Panel3'
    Color = clWhite
    ParentBackground = False
    TabOrder = 5
  end
  object Panel7: TPanel
    Left = 0
    Top = 435
    Width = 360
    Height = 48
    Align = alTop
    Caption = 'Panel3'
    Color = clWhite
    ParentBackground = False
    TabOrder = 6
  end
  object Panel8: TPanel
    Left = -1
    Top = 429
    Width = 360
    Height = 180
    Caption = 'Panel3'
    Color = clWhite
    ParentBackground = False
    TabOrder = 7
  end
  object Panel_IN31: TPanel
    Left = 19
    Top = 77
    Width = 141
    Height = 85
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = 3289650
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 8
    object Image1: TImage
      AlignWithMargins = True
      Left = 5
      Top = 3
      Width = 32
      Height = 32
      Hint = '{"src":"/media/images/history.png"}'
      Picture.Data = {
        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000200000
        00200806000000737A7AF4000002614944415478DAED96C16EDA40108667ACA2
        1CEBF00420C55C9B4A3DE4167882A64F1072AA621F02A71E93DC7AC3958AD35B
        E9139437283DF650855C7124D21700E798803C9D5D6487D07A592F44F4D03958
        96BC9EFD6666E79F45D8B0E13F0F605F0C4B563C3925C4524EDF11119D475EA5
        6F0C60B786366E4D2E11726F2E8D8821806A2A08354010362C80163BFAC51968
        0052A4BB3912F90CFE02083F8CBC9D861140B17DEDB3A71320381F79CE599EE8
        537880EF63D7A91A016C07618F17EC1B015C84558BE0DB7F80D5003E86EFC182
        77A66241B3C78FB1E7EC19020C3EA1856F0DF7971613FC8C3CE7951140B11D9E
        11C229F7F21740ECE40B9FEADC8687B04A0904004800B513D5BF2BEAC02A007A
        1AA256C2F424D3CDD8AD94F300241D14033423D7F1CD007816585BD3B1788F11
        6AD1B1D3D3D95C0E309A0EE57F442F8D67814C6530E8F0B2439E6C7DBA2FD4A2
        6679E93CD86E875D4478CD99BBE2CCEDAAD66A8D63A4699F173EE793DD197995
        232570527B8DE8F500DA03D14E2D8EC816539145A5A48C3E18F4C51494A318F1
        287277BAC60049FAC5BB482761E1203A2EDF2C444B23D7693ECED8A42B47F1CC
        FCF9EF5A00D2493CF98A88B3FA65F4723108A5DAF206F8E7B73978717EACC29B
        79F84C003BB83EE0A03ECB9403DC12603D2B8D2A80B47C88BE383F5925C1851F
        762DC4CB34E50475D5215A0690F8E4603A4949160FE6638007E1B9A2BB427559
        CBE90048BFB3BB654F402CEA4906809EF4EA02084B9571AD00625608008DCBCA
        9300E4B17C00A26DC4357C8D26AFE9DCD64B001E86C853598CCFCAF37AF0771D
        005A6BF489B1A6F84A1DD8846D1CE037CB4E9C3049DD70CE0000000049454E44
        AE426082}
    end
    object Label1: TLabel
      Left = 44
      Top = 3
      Width = 48
      Height = 17
      Caption = #38376#35786#24635#37327
      Font.Charset = ANSI_CHARSET
      Font.Color = 3289650
      Font.Height = -12
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 44
      Top = 19
      Width = 84
      Height = 17
      Caption = #25353#25346#21495#20154#27425#32479#35745
      Font.Charset = ANSI_CHARSET
      Font.Color = 3289650
      Font.Height = -12
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 10
      Top = 47
      Width = 59
      Height = 33
      Caption = '6,690'
      Font.Charset = ANSI_CHARSET
      Font.Color = clHighlight
      Font.Height = -24
      Font.Name = 'Arial Unicode MS'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 76
      Top = 59
      Width = 26
      Height = 18
      Caption = '+2.6'
      Font.Charset = ANSI_CHARSET
      Font.Color = clHighlight
      Font.Height = -13
      Font.Name = 'Arial Unicode MS'
      Font.Style = []
      ParentFont = False
    end
  end
  object Panel_IN32: TPanel
    Left = 177
    Top = 77
    Width = 163
    Height = 85
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = 3289650
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 9
    object Image2: TImage
      AlignWithMargins = True
      Left = 5
      Top = 3
      Width = 32
      Height = 32
      Hint = '{"src":"/media/images/history.png"}'
      Picture.Data = {
        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000200000
        00200806000000737A7AF4000000734944415478DA63641860C038EA8051078C
        3A60503AE0FFFFFF0780943D58011020F32900078146390C0D07D0138C3A60D4
        01B87241029092072B60646C44E653001E02CD5A40AC030E300C703900F2B102
        D4010DC87C0AC003A243809E60D401A30E18B4D970601D404F30EA8051078C3A
        000018D93F2119384EF50000000049454E44AE426082}
    end
    object Label6: TLabel
      Left = 45
      Top = 5
      Width = 60
      Height = 17
      Caption = #38376#24613#35786#24635#37327
      Font.Charset = ANSI_CHARSET
      Font.Color = 3289650
      Font.Height = -12
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 45
      Top = 20
      Width = 84
      Height = 17
      Caption = #25353#25346#21495#20154#27425#32479#35745
      Font.Charset = ANSI_CHARSET
      Font.Color = 3289650
      Font.Height = -12
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 19
      Top = 47
      Width = 59
      Height = 33
      Caption = '2,437'
      Font.Charset = ANSI_CHARSET
      Font.Color = clHighlight
      Font.Height = -24
      Font.Name = 'Arial Unicode MS'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 84
      Top = 59
      Width = 26
      Height = 18
      Caption = '+2.3'
      Font.Charset = ANSI_CHARSET
      Font.Color = clHighlight
      Font.Height = -13
      Font.Name = 'Arial Unicode MS'
      Font.Style = []
      ParentFont = False
    end
  end
  object Panel10: TPanel
    Left = 0
    Top = 400
    Width = 360
    Height = 35
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 1
    Caption = 'Panel3'
    Color = clWhite
    ParentBackground = False
    TabOrder = 10
    object Label10: TLabel
      AlignWithMargins = True
      Left = 18
      Top = 4
      Width = 246
      Height = 27
      Margins.Left = 10
      Align = alLeft
      AutoSize = False
      Caption = #38376#35786#31185#23460#35786#37327#25490#21517#21069'5'#65288#36739#19978#24180#65289
      Font.Charset = ANSI_CHARSET
      Font.Color = 3289650
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitLeft = 277
      ExplicitTop = 6
    end
    object Panel11: TPanel
      AlignWithMargins = True
      Left = 1
      Top = 11
      Width = 4
      Height = 13
      Margins.Left = 0
      Margins.Top = 10
      Margins.Bottom = 10
      Align = alLeft
      BevelOuter = bvNone
      Color = 16479286
      ParentBackground = False
      TabOrder = 0
    end
    object ComboBox4: TComboBox
      AlignWithMargins = True
      Left = 283
      Top = 4
      Width = 73
      Height = 28
      Margins.Left = 55
      Align = alRight
      TabOrder = 1
      Text = #20998#31867
    end
  end
end
