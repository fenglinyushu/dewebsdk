library dwTMediaPlayer__xg;
{
    集成字节跳动的西瓜播放器
}
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

function _GetType(AFileName:String):String;
begin
    (*
    如果为
    .mp4
    如果为
    .flv
    如果为
    .mpd
    否则都为
    m3u8
    *)

    Result  := 'hls';
    if Pos('.mp4',LowerCase(AFileName)) > 0 then begin
        Result  := 'mp4';
    end else if Pos('.flv',LowerCase(AFileName)) > 0 then begin
        Result  := 'flv';
    end else if Pos('.mpd',LowerCase(AFileName)) > 0 then begin
        Result  := 'mpd';
    end;
end;

function _GetInit(ACtrl:TComponent;AIsPlay:Boolean):String;
var
    joRes       : Variant;
    joHint      : Variant;
    sFull       : string;
    sCode       : string;
    sType       : string;   //视频类型，mp4/hls/flv/mpd，  默认为hls, 即m3u8
    sPoster     : String;   //封面，默认 //lf9-cdn-tos.bytecdntp.com/cdn/expire-1-M/byted-player-videos/1.0.0/poster.jpg
    iIsLive     : Integer;  //是否直播，0/1，默认0
begin
    //取得控件全名备用
    sFull   := dwFullName(ACtrl);

    //取得HINT对象JSON
    joHint  := dwGetHintJson(TControl(ACtrl));

    //封面，默认 //lf9-cdn-tos.bytecdntp.com/cdn/expire-1-M/byted-player-videos/1.0.0/poster.jpg
    sPoster   := dwGetStr(joHint,'poster','https://lf9-cdn-tos.bytecdntp.com/cdn/expire-1-M/byted-player-videos/1.0.0/poster.jpg');

    //是否直播，0/1，默认0
    iIsLive := dwGetInt(joHint,'islive',1);

    //
    with TMediaPlayer(Actrl) do begin
        sType   := _GetType(FileName);
        //
        if sType = 'hls' then begin
            Result  := ''
                    +'if (this.'+sFull+'__plr !== undefined){'
                        +'this.'+sFull+'__plr.destroy(false);'
                    +'};'#13
                    +'this.'+sFull+'__plr = new HlsPlayer({'#13
                        +'"id": "'+sFull+'",'#13
                        +'"poster": "'+sPoster+'",'#13
                        +'"url": "'+StringReplace(FileName,'"','\"',[rfReplaceAll])+'",'#13
                        +'"isLive": '+dwIIF(iIsLive=1,'true','false')+','#13
                        +'"autoplay": '+dwIIF(AutoOpen or AIsPlay,'true','false')+','#13
                        +'"closeVideoClick": true,'#13
                        +'"playsinline": true,'#13
                        +'"fluid": true,'#13

                        //设定值
                        +'"bufferBehind": 5,'#13
                        +'"retryCount":  5,'#13
                        +'"retryDelay": 5000,'#13
                        +'"loadTimeout": 10000,'#13

                        //
                        +'"whitelist": []'#13
                    +'});';
        end else if sType = 'mp4' then begin
            Result  := ''
                    +'if (this.'+sFull+'__plr !== undefined){'
                        +'this.'+sFull+'__plr.destroy(false);'
                    +'};'#13
                    +'this.'+sFull+'__plr = new Player({'#13
                        +'"id": "'+sFull+'",'#13
                        +'"poster": "'+sPoster+'",'#13
                        +'"url": "'+StringReplace(FileName,'"','\"',[rfReplaceAll])+'",'#13
                        +'"autoplay": '+dwIIF(AutoOpen or AIsPlay,'true','false')+','#13
                        +'"closeVideoClick": true,'#13
                        +'"playsinline": true,'#13
                        +'"fluid": true,'#13
                        +'"whitelist": []'#13
                    +'});';

        end else if sType = 'flv' then begin
            Result  := ''
                    +'if (this.'+sFull+'__plr !== undefined){'
                        +'this.'+sFull+'__plr.destroy(false);'
                    +'};'#13
                    +'this.'+sFull+'__plr = new FlvPlayer({'#13
                        +'"id": "'+sFull+'",'#13
                        +'"poster": "'+sPoster+'",'#13
                        +'"url": "'+StringReplace(FileName,'"','\"',[rfReplaceAll])+'",'#13
                        +'"autoplay": '+dwIIF(AutoOpen or AIsPlay,'true','false')+','#13
                        +'"closeVideoClick": true,'#13
                        +'"playsinline": true,'#13
                        +'"fluid": true,'#13
                        +'"whitelist": []'#13
                    +'});';
        end else if sType = 'mpd' then begin
            Result  := ''
                    +'if (this.'+sFull+'__plr !== undefined){'
                        +'this.'+sFull+'__plr.destroy(false);'
                    +'};'#13
                    +'this.'+sFull+'__plr = new ShakaJsPlayer({'#13
                        +'"id": "'+sFull+'",'#13
                        +'"poster": "'+sPoster+'",'#13
                        +'"url": "'+StringReplace(FileName,'"','\"',[rfReplaceAll])+'",'#13
                        +'"autoplay": '+dwIIF(AutoOpen or AIsPlay,'true','false')+','#13
                        +'"closeVideoClick": true,'#13
                        +'"fluid": true,'#13
                        +'"playsinline": true,'#13
                        +'"whitelist": []'#13
                    +'});';
        end;

    end;
end;

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):String;stdCall;
var
    joRes       : Variant;
    joHint      : Variant;
begin
    //取得HINT对象JSON
    joHint  := dwGetHintJson(TControl(ACtrl));

    with TMediaPlayer(Actrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');

        //需要额外引的代码
        joRes.Add('<script charset="utf-8" src="https://unpkg.byted-static.com/xgplayer/2.31.6/browser/index.js"></script>');
        joRes.Add('<script charset="utf-8" src="https://unpkg.byted-static.com/xgplayer-hls/2.5.2/dist/index.min.js"></script>');
        joRes.Add('<script charset="utf-8" src="https://unpkg.byted-static.com/xgplayer-flv/2.5.1/dist/index.min.js"></script>');
        joRes.Add('<script charset="utf-8" src="https://unpkg.byted-static.com/xgplayer-shaka/1.1.5/browser/index.js"></script>');
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
    //取得控件全名备用
    sFull   := dwFullName(ACtrl);

    //生成返回值数组
    joRes   := _Json('[]');

    //取得HINT对象JSON
    joHint  := dwGetHintJson(TControl(ACtrl));

    //
    with TMediaPlayer(ACtrl) do begin

        //外框
        sCode   := '<div'
                +' id="'+sFull+'"'
                +dwVisible(TControl(ACtrl))                            //用于控制可见性Visible
                +dwGetDWAttr(joHint)
                +' :style="{'
                    +'left:'+sFull+'__lef,'
                    +'top:'+sFull+'__top,'
                    +'width:'+sFull+'__wid,'
                    +'height:'+sFull+'__hei'
                +'}"'
                +' style="position:absolute;'
                    +dwGetDWStyle(joHint)
                +'"' // 封闭style
                +'>';
        //添加到返回值数据
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
        //生成返回值数组
        joRes    := _Json('[]');
        //生成返回值数组
        joRes.Add('</div>');
        //
        Result    := (joRes);
    end;
end;

//取得Data消息
function dwGetData(ACtrl:TComponent):String;StdCall;
var
    joRes    : Variant;
    sFull       : string;
begin
    //取得控件全名备用
    sFull   := dwFullName(ACtrl);
    //
    with TMediaPlayer(ACtrl) do begin

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
            //
            joRes.Add(sFull+'__plr:undefined,');
        end;
        //
        Result    := (joRes);
    end;
end;

//取得事件
function dwGetAction(ACtrl:TComponent):String;StdCall;
var
    joRes       : Variant;
    joHint      : Variant;
    sFull       : string;
    sCode       : string;
    sType       : string;   //视频类型，mp4/hls/flv/mpd，  默认为hls, 即m3u8
    sPoster     : String;   //封面，默认 //lf9-cdn-tos.bytecdntp.com/cdn/expire-1-M/byted-player-videos/1.0.0/poster.jpg
    iIsLive     : Integer;  //是否直播，0/1，默认0
begin
    //取得控件全名备用
    sFull   := dwFullName(ACtrl);

    //取得HINT对象JSON
    joHint  := dwGetHintJson(TControl(ACtrl));

    //封面，默认 //lf9-cdn-tos.bytecdntp.com/cdn/expire-1-M/byted-player-videos/1.0.0/poster.jpg
    sPoster   := dwGetStr(joHint,'poster','//lf9-cdn-tos.bytecdntp.com/cdn/expire-1-M/byted-player-videos/1.0.0/poster.jpg');

    //是否直播，0/1，默认0
    iIsLive := dwGetInt(joHint,'islive',0);

    //
    with TMediaPlayer(ACtrl) do begin

        //视频类型，mp4/hls/flv/mpd，  默认为hls, 即m3u8
        sType   := _GetType(FileName);

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
        joRes.Add('this.'+sFull+'__src="'+StringReplace(FileName,'"','\"',[rfReplaceAll])+'";');

        //
        if EnabledButtons  = [btPlay] then begin
            //如果已加载，则直接play. 如果未加载，则设置autoplay
            if StyleName = FileName then begin
                sCode   := 'this.'+sFull+'__plr.play();';
            end else begin
                sCode   := _GetInit(ACtrl,True);
                StyleName   := FileName;
            end;
            joRes.Add(sCode);
            EnabledButtons := [];
        end else begin
            joRes.Add('');      //增加一项空值，用于对齐
        end;
        if EnabledButtons  = [btPause] then begin
            sCode   := 'this.'+sFull+'__plr.pause();';
            joRes.Add(sCode);
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

//取得Mounted
function dwGetMounted(ACtrl:TComponent):String;StdCall;
var
    joRes       : Variant;
    joHint      : Variant;
    sCode       : string;
    sFull       : string;
    sType       : string;   //视频类型，mp4/hls/flv/mpd，  默认为hls, 即m3u8
    sPoster     : String;   //封面，默认 //lf9-cdn-tos.bytecdntp.com/cdn/expire-1-M/byted-player-videos/1.0.0/poster.jpg
    iIsLive     : Integer;  //是否直播，0/1，默认0
begin
    //生成返回值数组
    joRes   := _Json('[]');
    //
    sFull   := dwFullName(ACtrl);

    //取得HINT对象JSON
    joHint  := dwGetHintJson(TControl(ACtrl));

    //封面，默认 //lf9-cdn-tos.bytecdntp.com/cdn/expire-1-M/byted-player-videos/1.0.0/poster.jpg
    sPoster := dwGetStr(joHint,'poster','//lf9-cdn-tos.bytecdntp.com/cdn/expire-1-M/byted-player-videos/1.0.0/poster.jpg');

    //是否直播，0/1，默认0
    iIsLive := dwGetInt(joHint,'islive',0);

    //
    with TMediaplayer(ACtrl) do begin
        if AutoOpen then begin
            //用stylename保存老的FileName
            StyleName   := FileName;
        end;

        //
        if Trim(FileName) <> '' then begin
            sCode   := _GetInit(ACtrl,False);
        end;
        joRes.Add(sCode);
    end;
    //
    Result    := (joRes);
end;


exports
    dwGetMounted,
    dwGetExtra,
    dwGetEvent,
    dwGetHead,
    dwGetTail,
    dwGetAction,
    dwGetData;

begin
end.

