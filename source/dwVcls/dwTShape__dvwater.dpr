library dwTShape__dvwater;

uses
  ShareMem,
  dwCtrlBase,
  SynCommons,
  SysUtils,
  Buttons,
  ExtCtrls,
  Classes,
  Dialogs,
  StdCtrls,
  Windows,
  Controls,
  Forms;

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):String;stdCall;
var
    joRes   : Variant;
begin
     //生成返回值数组
    joRes := _Json('[]');
    {
    //以下是TChart时的代码,供参考
    joRes.Add('<script src="dist/charts/echarts.min.js"></script>');
    joRes.Add('<script src="dist/charts/lib/index.min.js"></script>');
    joRes.Add('<link rel="stylesheet" href="dist/charts/lib/style.min.css">');
    }
    //joRes.Add('<script src="dist/_datav/vue"></script>');
    joRes.Add('<script src="dist/_datav/datav.min.vue.js"></script>');
    joRes.Add('<style>.border-box-content{display:flex;justify-content: center;align-items: center;}</style>');
    //
    Result := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):String;StdCall;
begin

     //
     result    := '[]';
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):String;StdCall;
var
    sCode   : String;
    sFull   : string;
    //
    joHint  : Variant;
    joRes   : Variant;

begin
    //生成返回值数组
    joRes   := _Json('[]');

    //取得HINT对象JSON
    joHint  := dwGetHintJson(TControl(ACtrl));

    //
    sFull   := dwFullName(Actrl);

    //
    with TShape(ACtrl) do begin
        //
        sCode   :=
        '<dv-water-level-pond'
            +' id="'+sFull+'"'
            +' :config="'+sFull+'__cfg"'
            +dwVisible(TControl(ACtrl))
            +dwDisable(TControl(ACtrl))
            +dwGetDWAttr(joHint)
            +' :style="{'
                +'left:'+dwFullName(Actrl)+'__lef'
                +',top:'+dwFullName(Actrl)+'__top'
                +',width:'+dwFullName(Actrl)+'__wid'
                +',height:'+dwFullName(Actrl)+'__hei'
            +'}"'
            //
            +' style="'
                +'position:absolute;'
                +dwGetDWStyle(joHint)
            +'"' //style 封闭
        +'>';
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
     joRes.Add('</dv-water-level-pond>');
     //
     Result    := (joRes);
end;

//取得Data消息
function dwGetData(ACtrl:TComponent):String;StdCall;
var
    joRes       : Variant;
    joHint      : Variant;
    sFull       : string;
    sShape      : String;
    sFormatter  : String;
begin
    //
    sFull   := dwFullName(Actrl);

    //生成返回值数组
    joRes    := _Json('[]');

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //
    with TShape(ACtrl) do begin

        //取得 形状备用
        if Shape in [stRectangle, stSquare] then begin
            sShape  := ',shape: ''rect''';
        end else if Shape in [stRoundRect, stRoundSquare] then begin
            sShape  := ',shape: ''roundRect''';
        end else if Shape in [stEllipse, stCircle] then begin
            sShape  := ',shape: ''round''';
        end else begin
            sShape  := ',shape: ''round''';
        end;

        //取得格式化备用
        sFormatter  := ',formatter:''{value}%''';
        if joHint.Exists('formatter') then begin
            sFormatter  := ',formatter:'''+joHint.formatter+'''';
        end;

        joRes.Add(sFull+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(sFull+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(sFull+'__dis:'+dwIIF(Enabled,'false,','true,'));

        joRes.Add(sFull+'__cfg:{data:'+dwGetStr(joHint,'data','50')+''
            +sShape
            +sFormatter
        +'},');
    end;
    //
    Result    := (joRes);
end;

//取得事件
function dwGetAction(ACtrl:TComponent):String;StdCall;
var
    joRes       : Variant;
    joHint      : Variant;
    sFull       : string;
    sShape      : String;
    sFormatter  : String;
begin

    //
    sFull   := dwFullName(Actrl);

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //生成返回值数组
    joRes   := _Json('[]');

    //
    with TShape(ACtrl) do begin

        //取得 形状备用
        if Shape in [stRectangle, stSquare] then begin
            sShape  := ',shape: ''rect''';
        end else if Shape in [stRoundRect, stRoundSquare] then begin
            sShape  := ',shape: ''roundRect''';
        end else if Shape in [stEllipse, stCircle] then begin
            sShape  := ',shape: ''round''';
        end else begin
            sShape  := ',shape: ''round''';
        end;

        //取得格式化备用
        sFormatter  := ',formatter:''{value}%''';
        if joHint.Exists('formatter') then begin
            sFormatter  := ',formatter:'''+joHint.formatter+'''';
        end;

        joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
        //
        joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        joRes.Add('document.getElementById("'+sFull+'").width = '+IntToStr(Width)+';');
        joRes.Add('document.getElementById("'+sFull+'").height = '+IntToStr(Height)+';');

        joRes.Add('this.'+sFull+'__cfg={data:'+dwGetStr(joHint,'data','50')+''
            +sShape
            +sFormatter
        +'};');
        //
        //joRes.Add('this.'+sFull+'__typ="'+dwGetProp(TShape(ACtrl),'type')+'";');
    end;
    //
    Result    := (joRes);
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
 
