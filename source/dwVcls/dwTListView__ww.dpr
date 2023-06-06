library dwTListView__ww;

uses
    System.ShareMem,      //必须添加
    dwCtrlBase,           //一些基础函数
    SynCommons,           //mormot用于解析JSON的单元
    //untLog,             //日志
    Math,
    Variants,
    System.SysUtils,
    System.DateUtils,
    Vcl.ComCtrls,
    Vcl.ExtCtrls,
    System.Classes,
    Data.DB,
    Vcl.DBGrids,
    Vcl.Dialogs,
    Vcl.StdCtrls,
    Winapi.Windows,
    Vcl.Controls,

    Vcl.Forms;

function DeleteLastStr(str: string): string;
begin
    Delete(str, Length(str), 1);
    Result := str;
end;

function _GetValue(AField: TField): string;
begin
    try
        if AField.DataType in [ftString, ftSmallint, ftInteger, ftWord, ftBoolean, ftFloat, ftCurrency, ftBCD, ftBytes, ftVarBytes, ftAutoInc, ftFmtMemo, ftFixedChar, ftWideString, ftLargeint, ftMemo] then
        begin
            Result := dwProcessCaption(AField.AsString);
        end else if AField.DataType in [ftDate] then begin
                    Result := FormatDateTime('yyyy-mm-dd', AField.AsDateTime);
        end else if AField.DataType in [ftTime] then begin
            Result := FormatDateTime('HH:MM:SS', AField.AsDateTime);
        end else if AField.DataType in [ftDateTime] then begin
            case AField.Tag of
                1 : begin
                    Result := FormatDateTime('yyyy-mm-dd', AField.AsDateTime);
                end;
                2 : begin
                    Result := FormatDateTime('HH:MM:SS', AField.AsDateTime);
                end;
            else
                Result := FormatDateTime('yyyy-mm-dd HH:MM:SS', AField.AsDateTime);
            end;
        end else begin
            Result := '';
        end;
    except
    end;
end;

//取得汇总的行数
function _GetSumRowCount(ACtrl:TComponent):Integer;
var
    joHint      : Variant;
    joSummary   : Variant;
    joSum       : Variant;
    //
    iSum        : Integer;
    iCount      : Integer;
    iItem       : Integer;
begin
    try
        Result  := 0;
        //
        joHint  := _json(TControl(ACtrl).Hint);
        if joHint = unassigned then begin
            joHint  := _json('{}');
        end;

        //
        if not joHint.Exists('summary') then begin
            joHint.summary  := _json('[]');
        end;

        //得到汇总栏的行数(所有汇总的最大行数)
        joSummary   := joHint.summary;
        for iSum := 1 to joSummary._Count - 1 do begin     //joSummary的第一个项为标题，所以从1开始查找
            joSum   := joHint.summary._(iSum);
            iCount  := 1;
            //
            for iItem := 1 to iSum-1 do begin
                if joHint.summary._(iSum)._(0) = joHint.summary._(iItem)._(0) then begin
                    iCount  := iCount + 1;
                end;
            end;
            //
            Result  := Max(Result,iCount);
        end;
    except
        Result  := 0;
    end;
end;


//[ww_start][2022_04_10_00_08_15_724]
//_GetFields 取得包含各字段信息的JSON数组对象
function _GetFields(AGrid:TListView):Variant;
var
    iCol    : Integer;
    iFullW  : Integer;  //DBGrid总宽度
    iSumW   : Integer;  //各列总和
    iL      : Integer;
    //W
    fRatio  : Double;   //缩放比例
    //
    sCapt   : string;
    //
    joField : Variant;
begin
     //创建返回值数组
     Result  := _json('[]');
     //先设置所有字段的宽度总和iSumW = 0
     iSumW   := 0;
     //取得各字段的属性，如果没有，则设置为默认值。并取得iSumW
     for iCol := 0 to AGrid.Columns.Count-1 do begin
          //得到caption字符串
          sCapt   := AGrid.Columns[iCol].Caption;
          //根据caption生成JSON
          joField := _json(sCapt);
          //根据Caption为JSON分别处理。如是，则优先读取JSON信息
          if joField = unassigned then begin
               //不是JSON
               //未采用JSON来描述，则采用原Delphi默认字段属性
               joField             := _json('{}');
               joField.type        := 'string';
               joField.fieldname   := '';
               joField.width       := AGrid.Columns[iCol].Width;
               joField.viewwidth   := AGrid.Columns[iCol].Width;
               joField.caption     := AGrid.Columns[iCol].Caption;
               joField.color       := dwColor(AGrid.Font.Color);
               joField.bkcolor     := 'transparent';
               if AGrid.Columns[iCol].alignment = taLeftJustify then begin
                    joField.align       := 'left';
               end else if AGrid.Columns[iCol].alignment = taRightJustify then begin
                    joField.align       := 'left';
               end else if AGrid.Columns[iCol].alignment = taCenter then begin
                    joField.align       := 'center';
               end;
          end else begin
               //是JSON
               //采用JSON对字段进行描述
               //如果未指定类型，则默认为string
               if not joField.Exists('type') then begin
                    joField.type        := 'string';
               end;
               //如果未指定宽度，则采用字段宽度
               if not joField.Exists('width') then begin
                    joField.width       := AGrid.Columns[iCol].Width;
                    joField.viewwidth   := joField.width;
               end;
               //如果未指定字段名，则采用字段名
               if not joField.Exists('fieldname') then begin
                    joField.fieldname   := '';
               end;
               //如果没有指定caption,则默认为字段名
               if not joField.Exists('caption') then begin
                    joField.caption := joField.fieldname;
               end;
               //如果没有指定color
               if not joField.Exists('color') then begin
                    joField.color       := dwColor(AGrid.Font.Color);
               end;
               //如果没有指定bkcolor
               if not joField.Exists('bkcolor') then begin
                    joField.bkcolor     := 'transparent'
               end;
               //如果没有指定align
               if not joField.Exists('align') then begin
                    if AGrid.Columns[iCol].alignment = taLeftJustify then begin
                         //taLeftJustify
                         joField.align       := 'left';
                    end else if AGrid.Columns[iCol].alignment = taRightJustify then begin
                         joField.align       := 'right';
                    end else if AGrid.Columns[iCol].alignment = taCenter then begin
                         joField.align       := 'center';
                    end;
               end;
               //如果未指定sort，则默认为不排序
               if not joField.Exists('sort') then begin
                    joField.sort        := 0;
               end;
               //如果未指定sort，则默认为不排序
               if not joField.Exists('readonly') then begin
                    joField.readonly    := 0;
               end;
               //为progress类型增加minvalue,maxvalue
               if joField.type = 'progress' then begin
                    if not joField.Exists('minvalue') then begin
                         joField.minvalue    := 0;
                    end;
                    if not joField.Exists('maxvalue') then begin
                         joField.minvalue    := 100;
                    end;
               end;
          end;
          //计算字段宽度之和
          iSumW   := iSumW + joField.width;
          //将当前字段添加到返回值JSON数组
          Result.Add(joField);
     end;
     //如果无数据列，则退出
     if (Result._Count = 0) or ((Result._Count = 1) and ((Result._(0).fieldname = ''))) then begin
          Exit;
     end else begin
          //取得Grid宽度iFullW备用
          iFullW  := AGrid.Width;
          //根据是否自动缩放及最后一列类型，确定各字段的实际宽度
          if AGrid.ParentBiDiMode then begin
               //不缩放的情况
               //先设置所有字段显示宽度为设定宽度
               for iCol := 0 to AGrid.Columns.Count-1 do begin
                    Result._(iCol).viewwidth    := Result._(iCol).width ;
               end;
               //Grid的宽度比各字段宽度之各更宽，最后字段需要补齐
               if iFullW>iSumW then begin
                    //最后一列类型是button？
                    if Result._(Result._Count-1).type = 'button' then begin
                         //扩展倒数第2列宽度
                         Result._(Result._Count-2).viewwidth := Result._(Result._Count-2).viewwidth + iFullW - iSumW - 9;
                    end else begin
                         //扩展倒数第1列宽度
                         Result._(Result._Count-1).viewwidth := Result._(Result._Count-1).viewwidth + iFullW - iSumW - 9;
                    end;
               end;
          end else begin
               fRatio  := iFullW / iSumW;
               //最后一列类型是button？
               if Result._(Result._Count-1).type = 'button' then begin
                    //iSumW为最后一列（button列）宽度
                    iSumW   := Result._(Result._Count-1).width;
                    for iCol := 0 to AGrid.Columns.Count-3 do begin
                         //自动缩放模式
                         if not AGrid.ParentBiDiMode then begin
                              Result._(iCol).viewwidth    := Round(Result._(iCol).width * fRatio);
                              iSumW   := iSumW + Result._(iCol).viewwidth;
                         end else begin
                              Result._(iCol).viewwidth    := Round(Result._(iCol).width * 1);
                              iSumW   := iSumW + Result._(iCol).viewwidth;
                         end;
                    end;
                    //最后一列补齐 //-9是为了考虑尽量不出现水平滚动条
                    Result._(AGrid.Columns.Count-1).viewwidth    := Max(Result._(AGrid.Columns.Count-1).width,iFullW - 9 - iSumW);
               end else begin
                    //等比例缩放
                    iSumW   := 0;
                    for iCol := 0 to AGrid.Columns.Count-2 do begin
                         //自动缩放模式
                         if not AGrid.ParentBiDiMode then begin
                              Result._(iCol).viewwidth    := Round(Result._(iCol).width * fRatio);
                              iSumW   := iSumW + Result._(iCol).viewwidth;
                         end else begin
                              Result._(iCol).viewwidth    := Round(Result._(iCol).width * 1);
                              iSumW   := iSumW + Result._(iCol).viewwidth;
                         end;
                    end;
                    //最后一列补齐 //-9是为了考虑尽量不出现水平滚动条
                    Result._(AGrid.Columns.Count-1).viewwidth    := Max(Result._(AGrid.Columns.Count-1).width,iFullW - 9 - iSumW);
               end;
          end;
     end;
     //计算各字段的left
     
     iL  := 0;
     for iCol := 0 to Result._Count-1 do begin
          joField := Result._(iCol);
          joField.left    := iL;
          
          //
          iL  := iL + joField.viewwidth;
     end;
end;

//[ww_end][2022_04_10_00_08_15_724]



//生成汇总的数组
function _GetSummarys(AGrid:TListView):Variant;
var
    iSum    : Integer;
    iItem   : Integer;
    //
    joHint  : Variant;
    joSum   : Variant;
    joSItem : Variant;
begin
    Result  := _json('[]');

    //
    joHint  := _json(AGrid.Hint);
    if joHint = unassigned then begin
        joHint  := _json('{}');
    end;

    //
    if not joHint.Exists('summary') then begin
        joHint.summary  := _json('[]');
    end;

    //
    for iSum := 0 to joHint.summary._Count-1 do begin
        joSItem     := joHint.summary._(iSum);
        for iItem := 1 to joSItem._Count-1 do begin
            //
            joSum       := _json('{}');
            joSum.col   := joSItem._(0);
            //
            joSum.type  := joSItem._(iItem)._(0);   //avg/sum/max/min
            joSum.format:= joSItem._(iItem)._(1);   //"平均：%.2f元"
            joSum.value := 0;
            //
            Result.Add(joSum);
        end;
    end;
end;

//[ww_start][2022_04_10_11_15_58_969]
//_CreateColumnsHtml 根据计算的表头配置信息生成表头HTML
function _CreateColumnsHtml(AGrid:TListView;
    AFields:Variant;
    var AMax,AHeaderHeight,ARowHeight:Integer;
    var AHTML,AHover,ARecord:string):Integer;
var
    iL,iT   : Integer;
    iW,iH   : Integer;
    iCol    : Integer;
    iLevel  : Integer;  //表头的层次
    iStart  : Integer;  //表头合并的开始序号，从0开始 ，空间为[]
    iEnd    : Integer;  //表头合并的结束序号，从0开始
    sCapt   : String;
    iItem   : Integer;
    iCount  : Integer;  //表头中换行符的个数，用于计算TOp
    iTop    : Integer;
    //
    joField : Variant;
    joHint  : Variant;
    joItem  : Variant;
const
    //标题换行后计算的top值
    _TOPS   : array[0..5] of Integer = (-4,-12,-24,-32,-42,-54);
begin
     //取joHint
     
     //取joHint
     joHint  := _json(AGrid.Hint);
     if joHint = unassigned then begin
          joHint  := _json('{}');
     end;
     //计算多表头最大层数 AMax
     
     AMax    := 1;
     if joHint.Exists('merge') then begin
          for iItem := 0 to joHint.merge._Count - 1 do begin
               AMax    := Max(AMax,joHint.merge._(iItem)._(0));
          end;
     end;
     //取得Hover颜色，记录颜色，行高，标题行高等参数
     
     //得到Hover颜色
     AHover  := '#e1f3ff';
     if joHint.Exists('hover') then begin
          AHover  := joHint.hover;
     end;
     //得到record颜色(当前记录)
     ARecord  := '#e1f3ff';
     if joHint.Exists('record') then begin
          ARecord := joHint.record;
     end;
     //得到行高
     ARowHeight  := 40;
     if joHint.Exists('rowheight') then begin
          ARowHeight  := joHint.rowheight;
     end;
     //得到标题栏行高
     AHeaderHeight  := 40;
     if joHint.Exists('headerheight') then begin
          AHeaderHeight   := joHint.headerheight;
     end;
     //计算各字段的楼层高度
     for iCol := 0 to AFields._Count - 1 do begin
                  joField := AFields._(iCol);
                  joField.max := AMax;
          if joHint.Exists('merge') then begin
               for iItem := 0 to joHint.merge._Count - 1 do begin
                    iLevel  := joHint.merge._(iItem)._(0)-1;    //楼层
                    iStart  := joHint.merge._(iItem)._(1);      //起始序号
                    iEnd    := joHint.merge._(iItem)._(2);      //结束序号
                    //如果在合并范围之中，则降低楼层
                    if (iCol>=iStart) and (iCol<=iEnd) then begin
                         joField.max := Min(joField.max,iLevel);
                    end;
               end;
          end;
     end;
     //开始计算各字段的LTWH
     iL  := -1;
     for iCol := 0 to AFields._Count - 1 do begin
          joField := AFields._(iCol);
          //
          joField.left    := iL;
          joField.top     := ( AMax - joField.max ) * AHeaderHeight;
          joField.height  := joField.max * AHeaderHeight;
          //
          iL  := iL + joField.viewwidth;
          //如果最后一列未充满，则补齐
          if (iCol = AFields._Count - 1) and (iL < AGrid.Width) then begin
               joField.width   := joField.width + ( AGrid.Width - iL)+1;
          end;
     end;

     //生成一个空div， 仅用于生成垂直滚动格
     AHTML   := '<div'
     		+' id="'+dwFullName(AGrid)+'__scr"'         //scr : scroll
     		+' :style="{'
     			+'top:'+dwFullName(AGrid)+'__sct'       //sct : scroll top
     		+'}"'
     		+' style="'
     			+'position:absolute;'
     			+'left:0;'
     			+'width:1px;'
     			+'height:1px;'
     		+'"'
     		+'>'
            +'</div>';

     //生成标题总框
     AHTML   := AHTML + '<div'
     		+' id="'+dwFullName(AGrid)+'__tit"'
     		+' :style="{'
     			//+'width:'+dwFullName(AGrid)+'__twd,'    //twd : title width
     			+'top:'+dwFullName(AGrid)+'__ttp'       //ttp : title top
     		+'}"'
     		+' style="'
     			+'position:absolute;'
     			+'left:0;'
     			+'z-index:9;'
     			+'height:'+IntToStr(AMax*AHeaderHeight)+'px;'
     		+'"'
     		+'>';
     //生成各字段的HTML
     for iCol := 0 to AFields._Count - 1 do begin
          joField := AFields._(iCol);
          //
          iL      := joField.left;
          iT      := joField.top;
          iW      := joField.viewwidth;
          iH      := joField.height;
          sCapt   := '';
          if joField.Exists('caption') then begin
               sCapt   := joField.caption;
          end;
          if joField.Exists('type') and (joField.type = 'check') then begin
               AHTML   := AHTML + Format(#13'                <el-checkbox'
               		+' class="'+dwFullName(AGrid)+'dwdbgridtitle"'
               		+ ' :style="{'
               			+'left:'+dwFullName(AGrid)+'__cl'+IntToStr(iCol)+','
               			+'width:'+dwFullName(AGrid)+'__cw'+IntToStr(iCol)
               		+'}"'
               		+' style="'
               			+'position:absolute;top:%dpx;height:%dpx;line-height:%dpx'
               		+'"'
               		+' @change='''+dwFullName(TComponent(AGrid))+'__cc'+IntToStr(iCol)+''''
               		+'>'
               		+'</el-checkbox>',[iT,iH,iH]);
          end else begin
               AHTML   := AHTML + Format(#13'                <div class="'+dwFullName(AGrid)+'dwdbgridtitle"'
               		+ ' :style="{'
               			+'left:'+dwFullName(AGrid)+'__cl'+IntToStr(iCol)+','
               			+'width:'+dwFullName(AGrid)+'__cw'+IntToStr(iCol)
               		+'}"'
               		+' style="'
               			+'position:absolute;top:%dpx;height:%dpx;'
               		+'">'
               			+'<div>'
               			+'<span style="display:inline-block">'
               				+'%s'
               			+'</span>',
               			[iT,iH,sCapt]);
               //如果需要排序，则增加排序
               if joField.Exists('sort') and joField.sort=1 then begin
                    //取得换行个数
                    iCount  := dwSubStrCount(sCapt,'<br/>');
                    if iCount <=5 then begin
                         iTop    := _Tops[iCount];
                    end else begin
                         iTop    := -42-10*(iCount-4);
                    end;
                    AHTML   := AHTML
                    		+ '<span class="caret-wrapper"'
                    			+' style="'
                    				+'display: inline-flex;'
                    				+'flex-direction: column;'
                    				+'top: '+IntToStr(iTop)+'px;'     //根据标题中<br/>的个数控制top
                    				+'position: relative;'
                    			+'"'
                    		+'>'
                    		+'<i class="el-icon-caret-top"'
                    			+' @click=''dwevent('
                    					+'"",'
                    					+'"'+dwFullName(TComponent(AGrid))+'",'
                    					+'"'+IntToStr(iCol)+'",'
                    					+'"onsortasc",'
                    					+IntToStr(TForm(AGrid.Owner).Handle)
                    			+');'''
                    		+'></i>'
                    		+'<i class="el-icon-caret-bottom"'
                    			+' @click=''dwevent('
                    					+'"",'
                    					+'"'+dwFullName(TComponent(AGrid))+'",'
                    					+'"'+IntToStr(iCol)+'",'
                    					+'"onsortdesc",'
                    					+IntToStr(TForm(AGrid.Owner).Handle)
                    			+');'''
                    		+'>'
                    		+'</i>'
                    		+'</span>';
               end;
               //双层</div>封闭
               AHTML   := AHTML + '</div></div>';
          end;
     end;
     //增加合并的表头数据
     if joHint.Exists('merge') then begin
          for iItem := 0 to joHint.merge._Count - 1 do begin
               iLevel  := joHint.merge._(iItem)._(0);  //楼层
               iStart  := joHint.merge._(iItem)._(1);  //起始序号
               iEnd    := joHint.merge._(iItem)._(2);  //结束序号
               if (iStart >= 0) and (iStart <AFields._Count) and (iEnd >= 0) and (iEnd <AFields._Count) then begin
                    //
                    iL      := AFields._(iStart).left;
                    iT      := AHeaderHeight * (AMax - iLevel);
                    iW      := AFields._(iEnd).left + AFields._(iEnd).viewwidth - iL;
                    iH      := AHeaderHeight-1;
                    sCapt   := joHint.merge._(iItem)._(3);
                    //
                    iCount  := dwSubStrCount(sCapt,'<br/>');
                    //
                    AHTML   := AHTML + Format('<div class="'+dwFullName(AGrid)+'dwdbgridtitle"'
                    		+ ' :style="{'
                    			+'left:'+dwFullName(AGrid)+'__cl'+IntToStr(iItem+AFields._Count)+','
                    			+'width:'+dwFullName(AGrid)+'__cw'+IntToStr(iItem+AFields._Count)
                    		+'}"'
                    		+' style="'
                    			+'top:%dpx;height:%dpx;line-height:%dpx'
                    		+'">%s</div>',[iT,iH,(iH div (iCount+1)),sCapt]);
               end;
          end;
     end;
     //封闭div
     AHTML   := AHTML +'</div>';
     //
     Result  := 0;
end;

//[ww_end][2022_04_10_11_15_58_969]


//取得动态表头到JSON变量中，用于后续使用
function _GetColumnTitles(AGrid:TListView):variant;
var
    iL          : Integer;
    iCol        : Integer;
    iLevel      : Integer;  //表头的层次
    iStart      : Integer;  //表头合并的开始序号，从0开始 ，空间为[]
    iEnd        : Integer;  //表头合并的结束序号，从0开始
    iItem       : Integer;
    iMax        : Integer;  //当前表头的最大楼层数
    iHeaderH    : Integer;
    //
    joFields    : Variant;
    joField     : Variant;
    joHint      : Variant;
    joCols      : Variant;
    joItem      : Variant;
    joTitle     : Variant;
begin
    //创建返回值对象
    Result  := _json('[]');

    //先取得各字段信息
    joFields    := _GetFields(AGrid);;

    //取得Hint的JSON
    joHint  := dwGetHintJson(AGrid);

    //计算最大层数
    iMax    := 1;
    if joHint.Exists('merge') then begin
        for iItem := 0 to joHint.merge._Count - 1 do begin
            iMax    := Max(iMax,joHint.merge._(iItem)._(0));
        end;
    end;


    //得到标题栏行高
    iHeaderH    := 40;
    if joHint.Exists('headerheight') then begin
        iHeaderH   := joHint.headerheight;
    end;


    //计算各字段的楼层高度
    for iCol := 0 to joFields._Count - 1 do begin
        //取得当前字段JSON对象
        joField     := joFields._(iCol);
        //默认为最大楼层高
        joField.max := iMax;
        //如果合并项中有当前字段，则设置当前字段的楼层为合并项的楼层
        if joHint.Exists('merge') then begin
            for iItem := 0 to joHint.merge._Count - 1 do begin
                iLevel  := joHint.merge._(iItem)._(0)-1;  //楼层
                iStart  := joHint.merge._(iItem)._(1);  //起始序号
                iEnd    := joHint.merge._(iItem)._(2);  //结束序号
                //如果在合并范围之中，则降低楼层
                if (iCol>=iStart) and (iCol<=iEnd) then begin
                    joField.max := Min(joField.max,iLevel);
                end;
            end;
        end;
    end;

    //计算各字段的LTWH
    iL  := -1;
    for iCol := 0 to joFields._Count - 1 do begin
        joField := joFields._(iCol);
        //
        joField.left    := iL;
        joField.top     := ( iMax - joField.max ) * iHeaderH-1;
        joField.height  := joField.max * iHeaderH;
        //
        iL  := iL + joField.viewwidth;
        //如果最后一列未充满，则补齐
        if (iCol = joFields._Count - 1) and (iL < AGrid.Width) then begin
            joField.width   := joField.viewwidth + ( AGrid.Width - iL);
        end;
    end;

    //生成各字段的HTML
    for iCol := 0 to joFields._Count - 1 do begin
        joField := joFields._(iCol);
        //
        joTitle     := _json('{}');

        joTitle.l   := IntToStr(joField.left)+'px';
        joTitle.t   := IntToStr(joField.top)+'px';
        joTitle.w   := IntToStr(joField.viewwidth)+'px';
        joTitle.h   := IntToStr(joField.height)+'px';
        joTitle.c   := joField.caption;
        //
        Result.Add(joTitle);
    end;

    //增加合并的表头数据
    if joHint.Exists('merge') then begin
        //
        for iItem := 0 to joHint.merge._Count - 1 do begin
            iLevel  := joHint.merge._(iItem)._(0);  //楼层
            iStart  := joHint.merge._(iItem)._(1);  //起始序号
            iEnd    := joHint.merge._(iItem)._(2);  //结束序号


            //
            if (iStart >= 0) and (iStart <joHint.merge._Count) and (iEnd >= 0) and (iEnd <joHint.merge._Count) then begin
                //
                joTitle     := _json('{}');
                joTitle.l   := IntToStr(joFields._(iStart).left)+'px';
                joTitle.t   := IntToStr(iHeaderH * (iMax - iLevel)-1)+'px';
                joTitle.w   := IntToStr(joFields._(iEnd).left + joFields._(iEnd).viewwidth - joFields._(iStart).left-1)+'px';
                joTitle.h   := IntToStr(iHeaderH-1)+'px';
                joTitle.c   := joHint.merge._(iItem)._(3);

                //
                Result.Add(joTitle);
            end;
        end;
    end;
end;

//---------------------以上为辅助函数---------------------------------------------------------------

//当前控件需要引入的第三方JS/CSS ,一般为不做改动,目前仅在TChart使用时需要用到
function dwGetExtra(ACtrl: TComponent): string; stdcall;
var
    joRes       : Variant;
    joHint      : Variant;
    //
    sFull           : string;
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
    joRes   := _Json('[]');
    //
    sFull   := dwFullName(ACtrl);

    //
    with TListView(ACtrl) do begin
        //
        joHint  := dwGetHintJson(TListView(Actrl));

        //得到行高
        iRowHeight  := 40;
        if joHint.Exists('rowheight') then begin
            iRowHeight  := joHint.rowheight;
        end;

        //得到标题栏行高
        iHeaderHeight   := 40;
        if joHint.Exists('headerheight') then begin
            iHeaderHeight    := joHint.headerheight;
        end;

        //得到标题栏背景色
        sHeaderBKColor  := '#fff';
        if joHint.Exists('headerbkcolor') then begin
            sHeaderBKColor  := joHint.headerbkcolor;
        end;

        //
        sEvenBkColor    := '#f8f9fe';
        if joHint.Exists('evenbkcolor') then begin
            sEvenBkColor  := joHint.evenbkcolor;
        end;


		sCode   := '<style>'
				+' .'+sFull+'dwdbgridtitle{'
                    +'position:absolute;'
					+'text-align:center;'
					+dwIIF(BorderStyle=bsSingle,'border:solid 1px #ececec;','border-top:solid 1px #ececec;border-bottom:solid 1px #ececec;')
					+'font-weight:bold;'
                    +'overflow:hidden;'
                    +'background-color:#fff;'//+sHeaderBKColor+';'
					+'font-size:'+IntToStr(Font.Size+3)+'px;'
                    +'color:'+dwColor(Font.Color)+';'
					//+'line-height:'+IntToStr(iHeaderHeight)+'px;'
                    +'justify-content: center;'
	                +'flex-direction: column;'
                    +'display: flex;'
				+'}'
				+' .'+sFull+'dwdbgrid0{'
                    +'position:absolute;'
					//+'text-align:center;'
                    +'padding-left:5px;padding-right:5px;'
					+dwIIF(BorderStyle=bsSingle,'border:solid 1px #ececec;','border-top:solid 1px #ececec;border-bottom:solid 1px #ececec;')
                    +'outline:none;'
					+'overflow:hidden;'
	                +'text-overflow: ellipsis;'
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
    joField     : Variant;
    joFields    : Variant;
    joFDs       : Variant;
    //
    iCol        : Integer;  //列序号
    iRecNo      : Integer;  //记录位置
    iBtnId      : Integer;  //按钮ID
    iItem       : Integer;
    //
    sPrimaryKey : String;
    sKey        : String;
    sFDs        : string;
    slKeys      : TStringList;
    //
    bFound      : Boolean;
    //

    //
    oDataSet    : TDataSet;
    oBookMark   : TBookMark;
    oAfter      : Procedure(DataSet: TDataSet) of Object;
    oBefore     : Procedure(DataSet: TDataSet) of Object;
begin
    //转换为JSON
    joData := _Json(AData);

    //如果格式不正确，则退出
    if joData = unassigned then begin
        Exit;
    end;

    //
    joHint  := dwGetHintJson(TListView(ACtrl));

    with TListView(ACtrl) do begin
        //如果没有连接数据库，则退出
        oDataSet    := nil;
        if joHint.Exists('dataset') then begin
            oDataSet    := TDataSet(Owner.FindComponent(joHint.dataset));
        end;
        if oDataSet = nil then begin
            Exit;
        end;


        //处理各种事件
        if joData.e = 'onclick' then begin
            //得到记录位置和列序号
            iCol    := joData.v mod 100;
            iRecNo  := joData.v div 100;

            //移动数据表位置
            oDataSet.RecNo := iRecNo;

            //执行事件
            //if Assigned(TListView(ACtrl).OnCellClick) then begin
            //    if iCol<TListView(ACtrl).Columns.Count then begin
            //        TListView(ACtrl).OnCellClick(TListView(ACtrl).Columns[iCol]);
            //    end else begin
            //        TListView(ACtrl).OnCellClick(TListView(ACtrl).Columns[0]);
            //    end;
            //end;
        end else if joData.e = 'onbuttonclick' then begin
            //操作按钮事件


            //得到记录位置和列序号,及菜单
            iRecNo  := joData.v div 10000;              //数据表记录号
            iCol    := (joData.v mod 10000) div 100;    //列号
            iBtnId  := joData.v mod 100;                //按钮序号

            //移动数据表位置
            if oDataSet.RecNo <> iRecNo then begin
                oDataSet.RecNo := iRecNo;
            end;

            //执行事件
            if iCol<99 then begin
                if Assigned(OnEndDock) then begin
                    OnEndDock(TListView(ACtrl),nil,100+iCol,iBtnId);
                end;
            end;
        end else if joData.e = 'onsave' then begin
            //
            //保存事件
            sFDs    := dwUnescape(joData.v);
            joFDs   := _json(sFDs);     //得到当前编辑的数据

            //异常检查
            if joFDs = unassigned then begin
                Exit;
            end;

            //激活“保存前”事件
            if Assigned(OnEndDock) then begin
                OnEndDock(TListView(ACtrl),nil,4,oDataSet.RecNo);
            end;

            //得到各字段JSON数组
            joFields    := _GetFields(TListView(ACtrl));

            //保存编辑的数据
            oDataSet.Edit;
            for iCol := 0 to joFields._Count-1 do begin
                joField := joFields._(iCol);
                //
                if joField.Exists('type') and (joField.type = 'check') then begin
                    //-----选择框-----
                end else if joField.Exists('type') and (joField.type = 'index') then begin
                    //-----行号列-----
                end else if joField.Exists('type') and (joField.type = 'image') then begin
                    oDataSet.FieldByName(joField.fieldname).AsString    := joFDs._(iCol);
                end else if joField.Exists('type') and (joField.type = 'progress') then begin
                    //-----进度条-----
                    oDataSet.FieldByName(joField.fieldname).AsString    := joFDs._(iCol);
                end else if joField.Exists('type') and (joField.type = 'button') then begin
                    //-----按钮-----
                end else if joField.Exists('type') and (joField.type = 'boolean') then begin
                    //-----布尔型-----
                    oDataSet.FieldByName(joField.fieldname).AsString    := joFDs._(iCol);
                end else if joField.Exists('type') and (joField.type = 'string') and joField.Exists('list')then begin
                    //-----字符串型，带列表-----
                    oDataSet.FieldByName(joField.fieldname).AsString    := joFDs._(iCol);
                end else if joField.Exists('type') and (joField.type = 'date')then begin
                    //-----日期型-----
                    oDataSet.FieldByName(joField.fieldname).AsString    := joFDs._(iCol);
                end else begin
                    if joField.fieldname <> '' then begin
                        if oDataSet.FieldByName(joField.fieldname).DataType <> ftAutoInc then begin
                            oDataSet.FieldByName(joField.fieldname).AsString    := joFDs._(iCol);
                        end;
                    end;
                end;
            end;
            //
            oDataSet.Post;

            //激活“保存前”事件
            if Assigned(OnEndDock) then begin
                OnEndDock(TListView(ACtrl),nil,5,oDataSet.RecNo);
            end;

        end else if joData.e = 'onappend' then begin
            //
            //保存事件
            sFDs    := dwUnescape(joData.v);
            joFDs   := _json(sFDs);     //得到当前编辑的数据

            //异常检查
            if joFDs = unassigned then begin
                Exit;
            end;

            //激活“保存前”事件
            if Assigned(OnEndDock) then begin
                OnEndDock(TListView(ACtrl),nil,4,oDataSet.RecNo);
            end;

            //得到各字段JSON数组
            joFields    := _GetFields(TListView(ACtrl));

            //保存编辑的数据
            oDataSet.Append;
            for iCol := 0 to joFields._Count-1 do begin
                joField := joFields._(iCol);
                //
                if joField.Exists('type') and (joField.type = 'check') then begin
                    //-----选择框-----
                end else if joField.Exists('type') and (joField.type = 'index') then begin
                    //-----行号列-----
                end else if joField.Exists('type') and (joField.type = 'image') then begin
                    oDataSet.FieldByName(joField.fieldname).AsString    := joFDs._(iCol);
                end else if joField.Exists('type') and (joField.type = 'progress') then begin
                    //-----进度条-----
                    oDataSet.FieldByName(joField.fieldname).AsString    := joFDs._(iCol);
                end else if joField.Exists('type') and (joField.type = 'button') then begin
                    //-----按钮-----
                end else if joField.Exists('type') and (joField.type = 'boolean') then begin
                    //-----布尔型-----
                    oDataSet.FieldByName(joField.fieldname).AsString    := joFDs._(iCol);
                end else if joField.Exists('type') and (joField.type = 'string') and joField.Exists('list')then begin
                    //-----字符串型，带列表-----
                    oDataSet.FieldByName(joField.fieldname).AsString    := joFDs._(iCol);
                end else if joField.Exists('type') and (joField.type = 'date')then begin
                    //-----日期型-----
                    oDataSet.FieldByName(joField.fieldname).AsString    := joFDs._(iCol);
                end else begin
                    if joField.fieldname <> '' then begin
                        if oDataSet.FieldByName(joField.fieldname).DataType <> ftAutoInc then begin
                            oDataSet.FieldByName(joField.fieldname).AsString    := joFDs._(iCol);
                        end;
                    end;
                end;
            end;
            //
            oDataSet.Post;

            //激活“保存前”事件
            if Assigned(OnEndDock) then begin
                OnEndDock(TListView(ACtrl),nil,5,oDataSet.RecNo);
            end;
            //Options := Options - [dgEditing];
        end else if joData.e = 'oncancel' then begin
            //Options := Options - [dgEditing];

            //激活“取消”事件
            if Assigned(OnEndDock) then begin
                OnEndDock(TListView(ACtrl),nil,6,0);
            end;
        end else if joData.e = 'onsortasc' then begin
            //升序排序事件


            //得到列序号
            iCol    := joData.v;

            //执行事件
            if iCol<99 then begin
                if Assigned(OnEndDock) then begin
                    OnEndDock(TListView(ACtrl),nil,1,iCol);
                end;
            end;
        end else if joData.e = 'onsortdesc' then begin
            //逆序排序事件


            //得到列序号
            iCol    := joData.v;

            //执行事件
            if iCol<99 then begin
                if Assigned(OnEndDock) then begin
                    OnEndDock(TListView(ACtrl),nil,2,iCol);
                end;
            end;
        end else if joData.e = 'onfullcheck' then begin
            //得到主键
            sPrimaryKey := 'id';
            if joHint.Exists('primarykey') then begin
                sPrimaryKey := joHint.primarykey;
            end;

            //选中的记录， 保存到Hint中
            if sPrimaryKey <> '' then begin

                //保存当前位置
                oBookMark := oDataSet.GetBookmark;

                oDataSet.DisableControls;

                //保存原事件函数
                oAfter  := oDataSet.AfterScroll;
                oBefore := oDataSet.BeforeScroll;
                //清空事件
                oDataSet.AfterScroll    := nil;
                oDataSet.BeforeScroll   := nil;


                //将当前选择的复制到slKeys中
                slKeys  := TStringList.Create;
                oDataSet.First;
                while not oDataSet.Eof do begin
                    slKeys.Add(oDataSet.FieldByName(sPrimaryKey).AsString);
                    //
                    oDataSet.Next;
                end;

                oDataSet.GotoBookmark(oBookMark); //重新定位记录指针回到原来的位置
                oDataSet.EnableControls;

                oDataSet.FreeBookmark(oBookMark); //删除书签BookMark标志
                //恢复原事件函数
                oDataSet.AfterScroll    := oAfter  ;
                oDataSet.BeforeScroll   := oBefore ;
                //>

                //检查节点是否存在
                if not joHint.Exists('__selection') then begin
                    joHint.__selection  := _json('[]');
                end;

                //根据是全选中，还是全取消进行处理
                if joData.v='true' then begin
                    //将原来选择的也复制到slKeys中
                    for iItem := 0 to joHint.__selection._Count-1 do begin
                        slKeys.Add(joHint.__selection._(iItem));
                    end;

                    //去重
                    dwRemoveDuplicates(slKeys);

                    //再将slKeys生成到joHint.__selection中
                    joHint.__selection  := _json('[]');
                    for iItem := 0 to slKeys.Count-1 do begin
                        joHint.__selection.Add(slKeys[iItem]);
                    end;
                end else begin
                    for iItem := joHint.__selection._Count-1 downto 0 do begin
                        if slKeys.IndexOf(joHint.__selection._(iItem))>-1 then begin
                            joHint.__selection.Delete(iItem);
                        end;
                    end;

                end;

                //回写到Hint
                Hint    := joHint;

                //释放slKeys
                slKeys.Destroy;
            end;

            //执行事件
            if Assigned(OnEndDock) then begin
                if joData.v='true' then begin
                    OnEndDock(TListView(ACtrl),nil,3,-1);
                end else begin
                    OnEndDock(TListView(ACtrl),nil,3,0);
                end;
            end;
        end else if joData.e = 'onsinglecheck' then begin
            //得到主键
            sPrimaryKey := 'id';
            if joHint.Exists('primarykey') then begin
                sPrimaryKey := joHint.primarykey;
            end;

            //选中的记录， 保存到Hint中
            if sPrimaryKey <> '' then begin

                oDataSet.DisableControls;

                //保存原事件函数
                oAfter  := oDataSet.AfterScroll;
                oBefore := oDataSet.BeforeScroll;
                //清空事件
                oDataSet.AfterScroll    := nil;
                oDataSet.BeforeScroll   := nil;

                //
                oDataSet.RecNo  := joData.v div 100;

                //得到当前值
                sKey    := oDataSet.FieldByName(sPrimaryKey).AsString;

                oDataSet.EnableControls;

                //恢复原事件函数
                oDataSet.AfterScroll    := oAfter  ;
                oDataSet.BeforeScroll   := oBefore ;
                //检查节点是否存在
                if not joHint.Exists('__selection') then begin
                    joHint.__selection  := _json('[]');
                end;

                //根据是选中，还是取消进行处理
                if joData.v mod 2 = 1 then begin
                    //检查当前是否已在将原来选择的， 保存到bFound中
                    bFound  := False;
                    for iItem := 0 to joHint.__selection._Count-1 do begin
                        if sKey = joHint.__selection._(iItem) then begin
                            bFound  := True;
                        end;
                    end;

                    if not bFound then begin
                        joHint.__selection.Add(sKey);
                    end;
                end else begin
                    for iItem := joHint.__selection._Count-1 downto 0 do begin
                        if sKey = joHint.__selection._(iItem) then begin
                            joHint.__selection.Delete(iItem);
                            break;
                        end;
                    end;

                end;

                //回写到Hint
                Hint    := joHint;

            end;

            //执行事件
            if Assigned(OnEndDock) then begin
                OnEndDock(TListView(ACtrl),nil,3,joData.v div 100);
            end;
        end else if joData.e = 'ondblclick' then begin

            //执行事件
            if Assigned(OnDblClick) then begin
                OnDblClick(TListView(ACtrl));
            end;
        end else if copy(joData.e,1,length('oncolumnchange')) = 'oncolumnchange' then begin
            //oncolumnchange 数据字段列中的change事件
            //执行事件
            if Assigned(OnEndDock) then begin

                //得到列序号，从0开始
                sKey    := joData.e;
                Delete(sKey,1,length('oncolumnchange'));
                iCol    := StrToIntDef(sKey,-1);

                //异常检查
                if iCol < 0 then begin
                    Exit;
                end;

                //得到各字段JSON数组
                joFields    := _GetFields(TListView(ACtrl));

                //写入当前值
                oDataSet.Edit;
                if joFields._(iCol).fieldname <> '' then begin
                    oDataSet.FieldByName(joFields._(iCol).fieldname).AsString   := dwUnescape(joData.v);
                end;
                //
                OnEndDock(TListView(ACtrl),nil,7,iCol);
            end;
        end;
    end;

end;

//[ww_start][gethead]
//dwGetHead 取得HTML头部消息
function dwGetHead(ACtrl: TComponent): string; stdcall;
var
    iItem       : Integer;
    iCol        : Integer;
    iMax        : Integer;
    iTotal      : Integer;      //总宽度，用于宽度补齐
    iRowHeight  : Integer;      //行高
    iTitleColW  : Integer;      //纵向显示时的列宽
    iHeaderH    : Integer;      //表头的行高
    iRecCount   : Integer;      //记录总数
    iSumCount   : Integer;      //
    iSumCol     : Integer;      //汇总列序号
    iSum        : Integer;
    iCount      : Integer;
    iL,iT,iW,iH : Integer;
    //
    sFull       : string;
    sHover      : string;
    sRecord     : string;
    sCols       : String;
    sCode       : string;
    sHeaderBKC  : string;
    sChange     : string;   //生成激活编辑框OnChange事件的代码

    joHint      : Variant;  //HINT
    joRes       : Variant;  //返回结果
    joFields    : Variant;  //字段数组
    joField     : Variant;  //字段
    joButton    : Variant;  //操作按钮
    joSummary   : Variant;  //汇总配置
    joSum       : variant;  //单项汇总项
    //
    oDataSet    : TDataSet;
begin
    //生成返回值数组 joRes
    joRes := _Json('[]');

    //
    sFull   := dwFullName(ACtrl);

    //取得HINT对象joHint
    joHint := dwGetHintJson(TControl(ACtrl));
    //取得字段数组 joFields
    joFields    := _GetFields(TListView(ACtrl));
    //统一处理一些可能为空的属性:merge/summary/headerbkcolor，以便后面处理

    //标题合并项
    if not joHint.Exists('merge') then begin
        joHint.merge    := _json('[]');
    end;
    //汇总项
    if not joHint.Exists('summary') then begin
        joHint.summary  := _json('[]');
    end;
    //标题底色项
    if not joHint.Exists('headerbkcolor') then begin
        joHint.headerbkcolor  := '#f8f8f8';
    end;
    //用一个函数取得表头HTML：sCols及其他信息：标题楼层数iMax,标题总高iHeaderH,数据行高iRowHeight,Hover颜色sHover,当前记录颜色sRecord
    sCols   := '';
    _CreateColumnsHtml(TListView(ACtrl),joFields,iMax,iHeaderH,iRowHeight,sCols,sHover,sRecord);
    //得到标题栏背景色
    sHeaderBKC  := joHint.headerbkcolor;
    //---核心处理程序---
    with TListView(ACtrl) do begin
        oDataSet    := nil;
        if joHint.Exists('dataset') then begin
            oDataSet    := TDataSet(Owner.FindComponent(joHint.dataset));
        end;
        if oDataSet = nil then begin
            Result  := joRes;
            Exit;
        end;

        //默认记录总数为0
        iRecCount   := 0;
        iRecCount   := oDataSet.RecordCount;
        //根据Ctrl3D分别显示不同样式，为True时显示为表格，为False时显示为纵向单字段列表，主要用于手机显示
        if Ctl3D then begin
            //以下为显示普通表格样式，主要用于电脑/平板显示
            //添加全表的总外框
            joRes.Add('<div'
                    +' id="'+sFull+'"'
                    + ' class="dwscroll_bottom"'
                    + dwVisible(TControl(ACtrl))
                    + dwLTWHBordered(TControl(ACtrl))
                        + 'overflow:auto;'
                        //+ 'overflow-y:hidden;'
                        //+ 'border:solid 1px #ececec;'

                        ////+ '-moz-user-select:none;'
                        ////+ '-webkit-user-select:none;'
                        ////+ '-ms-user-select:none;'
                        ////+ ' user-select:none;'
                    + '"' //style 封闭
                    ////+' onselectstart="return false"'
                    +' @scroll="'+sFull+'__scroll($event)"'
                    + '>');
            //添加表头
            joRes.Add('    '+sCols);
            //初始化汇总变量
            joSummary   := joHint.summary;
            iSumCount   := 0;
            //得到汇总栏的行数(所有汇总的最大行数)
            for iSum := 1 to joSummary._Count - 1 do begin
                joSum   := joHint.summary._(iSum);
                iCount  := 1;

                for iItem := 1 to iSum-1 do begin
                    if joHint.summary._(iSum)._(0) = joHint.summary._(iItem)._(0) then begin
                        iCount  := iCount + 1;
                    end;
                end;
                iSumCount   := Max(iSumCount,iCount);
            end;
            //添加数据外框__dat
            joRes.Add('    <div'
                    +' id="'+sFull+'__dat"'
                    +' :style="{'
                    +'height:'+sFull+'__dth'       //dth : Data Height
                    +'}"'
                    +' style="'
                           +'position:absolute;'
                           +'overflow:visible;'
                           +'left:0;'
                           +'top:'+IntToStr(iMax*iHeaderH)+'px;'
                           +'width:100%;'
                           //+'height:'+IntToStr(Height-iMax*iHeaderH-iSumCount*iRowHeight)+'px;'
                    +'"' //style 封闭
                    +' @mouseover=''function(e){'
                           +'var iRecNo=parseInt((Math.abs(e.offsetY)+e.target.offsetTop)/'+IntToStr(iRowHeight)+');'//转化为记录No,从0开始
                           +'iRecNo=Math.min('+sFull+'__rcc-1,iRecNo);'                           //避免超记录
                           //+'this.console.log(iRecNo);'
                           //+'this.console.log(e);'
                           +sFull+'__hov=parseInt(iRecNo*'+IntToStr(iRowHeight)+')+"px";'   //更新记录指示框位置
                    +'}'''
                    +' @mouseleave=''function(e){'
                           //+'this.console.log(e);'
                           +sFull+'__hov="-500px";'   //更新记录指示框位置
                    +'}'''

                    +' @click=''function(e){'
                           //+'this.alert("pause");'
                           //+'this.console.log(e);'
                           +'var iRecNo=parseInt((e.offsetY+e.target.offsetTop)/'+IntToStr(iRowHeight)+');'//转化为记录No,从0开始
                           //+'this.console.log(iRecNo);'
                           //+'this.console.log('+sFull+'__rcc);'
                           +'iRecNo=Math.min('+sFull+'__rcc-1,iRecNo);'                           //避免超记录
                           //+'this.console.log(iRecNo);'
                           +sFull+'__rnt=parseInt(iRecNo*'+IntToStr(iRowHeight)+')+"px";'   //更新记录指示框位置
                           +'dwevent("","'+sFull+'",(iRecNo+1)*100+99,"onclick",'+IntToStr(TForm(Owner).Handle)+');'
                    +'}'''
                    + ' @dblclick='''
                       //+'this.console.log(''dblclick'');'
                       +'dwevent("","'+sFull+'","0","ondblclick",'+IntToStr(TForm(Owner).Handle)+');'
                    +''''
                    +' @keydown.up='''
                           +sFull+'__hov="-500px";'                 //隐藏Hover框
                           +'var iRecNo=parseInt('+sFull+'__rnt);'  //取得当前记录指示框的top
                           +'iRecNo=Math.round(iRecNo/'+IntToStr(iRowHeight)+');'  //转化为记录No,从0开始
                           +'iRecNo=Math.max(0,iRecNo-1);'                         //记录No-1
                           +sFull+'__rnt=parseInt(iRecNo*'+IntToStr(iRowHeight)+')+"px";'   //更新记录指示框位置
                           +'dwevent("","'+sFull+'",(iRecNo+1)*100+99,"onclick",'+IntToStr(TForm(Owner).Handle)+');'
                           +''''
                    +' @keydown.down='''
                           +sFull+'__hov="-500px";'                 //隐藏Hover框
                           +'var iRecNo=parseInt('+sFull+'__rnt);'  //取得当前记录指示框的top
                           +'iRecNo=Math.round(iRecNo/'+IntToStr(iRowHeight)+');'  //转化为记录No,从0开始
                           +'iRecNo=Math.min('+IntToStr(iRecCount-1)+',iRecNo+1);' //记录No+1
                           +'iRecNo=Math.max(0,iRecNo);'                           //避免RecCount = 0时出错
                           +sFull+'__rnt=parseInt(iRecNo*'+IntToStr(iRowHeight)+')+"px";'   //更新记录指示框位置
                           +'dwevent("","'+sFull+'",(iRecNo+1)*100+99,"onclick",'+IntToStr(TForm(Owner).Handle)+');'
                           +''''
                    + '>');
               //添加显示Hover位置的外框__hov
               joRes.Add('        <div'
                       + ' id="'+sFull+'__hov"'
                       + ' :style="{'
                           +'top:'+sFull+'__hov'
                       +'}"'
                       + ' style="'
                           +'position:absolute;'
                           +'background-color:'+sHover+';'
                           //+'z-index:-2;'
                           +'left:0;'
                           +'width:100%;'
                           +'height:'+IntToStr(iRowHeight)+'px;'
                       +'"' //style 封闭
                       + '></div>');
               //添加显示当前记录位置的外框__row
               joRes.Add('        <div'
                       + ' id="'+sFull+'__row"'
                       + ' :style="{'
                           +'top:'+sFull+'__rnt'
                       +'}"'
                       + ' style="'
                           +'position:absolute;'
                           +'background-color:'+sRecord+';'
                           //+'z-index:-1;'
                           +'left:0;'
                           +'width:100%;'
                           +'height:'+IntToStr(iRowHeight)+'px;'
                       +'"' //style 封闭
                       + '></div>');
               //各字段编辑框及保存/取消
               
               //总编辑框__edt，包括:编辑行框+“保存/取消”
               joRes.Add('        <div'
                       + ' id="'+sFull+'__edt"'    //edt:editor
                       + ' v-if="'+sFull+'__sed"'   //show editor : dgEditing
                       + ' :style="{'
                           +'top:'+sFull+'__rnt'
                       +'}"'
                       + ' style="'
                           +'position:absolute;'
                           //+'background-color:#fff;'
                           +'margin:0 auto;'
                           +'z-index:8;'
                           +'margin-top:1px;'
                           +'left:0;'
                           +'width:100%;'
                           +'height:'+IntToStr(iRowHeight*1-2)+'px;'
                       +'"' //style 封闭
                       + '>');
               //编辑行框__edr,其中为各字段的编辑框
               joRes.Add('        <div'
                       + ' id="'+sFull+'__edr"'    //edt:editor
                       + ' style="'
                           +'position:absolute;'
                           +'background-color:'+sRecord+';'
                           //+'border-radius:5px 5px 0 0;'
                           //+'text-align: right;'
                           +'top:1px;'
                           +'left:0;'
                           +'width:100%;'
                           +'height:'+IntToStr(iRowHeight-3)+'px;'
                       +'"' //style 封闭
                       +' @click=''function(e){'
                               +'e.stopPropagation();'//阻止冒泡
                       +'}'''
                       + '>');
               //添加各字段的编辑框
               for iCol := 0 to joFields._Count -1 do begin
                    joField := joFields._(iCol);
                    //
                    if not joField.Exists('readonly') then begin
                        joField.readonly    := False;
                    end;

                    sCode   := '';

                    //用于生成激活编辑框OnChange的代码sChange
                    //sChange := ' @change=function(e)'
                    //        +'{'
                    //            +sFull+'__fd'+IntToStr(iCol)+'=e;'
                    //            +'dwevent(null,'''+sFull+''',''this.'+sFull+'__fd'+IntToStr(iCol)+''',''oncolumnchange'+IntToStr(iCol)+''','''+IntToStr(TForm(Owner).Handle)+''');'
                    //        +'}';

                    //上面几行暂时无用
                    sChange := ' @change="'+sFull+'__change(e,'+IntToStr(iCol)+')"';

                    if joField.readonly then begin
                         //只读 readonly
                         sCode   := '        <el-input'
                                 +' :readonly="true"'
                                 +' v-model="'+sFull+'__fd'+IntToStr(iCol)+'"'
                                 +' :style="{'
                                     +'left:'+sFull+'__fl'+IntToStr(iCol)+','
                                     +'width:'+sFull+'__fw'+IntToStr(iCol)
                                 +'}"'
                                 +' style="'
                                     +'position:absolute;'
                                     +'text-align:center;'
                         			+'font-size:'+IntToStr(Font.Size+3)+'px;'
                                     +'color:'+dwColor(Font.Color)+';'
                                     +'border-left:1px solid #ececec;'
                                     +'border-right:1px solid #ececec;'
                                     +'top:0;'
                                     +'height:100%;'
                                 +'"'
                                 +'>'
                                 //+'{{'+sFull+'__fd'+IntToStr(iCol)+'}}'
                                 +'</el-input>';
                    //选择框 check
                    end else if joField.type = 'check' then begin
                         sCode   := '        <div'
                                 //+' v-model="'+sFull+'__fd'+IntToStr(iCol)+'"'
                                 +' :style="{'
                                     +'left:'+sFull+'__fl'+IntToStr(iCol)+','
                                     +'width:'+sFull+'__fw'+IntToStr(iCol)
                                     +'}"'
                                 +' style="'
                                     +'position:absolute;'
                         			+'font-size:'+IntToStr(Font.Size+3)+'px;'
                                     +'color:'+dwColor(Font.Color)+';'
                                     +'top:0;'
                                     +'height:100%;'
                                     +'border-left:1px solid #ececec;'
                                     +'border-right:1px solid #ececec;'
                                 +'"'
                                 +' ></div>';
                    //行号列 index
                    end else if joField.type = 'index' then begin
                         sCode   := '        <div'
                                 //+' v-model="'+sFull+'__fd'+IntToStr(iCol)+'"'
                                 +' :style="{'
                                     +'left:'+sFull+'__fl'+IntToStr(iCol)+','
                                     +'width:'+sFull+'__fw'+IntToStr(iCol)
                                     +'}"'
                                 +' style="'
                                     +'position:absolute;'
                         			+'font-size:'+IntToStr(Font.Size+3)+'px;'
                                     +'color:'+dwColor(Font.Color)+';'
                                     +'top:0;'
                                     +'height:100%;'
                                     +'border-left:1px solid #ececec;'
                                     +'border-right:1px solid #ececec;'
                                 +'"'
                                 +' ></div>';
                    //图片 image-----  显示文本编辑框
                    end else if joField.type = 'image' then begin
                         sCode   := '        <el-input'
                                 +' v-model="'+sFull+'__fd'+IntToStr(iCol)+'"'
                                 +' :style="{'
                                     +'left:'+sFull+'__fl'+IntToStr(iCol)+','
                                     +'width:'+sFull+'__fw'+IntToStr(iCol)
                                     +'}"'
                                 +' style="'
                                     +'position:absolute;'
                         			+'font-size:'+IntToStr(Font.Size+3)+'px;'
                                     +'color:'+dwColor(Font.Color)+';'
                                     +'top:0;'
                                     +'height:100%;'
                                     +'text-align:center;'
                                     +'border-left:1px solid #ececec;'
                                     +'border-right:1px solid #ececec;'
                                 +'"'
                                 +sChange
                                 //+' @mouseenter=''DBGrid1__hov=item.t'''
                                 //+' @mouseleave=''DBGrid1__hov="-500px"'''
                                 //+' @click=''DBGrid1__rnt=item.t;'
                                 //        +'dwevent("","'+sFull+'",item.r*100+'+IntToStr(iCol)+',"onclick",'+IntToStr(TForm(Owner).Handle)+');'''
                                 +' ></el-input>';
                    //进度条 progress
                    end else if joField.type = 'progress' then begin
                         sCode   := '        <el-input-number'
                                 +' v-model="'+sFull+'__fd'+IntToStr(iCol)+'"'
                                 +' controls-position="right"'
                                 +dwIIF(joField.Exists('minvalue'),' :min="'+IntToStr(joField.minvalue)+'"','')
                                 +dwIIF(joField.Exists('maxvalue'),' :max="'+IntToStr(joField.maxvalue)+'"','')
                                 +' :style="{'
                                     +'left:'+sFull+'__fl'+IntToStr(iCol)+','
                                     +'width:'+sFull+'__fw'+IntToStr(iCol)
                                     +'}"'
                                 +' style="'
                                     +'position:absolute;'
                         			+'font-size:'+IntToStr(Font.Size+3)+'px;'
                                     +'color:'+dwColor(Font.Color)+';'
                                     +'top:1px;'
                                     +'height:100%;'
                                     +'border-left:1px solid #ececec;'
                                     +'border-right:1px solid #ececec;'
                                 +'"'
                                 +sChange
                                 //+' @mouseenter=''DBGrid1__hov=item.t'''
                                 //+' @mouseleave=''DBGrid1__hov="-500px"'''
                                 //+' @click=''DBGrid1__rnt=item.t;'
                                 //        +'dwevent("","'+sFull+'",item.r*100+'+IntToStr(iCol)+',"onclick",'+IntToStr(TForm(Owner).Handle)+');'''
                                 +'></el-input-number>';
                    //按钮 button
                    end else if joField.type = 'button' then begin
                         sCode   := '        <div'
                                 //+' v-model="'+sFull+'__fd'+IntToStr(iCol)+'"'
                                 +' :style="{'
                                     +'left:'+sFull+'__fl'+IntToStr(iCol)+','
                                     +'width:'+sFull+'__fw'+IntToStr(iCol)
                                     +'}"'
                                 +' style="'
                                     +'position:absolute;'
                         			+'font-size:'+IntToStr(Font.Size+3)+'px;'
                                     +'color:'+dwColor(Font.Color)+';'
                                     +'top:0;'
                                     +'height:100%;'
                                     +'border-left:1px solid #ececec;'
                                     +'border-right:1px solid #ececec;'
                                 +'"'
                                 +' ></div>';
                    //布尔型 boolean
                    end else if joField.type = 'boolean' then begin
                         sCode   := '        <el-switch'
                                 +' v-model="'+sFull+'__fd'+IntToStr(iCol)+'"'
                                 +' :style="{'
                                     +'left:'+sFull+'__fl'+IntToStr(iCol)+','
                                     +'width:'+sFull+'__fw'+IntToStr(iCol)
                                     +'}"'
                                 +' style="'
                                     +'position:absolute;'
                         			+'font-size:'+IntToStr(Font.Size+3)+'px;'
                                     +'color:'+dwColor(Font.Color)+';'
                                     +'top:0;'
                                     +'height:100%;'
                                     +'padding-left:5px;'
                                     +'border-left:1px solid #ececec;'
                                     +'border-right:1px solid #ececec;'
                                 +'"'
                                 +sChange
                                 +' ></el-switch>';
                    //字符串型 string，带列表list
                    end else if (joField.type = 'string') and joField.Exists('list') then begin
                         sCode   := '        <el-select'
                                 +' v-model="'+sFull+'__fd'+IntToStr(iCol)+'"'
                                 //+' filterable'
                                 +' :style="{'
                                     +'left:'+sFull+'__fl'+IntToStr(iCol)+','
                                     +'width:'+sFull+'__fw'+IntToStr(iCol)
                                 +'}"'
                                 +' style="'
                                     +'position:absolute;'
                         			+'font-size:'+IntToStr(Font.Size+3)+'px;'
                                     +'color:'+dwColor(Font.Color)+';'
                                     +'top:0;'
                                     +'height:100%;'
                                     //+'padding-left:5px;'
                                     +'border-left:1px solid #ececec;'
                                     +'border-right:1px solid #ececec;'
                                 +'"'
                                 +sChange
                                 +'>'
                                 +'<el-option v-for="item in '+sFull+'__it'+IntToStr(iCol)+'" :key="item.value" :label="item.value" :value="item.value"/>'
                                 +'</el-select>';
                    //日期型date
                    end else if joField.Exists('type') and (joField.type = 'date') then begin
                         sCode   := '        <el-date-picker'
                                 +' type="date"'
                                 +' :clearable="false"'
                                 +' format="yyyy-MM-dd"'
                                 +' value-format="yyyy-MM-dd"'
                                 +' v-model="'+sFull+'__fd'+IntToStr(iCol)+'"'
                                 +' :style="{'
                                     +'left:'+sFull+'__fl'+IntToStr(iCol)+','
                                     +'width:'+sFull+'__fw'+IntToStr(iCol)
                                 +'}"'
                                 +' style="'
                                     +'position:absolute;'
                         			+'font-size:'+IntToStr(Font.Size+3)+'px;'
                                     +'color:'+dwColor(Font.Color)+';'
                                     +'top:0;'
                                     +'height:100%;'
                                     //+'padding-left:5px;'
                                     +'border-left:1px solid #ececec;'
                                     +'border-right:1px solid #ececec;'
                                 +'"'
                                 +sChange
                                 +'>'
                                 +'</el-date-picker>';
                    //整型 integer
                    end else if joField.type = 'integer' then begin
                         sCode   := '        <el-input-number'
                                 +' v-model="'+sFull+'__fd'+IntToStr(iCol)+'"'
                                 +' controls-position="right"'
                                 //+dwIIF(joField.Exists('minvalue'),' :min="'+IntToStr(joField.minvalue)+'"','')
                                 //+dwIIF(joField.Exists('maxvalue'),' :max="'+IntToStr(joField.maxvalue)+'"','')
                                 +' :style="{'
                                     +'left:'+sFull+'__fl'+IntToStr(iCol)+','
                                     +'width:'+sFull+'__fw'+IntToStr(iCol)
                                     +'}"'
                                 +' style="'
                                     +'position:absolute;'
                         			+'font-size:'+IntToStr(Font.Size+3)+'px;'
                                     +'color:'+dwColor(Font.Color)+';'
                                     +'top:1px;'
                                     +'height:100%;'
                                     +'border-left:1px solid #ececec;'
                                     +'border-right:1px solid #ececec;'
                                 +'"'
                                 +sChange
                                 //+' @mouseenter=''DBGrid1__hov=item.t'''
                                 //+' @mouseleave=''DBGrid1__hov="-500px"'''
                                 //+' @click=''DBGrid1__rnt=item.t;'
                                 //        +'dwevent("","'+sFull+'",item.r*100+'+IntToStr(iCol)+',"onclick",'+IntToStr(TForm(Owner).Handle)+');'''
                                 +'></el-input-number>';
                    end else begin
                         //用于生成激活编辑框OnChange的代码sChange
                         sChange := ' @change=function(e)'
                                 +'{'
                                     +sFull+'__fd'+IntToStr(iCol)+'=e.target.value;'
                                     +'dwevent(null,'''+sFull+''',''this.'+sFull+'__fd'+IntToStr(iCol)+''',''oncolumnchange'+IntToStr(iCol)+''','''+IntToStr(TForm(Owner).Handle)+''');'
                                 +'}';
                         sChange    := '';

                         //其他
                         sCode   := '        <input'
                                 +' v-model="'+sFull+'__fd'+IntToStr(iCol)+'"'
                                 +' :style="{'
                                     +'left:'+sFull+'__fl'+IntToStr(iCol)+','
                                     +'width:'+sFull+'__fw'+IntToStr(iCol)
                                 +'}"'
                                 +' style="'
                                     +'position:absolute;'
                         			+'font-size:'+IntToStr(Font.Size+3)+'px;'
                                     +'color:'+dwColor(Font.Color)+';'
                                     +'text-align:center;'
                                     //+'border-left:1px solid #ececec;'
                                     //+'border-right:1px solid #ececec;'
                                     +'border:0;'
                                     //+'border-bottom:0;'
                                     +'backgroundColor:transparent;'
                                     +'outline:none;'
                                     +'top:0;'
                                     +'height:100%;'
                                 +'"'
                                 +sChange
                                 //+' @mouseenter=''DBGrid1__hov=item.t'''
                                 //+' @mouseleave=''DBGrid1__hov="-500px"'''
                                 //+' @click=''DBGrid1__rnt=item.t;'
                                 //        +'dwevent("","'+sFull+'",item.r*100+'+IntToStr(iCol)+',"onclick",'+IntToStr(TForm(Owner).Handle)+');'''
                                 +' >';
                         //
                         sCode   := sCode+'</input>';
                    end;
                    joRes.Add(sCode);
               end;
               //封闭编辑行__edr
               joRes.Add('        </div>');
               //保存和取消按钮
               //保存按钮
               joRes.Add('        <el-button'
                       + ' type="primary"'    //edt:editor
                       //+' icon="el-icon-check"'
                       + ' :style="{'
                           +'left:'+sFull+'__svl'      //svl : save left
                       +'}"'
                       + ' style="'
                           +'position:absolute;'
                           +'top:5px;'
                           +'width:40px;'
                           +'height:'+IntToStr(iRowHeight-12)+'px;'
                       +'"' //style 封闭
                       +' @click.native="'+sFull+'__save"'
                       + '>保存</el-button>');
               //取消按钮
               joRes.Add('        <el-button'
                       + ' type="primary"'    //edt:editor
                       //+' icon="el-icon-check"'
                       + ' :style="{'
                           +'left:'+sFull+'__cal'      //cal : cancel left
                       +'}"'
                       + ' style="'
                           +'position:absolute;'
                           +'top:5px;'
                           +'width:40px;'
                           +'height:'+IntToStr(iRowHeight-12)+'px;'
                       +'"' //style 封闭
                       +' @click.native="'+sFull+'__cancel"'
                       + '>取消</el-button>');
               //封闭总编辑行框__edt
               joRes.Add('        </div>');
               //添加数据显示外框__dav : data view
               joRes.Add('    <div'
                       +' id="'+sFull+'__dav"' //dav: data view
                       +' v-show="'+sFull+'__dvv"'     //dvv: data view visible
                       +' :style="{'
                           +'height:'+sFull+'__aph'       //aph : Append Height
                       +'}"'
                       +' style="'
                               +'position:absolute;'
                               +'overflow:visible;'
                               //+'background-color:#fff;'
                               //+'z-index:9;'
                               +'left:0;'
                               +'top:0;'
                               +'width:100%;'
                               //+'height:200px;'
                       +'"' //style 封闭
                       + '>');
               //添加各字段数据
               for iCol := 0 to joFields._Count -1 do begin
                    joField := joFields._(iCol);
                    sCode   := '';
                    if joField.Exists('type') and (joField.type = 'check') then begin
                         //选择框
                         sCode   := '        <el-checkbox class="'+sFull+'dwdbgrid0"'
                         		+' v-for="(item,index) in '+lowerCase(sFull)+'__cd'+IntToStr(iCol)+'"'  //cd:ColumnData
                         		//+' :class="{''dwdbgrid1'':index%2 === 1}"'
                         		+' :row="item.r"'
                         		+' :key="index"'
                         		+' v-model="item.c"'
                         		+' :style="{top:item.t,left:item.l,width:item.w,''text-align'':item.align}"'
                         		+' style="position:absolute;"'
                         		+' @change=''function(val){'
                         				//+'this.console.log(item.r);'
                         				+'dwevent("","'+sFull+'",Number(item.r)*100+Number(val),"onsinglecheck",'+IntToStr(TForm(Owner).Handle)+');'
                         		+'}'''
                         		+'></el-checkbox>';
                    //图片
                    end else if joField.Exists('type') and (joField.type = 'image') then begin
                         sCode   := '        <div class="'+sFull+'dwdbgrid0"'
                         		+' v-for="(item,index) in '+lowerCase(sFull)+'__cd'+IntToStr(iCol)+'"' //cd:ColumnData
                         		//+' :class="{''dwdbgrid1'':index%2 === 1}"'
                         		+' :row="item.r"'
                         		//+' :key="index"'
                         		+' :style="{top:item.t,left:item.l,width:item.w,''text-align'':item.align}"'
                         		+' style="position:absolute;text-align:center;'
                         		+'"'
                         		//+' @mouseenter=''DBGrid1__hov=item.t'''
                         		//+' @mouseleave=''DBGrid1__hov="-500px"'''
                         		//+' @click=''DBGrid1__rnt=item.t;'
                         		//        +'dwevent("","'+sFull+'",item.r*100+'+IntToStr(iCol)+',"onclick",'+IntToStr(TForm(Owner).Handle)+');'''
                         		+' >';
                         //添加image
                         sCode   := sCode + '<img :src="item.c" style="vertical-align:middle;' + dwGetDWStyle(joField)+ '"></img>';
                         //
                         sCode   := sCode+'</div>';
                    //进度条
                    end else if joField.Exists('type') and (joField.type = 'progress') then begin
                         sCode   := '        <div class="'+sFull+'dwdbgrid0"'
                         		+' v-for="(item,index) in '+lowerCase(sFull)+'__cd'+IntToStr(iCol)+'"' //cd:ColumnData
                         		//+' :class="{''dwdbgrid1'':index%2 === 1}"'
                         		+' :row="item.r"'
                         		//+' :key="index"'
                         		+' :style="{top:item.t,left:item.l,width:item.w,''text-align'':item.align}"'
                         		+' style="position:absolute;text-align:center;'
                         		+'"'
                         		+' >';
                         //添加
                         sCode   := sCode + '<el-progress'
                         		+' :text-inside="true"'
                         		+' color="#ccc"'    //此处为进度条的前景色，需要的修改这里
                         		+' style="'
                         			+'top:'+IntToStr((iRowHeight-10-22) div 2)+'px;'
                         			+'margin:5px;'
                         		+'"'
                         		+' :stroke-width="24"'
                         		//+' :percentage="item.c"'
                         		+' :percentage="item.c > 100 ? 100 : item.c"'
                         		+' :format="'+sFull+'_format(item.c)"'
                         		+'>'
                         		+'</el-progress>';
                         //
                         sCode   := sCode+'</div>';
                    //按钮
                    end else if joField.Exists('type') and (joField.type = 'button') then begin
                         sCode   := '        <div class="'+sFull+'dwdbgrid0"'
                         		+' v-for="(item,index) in '+lowerCase(sFull)+'__cd'+IntToStr(iCol)+'"' //cd:ColumnData
                         		//+' :class="{''dwdbgrid1'':index%2 === 1}"'
                         		+' :row="item.r"'
                         		//+' :key="index"'
                         		+' :style="{top:item.t,left:item.l,width:item.w,''text-align'':item.align}"'
                         		+' style="position:absolute;text-align:center;'
                         		+'"'
                         		+' >';
                         if joField.Exists('list') then begin
                              for iItem := 0 to joField.list._Count -1 do begin
                                   joButton    := joField.list._(iItem);
                                   sCode   := sCode + '<el-button'
                                   		+' type="'+joButton._(1)+'"'
                                   		+' style="vertical-align:middle;margin:2px;"'
                                   		+' @click=''function(e){'
                                   				+'dwevent("","'+sFull+'",item.r*10000+'+IntToStr(iCol*100+iItem)+',"onbuttonclick",'+IntToStr(TForm(Owner).Handle)+');'
                                   				+'e.stopPropagation();'//阻止冒泡
                                   		+'}'''
                                   		+'>'+joButton._(0)+'</el-button>';
                              end;
                         end;
                         sCode   := sCode+'</div>';
                    end else begin
                         //其他
                         sCode   := '        <div'
                         		+' class="'+sFull+'dwdbgrid0"'
                         		+' v-for="(item,index) in '+lowerCase(sFull)+'__cd'+IntToStr(iCol)+'"' //cd:ColumnData
                         		//+' :class="{''dwdbgrid1'':index%2 === 1}"'
                         		+' :row="item.r"'
                         		+' tabIndex=0'
                         		//+' :key="index"'
                         		+' :style="{top:item.t,left:item.l,width:item.w,''text-align'':item.align,color:item.color,''background-color'':item.bkcolor}"'
                         		+' style="'
                                    +'position:absolute;'
                                    //+'white-space: pre-wrap;'
                                +'"'
                         		//+' @mouseenter=''DBGrid1__hov=item.t'''
                         		//+' @mouseleave=''DBGrid1__hov="-500px"'''
                         		//+' @click=''DBGrid1__rnt=item.t;'
                         		//        +'dwevent("","'+sFull+'",item.r*100+'+IntToStr(iCol)+',"onclick",'+IntToStr(TForm(Owner).Handle)+');'''
                         		+' >{{item.c}}</div>';
                    end;
                    joRes.Add(sCode);
               end;
               //封闭数据外框__dav
               joRes.Add('    </div>');
               //封闭数据外框__dat
               joRes.Add('    </div>');
               //添加汇总
               if iSumCount > 0 then begin
                    joSummary   := joHint.summary;
                    
                    //以下div为汇总区域的总外框
                    joRes.Add('    <div'
                            +' id="'+sFull+'__sum"'
                            + ' :style="{'
                                +'top:'+sFull+'__stp,'      //stp : summary top
                                +'width:'+sFull+'__swd'     //swd : summary width
                            +'}"'
                            + ' style="'
                                    +'position:absolute;'
                                    +'overflow:hidden;'
                                    +'left:0;'
                                    //+'top:'+IntToStr(Height-iSumCount*iRowHeight)+'px;'
                                    +'background-color:'+sHeaderBKC+';'
                                    +'bottom:0px;'
                                    //+'width:100%;'
                                    +'z-index:9;'
                                    +'height:'+IntToStr(iSumCount*iRowHeight)+'px;'
                            +'"' //style 封闭
                            + '>');
                    //显示“汇总”标题
                    joRes.Add('        <div'
                            + ' style="'
                                    +'position:absolute;'
                                    +'overflow:hidden;'
                                    +'left:10px;'
                                    +'top:0;'
                                    +'width:200px;'
                                    +'font-size:'+IntToStr(Font.Size+3)+'px;color:'+dwColor(Font.Color)+';'
                                    +'height:'+IntToStr(iSumCount*iRowHeight)+'px;'
                                    +'line-height:'+IntToStr(iSumCount*iRowHeight)+'px;'
                            +'"' //style 封闭
                            + '>'
                            +joSummary._(0)
                            +'</div>');
                    //生成汇总
                    for iItem := 1 to joSummary._Count -1 do begin
                         joSum   := joSummary._(iItem);
                         //得到需要汇总的序号
                         iSumCol := joSum._(0);
                         if (iSumCol<0) or (iSumCol>=joFields._Count) then begin
                              continue;
                         end;
                         //计算当前列的LEFT
                         iL  := -1;
                         for iCol := 0 to iSumCol -1 do begin
                              joField := joFields._(iCol);
                              iL      := iL + joField.width;
                         end;
                         //计算当前的Top
                         iT  := -2;
                         for iCol := 1 to iItem -1 do begin
                              if joSummary._(iCol)._(0) = iSumCol then begin
                                   iT  := iT + iRowHeight;
                              end;
                         end;
                         iW  := joFields._(iSumCol).width-1;
                         iH  := iRowHeight-1;
                         //显示“汇总”数值
                         joRes.Add('        <div'
                                 +' :style="{'
                                     +'left:'+sFull+'__sl'+IntToStr(iItem)+','   //sum left
                                     +'top:'+sFull+'__st'+IntToStr(iItem)+','    //sum top
                                     +'width:'+sFull+'__sw'+IntToStr(iItem)      //sum width
                                 +'}"'
                                 + ' style="'
                                         +'position:absolute;'
                                         +'overflow:hidden;'
                                         //+'left:'+IntToStr(iL)+'px;'
                                         //+'top:'+IntToStr(iT)+'px;'
                                         //+'width:'+IntToStr(iW)+'px;'
                                         +'height:'+IntToStr(iH)+'px;'
                                         +'line-height:'+IntToStr(iH)+'px;'
                                         +'border:solid 1px #ececec;'
                                         +'text-align:center;'
                                         +'font-size:'+IntToStr(Font.Size+3)+'px;color:'+dwColor(Font.Color)+';'
                                 +'"' //style 封闭
                                 + '>'
                                 +'{{'+sFull+'__sm'+IntToStr(iItem-1)+'}}'
                                 +'</div>');
                         //为当前列显示一个通天地的框，以美观
                         joRes.Add('        <div'
                                 +' :style="{'
                                     +'left:'+sFull+'__sl'+IntToStr(iItem)+','   //sum left
                                     +'width:'+sFull+'__sw'+IntToStr(iItem)      //sum width
                                 +'}"'
                                 + ' style="'
                                         +'position:absolute;'
                                         //+'left:'+IntToStr(iL)+'px;'
                                         +'top:-2px;'
                                         //+'width:'+IntToStr(iW)+'px;'
                                         +'height:100%;'
                                         +'border:solid 1px #ececec;'
                                 +'"' //style 封闭
                                 + '>'
                                 +'</div>');
                    end;
                    //封闭汇总外框
                    joRes.Add('    </div>');
               end;
        end else begin
               //以下为显示纵向单字段样式，主要用于手机显示
               //添加全表的总外框
               joRes.Add('<div'
                       + ' id="'+sFull+'"'
                       + dwLTWH(TControl(ACtrl))
                           + 'overflow:hidden;'
                           + 'border:solid 1px #ececec;'
                           + '-moz-user-select:none;'
                           + '-webkit-user-select:none;'
                           + '-ms-user-select:none;'
                           + 'user-select:none;'
                       + '"' //style 封闭
                       + ' onselectstart="return false"'
                       + '>');
               //得到纵向显示时标题列的宽度，默认为120
               iTitleColW  := 100;
               if joHint.Exists('titlecolwidth') then begin
                    iTitleColW  := joHint.titlecolwidth;
               end;
               //为数据添加一个外框，用于统一处理点击事件
               joRes.Add('    <div'
                       + ' style="'
                               +'position:absolute;'
                               +'overflow:hidden;'
                               +'left:0;'
                               +'top:0px;'
                               +'width:'+IntToStr(width)+'px;'
                               +'height:'+IntToStr(Height)+'px;'
                       +'"' //style 封闭
                       +' @mouseover=''function(e){'
                               +'var iRecNo=parseInt((Math.abs(e.offsetY)+e.target.offsetTop)/'+IntToStr(iRowHeight*(1+joFields._Count))+');'//转化为记录No,从
                               +'iRecNo=Math.min('+sFull+'__rcc-1,iRecNo);'                           //避免超记录
                               //+'this.console.log(iRecNo);'
                               //+'this.console.log(e);'
                               +sFull+'__hov=parseInt(iRecNo*'+IntToStr(iRowHeight)+')+"px";'   //更新记录指示框位置
                               //+'dwevent("","'+sFull+'",(iRecNo+1)*100+99,"onclick",'+IntToStr(TForm(Owner).Handle)+');'
                       +'}'''
                       +' @mouseleave=''function(e){'
                               //+'this.console.log(e);'
                               +sFull+'__hov="-500px";'   //更新记录指示框位置
                       +'}'''
               
               
                       +' @click=''function(e){'
                               //+'this.console.log(e);'
                               +'var iRecNo=parseInt((Math.abs(e.offsetY)+e.target.offsetTop)/'+IntToStr(iRowHeight*(1+joFields._Count))+');'//转化为记录No,从0开始
                               //+'var iRecNo=parseInt((e.offsetY+e.target.offsetTop)/'+IntToStr(iRowHeight)+');'//转化为记录No,从0开始
                               +'iRecNo=Math.min('+sFull+'__rcc-1,iRecNo);'                           //避免超记录
                               //+'this.console.log(iRecNo);'
                               //+'this.alert(iRecNo);'
                               //+sFull+'__rnt=parseInt(iRecNo*'+IntToStr((joFields._Count+1)*iRowHeight)+')+"px";'   //更新记录指示框位置
                               +'dwevent("","'+sFull+'",(iRecNo+1)*100+99,"onclick",'+IntToStr(TForm(Owner).Handle)+');'
                       +'}'''
               
               
                       + ' @dblclick='''
                           //+'this.alert("dblclick");'
                           //+'this.console.log("dblclick");'
                           +'dwevent("","'+sFull+'","0","ondblclick",'+IntToStr(TForm(Owner).Handle)+');'
                       +''''
               
                       +' @keydown.up='''
                               +sFull+'__hov="-500px";'                 //隐藏Hover框
                               +'var iRecNo=parseInt('+sFull+'__rnt);'  //取得当前记录指示框的top
                               +'iRecNo=Math.round(iRecNo/'+IntToStr(iRowHeight)+');'  //转化为记录No,从0开始
                               +'iRecNo=Math.max(0,iRecNo-1);'                         //记录No-1
                               +sFull+'__rnt=parseInt(iRecNo*'+IntToStr(iRowHeight)+')+"px";'   //更新记录指示框位置
                               +'dwevent("","'+sFull+'",(iRecNo+1)*100+99,"onclick",'+IntToStr(TForm(Owner).Handle)+');'
                       +''''
                       +' @keydown.down='''
                               +sFull+'__hov="-500px";'                 //隐藏Hover框
                               +'var iRecNo=parseInt('+sFull+'__rnt);'  //取得当前记录指示框的top
                               +'iRecNo=Math.round(iRecNo/'+IntToStr(iRowHeight)+');'  //转化为记录No,从0开始
                               +'iRecNo=Math.min('+IntToStr(iRecCount-1)+',iRecNo+1);' //记录No+1
                               +'iRecNo=Math.max(0,iRecNo);'                           //避免RecCount = 0时出错
                               +sFull+'__rnt=parseInt(iRecNo*'+IntToStr(iRowHeight)+')+"px";'   //更新记录指示框位置
                               +'dwevent("","'+sFull+'",(iRecNo+1)*100+99,"onclick",'+IntToStr(TForm(Owner).Handle)+');'
                       +''''
                       + '>');
               
               
               //添加显示当前记录位置的外框
               joRes.Add('        <div'
                       + ' id="'+sFull+'__row"'
                       + ' :style="{'
                           +'top:'+sFull+'__rnt'
                       +'}"'
                       + ' style="'
                           +'position:absolute;'
                           +'background-color:'+sRecord+';'
                           //+'border-radius:5px;'
                           +'left:0px;'
                           +'width:100%;'
                           //+'border:solid 1px #ececec;'
                           +'height:'+IntToStr(iRowHeight*joFields._Count-1)+'px;'
                       +'"' //style 封闭
                       + '>');
               //添加编辑框，其中包括多个字段的编辑器
               joRes.Add('        <div'
                       + ' id="'+sFull+'__edt"'    //edt:editor
                       + ' v-if="'+sFull+'__sed"'   //show editor : dgEditing
                       //+ ' :style="{'
                       //    +'left:'+sFull+'__fl0,'
                       //    +'top:'+sFull+'__rnt,'
                       //    +'width:'+sFull+'__fw0'
                       //+'}"'
                       + ' style="'
                           +'position:absolute;'
                           +'background-color:'+sRecord+';'
                           //+'margin:0 auto;'
                           +'z-index:8;'
                           //+'margin-top:1px;'
                           +'left:'+IntToStr(iTitleColW)+'px;'
                           +'width:'+IntToStr(Width-iTitleColW)+'px;'
                           +'height:'+IntToStr(iRowHeight*joFields._Count-1)+'px;'
                       +'"' //style 封闭
                       +' @click=''function(e){'
                               +'e.stopPropagation();'//阻止冒泡
                       +'}'''
                       + '>');
               //添加数据
               for iCol := 0 to joFields._Count -1 do begin
                    joField := joFields._(iCol);
                    sCode   := '';
                    if joField.readonly then begin
                         sCode   := '        <el-input'
                                 +' :readonly="true"'
                                 +' v-model="'+sFull+'__fd'+IntToStr(iCol)+'"'
                                 //+' :style="{'
                                 //+'}"'
                                 +' style="'
                                     +'position:absolute;'
                                     +'left:0;'
                                     +'top:'+IntToStr(iCol*iRowHeight)+'px;'
                                     +'width:100%;'
                                     +'height:'+IntToStr(iRowHeight-1)+'px;'
                                     +'border:1px solid #ececec;'
                                 +'"'
                                 +' >'
                                 +'</el-input>';
                    //选择框
                    end else if joField.Exists('type') and (joField.type = 'check') then begin
                         sCode   := '        <div'
                                 //+' v-model="'+sFull+'__fd'+IntToStr(iCol)+'"'
                                 //+' :style="{'
                                 //+'}"'
                                 +' style="'
                                     +'position:absolute;'
                                     +'left:0;'
                                     +'top:'+IntToStr(iCol*iRowHeight)+'px;'
                                     +'width:100%;'
                                     +'height:'+IntToStr(iRowHeight-1)+'px;'
                                     +'border:1px solid #ececec;'
                                 +'"'
                                 +' ></div>';
                    //行号列
                    end else if joField.Exists('type') and (joField.type = 'index') then begin
                         sCode   := '        <div'
                                 //+' v-model="'+sFull+'__fd'+IntToStr(iCol)+'"'
                                 //+' :style="{'
                                 //+'}"'
                                 +' style="'
                                     +'position:absolute;'
                                     +'left:0;'
                                     +'top:'+IntToStr(iCol*iRowHeight)+'px;'
                                     +'width:100%;'
                                     +'height:'+IntToStr(iRowHeight-1)+'px;'
                                     +'border:1px solid #ececec;'
                                 +'"'
                                 +' ></div>';
                    //图片-----  显示文本编辑框
                    end else if joField.Exists('type') and (joField.type = 'image') then begin
                         sCode   := '        <el-input'
                                 +' v-model="'+sFull+'__fd'+IntToStr(iCol)+'"'
                                 //+' :style="{'
                                 //+'}"'
                                 +' style="'
                                     +'position:absolute;'
                                     +'left:0;'
                                     +'top:'+IntToStr(iCol*iRowHeight)+'px;'
                                     +'width:100%;'
                                     +'height:'+IntToStr(iRowHeight-1)+'px;'
                                     +'border:1px solid #ececec;'
                                 +'"'
                                 //+' @mouseenter=''DBGrid1__hov=item.t'''
                                 //+' @mouseleave=''DBGrid1__hov="-500px"'''
                                 //+' @click=''DBGrid1__rnt=item.t;'
                                 //        +'dwevent("","'+sFull+'",item.r*100+'+IntToStr(iCol)+',"onclick",'+IntToStr(TForm(Owner).Handle)+');'''
                                 +' ></el-input>';
                    //进度条
                    end else if joField.Exists('type') and (joField.type = 'progress') then begin
                         sCode   := '        <el-input-number'
                                 +' v-model="'+sFull+'__fd'+IntToStr(iCol)+'"'
                                 +dwIIF(joField.Exists('minvalue'),' :min="'+IntToStr(joField.minvalue)+'"','')
                                 +dwIIF(joField.Exists('maxvalue'),' :max="'+IntToStr(joField.maxvalue)+'"','')
                                 //+' :style="{'
                                 //+'}"'
                                 +' style="'
                                     +'position:absolute;'
                                     +'left:0;'
                                     +'top:'+IntToStr(iCol*iRowHeight)+'px;'
                                     +'width:100%;'
                                     +'height:'+IntToStr(iRowHeight-1)+'px;'
                                     //+'padding-left:5px;'
                                     //+'padding-right:5px;'
                                     +'border:1px solid #ececec;'
                                 +'"'
                                 //+' @mouseenter=''DBGrid1__hov=item.t'''
                                 //+' @mouseleave=''DBGrid1__hov="-500px"'''
                                 //+' @click=''DBGrid1__rnt=item.t;'
                                 //        +'dwevent("","'+sFull+'",item.r*100+'+IntToStr(iCol)+',"onclick",'+IntToStr(TForm(Owner).Handle)+');'''
                                 +'></el-input-number>';
                    //按钮
                    end else if joField.Exists('type') and (joField.type = 'button') then begin
                         sCode   := '        <div'
                                 //+' v-model="'+sFull+'__fd'+IntToStr(iCol)+'"'
                                 //+' :style="{'
                                 //+'}"'
                                 +' style="'
                                     +'position:absolute;'
                                     +'left:0;'
                                     +'top:'+IntToStr(iCol*iRowHeight)+'px;'
                                     +'width:100%;'
                                     +'height:'+IntToStr(iRowHeight-1)+'px;'
                                     +'border:1px solid #ececec;'
                                 +'"'
                                 +' ></div>';
                    //布尔型
                    end else if joField.Exists('type') and (joField.type = 'boolean') then begin
                         sCode   := '        <el-switch'
                                 +' v-model="'+sFull+'__fd'+IntToStr(iCol)+'"'
                                 //+' :style="{'
                                 //+'}"'
                                 +' style="'
                                     +'position:absolute;'
                                     +'left:0;'
                                     +'top:'+IntToStr(iCol*iRowHeight)+'px;'
                                     +'padding-left:5px;'
                                     +'width:100%;'
                                     +'height:'+IntToStr(iRowHeight-1)+'px;'
                                     +'border:1px solid #ececec;'
                                 +'"'
                                 +' ></el-switch>';
                    //字符串型，带列表
                    end else if joField.Exists('type') and (joField.type = 'string') and joField.Exists('list') then begin
                         sCode   := '        <el-select'
                                 +' v-model="'+sFull+'__fd'+IntToStr(iCol)+'"'
                                 //+' filterable'
                                 //+' :style="{'
                                 //+'}"'
                                 +' style="'
                                     +'position:absolute;'
                                     +'left:0;'
                                     +'top:'+IntToStr(iCol*iRowHeight)+'px;'
                                     +'width:100%;'
                                     +'height:'+IntToStr(iRowHeight-1)+'px;'
                                     +'border:1px solid #ececec;'
                                 +'"'
                                 +'>'
                                 +'<el-option v-for="item in '+sFull+'__it'+IntToStr(iCol)+'" :key="item.value" :label="item.value" :value="item.value"/>'
                                 +'</el-select>';
                    //日期型
                    end else if joField.Exists('type') and (joField.type = 'date') then begin
                         sCode   := '        <el-date-picker'
                                 +' type="date"'
                                 +' :clearable="false"'
                                 +' format="yyyy-MM-dd"'
                                 +' value-format="yyyy-MM-dd"'
                                 +' v-model="'+sFull+'__fd'+IntToStr(iCol)+'"'
                                 //+' :style="{'
                                 //+'}"'
                                 +' style="'
                                     +'position:absolute;'
                                     +'left:0;'
                                     +'top:'+IntToStr(iCol*iRowHeight)+'px;'
                                     +'width:100%;'
                                     +'height:'+IntToStr(iRowHeight-1)+'px;'
                                     +'border:1px solid #ececec;'
                                 +'"'
                                 +'>'
                                 +'</el-date-picker>';
                    end else begin
                         //其他
                         sCode   := '        <el-input'
                                 +' v-model="'+sFull+'__fd'+IntToStr(iCol)+'"'
                                 //+' :style="{'
                                 //+'}"'
                                 +' style="'
                                     +'position:absolute;'
                                     +'left:0;'
                                     +'top:'+IntToStr(iCol*iRowHeight)+'px;'
                                     +'width:100%;'
                                     +'height:'+IntToStr(iRowHeight-1)+'px;'
                                     +'border:1px solid #ececec;'
                                 +'"'
                                 //+' @mouseenter=''DBGrid1__hov=item.t'''
                                 //+' @mouseleave=''DBGrid1__hov="-500px"'''
                                 //+' @click=''DBGrid1__rnt=item.t;'
                                 //        +'dwevent("","'+sFull+'",item.r*100+'+IntToStr(iCol)+',"onclick",'+IntToStr(TForm(Owner).Handle)+');'''
                                 +' >';
                         //
                         sCode   := sCode+'</el-input>';
                    end;
                    if sCode <>'' then begin
                         joRes.Add(sCode);
                    end;
               end;
               //保存按钮
               joRes.Add('        <el-button'
                       +' type="primary"'    //edt:editor
                       +' icon="el-icon-check"'
                       //+ ' :style="{'
                       //+'}"'
                       + ' style="'
                           +'position:absolute;'
                           +'top:5px;'
                           +'left:'+IntToStr(Width-iTitleColW-55)+'px;'
                           +'width:40px;'
                           +'height:30px;'
                       +'"' //style 封闭
                       +' @click.native="'+sFull+'__save"'
                       + '></el-button>');
               //编辑行封闭
               joRes.Add('</div>');
               //当前记录所在行封闭
               joRes.Add('</div>');
               for iCol := 0 to joFields._Count -1 do begin
                    joField := joFields._(iCol);
                    //添加左边的标题列
                    if joField.Exists('caption') then begin
                         sCode   := '        <div'
                                 +' class="'+sFull+'dwdbgrid0"'
                                 +' v-for="(item,index) in '+lowerCase(sFull)+'__cd'+IntToStr(iCol)+'"' //ct:ColumnTitle
                                 +' :row="item.r"'
                                 +' tabIndex=0'
                                 //+' :key="index"'
                                 +' :style="{top:item.t}"'
                                 +' style="position:absolute;left:-1px;width:'+IntToStr(iTitleColW-10)+'px;"'
                                 +' >'+joField.caption+'</div>';
                    end else begin
                         sCode   := '        <div'
                                 +' class="'+sFull+'dwdbgrid0"'
                                 +' v-for="(item,index) in '+lowerCase(sFull)+'__cd'+IntToStr(iCol)+'"' //ct:ColumnTitle
                                 +' :row="item.r"'
                                 +' tabIndex=0'
                                 //+' :key="index"'
                                 +' :style="{top:item.t}"'
                                 +' style="position:absolute;left:-1px;width:'+IntToStr(iTitleColW-10)+'px;"'
                                 +' ></div>';
                    end;
                    joRes.Add(sCode);
                    //添加右边的数值列  选择框
                    if joField.Exists('type') and (joField.type = 'check') then begin
                         sCode   := '        <el-checkbox'
                                 +' class="'+sFull+'dwdbgrid0"'
                                 +' @click.stop'
                                 +' v-for="(item,index) in '+lowerCase(sFull)+'__cd'+IntToStr(iCol)+'"'  //cd:ColumnData
                                 //+' :class="{''dwdbgrid1'':index%2 === 1}"'
                                 +' :row="item.r"'
                                 +' :key="index"'
                                 +' v-model="item.c"'
                                 +' :style="{top:item.t}"'
                                 +' style="position:absolute;left:'+IntToStr(iTitleColW)+'px;width:'+IntToStr(Width-iTitleColW)+'px;"'
                                 +' @click.stop.native=''function(val){'
                                         //+'this.console.log("val");'
                                         //+'dwevent("","'+sFull+'",Number(item.r)*100+Number(val),"onsinglecheck",'+IntToStr(TForm(Owner).Handle)+');'
                                         //+'val.preventDefault();'
                                 +'}'''
                                 +' @change=''function(val){'
                                         //+'this.console.log(val);'
                                         +'dwevent("","'+sFull+'",Number(item.r)*100+Number(val),"onsinglecheck",'+IntToStr(TForm(Owner).Handle)+');'
                                         //+'val.preventDefault();'
                                 +'}'''
                                 +'></el-checkbox>';
                    //图片
                    end else if joField.Exists('type') and (joField.type = 'image') then begin
                         sCode   := '        <div class="'+sFull+'dwdbgrid0"'
                                 +' v-for="(item,index) in '+lowerCase(sFull)+'__cd'+IntToStr(iCol)+'"' //cd:ColumnData
                                 //+' :class="{''dwdbgrid1'':index%2 === 1}"'
                                 +' :row="item.r"'
                                 //+' :key="index"'
                                 +' :style="{top:item.t}"'
                                 +' style="position:absolute;left:'+IntToStr(iTitleColW)+'px;width:'+IntToStr(Width-iTitleColW)+'px;"'
                                 +' >';
                         //添加image
                         sCode   := sCode + '<img :src="item.c" style="vertical-align:middle;' + dwGetDWStyle(joField)+ '"></img>';
                         //
                         sCode   := sCode+'</div>';
                    //进度条
                    end else if joField.Exists('type') and (joField.type = 'progress') then begin
                         sCode   := '        <div class="'+sFull+'dwdbgrid0"'
                                 +' v-for="(item,index) in '+lowerCase(sFull)+'__cd'+IntToStr(iCol)+'"' //cd:ColumnData
                                 //+' :class="{''dwdbgrid1'':index%2 === 1}"'
                                 +' :row="item.r"'
                                 //+' :key="index"'
                                 +' :style="{top:item.t}"'
                                 +' style="position:absolute;padding:0;left:'+IntToStr(iTitleColW)+'px;width:'+IntToStr(Width-iTitleColW)+'px;"'
                                 +' >';
                         //添加image
                         sCode   := sCode + '<el-progress :text-inside="true" color="#ccc" style="top:'+IntToStr((iRowHeight-10-22) div 2)+'px;margin:5px;" :stroke-width="24" :percentage="item.c"></el-progress>';
                         //
                         sCode   := sCode+'</div>';
                    //按钮
                    end else if joField.Exists('type') and (joField.type = 'button') then begin
                         sCode   := '        <div class="'+sFull+'dwdbgrid0"'
                                 +' v-for="(item,index) in '+lowerCase(sFull)+'__cd'+IntToStr(iCol)+'"' //cd:ColumnData
                                 //+' :class="{''dwdbgrid1'':index%2 === 1}"'
                                 +' :row="item.r"'
                                 //+' :key="index"'
                                 +' :style="{top:item.t}"'
                                 +' style="position:absolute;padding:0;left:'+IntToStr(iTitleColW)+'px;width:'+IntToStr(Width-iTitleColW)+'px;"'
                                 +' >';
                         //添加buttons
                         if joField.Exists('list') then begin
                              for iItem := 0 to joField.list._Count -1 do begin
                                   joButton    := joField.list._(iItem);
                                   sCode   := sCode + '<el-button type="'+joButton._(1)+'" style="vertical-align:middle;margin:2px;"'
                                           +' @click=''dwevent("","'+sFull+'",item.r*10000+'+IntToStr(iCol*100+iItem)+',"onbuttonclick",'+IntToStr(TForm(Owner).Handle)+');'''
                                           +'>'+joButton._(0)+'</el-button>';
                              end;
                         end;
                         sCode   := sCode+'</div>';
                    end else begin
                         //其他
                         sCode   := '        <div'
                                 +' class="'+sFull+'dwdbgrid0"'
                                 +' v-for="(item,index) in '+lowerCase(sFull)+'__cd'+IntToStr(iCol)+'"' //cd:ColumnData
                                +' :row="item.r"'
                                 +' tabIndex=0'
                                 //+' :key="index"'
                                 +' :style="{top:item.t}"'
                                 +' style="position:absolute;left:'+IntToStr(iTitleColW)+'px;width:'+IntToStr(Width-iTitleColW)+'px;"'
                                 +' >{{item.c}}</div>';
                    end;
                    joRes.Add(sCode);
            end;
            //封闭数据外框
            joRes.Add('    </div>');
        end;
    end;
    //返回值
    Result := (joRes);
end;

//[ww_end][gethead]

//取得HTML尾部消息
function dwGetTail(ACtrl: TComponent): string; stdcall;
var
    joRes       : Variant;
    oDataSet    : TDataSet;
    joHint      : Variant;
begin
    //生成返回值数组
    joRes := _Json('[]');

    //取得HINT对象joHint
    joHint := dwGetHintJson(TControl(ACtrl));

    with TListView(ACtrl) do begin
        oDataSet    := nil;
        if joHint.Exists('dataset') then begin
            oDataSet    := TDataSet(Owner.FindComponent(joHint.dataset));
        end;
        if oDataSet = nil then begin
            Result := (joRes);
            Exit;
        end;
    end;
    //生成返回值数组
    //joRes.Add('    </el-table>');
    joRes.Add('</div>');

    Result := (joRes);

end;


//取得Data
function dwGetData(ACtrl: TControl): string; stdcall;
var
    iRow, iCol  : Integer;
    iItem       : Integer;
    iSum        : Integer;
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

    //
    sCode       : string;
    sFull       : string;
    sCols       : string;
    sHover      : string;
    sRecord     : string;
    sField      : string;
    //
    fValue      : Double;
    fValues     : array of Double;
    //
    joHint      : Variant;
    joRes       : Variant;
    joFields    : Variant;
    joField     : Variant;
    joColDatas  : array of Variant;
    joValue     : Variant;
    joSummary   : variant;
    joSum       : variant;
    joSItem     : variant;
    joItem      : variant;
    joItems     : variant;
    //
    oDataSet    : TDataSet;
    oBookMark   : TBookMark;
    oAfter      : Procedure(DataSet: TDataSet) of Object;
    oBefore     : Procedure(DataSet: TDataSet) of Object;
begin
    //生成返回值数组
    joRes := _Json('[]');

    //
    sFull   := dwFullName(ACtrl);

    with TListView(ACtrl) do begin

        //取得HINT对象JSON
        joHint := dwGetHintJson(TControl(ACtrl));

        //取得字段数组对象
        joFields    := _GetFields(TListView(ACtrl));

        //总记录数
        iRecCount   := 0;

        //汇总
        if not joHint.Exists('summary') then begin
            joHint.summary  := _json('[]');
        end;

        //得到汇总栏的行数(所有汇总的最大行数)
        joSummary   := joHint.summary;
        iSumCount   := 0;
        for iSum := 1 to joSummary._Count - 1 do begin     //joSummary的第一个项为标题，所以从1开始查找
            joSum   := joHint.summary._(iSum);
            iCount  := 1;
            //
            for iItem := 1 to iSum-1 do begin
                if joHint.summary._(iSum)._(0) = joHint.summary._(iItem)._(0) then begin
                    iCount  := iCount + 1;
                end;
            end;
            //
            iSumCount   := Max(iSumCount,iCount);
        end;

        //取得数据集，备用
        oDataSet    := nil;
        if joHint.Exists('dataset') then begin
            oDataSet    := TDataSet(Owner.FindComponent(joHint.dataset));
        end;
        if oDataSet = nil then begin
            Exit;
        end;

        //添加基本数据
        joRes.Add(sFull + '__lef:"' + IntToStr(Left) + 'px",');
        joRes.Add(sFull + '__top:"' + IntToStr(Top) + 'px",');
        joRes.Add(sFull + '__wid:"' + IntToStr(Width) + 'px",');
        joRes.Add(sFull + '__hei:"' + IntToStr(Height) + 'px",');
        //添加因Border而需要修正的数据
        joRes.Add(sFull + '__leb:"' + IntToStr(Left+1) + 'px",');
        joRes.Add(sFull + '__tob:"' + IntToStr(Top+1) + 'px",');
        joRes.Add(sFull + '__wib:"' + IntToStr(Width-2) + 'px",');
        joRes.Add(sFull + '__heb:"' + IntToStr(Height-2) + 'px",');
        //
        joRes.Add(sFull + '__vis:' + dwIIF(Visible, 'true,', 'false,'));
        joRes.Add(sFull + '__dis:' + dwIIF(Enabled, 'false,', 'true,'));
        //columntitles
        //joRes.Add(sFull + '__cts:'+VariantSaveJSON(_GetColumnTitles(TListView(ACtrl))) + ',');
        //show editor
        joRes.Add(sFull + '__sed:'+dwIIF(ReadOnly,'false','true')+',');
        //record no top
        joRes.Add(sFull + '__rnt:"0px",');
        joRes.Add(sFull + '__hov:"-500px",');
        //title top
        joRes.Add(sFull + '__ttp:"0px",');
        //save / cancel div left
        joRes.Add(sFull + '__svl:"' + IntToStr(Width-115) + 'px",');
        joRes.Add(sFull + '__cal:"' + IntToStr(Width-73) + 'px",');
        //data view visible
        joRes.Add(sFull + '__dvv:true,');

        //默认值
        iMax      := 1;
        iHeaderH  := 40;

        //取得数据集
        if oDataSet <> nil then begin
            //总记录数
            iRecCount   := oDataSet.RecordCount;

            //取得表头的字符串
            sCols   := '';
            _CreateColumnsHtml(TListView(ACtrl),joFields,iMax,iHeaderH,iRowHeight,sCols,sHover,sRecord);

            //sct,用于生垂直滚动条的div的top
            joRes.Add(sFull + '__sct:"' + IntToStr(3 + iMax*iHeaderH + iRecCount*iRowHeight + iSumCount*iRowHeight) + 'px",');

            //写各字段的left/width和数据,用于显示编辑框
            for iCol := 0 to joFields._Count-1 do begin
                joField := joFields._(iCol);
                //fl:field left
                joRes.Add(sFull + '__fl'+IntToStr(iCol)+':"'+IntToStr(joField.left) + 'px",');
                //fw:field width
                if joField.Exists('type') and (joField.type='boolean') then begin
                    joRes.Add(sFull + '__fw'+IntToStr(iCol)+':"'+IntToStr(joField.viewwidth-1-5) + 'px",');
                end else begin
                    joRes.Add(sFull + '__fw'+IntToStr(iCol)+':"'+IntToStr(joField.viewwidth-1) + 'px",');
                end;
                //fd : field data
                if joField.fieldname<>'' then begin
                    if joField.Exists('type') and (joField.type='boolean') then begin
                        joRes.Add(sFull + '__fd'+IntToStr(iCol)+':'+dwIIF(oDataSet.FieldByName(joField.fieldname).AsBoolean,'true','false')+',');
                    end else if joField.Exists('type') and (joField.type='date') then begin
                        joRes.Add(sFull + '__fd'+IntToStr(iCol)+':"'+FormatDateTime('YYYY-MM-DD',oDataSet.FieldByName(joField.fieldname).AsDateTime)+'",');
                    end else begin
                        joRes.Add(sFull + '__fd'+IntToStr(iCol)+':"'+oDataSet.FieldByName(joField.fieldname).AsString+'",');
                    end;
                    //
                    if joField.Exists('type') and (joField.type = 'string') and joField.Exists('list')then begin
                        joItems := _json('[]');
                        for iItem := 0 to joField.list._Count-1 do begin
                            joItem  := _json('{}');
                            joItem.value    := joField.list._(iItem);
                            joItems.Add(joItem);
                        end;
                        joRes.Add(sFull + '__it'+IntToStr(iCol)+':'+VariantSaveJSON(joItems)+',');
                    end;

                end else begin
                    //return empty data
                    joRes.Add(sFull + '__fd'+IntToStr(iCol)+':"",');
                end;
            end;

            //保存当前位置
            oBookMark := oDataSet.GetBookmark;

            oDataSet.DisableControls;

            //保存原事件函数
            oAfter  := oDataSet.AfterScroll;
            oBefore := oDataSet.BeforeScroll;
            //清空事件
            oDataSet.AfterScroll    := nil;
            oDataSet.BeforeScroll   := nil;

            //<生成数据
            //初始数据
            SetLength(joColDatas,Integer(joFields._Count));
            for iCol := 0 to joFields._Count-1 do begin
                joColDatas[iCol]    := _json('[]');
            end;

            //汇总数据
            if not joHint.Exists('summary') then begin
                joHint.summary  := _json('[]');
            end;
            joSummary   := joHint.summary;
            if joSummary._count > 1 then begin
                SetLength(fValues,Integer(joSummary._Count)-1);
            end else begin
                SetLength(fValues,0);
            end;

            //
            oDataSet.First;
            iRow := 0;
            while not oDataSet.Eof do begin
                for iCol := 0 to joFields._Count-1 do begin
                    if Ctl3D then begin
                        joField := joFields._(iCol);

                        //得到各值的LTWH/row
                        joValue         := _json('{}');
                        joValue.l       := IntToStr(joField.left)+'px';
                        joValue.h       := IntToStr(iRowHeight)+'px';        //暂时没用
                        joValue.t       := IntToStr(oDataSet.RecNo * iRowHeight - iRowHeight)+'px';
                        joValue.w       := IntToStr(joField.viewwidth-10-1)+'px';  //-10是因为padding:5px
                        joValue.align   := joField.align;
                        joValue.color   := joField.color;
                        joValue.bkcolor := joField.bkcolor;
                        joValue.r       := oDataSet.RecNo;

                        //根据类型进行处理
                        if joField.Exists('type') and (joField.type = 'check') then begin
                            joValue.c   := false;
                        end else if joField.Exists('type') and (joField.type = 'index') then begin
                            joValue.c   := IntToStr(oDataSet.RecNo);
                        end else if joField.Exists('type') and (joField.type = 'boolean') then begin
                            if joField.Exists('list') then begin
                                if oDataSet.FieldByName(joField.fieldname).AsBoolean then begin
                                    joValue.c   := joField.list._(0);
                                end else begin
                                    joValue.c   := joField.list._(1);
                                end;
                            end else begin
                                joValue.c   := oDataSet.FieldByName(joField.fieldname).AsString;
                            end;
                        end else if joField.Exists('type') and (joField.type = 'date') then begin
                            if joField.Exists('format') then begin
                                joValue.c   := FormatDateTime(joField.format,oDataSet.FieldByName(joField.fieldname).AsDateTime);
                            end else begin
                                joValue.c   := FormatDateTime('yyyy-MM-dd',oDataSet.FieldByName(joField.fieldname).AsDateTime);
                            end;
                        end else if joField.Exists('type') and (joField.type = 'image') then begin
                            joValue.c   := Format(joField.format,[oDataSet.FieldByName(joField.fieldname).AsString]);
                        end else if joField.Exists('type') and (joField.type = 'progress') then begin
                            joValue.c   := Round(100*oDataSet.FieldByName(joField.fieldname).AsFloat / joField.total);
                        end else if joField.Exists('type') and (joField.type = 'button') then begin
                            joValue.c   := 'AAA';
                        end else if joField.Exists('type') and (joField.type = 'float') then begin
                            if joField.Exists('format') then begin
                                joValue.c   := Format(joField.format,[oDataSet.FieldByName(joField.fieldname).AsFloat]);
                            end else begin
                                joValue.c   := oDataSet.FieldByName(joField.fieldname).AsString;
                            end;
                        end else begin
                            if joField.fieldname <> '' then begin
                                joValue.c   := oDataSet.FieldByName(joField.fieldname).AsString;
                            end else begin
                                joValue.c   := '';
                            end;
                        end;
                        //
                        joColDatas[iCol].Add(joValue);
                    end else begin
                        //=================纵向单列显示=========================================
                        joField := joFields._(iCol);

                        //得到各值的LTWH/row
                        joValue     := _json('{}');
                        joValue.h   := IntToStr(iRowHeight)+'px';
                        joValue.t   := IntToStr(iRow * (iRowHeight*(joFields._Count+1)) + iCol*iRowHeight)+'px';
                        joValue.r   := oDataSet.RecNo;

                        //根据类型进行处理
                        if joField.Exists('type') and (joField.type = 'check') then begin
                            joValue.c   := false;
                        end else if joField.Exists('type') and (joField.type = 'index') then begin
                            joValue.c   := IntToStr(oDataSet.RecNo);
                        end else if joField.Exists('type') and (joField.type = 'boolean') then begin
                            if joField.Exists('list') then begin
                                if oDataSet.FieldByName(joField.fieldname).AsBoolean then begin
                                    joValue.c   := joField.list._(0);
                                end else begin
                                    joValue.c   := joField.list._(1);
                                end;
                            end else begin
                                joValue.c   := oDataSet.FieldByName(joField.fieldname).AsString;
                            end;
                        end else if joField.Exists('type') and (joField.type = 'date') then begin
                            if joField.Exists('format') then begin
                                joValue.c   := FormatDateTime(joField.format,oDataSet.FieldByName(joField.fieldname).AsDateTime);
                            end else begin
                                joValue.c   := FormatDateTime('yyyy-MM-dd',oDataSet.FieldByName(joField.fieldname).AsDateTime);
                            end;
                        end else if joField.Exists('type') and (joField.type = 'image') then begin
                            joValue.c   := Format(joField.format,[oDataSet.FieldByName(joField.fieldname).AsString]);
                        end else if joField.Exists('type') and (joField.type = 'progress') then begin
                            joValue.c   := Round(100*oDataSet.FieldByName(joField.fieldname).AsFloat / joField.total);
                        end else if joField.Exists('type') and (joField.type = 'button') then begin
                            joValue.c   := 'AAA';
                        end else begin
                            if joField.fieldname <> '' then begin
                                joValue.c   := oDataSet.FieldByName(joField.fieldname).AsString;
                            end else begin
                                joValue.c   := '';
                            end;
                        end;
                        //
                        joColDatas[iCol].Add(joValue);

                    end;
                end;

                //计算汇总
                for iSum := 1 to joSummary._Count-1 do begin
                    //得到汇总子对象
                    joSItem := joSummary._(iSum);
                    //汇总数据列
                    iSumCol := joSItem._(0);
                    //防止列号超范围
                    if (iSumCol<0) or (iSumCol>=joFields._Count) then begin
                        Continue;
                    end;
                    //得到汇总列字段名称
                    sField  := joFields._(iSumCol).fieldname;

                    //得以当前值
                    fValue  := 0;
                    try
                        if oDataSet.FindField(sField) <> nil then begin
                            if oDataSet.FieldByName(sField).DataType in [ftString, ftSmallint, ftInteger,  // 0..4
                                    ftWord,ftFloat, ftCurrency, ftBCD, ftDate, ftTime, ftDateTime, // 5..11
                                    ftAutoInc, ftBlob, ftLongWord, ftShortint, ftByte, ftExtended, ftSingle]
                            then begin
                                fValue  := oDataSet.FieldByName(sField).AsFloat;
                            end;
                        end;
                    except
                        fValue  := 0;
                    end;


                    //根据汇总方式（平均/求和/最小值/最大值）分别 处理
                    if (joSItem._(1) = 'avg') or (joSItem._(1) = 'sum') then begin
                        if oDataSet.Bof then begin
                            fValues[iSum-1] := fValue;
                        end else begin
                            fValues[iSum-1] := fValues[iSum-1] + fValue;
                        end;
                    end else if (joSItem._(1) = 'min') then begin
                        if oDataSet.Bof then begin
                            fValues[iSum-1] := fValue;
                        end else begin
                            fValues[iSum-1] := Min(fValues[iSum-1], fValue);
                        end;
                    end else if (joSItem._(1) = 'max') then begin
                        if oDataSet.Bof then begin
                            fValues[iSum-1] := fValue;
                        end else begin
                            fValues[iSum-1] := Max(fValues[iSum-1], fValue);
                        end;
                    end
                end;
                //
                oDataSet.Next;
                Inc(iRow);
            end;
            //生成数据代码
            for iCol := 0 to joFields._Count-1 do begin
                sCode := sFull + '__cd'+IntToStr(iCol)+':'+VariantSaveJSON(joColDatas[iCol]) + ',' ;
                joRes.Add(sCode);
            end;

            //重新定位记录指针回到原来的位置
            oDataSet.GotoBookmark(oBookMark);
            oDataSet.EnableControls;
            //删除书签BookMark标志
            oDataSet.FreeBookmark(oBookMark);
            //恢复原事件函数
            oDataSet.AfterScroll    := oAfter;
            oDataSet.BeforeScroll   := oBefore;
            //>
        end else begin
            //====================用于数据对齐======================================================
            //总记录数
            iRecCount   := 0;

            //取得表头的字符串
            sCols   := '';
            _CreateColumnsHtml(TListView(ACtrl),joFields,iMax,iHeaderH,iRowHeight,sCols,sHover,sRecord);

            //sct,用于生垂直滚动条的div的top
            joRes.Add(sFull + '__sct:"0px",');

            //写各字段的left/width和数据,用于显示编辑框
            for iCol := 0 to joFields._Count-1 do begin
                joField := joFields._(iCol);
                //fl:field left
                joRes.Add(sFull + '__fl'+IntToStr(iCol)+':"'+IntToStr(joField.left) + 'px",');
                //fw:field width
                if joField.Exists('type') and (joField.type='boolean') then begin
                    joRes.Add(sFull + '__fw'+IntToStr(iCol)+':"'+IntToStr(joField.viewwidth-1-5) + 'px",');
                end else begin
                    joRes.Add(sFull + '__fw'+IntToStr(iCol)+':"'+IntToStr(joField.viewwidth-1) + 'px",');
                end;
                //fd : field data
                if joField.fieldname<>'' then begin
                    if joField.Exists('type') and (joField.type='boolean') then begin
                        joRes.Add(sFull + '__fd'+IntToStr(iCol)+':'+'false'+',');
                    end else if joField.Exists('type') and (joField.type='date') then begin
                        joRes.Add(sFull + '__fd'+IntToStr(iCol)+':"'+'2000-01-01'+'",');
                    end else begin
                        joRes.Add(sFull + '__fd'+IntToStr(iCol)+':"'+''+'",');
                    end;
                    //
                    if joField.Exists('type') and (joField.type = 'string') and joField.Exists('list')then begin
                        joItems := _json('[]');
                        for iItem := 0 to joField.list._Count-1 do begin
                            joItem  := _json('{}');
                            joItem.value    := joField.list._(iItem);
                            joItems.Add(joItem);
                        end;
                        joRes.Add(sFull + '__it'+IntToStr(iCol)+':'+VariantSaveJSON(joItems)+',');
                    end;

                end else begin
                    //return empty data
                    joRes.Add(sFull + '__fd'+IntToStr(iCol)+':"",');
                end;
            end;



            //汇总数据
            if not joHint.Exists('summary') then begin
                joHint.summary  := _json('[]');
            end;
            joSummary   := joHint.summary;
            if joSummary._count > 1 then begin
                SetLength(fValues,Integer(joSummary._Count)-1);
            end else begin
                SetLength(fValues,0);
            end;


            //生成数据代码
            for iCol := 0 to joFields._Count-1 do begin
                sCode := sFull + '__cd'+IntToStr(iCol)+':'+'[]' + ',' ;
                joRes.Add(sCode);
            end;

            //>
            //======================================================================================

            //
            sCode := sFull + '__dat:[],';
            joRes.Add(sCode);
        end;

        //以下是不管是否有DataSet都有的部分
        //summary top
        joRes.Add(sFull + '__stp:"'+IntToStr(Height - iSumCount * iRowHeight-1)+'px",');
        //data height
        joRes.Add(sFull + '__dth:"'+IntToStr(Height - iSumCount * iRowHeight-iMax*iHeaderH+8)+'px",');
        //append visible
        joRes.Add(sFull + '__apv:' + dwIIF(not ShowHint, 'true,', 'false,'));
        //append height
        joRes.Add(sFull + '__aph:"'+IntToStr(Height -  iMax * iHeaderH -10)+'px",');

        //计算各表头基本字段的left/width
        if joFields <> unassigned then begin
            for iCol := 0 to joFields._Count - 1 do begin
                joField := joFields._(iCol);
                //
                joRes.Add(sFull + '__cl'+IntToStr(iCol)+':"' + IntToStr(joField.left) + 'px",');
                joRes.Add(sFull + '__cw'+IntToStr(iCol)+':"' + IntToStr(joField.viewwidth-1) + 'px",');
            end;
        end;

        //计算各表头融合字段的left/width
        if joHint.Exists('merge') then begin
            //
            for iItem := 0 to joHint.merge._Count - 1 do begin
                iLevel  := joHint.merge._(iItem)._(0);  //楼层
                iStart  := joHint.merge._(iItem)._(1);  //起始序号
                iEnd    := joHint.merge._(iItem)._(2);  //结束序号

                //如果起始/结束的列的序号超出范围，则跳过
                if (iStart<0)or(iStart>=joFields._Count) or (iEnd<0)or(iEnd>=joFields._Count) then begin
                    Continue;
                end;

                //当前合并的LEFT
                iL      := joFields._(iStart).left;
                iW      := joFields._(iEnd).left + joFields._(iEnd).viewwidth - iL;

                //
                joRes.Add(sFull + '__cl'+IntToStr(iItem+joFields._Count)+':"' + IntToStr(iL) + 'px",');
                joRes.Add(sFull + '__cw'+IntToStr(iItem+joFields._Count)+':"' + IntToStr(iW-1) + 'px",');
            end;
        end;

        //总记录数
        sCode := sFull + '__rcc:'+IntToStr(iRecCount)+',';
        joRes.Add(sCode);

        //汇总数据
        //"summary":[
        //  "汇总",
        //  [6,"sum","合计：%.0f"],
        //  [6,"avg","平均：%.0f"],
        //  [9,"max","最大：%.0f%%"],
        //  [9,"min","最小：%.0f%%"]
        //]
        if joSummary <> unassigned then begin
            for iSum := 1 to joSummary._Count-1 do begin
                joSItem := joSummary._(iSum);
                //
                iSumCol := joSItem._(0);
                //
                if (joSItem._(1) = 'avg') then begin
                    if iRecCount = 0 then begin
                        fValues[iSum-1] := 0;
                    end else begin
                        fValues[iSum-1] := fValues[iSum-1] / iRecCount;
                    end;
                end;
                //'{{'+sFull+'__s'+IntToStr(iCol)+'_'+IntToStr(iSum-1)+'}}'
                sCode := sFull + '__sm'+IntToStr(iSum-1)+':"'+Format(joSItem._(2),[fValues[iSum-1]])+'",';
                joRes.Add(sCode);

            end;

            //汇总位置 left/top/width
            for iSum := 1 to joSummary._Count -1 do begin
                joSItem := joSummary._(iSum);

                //得到需要汇总的序号
                iSumCol := joSItem._(0);
                //
                if (iSumCol<0) or (iSumCol>=joFields._Count) then begin
                    Continue;
                end;

                //计算当前列的LEFT
                iL  := -1;
                for iCol := 0 to iSumCol -1 do begin
                    joField := joFields._(iCol);
                    iL      := iL + joField.viewwidth;
                end;
                //计算当前的Top
                iT  := -2;
                for iCol := 1 to iSum -1 do begin
                    if joSummary._(iCol)._(0) = iSumCol then begin
                        iT  := iT + iRowHeight;
                    end;
                end;

                //
                iW  := joFields._(iSumCol).viewwidth-1;
                iH  := iRowHeight-1;
                //
                joRes.Add(sFull + '__sl'+IntToStr(iSum)+':"'+IntToStr(iL+1)+'px",');
                joRes.Add(sFull + '__st'+IntToStr(iSum)+':"'+IntToStr(iT)+'px",');
                joRes.Add(sFull + '__sw'+IntToStr(iSum)+':"'+IntToStr(iW)+'px",');
            end;

            //汇总栏宽度
            iCol    := joFields._Count-1;
            if iCol >=0 then begin
                joRes.Add(sFull + '__swd:"'+IntToStr(joFields._(iCol).left+joFields._(iCol).viewwidth-1)+'px",');
            end else begin
                joRes.Add(sFull + '__swd:"0px",');
            end;

        end;

        //最大滚动量 msc: max scroll
        joRes.Add(sFull + '__msc:'+IntToStr(3+(iRecCount+iSumCount)*iRowHeight-(Height-iMax * iHeaderH)+1)+',');
    end;


    //log.WriteLog('取得Data：'+joRes);
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
    sFull       : string;
    sCode       : string;
    sCols       : string;
    sHover      : string;
    sRecord     : string;
    sField      : string;
    sTmp        : string;
    //
    fValue      : Double;
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
    //
    oDataSet    : TDataSet;
    oBookMark   : TBookMark;
    oAfter      : Procedure(DataSet: TDataSet) of Object;
    oBefore     : Procedure(DataSet: TDataSet) of Object;
    //比GetData多的变量
    iSel        : Integer;
    joSels      : Variant;
    sPrimaryKey : string;
begin
    //生成返回值数组
    joRes := _Json('[]');

    //
    sFull   := dwFullName(ACtrl);

    with TListView(ACtrl) do begin
        //总记录数
        iRecCount   := 0;

        //取得HINT对象JSON
        joHint := dwGetHintJson(TControl(ACtrl));

        //取得字段数组对象
        joFields    := _GetFields(TListView(ACtrl));

        //取得已选择的值JSON
        if not joHint.Exists('__selection') then begin
            joHint.__selection  := _json('[]');
        end;
        joSels  := joHint.__selection;
        sTmp    := joSels;

        //取得数据集，备用
        oDataSet    := nil;
        if joHint.Exists('dataset') then begin
            if ( joHint.dataset<> '' ) then begin
                oDataSet    := TDataSet(Owner.FindComponent(joHint.dataset));
            end;
        end;
        if oDataSet = nil then begin
            Exit;
        end;

        //
        sCode := 'this.'+sFull + '__dat=[];';
        joRes.Add(sCode);

        //添加基本数据
        joRes.Add('this.'+sFull + '__lef="' + IntToStr(Left) + 'px",');
        joRes.Add('this.'+sFull + '__top="' + IntToStr(Top) + 'px",');
        joRes.Add('this.'+sFull + '__wid="' + IntToStr(Width) + 'px";');
        joRes.Add('this.'+sFull + '__hei="' + IntToStr(Height) + 'px";');
        //添加因Border而需要修正的数据
        joRes.Add('this.'+sFull + '__leb="' + IntToStr(Left+1) + 'px";');
        joRes.Add('this.'+sFull + '__tob="' + IntToStr(Top+1) + 'px";');
        joRes.Add('this.'+sFull + '__wib="' + IntToStr(Width-2) + 'px";');
        joRes.Add('this.'+sFull + '__heb="' + IntToStr(Height-2) + 'px";');
        //
        joRes.Add('this.'+sFull + '__vis=' + dwIIF(Visible, 'true;', 'false;'));
        joRes.Add('this.'+sFull + '__dis=' + dwIIF(Enabled, 'false;', 'true;'));
        //columntitles
        joRes.Add('this.'+sFull + '__cts='+VariantSaveJSON(_GetColumnTitles(TListView(ACtrl))) + ';');
        //show editor
        joRes.Add('this.'+sFull + '__sed='+dwIIF(not ReadOnly,'true','false') + ';');
        //joRes.Add('this.'+sFull + '__sed=false' + ';');
        //save / cancel div left
        joRes.Add('this.'+sFull + '__svl="' + IntToStr(Width-115) + 'px";');
        joRes.Add('this.'+sFull + '__cal="' + IntToStr(Width-73) + 'px";');

        //总记录数
        iRecCount   := oDataSet.RecordCount;

        //总记录数
        sCode := 'this.'+sFull + '__rcc='+IntToStr(iRecCount)+';';
        joRes.Add(sCode);

        //得到主键
        sPrimaryKey := 'id';
        if joHint.Exists('primarykey') then begin
            sPrimaryKey := joHint.primarykey;
        end;

        //取得表头的字符串
        sCols   := '';
        _CreateColumnsHtml(TListView(ACtrl),joFields,iMax,iHeaderH,iRowHeight,sCols,sHover,sRecord);

        //sct,用于生垂直滚动条的div的top
        joRes.Add('this.'+sFull + '__sct="' + IntToStr(3 + iMax*iHeaderH + iRecCount*iRowHeight + iSumCount*iRowHeight) + 'px";');

        //写各字段的left/width和数据,用于显示编辑框
        for iCol := 0 to joFields._Count-1 do begin
            joField := joFields._(iCol);
            joRes.Add('this.'+sFull + '__fl'+IntToStr(iCol)+'="'+IntToStr(joField.left) + 'px";');
            if joField.Exists('type') and (joField.type='boolean') then begin
                joRes.Add('this.'+sFull + '__fw'+IntToStr(iCol)+'="'+IntToStr(joField.viewwidth-1-5) + 'px";');
            end else begin
                joRes.Add('this.'+sFull + '__fw'+IntToStr(iCol)+'="'+IntToStr(joField.viewwidth-1) + 'px";');
            end;
            if joField.fieldname<>'' then begin
                if joField.Exists('type') and (joField.type='boolean') then begin
                    joRes.Add('this.'+sFull + '__fd'+IntToStr(iCol)+'='+dwIIF(oDataSet.FieldByName(joField.fieldname).AsBoolean,'true','false')+';');
                end else begin
                    joRes.Add('this.'+sFull + '__fd'+IntToStr(iCol)+'="'+oDataSet.FieldByName(joField.fieldname).AsString+'";');
                end;
                //
                if joField.Exists('type') and (joField.type = 'string') and joField.Exists('list')then begin
                    joItems := _json('[]');
                    for iItem := 0 to joField.list._Count-1 do begin
                        joItem  := _json('{}');
                        joItem.value    := joField.list._(iItem);
                        joItems.Add(joItem);
                    end;
                    joRes.Add('this.'+sFull + '__it'+IntToStr(iCol)+'='+VariantSaveJSON(joItems)+';');
                end;
            end else begin
                joRes.Add('this.'+sFull + '__fd'+IntToStr(iCol)+'="";');
            end;
        end;

        //记录位置record no top
        if Ctl3d then begin     //ctl3D为真表示为正常状态，否则为单列显示模式   //iMax*iHeaderH+
            joRes.Add('this.'+sFull + '__rnt="'+IntToStr((oDataSet.RecNo-1)*iRowHeight)+'px";');
            joRes.Add('this.'+sFull + '__hov="'+IntToStr((oDataSet.RecNo-1)*iRowHeight)+'px";');
        end else begin
            joRes.Add('this.'+sFull + '__rnt="'+IntToStr((oDataSet.RecNo-1)*iRowHeight*(joFields._Count+1))+'px";');
            //joRes.Add('this.'+sFull + '__hov="'+IntToStr((oDataSet.RecNo-1)*iRowHeight*joFields._Count)+'px";');
        end;

        //保存当前位置
        oBookMark := oDataSet.GetBookmark;

        oDataSet.DisableControls;

        //保存原事件函数
        oAfter  := oDataSet.AfterScroll;
        oBefore := oDataSet.BeforeScroll;
        //清空事件
        oDataSet.AfterScroll    := nil;
        oDataSet.BeforeScroll   := nil;

        //<生成数据
        //初始数据
        SetLength(joColDatas,Integer(joFields._Count));
        for iCol := 0 to joFields._Count-1 do begin
            joColDatas[iCol]    := _json('[]');
        end;

        //汇总数据
        if not joHint.Exists('summary') then begin
            joHint.summary  := _json('[]');
        end;
        joSummary   := joHint.summary;
        if joSummary._count > 1 then begin
            SetLength(fValues,Integer(joSummary._Count)-1);
        end else begin
            SetLength(fValues,0);
        end;

        //
        oDataSet.First;
        iRow := 0;
        while not oDataSet.Eof do begin
            for iCol := 0 to joFields._Count-1 do begin
                if Ctl3D then begin
                    joField := joFields._(iCol);

                    //得到各值的LTWH/row
                    joValue         := _json('{}');
                    joValue.l       := IntToStr(joField.left)+'px';
                    joValue.h       := IntToStr(iRowHeight)+'px';    //暂时没用
                    joValue.t       := IntToStr(oDataSet.RecNo * iRowHeight - iRowHeight)+'px';
                    joValue.w       := IntToStr(joField.viewwidth-1-10)+'px';   //-10是因为padding:5px
                    joValue.r       := oDataSet.RecNo;
                    joValue.align   := joField.align;
                    joValue.color   := joField.color;
                    joValue.bkcolor := joField.bkcolor;

                    //根据类型进行处理
                    if joField.Exists('type') and (joField.type = 'check') then begin
                        joValue.c   := false;
                        joSels  := joHint.__selection;
                        for iSel := 0 to joSels._Count-1 do begin
                            if joSels._(iSel) = oDataSet.FieldByName(sPrimaryKey).AsString then begin
                                joValue.c   := True;
                                break;
                            end;
                        end;
                    end else if joField.Exists('type') and (joField.type = 'index') then begin
                        joValue.c   := IntToStr(oDataSet.RecNo);
                    end else if joField.Exists('type') and (joField.type = 'boolean') then begin
                        if joField.Exists('list') then begin
                            if oDataSet.FieldByName(joField.fieldname).AsBoolean then begin
                                joValue.c   := joField.list._(0);
                            end else begin
                                joValue.c   := joField.list._(1);
                            end;
                        end else begin
                            joValue.c   := oDataSet.FieldByName(joField.fieldname).AsString;
                        end;
                    end else if joField.Exists('type') and (joField.type = 'datetime') then begin
                        if joField.Exists('format') then begin
                            joValue.c   := FormatDateTime(joField.format,oDataSet.FieldByName(joField.fieldname).AsDateTime);
                        end else begin
                            joValue.c   := oDataSet.FieldByName(joField.fieldname).AsString;
                        end;
                    end else if joField.Exists('type') and (joField.type = 'image') then begin
                        joValue.c   := Format(joField.format,[oDataSet.FieldByName(joField.fieldname).AsString]);
                    end else if joField.Exists('type') and (joField.type = 'progress') then begin
                        joValue.c   := Round(100*oDataSet.FieldByName(joField.fieldname).AsFloat / joField.total);
                    end else if joField.Exists('type') and (joField.type = 'float') then begin
                        if joField.Exists('format') then begin
                            joValue.c   := Format(joField.format,[oDataSet.FieldByName(joField.fieldname).AsFloat]);
                        end else begin
                            joValue.c   := oDataSet.FieldByName(joField.fieldname).AsString;
                        end;
                    end else if joField.Exists('type') and (joField.type = 'button') then begin
                        joValue.c   := 'AAA';
                    end else begin
                        if joField.fieldname = '' then begin
                            joValue.c   := '';
                        end else begin
                            joValue.c   := oDataSet.FieldByName(joField.fieldname).AsString;
                        end;
                    end;
                    //
                    joColDatas[iCol].Add(joValue);
                end else begin
                end;
            end;

            //计算汇总
            for iSum := 1 to joSummary._Count-1 do begin
                joSItem := joSummary._(iSum);
                //
                iSumCol := joSItem._(0);

                //
                if (iSumCol<0) or (iSumCol>=joFields._Count) then begin
                    Continue;
                end;

                //
                sField  := joFields._(iSumCol).fieldname;

                //得以当前值
                fValue  := 0;
                try
                    if oDataSet.FindField(sField) <> nil then begin
                        if oDataSet.FieldByName(sField).DataType in [ftString, ftSmallint, ftInteger,  // 0..4
                                ftWord,ftFloat, ftCurrency, ftBCD, ftDate, ftTime, ftDateTime, // 5..11
                                ftAutoInc, ftBlob, ftLongWord, ftShortint, ftByte, ftExtended, ftSingle]
                        then begin
                            fValue  := oDataSet.FieldByName(sField).AsFloat;
                        end;
                    end;
                except
                    fValue  := 0;
                end;

                //
                if (joSItem._(1) = 'avg') or (joSItem._(1) = 'sum') then begin
                    if oDataSet.Bof then begin
                        fValues[iSum-1] := fValue;
                    end else begin
                        fValues[iSum-1] := fValues[iSum-1] + fValue;
                    end;
                end else if (joSItem._(1) = 'min') then begin
                    if oDataSet.Bof then begin
                        fValues[iSum-1] := fValue;
                    end else begin
                        fValues[iSum-1] := Min(fValues[iSum-1], fValue);
                    end;
                end else if (joSItem._(1) = 'max') then begin
                    if oDataSet.Bof then begin
                        fValues[iSum-1] := fValue;
                    end else begin
                        fValues[iSum-1] := Max(fValues[iSum-1], fValue);
                    end;
                end
            end;
            //
            oDataSet.Next;
            Inc(iRow);

            //生成数据代码
            for iCol := 0 to joFields._Count-1 do begin
                sCode := 'this.'+sFull + '__cd'+IntToStr(iCol)+'='+VariantSaveJSON(joColDatas[iCol]) + ';' ;
                joRes.Add(sCode);
            end;
        end;

        //重新定位记录指针回到原来的位置
        oDataSet.GotoBookmark(oBookMark);
        oDataSet.EnableControls;
        //删除书签BookMark标志
        oDataSet.FreeBookmark(oBookMark);
        //恢复原事件函数
        oDataSet.AfterScroll    := oAfter;
        oDataSet.BeforeScroll   := oBefore;
        //>
        //计算各表头基本字段的left/width
        for iCol := 0 to joFields._Count - 1 do begin
            joField := joFields._(iCol);
            //
            joRes.Add('this.'+sFull + '__cl'+IntToStr(iCol)+'="' + IntToStr(joField.left) + 'px";');
            joRes.Add('this.'+sFull + '__cw'+IntToStr(iCol)+'="' + IntToStr(joField.viewwidth) + 'px";');
        end;

        //计算各表头融合字段的left/width
        if joHint.Exists('merge') then begin
            //
            for iItem := 0 to joHint.merge._Count - 1 do begin
                iLevel  := joHint.merge._(iItem)._(0);  //楼层
                iStart  := joHint.merge._(iItem)._(1);  //起始序号
                iEnd    := joHint.merge._(iItem)._(2);  //结束序号

                //
                if (iStart<0)or(iStart>=joFields._Count) or (iEnd<0)or(iEnd>=joFields._Count) then begin
                    Continue;
                end;

                //
                iL      := joFields._(iStart).left;
                iW      := joFields._(iEnd).left + joFields._(iEnd).viewwidth - iL;

                //
                joRes.Add('this.'+sFull + '__cl'+IntToStr(iItem+joFields._Count)+'="' + IntToStr(iL) + 'px";');
                joRes.Add('this.'+sFull + '__cw'+IntToStr(iItem+joFields._Count)+'="' + IntToStr(iW-1) + 'px";');
            end;
        end;
        //得到汇总的最大行数
        iSumCount   := _GetSumRowCount(ACtrl);

        //最大滚动量 msc: max scroll
        joRes.Add('this.'+sFull + '__msc='+IntToStr((iRecCount+iSumCount)*iRowHeight-(Height-iMax * iHeaderH)+1)+';');

        //summary top
        joRes.Add('this.'+sFull + '__stp="'+IntToStr(Height - iSumCount * iRowHeight-1)+'px";');
    end;

    //汇总数据
    if (joSummary <> unassigned) and (iRecCount>0) then begin
        for iSum := 1 to joSummary._Count-1 do begin
            joSItem := joSummary._(iSum);
            //
            iSumCol := joSItem._(0);
            //
            if (joSItem._(1) = 'avg') then begin
                fValues[iSum-1] := fValues[iSum-1] / iRecCount;
            end;
            //'{{'+sFull+'__s'+IntToStr(iCol)+'_'+IntToStr(iSum-1)+'}}'
            sCode := 'this.'+sFull + '__sm'+IntToStr(iSum-1)+'="'+Format(joSItem._(2),[fValues[iSum-1]])+'";';
            joRes.Add(sCode);

        end;

        //汇总位置 left/top/width
        for iSum := 1 to joSummary._Count -1 do begin
            joSItem := joSummary._(iSum);

            //得到需要汇总的序号
            iSumCol := joSItem._(0);

            //
            if (iSumCol<0) or (iSumCol>=joFields._Count) then begin
                Continue;
            end;


            //计算当前列的LEFT
            iL  := -1;
            for iCol := 0 to iSumCol -1 do begin
                joField := joFields._(iCol);
                iL      := iL + joField.viewwidth;
            end;
            //计算当前的Top
            iT  := -2;
            for iCol := 1 to iSum -1 do begin
                if joSummary._(iCol)._(0) = iSumCol then begin
                    iT  := iT + iRowHeight;
                end;
            end;

            //
            iW  := joFields._(iSumCol).viewwidth-1;
            iH  := iRowHeight-1;
            //
            joRes.Add('this.'+sFull + '__sl'+IntToStr(iSum)+'="'+IntToStr(iL)+'px";');
            joRes.Add('this.'+sFull + '__st'+IntToStr(iSum)+'="'+IntToStr(iT)+'px";');
            joRes.Add('this.'+sFull + '__sw'+IntToStr(iSum)+'="'+IntToStr(iW)+'px";');
        end;
        //汇总栏宽度
        iCol    := joFields._Count-1;
        if iCol >=0 then begin
            joRes.Add('this.'+sFull + '__swd="'+IntToStr(joFields._(iCol).left+joFields._(iCol).viewwidth-1)+'px";');
        end else begin
            joRes.Add('this.'+sFull + '__swd="0px";');
        end;
    end;

    //log.WriteLog('取得Data：'+joRes);
    Result := (joRes);

end;

function dwGetMethods(ACtrl:TControl):String;stdCall;
var
    iCol        : Integer;  //列
    iItem       : Integer;  //
    iSum        : Integer;  //汇总
    iSumCount   : Integer;  //汇总的最大行数
    iCount      : Integer;
    iRowHeight  : Integer;  //数据行高
    iRecCount   : Integer;  //数据的总记录数
    iTitHeight  : Integer;  //标题区的高度
    iHedHeight  : Integer;
    iMaxTitle   : Integer;
    //
    sFull       : string;
    sCode       : string;
    sPrimaryKey : String;       //数据表主键
    slKeys      : TStringList;
    //
    oDataSet    : TDataSet;
    //
    joRes       : Variant;
    joFields    : Variant;
    joField     : Variant;
    joSels      : Variant;  //用于保存
    joHint      : Variant;
    joSummary   : Variant;
    joSum       : Variant;

begin
    joRes   := _json('[]');

    //
    sFull   := dwFullName(ACtrl);

    //先取得各字段信息
    joFields    := _GetFields(TListView(ACtrl));

    //取得HINT对象JSON
    joHint := dwGetHintJson(TControl(ACtrl));


    with TListView(ACtrl) do begin

        //表头全选/全不选事件
        for iCol := 0 to joFields._Count -1 do begin
            joField := joFields._(iCol);
            if joField.Exists('type') and (joField.type = 'check') then begin
                //处理CheckBox所有列表头的选中/清除事件
                sCode   := sFull+'__cc'+IntToStr(iCol)+'(val) {'
                            //更新所有记录的CheckBox
                            +'this.'+sFull+'__cd'+IntToStr(iCol)+'.forEach((item,index)=>{'
                                +'Vue.set(item,''c'',val);'
                            +'});'
                            +'this.dwevent("","'+sFull+'",val,"onfullcheck",'+IntToStr(TForm(Owner).Handle)+');'
                        +'},';
                joRes.Add(sCode);

            end;
        end;

        //编辑后save事件
        sCode   := sFull+'__save(e) '
                +'{'
                    //更新所有记录的CheckBox
                    +'var fds = [];'
                    +'for (var i=0;i<'+IntToStr(joFields._Count)+';i++) {'
                        +'var v = ''this.'+sFull+'__fd'' + i;'
                        +'fds.push(eval(v).toString());'
                    +'};'
                    //+'console.log(fds);'
                    +'var stmp = "''"+JSON.stringify(fds).toString()+"''";'
                    //+'console.log(stmp);'
                    +'if (this.'+sFull+'__dvv == true){'
                        +'this.dwevent("","'+sFull+'",stmp,"onsave",'+IntToStr(TForm(Owner).Handle)+');'
                    +'}else{'
                        +'this.dwevent("","'+sFull+'",stmp,"onappend",'+IntToStr(TForm(Owner).Handle)+');'
                    +'};'
                    //隐藏数据编辑框
                    +'this.'+sFull+'__sed=false;'
                    //显示数据显示区
                    +'this.'+sFull+'__dvv=true;'
                    +'e.stopPropagation();'//阻止冒泡
                +'},';
        joRes.Add(sCode);

        //----------------
        //sChange := ' @change=function(e)'
        //        +'{'
        //            +sFull+'__fd'+IntToStr(iCol)+'=e;'
        //            +'dwevent(null,'''+sFull+''',''this.'+sFull+'__fd'+IntToStr(iCol)+''',''oncolumnchange'+IntToStr(iCol)+''','''+IntToStr(TForm(Owner).Handle)+''');'
        //        +'}';

        //change事件
        sCode   := sFull+'__change(e,col) '
                +'{'
                    ////+'this.'+sFull+'__fd${col}+=e;'
                    ////+'this.dwevent(null,'''+sFull+''',''this.'+sFull+'__fd${col}'',''oncolumnchange${col}'','''+IntToStr(TForm(Owner).Handle)+''');'
                +'},';
        joRes.Add(sCode);


        //编辑后cancel事件
        sCode   := sFull+'__cancel(e) '
                +'{'
                    //根据"编辑"/"append"分别 处理
                    +'if (this.'+sFull+'__dvv == true){'
                        //+'this.dwevent("","'+sFull+'",stmp,"onsave",'+IntToStr(TForm(Owner).Handle)+');'
                    +'}else{'
                        //显示数据显示区
                        +'this.'+sFull+'__edt=false;'
                    +'};'
                    //显示数据显示区
                    +'this.'+sFull+'__dvv=true;'
                    //隐藏编辑框
                    +'this.'+sFull+'__sed=false;'   //sed:show editor
                    //
                    +'this.dwevent("","'+sFull+'","","oncancel",'+IntToStr(TForm(Owner).Handle)+');'
                    +'e.stopPropagation();'//阻止冒泡
                +'},';
        joRes.Add(sCode);

        //<为在滚动条滚动事件中处理汇总框的TOP准备数据
        //汇总
        if not joHint.Exists('summary') then begin
            joHint.summary  := _json('[]');
        end;

        //得到行高
        iRowHeight  := 40;
        if joHint.Exists('rowheight') then begin
            iRowHeight  := joHint.rowheight;
        end;

        //得到汇总栏的行数(所有汇总的最大行数)
        joSummary   := joHint.summary;
        iSumCount   := 0;
        for iSum := 1 to joSummary._Count - 1 do begin     //joSummary的第一个项为标题，所以从1开始查找
            joSum   := joHint.summary._(iSum);
            iCount  := 1;
            //
            for iItem := 1 to iSum-1 do begin
                if joHint.summary._(iSum)._(0) = joHint.summary._(iItem)._(0) then begin
                    iCount  := iCount + 1;
                end;
            end;
            //
            iSumCount   := Max(iSumCount,iCount);
        end;
        //>

        //取得标题区高度，备用
        //计算多表头最大层数
        iMaxTitle   := 1;
        if joHint.Exists('merge') then begin
            for iItem := 0 to joHint.merge._Count - 1 do begin
                iMaxTitle   := Max(iMaxTitle,joHint.merge._(iItem)._(0));
            end;
        end;
        //得到标题栏行高
        iHedHeight  := 40;
        if joHint.Exists('headerheight') then begin
            iHedHeight  := joHint.headerheight;
        end;
        iTitHeight  := iMaxTitle * iHedHeight;
        //>

        //取得数据集，备用
        oDataSet    := nil;
        if joHint.Exists('dataset') then begin
            oDataSet    := TDataSet(Owner.FindComponent(joHint.dataset));
        end;

        //得到数据总行数，用于控制滚动条的最大滚动量
        iRecCount   := 0;
        if oDataSet <> nil then begin
            iRecCount   := oDataSet.RecordCount;
        end;

        //滚动条滚动事件，主要处理纵向滚动后
        sCode   := sFull+'__scroll(e) '
                +'{'
                    //限制滚动最大值
                    +'let iscr = '+sFull+'.scrollTop;'
                    //+'console.log(iscr);'
                    +sFull+'.scrollTop = Math.min(iscr,this.'+sFull+'__msc);'
                    //+sFull+'.scrollTop = Math.min(iscr,'+IntToStr((iRecCount+iSumCount)*iRowHeight-(Height-iTitHeight)+1)+');'
                    //+'console.log(this.'+sFull+'__msc);'
                    //title top
                    +'this.'+sFull+'__ttp = '+sFull+'.scrollTop+"px";'
                    //summary top
                    //+'this.'+sFull+'__stp = '+IntToStr(Height - iSumCount * iRowHeight-1)+' + '+sFull+'.scrollTop+"px";'
                    +'let istp = parseInt(this.'+sFull+'__hei);'
                    +'istp = istp - '+IntToStr(iSumCount * iRowHeight-1)+';'
                    +'istp = istp + iscr;'
                    +'this.'+sFull+'__stp = istp+"px";'
                +'},';
        joRes.Add(sCode);
    end;

    //用于进度条显示超过100%的数值
    joRes.Add(sFull+'_format(value) {return () => { return value + ''%'' }},');

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

