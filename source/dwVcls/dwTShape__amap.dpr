library dwTShape__amap;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     SysUtils,
     Buttons,
     ExtCtrls,
     Classes,
     Dialogs,
     StdCtrls,
     Windows,
     Controls,
     Forms;

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):String;stdCall;
var
    joRes   : Variant;
    joHint  : Variant;
begin
    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //生成返回值数组
    joRes    := _Json('[]');

    //
    //joRes.Add('<script src="https://webapi.amap.com/maps?v=2.0&key=你的高德地图API密钥"></script>');

    //
    if joHint.Exists('key') then begin
        joRes.Add('<script src="https://webapi.amap.com/maps?v=2.0&key='+joHint.key+'"></script>');
    end else begin
        joRes.Add('<script src="https://webapi.amap.com/maps?v=2.0&key=af99d484cfcb8108469b7bb0900effdc"></script>');
    end;

    //
    Result    := joRes;


end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):String;StdCall;
var
     joData    : Variant;
begin
     //
     joData    := _Json(AData);

     if joData.name = 'onenddock' then begin
          TShape(ACtrl).HelpKeyword     := joData.v;
          if Assigned(TShape(ACtrl).OnEndDock) then begin
               TShape(ACtrl).OnEndDock(TShape(ACtrl),nil,0,0);
          end;
     end;

     //
     result    := '[]';
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):String;StdCall;
var
    sCode   : String;
    sFull   : string;
    //
    joHint  : Variant;
    joRes   : Variant;

begin
    //生成返回值数组
    joRes   := _Json('[]');

    //取得HINT对象JSON
    joHint  := dwGetHintJson(TControl(ACtrl));

    //
    sFull   := dwFullName(Actrl);

    //
    with TShape(ACtrl) do begin
        //
        sCode   := '<div'
                +' id="'+sFull+'"'
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                +dwGetDWAttr(joHint)
                +dwLTWH(TControl(ACtrl))
                +'position:absolute;'
                //+'border: '+IntToStr(Pen.Width)+'px solid '+dwColor(Pen.Color)
                //+'width=100%;height=100%;'
                //+'object-fit: fill;'
                +dwGetDWStyle(joHint)
                +'"'
                //+dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
                //+dwIIF(Assigned(OnEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),'')
                //+dwIIF(Assigned(OnExit),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),'')
                +'>';
    end;
    joRes.Add(sCode);

    Result    := (joRes);
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //生成返回值数组
     joRes.Add('</div>');
     //
     Result    := (joRes);
end;

//取得Data消息
function dwGetData(ACtrl:TComponent):String;StdCall;
var
    joRes   : Variant;
    sFull   : string;
begin

    //
    sFull   := dwFullName(Actrl);

    //生成返回值数组
    joRes    := _Json('[]');
     //
     with TShape(ACtrl) do begin
          joRes.Add(sFull+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(sFull+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(sFull+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //
          //joRes.Add(dwFullName(Actrl)+'__map:null,');
          //joRes.Add(dwFullName(Actrl)+'__lushu:null,');

     end;
     //
     Result    := (joRes);
end;

//取得事件
function dwGetAction(ACtrl:TComponent):String;StdCall;
var
    joRes   : Variant;
    sFull   : string;
begin

    //
    sFull   := dwFullName(Actrl);

    //生成返回值数组
    joRes   := _Json('[]');
    //
    with TShape(ACtrl) do begin
        joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        //joRes.Add('this.'+dwFullName(Actrl)+'__cap="'+dwProcessCaption(Caption)+'";');
        //
        //joRes.Add('this.'+dwFullName(Actrl)+'__typ="'+dwGetProp(TShape(ACtrl),'type')+'";');
    end;
    //
    Result    := (joRes);
end;

//取得Mounted
function dwGetMounted(ACtrl:TComponent):String;StdCall;
var
    joRes   : Variant;
    sCode   : string;
    sFull   : string;
    fLon    : double;
    fLat    : double;
    iZoom   : Integer;
    joHint  : Variant;
    sStyle  : string;
begin

    //取得HINT对象JSON
    joHint  := dwGetHintJson(TControl(ACtrl));

    //
    sFull   := dwFullName(Actrl);

    //
    iZoom   := dwGetInt(joHint,'zoom',13);
    fLon    := dwGetDouble(joHint,'lon',108.9426);
    fLat    := dwGetDouble(joHint,'lat',34.2606);
    sStyle  := dwGetStr(joHint,'style','normal');

    //生成返回值数组
    joRes   := _Json('[]');

    //
    with TShape(ACtrl) do begin
        sCode   :=
        sFull+'__map = new AMap.Map('
            +'"'+sFull+'",{'
                +'zoom:'+IntToStr(iZoom)+','
                +'mapStyle: "amap://styles/'+sStyle+'", '
                +'center: ['+FloatToStr(fLon)+', '+FloatToStr(fLat)+']'
            +'}'
        +')';
        joRes.Add(sCode);
    end;
    //
    Result    := joRes;
end;


exports
     dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetMounted,
     dwGetData;
     
begin
end.
 
