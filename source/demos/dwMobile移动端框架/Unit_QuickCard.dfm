object Form_QuickCard: TForm_QuickCard
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Form_QuickCard'
  ClientHeight = 565
  ClientWidth = 351
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  StyleName = 
    '{"table":"dmMember","pagesize":5,"cardheight":150,"cardheight":1' +
    '60,"cardmargins":[10,1,10,9],"cardcolor":[250,250,250],"cardstyl' +
    'e":"background-image: linear-gradient(120deg, #84fab0 0%, #8fd3f' +
    '4 100%);border-radius:10px;","radius":0,"defaultquerymode":1,"de' +
    'faulteditmax":1,"buttoncaption":2,"switch":0,"fields":[{"type":"' +
    'string","name":"mName","caption":"'#22995#21517'","query":1,"left":130,"top"' +
    ':15,"width":180,"fontsize":24,"must":1,"default":"'#26410#21629#21517'","sort":1}' +
    ',{"name":"mheadship","query":1,"caption":"'#32844#21153'","width":100,"sort"' +
    ':1},{"name":"msalary","type":"money","caption":"'#24037#36164'","format":"'#65509'%' +
    'n","width":120},{"name":"maddr","caption":"'#22320#22336'","height":50,"dwst' +
    'yle":"word-wrap:normal;","left":130,"right":20},{"name":"mPhoto"' +
    ',"caption":"'#30456#29255'","left":20,"top":20,"height":80,"width":80,"imgdi' +
    'r":"media/images/mm/","dwstyle":"background:#fff;border-radius:4' +
    '0px;","type":"image"}]}'
  OnShow = FormShow
  TextHeight = 15
  object P0: TPanel
    Left = 0
    Top = 0
    Width = 351
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    Color = 16359209
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object L0: TLabel
      AlignWithMargins = True
      Left = 50
      Top = 3
      Width = 251
      Height = 44
      Margins.Left = 0
      Margins.Right = 50
      Align = alClient
      Alignment = taCenter
      Caption = #20154#21592#31649#29702
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -20
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 80
      ExplicitHeight = 27
    end
    object B0: TButton
      Left = 0
      Top = 0
      Width = 50
      Height = 50
      Hint = 
        '{"type":"text","icon":"el-icon-arrow-left","onclick":"try{histor' +
        'y.back()}finally{};"}'
      Align = alLeft
      Cancel = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -23
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
end
