library dwTMediaPlayer__flv;

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

        //生成返回值数组
        joRes    := _Json('[]');


        //需要额外引的代码
        joRes.Add('<script src="https://cdn.bootcdn.net/ajax/libs/flv.js/1.6.2/flv.js"></script>');

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
    sCode       : String;
    sFull       : string;

    //
    joHint      : Variant;
    joRes       : Variant;
begin
    sFull   := dwFullName(ACtrl);
    //
    with TMediaPlayer(ACtrl) do begin
        //============m3u8格式===========================================

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //外框
        sCode     := '<div'
                 +' id="'+sFull+'_frm"'
                 +dwVisible(TControl(ACtrl))                            //用于控制可见性Visible
                 +dwLTWH(TControl(ACtrl))                               //Left/Top/Width/Height
                 +'"' // 封闭style
                 +'>';
        //添加到返回值数据
        joRes.Add(sCode);

        //
        sCode     := '<video'
            +' id="'+sFull+'"'
            //+' class="video-js  vjs-big-play-centered"'
            +' controls autoplay'
            //+' preload="auto"'
            +' style="width:100%;height:100%;left:0px;top:0px"'
            //+' width="'+sFull+'__wid"'
            //+' height="'+sFull+'__hei"'
            //+' data-setup="{}"'
            +' >';
            //+'     <source :src="'+sFull+'__src"'
            //+' type="application/x-mpegURL"/>';

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
    joRes   : Variant;
    sFull   : string;
begin
    sFull   := dwFullName(ACtrl);
    //
    with TMediaPlayer(ACtrl) do begin
        //============m3u8格式===============================================================

        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TMediaPlayer(ACtrl) do begin
            joRes.Add(sFull+'__lef:"'+IntToStr(Left)+'px",');
            joRes.Add(sFull+'__top:"'+IntToStr(Top)+'px",');
            joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
            joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
            //
            joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
            //
            joRes.Add(sFull+'__loo:'+dwIIF(AutoRewind,'true,','false,'));
            joRes.Add(sFull+'__aut:'+dwIIF(Enabled,'true,','false,'));
            joRes.Add(sFull+'__src:"'+FileName+'",');
        end;
        //
        Result    := (joRes);
    end;
end;

//取得事件
function dwGetAction(ACtrl:TComponent):String;StdCall;
var
    joRes   : Variant;
    sFull   : string;
    sCode   : string;
begin
    sFull   := dwFullName(ACtrl);
    //
    with TMediaPlayer(ACtrl) do begin
        //============m3u8格式===============================================================
        //生成返回值数组
        joRes    := _Json('[]');
        //
        joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
        //
        joRes.Add('this.'+sFull+'__loo='+dwIIF(AutoRewind,'true;','false;'));
        joRes.Add('this.'+sFull+'__aut='+dwIIF(Enabled,'true;','false;'));
        joRes.Add('this.'+sFull+'__src="'+FileName+'";');

        //
        if EnabledButtons  = [btPlay] then begin
            sCode   :=
                    'let player = document.getElementById('''+sFull+''');'#13+
                    'if (flvjs.isSupported()) {'#13+
                        'var flvPlayer = flvjs.createPlayer({'#13+
                            'type: ''flv'','#13+
                            //'hasAudio: false,'#13+
                            'isLive: true, '#13+
                            'url: "'+FileName+'"'#13+
                        '});'#13+
                        'flvPlayer.attachMediaElement('+sFull+');'#13+
                        'flvPlayer.load(); '#13+
                        'flvPlayer.play(); '#13+
                    '}'#13
                    //'player.play();'
                    ;

            joRes.Add(sCode);
            EnabledButtons := [];
        end else begin
            joRes.Add('');      //增加一项空值，用于对齐
        end;
        if EnabledButtons  = [btPause] then begin
            joRes.Add('document.getElementById('''+sFull+''').pause();');
            EnabledButtons := [];
        end else begin
            joRes.Add('');
        end;
        if HelpContext > 0 then begin
            joRes.Add('document.getElementById("'+sFull+'").currentTime = '+IntToStr(HelpContext-1)+';');
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
 
