object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'DeWeb - Clients Managemaent System'
  ClientHeight = 850
  ClientWidth = 1000
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 20
  object SG: TStringGrid
    Left = 200
    Top = 50
    Width = 800
    Height = 528
    Color = clWhite
    ColCount = 10
    DefaultColWidth = 50
    DefaultRowHeight = 48
    FixedCols = 0
    RowCount = 11
    TabOrder = 0
    OnClick = SGClick
  end
  object TreeView: TTreeView
    Left = 0
    Top = 50
    Width = 200
    Height = 528
    Color = 16448250
    Indent = 19
    TabOrder = 2
    OnClick = TreeViewClick
    Items.NodeData = {
      0301000000240000000000000000000000FFFFFFFFFFFFFFFF00000000000000
      000200000001031A90AF8B555F240000000000000000000000FFFFFFFFFFFFFF
      FF00000000000000000000000001034100410041002400000000000000000000
      00FFFFFFFFFFFFFFFF0100000000000000000000000103420042004200}
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 200
    Height = 50
    BevelOuter = bvNone
    Color = 6577236
    ParentBackground = False
    TabOrder = 1
    object Label1: TLabel
      Left = 84
      Top = 13
      Width = 132
      Height = 25
      AutoSize = False
      Caption = #23458#25143#31649#29702#31995#32479
      Font.Charset = GB2312_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 12
      Top = 8
      Width = 65
      Height = 31
      Caption = 'CRM.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clLime
      Font.Height = -24
      Font.Name = #24494#36719#38597#40657
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
    end
  end
  object Panel2: TPanel
    Left = 800
    Top = 0
    Width = 200
    Height = 50
    BevelOuter = bvNone
    Color = 6577236
    ParentBackground = False
    TabOrder = 3
    object Edit_Search: TEdit
      Left = 50
      Top = 7
      Width = 143
      Height = 28
      Hint = '{"placeholder":"'#25628#32034'"}'
      TabOrder = 0
    end
  end
  object Panel_Edit: TPanel
    Left = 197
    Top = 577
    Width = 800
    Height = 46
    TabOrder = 4
    Visible = False
    object Edit1: TEdit
      Left = 2
      Top = 5
      Width = 68
      Height = 28
      AutoSize = False
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 70
      Top = 5
      Width = 50
      Height = 28
      AutoSize = False
      TabOrder = 1
    end
    object Edit3: TEdit
      Left = 120
      Top = 5
      Width = 50
      Height = 28
      AutoSize = False
      TabOrder = 2
    end
    object Edit4: TEdit
      Left = 170
      Top = 5
      Width = 50
      Height = 28
      AutoSize = False
      TabOrder = 3
    end
    object Edit5: TEdit
      Left = 220
      Top = 5
      Width = 100
      Height = 28
      AutoSize = False
      TabOrder = 4
    end
    object Edit6: TEdit
      Left = 320
      Top = 5
      Width = 50
      Height = 28
      AutoSize = False
      TabOrder = 5
    end
    object Edit7: TEdit
      Left = 370
      Top = 5
      Width = 50
      Height = 28
      AutoSize = False
      TabOrder = 6
    end
    object Edit8: TEdit
      Left = 420
      Top = 5
      Width = 50
      Height = 28
      AutoSize = False
      TabOrder = 7
    end
    object Edit9: TEdit
      Left = 470
      Top = 5
      Width = 150
      Height = 28
      AutoSize = False
      TabOrder = 8
    end
    object Edit10: TEdit
      Left = 620
      Top = 5
      Width = 178
      Height = 28
      AutoSize = False
      TabOrder = 9
    end
  end
  object MainMenu: TMainMenu
    AutoHotkeys = maManual
    Left = 293
    Top = 65533
    object MenuItem_Add: TMenuItem
      Caption = #22686#21152
      OnClick = MenuItem_AddClick
    end
    object MenuItem_Edit: TMenuItem
      Caption = #32534#36753
      OnClick = MenuItem_EditClick
    end
    object MenuItem_Delete: TMenuItem
      Caption = #21024#38500
      OnClick = MenuItem_DeleteClick
    end
    object MenuItem_Save: TMenuItem
      Caption = #20445#23384
      OnClick = MenuItem_SaveClick
    end
    object MenuItem_Cancel: TMenuItem
      Caption = #21462#28040
      OnClick = MenuItem_CancelClick
    end
    object MenuItem_Prev: TMenuItem
      Caption = #19978#19968#39029
      OnClick = MenuItem_PrevClick
    end
    object MenuItem_Next: TMenuItem
      Caption = #19979#19968#39029
      OnClick = MenuItem_NextClick
    end
    object MenuItem_About: TMenuItem
      Caption = #20851#20110
      OnClick = MenuItem_AboutClick
    end
  end
  object ADOQuery: TADOQuery
    Parameters = <>
    Left = 48
    Top = 112
  end
end
