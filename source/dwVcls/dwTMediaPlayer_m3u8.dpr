library dwTMediaPlayer_m3u8;

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
        //============m3u8格式===========================================

        //生成返回值数组
        joRes    := _Json('[]');


        //需要额外引的代码
        joRes.Add('<link href="dist/_videom3u8/video-js.css" rel="stylesheet" />');
        joRes.Add('<script src="dist/_videom3u8/video.js"></script>');

        //
        Result    := joRes;

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
        //============m3u8格式===========================================

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //外框
        sCode     := '<div'
                 +' id="'+dwPrefix(Actrl)+Name+'_frm"'
                 +dwVisible(TControl(ACtrl))                            //用于控制可见性Visible
                 +dwLTWH(TControl(ACtrl))                               //Left/Top/Width/Height
                 +'"' // 封闭style
                 +'>';
        //添加到返回值数据
        joRes.Add(sCode);

        //
        sCode     := '<video'
            +' id="'+dwPrefix(Actrl)+Name+'"'
            +' class="video-js  vjs-big-play-centered"'
            +' controls'
            +' preload="auto"'
            +' style="width:100%;height:100%;left:0px;top:0px"'
            //+' width="'+dwPrefix(Actrl)+Name+'__wid"'
            //+' height="'+dwPrefix(Actrl)+Name+'__hei"'
            +' data-setup="{}"'
            +' >'
            +'     <source :src="'+dwPrefix(Actrl)+Name+'__src"'
            +' type="application/x-mpegURL"/>';

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
        //============m3u8格式===============================================================

        //生成返回值数组
        joRes    := _Json('[]');
        //生成返回值数组
        joRes.Add('</video>');
        joRes.Add('</div>');
        //
        Result    := (joRes);
    end;
end;

//取得Data消息
function dwGetData(ACtrl:TComponent):String;StdCall;
var
    joRes    : Variant;
begin
    //
    with TMediaPlayer(ACtrl) do begin
        //============m3u8格式===============================================================

        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TMediaPlayer(ACtrl) do begin
            joRes.Add(dwPrefix(Actrl)+Name+'__lef:"'+IntToStr(Left)+'px",');
            joRes.Add(dwPrefix(Actrl)+Name+'__top:"'+IntToStr(Top)+'px",');
            joRes.Add(dwPrefix(Actrl)+Name+'__wid:"'+IntToStr(Width)+'px",');
            joRes.Add(dwPrefix(Actrl)+Name+'__hei:"'+IntToStr(Height)+'px",');
            //
            joRes.Add(dwPrefix(Actrl)+Name+'__vis:'+dwIIF(Visible,'true,','false,'));
            //
            joRes.Add(dwPrefix(Actrl)+Name+'__loo:'+dwIIF(AutoRewind,'true,','false,'));
            joRes.Add(dwPrefix(Actrl)+Name+'__aut:'+dwIIF(Enabled,'true,','false,'));
            joRes.Add(dwPrefix(Actrl)+Name+'__src:"'+FileName+'",');
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
        //============m3u8格式===============================================================
        //生成返回值数组
        joRes    := _Json('[]');
        //
        joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+dwPrefix(Actrl)+Name+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+dwPrefix(Actrl)+Name+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+dwPrefix(Actrl)+Name+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+dwPrefix(Actrl)+Name+'__vis='+dwIIF(Visible,'true;','false;'));
        //
        joRes.Add('this.'+dwPrefix(Actrl)+Name+'__loo='+dwIIF(AutoRewind,'true;','false;'));
        joRes.Add('this.'+dwPrefix(Actrl)+Name+'__aut='+dwIIF(Enabled,'true;','false;'));
        joRes.Add('this.'+dwPrefix(Actrl)+Name+'__src="'+FileName+'";');

        //
        if EnabledButtons  = [btPlay] then begin
            joRes.Add('var player = videojs("'+dwPrefix(Actrl)+Name+'");  player.play();');
            EnabledButtons := [];
        end else begin
            joRes.Add('');      //增加一项空值，用于对齐
        end;
        if EnabledButtons  = [btPause] then begin
            joRes.Add('var player = videojs("'+dwPrefix(Actrl)+Name+'"); player.pause();');
            EnabledButtons := [];
        end else begin
            joRes.Add('');
        end;
        if HelpContext > 0 then begin
            joRes.Add('document.getElementById("'+dwPrefix(Actrl)+Name+'").currentTime = '+IntToStr(HelpContext-1)+';');
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
 
