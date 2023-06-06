library dwTMemo__echartsmap;
(*
功能：
    用于通过echarts和geojson生成地图显示
配置：
    1 在lines中配置echarts ， 一般为 option = {...};
    2 在Hint中配置geojson, 如{"geojson":"media/geojson/341100_full.json"}
      geojson文件可以在下面网址取得
      https://datav.aliyun.com/portal/school/atlas/area_selector#&lat=31.769817845138945
    3 更新可以在改变Lines后，使用dwEchartsMap(Memo1);

*)

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

function dwUnicodeToChinese(inputstr: string): string;   //将类似“%u4E2D”转成中文
var
    index   : Integer;
    temp, top, last: string;
begin
    index := 1;
    while index >= 0 do begin
        index := Pos('%u', inputstr) - 1;
        if index < 0 then begin
            last := inputstr;
            Result := Result + last;
            Exit;
        end;
        top := Copy(inputstr, 1, index); // 取出 编码字符前的 非 unic 编码的字符，如数字
        temp := Copy(inputstr, index + 1, 6); // 取出编码，包括 \u,如\u4e3f
        Delete(temp, 1, 2);
        Delete(inputstr, 1, index + 6);
        Result := Result + top + WideChar(StrToInt('$' + temp));
    end;
end;

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
    joRes.Add('<script src="dist/_jquery/jquery.min.js"></script>');
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


        if joData.e = 'onclick' then begin
            if Assigned(OnClick) then begin
                ImeName := dwUnicodeToChinese(dwUnEscape(dwUnEscape(String(joData.v))));
                OnClick(TMemo(ACtrl));
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
    joHint      : Variant;
    //
begin
    //取得JSON
    joHint  := dwGetHintJson(TControl(Actrl));
    if not joHint.Exists('geojson') then begin
        joHint.geojson  := '';
    end;

    //取得FullName
    sFull   := dwFullName(Actrl);

    //
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
                    'that = this;'+
                    '$.get('''+joHint.geojson+''', function (mapJson) {'+
                        'echarts.registerMap(''MAP'', mapJson);'+

                        // 基于准备好的dom，初始化echarts实例
                        'var myChart = echarts.init(document.getElementById('''+sFull+'''));'+

                        // 指定图表的配置项和数据 option = {...}
                        sCode +#13+

                        // 使用刚指定的配置项和数据显示图表
                        'myChart.setOption(option);'+

                        //响应点击事件
                        'myChart.on(''click'', function (params) {'+
                            'that.dwevent("",'''+sFull+''',''"''+escape(JSON.stringify(params.data))+''"'',''onclick'','''+IntToStr(TForm(Owner).Handle)+''');'+
                        '});'+
                    '});';

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
 
