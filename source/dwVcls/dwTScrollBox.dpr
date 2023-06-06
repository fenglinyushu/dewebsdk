library dwTScrollBox;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     SysUtils,
     Classes,
     Dialogs,
     StdCtrls,
     Windows,
     Controls,
     Forms;

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):String;stdCall;
begin
     Result    := '[]';
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):String;StdCall;
var
    joData   : Variant;
    iValue  : Integer;
begin
    //
    joData  := _Json(AData);

    if joData.e = 'onenter' then begin
        if Assigned(TScrollBox(ACtrl).OnEnter) then begin
            TScrollBox(ACtrl).OnEnter(TScrollBox(ACtrl));
        end;
    end else if joData.e = 'onexit' then begin
        if Assigned(TScrollBox(ACtrl).OnExit) then begin
            TScrollBox(ACtrl).OnExit(TScrollBox(ACtrl));
        end;
    end else if joData.e = 'onmouseup' then begin
        //保存当前滚动位置,备用
        TScrollBox(ACtrl).HelpContext   := abs(Integer(joData.v));

        //激活滚动事件
        if Assigned(TScrollBox(ACtrl).Onmouseup) then begin
            TScrollBox(ACtrl).Onmouseup(TScrollBox(ACtrl),TMouseButton(ACtrl),[],joData.v,1);
        end;
    end else if joData.e = 'onenddock' then begin
        iValue  := Round(StrToFloatDef(joData.v,0));
        //保存当前滚动位置,备用
        TScrollBox(ACtrl).HelpContext   := abs(iValue);

        //激活滚动事件
        if Assigned(TScrollBox(ACtrl).OnEndDock) then begin
            if iValue > 0 then begin
                TScrollBox(ACtrl).OnEndDock(TScrollBox(ACtrl),nil,iValue,1);
            end else begin
                TScrollBox(ACtrl).OnEndDock(TScrollBox(ACtrl),nil,Abs(iValue),-1);
            end;
        end;

    end;
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
     with TScrollBox(ACtrl) do begin

          //
          sCode     := '<div'
                    +' id="'+dwFullName(Actrl)+'"'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +dwLTWH(TControl(ACtrl))
                    +dwGetDWStyle(joHint)
                    +'"' //style 封闭
                    //+dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnExit),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),'')
                    +'>';
          joRes.Add(sCode);
          //
          sCode     := '<el-scrollbar'
                    +' ref="'+dwFullName(Actrl)+'"'
                    +' style="height:100%;"'
                    //此处不需要监听scroll事件，没用。放到mounted中处理了
                    //+dwIIF(True,Format(_DWEVENT,['scroll',Name,'0','onscroll',TForm(Owner).Handle]),'')
                    +'>';
          joRes.Add(sCode);
     end;

     Result    := (joRes);
     //
     //@mouseenter.native=“enter”
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //生成返回值数组
     joRes.Add('</el-scrollbar>');
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
     with TScrollBox(ACtrl) do begin
          joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //
          //joRes.Add(dwFullName(Actrl)+'__cap:"'+dwProcessCaption(Caption)+'",');
          //
          joRes.Add(dwFullName(Actrl)+'__typ:"'+dwGetProp(TScrollBox(ACtrl),'type')+'",');
          //保存oldscrolltop以确定滚动方向
          joRes.Add(dwFullName(Actrl)+'__ost:0,');
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
     with TScrollBox(ACtrl) do begin
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
          joRes.Add('this.'+dwFullName(Actrl)+'__typ="'+dwGetProp(TScrollBox(ACtrl),'type')+'";');
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
begin
    //生成返回值数组
    joRes   := _Json('[]');
    //
    sFull   := dwFullName(Actrl);
    //
    with TScrollBox(ACtrl) do begin
        sCode   := ''
                //+'console.log(''me.$refs.'+sFull+''');'#13
                //+'console.log(me.$refs'+');'#13
                //+'console.log(me.$refs.'+sFull+');'#13
                +'let '+sFull+'__scr = me.$refs.'+sFull+'.wrap;'#13
                +'let '+sFull+'__t1 = 0;'#13       //第一次位置
                +'let '+sFull+'__t2 = 0;'#13       //第二次位置
                +'let '+sFull+'__tmr = null;'#13   //定时器，用于检查滚动停止
                +sFull+'__scr.onscroll = function() {'#13
                    //以下 if 区分向上滚动和向下滚动，激活OnEndDock事件  ost=OldScrollTop
                    +'if (me.'+sFull+'__ost<'+sFull+'__scr.scrollTop - '+IntToStr(HelpContext)+') {'#13
                        +'axios.post('#13
                            +'''/deweb/post'','#13
                            +'''{"m":"event","i":''+me.clientid+'',"e":"onenddock","c":"'+sFull+'","v":"''+'+sFull+'__scr.scrollTop+''"}'''#13
                            +',{headers:{shuntflag:0}}'#13
                            +')'#13
                        +'.then(resp =>{me.procResp(resp.data);});'#13
                        //滚动停止时（200ms滚动值未变化），激活滚动停止事件
                        +'me.'+sFull+'__ost='+sFull+'__scr.scrollTop;'#13
                        +'clearTimeout('+sFull+'__tmr);'#13
                        +sFull+'__tmr = setTimeout('+sFull+'__ise, 200);'#13   //ise = isScrollEnd
                        +sFull+'__t1 = '+sFull+'__scr.scrollTop;'#13
                    +'} else if (me.'+sFull+'__ost>'+sFull+'__scr.scrollTop + '+IntToStr(HelpContext)+') {'#13
                        +'axios.post('#13
                            +'''/deweb/post'','#13
                            +'''{"m":"event","i":''+me.clientid+'',"e":"onenddock","c":"'+sFull+'","v":"-''+'+sFull+'__scr.scrollTop+''"}'''#13
                            +',{headers:{shuntflag:0}}'#13
                            +')'#13
                        +'.then(resp =>{me.procResp(resp.data);});'#13
                        //滚动停止时（200ms滚动值未变化），激活滚动停止事件
                        +'me.'+sFull+'__ost='+sFull+'__scr.scrollTop;'#13
                        +'clearTimeout('+sFull+'__tmr);'#13
                        +sFull+'__tmr = setTimeout('+sFull+'__ise, 200);'#13   //ise = isScrollEnd
                        +sFull+'__t1 = '+sFull+'__scr.scrollTop;'#13
                    +'};'#13

                +'};'#13;

        //以下定时检查是否停止，如果已停止，则激活onenddock
        sCode   := sCode + #13
                +'function '+sFull+'__ise() {'#13  //ise = isScrollEnd

                    +sFull+'__t2 = '+sFull+'__scr.scrollTop;'#13
                    +'if('+sFull+'__t2 == '+sFull+'__t1){'#13
                        //+'console.log(''滚动结束了'');'
                        +'axios.post('#13
                            +'''/deweb/post'','#13
                            +'''{"m":"event","i":''+me.clientid+'',"e":"onmouseup","c":"'+sFull+'","v":"''+'+sFull+'__scr.scrollTop+''"}'''#13
                            +',{headers:{shuntflag:0}}'#13
                            +')'#13
                        +'.then(resp =>{me.procResp(resp.data);});'#13
                    +'}'#13

                +'}';
        joRes.Add(sCode);
    end;
    //
    Result    := (joRes);
end;

exports
     //dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetMounted,
     dwGetData;
     
begin
end.
 
