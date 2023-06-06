library dwTMemo__echarts;

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


//--------------------以上为辅助函数----------------------------------------------------------------


//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    joRes: Variant;
begin
     //生成返回值数组
    joRes := _Json('[]');
    //
    joRes.Add('<script src="dist/_echarts/echarts.min.js"></script>');
    //
    Result := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData    : Variant;
     oChange   : Procedure(Sender:TObject) of Object;
     sText     : string;
begin
    with TMemo(ACtrl) do begin
        //
        joData    := _Json(AData);


        if joData.e = 'onresize' then begin

            //
            if Assigned(TMemo(ACtrl).OnMouseUp) then begin
                TMemo(ACtrl).OnMouseUp(TMemo(ACtrl),mbLeft,[],0,0);
            end;
        end else if joData.e = 'onchange' then begin
        end else if joData.e = 'onexit' then begin
        end else if joData.e = 'onmouseenter' then begin
        end else if joData.e = 'onmouseexit' then begin
        end;
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode       : string;
    sFull       : string;
    sScroll     : string;
    //
    joHint      : Variant;
    joRes       : Variant;
begin
    sFull   := dwFullName(Actrl);

    //
    with TMemo(ACtrl) do begin

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        with TMemo(ACtrl) do begin
            //
            sScroll   := '';

            sCode     := '<div'
                    +' id="'+sFull+'"'
                    +dwVisible(TControl(ACtrl))
                    +dwGetDWAttr(joHint)
                    //style
                    +dwLTWH(TControl(ACtrl))
                    +dwGetDWStyle(joHint)
                    +'"' //style 封闭
                    +'>';

            //添加到返回值数据
            joRes.Add(sCode);
        end;

        //
        Result    := (joRes);
    end;
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
begin
    with TMemo(ACtrl) do begin

        //生成返回值数组
        joRes    := _Json('[]');
        //生成返回值数组
        joRes.Add('</div>');
        //
        Result    := (joRes);
    end;
end;




//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    sFull       : string;
    //
    joRes       : Variant;
    joHint      : Variant;
begin
    sFull   := dwFullName(Actrl);
    //
    with TMemo(ACtrl) do begin
        joHint  := dwGetHintJson(TControl(Actrl));

        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TMemo(ACtrl) do begin
            joRes.Add(sFull+'__lef:"'+IntToStr(Left)+'px",');
            joRes.Add(sFull+'__top:"'+IntToStr(Top)+'px",');
            joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
            joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
            //
            joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
            //
            if joHint.Exists('initdata') then begin
                joRes.Add(joHint.initdata);
            end;
        end;
        //
        Result    := (joRes);
    end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    sCode       : String;
    iItem       : Integer;
    sFull       : string;
    //
begin
    sFull   := dwFullName(Actrl);
    //
    with TMemo(ACtrl) do begin

        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TMemo(ACtrl) do begin
            //用于当width/height发生变化时,重绘
            sCode   := '/*real*/ '+
                    'if ((this.'+sFull+'__wid != "'+IntToStr(Width)+'px") ||(this.'+sFull+'__hei != "'+IntToStr(Height)+'px")) {'+
                        //'console.log("echarts resize!");'+
                        'this.dwevent(null,"'+sFull+'","","onresize",'+IntToStr(TForm(Owner).Handle)+');'+
                    '};';
            //
            joRes.Add(sCode);
            //
            joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
            joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
            joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
            joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
            //
            joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
        end;
        //
        Result    := (joRes);
    end;
end;

function dwGetMounted(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    sCode       : String;
    iItem       : Integer;
    sFull       : string;
    //
begin
    sFull   := dwFullName(Actrl);
    with TMemo(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TMemo(ACtrl) do begin
            sCode   := '';
            for iItem := 0 to Lines.Count-1 do begin
                sCode   := sCode + #13+Lines[iItem];//StringReplace(Lines[iItem],'''','"',[rfReplaceAll]);
            end;

            //
            sCode   :=
                    // 基于准备好的dom，初始化echarts实例
                    'var myChart = echarts.init(document.getElementById('''+sFull+'''));'+

                    // 指定图表的配置项和数据
                    //'var option = '+
                    sCode +#13+

                    // 使用刚指定的配置项和数据显示图表
                    'myChart.setOption(option);';

            joRes.Add(sCode);
            //
            joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));
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
     dwGetMounted,
     dwGetAction,
     dwGetData;
     
begin
end.
 
