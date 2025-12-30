library dwTPanel__elupload;

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
    joRes     : Variant;
    scode     : string;
begin
    //=============普通图片===============================================

    //生成返回值数组
    joRes    := _Json('[]');

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
         if Assigned(TPanel(ACtrl).OnClick) then begin
              TPanel(ACtrl).OnClick(TPanel(ACtrl));
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
         if Assigned(TPanel(ACtrl).OnMouseEnter) then begin
              TPanel(ACtrl).OnMouseEnter(TPanel(ACtrl));
         end;
    end else if joData.e = 'onexit' then begin
         //
         if Assigned(TPanel(ACtrl).OnMouseLeave) then begin
              TPanel(ACtrl).OnMouseLeave(TPanel(ACtrl));
         end;
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode       : string;
    sSize       : string;
    sName       : string;
    sRadius     : string;
    sPreview    : string;   //用于预览的字符串
     sFull   : String;
    joHint      : Variant;
    joRes       : Variant;
    sSrc        : String;
    sCaptcha    : string;
    //JS 代码
    sEnter      : String;
    sExit       : String;
begin
    //=============普通图片===================================================================

    //生成返回值数组
    joRes    := _Json('[]');

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));


    with TPanel(ACtrl) do begin
        //取得全名备用
        sFull   := dwFullName(Actrl);

        //
        scode   :=
        '<el-upload'
            +' id='''+sFull+''''

            //是否在选取文件后立即进行上传
            +' :auto-upload="true"'

            //必选参数，上传的地址
            +' action="'+dwGetStr(joHint,'action','media/images/temp/')+'"'

            //是否支持多选文件
            +dwIIF(dwGetInt(joHint,'multiple',0)=1,' multiple','')

            //是否启用拖拽上传
            +dwIIF(dwGetInt(joHint,'drag',0)=1,' drag','')

            //接受上传的文件类型（thumbnail-mode 模式下此参数无效）
            +' accept="'+dwGetStr(joHint,'accept','image/jpeg,image/gif,image/png')+'"'

            //上传文件个数的限制
            +' :limit="'+IntToStr(dwGetInt(joHint,'limit',1))+'"'

            //是否用默认文件列表显示
      		+' :show-file-list="'+dwIIF(dwGetInt(joHint,'showfilelist',0)=1,'true','false')+'"'

            //文件通过接口上传之前，一般用来判断规则，
            +' :before-upload="'+sFull+'__beforeupload"'

            // function(res, file, fileList)    上传成功，res为服务器返回的数据，可以判断是否解析成功
            +' :on-success="'+sFull+'__success"'

            //覆盖默认的上传行为，可以自定义上传的实现
            +' :http-request="'+sFull+'__httprequest"'

            //+' ref='''+sFull+'__upload'''
            //+' :class="{ disabled: '+sFull+'__noUpload }"'
            //+' :headers="{processData: false,contentType: false}"'
            //+' :on-change="'+sFull+'__handleChange"'
            +' list-type="picture-card"  '
            +' :limit="'+inttostr(tag)+'"'
            //+' :file-list="'+sFull+'__fileList"'
            +dwVisible(TControl(ACtrl))
            +dwDisable(TControl(ACtrl))
            +dwGetDWAttr(joHint)
            +' :style="{'
                +'left:'+sFull+'__lef,'
                +'top:'+sFull+'__top,'
                +'width:'+sFull+'__wid,'
                +'height:'+sFull+'__hei'
            +'}"'
            +' style="'
                +'position:absolute;'
                +dwGetHintStyle(joHint,'radius','border-radius','')   //border-radius
                +dwGetHintStyle(joHint,'backgroundcolor','background-color','')       //自定义背景色
                +dwGetHintStyle(joHint,'color','color','')             //自定义字体色
                +dwGetHintStyle(joHint,'fontsize','font-size','')      //自定义字体大小
                +dwGetDWStyle(joHint)
            +'"' //style 封闭
        +'>'#13
        +'</el-upload>';



        joRes.Add(scode);
    end;

    //
    Result    := (joRes);

end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
begin

    //
    Result    := '[]';
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes   : Variant;
    joHint  : Variant;
begin
    //=============普通图片===============================================

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TPanel(ACtrl) do begin
        joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(Enabled,'false,','true,'));
        //
        joRes.Add(dwFullName(Actrl)+'__dialogImageUrl:"",');
        joRes.Add(dwFullName(Actrl)+'__dialogVisible:'+dwIIF(Enabled,'false,','true,'));
        joRes.Add(dwFullName(Actrl)+'__noUpload:'+dwIIF(Enabled,'false,','true,'));
        //end else begin
        joRes.Add(dwFullName(Actrl)+'__src:"'+dwGetProp(TControl(ACtrl),'src')+'",');
        //end;
    end;
    //
    Result    := (joRes);
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
    joHint    : Variant;
begin
    //=============普通图片===============================================


    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TPanel(ACtrl) do begin
        joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');

        //joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
        //joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
        //joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
        //joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+dwFullName(Actrl)+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        //if dwGetProp(TControl(ACtrl),'src')='' then begin
        joRes.Add('this.'+dwFullName(Actrl)+'__dialogImageUrl="";');
        joRes.Add('this.'+dwFullName(Actrl)+'__dialogVisible='+dwIIF(Enabled,'false,','true,'));
        joRes.Add('this.'+dwFullName(Actrl)+'__noUpload='+dwIIF(Enabled,'false,','true,'));
        //            joRes.Add('this.'+dwFullName(Actrl)+'__dialogImageUrl="";');
        //end else begin
        joRes.Add('this.'+dwFullName(Actrl)+'__src="'+dwGetProp(TControl(ACtrl),'src')+'";');
        //end;

    end;
    //
    Result    := (joRes);
end;
function dwGetMethods(ACtrl:TControl):String;stdCall;
var
    //
    sDestDir    : string;
    sCode       : string;
    sFull       : String;
    //
    joRes       : Variant;
    joHint      : Variant;
begin
    joRes   := _json('[]');

    //取得名称 备用
    sFull   := dwFullName(ACtrl);

    //取得HINT对象JSON
    joHint  := dwGetHintJson(TControl(ACtrl));

    //
    with TPanel(ACtrl) do begin
        //上传文件位置
        sDestDir    := dwGetStr(joHint,'action','media/images/temp/');
        //
        if sDestDir <> '' then begin
            //去除前面的\
            if sDestDir[1] = '\' then begin
                Delete(sDestDir,1,1);
            end;
            //去除后面的\
            if sDestDir[Length(sDestDir)]='\' then begin
                Delete(sDestDir,Length(sDestDir),1);
            end;
        end;
        //把中间的\转化为/,以适应JS, 防止转义
        sDestDir    := StringReplace(sDestDir,'\','/',[rfReplaceAll]);

        //
        sCode   := sFull+'__handleRemove(file) { '
            +' this.$refs.'+sFull+'__upload.clearFiles();'
            +' this.'+sFull+'__noUpload = false;  '
            +' },  ' ;
        joRes.Add(sCode);

        //
        sCode   := sFull+'__beforeupload(file) { '
            //+' this.$refs.'+sFull+'__upload.clearFiles();'
            //+' this.'+sFull+'__noUpload = false;  '
            +' },  ' ;
        joRes.Add(sCode);

        //
        sCode   := sFull+'__success(res, file, fileList) { '
            +'console.log("success !!!!");'
            //+' this.$refs.'+sFull+'__upload.clearFiles();'
            //+' this.'+sFull+'__noUpload = false;  '
            +' },  ' ;
        joRes.Add(sCode);


        //
        sCode   := sFull+'__handlePictureCardPreview(file) {  '
            +'this.'+sFull+'__dialogImageUrl = file.url;  '
            +' this.'+sFull+'__dialogVisible = true;  '
        +' }, '   ;
                                              joRes.Add(sCode);
        //
        sCode   := sFull+'__handleChange(file, fileList) {  '
            +' this.'+sFull+'__fileList = fileList; '
            +'}, ';
        joRes.Add(sCode);

        //
        sCode   := sFull+'__httprequest(param) {'
            +'console.log("success 1");'
            +'let that = this;'
            +'let formData = new FormData(); '
            +'formData.append("file", this.'+sFull+'__fileList[0].raw);'
            +'let config = {'
                +'headers:{'
                    +'dataType: "json",'
                    +'method: "POST",'
                    +'contentType:false,'
                    +'processData:false,'
                    +'''destdir'': "'+sDestDir+'",'
                    +'contentType: "multipart/form-data",'
                    +'data: that.formData '
                +'}'
            +'}; '
            +'console.log("success 2");'
            +'axios.post(''/upload'', formData, config).then(resp =>{'
                +'console.log("success 3");'
                +'this.procResp(resp.data); '
            +'});  '
            +'console.log("success 4");'

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
 
