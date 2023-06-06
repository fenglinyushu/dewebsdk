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



//当前控件需要引入的第三方JS/CSS ,一般为不做改动,目前仅在TChart使用时需要用到
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    joRes     : Variant;
begin
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

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
    joData      : Variant;
    sSrc        : string;
    sCaptcha    : string;
    iX,iY       : Integer;
begin
    //=============普通图片===============================================

    //
    joData    := _Json(AData);

    if joData.e = 'onclick' then begin
         //
         if Assigned(TImage(ACtrl).OnClick) then begin
              TImage(ACtrl).OnClick(TImage(ACtrl));
         end;
    end else if joData.e = 'onmousedown' then begin
        if Assigned(TLabel(ACtrl).OnMouseDown) then begin
            iX  := StrToIntDef(joData.v,0);
            iY  := iX mod 100000;
            iX  := iX div 100000;
            TLabel(ACtrl).OnMouseDown(TLabel(ACtrl),mbLeft,[],iX,iY);
        end;
    end else if joData.e = 'onmouseup' then begin
        if Assigned(TLabel(ACtrl).OnMouseup) then begin
            iX  := StrToIntDef(joData.v,0);
            iY  := iX mod 100000;
            iX  := iX div 100000;
            TLabel(ACtrl).OnMouseup(TLabel(ACtrl),mbLeft,[],iX,iY);
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


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode       : string;
    sSize       : string;
    sName       : string;
    sRadius     : string;
    sPreview    : string;   //用于预览的字符串
    //
    joHint      : Variant;
    joRes       : Variant;
    sSrc        : String;
    sCaptcha    : string;
    //JS 代码
    sEnter      : String;
    sExit       : String;
    sClick      : string;
begin
    //=============普通图片===================================================================

    //生成返回值数组
    joRes    := _Json('[]');

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    if joHint = null then begin
        ShowMessage(TControl(ACtrl).Hint);
    end;


    with TImage(ACtrl) do begin
        //进入事件代码----------------------------------------------------------------------------
        sEnter  := '';
        if joHint.Exists('onenter') then begin
            sEnter  := 'dwexecute('''+dwProcQuotation(String(joHint.onenter))+''');';    //取得OnEnter的JS代码
        end;
        if sEnter='' then begin
            if Assigned(OnMouseEnter) then begin
                sEnter    := Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]);
            end else begin

            end;
        end else begin
            if Assigned(OnMouseEnter) then begin
                sEnter    := Format(_DWEVENTPlus,['mouseenter.native',sEnter,Name,'0','onenter',TForm(Owner).Handle])
            end else begin
                sEnter    := ' @mouseenter.native="'+sEnter+'"';
            end;
        end;


      //退出事件代码----------------------------------------------------------------------------
        sExit  := '';
        if joHint.Exists('onexit') then begin
            sExit  := 'dwexecute('''+dwProcQuotation(String(joHint.onexit))+''');';
        end;
        if sExit='' then begin
            if Assigned(OnMouseLeave) then begin
                sExit    := Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]);
            end else begin

            end;
        end else begin
            if Assigned(OnMouseLeave) then begin
                sExit    := Format(_DWEVENTPlus,['mouseleave.native',sExit,Name,'0','onexit',TForm(Owner).Handle])
            end else begin
                sExit    := ' @mouseleave.native="'+sExit+'"';
            end;
        end;

        //单击事件的JS代码------------------------------------------------------------------------
        sClick    := '';
        if joHint.Exists('onclick') then begin
            sClick := 'dwexecute('''+dwProcQuotation(String(joHint.onclick))+''');';
        end;
        //
        if sClick='' then begin
            if Assigned(OnClick) then begin
                sClick    := Format(_DWEVENT,['click.native',Name,'0','onclick',TForm(Owner).Handle]);
            end else begin

            end;
        end else begin
            if Assigned(OnClick) then begin
                sClick    := Format(_DWEVENTPlus,['click.native',sClick,Name,'0','onclick',TForm(Owner).Handle])
            end else begin
                sClick    := ' @click.native="'+sClick+'"';
            end;
        end;
    end;


    //得到圆角半径信息
    sRadius   := dwGetHintValue(joHint,'radius','border-radius','');
    sRadius   := StringReplace(sRadius,'=',':',[]);
    sRadius   := Trim(StringReplace(sRadius,'"','',[rfReplaceAll]));
    if sRadius<>'' then begin
        sRadius   := sRadius + ';';
    end;

    with TImage(ACtrl) do begin
        //如果没有手动设置图片源，则自动保存当前图片，并设置为图片源
        //if dwGetProp(TControl(ACtrl),'src')='' then begin
        //    sName     := 'dist\webimages\'+dwFullName(Actrl)+'.jpg';
        //    //保存图片到本地
        //    if not FileExists(sName) then begin
        //        Picture.SaveToFile(sName);
        //    end;
        //end;

        //生成预览字符串
        if IncrementalDisplay then begin
            sClick  := ' @click="image_preview_list=[];image_preview_list.push('+dwFullName(Actrl)+'__src);"';
        end;

        //2021-07-28 更改为可动态设置href
        //if joHint.Exists('href') then begin
        //    joRes.Add('<a href="'+String(joHint.href+'" target="_blank">');
        //end else if joHint.Exists('hrefself') then begin
        //    joRes.Add('<a href="'+String(joHint.hrefself+'">');
        //end;
        if joHint.Exists('href') then begin
            joRes.Add('<a :href="'+dwFullName(Actrl)+'__hrf" target="_blank">');
        end else if joHint.Exists('hrefself') then begin
            joRes.Add('<a :href="'+dwFullName(Actrl)+'__hrf">');
        end;

        //
        if Proportional then begin //Proportional:成比例的
            joRes.Add('<el-image'
                    //+dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),sPreview)
                    //+dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),'')
                    //+dwIIF(Assigned(OnMOuseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),'')
                    +' :src="'+dwFullName(Actrl)+'__src" fit="contain"'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +dwIIF(IncrementalDisplay,' :preview-src-list="image_preview_list"','')
                    +dwGetDWAttr(joHint)
                    +dwLTWH(TControl(ACtrl))
                    +sRadius
                    +dwIIF(sClick<>'','cursor: pointer;','')
                    +dwGetDWStyle(joHint)
                    +'"'
                    +dwIIF(Assigned(OnMouseDown),Format(_DWEVENT,['mousedown',Name,'event.offsetX*100000+event.offsetY','onmousedown',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnMouseUp),Format(_DWEVENT,['mouseup',Name,'event.offsetX*100000+event.offsetY','onmouseup',TForm(Owner).Handle]),'')
                    +sClick
                    +sEnter
                    +sExit
                    +'>');
        end else begin
            if Stretch then begin
                joRes.Add('<el-image :src="'+dwFullName(Actrl)+'__src" fit="fill"'
                        +dwVisible(TControl(ACtrl))
                        +dwDisable(TControl(ACtrl))
                        +dwIIF(IncrementalDisplay,' :preview-src-list="image_preview_list"','')
                        +dwGetDWAttr(joHint)
                        +dwLTWH(TControl(ACtrl))
                        +sRadius
                        +dwIIF(sClick<>'','cursor: pointer;','')
                        +dwGetDWStyle(joHint)
                        +'"'
                        //+dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
                        //+dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),sPreview)
                        //+dwIIF(Assigned(OnMOuseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),'')
                        +dwIIF(Assigned(OnMouseDown),Format(_DWEVENT,['mousedown',Name,'event.offsetX*100000+event.offsetY','onmousedown',TForm(Owner).Handle]),'')
                        +dwIIF(Assigned(OnMouseUp),Format(_DWEVENT,['mouseup',Name,'event.offsetX*100000+event.offsetY','onmouseup',TForm(Owner).Handle]),'')
                        +sClick
                        +sEnter
                        +sExit
                        +'>');
            end else begin
                joRes.Add('<el-image :src="'+dwFullName(Actrl)+'__src"  fit="none"'
                        +dwVisible(TControl(ACtrl))
                        +dwDisable(TControl(ACtrl))
                        +dwIIF(IncrementalDisplay,' :preview-src-list="image_preview_list"','')
                        +dwGetDWAttr(joHint)
                        +dwLTWH(TControl(ACtrl))
                        +sRadius
                        +dwIIF(sClick<>'','cursor: pointer;','')
                        +dwGetDWStyle(joHint)
                        +'"'
                        //+dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),sPreview)
                        //+dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),'')
                        //+dwIIF(Assigned(OnMOuseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),'')
                        +dwIIF(Assigned(OnMouseDown),Format(_DWEVENT,['mousedown',Name,'event.offsetX*100000+event.offsetY','onmousedown',TForm(Owner).Handle]),'')
                        +dwIIF(Assigned(OnMouseUp),Format(_DWEVENT,['mouseup',Name,'event.offsetX*100000+event.offsetY','onmouseup',TForm(Owner).Handle]),'')
                        +sClick
                        +sEnter
                        +sExit
                        +'>');
            end;
        end;
    end;

    //
    Result    := (joRes);
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
    joHint      : Variant;
begin
    //=============普通图片===============================================

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //生成返回值数组
    joRes    := _Json('[]');

    //生成返回值数组
    joRes.Add('</el-image>');          //此处需要和dwGetHead对应

    if joHint.Exists('href') OR joHint.Exists('hrefself') then begin
        joRes.Add('</a>');
    end;
    //
    Result    := (joRes);
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes   : Variant;
    joHint  : Variant;
begin
    //=============普通图片===============================================

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TImage(ACtrl) do begin
        joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(Enabled,'false,','true,'));
        //
        //if dwGetProp(TControl(ACtrl),'src')='' then begin
        //    joRes.Add(dwFullName(Actrl)+'__src:"dist/webimages/'+dwFullName(Actrl)+'.jpg",');
        //end else begin
            joRes.Add(dwFullName(Actrl)+'__src:"'+dwGetProp(TControl(ACtrl),'src')+'",');
        //end;

        //2021-07-28 更改为可动态设置href
        if joHint.Exists('href') then begin
             joRes.Add(dwFullName(Actrl)+'__hrf:"'+String(joHint.href)+'",');
        end else if joHint.Exists('hrefself') then begin
             joRes.Add(dwFullName(Actrl)+'__hrf:"'+String(joHint.hrefself)+'",');
        end;
    end;
    //
    Result    := (joRes);
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
    joHint    : Variant;
begin
    //=============普通图片===============================================


    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TImage(ACtrl) do begin
        joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');

        //joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
        //joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
        //joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
        //joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+dwFullName(Actrl)+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        //if dwGetProp(TControl(ACtrl),'src')='' then begin
        //    joRes.Add('this.'+dwFullName(Actrl)+'__src="dist/webimages/'+dwFullName(Actrl)+'.jpg";');
        //end else begin
            joRes.Add('this.'+dwFullName(Actrl)+'__src="'+dwGetProp(TControl(ACtrl),'src')+'";');
        //end;

        //2021-07-28 更改为可动态设置href
        if joHint.Exists('href') then begin
            joRes.Add('this.'+dwFullName(Actrl)+'__hrf="'+String(joHint.href)+'";');
        end else if joHint.Exists('hrefself') then begin
            joRes.Add('this.'+dwFullName(Actrl)+'__hrf="'+String(joHint.hrefself)+'";');
        end;
    end;
    //
    Result    := (joRes);
end;


exports
     //dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetData;
     
begin
end.
 
