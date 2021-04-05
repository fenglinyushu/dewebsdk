library dwTStringGrid;

uses
     ShareMem,      //�������

     //
     dwCtrlBase,    //һЩ��������

     //
     SynCommons,    //mormot���ڽ���JSON�ĵ�Ԫ

     //
     SysUtils,DateUtils,ComCtrls, ExtCtrls,
     Classes,Grids,
     Dialogs,
     StdCtrls,
     Windows,
     Controls,
     Forms;

//�Ӹ��ϵı��⣨�磺[center]���ᣩ �õ�����
function _GetColCaption(AText:String):String;
begin
     Result    := AText;
     Result    := StringReplace(Result,'[left]','',[]);
     Result    := StringReplace(Result,'[center]','',[]);
     Result    := StringReplace(Result,'[right]','',[]);
end;

//�Ӹ��ϵı��⣨�磺[center]���ᣩ �õ�����
function _GetColAlign(AText:String):String;
begin
     Result    := '';
     if Pos('[center]',AText)>0 then begin
          Result    := ' align="center"';
     end else if Pos('[right]',AText)>0 then begin
          Result    := ' align="right"';
     end;
end;


//��ǰ�ؼ���Ҫ����ĵ�����JS/CSS ,һ��Ϊ�����Ķ�,Ŀǰ����TChartʹ��ʱ��Ҫ�õ�
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
     joRes     : Variant;
begin
     //
     with TStringGrid(ACtrl) do begin
          if HelpKeyword = 'easy' then begin
               //Vue easy table-------------------------------------------------

               //���ɷ���ֵ����
               joRes    := _Json('[]');

               //�����Ӧ�Ŀ�
               joRes.Add('<script src="dist/_easytable/index.js"></script>');
               joRes.Add('<link rel="stylesheet" href="dist/_easytable/index.css">');

               //
               Result    := joRes;
          end else begin
               //Element table -------------------------------------------------

               //���ɷ���ֵ����
               joRes    := _Json('[]');

               {
               //������TChartʱ�Ĵ���,���ο�
               joRes.Add('<script src="dist/charts/echarts.min.js"></script>');
               joRes.Add('<script src="dist/charts/lib/index.min.js"></script>');
               joRes.Add('<link rel="stylesheet" href="dist/charts/lib/style.min.css">');
               }

               //
               Result    := joRes;
          end;
     end;
end;

//����JSON����ADataִ�е�ǰ�ؼ����¼�, �����ؽ���ַ���
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
                    //�����¼�
                    TStringGrid(ACtrl).OnExit    := TStringGrid(ACtrl).OnClick;
                    //����¼�,�Է�ֹ�Զ�ִ��
                    TStringGrid(ACtrl).OnClick  := nil;
                    //����ֵ
                    TStringGrid(ACtrl).Row   := joData.v;
                    //�ָ��¼�
                    TStringGrid(ACtrl).OnClick  := TStringGrid(ACtrl).OnExit;

                    //ִ���¼�
                    if Assigned(TStringGrid(ACtrl).OnClick) then begin
                         TStringGrid(ACtrl).OnClick(TStringGrid(ACtrl));
                    end;
               end else if joData.e = 'onenter' then begin
               end;

               //���OnExit�¼�
               TStringGrid(ACtrl).OnExit  := nil;
          end;
     end;

end;



//ȡ��HTMLͷ����Ϣ
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
          sSort     : String;      //����
          sAlign    : String;      //����
          sFilter   : String;      //����
     begin
          if ACol.Exists('items') then begin
               joRes.Add('        <el-table-column label="'+ACol.Caption+'">');
               for iiItem := 0 to ACol.items._Count-1 do begin
                    _AddChildCol(ACol.items._(iiItem),AColID,ASG);
               end;
               joRes.Add('        </el-table-column>');
          end else begin
               //ȡ������
               sSort     := '';
               if ACol.Exists('sort') then begin
                    if ACol.sort = 1 then begin
                         sSort     := ' sortable :sort-by="[''d'+IntToStr(AColID+1)+''']"';
                    end;
               end;

               //ȡ�ö���
               sAlign    := '';
               if ACol.Exists('align') then begin
                    sAlign    :=  ' align="'+ACol.align+'"';
               end;

               //ȡ�ù���   //:filters="[{ text: '��', value: '��' }, { text: '��˾', value: '��˾' }]"
               sFilter   := '';
               if ACol.Exists('filters') then begin
                    sFilter    := '[';
                    for iiItem := 0 to ACol.filters._Count-1 do begin
                         sFilter   := sFilter + Format('{ text:''%s'',value:''%s''},',[ACol.filters._(iiItem),ACol.filters._(iiItem)]);
                    end;
                    //ɾ�����Ķ���
                    if Length(sFilter)>2 then begin
                         Delete(sFilter,Length(sFilter),1);
                    end;
                    sFilter    := ' :filters="'+sFilter+']" :filter-method="filterHandler"';
               end;


               //������ַ���
               joRes.Add('        <el-table-column'
                         +dwIIF(AColID<ASG.FixedCols,' fixed="left"','')
                         +' show-overflow-tooltip'
                         +' prop="d'+IntToStr(AColID+1)+'"'
                         +sSort    //����  sortable
                         +sAlign   //���룬align="right"'
                         +sFilter  //����  :filters="[{ text: '��', value: '��' }, { text: '��˾', value: '��˾' }]
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
               //���ɷ���ֵ����
               joRes    := _Json('[]');

               //ȡ��HINT����JSON
               joHint    := dwGetHintJson(TControl(ACtrl));

               //
               with TStringGrid(ACtrl) do begin
                    //������
                    joRes.Add('<div' +dwLTWH(TControl(ACtrl))+'">');

                    //�������
                    joRes.Add('    <v-table'
                              +' :columns="'+dwPrefix(Actrl)+Name+'__clm"'     //column
                              +' :table-data="'+dwPrefix(Actrl)+Name+'__tbd"'  //table-data
                              //+' :show-vertical-border="false"'            //�ο���?
                              //+' row-hover-color="#eee"'
                              //+' row-click-color="#edf7ff"'
                              +' '+dwGetJsonAttr(joHint,'dwstyle')
                              //+' stripe'                  //������
                              //+dwIIF(Borderstyle<>bsNone,' border','')     //�Ƿ�߿�
                              //+dwVisible(TControl(ACtrl))                  //�Ƿ�ɼ�
                              //+dwDisable(TControl(ACtrl))                  //�Ƿ����
                              //+' height="'+IntToStr(TControl(ACtrl).Height)+'"' //�߶�, �д�ֵ����ʾ������
                              //+' :height="'+dwPrefix(Actrl)+Name+'__hei"' //�߶�, �д�ֵ����ʾ������
                              //+' style="width:100%"'                            //���
                              //+Format(_DWEVENT,['row-click',Name,'val.d0','onclick',TForm(Owner).Handle])
                              +'>');

               end;

               //
               Result    := (joRes);

          end else begin
               //Element table -------------------------------------------------

               //���ɷ���ֵ����
               joRes    := _Json('[]');

               //ȡ��HINT����JSON
               joHint    := dwGetHintJson(TControl(ACtrl));

               //
               with TStringGrid(ACtrl) do begin
                    //
                    sRowStyle := ' :row-style="{height:'''+IntToStr(DefaultRowHeight)+'px''}"'
                              +' :header-row-style="{height:'''+IntToStr(DefaultRowHeight)+'px''}"';     //�иߺ�����     ,color:''red''

                    //
                    if joHint.Exists('background') then begin
                         sRowStyle := sRowStyle + ' :header-cell-style="{background:'''+joHint.background+'''}"'; //����ɫ
                    end;

                    //������
                    joRes.Add('<div'
                              +dwLTWH(TControl(ACtrl))
                              +'"' //style ���
                              +'>');
                    //�������
                    joRes.Add('    <el-table'
                              +' :data="'+dwPrefix(Actrl)+Name+'__ces"'     //��������
                              +' highlight-current-row'     //��ǰ�и���
                              +sRowStyle
                              +' ref="'+dwPrefix(Actrl)+Name+'"'            //�ο���?
                              +dwGetDWStyle(joHint)
                              //+' stripe'                  //������
                              //+dwIIF(Borderstyle<>bsNone,' border','')     //�Ƿ�߿�
                              +dwVisible(TControl(ACtrl))                  //�Ƿ�ɼ�
                              +dwDisable(TControl(ACtrl))                  //�Ƿ����
                              //+' height="'+IntToStr(TControl(ACtrl).Height)+'"' //�߶�, �д�ֵ����ʾ������
                              +' :height="'+dwPrefix(Actrl)+Name+'__hei"' //�߶�, �д�ֵ����ʾ������
                              +' style="width:100%"'                            //���
                              +Format(_DWEVENT,['row-click',Name,'val.d0','onclick',TForm(Owner).Handle])
                              +'>');

                    //�������ӵ��к���, ���ڱ�ʾ�к�
                    joRes.Add('        <el-table-column'
                         +' show-overflow-tooltip'
                         +' fixed'
                         +' v-if=false'
                         +' prop="d0"'
                         +' label="rowno"'
                         +' width="10"'
                         +'></el-table-column>');



                    //��Ӹ���
                    if (not dwIsNull(joHint)) then begin
                         if  joHint.Exists('columns') then begin
                              //===����Ϊ���ͷ�����
                              joCols    := joHint.columns;
                              iColiD    := 0;
                              for iItem := 0 to joCols._Count-1 do begin
                                   joCol     := joCols._(iItem);
                                   _AddChildCol(joCol,iColID,TStringGrid(ACtrl));
                              end;
                         end;

                    end else begin
                         //===����Ϊ������ͷ�����
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

//ȡ��HTMLβ����Ϣ
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //
     with TStringGrid(ACtrl) do begin
          if HelpKeyword = 'easy' then begin
               //Vue easy table-------------------------------------------------

               //���ɷ���ֵ����
               joRes    := _Json('[]');

               //���ɷ���ֵ����
               joRes.Add('    </v-table>');
               joRes.Add('</div>');

               //
               Result    := (joRes);
          end else begin
               //Element table -------------------------------------------------

               //���ɷ���ֵ����
               joRes    := _Json('[]');

               //���ɷ���ֵ����
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



//ȡ��Data
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
                         { "name": "��è���30g", "last": "156.1", "percent": "-1.76", "earning": "5.6" },
                         { "name": "�ƽ�9995", "last": "182.1", "percent": "1.06", "earning": "12.5" },
                         { "name": "���ʰ�ƽ�9999", "last": "161.0", "percent": "-0.76", "earning": "18.2" },
                         { "name": "����T+D", "last": "197.1", "percent": "1.26", "earning": "14.7" },
                         { "name": "Mini�ƽ�T+D", "last": "183.6", "percent": "2.76", "earning": "18.7" }
                       ],
                       columns: [
                         { field: 'name', title: '����', width: 50, titleAlign: 'left', columnAlign: 'left', titleCellClassName: 'title-cell-class-name', isResize: true },
                         // formatter: function (rowData, rowIndex, pagingIndex, field) {
                         //   return rowIndex < 3 ? '<span style="color:red;font-weight: bold;">' + (rowIndex + 1) + '</span>' : rowIndex + 1
                         // }
                         { field: 'last', title: '����', width: 50, titleAlign: 'right', columnAlign: 'right', titleCellClassName: 'title-cell-class-name', isResize: true },
                         { field: 'percent', title: '�Ƿ�%', width: 50, titleAlign: 'right', columnAlign: 'right', titleCellClassName: 'title-cell-class-name', orderBy: 'desc', isResize: true },
                         { field: 'earning', title: '�ǵ�', width: 50, titleAlign: 'right', columnAlign: 'right', titleCellClassName: 'title-cell-class-name', isResize: true }
                       ]
               *)
               //���ɷ���ֵ����
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

               //���ɷ���ֵ����
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
                    //�б���
                    for iCol := 0 to ColCount-1 do begin
                         joRes.Add(dwPrefix(Actrl)+Name+'__col'+IntToStr(iCol)+':"'+_GetColCaption(Cells[iCol,0])+'",');
                    end;


                    //����
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



//ȡ��Method
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

               //���ɷ���ֵ����
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

               //���ɷ���ֵ����
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

                    //�б���
                    for iCol := 0 to ColCount-1 do begin
                         joRes.Add('this.'+dwPrefix(Actrl)+Name+'__col'+IntToStr(iCol)+'="'+Cells[iCol,0]+'";');
                    end;


                    //����
                    for iRow := 1 to RowCount-1 do begin
                         sCode     := 'this.$set(this.'+dwPrefix(Actrl)+TStringGrid(ACtrl).Name+'__ces,'+IntToStr(iRow-1)+',{d0:"'+IntToStr(iRow)+'",';
                         for iCol := 0 to ColCount-2 do begin
                              sCode     := sCode +'d'+IntToStr(iCol+1)+':"'+Cells[iCol,iRow]+'",';
                         end;
                         sCode     := sCode +'d'+IntToStr(ColCount)+':"'+Cells[ColCount-1,iRow]+'"});';
                         joRes.Add(sCode);
                    end;
                    //�к�
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
 
