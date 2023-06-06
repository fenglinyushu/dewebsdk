library dwTCalendar;
{
用于支持日历组件
}

uses
     ShareMem,      //必须添加

     //
     dwCtrlBase,    //一些基础函数

     //
     SynCommons,    //mormot用于解析JSON的单元

     //
     Math,
     Messages,  Graphics,Vcl.Samples.Calendar,
     SysUtils,DateUtils,ComCtrls, ExtCtrls,
     Classes,Grids,
     Dialogs,
     StdCtrls,
     Windows,
     Controls,
     Forms;

const
    _WEEKNAME : array[0..6] of String =('周日','周一','周二','周三','周四','周五','周六');
    //_WEEKNAME : array[0..6] of String =('Sun','Mon','Tue','Wed','Thu','Fri','Sat');

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

//本函数把HINT保存的日程信息，生成拟在界面上显示的JSON数据
function _GetSchedules(AHint:Variant;ACalFirst:TDate;ARowH,AColW:Integer):String;
var
    iY,iM,iD    : Word;         //年月日
    iLast       : Integer;      //当前日程持续天数
    iWeek       : Word;         //星期N
    iSc         : Integer;      //日程组循环变量
    iBack       : Integer;      //用于回溯，检查重叠的变量
    iTopPlus    : Integer;      //用于计算同一天有多个日程，避免重叠的变量
    iDays       : Integer;      //天数
    //
    dtSc        : TDate;
    dtBack      : TDate;        //用于回溯，检查重叠的日期变量
    //
    joScs       : Variant;      //日程组
    joSc        : Variant;      //日程
    joRes       : Variant;      //
    joBack      : Variant;
    joItem      : Variant;
begin
    //创建返回用的JSON数组对象
    joRes   := _json('[]');

    //如果有日程信息
    if AHint.Exists('schedule') then begin
        //
        joScs   := AHint.schedule;
        //
        for iSc := 0 to joScs._Count-1 do begin
            //得到具体日程JSON对象
            joSc    := joScs._(iSc);
            if not joSc.Exists('topplus') then begin
                joSc.topplus   := 0;
            end;
            //得到年月日
            iY  := joSc.year;
            iM  := joSc.month;
            iD  := joSc.day;
            //转换为TDate
            dtSc    := EncodeDate(iY,iM,iD);
            //检查当前日期中有几个前面的日程，主要用于计算top,以避免重叠.前提是日程按日期先后排列
            iTopPlus := 0;
            for iBack := iSc - 1 downto 0 do begin
                joBack   := joScs._(iBack);
                //得到年月日
                iY      := joBack.year;
                iM      := joBack.month;
                iD      := joBack.day;
                iLast   := joBack.last;
                //转换为TDate
                dtBack  := EncodeDate(iY,iM,iD);
                if (dtBack >= dtSc ) or (dtSc - dtBack < iLast) then begin
                    iTopPlus        := joBack.topplus;
                    iTopPlus        := iTopPlus + 1;
                    joSc.topplus    := iTopPlus;
                    //
                    break;
                end;
            end;
            //判断当前是否在本日历范围内
            iDays   := Trunc(dtSc - ACalFirst);
            if (iDays >= 0) and (iDays < 42) then begin
                joItem         := _JSON('{}');
                //
                joItem.left    := IntToStr((iDays mod 7) * AColW + 2)+'px';

                //说明：30为标题栏高度，25为当前日子的高度，接下来是星期数的高度，
                //      最后iExists * 20是当前日子中有多个日程影响的高度
                joItem.top     := IntToStr( 30 +  25 + (iDays div 7) * ARowH  + iTopPlus * 20)+'px';
                joItem.color   := joSc.color;
                joItem.caption := joSc.caption;

                //得到当前星期N，以计算换行显示
                iWeek   := DayOfWeek(dtSc)-1;
                joItem.width   := IntToStr(Min(joSc.last,7-iWeek)*AColW-8)+'px';
                if joSc.last <= 7-iWeek then begin
                    joItem.radius   := '2px';
                end else begin
                    joItem.radius   := '2px 0 0 2px';
                end;
                //
                joRes.Add(joItem);

                //如果需要换行显示
                iLast   := joSc.last - ( 7 - iWeek );
                dtSc    := dtSc + ( 7 - iWeek );
                while iLast >0 do begin
                    joItem         := _JSON('{}');
                    //
                    iDays           := Trunc(dtSc - ACalFirst);
                    joItem.left    := IntToStr((iDays mod 7) * AColW + 2)+'px';

                    //说明：30为标题栏高度，25为当前日子的高度，接下来是星期数的高度，
                    //      最后iExists * 20是当前日子中有多个日程影响的高度
                    joItem.top     := IntToStr( 30 +  25 + (iDays div 7) * ARowH + iTopPlus * 20)+'px';
                    joItem.color   := joSc.color;
                    joItem.caption := '';//joSc.caption;
                    //如果已完成，则后端显示圆角，前端直角；未完成，全部直角
                    if ilast <= 7-iWeek then begin
                        joItem.radius   := '0 2px 2px 0';
                    end else begin
                        joItem.radius   := '0';
                    end;

                    //得到当前星期N，以计算换行显示
                    iWeek   := DayOfWeek(dtSc)-1;
                    joItem.width   := IntToStr(Min(iLast,7-iWeek)*AColW-8)+'px';
                    //
                    joRes.Add(joItem);

                    //
                    iLast   := iLast - ( 7 - iWeek);
                end;
            end;
        end;
    end;
    //写ID
    for iSc := 0 to joRes._Count-1 do begin
        joRes._(iSc).id := iSc+1;
    end;
    //
    Result  := joRes;
end;


//--------------------以上为辅助函数----------------------------------------------------------------


//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    joRes   : Variant;
    sCode   : string;
    iRowH   : Integer;
    iColW   : Integer;
begin
    //
    with TCalendar(ACtrl) do begin
        iColW   := Width div 7;
        iRowH   := (Height-60) div 6;

        //生成返回值数组
        joRes    := _Json('[]');

		sCode   := '<style>'
				+'.dwcalendartitle{'
					+'position:absolute;'
					+'text-align:center;'
					+'border-right:solid 1px #dddddd;'
					//+'border-bottom:solid 1px #dddddd;'
					+'width:'+IntToStr(iColW-1)+'px;'
					+'height:30px;'
					+'line-height:30px;'
				+'}'
				+'.dwcalendar{'
					+'position:absolute;'
					+'border-right:solid 1px #dddddd;'
					+'border-top:solid 1px #dddddd;'
					+'text-align:right;'
					+'width:'+IntToStr(iColW-4)+'px;'
					+'height:'+IntToStr(iRowH-1)+'px;'
                    +'padding-right:3px;'
				+'}'
			+'</style>';
        //引入对应的库
        //joRes.Add(sCode);

        //
        Result    := joRes;
    end;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
    joData  : Variant;
    dtCurr  : TDate;
    iY,iM   : Word;
    iD      : Word;
    //
    sValue  : string;
begin

    //
    with TCalendar(ACtrl) do begin
        //
        joData    := _Json(AData);
        if joData.e = 'onclick' then begin
            sValue  := joData.v;
            //
            Year    := StrToIntDef(Copy(sValue,1,4),2000);
            Month   := StrToIntDef(Copy(sValue,6,2),1);
            Day     := StrToIntDef(Copy(sValue,9,2),01);

            //执行事件
            if Assigned(OnClick) then begin
                OnClick(TCalendar(ACtrl));
            end;
        end else if joData.e = 'onprev' then begin
            dtCurr  := EncodeDate(Year,Month,Day);
            dtCurr    := IncMonth(dtCurr,-1);
            DecodeDate(dtCurr,iY,iM,iD);
            Year    := iY;
            Month   := iM;
            Day     := iD;
        end else if joData.e = 'onnext' then begin
            dtCurr  := EncodeDate(Year,Month,Day);
            dtCurr    := IncMonth(dtCurr,1);
            DecodeDate(dtCurr,iY,iM,iD);
            Year    := iY;
            Month   := iM;
            Day     := iD;
        end else if joData.e = 'ontoday' then begin
            DecodeDate(Now,iY,iM,iD);
            Year    := iY;
            Month   := iM;
            Day     := iD;
        end else if joData.e = 'onenddock' then begin
             //执行事件
             if Assigned(TCalendar(ACtrl).OnEndDock) then begin
                  TCalendar(ACtrl).OnEndDock(TCalendar(ACtrl),nil,joData.v,0);
             end;
        end;
    end;

end;



//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    //
    I           : Integer;
    iWeek       : Integer;
    iW,iT       : Integer;
    iRowH       : Integer;
    iColW       : Integer;
    //
    sCode       : string;
    sFull       : string;
    //
    joHint      : Variant;
    joRes       : Variant;
    joSchedule  : Variant;

    //
    dtCurr      : TDate;
    dtFirstDay  : TDate;
    dtCalFirst  : TDate;    //当前日历上的第一天（左上角的第一个日期）
    dtCalLast   : TDate;    //当前日历上的最后一天（右下角的最一个日期）
    dtCal       : TDate;    //用于显示日历的临时变量
    dtStart     : TDate;    //
    dtEnd       : TDate;    //
    iMonth,iDay : Word;
    iYear       : Word;
    iFirstWeek  : Integer;

begin
    //
    sFull   := dwFullName(ACtrl);

    //
    with TCalendar(ACtrl) do begin
        iRowH   := (Height-60) div 6;   //按钮和标题各30
        iColW   := Width div 7;

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //
        dtCurr  := EncodeDate(Year,Month,Day);
        DecodeDate(dtCurr,iYear,iMonth,iDay);

        //得到当月的第一天
        dtFirstDay  := EncodeDate(iYear,iMonth,1);

        //得到当月第一天是星期几。 DayOfWeek：1 = 星期天  2 = 星期一  3 = 星期二 。。。。  7 = 星期六
        iFirstWeek  := DayOfWeek(dtFirstDay)-1;

        //得到日历上的第一天，最左上角的日期
        dtCalFirst  := dtFirstDay - iFirstWeek;

        //添加一个外框------------------------------------------------------------------------------
        sCode   := '<div'
                +' id="'+sFull+'"'
                +dwVisible(TControl(ACtrl))                            //用于控制可见性Visible
                +dwGetDWAttr(joHint)                        //dwAttr
                +' :style="{'
                //+'backgroundColor:'+sFull+'__col,'
                +'color:'+sFull+'__fcl,'
                +'''font-size'':'+sFull+'__fsz,'
                +'''font-family'':'+sFull+'__ffm,'
                +'''font-weight'':'+sFull+'__fwg,'
                +'''font-style'':'+sFull+'__fsl,'
                +'''text-decoration'':'+sFull+'__ftd,'
                +'left:'+sFull+'__lef,'
                +'top:'+sFull+'__top,'
                +'width:'+sFull+'__wid,'
                +'height:'+sFull+'__hei'
                +'}"'
                //
                +' style="position:absolute;'
                //+'overflow:hidden' // 封闭style
                +dwGetDWStyle(joHint)
                +'"' // 封闭style
                +'>';
        //添加到返回值数据
        joRes.Add(sCode);

        //<添加功能按钮，包括上一月，下一月，今天，日期显示等--------------------------------------
        //功能按钮区外框
        sCode   := '    <div'
                +' style="position:absolute;'
                    +'left:0;'
                    +'top:0;'
                    +'right:0;'
                    //+'padding:2px;'
                    +'width:100%;'
                    +'height:'+IntToStr(Height-30-iRowH*6)+'px;'
                +'"' // 封闭style
                +'>';
        //添加到返回值数据
        joRes.Add(sCode);
        //上一月
        sCode   := '<el-button type="default" icon="el-icon-arrow-left" '+Format(_DWEVENT,['click',Name,'0','onprev',TForm(Owner).Handle])+'></el-button>';
        joRes.Add(sCode);
        //下一月
        sCode   := '<el-button type="default"><i class="el-icon-arrow-right el-icon--right" '+Format(_DWEVENT,['click',Name,'0','onnext',TForm(Owner).Handle])+'></i></el-button>';
        joRes.Add(sCode);
        //今天
        sCode   := '<el-button type="default" style="float:right;" '+Format(_DWEVENT,['click',Name,'0','ontoday',TForm(Owner).Handle])+'>today</el-button>';
        joRes.Add(sCode);
        //当前月份
        sCode   := '<el-button type="text"'
                +' :style="{'+
                    'color:'+sFull+'__fcl,'+
                    'width:'+sFull+'__twd'+     //twd : title width
                '}"'
                +' style="'+
                    'positon:absolute;'+
                    'top:0;'+
                    'left:80px;'+
                    'font-size:120%;'+
                '">'+
                '{{'+sFull+'__cur}}'+
                '</el-button>';
        joRes.Add(sCode);
        //
        joRes.Add('    </div>');
        //>
        //为主显示区域添加一个框--------------------------------------------------------------------
        sCode   := '    <div'
                +' :style="{'
                    +'backgroundColor:'+sFull+'__col,'
                    //+'width:'+sFull+'__wid,'
                    +'height:'+sFull+'__he2'
                +'}"'
                //
                +' style="position:absolute;'
                +'left:0;'
                +'top:'+IntToStr(Height - iRowH*6-30)+'px;'
                +'width:100%;'
                +'border:solid 1px #dddddd;'
                +'border-radius:3px;'
                +'overflow:hidden' // 封闭style
                +'"' // 封闭style
                +'>';
        //添加到返回值数据
        joRes.Add(sCode);

        //<星期N标识,所有top=0,left依次排开
        iW  := Width div 7;
        for I:=0 to 6 do begin
            sCode   := '<div' +
                    ' class="dwcalendartitle"' +
                    ' :style={'+
                        'left:'+sFull+'__hl' + IntToStr(I) + '' +    //hl0 : header left
                    '}'+
                    ' style="' +
                        'position:absolute;'+
                    '"' +// 封闭style
                    '>' +
                    _WEEKNAME[I] +
                    '</div>';
            //添加到返回值数据
            joRes.Add(sCode);
        end;
{
        sCode   := '        <div'
                +' class="dwcalendartitle"'
                +' style="'
                +'position:absolute;'
                +'border-right:0;'
                +'left:'+IntToStr(iW*6)+'px;'
                +'width:'+IntToStr(Width-iW*6)+'px;'
                +'"' // 封闭style
                +'>'
                +_WEEKNAME[I]
                +'</div>';
}
        //添加到返回值数据
        joRes.Add(sCode);
        //>

        //<显示每日历-------------------------------------------------------------------------------
        sCode   := '        <div class="dwcalendar" v-for="(item,index) in '+lowerCase(sFull)+'__dns"'
                +' :key="index"'
                +' :style="{top:item.top,left:item.lef,width:item.wid,color:item.col}"'
                +' style="position:absolute;"'
                +'>{{item.day}}</div>';
        joRes.Add(sCode);

        //<显示日程---------------------------------------------------------------------------------
        sCode   := '        <div v-for="(item,index) in '+lowerCase(sFull)+'__scs"'
                //+' :key="index"'
                +' :style="{top:item.top,left:item.left,backgroundColor:item.color,width:item.width,''border-radius'':item.radius}"'
                +' style="position:absolute;font-size:12px;color:#d0d0d0;height:18px;padding-left:5px;" >'
                +'{{item.caption}}'
                +'</div>';

        joRes.Add(sCode);
(*

        //
        sCode   := '<el-calendar'
                +' v-model="'+sFull+'__val"'
                +'>'
                    +'<template  slot="dateCell"  slot-scope="{date, data}">'
                        +'<div @click="'+sFull+'__chg(data)">'
                            +'<el-row>'
                                +'<el-col style="text-align:center">'
                                    +'<div class="calendar-day">{{ data.day.split("-").slice(2).join("-") }}'
                                    +'</div>'
                                +'</el-col>'
                            +'</el-row>'
                        +'</div>'
                    +'</template>'
                +'</el-calendar>';
        joRes.Add(sCode);
*)
        //
        Result    := (joRes);
    end;
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
begin
    //
    with TCalendar(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');

        //
        joRes.Add('    </div>');
        //
        joRes.Add('</div>');
        //
        Result    := (joRes);
    end;
end;


//取得Data
function dwGetData(ACtrl:TControl):string;StdCall;
var
    I,J,iWeek   : Integer;
    iYear,iDay  : Word;
    iMonth      : Word;
    iLast       : Integer;
    iDays       : Integer;
    iExists     : Integer;
    iFirstWeek  : Integer;
    iRowH,iColW : Integer;
    iT,iID      : Integer;
    //
    bWrap       : Boolean;  //当前日程跨周六和周日的情况
    //
    sCode       : string;
    //
    dtCurr      : TDate;
    dtFirstDay  : TDate;
    dtLastDay   : TDate;
    dtCalFirst  : TDate;
    dtCal       : TDate;
    dtTmp       : TDate;
    //
    joRes       : Variant;
    joHint      : Variant;
    joDays      : Variant;
    joDay       : Variant;
    joScs       : Variant;
    joSchedule  : Variant;
    joTmp       : Variant;
    joResScs    : Variant;  //用于结果的日程组
    joResSc     : Variant;  //用于结果的日程
begin
    //生成返回值数组
    joRes    := _Json('[]');
    with TCalendar(ACtrl) do begin
        iRowH   := (Height-60) div 6;   //按钮和标题各30
        iColW   := Width div 7;
        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //
        dtCurr  := EncodeDate(Year,Month,Day);
        //
        joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(dwFullName(Actrl)+'__twd:"'+IntToStr(Width-160)+'px",');
        //
        joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(Enabled,'false,','true,'));
        //
        joRes.Add(dwFullName(Actrl)+'__val:"'+FormatDateTime('YYYY-MM-DD',dtCurr)+'",');

        //
        joRes.Add(dwFullName(Actrl)+'__col:"'+dwColor(TLabel(ACtrl).Color)+'",');
        //主显区高度
        joRes.Add(dwFullName(Actrl)+'__he2:"'+IntToStr(30+iRowH*6)+'px",');
        //当前月份
        joRes.Add(dwFullName(Actrl)+'__cur:"'+FormatDateTime('YYYY MM',dtCurr)+'",');
        //
        joRes.Add(dwFullName(Actrl)+'__fcl:"'+dwColor(Font.Color)+'",');
        joRes.Add(dwFullName(Actrl)+'__fsz:"'+IntToStr(Font.size+3)+'px",');
        joRes.Add(dwFullName(Actrl)+'__ffm:"Muli,sans-serif;",');//+Font.Name+'",');
        joRes.Add(dwFullName(Actrl)+'__fwg:"'+_GetFontWeight(Font)+'",');
        joRes.Add(dwFullName(Actrl)+'__fsl:"'+_GetFontStyle(Font)+'",');
        joRes.Add(dwFullName(Actrl)+'__ftd:"'+_GetTextDecoration(Font)+'",');

        //<生成日期显示数组-------------------------------------------------------------------------
        //根据年月月得到当前Date
        dtCurr  := EncodeDate(Year,Month,Day);
        //分解（以前代码）
        DecodeDate(dtCurr,iYear,iMonth,iDay);

        //得到当月的第一天
        dtFirstDay  := EncodeDate(iYear,iMonth,1);

        //得到当月第一天是星期几。 DayOfWeek：1 = 星期天  2 = 星期一  3 = 星期二 。。。。  7 = 星期六
        iFirstWeek  := DayOfWeek(dtFirstDay)-1;

        //得到日历上的第一天，最左上角的日期
        dtCalFirst  := dtFirstDay - iFirstWeek;
        dtCal       := dtCalFirst;

        //
        for I := 0 to 6 do begin
            joRes.Add(dwFullName(Actrl)+'__hl'+IntToStr(I)+':"'+IntToStr(5 + I * iColW)+'px",');
        end;

        joDays  := _json('[]');
        iT      := 30;
        iID     := 1;
        for iWeek := 0 to 5 do begin
            for I:=0 to 6 do begin
                joDay       := _json('{}');
                joDay.id    := iID;
                joDay.day   := DayOf(dtCal);
                joDay.top   := IntToStr(iT)+'px';
                joDay.lef   := IntToStr(I*iColW+5)+'px';
                if I = 6 then begin
                    joDay.wid   := IntToStr(Width - iColW*6-3)+'px';
                end else begin
                    joDay.wid   := IntToStr(iColW-4)+'px';
                end;
                if MonthOf(dtCal) = Month then begin
                    joDay.col   := dwColor(Font.Color);
                end else begin
                    joDay.col   := '#bbb';
                end;
                joDays.Add(joDay);
                Inc(iID);
                //
                dtCal   := dtCal + 1;
            end;
            //
            iT  := iT + iRowH;
        end;
        sCode   := lowerCase(dwFullName(Actrl))+'__dns:'+VariantSaveJSON(joDays) + ',' ;     //date names
        joRes.Add(sCode);
        //>

        //<生成日程JSON数组
        sCode   := lowerCase(dwFullName(Actrl))+'__scs:'+_GetSchedules(joHint,dtCalFirst,iRowH,iColW) + ',' ;     //date names
        joRes.Add(sCode);
        //>
    end;
    //
    Result    := joRes;
end;



//取得Method
function dwGetAction(ACtrl:TControl):string;StdCall;
var
    S           : string;
    sCode       : string;
    iRow,iCol   : Integer;
    joRes       : Variant;
    joHint      : Variant;
    joDays      : Variant;
    joDay       : Variant;
    dtCurr      : TDate;
    dtFirstDay  : TDate;
    dtCalFirst  : TDate;
    dtCal       : TDate;
    iYear,iDay  : Word;
    iMonth      : Word;
    I,iWeek     : Integer;
    iFirstWeek  : Integer;
    iRowH,iColW : Integer;
    iT,iID      : Integer;
begin
    //生成返回值数组
    joRes    := _Json('[]');
    with TCalendar(ACtrl) do begin
        iRowH   := (Height-60) div 6;   //按钮和标题各30
        iColW   := Width div 7;
        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //
        dtCurr  := EncodeDate(Year,Month,Day);
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px",');
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__twd="'+IntToStr(Width-160)+'px";');
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+dwFullName(Actrl)+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__val="'+FormatDateTime('YYYY-MM-DD',dtCurr)+'";');
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__col="'+dwColor(TLabel(ACtrl).Color)+'";');
        //主显区高度
        joRes.Add('this.'+dwFullName(Actrl)+'__he2="'+IntToStr(30+iRowH*6)+'px";');
        //当前月份
        joRes.Add('this.'+dwFullName(Actrl)+'__cur="'+FormatDateTime('YYYY MM',dtCurr)+'";');
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__fcl="'+dwColor(Font.Color)+'";');
        joRes.Add('this.'+dwFullName(Actrl)+'__fsz="'+IntToStr(Font.size+3)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__ffm="Muli,sans-serif;",');//+Font.Name+'",');
        joRes.Add('this.'+dwFullName(Actrl)+'__fwg="'+_GetFontWeight(Font)+'";');
        joRes.Add('this.'+dwFullName(Actrl)+'__fsl="'+_GetFontStyle(Font)+'";');
        joRes.Add('this.'+dwFullName(Actrl)+'__ftd="'+_GetTextDecoration(Font)+'";');

        //<生成日期显示数组-------------------------------------------------------------------------
        //
        dtCurr  := EncodeDate(Year,Month,Day);
        DecodeDate(dtCurr,iYear,iMonth,iDay);

        //得到当月的第一天
        dtFirstDay  := EncodeDate(iYear,iMonth,1);

        //得到当月第一天是星期几。 DayOfWeek：1 = 星期天  2 = 星期一  3 = 星期二 。。。。  7 = 星期六
        iFirstWeek  := DayOfWeek(dtFirstDay)-1;

        //得到日历上的第一天，最左上角的日期

        dtCalFirst  := dtFirstDay - iFirstWeek;
        dtCal       := dtCalFirst;

        //
        for I := 0 to 6 do begin
            joRes.Add('this.'+dwFullName(Actrl)+'__hl'+IntToStr(I)+'="'+IntToStr(5 + I * iColW)+'px";');
        end;

        joDays  := _json('[]');
        iT      := 30;
        iID     := 1;
        for iWeek := 0 to 5 do begin
            for I:=0 to 6 do begin
                joDay       := _json('{}');
                joDay.id    := iID;
                joDay.day   := DayOf(dtCal);
                joDay.top   := IntToStr(iT)+'px';
                joDay.lef   := IntToStr(I*iColW+5)+'px';
                if I = 6 then begin
                    joDay.wid   := IntToStr(Width - iColW*6-4)+'px';
                end else begin
                    joDay.wid   := IntToStr(iColW-4)+'px';
                end;
                if MonthOf(dtCal) = Month then begin
                    joDay.col   := dwColor(Font.Color);
                end else begin
                    joDay.col   := '#bbb';
                end;
                joDays.Add(joDay);
                Inc(iID);
                //
                dtCal   := dtCal + 1;
            end;
            //
            iT  := iT + iRowH;
        end;
        sCode   := 'this.'+lowerCase(dwFullName(Actrl))+'__dns='+VariantSaveJSON(joDays) + ';' ;     //date names
        joRes.Add(sCode);
        //>

        //<生成日程JSON数组
        sCode   := 'this.'+lowerCase(dwFullName(Actrl))+'__scs='+_GetSchedules(joHint,dtCalFirst,iRowH,iColW) + ';' ;     //date names
        joRes.Add(sCode);
        //>
    end;
    //
    Result    := joRes;
end;

function dwGetMethods(ACtrl:TControl):string;StdCall;
var
    //
    sCode   : string;
    //
    joRes   : Variant;
begin
    joRes   := _json('[]');


    with TCalendar(ACtrl) do begin
        sCode   := dwFullName(ACtrl)+'__chg(data){'
            //+'console.log(data.day);'
            +'this.'+dwFullName(ACtrl)+'__val=data.day;'
            +'this.dwevent(null,'''+dwFullName(ACtrl)+''',''this.'+dwFullName(ACtrl)+'__val'',''onclick'','''+IntToStr(TForm(Owner).Handle)+''');'
            +'},';
        //
        joRes.Add(sCode);
    end;

    //
    Result  := joRes;
end;


exports
     dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetMethods,
     dwGetData;

begin
end.
 
