object Form1: TForm1
  Left = 0
  Top = 0
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'DeWeb'
  ClientHeight = 619
  ClientWidth = 1000
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnCreate = FormCreate
  OnMouseUp = FormMouseUp
  TextHeight = 21
  object L_Prov: TLabel
    Left = 32
    Top = 29
    Width = 128
    Height = 21
    AutoSize = False
    Caption = #30465'/'#33258#27835#21306'/'#30452#36758#24066
    Font.Charset = ANSI_CHARSET
    Font.Color = clGray
    Font.Height = -16
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 176
    Top = 29
    Width = 124
    Height = 21
    AutoSize = False
    Caption = #24066
    Font.Charset = ANSI_CHARSET
    Font.Color = clGray
    Font.Height = -16
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 312
    Top = 29
    Width = 128
    Height = 21
    AutoSize = False
    Caption = #21306'/'#21439
    Font.Charset = ANSI_CHARSET
    Font.Color = clGray
    Font.Height = -16
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
  end
  object CB_Prov: TComboBox
    Left = 20
    Top = 56
    Width = 140
    Height = 29
    Hint = '{"dwattr":"filterable","dwstyle":"border-radius:4px 0 0 4px;"}'
    Style = csDropDownList
    TabOrder = 0
    OnChange = CB_ProvChange
  end
  object CB_City: TComboBox
    Left = 160
    Top = 56
    Width = 140
    Height = 29
    Hint = 
      '{"dwattr":"filterable autocomplete=\"new-password\"","dwstyle":"' +
      'border-radius:0px;"}'
    Style = csDropDownList
    TabOrder = 1
    OnChange = CB_CityChange
  end
  object CB_Dist: TComboBox
    Left = 300
    Top = 56
    Width = 140
    Height = 29
    Hint = '{"dwattr":"filterable","dwstyle":"border-radius:0 4px 4px 0;"}'
    Style = csDropDownList
    TabOrder = 2
  end
  object B_Set: TButton
    Left = 20
    Top = 104
    Width = 130
    Height = 33
    Hint = '{"type":"primary"}'
    Caption = #35774#32622
    TabOrder = 3
    OnClick = B_SetClick
  end
  object B_Get: TButton
    Left = 160
    Top = 104
    Width = 130
    Height = 33
    Hint = '{"type":"success"}'
    Caption = #21462#20540
    TabOrder = 4
    OnClick = B_GetClick
  end
end
