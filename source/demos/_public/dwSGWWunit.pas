unit dwSGWWunit;
{
说明：
    增强版StringGrid的控制单元
}

interface

uses
    dwBase,
    SynCommons,

    //
    ComObj,
    Vcl.GraphUtil,
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Data.DB,
    Data.Win.ADODB, Vcl.Menus, Vcl.Grids, Vcl.DBGrids;


//
function dwsgSaveToFile(ASG:TStringGrid;AFileName:String):Integer;
function dwsgLoadFromFile(ASG:TStringGrid;AFileName:String):Integer;

//导出到Excel（服务器需要安装Excel）
function dwsgSaveToExcel(ASG:TStringGrid;AFileName,ARootDir:String):Integer;

//取CELL值
function dwsgGetCell(ASG:TStringGrid;ACol,ARow,AIndex : Integer):String;

//设置Cell值
function dwsgSetCell(ASG:TStringGrid;ACol,ARow,AIndex : Integer;AValue:String):Integer;

//检查单元格字符串的JSON对象完整性
procedure _CheckCell(var AJson:Variant);

//在表格中的第ARow行插入新行。 ARow从0开始
function dwsgInsertRow(AGrid:TStringGrid;ARow:Integer):integer;

//删除表格中的第ARow。 ARow从0开始
function dwsgDeleteRow(AGrid:TStringGrid;ARow:Integer):integer;

implementation

//删除表格中的第ARow。 ARow从0开始
function dwsgDeleteRow(AGrid:TStringGrid;ARow:Integer):integer;
var
    iRow,iCol   : Integer;
    joCell      : Variant;
begin
    Result  := 0;
    if (ARow<0) or (ARow>AGrid.RowCount-1) then begin
        Result  := -1;
        Exit;
    end;

    with AGrid do begin
        //先移动行数据
        for iRow := ARow to RowCount-2 do begin
            for iCol := 0 to ColCount-1 do begin
                Cells[iCol,iRow]    := Cells[iCol,iRow+1];
            end;
        end;

        //删除一行
        RowCount    := RowCount - 1;

    end;
end;

//在表格中的第ARow行插入新行。 ARow从0开始
function dwsgInsertRow(AGrid:TStringGrid;ARow:Integer):integer;
var
    iRow,iCol   : Integer;
    joCell      : Variant;
begin
    Result  := 0;
    if (ARow<0) or (ARow>AGrid.RowCount) then begin
        Result  := -1;
        Exit;
    end;

    with AGrid do begin
        //增加一行
        RowCount    := RowCount + 1;

        //先移动行数据
        for iRow := RowCount-1 downto ARow+1 do begin
            for iCol := 0 to ColCount-1 do begin
                Cells[iCol,iRow]    := Cells[iCol,iRow-1];
            end;
        end;

        //清空新插入的行
        for iCol := 0 to ColCount-1 do begin
            joCell  := _json(Cells[iCol,ARow]);
            if joCell = unassigned then begin
                Cells[iCol,ARow]    := '';
            end else begin
                joCell.value        := _json('[""]');
                joCell.data         := '';
                Cells[iCol,ARow]    := joCell;
            end;
        end;
    end;
end;

function FontStyleToStr(AStyle:TFontStyles):String;
begin
    Result  := '';
    if fsBold in AStyle then begin
        Result  := Result + '1';
    end else begin
        Result  := Result + '0';
    end;
    if fsItalic in AStyle then begin
        Result  := Result + '1';
    end else begin
        Result  := Result + '0';
    end;
    if fsStrikeOut in AStyle then begin
        Result  := Result + '1';
    end else begin
        Result  := Result + '0';
    end;
    if fsUnderline in AStyle then begin
        Result  := Result + '1';
    end else begin
        Result  := Result + '0';
    end;
end;

function StrToFontStyle(AStr:String):TFontStyles;
begin
    Result  := [];
    if Length(AStr)<4 then begin
        Exit;
    end;
    //
    if AStr[1]='1' then begin
        Result  := Result + [fsBold];
    end;
    //
    if AStr[2]='1' then begin
        Result  := Result + [fsItalic];
    end;
    //
    if AStr[3]='1' then begin
        Result  := Result + [fsStrikeOut];
    end;
    //
    if AStr[4]='1' then begin
        Result  := Result + [fsUnderLine];
    end;
end;

function dwWebColorToColor(WebColor: string): TColor;
var
    iColor      : Integer;
    iR,iG,iB    : Integer;
begin
    Result  := 0;
    try
        if Length(WebColor)=7 then begin
            if WebColor[1]='#' then begin  //#f0f1f2
                iR  := StrToIntDef('$'+Copy(WebColor,2,2),0);
                iG  := StrToIntDef('$'+Copy(WebColor,6,2),0);
                iB  := StrToIntDef('$'+Copy(WebColor,6,2),0);
                Result  := iB*65536 + iG * 256 + iR;
            end;
        end else if Length(WebColor)=4 then begin
            if WebColor[1]='#' then begin   //#DDD
                iR  := StrToIntDef('$'+Copy(WebColor,2,1),0);
                iG  := StrToIntDef('$'+Copy(WebColor,3,1),0);
                iB  := StrToIntDef('$'+Copy(WebColor,4,1),0);
                Result  := iB*16*65536 + iG * 16 * 256 + iR*16;
            end;
        end;
    except
    end;
end;



function dwsgSaveToExcel(ASG:TStringGrid;AFileName,ARootDir:String):Integer;
const
    xlNormal    = -4143;
    //vert
    xlTop       = -4160;
    xlCenter    = -4108;
    xlBottom    = -4107;

    //HorizontalAlignment:
    xlLeft      = -4131;
    //xlCenter    = -4108;
    xlRight     = -4152;

var
    iCol,iRow   : Integer;
    iStart,iEnd : Integer;
    iBorder     : Integer;
    iR0,iC0     : Integer;
    iR1,iC1     : Integer;
    //
    sCell       : String;       //单元格
    sValue      : string;
    sStyle      : string;

    //
    joHint      : Variant;
    joSG        : Variant;
    joCell      : Variant;
    joBorders   : Variant;
    joBorder    : Variant;
    joStart     : Variant;
    joEnd       : Variant;
    //
    ExcelApp    : Variant;
    oSheet      : Variant;
    oWs         : Variant;
    oRg         : Variant;
    oPic        : Variant;
begin
    Result      := 0;
    try
        //检查是否安装了Excel
        try
            ExcelApp := CreateOleObject('Excel.application');
            ExcelApp.workbooks.add;
        except
            dwMessage('Please install MICROSOFT EXCEL on Server first!','error',TForm(ASG.Owner));
            Exit;
        end;


        //1) 显示当前窗口：
        //ExcelApp.Visible := True;

        //2) 更改 Excel 标题栏：
        ExcelApp.Caption := 'DeWeb StringGrid Excel';

        //4) 打开已存在的工作簿：
        //ExcelApp.WorkBooks.Open( 'C:\Excel\Demo.xls' );

        //5) 设置第2个工作表为活动工作表：
        ExcelApp.WorkSheets[1].Activate;
        //或
        //ExcelApp.WorksSheets[ 'Sheet2' ].Activate;
        //
        oWS := ExcelApp.Worksheets[1];


        //7) 设置指定列的宽度（单位：字符个数），以第一列为例：
        for iCol := 0 to ASG.ColCount-1 do begin
            ExcelApp.ActiveSheet.Columns[iCol+1].ColumnWidth := ASG.ColWidths[iCol] / 8.45;
        end;

        //8) 设置指定行的高度（单位：磅）（1磅＝0.035厘米），以第二行为例：
        for iRow := 0 to ASG.RowCount-1 do begin
            ExcelApp.ActiveSheet.Rows[iRow+1].RowHeight := ASG.RowHeights[iRow]*0.75; // 1厘米
        end;

        //6) 给单元格赋值：
        for iCol := 0 to ASG.ColCount-1 do begin
            for iRow := 0 to ASG.RowCount-1 do begin
                sCell   := ASG.Cells[iCol,iRow];

                //取得每个单元格的JSON
                joCell  := _json(sCell);

                //
                if joCell = unassigned then begin
                    joCell  := _json('{}');
                    joCell.data := sCell;
                end;


                //检查JSON完整性，并补全默认属性，以便于后面处理
                _CheckCell(joCell);

                //检查扩展（单元合并），生成扩展数组
                //CheckExpands(iRow,iCol,joCell);

                //单元格合并
                if joCell.Exists('expand') then begin
                    if (joCell.expand._(0)>0) or (joCell.expand._(1)>0) then begin
                        oRG := oWS.Range[oWS.Cells[iRow+1, iCol+1],oWS.Cells[iRow+1+joCell.expand._(1), iCol+1+joCell.expand._(0)]];//用数字行列号比较方便
                        oRG.merge;//合并
                    end;
                end;

                //取得值
                sValue  := dwsgGetCell(ASG,iCol,iRow,0);

                //处理换行
                sValue  := StringReplace(sValue,'<br/>',#13#10,[rfReplaceAll]);
                sValue  := StringReplace(sValue,'<br>',#13#10,[rfReplaceAll]);
                //处理复杂组合（删除基本HTML标识）
                sValue  := StringReplace(sValue,'<b>','',[rfReplaceAll]);
                sValue  := StringReplace(sValue,'</b>','',[rfReplaceAll]);
                sValue  := StringReplace(sValue,'<i>','',[rfReplaceAll]);
                sValue  := StringReplace(sValue,'</i>','',[rfReplaceAll]);
                sValue  := StringReplace(sValue,'</span>','',[rfReplaceAll]);
                //处理复杂组合（删除span）
                while Pos('<span',sValue)>0 do begin
                    iStart  := Pos('<span',sValue);
                    iEnd    := Pos('>',sValue);
                    //避免没有>的开发部
                    iEnd    := Max(iStart+5,iEnd);
                    //
                    Delete(sValue,iStart,iEnd-iStart+1);
                end;
                //处理Check
                if joCell.type = 'check' then begin
                    if lowercase(sValue) = 'true' then begin
                        sValue  := '√';
                    end else begin
                        sValue  := '□';
                    end;
                end;

                //处理Image
                if (joCell.type = 'image') and FileExists(ARootDir+String(joCell.data)) then begin
                    oRG         := oWS.Range[oWS.Cells[iRow+1, iCol+1],oWS.Cells[iRow+1+joCell.expand._(1), iCol+1+joCell.expand._(0)]];//用数字行列号比较方便
                    oPic        := oWS.Pictures.Insert(ARootDir+String(joCell.data)); //插入图片
                    oPic.left   := oRG.left + 1;    //左
                    oPic.top    := oRG.top + 1;     //高
                    oPic.width  := oRG.width - 1;   //宽度
                    oPic.height := oRG.height - 1;  //高度
                    oPic        := Unassigned;
                    //
                    sValue  := '';
                end;

                //
                ExcelApp.Cells[iRow+1,iCol+1].Value := sValue;

                //换行
                ExcelApp.Cells[iRow+1,iCol+1].WrapText:=true;

                //单元格颜色
                if joCell.Exists('bkcolor') then begin
                    if joCell.bkcolor <> 'transparent' then begin
                        ExcelApp.Cells[iRow+1,iCol+1].Interior.Color := dwWebColorToColor(joCell.bkcolor);
                    end;
                end;

                //字体颜色
                if joCell.Exists('fontcolor') then begin
                    ExcelApp.Cells[iRow+1,iCol+1].Font.Color := dwWebColorToColor(joCell.fontcolor);
                end else begin
                    ExcelApp.Cells[iRow+1,iCol+1].Font.Color := ASG.Font.Color;
                end;

                //字体名称
                if joCell.Exists('fontname') then begin
                    ExcelApp.Cells[iRow+1,iCol+1].Font.Name := String(joCell.fontname);
                end else begin
                    ExcelApp.Cells[iRow+1,iCol+1].Font.Name := ASG.Font.Name;
                end;

                //字号
                if joCell.Exists('fontsize') then begin
                    ExcelApp.Cells[iRow+1,iCol+1].Font.size := joCell.fontsize/1.1;
                end else begin
                    ExcelApp.Cells[iRow+1,iCol+1].Font.Size := ASG.Font.Size/1.1;
                end;
                if sValue = '□' then begin
                    ExcelApp.Cells[iRow+1,iCol+1].Font.Size := 24;
                end;

                //字体样式
                if joCell.Exists('fontstyle') then begin
                    sStyle  := joCell.fontstyle;
                    if Length(sStyle)>=4 then begin
                        if sStyle[1]='1' then begin
                            ExcelApp.Cells[iRow+1,iCol+1].Font.Bold := True;
                        end;
                        if sStyle[2]='1' then begin
                            ExcelApp.Cells[iRow+1,iCol+1].Font.Italic := True;
                        end;
                    end;
                end;

                //单元格对齐
                case joCell.align._(0) of
                    0 : begin
                        ExcelApp.Cells[iRow+1,iCol+1].HorizontalAlignment   := xlLeft;
                    end;
                    2 : begin
                        ExcelApp.Cells[iRow+1,iCol+1].HorizontalAlignment   := xlRight;
                    end;
                else
                        ExcelApp.Cells[iRow+1,iCol+1].HorizontalAlignment   := xlCenter;
                end;
                case joCell.align._(1) of
                    0 : begin
                        ExcelApp.Cells[iRow+1,iCol+1].VerticalAlignment     := xlTop;
                    end;
                    2 : begin
                        ExcelApp.Cells[iRow+1,iCol+1].VerticalAlignment     := xlBottom;
                    end;
                else
                        ExcelApp.Cells[iRow+1,iCol+1].VerticalAlignment     := xlCenter;
                end;

            end;
        end;

        //取得HINT对象joHint
        joHint  := _json(ASG.Hint);
        if joHint = unassigned then begin
            joHint  := _json('{}');
        end;

        //基本网格线
        iR1 := ASG.RowCount;
        iC1 := ASG.ColCount;
        oWS.Range[oWS.Cells[1,1],oWS.Cells[iR1,iC1]].Borders.linestyle  := 1;//xlContinuous	1
        oWS.Range[oWS.Cells[1,1],oWS.Cells[iR1,iC1]].Borders.color      := ASG.GradientEndColor;

        //绘制边框（目前一律2像素黑框）
        if joHint.Exists('borders') then begin
            joBorders   := joHint.borders;
            for iBorder := 0 to joBorders._Count-1 do begin
                joBorder    := joBorders._(iBorder);
                //
                joStart     := joBorder.start;
                joEnd       := joBorder.end;
                //
                iR0 := joStart._(1)+1;
                iC0 := joStart._(0)+1;
                iR1 := joEnd._(1)+1;
                iC1 := joEnd._(0)+1;

                //左
                oWS.Range[oWS.Cells[iR0,iC0],oWS.Cells[iR1,iC0]].Borders[1].Weight := 3;
                //右
                oWS.Range[oWS.Cells[iR0,iC1],oWS.Cells[iR1,iC1]].Borders[2].Weight := 3;
                //顶
                oWS.Range[oWS.Cells[iR0,iC0],oWS.Cells[iR0,iC1]].Borders[3].Weight := 3;
                //底
                oWS.Range[oWS.Cells[iR1,iC0],oWS.Cells[iR1,iC1]].Borders[4].Weight := 3;
            end;
        end;

        //9) 在第8行之前插入分页符：
        //ExcelApp.WorkSheets[1].Rows[8].PageBreak := 1;

        //10) 在第8列之前删除分页符：
        //ExcelApp.ActiveSheet.Columns[4].PageBreak := 0;

        //11) 指定边框线宽度：
        //ExcelApp.ActiveSheet.Range[ 'B3:D4' ].Borders[2].Weight := 3;
        //1-左    2-右   3-顶    4-底   5-斜( \ )     6-斜( / )

        //12) 清除第一行第四列单元格公式：
        //ExcelApp.ActiveSheet.Cells[1,4].ClearContents;

        //13) 设置第一行字体属性：
        //ExcelApp.ActiveSheet.Rows[1].Font.Name := '隶书';
        //ExcelApp.ActiveSheet.Rows[1].Font.Color  := clBlue;
        //ExcelApp.ActiveSheet.Rows[1].Font.Bold   := True;
        //ExcelApp.ActiveSheet.Rows[1].Font.UnderLine := True;

        //14) 进行页面设置：

        //a.页眉：
        //    ExcelApp.ActiveSheet.PageSetup.CenterHeader := '报表演示';
        //b.页脚：
        //    ExcelApp.ActiveSheet.PageSetup.CenterFooter := '第&P页';
        //c.页眉到顶端边距2cm：
        //    ExcelApp.ActiveSheet.PageSetup.HeaderMargin := 2/0.035;
        //d.页脚到底端边距3cm：
        //    ExcelApp.ActiveSheet.PageSetup.HeaderMargin := 3/0.035;
        //e.顶边距2cm：
        //    ExcelApp.ActiveSheet.PageSetup.TopMargin := 2/0.035;
        //f.底边距2cm：
        //    ExcelApp.ActiveSheet.PageSetup.BottomMargin := 2/0.035;
        //g.左边距2cm：
        //    ExcelApp.ActiveSheet.PageSetup.LeftMargin := 2/0.035;
        //h.右边距2cm：
        //    ExcelApp.ActiveSheet.PageSetup.RightMargin := 2/0.035;
        //i.页面水平居中：
        //    ExcelApp.ActiveSheet.PageSetup.CenterHorizontally := 2/0.035;
        //j.页面垂直居中：
        //    ExcelApp.ActiveSheet.PageSetup.CenterVertically := 2/0.035;
        //k.打印单元格网线：
        //    ExcelApp.ActiveSheet.PageSetup.PrintGridLines := True;

        //15) 拷贝操作：

        //a.拷贝整个工作表：
        //    ExcelApp.ActiveSheet.Used.Range.Copy;
        //b.拷贝指定区域：
        //    ExcelApp.ActiveSheet.Range[ 'A1:E2' ].Copy;
        //c.从A1位置开始粘贴：
        //    ExcelApp.ActiveSheet.Range.[ 'A1' ].PasteSpecial;
        //d.从文件尾部开始粘贴：
        //    ExcelApp.ActiveSheet.Range.PasteSpecial;

        //16) 插入一行或一列：
        //a. ExcelApp.ActiveSheet.Rows[2].Insert;
        //b. ExcelApp.ActiveSheet.Columns[1].Insert;

        //17) 删除一行或一列：
        //a. ExcelApp.ActiveSheet.Rows[2].Delete;
        //b. ExcelApp.ActiveSheet.Columns[1].Delete;

        //18) 打印预览工作表：
        //ExcelApp.ActiveSheet.PrintPreview;

        //19) 打印输出工作表：
        //ExcelApp.ActiveSheet.PrintOut;

        //20) 工作表保存：
        //if not ExcelApp.ActiveWorkBook.Saved then
        //   ExcelApp.ActiveSheet.PrintPreview;

        ExcelApp.DisplayAlerts := False;
        ExcelApp.WorkBooks[ExcelApp.WorkBooks.Count].SaveAS(AFileName);
        ExcelApp.activeWorkBook.saved := true;
        ExcelApp.workbooks.close;
        ExcelApp.quit;

{
        //21) 工作表另存为：
        //ExcelApp.SaveAs( AFileName );
        ExcelApp.DisplayAlerts := False;
        ExcelApp.ActiveWorkbook.SaveAs(AFileName,   xlNormal,   '',   '',   False,   False);
        ExcelApp.DisplayAlerts := True;

        //22) 放弃存盘：
        ExcelApp.ActiveWorkBook.Saved := True;

        //23) 关闭工作簿：
        ExcelApp.WorkBooks.Close;

        //24) 退出 Excel：
        ExcelApp.Quit;
}
    except
        Result      := -1;
    end;
end;


function dwsgSaveToFile(ASG:TStringGrid;AFileName:String):Integer;
var
    iCol,iRow   : Integer;
    joSG        : Variant;
    joCell      : Variant;
begin
    Result      := 0;
    try
        //创建JSON对象
        joSG        := _json('{}');

        with ASG do begin
            //保存SG基本属性
            joSG.helpkeyword        := HelpKeyword;
            joSG.rowcount           := RowCount;
            joSG.colcount           := ColCount;
            joSG.bordercolor        := GradientEndColor;
            joSG.fontname           := Font.Name;
            joSG.fontsize           := font.Size;
            joSG.fontcolor          := font.Color;
            joSG.fontstyle          := FontStyleToStr(font.Style);
            joSG.fixedcols          := FixedCols;
            joSG.fixedrows          := FixedRows;
            joSG.defaultrowheight   := DefaultRowHeight;
            joSG.defaultcolwidth    := DefaultColWidth;
            joSG.hint               := Hint;

            //保存行列SIZe
            joSG.rowheights     := _json('[]');
            for iRow := 0 to RowCount-1 do begin
                joSG.rowheights.add(RowHeights[iRow]);
            end;
            joSG.colwidths      := _json('[]');
            for iCol := 0 to ColCount-1 do begin
                joSG.colwidths.add(ColWidths[iCol]);
            end;

            //保存单元格信息
            joSG.cells          := _json('[]');
            for iRow := 0 to RowCount-1 do begin
                for iCol := 0 to ColCount-1 do begin
                    //跳过空的单元格
                    if Cells[iCol,iRow] = '' then begin
                        Continue;
                    end;

                    //
                    joCell  := _json('{}');
                    joCell.row      := iRow;
                    joCell.col      := iCol;
                    joCell.data     := Cells[iCol,iRow];

                    //
                    joSG.cells.add(joCell);
                end;
            end;
        end;

        //保存到文件
        JSONReformatToFile(DocVariantData(joSG).ToJSON(),AFileName);
    except
        Result      := -1;
    end;
end;

function dwsgLoadFromFile(ASG:TStringGrid;AFileName:String):Integer;
var
    iCol,iRow   : Integer;
    iCell       : Integer;
    joSG        : Variant;
    joCell      : Variant;
begin
    Result      := 0;
    try
        //创建JSON对象
        joSG        := _json('{}');
        DocVariantData(joSG).InitJSONFromFile(AFileName);

        //
        with ASG do begin
            //保存SG基本属性
            RowCount            := joSG.rowcount;
            ColCount            := joSG.colcount;
            GradientEndColor    := joSG.bordercolor;
            Font.Name           := joSG.fontname;
            font.Size           := joSG.fontsize;
            font.Color          := joSG.fontcolor;
            font.Style          := StrToFontStyle(joSG.fontstyle);
            FixedCols           := joSG.fixedcols;
            FixedRows           := joSG.fixedrows;
            DefaultRowHeight    := joSG.defaultrowheight;
            DefaultColWidth     := joSG.defaultcolwidth;
            Hint                := joSG.hint;

            //行列SIZe
            for iRow := 0 to RowCount-1 do begin
                RowHeights[iRow]    := joSG.rowheights._(iRow);
            end;
            for iCol := 0 to ColCount-1 do begin
                ColWidths[iCol]     := joSG.colwidths._(iCol);
            end;

            //清空数据
            for iRow := 0 to RowCount-1 do begin
                for iCol := 0 to ColCount-1 do begin
                    Cells[iCol,iRow]    := '';
                end;
            end;

            //单元格信息
            for iCell := 0 to joSG.cells._Count -1 do begin
                joCell  := joSG.cells._(iCell);
                //
                iCol    := joCell.col;
                iRow    := joCell.row;
                Cells[iCol,iRow]    := joCell.data;
            end;
        end;

    except
        Result      := -1;
    end;
end;



function dwsgGetCell(ASG:TStringGrid;ACol,ARow,AIndex : Integer):String;
var
    joCell  : Variant;
begin
    try
        //默认返回值
        Result  := '';

        //异常检查
        if (AIndex<0) or (ACol<0) or (ACol>=ASG.ColCount) or (ARow<0) or (ARow>=ASG.RowCount) then begin
            Exit;
        end;

        //转JSON
        joCell  := _json(ASG.Cells[ACol,ARow]);

        //默认格式
        if joCell = unassigned then begin
            joCell  := _json('{}');
            joCell.data := ASG.Cells[ACol,ARow];
        end;

        //检查value
        if not joCell.Exists('value') then begin
            joCell.value    := _json('[""]');
            if joCell.Exists('data') then begin
                DocVariantData(joCell.value).Values[0]  := joCell.data;
            end;
        end;

        //取得返回值
        if AIndex < joCell.value._Count then begin
            Result  := joCell.value._(AIndex);
        end;
    except
        Result  := '';
    end;
end;

function dwsgSetCell(ASG:TStringGrid;ACol,ARow,AIndex : Integer;AValue:String):Integer;
var
    //
    iItem   : Integer;
    //
    sFull   : string;
    sId     : String;
    sCode   : String;
    sPrefix : string;
    //
    joCell  : Variant;
    joItems : Variant;
    joItem  : Variant;
    //
    oForm   : TForm;
begin
    //默认返回值
    Result  := 0;

    //取得FullName备用
    sFull   := dwFullName(ASG);

    //取得id备用
    sId := IntToStr(ARow*ASG.ColCount+ACol);

    //取得Form备用
    oForm   := TForm(ASG.Owner);

    //cell转JSON
    joCell  := _json(ASG.Cells[ACol,ARow]);

    //异常检查
    if joCell = unassigned then begin
        joCell  := _json('{}');
        joCell.data := ASG.Cells[ACol,ARow];
    end;

    //检查value属性
    if not joCell.Exists('value') then begin
        joCell.value    := _json('[""]');
        DocVariantData(joCell.value).Values[0]  := joCell.data;
    end;

    //完全检查
    _CheckCell(joCell);

    //
    if (joCell.type = 'label') or (joCell.type = 'edit') or (joCell.type = 'memo') or (joCell.type = 'combo')then begin//=========================
        //将当前单元格的值以JSON的形式写入到CELL
        DocVariantData(joCell.value).Values[0] := AValue;
        ASG.Cells[ACol,ARow]    := joCell;

        //生成更改前端显示的JS代码
        sCode   := StringReplace(AValue,'"','\"',[rfReplaceAll]);
        sCode   := 'this.'+sFull+'__c'+sId+'__dat="'+sCode+'";';
        oForm.HelpFile  := oForm.HelpFile + sCode;
    end else if joCell.type = 'check' then begin             //=========================
        if LowerCase(AValue)='true' then begin
            AValue  := 'true';
        end else begin
            AValue  := 'false';
        end;
        //将当前单元格的值以JSON的形式写入到CELL
        DocVariantData(joCell.value).Values[0] := AValue;
        ASG.Cells[ACol,ARow]    := joCell;

        //生成更改前端显示的JS代码
        sCode   := 'this.'+sFull+'__c'+sId+'__dat='+AValue+';';
        oForm.HelpFile  := oForm.HelpFile + sCode;
    end else if joCell.type = 'spin' then begin             //=========================
        AValue  := IntToStr(StrToIntDef(AValue,0));
        //将当前单元格的值以JSON的形式写入到CELL
        DocVariantData(joCell.value).Values[0] := AValue;
        ASG.Cells[ACol,ARow]    := joCell;

        //生成更改前端显示的JS代码
        sCode   := 'this.'+sFull+'__c'+sId+'__dat='+AValue+';';
        oForm.HelpFile  := oForm.HelpFile + sCode;
    end else if joCell.type = 'group' then begin             //=========================
        if joCell.Exists('items') then begin
            //得到group控件组合JSON数组
            joItems := joCell.items;

            for iItem := 0 to joItems._Count-1 do begin
                //得到控件JSON
                joItem  := joItems._(iItem);
                //检查属性完整性
                //_CheckItem(joItem);
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

    //将value._(0)写入data，以解决刷新问题
    if joCell.Exists('value') then begin
        joCell.data := joCell.value._(0);
        ASG.Cells[ACol,ARow]    := joCell;
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

        //
        if not AJson.Exists('src') then begin
            AJson.src  := '';
        end;
    end else if  AJson.type = 'group' then begin                  //==========================================

        //
        if not AJson.Exists('items') then begin
            AJson.items  := _json('[]');
        end;
    end;
end;



end.
