object Form1: TForm1
  Left = 0
  Top = 0
  VertScrollBar.Visible = False
  BorderStyle = bsNone
  BorderWidth = 5
  Caption = 'DeWeb'
  ClientHeight = 790
  ClientWidth = 990
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 990
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object Image1: TImage
      AlignWithMargins = True
      Left = 15
      Top = 3
      Width = 58
      Height = 54
      Hint = '{"src":"media/images/internet/1.jpg"}'
      Margins.Left = 15
      Align = alLeft
    end
    object Label1: TLabel
      AlignWithMargins = True
      Left = 91
      Top = 3
      Width = 498
      Height = 54
      Margins.Left = 15
      Align = alLeft
      Caption = #21335#23433#30465#20114#32852#32593'+'#32844#19994#30149#38450#27835#19982#32844#19994#20581#24247#31649#29702#31995#32479
      Font.Charset = ANSI_CHARSET
      Font.Color = 6321236
      Font.Height = -24
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitHeight = 31
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 60
    Width = 990
    Height = 600
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 250
      Height = 600
      Align = alLeft
      BevelOuter = bvNone
      Color = 3484198
      ParentBackground = False
      TabOrder = 0
    end
    object PageControl1: TPageControl
      Left = 250
      Top = 0
      Width = 740
      Height = 600
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 1
      object TabSheet1: TTabSheet
        Caption = #39318#39029
        ImageIndex = 56
        object Panel4: TPanel
          Left = 0
          Top = 0
          Width = 732
          Height = 100
          Align = alTop
          BevelKind = bkFlat
          BevelOuter = bvNone
          Color = clWhite
          ParentBackground = False
          TabOrder = 0
          object Label2: TLabel
            Left = 16
            Top = 14
            Width = 60
            Height = 20
            Caption = #36523#20221#35777#21495
          end
          object Label3: TLabel
            Left = 16
            Top = 58
            Width = 60
            Height = 20
            Caption = #20225#19994#21517#31216
          end
          object Label4: TLabel
            Left = 297
            Top = 14
            Width = 30
            Height = 20
            Caption = #24615#21035
          end
          object Label5: TLabel
            Left = 448
            Top = 14
            Width = 30
            Height = 20
            Caption = #24037#31181
          end
          object Edit1: TEdit
            Left = 80
            Top = 12
            Width = 209
            Height = 28
            Hint = '{"placeholder":"'#31934#30830#21305#37197'"}'
            TabOrder = 0
          end
          object Edit2: TEdit
            Left = 82
            Top = 56
            Width = 210
            Height = 28
            Hint = '{"placeholder":"'#31934#30830#21305#37197'"}'
            TabOrder = 1
          end
          object Edit4: TEdit
            Left = 498
            Top = 12
            Width = 207
            Height = 28
            Hint = '{"placeholder":"'#31934#30830#21305#37197'"}'
            TabOrder = 2
          end
          object ComboBox1: TComboBox
            Left = 342
            Top = 12
            Width = 84
            Height = 28
            TabOrder = 3
            Text = #35831#36873#25321
            Items.Strings = (
              #30007
              #22899)
          end
          object Button1: TButton
            Left = 632
            Top = 58
            Width = 75
            Height = 31
            Hint = '{"type":"primary"}'
            Caption = #26597#35810
            TabOrder = 4
          end
        end
        object StringGrid1: TStringGrid
          AlignWithMargins = True
          Left = 3
          Top = 119
          Width = 726
          Height = 436
          Hint = '{"dwstyle":"stripe border","background":"#f5f7fA"}'
          Margins.Top = 19
          Margins.Bottom = 10
          Align = alClient
          DefaultColWidth = 100
          DefaultRowHeight = 37
          RowCount = 11
          TabOrder = 1
        end
      end
      object TabSheet2: TTabSheet
        Caption = #25253#21578#26597#35810
        ImageIndex = 1
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
      end
      object TabSheet3: TTabSheet
        Caption = #25253#21578#23548#20986
        ImageIndex = 2
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
      end
      object TabSheet4: TTabSheet
        Caption = #26426#26500#20449#24687
        ImageIndex = 3
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
      end
    end
  end
  object MainMenu: TMainMenu
    AutoHotkeys = maManual
    OwnerDraw = True
    Left = 85
    Top = 117
    object MenuItem2: TMenuItem
      Caption = #26426#26500#20449#24687#31649#29702
      Hint = '{"background-color":"rgb(38,42,53)"}'
      ImageIndex = 56
    end
    object MenuItem1: TMenuItem
      Caption = #20307#26816#25253#21578#31649#29702
      ImageIndex = 139
      object N2: TMenuItem
        Caption = #25253#21578#26597#35810
      end
      object N4: TMenuItem
        Caption = #25253#21578#23548#20986
      end
    end
    object MenuItem3: TMenuItem
      Caption = #26426#26500#22791#26696#31649#29702
      ImageIndex = 146
    end
    object N1: TMenuItem
      Caption = #32844#19994#30149#38450#27835#35843#26597#31649#29702
      ImageIndex = 187
    end
    object N3: TMenuItem
      Caption = #31995#32479#31649#29702
      ImageIndex = 6
      object N5: TMenuItem
        Caption = #25968#25454#22791#20221
      end
      object N6: TMenuItem
        Caption = #25968#25454#24674#22797
      end
    end
  end
end
