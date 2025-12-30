library dwTPanel__cesium;
{
    本模块用于解析DataV系统的dv-border-box-13
}


uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
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
     case TPanel(ACtrl).Alignment of
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
     case TPanel(ACtrl).Alignment of
          taRightJustify : begin
               Result    := 'text-align:right;';
          end;
          taCenter : begin
               Result    := 'text-align:center;';
          end;
     end;
end;


//=====================以上为辅助函数===============================================================

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    sCode       : String;
    sSelColor   : String;   //选中的边框颜色
    sNorColor   : String;   //未选中的边框颜色
    sFull       : String;
    joRes       : Variant;
    joHint      : Variant;
    iSize       : Integer;  //控制选择框的大小
begin
     //生成返回值数组
    joRes   := _Json('[]');

    //
    sFull   := dwFullName(ACtrl);

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //
    sCode   := '<link rel="stylesheet" href="dist/_cesium/Build/Cesium/Widgets/widgets.css">';
    joRes.Add(sCode);

    //
    sCode   := '<script src="dist/_cesium/Build/Cesium/Cesium.js"></script>';
    joRes.Add(sCode);

    //
    //sCode   := '<script src="dist/_cesium/viewerCesiumNavigationMixin.js"></script>';
    //joRes.Add(sCode);

    sCode   := '<script src="dist/_cesium/dwCesium.js"></script>';
    joRes.Add(sCode);

    //
    sCode   :=
        '<style>'+
            '/* 不占据空间，无法点击 */'+
            '.cesium-viewer-toolbar,             /* 右上角按钮组 */'+
            '.cesium-viewer-animationContainer,  /* 左下角动画控件 */'+
            '.cesium-viewer-timelineContainer,   /* 时间线 */'+
            '.cesium-viewer-bottom               /* logo信息 */'+
            '{'+
            '	display: none;'+
            '}'+
            '.cesium-viewer-fullscreenContainer  /* 全屏按钮 */'+
            '{ position: absolute; top: -999em;  }'+
	    '</style>';
    joRes.Add(sCode);

    //
    Result := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
    joData  : Variant;
    iX,iY   : Integer;
begin
    with TPanel(Actrl) do begin

        //
        joData    := _Json(AData);

        if joData.e = 'onclick' then begin
            if Enabled then begin
                Locked  := not Locked;
            end;
             if Assigned(TPanel(ACtrl).OnClick) then begin
                  TPanel(ACtrl).OnClick(TPanel(ACtrl));
             end;
        end else if joData.e = 'onmousedown' then begin
            if Assigned(TPanel(ACtrl).OnMouseDown) then begin
                iX  := StrToIntDef(joData.v,0);
                iY  := iX mod 100000;
                iX  := iX div 100000;
                TPanel(ACtrl).OnMouseDown(TPanel(ACtrl),mbLeft,[],iX,iY);
            end;
        end else if joData.e = 'onmouseup' then begin
            if Assigned(TPanel(ACtrl).OnMouseup) then begin
                iX  := StrToIntDef(joData.v,0);
                iY  := iX mod 100000;
                iX  := iX div 100000;
                TPanel(ACtrl).OnMouseup(TPanel(ACtrl),mbLeft,[],iX,iY);
            end;
        end else if joData.e = 'onenter' then begin
             if Assigned(TPanel(ACtrl).OnMouseEnter) then begin
                  TPanel(ACtrl).OnMouseEnter(TPanel(ACtrl));
             end;
        end else if joData.e = 'onexit' then begin
             if Assigned(TPanel(ACtrl).OnMouseLeave) then begin
                  TPanel(ACtrl).OnMouseLeave(TPanel(ACtrl));
             end;
        end;
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode   : string;
    sId     : string;
    sFull   : String;
    joHint  : Variant;
    joRes   : Variant;
begin
    //
    sFull   := dwFullName(ACtrl);

    //
    with TPanel(Actrl) do begin


        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        with TPanel(ACtrl) do begin
            //
            sCode   := '<div'
                    +' id="'+sFull+'"'
                    +dwGetDWAttr(joHint)
                    +dwVisible(TControl(ACtrl))                            //用于控制可见性Visible
                    +' :style="{'
                        +'backgroundColor:'+sFull+'__col,'
                        //Font
                        +'color:'+sFull+'__fcl,'
                        +'''font-size'':'+sFull+'__fsz,'
                        +'''font-family'':'+sFull+'__ffm,'
                        +'''font-weight'':'+sFull+'__fwg,'
                        +'''font-style'':'+sFull+'__fsl,'
                        +'''text-decoration'':'+sFull+'__ftd,'

                        +'transform:''rotateZ({'+sFull+'__rtz}deg)'','
                        +'left:'+sFull+'__lef,top:'+sFull+'__top,width:'+sFull+'__wid,height:'+sFull+'__hei}"'
                        //+' style="position:'+dwIIF(Parent.ControlCount=1,'relative','absolute')+';overflow:hidden;'
                        +' style="position:'+dwIIF((Parent.ControlCount=1)and(Parent.ClassName='TScrollBox'),'relative','absolute')+';overflow:hidden;'
                        +dwIIF(BorderStyle=bsSingle,'border-radius: 2px;box-shadow: 0 2px 4px rgba(0, 0, 0, .12), 0 0 6px rgba(0, 0, 0, .04);box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);','')
                        +dwGetHintStyle(joHint,'radius','border-radius','')   //border-radius
                        +dwGetDWStyle(joHint)
                    +'"' //style 封闭
                    +' @click="'+sFull+'__click()"'
                    +'>';
            //添加到返回值数据
            joRes.Add(sCode);
        end;
        //
        Result    := (joRes);
    end;
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
    joRes   : Variant;
    sId     : string;
    sFull   : String;
begin
    with TPanel(Actrl) do begin

        //生成返回值数组
        joRes    := _Json('[]');
        //生成返回值数组
        joRes.Add('</div>');
        //
        Result    := (joRes);
    end;
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    joHint      : Variant;
    sType       : String;
    sFull   : String;
begin
    //
    sFull   := dwFullName(ACtrl);

    with TPanel(Actrl) do begin
        joHint  := dwGetHintJson(TControl(Actrl));

        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TPanel(ACtrl) do begin
            joRes.Add(sFull+'__lef:"'+IntToStr(Left)+'px",');
            joRes.Add(sFull+'__top:"'+IntToStr(Top)+'px",');
            joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
            joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
            //
            joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
            //
            joRes.Add(sFull+'__cap:"'+dwProcessCaption(Caption)+'",');
            //
            joRes.Add(sFull+'__cls:"'+dwIIF(Locked,sFull+'_selected',sFull+'_normal')+'",');
            //
            //
            if TPanel(ACtrl).Color = clNone then begin
                joRes.Add(sFull+'__col:"rgba(0,0,0,0)",');
            end else begin
                joRes.Add(sFull+'__col:"'+dwAlphaColor(TPanel(ACtrl))+'",');
            end;
            //
            joRes.Add(sFull+'__rtz:30,');
            //
            joRes.Add(sFull+'__fcl:"'+dwColor(Font.Color)+'",');
            joRes.Add(sFull+'__fsz:"'+IntToStr(Font.size+3)+'px",');
            joRes.Add(sFull+'__ffm:"'+Font.Name+'",');
            joRes.Add(sFull+'__fwg:"'+_GetFontWeight(Font)+'",');
            joRes.Add(sFull+'__fsl:"'+_GetFontStyle(Font)+'",');
            joRes.Add(sFull+'__ftd:"'+_GetTextDecoration(Font)+'",');
            //
            joRes.Add(sFull+':0,');
        end;
        //
        Result    := (joRes);
    end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes   : Variant;
    joHint  : Variant;
    sFull   : String;
begin
    //
    sFull   := dwFullName(ACtrl);

    with TPanel(Actrl) do begin
        joHint  := dwGetHintJson(TControl(Actrl));

        //生成返回值数组
        joRes    := _Json('[]');
            //
            with TPanel(ACtrl) do begin
            joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
            joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
            joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
            joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
            //
            joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
            //
            joRes.Add('this.'+sFull+'__cap="'+dwProcessCaption(Caption)+'";');
            //
            joRes.Add('this.'+sFull+'__cls="'+dwIIF(Locked,sFull+'_selected',sFull+'_normal')+'";');
            //
            //
            if TPanel(ACtrl).Color = clNone then begin
                joRes.Add('this.'+sFull+'__col="rgba(0,0,0,0)";');
            end else begin
                joRes.Add('this.'+sFull+'__col="'+dwAlphaColor(TPanel(ACtrl))+'";');
            end;
            //
            joRes.Add('this.'+sFull+'__fcl="'+dwColor(Font.Color)+'";');
            joRes.Add('this.'+sFull+'__fsz="'+IntToStr(Font.size+3)+'px";');
            joRes.Add('this.'+sFull+'__ffm="'+Font.Name+'";');
            joRes.Add('this.'+sFull+'__fwg="'+_GetFontWeight(Font)+'";');
            joRes.Add('this.'+sFull+'__fsl="'+_GetFontStyle(Font)+'";');
            joRes.Add('this.'+sFull+'__ftd="'+_GetTextDecoration(Font)+'";');
        end;
        //
        Result    := (joRes);
    end;
end;

function dwGetMethods(ACtrl:TControl):String;stdCall;
var
    //
    sCode   : string;
    sFull   : string;
    //
    joHint  : Variant;
    joRes   : Variant;
begin
    //返回值 JSON对象，可以直接转换为字符串
    joRes   := _json('[]');

    //
    sFull   := dwFullName(ACtrl);

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    with TPanel(ACtrl) do begin
        //函数头部
        sCode   := sFull+'__click(event) {'#13;

        //加入Hint中的onclick赋于的直接js代码
        if joHint.Exists('onclick') then begin
            sCode   := sCode +joHint.onclick+#13;
        end;

        //如果Enabled, 则自动翻转选中状态
        if Enabled then begin
            sCode   := sCode +
                    'if (this.'+sFull+'__cls == "'+sFull+'_selected"){'#13#10+
                        'this.'+sFull+'__cls = "'+sFull+'_normal";'#13#10+
                    '} else {'#13#10+
                        'this.'+sFull+'__cls = "'+sFull+'_selected";'#13#10+
                    '};'#13#10;
        end;

        //
        sCode   := sCode + 'this.dwevent("",'''+sFull+''',''0'',''onclick'','''+IntToStr(TForm(Owner).Handle)+''');'
                +'},';

        //
        joRes.Add(sCode);
    end;

    //
    Result   := joRes;
end;

function dwGetMounted(ACtrl:TControl):String;stdCall;
var
    //
    sCode       : string;
    sFull       : string;
    //
    joRes       : Variant;
    joHint      : Variant;
begin
    joRes   := _json('[]');

    //
    sFull   := dwFullName(ACtrl);

    //取得HINT对象JSON
    joHint := dwGetHintJson(TControl(ACtrl));

    //
    if not joHint.Exists('token') then begin
        joHint.token := 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIxYzk4OTM1MS02MDJiLTQxNjgtOWJmZi0wZTFjNWNiN2E0M2EiLCJpZCI6MjA3Mjc4LCJpYXQiOjE3MTMzOTk5NDh9.onUe7bOZvhXrjqpepcP-PFujPJSd2iFyc7CaFWqqUKA';
    end;

    //此处应修改为最新的token
    sCode   := ''
            +'Cesium.Ion.defaultAccessToken = "'+joHint.token+'";'
            +sFull+' = new Cesium.Viewer('
                +''''+sFull+''''
                //+',{ terrainProvider: Cesium.createDefaultTerrainProvider()}'
            +');'#13
            //+sFull+'.extend(Cesium.viewerCesiumNavigationMixin, {});'
            ;
    joRes.Add(sCode);
(*

    sCode   := ''
            +#13'var cesiumTerrainProviderMeshes = new Cesium.CesiumTerrainProvider({'
                +#13'url : "https://assets.agi.com/stk-terrain/world",'
            +#13'});'

            +#13+sFull+'.terrainProvider = cesiumTerrainProviderMeshes;';

    joRes.Add(sCode);

    //添加离线图形
    sCode   :=
            'let url = ''media/cesium/image/{z}/{x}/{y}.jpg'';'#13+
			'const imagery = new Cesium.WebMapTileServiceImageryProvider({'#13+
				'url: url,'#13+
                'fileExtension:"jpg"'#13+
				//'layer: "uav_amap:ggdt",'#13+
				//'style: "",'#13+
				//'format: "image/png",'#13+
				//'tileMatrixSetID: ''EPSG:4326'','#13+
				//'tilingScheme: new Cesium.GeographicTilingScheme(),'#13+
			'});'#13+
			sFull+'.imageryLayers.addImageryProvider(imagery);';
    joRes.Add(sCode);

    //地形数据
    sCode   :=
			'const terrainProvider = Cesium.CesiumTerrainProvider.fromUrl(''media/cesium/terrain/'','#13+
				'{'#13+
					'requestVertexNormals: true, // 请求照明'#13+
					'requestWaterMask: true, // 请求水波纹效果'#13+
				'}, '#13+
			');'#13+
			sFull+'.terrainProvider = terrainProvider;';
    //joRes.Add(sCode);

    //是否反锯齿
    if TPanel(ACtrl).ShowCaption then begin
        sCode   :=
                //设定分辨率,配置Cesium抗锯齿;
                'if (Cesium.FeatureDetection.supportsImageRenderingPixelated()) {'#13+
                    //判断是否支持图像渲染像素化处理
                    sFull+'.resolutionScale = window.devicePixelRatio;'#13+
                '}'#13+
                //开启抗锯齿
                sFull+'.scene.fxaa = true;'#13+
                sFull+'.scene.postProcessStages.fxaa.enabled = true;';
        joRes.Add(sCode);

    end;
*)
    //
    Result   := joRes;
end;




exports
     dwGetExtra,
     dwGetMethods,
     dwGetEvent,
     dwGetMounted,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetData;

begin
end.

