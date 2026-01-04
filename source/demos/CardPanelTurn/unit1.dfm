object Form1: TForm1
  Left = 0
  Top = 0
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'CardPanelTurn'
  ClientHeight = 638
  ClientWidth = 527
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  StyleName = 
    '{"theme":{"index":0,"items":[{"name":"'#40664#35748'","logobk":"#222e41","lo' +
    'gofont":"#FFFFFF","bannerbk":"#f5f7fa","bannerfont":"#5C5C5C","m' +
    'enubk":"#304156","menuactive":"#333333","menuhover":"#333333","m' +
    'enuactivefont":"#FFD04B","menufont":"#FFFFFF"},{"name":"'#33509#20381'","log' +
    'obk":"#127EA2","logofont":"#ffffff","bannerbk":"#018CB5","banner' +
    'font":"#ffffff","menubk":"#0A2D4D","menuactive":"#088EFD","menuh' +
    'over":"#088EFD","menufont":"#ffffff"},{"name":"'#33150#35759#20113'","logobk":"#2' +
    '62F40","logofont":"#A1ABB7","bannerbk":"#262F3E","bannerfont":"#' +
    'A1ABB7","menubk":"#1E222D","menuactive":"#006FFF","menuhover":"#' +
    '272E3E","menufont":"#A1ABB7"},{"name":"'#34013#33394#28165#29245'","logobk":"#2945CC",' +
    '"logofont":"#ffffff","bannerbk":"#ffffff","bannerfont":"#646464"' +
    ',"menubk":"#2945CC","menuactive":"#ffffff","menuactivefont":"#33' +
    '3333","menuhover":"#7E8EFD","menufont":"#ffffff"},{"name":"'#32418#33394#28608#24773'"' +
    ',"logobk":"#B81C24","logofont":"#FFEE75","bannerbk":"#D8162C","b' +
    'annerfont":"#FFEE75","menubk":"#F0F0F0","menuactive":"#D8162C","' +
    'menuactivefont":"#FFEE75","menuhover":"#D8162C","menufont":"#333' +
    '333"}]}}'
  OnMouseDown = FormMouseDown
  OnMouseUp = FormMouseUp
  OnShow = FormShow
  TextHeight = 21
  object P_Banner: TPanel
    Left = 0
    Top = 0
    Width = 527
    Height = 50
    Align = alTop
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object Label1: TLabel
      AlignWithMargins = True
      Left = 16
      Top = 4
      Width = 507
      Height = 42
      Margins.Left = 15
      Align = alClient
      Caption = #32763#20070#25928#26524' CardPanel__turn'
      Font.Charset = ANSI_CHARSET
      Font.Color = 3289650
      Font.Height = -19
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 232
      ExplicitHeight = 25
    end
  end
  object CardPanel1: TCardPanel
    AlignWithMargins = True
    Left = 50
    Top = 70
    Width = 427
    Height = 518
    Hint = '{"display":"single","acceleration":1}'
    HelpType = htKeyword
    HelpKeyword = 'turn'
    Margins.Left = 50
    Margins.Top = 20
    Margins.Right = 50
    Margins.Bottom = 50
    Align = alClient
    ActiveCard = Card7
    BevelOuter = bvNone
    Caption = 'CardPanel1'
    TabOrder = 1
    object Card1: TCard
      Left = 0
      Top = 0
      Width = 427
      Height = 518
      Caption = 'Card1'
      CardIndex = 0
      TabOrder = 0
      ExplicitWidth = 527
      ExplicitHeight = 588
      object Image1: TImage
        Left = 0
        Top = 0
        Width = 427
        Height = 518
        Hint = '{"src":"media/images/mn/1.jpg"}'
        Align = alClient
        Stretch = True
        ExplicitLeft = -172
        ExplicitWidth = 472
        ExplicitHeight = 200
      end
    end
    object Card2: TCard
      Left = 0
      Top = 0
      Width = 427
      Height = 518
      Caption = 'Card2'
      CardIndex = 1
      TabOrder = 1
      ExplicitWidth = 527
      ExplicitHeight = 588
      object Image2: TImage
        Left = 0
        Top = 0
        Width = 427
        Height = 518
        Hint = '{"src":"media/images/mn/2.jpg"}'
        Align = alClient
        Stretch = True
        ExplicitLeft = -172
        ExplicitWidth = 472
        ExplicitHeight = 200
      end
    end
    object Card3: TCard
      Left = 0
      Top = 0
      Width = 427
      Height = 518
      Caption = 'Card3'
      CardIndex = 2
      TabOrder = 2
      ExplicitWidth = 527
      ExplicitHeight = 588
      object Image3: TImage
        Left = 0
        Top = 0
        Width = 427
        Height = 518
        Hint = '{"src":"media/images/mn/3.jpg"}'
        Align = alClient
        Stretch = True
        ExplicitLeft = -172
        ExplicitWidth = 472
        ExplicitHeight = 200
      end
    end
    object Card4: TCard
      Left = 0
      Top = 0
      Width = 427
      Height = 518
      Caption = 'Card4'
      CardIndex = 3
      TabOrder = 3
      ExplicitWidth = 527
      ExplicitHeight = 588
      object Image4: TImage
        Left = 0
        Top = 0
        Width = 427
        Height = 518
        Hint = '{"src":"media/images/mn/4.jpg"}'
        Align = alClient
        Stretch = True
        ExplicitLeft = -172
        ExplicitWidth = 472
        ExplicitHeight = 200
      end
    end
    object Card5: TCard
      Left = 0
      Top = 0
      Width = 427
      Height = 518
      Caption = 'Card5'
      CardIndex = 4
      TabOrder = 4
      ExplicitWidth = 527
      ExplicitHeight = 588
      object Image5: TImage
        Left = 0
        Top = 0
        Width = 427
        Height = 518
        Hint = '{"src":"media/images/mn/5.jpg"}'
        Align = alClient
        Stretch = True
        ExplicitLeft = -172
        ExplicitWidth = 472
        ExplicitHeight = 200
      end
    end
    object Card6: TCard
      Left = 0
      Top = 0
      Width = 427
      Height = 518
      Caption = 'Card6'
      CardIndex = 5
      TabOrder = 5
      ExplicitWidth = 527
      ExplicitHeight = 588
      object Image6: TImage
        Left = 0
        Top = 0
        Width = 427
        Height = 518
        Hint = '{"src":"media/images/mn/6.jpg"}'
        Align = alClient
        Stretch = True
        ExplicitLeft = 8
        ExplicitWidth = 472
        ExplicitHeight = 498
      end
    end
    object Card7: TCard
      Left = 0
      Top = 0
      Width = 427
      Height = 518
      Caption = 'Card7'
      CardIndex = 6
      TabOrder = 6
      object Image7: TImage
        Left = 0
        Top = 0
        Width = 427
        Height = 518
        Hint = '{"src":"media/images/mn/7.jpg"}'
        Align = alClient
        Stretch = True
        ExplicitLeft = -32
        ExplicitTop = -96
        ExplicitWidth = 472
        ExplicitHeight = 498
      end
    end
  end
end
