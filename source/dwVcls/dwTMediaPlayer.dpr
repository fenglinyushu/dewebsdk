library dwTMediaPlayer;

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

//��ǰ�ؼ���Ҫ����ĵ�����JS/CSS
function dwGetExtra(ACtrl:TComponent):String;stdCall;
var
     joRes     : Variant;
begin
     with TMediaPlayer(Actrl) do begin
          if HelpKeyword = 'm3u8' then begin
               //============m3u8��ʽ===========================================

               //���ɷ���ֵ����
               joRes    := _Json('[]');


               //��Ҫ�������Ĵ���
               joRes.Add('<link href="dist/_videom3u8/video-js.css" rel="stylesheet" />');
               joRes.Add('<script src="dist/_videom3u8/video.js"></script>');

               //
               Result    := joRes;

          end else if HelpKeyword = 'mp3' then begin
               //============mp3��ʽ============================================

               Result    := '[]';

          end else begin
               //============mp4��ʽ============================================

               Result    := '["<link rel=\"stylesheet\" href=\"dist/_video/video-js.min.css\">",'
                         +'"<script src=\"dist/_video/video.min.js\"></script>"]';
          end;
     end;
end;

//����JSON����ADataִ�е�ǰ�ؼ����¼�, �����ؽ���ַ���
function dwGetEvent(ACtrl:TComponent;AData:String):String;StdCall;
begin
     //
     //TMediaPlayer(ACtrl).OnClick(TMediaPlayer(ACtrl));
end;


//ȡ��HTMLͷ����Ϣ
function dwGetHead(ACtrl:TComponent):String;StdCall;
var
     sCode     : String;

     //
     joHint    : Variant;
     joRes     : Variant;
begin
     //
     with TMediaPlayer(ACtrl) do begin
          if HelpKeyword = 'm3u8' then begin
               //============m3u8��ʽ===========================================

               //���ɷ���ֵ����
               joRes    := _Json('[]');

               //ȡ��HINT����JSON
               joHint    := dwGetHintJson(TControl(ACtrl));

               //���
               sCode     := '<div'
                         +dwVisible(TControl(ACtrl))                            //���ڿ��ƿɼ���Visible
                         +dwLTWH(TControl(ACtrl))                               //Left/Top/Width/Height
                         +'"' // ���style
                         +'>';
               //��ӵ�����ֵ����
               joRes.Add(sCode);

               //
               sCode     := '<video'
                    +' id="'+Name+'"'
                    +' class="video-js  vjs-big-play-centered"'
                    +' controls'
                    +' preload="auto"'
                    +' style="width:100%;height:100%"'
                    //+' width="'+name+'__wid"'
                    //+' height="'+name+'__hei"'
                    +' data-setup="{}"'
                    +' >'
                    +'     <source :src="'+Name+'__src"'
                    +' type="application/x-mpegURL"/>';

               joRes.Add(sCode);
               //
               Result    := (joRes);

          end else if HelpKeyword = 'mp3' then begin
               //============mp3��ʽ============================================

               //���ɷ���ֵ����
               joRes    := _Json('[]');

               //ȡ��HINT����JSON
               joHint    := dwGetHintJson(TControl(ACtrl));

               //
               sCode     := '<div'
                         +dwVisible(TControl(ACtrl))                            //���ڿ��ƿɼ���Visible
                         +dwLTWH(TControl(ACtrl))                               //Left/Top/Width/Height
                         +'"' // ���style
                         +'>';
               //��ӵ�����ֵ����
               joRes.Add(sCode);

               //
               sCode     := '    <audio'
                    +' id="'+Name+'"'
                    +' :preload="true"'
                    +' :src="'+Name+'__src"'
                    +' :autoplay="'+Name+'__aut"'
                    +' :loop="'+Name+'__loo"'
                    +' :controls="'+Name+'__vis"'
                    +' style="width:100%;height:100%"'
                    +'>';

               joRes.Add(sCode);

               //
               Result    := (joRes);
          end else begin
               //============mp4��ʽ============================================

               //���ɷ���ֵ����
               joRes    := _Json('[]');

               //ȡ��HINT����JSON
               joHint    := dwGetHintJson(TControl(ACtrl));

               //
               sCode     := '<video'
                         +' id="'+Name+'"'
                         +' class="video-js vjs-big-play-centered"'
                         +dwVisible(TControl(ACtrl))
                         +' :preload="true"'
                         +' :loop="'+Name+'__loo"'
                         +' :autoplay="'+Name+'__aut"'
                         +' :src="'+Name+'__src"'
                         +' data-setup="{}"'
                         +' controls'
                         //+' :poster="poster"'
                         //+dwDisable(TControl(ACtrl))
                         //+dwGetHintValue(joHint,'type','type',' type="default"')         //sButtonType
                         +dwLTWH(TControl(ACtrl))
                         +'"' //style ���
                         +'>';
               joRes.Add(sCode);
               //
               Result    := (joRes);
          end;
     end;
end;

//ȡ��HTMLβ����Ϣ
function dwGetTail(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin
     //
     with TMediaPlayer(ACtrl) do begin
          if HelpKeyword = 'm3u8' then begin
               //���ɷ���ֵ����
               joRes    := _Json('[]');
               //���ɷ���ֵ����
               joRes.Add('</video>');
               joRes.Add('</div>');
               //
               Result    := (joRes);

          end else if HelpKeyword = 'mp3' then begin
               //============mp3��ʽ============================================
               //���ɷ���ֵ����
               joRes    := _Json('[]');

               //���ɷ���ֵ����
               joRes.Add('    </audio>');
               joRes.Add('</div>');

               //
               Result    := (joRes);
          end else begin
               //============mp4��ʽ============================================

               //���ɷ���ֵ����
               joRes    := _Json('[]');
               //���ɷ���ֵ����
               joRes.Add('</video>');
               //
               Result    := (joRes);
          end;
     end;
end;

//ȡ��Data��Ϣ
function dwGetData(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin
     //
     with TMediaPlayer(ACtrl) do begin
          if HelpKeyword = 'm3u8' then begin
               //============m3u8��ʽ===========================================

               //���ɷ���ֵ����
               joRes    := _Json('[]');
               //
               with TMediaPlayer(ACtrl) do begin
                    joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
                    joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
                    joRes.Add(Name+'__wid:"'+IntToStr(Width)+'px",');
                    joRes.Add(Name+'__hei:"'+IntToStr(Height)+'px",');
                    //
                    joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
                    //
                    joRes.Add(Name+'__loo:'+dwIIF(AutoRewind,'true,','false,'));
                    joRes.Add(Name+'__aut:'+dwIIF(Enabled,'true,','false,'));
                    joRes.Add(Name+'__src:"'+FileName+'",');
               end;
               //
               Result    := (joRes);

          end else if HelpKeyword = 'mp3' then begin
               //============mp3��ʽ============================================

               //���ɷ���ֵ����
               joRes    := _Json('[]');
               //
               with TMediaPlayer(ACtrl) do begin
                    joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
                    joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
                    joRes.Add(Name+'__wid:"'+IntToStr(Width)+'px",');
                    joRes.Add(Name+'__hei:"'+IntToStr(Height)+'px",');
                    //
                    joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
                    //
                    joRes.Add(Name+'__loo:'+dwIIF(AutoRewind,'true,','false,'));
                    joRes.Add(Name+'__aut:'+dwIIF(Enabled,'true,','false,'));
                    joRes.Add(Name+'__src:"'+FileName+'",');
               end;
               //
               Result    := (joRes);


          end else begin
               //============mp4��ʽ============================================
               //���ɷ���ֵ����
               joRes    := _Json('[]');
               //
               with TMediaPlayer(ACtrl) do begin
                    joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
                    joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
                    joRes.Add(Name+'__wid:"'+IntToStr(Width)+'px",');
                    joRes.Add(Name+'__hei:"'+IntToStr(Height)+'px",');
                    //
                    joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
                    //
                    joRes.Add(Name+'__loo:'+dwIIF(AutoRewind,'true,','false,'));
                    joRes.Add(Name+'__aut:'+dwIIF(Enabled,'true,','false,'));
                    joRes.Add(Name+'__src:"'+FileName+'",');
               end;
               //
               Result    := (joRes);
          end;
     end;
end;

//ȡ���¼�
function dwGetMethod(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin
     //
     with TMediaPlayer(ACtrl) do begin
          if HelpKeyword = 'm3u8' then begin
               //============m3u8��ʽ===========================================
               //���ɷ���ֵ����
               joRes    := _Json('[]');
               //
               joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
               joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
               joRes.Add('this.'+Name+'__wid="'+IntToStr(Width)+'px";');
               joRes.Add('this.'+Name+'__hei="'+IntToStr(Height)+'px";');
               //
               joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
               //
               joRes.Add('this.'+Name+'__loo='+dwIIF(AutoRewind,'true;','false;'));
               joRes.Add('this.'+Name+'__aut='+dwIIF(Enabled,'true;','false;'));
               joRes.Add('this.'+Name+'__src="'+FileName+'";');

               //
               if EnabledButtons  = [btPlay] then begin
                    joRes.Add('var player = videojs("'+name+'");  player.play();');
                    EnabledButtons := [];
               end else begin
                    joRes.Add('');      //����һ���ֵ�����ڶ���
               end;
               if EnabledButtons  = [btPause] then begin
                    joRes.Add('var player = videojs("'+name+'"); player.pause();');
                    EnabledButtons := [];
               end else begin
                    joRes.Add('');
               end;
               if HelpContext > 0 then begin
                    joRes.Add('document.getElementById("'+Name+'").currentTime = '+IntToStr(HelpContext-1)+';');
                    HelpContext    := 0;
               end else begin
                    joRes.Add('');
               end;
               //
               Result    := (joRes);


          end else if HelpKeyword = 'mp3' then begin
               //============mp3��ʽ============================================

               //���ɷ���ֵ����
               joRes    := _Json('[]');
               //
               joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
               joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
               joRes.Add('this.'+Name+'__wid="'+IntToStr(Width)+'px";');
               joRes.Add('this.'+Name+'__hei="'+IntToStr(Height)+'px";');
               //
               joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
               //
               joRes.Add('this.'+Name+'__loo='+dwIIF(AutoRewind,'true;','false;'));
               joRes.Add('this.'+Name+'__aut='+dwIIF(Enabled,'true;','false;'));
               joRes.Add('this.'+Name+'__src="'+FileName+'";');

               //
               if EnabledButtons  = [btPlay] then begin
                    joRes.Add('document.getElementById("'+Name+'").play();');
                    EnabledButtons := [];
               end else begin
                    joRes.Add('');
               end;
               if EnabledButtons  = [btPause] then begin
                    joRes.Add('document.getElementById("'+Name+'").pause();');
                    EnabledButtons := [];
               end else begin
                    joRes.Add('');
               end;
               if HelpContext > 0 then begin
                    joRes.Add('document.getElementById("'+Name+'").currentTime = '+IntToStr(HelpContext-1)+';');
                    HelpContext    := 0;
               end else begin
                    joRes.Add('');
               end;
               //
               Result    := (joRes);


          end else begin
               //============mp4��ʽ============================================
               //���ɷ���ֵ����
               joRes    := _Json('[]');
               //
               joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
               joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
               joRes.Add('this.'+Name+'__wid="'+IntToStr(Width)+'px";');
               joRes.Add('this.'+Name+'__hei="'+IntToStr(Height)+'px";');
               //
               joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
               //
               joRes.Add('this.'+Name+'__loo='+dwIIF(AutoRewind,'true;','false;'));
               joRes.Add('this.'+Name+'__aut='+dwIIF(Enabled,'true;','false;'));
               joRes.Add('this.'+Name+'__src="'+FileName+'";');

               //
               if EnabledButtons  = [btPlay] then begin
                    joRes.Add('document.getElementById("'+Name+'").play();');
                    EnabledButtons := [];
               end else begin
                    joRes.Add('');
               end;
               if EnabledButtons  = [btPause] then begin
                    joRes.Add('document.getElementById("'+Name+'").pause();');
                    EnabledButtons := [];
               end else begin
                    joRes.Add('');
               end;
               if HelpContext > 0 then begin
                    joRes.Add('document.getElementById("'+Name+'").currentTime = '+IntToStr(HelpContext-1)+';');
                    HelpContext    := 0;
               end else begin
                    joRes.Add('');
               end;
               //
               Result    := (joRes);
          end;
     end;
end;

exports
     dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetMethod,
     dwGetData;
     
begin
end.
 
