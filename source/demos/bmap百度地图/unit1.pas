unit unit1;

interface

uses
     dwBase,
     //
     Math,
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Shape1: TShape;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    Bt1: TButton;
    Bt2: TButton;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure Bt1Click(Sender: TObject);
    procedure FormContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure Bt2Click(Sender: TObject);
  private
    giZoom  : Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
     Form1             : TForm1;


implementation


{$R *.dfm}

function dwfAlignHorzPro(AParent:TPanel;ARowCount:Integer):Integer;
var
    iItem   : Integer;
    iWidth  : Integer;
    iCount  : Integer;
    iHeight : Integer;
    iRow    : Integer;
    iCol    : Integer;
    iLeft   : Integer;
    iTop    : Integer;
begin
    //<异常检测
    //如果子控件为0，则退出
    if AParent.ControlCount = 0 then begin
        Exit;
    end;
    //>

    //控制行数
    if ARowCount<1 then begin
        ARowCount   := 1;
    end;

    //取得每行个数
    iCount  := AParent.ControlCount;
    iCount  := Ceil(iCount / ARowCount);

    //取得每个控件的宽度(此处要求每个子控件的Margins.Left和right相同)
    iWidth  := (AParent.Width  - AParent.Controls[0].Margins.Right) div iCount;

    //取得每个控件的高度(含上下margins)
    iHeight := (AParent.Height  - AParent.Controls[0].Margins.Bottom) div ARowCount;
    //iHeight := iHeight - AParent.Controls[0].Margins.Top - AParent.Controls[0].Margins.Bottom

    //对子控件进行处理
    for iItem := 0 to AParent.ControlCount-1 do begin
        with TPanel(AParent.Controls[iItem]) do begin
            //得出行和列
            iRow    := TabOrder div iCount;
            iCol    := TabOrder mod iCount;
            //设置LTWH
            Align   := alNone;
            Left    := iCol * iWidth + Margins.Left;
            Width   := iWidth - Margins.Left - Margins.Right;
            Top     := iRow * iHeight + Margins.Top;
            Height  := iHeight - Margins.Top - Margins.Bottom;
        end;
    end;
end;


procedure TForm1.Bt1Click(Sender: TObject);
var
    sJS     : string;
begin
    sJS     :=
            dwFullName(Shape1)+'__map.addEventListener(''click'', function(e) {'#13#10
            +'    console.log( e.point );'#13#10
            +'});'#13

            //
            +'';

    dwRunJS(sJS,self);
end;

procedure TForm1.Bt2Click(Sender: TObject);
var
    sJS     : string;
begin
    sJS     := ''
            +dwFullName(Shape1)+'__map.setMapStyle({style: ''dark''});'#13
            //
            +'console.log("AAA");';

    dwRunJS(sJS,self);
end;

procedure TForm1.Button10Click(Sender: TObject);
var
    sJS     : string;
begin
    sJS     :=
		// 绘制线
		'var polyline = new BMap.Polyline(['
		+'	new BMap.Point(116.399, 40.110),'
		+'	new BMap.Point(116.505, 39.980),'
		+'	new BMap.Point(116.423493, 39.907445)'
		+'], {'
		+'	strokeColor: ''#08f'','
		+'	strokeWeight: 5,'
		+'	strokeOpacity: 0.5'
		+'});'
		+dwFullName(Shape1)+'__map.addOverlay(polyline);';

    //
    dwRunJS(sJS,Self);
end;

procedure TForm1.Button11Click(Sender: TObject);
var
    sJS     : string;
begin
    sJS     :=
		// 绘制圆
		'var circle = new BMap.Circle(new BMap.Point(116.404, 40.000), 5000, {'
		+'	strokeColor: ''red'','
		+'	strokeWeight: 2,'
		+'	strokeOpacity: 0.5'
		+'});'
		+dwFullName(Shape1)+'__map.addOverlay(circle);';

    //
    dwRunJS(sJS,Self);

end;

procedure TForm1.Button12Click(Sender: TObject);
var
    sJS     : string;
begin
    sJS     :=
		//'var lushu;'
		// 实例化一个驾车导航用来生成路线
		'var drv = new BMap.DrivingRoute(''北京'', {'
		+'	onSearchComplete: function(res) {'
		+'		if (drv.getStatus() == BMAP_STATUS_SUCCESS) {'
		+'			var plan = res.getPlan(0);'
		+'			var arrPois =[];'
		+'			for(var j=0;j<plan.getNumRoutes();j++){'
		+'				var route = plan.getRoute(j);'
		+'				arrPois= arrPois.concat(route.getPath());'
		+'			}'
		+dwFullName(Shape1)+'__map.addOverlay(new BMap.Polyline(arrPois, {strokeColor: ''#111''}));'
		+dwFullName(Shape1)+'__map.setViewport(arrPois);'
		+'			var fly = ''data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAC0AAAAwCAYAAACFUvPfAA'
        +'AABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAACXBIWXMA'
        +'ACcQAAAnEAGUaVEZAAABWWlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZT'
        +'puczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNS40LjAiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93'
        +'d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm'
        +'91dD0iIgogICAgICAgICAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyI+CiAgICAg'
        +'ICAgIDx0aWZmOk9yaWVudGF0aW9uPjE8L3RpZmY6T3JpZW50YXRpb24+CiAgICAgIDwvcmRmOkRlc2NyaXB0aW9uPg'
        +'ogICA8L3JkZjpSREY+CjwveDp4bXBtZXRhPgpMwidZAAAHTUlEQVRoBdVZa2gcVRQ+Z2b2kewm203TNPQRDSZEE7VP'
        +'1IIoFUFQiig+QS0tqEhLoCJIsUIFQUVBpFQUH/gEtahYlPZHIX981BCbppramjS2Jm3TNNnNupvsZnfmHs+dZCeT7M'
        +'5mM5ugHpjdmfP85txz7z17F+B/SOgGMxFhby94L/tBkfbLUiAaG3HCjS83Nq5A9/SQLxEeewUJN5BCAgliBtCzG6or'
        +'fncDYr42ZqbmaySzikA+QLqZAd/C9ltUwGc6iDzz9eVG3xXoyUD4I3+TLej93uj47bbnRbt1DVohPMmoRm3IKoRBrd'
        +'1DQ0Ebb1FuXYMmQ/QzogszUCHclsbyu2fwFuHBNejI8mAEAE/NwuRFhNauwXjNLP6CProGvRlRB4SuPGhuECpuzcNf'
        +'MJZr0BIBChN0JgcN4pOdQ7HGHP4CMUoCraPoYRxcJjOJl8OrUFF3fkGkzpQszFNJoEnJyIl41gHKow3DiZsdZCWxSw'
        +'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'';'
		+'			lushu = new BMapLib.LuShu('+dwFullName(Shape1)+'__map,arrPois,{'
		+'				defaultContent:"",'//"从天安门到百度大厦"
		+'				autoView:true,'//是否开启自动视野调整，如果开启那么路书在运动过程中会根据视野自动调整
		+'				icon: new BMap.Icon(fly, new BMap.Size(48, 48), { anchor: new BMap.Size(24, 24) }),'
		//+'				//icon  : new BMap.Icon(''media/images/32/user.png'', new BMap.Size(52,26),{anchor : new BMap.Size(27, 13)}),'
		+'				speed: 4500,'
		+'				enableRotation:true,'//是否设置marker随着道路的走向进行旋转
		+'				landmarkPois: ['
		+'				   {lng:116.314782,lat:39.913508,html:''加油站'',pauseTime:2},'
		+'				   {lng:116.315391,lat:39.964429,html:''高速公路收费<div><img src="https://map.baidu.com/img/logo-map.gif"/></div>'',pauseTime:3},'
		+'				   {lng:116.381476,lat:39.974073,html:''肯德基早餐'',pauseTime:2}'
		+'				]'
		+'			});'
		+'		}'
		+'	}'
		+'});'
		+'var start=new BMap.Point(116.404844,39.911836);'
		+'var end=new BMap.Point(116.308102,40.056057); '
		+'drv.search(start, end);';

    //
    dwRunJS(sJS,Self);
end;

procedure TForm1.Button13Click(Sender: TObject);
var
    sJS     : string;
begin
    sJS     := 'lushu.start();';

    //
    dwRunJS(sJS,Self);
end;

procedure TForm1.Button14Click(Sender: TObject);
var
    sJS     : string;
begin
    sJS     := 'lushu.pause();';

    //
    dwRunJS(sJS,Self);
end;

procedure TForm1.Button15Click(Sender: TObject);
var
    sJS     : string;
begin
    sJS     := 'lushu.stop();';

    //
    dwRunJS(sJS,Self);
end;

procedure TForm1.Button16Click(Sender: TObject);
var
    sJS     : string;
begin
    sJS     :=
		'var point = new BMap.Point(116.4074, 39.9042);'

		// 初始化地图，设置中心点坐标和地图级别
		+dwFullName(Shape1)+'__map.centerAndZoom(point, '+IntToStr(giZoom)+');';

    //
    dwRunJS(sJS,Self);

end;

procedure TForm1.Button17Click(Sender: TObject);
var
    sJS     : string;
begin
    Dec(giZoom);
    sJS     :=

		// 初始化地图，设置中心点坐标和地图级别
		dwFullName(Shape1)+'__map.setZoom('+IntToStr(giZoom)+');';

    //
    dwRunJS(sJS,Self);
end;

procedure TForm1.Button18Click(Sender: TObject);
var
    sJS     : string;
begin
    Inc(giZoom);
    sJS     :=

		// 初始化地图，设置中心点坐标和地图级别
		dwFullName(Shape1)+'__map.setZoom('+IntToStr(giZoom)+');';

    //
    dwRunJS(sJS,Self);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    dwRunJS(dwFullName(Shape1)+'__map.addControl(new BMap.NavigationControl());',self);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
    sJS     : string;
begin
    sJS     := dwFullName(Shape1)+'__map.addControl(new BMap.MapTypeControl());'		//地图/卫星/三维
            +dwFullName(Shape1)+'__map.setCurrentCity("北京");'; // 仅当设置城市信息时，MapTypeControl的切换功能才能可用
    //
    dwRunJS(sJS,Self);

end;

procedure TForm1.Button3Click(Sender: TObject);
var
    sJS     : string;
begin
    sJS     :=
        //向地图添加一个缩略图控件
		'var overView = new BMap.OverviewMapControl();'
		+'var overViewOpen = new BMap.OverviewMapControl({isOpen:true, anchor: BMAP_ANCHOR_BOTTOM_RIGHT});'
		+dwFullName(Shape1)+'__map.addControl(overView);'
		+dwFullName(Shape1)+'__map.addControl(overViewOpen);';

    //
    dwRunJS(sJS,Self);
end;

procedure TForm1.Button4Click(Sender: TObject);
var
    sJS     : string;
begin
    sJS     :=
		//一个比例尺控件
		//'var opts = {offset: new BMap.Size(10, 10)};'
		dwFullName(Shape1)+'__map.addControl(new BMap.ScaleControl());';

    //
    dwRunJS(sJS,Self);
end;

procedure TForm1.Button5Click(Sender: TObject);
var
    sJS     : string;
begin
    sJS     :=
		// 创建点标记
		'var marker1 = new BMap.Marker(new BMap.Point(116.402, 39.925));'
		// 在地图上添加点标记
		+dwFullName(Shape1)+'__map.addOverlay(marker1);';

    //
    dwRunJS(sJS,Self);

end;

procedure TForm1.Button6Click(Sender: TObject);
var
    sJS     : string;
begin
    sJS     :=
		// 创建点标记
		'var marker2 = new BMap.Marker(new BMap.Point(116.300, 39.915),{enableDragging: true});'
		// 在地图上添加点标记
		+dwFullName(Shape1)+'__map.addOverlay(marker2);';

    //
    dwRunJS(sJS,Self);
end;

procedure TForm1.Button7Click(Sender: TObject);
var
    sJS     : string;
begin
    sJS     :=
		// 创建图标
		'var myIcon = new BMap.Icon("media/images/32/contact.png", new BMap.Size(52, 26));'
		// 创建Marker标注，使用图标
		+'var pt = new BMap.Point(116.310, 40.000);'
		+'var marker3 = new BMap.Marker(pt, {icon: myIcon});'
		// 将标注添加到地图
		+dwFullName(Shape1)+'__map.addOverlay(marker3);';

    //
    dwRunJS(sJS,Self);

end;

procedure TForm1.Button8Click(Sender: TObject);
var
    sJS     : string;
begin
    sJS     :=
		'var pt4 = new BMap.Point(116.418, 39.910);'
		+'var marker4 = new BMap.Marker(pt4);'
		+dwFullName(Shape1)+'__map.addOverlay(marker4);'
		// 创建信息窗口
		+'var opts = {'
		+'	width: 200,'
		+'	height: 100,'
		+'	title : "故宫博物院" ,' // 信息窗口标题
		+'	message:"这里是故宫" '
		+'};'
		+'var infoWindow = new BMap.InfoWindow(''地址：北京市东城区王府井大街'', opts);'
		// 点标记添加点击事件
		+'marker4.addEventListener(''click'', function () {'
		+dwFullName(Shape1)+'__map.openInfoWindow(infoWindow, pt4);' // 开启信息窗口
		+'});';

    //
    dwRunJS(sJS,Self);
end;

procedure TForm1.Button9Click(Sender: TObject);
var
    sJS     : string;
begin
    sJS     :=
		// 绘制面
		'var polygon = new BMap.Polygon(['
		+'	new BMap.Point(116.227112, 40.020977),'
		+'	new BMap.Point(116.185243, 39.953063),'
		+'	new BMap.Point(116.394226, 39.897988),'
		+'	new BMap.Point(116.401772, 39.921364),'
		+'	new BMap.Point(116.48248, 39.917893)'
		+'], {'
		+'	strokeColor: ''blue'','
		+'	strokeWeight: 2,'
		+'	strokeOpacity: 0.5'
		+'});'
		+dwFullName(Shape1)+'__map.addOverlay(polygon);';

    //
    dwRunJS(sJS,Self);
end;

procedure TForm1.FormContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
var
    sVar        : String;
begin
    //取得前端JS发送的数据
    sVar := dwGetProp(Self,'__var');

    //显示
    dwMessage(sVar,'success',self);

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    giZoom  := 12;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
    sJS     : string;
begin
    sJS     :=
            'var point = new BMap.Point(116.4074, 39.9042);'

            // 初始化地图，设置中心点坐标和地图级别
            +dwFullName(Shape1)+'__map.centerAndZoom(point, '+IntToStr(giZoom)+');'

            //以下为增加鼠标点击地图时, 取当前位置,并发送给该应用, 激活OnContextPopup
            //发送的数据可通过 dwGetProp(Self,'__var') 取得
            +dwFullName(Shape1)+'__map.addEventListener(''click'', function(e) {'#13#10
            +'    console.log( e.point );'#13#10
            +'    dwSetVar( JSON.stringify(e.point) );'#13#10
            +'});'#13

            //暗色主题
            //+dwFullName(Shape1)+'__map.setMapStyle({style: ''dark''});'#13

            //
            +'';

    //
    dwRunJS(sJS,Self);

end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    if (X>600)and(Y>600) then begin
        dwSetPCMode(Self);
        //
        dwfAlignHorzPro(Panel1,1);
    end else begin
        //设置当前屏幕显示模式为移动应用模式.如果电脑访问，则按414x726（iPhone6/7/8 plus）显示
        dwBase.dwSetMobileMode(self,414,736);
        //
        Panel1.Height   := 84;
        //
        dwfAlignHorzPro(Panel1,3);
    end;
end;

end.
