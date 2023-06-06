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

//处理cells,以防止出错
function _ProcessCell(ACell:String):String;
begin
    Result  := ACell;
    Result  := StringReplace(Result,'\','\\',[rfReplaceAll]);
    Result  := StringReplace(Result,'"','\"',[rfReplaceAll]);
end;


//从复合的标题（如：[center]籍贯） 得到标题
function _GetColCaption(AText:String):String;
var
    joCol   : Variant;
begin
    Result    := AText;
    if dwStrIsJson(AText) then begin
        joCol := _Json(AText);
        if joCol.Exists('caption') then begin
            Result  := joCol.caption;
        end else begin
            Result  := 'noname';
        end;
    end else begin
        Result  := _ProcessCell(Result);
        Result  := StringReplace(Result,'[*left*]','',[]);
        Result  := StringReplace(Result,'[*center*]','',[]);
        Result  := StringReplace(Result,'[*right*]','',[]);
    end;
end;

//从复合的标题（如:籍贯[*center*]） 得到标题
function _GetColAlign(AText:String):String;
begin
     Result    := '';
     if Pos('[*center*]',AText)>0 then begin
          Result    := ' align="center"';
     end else if Pos('[*right*]',AText)>0 then begin
          Result    := ' align="right"';
     end;
end;

//从列标题JSON对象中得到标题 对齐
function _GetColAlignFromJson(AJSON:Variant):String;
begin
    Result    := '';
    if AJSON.Exists('align') then begin
        if AJSON.align='center' then begin
            Result    := ' align="center"';
        end else if AJSON.align='right' then begin
            Result    := ' align="right"';
        end;
    end;
end;

//从列标题JSON对象中得到selection
function _GetColTypeFromJson(AJSON:Variant):String;
begin
    Result    := '';
    if AJSON.Exists('type') then begin
        //if AJSON.sort=True then begin
            Result    := ' type="'+AJSON.type+'"';
        //end;
    end;
end;



//从列标题JSON对象中得到排序
function _GetColSortFromJson(AJSON:Variant):String;
begin
    Result    := '';
    if AJSON.Exists('sort') then begin
        if AJSON.sort=True then begin
            Result    := ' sortable="custom"';
        end;
    end;
end;

//从列标题JSON对象中得到标题
function _GetColCaptionFromJson(AJSON:Variant):String;
begin
    Result    := 'noname';
    if AJSON.Exists('caption') then begin
        Result    := AJSON.caption;
    end;
end;

//从列标题JSON对象中得到Filter
function _GetColFilterFromJson(AJSON:Variant;AName:String;ACol:Integer;Owner:TObject):String;
begin
    Result    := '';
    if AJSON.Exists('filter') then begin
        Result    := ' :filters="'+AName+'__flt'+ACol.ToString+'"';   //:filters="StringGrid1__flt1"
                //+' :filter-method=r(value, row, column){dwevent(null,'''+AName+''',''"''+value+''/''+row+''/''+column+''"'',''onfilter'','+IntToStr(TForm(Owner).Handle)+');}'
    end;
end;


//--------------------以上为辅助函数----------------------------------------------------------------


//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    joRes     : Variant;
begin
    //
    with TStringGrid(ACtrl) do begin
        //ve-candle v-charts中的K线图-----------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');

        //需要额外引的代码
        joRes.Add('<script src="dist/_vcharts/echarts.min.js"></script>');
        joRes.Add('<script src="dist/_vcharts/lib/index.min.js"></script>');
        joRes.Add('<link rel="stylesheet" href="dist/_vcharts/lib/style.min.css">');


        //
        Result    := joRes;
    end;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
begin
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
    procedure _AddChildCol(ACol:Variant;var AColID:Integer;ASG:TStringGrid);
    var
        iiItem    : Integer;
        sSort     : String;      //排序
        sAlign    : String;      //对齐
        sFilter   : String;      //过滤
    begin
        if ACol.Exists('items') then begin
             joRes.Add('<el-table-column label="'+ACol.Caption+'">');
             for iiItem := 0 to ACol.items._Count-1 do begin
                  _AddChildCol(ACol.items._(iiItem),AColID,ASG);
             end;
             joRes.Add('</el-table-column>');
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
             joRes.Add('<el-table-column'
                       +dwIIF(AColID<ASG.FixedCols,' fixed="left"','')
                       +dwIIF(ASG.DefaultDrawing,' show-overflow-tooltip','')

                       +' prop="d'+IntToStr(AColID+1)+'"'
                       +sSort    //排序  sortable
                       +sAlign   //对齐，align="right"'
                       +sFilter  //过滤  :filters="[{ text: '家', value: '家' }, { text: '公司', value: '公司' }]
                       +' :label="'+dwFullName(Actrl)+'__col'+IntToStr(AColID)+'"'
                       +' width="'+IntToStr(ASG.ColWidths[AColID])+'"></el-table-column>');
             //
             Inc(AColID);
        end;
    end;
begin
    //
    with TStringGrid(ACtrl) do begin
        //ve-candle v-charts中的地图-----------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');

        //先添加一个外框，以更好的控制
        sCode     := '<div'
                +' id="'+dwFullName(Actrl)+'"'
                +dwVisible(TControl(ACtrl))                            //用于控制可见性Visible
                +dwLTWH(TControl(ACtrl))                               //Left/Top/Width/Height
                +'"' // 封闭style
                +'>';
        joRes.Add(sCode);

        //添加ve-candle实体
        sCode     := '    <ve-map'
                //+' :legend="'+dwFullName(Actrl)+'__lgd"'             //
                //+' :colors="'+dwFullName(Actrl)+'__clr"'             //颜色，Data中应该类似colors: ['red','green']
                //+' :legend-visible="'+dwFullName(Actrl)+'__lgv"'
                //+' :tooltip-visible="'+dwFullName(Actrl)+'__sht"'
                //+' :extend="'+dwFullName(Actrl)+'__ext"'
                //+' :settings="'+dwFullName(Actrl)+'__set"'
                //+' :grid="'+dwFullName(Actrl)+'__grd"'             //加这个报错
                //+' :title='''+dwFullName(Actrl)+'__tit'''  //没引入
                //+' :height="'+dwFullName(Actrl)+'__hei"'
                //+' :judge-width="true"'
                +' :data="'+dwFullName(Actrl)+'__dat"'
                +'>';

        //添加到返回值数据
        joRes.Add(sCode);

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
        //ve-candle v-charts中的K线图-----------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');

        //生成返回值数组
        joRes.Add('    </ve-map>');
        joRes.Add('</div>');

        //
        Result    := (joRes);
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
                    S := S + '"col'+IntToStr(iCol)+'":'''+_ProcessCell(Cells[iCol,iRow])+''',';
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
        //ve-candle v-charts中的K线图-----------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');

        //
        with TStringGrid(ACtrl) do begin

            //基本LTWH
            joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
            joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
            joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
            joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');

            //可见性和可用性
            joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
            joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(Enabled,'false,','true,'));

            //Settings
            joRes.Add(dwFullName(Actrl)+'__set : {showMA: true,showVol: true,showDataZoom: true},');

            //数据
            sCode   := dwFullName(Actrl)+'__dat : {'#13
                    +'    columns: ['''+Cells[0,0]+'''';
            for iCol := 1 to ColCount-1 do begin
                sCode   := sCode + ','''+Cells[iCol,0]+'''';
            end;
            sCode   := sCode +'],'#13
                    +'    rows: ['#13;

            for iRow := 1 to RowCount-1 do begin
                sCode   := sCode + '        {'''+Cells[0,0]+''':'''+Cells[0,iRow]+'''';
                for iCol := 1 to ColCount-1 do begin
                    sCode   := sCode + ','''+Cells[iCol,0]+''':'+Cells[iCol,iRow];
                end;
                sCode     := sCode + '},';
            end;
            if RowCount>1 then begin
                 Delete(sCode,Length(sCode),1);
            end;
            sCode     := sCode + #13'    ]'#13;
            sCode     := sCode + '},';
            joRes.Add(sCode);

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
        //ve-candle v-charts中的K线图-----------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');

        //
        with TStringGrid(ACtrl) do begin

            joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
            //
            joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));
            joRes.Add('this.'+dwFullName(Actrl)+'__dis='+dwIIF(Enabled,'false;','true;'));

            //Settings
            joRes.Add('this.'+dwFullName(Actrl)+'__set = {showMA: true,showVol: true,showDataZoom: true};');

            //数据
            sCode   := 'this.'+dwFullName(Actrl)+'__dat = {'#13
                    +'    columns: ['''+Cells[0,0]+'''';
            for iCol := 1 to ColCount-1 do begin
                sCode   := sCode + ','''+Cells[iCol,0]+'''';
            end;
            sCode   := sCode +'],'#13
                    +'    rows: ['#13;

            for iRow := 1 to RowCount-1 do begin
                sCode   := sCode + '        {'''+Cells[0,0]+''':'''+Cells[0,iRow]+'''';
                for iCol := 1 to ColCount-1 do begin
                    sCode   := sCode + ','''+Cells[iCol,0]+''':'+Cells[iCol,iRow];
                end;
                sCode     := sCode + '},';
            end;
            if RowCount>1 then begin
                 Delete(sCode,Length(sCode),1);
            end;
            sCode     := sCode + #13'    ]'#13;
            sCode     := sCode + '};';
            joRes.Add(sCode);

        end;
        //
        Result    := (joRes);
    end;
end;



exports
     dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     //dwGetMethods,
     dwGetData;

begin
end.
 
