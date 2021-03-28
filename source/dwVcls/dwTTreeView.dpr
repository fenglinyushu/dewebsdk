library dwTTreeView;

uses
     ShareMem,      //必须添加

     //
     dwCtrlBase,    //一些基础函数

     //
     SynCommons,    //mormot用于解析JSON的单元

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
     //设置stateindex为序号, 以用于后来确定点击的节点
     for iItem := 0 to ATV.Items.Count-1 do begin
          ATV.Items[iItem].StateIndex  := iItem;
     end;

     //生成数据
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




//当前控件需要引入的第三方JS/CSS ,一般为不做改动,目前仅在TChart使用时需要用到
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
     joRes     : Variant;
begin
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

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData    : Variant;
     iItem     : Integer;
     oTreeNode : TTreeNode;

begin
{
                                   //先找到对应的节点
                                   iItem     := StrToIntDef(joData.v,1)-1;
                                   oTreeNode := TTreeView(oComp).Items[iItem];
                                   oTreeNode.Selected  := True;

                                   //如果有事件
                                   if Assigned(TTreeView(oComp).OnClick) then begin
                                        //标记CID, 以备后面dwCreateForm使用
                                        TTreeView(oComp).Tag  := joData.i;

                                        //取得事件执行前控件信息
                                        jaBefore  := dwGetComponentInfos(oForm);

                                        //执行事件
                                        TTreeView(oComp).OnClick(TTreeView(oComp));


                                        //综合过程After
                                        ProcessAfter;

                                   end;

}     //
     joData    := _Json(AData);

     //找到对应的节点,并选中
     iItem     := StrToIntDef(joData.v,1)-1;
     oTreeNode := TTreeView(ACtrl).Items[iItem];
     oTreeNode.Selected  := True;

     //
     if joData.e = 'onclick' then begin
          //执行事件
          if Assigned(TTreeView(ACtrl).OnClick) then begin
               TTreeView(ACtrl).OnClick(TTreeView(ACtrl));
          end;
     end else if joData.e = 'onenter' then begin
     end;

end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
     sCode     : string;
     joHint    : Variant;
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');

     //取得HINT对象JSON
     joHint    := dwGetHintJson(TControl(ACtrl));
     with TTreeView(ACtrl) do begin
          sCode     := '';
          //_GetExpanded(TTreeView(ACtrl),sCode);
          if sCode <>'' then begin
               System.Delete(sCode,Length(sCode),1);
          end;
          //
          joRes.Add('<el-tree'
                    +dwVisible(TControl(ACtrl))                            //用于控制可见性Visible
                    +dwDisable(TControl(ACtrl))                            //用于控制可用性Enabled(部分控件不支持)
                    +' :data="'+dwPrefix(Actrl)+Name+'__dat"'
                    +' node-key="id"'
                    +' :default-expanded-keys="['+sCode+']"'
                    +' :props="'+dwPrefix(Actrl)+Name+'__dps"'                             //defaultProps
                    +dwLTWH(TControl(ACtrl))                               //Left/Top/Width/Height
                    +'background-color:'+dwColor(Color)+';'
                    +'overflow:auto;'
                    +'"' // 封闭style
                    +Format(_DWEVENT,['node-click',Name,'val.$treeNodeId','onclick',TForm(Owner).Handle]) //绑定OnChange事件
                    +'>');
          joRes.Add('<span class="custom-tree-node" slot-scope="{ node, data }">'
                    +'<span>'
                    +'<i :class="data.icon"></i><span>&nbsp;</span>{{node.label}}'
                    +'</span>'
                    +'</span>');

          //添加到返回值数据
          joRes.Add(sCode);
     end;
     //
     Result    := (joRes);
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //生成返回值数组
     joRes.Add('</el-tree>');          //此处需要和dwGetHead对应
     //
     Result    := (joRes);
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sCode     : String;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //
     with TTreeView(ACtrl) do begin
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__dat:'+_GetTreeViewData(TTreeView(ACtrl))+',');
          //defaultProps
          joRes.Add(dwPrefix(Actrl)+Name+'__dps: {children: ''children'',label: ''label''},');
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(dwPrefix(Actrl)+Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
     end;
     //
     Result    := (joRes);
end;

function dwGetMethod(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sCode     : String;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //
     with TTreeView(ACtrl) do begin
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__dat='+_GetTreeViewData(TTreeView(ACtrl))+';');
     end;
     //
     Result    := (joRes);
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
 
