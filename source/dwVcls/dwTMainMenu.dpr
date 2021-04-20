library dwTMainMenu;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, ComCtrls, ExtCtrls, Menus,
     StdCtrls, Windows;

//======辅助函数================================================================
//取得MenuItem
function dwGetMenuItem(AMenu:TMainMenu;AValue:string):TMenuItem;
var
     iIDs      : array of Integer;
     I         : Integer;
begin
     //将AValue 转换为int数组
     SetLength(iIDs,0);
     while Pos('-',AValue)>0 do begin
          SetLength(iIDs,Length(iIDs)+1);
          iIDs[High(iIDs)]    := StrToIntDef(Copy(AValue,1,Pos('-',AValue)-1),0);
          //
          Delete(AValue,1,Pos('-',AValue));
     end;
     SetLength(iIDs,Length(iIDs)+1);
     iIDs[High(iIDs)]    := StrToIntDef(AValue,0);

     //
     Result    := AMenu.Items[iIDs[0]];

     //
     for i := 1 to High(iIDs) do begin
          Result    := Result.Items[iIDs[i]];
     end;
end;
//==============================================================================

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
begin
     Result    := '[]';
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData    : Variant;
     oMenuItem : TMenuItem;

begin
     joData    := _json(AData);

     //先找到对应的菜单项
     oMenuItem := dwGetMenuItem(TMainMenu(ACtrl),joData.v);

     //
     if oMenuItem = nil then begin
          Exit;
     end;

     //执行事件
     if Assigned(oMenuItem.OnClick) then begin
          oMenuItem.OnClick(oMenuItem);
     end;
end;

function _CreateItems (AItem:TMenuItem;APath:String; var ACode:String):Integer;
var
     ii        : Integer;
     ii1       : Integer;
     miItem    : TMenuItem;
     ssPath    : String;
begin
     //注释： index 从0开始，每一层用-隔开，如1-3-2

     //
     for ii := 0 to AItem.Count-1 do begin
          miItem   := AItem.items[ii];
          //
          if miItem.Count = 0 then begin
               if (miItem.ImageIndex>0)and(miItem.ImageIndex<=High(dwIcons)) then begin
                    ACode     := ACode + '<el-menu-item index="'+APath+'-'+IntToStr(ii)+'">'
                    +'<i class="'+dwIcons[miItem.ImageIndex]+'"></i>'
                    +'<span slot="title">'+miItem.caption+'</span>'
                    +'</el-menu-item>'#13;
               end else begin

                    ACode     := ACode + '<el-menu-item index="'+APath+'-'+IntToStr(ii)+'">'
                    +miItem.caption+'</el-menu-item>'#13;
               end;
          end else begin
               ACode     := ACode + '<el-submenu index="'+APath+'-'+IntToStr(ii)+'"><template slot="title">'#13;
               if (miItem.ImageIndex>0)and(miItem.ImageIndex<=High(dwIcons)) then begin
                    ACode     := ACode + '<i class="'+dwIcons[miItem.ImageIndex]+'"></i>';
               end;
               ACode     := ACode + '<span>'+miItem.caption+'</span></template>'#13;

               //
               ssPath    := APath+'-'+IntToStr(ii);

               _CreateItems(miItem,ssPath,ACode);


               //
               //ACode     := ACode + '    </template>'#13;
               ACode     := ACode + '</el-submenu>'#13;
          end;
     end;

end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
     sCode     : string;
     joHint    : Variant;
     joRes     : Variant;
     iItem     : Integer;
     oItem     : TMenuItem;
     sHint     : String;
begin
     //生成返回值数组
     joRes    := _Json('[]');

     //取得HINT对象JSON
     sHint     := '{}';
     if TMainMenu(ACtrl).Items.Count>0 then begin
          sHint     := TMainMenu(ACtrl).Items[0].Hint;
     end;
     TDocVariant.New(joHint);
     if (sHint<>'') then begin
          if (Copy(sHint,1,1) = '{') and (Copy(sHint,Length(sHint),1) = '}') then begin
               joHint    := _json(sHint);
          end;
     end;

     with TMainMenu(ACtrl) do begin
          sCode     := '<el-menu'
                    +' id="'+dwPrefix(Actrl)+Name+'"'
                    +' :default-active="'+dwPrefix(Actrl)+Name+'__act"'     //默认选中状态
                    +' class="el-menu-demo"'
                    +dwIIF(ParentBiDiMode=False,'',' mode="horizontal"')

                    //+' background-color="#545c64"'  背景色
                    +dwGetHintValue(joHint,'background-color','background-color',' background-color="#545c64"')

                    //+' text-color="#fff"'           //文本色
                    +dwGetHintValue(joHint,'text-color','text-color',' text-color="#fff"')

                    //+' active-text-color="#ffd04b"' //激活状态文本色
                    +dwGetHintValue(joHint,'active-text-color','active-text-color',' active-text-color="#ffd04b"')

                    //:collapse="isCollapse"           //折叠
                    +' :collapse="'+dwPrefix(Actrl)+Name+'__cps"'
                    +' :collapse-transition="false"'

                    //+dwVisible(ACtrl)
                    //+dwDisable(ACtrl)
                    +dwLTWHComp(ACtrl)
                    +dwIIF(ParentBiDiMode=False,'line-height:30px;','line-height:'+IntToStr((Tag mod 10000)-22)+'px;')
                    +'"' //style 封闭

                    +Format(_DWEVENT,['select',Name,'val','onclick',TForm(Owner).Handle])
                    +'>';
          //添加
          joRes.Add(sCode);

          //
          sCode      := '';

          for iItem := 0 to Items.Count-1 do begin
               oItem     := Items[iItem];
               if oItem.Count = 0 then begin //无子菜单

                    //根据有无图标判断
                    if (oItem.ImageIndex>0)and(oItem.ImageIndex<=High(dwIcons)) then begin
                         joRes.Add('<el-menu-item index="'+IntToStr(iItem)+'" style="height:50px;line-height:35px">'
                              +'<i class="'+dwIcons[oItem.ImageIndex]+'"></i>'
                              +'<span slot="title">'+oItem.caption+'</span>'
                              +'</el-menu-item>');
                    end else begin
                         joRes.Add('<el-menu-item index="'+IntToStr(iItem)+'" style="height:50px;line-height:35px">'+oItem.Caption+'</el-menu-item>');
                    end;

               end else begin
                    joRes.Add('<el-submenu index="'+IntToStr(iItem)+'"><template slot="title">');
                    if (oItem.ImageIndex>0)and(oItem.ImageIndex<=High(dwIcons)) then begin
                         joRes.Add('<i class="'+dwIcons[oItem.ImageIndex]+'"></i>');
                    end;
                    joRes.Add('<span>'+oItem.Caption+'</span></template>');
                    //
                    _CreateItems(oItem,IntToStr(iItem),sCode);
                    joRes.Add(sCode);
                    sCode     := '';
                    //
                    joRes.Add('</el-submenu>');
               end;
          end;
          //添加
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
     joRes.Add('</el-menu>');
     //
     Result    := (joRes);
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sAction   : String;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //
     with TMainMenu(ACtrl) do begin

          //折叠状态
          joRes.Add(dwPrefix(Actrl)+Name+'__cps:'+dwIIF(AutoMerge,'true','false')+',');

          if Tag < 10000 then begin
               //如果没有设置当前菜单的LTWH,则为默认值
               joRes.Add(dwPrefix(Actrl)+Name+'__lef:"0px",');
               joRes.Add(dwPrefix(Actrl)+Name+'__top:"0px",');
               joRes.Add(dwPrefix(Actrl)+Name+'__wid:"600px",');
               joRes.Add(dwPrefix(Actrl)+Name+'__hei:"38px",');
          end else begin
               joRes.Add(dwPrefix(Actrl)+Name+'__lef:"'+IntToStr(DesignInfo div 10000)+'px",');
               joRes.Add(dwPrefix(Actrl)+Name+'__top:"'+IntToStr(DesignInfo mod 10000)+'px",');
               joRes.Add(dwPrefix(Actrl)+Name+'__wid:"'+IntToStr(Tag div 10000)+'px",');
               joRes.Add(dwPrefix(Actrl)+Name+'__hei:"'+IntToStr(Tag mod 10000)+'px",');
          end;

          //当前激活菜单位置(保存在Items[0].Hint)
          if Items.Count>0 then begin
               sAction   := Items[1].Hint;// dwGetProp(TControl(Items[0]),'actionindex');
               if sAction<>'' then begin
                    joRes.Add(dwPrefix(Actrl)+Name+'__act:"'+sAction+'",');
               end else begin
                    joRes.Add(dwPrefix(Actrl)+Name+'__act:"0",');
               end;
          end else begin
               joRes.Add(dwPrefix(Actrl)+Name+'__act:"0",');
          end;
     end;
     //
     Result    := (joRes);
end;

function dwGetMethod(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //
     with TMainMenu(ACtrl) do begin
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lef="'+IntToStr(DesignInfo div 10000)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__top="'+IntToStr(DesignInfo mod 10000)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__wid="'+IntToStr(Tag div 10000)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__hei="'+IntToStr(Tag mod 10000)+'px";');

          //折叠状态
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__cps='+dwIIF(AutoMerge,'true','false')+';');
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
 
