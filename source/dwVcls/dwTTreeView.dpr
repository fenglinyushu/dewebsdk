library dwTTreeView;

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
     //
     function __GetItemData(ANode:TTreeNode):string;
     var
          II        : Integer;
     begin
          Result         := '{';
          Result         := Result + 'id:'+IntToStr(ANode.GetHashCode)+',';
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
     //2023-10-06 使用了每个节点的 GetHashCode 代替 stateindex, 以下代码作废
     //设置stateindex为序号, 以用于后来确定点击的节点
     //iItem  := 0;
     //tnItem := ATV.Items.GetFirstNode;
     //while tnItem <> nil do begin
     //    tnItem.StateIndex  := iItem;
     //    tnItem := tnItem.GetNext;
     //    Inc(iItem);
     //end;


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

    if joHint <> unassigned then begin
        if joHint.Exists('selected') then begin
            sCode   :=
                    '<style>'+
                        '.el-tree-node.is-current > .el-tree-node__content {'+
                            'background-color: '+joHint.selected+' !important;'+
                        '}'+
                    '</style>';
            joRes.Add(sCode);

        end;
        if joHint.Exists('lineheight') then begin
            sCode   :=
                    '<style>'+
                        // 设置节点高度
                        '.el-tree-node__content{'+
                            'height: '+IntToStr(joHint.lineheight)+'px !important;'+
                        '}'+
                    '</style>';
            joRes.Add(sCode);

        end;
    end;

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
    joValue     : Variant;
    joSel       : Variant;
    joHalf      : Variant;
    bFound      : Boolean;
begin
    //
    joData      := _Json(AData);




    //
    if joData.e = 'onclick' then begin
        //找到对应的节点,并选中
        iHashCode   := StrToIntDef(joData.v,-1);
        if iHashCode = -1 then begin
            Exit;
        end;
        //
        with TTreeView(ACtrl) do begin
            for iItem := 0 to Items.Count-1 do begin
                if Items[iItem].GetHashCode = iHashCode then begin
                    Items[iItem].Selected  := True;
                    break;
                end;
            end;
        end;
        //执行事件
        if Assigned(TTreeView(ACtrl).OnClick) then begin
            TTreeView(ACtrl).OnClick(TTreeView(ACtrl));
        end;
    end else if joData.e = 'nodeexpand' then begin
        //找到对应的节点,并选中
        iHashCode   := StrToIntDef(joData.v,-1);
        if iHashCode = -1 then begin
            Exit;
        end;
        //
        with TTreeView(ACtrl) do begin
            for iItem := 0 to Items.Count-1 do begin
                if Items[iItem].GetHashCode = iHashCode then begin
                    Items[iItem].Expanded   := True;
                    break;
                end;
            end;
        end;
    end else if joData.e = 'nodecollapse' then begin
        //
        with TTreeView(ACtrl) do begin
            for iItem := 0 to Items.Count-1 do begin
                if Items[iItem].GetHashCode = iHashCode then begin
                    Items[iItem].Expanded   := False;
                    break;
                end;
            end;
        end;
    end else if joData.e = 'check' then begin
        //取得选中的数据，为两个数组，前面为全选中的节点id,后面是半选中的节点id
        sValue  := dwUnescape(joData.v);

        //转化为JSON对象
        joValue := _json('['+sValue+']');

        //
        if joValue = unassigned then begin
            Exit;
        end;
        joSel   := joValue._(0);
        joHalf  := joValue._(1);

        //设置节点
        with TTreeView(ACtrl) do begin
            for iItem := 0 to Items.Count-1 do begin
                Items[iItem].StateIndex := 0;

                //检查是否为全选中
                bFound  := False;
                for iSel := 0 to joSel._Count - 1 do begin
                    if Items[iItem].GetHashCode = joSel._(iSel) then begin
                        Items[iItem].StateIndex := 1;
                        bFound  := True;
                        break;
                    end;
                end;

                //检查是否为半选中
                if not bFound then begin
                    for iHalf := 0 to joHalf._Count - 1 do begin
                        if Items[iItem].GetHashCode = joHalf._(iHalf) then begin
                            Items[iItem].StateIndex := 2;
                            break;
                        end;
                    end;
                end;
            end;
        end;
    end;

end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode   : string;
    joHint  : Variant;
    joRes   : Variant;
    sFull   : String;
begin
    //
    sFull   := dwFullName(ACtrl);

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
                +' ref="'+sFull+'"'
                +' id="'+sFull+'"'
                +dwVisible(TControl(ACtrl))                             //用于控制可见性Visible
                +dwDisable(TControl(ACtrl))                           //用于控制可用性Enabled(部分控件不支持)
                +dwIIF(MultiSelect,' show-checkbox','')                 //MultiSelect为true时显示为可选择
                +' :data="'+sFull+'__dat"'
                +' node-key="id"'
                +' :default-expanded-keys="'+sFull+'__dek"'
                +' :highlight-current="'+dwIIF(HideSelection,'false','true')+'"'    //
                +' :props="'+sFull+'__dps"'                             //defaultProps
                +' :expand-on-click-node="'+dwIIF(HotTrack,'true','false')+'"'      //HotTrack为真时点击展开
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
                +Format(_DWEVENT,['node-click',Name,'val.id','onclick',TForm(Owner).Handle]) //绑定OnChange事件
                +' @node-expand="'+sFull+'__nodeexpand" '
                +' @node-collapse="'+sFull+'__nodecollapse" '
                +' @check="'+sFull+'__check" '
                +'>');
                joRes.Add('<span'
                    +' class="custom-tree-node" slot-scope="{ node, data }">'
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
    joRes   : Variant;
    sCode   : String;
    sFull   : String;
begin
    //得到全名备用
    sFull   := dwFullName(ACtrl);

    //生成返回值数组
    joRes   := _Json('[]');


    //
    with TTreeView(ACtrl) do begin
        //
        joRes.Add(sFull+'__dat:'+_GetTreeViewData(TTreeView(ACtrl))+',');
        //defaultProps
        joRes.Add(sFull+'__dps: {children: ''children'',label: ''label''},');
        //
        joRes.Add(sFull+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(sFull+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(sFull+'__dis:'+dwIIF(Enabled,'false,','true,'));
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
    //得到全名备用
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
        joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));
        joRes.Add('this.'+sFull+'__pte='+dwIIF(Enabled,'"auto";','"none";'));
        //
        joRes.Add('this.'+sFull+'__dat='+_GetTreeViewData(TTreeView(ACtrl))+';');

        //
        joRes.Add('this.'+sFull+'__dek='+_GetTreeDefaultExpandedKeys(TTreeView(ACtrl))+';');

        //各节点展开/合拢状态代码
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

        //高亮当前行
        if Selected <> nil then begin
            sCode   := ''
                    +'this.$nextTick(function(){'
                    +'    this.$refs["'+sFull+'"].setCurrentKey('+IntToStr(Selected.GetHashCode)+');'
                    +'});';
        end else begin
            sCode   := '';
        end;
        joRes.Add(sCode);


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
                sFull+'__nodeexpand(data){'+
                    'var jo={};'+
                    'jo.m="event";'+
                    'jo.c="'+sFull+'";'+
                    'jo.i='+IntToStr(iHandle)+';'+
                    'jo.v=''''+data.id+'''';'+
                    'jo.e="nodeexpand";'+
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
                    //'console.log(keys, leafOnly);'+
                    //获取所有选中的节点id
                    'let _sel  = this.$refs.'+sFull+'.getCheckedKeys();'+
                    'let _half = this.$refs.'+sFull+'.getHalfCheckedKeys();'+
                    //'console.log(_sel, ''选中的节点'');'+
                    //'console.log(_half, ''半选中的节点'');'+
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

function dwGetMounted(ACtrl:TControl):String;stdCall;
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
        if Selected <> nil then begin
            sCode   := ''
                    +'this.$nextTick(function(){'#13
                    +'    this.$refs["'+sFull+'"].setCurrentKey('+IntToStr(Selected.GetHashCode)+');'#13
                    +'});';
            joRes.Add(sCode);
        end;
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
     dwGetMounted,
     dwGetTail,
     dwGetAction,
     dwGetData;

begin
end.
 
