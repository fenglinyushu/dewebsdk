object Form_sys_Message: TForm_sys_Message
  Left = 0
  Top = 0
  HelpKeyword = 'embed'
  BorderStyle = bsNone
  Caption = #31995#32479#28040#24687
  ClientHeight = 658
  ClientWidth = 800
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clGray
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnMouseDown = FormMouseDown
  OnShow = FormShow
  TextHeight = 20
  object Pn1: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 658
    Hint = 
      '{"account":"dwFrame","table":"sys_Message","visiblecol":1,"delet' +
      'ecols":[2,6],"new":0,"edit":0,"import":0,"switch":0,"defaultorde' +
      'r":"mStatus,mCreateDateTime DESC","defaultquerymode":1,"select":' +
      '40,"fields":[{"name":"mId","caption":"'#32534#21495'","align":"center","widt' +
      'h":60,"type":"auto"},{"name":"mCreatorId","caption":"'#21457#36865#20154'","type"' +
      ':"dbcombopair","sort":1,"width":100,"align":"center","table":"sy' +
      's_User","datafield":"uId","viewfield":"uName"},{"name":"mTargetI' +
      'd","caption":"'#25509#25910#20154'","type":"dbcombopair","sort":1,"width":100,"al' +
      'ign":"center","table":"sys_User","datafield":"uId","viewfield":"' +
      'uName"},{"name":"mType","caption":"'#31867#21035'","type":"combo","align":"c' +
      'enter","must":1,"sort":1,"dbfilter":1,"list":["'#36890#30693'","'#23457#25209'","'#20854#20182'"],"w' +
      'idth":90},{"name":"mCreateDateTime","caption":"'#26085#26399'","type":"datet' +
      'ime","align":"center","width":160,"sort":1},{"name":"mData","cap' +
      'tion":"'#20869#23481'","query":1,"sort":1,"width":300},{"name":"mStatus","ca' +
      'ption":"'#29366#24577'","type":"combo","align":"center","must":1,"sort":1,"d' +
      'bfilter":1,"list":["'#24453#38405'","'#24050#38405'"],"width":90},{"name":"mRemark","cap' +
      'tion":"'#22791#27880'","sort":1,"width":80,"query":1},{"name":"mId","caption' +
      '":"","type":"button","width":90,"list":[{"caption":"'#26631#35760#24050#38405'","type"' +
      ':"primary","width":80,"method":"custom"}]}]}'
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Pn1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    OnDragOver = Pn1DragOver
  end
  object BtAll: TButton
    Left = 600
    Top = 224
    Width = 75
    Height = 33
    Hint = '{"type":"primary"}'
    Caption = #26412#39029#20840#38405
    TabOrder = 1
    OnClick = BtAllClick
  end
  object FDQuery1: TFDQuery
    Left = 106
    Top = 361
  end
end
