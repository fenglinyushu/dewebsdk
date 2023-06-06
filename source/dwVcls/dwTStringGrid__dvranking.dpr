library dwTStringGrid__dvranking;

uses
     ShareMem,      //必须添加

     //
     dwCtrlBase,    //一些基础函数

     //
     SynCommons,    //mormot用于解析JSON的单元

     //
     SysUtils,DateUtils,ComCtrls, ExtCtrls,
     Classes,Grids,
     Dialogs,
     StdCtrls,
     Windows,
     Controls,
     Forms;


function _GetConfig(ACtrl:TComponent):string;
var
    iRow    : Integer;
    iCol    : Integer;
    joHint  : Variant;
begin
    Result  := '{';

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));


    with TStringGrid(ACtrl) do begin

        //<Get Data
        Result  := Result + 'data:[';
        for iRow := 0 to RowCount-1 do begin
            Result  := Result + Format('{name:"%s",value:%d},',[Cells[0,iRow],StrToIntDef(Cells[1,iRow],-1)]);
        end;
        Delete(Result,Length(Result),1);
        Result  := Result + ']';
        //>

        //rowNum	表行数	Number	---	5
        if joHint.Exists('rownum') then begin
            Result  := Result + ',rowNum:'+IntToStr(joHint.rowNum);
        end;

        //waitTime	轮播时间间隔(ms)	Number	---	2000
        if joHint.Exists('waittime') then begin
            Result  := Result + ',waitTime:'+IntToStr(joHint.waitTime)+'';
        end;

        //carousel	轮播方式	String	'single'|'page'	'single'
        if joHint.Exists('carousel') then begin
            Result  := Result + ',carousel:"'+joHint.carousel+'"';
        end;

        //unit	数值单位	String	---	''
        if joHint.Exists('unit') then begin
            Result  := Result + ',unit:"'+joHint.unit+'"';
        end;

        //sort	自动排序	Boolean	---	true
        if joHint.Exists('sort') then begin
            Result  := Result + ',sort:'+dwIIF(joHint.sort,'true','false');
        end;



        //

        Result  := Result + '}';
    end;
end;

//--------------------以上为辅助函数----------------------------------------------------------------


//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    joRes: Variant;
begin
    //生成返回值数组
    joRes := _Json('[]');
    joRes.Add('<script src="dist/_datav/datav.min.vue.js"></script>');

    //
    Result := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
    joData  : Variant;
    joValue : Variant;
    joHint  : Variant;
    //
    iValue  : Integer;
    iRow    : Integer;
    iCol    : Integer;
    iOrder  : Integer;
    iP0,iP1 : Integer;
    sValue  : string;
    sCol    : string;
    sFilter : String;

    //OnMouseDown,OnMouseUp
    mButton : TMouseButton;
    mShift  : TShiftState;
    mX, mY  : Integer;
begin

    //
    with TStringGrid(ACtrl) do begin
        //vue luck draw -------------------------------------------------

        //
        joData    := _Json(AData);
        if joData.e = 'onclick' then begin
        end else if joData.e = 'onenddock' then begin
             //执行事件
             if Assigned(TStringGrid(ACtrl).OnEndDock) then begin
                  TStringGrid(ACtrl).OnEndDock(TStringGrid(ACtrl),nil,joData.v,0);
             end;
        end;
    end;

end;



//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    //
    iItem     : Integer;
    iColID    : Integer;
    //
    bColed    : Boolean;     //已添加表头信息
    //
    sRowStyle : string;
    sBack     : string;
    sCode      : string;
    //
    joHint    : Variant;
    joRes     : Variant;
    joCols    : Variant;
    joCol     : Variant;
begin
    //
    with TStringGrid(ACtrl) do begin
        //-------------DataV动态环图----------------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //
        with TStringGrid(ACtrl) do begin
            //添加主体
            joRes.Add('<dv-scroll-ranking-board'
                    +' id="'+dwFullName(Actrl)+'"'
                    +' :config="'+dwFullName(Actrl)+'__cfg"'    //config
                    +dwVisible(TControl(ACtrl))                 //是否可见
                    +dwGetDWAttr(joHint)                        //dwAttr
                    +' :style="{'
                        +'left:'+dwFullName(Actrl)+'__lef,'
                        +'top:'+dwFullName(Actrl)+'__top,'
                        +'width:'+dwFullName(Actrl)+'__wid,'
                        +'height:'+dwFullName(Actrl)+'__hei'
                    +'}"'
                    //
                    +' style="position:absolute;'
                        +dwGetDWStyle(joHint)
                    +'"'
                    +'>');

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
    //
    with TStringGrid(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');

        //
        joRes.Add('</dv-scroll-ranking-board>');

        //
        Result    := joRes;
    end;
end;

//取得Data
function dwGetData(ACtrl:TControl):string;StdCall;
var
     joRes     : Variant;
     //
     iRow,iCol : Integer;
     sCode     : String;
     S         : String;
begin
    //
    with TStringGrid(ACtrl) do begin
        //TStringGrid 用作幸运大抽奖

        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TStringGrid(ACtrl) do begin
            //
            joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
            joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
            joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
            joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
            //
            joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));

            //
            joRes.Add(dwFullName(Actrl)+'__cfg :'+_GetConfig(ACtrl)+',');
            //joRes.Add(dwFullName(Actrl)+'__clr :["#00f","#0f0","f00","#888"],');//+_GetData(ACtrl)+',');
        end;

        //
        Result    := (joRes);
    end;
end;



//取得Method
function dwGetAction(ACtrl:TControl):string;StdCall;
var
    joRes     : Variant;
    //
    iRow,iCol : Integer;
    sCode     : String;
begin
    //
    with TStringGrid(ACtrl) do begin
        //TStringGrid 用作幸运大抽奖

        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TStringGrid(ACtrl) do begin
            //
            joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
            //
            joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));

            //
            joRes.Add('this.'+dwFullName(Actrl)+'__cfg ='+_GetConfig(ACtrl)+';');
            //joRes.Add(dwFullName(Actrl)+'__clr :["#00f","#0f0","f00","#888"],');//+_GetData(ACtrl)+',');
        end;

        //
        Result    := (joRes);
    end;
end;

function dwGetMethods(ACtrl:TControl):string;StdCall;
var
    //
    sCode   : string;
    //
    joRes   : Variant;
begin
    joRes   := _json('[]');


    with TStringGrid(ACtrl) do begin
    end;

    //
    Result  := joRes;
end;


exports
     dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetMethods,
     dwGetData;

begin
end.
 
