library dwTEdit__cleave;

uses
     ShareMem,      //必须添加

     //
     dwCtrlBase,    //一些基础函数

     //
     SynCommons,    //mormot用于解析JSON的单元

     //
     Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, ComCtrls, ExtCtrls,
     StdCtrls, Windows;

function _GetFont(AFont:TFont):string;
begin

    Result    := 'color:'+dwColor(AFont.color)+';'
               +'font-family:'''+AFont.name+''';'
               +'font-size:'+IntToStr(AFont.size+3)+'px;';

     //粗体
     if fsBold in AFont.Style then begin
          Result    := Result+'font-weight:bold;';
     end else begin
          Result    := Result+'font-weight:normal;';
     end;

     //斜体
     if fsItalic in AFont.Style then begin
          Result    := Result+'font-style:italic;';
     end else begin
          Result    := Result+'font-style:normal;';
     end;

     //下划线
     if fsUnderline in AFont.Style then begin
          Result    := Result+'text-decoration:underline;';
          //删除线
          if fsStrikeout in AFont.Style then begin
               Result    := Result+'text-decoration:line-through;';
          end;
     end else begin
          //删除线
          if fsStrikeout in AFont.Style then begin
               Result    := Result+'text-decoration:line-through;';
          end else begin
               Result    := Result+'text-decoration:none;';
          end;
     end;
end;

function _GetFontWeight(AFont:TFont):String;
begin
     if fsBold in AFont.Style then begin
          Result    := 'bold';
     end else begin
          Result    := 'normal';
     end;

end;
function _GetFontStyle(AFont:TFont):String;
begin
     if fsItalic in AFont.Style then begin
          Result    := 'italic';
     end else begin
          Result    := 'normal';
     end;
end;
function _GetTextDecoration(AFont:TFont):String;
begin
     if fsUnderline in AFont.Style then begin
          Result    :='underline';
          //删除线
          if fsStrikeout in AFont.Style then begin
               Result    := 'line-through';
          end;
     end else begin
          //删除线
          if fsStrikeout in AFont.Style then begin
               Result    := 'line-through';
          end else begin
               Result    := 'none';
          end;
     end;
end;
function _GetTextAlignment(ACtrl:TControl):string;
begin
     Result    := '';
     case TPanel(ACtrl).Alignment of
          taRightJustify : begin
               Result    := 'right';
          end;
          taCenter : begin
               Result    := 'center';
          end;
     end;
end;




function _GetAlignment(ACtrl:TControl):string;
begin
     Result    := '';
     case TPanel(ACtrl).Alignment of
          taRightJustify : begin
               Result    := 'text-align:right;';
          end;
          taCenter : begin
               Result    := 'text-align:center;';
          end;
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

     joRes.Add('<script src="dist/_cleave/cleave.min.js"></script>');
     joRes.Add('<script src="dist/_cleave/cleave-phone.cn.js"></script>');

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
    sBorder : string;
    sAlign  : string;
    sFull   : string;
    //
    joHint  : Variant;
    joRes   : Variant;
begin
    //生成返回值数组
    joRes    := _Json('[]');

    //取得全名备用
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
                sAlign  := ''
            end;
            taCenter : begin
                sAlign  := 'text-align: center;'
            end;
            taRightJustify : begin
                sAlign  := 'text-align: right;'
            end;
        end;

        //
        sCode   := '<input'
                +' id="'+sFull+'"'
                +' class="'+sFull+'"'
                +dwVisible(TControl(ACtrl))                            //用于控制可见性Visible
                +dwDisable(TControl(ACtrl))                            //用于控制可用性Enabled(部分控件不支持)
                +dwIIF(PasswordChar=#0,'',' show-password')            //是否为密码
                +' v-model="'+sFull+'__txt"'                            //前置
                +dwGetHintValue(joHint,'placeholder','placeholder','') //placeholder,提示语
                +dwGetHintValue(joHint,'prefix-icon','prefix-icon','') //前置Icon
                +dwGetHintValue(joHint,'suffix-icon','suffix-icon','') //后置Icon
                +dwIIF(ReadOnly,' readonly','')                         //是否只读
                +dwGetDWAttr(joHint)
                //+dwLTWH(TControl(ACtrl))                               //Left/Top/Width/Height
                +' :style="{'
                    +'backgroundColor:'+sFull+'__col,'
                    //Font
                    +'color:'+dwFullName(Actrl)+'__fcl,'
                    +'''font-size'':'+dwFullName(Actrl)+'__fsz,'
                    +'''font-family'':'+dwFullName(Actrl)+'__ffm,'
                    +'''font-weight'':'+dwFullName(Actrl)+'__fwg,'
                    +'''font-style'':'+dwFullName(Actrl)+'__fsl,'
                    +'''text-decoration'':'+dwFullName(Actrl)+'__ftd,'
                    //
                    +'left:'+sFull+'__lef,'
                    +'top:'+sFull+'__top,'
                    +'width:'+sFull+'__wid,'
                    +'height:'+sFull+'__hei'
                +'}"'
                +' style="position:absolute;'
                    +'outline:none;'
                    +'padding: 0 3px 0 3px;'  //上右下左
                    +sBorder
                    +sAlign
                    +'overflow: hidden;'
                    +dwGetDWStyle(joHint)
                +'"' // 封闭style
                //+' onclick="this.dwevent('''','''+Name+''',''0'',''onclick'','''+IntToStr(TForm(Owner).Handle)+''')"'
                +dwIIF(Assigned(OnClick),    Format(_DWEVENT,['click.native',             Name,'0','onclick', TForm(Owner).Handle]),'')
                +dwIIF(Assigned(OnKeyDown),   Format(_DWEVENT,['keydown.native',   Name,'event.keyCode','onkeydown', TForm(Owner).Handle]),'')
                +dwIIF(Assigned(OnKeyUp),     Format(_DWEVENT,['keyup.native',     Name,'event.keyCode','onkeyup',   TForm(Owner).Handle]),'')
                +dwIIF(Assigned(OnKeyPress),  Format(_DWEVENT,['keypress.native',  Name,'event.keyCode','onkeypress',TForm(Owner).Handle]),'')
                +Format(_DWEVENT,['input',Name,'escape(this.'+sFull+'__txt)','onchange',TForm(Owner).Handle]) //绑定事件
                +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onmouseenter',TForm(Owner).Handle]),'')
                +dwIIF(Assigned(OnMouseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onmouseexit',TForm(Owner).Handle]),'')
                +dwIIF(Assigned(OnEnter),     Format(_DWEVENT,['focus',            Name,'0','onenter',TForm(Owner).Handle]),'')
                +dwIIF(Assigned(OnExit),      Format(_DWEVENT,['blur',             Name,'0','onexit',TForm(Owner).Handle]),'')
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
     joRes.Add('</input>');          //此处需要和dwGetHead对应
     //
     Result    := (joRes);
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
    sFull   : string;
begin
    //生成返回值数组
    joRes    := _Json('[]');

    //取得全名备用
    sFull   := dwFullName(ACtrl);
    //
    with TEdit(ACtrl) do begin
        joRes.Add(sFull+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(sFull+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(sFull+'__wid:"'+IntToStr(Width-6)+'px",');
        joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(sFull+'__dis:'+dwIIF(Enabled,'false,','true,'));
        //
        joRes.Add(sFull+'__txt:"'+dwChangeChar(Text)+'",');
        //
        joRes.Add(sFull+'__col:"'+dwColor(Color)+'",');
        //
        joRes.Add(sFull+'__fcl:"'+dwColor(Font.Color)+'",');
        joRes.Add(sFull+'__fsz:"'+IntToStr(Font.size+3)+'px",');
        joRes.Add(sFull+'__ffm:"'+Font.Name+'",');
        joRes.Add(sFull+'__fwg:"'+_GetFontWeight(Font)+'",');
        joRes.Add(sFull+'__fsl:"'+_GetFontStyle(Font)+'",');
        joRes.Add(sFull+'__ftd:"'+_GetTextDecoration(Font)+'",');
    end;
    //
    Result    := (joRes);
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    joHint      : Variant;  //__eventcomponent
    sEventComp  : String;
    sFull       : string;
begin
    //生成返回值数组
    joRes   := _Json('[]');

    //取得全名备用
    sFull   := dwFullName(ACtrl);;

    //得到事件源控件
    joHint  := dwGetHintJson(TControl(ACtrl.Owner));

    //
    sEventComp  := '';
    if joHint.Exists('__eventcomponent') then begin
        sEventComp  := LowerCase(joHint.__eventcomponent);
    end;

    //
    with TEdit(ACtrl) do begin
        joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width-6)+'px";');
        joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));
        //如果当前是事件源控件，则不处理
        if (sEventComp <> sFull) or (TControl(ACtrl).ParentCustomHint=False) then begin
            joRes.Add('this.'+sFull+'__txt="'+dwChangeChar(Text)+'";');
        end else begin
            joRes.Add('');
        end;
        //
        joRes.Add('this.'+sFull+'__col="'+dwColor(Color)+'";');
        //
        joRes.Add('this.'+sFull+'__fcl="'+dwColor(Font.Color)+'";');
        joRes.Add('this.'+sFull+'__fsz="'+IntToStr(Font.size+3)+'px";');
        joRes.Add('this.'+sFull+'__ffm="'+Font.Name+'";');
        joRes.Add('this.'+sFull+'__fwg="'+_GetFontWeight(Font)+'";');
        joRes.Add('this.'+sFull+'__fsl="'+_GetFontStyle(Font)+'";');
        joRes.Add('this.'+sFull+'__ftd="'+_GetTextDecoration(Font)+'";');
    end;
    //
    Result    := (joRes);
end;

//取得Mounted
function dwGetMounted(ACtrl:TComponent):String;StdCall;
var
    joRes   : Variant;
    joHint  : Variant;
    //
    bFound  : Boolean;
    //
    sCode   : string;
begin
    //生成返回值数组
    joRes   := _Json('[]');

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //
    with TShape(ACtrl) do begin

        //
        sCode   := 'var cleave = new Cleave(''.'+dwFullName(Actrl)+''', {';

        //
        bFound  := False;
        if joHint.Exists('type') then begin
            if joHint.type = 'creditcard' then begin        //信用卡================================
                bFound  := True;
                //基本
                sCode   := sCode + 'creditCard: true,';
                //A `Boolean` value indicates if enable credit card strict mode.
                //Expand use of 19-digit PANs for supported credit card.
                if joHint.Exists('creditcardstrictmode') then begin
                    sCode   := sCode+'creditCardStrictMode: true,'
                end;
            end else if joHint.type = 'phone' then begin    //电话==================================
                bFound  := True;
                //基本
                sCode   := sCode + 'phone: true,';
                //
                if joHint.Exists('phoneregioncode') then begin
                    sCode   := sCode+'phoneRegionCode: '''+joHint.phoneregioncode+''','
                end else begin
                    sCode   := sCode+'phoneRegionCode: "'+'CN'+'",'
                end;
            end else if joHint.type = 'date' then begin     //日期==================================
                bFound  := True;
                //基本
                sCode   := sCode + 'date: true,';
                //
                if joHint.Exists('datepattern') then begin
                    sCode   := sCode+'datePattern: '+String(joHint.datepattern)+','
                end;
                //最小值
                if joHint.Exists('datemin') then begin
                    sCode   := sCode+'dateMin: '''+joHint.datemin+''','
                end;
                //最大值
                if joHint.Exists('datemax') then begin
                    sCode   := sCode+'dateMax: '''+joHint.datemax+''','
                end;
            end else if joHint.type = 'time' then begin     //时间==================================
                bFound  := True;
                //基本
                sCode   := sCode + 'time: true,';
                //分隔符
                if joHint.Exists('delimiter') then begin
                    sCode   := sCode+'delimiter: '''+joHint.delimiter+''','
                end;
                //分隔符
                if joHint.Exists('timepattern') then begin
                    sCode   := sCode+'timePattern: '+String(joHint.timepattern)+','
                end;
            end else if joHint.type = 'numeral' then begin //数字==================================
                bFound  := True;
                //基本
                sCode   := sCode + 'numeral: true,';

                //千分位/万分位/。。。
                //### `numeralThousandsGroupStyle`
                //A `String` value indicates the thousands separator grouping style.
                //It accepts three preset value:
                //- `thousand`: Thousand numbering group style. It groups numbers in thousands and the delimiter occurs every 3 digits. `1,234,567.89`
                //- `lakh`: Indian numbering group style. It groups the rightmost 3 digits in a similar manner to regular way but then groups every 2 digits thereafter. `12,34,567.89`
                //- `wan`: Chinese numbering group style. It groups numbers in 10-thousand(万, 萬) and the delimiter occurs every 4 digits. `123,4567.89`
                //- `none`: Does not group thousands. `1234567.89`
                //**Default value**: `thousand`
                if joHint.Exists('numeralthousandsgroupstyle') then begin
                    sCode   := sCode+'numeralThousandsGroupStyle: '''+joHint.numeralthousandsgroupstyle+''','
                end;

                //
                //### `numeralIntegerScale`
                //An `Int` value indicates the numeral integer scale.
                if joHint.Exists('numeralintegerscale') then begin
                    sCode   := sCode+'numeralIntegerScale: '+String(joHint.numeralintegerscale)+','
                end;

                //小数位数
                //### `numeralDecimalScale`
                //An `Int` value indicates the numeral decimal scale.
                //**Default value**: `2`
                if joHint.Exists('numeraldecimalscale') then begin
                    sCode   := sCode+'numeralDecimalScale: '+String(joHint.numeraldecimalscale)+','
                end;

                //小数点符号
                //### `numeralDecimalMark`
                //A `String` value indicates the numeral decimal mark.
                //Decimal mark can be different in handwriting, and for [delimiter](#delimiter) as well.
                //**Default value**: `.`
                if joHint.Exists('numeraldecimalmark') then begin
                    sCode   := sCode+'numeralDecimalMark: '''+String(joHint.numeraldecimalmark)+''','
                end;

                //仅输入负数？
                //### `numeralPositiveOnly`
                //A `Boolean` value indicates if it only allows positive numeral value
                //**Default value**: `false`
                if joHint.Exists('numeralpositiveonly') then begin
                    sCode   := sCode+'numeralPositiveOnly: '''+joHint.numeralpositiveonly+''',';
                end;

                //前缀
                //### `signBeforePrefix`
                //A `Boolean` value indicates if the sign of the numeral should appear before the prefix.
                //**Default value**: `false`
                if joHint.Exists('signbeforezprefix') then begin
                    sCode   := sCode+'signBeforePrefix: true,';
                end;

                //后缀
                //A `Boolean` value makes prefix should be appear after the numeral.
                //**Default value**: `false`
                if joHint.Exists('tailprefix') then begin
                    sCode   := sCode+'tailPrefix: true,'
                end;

                //?
                //A `Boolean` value indicates if zeroes appearing at the beginning of the number should be stripped out.
                //This also prevents a number like "100,000" to disappear if the leading "1" is deleted.
                //**Default value**: `true`
                if joHint.Exists('stripleadingzeroes') then begin
                    sCode   := sCode+'stripLeadingZeroes: '+String(joHint.stripleadingzeroes)+','
                end;
            end;
        end;

        //通用项================================================================================
        //分段
        if joHint.Exists('blocks') then begin
            sCode   := sCode+'blocks: '+String(joHint.blocks)+',';
        end;

        //分隔符
        if joHint.Exists('delimiter') then begin
            sCode   := sCode+'delimiter: '''+joHint.delimiter+''','
        end;

        //多分隔符
        if joHint.Exists('delimiters') then begin
            sCode   := sCode+'delimiters: '+String(joHint.delimiters)+',';
        end;

        //分隔符懒出
        //### `delimiterLazyShow`
        //A `boolean` value that if true, will lazy add the delimiter only when the user starting typing the next group section
        //This option is ignored by `phone`, and `numeral` shortcuts mode.
        //**Default value**: `false`
        if joHint.Exists('delimiterlazyshow') then begin
            sCode   := sCode+',delimiterLazyShow: true,';
        end;

        //前后缀
        if joHint.Exists('prefix') then begin
            sCode   := sCode+'prefix: '''+String(joHint.prefix)+''',';
        end;

        //不立即显示前后缀
        //### `noImmediatePrefix`
        //A `boolean` value that if true, will only add the prefix once the user enters values. Useful if you need to use placeholders.
        //**Default value**: `false`
        if joHint.Exists('noimmediateprefix') then begin
            sCode   := sCode+'noImmediatePrefix: true,';
        end;

        //
        //### `rawValueTrimPrefix`
        //A `Boolean` value indicates if to trim prefix in calling `getRawValue()` or getting `rawValue` in AngularJS or ReactJS component.
        //**Default value**: `false`
        if joHint.Exists('rawvaluetrimprefix') then begin
            sCode   := sCode+'rawValueTrimPrefix: true,';
        end;

        //uppercase
        if joHint.Exists('uppercase') then begin
            sCode   := sCode+'uppercase: '+String(joHint.uppercase)+',';
        end;

        //lowercase
        if joHint.Exists('lowercase') then begin
            sCode   := sCode+'lowercase: '+String(joHint.lowercase)+''',';
        end;
        //
        //### `swapHiddenInput`
        //A `Boolean` value indicates if it swaps the input field to a hidden field.
        //This way, formatting only happens on the cloned (visible) UI input, the value of hidden field will be updated as raw value without formatting.
        //**Default value**: `false`
        if joHint.Exists('swaphiddeninput') then begin
            sCode   := sCode+'swapHiddenInput: '+String(joHint.swaphiddeninput)+''',';
        end;

        //删除最后的空格
        if sCode[Length(sCode)]=',' then begin
            Delete(sCode,Length(sCode),1);
        end;

        //尾部封闭
        sCode   := sCode+'});';

        joRes.Add(sCode);
    end;
    //
    Result    := joRes;
end;



exports
     dwGetExtra,
     dwGetMounted,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetData;
     
begin
end.
 
