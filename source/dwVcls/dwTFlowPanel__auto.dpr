library dwTFlowPanel__auto;
{
说明：
    用于将其内的子控件自动适配PC/移动端
    也就是可以将其内的多个子控件水平自动等宽排列。
    如果子控件太多(数量n*子控件最小宽度>宽度),则换行显示

具体设计：
    1 设置一个子控件最小宽度(通过HelpContext)iMinW，如20；
      如果 HelpContext 为 0 （默认值）,则最小宽度为20
      否则为 当前子控件的最小宽度
      如果 HelpContext 为负值 ，则为固定宽度
    2 如果FP宽度小于iMinW, 则置所有子控件宽度为FP宽度；
    3 如果FP宽度大于iMinW, 则置所有子控件占满FP宽度
      假定iMinW = 200
      如FP.width = 300, 则置所有子控件宽度为300
      如FP.width = 500, 则置所有子控件宽度为250
      ...
    4 当iMinW大于10000时，比如10004， 先取10000的余数，比如4，表示每行排列4个控件
}

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     Math,
     Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, ComCtrls, ExtCtrls,
     StdCtrls, Windows;

function _GetFont(AFont:TFont):string;
begin

    Result    := 'color:'+dwColor(AFont.color)+';'
               +'font-family:'''+AFont.name+''';'
               +'font-size:'+IntToStr(AFont.size+3)+'px;';

     //粗体
     if fsBold in AFont.Style then begin
          Result    := Result+'font-weight:bold;';
     end else begin
          Result    := Result+'font-weight:normal;';
     end;

     //斜体
     if fsItalic in AFont.Style then begin
          Result    := Result+'font-style:italic;';
     end else begin
          Result    := Result+'font-style:normal;';
     end;

     //下划线
     if fsUnderline in AFont.Style then begin
          Result    := Result+'text-decoration:underline;';
          //删除线
          if fsStrikeout in AFont.Style then begin
               Result    := Result+'text-decoration:line-through;';
          end;
     end else begin
          //删除线
          if fsStrikeout in AFont.Style then begin
               Result    := Result+'text-decoration:line-through;';
          end else begin
               Result    := Result+'text-decoration:none;';
          end;
     end;
end;

function _GetFontWeight(AFont:TFont):String;
begin
     if fsBold in AFont.Style then begin
          Result    := 'bold';
     end else begin
          Result    := 'normal';
     end;

end;
function _GetFontStyle(AFont:TFont):String;
begin
     if fsItalic in AFont.Style then begin
          Result    := 'italic';
     end else begin
          Result    := 'normal';
     end;
end;
function _GetTextDecoration(AFont:TFont):String;
begin
     if fsUnderline in AFont.Style then begin
          Result    :='underline';
          //删除线
          if fsStrikeout in AFont.Style then begin
               Result    := 'line-through';
          end;
     end else begin
          //删除线
          if fsStrikeout in AFont.Style then begin
               Result    := 'line-through';
          end else begin
               Result    := 'none';
          end;
     end;
end;
function _GetTextAlignment(ACtrl:TControl):string;
begin
     Result    := '';
     case TFlowPanel(ACtrl).Alignment of
          taRightJustify : begin
               Result    := 'right';
          end;
          taCenter : begin
               Result    := 'center';
          end;
     end;
end;

function _GetAlignment(ACtrl:TControl):string;
begin
     Result    := '';
     case TFlowPanel(ACtrl).Alignment of
          taRightJustify : begin
               Result    := 'text-align:right;';
          end;
          taCenter : begin
               Result    := 'text-align:center;';
          end;
     end;
end;

//重排当前子控件
function dwRealign(AFP:TFlowPanel):Integer;
var
    iMinW       : Integer;
    iCtrl       : Integer;
    iColCount   : Integer;
    iRowCount   : Integer;
    iCtrlW      : Integer;  //子控件宽度
    iLastCount  : Integer;  //未完全整除的最下面一行的子控件数量
    iLastW      : Integer;  //未完全整除的最下面一行的子控件宽度
    iLastWidth  : Integer;  //每行最后一个的宽度
    //
    oCtrl       : TControl;
    oLastVCtrl  : TControl; //最后一个可见的Control， 用于设置Margins.Bottom, 否则最后一行可能被遮挡
    //
    bOldAuto    : Boolean;
begin
    //如果没有子控件，则退出
    if AFP.ControlCount = 0 then begin
        Exit;
    end;

    //HelpContext表示子控件的最小宽度。 如果超过最小宽度，则设置为一行
    if AFP.HelpContext <> 0 then begin
        iMinW   := AFP.HelpContext;
    end else begin
        iMinW   := 20;
    end;

    //保存原AutoSize信息
    bOldAuto    := AFP.AutoSize;

    //先置非AutoSize
    AFP.AutoSize    := False;

    //设置最后一个可视控件默认为nil，即未赋值
    oLastVCtrl      := nil;

    //
    if iMinW > 10000 then begin
        //当iMinW大于10000时，比如10004， 先取10000的余数，比如4，表示每行排列4个控件


        //得到每行的列数
        iColCount   := iMinW mod 10000;
        iColCount   := Min(AFP.ControlCount,iColCount);

        //行数
        iRowCount   := Ceil(AFP.ControlCount/iColCount);

        //每个子控件宽度
        iCtrlW      := (AFP.Width div iColCount);

        //计算未完全整除的最下面一行的子控件宽度
        iLastW  := 20;
        if (AFP.ControlCount < iColCount * iRowCount) and AFP.Locked then begin
            iLastCount  := AFP.ControlCount - iColCount * (iRowCount-1);
            iLastW      := (AFP.Width div iLastCount) - 2;


            //设置每个子控件宽度
            for iCtrl := 0 to iColCount * (iRowCount-1) - 1 do begin
                oCtrl       := AFP.Controls[iCtrl];
                //
                if oCtrl.AlignWithMargins then begin
                    oCtrl.Width := iCtrlW - oCtrl.Margins.Left - oCtrl.Margins.Right;
                end else begin
                    oCtrl.Width := iCtrlW;
                end;
            end;

            //设置未完全整除的最下面一行的子控件宽度
            for iCtrl := iColCount * (iRowCount-1) to AFP.ControlCount - 1 do begin
                oCtrl       := AFP.Controls[iCtrl];
                //
                if oCtrl.AlignWithMargins then begin
                    oCtrl.Width := iLastW - oCtrl.Margins.Left - oCtrl.Margins.Right;
                end else begin
                    oCtrl.Width := iLastW;
                end;
                //最后一个设置Margins.Bottom，以保证下部空白
                oCtrl.Margins.Bottom    := Max(oCtrl.Margins.Bottom,10);

            end;
        end else begin
            //设置每个子控件宽度
            for iCtrl := 0 to AFP.ControlCount - 1 do begin
                oCtrl       := AFP.Controls[iCtrl];

                //取到最后一个可视化Ctrl, 以设置上边距，防止遮挡
                if oCtrl.Visible then begin
                    oLastVCtrl  := oCtrl;
                end;

                //每行的最后一个单独处理。 因为如果正好宽度相等会挤到下一行
                if (iCtrl mod iColCount) = iColCount - 1 then begin
                    //此处最后-1是为了防止被挤到下一行
                    iLastWidth  := AFP.Width - (iColCount - 1) * iCtrlW - 1;
                    if oCtrl.AlignWithMargins then begin
                        oCtrl.Width := iLastWidth - oCtrl.Margins.Left - oCtrl.Margins.Right;
                    end else begin
                        oCtrl.Width := iLastWidth;
                    end;
                end else begin
                    if oCtrl.AlignWithMargins then begin
                        oCtrl.Width := iCtrlW - oCtrl.Margins.Left - oCtrl.Margins.Right;
                    end else begin
                        oCtrl.Width := iCtrlW;
                    end;
                end;
                //

            end;
            //最后一个设置Margins.Bottom，以保证下部空白
            if oLastVCtrl <> nil then begin
                oLastVCtrl.Margins.Bottom    := Max(oCtrl.Margins.Bottom,10);
            end;


        end;

    end else if iMinW > 0 then begin
        if AFP.Width < Abs(iMinW) then begin
            //得到每行的列数
            iColCount   := 1;

            //行数
            iRowCount   := AFP.ControlCount;

            //每个子控件宽度
            iCtrlW      := AFP.Width - 1;

        end else begin
            //得到每行的列数
            iColCount   := AFP.Width div iMinW;
            iColCount   := Min(AFP.ControlCount,iColCount);

            //行数
            iRowCount   := Ceil(AFP.ControlCount/iColCount);

            //重新计算iColCount， 以避免最后一行数量太少的现象
            iColCount   := Ceil(AFP.ControlCount/iRowCount);

            //每个子控件宽度
            iCtrlW      := (AFP.Width div iColCount);
        end;

        //计算未完全整除的最下面一行的子控件宽度
        iLastW  := 20;
        if (AFP.ControlCount < iColCount * iRowCount) and AFP.Locked then begin
            iLastCount  := AFP.ControlCount - iColCount * (iRowCount-1);
            iLastW      := (AFP.Width div iLastCount) - 2;


            //设置每个子控件宽度
            for iCtrl := 0 to iColCount * (iRowCount-1) - 1 do begin
                oCtrl       := AFP.Controls[iCtrl];
                //
                if oCtrl.AlignWithMargins then begin
                    oCtrl.Width := iCtrlW - oCtrl.Margins.Left - oCtrl.Margins.Right;
                end else begin
                    oCtrl.Width := iCtrlW;
                end;
            end;

            //设置未完全整除的最下面一行的子控件宽度
            for iCtrl := iColCount * (iRowCount-1) to AFP.ControlCount - 1 do begin
                oCtrl       := AFP.Controls[iCtrl];
                //
                if oCtrl.AlignWithMargins then begin
                    oCtrl.Width := iLastW - oCtrl.Margins.Left - oCtrl.Margins.Right;
                end else begin
                    oCtrl.Width := iLastW;
                end;
                //最后一个设置Margins.Bottom，以保证下部空白
                oCtrl.Margins.Bottom    := Max(oCtrl.Margins.Bottom,10);

            end;
        end else begin
            //设置每个子控件宽度
            for iCtrl := 0 to AFP.ControlCount - 1 do begin
                oCtrl       := AFP.Controls[iCtrl];

                //取到最后一个可视化Ctrl, 以设置上边距，防止遮挡
                if oCtrl.Visible then begin
                    oLastVCtrl  := oCtrl;
                end;

                //每行的最后一个单独处理。 因为如果正好宽度相等会挤到下一行
                if (iCtrl mod iColCount) = iColCount - 1 then begin
                    //此处最后-1是为了防止被挤到下一行
                    iLastWidth  := AFP.Width - (iColCount - 1) * iCtrlW - 1;
                    if oCtrl.AlignWithMargins then begin
                        oCtrl.Width := iLastWidth - oCtrl.Margins.Left - oCtrl.Margins.Right;
                    end else begin
                        oCtrl.Width := iLastWidth;
                    end;
                end else begin
                    if oCtrl.AlignWithMargins then begin
                        oCtrl.Width := iCtrlW - oCtrl.Margins.Left - oCtrl.Margins.Right;
                    end else begin
                        oCtrl.Width := iCtrlW;
                    end;
                end;
                //

            end;
            //最后一个设置Margins.Bottom，以保证下部空白
            if oLastVCtrl <> nil then begin
                oLastVCtrl.Margins.Bottom    := Max(oCtrl.Margins.Bottom,10);
            end;


        end;
    end else begin
        //==============================================================================================================
        //以下HelpContext为负值，表示固定宽度（不扩展，只缩窄）
        //==============================================================================================================


        if AFP.Width < Abs(iMinW) then begin
            //------------------------------------------------------------------
            //如果屏幕比固定宽度窄，则缩窄显示
            //------------------------------------------------------------------

            //得到每行的列数
            iColCount   := 1;

            //行数
            iRowCount   := AFP.ControlCount;

            //每个子控件宽度
            iCtrlW      := AFP.Width - 1;

        end else begin
            //------------------------------------------------------------------
            //如果屏幕比固定宽度宽，则正常显示
            //------------------------------------------------------------------

            //得到每行的列数
            iColCount   := AFP.Width div abs(iMinW);        //计算每行最大列数
            iColCount   := Min(AFP.ControlCount,iColCount); //不超过子控件数

            //行数
            iRowCount   := Ceil(AFP.ControlCount/iColCount);

            //重新计算iColCount， 以避免最后一行数量太少的现象
            iColCount   := Ceil(AFP.ControlCount/iRowCount);

            //每个子控件宽度
            iCtrlW      := (AFP.Width div iColCount);
        end;

        //计算未完全整除的最下面一行的子控件宽度
        iLastW  := 20;
        if (AFP.ControlCount < iColCount * iRowCount) and AFP.Locked then begin
            iLastCount  := AFP.ControlCount - iColCount * (iRowCount-1);
            iLastW      := (AFP.Width div iLastCount) - 2;


            //设置每个子控件宽度
            for iCtrl := 0 to iColCount * (iRowCount-1) - 1 do begin
                oCtrl       := AFP.Controls[iCtrl];
                //
                oCtrl.Width             := Abs(iMinW);
                oCtrl.AlignWithMargins  := True;
                oCtrl.Margins.Left      := (iCtrlW - Abs(iMinW)) div 2;
                oCtrl.Margins.Right     := iCtrlW - oCtrl.Margins.Left - abs(iMinW);
            end;

            //设置未完全整除的最下面一行的子控件宽度
            for iCtrl := iColCount * (iRowCount-1) to AFP.ControlCount - 1 do begin
                oCtrl       := AFP.Controls[iCtrl];

                //
                oCtrl.Width             := Abs(iMinW);
                oCtrl.AlignWithMargins  := True;
                oCtrl.Margins.Left      := (iLastW - Abs(iMinW)) div 2;
                oCtrl.Margins.Right     := iLastW - oCtrl.Margins.Left - abs(iMinW);
            end;
        end else begin
            //设置每个子控件宽度
            for iCtrl := 0 to AFP.ControlCount - 1 do begin
                oCtrl       := AFP.Controls[iCtrl];

                //取到最后一个可视化Ctrl, 以设置上边距，防止遮挡
                if oCtrl.Visible then begin
                    oLastVCtrl  := oCtrl;
                end;

                //每行的最后一个单独处理。 因为如果正好宽度相等会挤到下一行
                if (iCtrl mod iColCount) = iColCount - 1 then begin
                    //此处最后-1是为了防止被挤到下一行
                    iLastWidth  := AFP.Width - (iColCount - 1) * iCtrlW - 1;
                    //
                    oCtrl.Width             := Abs(iMinW);
                    oCtrl.AlignWithMargins  := True;
                    //oCtrl.Margins.Top       := 10;
                    //oCtrl.Margins.Bottom    := 0;
                    oCtrl.Margins.Left      := (iLastWidth - Abs(iMinW)) div 2;
                    oCtrl.Margins.Right     := iLastWidth - oCtrl.Margins.Left - abs(iMinW);
                end else begin
                    //
                    oCtrl.Width             := Abs(iMinW);
                    oCtrl.AlignWithMargins  := True;
                    //oCtrl.Margins.Top       := 10;
                    //oCtrl.Margins.Bottom    := 0;
                    oCtrl.Margins.Left      := (iCtrlW - Abs(iMinW)) div 2;
                    oCtrl.Margins.Right     := iCtrlW - oCtrl.Margins.Left - abs(iMinW);
                end;


            end;
            //最后一个设置Margins.Bottom，以保证下部空白
            oLastVCtrl.Margins.Bottom    := Max(oCtrl.Margins.Bottom,10);

        end;
    end;
    //
    AFP.AutoSize    := True;
    AFP.AutoSize    := bOldAuto;
end;



//==================================================================================================

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
begin
     Result    := '[]';
end;



//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData    : Variant;
begin
    with TFlowPanel(ACtrl) do begin
        //
        joData    := _Json(AData);

        if joData.e = 'onclick' then begin
            TFlowPanel(ACtrl).OnClick(TFlowPanel(ACtrl));
        end else if joData.e = 'onenter' then begin
            TFlowPanel(ACtrl).OnEnter(TFlowPanel(ACtrl));
        end else if joData.e = 'onexit' then begin
            TFlowPanel(ACtrl).OnExit(TFlowPanel(ACtrl));
        end;
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode     : string;
    joHint    : Variant;
    joRes     : Variant;
    sEnter    : String;
    sExit     : String;
    sClick    : string;
begin
    //
    dwRealign(TFlowPanel(ACtrl));

    //
    with TFlowPanel(ACtrl) do begin
        //
        BevelOuter  := bvNone;
        BevelKind   := bkNone;
        BevelInner  := bvNone;
        BorderStyle := bsNone;

        //===============================================================

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //进入事件代码--------------------------------------------------------
        sEnter  := '';
        if joHint.Exists('onenter') then begin
            sEnter  := String(joHint.onenter);
        end;
        if sEnter='' then begin
            if Assigned(OnEnter) then begin
                 sEnter    := Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]);
            end else begin

            end;
        end else begin
            if Assigned(OnEnter) then begin
                 sEnter    := Format(_DWEVENTPlus,['mouseenter.native',sEnter,Name,'0','onenter',TForm(Owner).Handle])
            end else begin
                 sEnter    := ' @mouseenter.native="'+sEnter+'"';
            end;
        end;


        //退出事件代码--------------------------------------------------------
        sExit  := '';
        if joHint.Exists('onexit') then begin
            sExit  := String(joHint.onexit);
        end;
        if sExit='' then begin
            if Assigned(OnExit) then begin
                 sExit    := Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]);
            end else begin

            end;
        end else begin
            if Assigned(OnExit) then begin
                 sExit    := Format(_DWEVENTPlus,['mouseleave.native',sExit,Name,'0','onexit',TForm(Owner).Handle])
            end else begin
                 sExit    := ' @mouseleave.native="'+sExit+'"';
            end;
        end;

        //单击事件代码--------------------------------------------------------
        sClick    := '';
        if joHint.Exists('onclick') then begin
            sClick := String(joHint.onclick);
        end;
        //
        if sClick='' then begin
            if Assigned(OnClick) then begin
                 sClick    := Format(_DWEVENT,['click.native',Name,'0','onclick',TForm(Owner).Handle]);
            end else begin

            end;
        end else begin
            if Assigned(OnClick) then begin
                 sClick    := Format(_DWEVENTPlus,['click.native',sClick,Name,'0','onclick',TForm(Owner).Handle])
            end else begin
                 sClick    := ' @click.native="'+sClick+'"';
            end;
        end;


        //
        sCode   := '<el-main'
                +' id="'+dwFullName(Actrl)+'"'
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                //+dwGetHintValue(joHint,'type','type',' type="default"')
                //+dwGetHintValue(joHint,'icon','icon','')
                +' :style="{'
                    +'backgroundColor:'+dwFullName(Actrl)+'__col,'
                    //Font
                    +'color:'+dwFullName(Actrl)+'__fcl,'
                    +'''font-size'':'+dwFullName(Actrl)+'__fsz,'
                    +'''font-family'':'+dwFullName(Actrl)+'__ffm,'
                    +'''font-weight'':'+dwFullName(Actrl)+'__fwg,'
                    +'''font-style'':'+dwFullName(Actrl)+'__fsl,'
                    +'''text-decoration'':'+dwFullName(Actrl)+'__ftd,'

                    +'transform:''rotateZ({'+dwFullName(Actrl)+'__rtz}deg)'','
                    +'left:'+dwFullName(Actrl)+'__lef,top:'+dwFullName(Actrl)+'__top,width:'+dwFullName(Actrl)+'__wid,height:'+dwFullName(Actrl)+'__hei}"'
                    //+' style="position:'+dwIIF(Parent.ControlCount=1,'relative','absolute')+';overflow:hidden;'
                    +' style="position:'+dwIIF((Parent.ControlCount=1)and(Parent.ClassName='TScrollBox'),'relative','absolute')+';overflow:hidden;'
                    +dwIIF(BorderStyle=bsSingle,'border-radius: 2px;box-shadow: 0 2px 4px rgba(0, 0, 0, .12), 0 0 6px rgba(0, 0, 0, .04);box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);','')
                    +dwGetHintStyle(joHint,'radius','border-radius','')   //border-radius
                    +dwGetDWStyle(joHint)
                +'"' //style 封闭
                +sClick
                +sEnter
                +sExit
                +'>';
        //添加到返回值数据
        joRes.Add(sCode);
        //
        Result    := (joRes);

    end;
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
    sCode     : String;
begin
    with TFlowPanel(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //生成返回值数组
        joRes.Add('</el-main>');
        //
        Result    := (joRes);
    end;
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
    joHint    : Variant;
begin
    //
    dwRealign(TFlowPanel(ACtrl));

    with TFlowPanel(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TFlowPanel(ACtrl) do begin
            joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
            joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
            joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
            joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
            //
            joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
            joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(Enabled,'false,','true,'));
            //
            if TFlowPanel(ACtrl).Color = clNone then begin
                joRes.Add(dwFullName(Actrl)+'__col:"rgba(0,0,0,0)",');
            end else begin
                joRes.Add(dwFullName(Actrl)+'__col:"'+dwColor(TPanel(ACtrl).Color)+'",');
            end;
            //
            joRes.Add(dwFullName(Actrl)+'__rtz:30,');
            //
            joRes.Add(dwFullName(Actrl)+'__fcl:"'+dwColor(Font.Color)+'",');
            joRes.Add(dwFullName(Actrl)+'__fsz:"'+IntToStr(Font.size+3)+'px",');
            joRes.Add(dwFullName(Actrl)+'__ffm:"'+Font.Name+'",');
            joRes.Add(dwFullName(Actrl)+'__fwg:"'+_GetFontWeight(Font)+'",');
            joRes.Add(dwFullName(Actrl)+'__fsl:"'+_GetFontStyle(Font)+'",');
            joRes.Add(dwFullName(Actrl)+'__ftd:"'+_GetTextDecoration(Font)+'",');
        end;
        //
        Result    := (joRes);
    end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes   : Variant;
    joHint  : Variant;
begin
    //
    dwRealign(TFlowPanel(ACtrl));

    with TFlowPanel(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TFlowPanel(ACtrl) do begin
            joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
            //
            joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));
            joRes.Add('this.'+dwFullName(Actrl)+'__dis='+dwIIF(Enabled,'false;','true;'));
            //
            if TFlowPanel(ACtrl).Color = clNone then begin
                joRes.Add('this.'+dwFullName(Actrl)+'__col="rgba(0,0,0,0)";');
            end else begin
                joRes.Add('this.'+dwFullName(Actrl)+'__col="'+dwColor(TPanel(ACtrl).Color)+'";');
            end;
            //
            joRes.Add('this.'+dwFullName(Actrl)+'__fcl="'+dwColor(Font.Color)+'";');
            joRes.Add('this.'+dwFullName(Actrl)+'__fsz="'+IntToStr(Font.size+3)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__ffm="'+Font.Name+'";');
            joRes.Add('this.'+dwFullName(Actrl)+'__fwg="'+_GetFontWeight(Font)+'";');
            joRes.Add('this.'+dwFullName(Actrl)+'__fsl="'+_GetFontStyle(Font)+'";');
            joRes.Add('this.'+dwFullName(Actrl)+'__ftd="'+_GetTextDecoration(Font)+'";');
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
 
