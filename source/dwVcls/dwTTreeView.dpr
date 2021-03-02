library dwTTreeView;

uses
     ShareMem,      //�������

     //
     dwCtrlBase,    //һЩ��������

     //
     SynCommons,    //mormot���ڽ���JSON�ĵ�Ԫ

     //
     SysUtils,
     Classes,
     Dialogs,
     StdCtrls,ComCtrls,
     Windows,
     Controls,
     Forms;


function _GetExpanded(ANode:TTreeNode;var AExpanded:String):Integer;
var
     iItem     : Integer;
     tnItem    : TTreeNode;
begin
     //
     for iItem := 0 to ANode.Count-1 do begin
          tnItem    := ANode.Item[iItem];
          //
          if tnItem.expanded then begin
               AExpanded := AExpanded + IntToStr(tnItem.StateIndex)+',';
               _GetExpanded(tnItem,AExpanded);
          end;
     end;
     Result    := 0 ;
end;

function _GetTreeViewData(ATV:TTreeView):String;
     //
     function __GetItemData(ANode:TTreeNode):string;
     var
          II        : Integer;
     begin
          Result         := '{';
          Result         := Result + 'id:'+IntToStr(ANode.StateIndex)+',';
          Result         := Result + 'label:'''+ANode.Text+'''';
          //
          if (ANode.ImageIndex>0)and(ANode.ImageIndex<=High(dwIcons)) then begin
               Result         := Result + ',icon:'''+dwIcons[ANode.ImageIndex]+'''';
          end;

          if ANode.Count>0 then begin
               Result         := Result + ',children:[';
               for II := 0 to ANode.Count-1 do begin
                    Result         := Result + __GetItemData(ANode.Item[II])+',';
               end;
               Delete(Result,Length(Result),1);
               Result         := Result + ']';
          end;
          Result         := Result + '}';
     end;
var
     tnItem    : TTreeNode;
     iItem     : Integer;
begin
     //����stateindexΪ���, �����ں���ȷ������Ľڵ�
     for iItem := 0 to ATV.Items.Count-1 do begin
          ATV.Items[iItem].StateIndex  := iItem;
     end;

     //��������
     Result    := '[';
     tnItem    := ATV.Items.GetFirstNode;
     while tnItem <> nil do begin
          Result    := Result + __GetItemData(tnItem)+',';
          //
          tnItem    := tnItem.getNextSibling;
     end;
     if Length(Result)>1 then begin
          Delete(Result,Length(Result),1);
     end;
     //
     Result    := Result+']';
end;




//��ǰ�ؼ���Ҫ����ĵ�����JS/CSS ,һ��Ϊ�����Ķ�,Ŀǰ����TChartʹ��ʱ��Ҫ�õ�
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
     joRes     : Variant;
begin
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

//����JSON����ADataִ�е�ǰ�ؼ����¼�, �����ؽ���ַ���
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData    : Variant;
     iItem     : Integer;
     oTreeNode : TTreeNode;

begin
{
                                   //���ҵ���Ӧ�Ľڵ�
                                   iItem     := StrToIntDef(joData.value,1)-1;
                                   oTreeNode := TTreeView(oComp).Items[iItem];
                                   oTreeNode.Selected  := True;

                                   //������¼�
                                   if Assigned(TTreeView(oComp).OnClick) then begin
                                        //���CID, �Ա�����dwCreateFormʹ��
                                        TTreeView(oComp).Tag  := joData.cid;

                                        //ȡ���¼�ִ��ǰ�ؼ���Ϣ
                                        jaBefore  := dwGetComponentInfos(oForm);

                                        //ִ���¼�
                                        TTreeView(oComp).OnClick(TTreeView(oComp));


                                        //�ۺϹ���After
                                        ProcessAfter;

                                   end;

}     //
     joData    := _Json(AData);

     //�ҵ���Ӧ�Ľڵ�,��ѡ��
     iItem     := StrToIntDef(joData.value,1)-1;
     oTreeNode := TTreeView(ACtrl).Items[iItem];
     oTreeNode.Selected  := True;

     //
     if joData.event = 'onclick' then begin
          //ִ���¼�
          if Assigned(TTreeView(ACtrl).OnClick) then begin
               TTreeView(ACtrl).OnClick(TTreeView(ACtrl));
          end;
     end else if joData.event = 'onenter' then begin
     end;

end;


//ȡ��HTMLͷ����Ϣ
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
     sCode     : string;
     joHint    : Variant;
     joRes     : Variant;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');

     //ȡ��HINT����JSON
     joHint    := dwGetHintJson(TControl(ACtrl));
     with TTreeView(ACtrl) do begin
          sCode     := '';
          //_GetExpanded(TTreeView(ACtrl),sCode);
          if sCode <>'' then begin
               System.Delete(sCode,Length(sCode),1);
          end;
          //
          joRes.Add('<el-tree'
                    +dwVisible(TControl(ACtrl))                            //���ڿ��ƿɼ���Visible
                    +dwDisable(TControl(ACtrl))                            //���ڿ��ƿ�����Enabled(���ֿؼ���֧��)
                    +' :data="'+Name+'__dat"'
                    +' node-key="id"'
                    +' :default-expanded-keys="['+sCode+']"'
                    +' :props="'+Name+'__dps"'                             //defaultProps
                    +dwLTWH(TControl(ACtrl))                               //Left/Top/Width/Height
                    +'background-color:'+dwColor(Color)+';'
                    +'overflow:auto;'
                    +'"' // ���style
                    +Format(_DWEVENT,['node-click',Name,'val.$treeNodeId','onclick','']) //��OnChange�¼�
                    +'>');
          joRes.Add('<span class="custom-tree-node" slot-scope="{ node, data }">'
                    +'<span>'
                    +'<i :class="data.icon"></i><span>&nbsp;</span>{{node.label}}'
                    +'</span>'
                    +'</span>');

          //��ӵ�����ֵ����
          joRes.Add(sCode);
     end;
     //
     Result    := (joRes);
end;

//ȡ��HTMLβ����Ϣ
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //���ɷ���ֵ����
     joRes.Add('</el-tree>');          //�˴���Ҫ��dwGetHead��Ӧ
     //
     Result    := (joRes);
end;

//ȡ��Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sCode     : String;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //
     with TTreeView(ACtrl) do begin
          //
          joRes.Add(Name+'__dat:'+_GetTreeViewData(TTreeView(ACtrl))+',');
          //defaultProps
          joRes.Add(Name+'__dps: {children: ''children'',label: ''label''},');
          //
          joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
     end;
     //
     Result    := (joRes);
end;

function dwGetMethod(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sCode     : String;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //
     with TTreeView(ACtrl) do begin
          joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          joRes.Add('this.'+Name+'__dat='+_GetTreeViewData(TTreeView(ACtrl))+';');
     end;
     //
     Result    := (joRes);
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
 
