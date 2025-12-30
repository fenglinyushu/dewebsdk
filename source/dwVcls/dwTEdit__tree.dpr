library dwTEdit__tree;

uses
     ShareMem,      //必须添加

     //
     dwCtrlBase,    //一些基础函数

     //
     SynCommons,    //mormot用于解析JSON的单元

     //
     SysUtils,
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
     //生成返回值数组
     joRes    := _Json('[]');

     {
     //以下是TChart时的代码,供参考
     joRes.Add('<script src="dist/charts/echarts.min.js"></script>');
     joRes.Add('<script src="dist/charts/lib/index.min.js"></script>');
     joRes.Add('<link rel="stylesheet" href="dist/charts/lib/style.min.css">');
     }

     //https://vue-treeselect.js.org/
     joRes.Add('<script src="dist/_treeselect/vue-treeselect.umd.min.js"></script>');
     joRes.Add('<link rel="stylesheet" href="dist/_treeselect/vue-treeselect.min.css">');
     joRes.Add('<script>Vue.component(''treeselect'', VueTreeselect.Treeselect)</script>');

     //
     Result    := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData     : Variant;
     oChange    : Procedure(Sender:TObject) of Object;
     iKey       : Word;
     cKey       : Char;
begin
    //
    joData    := _Json(AData);


    if joData.e = 'onenter' then begin
        if Assigned(TEdit(ACtrl).OnEnter) then begin
            TEdit(ACtrl).OnEnter(TEdit(ACtrl));
        end;
    end else if joData.e = 'onchange' then begin
        //保存事件
        oChange   := TEdit(ACtrl).OnChange;
        //清空事件,以防止自动执行
        TEdit(ACtrl).OnChange  := nil;
        //更新值
        TEdit(ACtrl).Text    := dwUnescape(dwUnescape(joData.v));
        //恢复事件
        TEdit(ACtrl).OnChange  := oChange;

        //执行事件
        if Assigned(TEdit(ACtrl).OnChange) then begin
            TEdit(ACtrl).OnChange(TEdit(ACtrl));
        end;
    end else if joData.e = 'onexit' then begin
        if Assigned(TEdit(ACtrl).OnExit) then begin
            TEdit(ACtrl).OnExit(TEdit(ACtrl));
        end;
    end else if joData.e = 'onclick' then begin
        if Assigned(TEdit(ACtrl).Onclick) then begin
            TEdit(ACtrl).Onclick(TEdit(ACtrl));
        end;
    end else if joData.e = 'onkeydown' then begin
        if Assigned(TEdit(ACtrl).OnKeyDown) then begin
            iKey    := StrToIntDef(joData.v,0);
            TEdit(ACtrl).OnKeyDown(TEdit(ACtrl),iKey,[]);//Chr(StrToIntDef(joData.v,32)));
        end;
    end else if joData.e = 'onkeyup' then begin
        if Assigned(TEdit(ACtrl).OnKeyup) then begin
            iKey    := StrToIntDef(joData.v,0);
            TEdit(ACtrl).OnKeyup(TEdit(ACtrl),iKey,[]);//Chr(StrToIntDef(joData.v,32)));
        end;
    end else if joData.e = 'onkeypress' then begin
        if Assigned(TEdit(ACtrl).OnKeyPress) then begin
            cKey  := Chr(StrToIntDef(joData.v,0));
            TEdit(ACtrl).OnKeyPress(TEdit(ACtrl),cKey);//Chr(StrToIntDef(joData.v,32)));
        end;
    end else if joData.e = 'onmouseenter' then begin
        if Assigned(TEdit(ACtrl).OnMouseEnter) then begin
            TEdit(ACtrl).OnMouseEnter(TEdit(ACtrl));
        end;
    end else if joData.e = 'onmouseexit' then begin
        if Assigned(TEdit(ACtrl).OnMouseLeave) then begin
            TEdit(ACtrl).OnMouseLeave(TEdit(ACtrl));
        end;
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode   : string;
    sFull   : string;
    joHint  : Variant;
    joRes   : Variant;
    sBorder : string;
    sAlign  : string;
begin
    //生成返回值数组
    joRes    := _Json('[]');

    //
    sFull   := dwFullName(ACtrl);

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //计算Border
    if TEdit(ACtrl).BorderStyle = bsSingle then begin
        sBorder := dwGetHintStyle(joHint,'radius','border-radius','border-radius:4px;')   //border-radius
                +dwGetHintStyle(joHint,'border','border','border:1px solid #DCDFE6;')   //border-radius
    end else begin
        sBorder := 'border:0px;'+dwGetHintStyle(joHint,'radius','border-radius','border-radius:4px;')   //border-radius
                +dwGetHintStyle(joHint,'border','border','border:0px solid #DCDFE6;')   //border-radius
    end;

    //
    with TEdit(ACtrl) do begin
        //计算alignment
        case Alignment of
            taLeftJustify : begin
                sAlign  := 'text-align: left;'
            end;
            taCenter : begin
                sAlign  := 'text-align: center;'
            end;
            taRightJustify : begin
                sAlign  := 'text-align: right;'
            end;
        end;

        //
        sCode   := '<treeselect'
            +' id="'+sFull+'"'
            //+' name="'+sFull+'"'
            +' v-model="'+sFull+'__val"'               //返回值
            +' :multiple="'+sFull+'__mul"'
            +' :clearable="'+sFull+'__clr"'
            +' :searchable="'+sFull+'__sch"'
            //+' :disabled="disabled"
            +' :open-on-click="'+sFull+'__ooc"'
            +' :open-on-focus="'+sFull+'__oof"'
            +' :clear-on-select="'+sFull+'__cos"'
            +' :close-on-select="'+sFull+'__cls"'
            +' :always-open="'+sFull+'__aop"'
            +' :append-to-body="'+sFull+'__atb"'
            +' :options="'+sFull+'__opt"'              //选项
            +' :limit="'+sFull+'__lmt"'
            +' :max-height="'+sFull+'__mxh"'
            +' :disable-branch-nodes="'+sFull+'__dbn"'


            +dwVisible(TControl(ACtrl))                            //用于控制可见性Visible
            +dwDisable(TControl(ACtrl))                            //用于控制可用性Enabled(部分控件不支持)

            //+dwGetHintValue(joHint,'placeholder','placeholder','') //placeholder,提示语
            //+dwGetHintValue(joHint,'prefix-icon','prefix-icon','') //前置Icon
            //+dwGetHintValue(joHint,'suffix-icon','suffix-icon','') //后置Icon
            +dwGetDWAttr(joHint)
            //+dwLTWH(TControl(ACtrl))                               //Left/Top/Width/Height
            +' :style="{'
                +'backgroundColor:'+sFull+'__col,'
                +'left:'+sFull+'__lef,'
                +'top:'+sFull+'__top,'
                +'width:'+sFull+'__wid,'
                +'height:'+sFull+'__hei'
            +'}"'
            +' style="'
                +'position:absolute;'
                //+sBorder
                //+sAlign
                //+'overflow: hidden;'
                +dwGetDWStyle(joHint)
            +'"' // 封闭style
            +' @select="'+sFull+'__select"'
            //+' @select =
            //+' onclick="this.dwevent('''','''+Name+''',''0'',''onclick'','''+IntToStr(TForm(Owner).Handle)+''')"'
            //+Format(_DWEVENT,['select',Name,'escape(this.'+sFull+'__val)','onchange',TForm(Owner).Handle]) //绑定事件
            //+dwIIF(Assigned(OnClick),        Format(_DWEVENT,['click.native',        Name,'0','onclick', TForm(Owner).Handle]),'')
            //+dwIIF(Assigned(OnKeyDown),      Format(_DWEVENT,['keydown.native',      Name,'event.keyCode','onkeydown', TForm(Owner).Handle]),'')
            //+dwIIF(Assigned(OnKeyUp),        Format(_DWEVENT,['keyup.native',        Name,'event.keyCode','onkeyup',   TForm(Owner).Handle]),'')
            //+dwIIF(Assigned(OnKeyPress),     Format(_DWEVENT,['keypress.native',     Name,'event.keyCode','onkeypress',TForm(Owner).Handle]),'')
            //+Format(_DWEVENT,['input',Name,'escape(this.'+sFull+'__txt)','onchange',TForm(Owner).Handle]) //绑定事件
            //+dwIIF(Assigned(OnMouseEnter),   Format(_DWEVENT,['mouseenter.native',   Name,'0','onmouseenter',TForm(Owner).Handle]),'')
            //+dwIIF(Assigned(OnMouseLeave),   Format(_DWEVENT,['mouseleave.native',   Name,'0','onmouseexit',TForm(Owner).Handle]),'')
            //+dwIIF(Assigned(OnEnter),        Format(_DWEVENT,['focus',               Name,'0','onenter',TForm(Owner).Handle]),'')
            //+dwIIF(Assigned(OnExit),         Format(_DWEVENT,['blur',                Name,'0','onexit',TForm(Owner).Handle]),'')
        +'>';
        //添加到返回值数据
         joRes.Add(sCode);
    end;
    //
    Result    := (joRes);
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //生成返回值数组
     joRes.Add('</treeselect>');          //此处需要和dwGetHead对应
     //
     Result    := (joRes);
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    joHint      : Variant;
    sCode       : String;
    sFull       : String;
begin
    //生成返回值数组
    joRes    := _Json('[]');

    //
    sFull   := dwFullName(ACtrl);

    //
    joHint  := dwGetHintJson(TControl(ACtrl));

    //
    with TEdit(ACtrl) do begin
        joRes.Add(sFull+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(sFull+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(sFull+'__dis:'+dwIIF(Enabled,'false,','true,'));
        //
        joRes.Add(sFull+'__rdo:'+dwIIF(ReadOnly,'true,','false,'));
        //
        if Text = '' then begin
            joRes.Add(sFull+'__val:[],');
        end else begin
            joRes.Add(sFull+'__val:['''+dwChangeChar(Text)+'''],');
        end;
        //
        joRes.Add(sFull+'__col:"'+dwColor(Color)+'",');

        //选项
        joRes.Add(sFull+'__mul:'+dwGet01Bool(joHint,'multipe','false')+',');
        joRes.Add(sFull+'__clr:'+dwGet01Bool(joHint,'clearable','true')+',');
        joRes.Add(sFull+'__sch:'+dwGet01Bool(joHint,'searchable','true')+',');
        joRes.Add(sFull+'__ooc:'+dwGet01Bool(joHint,'openonclick','false')+',');
        joRes.Add(sFull+'__oof:'+dwGet01Bool(joHint,'openonfocus','false')+',');
        joRes.Add(sFull+'__cos:'+dwGet01Bool(joHint,'clearonselect','false')+',');
        joRes.Add(sFull+'__cls:'+dwGet01Bool(joHint,'closeonselect','true')+',');
        joRes.Add(sFull+'__aop:'+dwGet01Bool(joHint,'alwaysopen','false')+',');
        joRes.Add(sFull+'__atb:'+dwGet01Bool(joHint,'appendtobody','false')+',');
        joRes.Add(sFull+'__lmt:'+IntToStr(dwGetInt(joHint,'limit',3))+',');
        joRes.Add(sFull+'__mxh:'+IntToStr(dwGetInt(joHint,'maxheight',200))+',');
        joRes.Add(sFull+'__dbn:'+dwGet01Bool(joHint,'disablebranchnodes','false')+',');

        //可选节点
        joRes.Add(sFull+'__opt:'+dwGetStr(joHint,'options','[]')+',');

        //
        joRes.Add(sCode);
    end;
    //
    Result    := (joRes);
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    joHint      : Variant;  //__eventcomponent
    sEventComp  : String;
    sFull       : String;
begin
    //生成返回值数组
    joRes   := _Json('[]');

    //
    sFull   := dwFullName(ACtrl);

    //得到事件源控件
    joHint  := dwGetHintJson(TControl(ACtrl.Owner));
    sEventComp  := '';
    if joHint.Exists('__eventcomponent') then begin
        sEventComp  := LowerCase(joHint.__eventcomponent);
    end;

    //
    joHint  := dwGetHintJson(TControl(ACtrl));

    //
    with TEdit(ACtrl) do begin
        joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        joRes.Add('this.'+sFull+'__rdo='+dwIIF(readonly,'true;','false;'));

        //如果当前是事件源控件，则不处理
        if (sEventComp <> sFull) or (TEdit(ACtrl).DoubleBuffered = True) then begin
            if Text = '' then begin
                joRes.Add('this.'+sFull+'__val=[];');
            end else begin
                joRes.Add('this.'+sFull+'__val=['''+dwChangeChar(Text)+'''];');
            end;
        end else begin
            joRes.Add('');
        end;
        //
        joRes.Add('this.'+sFull+'__col="'+dwColor(Color)+'";');

        //选项
        joRes.Add('this.'+sFull+'__mul='+dwGet01Bool(joHint,'multipe','false')+';');
        joRes.Add('this.'+sFull+'__clr='+dwGet01Bool(joHint,'clearable','true')+';');
        joRes.Add('this.'+sFull+'__sch='+dwGet01Bool(joHint,'searchable','true')+';');
        joRes.Add('this.'+sFull+'__ooc='+dwGet01Bool(joHint,'openonclick','false')+';');
        joRes.Add('this.'+sFull+'__oof='+dwGet01Bool(joHint,'openonfocus','false')+';');
        joRes.Add('this.'+sFull+'__cos='+dwGet01Bool(joHint,'clearonselect','false')+';');
        joRes.Add('this.'+sFull+'__cls='+dwGet01Bool(joHint,'closeonselect','true')+';');
        joRes.Add('this.'+sFull+'__aop='+dwGet01Bool(joHint,'alwaysopen','false')+';');
        joRes.Add('this.'+sFull+'__atb='+dwGet01Bool(joHint,'appendtobody','false')+';');
        joRes.Add('this.'+sFull+'__lmt='+IntToStr(dwGetInt(joHint,'limit',3))+';');
        joRes.Add('this.'+sFull+'__mxh='+IntToStr(dwGetInt(joHint,'maxheight',200))+';');
        joRes.Add('this.'+sFull+'__dbn='+dwGet01Bool(joHint,'disablebranchnodes','false')+';');

        //可选节点
        joRes.Add('this.'+sFull+'__opt='+dwGetStr(joHint,'options','[]')+';');
    end;
    //
    Result    := (joRes);
end;

//dwGetMethod
function dwGetMethods(ACtrl:TControl):String;stdCall;
var
    iColumn     : Integer;  //列
    iItem       : Integer;  //
    iSet        : Integer;  //
    iCount      : Integer;
    //
    sCode       : string;
    sPrimaryKey : String;       //数据表主键
    sFull       : string;
    sSet        : String;       //同步控制其他控件的值
    sSetValue   : String;
    //
    slKeys      : TStringList;
    //
    joHint      : Variant;
    joRes       : Variant;
    joColumns   : Variant;
    joColumn    : Variant;

begin
    joRes   := _json('[]');

    //
    sFull   := dwFullName(ACtrl);

    //取得HINT对象JSON
    joHint := dwGetHintJson(TControl(ACtrl));


    with TEdit(ACtrl) do begin


        //选择事件
        sCode   :=
                sFull+'__select(node,instanceId) '
                +'{'
                    +'var jo={};'
                    +'jo.m="event";'
                    +'jo.c="'+sFull+'";'
                    +'jo.i='+IntToStr(TForm(Owner).Handle)+';'
                    +'jo.v=node.id;'
                    +'jo.e="onchange";'
                    +'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:2051}})'
                    +'.then(resp =>{this.procResp(resp.data)});'
                +'},';
        joRes.Add(sCode);


    end;
    //
    Result   := joRes;

end;




exports
     dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetMethods,
     dwGetAction,
     dwGetData;
     
begin
end.

