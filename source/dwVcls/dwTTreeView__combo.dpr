library dwTTreeView__combo;

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

function _GetTreeNodeIndex(ATreeNode:TTreeNode):Integer;
begin
    Result  := 0;
    while ATreeNode.GetPrev <> nil do begin
        ATreeNode   := ATreeNode.GetPrev;
        Inc(Result);
    end;
end;

function _GetTreeViewValue(ATV:TTreeView):String;
var
	oTreeNode	: TTreeNode;
begin
	if ATV.selected = nil then begin
		Result	:= '';
	end else begin
		oTreeNode	:= ATV.Selected;
		Result		:= IntToStr(_GetTreeNodeIndex(oTreeNode));
	end;
end;



function _GetTreeViewData(ATV:TTreeView):String;

    //取得节点的Value, 也就是其祖先辈节点的序号数组，如: 1,3,2
    function __GetNodeValue(ANode:TTreeNode):string;
    begin
        Result  := IntToStr(ANode.Index);
    end;

    //
    function __GetItemData(ANode:TTreeNode):string;
    var
        II      : Integer;
    begin
        Result  := '{';
        //
        Result  := Result + 'value:'''+IntToStr(_GetTreeNodeIndex(ANode))+''',';
        Result  := Result + 'label:'''+ANode.Text+'''';
        //
        if ANode.Count>0 then begin
            Result      := Result + ',children:[';
            for II := 0 to ANode.Count-1 do begin
                Result  := Result + __GetItemData(ANode.Item[II])+',';
            end;
            Delete(Result,Length(Result),1);
            Result         := Result + ']';
        end;
        Result         := Result + '},';
    end;
var
     tnItem    : TTreeNode;
     iItem     : Integer;
begin
     //生成数据
     Result    := '[';
     tnItem    := ATV.Items.GetFirstNode;
     while tnItem <> nil do begin
          Result    := Result + __GetItemData(tnItem);
          //
          tnItem    := tnItem.getNextSibling;
     end;
     if Length(Result)>1 then begin
          Delete(Result,Length(Result),1);
     end;
     //
     Result    := Result+']';
end;


//==================================================================================================

//当前控件需要引入的第三方JS/CSS
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
    joData      : Variant;
    joValue     : Variant;
    sValue      : String;
    iItem       : Integer;
    oTreeNode   : TTreeNode;

begin
    //
    joData      := _Json(AData);

    //找到对应的节点,并选中
    sValue      := dwUnescape(joData.v);
    joValue     := _json('['+sValue+']');
    //
    oTreeNode   := TTreeView(ACtrl).Items[0];
    for iItem := 1 to joValue._(joValue._Count-1) do begin
        oTreeNode   := oTreeNode.getNext;
    end;
    oTreeNode.Selected  := True;

    //
    if joData.e = 'onchange' then begin
        //执行事件
        if Assigned(TTreeView(ACtrl).OnChange) then begin
            TTreeView(ACtrl).OnChange(TTreeView(ACtrl),oTreeNode);
        end;
    end else if joData.e = 'onenter' then begin
    end;

end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode   : string;
    sFull   : string;
    joHint  : Variant;
    joRes   : Variant;
begin
    //生成返回值数组
    joRes    := _Json('[]');

    //
    sFull   := dwFullName(ACtrl);

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    with TTreeView(ACtrl) do begin
        sCode   :=
                '<el-cascader'+
                ' id="'+sFull+'"' +
                dwVisible(TControl(ACtrl)) +                            //用于控制可见性Visible
                dwDisable(TControl(ACtrl)) +                           //用于控制可用性Enabled(部分控件不支持)
                ' v-model="'+sFull+'__val"' +
                ' :options="'+sFull+'__opt"' +                            //defaultProps
                dwGetDWAttr(joHint) +
                // :style
                ' :style="{' +
                    'left:'+sFull+'__lef,' +
                    'top:'+sFull+'__top,' +
                    'width:'+sFull+'__wid,' +
                    'height:'+sFull+'__hei,' +
                    'lineHeight:'+sFull+'__hei' +
                '}"' +
                // style
                ' style="' +
                    'background-color:'+dwColor(Color)+';' +
                    dwGetDWStyle(joHint) +
                '"' +
                // 事件
                ' @change="'+sFull+'__change"' +
                '>';
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
     joRes.Add('</el-cascader>');          //此处需要和dwGetHead对应
     //
     Result    := (joRes);
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
    sCode     : String;
    sFull   : string;
begin
    //生成返回值数组
    joRes    := _Json('[]');

    //
    sFull   := dwFullName(ACtrl);

    //
    with TTreeView(ACtrl) do begin
        //
        joRes.Add(sFull+'__val: "'+_GetTreeViewValue(TTreeView(ACtrl))+'",');
        //defaultProps
        joRes.Add(sFull+'__opt: '+_GetTreeViewData(TTreeView(ACtrl))+',');
        //
        joRes.Add(sFull+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(sFull+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(sFull+'__dis:'+dwIIF(Enabled,'false,','true,'));
    end;
    //
    Result    := (joRes);
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
    sCode     : String;
    sFull   : string;
begin
    //生成返回值数组
    joRes    := _Json('[]');

    //
    sFull   := dwFullName(ACtrl);

    //
    with TTreeView(ACtrl) do begin
        joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        joRes.Add('this.'+sFull+'__val="'+_GetTreeViewValue(TTreeView(ACtrl))+'";');
        joRes.Add('this.'+sFull+'__opt='+_GetTreeViewData(TTreeView(ACtrl))+';');
    end;
    //
    Result    := (joRes);
end;

//dwGetMethod
function dwGetMethods(ACtrl:TControl):String;stdCall;
var
    //
    sCode       : string;
    sFull       : string;
    //
    joHint      : Variant;
    joRes       : Variant;
begin
    joRes   := _json('[]');

    //
    sFull   := dwFullName(ACtrl);

    //取得HINT对象JSON
    joHint := dwGetHintJson(TControl(ACtrl));


    with TTreeView(ACtrl) do begin
        //编辑后save事件
        sCode   :=
                sFull+'__change(value) ' +
                '{' +
                    'console.log(value);' +
                    'this.dwevent("","'+sFull+'",value,"onchange",'+IntToStr(TForm(Owner).Handle)+');'+
                '},';
        joRes.Add(sCode);
    end;
    //
    Result   := joRes;

end;


exports
     //dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetMethods,
     dwGetData;
     
begin
end.
 
