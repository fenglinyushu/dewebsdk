library dwTStringGrid__luck;

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


//--------------------以上为辅助函数----------------------------------------------------------------


//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    joRes     : Variant;
begin
    //
    with TStringGrid(ACtrl) do begin
        //LuckDraw------------------------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');

        //引入对应的库
        joRes.Add('<script src="dist/_luckdraw/vue-luck-draw.umd.min.js"></script>');

        //
        Result    := joRes;
    end;
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
        //-------------转盘抽奖-----------------------------------------------------------------
        {
        <lucky-wheel
            ref="LuckyWheel"
            width="300px"
            height="300px"
            :prizes="prizes"
            :default-style="defaultStyle"
            :blocks="blocks"
            :buttons="buttons"
            @start="startCallBack"
            @end="endCallBack"
        />
        }

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //
        with TStringGrid(ACtrl) do begin
            //添加主体
            joRes.Add('<lucky-wheel'
                    //+' id="'+dwFullName(Actrl)+'"'
                    +' ref="'+dwFullName(Actrl)+'__ref"'
                    +' :prizes="'+dwFullName(Actrl)+'__prz"'     //prizes
                    +' :default-style="'+dwFullName(Actrl)+'__dfs"'
                    +' :blocks="'+dwFullName(Actrl)+'__blk"'
                    +' :buttons="'+dwFullName(Actrl)+'__bts"'
                    +dwVisible(TControl(ACtrl))                 //是否可见
                    +dwGetDWAttr(joHint)                        //dwAttr
                    //Style
                    +dwLTWH(TControl(ACtrl))
                    +dwGetDWStyle(joHint)
                    +'"'                            //宽度
                    +#13
                    +' @start="dwexecute(''this.$refs.'+dwFullName(Actrl)+'__ref.play();'
                            +'setTimeout(() => {this.$refs.'+dwFullName(Actrl)+'__ref.stop(Math.random() * 8 >> 0) }, 3000);'')"'
                    +' @end="function(e){dwevent(e,'''+dwFullName(Actrl)+''',e.pid,''onenddock'','''+IntToStr(TForm(Owner).Handle)+''')}"'
                    +'/>');

        end;
        //="dwevent($event,'Edit1','event.keyCode','onkeydown','1967084')" @input="dwevent($event,'Edit1','escape(this.Edit1__txt)','onchange','1967084')">


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
        //幸运大抽奖---------------------------------------------------------------------------

        //
        Result    := '[]';
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

            //奖项设置
            sCode   := dwFullName(Actrl)+'__prz :[';
            for iRow := 0 to RowCount-1 do begin
                sCode   := sCode+#13'{"pid":"'+iRow.ToString+'",';
                sCode   := sCode+'"title":"'+Cells[0,iRow]+'",';
                sCode   := sCode+'"background":"'+Cells[1,iRow]+'",';
                sCode   := sCode+'"fonts":[{"text":"'+Cells[2,iRow]+'",';
                sCode   := sCode+'"top":"'+Cells[3,iRow]+'"}],';
                sCode   := sCode+'"imgs":[{"src":"'+Cells[4,iRow]+'",';
                sCode   := sCode+'"width":"'+Cells[5,iRow]+'",';
                sCode   := sCode+'"top":"'+Cells[6,iRow]+'"}]},';
            end;
            sCode   := sCode+'],';
            joRes.Add(sCode);
            //
            (* 其他相关设置
            defaultStyle: {
                fontColor: '#d64737',
                fontSize: '14px'
            },
            blocks: [
                { padding: '13px', background: '#d64737' }
            ],
            buttons: [
                { radius: '50px', background: '#d64737' },
                { radius: '45px', background: '#fff' },
                { radius: '41px', background: '#f6c66f', pointer: true },
                {
                    radius: '35px', background: '#ffdea0',
                    imgs: [
                        { src: 'media/images/luck/button.png', width: '65%', top: '-50%' }
                    ]
                }
            ]
            *)
            //defaultStyle
            sCode   := dwFullName(Actrl)+'__dfs :{fontColor: '''+dwColor(Font.Color)+''',fontSize: '''+IntToStr(Font.Size+3)+'px''},';
            joRes.Add(sCode);
            //blocks
            sCode   := dwFullName(Actrl)+'__blk :[ { padding: ''13px'', background: ''#d64737'' }],';
            joRes.Add(sCode);
            //buttons
            sCode   := dwFullName(Actrl)+'__bts :['
                    +'{ radius: ''50px'', background: ''#d64737'' },'
                    +'{ radius: ''45px'', background: ''#fff'' },'
                    +'{ radius: ''41px'', background: ''#f6c66f'', pointer: true },'
                    +'{ radius: ''35px'', background: ''#ffdea0'', imgs: [{ src: ''image/luck/button.png'', width: ''65%'', top: ''-50%'' }]}],';
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
 
