﻿library dwTGauge;

uses
     ShareMem,      //必须添加

     //
     dwCtrlBase,    //一些基础函数

     //
     SynCommons,    //mormot用于解析JSON的单元

     //
     Math,
     Vcl.Samples.Gauges,
     ComCtrls,
     SysUtils,
     Classes,
     Dialogs,
     StdCtrls,
     Windows,
     Controls,
     Forms;

function _GetConfig(ACtrl:TComponent):string;
var
    iRow    : Integer;
begin
    with TGauge(ACtrl) do begin
        Result  := '{'
                    +'title: {'
                        +'text: ''剩余油量表'','
                        +'style: {'
                            +'fill: ''#fff'''
                        +'}'
                    +'},'
                    +'series: ['
                    +'{'
                        +'type: ''gauge'','
                        +'data: [ { name: ''itemA'', value: 55 } ],'
                        +'center: [''50%'', ''55%''],'
                        +'axisLabel: {'
                            +'formatter: ''{value}%'','
                            +'style: {fill: ''#fff''}'
                        +'},'
                        +'axisTick: {'
                            +'style: {stroke: ''#fff''}'
                        +'},'
                        +'animationCurve: ''easeInOutBack'''
                    +'}'
                    +']'
                +'}'
    end;

end;

//--------------------以上为辅助函数----------------------------------------------------------------


//当前控件需要引入的第三方JS/CSS ,一般为不做改动,目前仅在TGauge使用时需要用到
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    joRes: Variant;
begin
     //生成返回值数组
    joRes := _Json('[]');
    joRes.Add('<script src="dist/_datav/datav.min.vue.js"></script>');
    //
    Result := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData    : Variant;
     oChange   : Procedure(Sender:TObject) of Object;
begin
{     //
     joData    := _Json(AData);


     if joData.e = 'onenter' then begin
          if Assigned(TGauge(ACtrl).OnEnter) then begin
               TGauge(ACtrl).OnEnter(TGauge(ACtrl));
          end;
     end else if joData.e = 'onchange' then begin
          //保存事件
          oChange   := TGauge(ACtrl).OnChange;
          //清空事件,以防止自动执行
          TGauge(ACtrl).OnChange  := nil;
          //更新值
          TGauge(ACtrl).Text    := dwUnescape(joData.v);
          //恢复事件
          TGauge(ACtrl).OnChange  := oChange;

          //执行事件
          if Assigned(TGauge(ACtrl).OnChange) then begin
               TGauge(ACtrl).OnChange(TGauge(ACtrl));
          end;
     end else if joData.e = 'onexit' then begin
          if Assigned(TGauge(ACtrl).OnExit) then begin
               TGauge(ACtrl).OnExit(TGauge(ACtrl));
          end;
     end else if joData.e = 'onmouseenter' then begin
          if Assigned(TGauge(ACtrl).OnMouseEnter) then begin
               TGauge(ACtrl).OnMouseEnter(TGauge(ACtrl));
          end;
     end else if joData.e = 'onmouseexit' then begin
          if Assigned(TGauge(ACtrl).OnMouseLeave) then begin
               TGauge(ACtrl).OnMouseLeave(TGauge(ACtrl));
          end;
     end;
}
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    //
    iItem     : Integer;
    iColID    : Integer;
    //
    bColed    : Boolean;     //已添加表头信息
    //
    sRowStyle : string;
    sBack     : string;
    sCode      : string;
    //
    joHint    : Variant;
    joRes     : Variant;
    joCols    : Variant;
    joCol     : Variant;
begin
    //
    with TGauge(ACtrl) do begin
        //-------------DataV图表--------------------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //
        with TGauge(ACtrl) do begin
            //添加主体
            joRes.Add('<dv-charts'
                    +' id="'+dwFullName(Actrl)+'"'
                    +' :config="'+dwFullName(Actrl)+'__cfg"'    //config
                    +dwVisible(TControl(ACtrl))                 //是否可见
                    +dwGetDWAttr(joHint)                        //dwAttr
                    +' :style="{'
                        +'left:'+dwFullName(Actrl)+'__lef,'
                        +'top:'+dwFullName(Actrl)+'__top,'
                        +'width:'+dwFullName(Actrl)+'__wid,'
                        //+'height:'+dwFullName(Actrl)+'__hei'
                    +'}"'
                    //
                    +' style="position:absolute;'
                        +'height:300px;'
                        +dwGetDWStyle(joHint)
                    +'"'
                    +'>');

        end;


        //
        Result    := (joRes);
    end;
end;


//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sType     : string;
begin
     //生成返回值数组
     joRes    := _Json('[]');

     //生成返回值数组
     joRes.Add('</dv-charts>');               //此处需要和dwGetHead对应
     //
     Result    := (joRes);
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    iSeries : Integer;
    iX      : Integer;
    //
    joRes   : Variant;
    //
    sDat    : String;
    sGrid   : String;
begin
    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TGauge(ACtrl) do begin
        //基本数据
        joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
        //
        //
        joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));

        //
        joRes.Add(dwFullName(Actrl)+'__cfg :'+_GetConfig(ACtrl)+',');
    end;
    //
    Result    := (joRes);
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
    //
    iRow,iCol : Integer;
    sCode     : String;
begin
    //
    with TGauge(ACtrl) do begin
        //TGauge 用作幸运大抽奖

        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TGauge(ACtrl) do begin
            //
            joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
            //
            joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));

            //
            joRes.Add('this.'+dwFullName(Actrl)+'__cfg ='+_GetConfig(ACtrl)+';');
        end;

        //
        Result    := (joRes);
    end;
end;


exports
     dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetData;
     
begin
end.
 
