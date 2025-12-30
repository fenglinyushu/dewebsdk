library dwTImage__preview;

uses
     ShareMem,      //必须添加

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
     Windows,
     Controls,
     Forms;



//当前控件需要引入的第三方JS/CSS ,一般为不做改动,目前仅在TChart使用时需要用到
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    joRes   : Variant;
    sCode   : string;
    joHint  : Variant;
begin
    //=============普通图片===============================================

    //生成返回值数组
    joRes    := _Json('[]');

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));


    //以下是TChart时的代码,供参考
    joRes.Add('<link rel="stylesheet" href="dist/_photopreview/skin.css">');
    joRes.Add('<script src="dist/_photopreview/vue-photo-preview.js"></script>');
	sCode   :=
    	'<script>'#13#10+
			'var options={'#13#10+
				'maxSpreadZoom: '+IntToStr(dwGetInt(joHint,'maxspreadzoom',5))+','#13#10+
                'fullscreenEl: '+dwIIF(dwGetInt(joHint,'fullscreen',0)=1,'true','false')+','#13#10+
                'CloseEl: '+dwIIF(dwGetInt(joHint,'close',0)=1,'true','false')+','#13#10+
                'captionEl: '+dwIIF(dwGetInt(joHint,'caption',1)=1,'true','false')+','#13#10+
                'zoomEl: '+dwIIF(dwGetInt(joHint,'zoom',1)=1,'true','false')+','#13#10+
                //'shareEl: '+dwIIF(dwGetInt(joHint,'fullscreen',0)=1,'true','false')+','#13#10+
                'counterEl: '+dwIIF(dwGetInt(joHint,'counter',0)=1,'true','false')+','#13#10+
                'arrowEl: '+dwIIF(dwGetInt(joHint,'arrow',0)=1,'true','false')+','#13#10+
                'tapToClose: '+dwIIF(dwGetInt(joHint,'taptoclose',1)=1,'true','false')+','#13#10+
                'tapToToggleControls: '+dwIIF(dwGetInt(joHint,'taptotogglecontrols',1)=1,'true','false')+','#13#10+
                'clickToCloseNonZoomable: '+dwIIF(dwGetInt(joHint,'clicktoclosenonzoomable',1)=1,'true','false')+','#13#10+
                'indexIndicatorSep: '+dwIIF(dwGetInt(joHint,'indexindicatorsep',0)=1,'true','false')+','#13#10+

			'};'#13#10+
			'Vue.use(vuePhotoPreview,options);'#13#10+
		'</script>'#13#10+
        '';
    joRes.Add(sCode);



    //
    Result    := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
    joData      : Variant;
    sSrc        : string;
    sCaptcha    : string;
    iX,iY       : Integer;
begin
    //=============普通图片===============================================

    //
    joData    := _Json(AData);

    if joData.e = 'onclick' then begin
         //
         if Assigned(TImage(ACtrl).OnClick) then begin
              TImage(ACtrl).OnClick(TImage(ACtrl));
         end;
    end else if joData.e = 'onmousedown' then begin
        if Assigned(TLabel(ACtrl).OnMouseDown) then begin
            iX  := StrToIntDef(joData.v,0);
            iY  := iX mod 100000;
            iX  := iX div 100000;
            TLabel(ACtrl).OnMouseDown(TLabel(ACtrl),mbLeft,[],iX,iY);
        end;
    end else if joData.e = 'onmouseup' then begin
        if Assigned(TLabel(ACtrl).OnMouseup) then begin
            iX  := StrToIntDef(joData.v,0);
            iY  := iX mod 100000;
            iX  := iX div 100000;
            TLabel(ACtrl).OnMouseup(TLabel(ACtrl),mbLeft,[],iX,iY);
        end;
    end else if joData.e = 'onenter' then begin
         //
         if Assigned(TImage(ACtrl).OnMouseEnter) then begin
              TImage(ACtrl).OnMouseEnter(TImage(ACtrl));
         end;
    end else if joData.e = 'onexit' then begin
         //
         if Assigned(TImage(ACtrl).OnMouseLeave) then begin
              TImage(ACtrl).OnMouseLeave(TImage(ACtrl));
         end;
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode       : string;
    sFull       : string;
    sSize       : string;
    sName       : string;
    sRadius     : string;
    sPreview    : string;   //用于预览的字符串
    //
    joHint      : Variant;
    joRes       : Variant;
    sSrc        : String;
    sCaptcha    : string;
    //JS 代码
    sEnter      : String;
    sExit       : String;
    sClick      : string;
begin
    //=============普通图片===================================================================

    //生成返回值数组
    joRes    := _Json('[]');

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //
    sFull   := dwFullName(Actrl);

    with TImage(ACtrl) do begin
        //进入事件代码----------------------------------------------------------------------------
        sEnter  := '';
        if joHint.Exists('onenter') then begin
            sEnter  := 'dwexecute('''+dwProcQuotation(String(joHint.onenter))+''');';    //取得OnEnter的JS代码
        end;
        if sEnter='' then begin
            if Assigned(OnMouseEnter) then begin
                sEnter    := Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]);
            end else begin

            end;
        end else begin
            if Assigned(OnMouseEnter) then begin
                sEnter    := Format(_DWEVENTPlus,['mouseenter.native',sEnter,Name,'0','onenter',TForm(Owner).Handle])
            end else begin
                sEnter    := ' @mouseenter.native="'+sEnter+'"';
            end;
        end;


      //退出事件代码----------------------------------------------------------------------------
        sExit  := '';
        if joHint.Exists('onexit') then begin
            sExit  := 'dwexecute('''+dwProcQuotation(String(joHint.onexit))+''');';
        end;
        if sExit='' then begin
            if Assigned(OnMouseLeave) then begin
                sExit    := Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]);
            end else begin

            end;
        end else begin
            if Assigned(OnMouseLeave) then begin
                sExit    := Format(_DWEVENTPlus,['mouseleave.native',sExit,Name,'0','onexit',TForm(Owner).Handle])
            end else begin
                sExit    := ' @mouseleave.native="'+sExit+'"';
            end;
        end;

        //单击事件的JS代码------------------------------------------------------------------------
        sClick    := '';
        if joHint.Exists('onclick') then begin
            sClick := 'dwexecute('''+dwProcQuotation(String(joHint.onclick))+''');';
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
    end;


    //得到圆角半径信息
    sRadius   := dwGetHintValue(joHint,'radius','border-radius','');
    sRadius   := StringReplace(sRadius,'=',':',[]);
    sRadius   := Trim(StringReplace(sRadius,'"','',[rfReplaceAll]));
    if sRadius<>'' then begin
        sRadius   := sRadius + ';';
    end;

    with TImage(ACtrl) do begin

        //
        joRes.Add('<div'
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                +dwGetDWAttr(joHint)
                +dwLTWH(TControl(ACtrl))
                +sRadius
                +dwIIF(sClick<>'','cursor: pointer;','')
                +dwGetDWStyle(joHint)
                +'"'
                +dwIIF(Assigned(OnMouseDown),Format(_DWEVENT,['mousedown',Name,'event.offsetX*100000+event.offsetY','onmousedown',TForm(Owner).Handle]),'')
                +dwIIF(Assigned(OnMouseUp),Format(_DWEVENT,['mouseup',Name,'event.offsetX*100000+event.offsetY','onmouseup',TForm(Owner).Handle]),'')
                +sClick
                +sEnter
                +sExit
                +'>');
        joRes.Add('<img '+
                //:style="{left:image1__lef,top:image1__top,width:image1__wid,height:image1__hei}"
                ' :style="{'+
                    'width:'+sFull+'__iw,'+
                    'height:'+sFull+'__ih,'+
                    'margin:'+sFull+'__im,'+
                    'objectFit:'+sFull+'__iof,'+
                    'borderRadius:'+sFull+'__ibr'+
                '}"'+
                ' style="'+
                    dwGetStr(joHint,'imagestyle','')+
                '"'+
                ' v-for="item in '+sFull+'__imgs"'+
                ' :src="item"'+
                ' preview="'+IntToStr(HelpContext)+'"'+
                ' preview-text=""'+
                '>');
        joRes.Add('</div>');
    end;

    //
    Result    := (joRes);
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
    joHint      : Variant;
begin
    //=============普通图片===============================================

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //生成返回值数组
    joRes    := _Json('[]');

    //
    Result    := (joRes);
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes   : Variant;
    joHint  : Variant;
    sFull   : String;
begin
    //=============普通图片===============================================

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //生成返回值数组
    joRes    := _Json('[]');
    //joRes.Add('img1: ["media/images/mn/1.jpg","media/images/mn/2.jpg"],');

    //
    sFull   := dwFullName(Actrl);

    //
    with TImage(ACtrl) do begin
        joRes.Add(sFull+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(sFull+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(sFull+'__dis:'+dwIIF(Enabled,'false,','true,'));
        //
        if joHint.Exists('src') then begin
            joRes.Add(sFull+'__imgs:'+VariantSaveJSON(joHint.src)+',');
        end;

        //
        joRes.Add(sFull+'__iw: "'+IntToStr(dwGetInt(joHint,'width',100))+'px",');
        joRes.Add(sFull+'__ih: "'+IntToStr(dwGetInt(joHint,'height',100))+'px",');
        joRes.Add(sFull+'__im: "'+dwGetStr(joHint,'margin','10px 0 0 10px')+'",');
        joRes.Add(sFull+'__iof:"'+dwGetStr(joHint,'objectfit','cover')+'",');
        joRes.Add(sFull+'__ibr:"'+dwGetStr(joHint,'radius','5px')+'",');

    end;

    //
    Result    := (joRes);
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes   : Variant;
    joHint  : Variant;
    sFull   : String;
begin
    //=============普通图片===============================================


    //取得HINT对象JSON
    joHint  := dwGetHintJson(TControl(ACtrl));

    //生成返回值数组
    joRes   := _Json('[]');


    //
    sFull   := dwFullName(Actrl);

    //
    with TImage(ACtrl) do begin
        joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');

        //
        joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        if joHint.Exists('src') then begin
            joRes.Add('this.'+sFull+'__imgs='+VariantSaveJSON(joHint.src)+';');
        end else begin
            joRes.Add('this.'+sFull+'__imgs=[];');
        end;
        //
        joRes.Add('this.'+sFull+'__iw= "'+IntToStr(dwGetInt(joHint,'width',100))+'px";');
        joRes.Add('this.'+sFull+'__ih= "'+IntToStr(dwGetInt(joHint,'height',100))+'px";');
        joRes.Add('this.'+sFull+'__im= "'+dwGetStr(joHint,'margin','10px 0 0 10px')+'";');
        joRes.Add('this.'+sFull+'__iof="'+dwGetStr(joHint,'objectfit','cover')+'";');
        joRes.Add('this.'+sFull+'__ibr="'+dwGetStr(joHint,'radius','5px')+'";');

        //
        joRes.Add('this.$previewRefresh();');

    end;

    //
    Result    := (joRes);
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
 
