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
        end else if joData.e = 'onclick' then begin
            //点击事件
            //
            if Assigned(TMemo(ACtrl).OnClick) then begin
                StyleName   := dwUnescape(joData.v);
                TMemo(ACtrl).OnClick(TMemo(ACtrl));
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
            joRes.Add(sFull+'__chart:null,');
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

        //
        if ShowHint then begin
            sCode   := 'that = this;';

            //
            for iItem := 0 to Lines.Count-1 do begin
                sCode   := sCode + #13+Lines[iItem];
            end;

            //
            sCode   := ''

                    // 销毁旧的图表实例
                    +'if (this.'+sFull+'__chart) {'
                        +'this.'+sFull+'__chart.dispose();'
                        //+'console.log("2disposed!");'
                    +'}else{'
                        +'console.log("2not existed!");'
                    +'};'

                    // 基于准备好的dom，初始化echarts实例
                    //+'var '+sFull+'__chart;'
                    //+sFull+'__chart.dispose();'
                    +'this.'+sFull+'__chart = echarts.init(document.getElementById('''+sFull+'''), null, { width: '+IntToStr(Width)+', height: '+IntToStr(Height)+'});'

                    // 指定图表的配置项和数据
                    //'var option = '+
                    +sCode +#13

                // 使用刚指定的配置项和数据显示图表
                +'this.'+sFull+'__chart.setOption(option);';

            joRes.Add(sCode);
            //
            ShowHint    := False;
        end else begin
            joRes.Add('');
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

        sCode   := 'that = this;';
        for iItem := 0 to Lines.Count-1 do begin
            sCode   := sCode + #13+Lines[iItem];//StringReplace(Lines[iItem],'''','"',[rfReplaceAll]);
        end;

        //
        sCode   :=
                // 基于准备好的dom，初始化echarts实例
                'this.'+sFull+'__chart = echarts.init(document.getElementById('''+sFull+'''), null, { width: '+IntToStr(Width)+', height: '+IntToStr(Height)+'});'

                // 指定图表的配置项和数据
                //'var option = '+
                +sCode +#13

                // 使用刚指定的配置项和数据显示图表
                +'this.'+sFull+'__chart.setOption(option);'

                // 当鼠标点击事件触发时，在控制台输出params
                +'this.'+sFull+'__chart.on(''click'', function(params){'
                    //+'alert("click");'
                    +'let _p ={};'
                    +'_p.name = params.name;'
                    +'_p.data = params.data;'
                    +'_p.seriesName = params.seriesName;'
                    +'_p.seriesIndex = params.seriesIndex;'
                    +'_p.dataIndex = params.dataIndex;'
                    +'console.log(JSON.stringify(_p));'
                    +'let _s = JSON.stringify(_p);'
                    //
                    +'that.dwevent("",'''+sFull+''',_s,''onclick'','''+IntToStr(TForm(Owner).Handle)+''');'
                +'});';

        joRes.Add(sCode);
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));

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
 
