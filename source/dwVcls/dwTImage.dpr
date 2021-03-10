library dwTImage;

uses
     ShareMem,      //必须添加

     //
     dwCtrlBase,    //一些基础函数

     //
     SynCommons,    //mormot用于解析JSON的单元

     //
     SysUtils,DateUtils,ComCtrls, ExtCtrls,
     Vcl.Imaging.jpeg,Vcl.Graphics,
     Classes,
     Dialogs,
     StdCtrls,
     Windows,
     Controls,
     Forms;

const
     CodeChar: array [0 .. 31] of char = (
          '2','3','4','5','6','7','8','9',
          'A','B','C','D','E','F','G','H',
          'J','K','L','M','N','P','Q','R',
          'S','T','U','V','W','X','Y','Z');

     CodeChar1: array [0 .. 31] of char = (
          '我','妮','爱','他','他','随','你','吗','秋',
          '琳','英','圈','坤','菜','平','后','芳','要',
          '香','港','澳','情','感','值','得','宾','开',
          '枪','飞','鸡','鸭','睛');


function _CreateCaptcha(AWidth,AHeight:Integer;var ASrc,ACaptcha:String):Integer;
var
     //
     iFont     : Integer;
     I,X,Y     : Integer;
     sTmp      : String;
     oBmp      : Vcl.Graphics.TBitmap;

begin
     try
          //文件名称=随机前缀（可自行更改）+日期
          ASrc     := 'LJTRNB_'+FormatDateTime('YYYYMMdd_hhmmss_zzz',now)+'.jpg';
          //
          oBmp := Vcl.Graphics.TBitmap.Create;
          oBmp.Width     := AWidth;
          oBmp.Height    := AHeight;
          oBmp.Canvas.Pen.Width    := 1;
          iFont     := AWidth div 8; //可以写N个字符的
          oBmp.Canvas.Font.Size:= iFont;
          oBmp.Canvas.Font.Name:='微软雅黑';
          oBmp.Canvas.Font.Color:=clGreen;
          //先随机画线200条
          for I := 0 to (AWidth*AHeight) div 300 do  begin
               Randomize;
               oBmp.Canvas.Pen.Color:= RGB(Random(156)+100, Random(156)+100,Random(156)+100);
               oBmp.Canvas.MoveTo(Random(AWidth),Random(AHeight));
               oBmp.Canvas.LineTo(Random(AWidth),Random(AHeight));
          end;
          oBmp.Canvas.Font.Color:=RGB(Random(10), Random(100),Random(100));//clBlack;
          oBmp.Canvas.Font.Style:=[fsBold,fsItalic];


          //最多有四个字符
          X    := 0;
          ACaptcha  := '';
          oBmp.Canvas.Brush.Style:=bsClear;
          for I :=0 to 3 do begin
               Randomize;
               sTmp      := CodeChar[Random(Length(CodeChar))];
               ACaptcha  := ACaptcha + sTmp;
               X    := X + Random((AWidth-iFont*2) div 4);
               oBmp.Canvas.TextOut(X,Random(AHeight-iFont*2),sTmp);
               x:=x+iFont;
          end;

          //再随机画线
          for I := 0 to (AWidth*AHeight) div 400 do  begin
               Randomize;
               oBmp.Canvas.Pen.Color:= RGB(Random(156)+100, Random(156)+100,Random(156)+100);
               oBmp.Canvas.MoveTo(Random(AWidth),Random(AHeight));
               oBmp.Canvas.LineTo(Random(AWidth),Random(AHeight));
          end;

          //
          oBmp.SaveToFile('media/images/'+ASrc);
          oBmp.Destroy;
          //>

          //
          Result    := 1;
     except
     end;
end;


//当前控件需要引入的第三方JS/CSS ,一般为不做改动,目前仅在TChart使用时需要用到
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
     joRes     : Variant;
begin
     if TImage(ACtrl).HelpKeyword = 'captcha' then begin
          //=============验证码=================================================

          //生成返回值数组
          joRes    := _Json('[]');

          {
          //以下是TChart时的代码,供参考
          joRes.Add('<script src="dist/charts/echarts.min.js"></script>');
          joRes.Add('<script src="dist/charts/lib/index.min.js"></script>');
          joRes.Add('<link rel="stylesheet" href="dist/charts/lib/style.min.css">');
          }

          //
          Result    := joRes;
     end else begin
          //=============普通图片===============================================

          //生成返回值数组
          joRes    := _Json('[]');

          {
          //以下是TChart时的代码,供参考
          joRes.Add('<script src="dist/charts/echarts.min.js"></script>');
          joRes.Add('<script src="dist/charts/lib/index.min.js"></script>');
          joRes.Add('<link rel="stylesheet" href="dist/charts/lib/style.min.css">');
          }

          //
          Result    := joRes;
     end;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData    : Variant;
     sSrc      : string;
     sCaptcha  : string;
begin
     if TImage(ACtrl).HelpKeyword = 'captcha' then begin
          //=============验证码=================================================
          //
          joData    := _Json(AData);

          if joData.e = 'onclick' then begin
               //重新生成验证码
               with TImage(ACtrl) do begin
                    _CreateCaptcha(Width,Height,sSrc,sCaptcha);
                    //
                    Hint := '{"src":"media/images/'+sSrc+'","captcha":"'+sCaptcha+'"}';
               end;
          end;
     end else begin
          //=============普通图片===============================================

          //
          joData    := _Json(AData);

          if joData.e = 'onclick' then begin
               //
               if Assigned(TImage(ACtrl).OnClick) then begin
                    TImage(ACtrl).OnClick(TImage(ACtrl));
               end;
          end else if joData.e = 'onenter' then begin
               //
               if Assigned(TImage(ACtrl).OnMouseEnter) then begin
                    TImage(ACtrl).OnMouseEnter(TImage(ACtrl));
               end;
          end else if joData.e = 'onexit' then begin
               //
               if Assigned(TImage(ACtrl).OnMouseLeave) then begin
                    TImage(ACtrl).OnMouseLeave(TImage(ACtrl));
               end;
          end;
     end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
     sCode     : string;
     sSize     : string;
     sName     : string;
     sRadius   : string;
     //
     joHint    : Variant;
     joRes     : Variant;
     sSrc      : String;
     sCaptcha  : string;
begin
     if TImage(ACtrl).HelpKeyword = 'captcha' then begin
          //=============验证码=================================================

          //生成返回值数组
          joRes    := _Json('[]');

          //取得HINT对象JSON
          joHint    := dwGetHintJson(TControl(ACtrl));


          with TImage(ACtrl) do begin
               //生成验证码
               _CreateCaptcha(Width,Height,sSrc,sCaptcha);
               //
               Hint := '{"src":"media/images/'+sSrc+'","captcha":"'+sCaptcha+'"}';

               //
               joRes.Add('<el-image'
                         +' id="'+Name+'"'
                         +' :src="'+Name+'__src"'
                         +' fit="none"'
                         +dwVisible(TControl(ACtrl))
                         +dwDisable(TControl(ACtrl))
                         +dwLTWH(TControl(ACtrl))
                         +sRadius
                         +'cursor: pointer;'
                         +'"'
                         +dwIIF(True,Format(_DWEVENT,['click',Name,'0','onclick','']),'')
                    +'>');
          end;

          //
          Result    := (joRes);

     end else begin
          //=============普通图片===============================================

          //生成返回值数组
          joRes    := _Json('[]');

          //取得HINT对象JSON
          joHint    := dwGetHintJson(TControl(ACtrl));

          //得到圆角半径信息
          sRadius   := dwGetHintValue(joHint,'radius','border-radius','');
          sRadius   := StringReplace(sRadius,'=',':',[]);
          sRadius   := Trim(StringReplace(sRadius,'"','',[rfReplaceAll]));
          if sRadius<>'' then begin
               sRadius   := sRadius + ';';
          end;

          with TImage(ACtrl) do begin
               //如果没有手动设置图片源，则自动保存当前图片，并设置为图片源
               if dwGetProp(TControl(ACtrl),'src')='' then begin
                    sName     := 'dist\webimages\'+Name+'.jpg';
                    //保存图片到本地
                    if not FileExists(sName) then begin
                         Picture.SaveToFile(sName);
                    end;
               end;

               if Proportional then begin
                    joRes.Add('<el-image'
                              +dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick','']),'')
                              +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter','']),'')
                              +dwIIF(Assigned(OnMOuseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit','']),'')
                              +' :src="'+Name+'__src" fit="contain"'
                              +dwVisible(TControl(ACtrl))
                              +dwDisable(TControl(ACtrl))
                              +dwLTWH(TControl(ACtrl))
                              +sRadius
                              +dwIIF(Assigned(OnClick),'cursor: pointer;','')
                              +'"'
                              +'>');
               end else begin
                    if Stretch then begin
                         joRes.Add('<el-image :src="'+Name+'__src" fit="fill"'
                                   +dwVisible(TControl(ACtrl))
                                   +dwDisable(TControl(ACtrl))
                                   +dwLTWH(TControl(ACtrl))
                                   +sRadius
                                   +dwIIF(Assigned(OnClick),'cursor: pointer;','')
                                   +'"'
                                   +dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick','']),'')
                                   +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter','']),'')
                                   +dwIIF(Assigned(OnMOuseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit','']),'')
                              +'>');
                    end else begin
                         joRes.Add('<el-image :src="'+Name+'__src" fit="none"'
                                   +dwVisible(TControl(ACtrl))
                                   +dwDisable(TControl(ACtrl))
                                   +dwLTWH(TControl(ACtrl))
                                   +sRadius
                                   +dwIIF(Assigned(OnClick),'cursor: pointer;','')
                                   +'"'
                                   +dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick','']),'')
                                   +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter','']),'')
                                   +dwIIF(Assigned(OnMOuseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit','']),'')
                              +'>');
                    end;
               end;
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
     if TImage(ACtrl).HelpKeyword = 'captcha' then begin
          //=============验证码=================================================


          //生成返回值数组
          joRes    := _Json('[]');

          //生成返回值数组
          joRes.Add('</el-Image>');          //此处需要和dwGetHead对应

          //
          Result    := (joRes);
     end else begin
          //=============普通图片===============================================

          //生成返回值数组
          joRes    := _Json('[]');

          //生成返回值数组
          joRes.Add('</el-Image>');          //此处需要和dwGetHead对应

          //
          Result    := (joRes);
     end;
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     if TImage(ACtrl).HelpKeyword = 'captcha' then begin
          //=============验证码=================================================

          //生成返回值数组
          joRes    := _Json('[]');
          //
          with TImage(ACtrl) do begin
               joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
               joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
               joRes.Add(Name+'__wid:"'+IntToStr(Width)+'px",');
               joRes.Add(Name+'__hei:"'+IntToStr(Height)+'px",');
               //
               joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
               joRes.Add(Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
               //
               joRes.Add(Name+'__src:"'+dwGetProp(TControl(ACtrl),'src')+'",');
          end;
          //
          Result    := (joRes);
     end else begin
          //=============普通图片===============================================

          //生成返回值数组
          joRes    := _Json('[]');
          //
          with TImage(ACtrl) do begin
               joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
               joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
               joRes.Add(Name+'__wid:"'+IntToStr(Width)+'px",');
               joRes.Add(Name+'__hei:"'+IntToStr(Height)+'px",');
               //
               joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
               joRes.Add(Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
               //
               if dwGetProp(TControl(ACtrl),'src')='' then begin
                    joRes.Add(Name+'__src:"dist/webimages/'+Name+'.jpg",');
               end else begin
                    joRes.Add(Name+'__src:"'+dwGetProp(TControl(ACtrl),'src')+'",');
               end;
          end;
          //
          Result    := (joRes);
     end;
end;

function dwGetMethod(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     if TImage(ACtrl).HelpKeyword = 'captcha' then begin
          //=============验证码=================================================


          //生成返回值数组
          joRes    := _Json('[]');
          //
          with TImage(ACtrl) do begin
               joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
               joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
               joRes.Add('this.'+Name+'__wid="'+IntToStr(Width)+'px";');
               joRes.Add('this.'+Name+'__hei="'+IntToStr(Height)+'px";');
               //
               joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
               joRes.Add('this.'+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
               //
               joRes.Add('this.'+Name+'__src="'+dwGetProp(TControl(ACtrl),'src')+'";');
          end;
          //
          Result    := (joRes);
     end else begin
          //=============普通图片===============================================

          //生成返回值数组
          joRes    := _Json('[]');
          //
          with TImage(ACtrl) do begin
               joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
               joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
               joRes.Add('this.'+Name+'__wid="'+IntToStr(Width)+'px";');
               joRes.Add('this.'+Name+'__hei="'+IntToStr(Height)+'px";');
               //
               joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
               joRes.Add('this.'+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
               //
               if dwGetProp(TControl(ACtrl),'src')='' then begin
                    joRes.Add('this.'+Name+'__src="dist/webimages/'+Name+'.jpg";');
               end else begin
                    joRes.Add('this.'+Name+'__src="'+dwGetProp(TControl(ACtrl),'src')+'";');
               end;
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
     dwGetMethod,
     dwGetData;
     
begin
end.
 
