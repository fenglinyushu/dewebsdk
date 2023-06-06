unit dwTreeViews;

interface

uses
     //
     dwCtrlBase,

     //
     SynCommons,

     //
     Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, ComCtrls, ExtCtrls,
     Spin, Grids,
     Math,typinfo,
     DateUtils, StdCtrls, Menus,
     Windows,Types;



//返回值说明 : 返回一个字符串数组(每个元素代表一行,自带当前缩进)

//取得HTML头部消息
function dwGetHtmlHead(ACtrl:TControl):Variant;

//取得HTML尾部消息
function dwGetHtmlTail(ACtrl:TControl):Variant;

//取得Data消息, ASeparator为分隔符, 一般为:或=
function dwGetData(ACtrl:TControl;ASeparator:String):Variant;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwEvent(ACtrl:TControl;AData:Variant):String;


implementation

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwEvent(ACtrl:TControl;AData:Variant):String;
var
     sValue    : String;
     iItem     : Integer;
begin

     //保存事件
     TTreeView(ACtrl).OnExit    := TTreeView(ACtrl).OnClick;
     //清空事件,以防止自动执行
     TTreeView(ACtrl).OnClick  := nil;
     //更新值
     TTreeView(ACtrl).Items[AData.v-1].Selected := True;
     //恢复事件
     TTreeView(ACtrl).OnClick  := TTreeView(ACtrl).OnExit;

     //执行事件
     if Assigned(TTreeView(ACtrl).OnClick) then begin
          TTreeView(ACtrl).OnClick(TTreeView(ACtrl));
     end;

     //清空OnExit事件
     TTreeView(ACtrl).OnExit  := nil;

end;

function dwGetTreeViewData(ATV:TTreeView):String;
     procedure _GetNodeData(ANode:TTreeNode;var AData:String);
     var
          iiItem    : Integer;
     begin
          AData     := AData + '{id:'+IntToStr(ANode.StateIndex)+',label:'''+ANode.Text+''',children:[';
          for iiItem := 0 to ANode.Count-1 do begin
               _GetNodeData(ANode.Item[iiItem],AData);
          end;
          AData     := AData + ']},';
     end;
var
     iItem     : Integer;
     tnNode    : TTreeNode;
begin
     Result    := '';
     if ATV.Items.Count=0 then begin
          Exit;
     end;

     //
     tnNode    := ATV.Items[0];
     Result    := '[';
     while True do begin
          _GetNodeData(tnNode,Result);

          //
          if tnNode.getNextSibling = nil then begin
               break;
          end else begin
               tnNode    := tnNode.getNextSibling;
          end;
     end;
     Delete(Result,Length(Result),1);
     Result    := Result + ']';
end;


//取得HTML头部消息
function dwGetHtmlHead(ACtrl:TControl):Variant;
var
     sCode     : string;
     sExpanded : string;
     //
     iItem     : Integer;
     //
     joHint    : Variant;
begin
     //生成返回值数组
     Result    := _Json('[]');

     //取得HINT对象JSON
     joHint    := dwGetHintJson(ACtrl);

     with TTreeView(ACtrl) do begin
          //设置stateindex,备用
          for iItem := 0 to items.Count-1 do begin
               Items[iItem].StateIndex  := iItem;
          end;
          //取得Expanded字符串
          sExpanded    := '';
          for iItem := 0 to items.Count-1 do begin
               if Items[iItem].Expanded then begin
                    sExpanded    := sExpanded+IntToStr(iItem)+',';
               end;
          end;
          if Length(sExpanded)>1 then begin
               Delete(sExpanded,Length(sExpanded),1);
          end;

          //生成字符串 
          Result.Add('<el-tree'
                    +' ref="tree"'
                    +' :data="'+dwFullName(Actrl)+'__dat"'
                    +'  node-key="id"'
                    +' :default-expanded-keys="['+sExpanded+']"'
                    +' :props="'+dwFullName(Actrl)+'__dfp"'
                    +dwVisible(ACtrl)
                    +dwDisable(ACtrl)
                    +dwLTWH(ACtrl)
                    +'background-color:'+dwColor(Color)+';overflow:auto"'
                    +Format(_DWEVENT,['node-click',Name,'val.$treeNodeId','onclick',TForm(Owner).Handle])
                    +'>');

     end;
end;

//取得HTML尾部消息
function dwGetHtmlTail(ACtrl:TControl):Variant;
begin
     //生成返回值数组
     Result    := _Json('["</el-tree>"]');
end;

//取得Data消息, ASeparator为分隔符, 一般为:或=
function dwGetData(ACtrl:TControl;ASeparator:String):Variant;
var
     iItem     : Integer;
     sCode     : String;
begin
     //生成返回值数组
     Result    := _Json('[]');

     //生成Data:选项

     //
     with TTreeView(ACtrl) do begin
          //
          Result.Add(dwFullName(Actrl)+'__lef'+ASeparator+'"'+IntToStr(Left)+'px"');
          Result.Add(dwFullName(Actrl)+'__top'+ASeparator+'"'+IntToStr(Top)+'px"');
          Result.Add(dwFullName(Actrl)+'__wid'+ASeparator+'"'+IntToStr(Width)+'px"');
          Result.Add(dwFullName(Actrl)+'__hei'+ASeparator+'"'+IntToStr(Height)+'px"');
          //
          Result.Add(dwFullName(Actrl)+'__vis'+ASeparator+''+dwIIF(Visible,'true','false'));
          Result.Add(dwFullName(Actrl)+'__dis'+ASeparator+''+dwIIF(Enabled,'false','true'));
          //
          Result.Add(dwFullName(Actrl)+'__dat'+ASeparator+dwGetTreeViewData(TTreeView(ACtrl)));
          Result.Add(dwFullName(Actrl)+'__dfp'+ASeparator+'{children: ''children'',label: ''label''}');
     end;
end;


end.
