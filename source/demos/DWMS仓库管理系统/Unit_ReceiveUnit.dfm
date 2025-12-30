object Form_ReceiveUnit: TForm_ReceiveUnit
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #39046#26009#21333#20301#31649#29702
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
      '{"account":"dwERP","table":"eReceiveUnit","fields":[{"name":"rId' +
      '","caption":"id","sort":1,"width":60,"type":"auto","align":"cent' +
      'er"},{"name":"rName","caption":"'#21517#31216'","sort":1,"query":1,"width":2' +
      '00},{"name":"rNo","caption":"'#32534#30721'","sort":1,"query":1,"align":"cen' +
      'ter","width":80},{"name":"rContactName","caption":"'#32852#31995#20154'","align":' +
      '"center","sort":1,"width":90,"query":1},{"name":"rPhone","captio' +
      'n":"'#30005#35805'","sort":1,"width":140,"query":1},{"name":"rEmail","captio' +
      'n":"'#37038#31665'","sort":1,"width":200},{"name":"rAddress","caption":"'#22320#22336'",' +
      '"sort":1,"width":220,"query":1},{"name":"rCreateDate","caption":' +
      '"'#21019#24314#26085#26399'","type":"date","align":"center","sort":1,"width":120},{"na' +
      'me":"rRemark","caption":"'#22791#27880'","sort":1,"width":150,"query":1}]}'
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
