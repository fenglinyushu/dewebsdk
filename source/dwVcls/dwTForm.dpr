library dwTForm;

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
//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
begin
     Result    := '[]';
end;
//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
    joData  : Variant;
    oAction : TCloseAction;
    oObject : TDragDockObject;
begin
    with TForm(ACtrl) do begin
        if HelpKeyword = 'dialog' then begin
            //-------------作为对话框---------------------------------------------------------------
        end else if HelpKeyword = 'embed' then begin
            //-------------作为嵌入式窗体-----------------------------------------------------------
            //
            joData    := _Json(AData);
            if joData.e = 'onclick' then begin
                if Assigned(OnClick) then begin
                    TForm(ACtrl).OnClick(TForm(ACtrl));
                end;
            end else if joData.e = 'onenter' then begin
                //TForm(ACtrl).OnEnter(TForm(ACtrl));
            end else if joData.e = 'onexit' then begin
                //TForm(ACtrl).OnExit(TForm(ACtrl));
            end else if joData.e = 'onenddock' then begin
                if Assigned(TForm(ACtrl).OnEndDock) then begin
                    TForm(ACtrl).OnEndDock(TForm(ACtrl),nil,0,0);
                end;
            end else if joData.e = 'onstartdock' then begin
                if Assigned(TForm(ACtrl).OnStartDock) then begin
                    TForm(ACtrl).OnStartDock(TForm(ACtrl),oObject);
                end;
            end;
        end else begin
            //-------------作为普通窗体-------------------------------------------------------------
            //
            joData    := _Json(AData);
            if joData.e = 'onclose' then begin
                if Assigned(OnClose) then begin
                    TForm(ACtrl).OnClose(TForm(ACtrl),oAction);
                end;
            end else if joData.e = 'onenddock' then begin
                if Assigned(TForm(ACtrl).OnEndDock) then begin
                    TForm(ACtrl).OnEndDock(TForm(ACtrl),nil,0,0);
                end;
            end else if joData.e = 'onstartdock' then begin
                if Assigned(TForm(ACtrl).OnStartDock) then begin
                    TForm(ACtrl).OnStartDock(TForm(ACtrl),oObject);
                end;
            end;
        end;
    end;
end;

//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
     sCode     : string;
     joHint    : Variant;
     joRes     : Variant;
     sEnter    : String;
     sExit     : String;
     sClick    : string;
begin
    with TForm(ACtrl) do begin
        if HelpKeyword = 'dialog' then begin

        end else if HelpKeyword = 'embed' then begin
            //===============================================================
            //生成返回值数组
            joRes    := _Json('[]');
            //取得HINT对象JSON
            joHint    := dwGetHintJson(TControl(ACtrl));
            //进入事件代码--------------------------------------------------------
            sEnter  := '';

            //退出事件代码--------------------------------------------------------
            sExit  := '';
            //单击事件代码--------------------------------------------------------
            sClick    := '';
            if joHint.Exists('onclick') then begin
                 sClick := String(joHint.onclick);
            end;
            //
            if sClick='' then begin
                 if Assigned(OnClick) then begin
                      sClick    := Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]);
                 end else begin
                 end;
            end else begin
                 if Assigned(OnClick) then begin
                      sClick    := Format(_DWEVENTPlus,['click',sClick,Name,'0','onclick',TForm(Owner).Handle])
                 end else begin
                      sClick    := ' @click="'+sClick+'"';
                 end;
            end;

            //
            sCode     := '<el-main'
                    +' id="'+dwFullName(Actrl)+'"'
                    +dwVisible(TControl(ACtrl))
                    //+dwDisable(TControl(ACtrl))
                    //+dwGetHintValue(joHint,'type','type',' type="default"')
                    //+dwGetHintValue(joHint,'icon','icon','')
                    +' :style="{'
                        +'backgroundColor:'+dwFullName(Actrl)+'__col,'
                        +'left:'+dwFullName(Actrl)+'__lef,'
                        +'top:'+dwFullName(Actrl)+'__top,'
                        +'width:'+dwFullName(Actrl)+'__wid,'
                        +'height:'+dwFullName(Actrl)+'__hei'
                    +'}"'
                    +' style="'
                        +'position:'+dwIIF(Parent.ControlCount=1,'relative','absolute')+';'
                        +'overflow:hidden;'
                        +dwIIF(BorderStyle=bsSingle,'border-radius: 2px;box-shadow: 0 2px 4px rgba(0, 0, 0, .12), 0 0 6px rgba(0, 0, 0, .04);box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);','')
                        +dwGetHintStyle(joHint,'radius','border-radius','')   //border-radius
                        +dwGetDWStyle(joHint)
                    +'"' //style 封闭
                    +sClick
                    +sEnter
                    +sExit
                    +'>';
            //添加到返回值数据
            joRes.Add(sCode);
            //
            Result    := (joRes);
        end else begin
            //===============================================================
            //生成返回值数组
            joRes    := _Json('[]');
            //取得HINT对象JSON
            joHint    := dwGetHintJson(TControl(ACtrl));

            //退出事件代码--------------------------------------------------------
            sExit  := '';
            if joHint.Exists('onexit') then begin
                sExit  := String(joHint.onexit);
            end;
            if sExit='' then begin
                if Assigned(OnClose) then begin
                    sExit    := Format(_DWEVENT,['mouseleave',Name,'0','onexit',Handle]);
                end else begin
                end;
            end;
            //单击事件代码--------------------------------------------------------
            sClick    := '';
            if joHint.Exists('onclick') then begin
                sClick := String(joHint.onclick);
            end;
            //
            if sClick='' then begin
                if Assigned(OnClick) then begin
                    sClick    := Format(_DWEVENT,['click',Name,'0','onclick',Handle]);
                end else begin
                end;
            end else begin
                if Assigned(OnClick) then begin
                    sClick    := Format(_DWEVENTPlus,['click',sClick,Name,'0','onclick',Handle])
                end else begin
                    sClick    := ' @click="'+sClick+'"';
                end;
            end;
            //
            sCode     := '<div'
                    +' class="dwmask"'
                    +' v-show="'+Name+'__vis"'
                    //+' :visible.sync="'+Name+'__vis"'
                    //+' :close-on-click-modal="false"'
                    +' :style="{'
                    //     +'backgroundColor:'+Name+'__col;'
                        +'paddingTop:'+Name+'__top'
                    +'}"' //:style 封闭
                    +'>';
            //:width='+Name+'__wid :height='+Name+'__hei
            //添加到返回值数据
            joRes.Add(sCode);

            //FORM全部------------------------------------------------------------------------------
            sCode     := '<div'
            +' id="'+Name+'"'
            +dwGetDWAttr(joHint)
            +' :style="{'
                +'opacity:1,'
                +'backgroundColor:'+Name+'__col,'
                +'width:'+Name+'__wid,'
                +'height:'+Name+'__fht'
            +'}"'
            +' style="position:relative;'
                +'margin:0 auto;'
                +'overflow:hidden;'
                +'border-radius: 4px;'
                +'box-shadow: 0 2px 4px rgba(0, 0, 0, .12), 0 0 6px rgba(0, 0, 0, .04);'
                //+'box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);'
                +dwGetDWStyle(joHint)
            +'"' //style 封闭
            +sClick
            +sEnter
            +sExit
            +'>';
            //添加到返回值数据
            joRes.Add(sCode);


            //FORM标题------------------------------------------------------------------------------
            if BorderStyle <> bsNone then begin
                sCode     := '<div'
                        //+' id="formtitle"'
                        //+' :style="{'
                        //    +'width:'+Name+'__wid,'
                        //    +'height:'+Name+'__hei'
                        //+'}"'
                        +' style="'
                            +'position:absolute;'
                            +'border:3px 3px 0 0;'
                            +'border-bottom:solid 1px rgba(0,0,0,0.04);'
                            +'left:0;'
                            +'top:0;'
                            +'width:100%;'
                            +'height:40px;'
                        +'"' //style 封闭
                        +'>'
                        +'<span style="font-size:12pt;line-height:40px;color:#555" >'
                            +'{{'+Name+'__cap}}'
                        +'</span>';

                        //关闭按钮
                        if biSystemMenu in BorderIcons then begin
                            sCode   := sCode
                                    + '<el-button type="text"'
                                    +' icon="el-icon-close"'
                                    +' style="height:40px;width:40px;font-size:14pt;color:#aaa;float:right;"'
                                    +' @click="dwexecute(''this.'+Name+'__vis=false;'');'
                                    +'dwevent($event,'''+name+''',''0'',''onclose'','''+IntToStr(Handle)+''')"'
                                    +'>'
                                    +'</el-button>'
                        end;
                        sCode   := sCode + '</div>';
                //添加到返回值数据
                joRes.Add(sCode);
            end;

            //FORM内容区----------------------------------------------------------------------------
            sCode     := '<div'
                    //+' id="formcontent"'
                    +' :style="{'
                        +'height:'+Name+'__hei'
                    +'}"'
                    +' style="'
                        +'position:absolute;'
                        +'text-align:left;'
                        +'border:0 0 3px 3px;'
                        +'left:0;'
                        +dwIIF(BorderStyle=bsNone,'top:0px;','top:40px;')
                        +'width:100%;'
                    +'"' //style 封闭
                    +'>';
            //添加到返回值数据
            joRes.Add(sCode);

            //
            Result    := (joRes);
        end;
    end;
end;
//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
    sCode     : String;
begin
    with TForm(ACtrl) do begin
        if HelpKeyword = 'dialog' then begin
        end else if HelpKeyword = 'embed' then begin
            //生成返回值数组
            joRes    := _Json('[]');
            //生成返回值数组
            joRes.Add('</el-main>');
            //
            Result    := (joRes);
        end else begin
            //生成返回值数组
            joRes    := _Json('[]');
            //生成返回值数组
            joRes.Add('</div>');
            joRes.Add('</div>');
            joRes.Add('</div>');
            //
            Result    := (joRes);
        end;
    end;
end;
//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
    with TForm(ACtrl) do begin
        if HelpKeyword = 'dialog' then begin
        end else if HelpKeyword = 'embed' then begin
            //生成返回值数组
            joRes    := _Json('[]');
            //
            with TForm(ACtrl) do begin
                joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
                joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
                joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
                joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
                //
                joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Enabled,'true,','false,'));
                //
                if TPanel(ACtrl).Color = clNone then begin
                    joRes.Add(dwFullName(Actrl)+'__col:"rgba(0,0,0,0)",');
                end else begin
                    joRes.Add(dwFullName(Actrl)+'__col:"'+dwAlphaColor(TPanel(ACtrl))+'",');
                end;
            end;
            //
            Result    := (joRes);
        end else begin
            //生成返回值数组
            joRes    := _Json('[]');
            //
            with TForm(ACtrl) do begin
                joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
                joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
                joRes.Add(Name+'__wid:"'+IntToStr(ClientWidth)+'px",');
                joRes.Add(Name+'__hei:"'+IntToStr(ClientHeight)+'px",');
                //
                joRes.Add(Name+'__col:"'+dwColor(Color)+'",');
                //
                joRes.Add(Name+'__vis:false,');     //默认不显示
                //标题
                joRes.Add(Name+'__cap:"'+Caption+'",');
                if BorderStyle = bsNone then begin
                    joRes.Add(Name+'__fht:"'+IntToStr(ClientHeight)+'px",');
                end else begin
                    joRes.Add(Name+'__fht:"'+IntToStr(ClientHeight+40)+'px",');
                end;
            end;
            //
            Result    := (joRes);
        end;
    end;
end;
function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
begin
    with TForm(ACtrl) do begin
        if HelpKeyword = 'dialog' then begin
        end else if HelpKeyword = 'embed' then begin
            //生成返回值数组
            joRes    := _Json('[]');
            //
            with TPanel(ACtrl) do begin
                joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
                joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
                joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
                joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
                //
                joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Enabled,'true;','false;'));
                //
                if TPanel(ACtrl).Color = clNone then begin
                    joRes.Add('this.'+dwFullName(Actrl)+'__col="rgba(0,0,0,0)";');
                end else begin
                    joRes.Add('this.'+dwFullName(Actrl)+'__col="'+dwAlphaColor(TPanel(ACtrl))+'";');
                end;
            end;
            //
            Result    := (joRes);
        end else begin
            //生成返回值数组
            joRes    := _Json('[]');
            //
            with TForm(ACtrl) do begin
                joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
                joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
                joRes.Add('this.'+Name+'__wid="'+IntToStr(ClientWidth)+'px";');
                joRes.Add('this.'+Name+'__hei="'+IntToStr(ClientHeight)+'px";');
                //
                joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
                //joRes.Add('this.'+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
                //
                joRes.Add('this.'+Name+'__col="'+dwColor(Color)+'";');
                joRes.Add('this.'+Name+'__cap="'+Caption+'";');
                if BorderStyle = bsNone then begin
                    joRes.Add('this.'+Name+'__fht="'+IntToStr(ClientHeight)+'px";');
                end else begin
                    joRes.Add('this.'+Name+'__fht="'+IntToStr(ClientHeight+40)+'px";');
                end;
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
     dwGetAction,
     dwGetData;
begin
end.

