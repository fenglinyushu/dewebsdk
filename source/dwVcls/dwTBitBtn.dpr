library dwTBitBtn;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     Buttons,
     SysUtils,
     Classes,
     Dialogs,
     StdCtrls,
     Windows,
     Controls,
     Forms;

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):String;stdCall;
begin
     Result    := '[]';
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):String;StdCall;
var
    joData  : Variant;
    oObject : TDragDockObject;
begin
     //
     joData    := _Json(AData);

     if joData.e = 'onenddock' then begin
          if Assigned(TBitBtn(ACtrl).OnEndDock) then begin
               TBitBtn(ACtrl).OnEndDock(TBitBtn(ACtrl),nil,0,0);
          end;
     end else if joData.e = 'onstartdock' then begin
          if Assigned(TBitBtn(ACtrl).OnStartDock) then begin
               TBitBtn(ACtrl).OnStartDock(TBitBtn(ACtrl),oObject);
          end;
     end else if joData.e = 'onenter' then begin
          if Assigned(TBitBtn(ACtrl).OnEnter) then begin
               TBitBtn(ACtrl).OnEnter(TBitBtn(ACtrl));
          end;
     end else if joData.e = 'onexit' then begin
          if Assigned(TBitBtn(ACtrl).OnExit) then begin
               TBitBtn(ACtrl).OnExit(TBitBtn(ACtrl));
          end;
     end else if joData.e = 'getfilename' then begin
          //TBitBtn(ACtrl).Caption   := dwUnescape(joData.v);
     end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):String;StdCall;
var
    sCode   : String;
    sSize   : String;
    sDir    : String;   //自定义上传目录
    sFull   : string;
    //
    bAuto   : Boolean;

    //
    joHint  : Variant;
    joRes   : Variant;
    iHandle : Integer;
begin
    //生成返回值数组
    joRes    := _Json('[]');

    //
    sFull   := dwFullName(ACtrl);

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //_DWEVENT = ' @%s="dwevent($event,''%s'',''%s'',''%s'',''%s'')"';
    //参数依次为: JS事件名称, 控件名称,控件值,Delphi事件名称,备用


    //
    with TBitBtn(ACtrl) do begin
        //添加Form
        joRes.Add('<form'
                +' id="'+sFull+'__frm"'
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                +dwLTWH(TControl(ACtrl))
                +'"' //style 封闭
                +' action="/dwupload"'
                +' method="POST"'
                +' enctype="multipart/form-data"'
                +' target="upload_iframe"'
                +'>');

        //求Form的Handle
        //
        iHandle := TForm(Actrl.Owner).Handle;
        if lowerCase(ACtrl.Owner.ClassName) <> 'tform1' then begin
            //iHandle := TForm(TForm(Actrl.Owner).Owner).Handle;
        end;


        //添加Input
		joRes.Add('<input'
                +' id="'+sFull+'__inp"'
                +' type="FILE"'
                +' name="file"'
                +' style="display:none"'
                +dwGetHintValue(joHint,'accept','accept','')
                +dwGetHintValue(joHint,'capture','capture','')
                +' @change="'+sFull+'__change"'
                //+dwIIF(bAuto,
                //    ' @change=dwInputSubmit('+iHandle.ToString+','''+sFull+''','''+sDir+''');',
                //    ' @change=dwInputChange('+iHandle.ToString+','''+sFull+''');')
                +'>');


        //添加Button
        //得到大小：large/medium/small/mini
        if Height>50 then begin
             sSize     := ' size=large';
        end else if Height>35 then begin
             sSize     := ' size=medium';
        end else if Height>20 then begin
             sSize     := ' size=small';
        end else begin
             sSize     := ' size=mini';
        end;

        //
        sCode     := '<el-button'
                +' id="'+sFull+'__btn"'
                +sSize
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                //+dwGetHintValue(joHint,'type','type',' type="default"')         //sButtonType
                +' :type="'+sFull+'__typ"'
                +dwGetHintValue(joHint,'icon','icon','')         //ButtonIcon
                +dwGetHintValue(joHint,'style','','')             //样式，空（默认）/plain/round/circle
                //
                +dwGetDWAttr(joHint)
                //
                +' style="position:absolute;width:100%;height:100%;'
                +dwGetHintStyle(joHint,'radius','border-radius','')   //border-radius
                +dwGetDWStyle(joHint)
                +'"'
                //默认选择文件
                +' @click="'+sFull+'__click()"'
                //+' @click="''dwInputClick('''+sFull+'__inp'');"'

                //其他事件
                //+dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
                +dwIIF(Assigned(OnEnter),Format(_DWEVENT,['mouseenter.native',sFull,'0','onenter',TForm(Owner).Handle]),'')
                +dwIIF(Assigned(OnExit),Format(_DWEVENT,['mouseleave.native',sFull,'0','onexit',TForm(Owner).Handle]),'')
                +'>{{'+sFull+'__cap}}';
        //
        joRes.Add(sCode);

    end;

    Result    := (joRes);
    //
    //@mouseenter.native=“enter”
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //生成返回值数组
     joRes.Add('</el-button>');
     joRes.Add('</form>');
     //
     Result    := (joRes);
end;

//取得Data消息
function dwGetData(ACtrl:TComponent):String;StdCall;
var
    joRes   : Variant;
    sFull   : string;
begin
    //
    sFull  := dwFullName(ACtrl);

    //生成返回值数组
    joRes  := _Json('[]');

    //
    with TBitBtn(ACtrl) do begin
        joRes.Add(sFull+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(sFull+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(sFull+'__dis:'+dwIIF(Enabled,'false,','true,'));
        //
        joRes.Add(sFull+'__cap:"'+dwProcessCaption(Caption)+'",');
        //
        joRes.Add(sFull+'__typ:"'+dwGetProp(TBitBtn(ACtrl),'type')+'",');
    end;
    //
    Result    := (joRes);
end;

//取得事件
function dwGetAction(ACtrl:TComponent):String;StdCall;
var
    joRes   : Variant;
    sFull   : string;
begin
    //
    sFull  := dwFullName(ACtrl);

    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TBitBtn(ACtrl) do begin
        joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        joRes.Add('this.'+sFull+'__cap="'+dwProcessCaption(Caption)+'";');
        //
        joRes.Add('this.'+sFull+'__typ="'+dwGetProp(TBitBtn(ACtrl),'type')+'";');
    end;
    //
    Result    := (joRes);
end;

function dwGetMethods(ACtrl:TControl):String;stdCall;
var
    bAuto   : Boolean;
    //
    sCode   : string;
    sFull   : string;
    sDir    : string;
    //
    joRes   : Variant;
    joHint  : variant;

begin
    //返回值 JSON对象，可以直接转换为字符串
    joRes   := _json('[]');

    //
    sFull   := dwFullName(Actrl);

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));


    with TButton(ACtrl) do begin
        //---------- click事件
        sCode   := sFull+'__click(event) {'
                    +'console.log("dwClick");'
                    +'document.getElementById("'+sFull+'__inp").click();'
                +'},';
        joRes.Add(sCode);

        //---------- change事件

        //在Hint中"auto":1表示自动上传
        bAuto   := False;
        if joHint.Exists('auto') then begin
            bAuto  := Integer(joHint.auto) = 1;
        end;

        //取上传目录. 格式: mydir\dasdf  前面没有\, 后面无\
        sDir    := '';
        if joHint.Exists('dir') then begin
            sDir  := String(joHint.dir);
        end;
        sDir    := Trim(sDir);
        if sDir <> '' then begin
            //去除前面的\
            if sDir[1] = '\' then begin
                Delete(sDir,1,1);
            end;
            //去除后面的\
            if sDir[Length(sDir)]='\' then begin
                Delete(sDir,Length(sDir),1);
            end;
        end;
        sCode   := sFull+'__change(event) {'
                +dwIIF(bAuto,
                    //'console.log("dwInputSubmit");'+
                    'this.dwInputSubmit('+IntToStr(TForm(Actrl.Owner).Handle)+','''+sFull+''','''+sDir+''');',
                    //'console.log("dwInputChange");'+
                    'this.dwInputChange('+IntTostr(TForm(Actrl.Owner).Handle)+','''+sFull+''');')
                +'},';
        joRes.Add(sCode);

    end;

    //
    Result   := joRes;
end;


exports
     //dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetMethods,
     dwGetAction,
     dwGetData;

begin
end.

