library dwTStaticText__map;

uses
  ShareMem,
  dwCtrlBase,
  SynCommons,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ComCtrls,
  ExtCtrls,
  StdCtrls,
  Windows;

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


//--------------------以上为辅助函数----------------------------------------------------------------


//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    joRes: Variant;
begin
     //生成返回值数组
    joRes := _Json('[]');

    //
    with TStaticText(ACtrl) do begin
        joRes.Add('<link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" />');
        joRes.Add('<script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js"></script>');
        joRes.Add('<style>'
            +#13'.leaflet-tooltip {'
                +#13'background: none !important;'
                +#13'border: none !important;'
                +#13'color: '+dwColor(Font.Color)+' !important;'
                +#13'font-size: '+IntToStr(Font.Size+3)+'px !important;'
                +#13'font-weight: '+dwIIF((fsBold in Font.Style),'bold','normal')+' !important;'
                +#13'padding: 0 !important;'
                +#13'box-shadow: none !important; '
            +#13'}'
        +#13'</style>');
    end;
    //
    Result := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData    : Variant;
     oChange   : Procedure(Sender:TObject) of Object;
     sText     : string;
begin
    with TStaticText(ACtrl) do begin
        //
        joData    := _Json(AData);


        if joData.e = 'onresize' then begin

            //
            if Assigned(TStaticText(ACtrl).OnMouseUp) then begin
                TStaticText(ACtrl).OnMouseUp(TStaticText(ACtrl),mbLeft,[],0,0);
            end;
        end else if joData.e = 'onclick' then begin
            //点击事件
            //
            if Assigned(TStaticText(ACtrl).OnClick) then begin
                StyleName   := dwUnescape(joData.v);
                TStaticText(ACtrl).OnClick(TStaticText(ACtrl));
            end;

        end else if joData.e = 'onchange' then begin
        end else if joData.e = 'onexit' then begin
        end else if joData.e = 'onmouseenter' then begin
        end else if joData.e = 'onmouseexit' then begin
        end;
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode       : string;
    sFull       : string;
    sFont       : string;
    //
    joHint      : Variant;
    joRes       : Variant;
begin
    sFull       := dwFullName(Actrl);
    //
    with TStaticText(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //字体
        sFont   := '';
        if ParentFont = False then begin
            sFont   := _GetFont(Font);
        end;

        //
        sCode   := '<div'
                +' id="'+sFull+'"'
                +dwGetDWAttr(joHint)
                +' style="'
                    +'position:absolute;'
                    +'backgroundColor:'+dwAlphaColor(TPanel(ACtrl))+';'
                    +'left:'+IntToStr(Left)+'px;'
                    +'top:'+IntToStr(top)+'px;'
                    +'width:'+IntToStr(width)+'px;'
                    +'height:'+IntToStr(height)+'px;'
                    //+sFont
                    +dwGetDWStyle(joHint)
                +'"'
                +'>'
                +dwGetStr(joHint,'dwchild','');
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
begin
    with TStaticText(ACtrl) do begin

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
    sFull       : string;
begin
    sFull       := dwFullName(Actrl);

    with TStaticText(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //
        Result    := (joRes);
    end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    joHint      : Variant;
    sFull       : string;
begin
    sFull       := dwFullName(Actrl);

    with TStaticText(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //
        joRes.Add(
            '$("#'+sFull+'").css({'
                +'"left": "'+InttoStr(Left)+'px",'
                +'"top": "'+InttoStr(top)+'px",'
                +'"width": "'+InttoStr(width)+'px",'
                +'"height": "'+InttoStr(height)+'px"'
            +'});'
        );
        //
        Result    := (joRes);
    end;
end;

function dwGetMounted(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    joHint      : Variant;
    //
    iItem       : Integer;
    sCode       : String;
    sFull       : string;
    sDir        : String;
    sData       : String;   //文件名
begin
    //取得全名备用
    sFull   := dwFullName(Actrl);

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //取得目录备用(建议放在media/geojson目录, 注:只有media,download,upload,dist等目录的子目录可以访问)
    sDir    := dwGetStr(joHint,'dir','media/geojson/');

    //检查目录, 不能为空;且最后一位是/
    if sDir = '' then begin
        sDir    := 'media/geojson/';
    end;
    if sDir[Length(sDir)] <> '/' then begin
        sDir    := sDir+'/';
    end;

    //取得数据名备用, 后缀名为json. 注意这里不写后缀名
    sData   := dwGetStr(joHint,'data','main');

    //
    with TStaticText(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TStaticText(ACtrl) do begin
            sCode   := 'that = this;';

            //
            sCode   := ''
            +'var '+sFull+'__map = L.map("'+sFull+'", {'
                +'zoomControl: false, '         // 不显示缩放控件
                +'attributionControl: false'    // 去除右下角的Leaflet标识
            +'});'
            +'var '+sFull+'__geoJsonLayer ;'

            // 添加OpenStreetMap图层
            //L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            //    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
            //}).addTo([*name*]__map);

            // 美观的颜色方案（根据需求调整颜色）
            +'const colorPalette = ['
                +'"#8FBC8F", "#3CB371", "#2E8B57", "#006400", "#228B22",'
                +'"#ADFF2F", "#9ACD32", "#556B2F", "#6B8E23", "#98FB98",'
                +'"#00FA9A", "#32CD32", "#00FF7F", "#7CFC00", "#228B22"'
            +'];'

            // 为每个区域分配不同的颜色
            +'function getColor(index) {'
                +'return colorPalette[index % colorPalette.length];' // 如果颜色数目不够则循环使用
            +'};'

            // 自定义样式函数
            +'function style(feature, index, neighborColors) {'
                +'let color = getColor(index);'  // 默认颜色

                // 检查相邻区域的颜色，确保不相同
                +'const neighbors = feature.properties.neighbors || [];' // 假设GeoJSON文件中有neighbors属性，表示相邻区域
                +'neighbors.forEach(neighbor => {'
                    +'if (neighborColors[neighbor]) {'
                        // 如果相邻区域有颜色，调整当前区域颜色
                        +'color = adjustColor(color, neighborColors[neighbor]);'
                    +'}'
                +'});'

                // 将当前区域的颜色保存在邻居的颜色记录中
                +'neighborColors[feature.properties.name] = color;'

                +'return {'
                    //+'color: "'+dwColor(dwGetColorFromJson(joHint.bordercolor,clBlack))+'",'    // 边界线颜色
                    +'color: color,'    // 边界线颜色
                    +'weight: '+IntToStr(dwGetInt(joHint,'borderwidth',1))+','       // 边界线宽度设置为1
                    +'opacity: 1,'      // 边界线透明度
                    +'fillOpacity: 1'   // 填充区域的透明度
                +'};'
            +'}'

            // 适当调整颜色，避免与邻居的颜色重复
            +'function adjustColor(color, neighborColor) {'
                // 在此可以定义如何调整颜色，简单的方式是调整亮度或选择另外一种颜色
                +'return color;' // 这里可以自定义颜色调整的逻辑
            +'}'

            // 点击事件，加载对应的区域JSON文件
            +'function onEachFeature(feature, layer) {'
                +'layer.bindTooltip(feature.properties.name, {'
                    +'permanent: true,'
                    +'direction: "center",'
                    +'className: "leaflet-tooltip"'
                +'});'

                // 监听点击事件
                +'layer.on("click", function () {'
                    +'let fileName = feature.properties.id;'  	// 获取区域名称
                    // 如果长度大于2，使用 padEnd 方法将其补齐到6位
                    +'if (fileName.length > 2) {'
                        +'fileName = fileName.padEnd(6, "0");'
                    +'}'
                    +'fileName = "'+sDir+'"+fileName;'
                    +'loadRegionGeoJSON(fileName);'
                +'});'
            +'}'

            // 加载指定区域的GeoJSON文件
            +'function loadRegionGeoJSON(fileName) {'
                // 清空当前地图上的所有层
                +sFull+'__map.eachLayer(function(layer) {'
                    +'if (layer instanceof L.GeoJSON) {'
                        +sFull+'__map.removeLayer(layer);'
                    +'}'
                +'});'

                +'fetch(fileName+".json")'
                    +'.then(response => response.json())'
                    +'.then(geojsonData => {'
                        +'const neighborColors = {};'  // 存储每个区域的颜色
                        +'let index = 0;'  // 每个区域的索引
                        +sFull+'__geoJsonLayer = L.geoJSON(geojsonData, {'
                            +'style: function(feature) {'
                                +'return style(feature, index++, neighborColors);'
                            +'},'
                            +'onEachFeature: onEachFeature'
                        +'}).addTo('+sFull+'__map);'

                        // 获取所有区域的边界并自动调整视图
                        +sFull+'__bounds = '+sFull+'__geoJsonLayer.getBounds();'
                        +sFull+'__map.fitBounds('+sFull+'__bounds);'  // 自动居中并显示所有区域
                    +'})'
                    +'.catch(error => {'
                        +'loadRegionGeoJSON("'+sDir+sData+'");'  // 返回中国地图
                    +'});'
            +'};'

            // 点击空白区域返回上一级
            +sFull+'__map.on("click", function (e) {'
                +'if ('+sFull+'__map.getZoom() === 5) {'
                    +'loadRegionGeoJSON("'+sDir+sData+'");'  // 返回中国地图
                +'}'
            +'});'

            // 使用fetch API读取china.json文件
            +'loadRegionGeoJSON("'+sDir+sData+'");'  // 返回中国地图

            // 使用 ResizeObserver 监听容器大小变化
            +'var resizeObserver = new ResizeObserver(function(entries) {'
                // 检查是否有变化
                +'entries.forEach(function(entry) {'
                    // 如果容器的大小发生变化，调用 invalidateSize() 刷新地图
                    +sFull+'__map.invalidateSize();'
                    //+'console.log("layer:",'+sFull+'__geoJsonLayer);'
                    +'try {'
                        +'var bounds = '+sFull+'__geoJsonLayer.getBounds();'
                        //+'console.log("bounds:",bounds);'
                        +sFull+'__map.fitBounds(bounds);'  // 自动居中并显示所有区域
                    +'}catch (error){'
                    +'};'
                +'});'
            +'});'


            // 开始监听
            +'resizeObserver.observe(document.getElementById("'+sFull+'"));'
            +'';

            joRes.Add(sCode);
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
     dwGetMounted,
     dwGetAction,
     dwGetData;
     
begin
end.
 
