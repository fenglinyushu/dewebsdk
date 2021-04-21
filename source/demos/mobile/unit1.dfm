object Form1: TForm1
  Left = 0
  Top = 0
  Hint = '{"type":"primary"}'
  VertScrollBar.Visible = False
  BorderStyle = bsNone
  Caption = 'DeWeb'
  ClientHeight = 511
  ClientWidth = 360
  Color = clWhite
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
  object Panel_Header: TPanel
    Left = 0
    Top = 0
    Width = 360
    Height = 40
    Margins.Left = 0
    Margins.Top = 10
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    Color = 1492260
    ParentBackground = False
    TabOrder = 0
    object Label_Header: TLabel
      AlignWithMargins = True
      Left = 49
      Top = 3
      Width = 265
      Height = 34
      Align = alClient
      Alignment = taCenter
      AutoSize = False
      Caption = 'Header'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitLeft = 48
      ExplicitWidth = 295
      ExplicitHeight = 30
    end
    object Button_Return: TButton
      AlignWithMargins = True
      Left = 3
      Top = 2
      Width = 40
      Height = 34
      Hint = 
        '{"fontsize":"24px","color":"rgb(255,255,255)","icon":"el-icon-ar' +
        'row-left","type":"text"}'
      Margins.Top = 2
      Margins.Bottom = 4
      Align = alLeft
      TabOrder = 0
    end
    object Button_Menu: TButton
      AlignWithMargins = True
      Left = 320
      Top = 2
      Width = 40
      Height = 34
      Hint = 
        '{"fontsize":"24px","color":"rgb(255,255,255)","icon":"el-icon-me' +
        'nu","type":"text"}'
      Margins.Top = 2
      Margins.Right = 0
      Margins.Bottom = 4
      Align = alRight
      TabOrder = 1
    end
  end
  object Panel_Footer: TPanel
    Left = 16
    Top = 416
    Width = 300
    Height = 50
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      300
      50)
    object Image_bottom0: TImage
      Left = 12
      Top = 14
      Width = 24
      Height = 24
      Hint = '{"src":"/media/images/app0/bottom0.jpg"}'
      Anchors = [akTop]
    end
    object Image_bottom1: TImage
      Left = 74
      Top = 14
      Width = 24
      Height = 24
      Hint = '{"src":"/media/images/app0/bottom1.jpg"}'
      Anchors = [akTop]
    end
    object Image_bottom2: TImage
      Left = 129
      Top = 1
      Width = 40
      Height = 50
      Hint = '{"radius":"50%","src":"/media/images/app0/bottom2.jpg"}'
      Anchors = [akTop]
    end
    object Image_bottom3: TImage
      Left = 201
      Top = 14
      Width = 24
      Height = 24
      Hint = '{"src":"/media/images/app0/bottom3.jpg"}'
      Anchors = [akTop]
    end
    object Image_bottom4: TImage
      Left = 257
      Top = 14
      Width = 24
      Height = 24
      Hint = '{"src":"/media/images/app0/bottom4.jpg"}'
      Anchors = [akTop]
    end
    object Panel_FooterTopLine: TPanel
      Left = 0
      Top = 0
      Width = 300
      Height = 1
      Align = alTop
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 0
    end
    object Panel1: TPanel
      Left = 0
      Top = 49
      Width = 300
      Height = 1
      Align = alBottom
      BevelOuter = bvNone
      Color = clNavy
      ParentBackground = False
      TabOrder = 1
    end
  end
  object ScrollBox_Content: TScrollBox
    Left = 0
    Top = 40
    Width = 360
    Height = 321
    VertScrollBar.Visible = False
    Align = alTop
    BorderStyle = bsNone
    TabOrder = 2
    object Panel_Content: TPanel
      Left = 0
      Top = 0
      Width = 360
      Height = 1200
      Align = alTop
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object Panel_dm2: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 0
        Width = 355
        Height = 130
        Hint = '{"borderradius":"10px"}'
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 10
        Align = alTop
        BevelOuter = bvNone
        Color = 16775927
        ParentBackground = False
        TabOrder = 0
        OnClick = Panel_dm2Click
        object Image_DM2: TImage
          AlignWithMargins = True
          Left = 10
          Top = 23
          Width = 80
          Height = 84
          Hint = '{"radius":"5px","src":"/media/images/app0/202.jpg"}'
          Margins.Left = 10
          Margins.Top = 23
          Margins.Bottom = 23
          Align = alLeft
          Picture.Data = {
            0954506E67496D61676589504E470D0A1A0A0000000D49484452000000300000
            003008060000005702F9870000065E4944415478DAD5594D561B391096DA6ABF
            C9B0809C20649784459C13604E10E70498136096137B1ECD1B9859C69C20F609
            3027009F00676160379E13C45EC064E876D794BA5BB6A45677CB76320C7A8F67
            FA4FAAAF7EBE2A952879E2833EB6004F06C09B13FF9010A85342378140E7DE77
            0F461E1DFF6F00BCFA03364BD3E9F6B454EADFFE42479AF01E2E74A87C00E472
            D872771E150017DA09B96649956B96DF9B8664E7F657F75205F07085CF2BFAF7
            40488F00ED5CB7D8F97F0AE0D56F7ED571601785AAEBCF4C00B64E7C7EBD9D35
            1FBAD48882E30D5BACFB43016C7AB0B1C68243FCAA61783C2100BD69C9F57417
            7AFD7B507300CE0A1740B722941D0C9B74F0DD016C9D4005887F265C65BE2874
            0975DB458B721034C420A6640397EDDCF9A5DE33E663509306A5F485FC6E48A0
            71D32C9F7E37005B27411D25FDAC0B6ED2F632E3F5F143C3A1D4C37FD767D323
            535D37CB7B2B0330083F0929ADDF7C64BDA26F7990F35F1B9011214C83365AE8
            FD5C49C54C950B20253CC017D47ACD24108F0FC1EB6F8EFD9E2288245048A107
            8E7B9E056AEBF8A14328DD9D7F926F894C00DCE70909AE64E1EF02B7AA271F2E
            F8CF6EB04F81348092CB7B9F458BAD31641E4ADF66CDCF29941276648A1D5D71
            F8EED175D3F5AC01C442F91733EECE103E629710178A0273A6B10166D91D2B10
            40CEC3126B98AC81D4DBC69F7D716DA2E74C00DAC793A9C32AFA22BAA955EDCE
            41A0751A14301628AD913848FB82856485C82E2886EC8A7C4E74A5778500A292
            200CFE945ED91B3659C75678699C0E9B6E439D976C0897E1D734F4DF3B80C028
            A90AD03AA835371825C08DAE9402A009D74721AA8A564C758D6184000737AD72
            5BBEC7057AE6FA98C149DD5C5AA4412414FB29793E422BBCCC04A06B5FF7BB54
            60E701A0F4834EB5C67C924201DD61AB5C579476FC309A273BD523140032DA55
            B49FC51A96AE97529C6605251614006AD195F6FD422190ADB0ACA8733F8FAC05
            C12ED636DD3B9F8CB85B58592096524960492C7C15D7773E7B2EDC8CDABC2404
            472A6D4482984048A637594A6815BF1DE451EBEC7D87BD94994F56AEEC9E3300
            BC442E39E44268128599059900C7CD173AEE073E715C619646B170C106172ED9
            1F9C9902546855592767E824A02965C670D4F482EEC38AE9818CD12D76F40C9A
            B8CC859CD45242259A538332732831A8019F3DB302A0BB84292B6A04601E8915
            6C6241A7CC420072F6D5CDA7A7F52C8EC7D2A15DC432B35838F1797CADE7BD8B
            42EA240309BA312AE2B90E806B74DBA4E1F496506528AE1DC2D888C746BCB9F7
            3DA974D0541B07BB0DA56602909ECD5D482981550195C58400DC0D00E27B580A
            2466EF60901F712051D6CDD871F1C56D92E262006C6220A94AD75CB29917B011
            90907685151361EB005043301BA2382CB2820C40068CF3FC75DD2A6F2A009420
            D4D2F93CE8D83B9E94B0D4BE4AED8DCD4046A88CF6DFBEDBCD6A626506B446E5
            8541ACE601C217EB60A01CF0CB64D3D2E056D103DA7A20034D811C996A7A9B51
            98073204534B62CB24943126C85E9ECE5E625E522220DFBBFDE8F6E5EBC24CBC
            75EC7F4DF9B444579116EC12903A05FA2BA58E67AAAB0C9A151F29EEC387DCB9
            30D64226E1E46089DC88F9036B005161E7B485E071378FECE3823539C84D5D3B
            53292E645873A73563396DCAA47AC2B2ECB029AEC283144878A8073DDF0F5FB7
            DC9A6E0171DFD6C2EA7E20E99E451339B463D2425E10F3C5EF0356E7E64DFAA7
            9F8C855D3C2226516A7DB4F87DE0561669BB2FD5DC35F0F7ACD99530D667EE2A
            45F3709E97886182345D1545229FE7A772F0F6DB03FB920768E9F6BA04A28F89
            A93E2BB1B5368B15000A6DB111E2F7D3EE6CDE5CAD04205A0805165ACFE95AE7
            03C0DAE9DB3F642CB49C5562E81B1C6B00D22106C96AF12581C8855F2F9A4F1A
            A93DB734576ADFBD50636B26BC96B8F2CEB604C545F50E891A59A66D234F4EE8
            26AC93D58E470067A6F859DA028666EB8012776F9143089B91B71D35ED3FAC01
            44200CD48979DFBBF7D9E9AA278D71FC4CB18CE781AC04FF29AE31A684F5F294
            B5C0094D54357220733FC752032869870EEB2E7AD02177B535C127E8EF35DBA2
            6F21164A3A771D623AB0C36A93B7D743FC33717774D801C10B0A5011FD50C312
            7DAC736A3F3C91C5193B6C2F5AD8E58C3E6ADD5BA6D45EED9C384E42759B76A1
            61C4A79A403BCBEE115606A083C16AB38AAE54894F2225378B2A533A86A8A744
            064581F928001E6B3C7900FF026484B86D9717D4A50000000049454E44AE4260
            82}
          ExplicitLeft = 20
          ExplicitTop = 25
          ExplicitHeight = 76
        end
        object Panel_dm2c: TPanel
          AlignWithMargins = True
          Left = 113
          Top = 23
          Width = 239
          Height = 84
          Margins.Left = 20
          Margins.Top = 23
          Margins.Bottom = 23
          Align = alClient
          BevelKind = bkSoft
          BevelOuter = bvNone
          ParentBackground = False
          ParentColor = True
          TabOrder = 0
          DesignSize = (
            235
            80)
          object Image2: TImage
            AlignWithMargins = True
            Left = 154
            Top = 65
            Width = 12
            Height = 12
            Hint = '{"radius":"5px","src":"/media/images/app0/heart.jpg"}'
            Margins.Left = 10
            Margins.Top = 23
            Margins.Bottom = 23
            Anchors = [akTop, akRight]
            Picture.Data = {
              0A544A504547496D6167653D030000FFD8FFE000104A46494600010101007800
              780000FFE100224578696600004D4D002A000000080001011200030000000100
              01000000000000FFDB0043000201010201010202020202020202030503030303
              030604040305070607070706070708090B0908080A0807070A0D0A0A0B0C0C0C
              0C07090E0F0D0C0E0B0C0C0CFFDB004301020202030303060303060C0807080C
              0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
              0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0CFFC0001108000C000C030122000211
              01031101FFC4001F000001050101010101010000000000000000010203040506
              0708090A0BFFC400B5100002010303020403050504040000017D010203000411
              05122131410613516107227114328191A1082342B1C11552D1F0243362728209
              0A161718191A25262728292A3435363738393A434445464748494A5354555657
              58595A636465666768696A737475767778797A838485868788898A9293949596
              9798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2
              D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F
              0100030101010101010101010000000000000102030405060708090A0BFFC400
              B511000201020404030407050404000102770001020311040521310612415107
              61711322328108144291A1B1C109233352F0156272D10A162434E125F1171819
              1A262728292A35363738393A434445464748494A535455565758595A63646566
              6768696A737475767778797A82838485868788898A92939495969798999AA2A3
              A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8
              D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C0301000211031100
              3F00FD70F027C1DD1BC79ACEBF69AB5D6ADA7F8EB4DD566FEDABAB7BD9629B55
              B096566893EF63ECB24051005C79650818239E6F4EF873E32F10EA5AACFF0007
              F5B8FC33E078EF5A0B585E66305D4A8A8B34D6E1B3884C819460E0B2391D6BD9
              BE2BFC16D1FE284F67717926A3637909166F73A7DC1B79AE6D656025B69187DE
              89F3C8EA0F208C9CF59A56996DA16976D63656F0DAD9DA44B0C10C4BB5224518
              0AA07400715D4CCB9AC7FFD9}
            ExplicitLeft = 147
          end
          object StaticText6: TStaticText
            AlignWithMargins = True
            Left = 0
            Top = 39
            Width = 56
            Height = 23
            Caption = #26102#20809#27969#36893
            Font.Charset = ANSI_CHARSET
            Font.Color = 13158600
            Font.Height = -13
            Font.Name = #24494#36719#38597#40657
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object StaticText5: TStaticText
            AlignWithMargins = True
            Left = 0
            Top = 22
            Width = 109
            Height = 23
            Caption = #31616#21333#20856#38597#30340#25163#34920
            Font.Charset = ANSI_CHARSET
            Font.Color = 6579300
            Font.Height = -15
            Font.Name = #24494#36719#38597#40657
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
          object Panel2: TPanel
            Left = 0
            Top = 0
            Width = 70
            Height = 20
            Hint = '{"borderradius":"10px"}'
            BevelOuter = bvNone
            Color = 16748617
            ParentBackground = False
            TabOrder = 2
            object Label1: TLabel
              Left = 0
              Top = 0
              Width = 70
              Height = 20
              Align = alClient
              Alignment = taCenter
              Caption = #22899#22763#29992
              Font.Charset = ANSI_CHARSET
              Font.Color = 15790320
              Font.Height = -13
              Font.Name = #24494#36719#38597#40657
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
              ExplicitWidth = 39
              ExplicitHeight = 19
            end
          end
          object StaticText_DM2_Price: TStaticText
            AlignWithMargins = True
            Left = 0
            Top = 58
            Width = 39
            Height = 23
            Caption = #165'59.0'
            Font.Charset = ANSI_CHARSET
            Font.Color = 16748617
            Font.Height = -13
            Font.Name = #24494#36719#38597#40657
            Font.Style = []
            ParentFont = False
            TabOrder = 3
          end
          object StaticText_DM2_Heart: TStaticText
            AlignWithMargins = True
            Left = 172
            Top = 58
            Width = 28
            Height = 23
            Anchors = [akTop, akRight]
            Caption = '236'
            Font.Charset = ANSI_CHARSET
            Font.Color = 13158600
            Font.Height = -13
            Font.Name = #24494#36719#38597#40657
            Font.Style = []
            ParentFont = False
            TabOrder = 4
          end
        end
      end
    end
  end
end
