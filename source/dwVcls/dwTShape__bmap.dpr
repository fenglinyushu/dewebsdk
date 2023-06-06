library dwTShape__bmap;

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
begin
    //生成返回值数组
    joRes    := _Json('[]');
    //生成返回值数组
    joRes.Add('<style type="text/css">'+
                '.anchorBL {display: none;}'+
                '.BMap_cpyCtrl {display: none;}'+
                '.BMap_scaleCtrl {display: block;}'+
            '</style>');
    joRes.Add('<script type="text/javascript" src="https://api.map.baidu.com/api?v=3.0&ak=MDUPjhlGcCsg7gKrs6FmTQsz"></script>');
    joRes.Add('<script type="text/javascript" src="https://api.map.baidu.com/library/LuShu/1.2/src/LuShu_min.js"></script>');
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
     sCode     : String;

     //
     joHint    : Variant;
     joRes     : Variant;

begin
     //生成返回值数组
     joRes    := _Json('[]');

     //取得HINT对象JSON
     joHint    := dwGetHintJson(TControl(ACtrl));

     //_DWEVENT = ' @%s="dwevent($event,''%s'',''%s'',''%s'',''%s'')"';
     //参数依次为: JS事件名称, 控件名称,控件值,Delphi事件名称,备用


     //
     with TShape(ACtrl) do begin
          //
          sCode     := '<div'
                    +' id="'+dwFullName(Actrl)+'"'
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
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //
     with TShape(ACtrl) do begin
          joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(Enabled,'false,','true,'));
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
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //
     with TShape(ACtrl) do begin
          joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+dwFullName(Actrl)+'__dis='+dwIIF(Enabled,'false;','true;'));
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
begin
    //生成返回值数组
    joRes   := _Json('[]');
    //
    with TShape(ACtrl) do begin
        sCode   := dwFullName(Actrl)+'__map = new BMap.Map("'+dwFullName(Actrl)+'",{minZoom:1,maxZoom:25});'
                // 创建点坐标 （北京天安门坐标）
                +'var point = new BMap.Point(116.404, 39.915);'

                // 默认的地图是只可以鼠标拖动的，鼠标滚轮不会修改Zoom值
                +dwFullName(Actrl)+'__map.enableScrollWheelZoom(true);'

                // 初始化地图，设置中心点坐标和地图级别
                +dwFullName(Actrl)+'__map.centerAndZoom(point, 12);';
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
 
