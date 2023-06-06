library dwTMediaPlayer__easyplayer;

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
{
## 配置属性

| 参数               | 说明                                             | 类型                       | 默认值 |
| ------------------ | ------------------------------------------------ | -------------------------- | ------ |
| video-url          | 视频地址                                         | String                     | -      |
| video-title        | 视频右上角显示的标题                             | String                     | -      |
| snap-url           | 视频封面图片                                     | String                     | -      |
| auto-play          | 自动播放                                         | Boolean                    | true   |
| live               | 是否直播, 标识要不要显示进度条                   | Boolean                    | true   |
| speed              | 是否显示倍速播放按钮。注：当live为true，此不生效 |Boolean                     | true   |
| loop               | 是否轮播。                                       |Boolean                     | false  |
| alt                | 视频流地址没有指定情况下, 视频所在区域显示的文字 | String                     | 无信号 |
| muted              | 是否静音                                         | Boolean                    | false  |
| aspect             | 视频显示区域的宽高比                             | String                     | 16:9   |
| isaspect           | 视频显示区域是否强制宽高比                       | Boolean                    | true   |
| loading            | 指示加载状态, 支持 sync 修饰符                   | String                     | -      |
| fluent             | 流畅模式                                         | Boolean                    | true   |
| timeout            | 加载超时(秒)                                     | Number                     | 20     |
| stretch            | 是否不同分辨率强制铺满窗口                       | Boolean                    | false  |
| show-custom-button | 是否在工具栏显示自定义按钮(极速/流畅, 拉伸/标准) | Boolean                    | true   |
| isresolution       | 是否在播放 m3u8 时显示多清晰度选择               | Boolean                    | false  |
| isresolution       | 供选择的清晰度 "yh,fhd,hd,sd", yh:原始分辨率     | fhd:超清，hd:高清，sd:标清 | -      |
| resolutiondefault  | 默认播放的清晰度                                 | String                     | hd     |
### HTTP-FLV 播放相关属性
#### 注意：此属性只在播放flv格式的流时生效。
| 属性     | 说明                                   | 类型    | 默认值             |
| -------- | -------------------------------------- | ------- | ------------------ |
| hasaudio | 是否有音频，传递该属性可以加快启播速度 | Boolean | 默认不配置自动判断 |
| hasvideo | 是否有视频，传递该属性可以加快启播速度 | Boolean | 默认不配置自动判断 |
## 事件回调
| 方法名     | 说明         | 参数                  |
| ---------- | ------------ | --------------------- |
| video-url  | 触发通知消息 | type: '', message: '' |
| ended      | 播放结束     | -                     |
| timeupdate | 进度更新     | 当前时间进度          |
| pause      | 暂停         | 当前时间进度          |
| play       | 播放         | 当前时间进度          |

}

//==================================================================================================

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):String;stdCall;
var
    joRes     : Variant;
begin
    with TMediaPlayer(Actrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');


        //需要额外引的代码
        //joRes.Add('<script src="dist/_jquery/jquery.min.js"></script>');
        joRes.Add('<script src="dist/_easyplayer/EasyPlayer-element.min.js"></script>');

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

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //外框
        sCode     := '<div'
                 +' id="'+dwFullName(Actrl)+'_frm"'
                 +dwGetDWAttr(joHint)
                 +dwVisible(TControl(ACtrl))                            //用于控制可见性Visible
                 +dwLTWH(TControl(ACtrl))                               //Left/Top/Width/Height
                 +dwGetDWStyle(joHint)
                 +'"' // 封闭style
                 +'>';
        //添加到返回值数据
        joRes.Add(sCode);

        //<easy-player id="player" live="true" show-custom-button="true"></easy-player>
        sCode     := '<easy-player'
            +' id="'+dwFullName(Actrl)+'"'

            //| video-url          | 视频地址                                         | String      | -      |
            +' :video-url="'+dwFullName(Actrl)+'__src"'

            //| video-title        | 视频右上角显示的标题                             | String      | -      |
            +dwGetAttr(joHint,'video-title')

            //|            | 视频封面图片                                             | String               |
            +dwGetAttr(joHint,'snap-url')

            //| auto-play          | 自动播放                                         | Boolean     | true   |
            +' auto-play='+dwIIF(AutoOpen,'"true"','"false"')

            //| live               | 是否直播, 标识要不要显示进度条                   | Boolean     | true   |
            +dwGetAttrBoolean(joHint,'live')

            //| speed              | 是否显示倍速播放按钮。注：当live为true，此不生效 |Boolean      | true   |
            +dwGetAttrBoolean(joHint,'speed')

            //| loop               | 是否轮播。                                       |Boolean      | false  |
            +' loop='+dwIIF(AutoRewind,'"true"','"false"')

            //| alt                | 视频流地址没有指定情况下, 视频所在区域显示的文字 | String      | 无信号 |
            +dwGetAttr(joHint,'alt')

            //| muted              | 是否静音                                         | Boolean     | false  |
            +dwGetAttrBoolean(joHint,'muted')

            //| aspect             | 视频显示区域的宽高比                             | String      | 16:9   |
            +dwGetAttr(joHint,'aspect')

            //| isaspect           | 视频显示区域是否强制宽高比                       | Boolean     | true   |
            +dwGetAttrBoolean(joHint,'isaspect')

            //| loading            | 指示加载状态, 支持 sync 修饰符                   | String      | -      |
            +dwGetAttr(joHint,'loading')

            //| fluent             | 流畅模式                                         | Boolean     | true   |
            +dwGetAttrBoolean(joHint,'fluent')

            //| timeout            | 加载超时(秒)                                     | Number      | 20     |
            //+dwGetAttrInteger(joHint,'timeout')

            //| stretch            | 是否不同分辨率强制铺满窗口                       | Boolean     | false  |
            +dwGetAttrBoolean(joHint,'stretch')

            //| show-custom-button | 是否在工具栏显示自定义按钮(极速/流畅, 拉伸/标准) | Boolean     | true   |
            +dwGetAttrBoolean(joHint,'show-custom-button')

            //| isresolution       | 是否在播放 m3u8 时显示多清晰度选择               | Boolean     | false  |
            +dwGetAttrBoolean(joHint,'isresolution')

            //| isresolution       | 供选择的清晰度 "yh,fhd,hd,sd", yh:原始分辨率     | fhd:超清，hd:高清，sd:标清 | -      |
            +dwGetAttr(joHint,'isresolution')

            //| resolutiondefault  | 默认播放的清晰度                                 | String      | hd     |
            +dwGetAttr(joHint,'resolutiondefault')

            +' >';

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
        joRes.Add('</easy-player>');
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

        //
        if EnabledButtons  = [btPlay] then begin
            joRes.Add('var player = videojs("'+dwFullName(Actrl)+'");  player.play();');
            EnabledButtons := [];
        end else begin
            joRes.Add('');      //增加一项空值，用于对齐
        end;
        if EnabledButtons  = [btPause] then begin
            joRes.Add('var player = videojs("'+dwFullName(Actrl)+'"); player.pause();');
            EnabledButtons := [];
        end else begin
            joRes.Add('');
        end;
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
 
