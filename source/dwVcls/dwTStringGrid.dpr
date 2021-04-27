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
     Result    := StringReplace(Result,'[*left*]','',[]);
     Result    := StringReplace(Result,'[*center*]','',[]);
     Result    := StringReplace(Result,'[*right*]','',[]);
end;

//�Ӹ��ϵı��⣨�磺[center]���ᣩ �õ�����
function _GetColAlign(AText:String):String;
begin
     Result    := '';
     if Pos('[*center*]',AText)>0 then begin
          Result    := ' align="center"';
     end else if Pos('[*right*]',AText)>0 then begin
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
               joRes.Add('<script src="dist/ex/dwStringGrid.js"></script>');

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
     bColed    : Boolean;     //����ӱ�ͷ��Ϣ
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
                              +' id="'+dwPrefix(Actrl)+Name+'"'
                              +' :data="'+dwPrefix(Actrl)+Name+'__ces"'     //��������
                              +' highlight-current-row'     //��ǰ�и���
                              +sRowStyle
                              +' ref="'+dwPrefix(Actrl)+Name+'"'            //�ο���?
                              +dwGetDWAttr(joHint)
                              //+' stripe'                  //������
                              //+dwIIF(Borderstyle<>bsNone,' border','')     //�Ƿ�߿�
                              +dwVisible(TControl(ACtrl))                  //�Ƿ�ɼ�
                              +dwDisable(TControl(ACtrl))                  //�Ƿ����
                              //+' height="'+IntToStr(TControl(ACtrl).Height)+'"' //�߶�, �д�ֵ����ʾ������
                              +' :height="'+dwPrefix(Actrl)+Name+'__hei"' //�߶�, �д�ֵ����ʾ������
                              +' style="width:100%'
                              +dwGetDWStyle(joHint)
                              +'"'                            //���
                              +Format(_DWEVENT,['row-click',Name,'val.d0','onclick',TForm(Owner).Handle])
                              +'>');

                    //�������ӵ��к���, ���ڱ�ʾ�к�,���в���ʾ��Ϊ����״̬
                    joRes.Add('        <el-table-column'
                         +' show-overflow-tooltip'
                         +' fixed'
                         +' v-if=false'
                         +' prop="d0"'
                         +' label="rowno"'
                         +' width="10"'
                         +'></el-table-column>');



                    //��Ӹ���
                    bColed    := False;
                    if (not dwIsNull(joHint)) then begin
                         if  joHint.Exists('columns') then begin
                              //===����Ϊ���ͷ�����

                              //���������column����
                              bColed    := True;

                              joCols    := joHint.columns;
                              iColiD    := 0;
                              for iItem := 0 to joCols._Count-1 do begin
                                   joCol     := joCols._(iItem);
                                   _AddChildCol(joCol,iColID,TStringGrid(ACtrl));
                              end;
                         end;
                    end;

                    if not bColed then begin
                         //===����Ϊ������ͷ�����
                         for iItem := 0 to ColCount-1 do begin
                              joRes.Add('        <el-table-column'
                                        +dwIIF(iItem<FixedCols,' fixed="left"','')   //�̶���
                                        +' v-if="'+dwPrefix(Actrl)+Name+'__clv'+IntToStr(iItem)+'"'
                                        +' show-overflow-tooltip'
                                        +' prop="d'+IntToStr(iItem+1)+'"'
                                        +_GetColAlign(Cells[iItem,0])      //�����ı�,ȷ�����뷽ʽ
                                        +' :label="'+dwPrefix(Actrl)+Name+'__col'+IntToStr(iItem)+'"'
                                        +' :width="'+dwPrefix(Actrl)+Name+'__cws'+IntToStr(iItem)+'"'
                                        +'></el-table-column>');
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
                    //�п�
                    for iCol := 0 to ColCount-1 do begin
                         joRes.Add(dwPrefix(Actrl)+Name+'__cws'+IntToStr(iCol)+':"'+IntToStr(ColWidths[iCol])+'",');
                    end;
                    //������
                    for iCol := 0 to ColCount-1 do begin
                         joRes.Add(dwPrefix(Actrl)+Name+'__clv'+IntToStr(iCol)+':true,');
                    end;


                    //����
                    sCode     := dwPrefix(Actrl)+Name+'__ces:[';
                    for iRow := 1 to RowCount-1 do begin
                         sCode     := sCode + '{d0:'''+IntToStr(iRow)+''',';
                         for iCol := 0 to ColCount-1 do begin
                              sCode     := sCode + 'd'+IntToStr(iCol+1)+':'''+Cells[iCol,iRow]+''',';
                         end;
                         Delete(sCode,Length(sCode),1);
                         sCode     := sCode + '},';
                    end;
                    if RowCount>1 then begin
                         Delete(sCode,Length(sCode),1);
                    end;
                    sCode     := sCode + '],';
                    joRes.Add(sCode);
(*
                    joRes.Add(dwPrefix(Actrl)+Name+'__ces:[{');
                    for iRow := 1 to RowCount-1 do begin
                         joRes.Add('d0: '''+IntToStr(iRow)+''',');
                         for iCol := 0 to ColCount-1 do begin
                              if iCol < ColCount-1 then begin
                                   joRes.Add('d'+IntToStr(iCol+1)+': '''+Cells[iCol,iRow]+''',');
                              end else begin
                                   joRes.Add('d'+IntToStr(iCol+1)+': '''+Cells[iCol,iRow]+'''');
                              end;
                         end;
                         if iRow<RowCount-1 then begin
                              joRes.Add('},{');
                         end else begin
                              joRes.Add('}],');
                         end;
                    end;
*)
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
                    //�п�
                    for iCol := 0 to ColCount-1 do begin
                         joRes.Add('this.'+dwPrefix(Actrl)+Name+'__cws'+IntToStr(iCol)+'="'+IntToStr(ColWidths[iCol])+'";');
                    end;
                    //������
                    for iCol := 0 to ColCount-1 do begin
                         joRes.Add('this.'+dwPrefix(Actrl)+Name+'__clv'+IntToStr(iCol)+'='+dwIIF(ColWidths[iCol]>0,'true','false')+';');
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
     dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetMethod,
     dwGetData;

begin
end.
 
