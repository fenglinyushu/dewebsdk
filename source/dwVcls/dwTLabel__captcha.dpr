library dwTLabel__captcha;

uses
    ShareMem,

     //
     dwCtrlBase,    //一些基础函数

     //
     SynCommons,    //mormot用于解析JSON的单元

     //
     SysUtils,DateUtils,ComCtrls, ExtCtrls,
     Vcl.Imaging.jpeg,Vcl.Graphics,
     Classes,
     Dialogs,
     StdCtrls,
     encddecd,
     Windows,
     Controls,
     Forms;

const
     CodeChar: array [0 .. 31] of char = (
          '2','3','4','5','6','7','8','9',
          'A','B','C','D','E','F','G','H',
          'J','K','L','M','N','P','Q','R',
          'S','T','U','V','W','X','Y','Z');

     CodeChar1: array [0 .. 31] of char = (
          '我','妮','爱','他','他','随','你','吗','秋',
          '琳','英','圈','坤','菜','平','后','芳','要',
          '香','港','澳','情','感','值','得','宾','开',
          '枪','飞','鸡','鸭','睛');

function BaseImage(fn: string): string;
var
    m1: TMemoryStream;
    m2: TStringStream;
    str: string;
begin
    m1 := TMemoryStream.Create;
    m2 := TStringStream.Create('');
    m1.LoadFromFile(fn);
    EncdDecd.EncodeStream(m1, m2);                       // 将m1的内容Base64到m2中
    str := m2.DataString;
    str := StringReplace(str, #13, '', [rfReplaceAll]);  // 这里m2中数据会自动添加回车换行，所以需要将回车换行替换成空字符
    str := StringReplace(str, #10, '', [rfReplaceAll]);
    result := str;                                       // 返回值为Base64的Stream
    m1.Free;
    m2.Free;
end;


function _CreateCaptcha(AWidth,AHeight:Integer;var ACaptcha:String):String;
var
    //
    iFont   : Integer;
    I,X,Y   : Integer;
    sTmp    : String;
    sSrc    : string;
    oBmp    : Vcl.Graphics.TBitmap;
begin
    try
        //文件名称=随机前缀（可自行更改）+日期
        //ASrc     := '_dwcaptcha_.jpg';  //'+FormatDateTime('YYYYMMdd_hhmmss_zzz',now)+'
        sSrc     := FormatDateTime('YYYYMMdd_hhmmss_zzz_',now)+IntToStr(Random(1000))+'.jpg';
        //
        oBmp := Vcl.Graphics.TBitmap.Create;
        oBmp.Width     := AWidth;
        oBmp.Height    := AHeight;
        oBmp.Canvas.Pen.Width    := 1;
        iFont     := AWidth div 8; //可以写N个字符的
        oBmp.Canvas.Font.Size:= iFont;
        oBmp.Canvas.Font.Name:='微软雅黑';
        oBmp.Canvas.Font.Color:=clGreen;
        //先随机画线200条
        for I := 0 to (AWidth*AHeight) div 300 do  begin
            Randomize;
            oBmp.Canvas.Pen.Color:= RGB(Random(156)+100, Random(156)+100,Random(156)+100);
            oBmp.Canvas.MoveTo(Random(AWidth),Random(AHeight));
            oBmp.Canvas.LineTo(Random(AWidth),Random(AHeight));
        end;
        oBmp.Canvas.Font.Color:=RGB(Random(10), Random(100),Random(100));//clBlack;
        oBmp.Canvas.Font.Style:=[fsBold,fsItalic];


        //最多有四个字符
        X    := 0;
        ACaptcha  := '';
        oBmp.Canvas.Brush.Style:=bsClear;
        for I :=0 to 3 do begin
            Randomize;
            sTmp      := CodeChar[Random(Length(CodeChar))];
            ACaptcha  := ACaptcha + sTmp;
            X    := X + Random((AWidth-iFont*2) div 4)-1;
            oBmp.Canvas.TextOut(X,Random(AHeight-iFont*2),sTmp);
            x:=x+iFont;
        end;

        //再随机画线
        for I := 0 to (AWidth*AHeight) div 400 do  begin
            Randomize;
            oBmp.Canvas.Pen.Color:= RGB(Random(156)+100, Random(156)+100,Random(156)+100);
            oBmp.Canvas.MoveTo(Random(AWidth),Random(AHeight));
            oBmp.Canvas.LineTo(Random(AWidth),Random(AHeight));
        end;

        //如果不存在，则创建
        if not DirectoryExists('media/images/temp/') then begin
            //
            ForceDirectories(GetCurrentDir+'\media\images\temp');
        end;

        //
        oBmp.SaveToFile('media/images/temp/'+sSrc);
        oBmp.Destroy;
        //>

        //进行base64编码
        Result := 'data:image/png;base64,'+BaseImage('media/images/temp/'+sSrc);

        //Result  := 'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7';

        //删除源文件
        DeleteFile(PChar('media/images/temp/'+sSrc));

    except
    end;
end;


//当前控件需要引入的第三方JS/CSS ,一般为不做改动,目前仅在TChart使用时需要用到
function dwGetExtra(ACtrl:TComponent):String;stdCall;
begin
    Result    := '[]';
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):String;stdCall;
var
    joData      : Variant;
    joCaption   : Variant;  //用caption来保存验证码和BASE64码
    sSrc        : string;
    sCaptcha    : string;
    iX,iY       : Integer;
    sBase64     : string;   //图片的base64编码
    sCode  : string;
begin
    //=============验证码=================================================
    //最小的base64图片
    //<img src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7">

    //
    joData    := _Json(AData);

    if joData.e = 'onclick' then begin
        //重新生成验证码
        with TLabel(ACtrl) do begin
            sBase64 := _CreateCaptcha(Width,Height,sCaptcha);
            //
            joCaption           := _JSON('{}');
            joCaption.captcha   := sCaptcha;
            joCaption.base64    := sBase64;
            Hint                := joCaption;
            Caption             := sCaptcha;
        end;
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):String;stdCall;
type
     PdwUpdate = function (AComponent,AProperty,AValue:String):Integer;stdcall;
var
    sCode       : string;
    sSize       : string;
    sName       : string;
    sRadius     : string;
    sPreview    : string;   //用于预览的字符串
    //
    joRes       : Variant;
    joCaption   : Variant;  //用caption来保存验证码和BASE64码
    sHint       : String;
    sCaptcha    : string;
    sBase64     : string;   //图片的base64编码
    //
    hHandle     : Integer;
    fUpdate     : PdwUpdate;
begin
    //=============验证码=================================================
    //生成返回值数组
    joRes    := _Json('[]');
    with TLabel(ACtrl) do begin
        //生成验证码,并得到base64码
        sBase64 := _CreateCaptcha(Width,Height,sCaptcha);
        //
        joCaption           := _JSON('{}');
        joCaption.captcha   := sCaptcha;
        joCaption.base64    := sBase64;
        Hint                := joCaption;
        Caption             := sCaptcha;

        //
        joRes.Add('<el-image'
                +' id="'+dwFullName(Actrl)+'"'
                +' :src="'+dwFullName(Actrl)+'__src"'
                +' fit="none"'
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                +dwLTWH(TControl(ACtrl))
                +sRadius
                +'cursor: pointer;'
                +'"'
                +dwIIF(True,Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
                +'>');
    end;
    //
    Result  := joRes;
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):String;stdCall;
var
    joRes  : Variant;
    sCode  : string;
begin
    //=============验证码=================================================


    //生成返回值数组
    joRes    := _Json('[]');

    //生成返回值数组
    joRes.Add('</el-Image>');          //此处需要和dwGetHead对应

    //
    Result  := joRes;
end;

//取得Data
function dwGetData(ACtrl:TComponent):String;stdCall;
var
    joRes       : Variant;
    joCaption   : Variant;
    sCode       : string;
begin
    //=============验证码=================================================

    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TLabel(ACtrl) do begin
        joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(Enabled,'false,','true,'));
        //
        joCaption   := _JSON(Hint);
        joRes.Add(dwFullName(Actrl)+'__src:"'+joCaption.base64+'",');
    end;
    //
    Result  := joRes;
end;

function dwGetAction(ACtrl:TComponent):String;stdCall;
var
    joRes       : Variant;
    joCaption   : Variant;
    sCode       : string;
begin
    //=============验证码=================================================

    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TLabel(ACtrl) do begin
        joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+dwFullName(Actrl)+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        joCaption   := _JSON(Hint);
        joRes.Add('this.'+dwFullName(Actrl)+'__src="'+joCaption.base64+'";');
        VarClear(joCaption);
    end;
    //
    Result  := joRes;
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
 
