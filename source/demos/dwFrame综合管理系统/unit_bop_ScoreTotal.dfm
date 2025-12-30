object Form_bop_ScoreTotal: TForm_bop_ScoreTotal
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #24635#25104#32489
  ClientHeight = 540
  ClientWidth = 989
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
  object Pn1: TPanel
    Left = 0
    Top = 0
    Width = 989
    Height = 540
    Hint = 
      '{"account":"dwGMS","table":"sys_Student","select":40,"visiblecol' +
      '":1,"import":0,"export":1,"new":0,"oneline":1,"defaulteditmax":0' +
      ',"defaultorder":"sId DESC","deletecols":[2],"fields":[{"name":"s' +
      'Id","caption":"id","align":"center","width":60,"sort":1,"type":"' +
      'auto"},{"name":"sName","caption":"'#22995#21517'","sort":1,"view":3,"align":' +
      '"center","width":70},{"name":"sGradeNum","caption":"'#24180#32423'","align":' +
      '"center","dbfilter":1,"view":3,"type":"combopair","list":[["11",' +
      '"'#23567#23398#19968#24180#32423'"],["12","'#23567#23398#20108#24180#32423'"],["13","'#23567#23398#19977#24180#32423'"],["14","'#23567#23398#22235#24180#32423'"],["15","'#23567#23398#20116 +
      #24180#32423'"],["16","'#23567#23398#20845#24180#32423'"],["21","'#21021#20013#19968#24180#32423'"],["22","'#21021#20013#20108#24180#32423'"],["23","'#21021#20013#19977#24180#32423'"]' +
      ',["31","'#39640#20013#19968#24180#32423'"],["32","'#39640#20013#20108#24180#32423'"],["33","'#39640#20013#19977#24180#32423'"]]},{"name":"sClassN' +
      'ame","caption":"'#29677#32423'","sort":1,"view":3,"dbfilter":1,"align":"cent' +
      'er","width":120},{"name":"sGender","caption":"","type":"combopai' +
      'r","dbfilter":1,"align":"center","list":[["1","'#30007'"],["2","'#22899'"]],"s' +
      'ort":1,"view":3,"width":50,"query":1},{"name":"sRegisterNum","ca' +
      'ption":"'#23398#31821#21495'","sort":1,"view":3,"align":"center","width":170},{"n' +
      'ame":"sScore","caption":"'#24635#20998'","view":3,"sort":1,"format":"%.1f","' +
      'align":"center","width":70},{"name":"sValue112","caption":"BMI",' +
      '"view":3,"sort":1,"align":"center","format":"%.1f","width":70},{' +
      '"name":"sScore112","caption":"","sort":1,"view":3,"align":"cente' +
      'r","width":50},{"name":"sValue100","caption":"'#36523#39640'","view":3,"sort' +
      '":1,"format":"%.1f","align":"center","width":70},{"name":"sValue' +
      '101","caption":"'#20307#37325'","view":3,"sort":1,"format":"%.1f","align":"c' +
      'enter","width":70},{"name":"sValue102","caption":"'#32954#27963#37327'","view":3,' +
      '"format":"%d","align":"center","width":70},{"name":"sScore102","' +
      'caption":"","sort":1,"view":3,"align":"center","width":35},{"nam' +
      'e":"sValue103","caption":"'#32954#27963#37327'","view":3,"format":"%.2f","align":' +
      '"center","width":70},{"name":"sScore103","caption":"","sort":1,"' +
      'view":3,"align":"center","width":35},{"name":"sValue104","captio' +
      'n":"'#22352#20301#20307#21069#23624'","view":3,"format":"%.1f","align":"center","width":70}' +
      ',{"name":"sScore104","caption":"","sort":1,"view":3,"align":"cen' +
      'ter","width":35},{"name":"sValue105","caption":"'#31435#23450#36339#36828'","view":3,"' +
      'align":"center","width":70},{"name":"sScore105","caption":"","so' +
      'rt":1,"view":3,"align":"center","width":35},{"name":"sValue106",' +
      '"caption":"800'#31859#36305'","view":3,"format":"seconds","align":"center","' +
      'width":70},{"name":"sScore106","caption":"","sort":1,"view":3,"a' +
      'lign":"center","width":35},{"name":"sValue107","caption":"1000'#31859#36305 +
      '","format":"seconds","view":3,"align":"center","width":70},{"nam' +
      'e":"sScore107","caption":"","sort":1,"view":3,"align":"center","' +
      'width":35},{"name":"sValue108","caption":"'#19968#20998#38047#20208#21351#36215#22352'","view":3,"ali' +
      'gn":"center","width":70},{"name":"sScore108","caption":"","sort"' +
      ':1,"view":3,"align":"center","width":35},{"name":"sValue109","ca' +
      'ption":"'#19968#20998#38047#20208#21351#36215#22352'","view":3,"align":"center","width":70},{"name":"' +
      'sScore109","caption":"","sort":1,"view":3,"align":"center","widt' +
      'h":35},{"name":"sValue110","caption":"'#19968#20998#38047#36339#32499'","view":3,"align":"c' +
      'enter","width":70},{"name":"sScore110","caption":"","sort":1,"vi' +
      'ew":3,"align":"center","width":35},{"name":"sValue111","caption"' +
      ':"50'#31859'X8'#24448#36820#36305'","format":"seconds","view":3,"align":"center","width"' +
      ':70},{"name":"sScore111","caption":"","sort":1,"view":3,"align":' +
      '"center","width":35},{"name":"sRemark","caption":"'#22791#27880'","width":60' +
      ',"query":1}]}'
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Pn1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object Bt1: TButton
      Left = 520
      Top = 112
      Width = 90
      Height = 25
      Hint = '{"type":"success"}'
      Caption = #26356#26032#25968#25454
      TabOrder = 0
      OnClick = Bt1Click
    end
  end
  object FDQuery1: TFDQuery
    Left = 528
    Top = 184
  end
end
