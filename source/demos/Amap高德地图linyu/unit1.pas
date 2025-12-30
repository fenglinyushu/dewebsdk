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
    BtText: TButton;
    Button4: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure BtTextClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button8Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
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


procedure TForm1.BtTextClick(Sender: TObject);
var
    sJS     : string;
begin
    //生成javascript代码字符串(以下为D12才支付的代码格式, 以前的D版本需要修改)
    sJS     :=
            '// 创建纯文本标记'#13#10
            +'var text = new AMap.Text({'#13#10
            +'    text:''纯文本标记'','#13#10
            +'    anchor:''center'', // 设置文本标记锚点'#13#10
            +'    draggable:true,'#13#10
            +'    cursor:''pointer'','#13#10
            +'    angle:10,'#13#10
            +'    style:{'#13#10
            +'        ''padding'': ''.75rem 1.25rem'','#13#10
            +'        ''margin-bottom'': ''1rem'','#13#10
            +'        ''border-radius'': ''.25rem'','#13#10
            +'        ''background-color'': ''white'','#13#10
            +'        ''width'': ''15rem'','#13#10
            +'        ''border-width'': 0,'#13#10
            +'        ''box-shadow'': ''0 2px 6px 0 rgba(114, 124, 245, .5)'','#13#10
            +'        ''text-align'': ''center'','#13#10
            +'        ''font-size'': ''20px'','#13#10
            +'        ''color'': ''blue'''#13#10
            +'    },'#13#10
            +'    position: [118.37845166261107,24.701889134061303]'#13#10
            +'});'#13#10
            +''#13#10
            +'text.setMap(dw_map);';
    //替换掉其中的AMap
    sJs := StringReplace(sJS,'dw_map', dwFullName(Shape1)+'__map',[rfReplaceAll]);
    //
    dwRunJS(sJS,Self);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    dwRunJS(dwFullName(Shape1)+'__map.setZoom('+intToStr(11+Random(7))+');',self);    //随机放大缩小
end;

procedure TForm1.Button2Click(Sender: TObject);
var
    sJS     : string;
    x,y,z,theta: real;
begin

    dwRunJS(dwFullName(Shape1)+'__map.setCenter([118.37845166261107,24.701889134061303]);',self);
     //  dwRunJS(dwFullName(Shape1)+'__map.setZoom('+intToStr(11+Random(7))+');',self);    //随机放大缩小



end;

procedure TForm1.Button3Click(Sender: TObject);
var
    sJS     : string;
begin
    sJS     :=
        //取得缩放数据
        'var zoom = '+dwFullName(Shape1)+'__map.getZoom(); '
        //取得中心点数据
        +'var center = '+dwFullName(Shape1)+'__map.getCenter();'
        //将上述信息组合成成一个json字符串
        //+'console.log(center,zoom);'
        +'var sInfo = ''{"id":1,"zoom":'' +zoom +'',"lng":''+center.lng+'',"lat":''+center.lat+''}'';'


        //+'console.log(sInfo);'
        //发送到后端
        +'dwSetVar(sInfo);'
        +'';
    //
    dwRunJS(sJS,Self);




end;




procedure TForm1.Button4Click(Sender: TObject);
var
    sJS     : string;
begin

    dwRunJS(dwFullName(Shape1)+'__map.setZoom(''18'');',self);    //随机放大缩小

    //生成javascript代码字符串(以下为D12才支付的代码格式, 以前的D版本需要修改)
    sJS     :=
     ' circleMarker = new AMap.CircleMarker({ '
           +'  center: [118.37845166261107,24.901889134061303],'
       +'  radius:10+Math.random()*10,'//3D视图下，CircleMarker半径不要超过64px
       +'  fillColor:''rgba(255,0,0,1)'', '
       +'   fillOpacity:0.5, '
      //' marker = new AMap.Marker({ '
      //+'  icon: "//a.amap.com/jsapi_demos/static/demo-center/icons/poi-marker-default.png", '    //平台图标
      //+'  icon: "media/images/32/a (31).png", ' //本地图标
     // +'  position: [118.375394,24.697602],'
      +'  offset: new AMap.Pixel(-13, -30)  '
      +'});  '
     //+' marker.setMap(dw_map);   ' ;
      +' circleMarker.setMap(dw_map);   ' ;
    //替换掉其中的AMap
    sJs := StringReplace(sJS,'dw_map', dwFullName(Shape1)+'__map',[rfReplaceAll]);

    //
    dwRunJS(sJS,Self);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin

    dwRunJS(dwFullName(Shape1)+'__map.setMapStyle(''amap://styles/normal'');',self); // 设置极夜蓝样式

    //标准（normal）：使用标准样式，可以通过设置地图的mapStyle属性为"amap://styles/normal"来应用。
    //幻影黑（dark）：使用幻影黑样式，设置mapStyle属性为"amap://styles/dark"。
    //涂鸦（graffiti）：使用涂鸦样式，设置mapStyle属性为"amap://styles/graffiti"。
    //酱籽（wine）：使用酱籽样式，虽然在搜索结果中没有直接提到酱籽的样式代码，但通常可以通过"amap://styles/wine"来尝试应用。
    //远山黛（whitesmoke）：使用远山黛样式，设置mapStyle属性为"amap://styles/whitesmoke"。
    //草色青（fresh）：使用草色青样式，设置mapStyle属性为"amap://styles/fresh"。
    //极夜蓝（darkblue）：使用极夜蓝样式，设置mapStyle属性为"amap://styles/darkblue"。


end;

procedure TForm1.Button7Click(Sender: TObject);
begin
    dwRunJS(dwFullName(Shape1)+'__map.setMapStyle(''amap://styles/darkblue'');',self); // 设置极夜蓝样式
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
    dwRunJS(dwFullName(Shape1)+'__map.setMapStyle(''amap://styles/whitesmoke'');',self); // 设置极夜蓝样式
end;

procedure TForm1.FormContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
  var
    sVar        : String;
begin
    sVar:=dwGetProp(Self,'__var');
      //前端dwSetVar时自动触发
    dwMessage(sVar,'',self);

    //取得前端JS发送的数据
    //sVar := dwGetProp(Self,'__var');

    //显示
    //dwMessage('ly:'+sVar,'success',self);
end;


procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
    sJS     : string;
begin
    sJS     :=
          //为地图注册click事件获取鼠标点击出的经纬度坐标
    dwFullName(Shape1)+'__map.on(''click'', function(e) { var text = e.lnglat.getLng() + '','' + e.lnglat.getLat();'
     +'dwSetVar(text);'
    +'});';



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
