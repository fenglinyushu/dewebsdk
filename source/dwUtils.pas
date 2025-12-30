unit dwUtils;
{
    用于DWS的一些功能函数
}


interface

uses
    //
    dwVars,

    //第三方控件
    SynCommons,
    uSMBIOS,    //用于读UUID的单元
    //JsonDataObjects,
    //
    ADODB,
    HTTPApp,XpMan,
    //IdURI,
    //SynaCode,
    Winapi.WinSock,
    NB30,
    Generics.Collections, //用于TDictionary
    Math,
    DateUtils,
    TypInfo,
    Variants,
    Graphics,
    Dialogs,
    ComObj,    //用于scriptcontrol
    Windows, Messages, SysUtils, Classes, Controls, Forms,
    StdCtrls, ExtCtrls, StrUtils;

//得到FORM中各控件的关键信息
function  dwGetComponentInfos(AForm:TForm):String;

//取得硬件唯一ID
function dwGetUUID:String;

// 获取本机其中一个网卡的地址
function dwGetMacAddress(index:integer):string;

implementation

function dwGetMacAddress(index:integer):string;
var
   ncb : TNCB;                {NetBios控制块}
   AdapterS : TAdapterStatus; {网卡状态结构}
   LanaNum : TLanaeNum;       {Netbios Lana}
   i : integer;
   rc : AnsiChar;                 {NetBios的返回代码}
   str : String;
begin
   Result := '';
   try

      ZeroMemory(@ncb, SizeOf(ncb));   {NetBios控制块清零}
      ncb.ncb_command := chr(NCBENUM); {ENUM}
      rc := NetBios(@ncb);             {取返回代码}

      ncb.ncb_buffer := @LanaNum;      {再一次处理ENUM命令}
      ncb.ncb_length := Sizeof(LanaNum);
      rc := NetBios(@ncb);             {取返回代码}

      if ord(rc)<>0 then exit;

      ZeroMemory(@ncb, Sizeof(ncb));   {NetBios控制块清零}
      ncb.ncb_command := chr(NCBRESET);
      ncb.ncb_lana_num := LanaNum.lana[index];
      rc := NetBios(@ncb);
      if ord(rc)<>0 then exit;

      ZeroMemory(@ncb, Sizeof(ncb));   {取网卡的状态}
      ncb.ncb_command := chr(NCBASTAT);
      ncb.ncb_lana_num := LanaNum.lana[index];
      StrPCopy(ncb.ncb_callname,'*');
      ncb.ncb_buffer := @AdapterS;
      ncb.ncb_length := SizeOf(AdapterS);
      rc := NetBios(@ncb);

      str := '';                       {将MAC地址转换成字符串}
      for i:=0 to 5 do
         str := str + IntToHex(Integer(AdapterS.adapter_address[i]),2);
      Result := str;
   finally
   end;
end;

function GetHardDiskSerialNumber: string;
var
    SWbemLocator: OLEVariant;
    SWbemServices: OLEVariant;
    SWbemObjectSet: OLEVariant;
    SWbemObject: OLEVariant;
    i: Integer;
begin
    Result := '';

    try
        SWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
        SWbemServices := SWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '');
        SWbemObjectSet := SWbemServices.ExecQuery('SELECT * FROM Win32_DiskDrive WHERE MediaType = "Fixed hard disk media"');

        for i := 0 to SWbemObjectSet.Count - 1 do begin
            SWbemObject := SWbemObjectSet.ItemIndex(i);
            Result := SWbemObject.SerialNumber;
            Exit; // Assuming you want to get the first serial number found
        end;
    except
        Result  := 'DW1973102786'   //如出现异常，则指定为固定值
    end;
end;



function dwGetUUID:String;
Var
    SMBios      : TSMBios;
    LSystem     : TSystemInformation;
    sText       : String;
    {$IFNDEF LINUX}
        UUID    : Array [0 .. 31] of AnsiChar;
    {$ENDIF}
begin
    try
        SMBios := TSMBios.Create;
        try
            //SMBios.LoadFromFile('/home/rruz/PAServer/scratch-dir/RRUZ-Linux Ubuntu/SMBiosTables/SMBIOS.dat', true);
            LSystem := SMBios.SysInfo;
            //WriteLn('System Information');
            //WriteLn('Manufacter    ' + LSystem.ManufacturerStr);
            //WriteLn('Product Name  ' + LSystem.ProductNameStr);
            //WriteLn('Version       ' + LSystem.VersionStr);
            //WriteLn('Serial Number ' + LSystem.SerialNumberStr);
            {$IFNDEF LINUX}
                BinToHex(@LSystem.RAWSystemInformation.UUID, UUID, SizeOf(LSystem.RAWSystemInformation.UUID));
                Result  := UUID;
                //WriteLn('UUID          ' + UUID);
            {$ENDIF}
            if SMBios.SmbiosVersion >= '2.4' then begin
                //WriteLn('SKU Number    ' + LSystem.SKUNumberStr);
                //WriteLn('Family        ' + LSystem.FamilyStr);
            end;
            //WriteLn;
        finally
            SMBios.Free;
        end;
    except
        sText   := GetHardDiskSerialNumber;
        while Length(sText)<12 do begin
            sText   := sText+'F';
        end;
        Result  := Copy(sText,1,12);
    end;
end;


//得到FORM中各控件的关键信息
function dwGetComponentInfos(AForm:TForm):String;
var
    //
    iComp   : Integer;
    iArray  : Integer;
    iDWVcl  : Integer;
    //
    sVcl    : String;
    pVcl    : PWideChar;
    sItem   : string;

    //
    oComp   : TComponent;
    //
    joArray : Variant;
    joForm  : Variant;
    joRes   : Variant;
begin
    //<-----说明
    //1 2021-12-22 加入了强制刷新功能，设置ParentCustomHint = False时强制刷新，包括Form
    //>
    try
        //结果数组
        joRes    := _JSON('[]');

        //先添加窗体本身数据
        if AForm.ParentCustomHint then begin
            joRes.Add('this.__name = "'+AForm.Name+'";');
            joRes.Add('this.'+AForm.Name+'__top="'+IntToStr(AForm.Top)+'px";');
            joRes.Add('this.'+AForm.Name+'__wid="'+IntToStr(AForm.ClientWidth)+'px";');
            joRes.Add('this.'+AForm.Name+'__hei="'+IntToStr(AForm.ClientHeight)+'px";');
            if AForm.Owner = nil then begin
                joRes.Add('document.title ="'+(AForm.Caption)+'";');
            end;
        end else begin
            AForm.ParentCustomHint  := True;
            Exit;
        end;

        //
        for iComp := 0 to AForm.ComponentCount-1 do begin
            //查找到控件
            oComp     := AForm.Components[iComp];

            //以下3行仅用于系统调试
            //if Pos('form_home',lowercase(oComp.Name))>0 then begin
            //    oComp     := AForm.Components[iComp];
            //end;

            //找到控件对应DLL序号
            if grDWVclNames.TryGetValue(dwGetCompDllName(oComp),iDWVcl) then begin
                //得到控件操作后的信息
                sVcl    := (grDWVcls[iDWVcl].GetAction(TControl(oComp)));

                //转换化JSON数组对象
                joArray   := _json(sVcl);

                sVcl        := '';

                //异常处理
                if joArray = unassigned then begin
                    joArray   := _json('[]');
                end;
            end else begin
                //返回回数
                joArray   := _json('[]');
            end;

            //将操作结果（送前端执行的JS代码）保存到JSON数组
            //如果ParentCustomHint = False，表明需要强制刷新，则在代码中多增加一个空格(这样系统会感觉是变化了，就会更新)
            //并置ParentCustomHint = True, 用于执行后取得正确的值
            if dwHasProperty(oComp,'ParentCustomHint') and (TControl(oComp).ParentCustomHint = False) then begin
                TControl(oComp).ParentCustomHint    := True;
                for iArray := 0 to joArray._Count-1 do begin
                    joRes.Add(' '+joArray._(iArray));
                end;
            end else begin
                //joRes.Add(joArray);
                for iArray := 0 to joArray._Count-1 do begin
                    sItem   := joArray._(iArray);
                    joRes.Add(sItem);
                    //joRes.Add(joArray._(iArray));
                end;

            end;
            //
            VarClear(joArray);


            //
            if dwIsTForm(oComp) then begin
                joForm    := _JSON(dwGetComponentInfos(TForm(oComp)));
                //
                //joRes.Add(joForm);

                for iArray := 0 to joForm._Count-1 do begin
                    joRes.Add(joForm._(iArray));
                end;
                //
                VarClear(joForm);
            end;

        end;

        //
        Result  := joRes;//.ToString;

        //将Result保存到当前Form的Hint中的compinfos
        //dwSetProp(AForm,'compinfos',string(Result));
    except
        ShowMessage(AForm.Name);
    end;
end;


//得到FORM中各控件的关键信息
function dwGetComponentInfos_old(AForm:TForm):String;
var
    //
    iComp   : Integer;
    iArray  : Integer;
    iDWVcl  : Integer;
    //
    sVcl    : String;
    sItem   : string;

    //
    oComp   : TComponent;
    //
    joArray : Variant;
    joForm  : Variant;
    joRes   : Variant;
begin
    //<-----说明
    //1 2021-12-22 加入了强制刷新功能，设置ParentCustomHint = False时强制刷新，包括Form
    //>

    //结果数组
    joRes    := _json('[]');

    //先添加窗体本身数据
    if AForm.ParentCustomHint then begin
        joRes.Add('this.'+AForm.Name+'__top="'+IntToStr(AForm.Top)+'px";');
        joRes.Add('this.'+AForm.Name+'__wid="'+IntToStr(AForm.ClientWidth)+'px";');
        joRes.Add('this.'+AForm.Name+'__hei="'+IntToStr(AForm.ClientHeight)+'px";');
    end else begin
        AForm.ParentCustomHint  := True;
        Exit;
    end;

    //
    for iComp := 0 to AForm.ComponentCount-1 do begin
        //查找到控件
        oComp     := AForm.Components[iComp];


        //
        joArray   := _json('[]');

        //
        if grDWVclNames.TryGetValue(dwGetCompDllName(oComp),iDWVcl) then begin
            //以下3行仅用于调试
            //if dwGetCompDllName(oComp) = 'dwtdbgrid.dll' then begin
            //    sVcl    := sVcl + '';
            //end;

            //得到控件操作后的信息
            sVcl      := grDWVcls[iDWVcl].GetAction(TControl(oComp));

            //
            joArray   := _json(sVcl);

            //异常处理
            if joArray = unassigned then begin
                joArray   := _json('[]');
            end;
        end;

        //将操作结果（送前端执行的JS代码）保存到JSON数组
        //如果ParentCustomHint = False，表明需要强制刷新，则在代码中多增加一个空格(这样系统会感觉是变化了，就会更新)
        //并置ParentCustomHint = True, 用于执行后取得正确的值
        if dwHasProperty(oComp,'ParentCustomHint') and (TControl(oComp).ParentCustomHint = False) then begin
            TControl(oComp).ParentCustomHint    := True;
            for iArray := 0 to joArray._Count-1 do begin
                joRes.Add(' '+joArray._(iArray));
            end;
        end else begin
            //joRes.Add(joArray);
            for iArray := 0 to joArray._Count-1 do begin
                sItem   := joArray._(iArray);
                joRes.Add(sItem);
                //joRes.Add(joArray._(iArray));
            end;

        end;
        //
        VarClear(joArray);


        //
        if dwIsTForm(oComp) then begin
            joForm    := (dwGetComponentInfos(TForm(oComp)));
            //
            //joRes.Add(joForm);

            for iArray := 0 to joForm._Count-1 do begin
                joRes.Add(joForm._(iArray));
            end;
            //
            VarClear(joForm);
        end;

    end;
    //
    Result  := joRes;
end;


end.
