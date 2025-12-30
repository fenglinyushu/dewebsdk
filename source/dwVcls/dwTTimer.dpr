library dwTTimer;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     SysUtils,ExtCtrls,
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
begin
     //
     if Assigned(TTimer(ACtrl).OnTimer) then  begin
          TTimer(ACtrl).OnTimer(TTimer(ACtrl));
     end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):String;StdCall;
var
    joRes   : Variant;
    sCode   : String;
    sFull   : string;
begin
    //
    sFull   := dwFullName(Actrl);

    //生成返回值数组
    joRes   := _Json('[]');

    //
    with TTimer(ACtrl) do begin
        sCode   :=
        '<div '
            +' id="'+sFull+'"'
            +dwDisable(TControl(ACtrl))         //是否启用
            +' :data-interval="'+sFull+'__int"' //时间间隔
            +' :data-value="'+sFull+'__val"'    //时钟对应的数值
            +' style="display: none;"'
        +'>'
        +'</div>';

    end;
    //joRes.Add(sCode);

    //
    Result    := (joRes);
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //
     Result    := (joRes);
end;

//取得Data
function dwGetData(ACtrl:TComponent):String;StdCall;
var
    joRes   : Variant;
    sCode   : String;
    sFull   : string;
begin
    //
    sFull   := dwFullName(Actrl);
    //生成返回值数组
    joRes    := _Json('[]');

    with TTimer(ACtrl) do begin
        //
        joRes.Add(sFull+'__dis:'+dwIIF(Enabled,'false,','true,'));
        joRes.Add(sFull+'__int:'+IntToStr(InterVal)+',');
        joRes.Add(sFull+'__val:0,');
    end;

    //
    Result    := (joRes);
end;

function dwGetAction(ACtrl:TComponent):String;StdCall;
var
    joRes   : Variant;
    sCode   : String;
    sFull   : string;
    oForm   : TForm;
begin
    sFull   := dwFullName(Actrl);

    //生成返回值数组
    joRes    := _Json('[]');

    //
    oForm   := TForm(ACtrl.Owner);
    //if (oForm.Parent<>nil) and (LowerCase(Copy(oForm.ClassName,1,5))='tform') then begin
    //    oForm   := TForm(oForm.Parent);
    //end;


    with TTimer(ACtrl) do begin

        if DesignInfo = 1 then begin   //创建定时器
            sCode   :=
            '_that = this;'
            +'if (_that.'+sFull+'__val === 0 ){'
                +'_that.'+sFull+'__val = window.setInterval(function() {'
                    +'axios.post(''/deweb/post'',''{"m":"event","i":'+IntToStr(oForm.Handle)+',"c":"'+sFull+'"}'')'#13
                    +'.then(resp =>{_that.procResp(resp.data);})'#13
                +'},'+IntToStr(Interval)+');'
            +'};';

        end else begin                     //清除定时器
            sCode     :=
            '_that = this;'
            +'if (_that.'+sFull+'__val != 0 ){'
                +'clearInterval(_that.'+sFull+'__val);'
                +'_that.'+sFull+'__val = 0;'
            +'};';
        end;
        joRes.Add(sCode);
    end;

    //dwFrame3中的时钟未正确停止
    //
    Result    := (joRes);
end;

//取得Mounted
function dwGetMounted(ACtrl:TComponent):String;StdCall;
var
    joRes   : Variant;
    joHint  : Variant;
    //
    sCode   : string;
    sFull   : string;
    oForm   : TForm;
begin
    //
    sFull   := dwFullName(ACtrl);

    //生成返回值数组
    joRes   := _Json('[]');

    //
    oForm   := TForm(ACtrl.Owner);

    with TTimer(ACtrl) do begin
        //DesignInfo  := 0;      HERE!
        if Enabled  or (DesignInfo  = 1) then begin
            DesignInfo  := 1;

            //关闭以自动在web中处理
            Enabled := False;

            //
            sCode   :=
            'window._this.'+sFull+'__val = window.setInterval(function() {'#13
                +'axios.post(''/deweb/post'',''{"m":"event","i":'+IntToStr(oForm.Handle)+',"c":"'+sFull+'"}'',{headers:{shuntflag:[!shuntflag!]}})'#13
                +'.then(resp =>{window._this.procResp(resp.data);})'#13
            +'}, '+IntToStr(InterVal)+');'
            +'';
            joRes.Add(sCode);
        end;
    end;

    //
    Result    := joRes;
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
 
