library dwTPanel__scroll;

{
    能自动触发滚动事件的TPanel
    -
    当事件滚动结束200ms后自动触发OnEndDock 事件
    其中X, Y为
    Y 为方向 ,1 向下, -1 向上  ,0 到顶部, 9到底部
    X 为滚动值
}


uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, ComCtrls, ExtCtrls,
     StdCtrls, Windows;

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):String;stdCall;
begin
     Result    := '[]';
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):String;StdCall;
var
    joData  : Variant;
    iValue  : Integer;
    //oChange : Procedure(Sender, Target: TObject; X, Y: Integer) of Object;
begin
    //
    joData  := _Json(AData);

    with TPanel(ACtrl) do begin
        if joData.e = 'onenter' then begin
            if Assigned(OnEnter) then begin
                OnEnter(TPanel(ACtrl));
            end;
        end else if joData.e = 'onexit' then begin
            if Assigned(OnExit) then begin
                OnExit(TPanel(ACtrl));
            end;
        end else if joData.e = 'onmouseup' then begin

            //激活滚动事件
            if Assigned(TPanel(ACtrl).Onmouseup) then begin
                Onmouseup(TPanel(ACtrl),TMouseButton(ACtrl),[],joData.v,1);
            end;
        end else if joData.e = 'onenddock' then begin
            iValue  := Round(StrToFloatDef(joData.v,0));

            //激活滚动事件
            if Assigned(TPanel(ACtrl).OnEndDock) then begin
                if iValue > 0 then begin
                    OnEndDock(TPanel(ACtrl),nil,iValue,1);
                end else begin
                    OnEndDock(TPanel(ACtrl),nil,Abs(iValue),-1);
                end;
            end;
        end else if joData.e = 'onenddocktop' then begin    //滚动到顶部事件
            //激活滚动事件
            if Assigned(OnEndDock) then begin
                OnEndDock(TPanel(ACtrl),nil,0,0);
            end;
        end else if joData.e = 'onenddockbottom' then begin
            iValue  := Round(StrToFloatDef(joData.v,0));

            //激活滚动事件
            if Assigned(OnEndDock) then begin
                OnEndDock(TPanel(ACtrl),nil,Abs(iValue),9);
            end;

        end;
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):String;StdCall;
var
    sCode       : String;

    //
    joHint      : Variant;
    joRes       : Variant;
    //
    sFull       : string;
begin
    sFull   := dwFullName(ACtrl);

    //生成返回值数组
    joRes    := _Json('[]');

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //_DWEVENT = ' @%s="dwevent($event,''%s'',''%s'',''%s'',''%s'')"';
    //参数依次为: JS事件名称, 控件名称,控件值,Delphi事件名称,备用


    //
    with TPanel(ACtrl) do begin

        //
        sCode   := '<div'
                +' id="'+sFull+'"'
                +' ref="'+sFull+'"'
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                +dwGetDWAttr(joHint)
                +dwLTWH(TControl(ACtrl))
                +'backgroundColor:'+dwColor(TPanel(ACtrl).Color)+';'
                +dwGetDWStyle(joHint)
                +'"' //style 封闭
                //+dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
                +dwIIF(Assigned(OnEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),'')
                +dwIIF(Assigned(OnExit),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),'')
                +'>';
        joRes.Add(sCode);
    end;

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
    joRes       : Variant;
    //
    sFull       : string;
begin
    sFull   := dwFullName(ACtrl);

    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TPanel(ACtrl) do begin
        joRes.Add(sFull+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(sFull+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(sFull+'__dis:'+dwIIF(Enabled,'false,','true,'));
        //
        //joRes.Add(sFull+'__cap:"'+dwProcessCaption(Caption)+'",');
        //
        joRes.Add(sFull+'__typ:"'+dwGetProp(TPanel(ACtrl),'type')+'",');
        //保存oldscrolltop以确定滚动方向
        joRes.Add(sFull+'__ost:0,');
    end;
    //
    Result    := (joRes);
end;


//取得事件
function dwGetAction(ACtrl:TComponent):String;StdCall;
var
    joRes       : Variant;
    //
    sFull       : string;
begin
    sFull   := dwFullName(ACtrl);

    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TPanel(ACtrl) do begin
        joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        //joRes.Add('this.'+sFull+'__cap="'+dwProcessCaption(Caption)+'";');
        //
        joRes.Add('this.'+sFull+'__typ="'+dwGetProp(TPanel(ACtrl),'type')+'";');
    end;
    //
    Result    := (joRes);
end;

//取得Mounted
function dwGetMounted(ACtrl:TComponent):String;StdCall;
var
    iTimeOut    : Integer;
    joRes       : Variant;
    sCode       : string;
    sFull       : string;
begin
    //生成返回值数组
    joRes   := _Json('[]');

    //
    sFull   := dwFullName(ACtrl);


    //
    with TPanel(ACtrl) do begin

        //定时器时间间隔
        iTimeout    := 200;
        if HelpContext > 0 then begin
            iTimeOut    := HelpContext;
        end;

        sCode   :=
        '''
        let %s__stt = 0;        //初始滚动位置
        let %s__cur = 0;        //当前滚动位置
        let %s__tmr = null;     //时钟控件
        document.getElementById('%s').addEventListener("scroll", function() {
            clearTimeout(%s__tmr);
            %s__cur = %s.scrollTop;     //保存当前位置
            %s__tmr = setTimeout(%s__ise, %d); //创建时钟控件
        });

        //以下定时检查是否停止，如果已停止，则激活onenddock
        function %s__ise() {
            //console.log('down....',%s__stt,%s__cur);
            if (%s__cur == %s.scrollTop) {
                //console.log('滚动结束了');
                if (Math.abs(%s__cur - %s__stt) >= %d ) {
                    if (%s.scrollTop + %s.clientHeight >= %s.scrollHeight-3){
                        //console.log('bottom.......');
                        axios.post(
                            '/deweb/post',
                            '{"m":"event","i":'+_this.clientid+',"e":"onenddockbottom","c":"%s","v":"'+%s.scrollTop+'"}'
                            ,{headers:{shuntflag:0}}
                        )
                        .then(resp =>{_this.procResp(resp.data);});
                    } else if (%s.scrollTop == 0){
                        //console.log('Top.........');
                        axios.post(
                            '/deweb/post',
                            '{"m":"event","i":'+_this.clientid+',"e":"onenddocktop","c":"%s","v":"0"}'
                            ,{headers:{shuntflag:0}}
                        )
                        .then(resp =>{_this.procResp(resp.data);});
                    } else {

                        var _val = %s.scrollTop;
                        if (%s__stt > %s.scrollTop) {
                            _val = -1*_val;
                        }
                        //console.log(_val);
                        axios.post(
                            '/deweb/post',
                            '{"m":"event","i":'+_this.clientid+',"e":"onenddock","c":"%s","v":"'+_val+'"}'
                            ,{headers:{shuntflag:0}}
                        )
                        .then(resp =>{_this.procResp(resp.data);});
                        %s__stt = %s.scrollTop;
                    }
                    clearTimeout(%s__tmr);
                }
            }
        };
        ''';
        sCode   := Format(sCode,[
                sFull,sFull,sFull,sFull,sFull,  sFull,sFull,sFull,sFull,iTimeout,
                sFull,sFull,sFull,sFull,sFull,  sFull,sFull,  HelpContext,
                sFull,sFull,sFull,sFull,sFull,  sFull,sFull,sFull,sFull,sFull,
                sFull,sFull,sFull,sFull]);
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
 
