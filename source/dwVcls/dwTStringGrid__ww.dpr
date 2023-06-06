library dwTStringGrid__ww;
uses
    System.ShareMem,      //必须添加
    dwCtrlBase,           //一些基础函数
    SynCommons,           //mormot用于解析JSON的单元
    //untLog,             //日志
    Math,Grids,
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
function  dwButtonFontStyle(ACtrl:TControl):String;
begin
    with ACtrl do begin
        Result    := //'color:'+dwFullName(Actrl)+'__fcl,'+         //颜色
            '''font-size'':'+dwFullName(Actrl)+'__fsz,'         //size
            +'''font-family'':'+dwFullName(Actrl)+'__ffm,'       //字体
            +'''font-weight'':'+dwFullName(Actrl)+'__fwg,'       //bold
            +'''font-style'':'+dwFullName(Actrl)+'__fsl,'        //italic
            +'''text-decoration'':'+dwFullName(Actrl)+'__ftd,'   //下划线或贯穿线，只能选一种
    end;
end;

function _In(AValue:Integer;AArray:Variant):boolean;
var
    I       : Integer;
begin
    Result  := False;
    for I := 0 to AArray._Count-1 do begin
        if AArray._(I) = AValue then begin
            Result  := True;
            break;
        end;
    end;
end;

procedure _CheckHint(var AJson:Variant);
var
    iItem       : Integer;  //
    iBorder     : Integer;
    //
    joBorders   : Variant;
    joBorder    : Variant;
begin
    //
    if AJson = unassigned then begin
        AJson   := _json('{"align":[1,1],"data":""}');
    end;

    //
    if not AJson.Exists('borders') then begin
        AJson.borders   := _json('[]');
    end;

    //用于link类型的href
    if not AJson.Exists('href') then begin
        AJson.href   := '';
    end;

    //
    joBorders   := AJson.borders;
    for iBorder := 0 to joBorders._Count-1 do begin
        //得到单个border设置
        joBorder    := joBorders._(iBorder);

        //
        if not joBorder.Exists('start') then begin
            joBorder.start  := _json('[0,0]');
        end;

        //
        if not joBorder.Exists('dwattr') then begin
            joBorder.dwattr  := '';
        end;

        //
        if not joBorder.Exists('dwstyle') then begin
            joBorder.dwstyle  := '';
        end;

        if not joBorder.Exists('end') then begin
            joBorder.end    := _json(joBorder.start);
        end;


        if not joBorder.Exists('style') then begin
            joBorder.style  := 'border:solid 1px #000;';
        end;
    end;
end;


procedure _CheckCell(var AJson:Variant);
begin
    //
    if AJson = unassigned then begin
        AJson   := _json('{"align":[1,1],"data":""}');
    end;

    //type 默认为label
    if not AJson.Exists('type') then begin
        AJson.type  := 'label';
    end;

    //值 默认为空
    if not AJson.Exists('data') then begin
        AJson.data  := '';
    end;

    //背景色 默认为透明
    if not AJson.Exists('bkcolor') then begin
        AJson.bkcolor  := 'transparent';
    end;

    //默认左对齐,上对齐
    if not AJson.Exists('align') then begin
        AJson.align := _json('[1,1]');
    end;

    //默认dwstyle
    if not AJson.Exists('dwstyle') then begin
        AJson.dwstyle := '';
    end;

    //默认expand
    if not AJson.Exists('expand') then begin
        AJson.expand := _json('[0,0]');
    end;

    //默认dwattr
    if not AJson.Exists('dwattr') then begin
        AJson.dwattr := '';
    end;

    if AJson.type = 'image' then begin                  //==========================================
        //
        if not AJson.Exists('left') then begin
            AJson.left  := '0';
        end;

        //
        if not AJson.Exists('top') then begin
            AJson.top  := '0';
        end;

        //
        if not AJson.Exists('width') then begin
            AJson.widthex  := '100%';
        end else begin
            AJson.widthex  := IntToStr(AJson.width)+'px';
        end;

        //
        if not AJson.Exists('height') then begin
            AJson.heightex  := '100%';
        end else begin
            AJson.heightex  := IntToStr(AJson.height)+'px';
        end;

    end else if  AJson.type = 'group' then begin                  //==========================================

        //
        if not AJson.Exists('items') then begin
            AJson.items  := _json('[]');
        end;
    end;
end;

procedure _CheckItem(var AJson:Variant);
begin
    //
    if AJson = unassigned then begin
        AJson   := _json('{}');
    end;

    //type 默认为label
    if not AJson.Exists('type') then begin
        AJson.type  := 'label';
    end;

    if AJson.type = 'label' then begin
        //
        if not AJson.Exists('left') then begin
            AJson.left  := '0';
        end;

        //
        if not AJson.Exists('top') then begin
            AJson.top  := '0';
        end;

        //
        if not AJson.Exists('width') then begin
            AJson.widthex  := '100%';
        end else begin
            AJson.widthex  := IntToStr(AJson.width)+'px';
        end;

        //
        if not AJson.Exists('height') then begin
            AJson.heightex  := '100%';
        end else begin
            AJson.heightex  := IntToStr(AJson.height)+'px';
        end;


        //背景色 默认为透明
        if not AJson.Exists('bkcolor') then begin
            AJson.bkcolor  := 'transparent';
        end;

        //默认左对齐,上对齐
        if not AJson.Exists('align') then begin
            AJson.align := _json('[1,1]');
        end;

        //默认dwstyle
        if not AJson.Exists('dwstyle') then begin
            AJson.dwstyle := '';
        end;

        //默认dwattr
        if not AJson.Exists('dwattr') then begin
            AJson.dwattr := '';
        end;
    end else if (AJson.type = 'edit')or(AJson.type='memo') then begin

        //默认data
        if not AJson.Exists('data') then begin
            AJson.data := '';
        end;

        //
        if not AJson.Exists('left') then begin
            AJson.left  := '0';
        end;

        //
        if not AJson.Exists('top') then begin
            AJson.top  := '0';
        end;

        //
        if not AJson.Exists('width') then begin
            AJson.widthex  := '100%';
        end else begin
            AJson.widthex  := IntToStr(AJson.width)+'px';
        end;

        //
        if not AJson.Exists('height') then begin
            AJson.heightex  := '100%';
        end else begin
            AJson.heightex  := IntToStr(AJson.height)+'px';
        end;


        //背景色 默认为透明
        if not AJson.Exists('bkcolor') then begin
            AJson.bkcolor  := 'transparent';
        end;

        //默认左对齐,上对齐
        if not AJson.Exists('align') then begin
            AJson.align := _json('[1,1]');
        end;

        //默认dwstyle
        if not AJson.Exists('dwstyle') then begin
            AJson.dwstyle := '';
        end;

        //默认dwattr
        if not AJson.Exists('dwattr') then begin
            AJson.dwattr := '';
        end;
    end else if AJson.type = 'check' then begin
        //默认data
        if not AJson.Exists('data') then begin
            AJson.data := false;
        end;

        //
        if not AJson.Exists('left') then begin
            AJson.left  := '0';
        end;

        //
        if not AJson.Exists('top') then begin
            AJson.top  := '0';
        end;

        //背景色 默认为透明
        if not AJson.Exists('bkcolor') then begin
            AJson.bkcolor  := 'transparent';
        end;

        //默认dwstyle
        if not AJson.Exists('dwstyle') then begin
            AJson.dwstyle := '';
        end;

        //默认dwattr
        if not AJson.Exists('dwattr') then begin
            AJson.dwattr := '';
        end;
    end else if AJson.type = 'image' then begin         //==========================================
        //
        if not AJson.Exists('left') then begin
            AJson.left  := '0';
        end;

        //
        if not AJson.Exists('top') then begin
            AJson.top  := '0';
        end;

        //
        if not AJson.Exists('width') then begin
            AJson.widthex  := '100%';
        end else begin
            AJson.widthex  := IntToStr(AJson.width)+'px';
        end;

        //
        if not AJson.Exists('height') then begin
            AJson.heightex  := '100%';
        end else begin
            AJson.heightex  := IntToStr(AJson.height)+'px';
        end;


        //
        if not AJson.Exists('data') then begin
            AJson.data  := '';
        end;

        //默认dwstyle
        if not AJson.Exists('dwstyle') then begin
            AJson.dwstyle := '';
        end;

        //默认dwattr
        if not AJson.Exists('dwattr') then begin
            AJson.dwattr := '';
        end;
    end else if AJson.type = 'combo' then begin         //==========================================
        //
        if not AJson.Exists('left') then begin
            AJson.left  := '0';
        end;

        //
        if not AJson.Exists('top') then begin
            AJson.top  := '0';
        end;

        //
        if not AJson.Exists('width') then begin
            AJson.widthex  := '100%';
        end else begin
            AJson.widthex  := IntToStr(AJson.width)+'px';
        end;

        //
        if not AJson.Exists('height') then begin
            AJson.heightex  := '100%';
        end else begin
            AJson.heightex  := IntToStr(AJson.height)+'px';
        end;


        //
        if not AJson.Exists('list') then begin
            AJson.list := _json('[]');
        end;

        //默认dwstyle
        if not AJson.Exists('dwstyle') then begin
            AJson.dwstyle := '';
        end;

        //默认dwattr
        if not AJson.Exists('dwattr') then begin
            AJson.dwattr := '';
        end;
    end;

end;

function _GetCellFontStyle(var AJson:Variant):String;
var
    sStyle  : string;
begin
    Result  := '';
    //
    if Ajson.Exists('fontname') then begin
        Result  := Result + 'font-family:'''+AJson.fontname+''';';
    end;

    //
    if Ajson.Exists('fontcolor') then begin
        Result  := Result + 'color:'+AJson.fontcolor+';';
    end;

    //
    if Ajson.Exists('fontsize') then begin
        Result  := Result + 'font-size:'+IntToStr(AJson.fontsize)+'px;';
    end;

    //
    if Ajson.Exists('fontstyle') then begin
        sStyle  := AJson.fontstyle;     //应为一个由0和1组成的4位字符串，分别表示BISU
        if Length(sStyle)<4 then begin
            Exit;
        end;
        //
        if sStyle[1] = '1' then begin
            Result  := Result + 'font-weight:bold;';
        end;
        //
        if sStyle[2] = '1' then begin
            Result  := Result + 'font-style:italic;';
        end;
    end;

end;


function _GetAlignStyle(var AJson:Variant):String;
var
    iH,iV   : Integer;
    iHV     : Integer;
begin
    Result  := '';
    //
    if not AJson.Exists('align') then begin
        Exit;
    end;
    //
    iH      := AJson.align._(0);
    iV      := AJson.align._(1);
    iHV     := iH*10+iV;

    //
    case iHV of
        0 : begin
            Result  := 'justify-content:flex-start;'
                    +'align-items:flex-start;'
        end;
        1 : begin
            Result  := 'justify-content:flex-start;'
                    +'align-items:center;'
        end;
        2 : begin
            Result  := 'justify-content:flex-start;'
                    +'align-items:flex-end;'
        end;

        //
        10 : begin
            Result  := 'justify-content:center;'
                    +'align-items:flex-start;'
                    +'text-align:center;'
        end;
        11 : begin
            Result  := 'justify-content:center;'
                    +'align-items:center;'
                    +'text-align:center;'
        end;
        12 : begin
            Result  := 'justify-content:center;'
                    +'align-items:flex-end;'
                    +'text-align:center;'
        end;

        //
        20 : begin
            Result  := 'justify-content:flex-end;'
                    +'align-items:flex-start;'
                    +'text-align:right;'
        end;
        21 : begin
            Result  := 'justify-content:flex-end;'
                    +'align-items:center;'
                    +'text-align:right;'
        end;
        22 : begin
            Result  := 'justify-content:flex-end;'
                    +'align-items:flex-end;'
                    +'text-align:right;'
        end;
    else
            Result  := 'justify-content:flex-start;'
                    +'align-items:flex-start;'
                    +'text-align:center;'
    end;

end;



//---------------------以上为辅助函数---------------------------------------------------------------
//当前控件需要引入的第三方JS/CSS ,一般为不做改动,目前仅在TChart使用时需要用到
function dwGetExtra(ACtrl: TComponent): string; stdcall;
var
    joRes           : Variant;
    joHint          : Variant;
    //
    sCode           : string;
    sHeaderBKColor  : string;
    sEvenBKColor    : string;   //偶数行背景色
    //
    iRowH           : Integer;
    iColW           : Integer;
    iRowHeight      : Integer;
    iHeaderHeight   : Integer;
begin
    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TStringGrid(ACtrl) do begin
        //
        joHint  := dwGetHintJson(TStringGrid(Actrl));
        //得到行高
        iRowHeight  := 35;
        if joHint.Exists('rowheight') then begin
            iRowHeight  := joHint.rowheight;
        end;
        //得到标题栏行高
        iHeaderHeight   := 35;
        if joHint.Exists('headerheight') then begin
            iHeaderHeight    := joHint.headerheight;
        end;
        //得到标题栏背景色
        sHeaderBKColor  := dwColor(TStringGrid(ACtrl).FixedColor);
        if joHint.Exists('headerbkcolor') then begin
            sHeaderBKColor  := joHint.headerbkcolor;
        end;
        //
        sEvenBkColor    := '#f8f9fe';
        if joHint.Exists('evenbkcolor') then begin
            sEvenBkColor  := joHint.evenbkcolor;
        end;

		sCode   := '<style>'
				+' .'+dwFullName(ACtrl)+'dwStringGridtitle{'
                    +'position:absolute;'
					+'text-align:center;'
					+dwIIF(BorderStyle=bsSingle,'border:solid 1px #ececec;','border-top:solid 1px #ececec;border-bottom:solid 1px #ececec;')
					+'font-weight:bold;'
                    +'overflow:hidden;'
                    +'background-color:#fafafa;'//+sHeaderBKColor+';'
					+'font-size:'+IntToStr(Font.Size+3)+'px;'
                    +'color:'+dwColor(Font.Color)+';'
					//+'line-height:'+IntToStr(iHeaderHeight)+'px;'
                    +'justify-content: center;'
	                +'flex-direction: column;'
                    +'display: flex;'
				+'}'
				+' .'+dwFullName(ACtrl)+'dwStringGrid0{'
                    +'position:absolute;'
					//+'text-align:center;'
                    +'padding-left:5px;padding-right:5px;'
					+dwIIF(BorderStyle=bsSingle,'border:solid 1px #ececec;','border-top:solid 1px #ececec;border-bottom:solid 1px #ececec;')
                    +'outline:none;'
					+'overflow:hidden;'
					//+'border:solid 1px #ececec;'
					+'font-size:'+IntToStr(Font.Size+3)+'px;'
                    +'color:'+dwColor(Font.Color)+';'
					+'height:'+IntToStr(iRowHeight-1)+'px;'
					+'line-height:'+IntToStr(iRowHeight-1)+'px;'
                    +'white-space: nowrap;'     //不折行
				+'}'
                +'</style>';
        //引入对应的库
        joRes.Add(sCode);
        //
        sCode   := '<style>'
                +'.dwscroll_bottom::-webkit-scrollbar {/*滚动条整体样式*/'
                    +'width:5px;/*高宽分别对应横竖滚动条的尺寸*/'
                    +'height:5px;'
                +'}'
                +'.dwscroll_bottom::-webkit-scrollbar-thumb {/*滚动条里面小方块*/'
                    +'border-radius:5px;'
                    +'-webkit-box-shadow: inset005pxrgba(0,0,0,0.2);'
                    +'background:rgba(0,0,0,0.2);'
                +'}'
                +'.dwscroll_bottom::-webkit-scrollbar-track {/*滚动条里面轨道*/'
                    +'-webkit-box-shadow: inset005pxrgba(0,0,0,0.2)'
                    +'border-radius:0;'
                    +'background:rgba(0,0,0,0.1);'
				+'}'
                +'</style>';
        //引入对应的库
        joRes.Add(sCode);

        //
        Result    := joRes;
    end;
end;
//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl: TComponent; AData: string): string; stdcall;
var
    joHint      : Variant;
    joData      : Variant;
    joValue     : Variant;
    joCell      : Variant;
    joGroup     : Variant;
    joItem      : Variant;
    //
    iCol,iRow   : Integer;  //序号
    iKey        : Word;
    iId         : Integer;  //单元格内group中的元素序号，其中group类型的从1开始
    iItem       : Integer;
    //
    sData       : String;
    sValue      : String;
    sCell       : String;
    sId         : string;
    //
    bFound      : Boolean;
    //
    //
begin

    //转换为JSON
    joData := _Json(AData);
    //如果格式不正确，则退出
    if joData = unassigned then begin
        Exit;
    end;
    //
    joHint  := dwGetHintJson(TStringGrid(ACtrl));
    with TStringGrid(ACtrl) do begin

        //处理各种事件
        if joData.e = 'dws_change' then begin
            sValue  := joData.v;
            sValue  := dwUnescape(sValue);
            joValue := _json(sValue);
            //
            if joValue = unassigned then begin
                Exit;
            end;
            if joValue._Count <4 then begin
                Exit;
            end;
            //得到记录位置和列序号
            iCol    := joValue._(0);
            iRow    := joValue._(1);
            iId     := joValue._(2);
            sValue  := joValue._(3);

            //
            if (iCol<0) or (iCol>=ColCount) or (iRow<0) or (iRow>=RowCount) then begin
                Exit;
            end;

            //更新本地cell值
            sCell   := Cells[iCol,iRow];        //取得当前单元格字符串值
            joCell  := _json(sCell);            //转换为JSON
            if joCell = unassigned then begin
                joCell  := _json('{}');
            end;
            _CheckCell(joCell);
            //
            if not joCell.Exists('value') then begin
                joCell.value    := _json('[""]');
            end;
            //赋值
            DocVariantData(joCell.value).Value[iID]  := sValue;
            //回写到cell的data中，以在刷新时保存当前数据
            joCell.data := sValue;
            //回写到cells
            Cells[iCol,iRow]    := joCell;

            //执行事件
            if Assigned(TStringGrid(ACtrl).OnGetEditMask) then begin
                sID := IntToStr(iID);
                TStringGrid(ACtrl).OnGetEditMask(TStringGrid(ACtrl),iCol,iRow,sID);
            end;
        end else if joData.e = 'dws_btnclick' then begin
            if Assigned(TStringGrid(ACtrl).OnFixedCellClick) then begin
                sValue  := joData.v;
                sValue  := dwUnescape(sValue);
                joValue := _json(sValue);
                //
                if joValue = unassigned then begin
                    Exit;
                end;
                if joValue._Count <4 then begin
                    Exit;
                end;
                //得到记录位置和列序号
                iCol    := joValue._(0);
                iRow    := joValue._(1);
                //
                TStringGrid(ACtrl).OnFixedCellClick(TStringGrid(ACtrl),iCol,iRow);
            end;
        end else if joData.e = 'dws_keydown' then begin
            if Assigned(TStringGrid(ACtrl).OnKeydown) then begin
                sValue  := joData.v;
                sValue  := dwUnescape(sValue);
                joValue := _json(sValue);
                //
                if joValue = unassigned then begin
                    Exit;
                end;
                if joValue._Count <3 then begin
                    Exit;
                end;
                //得到记录位置和列序号
                iCol    := joValue._(0);
                iRow    := joValue._(1);
                iKey    := joValue._(2);
                //切换到当前单元格
                Col     := iCol;
                Row     := iRow;
                //
                OnKeyDown(TStringGrid(ACtrl),iKey,[]);
            end;
        end else if joData.e = 'dws_keyup' then begin
            if Assigned(TStringGrid(ACtrl).OnKeyup) then begin
                sValue  := joData.v;
                sValue  := dwUnescape(sValue);
                joValue := _json(sValue);
                //
                if joValue = unassigned then begin
                    Exit;
                end;
                if joValue._Count <3 then begin
                    Exit;
                end;
                //得到记录位置和列序号
                iCol    := joValue._(0);
                iRow    := joValue._(1);
                iKey    := joValue._(2);
                //切换到当前单元格
                Col     := iCol;
                Row     := iRow;
                //
                OnKeyup(TStringGrid(ACtrl),iKey,[]);
            end;
        end else if joData.e = 'dws_click' then begin
            if Assigned(TStringGrid(ACtrl).OnDragDrop) then begin
                sValue  := joData.v;
                sValue  := dwUnescape(sValue);
                joValue := _json(sValue);
                //
                if joValue = unassigned then begin
                    Exit;
                end;
                if joValue._Count <2 then begin
                    Exit;
                end;
                //得到记录位置和列序号
                iCol    := joValue._(0);
                iRow    := joValue._(1);
                //切换到当前单元格
                Col     := iCol;
                Row     := iRow;
                //
                OnDragDrop(TStringGrid(ACtrl),nil,iCol,iRow);
            end;



        end else if joData.e = 'oncancel' then begin
        end else if joData.e = 'onsortasc' then begin
            //升序排序事件
        end else if joData.e = 'onsortdesc' then begin
            //逆序排序事件

        end else if joData.e = 'onfullcheck' then begin
            //选中的记录， 保存到Hint中
        end else if joData.e = 'onsinglecheck' then begin
        end else if joData.e = 'ondblclick' then begin
            //执行事件
            if Assigned(OnDblClick) then begin
                OnDblClick(TStringGrid(ACtrl));
            end;
        end;
    end;
end;
//dwGetHead 取得HTML头部消息
function dwGetHead(ACtrl: TComponent): string; stdcall;
var
    iRow,iCol   : Integer;
    iCellLeft   : Integer;
    iCellTop    : Integer;
    iItem       : Integer;
    iBorder     : Integer;
    //
    bAutoCopy   : Boolean;  //是否自动复制上行同列内容
    //
    sCell       : string;
    sCode       : string;
    sFull       : string;
    sPrefix     : string;   //用于控制组合单元格中的前缀
    sId         : string;
    sValue      : string;
    sKeydown    : string;   //用于添加OnKeydown事件的代码字符串
    sKeyup      : string;   //
    sKeypress   : string;
    sClick      : string;   //用于添加onclick/ondragdrop事件代码字符串
    //
    joRes       : Variant;  //返回结果
    joHint      : Variant;  //HINT
    joCell      : Variant;  //Cell JSON
    joGroup     : Variant;  //Cell JSON 的 group 属性（数组型）
    joItems     : Variant;  //Cell JSON 的 items 中的控件数组元素
    joItem      : variant;
    joBorders   : Variant;
    joBorder    : Variant;
    //
    ptExpands    : array of TPoint;  //记录已被合并，不需要显示的单元格
    //
    procedure CheckExpands(ARow,ACol:Integer;AJson:Variant);     //检查当前节点，如果扩展，则更新扩展数组
    var
        iiH,iiV : Integer;
        iiC,iiR : Integer;
    begin
        if AJson.Exists('expand') then begin
            iiH := AJson.expand._(0);
            iiV := AJson.expand._(1);
            //
            if (iiH>0) and (iiV>0) then begin
                for iiC := 0 to iiH do begin
                    for iiR := 0 to iiV do begin
                        //
                        if (iiC=0) and (iiR=0) then begin
                            Continue;
                        end;
                        //
                        SetLength(ptExpands,Length(ptExpands)+1);
                        ptExpands[High(ptExpands)].X    := ACol + iiC;
                        ptExpands[High(ptExpands)].Y    := ARow + iiR;
                    end;
                end;
            end else if (iiH>0) then begin
                for iiC := 1 to iiH do begin
                    SetLength(ptExpands,Length(ptExpands)+1);
                    ptExpands[High(ptExpands)].X    := ACol + iiC;
                    ptExpands[High(ptExpands)].Y    := ARow;
                end;
            end else if (iiV>0) then begin
                for iiR := 1 to iiV do begin
                    SetLength(ptExpands,Length(ptExpands)+1);
                    ptExpands[High(ptExpands)].X    := ACol;
                    ptExpands[High(ptExpands)].Y    := ARow+iiR;
                end;
            end;
        end;
    end;

    function  InExpands(ARow,ACol:Integer):Boolean; //当前单元格是否已被扩展.如已被扩展,则不显示
    var
        iiExpand    : Integer;
    begin
        Result  := False;
        for iiExpand := High(ptExpands) downto 0 do begin
            if (ptExpands[iiExpand].X = ACol) and (ptExpands[iiExpand].Y = ARow) then begin
                Result  := True;
                break;
            end;
        end;
    end;

begin
    //生成返回值数组 joRes
    joRes   := _Json('[]');

    //取得HINT对象joHint
    joHint  := dwGetHintJson(TControl(ACtrl));

    //补全属性，以便后面处理
    _CheckHint(joHint);

    //取得名称备用
    sFull   := dwFullName(ACtrl);

    //取得autocopy设置
    bAutoCopy   := False;
    if joHint.Exists('autocopy') then begin
        if joHint.autocopy = 1 then begin
            bAutoCopy   := True;
        end;
    end;

    //---核心处理程序---
    with TStringGrid(ACtrl) do begin
        //外框
        sCode   := concat(
                '<div ',
                    'id="'+sFull+'" ',
                    dwVisible(TControl(ACtrl)),
                    dwDisable(TControl(ACtrl)),
                    ' :style="{',
                        //
                        'color:'+sFull+'__fcl,',
                        '''font-size'':'+sFull+'__fsz,',
                        '''font-family'':'+sFull+'__ffm,',
                        '''font-weight'':'+sFull+'__fwg,',
                        '''font-style'':'+sFull+'__fsl,',
                        '''text-decoration'':'+sFull+'__ftd,',
                        //
                        'left:'+sFull+'__lef,',
                        'top:'+sFull+'__top,',
                        'width:'+sFull+'__wid,',
                        'height:'+sFull+'__hei',
                    '}"',
                    ' style="',
                        'position:absolute;',
                        'overflow:auto;',
                    '"', //style 封闭
                    //dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),''),
                    //dwIIF(Assigned(OnEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),''),
                    //dwIIF(Assigned(OnExit),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),''),
                '>');
        //添加到返回值数据
        joRes.Add(sCode);

        //处理所有单元格
        for iRow := 0 to RowCount-1 do begin
            for iCol := 0 to ColCount-1 do begin
                sCell   := Cells[iCol,iRow];

                //取得keydown/keyup事件代码备用
                sKeydown    := dwIIF(Assigned(OnKeydown), ' @keydown='+sFull+'__dws_keydown($event,'+IntToStr(iCol)+','+IntToStr(iRow)+')','');
                sKeyup      := dwIIF(Assigned(OnKeyup),   ' @keyup='+sFull+'__dws_keyup($event,'+IntToStr(iCol)+','+IntToStr(iRow)+')','');
                sClick      := dwIIF(Assigned(OnDragDrop),' @click='+sFull+'__dws_click($event,'+IntToStr(iCol)+','+IntToStr(iRow)+')','');

                //取得每个单元格的JSON
                joCell  := _json(sCell);

                //
                if joCell = unassigned then begin
                    joCell  := _json('{}');
                    joCell.data := sCell;
                end;


                //检查JSON完整性，并补全默认属性，以便于后面处理
                _CheckCell(joCell);

                //取得id备用
                sId := IntToStr(iRow*ColCount+iCol);

                //检查扩展（单元合并），生成扩展数组
                CheckExpands(iRow,iCol,joCell);


                //生成单元格外框
                sCode   := concat(
                        '<div ',
                            'id="'+sFull+'__c'+sId+'" ',
                            ' '+joCell.dwattr,
                            ' style="',
                                'position:absolute;',
                                'border:solid '+IntToStr(GridLineWidth)+'px '+dwColor(GradientEndColor)+';',
                                'overflow:hidden;',
                                dwIIF(InExpands(iRow,iCol),'display:none;','display:flex;'),
                                'background-color:'+joCell.bkcolor+';',

                                _GetAlignStyle(joCell),
                                _GetCellFontStyle(joCell),
                                joCell.dwstyle,
                            '"',
                            ' :style="{',
                                'left:'+sFull+'__lf'+IntToStr(iCol)+',',
                                'top:'+sFull+'__tp'+IntToStr(iRow)+',',
                                dwIIF(joCell.expand <> _json('[0,0]'),'width:'+sFull+'__w'+IntToStr(iRow)+'_'+IntToStr(iCol),'width:'+sFull+'__wd'+IntToStr(iCol))+',',
                                dwIIF(joCell.expand <> _json('[0,0]'),'height:'+sFull+'__h'+IntToStr(iRow)+'_'+IntToStr(iCol),'height:'+sFull+'__hi'+IntToStr(iRow))+'',
                            '}"',
                        '>');
                joRes.add(scode);


                if joCell.type = 'check' then begin                      //=========================
                    sCode   := concat(
                            '<el-checkbox ',
                                //' ref="'+sFull+'__c'+sId+'"',
                                ' '+joCell.dwattr,
                                ' v-model="'+sFull+'__c'+sId+'__dat" ',
                                dwGetHintValue(joCell,'placeholder','placeholder',''), //placeholder,提示语

                                ' style="',
                                    'position:absolute;',
                                    'overflow:hidden;',
                                    'background-color:'+joCell.bkcolor+';',
                                    'display:flex;',
                                    _GetAlignStyle(joCell),
                                    _GetCellFontStyle(joCell),
                                    joCell.dwstyle,
                                    'left:0;',
                                    'top:0;',
                                    'width:100%;',
                                    'height:100%;',
                                '"',
                                //回车下一格
                                ' @keyup.native.enter="'+sFull+'__focusNext('''+sId+''')"',
                                ' @change="'+sFull+'__dws_change('''+sFull+''','+IntToStr(iCol)+','+IntToStr(iRow)+',0,this.escape('+sFull+'__c'+sId+'__dat))"',
                            '>',
                            '</el-checkbox>');
                    //
                    joRes.add(scode);
                end else if joCell.type = 'combo' then begin             //=========================
                    sCode   := concat(
                            '<el-select ',
                                //' ref="'+sFull+'__c'+sId+'"',
                                ' '+joCell.dwattr,
                                ' v-model="'+sFull+'__c'+sId+'__dat" ',
                                dwGetHintValue(joCell,'placeholder','placeholder',''), //placeholder,提示语

                                ' style="',
                                    'position:absolute;',
                                    'overflow:hidden;',
                                    'background-color:'+joCell.bkcolor+';',
                                    'display:flex;',
                                    _GetAlignStyle(joCell),
                                    _GetCellFontStyle(joCell),
                                    joCell.dwstyle,
                                    'left:0;',
                                    'top:0;',
                                    'width:100%;',
                                    'height:100%;',
                                '"',
                                ' @keyup.native.enter="'+sFull+'__focusNext('''+sId+''')"',
                                ' @change="'+sFull+'__dws_change('''+sFull+''','+IntToStr(iCol)+','+IntToStr(iRow)+',0,this.escape('+sFull+'__c'+sId+'__dat))"',
                            '>');
                    //
                    joRes.add(scode);
                    joRes.Add('    <el-option style="font-size:'+IntToStr(Font.Size)+'px" v-for="item in '+sFull+'__c'+sId+'__its" :key="item.value" :label="item.value" :value="item.value"/>');
                    joRes.Add('</el-select>');
                end else if joCell.type = 'edit' then begin              //=========================
                    if joCell.Exists('button') then begin
                        sCode   := concat(
                                '<input ',
                                    ' ref="'+sFull+'__c'+sId+'"',
                                    ' '+joCell.dwattr,
                                    ' v-model="'+sFull+'__c'+sId+'__dat" ',
                                    dwGetHintValue(joCell,'placeholder','placeholder',''), //placeholder,提示语

                                    ' style="',
                                        'position:absolute;',
                                        'overflow:hidden;',
                                        'border:none;',
                                        'outline:medium;',
                                        'background-color:'+joCell.bkcolor+';',
                                        'display:flex;',
                                        _GetAlignStyle(joCell),
                                        _GetCellFontStyle(joCell),
                                        joCell.dwstyle,
                                        'top:0;',
                                        'width: calc(100% - 30px);',
                                        'right:24px;',
                                        'height:100%;',
                                    '}"',
                                    ' @keyup.enter="'+sFull+'__focusNext('''+sId+''')"',
                                    sKeydown,
                                    sKeyup,
                                    sClick,
                                    ' @input="'+sFull+'__dws_change('''+sFull+''','+IntToStr(iCol)+','+IntToStr(iRow)+',0,this.escape('+sFull+'__c'+sId+'__dat))"',
                                '>',
                                '</input>',
                                ' <el-button',
                                    ' style="',
                                        'position:absolute;',
                                        'width:24px;',
                                        'right:0px;',
                                        'height:100%;',
                                        'border:0;',
                                        'border-radius:0px;',
                                    '"',
                                    ' icon="el-icon-more"',
                                    //' @keydown="'+sFull+'__dws_keydown"',
                                    ' @keydown='+sFull+'__dws_keydown($event,'+IntToStr(iCol)+','+IntToStr(iRow)+')',

                                    ' @click='+sFull+'__dws_btnclick('''+sFull+''','+IntToStr(iCol)+','+IntToStr(iRow)+',0,this.escape('+sFull+'__c'+sId+'__dat))',
                                '>',
                                '</el-button>');
                    end else begin
                        sCode   := concat(
                                '<input ',
                                    ' ref="'+sFull+'__c'+sId+'"',
                                    ' '+joCell.dwattr,
                                    ' v-model="'+sFull+'__c'+sId+'__dat" ',
                                    dwGetHintValue(joCell,'placeholder','placeholder',''), //placeholder,提示语

                                    ' style="',
                                        'position:absolute;',
                                        'border:none;',
                                        'outline:medium;',
                                        'overflow:hidden;',
                                        'background-color:'+joCell.bkcolor+';',
                                        'display:flex;',
                                        _GetAlignStyle(joCell),
                                        _GetCellFontStyle(joCell),
                                        joCell.dwstyle,
                                        'top:0;',
                                        'width: calc(100% - 9px);',
                                        'right:3px;',
                                        'height:100%;',
                                    '}"',
                                    ' @keyup.enter="'+sFull+'__focusNext('''+sId+''')"',
                                    sKeydown,
                                    sKeyup,
                                    sClick,
                                    ' @input="'+sFull+'__dws_change('''+sFull+''','+IntToStr(iCol)+','+IntToStr(iRow)+',0,this.escape('+sFull+'__c'+sId+'__dat))"',
                                '>',
                                '</input>');
                    end;
                    //
                    joRes.add(scode);
                end else if joCell.type = 'memo' then begin              //=========================
                    if joCell.Exists('button') then begin
                        sCode   := concat(
                                '<textarea ',
                                    ' ref="'+sFull+'__c'+sId+'"',
                                    //' type="textarea"',
                                    ' '+joCell.dwattr,
                                    ' v-model="'+sFull+'__c'+sId+'__dat" ',
                                    dwGetHintValue(joCell,'placeholder','placeholder',''), //placeholder,提示语

                                    ' :style="{',
                                        //'left:'+sFull+'__lf'+IntToStr(iCol)+',',
                                        //'top:'+sFull+'__tp'+IntToStr(iRow)+',',
                                        //dwIIF(joCell.expand <> _json('[0,0]'),'width:'+sFull+'__w'+IntToStr(iRow)+'_'+IntToStr(iCol),'width:'+sFull+'__wd'+IntToStr(iCol))+',',
                                        dwIIF(joCell.expand <> _json('[0,0]'),'height:'+sFull+'__h'+IntToStr(iRow)+'_'+IntToStr(iCol),'height:'+sFull+'__hi'+IntToStr(iRow))+'',
                                    '}"',

                                    ' style="',
                                        'position:absolute;',
                                        'outline:none;',
                                        'resize:none;',
                                        'overflow:hidden;',
                                        'background-color:'+joCell.bkcolor+';',
                                        'display:flex;',
                                        _GetAlignStyle(joCell),
                                        _GetCellFontStyle(joCell),
                                        joCell.dwstyle,
                                        'top:0;',
                                        'width: calc(100% - 30px);',
                                        'right:24px;',
                                        'border:0;',
                                        //'height:100%',
                                    '}"',
                                    //' @keyup.enter="'+sFull+'__focusNext('''+sId+''')"',
                                    sKeydown,
                                    sKeyup,
                                    sClick,
                                    ' @input="'+sFull+'__dws_change('''+sFull+''','+IntToStr(iCol)+','+IntToStr(iRow)+',0,this.escape('+sFull+'__c'+sId+'__dat))"',
                                '>',
                                '</textarea>',
                                //
                                //'</input>',
                                ' <el-button',
                                    ' style="',
                                        'position:absolute;',
                                        'width:24px;',
                                        'right:0px;',
                                        'height:100%;',
                                        'border:0;',
                                        'border-radius:0px;',
                                    '"',
                                    ' icon="el-icon-more"',
                                    //' @keydown="'+sFull+'__dws_keydown"',
                                    ' @keydown='+sFull+'__dws_keydown($event,'+IntToStr(iCol)+','+IntToStr(iRow)+')',

                                    ' @click='+sFull+'__dws_btnclick('''+sFull+''','+IntToStr(iCol)+','+IntToStr(iRow)+',0,this.escape('+sFull+'__c'+sId+'__dat))',
                                '>',
                                '</el-button>');
                        //
                        joRes.add(scode);
                    end else begin
                        sCode   := concat(
                                '<textarea ',
                                    ' ref="'+sFull+'__c'+sId+'"',
                                    //' type="textarea"',
                                    ' '+joCell.dwattr,
                                    ' v-model="'+sFull+'__c'+sId+'__dat" ',
                                    dwGetHintValue(joCell,'placeholder','placeholder',''), //placeholder,提示语

                                    ' :style="{',
                                        //'left:'+sFull+'__lf'+IntToStr(iCol)+',',
                                        //'top:'+sFull+'__tp'+IntToStr(iRow)+',',
                                        //dwIIF(joCell.expand <> _json('[0,0]'),'width:'+sFull+'__w'+IntToStr(iRow)+'_'+IntToStr(iCol),'width:'+sFull+'__wd'+IntToStr(iCol))+',',
                                        dwIIF(joCell.expand <> _json('[0,0]'),'height:'+sFull+'__h'+IntToStr(iRow)+'_'+IntToStr(iCol),'height:'+sFull+'__hi'+IntToStr(iRow))+'',
                                    '}"',

                                    ' style="',
                                        'position:absolute;',
                                        'overflow:hidden;',
                                        'outline:none;',
                                        'resize:none;',
                                        'background-color:'+joCell.bkcolor+';',
                                        'display:flex;',
                                        _GetAlignStyle(joCell),
                                        _GetCellFontStyle(joCell),
                                        joCell.dwstyle,
                                        'top:0;',
                                        'width: calc(100% - 9px);',
                                        'right:3px;',
                                        'border:0;',
                                        //'height:100%',
                                    '}"',
                                    //' @keyup.enter="'+sFull+'__focusNext('''+sId+''')"',
                                    sKeydown,
                                    sKeyup,
                                    sClick,
                                    ' @input="'+sFull+'__dws_change('''+sFull+''','+IntToStr(iCol)+','+IntToStr(iRow)+',0,this.escape('+sFull+'__c'+sId+'__dat))"',
                                '>',
                                '</textarea>');
                        //
                        joRes.add(scode);
                    end;
//-----------------------------
                end else if joCell.type = 'link' then begin             //=========================
                    if joCell.Exists('href') then begin
                        sCode   := concat(
                                '<a',
                                    ' '+joCell.dwattr,
                                    ' :href="'+sFull+'__c'+sId+'__hrf" ',
                                    ' style="',
                                        'position:absolute;',
                                        'background-color:'+joCell.bkcolor+';',
                                        joCell.dwstyle,
                                        'left:0;',
                                        'top:0;',
                                        'width:100%;',
                                        'height:100%',
                                    '}"',
                                    sClick,
                                '>',
                                '{{'+sFull+'__c'+sId+'__dat}}',
                                '');
                        //
                        joRes.add(scode);
                        joRes.Add('</a>');
                    end;
//-----------------------------
                end else if joCell.type = 'image' then begin             //=========================
                    sCode   := concat(
                            '<el-image',
                                ' '+joCell.dwattr,
                                ' :src="'+sFull+'__c'+sId+'__dat" ',
                                ' style="',
                                    'position:absolute;',
                                    'background-color:'+joCell.bkcolor+';',
                                    joCell.dwstyle,
                                    'left:0;',
                                    'top:0;',
                                    'width:100%;',
                                    'height:100%',
                                '}"',
                                sClick,
                            '>');
                    //
                    joRes.add(scode);
                    joRes.Add('</el-image>');
                end else if joCell.type = 'label' then begin                      //=========================
                    if _json(sCell) = unassigned then begin
                        sCode   := concat(
                            '<div ',
                                ' '+joCell.dwattr,
                                ' style="',
                                    'overflow:hidden;',
                                    'padding:3px;',
                                    'display:flex;',
                                    _GetAlignStyle(joCell),
                                    _GetCellFontStyle(joCell),
                                    joCell.dwstyle,
                                    'left:0;',
                                    'top:0;',
                                    'width:100%;',
                                    'height:100%;',
                                '"',
                                sClick,
                            '>',
                            '{{'+sFull+'__c'+sId+'__dat}}',
                            '</div>');
                    end else begin
                        sCode   := concat(
                            '<div ',
                                ' '+joCell.dwattr,
                                ' v-html="'+sFull+'__c'+sId+'__dat" ',
                                ' style="',
                                    'overflow:hidden;',
                                    'padding:3px;',
                                    'display:flex;',
                                    _GetAlignStyle(joCell),
                                    _GetCellFontStyle(joCell),
                                    joCell.dwstyle,
                                    'left:0;',
                                    'top:0;',
                                    'width:100%;',
                                    'height:100%;',
                                '"',
                                sClick,
                            '>',
                            '</div>');
                    end;
                    //
                    joRes.add(scode);
                end else if joCell.type = 'spin' then begin              //=========================
                    sCode   := concat(
                            '<el-input-number ',
                                ' ref="'+sFull+'__c'+sId+'"',
                                ' '+joCell.dwattr,
                                ' v-model="'+sFull+'__c'+sId+'__dat" ',
                                ' controls-position="right"',
                                dwGetHintValue(joCell,'placeholder','placeholder',''), //placeholder,提示语

                                ' style="',
                                    'position:absolute;',
                                    'overflow:hidden;',
                                    'background-color:'+joCell.bkcolor+';',
                                    'display:flex;',
                                    _GetAlignStyle(joCell),
                                    joCell.dwstyle,
                                    'left:0;',
                                    'top:0;',
                                    'width:100%;',
                                    'height:100%;',
                                '"',
                                ' @keyup.native.enter="'+sFull+'__focusNext('''+sId+''')"',
                                sClick,
                                ' @change="'+sFull+'__dws_change('''+sFull+''','+IntToStr(iCol)+','+IntToStr(iRow)+',0,this.escape('+sFull+'__c'+sId+'__dat))"',
                            '>',
                            '</el-input-number>');
                    //
                    joRes.add(scode);
                end else if joCell.type = 'group' then begin             //=========================
                    if joCell.Exists('items') then begin
                        //得到group控件组合JSON数组
                        joItems := joCell.items;

                        for iItem := 0 to joItems._Count-1 do begin
                            //得到控件JSON
                            joItem  := joItems._(iItem);
                            //检查属性完整性
                            _CheckItem(joItem);
                            //生成前缀,备用
                            sPrefix := sFull+'__c'+sId+'_'+IntToStr(iItem);
                            //
                            if joItem.type='check' then begin
                                sCode   := concat(
                                        '<el-checkbox',
                                            ' '+joItem.dwattr,
                                            ' v-model="'+sPrefix+'__dat" ',
                                            dwGetHintValue(joItem,'placeholder','placeholder',''), //placeholder,提示语

                                            ' style="',
                                                'position:absolute;',
                                                'background-color:'+joItem.bkcolor+';',
                                                joItem.dwstyle,
                                                'left:'+IntToStr(joItem.left)+'px;',
                                                'top:'+IntToStr(joItem.top)+'px;',
                                            '}"',
                                        '>');
                                //
                                joRes.add(scode);
                                joRes.Add('</el-checkbox>');
                            end else if joItem.type='combo' then begin   //-------------------------
                                //传值使用的JSON字符串的头部
                                sValue  := '''{"id":['+IntToStr(iRow)+','+IntToStr(iCol)+','+IntToStr(iItem)+'],"value":';

                                //
                                sCode   := concat(
                                        '<el-select',
                                            ' '+joItem.dwattr,
                                            //' filterable',
                                            ' v-model="'+sPrefix+'__dat" ',
                                            dwGetHintValue(joItem,'placeholder','placeholder',''), //placeholder,提示语

                                            ' style="',
                                                'position:absolute;',
                                                'background-color:'+joItem.bkcolor+';',
                                                _GetCellFontStyle(joItem),
                                                joItem.dwstyle,
                                                'left:'+IntToStr(joItem.left)+'px;',
                                                'top:'+IntToStr(joItem.top)+'px;',
                                                'width:'+joItem.widthex+';',
                                                'height:'+joItem.heightex+';',
                                            '"',
                                        '>');
                                //
                                joRes.add(scode);
                                //添加
                                joRes.Add('    <el-option style="font-size:'+IntToStr(Font.Size)+'px" v-for="item in '+sPrefix+'__its" :key="item.value" :label="item.value" :value="item.value"/>');
                                //添加选项
                                joRes.Add('</el-select>');
                            end else if joItem.type='edit' then begin    //-------------------------
                                sCode   := concat(
                                        '<el-input',
                                            ' '+joItem.dwattr,
                                            ' v-model="'+sPrefix+'__dat" ',
                                            dwGetHintValue(joItem,'placeholder','placeholder',''), //placeholder,提示语

                                            ' style="',
                                                'position:absolute;',
                                                'background-color:'+joItem.bkcolor+';',
                                                _GetCellFontStyle(joItem),
                                                joItem.dwstyle,
                                                'left:'+IntToStr(joItem.left)+'px;',
                                                'top:'+IntToStr(joItem.top)+'px;',
                                                'width:'+joItem.widthex+';',
                                                'height:'+joItem.heightex+';',
                                            '"',
                                        '>');
                                //
                                joRes.add(scode);
                                joRes.Add('</el-input>');
                            end else if joItem.type='image' then begin   //-------------------------
                                sCode   := concat(
                                        '<el-image',
                                            ' '+joItem.dwattr,
                                            ' :src="'+sPrefix+'__dat" ',

                                            ' style="',
                                                'position:absolute;',
                                                joItem.dwstyle,
                                                'left:'+IntToStr(joItem.left)+'px;',
                                                'top:'+IntToStr(joItem.top)+'px;',
                                                'width:'+joItem.widthex+';',
                                                'height:'+joItem.heightex+';',
                                            '"',
                                        '>');
                                //
                                joRes.add(scode);
                                joRes.Add('</el-image>');
                            end else if joItem.type='label' then begin   //-------------------------
                                sCode   := concat(
                                        '<div',
                                            ' '+joItem.dwattr,
                                            ' style="',
                                                'position:absolute;',
                                                'overflow:hidden;',
                                                'display:flex;',
                                                _GetAlignStyle(joItem),
                                                _GetCellFontStyle(joItem),
                                                joItem.dwstyle,
                                                'left:'+IntToStr(joItem.left)+'px;',
                                                'top:'+IntToStr(joItem.top)+'px;',
                                                'width:'+joItem.widthex+';',
                                                'height:'+joItem.heightex+';',
                                            '"',
                                        '>',
                                        joItem.data);
                                //
                                joRes.add(scode);
                                joRes.Add('</div>');
                            end;
                        end;
                    end;
                end;

                //单元格的外框的封闭
                joRes.Add('</div>');

            end;

        end;

        //处理borders,类似 {"borders":[{"start":[0,2],"end":[17,11],"style":"border:solid 2px #333;"}]}
        joBorders   := joHint.borders;

        for iBorder := 0 to joBorders._Count-1 do begin
            //得到单个border设置
            joBorder    := joBorders._(iBorder);
            //
            sId         := IntToStr(iBorder);
            //
            sCode   := concat(
                    '<div ',
                        'id="'+sFull+'__b'+sId+'" ',
                        ' '+joBorder.dwattr,
                        ' style="',
                            'position:absolute;',
                            joBorder.style,
                            'background-color:transparent;',
                            'pointer-events:none;',
                            joBorder.dwstyle,
                        '"',
                        ' :style="{',
                            'left:'+sFull+'__lf'+IntToStr(joBorder.start._(0))+',',
                            'top:'+sFull+'__tp'+IntToStr(joBorder.start._(1))+',',
                            'width:'+sFull+'__bw'+IntToStr(iBorder)+',',
                            'height:'+sFull+'__bh'+IntToStr(iBorder),
                        '}"',
                    '></div>');
            joRes.add(scode);
        end;


    end;
    //返回值
    Result := joRes;
end;
//[ww_end][gethead]
//取得HTML尾部消息
function dwGetTail(ACtrl: TComponent): string; stdcall;
var
    joRes: Variant;
begin
    //生成返回值数组
    joRes := _Json('[]');
    //生成返回值数组
    //joRes.Add('    </el-table>');
    joRes.Add('</div>');
    Result := (joRes);
end;

function _dwGeneral(ACtrl:TComponent;AMode:String):Variant;
var
    iRow, iCol  : Integer;
    iItem       : Integer;
    iList       : Integer;
    iValue      : Integer;
    iSumCol     : Integer;
    iSumCount   : Integer;      //
    iCount      : Integer;
    iTotal      : Integer;
    iMax        : Integer;
    iRecCount   : Integer;
    iHeaderH    : Integer;
    iRowHeight  : Integer;
    iL,iT,iW,iH : Integer;
    iLevel      : Integer;
    iStart      : Integer;
    iEnd        : Integer;
    iHorz,iVert : Integer;
    iR,iC       : Integer;
    iBorder     : Integer;
    //
    iaLefts     : array of Integer;
    iaTops      : array of Integer;
    //
    sCode       : string;
    sCols       : string;
    sHover      : string;
    sRecord     : string;
    sField      : string;
    sFull       : string;
    sId         : String;
    sPrefix     : string;
    sDat        : string;
    sMiddle     : string;
    sTail       : string;
    //
    fValues     : array of Double;
    //
    joHint      : Variant;
    joRes       : Variant;
    joCell      : Variant;
    joFields    : Variant;
    joField     : Variant;
    joColDatas  : array of Variant;
    joValue     : Variant;
    joSummary   : variant;
    joSum       : variant;
    joSItem     : variant;
    joItem      : variant;
    joItems     : variant;
    joBorders   : variant;
    joBorder    : variant;
begin
    //生成返回值数组
    joRes := _Json('[]');

    //区分是否GetData，以确定使用 ;/,
    if LowerCase(AMode) = 'data' then begin
        sFull   := dwFullName(Actrl);
        sMiddle := ':';
        sTail   := ',';
    end else begin
        sFull   := 'this.'+dwFullName(Actrl);
        sMiddle := '=';
        sTail   := ';';
    end;


    with TStringGrid(ACtrl) do begin
        //取得HINT对象JSON
        joHint := dwGetHintJson(TControl(ACtrl));

        //
        _CheckHint(joHint);

        //总记录数
        iRecCount   := 0;

        //
        joRes.Add(sFull+'__lef'+sMiddle+'"' + IntToStr(Left)+'px"'+sTail);
        joRes.Add(sFull+'__top'+sMiddle+'"' + IntToStr(Top)+'px"'+sTail);
        joRes.Add(sFull+'__wid'+sMiddle+'"' + IntToStr(Width)+'px"'+sTail);
        joRes.Add(sFull+'__hei'+sMiddle+'"' + IntToStr(Height)+'px"'+sTail);
        //
        joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true','false')+sTail);
        joRes.Add(sFull+'__dis:'+dwIIF(Enabled,'false','true')+sTail);

        //置单元格的height和top(不包括带扩展单元格)
        iT  := 0;
        SetLength(iaTops,RowCount+1);
        for iRow := 0 to RowCount-1 do begin
            joRes.Add(sFull+'__hi'+IntToStr(iRow)+''+sMiddle+'"' + IntToStr(RowHeights[iRow]-1)+'px"'+sTail);
            joRes.Add(sFull+'__tp'+IntToStr(iRow)+''+sMiddle+'"' + IntToStr(iT)+'px"'+sTail);
            //
            iaTops[iRow]   := iT;
            Inc(iT,RowHeights[iRow]);
            iaTops[iRow+1] := iT;
        end;

        //置单元格的width和left(不包括带扩展单元格)
        iL  := 0;
        SetLength(iaLefts,ColCount+1);
        for iCol := 0 to ColCount-1 do begin
            joRes.Add(sFull+'__wd'+IntToStr(iCol)+''+sMiddle+'"' +IntToStr(ColWidths[iCol]-1)+'px"'+sTail);
            joRes.Add(sFull+'__lf'+IntToStr(iCol)+''+sMiddle+'"' +IntToStr(iL)+'px"'+sTail);
            //
            iaLefts[iCol]   := iL;
            Inc(iL,ColWidths[iCol]);
            iaLefts[iCol+1] := iL;
        end;

        //处理所有单元格
        for iRow := 0 to RowCount-1 do begin
            for iCol := 0 to ColCount-1 do begin
                //
                if Cells[iCol,iRow]='' then begin
                    //Continue;
                end;

                //取得每个单元格的JSON
                joCell  := _json(Cells[iCol,iRow]);

                //
                if joCell = unassigned then begin
                    joCell      := _json('{}');
                    joCell.data := Cells[iCol,iRow];
                end;

                //检查JSON完整性，并补全默认属性，以便于后面处理
                _CheckCell(joCell);

                //生成带扩展的单元格width/height
                if (joCell.expand._(0)<>0) or (joCell.expand._(1) <> 0) then begin
                    //得到水平和纵向扩展单元格个数
                    iHorz   := joCell.expand._(0);
                    iVert   := joCell.expand._(1);
                    //得到当前单元格扩展后的宽和高
                    iW  := iaLefts[iCol+iHorz+1] - iaLefts[iCol];
                    iH  := iaTops[iRow+iVert+1] - iaTops[iRow];
                    //添加到data
                    joRes.Add(sFull+'__w'+IntToStr(iRow)+'_'+IntToStr(iCol)+''+sMiddle+'"' +IntToStr(iW-1)+'px"'+sTail);
                    joRes.Add(sFull+'__h'+IntToStr(iRow)+'_'+IntToStr(iCol)+''+sMiddle+'"' +IntToStr(iH-1)+'px"'+sTail);
                end;

                //取得id备用
                sId := IntToStr(iRow*ColCount+iCol);

                //
                sDat    := sFull+'__c'+sId+'__dat:';

                if joCell.type = 'label' then begin                      //=========================
                    //当前值
                    joRes.Add(sDat+'"'+joCell.data+'"'+sTail);
                end else if joCell.type = 'edit' then begin              //=========================
                    //当前值                           '+sTail
                    joRes.Add(sDat+'"'+joCell.data+'"'+sTail);
                end else if joCell.type = 'memo' then begin              //=========================
                    //当前值
                    joRes.Add(sDat+'"'+joCell.data+'"'+sTail);
                end else if joCell.type = 'check' then begin              //=========================
                    //当前值
                    if LowerCase(joCell.data) = 'true' then begin
                        joRes.Add(sDat+'true'+sTail);
                    end else begin
                        joRes.Add(sDat+'false'+sTail);
                    end;
                end else if joCell.type = 'spin' then begin              //=========================
                    //当前值
                    iValue  := StrToIntDef(joCell.data,0);
                    joRes.Add(sDat+IntToStr(iValue)+sTail);
                end else if joCell.type = 'combo' then begin             //=========================
                    //当前值
                    joRes.Add(sFull+'__c'+sId+'__dat'+sMiddle+'"' +joCell.data+'"'+sTail);
                    //选项
                    sCode     := sFull+'__c'+sId+'__its:[';
                    for iItem := 0 to joCell.list._Count-1 do begin
                         sCode     := sCode + '{value:'''+joCell.list._(iItem)+'''},';
                    end;
                    if joCell.list._Count>0 then begin
                         Delete(sCode,Length(sCode),1);     //删除最后的逗号
                    end;
                    sCode     := sCode + ']'+sTail;
                    joRes.Add(sCode);

                end else if joCell.type = 'image' then begin             //=========================
                    //当前值
                    joRes.Add(sFull+'__c'+sId+'__dat'+sMiddle+'"' +joCell.data+'"'+sTail);
                end else if joCell.type = 'link' then begin             //=========================
                    //当前值
                    joRes.Add(sFull+'__c'+sId+'__dat'+sMiddle+'"' +joCell.data+'"'+sTail);
                    //当前值
                    joRes.Add(sFull+'__c'+sId+'__hrf'+sMiddle+'"' +joCell.href+'"'+sTail);
                end else if joCell.type = 'group' then begin             //=========================
                end;
            end;
        end;

        //处理borders,类似 {"borders":[{"start":[0,2],"end":[17,11],"style":"border:solid 2px #333;"}]}
        joBorders   := joHint.borders;
        for iBorder := 0 to joBorders._Count-1 do begin
            //得到单个border设置
            joBorder    := joBorders._(iBorder);
            //
            sId         := IntToStr(iBorder);
            //
            joRes.Add(sFull+'__bw'+IntToStr(iBorder)+''+sMiddle+'"' +IntToStr(iaLefts[1+Integer(joBorder.end._(0))]-iaLefts[Integer(joBorder.start._(0))]-2)+'px",');
            joRes.Add(sFull+'__bh'+IntToStr(iBorder)+''+sMiddle+'"' +IntToStr(iaTops[1+Integer(joBorder.end._(1))]-iaTops[Integer(joBorder.start._(1))]-2)+'px",');
        end;


        //字体信息
        joRes.Add(sFull+'__fcl'+sMiddle+'"' +dwColor(Font.Color)+'"'+sTail);
        joRes.Add(sFull+'__fsz'+sMiddle+'"' +IntToStr(Font.size+3)+'px"'+sTail);
        joRes.Add(sFull+'__ffm'+sMiddle+'"' +Font.Name+'"'+sTail);
        joRes.Add(sFull+'__fwg'+sMiddle+'"' +_GetFontWeight(Font)+'"'+sTail);
        joRes.Add(sFull+'__fsl'+sMiddle+'"' +_GetFontStyle(Font)+'"'+sTail);
        joRes.Add(sFull+'__ftd'+sMiddle+'"' +_GetTextDecoration(Font)+'"'+sTail);
    end;


    //log.WriteLog('取得Data：'+joRes);
    Result := (joRes);
end;


//取得Data
function dwGetData(ACtrl: TControl): string; stdcall;
var
    sFull       : string;
    //
    joHint      : Variant;
    joRes       : Variant;
begin
    //生成返回值数组
    joRes := _dwGeneral(ACtrl,'data');



    //
    Result := (joRes);
end;
//取得Method
function dwGetAction(ACtrl: TControl): string; stdcall;
var
    iRow, iCol  : Integer;
    iItem       : Integer;
    iSum        : Integer;
    iSumCol     : Integer;
    iSumCount   : Integer;
    iTotal      : Integer;
    iMax        : Integer;
    iRecCount   : Integer;
    iHeaderH    : Integer;
    iRowHeight  : Integer;
    iL,iT,iW,iH : Integer;
    iLevel      : Integer;
    iStart      : Integer;
    iEnd        : Integer;
    //
    sCode       : string;
    sCols       : string;
    sHover      : string;
    sRecord     : string;
    sField      : string;
    sFull       : string;
    sTmp        : string;
    //
    fValues     : array of Double;
    //
    joHint      : Variant;
    joRes       : Variant;
    joFields    : Variant;
    joField     : Variant;
    joColDatas  : array of Variant;
    joValue     : Variant;
    joSummary   : variant;
    joSItem     : variant;
    joItem      : Variant;
    joItems     : Variant;
    //比GetData多的变量
    iSel        : Integer;
    joSels      : Variant;
    sPrimaryKey : string;
begin
    //生成返回值数组
    joRes := _Json('[]');

    //取得名称备用
    sFull   := dwFullName(ACtrl);

    with TStringGrid(ACtrl) do begin
        //总记录数
        iRecCount   := 0;
        //取得HINT对象JSON
        joHint := dwGetHintJson(TControl(ACtrl));

        joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        joRes.Add('this.'+sFull+'__fcl="'+dwColor(Font.Color)+'";');
        joRes.Add('this.'+sFull+'__fsz="'+IntToStr(Font.size+3)+'px";');
        joRes.Add('this.'+sFull+'__ffm="'+Font.Name+'";');
        joRes.Add('this.'+sFull+'__fwg="'+_GetFontWeight(Font)+'";');
        joRes.Add('this.'+sFull+'__fsl="'+_GetFontStyle(Font)+'";');
        joRes.Add('this.'+sFull+'__ftd="'+_GetTextDecoration(Font)+'";');
    end;


    //log.WriteLog('取得Data：'+joRes);
    Result := (joRes);
end;
function dwGetMethods(ACtrl:TControl):String;stdCall;
var
    iRow,iCol   : Integer;
    iCellLeft   : Integer;
    iCellTop    : Integer;
    iItem       : Integer;
    iBorder     : Integer;
    iHandle     : Integer;
    iColCount   : Integer;
    iRowCount   : Integer;
    //
    sCell       : string;
    sCode       : string;
    sFull       : string;
    sPrefix     : string;   //用于控制组合单元格中的前缀
    sId         : string;
    sValue      : string;
    sChange     : string;   //用于生成统一的OnChange函数
    //
    joRes       : Variant;  //返回结果
    joHint      : Variant;  //HINT
    joCell      : Variant;  //Cell JSON
    joGroup     : Variant;  //Cell JSON 的 group 属性（数组型）
    joItems     : Variant;  //Cell JSON 的 items 中的控件数组元素
    joItem      : variant;
begin
    joRes   := _json('[]');

    //取得HINT对象JSON
    joHint := dwGetHintJson(TControl(ACtrl));

    //
    _CheckHint(joHint);

    //取得名称 备用
    sFull   := dwFullName(ACtrl);

    //取得句柄备用
    iHandle := TForm(ACtrl.Owner).Handle;

    with TStringGrid(ACtrl) do begin

        //统一的跳到下一格函数
        sCode   := Concat(
                sFull+'__focusNext(AId){',
                    'for (i = parseInt(AId)+1; i < '+IntToStr(RowCount*ColCount)+'; i++) {',
                        'var oBefore = (document.activeElement);',
                        'if (this.$refs["'+sFull+'__c"+i] !== undefined){;',
                            'this.$refs["'+sFull+'__c"+i].focus();',
                            'var oAfter = (document.activeElement);',
                            'if (oAfter !== oBefore){',
                                'break;',
                            '}',
                        '}',
                    '}',
                '},'
                );
        joRes.Add(sCode);

        //统一的btnclick函数
        joRes.Add(sFull+'__dws_btnclick(e,col,row,index,value){');
        //
        sCode   := Concat(
                '        var jo={};',
                'jo.m="event";',
                'jo.c="'+sFull+'";',
                'jo.i='+IntToStr(iHandle)+';',
                'jo.v=''[''+col+'',''+row+'',0,"''+value+''"]'';',
                'jo.e="dws_btnclick";'
                ,'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:2051}})',
                '.then(resp =>{this.procResp(resp.data)});'
                //,'console.log("edit_change");'
                //,'e.stopPropagation();'
                );
        joRes.Add(sCode);
        joRes.Add('},');


        //统一的keydown函数
        joRes.Add(sFull+'__dws_keydown(e,col,row){');
        //
        sCode   := Concat(
                '        var jo={};',
                'jo.m="event";',
                'jo.c="'+sFull+'";',
                'jo.i='+IntToStr(iHandle)+';',
                'jo.v=''[''+col+'',''+row+'',''+e.keyCode+'']'';',
                'jo.e="dws_keydown";'
                ,'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:2051}})',
                '.then(resp =>{this.procResp(resp.data)});'
                //'console.log(e.keyCode);'
                //,'e.stopPropagation();'
                );
        joRes.Add(sCode);
        joRes.Add('},');

        //统一的keyup函数
        joRes.Add(sFull+'__dws_keyup(e,col,row){');
        //
        sCode   := Concat(
                '        var jo={};',
                'jo.m="event";',
                'jo.c="'+sFull+'";',
                'jo.i='+IntToStr(iHandle)+';',
                'jo.v=''[''+col+'',''+row+'',''+e.keyCode+'']'';',
                'jo.e="dws_keyup";'
                ,'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:2051}})',
                '.then(resp =>{this.procResp(resp.data)});'
                //'console.log(e.keyCode);'
                //,'e.stopPropagation();'
                );
        joRes.Add(sCode);
        joRes.Add('},');


        //统一的keyup函数
        joRes.Add(sFull+'__dws_click(e,col,row){');
        //
        sCode   := Concat(
                '        var jo={};',
                'jo.m="event";',
                'jo.c="'+sFull+'";',
                'jo.i='+IntToStr(iHandle)+';',
                'jo.v=''[''+col+'',''+row+'']'';',
                'jo.e="dws_click";'
                ,'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:2051}})',
                '.then(resp =>{this.procResp(resp.data)});'
                //'console.log(e.keyCode);'
                //,'e.stopPropagation();'
                );
        joRes.Add(sCode);
        joRes.Add('},');


        //统一的OnChange函数
        joRes.Add(sFull+'__dws_change(e,col,row,index,value){');

        //
        for iRow := 0 to RowCount-1 do begin
            for iCol := 0 to ColCount-1 do begin

                sCell   := Cells[iCol,iRow];

                //取得每个单元格的JSON
                joCell  := _json(sCell);

                //检查JSON完整性，并补全默认属性，以便于后面处理
                _CheckCell(joCell);

                //取得id备用
                sId := IntToStr(iRow*ColCount+iCol);

                //
                sChange := '';
                if joCell.type = 'label' then begin                      //=========================
                end else if joCell.type = 'edit' then begin              //=========================
                    sChange := Concat(
                        '        var jo={};',
                        'jo.m="event";',
                        'jo.c="'+sFull+'";',
                        'jo.i='+IntToStr(iHandle)+';',
                        'jo.v=''['+IntToStr(iCol)+','+IntToStr(iRow)+',0,"''+value+''"]'';',
                        'jo.e="dws_change";'
                        ,'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:2051}})',
                        '.then(resp =>{this.procResp(resp.data)});'
                        //,'console.log("edit_change");'
                        //,'e.stopPropagation();'
                        )
                end else if joCell.type = 'memo' then begin              //=========================
                    sChange := Concat(
                        '        var jo={};',
                        'jo.m="event";',
                        'jo.c="'+sFull+'";',
                        'jo.i='+IntToStr(iHandle)+';',
                        'jo.v=''['+IntToStr(iCol)+','+IntToStr(iRow)+',0,"''+value+''"]'';',
                        'jo.e="dws_change";'
                        ,'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:2051}})',
                        '.then(resp =>{this.procResp(resp.data)});'
                        //,'console.log("edit_change");'
                        //,'e.stopPropagation();'
                        )

                end else if joCell.type = 'check' then begin             //=========================
                    sChange := Concat(
                        '        var jo={};',
                        'jo.m="event";',
                        'jo.c="'+sFull+'";',
                        'jo.i='+IntToStr(iHandle)+';',
                        'jo.v=''['+IntToStr(iCol)+','+IntToStr(iRow)+',0,"''+value+''"]'';',
                        'jo.e="dws_change";'
                        ,'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:2051}})',
                        '.then(resp =>{this.procResp(resp.data)});'
                        //,'e.stopPropagation();'
                        )
                end else if joCell.type = 'combo' then begin             //=========================
                    sChange := Concat(
                        '        var jo={};',
                        'jo.m="event";',
                        'jo.c="'+sFull+'";',
                        'jo.i='+IntToStr(iHandle)+';',
                        'jo.v=''['+IntToStr(iCol)+','+IntToStr(iRow)+',0,"''+value+''"]'';',
                        'jo.e="dws_change";'
                        ,'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:2051}})',
                        '.then(resp =>{this.procResp(resp.data)});'
                        //,'e.stopPropagation();'
                        )
                end else if joCell.type = 'spin' then begin             //=========================
                    sChange := Concat(
                        '        var jo={};',
                        'jo.m="event";',
                        'jo.c="'+sFull+'";',
                        'jo.i='+IntToStr(iHandle)+';',
                        'jo.v=''['+IntToStr(iCol)+','+IntToStr(iRow)+',0,"''+value+''"]'';',
                        'jo.e="dws_change";'
                        ,'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:2051}})',
                        '.then(resp =>{this.procResp(resp.data)});'
                        //,'e.stopPropagation();'
                        )
                end else if joCell.type = 'image' then begin             //=========================
                end else if joCell.type = 'group' then begin             //=========================
                    if joCell.Exists('items') then begin
                        //得到group控件组合JSON数组
                        joItems := joCell.items;

                        for iItem := 0 to joItems._Count-1 do begin
                            //得到控件JSON
                            joItem  := joItems._(iItem);
                            //检查属性完整性
                            _CheckItem(joItem);
                            //生成前缀,备用
                            sPrefix := sFull+'__c'+sId+'_'+IntToStr(iItem);
                            //
                            if joItem.type='check' then begin
                            end else if joItem.type='combo' then begin   //-------------------------
                            end else if joItem.type='edit' then begin    //-------------------------
                            end else if joItem.type='image' then begin   //-------------------------
                            end else if joItem.type='label' then begin   //-------------------------
                            end;
                        end;
                    end;
                end;
                //
                if sChange <> '' then begin
                    //
                    joRes.Add('    if ((col=='+IntToStr(iCol)+') && (row=='+IntToStr(iRow)+')){');
                    joRes.Add(sChange);
                    joRes.Add('    }');
                end;
            end;
        end;
        joRes.Add('},');

    end;
    //

    //
    Result := (joRes);
end;

function dwGetMounted(ACtrl:TControl):String;stdCall;
var
    iItem       : Integer;  //
    iRow,iCol   : Integer;  //
    iBorder     : Integer;
    //
    sCode       : string;
    sCell       : string;       //单元格id的前缀
    sId         : String;
    //
    joRes       : Variant;
    joHint      : Variant;
    joBorders   : Variant;
    joBorder    : Variant;
    joCell      : Variant;
begin
    joRes   := _json('[]');

    //取得HINT对象JSON
    joHint := dwGetHintJson(TControl(ACtrl));

    //
    _CheckHint(joHint);

    with TStringGrid(ACtrl) do begin
        //取得单元格ID前缀备用
        sCell   := dwFullName(ACtrl)+'__c';


        //处理borders,类似 {"borders":[{"start":[0,2],"end":[17,11],"position":[1,1,1,1],"style":"solid 2px #333"}]}
        joBorders   := joHint.borders;

        for iBorder := 0 to joBorders._Count-1 do begin
            //得到单个border设置
            joBorder    := joBorders._(iBorder);

            //
            for iCol := 0 to joBorder.end._(0)+1 do begin   //增加1是为了当前单元格边框 不被后续的遮挡
                for iRow := 0 to joBorder.end._(1)+1 do begin

                    //取得id备用
                    sId := IntToStr(iRow*ColCount+iCol);

                    //取得每个单元格的JSON
                    joCell  := _json(Cells[iCol,iRow]);

                    //检查JSON完整性，并补全默认属性，以便于后面处理
                    _CheckCell(joCell);

                    //处理上边框
                    if (joBorder.position._(0) = 1) and (iRow = joBorder.start._(1)) and (iCol >= joBorder.start._(0))  and (iCol <= joBorder.end._(0)) then begin
                        //joRes.Add('document.getElementById("'+sCell+sId+'").style.borderTop = "'+joBorder.style+'";');
                    end;

                    //处理下边框(分两种情况：1最末行，则直接处理最末行的borderbottom;2非最末行，则处理上一行的borderTop. 主要是因为如果非最末行，当前borderBottom会被下一行遮挡)
                    if (joBorder.position._(1) = 1) then begin
                        if joBorder.end._(1) = RowCount-1 then begin
                            if (iRow+joCell.expand._(1) = joBorder.end._(1)) and (iCol+joCell.expand._(0) >= joBorder.start._(0)) and (iCol <= joBorder.end._(0))  then begin
                                //joRes.Add('document.getElementById("'+sCell+sId+'").style.borderBottom = "'+joBorder.style+'";');
                            end;
                        end else begin
                            if (iRow+joCell.expand._(1) = joBorder.end._(1)+1) and (iCol+joCell.expand._(0) >= joBorder.start._(0)) and (iCol <= joBorder.end._(0))  then begin
                                //joRes.Add('document.getElementById("'+sCell+sId+'").style.borderTop = "'+joBorder.style+'";');
                            end;
                        end;
                    end;

                    //处理左边框
                    if (joBorder.position._(2) = 1) and (iCol = joBorder.start._(0)) then begin
                        //joRes.Add('document.getElementById("'+sCell+sId+'").style.borderLeft = "'+joBorder.style+'";');
                    end;

                    //处理右边框
                    if (joBorder.position._(1) = 1) and (iRow+joCell.expand._(1) = joBorder.end._(1)) then begin
                        //joRes.Add('document.getElementById("'+sCell+sId+'").style.borderBottom = "'+joBorder.style+'";');
                    end;

                end;
            end;

        end;
    end;
    //
    Result   := joRes;
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
