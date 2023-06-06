library dwTRadioGroup;

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
     Vcl.ExtCtrls,
     Windows,
     Controls,
     Forms;

function dwUnicodeToChinese(inputstr: string): string;   //将类似“%u4E2D”转成中文
var
    index   : Integer;
    temp, top, last: string;
begin
    index := 1;
    while index >= 0 do begin
        index := Pos('%u', inputstr) - 1;
        if index < 0 then begin
            last := inputstr;
            Result := Result + last;
            Exit;
        end;
        top := Copy(inputstr, 1, index); // 取出 编码字符前的 非 unic 编码的字符，如数字
        temp := Copy(inputstr, index + 1, 6); // 取出编码，包括 \u,如\u4e3f
        Delete(temp, 1, 2);
        Delete(inputstr, 1, index + 6);
        Result := Result + top + WideChar(StrToInt('$' + temp));
    end;
end;

//==================================================================================================

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

     //
     Result    := joRes;
end;




//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
    iItem       : Integer;
    sValue      : string;
    joData      : Variant;
    oProcedure  : procedure(Sender:TObject) of Object;
begin
     //
     joData    := _Json(AData);

    with TRadioGroup(ACtrl) do begin
        if joData.e = 'onwebchange' then begin
            //保存事件
            oProcedure    := OnClick;
            //清空事件,以防止自动执行
            OnClick := nil;
            //更新值
            sValue  := dwUnicodeToChinese(String(joData.v));
            for iItem := 0 to Items.Count-1 do begin
                if Items[iItem] = sValue then begin
                    ItemIndex   := iItem;
                    break;
                end;
            end;
            //恢复事件
            OnClick := oProcedure;
            //执行事件
            if Assigned(OnClick) then begin
                OnClick(TRadioGroup(ACtrl));
            end;
        end else if joData.e = 'onenter' then begin
        end;
    end;

end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    iItem       : Integer;
    sCode       : string;
    joHint      : Variant;
    joRes       : Variant;
begin
(*
    <el-radio-group v-model="radio1">
      <el-radio-button label="上海"></el-radio-button>
      <el-radio-button label="北京"></el-radio-button>
      <el-radio-button label="广州"></el-radio-button>
      <el-radio-button label="深圳"></el-radio-button>
    </el-radio-group>
*)
    //生成返回值数组
    joRes    := _Json('[]');

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));
    with TRadioGroup(ACtrl) do begin
        //
        sCode   := '<el-radio-group'
                +' id="'+dwFullName(Actrl)+'"'
                +' label="1"'       //选中值
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                +' v-model="'+dwFullName(Actrl)+'__iti"'    //iti : itemindex
                +' fill="'+dwColor(Color)+'"'    //iti : itemindex
                +' text-color="'+dwColor(Font.Color)+'"'    //iti : itemindex
                +dwGetDWAttr(joHint)
                +dwLTWH(TControl(ACtrl))
                +dwGetDWStyle(joHint)
                +'"' //style 封闭
                +' @change="'+dwFullName(Actrl)+'__chg"'    //chg : chang
                //+dwIIF(Assigned(OnClick),Format(_DWEVENT,['click.native.prevent',Name,'(this.'+dwFullName(Actrl)+'__chk)','onclick',TForm(Owner).Handle]),'')
                +'>';
        //添加到返回值数据
        joRes.Add(sCode);

        for iItem := 0 to Items.Count-1 do begin
            sCode   := Concat(
                    '<el-radio-button',
                    ' label="'+Items[iItem]+'">',
                    '</el-radio-button>'
                    );
            //添加到返回值数据
            joRes.Add(sCode);
        end;

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
     joRes.Add('</el-radio-group>');          //此处需要和dwGetHead对应
     //
     Result    := (joRes);
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes    : Variant;
begin
    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TRadioGroup(ACtrl) do begin
        joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(Enabled,'false,','true,'));
        //
        joRes.Add(dwFullName(Actrl)+'__cap:"'+dwProcessCaption(Caption)+'",');
        //
        if ItemIndex = -1 then begin
            joRes.Add(dwFullName(Actrl)+'__iti:"",');
        end else begin
            joRes.Add(dwFullName(Actrl)+'__iti:"'+Items[ItemIndex]+'",');
        end;
    end;
    //
    Result    := (joRes);
end;

//取得Data
function dwGetAction(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TRadioGroup(ACtrl) do begin
        joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+dwFullName(Actrl)+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__cap="'+dwProcessCaption(Caption)+'";');
        //
        if ItemIndex = -1 then begin
            joRes.Add('this.'+dwFullName(Actrl)+'__iti="";');
        end else begin
            joRes.Add('this.'+dwFullName(Actrl)+'__iti="'+Items[ItemIndex]+'";');
        end;
    end;
    //
    Result    := (joRes);
end;

function dwGetMethods(ACtrl:TControl):String;stdCall;
var
    iItem       : Integer;  //
    sCode       : string;
    joRes       : variant;
    joHint      : variant;
begin
    joRes   := _json('[]');

    //取得HINT对象JSON
    joHint := dwGetHintJson(TControl(ACtrl));


    with TRadioGroup(ACtrl) do begin

        //change事件
        sCode   := Concat(
                dwFullName(Actrl)+'__chg(e) ',
                '{',
                    //'console.log(e);',
                    //
                    'var stmp = "''"+(e)+"''";',
                    //'console.log(stmp);',
                    'this.dwevent("","'+dwFullName(Actrl)+'",stmp,"onwebchange",'+IntToStr(TForm(Owner).Handle)+');',
                '},'
                );
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
     dwGetAction,
     dwGetMethods,
     dwGetData;
     
begin
end.
 
