library dwTDateTimePicker;

uses
     ShareMem,      //必须添加

     //
     dwCtrlBase,    //一些基础函数

     //
     SynCommons,    //mormot用于解析JSON的单元

     //
     SysUtils,DateUtils,ComCtrls, ExtCtrls,
     Classes,
     Dialogs,
     StdCtrls,
     Windows,
     Controls,
     Forms;

//--------------------------------------------------------------------------------------------------
const
    Convert: array[0..255] of Integer =
    (
     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
      0, 1, 2, 3, 4, 5, 6, 7, 8, 9,-1,-1,-1,-1,-1,-1,
     -1,10,11,12,13,14,15,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,10,11,12,13,14,15,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
     );



function PCharToIntDef(const S: PAnsichar; Len: Integer; def: Integer = 0): Integer;
var
  I: Integer;
  v: Integer;
begin
  Result := 0;
  for I := 0 to len-1 do begin
    V := Convert[ord(s[i])];
    if V<0 then begin
      Result := def;
      Exit;
    end;
    result := (result * 10) + V;
  end;
end;



function LocalTimeZoneBias: Integer;
{$IFDEF LINUX}
var
    TV: TTimeval;
    TZ: TTimezone;
begin
    gettimeofday(TV, TZ);
    Result := TZ.tz_minuteswest;
end;
{$ELSE}
var
    TimeZoneInformation: TTimeZoneInformation;
    Bias: Longint;
begin
    case GetTimeZoneInformation(TimeZoneInformation) of
        TIME_ZONE_ID_STANDARD: Bias := TimeZoneInformation.Bias + TimeZoneInformation.StandardBias;
        TIME_ZONE_ID_DAYLIGHT: Bias := TimeZoneInformation.Bias + ((TimeZoneInformation.DaylightBias div 60) * -100);
    else
        Bias := TimeZoneInformation.Bias;
    end;
    Result := Bias;
end;

{$ENDIF}

var
    DLocalTimeZoneBias: Double = -0.33333333;

function StrToMonth(AStr:String):Integer;
begin
    Result  := 1;
    if Astr = 'Jan' then begin
        Result  := 1;
    end else if AStr = 'Feb' then begin
        Result  := 2;
    end else if AStr = 'Mar' then begin
        Result  := 3;
    end else if AStr = 'Apr' then begin
        Result  := 4;
    end else if AStr = 'May' then begin
        Result  := 5;
    end else if AStr = 'Jun' then begin
        Result  := 6;
    end else if AStr = 'Jul' then begin
        Result  := 7;
    end else if AStr = 'Aug' then begin
        Result  := 8;
    end else if AStr = 'Sep' then begin
        Result  := 9;
    end else if AStr = 'Oct' then begin
        Result  := 10;
    end else if AStr = 'Nov' then begin
        Result  := 11;
    end else if AStr = 'Dec' then begin
        Result  := 12;
    end;
end;

function DateTimeToGMT(const DT: TDateTime): TDateTime; inline;
begin
    Result := DT + DLocalTimeZoneBias;
end;

function GMTToDateTime(const DT: TDateTime): TDateTime; inline;
begin
    Result := DT - DLocalTimeZoneBias;
end;

function DateTimeToGMTRFC822(const DateTime: TDateTime): string;
const
    WEEK: array[1..7] of string = ('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat');
    STR_ENGLISH_M: array[1..12] of string = ('Jan', 'Feb', 'Mar', 'Apr', 'May','Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
var
    wWeek, wYear, wMonth, wDay, wHour, wMin, wSec, wMilliSec: Word;
begin
    DecodeDateTime(DateTimeToGMT(DateTime), wYear, wMonth, wDay, wHour, wMin, wSec, wMilliSec);
    wWeek   := DayOfWeek(DateTimeToGMT(DateTime));
    Result  := Format('%s, %.2d %s %.4d %.2d:%.2d:%.2d GMT',[WEEK[wWeek], wDay, STR_ENGLISH_M[wMonth], wYear, wHour, wMin, wSec]);
end;



function GMTRFC822ToDateTime(const pSour: AnsiString): TDateTime;
    function GetMonthDig(const Value: PAnsiChar): Integer;
    const
        STR_ENGLISH_M: array[1..12] of PAnsiChar = ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
    begin
        for Result := Low(STR_ENGLISH_M) to High(STR_ENGLISH_M) do begin
            if StrLIComp(Value, STR_ENGLISH_M[Result], 3) = 0 then Exit;
        end;
        Result := 0;
    end;
var
    P1, P2, PMax: PAnsiChar;
    wDay, wMonth, wYear, wHour, wMinute, wSec: SmallInt;
begin
    Result := 0;
    if Length(pSour) < 25 then Exit;
    P1 := Pointer(pSour);
    P2 := P1;
    PMax := P1 + Length(pSour);
    while (P1 < PMax) and (P1^ <> ',') do Inc(P1); Inc(P1);
    if (P1^ <> #32) and (P1 - P2 < 4) then Exit;
    Inc(P1); P2 := P1;
    while (P1 < PMax) and (P1^ <> #32) do Inc(P1);
    if (P1^ <> #32) then Exit;
    wDay := PCharToIntDef(P2, P1 - P2);
    if wDay = 0 then Exit;
    Inc(P1); P2 := P1;
    while (P1 < PMax) and (P1^ <> #32) do Inc(P1);
    if (P1^ <> #32) and (P1 - P2 < 3) then Exit;
    wMonth := GetMonthDig(P2);
    Inc(P1); P2 := P1;
    while (P1 < PMax) and (P1^ <> #32) do Inc(P1);
    if (P1^ <> #32) then Exit;
    wYear := PCharToIntDef(P2, P1 - P2);
    if wYear = 0 then Exit;
    Inc(P1); P2 := P1;
    while (P1 < PMax) and (P1^ <> ':') do Inc(P1);
    if (P1^ <> ':') then Exit;
    wHour := PCharToIntDef(P2, P1 - P2);
    if wHour = 0 then Exit;
    Inc(P1); P2 := P1;

    while (P1 < PMax) and (P1^ <> ':') do Inc(P1);
    if (P1^ <> ':') then Exit;
    wMinute := PCharToIntDef(P2, P1 - P2);
    if wMinute = 0 then Exit;
    Inc(P1); P2 := P1;

    while (P1 < PMax) and (P1^ <> #32) do Inc(P1);
    if (P1^ <> #32) then Exit;
    wSec := PCharToIntDef(P2, P1 - P2);
    if wSec = 0 then Exit;

    Result := GMTToDateTime(EnCodeDateTime(wYear, wMonth, wDay, wHour, wMinute, wSec, 0));
end;
//--------------------------------------------------------------------------------------------------

//当前控件需要引入的第三方JS/CSS ,一般为不做改动,目前仅在TChart使用时需要用到
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
     joData    : Variant;
     iYear     : Word;
     iMonth    : Word;
     iDay      : Word;
     //
     sDate     : string;
     //
     dtTmp     : TDateTime;
begin
    with TDateTimePicker(ACtrl) do begin
        //
        joData    := _Json(AData);

        if joData.e = 'onchange' then begin
            //保存事件
            OnExit    := OnChange;
            //清空事件,以防止自动执行
            OnChange  := nil;
            //更新值
            //针对D10.4.2以前无 dtkDateTime 的处理 ,标识为：日期+时间型
            {$IFDEF VER340}
                //ShowHint    := True;
                if ShowHint then begin
            {$ELSE}
                if  Kind = dtkDateTime then begin
            {$ENDIF}
                sDate     := dwUnescape(joData.v);  //Mon Feb 19 2018 06:00:00 GMT+0800 (中国标准时间)
                iYear     := StrToIntDef(Copy(sDate,12,4),1900);
                iMonth    := StrToMonth(Copy(sDate,5,3));
                iDay      := StrToIntDef(Copy(sDate,9,2),1);

                TDateTimePicker(ACtrl).Date := EncodeDate(iYear,iMonth,iDay);//StrToDateDef(joData.v,Now);
                TDateTimePicker(ACtrl).Time := StrToTimeDef(Copy(sDate,17,8),Now);
            end else if Kind = dtkDate then begin
                sDate     := joData.v;
                iYear     := StrToIntDef(Copy(sDate,1,4),1900);
                iMonth    := StrToIntDef(Copy(sDate,6,2),1);
                iDay      := StrToIntDef(Copy(sDate,9,2),1);

                TDateTimePicker(ACtrl).Date    :=  EncodeDate(iYear,iMonth,iDay);//StrToDateDef(joData.v,Now);
            end else begin
                sDate     := dwUnescape(joData.v);  //Mon Feb 19 2018 06:00:00 GMT+0800 (中国标准时间)
                TDateTimePicker(ACtrl).Time := StrToTimeDef(Copy(sDate,17,8),Now);
                //TDateTimePicker(ACtrl).Time    := StrToTimeDef(StringReplace(joData.v,'%3A',':',[rfReplaceAll])+':00',Now);
            end;
            //恢复事件
            TDateTimePicker(ACtrl).OnChange  := TDateTimePicker(ACtrl).OnExit;

            //执行事件
            if Assigned(TDateTimePicker(ACtrl).OnChange) then begin
                TDateTimePicker(ACtrl).OnChange(TDateTimePicker(ACtrl));
            end;

            //清空OnExit事件
            TDateTimePicker(ACtrl).OnExit  := nil;
        end else if joData.e = 'onenter' then begin
        end;
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
    with TDateTimePicker(ACtrl) do begin
        //生成字符串
        {$IFDEF VER340}
            if ShowHint then begin
        {$ELSE}
            if ShowHint or (kind = dtkDateTime) then begin
        {$ENDIF}
            //日期时间  <el-date-picker v-model="value1" type="datetime" placeholder="选择日期时间"> </el-date-picker>
            sCode   := '<el-date-picker'
                    +' v-model="'+sFull+'__val"'
                    +' type="datetime"'
                    +' format="yyyy-MM-dd HH:mm:ss"'
                    //+' value-format="yyyy-MM-dd hh:mm:ss"'
                    +' id="'+sFull+'"'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +dwGetDWAttr(joHint)
                    //Style
                    +dwLTWH(TControl(ACtrl))
                        +dwGetDWStyle(joHint)
                    +'"' //style 封闭
                    +SysUtils.Format(_DWEVENT,['change',Name,'this.'+sFull+'__val','onchange',TForm(Owner).Handle])
                    +'>';
        end else if kind =  dtkDate then begin
            //日期  <el-date-picker v-model="value1"  type="date" placeholder="选择日期"></el-date-picker>
            sCode   := '<el-date-picker type="date" format="yyyy-MM-dd" value-format="yyyy-MM-dd"'
                    +' id="'+sFull+'"'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +' v-model="'+sFull+'__val"'
                    +dwGetDWAttr(joHint)
                    //Style
                    +dwLTWH(TControl(ACtrl))
                        +dwGetDWStyle(joHint)
                    +'"' //style 封闭
                    +SysUtils.Format(_DWEVENT,['change',Name,'this.'+sFull+'__val','onchange',TForm(Owner).Handle])
                    +'>';
        end else begin
            //时间
            sCode   := '<el-time-picker'
                    +' id="'+sFull+'"'
                    +' :picker-options="{selectableRange: ''00:00:00 - 23:59:59''}" '
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +' v-model="'+sFull+'__val"'
                    +dwGetDWAttr(joHint)
                    //Style
                    +dwLTWH(TControl(ACtrl))
                        +dwGetDWStyle(joHint)
                    +'"' //style 封闭
                    +SysUtils.Format(_DWEVENT,['change',Name,'this.'+sFull+'__val','onchange',TForm(Owner).Handle])
                    +'>';
        end;
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
    with TDateTimePicker(ACtrl) do begin
        {$IFDEF VER340}
            if ShowHint then begin
        {$ELSE}
            if ShowHint or (kind = dtkDateTime) then begin
        {$ENDIF}
            //日期时间  <el-date-picker v-model="value1" type="datetime" placeholder="选择日期时间"> </el-date-picker>
            joRes.Add('</el-date-picker>');          //此处需要和dwGetHead对应
        end else if Kind =  dtkDate then begin
            joRes.Add('</el-date-picker>');          //此处需要和dwGetHead对应
        end else begin
            joRes.Add('</el-time-picker>');          //此处需要和dwGetHead对应
        end;
     end;
     //
     Result    := (joRes);
end;

//取得Data消息
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    sFull   : string;
    joRes   : Variant;
begin
    //生成返回值数组
    joRes    := _Json('[]');

    //
    sFull   := dwFullName(ACtrl);

    //
    with TDateTimePicker(ACtrl) do begin
        joRes.Add(sFull+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(sFull+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(sFull+'__dis:'+dwIIF(Enabled,'false,','true,'));
        //
        {$IFDEF VER340}
            if ShowHint then begin
        {$ELSE}
            if ShowHint or (kind = dtkDateTime) then begin
        {$ENDIF}
            if Trunc(Date) = StrToDateDef('9999-09-09',Now) then begin
                joRes.Add(sFull+'__val:"",');
            end else if Trunc(Date) = StrToDateDef('3000-01-01',Now) then begin
                joRes.Add(sFull+'__val:"",');
            end else begin
                joRes.Add(sFull+'__val:"'+DateTimeToGMTRFC822(DateTime)+'",');
            end;
        end else if kind = dtkDate then begin
            if Trunc(Date) = StrToDateDef('9999-09-09',Now) then begin
                joRes.Add(sFull+'__val:"",');
            end else if Trunc(Date) = StrToDateDef('3000-01-01',Now) then begin
                joRes.Add(sFull+'__val:"",');
            end else begin
                joRes.Add(sFull+'__val:"'+FormatDateTime('yyyy-MM-dd',Date)+'",');
            end;
        end else begin
            joRes.Add(sFull+'__val:"'+DateTimeToGMTRFC822(DateTime)+'",');//+FormatDateTime('hh:mm:ss',Time)+'",');
        end;
    end;
    //
    Result    := (joRes);
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    sFull   : string;
    joRes     : Variant;
    sDT       : String;
begin
    //生成返回值数组
    joRes    := _Json('[]');

    //
    sFull   := dwFullName(ACtrl);

    //
    with TDateTimePicker(ACtrl) do begin
        joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        {$IFDEF VER340}
            if ShowHint then begin
        {$ELSE}
            if ShowHint or (kind = dtkDateTime) then begin
        {$ENDIF}
            if Trunc(Date) = 0 then begin
                joRes.Add('this.'+sFull+'__val="";');
            end else if Trunc(Date) = StrToDateDef('9999-09-09',Now) then begin
                joRes.Add('this.'+sFull+'__val="";');
            end else begin
                sDT     := DateTimeToStr(DateTime);
                sDt     := DateTimeToGMTRFC822(DateTime);
                joRes.Add('this.'+sFull+'__val="'+DateTimeToGMTRFC822(DateTime)+'";');
            end;
        end else if kind =  dtkDate then begin  //日期型
            if Trunc(Date) = 0 then begin
                joRes.Add('this.'+sFull+'__val="";');
            end else if Trunc(Date) = StrToDateDef('9999-09-09',Now) then begin
                joRes.Add('this.'+sFull+'__val="";');
            end else begin
                joRes.Add('this.'+sFull+'__val="'+FormatDateTime('YYYY-MM-dd',Date)+'";');
            end;
        end else begin  //时间型
            //joRes.Add('this.'+sFull+'__val="'+FormatDateTime('hh:mm:ss',Time)+'";');
            sDT:= DateTimeToStr(DateTime);
            sDt := DateTimeToGMTRFC822(DateTime);
            joRes.Add('this.'+sFull+'__val="'+DateTimeToGMTRFC822(DateTime)+'";');
        end;
    end;
    //
    Result    := (joRes);
end;


exports
     //dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetData;

begin
end.

