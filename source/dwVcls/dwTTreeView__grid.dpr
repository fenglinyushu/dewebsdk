library dwTTreeView__grid;

uses
     ShareMem,      //必须添加

     //
     dwCtrlBase,    //一些基础函数

     //
     SynCommons,    //mormot用于解析JSON的单元

     //
     SysUtils,
     Variants,
     Classes,
     Dialogs,
     Math,
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
               AExpanded := AExpanded + IntToStr(tnItem.GetHashCode)+',';
               _GetExpanded(tnItem,AExpanded);
          end;
     end;
     Result    := 0 ;
end;

function _GetTreeDefaultExpandedKeys(ATV:TTreeView):String;
var
    iItem   : Integer;
    tnNode  : TTreeNode;
begin
    try
        Result  := '[';
        if ATV.Items.Count>0 then begin
            tnNode  := ATV.Items[0];
            if tnNode.Expanded then begin
                Result  := Result + IntToStr(tnNode.GetHashCode) + ',';
            end;
            _GetExpanded(tnNode,Result);

            //
            tnNode  := tnNode.getNextSibling;
            while tnNode <> nil do begin
                if tnNode.Expanded then begin
                    Result  := Result + IntToStr(tnNode.GetHashCode) + ',';
                end;
                _GetExpanded(tnNode,Result);
                //
                tnNode  := tnNode.getNextSibling;
            end;
        end;
        //
        if Length(Result)>2 then begin
            Delete(Result,Length(Result),1);
        end;
        //
        Result  := Result + ']';
    except
        Result  := '[]';
    end;
end;

function _GetTreeViewData(ATV:TTreeView):String;
var
    iItem       : Integer;
    iCol        : Integer;
    iId         : Integer;
    iIds        : array[0..99] of Integer;  //当前节点的序号集合，反向，即iIds[0]表示最深层次的序号
    iGroup      : Integer;
    //
    sType       : String;
    //
    tnTemp      : TTreeNode;
    tnItem      : TTreeNode;
    //
    joHint      : Variant;
    joRes       : Variant;
    joCur       : Variant;
    joText      : Variant;
    joData      : Variant;
    joColumns   : Variant;
    joColumn    : Variant;
begin
    //取得HINT对象JSON
    joHint    := dwGetHintJson(ATV);

    //生成数据
    joRes   := _json('[]');

    //默认返回值
    Result  := joRes;

    //得到TreeView中定义的列
    if not joHint.Exists('columns') then begin
        joHint.columns  := _json('[]');
    end;

    //
    for iItem := 0 to ATV.Items.Count - 1 do begin
        tnItem  := ATV.Items[iItem];

        //取得序号数组
        iIDs[0] := tnItem.Index;
        iID     := 1;
        while tnItem.Parent <> nil do begin
            tnItem      := tnItem.Parent;
            iIds[iId]   := tnItem.Index;
            Inc(iId);
        end;

        //取得当前JSON节点
        tnItem  := ATV.Items[iItem];
        joCur   := joRes;
        for iId := 0 to tnItem.Level - 1  do begin
            if iId = 0 then begin
                joCur   := joRes._(iIds[tnItem.Level - iId]);
            end else begin
                joCur   := joCur.children._(iIds[tnItem.Level - iId]);
            end;
        end;

        //将节点的Text转化为JSON数组
        joText  := _json(tnItem.Text);
        if joText = unassigned then begin
            joText  := _json('[]');
            joText.Add(tnItem.Text);
        end;
        if joText._Count <= 0 then begin
            joText  := _json('[]');
            joText.Add(tnItem.Text);
        end;

        //
        if tnItem.Count > 0 then begin
            joData  := _Json('{"children":[]}');
        end else begin
            joData  := _Json('{}');
        end;
        joData.id   := tnItem.GetHashCode;
        joColumns   := joHint.columns;
        for iCol := 0 to joColumns._Count - 1 do begin
            joColumn    := joColumns._(iCol);
            if iCol < joText._Count then begin
                if joColumn.type = 'buttongroup' then begin
                    for iGroup := 0 to joColumn.count - 1 do begin     //这里报错！ 删除了dwRuoyi角色管理中的备用5
                        if VarType(joText._(iCol)) = varArray then begin
                            if iGroup < joText._(iCol)._Count then begin
                                if joText._(iCol)._(iGroup).Exits('caption') then begin
                                    joData.Add('c'+Inttostr(iCol)+'_'+IntToStr(iGroup),joText._(iCol)._(iGroup).caption);
                                end;
                            end;
                        end;
                    end;
                end else if joColumn.type = 'check' then begin  //check时支持1为true，其余为 false
                    if (joText._(iCol)='1') then begin
                        joData.Add('c'+Inttostr(iCol),true);
                    end else begin
                        joData.Add('c'+Inttostr(iCol),false);
                    end;
                end else begin
                    joData.Add('c'+Inttostr(iCol),joText._(iCol));
                end;
            end else begin
                joData.Add('c'+Inttostr(iCol),'');
            end;
        end;
        if tnItem.Level = 0 then begin
            joCur.Add(joData);
            joRes   := joCur;
        end else begin
            joCur.children.Add(joData);
        end;
    end;

    //
    Result := joRes;
end;




//当前控件需要引入的第三方JS/CSS ,一般为不做改动,目前仅在TChart使用时需要用到
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    joRes   : Variant;
    joHint  : Variant;
    sCode   : String;
begin
    //生成返回值数组
    joRes   := _Json('[]');

    {
    //以下是TChart时的代码,供参考
    joRes.Add('<script src="dist/charts/echarts.min.js"></script>');
    joRes.Add('<script src="dist/charts/lib/index.min.js"></script>');
    joRes.Add('<link rel="stylesheet" href="dist/charts/lib/style.min.css">');
    }

    joHint  := dwGetHintJson(TControl(ACtrl));


    //
    Result  := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
    joData      : Variant;
    iHashCode   : Integer;
    oTreeNode   : TTreeNode;
    iItem       : Integer;
    iSel,iHalf  : Integer;
    sValue      : String;
    bFound      : Boolean;
    iHash       : Integer;
    iCol        : integer;
    iGroup      : Integer;
    joValue     : Variant;
    joSel       : Variant;
    joHalf      : Variant;
    joHint      : Variant;
    joColumns   : Variant;
    joText      : Variant;
begin
    //
    joData      := _Json(AData);


    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //添加列
    if joHint.Exists('columns') then begin
        joColumns   := joHint.columns;
    end else begin
        joColumns   := _json('[]');
    end;

    //
    if joData.e = 'cellclick' then begin
        //取得选中的数据，为两个数组，前面为全选中的节点id,后面是半选中的节点id
        sValue  := dwUnescape(joData.v);

        //转化为JSON对象
        joValue := _json('['+sValue+']');

        //
        if joValue = unassigned then begin
            Exit;
        end;
        iHash   := joValue._(0);    //节点Hash值
        iCol    := joValue._(1);    //列
        iGroup  := joValue._(2);    //列中组件序号

        //
        oTreeNode   := nil;
        with TTreeView(ACtrl) do begin
            //根据hash值取得节点
            for iItem := 0 to Items.Count-1 do begin
                if Items[iItem].GetHashCode = iHash then begin
                    oTreeNode   := Items[iItem];
                    break;
                end;
            end;

            //
            if oTreeNode <> nil then begin
                //设置节点的Text(check)
                if joColumns._Count > iCol then begin
                    if joColumns._(iCol).type = 'check' then begin
                        joText  := _json(oTreeNode.Text);
                        if joText = unassigned then begin
                            joText  := _json('[]');
                            joText.Add(oTreeNode.Text);
                        end;
                        while joText._Count - 1 < iCol do begin
                            joText.Add('');
                        end;
                        //joText._(iCol)  := variant(abs(iGroup));
                        DocVariantData(joText).Value[iCol] := abs(iGroup);
                        oTreeNode.Text  := joText;
                    end;
                end;

                //激活事件
                if Assigned(OnEndDock) then begin
                    OnEndDock(TTreeView(ACtrl),oTreeNode,iCol,iGroup);
                end;
            end;
        end;
    end;

end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode       : string;
    sFull       : String;
    sType       : String;   //列类型
    sCaption    : String;   //列标题
    //
    iWidth      : Integer;  //列宽
    iCol        : Integer;
    iCount      : Integer;
    iGroup      : Integer;
    //
    joRes       : Variant;
    joHint      : Variant;
    joColumns   : Variant;
    joColumn    : Variant;
    joButton    : Variant;
begin
    //
    sFull   := dwFullName(ACtrl);

    //生成返回值数组
    joRes    := _Json('[]');

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //
    with TTreeView(ACtrl) do begin
        sCode     := '';
        //_GetExpanded(TTreeView(ACtrl),sCode);
        if sCode <>'' then begin
            System.Delete(sCode,Length(sCode),1);
        end;
        //
        joRes.Add('<el-table'
                //+' ref="'+sFull+'"'
                +' id="'+sFull+'"'
                +dwVisible(TControl(ACtrl))                             //用于控制可见性Visible
                //+dwDisable(TControl(ACtrl))                           //用于控制可用性Enabled(部分控件不支持)
                +dwIIF(MultiSelect,' show-checkbox','')                 //MultiSelect为true时显示为可选择
                +' :data="'+sFull+'__dat"'
                +' row-key="id"'
                +' :row-style="{height:''40px''}"'
                +' :header-cell-style="{background:''#FAFAFA'',textAlign: ''center'',height: ''40px''}"'
                +' :tree-props="{children: ''children'', hasChildren: ''hasChildren''}"'
                //+' :default-expanded-keys="'+sFull+'__dek"'
                //+' :highlight-current="'+dwIIF(HideSelection,'false','true')+'"'    //
                //+' :props="'+sFull+'__dps"'                             //defaultProps
                //+' :expand-on-click-node="'+dwIIF(HotTrack,'true','false')+'"'      //HotTrack为真时点击展开
                +dwGetDWAttr(joHint)
                //+dwLTWH(TControl(ACtrl))                               //Left/Top/Width/Height
                +' :style="{'
                    +'pointerEvents:'+sFull+'__pte,'
                    +'left:'+sFull+'__lef,'
                    +'top:'+sFull+'__top,'
                    +'width:'+sFull+'__wid,'
                    +'height:'+sFull+'__hei'
                +'}"'
                +' style="position:absolute;'
                    +dwGetDWStyle(joHint)
                    +'background-color:'+dwColor(Color)+';'
                    +'overflow:auto;'
                +'"' // 封闭style
                //+Format(_DWEVENT,['node-click',Name,'val.$treeNodeId','onclick',TForm(Owner).Handle]) //绑定OnChange事件
                //+Format(_DWEVENT,['node-click',Name,'val.id','onclick',TForm(Owner).Handle]) //绑定OnChange事件
                //+' @node-expand="'+sFull+'__nodeexpand" '
                //+' @node-collapse="'+sFull+'__nodecollapse" '
                +' @check="'+sFull+'__check" '
                +'>');

        //添加到返回值数据
        joRes.Add(sCode);

        //添加列
        if joHint.Exists('columns') then begin
            joColumns   := joHint.columns;
            for iCol := 0 to joColumns._Count - 1 do begin
                //得到列的JSON对象
                joColumn    := joColumns._(iCol);

                //取得各属性
                sType       := dwGetStr(joColumn,'type','label');
                sCaption    := dwGetStr(joColumn,'caption','noname');
                iWidth      := dwGetInt(joColumn,'width',100);

                //根据类型添加代码
                if sType = 'check' then begin
                    sCode   :=
                            '<el-table-column'
                                +' label="'+sCaption+'"'
                                +' width="'+IntToStr(iWidth)+'"'
                                +' prop="c'+IntToStr(iCol)+'"'
                                +' align="center"'
                                +'>'#13
                                +'<template slot-scope="scope">'#13
                                    +'<el-checkbox'
                                        +' @change="'+sFull+'__cellclick(scope.row.id, '+IntToStr(iCol)+', scope.row.c'+IntToStr(iCol)+')"'
                                        +' v-model="scope.row.c'+IntToStr(iCol)+'"'
                                    +'>'
                                    +'</el-checkbox>'#13
                                +'</template>'#13
                            +'</el-table-column>';
                end else if sType = 'button' then begin
                    sCode   :=
                            '<el-table-column'
                                +' label="'+sCaption+'"'
                                +' width="'+IntToStr(iWidth)+'"'
                                +' prop="c'+IntToStr(iCol)+'"'
                                +'>'#13
                                +'<template slot-scope="scope">'#13
                                    +'<el-button'
                                    +' @click="'+sFull+'__cellclick(scope.row.id, '+IntToStr(iCol)+', 0)"'
                                    +'>{{scope.row.c'+IntToStr(iCol)+'}}'
                                    +'</el-button>'#13
                                +'</template>'#13
                            +'</el-table-column>';
                end else if sType = 'buttongroup' then begin
                    sCode   :=
                            '<el-table-column'
                                +' label="'+sCaption+'"'
                                //+' width="'+IntToStr(iWidth)+'"'
                                +' prop="c'+IntToStr(iCol)+'"'
                                +'>'#13
                                +'<template slot-scope="scope">'#13;
                    for iGroup := 0 to joColumn.items._Count - 1 do begin
                        joButton    := joColumn.items._(iGroup);
                        scode   := scode
                                +'<el-button'
                                    +' type="'+joButton._(1)+'"'
                                    +' style="'
                                        +'width:'+IntToStr(joButton._(2))+'px;'
                                    +'"'
                                    +' @click="'+sFull+'__cellclick(scope.row.id, '+IntToStr(iCol)+', '+IntToStr(iGroup)+')"'
                                +'>'
                                    +joButton._(0)
                                +'</el-button>'#13
                    end;
                    scode   := scode
                                +'</template>'#13
                            +'</el-table-column>';
                end else begin
                    sCode   :=
                            '<el-table-column'
                                +' prop="c'+IntToStr(iCol)+'"'
                                +' label="'+sCaption+'"'
                                +' width="'+IntToStr(iWidth)+'"'
                                +'>'#13
                            +'</el-table-column>';
                end;
                //添加到返回值数据
                joRes.Add(sCode);
            end;
        end;
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
     joRes.Add('</el-table>');          //此处需要和dwGetHead对应
     //
     Result    := (joRes);
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes   : Variant;
    sCode   : String;
    sFull   : String;
begin
    //
    sFull   := dwFullName(ACtrl);
    //生成返回值数组
    joRes   := _Json('[]');


    //
    with TTreeView(ACtrl) do begin
        //
        joRes.Add(sFull+'__dat:eval('''+_GetTreeViewData(TTreeView(ACtrl))+'''),');
        //
        joRes.Add(sFull+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(sFull+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(sFull+'__pte:'+dwIIF(Enabled,'"auto",','"none",'));
        //
        joRes.Add(sFull+'__dek:'+_GetTreeDefaultExpandedKeys(TTreeView(ACtrl))+',');
    end;
    //
    Result    := (joRes);
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes   : Variant;
    sFull   : String;
    sCode   : String;
    tnItem  : TTreeNode;
    iItem   : Integer;
begin
    //
    sFull   := dwFullName(ACtrl);


    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TTreeView(ACtrl) do begin
        joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+sFull+'__pte='+dwIIF(Enabled,'"auto";','"none";'));
        //
        joRes.Add('this.'+sFull+'__dat=eval('''+_GetTreeViewData(TTreeView(ACtrl))+''');');

        //
        //joRes.Add('this.'+sFull+'__dek='+_GetTreeDefaultExpandedKeys(TTreeView(ACtrl))+';');

        //各节点展开/合拢状态代码
(*
        sCode   := '';
        iItem  := 0;
        tnItem := Items.GetFirstNode;
        while tnItem <> nil do begin
            //
            if tnItem.Count>0 then begin
                if tnItem.Expanded then begin
                    sCode   := sCode + 'this.$refs.'+sFull+'.store.nodesMap['+IntToStr(tnItem.GetHashCode)+'].expanded = true;'
                end else begin
                    sCode   := sCode + 'this.$refs.'+sFull+'.store.nodesMap['+IntToStr(tnItem.GetHashCode)+'].expanded = false;'
                end;
            end;

            //
            tnItem := tnItem.GetNext;
            Inc(iItem);
        end;
        //
        joRes.Add(sCode);
*)

    end;
    //
    Result    := (joRes);
end;

function dwGetMethods(ACtrl:TControl):String;stdCall;
var
    //
    sCode       : string;
    sFull       : string;
    //
    iHandle     : THandle;

    //
    joRes       : Variant;  //返回结果
    joHint      : Variant;  //HINT
begin
    joRes   := _json('[]');

    //取得HINT对象JSON
    joHint := dwGetHintJson(TControl(ACtrl));

    //取得名称 备用
    sFull   := dwFullName(ACtrl);

    //取得句柄备用
    iHandle := TForm(ACtrl.Owner).Handle;

    //
    with TTreeView(ACtrl) do begin

        //展开函数
        sCode   :=
                sFull+'__cellclick(id,col,group){'+
                    'console.log(id,col,group);'+
                    'var jo={};'+
                    'jo.m="event";'+
                    'jo.c="'+sFull+'";'+
                    'jo.i='+IntToStr(iHandle)+';'+
                    'jo.v = id+'',''+col+'',''+group;'+
                    'jo.e="cellclick";'+
                    'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:2051}})'+
                    '.then(resp =>{this.procResp(resp.data)});'+
                '},';
        joRes.Add(sCode);

        //合拢函数
        sCode   :=
                sFull+'__nodecollapse(data){'+
                    'var jo={};'+
                    'jo.m="event";'+
                    'jo.c="'+sFull+'";'+
                    'jo.i='+IntToStr(iHandle)+';'+
                    'jo.v=''''+data.id+'''';'+
                    'jo.e="nodecollapse";'+
                    'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:2051}})'+
                    '.then(resp =>{this.procResp(resp.data)});'+
                '},';
        joRes.Add(sCode);

        //当复选框被点击的时候触发
        //共两个参数，依次为：传递给 data 属性的数组中该节点所对应的对象、树目前的选中状态对象，
        //包含 checkedNodes、checkedKeys、halfCheckedNodes、halfCheckedKeys 四个属性
        sCode   :=
                sFull+'__check(keys, leafOnly){'+
    'console.log(keys, leafOnly);'+
    //获取所有选中的节点id
    'let _sel  = this.$refs.'+sFull+'.getCheckedKeys();'+
    'let _half = this.$refs.'+sFull+'.getHalfCheckedKeys();'+
    'console.log(_sel, ''选中的节点'');'+
    'console.log(_half, ''半选中的节点'');'+
    '_sel = "["+_sel+"],["+_half+"]";'+
                    //'console.log(data);'+
                    'var jo={};'+
                    'jo.m="event";'+
                    'jo.c="'+sFull+'";'+
                    'jo.i='+IntToStr(iHandle)+';'+
                    'jo.v=escape(_sel);'+
                    'jo.e="check";'+
                    'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:2051}})'+
                    '.then(resp =>{this.procResp(resp.data)});'+
                '},';
        joRes.Add(sCode);
    end;
    //

    //
    Result := (joRes);
end;



exports
     dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetMethods,
     dwGetTail,
     dwGetAction,
     dwGetData;
     
begin
end.
 
