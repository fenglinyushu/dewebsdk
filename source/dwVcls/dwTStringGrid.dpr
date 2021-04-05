library dwTStringGrid;

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

//从复合的标题（如：[center]籍贯） 得到标题
function _GetColCaption(AText:String):String;
begin
     Result    := AText;
     Result    := StringReplace(Result,'[left]','',[]);
     Result    := StringReplace(Result,'[center]','',[]);
     Result    := StringReplace(Result,'[right]','',[]);
end;

//从复合的标题（如：[center]籍贯） 得到标题
function _GetColAlign(AText:String):String;
begin
     Result    := '';
     if Pos('[center]',AText)>0 then begin
          Result    := ' align="center"';
     end else if Pos('[right]',AText)>0 then begin
          Result    := ' align="right"';
     end;
end;


//当前控件需要引入的第三方JS/CSS ,一般为不做改动,目前仅在TChart使用时需要用到
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
     joRes     : Variant;
begin
     //
     with TStringGrid(ACtrl) do begin
          if HelpKeyword = 'easy' then begin
               //Vue easy table-------------------------------------------------

               //生成返回值数组
               joRes    := _Json('[]');

               //引入对应的库
               joRes.Add('<script src="dist/_easytable/index.js"></script>');
               joRes.Add('<link rel="stylesheet" href="dist/_easytable/index.css">');

               //
               Result    := joRes;
          end else begin
               //Element table -------------------------------------------------

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
     end;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData    : Variant;
begin

     //
     with TStringGrid(ACtrl) do begin
          if HelpKeyword = 'easy' then begin
               //Vue easy table-------------------------------------------------

          end else begin
               //Element table -------------------------------------------------

               //
               joData    := _Json(AData);
               if joData.e = 'onclick' then begin
                    //保存事件
                    TStringGrid(ACtrl).OnExit    := TStringGrid(ACtrl).OnClick;
                    //清空事件,以防止自动执行
                    TStringGrid(ACtrl).OnClick  := nil;
                    //更新值
                    TStringGrid(ACtrl).Row   := joData.v;
                    //恢复事件
                    TStringGrid(ACtrl).OnClick  := TStringGrid(ACtrl).OnExit;

                    //执行事件
                    if Assigned(TStringGrid(ACtrl).OnClick) then begin
                         TStringGrid(ACtrl).OnClick(TStringGrid(ACtrl));
                    end;
               end else if joData.e = 'onenter' then begin
               end;

               //清空OnExit事件
               TStringGrid(ACtrl).OnExit  := nil;
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
     sRowStyle : string;
     sBack     : string;
     //
     joHint    : Variant;
     joRes     : Variant;
     joCols    : Variant;
     joCol     : Variant;
     procedure _AddChildCol(ACol:Variant;var AColID:Integer;ASG:TStringGrid);
     var
          iiItem    : Integer;
          sSort     : String;      //排序
          sAlign    : String;      //对齐
          sFilter   : String;      //过滤
     begin
          if ACol.Exists('items') then begin
               joRes.Add('        <el-table-column label="'+ACol.Caption+'">');
               for iiItem := 0 to ACol.items._Count-1 do begin
                    _AddChildCol(ACol.items._(iiItem),AColID,ASG);
               end;
               joRes.Add('        </el-table-column>');
          end else begin
               //取得排序
               sSort     := '';
               if ACol.Exists('sort') then begin
                    if ACol.sort = 1 then begin
                         sSort     := ' sortable :sort-by="[''d'+IntToStr(AColID+1)+''']"';
                    end;
               end;

               //取得对齐
               sAlign    := '';
               if ACol.Exists('align') then begin
                    sAlign    :=  ' align="'+ACol.align+'"';
               end;

               //取得过滤   //:filters="[{ text: '家', value: '家' }, { text: '公司', value: '公司' }]"
               sFilter   := '';
               if ACol.Exists('filters') then begin
                    sFilter    := '[';
                    for iiItem := 0 to ACol.filters._Count-1 do begin
                         sFilter   := sFilter + Format('{ text:''%s'',value:''%s''},',[ACol.filters._(iiItem),ACol.filters._(iiItem)]);
                    end;
                    //删除最后的逗号
                    if Length(sFilter)>2 then begin
                         Delete(sFilter,Length(sFilter),1);
                    end;
                    sFilter    := ' :filters="'+sFilter+']" :filter-method="filterHandler"';
               end;


               //组成列字符串
               joRes.Add('        <el-table-column'
                         +dwIIF(AColID<ASG.FixedCols,' fixed="left"','')
                         +' show-overflow-tooltip'
                         +' prop="d'+IntToStr(AColID+1)+'"'
                         +sSort    //排序  sortable
                         +sAlign   //对齐，align="right"'
                         +sFilter  //过滤  :filters="[{ text: '家', value: '家' }, { text: '公司', value: '公司' }]
                         +' :label="'+dwPrefix(Actrl)+ASG.Name+'__col'+IntToStr(AColID)+'"'
                         +' width="'+IntToStr(ASG.ColWidths[AColID])+'"></el-table-column>');
               //
               Inc(AColID);
          end;
     end;
begin
     //
     with TStringGrid(ACtrl) do begin
          if HelpKeyword = 'easy' then begin
               //Vue easy table-------------------------------------------------
               (*
                   <v-table
                            :width="1000"
                            :columns="columns"
                            :table-data="tableData"
                            :show-vertical-border="false"
                   ></v-table>
               *)
               //生成返回值数组
               joRes    := _Json('[]');

               //取得HINT对象JSON
               joHint    := dwGetHintJson(TControl(ACtrl));

               //
               with TStringGrid(ACtrl) do begin
                    //添加外框
                    joRes.Add('<div' +dwLTWH(TControl(ACtrl))+'">');

                    //添加主体
                    joRes.Add('    <v-table'
                              +' :columns="'+dwPrefix(Actrl)+Name+'__clm"'     //column
                              +' :table-data="'+dwPrefix(Actrl)+Name+'__tbd"'  //table-data
                              //+' :show-vertical-border="false"'            //参考名?
                              //+' row-hover-color="#eee"'
                              //+' row-click-color="#edf7ff"'
                              +' '+dwGetJsonAttr(joHint,'dwstyle')
                              //+' stripe'                  //斑马纹
                              //+dwIIF(Borderstyle<>bsNone,' border','')     //是否边框
                              //+dwVisible(TControl(ACtrl))                  //是否可见
                              //+dwDisable(TControl(ACtrl))                  //是否可用
                              //+' height="'+IntToStr(TControl(ACtrl).Height)+'"' //高度, 有此值则显示滚动条
                              //+' :height="'+dwPrefix(Actrl)+Name+'__hei"' //高度, 有此值则显示滚动条
                              //+' style="width:100%"'                            //宽度
                              //+Format(_DWEVENT,['row-click',Name,'val.d0','onclick',TForm(Owner).Handle])
                              +'>');

               end;

               //
               Result    := (joRes);

          end else begin
               //Element table -------------------------------------------------

               //生成返回值数组
               joRes    := _Json('[]');

               //取得HINT对象JSON
               joHint    := dwGetHintJson(TControl(ACtrl));

               //
               with TStringGrid(ACtrl) do begin
                    //
                    sRowStyle := ' :row-style="{height:'''+IntToStr(DefaultRowHeight)+'px''}"'
                              +' :header-row-style="{height:'''+IntToStr(DefaultRowHeight)+'px''}"';     //行高和字体     ,color:''red''

                    //
                    if joHint.Exists('background') then begin
                         sRowStyle := sRowStyle + ' :header-cell-style="{background:'''+joHint.background+'''}"'; //背景色
                    end;

                    //添加外框
                    joRes.Add('<div'
                              +dwLTWH(TControl(ACtrl))
                              +'"' //style 封闭
                              +'>');
                    //添加主体
                    joRes.Add('    <el-table'
                              +' :data="'+dwPrefix(Actrl)+Name+'__ces"'     //行内数据
                              +' highlight-current-row'     //当前行高亮
                              +sRowStyle
                              +' ref="'+dwPrefix(Actrl)+Name+'"'            //参考名?
                              +dwGetDWStyle(joHint)
                              //+' stripe'                  //斑马纹
                              //+dwIIF(Borderstyle<>bsNone,' border','')     //是否边框
                              +dwVisible(TControl(ACtrl))                  //是否可见
                              +dwDisable(TControl(ACtrl))                  //是否可用
                              //+' height="'+IntToStr(TControl(ACtrl).Height)+'"' //高度, 有此值则显示滚动条
                              +' :height="'+dwPrefix(Actrl)+Name+'__hei"' //高度, 有此值则显示滚动条
                              +' style="width:100%"'                            //宽度
                              +Format(_DWEVENT,['row-click',Name,'val.d0','onclick',TForm(Owner).Handle])
                              +'>');

                    //添加另外加的行号列, 用于表示行号
                    joRes.Add('        <el-table-column'
                         +' show-overflow-tooltip'
                         +' fixed'
                         +' v-if=false'
                         +' prop="d0"'
                         +' label="rowno"'
                         +' width="10"'
                         +'></el-table-column>');



                    //添加各列
                    if (not dwIsNull(joHint)) then begin
                         if  joHint.Exists('columns') then begin
                              //===以下为多表头的情况
                              joCols    := joHint.columns;
                              iColiD    := 0;
                              for iItem := 0 to joCols._Count-1 do begin
                                   joCol     := joCols._(iItem);
                                   _AddChildCol(joCol,iColID,TStringGrid(ACtrl));
                              end;
                         end;

                    end else begin
                         //===以下为正常表头的情况
                         for iItem := 0 to ColCount-1 do begin
                              joRes.Add('        <el-table-column'
                                        +dwIIF(iItem<FixedCols,' fixed="left"','')
                                        +' show-overflow-tooltip'
                                        +' prop="d'+IntToStr(iItem+1)+'"'
                                        +_GetColAlign(Cells[iItem,0])
                                        +' :label="'+dwPrefix(Actrl)+Name+'__col'+IntToStr(iItem)+'"'
                                        +' width="'+IntToStr(ColWidths[iItem])+'"></el-table-column>');
                         end;
                    end;
               end;

               //
               Result    := (joRes);
          end;
     end;
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //
     with TStringGrid(ACtrl) do begin
          if HelpKeyword = 'easy' then begin
               //Vue easy table-------------------------------------------------

               //生成返回值数组
               joRes    := _Json('[]');

               //生成返回值数组
               joRes.Add('    </v-table>');
               joRes.Add('</div>');

               //
               Result    := (joRes);
          end else begin
               //Element table -------------------------------------------------

               //生成返回值数组
               joRes    := _Json('[]');

               //生成返回值数组
               joRes.Add('    </el-table>');
               joRes.Add('</div>');

               //
               Result    := (joRes);
          end;
     end;
end;

function _GetTableData(ACtrl:TControl):string;
var
     S         : string;
     iRow,iCol : Integer;
begin
     with TStringGrid(ACtrl) do begin
          S    := '[';
          for iRow := 1 to RowCount-1 do begin
               S := S + '{';
               for iCol := 0 to ColCount-1 do begin
                    S := S + '"col'+IntToStr(iCol)+'":'''+Cells[iCol,iRow]+''',';
               end;
               Delete(S,Length(S),1);
               S := S + '},'#13;
          end;
          Delete(S,Length(S)-1,2);
          S := S + ']';
     end;
     //
     Result    := S;
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
          if HelpKeyword = 'easy' then begin
               //Vue easy table-------------------------------------------------
               (*
                       tableData: [
                         { "name": "熊猫金币30g", "last": "156.1", "percent": "-1.76", "earning": "5.6" },
                         { "name": "黄金9995", "last": "182.1", "percent": "1.06", "earning": "12.5" },
                         { "name": "国际版黄金9999", "last": "161.0", "percent": "-0.76", "earning": "18.2" },
                         { "name": "白银T+D", "last": "197.1", "percent": "1.26", "earning": "14.7" },
                         { "name": "Mini黄金T+D", "last": "183.6", "percent": "2.76", "earning": "18.7" }
                       ],
                       columns: [
                         { field: 'name', title: '名称', width: 50, titleAlign: 'left', columnAlign: 'left', titleCellClassName: 'title-cell-class-name', isResize: true },
                         // formatter: function (rowData, rowIndex, pagingIndex, field) {
                         //   return rowIndex < 3 ? '<span style="color:red;font-weight: bold;">' + (rowIndex + 1) + '</span>' : rowIndex + 1
                         // }
                         { field: 'last', title: '最新', width: 50, titleAlign: 'right', columnAlign: 'right', titleCellClassName: 'title-cell-class-name', isResize: true },
                         { field: 'percent', title: '涨幅%', width: 50, titleAlign: 'right', columnAlign: 'right', titleCellClassName: 'title-cell-class-name', orderBy: 'desc', isResize: true },
                         { field: 'earning', title: '涨跌', width: 50, titleAlign: 'right', columnAlign: 'right', titleCellClassName: 'title-cell-class-name', isResize: true }
                       ]
               *)
               //生成返回值数组
               joRes    := _Json('[]');
               //
               with TStringGrid(ACtrl) do begin

                    //
                    joRes.Add(dwPrefix(Actrl)+Name+'__lef:"'+IntToStr(Left)+'px",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__top:"'+IntToStr(Top)+'px",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__wid:"'+IntToStr(Width)+'px",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__hei:"'+IntToStr(Height)+'px",');
                    //
                    joRes.Add(dwPrefix(Actrl)+Name+'__vis:'+dwIIF(Visible,'true,','false,'));
                    joRes.Add(dwPrefix(Actrl)+Name+'__dis:'+dwIIF(Enabled,'false,','true,'));

                    //tableData
                    S := dwPrefix(Actrl)+Name+'__tbd:'+_GetTableData(ACtrl)+','#13;
                    joRes.Add(S);

                    //columns
                    S := dwPrefix(Actrl)+Name+'__clm: [';
                    for iCol := 0 to ColCount-1 do begin
                         S := S + '{field:''col'+IntToStr(iCol)+''','
                                   +'title:'''+Cells[iCol,0]+''','
                                   +'width:'+IntToStr(ColWidths[iCol])+','
                                   +'titleAlign: ''left'','
                                   +'columnAlign: ''left'','
                                   +'titleCellClassName: ''title-cell-class-name'','
                                   +'isEdit:true,'
                                   +'sResize:true},'#13;
                    end;
                    Delete(S,Length(S)-1,2);
                    S := S + '],'#13;

                    joRes.Add(S);
               end;
               //
               Result    := (joRes);
          end else begin
               //Element table -------------------------------------------------

               //生成返回值数组
               joRes    := _Json('[]');
               //
               with TStringGrid(ACtrl) do begin

                    //
                    joRes.Add(dwPrefix(Actrl)+Name+'__lef:"'+IntToStr(Left)+'px",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__top:"'+IntToStr(Top)+'px",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__wid:"'+IntToStr(Width)+'px",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__hei:"'+IntToStr(Height)+'px",');
                    //
                    joRes.Add(dwPrefix(Actrl)+Name+'__vis:'+dwIIF(Visible,'true,','false,'));
                    joRes.Add(dwPrefix(Actrl)+Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
                    //列标题
                    for iCol := 0 to ColCount-1 do begin
                         joRes.Add(dwPrefix(Actrl)+Name+'__col'+IntToStr(iCol)+':"'+_GetColCaption(Cells[iCol,0])+'",');
                    end;


                    //内容
                    sCode     := dwPrefix(Actrl)+Name+'__ces:[';
                    for iRow := 1 to RowCount-1 do begin
                         sCode     := sCode + '{"d0":'''+IntToStr(iRow)+''',';
                         for iCol := 0 to ColCount-1 do begin
                              sCode     := sCode + '"d'+IntToStr(iCol+1)+'":'''+Cells[iCol,iRow]+''',';
                         end;
                         sCode     := sCode + '},';
                    end;
                    sCode     := sCode + '],';
                    joRes.Add(sCode);
                    //joRes.Add('currentRow: 1,');
               end;
               //
               Result    := (joRes);
          end;
     end;
end;



//取得Method
function dwGetMethod(ACtrl:TControl):string;StdCall;
var
     joRes     : Variant;
     //
     iRow,iCol : Integer;
     sCode     : String;
begin
     //
     with TStringGrid(ACtrl) do begin
          if HelpKeyword = 'easy' then begin
               //Vue easy table-------------------------------------------------

               //生成返回值数组
               joRes    := _Json('[]');

               //
               with TStringGrid(ACtrl) do begin
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lef="'+IntToStr(Left)+'px";');
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__top="'+IntToStr(Top)+'px";');
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__wid="'+IntToStr(Width)+'px";');
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__hei="'+IntToStr(Height)+'px";');
                    //
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__vis='+dwIIF(Visible,'true;','false;'));
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__dis='+dwIIF(Enabled,'false;','true;'));

                    //tableData
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__tbd='+_GetTableData(ACtrl)+';');


               end;
               //
               Result    := (joRes);
          end else begin
               //Element table -------------------------------------------------

               //生成返回值数组
               joRes    := _Json('[]');

               //
               with TStringGrid(ACtrl) do begin
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lef="'+IntToStr(Left)+'px";');
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__top="'+IntToStr(Top)+'px";');
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__wid="'+IntToStr(Width)+'px";');
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__hei="'+IntToStr(Height)+'px";');
                    //
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__vis='+dwIIF(Visible,'true;','false;'));
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__dis='+dwIIF(Enabled,'false;','true;'));

                    //列标题
                    for iCol := 0 to ColCount-1 do begin
                         joRes.Add('this.'+dwPrefix(Actrl)+Name+'__col'+IntToStr(iCol)+'="'+Cells[iCol,0]+'";');
                    end;


                    //内容
                    for iRow := 1 to RowCount-1 do begin
                         sCode     := 'this.$set(this.'+dwPrefix(Actrl)+TStringGrid(ACtrl).Name+'__ces,'+IntToStr(iRow-1)+',{d0:"'+IntToStr(iRow)+'",';
                         for iCol := 0 to ColCount-2 do begin
                              sCode     := sCode +'d'+IntToStr(iCol+1)+':"'+Cells[iCol,iRow]+'",';
                         end;
                         sCode     := sCode +'d'+IntToStr(ColCount)+':"'+Cells[ColCount-1,iRow]+'"});';
                         joRes.Add(sCode);
                    end;
                    //行号
                    joRes.Add('this.$refs.'+dwPrefix(Actrl)+Name+'.setCurrentRow(this.$refs.'+dwPrefix(Actrl)+Name+'.data['+IntToStr(Row-1)+']);');
               end;
               //
               Result    := (joRes);
          end;
     end;
end;



exports
     //dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetMethod,
     dwGetData;

begin
end.
 
