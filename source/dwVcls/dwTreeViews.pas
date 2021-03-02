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



//����ֵ˵�� : ����һ���ַ�������(ÿ��Ԫ�ش���һ��,�Դ���ǰ����)

//ȡ��HTMLͷ����Ϣ
function dwGetHtmlHead(ACtrl:TControl):Variant;

//ȡ��HTMLβ����Ϣ
function dwGetHtmlTail(ACtrl:TControl):Variant;

//ȡ��Data��Ϣ, ASeparatorΪ�ָ���, һ��Ϊ:��=
function dwGetData(ACtrl:TControl;ASeparator:String):Variant;

//����JSON����ADataִ�е�ǰ�ؼ����¼�, �����ؽ���ַ���
function dwEvent(ACtrl:TControl;AData:Variant):String;


implementation

//����JSON����ADataִ�е�ǰ�ؼ����¼�, �����ؽ���ַ���
function dwEvent(ACtrl:TControl;AData:Variant):String;
var
     sValue    : String;
     iItem     : Integer;
begin

     //�����¼�
     TTreeView(ACtrl).OnExit    := TTreeView(ACtrl).OnClick;
     //����¼�,�Է�ֹ�Զ�ִ��
     TTreeView(ACtrl).OnClick  := nil;
     //����ֵ
     TTreeView(ACtrl).Items[AData.Value-1].Selected := True;
     //�ָ��¼�
     TTreeView(ACtrl).OnClick  := TTreeView(ACtrl).OnExit;

     //ִ���¼�
     if Assigned(TTreeView(ACtrl).OnClick) then begin
          TTreeView(ACtrl).OnClick(TTreeView(ACtrl));
     end;

     //���OnExit�¼�
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


//ȡ��HTMLͷ����Ϣ
function dwGetHtmlHead(ACtrl:TControl):Variant;
var
     sCode     : string;
     sExpanded : string;
     //
     iItem     : Integer;
     //
     joHint    : Variant;
begin
     //���ɷ���ֵ����
     Result    := _Json('[]');

     //ȡ��HINT����JSON
     joHint    := dwGetHintJson(ACtrl);

     with TTreeView(ACtrl) do begin
          //����stateindex,����
          for iItem := 0 to items.Count-1 do begin
               Items[iItem].StateIndex  := iItem;
          end;
          //ȡ��Expanded�ַ���
          sExpanded    := '';
          for iItem := 0 to items.Count-1 do begin
               if Items[iItem].Expanded then begin
                    sExpanded    := sExpanded+IntToStr(iItem)+',';
               end;
          end;
          if Length(sExpanded)>1 then begin
               Delete(sExpanded,Length(sExpanded),1);
          end;

          //�����ַ��� 
          Result.Add('<el-tree'
                    +' ref="tree"'
                    +' :data="'+Name+'__dat"'
                    +'  node-key="id"'
                    +' :default-expanded-keys="['+sExpanded+']"'
                    +' :props="'+Name+'__dfp"'
                    +dwVisible(ACtrl)
                    +dwDisable(ACtrl)
                    +dwLTWH(ACtrl)
                    +'background-color:'+dwColor(Color)+';overflow:auto"'
                    +Format(_DWEVENT,['node-click',Name,'val.$treeNodeId','onclick',''])
                    +'>');

     end;
end;

//ȡ��HTMLβ����Ϣ
function dwGetHtmlTail(ACtrl:TControl):Variant;
begin
     //���ɷ���ֵ����
     Result    := _Json('["</el-tree>"]');
end;

//ȡ��Data��Ϣ, ASeparatorΪ�ָ���, һ��Ϊ:��=
function dwGetData(ACtrl:TControl;ASeparator:String):Variant;
var
     iItem     : Integer;
     sCode     : String;
begin
     //���ɷ���ֵ����
     Result    := _Json('[]');

     //����Data:ѡ��

     //
     with TTreeView(ACtrl) do begin
          //
          Result.Add(Name+'__lef'+ASeparator+'"'+IntToStr(Left)+'px"');
          Result.Add(Name+'__top'+ASeparator+'"'+IntToStr(Top)+'px"');
          Result.Add(Name+'__wid'+ASeparator+'"'+IntToStr(Width)+'px"');
          Result.Add(Name+'__hei'+ASeparator+'"'+IntToStr(Height)+'px"');
          //
          Result.Add(Name+'__vis'+ASeparator+''+dwIIF(Visible,'true','false'));
          Result.Add(Name+'__dis'+ASeparator+''+dwIIF(Enabled,'false','true'));
          //
          Result.Add(Name+'__dat'+ASeparator+dwGetTreeViewData(TTreeView(ACtrl)));
          Result.Add(Name+'__dfp'+ASeparator+'{children: ''children'',label: ''label''}');
     end;
end;


end.
