library dwTMediaPlayer__mp3;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,


     //
     MPlayer,
     SysUtils,
     Classes,
     Dialogs,
     StdCtrls,
     Windows,
     Controls,
     Forms;

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):String;stdCall;
var
    joRes     : Variant;
begin
    with TMediaPlayer(Actrl) do begin
        //============mp3格式============================================

        Result    := '[]';
    end;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):String;StdCall;
begin
     //
     //TMediaPlayer(ACtrl).OnClick(TMediaPlayer(ACtrl));
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):String;StdCall;
var
    sCode     : String;

    //
    joHint    : Variant;
    joRes     : Variant;
begin
    //
    with TMediaPlayer(ACtrl) do begin
        //============mp3格式============================================

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //
        sCode     := '<div'
                 +' id="'+dwFullName(Actrl)+'__frm"'
                 +dwVisible(TControl(ACtrl))                            //用于控制可见性Visible
                 +dwLTWH(TControl(ACtrl))                               //Left/Top/Width/Height
                 +'"' // 封闭style
                 +'>';
        //添加到返回值数据
        joRes.Add(sCode);

        //
        sCode     := '    <audio'
            +' id="'+dwFullName(Actrl)+'"'
            +' :preload="true"'
            +' :src="'+dwFullName(Actrl)+'__src"'
            +' :autoplay="'+dwFullName(Actrl)+'__aut"'
            +' :loop="'+dwFullName(Actrl)+'__loo"'
            +' :controls="'+dwFullName(Actrl)+'__vis"'
            +' style="width:100%;height:100%"'
            +'>';

        joRes.Add(sCode);

        //
        Result    := (joRes);
    end;
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin
    //
    with TMediaPlayer(ACtrl) do begin
        //============mp3格式================================================================

        //生成返回值数组
        joRes    := _Json('[]');

        //生成返回值数组
        joRes.Add('    </audio>');
        joRes.Add('</div>');

        //
        Result    := (joRes);
    end;
end;

//取得Data消息
function dwGetData(ACtrl:TComponent):String;StdCall;
var
    joRes     : Variant;
begin
    //
    with TMediaPlayer(ACtrl) do begin
        //============mp3格式================================================================

        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TMediaPlayer(ACtrl) do begin
            joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
            joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
            joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
            joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
            //
            joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
            //
            joRes.Add(dwFullName(Actrl)+'__loo:'+dwIIF(AutoRewind,'true,','false,'));
            joRes.Add(dwFullName(Actrl)+'__aut:'+dwIIF(Enabled,'true,','false,'));
            joRes.Add(dwFullName(Actrl)+'__src:"'+FileName+'",');
        end;
        //
        Result    := (joRes);

    end;
end;

//取得事件
function dwGetAction(ACtrl:TComponent):String;StdCall;
var
    joRes     : Variant;
begin
    //
    with TMediaPlayer(ACtrl) do begin
        //============mp3格式================================================================

        //生成返回值数组
        joRes    := _Json('[]');
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__loo='+dwIIF(AutoRewind,'true;','false;'));
        joRes.Add('this.'+dwFullName(Actrl)+'__aut='+dwIIF(Enabled,'true;','false;'));
        joRes.Add('this.'+dwFullName(Actrl)+'__src="'+FileName+'";');

        //play
        if EnabledButtons  = [btPlay] then begin
            joRes.Add('document.getElementById("'+dwFullName(Actrl)+'").play();');
            EnabledButtons := [];
        end else begin
            joRes.Add('');
        end;

        //pause
        if EnabledButtons  = [btPause] then begin
            joRes.Add('document.getElementById("'+dwFullName(Actrl)+'").pause();');
            EnabledButtons := [];
        end else begin
            joRes.Add('');
        end;

        //
        if HelpContext > 0 then begin
            joRes.Add('document.getElementById("'+dwFullName(Actrl)+'").currentTime = '+IntToStr(HelpContext-1)+';');
            HelpContext    := 0;
        end else begin
            joRes.Add('');
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
 
