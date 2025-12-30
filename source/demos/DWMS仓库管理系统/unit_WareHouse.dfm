object Form_WareHouse: TForm_WareHouse
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #20179#24211#31649#29702
  ClientHeight = 540
  ClientWidth = 360
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OnShow = FormShow
  TextHeight = 23
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 360
    Height = 540
    Hint = 
      '{"account":"dwERP","table":"eWareHouse","fields":[{"name":"wId",' +
      '"caption":"id","sort":1,"width":60,"type":"auto","align":"center' +
      '"},{"name":"wActive","caption":"'#22312#29992'","sort":1,"width":100,"type":' +
      '"boolean","align":"center","caption":"gActive","query":1,"dbfilt' +
      'er":1,"list":["'#9675'","'#9679'"]},{"name":"wName","caption":"'#21517#31216'","sort":1,' +
      '"query":1,"dbfilter":1},{"name":"wLocation","caption":"'#20301#32622'","sort' +
      '":1,"width":200,"query":1},{"name":"wManager","caption":"'#36127#36131#20154'","s' +
      'ort":1,"align":"center","width":100,"dbfilter":1,"query":1},{"na' +
      'me":"wCapacity","caption":"'#23481#31215'","sort":1,"width":100,"type":"inte' +
      'ger","align":"right","query":0},{"name":"wAvailableSpace","capti' +
      'on":"'#21487#29992#31354#38388'","sort":1,"width":140,"type":"integer","align":"right"' +
      ',"query":0},{"name":"wRemark","caption":"'#22791#27880'","sort":1,"width":20' +
      '0,"query":1}]}'
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
  end
end
