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

//======��������================================================================
//ȡ��MenuItem
function dwGetMenuItem(AMenu:TMainMenu;AValue:string):TMenuItem;
var
     iIDs      : array of Integer;
     I         : Integer;
begin
     //��AValue ת��Ϊint����
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

//��ǰ�ؼ���Ҫ����ĵ�����JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
begin
     Result    := '[]';
end;

//����JSON����ADataִ�е�ǰ�ؼ����¼�, �����ؽ���ַ���
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData    : Variant;
     oMenuItem : TMenuItem;

begin
     joData    := _json(AData);

     //���ҵ���Ӧ�Ĳ˵���
     oMenuItem := dwGetMenuItem(TMainMenu(ACtrl),joData.value);

     //
     if oMenuItem = nil then begin
          Exit;
     end;

     //ִ���¼�
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
     //ע�ͣ� index ��0��ʼ��ÿһ����-��������1-3-2

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


//ȡ��HTMLͷ����Ϣ
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
     sCode     : string;
     joHint    : Variant;
     joRes     : Variant;
     iItem     : Integer;
     oItem     : TMenuItem;
     sHint     : String;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');

     //ȡ��HINT����JSON
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
                    +' :default-active="'+Name+'__act"'     //Ĭ��ѡ��״̬
                    +' class="el-menu-demo"'
                    +dwIIF(ownerDraw,'',' mode="horizontal"')
                    //+' background-color="#545c64"'
                    +dwGetHintValue(joHint,'background-color','background-color',' background-color="#545c64"')
                    //+' text-color="#fff"'
                    +dwGetHintValue(joHint,'text-color','text-color',' text-color="#fff"')
                    //+' active-text-color="#ffd04b"'
                    +dwGetHintValue(joHint,'active-text-color','active-text-color',' active-text-color="#ffd04b"')
                    //+dwVisible(ACtrl)
                    //+dwDisable(ACtrl)
                    +dwLTWHComp(ACtrl)
                    +dwIIF(ownerDraw,'line-height:30px;','line-height:'+IntToStr((Tag mod 10000)-22)+'px;')
                    +'"' //style ���
                    +Format(_DWEVENT,['select',Name,'val','onclick',''])
                    +'>';
          //���
          joRes.Add(sCode);

          //
          sCode      := '';

          for iItem := 0 to Items.Count-1 do begin
               oItem     := Items[iItem];
               if oItem.Count = 0 then begin
                    if (oItem.ImageIndex>0)and(oItem.ImageIndex<=High(dwIcons)) then begin
                         joRes.Add('<el-menu-item index="'+IntToStr(iItem)+'">'
                              +'<i class="'+dwIcons[oItem.ImageIndex]+'"></i>'
                              +'<span slot="title">'+oItem.caption+'</span>'
                              +'</el-menu-item>');
                    end else begin
                         joRes.Add('<el-menu-item index="'+IntToStr(iItem)+'">'+oItem.Caption+'</el-menu-item>');
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
          //���
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
     joRes.Add('</el-menu>');
     //
     Result    := (joRes);
end;

//ȡ��Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sAction   : String;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //
     with TMainMenu(ACtrl) do begin
          if Tag < 10000 then begin
               //���û�����õ�ǰ�˵���LTWH,��ΪĬ��ֵ
               joRes.Add(Name+'__lef:"0px",');
               joRes.Add(Name+'__top:"0px",');
               joRes.Add(Name+'__wid:"600px",');
               joRes.Add(Name+'__hei:"38px",');
          end else begin
               joRes.Add(Name+'__lef:"'+IntToStr(DesignInfo div 10000)+'px",');
               joRes.Add(Name+'__top:"'+IntToStr(DesignInfo mod 10000)+'px",');
               joRes.Add(Name+'__wid:"'+IntToStr(Tag div 10000)+'px",');
               joRes.Add(Name+'__hei:"'+IntToStr(Tag mod 10000)+'px",');
          end;

          //��ǰ�˵�λ��(������Items[0].Hint)
          if Items.Count>0 then begin
               sAction   := Items[1].Hint;// dwGetProp(TControl(Items[0]),'actionindex');
               if sAction<>'' then begin
                    joRes.Add(Name+'__act:"'+sAction+'",');
               end else begin
                    joRes.Add(Name+'__act:"0",');
               end;
          end else begin
               joRes.Add(Name+'__act:"0",');
          end;
     end;
     //
     Result    := (joRes);
end;

function dwGetMethod(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //
     with TMainMenu(ACtrl) do begin
          joRes.Add('this.'+Name+'__lef="'+IntToStr(DesignInfo div 10000)+'px";');
          joRes.Add('this.'+Name+'__top="'+IntToStr(DesignInfo mod 10000)+'px";');
          joRes.Add('this.'+Name+'__wid="'+IntToStr(Tag div 10000)+'px";');
          joRes.Add('this.'+Name+'__hei="'+IntToStr(Tag mod 10000)+'px";');
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
 
