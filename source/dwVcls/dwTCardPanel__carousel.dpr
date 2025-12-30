library dwTCardPanel__carousel;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     Vcl.WinXPanels,
     Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, ComCtrls, ExtCtrls,
     StdCtrls, Windows;

//--------------一些自用函数------------------------------------------------------------------------
function dwLTWHTab(ACtrl:TControl):String;  //可以更新位置的用法
begin
     //只有W，H
     with ACtrl do begin
          Result    := ' :style="{width:'+dwFullName(Actrl)+'__wid,height:'+dwFullName(Actrl)+'__hei}"'
                    +' style="position:absolute;left:0px;top:0px;';
     end;
end;


//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    joRes   : Variant;
begin
    with TCardPanel(Actrl) do begin
        Result    := '[]';
    end;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
    iTab        : Integer;
    iName       : Integer;
    sTabName    : string;
    sAction     : string;
    joData      : Variant;
    oCard       : TCard;
    oChange     : Procedure(Sender:TObject;PrevCard,NextCard:TCard) of Object;
begin
    with TCardPanel(Actrl) do begin
        //用作走马灯控件（该部分未测试）---------------------------------------------------

           //解析AData字符串到JSON对象
        joData    := _json(AData);

        if joData.e = 'onchange' then begin
            //保存事件
            oChange := TCardPanel(ACtrl).OnCardChange;

            //清空事件,以防止自动执行
            TCardPanel(ACtrl).OnCardChange  := nil;

            //更新值
            for iTab := 0 to TCardPanel(ACtrl).CardCount-1 do begin
                if TCardPanel(ACtrl).Cards[iTab].Name = joData.v then begin
                     TCardPanel(ACtrl).ActiveCardIndex     := iTab;
                     break;
                end;
            end;
            //恢复事件
            TCardPanel(ACtrl).OnCardChange  := oChange;

            //执行事件
            if Assigned(OnCardChange) then begin
                OnCardChange(TCardPanel(ACtrl),ActiveCard,ActiveCard);
            end;

            //清空OnExit事件
            TCardPanel(ACtrl).OnExit  := nil;
        end else if joData.e = 'onenddock' then begin
            //ShowMessage(joData.v);
            sAction := dwUnescape(joData.v);
            //
            sTabName    := Copy(sAction,1,Pos(',',sAction)-1);
            Delete(sAction,1,Pos(',',sAction));
            //
            if sAction = 'add' then begin
                //oCard    := TCard.Create(TForm(ACtrl.Owner));

                //设置一个可用的Name
                //for iName := 1 to 9999 do begin
                //    if not Assigned(TForm(ACtrl.Owner).FindComponent('TabSheet'+IntToStr(iName))) then begin
                //        oCard.Name           := 'TabSheet'+IntToStr(iName);
                //        //
                //        break;
                //    end;
                //end;
                //oCard.CardControl    := TCardPanel(ACtrl);

                //执行事件
                if Assigned(TCardPanel(ACtrl).OnEndDock) then begin
                    TCardPanel(ACtrl).OnEndDock(TCardPanel(ACtrl),nil,1,0);
                end;
                //
            end else if sAction = 'remove' then begin
                for iTab := 0 to TCardPanel(ACtrl).CardCount-1 do begin
                    oCard    := TCardPanel(ACtrl).Cards[iTab];
                    if oCard.Name = sTabName then begin
                        //oCard.Destroy;
                        //执行事件
                        if Assigned(TCardPanel(ACtrl).OnEndDock) then begin
                            TCardPanel(ACtrl).OnEndDock(TCardPanel(ACtrl),nil,0,iTab);
                        end;
                        //
                        break;
                    end;
                end;
            end;
        end;
    end;

end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
     sCode      : string;
     sEdit      : string;   //增减TTabSheet的处理代码
     joHint     : Variant;
     joRes      : Variant;
     joTabHint  : Variant;
     iTab       : Integer;
begin
    with TCardPanel(Actrl) do begin
        //用作走马灯控件------------------------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));


        with TCardPanel(ACtrl) do begin
            //为其TabSheet赋值HelpKeyword,以保持一致性
            for iTab := 0 to CardCount-1 do begin
                Cards[iTab].HelpKeyword := HelpKeyword;
            end;


            //外框
            joRes.Add('<el-carousel'
                    +' id="'+dwFullName(Actrl)+'"'
                    +' class="swiper-container"'
                    +dwVisible(TControl(ACtrl))
                    +dwGetDWAttr(joHint)
                    +dwLTWH(TControl(ACtrl))
                    +dwGetDWStyle(joHint)
                    +'overflow:hidden;'
                    +'text-align:center;'   //水平居中
                    +'"' //style 封闭
                    +'>');
        end;
        //
        Result    := (joRes);

    end;
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
    with TCardPanel(Actrl) do begin
        //用作走马灯控件-------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');
        //生成返回值数组
        joRes.Add('</el-carousel>');
        //
        Result    := (joRes);
    end;
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     iTab      : Integer;
begin
    with TCardPanel(Actrl) do begin
        //用作走马灯控件（代码未测试）---------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TCardPanel(ACtrl) do begin
            joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
            joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
            joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
            joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
            //
            joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
            joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(Enabled,'false,','true,'));
            //
            if ActiveCardIndex>=0 then begin
                 joRes.Add(dwFullName(Actrl)+'__apg:"'+LowerCase(dwPrefix(Actrl)+ActiveCard.Name)+'",');
            end else begin
                 joRes.Add(dwFullName(Actrl)+'__apg:"'+''+'",');
            end;
            //各页面可见性
            for iTab := 0 to CardCount-1 do begin
                joRes.Add(LowerCase(dwPrefix(Actrl)+Cards[iTab].Name)+'__tbv:'+dwIIF(Cards[iTab].Visible,'true,','false,'));
            end;
        end;
        //
        Result    := (joRes);
    end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
    iTab      : Integer;
begin
    with TCardPanel(Actrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //
        //
        with TCardPanel(ACtrl) do begin
            joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
            //
            joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));
            joRes.Add('this.'+dwFullName(Actrl)+'__dis='+dwIIF(Enabled,'false;','true;'));
            //
            if ActiveCardIndex>=0 then begin
                 joRes.Add('this.'+dwFullName(Actrl)+'__apg="'+LowerCase(dwPrefix(Actrl)+ActiveCard.Name)+'";');
            end else begin
                 joRes.Add('this.'+dwFullName(Actrl)+'__apg="'+''+'";');
            end;

            //各页面可见性
            for iTab := 0 to CardCount-1 do begin
                 joRes.Add('this.'+LowerCase(dwPrefix(Actrl)+Cards[iTab].Name)+'__tbv='+dwIIF(Cards[iTab].Visible,'true;','false;'));
            end;
        end;
        //
        Result    := (joRes);
    end;
end;


exports
    dwGetExtra,
    dwGetEvent,
    dwGetHead,
    dwGetTail,
    dwGetAction,
    dwGetData;
     
begin
end.
 
