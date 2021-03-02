object form1: Tform1
  Left = 370
  Top = 190
  Caption = #22823#23500#32705#35770#22363
  ClientHeight = 524
  ClientWidth = 1017
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = 15790320
  Font.Charset = DEFAULT_CHARSET
  Font.Color = 6579300
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnMouseUp = FormMouseUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 20
  object Panel_All: TPanel
    Left = 0
    Top = 0
    Width = 1017
    Height = 1060
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 0
    object Panel_99_Foot: TPanel
      Left = 0
      Top = 146
      Width = 1017
      Height = 70
      Align = alTop
      Color = clWhite
      TabOrder = 0
      object Label14: TLabel
        Left = 1
        Top = 49
        Width = 1015
        Height = 20
        Align = alBottom
        Alignment = taCenter
        Caption = #24863#35874#24800#39038','#22914#26377#20219#20309#24314#35758#21644#24847#35265','#35831#32852#31995#29256#20027'1'
        ExplicitWidth = 287
      end
      object Label15: TLabel
        Left = 1
        Top = 29
        Width = 1015
        Height = 20
        Align = alBottom
        Alignment = taCenter
        Caption = '(C) '#29256#26435#25152#26377'. '#22823#23500#32705#35770#22363' 1998-2020'
        ExplicitWidth = 249
      end
      object Panel4: TPanel
        Left = 1
        Top = 1
        Width = 1015
        Height = 1
        Align = alTop
        TabOrder = 0
      end
    end
    object Panel_10_Posts: TPanel
      Left = 0
      Top = 56
      Width = 1017
      Height = 90
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 1
      object Panel_Post: TPanel
        Left = 0
        Top = 0
        Width = 1017
        Height = 90
        Align = alTop
        AutoSize = True
        BorderWidth = 5
        Color = clWhite
        TabOrder = 0
        Visible = False
        object Label_Message: TLabel
          Left = 6
          Top = 44
          Width = 1005
          Height = 40
          Align = alTop
          Caption = 
            #22823#23478#30475#30475#65292#20026#20160#20040#25105#30340'jsp'#39029#38754#20013#30340#27721#23383#22312#31243#24207#25191#34892#21518#21464#25104#20102#20081#30721'<p align="center"><fontolor="#0000' +
            'FF">&Icirc;&Ograve;&micro;&Auml;&sup1;'#164#215#247'&Igrave;'#168'</font></p>'#65292#25105#30693 +
            #36947#26159#23383#31526#38598#30340#38382#39064#65292#21487#26159#25105#29992#30340#26159'GBK'#21568#65292#20026#20160#20040#36824#26159#26377#38382#39064#21602#65311#35831#37027#20301#26379#21451#24110#24110#24537#65292#32473#20010#26368#31616#21333#30340#26041#27861' '
          WordWrap = True
          ExplicitWidth = 987
        end
        object Panel_00_PostBase: TPanel
          Left = 6
          Top = 6
          Width = 1005
          Height = 28
          Align = alTop
          BevelOuter = bvNone
          BorderStyle = bsSingle
          Color = 16771553
          TabOrder = 0
          DesignSize = (
            1001
            24)
          object Label_CreateDate: TLabel
            Left = 863
            Top = 4
            Width = 150
            Height = 19
            Alignment = taCenter
            Anchors = [akTop, akRight]
            AutoSize = False
            Caption = '2020-08-05 08:00:00'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 16752192
            Font.Height = -13
            Font.Name = #24494#36719#38597#40657
            Font.Style = []
            ParentFont = False
            ExplicitLeft = 846
          end
          object Label_Floor: TLabel
            Left = 10
            Top = 4
            Width = 40
            Height = 19
            AutoSize = False
            Caption = '999'#27004
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 16752192
            Font.Height = -13
            Font.Name = #24494#36719#38597#40657
            Font.Style = []
            ParentFont = False
          end
          object StaticText_Poster: TStaticText
            Left = 55
            Top = 0
            Width = 411
            Height = 24
            Hint = '{"type":"default"}'
            AutoSize = False
            Caption = 'StaticText_Subject'
            TabOrder = 0
          end
        end
        object Panel_Space: TPanel
          Left = 6
          Top = 34
          Width = 1005
          Height = 10
          Align = alTop
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 1
        end
      end
    end
    object Panel_00_Title: TPanel
      Left = 0
      Top = 0
      Width = 1017
      Height = 56
      Align = alTop
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 2
      object Label1: TLabel
        Left = 8
        Top = 4
        Width = 38
        Height = 19
        Caption = #26631#39064' :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 6579300
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label_Room: TLabel
        Left = 8
        Top = 30
        Width = 30
        Height = 20
        Caption = #20998#31867
        Visible = False
      end
      object Label_ThreadTitle: TLabel
        Left = 56
        Top = 4
        Width = 929
        Height = 45
        AutoSize = False
        Caption = #20998#31867
      end
    end
  end
end
