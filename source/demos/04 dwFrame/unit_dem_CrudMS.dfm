object Form_dem_CrudMS: TForm_dem_CrudMS
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Crud Main-Sub'
  ClientHeight = 540
  ClientWidth = 946
  Color = clBtnFace
  TransparentColor = True
  TransparentColorValue = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OnShow = FormShow
  TextHeight = 23
  object SlR: TSplitter
    Left = 0
    Top = 196
    Width = 946
    Height = 7
    Cursor = crVSplit
    Hint = '{"link":"PnB"}'
    Align = alBottom
    ExplicitLeft = 939
    ExplicitTop = 0
    ExplicitWidth = 230
  end
  object Pn1: TPanel
    Left = 0
    Top = 0
    Width = 946
    Height = 196
    Hint = 
      '{"account":"dwFrame","deletecols":[3,4],"batch":0,"import":0,"ex' +
      'port":1,"rowheight":40,"select":40,"pagesize":10,"table":"bop_co' +
      'ntract","visiblecol":1,"defaultorder":"cid DESC","dwstyle":"user' +
      '-select: text;","slave":[{"panel":"PnP","masterfield":"cId","sla' +
      'vefield":"pCId"}],"fields":[{"name":"cid","caption":"'#32534#21495'","align"' +
      ':"center","width":50,"type":"auto"},{"name":"cUserID","caption":' +
      '"'#19994#21153#21592'","type":"dbcombopair","sort":1,"view":3,"readonly":1,"query' +
      '":1,"width":100,"dbfilter":1,"align":"center","table":"sys_user"' +
      ',"datafield":"uid","viewfield":"uname"},{"name":"cProductionSupe' +
      'rvisorId","caption":"'#29983#20135#20027#31649'","type":"dbcombopair","sort":1,"query"' +
      ':1,"width":120,"dbfilter":1,"align":"center","table":"sys_user",' +
      '"datafield":"uId","viewfield":"uName","viewdefault":"-"},{"name"' +
      ':"cPI_NO","caption":"PI'#21495'","sort":1,"query":1,"view":3,"width":16' +
      '0},{"name":"cOrderStatus","caption":"'#35746#21333#29366#24577'","align":"center","dbf' +
      'ilter":1,"type":"combo","list":["'#24050#23436#32467'","'#24050#25237#20135'","'#31561#24453#23450#37329'","'#21487#29305#27530#20808#34892'","'#24322#24120#29366#24577 +
      '"],"default":"'#31561#24453#23450#37329'","sort":1,"width":120,"query":1},{"name":"cDe' +
      'tail","caption":"'#20135#21697#28165#21333'","sort":1,"query":1,"view":2,"width":150},' +
      '{"name":"cCustomerId","caption":"'#23458#25143'","sort":1,"dbfilter":1,"widt' +
      'h":160,"type":"dbcombopair","table":"dic_customer","datafield":"' +
      'cId","viewfield":"cName"},{"name":"cEntryDate","caption":"'#24405#20837#26085#26399'",' +
      '"type":"date","align":"center","width":100,"sort":1},{"name":"cE' +
      'TD","caption":"'#20132#26399'ETD","type":"date","align":"center","width":100' +
      ',"sort":1},{"name":"cRemark","caption":"'#22791#27880'","sort":1,"width":70,' +
      '"query":1}]}'
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Pn1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    OnDragOver = Pn1DragOver
  end
  object PnB: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 203
    Width = 946
    Height = 337
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'PnB'
    ParentBackground = False
    TabOrder = 1
    object PnP: TPanel
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 946
      Height = 337
      Hint = 
        '{"account":"dwFrame","batch":1,"defaulteditmax":0,"deletecols":[' +
        '1],"export":0,"import":0,"pagesize":5,"prefix":"x","rowheight":3' +
        '5,"select":40,"switch":0,"table":"bop_ContractProduct","visiblec' +
        'ol":1,"master":{"panel":"Pn1","masterfield":"cId","slavefield":"' +
        'pCId"},"fields":[{"name":"pId","view":2},{"name":"pCId","view":2' +
        '},{"name":"pProductid","caption":"'#20135#21697#21517#31216'","width":120,"type":"dbco' +
        'mbopair","table":"bop_Product","datafield":"pId","viewfield":"pN' +
        'ame","viewdefault":"","sort":1,"listcount":-1},{"name":"pFactory' +
        'Id","caption":"'#20135#21697#24037#21378'","width":160,"type":"dbcombopair","table":"d' +
        'ic_Factory","datafield":"fId","viewfield":"fName","sort":1,"view' +
        'default":""},{"name":"pProductid as a1","caption":"'#20135#21697#26448#36136'","width"' +
        ':120,"type":"dbcombopair","table":"bop_Product","datafield":"pId' +
        '","viewfield":"pMaterial","view":3,"sort":1,"viewdefault":""}]}'
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alClient
      BevelOuter = bvNone
      Caption = 'PnP'
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object PnPT: TPanel
        Left = 0
        Top = 0
        Width = 946
        Height = 30
        Hint = '{"dwstyle":"border-bottom:solid 1px #ddd;"}'
        Align = alTop
        BevelOuter = bvNone
        Color = 16448250
        ParentBackground = False
        TabOrder = 0
        object LaT1: TLabel
          AlignWithMargins = True
          Left = 20
          Top = 3
          Width = 906
          Height = 24
          Margins.Left = 20
          Margins.Right = 20
          Align = alClient
          Alignment = taCenter
          AutoSize = False
          Caption = #21512#21516#20135#21697
          Font.Charset = ANSI_CHARSET
          Font.Color = clGray
          Font.Height = -15
          Font.Name = #24494#36719#38597#40657
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
          ExplicitLeft = 17
          ExplicitTop = -1
          ExplicitWidth = 480
        end
      end
    end
  end
end
