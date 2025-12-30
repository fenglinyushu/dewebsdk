library dwTMemo__toastuiviewer;
(*
功能说明：
    该控件用于在WEB中使用markdown编辑器

用法：
    1 配置Hint

*)

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



//-------辅助函数-----------------------------------------------------------------------------------
//Delphi的Memo中的字符串 -> Web用的字符串
function dwTextToInit(AText:string):string;
var
    slTxt     : TStringList;
    iItem     : Integer;
begin
    //<转义可能出错的字符
    //AText     := StringReplace(AText,'\','\\',[rfReplaceAll]);
    //AText     := StringReplace(AText,'"','\"',[rfReplaceAll]);

    //
    slTxt     := TStringList.Create;
    slTxt.Text     := AText;
    for iItem := 0 to slTxt.Count-1 do begin
        slTxt[iItem]    := TrimLeft(slTxt[iItem]);
    end;
    Result  := slTxt.Text;
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

//==================================================================================================

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    joRes       : Variant;
begin
    //返回值数组
    joRes   := _json('[]');

    //基本JS/CSS
    joRes.Add('<link rel="stylesheet" href="dist/_toastui/toastui-editor.min.css">');
    joRes.Add('<script src="dist/_toastui/toastui-editor-viewer.min.js"></script>');

    //
    Result  := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
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
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode       : string;
    joHint      : Variant;
    joRes       : Variant;
    sFull       : string;
begin
    //取得全名, 备用
    sFull   := dwFullName(ACtrl);

    //
    with TMemo(ACtrl) do begin
        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //生成返回值数组
        joRes   := _Json('[]');
        //
        sCode   := '<div'
                +' id="'+sFull+'"'
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                +dwGetDWAttr(joHint)
                +' :style="{'
                    +'''font-size'':'+sFull+'__fsz,'
                    +'''font-family'':'+sFull+'__ffm,'
                    //+'''font-weight'':'+sFull+'__fwg,'
                    //+'''font-style'':'+sFull+'__fsl,'
                    //+'''text-decoration'':'+sFull+'__ftd,'
                    +'left:'+sFull+'__lef,'
                    +'top:'+sFull+'__top,'
                    +'width:'+sFull+'__wid,'
                    +'height:'+sFull+'__hei'
                +'}"'
                +' style="position:absolute;'
                    +dwGetDWStyle(joHint)
                +'"' //style 封闭
                +'>';
        //
        joRes.Add(sCode);

        //
        Result    := (joRes);
    end;
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
begin
    with TMemo(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //生成返回值数组
        joRes.Add('</div>');
        //
        Result    := (joRes);
    end;
end;




//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    sCode       : String;
    iItem       : Integer;
    sFull       : string;
begin
    //取得全名, 备用
    sFull   := dwFullName(ACtrl);

    with TMemo(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TMemo(ACtrl) do begin
            joRes.Add(sFull+'__lef:"'+IntToStr(Left)+'px",');
            joRes.Add(sFull+'__top:"'+IntToStr(Top)+'px",');
            joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
            joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
            //
            joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
            joRes.Add(sFull+'__dis:'+dwIIF(Enabled,'false,','true,'));
            //
            joRes.Add(sFull+'__fcl:"'+dwColor(Font.Color)+'",');
            joRes.Add(sFull+'__fsz:"'+IntToStr(Font.size+3)+'px",');
            joRes.Add(sFull+'__ffm:"'+Font.Name+'",');
        end;
        //
        Result    := (joRes);
    end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    sCode       : String;
    iItem       : Integer;
    sFull       : string;
begin
    //取得全名, 备用
    sFull   := dwFullName(ACtrl);

    with TMemo(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TMemo(ACtrl) do begin
            joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
            joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
            joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
            joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
            //
            joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
            joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));

            //定义TUE(ToastUiEditor)变量, 备用
            joRes.Add('this.'+sFull+'__tue = null');
            //joRes.Add('this.$refs.'+sFull+'.innerHTML=`'+text+'`;');

            //重绘 (根据Memo.Text)
            if Docksite then begin
                sCode   := sFull+'_tue.setMarkdown(`'+dwTextToInit(Text)+'`);';
                joRes.Add(sCode);
                //
                Docksite    := False;
            end else begin
                joRes.Add('');
            end;
        end;
        //
        Result    := (joRes);
    end;
end;

//取得Mounted
function dwGetMounted(ACtrl:TComponent):String;StdCall;
var
    joRes   : Variant;
    joHint  : Variant;
    //
    sCode   : string;
    sFull   : string;
begin
    //
    sFull   := dwFullName(ACtrl);

    //生成返回值数组
    joRes   := _Json('[]');

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));


    with TMemo(ACtrl) do begin
        sCode   :=
            ''
            +'var editorElement = document.getElementById('''+sFull+''');'#13
            +'let _initdata=`'+dwTextToInit(Text)+'`;'#13
            +sFull + '_tue = new toastui.Editor({'
            +'	el: editorElement,'
            +'	initialValue : _initdata,'
            +'viewer: true,' // 设置为查看器模式（不可编辑）
            +'height: ''100%'','
            +'theme: ''light'','
            +'usageStatistics: false'
            //+'  ,toolbarItems: [ [''heading'', ''bold'', ''italic'', ''strike'', ''quote'', ''ul'', ''ol'', ''task'', ''indent'', ''outdent'', ''hr'', ''link'', ''image'', ''code'', ''table'', ''lineHeight'']]'
            +'});'
            +sFull + '_tue.on(''change'', function() {'

            +'	const mdText = ' + sFull + '_tue.getMarkdown();' // 处理内容
            //+'	console.log(mdText);'
            +'  window._this.dwevent(null,'''+sFull+''',escape(mdText),''onchange'','''+IntToStr(TForm(Owner).Handle)+''');'
            +'});';

        //
        joRes.Add(sCode);
    end;


    Result    := joRes;
end;



exports
     dwGetExtra,
     dwGetEvent,
     dwGetMounted,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetData;
     
begin
end.
 
