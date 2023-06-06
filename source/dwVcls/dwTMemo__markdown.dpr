library dwTMemo__markdown;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     Vcl.ComCtrls,
     SysUtils,
     Classes,
     Dialogs,
     StdCtrls,
     Windows,
     Controls,
     Forms;

//-------辅助函数-----------------------------------------------------------------------------------
//Delphi的Memo中的字符串 -> Web用的字符串
function dwTextToWeb(AText:string):string;
var
    slTxt     : TStringList;
    iItem     : Integer;
begin
    //<转义可能出错的字符
    AText     := StringReplace(AText,'\','\\',[rfReplaceAll]);
    AText     := StringReplace(AText,'"','\"',[rfReplaceAll]);

    //
    slTxt     := TStringList.Create;
    slTxt.Text     := AText;
    Result    := '';
    for iItem := 0 to slTxt.Count-1 do begin
        if iItem <slTxt.Count-1 then begin
            Result     := Result + slTxt[iItem]+'\n';
        end else begin
            Result     := Result + slTxt[iItem];
        end;
    end;
    slTxt.Destroy;
end;

//Web用的字符串 -> Delphi的Memo中的字符串
function dwWebToText(AText:string):string;
var
    slTxt     : TStringList;
begin
    //更新值
    Result  := dwUnescape(AText);
    Result  := dwUnescape(Result);
    Result  := StringReplace(Result,#10,#13#10,[rfReplaceAll]);
    //Result  := StringReplace(Result,'"','\"',[rfReplaceAll]);
end;
//-------辅助函数-----------------------------------------------------------------------------------

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):String;stdCall;
var
    joRes     : Variant;
begin
    joRes    := _Json('[]');

    //生成返回值数组
    joRes.Add('<script src="dist/_jquery/jquery.min.js"></script>');
    joRes.Add('<script src="dist/_editormd/editormd.min.js"></script>');
    joRes.Add('<script src="dist/_editormd/lib/marked.min.js"></script>');
    joRes.Add('<script src="dist/_editormd/lib/prettify.min.js"></script>');
    joRes.Add('<link rel="stylesheet" href="dist/_editormd/style.css" />');
    joRes.Add('<link rel="stylesheet" href="dist/_editormd/editormd.css" />');

    //返回值
    Result    := (joRes);
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):String;StdCall;
var
    joData  : Variant;
    joRes   : Variant;
    oChange : Procedure(Sender:TObject) of Object;
    sText   : string;
begin
    //
    joData    := _Json(AData);

    if joData.e = 'onclick' then begin
        if Assigned(TMemo(ACtrl).OnClick) then begin
            TMemo(ACtrl).OnClick(TMemo(ACtrl));
        end;
    end else if joData.e = 'onchange' then begin
        //保存事件
        oChange   := TMemo(ACtrl).OnChange;
        //清空事件,以防止自动执行
        TMemo(ACtrl).OnChange  := nil;
        TMemo(ACtrl).Text    := dwWebToText(joData.v);

        //恢复事件
        TMemo(ACtrl).OnChange  := oChange;

        //执行事件
        if Assigned(TMemo(ACtrl).OnChange) then begin
           TMemo(ACtrl).OnChange(TMemo(ACtrl));
        end;
    end else if joData.e = 'onenter' then begin
        if Assigned(TMemo(ACtrl).OnEnter) then begin
            TMemo(ACtrl).OnEnter(TMemo(ACtrl));
        end;
    end else if joData.e = 'onexit' then begin
        if Assigned(TMemo(ACtrl).OnExit) then begin
            TMemo(ACtrl).OnExit(TMemo(ACtrl));
        end;
    end else if joData.e = 'onmouseenter' then begin
        if Assigned(TMemo(ACtrl).OnMouseEnter) then begin
            TMemo(ACtrl).OnMouseEnter(TMemo(ACtrl));
        end;
    end else if joData.e = 'onmouseexit' then begin
        if Assigned(TMemo(ACtrl).OnMouseLeave) then begin
            TMemo(ACtrl).OnMouseLeave(TMemo(ACtrl));
        end;
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):String;StdCall;
var
    sCode   : String;
    sSize   : String;
    sRIcon  : string;

    //
    joHint  : Variant;
    joRes   : Variant;
    sEnter  : String;
    sExit   : String;
    sClick  : string;
begin

    //生成返回值数组
    joRes    := _Json('[]');

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //
    with TMemo(ACtrl) do begin
        //外框
        sCode   := '<div'
                +' id="'+dwFullName(Actrl)+'"'
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                +dwGetDWAttr(joHint)
                //Style
                +dwLTWH(TControl(ACtrl))
                +dwGetDWStyle(joHint)
                +'"' //style 封闭
                //+' @input="this.console.log(''on input'')"'
                //+Format(_DWEVENT,['input',Name,'escape('+dwFullName(Actrl)+'__obj.getMarkdown())','onchange',TForm(Owner).Handle])
                //+dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
                //+dwIIF(Assigned(OnEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),'')
                //+dwIIF(Assigned(OnExit),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),'')
                +'>';
        joRes.Add(sCode);

        //textarea
        sCode   := '    <textarea'
                +' v-model="'+dwFullName(Actrl)+'__txt"'
                +' style="display:none;'
                +'"'
                //+Format(_DWEVENT,['input',Name,'escape(this.'+dwFullName(Actrl)+'__obj.getMarkdown())','onchange',TForm(Owner).Handle])
                +'>';
        //对应的内容变量
        sCode   := sCode +'{{'+dwFullName(Actrl)+'__txt}}';

    end;
    joRes.Add(sCode);
    Result    := (joRes);
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin

    //生成返回值数组
    joRes    := _Json('[]');
    //生成返回值数组
    joRes.Add('    </textarea>');
    joRes.Add('</div>');
    //
    Result    := (joRes);
end;

//取得Data消息
function dwGetData(ACtrl:TComponent):String;StdCall;
var
    joRes   : Variant;
    joHint  : Variant;
begin
    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TMemo(ACtrl) do begin
        joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(Enabled,'false,','true,'));
        //
        //为内容变量赋值
        joRes.Add(dwFullName(Actrl)+'__txt:"'+dwTextToWeb(Text)+'",');

    end;
    //
    Result    := (joRes);
end;

//取得事件
function dwGetAction(ACtrl:TComponent):String;StdCall;
var
    joRes     : Variant;
    joHint  : Variant;
begin
    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TMemo(ACtrl) do begin
        joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height+2)+'px";');
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+dwFullName(Actrl)+'__dis='+dwIIF(Enabled,'false;','true;'));
        //更新
        joRes.Add('this.'+dwFullName(Actrl)+'__txt="'+dwTextToWeb(Text)+'";');
    end;
    //
    Result    := (joRes);
end;

//取得面渲染完成后执行代码
function dwGetMounted(ACtrl:TControl):string;StdCall;
var
    joRes   : Variant;
    joHint  : Variant;
    sCode   : String;
    sToolBar: String;
begin
    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));


    //
    sToolBar := '';
    if joHint.Exists('toolbaricons') then begin
        //sToolBar    := 'toolbarIcons : function() { return '+VariantSaveJSON(String(joHint.toolbaricons))+'},';
        sToolBar    := joHint.toolbaricons;
        sToolBar    := 'toolbarIcons : function() { return '+sToolBar+'},';
    end;

    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TMemo(ACtrl) do begin
        //初始化            editormd.markdownToHTML
        sCode   := dwFullName(Actrl)+'__obj = ';
            //区分编辑器/展示
            if ParentBiDiMode then begin
                sCode   := sCode + 'editormd'
            end else begin
                sCode   := sCode + 'editormd.markdownToHTML'
            end;
            //
            sCode   := sCode + '('''+dwFullName(Actrl)+''', '
                +'{'
                    +'width : '+Width.ToString+','
                    +'height : '+Height.ToString+','
                    +sToolBar                                           //个性化工具栏
                    +'readonly : '+dwBoolToStr(ReadOnly)+','            //是否
                    +'toolbar : '+dwBoolToStr(ShowHint)+','             //显隐工具栏
                    +'htmlDecode : "style,script,iframe",'              //
                    +'syncScrolling : ''single'','
                    +'watch : true,'                                    //显示预览,默认打开，以响应onchange函数
                    +'saveHTMLToTextarea : true, '
                    +'preview : true,'
                    +'emoji : true, '                                   //显示表情
                    +'editor : false,'
                    +'path : ''dist/_editormd/lib/'''
                    +',onchange : function() {'
                        +'$("#output").html("onchange : this.id =>" + this.id + ", markdown =>" + this.getValue());'
                        +'console.log("onchange =>", this, this.id, this.settings, this.state);'
                        //+'console.log("onchangeasdfa");'
                        +'me.dwevent(null,'''+dwFullName(Actrl)+''',''escape('+dwFullName(Actrl)+'__obj.getMarkdown())'',''onchange'','''+IntToStr(TForm(Owner).Handle)+''');'
                        //+Format(_DWEVENT,['input',Name,'escape('+dwFullName(Actrl)+'__obj.getMarkdown())','onchange',TForm(Owner).Handle])
                    +'}'
                +'});';
        joRes.Add(sCode);
    end;
    //
    Result    := (joRes);
    (* 配置参数

        {
         theme                : "",             // Editor.md self themes, before v1.5.0 is CodeMirror theme,
         editorTheme          : "default",      // Editor area, this is CodeMirror theme at v1.5.0
         previewTheme         : "",             // Preview area theme, default empty
         width                : "100%",
         height               : "100%",
         path                 : "./lib/",       // Dependents module file directory
         pluginPath           : "",             // If this empty, default use settings.path + "../plugins/"
         delay                : 300,            // Delay parse markdown to html, Uint : ms
         autoLoadModules      : true,           // Automatic load dependent module files
         watch                : true,
         placeholder          : "Enjoy Markdown! coding now...",
         gotoLine             : true,           // Enable / disable goto a line
         codeFold             : false,
         autoHeight           : false,
         autoFocus            : true,           // Enable / disable auto focus editor left input area
         autoCloseTags        : true,
         searchReplace        : true,           // Enable / disable (CodeMirror) search and replace function
         syncScrolling        : true,           // options: true | false | "single", default true
         saveHTMLToTextarea   : false,          // If enable, Editor will create a <textarea name="{editor-id}-html-code"> tag save HTML code for form post to server-side.
         onload               : function() {},
         onresize             : function() {},
         onchange             : function() {},
         onwatch              : null,
         onunwatch            : null,
         onpreviewing         : function() {},
         onpreviewed          : function() {},
         onfullscreen         : function() {},
         onfullscreenExit     : function() {},
         onscroll             : function() {},
         onpreviewscroll      : function() {},

         imageUpload          : false,          // Enable/disable upload
         imageFormats         : ["jpg", "jpeg", "gif", "png", "bmp", "webp"],
         imageUploadURL       : "",             // Upload url
         crossDomainUpload    : false,          // Enable/disable Cross-domain upload
         uploadCallbackURL    : "",             // Cross-domain upload callback url

         emoji                : false,          // :emoji: , Support Github emoji, Twitter Emoji (Twemoji);
         // Support FontAwesome icon emoji :fa-xxx: > Using fontAwesome icon web fonts;
         // Support Editor.md logo icon emoji :editormd-logo: :editormd-logo-1x: > 1~8x;
         tex                  : false,          // TeX(LaTeX), based on KaTeX
         flowChart            : false,          // flowChart.js only support IE9+
         sequenceDiagram      : false,          // sequenceDiagram.js only support IE9+
         previewCodeHighlight : true,           // Enable / disable code highlight of editor preview area
        ​
         toolbar              : true,           // show or hide toolbar
         toolbarAutoFixed     : true,           // on window scroll auto fixed position
         toolbarIcons         : "full",         // Toolbar icons mode, options: full, simple, mini, See `editormd.toolbarModes` property.
         toolbarTitles        : {},
         toolbarHandlers      : {
         ucwords : function() {
         return editormd.toolbarHandlers.ucwords;
         },
         lowercase : function() {
         return editormd.toolbarHandlers.lowercase;
         }
        }
    *)

end;

exports
     dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetMounted,
     dwGetData;
     
begin
end.
 
