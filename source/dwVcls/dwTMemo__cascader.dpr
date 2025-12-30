library dwTMemo__cascader;
(*
说明；用于生成多级级联选择框

使用：
    1、放置TMemo
    2、设置HelpKeyword = 'cascader'
    3、在Lines中设置数据项，形如：
    {
        "children":[
            {
                "label":"湖北",
                "children":[
                    {
                        "label":"武汉",
                        "children":[
                            {
                                "label":"武昌"
                            },
                            {
                                "label":"汉口"
                            },
                            {
                                "label":"汉阳"
                            }
                        ]
                    },
                    {
                        "label":"襄阳",
                        "children":[
                            {
                                "label":"襄城区"
                            },
                            {
                                "label":"樊城区"
                            },
                            {
                                "label":"襄州区"
                            }
                        ]
                    }
                ]
            },

            {
                "label":"浙江",
                "children":[
                    {
                        "label":"杭州",
                        "children":[
                            {
                                "label":"杭昌"
                            },
                            {
                                "label":"杭东"
                            },
                            {
                                "label":"杭南"
                            }
                        ]
                    }
                ]
            }
        ]
    }

*)

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
     Variants,
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


function _GeTMemoValue(ACtrl:TMemo):String;
var
    joData  : Variant;
begin
    Result  := '';

    //
    joData  := _json(ACtrl.Text);

    if joData <> unassigned then begin
        Result  := joData.value;
    end;
end;

//设置 每个节点的value,格式为, 并保存到Memo中
function _SetValue(ACtrl:TMemo):Integer;
    procedure __SetChildren(var ANode:Variant;APrefix:String);
    var
        iiChild     : Integer;
        ssPrefix    : String;
        joChild     : Variant;
    begin
        if not ANode.Exists('children') then begin
            Exit;
        end;
        for iiChild := 0 to ANode.children._Count - 1 do begin
            //
            joChild := ANode.children._(iiChild);

            //
            if APrefix <> '' then begin
                ssPrefix    := APrefix + '/' + joChild.label;
            end else begin
                ssPrefix    := joChild.label;
            end;

            //
            joChild.value := ssPrefix;

            //
            __SetChildren(joChild,ssPrefix);
        end;
    end;
var
    joData  : Variant;
    joItem  : Variant;
begin
    //
    Result  := 0;

    //
    joData  := _json(ACtrl.Text);

    if joData = unassigned then begin
        Result  := -1;
    end else begin
        if not joData.Exists('seted') then begin
            //
            joData.value    := '';

            //设置一个标志，以防多次setValue
            joData.seted    := 1;

            //
            __SetChildren(joData,'');

            //
            ACtrl.Text  := joData;
        end;
    end;

end;



function _GetMemoData(ACtrl:TMemo):String;
var
    joData  : Variant;
begin
    joData  := _json(ACtrl.Text);

    //生成数据                   DocVariantData(AJson).ToJSON('','',jsonHumanReadable)
    Result  := DocVariantData(joData.children).ToJSON('','',jsonHumanReadable);

    //进行改造
    Result  := StringReplace(Result,'"value":','value:',[rfReplaceAll]);
    Result  := StringReplace(Result,'"label":','label:',[rfReplaceAll]);
    Result  := StringReplace(Result,'"children":','children:',[rfReplaceAll]);
    Result  := StringReplace(Result,'"','''',[rfReplaceAll]);

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

begin
    //
    joData      := _Json(AData);

    //找到对应的数据
    sValue      := dwUnescape(joData.v);

    //
    if joData.e = 'onchange' then begin
        while Pos(',',sValue) > 0 do begin
            Delete(sValue,1,Pos(',',sValue));
        end;

        //保存在Memo1.Text生成的JSON的value中
        joValue     := _json(TMemo(ACtrl).Text);
        if joValue = unassigned then begin
            joValue := _json('{}');
        end;
        joValue.value   := sValue;
        TMemo(ACtrl).Text   := joValue;
        //执行事件
        if Assigned(TMemo(ACtrl).OnChange) then begin
            TMemo(ACtrl).OnChange(TMemo(ACtrl));
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

    //
    _SetValue(TMemo(ACtrl));

    with TMemo(ACtrl) do begin
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
                    'position:absolute;'+
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
    with TMemo(ACtrl) do begin
        //
        joRes.Add(sFull+'__val: "'+_GeTMemoValue(TMemo(ACtrl))+'",');
        //defaultProps
        joRes.Add(sFull+'__opt: '+_GeTMemoData(TMemo(ACtrl))+',');
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
    with TMemo(ACtrl) do begin
        joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        joRes.Add('this.'+sFull+'__val="'+_GeTMemoValue(TMemo(ACtrl))+'";');
        joRes.Add('this.'+sFull+'__opt='+_GeTMemoData(TMemo(ACtrl))+';');
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


    with TMemo(ACtrl) do begin
        //编辑后save事件
        sCode   :=
                sFull+'__change(value) ' +
                '{' +
                    //'console.log(value);' +
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
 
