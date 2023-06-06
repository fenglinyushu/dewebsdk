library dwTListView__mobile;

uses
    ShareMem,

    //deweb 控件开发单元
    dwBase,
    dwCtrlBase,
    dwDB,

    //JSON解析处理单元
    SynCommons,

    //
    Generics.Collections,
    Messages,
    Graphics,
    ComCtrls,
    ExtCtrls,
    ADODB,
    Math,
    Vcl.DBGrids,
    SysUtils,
    Variants,
    Classes,
    Dialogs,
    StdCtrls,
    Windows,
    Controls,
    Forms;

type
    TDics   = array of TDictionary<string,String>;

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
     case TLabel(ACtrl).Alignment of
          taRightJustify : begin
               Result    := 'right';
          end;
          taCenter : begin
               Result    := 'center';
          end;
     else
               Result    := 'left';
     end;
end;

function _GetColumns(ACtrl:TComponent):Variant;
var
    //
    iColumn     : Integer;
    iTop        : Integer;
    iLeft       : Integer;
    //
    oColumn     : TListColumn;
    //
    joColumn    : Variant;
    joCaption   : Variant;
begin
    //生成各列的显示设置JSON对象
    Result   := _json('[]');

    //
    with TListView(ACtrl) do begin
        //默认上边距5
        iTop    := 10;
        iLeft   := 10;

        //
        for iColumn := 0 to Columns.Count-1 do begin
            oColumn             := Columns[iColumn];
            //
            joColumn            := _json(oColumn.Caption);
            if joColumn = unassigned then begin
                joColumn            := _json('{}');
            end;
            //
            case oColumn.Alignment of
                taLeftJustify   : joColumn.alignment  := 'left';
                taCenter        : joColumn.alignment  := 'center';
                taRightJustify  : joColumn.alignment  := 'right';
            end;

            //
            if not joColumn.Exists('width') then begin
                joColumn.width   := oColumn.Width;
            end;
            //
            if not joColumn.Exists('top') then begin
                joColumn.top        := iTop;
            end else begin
                iTop    := joColumn.top;
            end;
            //如果没有指定left，则使用上个字段的left；如果为第1个字段，则为10
            if not joColumn.Exists('left') then begin
                joColumn.left       := iLeft;
            end else begin
                iLeft   := joColumn.left;
            end;
            //
            if not joColumn.Exists('type') then begin
                joColumn.type       := 'label';
            end;
            //
            if not joColumn.Exists('dwattr') then begin
                joColumn.dwattr := '';
            end;
            //
            if not joColumn.Exists('dwstyle') then begin
                joColumn.dwstyle    := '';
            end;
            //字体
            if not joColumn.Exists('fontname') then begin
                joColumn.fontname   := Font.Name;
            end;
            if not joColumn.Exists('fontsize') then begin
                joColumn.fontsize   := Font.Size;
            end;
            if not joColumn.Exists('fontcolor') then begin
                joColumn.fontcolor  := dwColor(Font.Color);
            end;
            if not joColumn.Exists('fontbold') then begin
                joColumn.fontbold  := 'normal';
            end;
            if not joColumn.Exists('fontitalic') then begin
                joColumn.fontitalic  := 'normal';
            end;
            if not joColumn.Exists('fontdecoration') then begin
                joColumn.fontdecoration  := 'none';
            end;
            //
            if not joColumn.Exists('color') then begin
                joColumn.color      := Color;
            end;
            //
            if not joColumn.Exists('height') then begin
                joColumn.height     := Round(joColumn.fontsize*1.5);
            end;

            //协调left/width/right和top/height/bottom
            joColumn.horzmode   := 0;                   //0：left + width
            if joColumn.Exists('right') then begin
                if joColumn.Exists('nowidth') then begin
                    joColumn.Delete('width');
                    joColumn.horzmode   := 1;           //1 : left + right
                end else begin
                    joColumn.Delete('left');
                    joColumn.horzmode   := 2;           //2 : right + width
                end;
            end;
            joColumn.vertmode   := 0;                   //0：top + height
            if joColumn.Exists('bottom') then begin
                if joColumn.Exists('noheight') then begin
                    joColumn.Delete('height');
                    joColumn.vertmode   := 1;           //1：top + bottom
                end else begin
                    joColumn.Delete('top');
                    joColumn.vertmode   := 2;           //2：height + bottom
                end;
            end;

            //
            if (joColumn.type = 'rate') and (not joColumn.Exists('scale')) then begin
                joColumn.scale  := 1;
            end;

            //
            if not joColumn.Exists('caption') then begin
                if joColumn.Exists('fieldname') then begin
                    joColumn.caption    := joColumn.fieldname;
                end else begin
                    joColumn.caption    := '';
                end;
            end;

            //
            if joColumn.type='boolean' then begin
                if not joColumn.Exists('list') then begin
                    joColumn.list   := _json('["true","false"]');
                end;
            end;

            //更新顶间距
            iTop            := iTop + joColumn.height;

            //
            Result.Add(joColumn);
        end;
    end;
end;





//==================================================================================================

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):String;stdCall;
begin
     Result    := '[]';
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):String;StdCall;
var
    //
    iColumn     : Integer;
    iOldRecNo   : Integer;
    //
    sValue      : String;
    sField      : string;
    sJS         : string;
    sFull       : string;
    //
    joData      : Variant;
    joValue     : Variant;
    joColumns   : Variant;
    joColumn    : Variant;
begin
    //
    joData  := _Json(AData);
    //
    if joData = unassigned then begin
        Exit;
    end;

    //
    sFull   := dwFullName(Actrl);

    //
    with TListView(ACtrl) do begin
        //取得各列信息JSON数组
        joColumns   := _GetColumns(ACtrl);


        if joData.e = 'oncompclick' then begin
            sValue  := dwUnescape(joData.v); //应该为2个整型数，例：7,12,第一个为列序号（0始），第二个为记录序号（0始）
            joValue := _json('['+sValue+']');
            //
            if joValue = unassigned then begin
                Exit;
            end;

            if joValue._Count <> 2 then begin
                Exit;
            end;

            with TListView(ACtrl) do begin
                if Assigned(OnEndDrag) then begin
                    OnEndDrag(TListView(ACtrl),nil,joValue._(0),joValue._(1));
                end;
                //
                if ItemIndex <> joValue._(1) then begin
                    ItemIndex   := joValue._(1);
                    if Assigned(OnChange) then begin
                        OnChange(TListView(ACtrl),Items[ItemIndex],ctText);
                    end;
                end;
            end;
        end else if joData.e = 'ondeleteclick' then begin   //已确认删除
            //v为记录号，从0开始
            Items.Delete(joData.v);
            //
            if Assigned(TListView(ACtrl).OnChange) then begin
                TListView(ACtrl).OnChange(TListView(ACtrl),nil,ctText);
            end;
        end else if joData.e = 'onedit' then begin
            //v为记录号，从0开始
            Items[joData.v].Selected    := True;
            //
            if Assigned(TListView(ACtrl).OnChange) then begin
                TListView(ACtrl).OnChange(TListView(ACtrl),Selected,ctText);
            end;
        end else if joData.e = 'onappend' then begin
            //v为记录号，从0开始

            with Items.Add do begin
                Caption := '';
                for iColumn := 1 to Columns.Count-1 do begin
                    joColumn    := joColumns._(iColumn);
                    if joColumn.Exists('default') then begin
                        SubItems.Add(joColumn.default);
                    end else begin
                        SubItems.Add('');
                    end;
                end;
                //
                Selected    := True;
            end;
            //
            if Assigned(TListView(ACtrl).OnChange) then begin
                TListView(ACtrl).OnChange(TListView(ACtrl),Selected,ctText);
            end;
        end else if joData.e = 'onmoveup' then begin
            //v为记录号，从0开始
            if joData.v>0 then begin
                sValue  := Items[joData.v-1].Caption;
                //
                Items[joData.v-1].Caption   := Items[joData.v].Caption;
                Items[joData.v].Caption     := sValue;
                //
                for iColumn := 1 to Columns.Count-1 do begin
                    if iColumn > Items[joData.v-1].SubItems.Count-1 then begin
                        break;
                    end;

                    sValue  := Items[joData.v-1].SubItems[iColumn-1];
                    //
                    Items[joData.v-1].SubItems[iColumn-1]   := Items[joData.v].SubItems[iColumn-1];
                    Items[joData.v].SubItems[iColumn-1]     := sValue;
                end;
            end;
            //
            if Assigned(TListView(ACtrl).OnChange) then begin
                TListView(ACtrl).OnChange(TListView(ACtrl),Items[joData.v],ctText);
            end;
        end else if joData.e = 'onmovedown' then begin
            //v为记录号，从0开始
            if joData.v<Items.Count-1 then begin
                sValue  := Items[joData.v+1].Caption;
                //
                Items[joData.v+1].Caption   := Items[joData.v].Caption;
                Items[joData.v].Caption     := sValue;
                //
                for iColumn := 1 to Columns.Count-1 do begin
                    if iColumn > Items[joData.v+1].SubItems.Count-1 then begin
                        break;
                    end;
                    sValue  := Items[joData.v+1].SubItems[iColumn-1];
                    //
                    Items[joData.v+1].SubItems[iColumn-1]   := Items[joData.v].SubItems[iColumn-1];
                    Items[joData.v].SubItems[iColumn-1]     := sValue;
                end;
            end;

            //
            if Assigned(TListView(ACtrl).OnChange) then begin
                TListView(ACtrl).OnChange(TListView(ACtrl),Items[joData.v],ctText);
            end;

        end else if joData.e = 'onsave' then begin
            //oDataSet.RecNo  := Integer(joData.v)+1;
            //得到数据字符串，JSON数组格式，第一个值 为记录号，0始
            sValue  := dwUnescape(joData.v);
            //
            joValue := _json(sValue);
            //
            with Items[joValue._(0)] do begin
                Caption := joValue._(1);
                //
                SubItems.Clear;
                for iColumn := 2 to joValue._Count-1 do begin
                    SubItems.Add(String(joValue._(iColumn)));
                end;
            end;
            //
            if Assigned(TListView(ACtrl).OnChange) then begin
                TListView(ACtrl).OnChange(TListView(ACtrl),Items[joValue._(0)],ctText);
            end;

        end else if joData.e = 'onquery' then begin
            //v为搜索关键字（可能多个）
            sValue  := dwUnescape(joData.v);


        end else if joData.e = 'onenddock' then begin
        end;
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):String;StdCall;
var
    sCode       : String;
    sFull       : string;
    sKey        : String;
    sCardStyle  : string;
    sCardAttr   : string;
    sMin,sMax   : string;       //用于
    //
    iRecord     : Integer;
    iColumn     : Integer;
    iTop        : Integer;
    iList       : Integer;
    iPageSize   : Integer;
    iBtnTop     : Integer;  //记录卡片内按钮top
    //
    bDelete     : Boolean;
    //
    oColumn     : TListColumn;

    //
    joHint      : Variant;
    joRes       : Variant;
    //
    joColumns   : Variant;
    joColumn    : Variant;
    joCaption   : Variant;

    //生成字段的left/width/right和top/height/bottom字符串
    function _GetLWR_THB(AColumn:Integer):String;
    var
        jjCol   : variant;
    begin
        Result  := '';
        jjCol   := joColumns._(AColumn);
        if jjCol.Exists('left') then begin
            Result  := Result +'left:rd.dl'+IntToStr(AColumn)+',';         //data left
        end;
        if jjCol.Exists('width') then begin
            Result  := Result +'width:rd.dw'+IntToStr(AColumn)+',';         //data left
        end;
        if jjCol.Exists('right') then begin
            Result  := Result +'right:rd.dr'+IntToStr(AColumn)+',';         //data left
        end;

        if jjCol.Exists('top') then begin
            Result  := Result +'top:rd.dt'+IntToStr(AColumn)+',';         //data left
        end;
        if jjCol.Exists('height') then begin
            Result  := Result +'height:rd.dh'+IntToStr(AColumn)+',';         //data left
        end;
        if jjCol.Exists('bottom') then begin
            Result  := Result +'bottom:rd.db'+IntToStr(AColumn)+',';         //data left
        end;
    end;

    //检查是否显示增删改查移：0/1/2/3/4
    function _GetModule(AIndex:Integer):Boolean;
    begin
        Result  := True;
        if AIndex in [0,1,2,3,4,5] then begin
            if joHint.Exists('module') then begin
                if joHint.module._Count>AIndex then begin
                    Result  := joHint.module._(AIndex)<>0;
                end;
            end;
        end;
        if AIndex in [3,5] then begin
            Result  := False;
        end;

    end;
begin
    //生成返回值数组
    joRes    := _Json('[]');

    //取得全名备用
    sFull   := dwFullName(Actrl);

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //_DWEVENT = ' @%s="dwevent($event,''%s'',''%s'',''%s'',''%s'')"';
    //参数依次为: JS事件名称, 控件名称,控件值,Delphi事件名称,备用


    //
    with TListView(ACtrl) do begin

        //背景框 总外框
        sCode   := '<div'
                +' id="'+sFull+'"'
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                +dwGetDWAttr(joHint)
                +' :style="{'
                    //字体
                    +'''font-size'':'+dwFullName(Actrl)+'__fsz,'
                    +'''font-family'':'+dwFullName(Actrl)+'__ffm,'
                    +'''font-weight'':'+dwFullName(Actrl)+'__fwg,'
                    +'''font-style'':'+dwFullName(Actrl)+'__fsl,'
                    +'''text-decoration'':'+dwFullName(Actrl)+'__ftd,'
                    //+'''text-align'':'+dwFullName(Actrl)+'__fta,'
                    //LTWH
                    +'left:'+sFull+'__lef,'
                    +'top:'+sFull+'__top,'
                    +'width:'+sFull+'__wid,'
                    +'height:'+sFull+'__hei'
                +'}"'
                +' style="position:absolute;'
                    +dwGetDWStyle(joHint)
                    +'background-color:'+dwColor(Color)+';'
                +'"' //style 封闭
                //+dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
                +dwIIF(Assigned(OnEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),'')
                +dwIIF(Assigned(OnExit),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),'')
                +'>';
        joRes.Add(sCode);

        //
        if _GetModule(3) then begin
            //查询框
            sCode   := concat(
                    '<div',
                        ' style="',
                            'position:absolute;',
                            'top:0px;',
                            'height:50px;',
                            'width:100%;',
                            'background:#cc9933;',
                        '"',
                    '>');
            joRes.Add(sCode);

            //关键字框
            sCode   := concat(
                    '<el-input',
                        ' v-model="'+sFull+'__key"',     //keyword
                        ' prefix-icon="el-icon-search"',
                        ' placeholder="搜索"',
                        ' style="',
                            'position:absolute;',
                            'top:10px;',
                            'height:30px;',
                            'left:8%;',
                            'width:84%;',
                            'border-radius:15px;',
                            'background:#fff;',
                        '"',
                        ' @input="'+sFull+'__query($event,'+sFull+'__key)"',
                    '></el-input>');
            joRes.Add(sCode);


            //查询框封闭
            joRes.Add('</div>');

            //滚动框
            sCode   := concat(
                    '<el-scrollbar',
                        ' ref="'+sFull+'"',
                        ' style="',
                            'position:absolute;',
                            'top:50px;',
                            'width:100%;',
                            'bottom:0px;',
                        '"',
                    '>');
            joRes.Add(sCode);
        end else begin
            //滚动框
            sCode   := concat(
                    '<el-scrollbar',
                        ' ref="'+sFull+'"',
                        ' style="',
                            'width:100%;',
                            'top:0px;',
                            'height:100%;',
                            'bottom:0px;',
                        '"',
                    '>');
            joRes.Add(sCode);
        end;

        //内框（用于放置多条记录)
        sCode   := '<el-main'
                +' id="'+sFull+'__ctt"'     //ctt:content
                //动态值
                +' :style="{'
                    +'height:'+sFull+'__cth'       //cth : content height
                +'}"'
                //静态值
                +' style="'
                    +'position:relative;'
                    +'color:'+dwColor(Font.Color)+';'
                    +'left:0;'
                    +'top:0;'
                    +'width:100%;'
                    +'overflow:hidden;'
                +'"'
                +'>';
        joRes.Add(sCode);

        //
        joColumns   := _GetColumns(ACtrl);


        //取得每个卡的attr和style备用
        sCardAttr   := '';
        if joHint.Exists('cardattr') then begin
            sCardAttr   := ' '+ joHint.cardattr;
        end;
        sCardStyle  := '';
        if joHint.Exists('cardstyle') then begin
            sCardStyle  := ' '+ joHint.cardstyle;
        end;


        //显示多条记录
        sCode   := '<div'   //每个卡片的框
                +' v-for="(rd,rindex) in '+sFull+'__rds"'     //rds:records
                +sCardAttr
                //动态值
                +' :style="{'
                    +'border:rd.b,'
                    +dwIIF(pos('radius',sCardStyle)>0,'','borderRadius:rd.r,')    //rd.r : record radius
                    +'left:rd.l,'           //rd.l : record left
                    +'top:rd.t,'            //rd.t : record top
                    +'width:rd.w,'          //rd.w : record width
                    +'height:rd.h'         //rd.h : record height
                +'}"'
                //静态值
                +' style="'
                    +'position:absolute;'
                    +'background-color:'+dwColor(Color)+';'
                    //+'overflow:hidden;'
                    +'left:0;'
                    +'width:100%;'
                    //+'border:solid 1px #ccc;'
                    +sCardStyle
                +'"'
                +' @click="function(event){'
                    +'dwevent(event,'''+sFull+''',''[-1,''+rindex+'']'',''oncompclick'','''+IntToStr(TForm(Owner).Handle)+''');'
                +'}" '
                +'>';
        //
        for iColumn := 0 to Columns.Count-1 do begin
            oColumn     := Columns[iColumn];
            joColumn    := joColumns._(iColumn);
                        //
            if joColumn.type = 'image' then begin
                //
                sCode   := sCode
                        +#13'<el-image'
                            //
                            +' :src="rd.src'+IntToStr(iColumn)+'"'
                            //
                            +dwGetDWAttr(joColumn)
                            //动态值
                            +' :style="{'
                                //生成字段的left/width/right和top/height/bottom字符串
                                +_GetLWR_THB(iColumn)
                            +'}"'
                            //静态值
                            +' style="'
                                +'position:absolute;'
                                +dwGetDWStyle(joColumn)
                            +'"'
                            +' @click="function(event){'
                                +'dwevent(event,'''+sFull+''',''[''+'''+IntToStr(iColumn)+',''+rindex+'']'',''oncompclick'','''+IntToStr(TForm(Owner).Handle)+''');'
                            +'}" '
                            +'>'
                        +'</el-image>';
            end else if joColumn.type = 'button' then begin
                sCode   := sCode
                        +#13'<el-button'
                            //
                            +dwGetDWAttr(joColumn)
                            //动态值
                            +' :style="{'
                                //字体
                                //+'''font-size'':rd.dfs'+IntToStr(iColumn)+','
                                //+'''font-family'':rd.dfn'+IntToStr(iColumn)+','
                                //+'''font-weight'':rd.dfwg'+IntToStr(iColumn)+','
                                //+'''font-style'':rd.dfsl'+IntToStr(iColumn)+','
                                //+'''text-decoration'':rd.dftd'+IntToStr(iColumn)+','
                                //+'color:rd.dfc'+IntToStr(iColumn)+','
                                //生成字段的left/width/right和top/height/bottom字符串
                                +_GetLWR_THB(iColumn)
                            +'}"'
                            //静态值
                            +' style="'
                                +'position:absolute;'
                                //+'background-color:'+dwColor(joColumn.color)+';'
                                +dwGetDWStyle(joColumn)
                            +'"'
                            +' @click="function(event){'
                                +'dwevent(event,'''+sFull+''',''[''+'''+IntToStr(iColumn)+',''+rindex+'']'',''oncompclick'','''+IntToStr(TForm(Owner).Handle)+''');'
                            +'}" '
                            +'>'
                            +'{{rd.d'+IntToStr(iColumn)+'}}'
                        +'</el-button>';
            end else if joColumn.type = 'rate' then begin
                sCode   := sCode
                        +#13'<el-rate'
                            //
                            +' v-model="rd.d'+IntToStr(iColumn)+'"'
                            +' disabled'
                            +' allow-half'
                            //+' show-score'
                            +' text-color="rd.dfc'+IntToStr(iColumn)+'"'
                            //
                            +dwGetDWAttr(joColumn)
                            //动态值
                            +' :style="{'
                                //字体
                                +'''font-size'':rd.dfs'+IntToStr(iColumn)+','
                                +'''font-family'':rd.dfn'+IntToStr(iColumn)+','
                                +'''font-weight'':rd.dfwg'+IntToStr(iColumn)+','
                                +'''font-style'':rd.dfsl'+IntToStr(iColumn)+','
                                +'''text-decoration'':rd.dftd'+IntToStr(iColumn)+','
                                //生成字段的left/width/right和top/height/bottom字符串
                                +_GetLWR_THB(iColumn)
                            +'}"'
                            //静态值
                            +' style="'
                                +'position:absolute;'
                                +'background-color:'+dwColor(joColumn.color)+';'
                                +dwGetDWStyle(joColumn)

                            +'"'
                            +' @click="function(event){'
                                +'dwevent(event,'''+sFull+''',''[''+'''+IntToStr(iColumn)+',''+rindex+'']'',''oncompclick'','''+IntToStr(TForm(Owner).Handle)+''');'
                            +'}" '
                            +'>'
                        +'</el-rate>';
            end else begin
                sCode   := sCode
                        +#13'<div'
                            //
                            +dwGetDWAttr(joColumn)
                            //动态值
                            +' :style="{'
                                //字体
                                +'''font-size'':rd.dfs'+IntToStr(iColumn)+','
                                +'''font-family'':rd.dfn'+IntToStr(iColumn)+','
                                +'''font-weight'':rd.dfwg'+IntToStr(iColumn)+','
                                +'''font-style'':rd.dfsl'+IntToStr(iColumn)+','
                                +'''text-decoration'':rd.dftd'+IntToStr(iColumn)+','
                                +'color:rd.dfc'+IntToStr(iColumn)+','
                                //生成字段的left/width/right和top/height/bottom字符串
                                +_GetLWR_THB(iColumn)
                            +'}"'
                            //静态值
                            +' style="'
                                +'position:absolute;'
                                +'overflow:hidden;'
                                +'text-align:'+joColumn.alignment+';'
                                +dwGetDWStyle(joColumn)
                            +'"'
                            +' @click="function(event){'
                                +'dwevent(event,'''+sFull+''',''[''+'''+IntToStr(iColumn)+',''+rindex+'']'',''oncompclick'','''+IntToStr(TForm(Owner).Handle)+''');'
                            +'}" '
                            +'>'
                            +'{{rd.d'+IntToStr(iColumn)+'}}'
                        +'</div>';
            end;
        end;

        //添加“删除”按钮
        iBtnTop := 6;
        bDelete := _GetModule(1);   //用于标志是否有删除按钮，以便显示编辑按钮top
        if bDelete then begin
            //
            sCode   := sCode
                    +#13'<el-button'
                        +' icon="el-icon-remove-outline"'    //el-icon-minus"'
                        //+' circle'
                        +' type="text"'
                        //动态值
                        +' :style="{'
                            //字体
                            {
                            +'''font-family'':rd.dfn'+IntToStr(iColumn)+','
                            +'''font-weight'':rd.dfwg'+IntToStr(iColumn)+','
                            +'''font-style'':rd.dfsl'+IntToStr(iColumn)+','
                            +'''text-decoration'':rd.dftd'+IntToStr(iColumn)+','
                            +'color:rd.dfc'+IntToStr(iColumn)+','
                            }
                        +'}"'
                        //静态值
                        +' style="'
                            +'position:absolute;'
                            +'font-size:20px;'
                            +'color:#ccc;'
                            +'right:8px;'
                            +'top:'+IntToStr(iBtnTop)+'px;'
                            +'width:28px;'
                            +'height:28px;'
                            +'background-color:transparent;'
                        +'"'
                        +' @click="function(event){'
                            +sFull+'__rcn=rindex;'
                            +sFull+'__cfv=true;'
                        +'}" '
                        +'>'
                    +'</el-button>';
            //
            iBtnTop := iBtnTop + 24;
        end;

        //添加“编辑”按钮
        if _GetModule(2) then begin
            //
            sCode   := sCode
                    +#13'<el-button'
                        +' icon="el-icon-edit-outline"'    //el-icon-minus"'
                        //+' circle'
                        +' type="text"'
                        //动态值
                        +' :style="{'
                            //字体
                            {
                            +'''font-family'':rd.dfn'+IntToStr(iColumn)+','
                            +'''font-weight'':rd.dfwg'+IntToStr(iColumn)+','
                            +'''font-style'':rd.dfsl'+IntToStr(iColumn)+','
                            +'''text-decoration'':rd.dftd'+IntToStr(iColumn)+','
                            +'color:rd.dfc'+IntToStr(iColumn)+','
                            }
                        +'}"'
                        //静态值
                        +' style="'
                            +'position:absolute;'
                            +'font-size:20px;'
                            +'color:#ccc;'
                            +'right:8px;'
                            +'top:'+IntToStr(iBtnTop)+'px;'
                            +'width:28px;'
                            +'height:28px;'
                            +'background-color:transparent;'
                        +'"'
                        +' @click="function(event){'
                            +sFull+'__rcn=rindex;'
                            +'dwevent(event,'''+sFull+''',''this.'+sFull+'__rcn'',''onedit'','''+IntToStr(TForm(Owner).Handle)+''');'
                            +sFull+'__edv=true;'
                        +'}" '
                        +'>'
                    +'</el-button>';
            //
            iBtnTop := iBtnTop + 24;
        end;

        //添加“上移”/"下移"按钮
        if _GetModule(4) then begin
            //上移
            sCode   := sCode
                    +#13'<el-button'
                        +' icon="el-icon-top"'    //el-icon-minus"'
                        //+' circle'
                        +' type="text"'
                        //动态值
                        +' :style="{'
                            //字体
                            {
                            +'''font-family'':rd.dfn'+IntToStr(iColumn)+','
                            +'''font-weight'':rd.dfwg'+IntToStr(iColumn)+','
                            +'''font-style'':rd.dfsl'+IntToStr(iColumn)+','
                            +'''text-decoration'':rd.dftd'+IntToStr(iColumn)+','
                            +'color:rd.dfc'+IntToStr(iColumn)+','
                            }
                        +'}"'
                        //静态值
                        +' style="'
                            +'position:absolute;'
                            +'font-size:20px;'
                            +'color:#ccc;'
                            +'right:8px;'
                            +'top:'+IntToStr(iBtnTop)+'px;'
                            +'width:28px;'
                            +'height:28px;'
                            +'background-color:transparent;'
                        +'"'
                        +' @click="function(event){'
                            +sFull+'__rcn=rindex;'
                            +'dwevent(event,'''+sFull+''',''this.'+sFull+'__rcn'',''onmoveup'','''+IntToStr(TForm(Owner).Handle)+''');'
                        +'}" '
                        +'>'
                    +'</el-button>';
            //
            iBtnTop := iBtnTop + 24;

            //下移
            sCode   := sCode
                    +#13'<el-button'
                        +' icon="el-icon-bottom"'    //el-icon-minus"'
                        //+' circle'
                        +' type="text"'
                        //动态值
                        +' :style="{'
                            //字体
                            {
                            +'''font-family'':rd.dfn'+IntToStr(iColumn)+','
                            +'''font-weight'':rd.dfwg'+IntToStr(iColumn)+','
                            +'''font-style'':rd.dfsl'+IntToStr(iColumn)+','
                            +'''text-decoration'':rd.dftd'+IntToStr(iColumn)+','
                            +'color:rd.dfc'+IntToStr(iColumn)+','
                            }
                        +'}"'
                        //静态值
                        +' style="'
                            +'position:absolute;'
                            +'font-size:20px;'
                            +'color:#ccc;'
                            +'right:8px;'
                            +'top:'+IntToStr(iBtnTop)+'px;'
                            +'width:28px;'
                            +'height:28px;'
                            +'background-color:transparent;'
                        +'"'
                        +' @click="function(event){'
                            +sFull+'__rcn=rindex;'
                            +'dwevent(event,'''+sFull+''',''this.'+sFull+'__rcn'',''onmovedown'','''+IntToStr(TForm(Owner).Handle)+''');'
                        +'}" '
                        +'>'
                    +'</el-button>';
            //
            iBtnTop := iBtnTop + 24;
        end;
        //
        sCode   := sCode+'</div>';
        joRes.Add(sCode);

        //
        joRes.Add('</el-main>');

        //添加“添加”按钮
        if _GetModule(0) then begin
            sCode   :=
                    '<el-button'
                        //+' icon="el-icon-circle-plus"'    //el-icon-minus"'
                        +' circle'
                        +' type="text"'
                        //动态值
                        +' :style="{'
                            //字体
                            {
                            +'''font-family'':rd.dfn'+IntToStr(iColumn)+','
                            +'''font-weight'':rd.dfwg'+IntToStr(iColumn)+','
                            +'''font-style'':rd.dfsl'+IntToStr(iColumn)+','
                            +'''text-decoration'':rd.dftd'+IntToStr(iColumn)+','
                            +'color:rd.dfc'+IntToStr(iColumn)+','
                            }
                        +'}"'
                        //静态值
                        +' style="'
                            +'position:absolute;'
                            +'font-size:40px;'
                            +'color:#fff;'
                            +'right:10px;'
                            +'bottom:40px;'
                            +'width:48px;'
                            +'height:48px;'
                            +'background-color:rgb(147,125,252);'
                        +'"'
                        +' @click="'+sFull+'__append($event,'+sFull+'__rcn)"'
                        +'>+'
                    +'</el-button>';
            //
            joRes.Add(sCode);
        end;


        //生成返回值数组
        joRes.Add('</el-scrollbar>');



        //<添加删除确认窗体=========================================================================
        //遮罩层
        sCode   := Concat('<div id='+sFull+'"__cfm"',   //cfm:confirm mask
                ' v-show="'+sFull+'__cfv"',         //confirm visible
                ' style="',
                    'position:fixed;',
                    'left:0;',
                    'top:0;',
                    'right:0;',
                    'bottom:0;',
                    'background: rgba(0,0,0,0.5);',
                    'z-index:9;',
                '"',
                '>');
        joRes.Add(sCode);

        //窗体
        sCode   := Concat('<div id='+sFull+'"__cff"',   //cff:confirm form
                ' style="',
                    'position:absolute;',
                    'left:25px;',
                    'bottom:50px;',
                    'right:25px;',
                    'height:130px;',
                    'border-radius:15px;',
                    'background-color:#fff;',
                    'opacity: 1;',
                '"',
                '>');
        joRes.Add(sCode);

        //标题
        sCode   := Concat('<div id='+sFull+'"__cft"',   //confirm title
                ' style="',
                    'position:absolute;',
                    'top:0px;',
                    'width:100%;',
                    'height:80px;',
                    'line-height:80px;',
                    'text-align:center;',
                    'border-bottom:solid 1px #ccc;',
                '"',
                '>',
                '确认删除？',
                '</div>');
        joRes.Add(sCode);

        //取消按钮
        sCode   := Concat('<div id='+sFull+'"__cfc"',   //confirm cancel
                ' style="',
                    'position:absolute;',
                    'left:0px;',
                    'bottom:0px;',
                    'width:50%;',
                    'height:50px;',
                    'line-height:50px;',
                    'text-align:center;',
                    'border-right:solid 1px #ccc;',
                '"',
                ' @click="function(event){',
                    ''+sFull+'__cfv=false;',
                '}" ',
                '>',
                '取消',
                '</div>');
        joRes.Add(sCode);

        //确认删除按钮
        sCode   := Concat('<div id='+sFull+'"__cfd"',   //confirm delete
                ' style="',
                    'position:absolute;',
                    'right:0;',
                    'bottom:0px;',
                    'width:50%;',
                    'height:50px;',
                    'line-height:50px;',
                    'text-align:center;',
                    'color:red;',
                '"',
                ' @click="function(event){',
                    'dwevent(event,'''+sFull+''',''this.'+sFull+'__rcn'',''ondeleteclick'','''+IntToStr(TForm(Owner).Handle)+''');',
                    ''+sFull+'__cfv=false;',
                '}" ',
                '>',
                '删除',
                '</div>');
        joRes.Add(sCode);

        joRes.Add('</div>');    //cff:confirm form


        joRes.Add('</div>');    //cfm:confirm mask
        //> ==== 删除确认框结束

        //<添加编辑/新增窗体========================================================================
        //遮罩层
        sCode   := Concat('<div id='+sFull+'"__edm"',   //cfm:edit/append mask
                ' v-show="'+sFull+'__edv"',         //edit/append visible
                ' style="',
                    'position:fixed;',
                    'left:0;',
                    'top:0;',
                    'right:0;',
                    'bottom:0;',
                    'background: rgba(0,0,0,0.5);',
                    'font-size:17px;',
                    'z-index:9;',
                '"',
                '>');
        joRes.Add(sCode);

        //窗体
        sCode   := Concat('<div id='+sFull+'"__edf"',   //edit/append form
                ' style="',
                    'position:absolute;',
                    'left:25px;',
                    'top:25px;',
                    'right:25px;',
                    'bottom:25px;',
                    'border-radius:15px;',
                    'background-color:#fff;',
                    'opacity: 1;',
                '"',
                '>');
        joRes.Add(sCode);

        //标题
        sCode   := Concat('<div id='+sFull+'"__edt"',   //edit/append title
                ' style="',
                    'position:absolute;',
                    'top:0px;',
                    'width:100%;',
                    'height:50px;',
                    'line-height:50px;',
                    'text-align:center;',
                    'border-bottom:solid 1px #ccc;',
                '"',
                '>',
                'Data',
                '</div>');
        joRes.Add(sCode);

        //滚动框
        sCode   := concat('<el-scrollbar',
                ' ref="'+sFull+'__dts"',    //data scroll
                //动态值
                //' :style="{',
                //    'height:'+sFull+'__dsh',       //data scroll height
                //'}"',
                ' style="',
                    'position:absolute;',
                    'top:50px;',
                    'width:100%;',
                    'bottom:50px;',
                    //'height:'+IntToStr(TForm(Owner).Height-150)+'px;',
                '"',
                '>');
        joRes.Add(sCode);

        //内框（用于放置数据编辑框)
        sCode   := '<el-main'
                +' id="'+sFull+'__dtc"'     //data content
                //动态值
                +' :style="{'
                    +'height:'+sFull+'__dch'       //data content height
                +'}"'
                //静态值
                +' style="'
                    +'position:relative;'
                    +'color:'+dwColor(Font.Color)+';'
                    +'left:0;'
                    +'top:0;'
                    +'width:100%;'
                    +'overflow:hidden;'
                +'"'
                +'>';
        joRes.Add(sCode);

        //此处生成多个字段的编辑框
        //
        iTop    := 25;
        for iColumn := 0 to Columns.Count-1 do begin
            oColumn     := Columns[iColumn];
            joColumn    := joColumns._(iColumn);

            //
            if joColumn.type = 'autoinc' then begin
                continue;
            end;
            if joColumn.type = 'button' then begin
                continue;
            end;


            //字段caption
            sCode   := Concat('<div',
                    ' style="',
                        'position:absolute;',
                        'top:'+IntToStr(iTop)+'px;',
                        'left:25px;',
                        'right:25px;',
                        'height:20px;',
                        'line-height:20px;',
                        'background:transparent;',
                        'padding-left:5px;',
                    '"',
                    '>',
                    joColumn.caption,
                    '</div>');
            joRes.Add(sCode);

            //字段编辑框
            if joColumn.type = 'boolean' then begin //==============================================
                //外框（无边框，仅用于界定范围）
                sCode   := Concat('<div',
                        ' id="'+sFull+'__de'+IntToStr(iColumn)+'"',         //data edit
                        //' v-model="'+sFull+'__di'+IntToStr(iColumn)+'"',     //data input
                        //动态值
                        ' :style="{',
                            'width:'+sFull+'__edw',       //edit width
                        '}"',
                        //
                        ' style="',
                            'position:absolute;',
                            //'border: 1px solid #ccc;',
                            'top:'+IntToStr(iTop+20+3)+'px;',
                            'left:25px;',
                            //'right:25px;',
                            'height:27px;',
                            //'line-height:32px;',
                            //'border-radius:4px;',
                            //'outline-style: none;',
                            //'border: 1px solid #ccc;',
                            //'color:#808080;',
                            'padding:0 0 0 5px;',
                            'margin-top:5px;',
                        '"',
                        '>');
                joRes.Add(sCode);

                //添加选项
                sCode   := concat('<el-radio',
                        ' label="True">',
                        joColumn.list._(0),
                        '</el-radio>');
                joRes.Add(sCode);

                sCode   := concat('<el-radio',
                        ' v-model="'+sFull+'__di'+IntToStr(iColumn)+'"',     //data input
                        ' label="False">',
                        joColumn.list._(1),
                        '</el-radio>');
                joRes.Add(sCode);

                //尾部封闭
                joRes.Add('</div>');
            end else if joColumn.type = 'combo' then begin  //======================================
                //外框
                sCode   := Concat('<div',
                        //动态值
                        ' :style="{',
                            'width:'+sFull+'__edw',       //edit width
                        '}"',
                        ' style="',
                            'position:absolute;',
                            'top:'+IntToStr(iTop+20+3)+'px;',
                            'left:25px;',
                            //'right:25px;',
                            'height:34px;',
                            //'line-height:32px;',
                            //'border-radius:4px;',
                            //'outline-style: none;',
                            //'border: 1px solid #ccc;',
                            //'color:#808080;',
                            'padding:0 0 0 5px;',
                        '"',
                        '>');
                joRes.Add(sCode);

                //添加select
                sCode   := concat('<select',
                        ' id="'+sFull+'__de'+IntToStr(iColumn)+'"',         //data element
                        ' v-model="'+sFull+'__di'+IntToStr(iColumn)+'"',     //data input
                        ' style="',
                            'appearance:none;',
                            '-moz-appearance:none;',
                            '-webkit-appearance:none;',
                            'background:url(''media/images/dwarrow.png'') no-repeat scroll right center transparent;',
                            'padding:0 14px 0 5px;',
                            'position:absolute;',
                            'top:0px;',
                            'left:0px;',
                            'height:100%;',
                            'width:100%;',
                            'outline:none;',
                            'border:solid 1px #ccc;',
                            'border-radius:3px;',
                        '"',
                        ' @change="'+sFull+'__change'+IntToStr(iColumn)+'($event)"',
                        '>');
                joRes.Add(sCode);

                //添加可选项
                for iList := 0 to joColumn.list._count-1 do begin
                    sCode   := '<option value="'+joColumn.list._(iList)+'">'+joColumn.list._(iList)+'</option>';
                    joRes.Add(sCode);
                end;
                joRes.Add('</select>');

                //添加input
                sCode   := concat('<input',
                        ' id="'+sFull+'__dei'+IntToStr(iColumn)+'"',         //data element input
                        ' v-model="'+sFull+'__di'+IntToStr(iColumn)+'"',     //data input
                        //' type="text"',
                        //' name="format"',
                        //' value=""',
                        ' style="',
                            'position:absolute;',
                            'top:1px;',
                            'color:inherit;',
                            'left:4px;',
                            'right:20px;',
                            'bottom:1px;',
                            'border:0;',
                            'outline:none;',
                        '"',
                        ' />');
                joRes.Add(sCode);

                //尾部封闭
                joRes.Add('</div>');
            end else if joColumn.type = 'date' then begin  //======================================
                //外框
                sCode   := Concat('<el-date-picker',
                        ' id="'+sFull+'__de'+IntToStr(iColumn)+'"',         //data element
                        ' v-model="'+sFull+'__di'+IntToStr(iColumn)+'"',     //data input
                        ' value-format="yyyy-MM-dd"',
                        ' type="date"',
                        //动态值
                        ' :style="{',
                            'width:'+sFull+'__edw',       //edit width
                        '}"',
                        ' style="',
                            'position:absolute;',
                            'top:'+IntToStr(iTop+20+3)+'px;',
                            'left:25px;',
                            'height:32px;',
                            'border:solid 1px #ccc;',
                            'border-radius:3px;',
                            //'line-height:32px;',
                            //'border-radius:4px;',
                            //'outline-style: none;',
                            //'border: 1px solid #ccc;',
                            //'color:#808080;',
                            'padding:0 0 0 5px;',
                        '"',
                        '>');
                joRes.Add(sCode);


                //尾部封闭
                joRes.Add('</el-date-picker>');
            end else if joColumn.type = 'integer' then begin  //====================================
                //
                sMin    := '';
                if joColumn.Exists('min') then begin
                    sMin    := ' :min = "'+IntToStr(joColumn.min)+'"';
                end;
                sMax    := '';
                if joColumn.Exists('max') then begin
                    sMax    := ' :max = "'+IntToStr(joColumn.max)+'"';
                end;
                //外框
                sCode   := Concat('<el-input-number',
                        ' id="'+sFull+'__de'+IntToStr(iColumn)+'"',         //data element
                        ' v-model="'+sFull+'__di'+IntToStr(iColumn)+'"',     //data input
                        sMin,
                        sMax,
                        ' type="date"',
                        //动态值
                        ' :style="{',
                            'width:'+sFull+'__edw',       //edit width
                        '}"',
                        ' style="',
                            'position:absolute;',
                            'top:'+IntToStr(iTop+20+3)+'px;',
                            'left:25px;',
                            'height:34px;',
                            'border:solid 1px #ccc;',
                            'border-radius:3px;',
                            //'line-height:32px;',
                            //'border-radius:4px;',
                            //'outline-style: none;',
                            //'border: 1px solid #ccc;',
                            //'color:#808080;',
                            'padding:0 0 0 5px;',
                        '"',
                        '>');
                joRes.Add(sCode);


                //尾部封闭
                joRes.Add('</el-input-number>');
            end else if joColumn.type = 'rate' then begin  //=======================================
                //外框
                sCode   := Concat('<el-input-number',
                        ' id="'+sFull+'__de'+IntToStr(iColumn)+'"',         //data element
                        ' v-model="'+sFull+'__di'+IntToStr(iColumn)+'"',     //data input
                        ' type="date"',
                        //动态值
                        ' :style="{',
                            'width:'+sFull+'__edw',       //edit width
                        '}"',
                        ' style="',
                            'position:absolute;',
                            'top:'+IntToStr(iTop+20+3)+'px;',
                            'left:25px;',
                            'height:34px;',
                            'border:solid 1px #ccc;',
                            'border-radius:3px;',
                            //'line-height:32px;',
                            //'border-radius:4px;',
                            //'outline-style: none;',
                            //'border: 1px solid #ccc;',
                            //'color:#808080;',
                            'padding:0 0 0 5px;',
                        '"',
                        '>');
                joRes.Add(sCode);


                //尾部封闭
                joRes.Add('</el-input-number>');
            end else begin  //======================================================================
                sCode   := Concat('<input',
                        ' id="'+sFull+'__de'+IntToStr(iColumn)+'"',         //data element
                        ' v-model="'+sFull+'__di'+IntToStr(iColumn)+'"',     //data input
                        //动态值
                        ' :style="{',
                            'width:'+sFull+'__edw',       //edit width
                        '}"',
                        ' style="',
                            'position:absolute;',
                            'top:'+IntToStr(iTop+20+3)+'px;',
                            'left:25px;',
                            'right:25px;',
                            'height:32px;',
                            'line-height:32px;',
                            'border-radius:4px;',
                            'outline-style: none;',
                            'border: 1px solid #ccc;',
                            'color:#808080;',
                            'padding:0px 0px 0px 5px;',
                        '"',
                        '>',
                        '</input>');
                joRes.Add(sCode);
            end;
            //
            iTop    := iTop + 70;
        end;

        //
        joRes.Add('</el-main>');
        joRes.Add('</el-scrollbar>');

        //编辑窗体的“取消”按钮
        sCode   := Concat('<div id='+sFull+'"__edc"',   //edit/append cancel
                ' style="',
                    'position:absolute;',
                    'left:0px;',
                    'bottom:0px;',
                    'width:50%;',
                    'height:50px;',
                    'line-height:50px;',
                    'text-align:center;',
                    'border-right:solid 1px #ccc;',
                    'border-top:solid 1px #ccc;',
                '"',
                ' @click="'+sFull+'__editcancel($event,'+sFull+'__rcn)"',
                '>',
                '取消',
                '</div>');
        joRes.Add(sCode);

        //编辑窗体的“保存“按钮
        sCode   := Concat('<div id='+sFull+'"__eds"',   //edit/append save
                ' style="',
                    'position:absolute;',
                    'right:0;',
                    'bottom:0px;',
                    'width:50%;',
                    'height:50px;',
                    'line-height:50px;',
                    'text-align:center;',
                    'border-top:solid 1px #ccc;',
                    'color:red;',
                '"',
                ' @click="'+sFull+'__editsave($event,'+sFull+'__rcn)"',
                //' @click="function(event){',
                //    _GetCurValues,
                //    'dwevent(event,'''+sFull+''',''scur'',''onsaveclick'','''+IntToStr(TForm(Owner).Handle)+''');',
                //    ''+sFull+'__edv=false;',
                //'}" ',
                '>',
                '保存',
                '</div>');
        joRes.Add(sCode);

        joRes.Add('</div>');    //edit/append form


        joRes.Add('</div>');    //edit/append mask
        //> ==== 编辑框结束
    end;




    //DBGrid的总外框尾部封闭
    joRes.Add('</div>');    //总外框

    //
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
     //
     Result    := (joRes);
end;


//取得Data和Action的通用函数(因为这两个函数拥有太多的重复代码，维护不方便)
function _dwGeneral(ACtrl:TComponent;AMode:String):Variant;
var
    joRes           : Variant;
    joColumns       : Variant;      //各列显示设置的JSON对象
    joColumn        : Variant;      //单列显示设置的JSON对象
    joCaption       : Variant;      //Column的Title.caption中的JSON对象
    //
    //
    iRecord         : Integer;
    iColumn         : Integer;
    iRecordHeight   : Integer;      //单个记录的显示高度
    iRecordFullH    : Integer;      //单个记录的显示高度(包含下面边距)
    iRecordCount    : Integer;      //记录数量
    idch            : Integer;      //data content height
    iOldRecNo       : Integer;      //
    //
    sFull           : string;
    sCode           : string;
    sValue          : string;
    sFormat         : string;
    //
    sMiddle         : string;       //中间符号，为：或=
    sTail           : string;       //属部符号，为，或；
    sTmp            : String;
    //

    //
    rDics           : TDics;
begin
    //生成返回值数组
    joRes    := _Json('[]');

    //
    if LowerCase(AMode) = 'data' then begin
        sFull   := dwFullName(Actrl);
        sMiddle := ':';
        sTail   := ',';
    end else begin
        sFull   := 'this.'+dwFullName(Actrl);
        sMiddle := '=';
        sTail   := ';';
    end;

    //
    with TListView(ACtrl) do begin

        //基本LTWH
        joRes.Add(sFull+'__lef'+sMiddle+'"'+IntToStr(Left)+'px"'+sTail);
        joRes.Add(sFull+'__top'+sMiddle+'"'+IntToStr(Top)+'px"'+sTail);
        joRes.Add(sFull+'__wid'+sMiddle+'"'+IntToStr(Width)+'px"'+sTail);
        joRes.Add(sFull+'__hei'+sMiddle+'"'+IntToStr(Height)+'px"'+sTail);

        //可见性和禁用
        joRes.Add(sFull+'__vis'+sMiddle+''+dwIIF(Visible,'true'+sTail,'false'+sTail));
        joRes.Add(sFull+'__dis'+sMiddle+''+dwIIF(Enabled,'false'+sTail,'true'+sTail));

        //字体
        joRes.Add(sFull+'__fcl'+sMiddle+'"'+dwColor(Font.Color)+'"'+sTail);
        joRes.Add(sFull+'__fsz'+sMiddle+'"'+IntToStr(Font.size+3)+'px"'+sTail);
        joRes.Add(sFull+'__ffm'+sMiddle+'"'+Font.Name+'"'+sTail);
        joRes.Add(sFull+'__fwg'+sMiddle+'"'+_GetFontWeight(Font)+'"'+sTail);
        joRes.Add(sFull+'__fsl'+sMiddle+'"'+_GetFontStyle(Font)+'"'+sTail);
        joRes.Add(sFull+'__ftd'+sMiddle+'"'+_GetTextDecoration(Font)+'"'+sTail);
        //joRes.Add(sFull+'__fta'+sMiddle+'"'+_GetTextAlignment(TLabel(ACtrl))+'"'+sTail);

        //删除确认框默认不可见
        joRes.Add(sFull+'__cfv'+sMiddle+'false'+sTail);  //cfv:conform visible
        joRes.Add(sFull+'__edv'+sMiddle+'false'+sTail);  //edv:edit visible
        joRes.Add(sFull+'__eds'+sMiddle+'""'+sTail);     //eds:edit state ， 用于区分edit/append

        //保存oldscrolltop以确定滚动方向
        joRes.Add(sFull+'__ost'+sMiddle+'0'+sTail);

        //单条记录的显示高度(不包含上下边距,由HelpContext设置)
        iRecordHeight   := StrToInt(dwIIF(HelpContext=0,'140',IntToStr(HelpContext)));

        //单条记录总高为+10
        iRecordFullH    := iRecordHeight + 10;

        //编辑框宽度edw
        joRes.Add(sFull+'__edw'+sMiddle+'"'+IntToStr(Width-105)+'px"'+sTail);

        //数据库总记录条数
        iRecordCount    := Items.Count;

        //cth: content height. 数据区总高度
        joRes.Add(sFull+'__cth'+sMiddle+'"'+IntToStr(20+iRecordFullH*iRecordCount)+'px"'+sTail);

        //取得字段集合
        joColumns   := _GetColumns(ACtrl);

        //编辑时scrollbar的高度
        //joRes.Add(sFull+'__dsh'+sMiddle+'"'+IntToStr(TForm(Owner).Height-150)+'px"'+sTail);
        //编辑时编辑区的高度
        idch    := 25;
        for iColumn := 0 to Columns.Count-1 do begin
            joColumn    := joColumns._(iColumn);

            //
            if joColumn.fieldname = '' then begin
                continue;
            end;

            //
            idch    := idch + 70;
        end;
        joRes.Add(sFull+'__dch'+sMiddle+'"'+IntToStr(idch)+'px"'+sTail); //data content height

        //保存记录号  record no
        if Items.Count>0 then begin

            if Selected = nil then begin
                Items[0].Selected   := True;
            end;
            joRes.Add(sFull+'__rcn'+sMiddle+IntToStr(Selected.Index)+sTail);


            //数据值 di
            for iColumn := 0 to joColumns._Count-1 do begin
                joColumn    := joColumns._(iColumn);

                //
                sTmp    := '';
                if iColumn = 0 then begin
                    sTmp    := Selected.Caption;
                end else begin
                    if iColumn-1<Selected.SubItems.Count then begin
                        sTmp    := Selected.SubItems[iColumn-1];
                    end;
                end;
                if joColumn.type = 'integer' then begin
                    sTmp    := sFull+'__di'+IntToStr(iColumn)+sMiddle+''+IntToStr(StrToIntDef(sTmp,0))+''+sTail;
                end else begin
                    sTmp    := sFull+'__di'+IntToStr(iColumn)+sMiddle+'"'+sTmp+'"'+sTail;
                end;

                joRes.Add(sTmp);
            end;

            //生成__rds： records
            sCode   := sFull+'__rds'+sMiddle+'[';
            for iRecord := 0 to Items.Count-1 do begin

                //记录块的ltwh
                sCode   := sCode+'{';
                sCode   := sCode+'l:"10px",';
                sCode   := sCode+'t:"'+IntToStr(10+iRecord*iRecordFullH)+'px",';
                sCode   := sCode+'w:"'+IntToStr(TListView(ACtrl).Width-20)+'px",';
                sCode   := sCode+'h:"'+IntToStr(iRecordHeight)+'px",';

                //显示选中标志
                if iRecord = ItemIndex then begin
                    sCode   := sCode+'b:"solid 1px #6A5ACD",';
                end else begin
                    sCode   := sCode+'b:"solid 1px #ccc",';
                end;

                //
                for iColumn := 0 to Columns.Count-1 do begin
                    //取得当前字段JSON对象
                    joColumn    := joColumns._(iColumn);

                    //ltwh和rb数据
                    if joColumn.Exists('left') then begin
                        sCode   := sCode+'dl'+IntToStr(iColumn)+':"'+IntToStr(joColumn.left)+'px",';
                    end;
                    if joColumn.Exists('width') then begin
                        sCode   := sCode+'dw'+IntToStr(iColumn)+':"'+IntToStr(joColumn.width)+'px",';
                    end;
                    if joColumn.Exists('right') then begin
                        sCode   := sCode+'dr'+IntToStr(iColumn)+':"'+IntToStr(joColumn.right)+'px",';
                    end;
                    if joColumn.Exists('top') then begin
                        sCode   := sCode+'dt'+IntToStr(iColumn)+':"'+IntToStr(joColumn.top)+'px",';
                    end;
                    if joColumn.Exists('height') then begin
                        sCode   := sCode+'dh'+IntToStr(iColumn)+':"'+IntToStr(joColumn.height)+'px",';
                    end;
                    if joColumn.Exists('bottom') then begin
                        sCode   := sCode+'db'+IntToStr(iColumn)+':"'+IntToStr(joColumn.bottom)+'px",';
                    end;
                    //字体
                    sCode   := sCode+'dfn'+IntToStr(iColumn)+':"'+joColumn.fontname+'",';
                    sCode   := sCode+'dfs'+IntToStr(iColumn)+':"'+IntToStr(joColumn.fontsize)+'px",';
                    sCode   := sCode+'dfc'+IntToStr(iColumn)+':"'+joColumn.fontcolor+'",';
                    sCode   := sCode+'dfwg'+IntToStr(iColumn)+':"'+joColumn.fontbold+'",';
                    sCode   := sCode+'dfsl'+IntToStr(iColumn)+':"'+joColumn.fontitalic+'",';
                    sCode   := sCode+'dftd'+IntToStr(iColumn)+':"'+joColumn.fontdecoration+'",';
                    //data
                    sValue  := '';
                    if iColumn = 0 then begin
                        sValue  := Items[iRecord].Caption;
                    end else begin
                        if iColumn-1<Items[iRecord].SubItems.Count then begin
                            sValue  := Items[iRecord].SubItems[iColumn-1];
                        end;
                    end;
                    if joColumn.type = 'boolean' then begin
                        if joColumn.Exists('list') then begin
                            sValue  := LowerCase(trim(sValue));
                            if (sValue='true') or (sValue='t') or (sValue='1') or (sValue='y') then begin
                                sCode   := sCode+'d'+IntToStr(iColumn)+':"'+joColumn.list._(0)+'",';
                            end else begin
                                sCode   := sCode+'d'+IntToStr(iColumn)+':"'+joColumn.list._(1)+'",';
                            end;
                        end else begin
                            sCode   := sCode+'d'+IntToStr(iColumn)+':"'+sValue+'",';
                        end;
                    end else if joColumn.type = 'image' then begin
                        if joColumn.Exists('format') then begin
                            sCode   := sCode+'src'+IntToStr(iColumn)+':"'+Format(joColumn.format,[sValue])+'",';
                        end else begin
                            sCode   := sCode+'src'+IntToStr(iColumn)+':"'+sValue+'",';
                        end;
                    end else if joColumn.type = 'integer' then begin
                        if joColumn.Exists('format') then begin
                            sFormat := joColumn.format;
                            if Pos('%n',sFormat)>0 then begin
                                sCode   := sCode+'d'+IntToStr(iColumn)+':"'+Format(sFormat,[StrToFloatDef(sValue,0.0)])+'",';
                            end else if Pos('%s',sFormat)>0 then begin
                                sCode   := sCode+'d'+IntToStr(iColumn)+':"'+Format(sFormat,[sValue])+'",';
                            end else if Pos('%d',sFormat)>0 then begin
                                sCode   := sCode+'d'+IntToStr(iColumn)+':"'+Format(sFormat,[StrToIntDef(sValue,0)])+'",';
                            end;
                        end else begin
                            sCode   := sCode+'d'+IntToStr(iColumn)+':"'+sValue+'",';
                        end;
                    end else if joColumn.type = 'button' then begin
                        sCode   := sCode+'d'+IntToStr(iColumn)+':"'+joColumn.caption+'",';
                    end else if joColumn.type = 'rate' then begin
                        sCode   := sCode+'d'+IntToStr(iColumn)+':'+FloatToStr(Max(0,Min(5,joColumn.scale*StrToFloatDef(sValue,0))))+',';
                    end else if joColumn.type = 'link' then begin
                        if rDics[iColumn].TryGetValue(sValue,sValue) then begin
                            sCode   := sCode+'d'+IntToStr(iColumn)+':"'+sValue+'",';
                        end else begin
                            sCode   := sCode+'d'+IntToStr(iColumn)+':"",';
                        end;
                    end else begin
                        if joColumn.Exists('format') then begin
                            sFormat := joColumn.format;
                            if Pos('%n',sFormat)>0 then begin
                                sValue  := Format(sFormat,[StrToFloatDef(sValue,0.0)]);
                            end else if Pos('%s',sFormat)>0 then begin
                                sValue  := Format(sFormat,[sValue]);
                            end else if Pos('%d',sFormat)>0 then begin
                                sValue  := Format(sFormat,[StrToIntDef(sValue,0)]);
                            end else begin
                                sValue  := Format(sFormat,[sValue]);
                            end;

                        end;
                        sCode   := sCode+'d'+IntToStr(iColumn)+':"'+sValue+'",';
                    end;
                end;
                //
                sCode   := sCode+'r:"10px"';
                sCode   := sCode+'}'+dwIIF(iRecord<Items.Count-1,',','');
            end;
            sCode   := sCode+']'+sTail;
            joRes.Add(sCode);

        end else begin  //没有数据的情况========================================

            //记录数为0
            joRes.Add(sFull+'__rcn'+sMiddle+'0'+sTail);

            //数据值 di
            for iColumn := 0 to joColumns._Count-1 do begin
                joColumn    := joColumns._(iColumn);

                //
                if joColumn.type = 'integer' then begin
                    if joColumn.Exists('default') then begin
                        sTmp    := sFull+'__di'+IntToStr(iColumn)+sMiddle+IntToStr(joColumn.default)+sTail;
                    end else if joColumn.Exists('min') then begin
                        sTmp    := sFull+'__di'+IntToStr(iColumn)+sMiddle+IntToStr(joColumn.min)+sTail;
                    end else begin
                        sTmp    := sFull+'__di'+IntToStr(iColumn)+sMiddle+'0'+sTail;
                    end;
                end else begin
                    sTmp    := sFull+'__di'+IntToStr(iColumn)+sMiddle+'""'+sTail;
                end;

                joRes.Add(sTmp);
            end;

            //生成__rds： records
            sCode   := sFull+'__rds'+sMiddle+'[';
            for iRecord := 0 to Items.Count-1 do begin

                //记录块的ltwh
                sCode   := sCode+'{';
                sCode   := sCode+'l:"10px",';
                sCode   := sCode+'t:"'+IntToStr(10+iRecord*iRecordFullH)+'px",';
                sCode   := sCode+'w:"'+IntToStr(TListView(ACtrl).Width-20)+'px",';
                sCode   := sCode+'h:"'+IntToStr(iRecordHeight)+'px",';

                //
                for iColumn := 0 to Columns.Count-1 do begin
                    //取得当前字段JSON对象
                    joColumn    := joColumns._(iColumn);

                    //ltwh和rb数据
                    if joColumn.Exists('left') then begin
                        sCode   := sCode+'dl'+IntToStr(iColumn)+':"'+IntToStr(joColumn.left)+'px",';
                    end;
                    if joColumn.Exists('width') then begin
                        sCode   := sCode+'dw'+IntToStr(iColumn)+':"'+IntToStr(joColumn.width)+'px",';
                    end;
                    if joColumn.Exists('right') then begin
                        sCode   := sCode+'dr'+IntToStr(iColumn)+':"'+IntToStr(joColumn.right)+'px",';
                    end;
                    if joColumn.Exists('top') then begin
                        sCode   := sCode+'dt'+IntToStr(iColumn)+':"'+IntToStr(joColumn.top)+'px",';
                    end;
                    if joColumn.Exists('height') then begin
                        sCode   := sCode+'dh'+IntToStr(iColumn)+':"'+IntToStr(joColumn.height)+'px",';
                    end;
                    if joColumn.Exists('bottom') then begin
                        sCode   := sCode+'db'+IntToStr(iColumn)+':"'+IntToStr(joColumn.bottom)+'px",';
                    end;
                    //字体
                    sCode   := sCode+'dfn'+IntToStr(iColumn)+':"'+joColumn.fontname+'",';
                    sCode   := sCode+'dfs'+IntToStr(iColumn)+':"'+IntToStr(joColumn.fontsize)+'px",';
                    sCode   := sCode+'dfc'+IntToStr(iColumn)+':"'+joColumn.fontcolor+'",';
                    sCode   := sCode+'dfwg'+IntToStr(iColumn)+':"'+joColumn.fontbold+'",';
                    sCode   := sCode+'dfsl'+IntToStr(iColumn)+':"'+joColumn.fontitalic+'",';
                    sCode   := sCode+'dftd'+IntToStr(iColumn)+':"'+joColumn.fontdecoration+'",';
                    //data
                    sValue  := '';
                    if iColumn = 0 then begin
                        sValue  := Items[iRecord].Caption;
                    end else begin
                        if iColumn-1<Items[iRecord].SubItems.Count then begin
                            sValue  := Items[iRecord].SubItems[iColumn-1];
                        end;
                    end;
                    if joColumn.type = 'boolean' then begin
                        sCode   := sCode+'d'+IntToStr(iColumn)+':"'+sValue+'",';
                    end else if joColumn.type = 'image' then begin
                        sCode   := sCode+'src'+IntToStr(iColumn)+':"'+sValue+'",';
                    end else if joColumn.type = 'integer' then begin
                        sCode   := sCode+'d'+IntToStr(iColumn)+':"'+sValue+'",';
                    end else if joColumn.type = 'button' then begin
                        sCode   := sCode+'d'+IntToStr(iColumn)+':"'+joColumn.caption+'",';
                    end else if joColumn.type = 'rate' then begin
                        sCode   := sCode+'d'+IntToStr(iColumn)+':'+FloatToStr(Max(0,Min(5,joColumn.scale*StrToFloatDef(sValue,0))))+',';
                    end else begin
                        sCode   := sCode+'d'+IntToStr(iColumn)+':"'+sValue+'",';
                    end;
                end;
                //
                sCode   := sCode+'r:"10px"';
                sCode   := sCode+'}'+dwIIF(iRecord<Items.Count-1,',','');
            end;
            sCode   := sCode+']'+sTail;
            joRes.Add(sCode);

        end;
    end;
    //
    Result    := (joRes);
end;

function dwGetData(ACtrl:TComponent):String;StdCall;
var
    sFull   : string;
    joRes   : Variant;
begin
    sFull   := dwFullName(ACtrl);
    //
    joRes   := _dwGeneral(ACtrl,'data');

    //默认搜索关键字
    joRes.Add(sFull+'__key:"",');

    //默认页码
    joRes.Add(sFull+'__cpg:1,');

    //
    Result  := joRes;
end;


//取得交互事件
function dwGetAction(ACtrl:TComponent):String;StdCall;
begin
    Result  := _dwGeneral(ACtrl,'action');
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


    with TListView(ACtrl) do begin

        //取得字段集合
        joColumns   := _GetColumns(ACtrl);

        //
        for iColumn := 0 to joColumns._Count-1 do begin
            joColumn    := joColumns._(iColumn);
            //
            if joColumn.type = 'combo' then begin
                //实现多控件同步的变量
                sSet    := '';
                if joColumn.Exists('set') then begin    //set应为[2,3], 为combo控件的id序号
                    for iSet := 0 to joColumn.set._Count-1 do begin
                        sSetValue   := IntToStr(joColumn.set._(iSet));
                        sSet    := concat(sSet,
                                'var ocur = event.target;',
                                'var osel = document.getElementById("'+sFull+'__de'+sSetValue+'");',
                                'var oinp = document.getElementById("'+sFull+'__dei'+sSetValue+'");',
                                'osel.selectedIndex = ocur.selectedIndex;',
                                //'console.log(osel.value);',
                                'this.'+sFull+'__di'+sSetValue+' = osel.value;'
                        );
                        //更新对应input的值
                        //sSet    := sSet + 'this.'+sFull+'__di'+sSetValue+'=event.target.value;';
                    end;
                end;

                //change事件
                sCode   := concat(sFull+'__change'+IntToStr(iColumn)+'(e) ',
                        '{',
                            //更新对应input的值
                            'this.'+sFull+'__di'+IntToStr(iColumn)+'=event.target.value;',
                            sSet,
                            'e.stopPropagation();',//阻止冒泡
                        '},');
                joRes.Add(sCode);
            end;
        end;

        //编辑后save事件
        sCode   := concat(
                sFull+'__editsave(e,recordno) ',
                '{',
                    //更新所有记录的CheckBox
                    'var fds = [];',
                    'fds.push(recordno);',
                    'for (var i=0;i<'+IntToStr(joColumns._Count)+';i++) {',
                        'var v = ''this.'+sFull+'__di'' + i;',
                        'if (eval(v)==null){',
                            'fds.push("");',
                        '}else{',
                            'fds.push(eval(v));',
                        '};',
                    '};',
                    //+'console.log(fds);'
                    'var stmp = "''"+JSON.stringify(fds).toString()+"''";',
                    //+'console.log(stmp);'
                    'this.dwevent("","'+dwFullName(Actrl)+'",stmp,"onsave",'+IntToStr(TForm(Owner).Handle)+');',
                    'this.'+sFull+'__edv=false;',
                    //隐藏数据编辑框
                    //+'this.'+dwFullName(Actrl)+'__sed=false;'
                    'e.stopPropagation();',//阻止冒泡
                '},');
        joRes.Add(sCode);

        //编辑/append后cancel事件
        sCode   := concat(
                sFull+'__editcancel(e,recordno) {',
                    //如果是append状态，则删除当前记录
                    'if (this.'+sFull+'__eds == "append") {',
                        'this.dwevent(e,'''+sFull+''',''this.'+sFull+'__rcn'',''ondeleteclick'','''+IntToStr(TForm(Owner).Handle)+''');',
                    '};',
                    //隐藏数据编辑框
                    'this.'+sFull+'__edv=false;',
                    //置当前状态
                    'this.'+sFull+'__eds="";',
                    'e.stopPropagation();',//阻止冒泡
                '},');
        joRes.Add(sCode);

        //编辑/append后cancel事件
        sCode   := concat(
                sFull+'__append(e) {',
                    //隐藏数据编辑框
                    'this.'+sFull+'__edv=true;',
                    //置当前状态
                    'this.'+sFull+'__eds="append";',
                    'this.dwevent(e,'''+sFull+''',''this.'+sFull+'__rcn'',''onappend'','''+IntToStr(TForm(Owner).Handle)+''');',
                    'e.stopPropagation();',//阻止冒泡
                '},');
        joRes.Add(sCode);

        //搜索关键字input的键入事件
        sCode   := concat(
                sFull+'__query(e,skeyword) {',
                    'this.dwevent(e,'''+sFull+''',''this.'+sFull+'__key'',''onquery'','''+IntToStr(TForm(Owner).Handle)+''');',
                    //'e.stopPropagation();',//阻止冒泡
                '},');
        joRes.Add(sCode);

        //分页按钮
        sCode   := concat(
                sFull+'__first(e) {',
                    'this.dwevent(e,'''+sFull+''',''this.'+sFull+'__cpg'',''onquery'','''+IntToStr(TForm(Owner).Handle)+''');',
                    //'e.stopPropagation();',//阻止冒泡
                '},');
        joRes.Add(sCode);

        sCode   := concat(
                sFull+'__prev(e) {',
                    'this.dwevent(e,'''+sFull+''',''this.'+sFull+'__cpg'',''onquery'','''+IntToStr(TForm(Owner).Handle)+''');',
                    //'e.stopPropagation();',//阻止冒泡
                '},');
        joRes.Add(sCode);

        sCode   := concat(
                sFull+'__next(e) {',
                    'this.dwevent(e,'''+sFull+''',''this.'+sFull+'__cpg'',''onquery'','''+IntToStr(TForm(Owner).Handle)+''');',
                    //'e.stopPropagation();',//阻止冒泡
                '},');
        joRes.Add(sCode);

        sCode   := concat(
                sFull+'__last(e) {',
                    'this.dwevent(e,'''+sFull+''',''this.'+sFull+'__cpg'',''onquery'','''+IntToStr(TForm(Owner).Handle)+''');',
                    //'e.stopPropagation();',//阻止冒泡
                '},');
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
     //dwGetMounted,
     dwGetMethods,
     dwGetData;

begin
end.

