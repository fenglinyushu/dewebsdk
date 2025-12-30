unit unit1;

interface

uses
    //
    dwBase,

    //
    CloneComponents,

    //
    Math,
    Graphics,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    DateUtils,SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.Imaging.pngimage,
  Data.Win.ADODB, Vcl.DBGrids, Vcl.Samples.Spin, Vcl.Samples.Calendar, Vcl.Buttons,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.WinXCtrls, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.MSAccDef,
  FireDAC.Phys.MSSQLDef, FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL,
  FireDAC.Phys.MSSQL, FireDAC.Phys.ODBCBase, FireDAC.Phys.MSAcc, Vcl.Menus,
  FireDAC.Phys.OracleDef, FireDAC.Phys.Oracle, Vcl.WinXPanels, Vcl.ButtonGroup;

type
  TForm1 = class(TForm)
    Pn1: TPanel;
    Panel1: TPanel;
    Button_Open: TButton;
    Button_Play: TButton;
    Button_Pause: TButton;
    Button_Left: TButton;
    Button_Right: TButton;
    Timer1: TTimer;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Button_OpenClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button_PlayClick(Sender: TObject);
    procedure Button_PauseClick(Sender: TObject);
    procedure Button_LeftClick(Sender: TObject);
    procedure Button_RightClick(Sender: TObject);
  private
    { Private declarations }
  public
        gfLon   : Double;
        gfLat   : Double;
        gfAlt   : Double;
        gfHdg   : Double;

    gsMainDir   : String;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}



procedure TForm1.Button_LeftClick(Sender: TObject);
begin
    gfHdg   := gfHdg - 1;
end;

procedure TForm1.Button_OpenClick(Sender: TObject);
var
    sJS     : String;
begin
    gfLon   := -80;
    gfLat   := 40;
    gfAlt   := 2000;
    gfHdg   := 0;

    //
    sJS     := 'dwcAddEntity('+dwFullName(Pn1)+',1,"media/cesium/f22.glb",'
            +FloatToStr(gfLon)+','
            +FloatToStr(gfLat)+','
            +FloatToStr(gfAlt)+','
            +FloatToStr(gfHdg)+','
            +'0,0,128,20000);';
    sJS     := sJS + 'dwcSelect('+dwFullName(Pn1)+',1);';
    //
    dwRunJS(sJS,self);

    //
    Button_Play.Enabled     := True;
    Button_Pause.Enabled    := True;
    Button_Left.Enabled     := True;
    Button_Right.Enabled    := True;


end;

procedure TForm1.Button_PauseClick(Sender: TObject);
begin
    Timer1.DesignInfo   := 0;

end;

procedure TForm1.Button_PlayClick(Sender: TObject);
begin
    Timer1.DesignInfo   := 1;
end;

procedure TForm1.Button_RightClick(Sender: TObject);
begin
    gfHdg   := gfHdg + 1;

end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    dwSetPCMode(Self);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
    sJS     : string;
    sFull   : string;
begin
    sFull   := dwFullName(Pn1);
    gfLon   := gfLon + 150 / 3.6 /108000 * sin(gfHdg/180*PI);
    gfLat   := gfLat + 150 / 3.6 /108000 * cos(gfHdg/180*PI);
    sJS     := sJS + 'dwcSet6D('+sFull+',1,'
            +FloatToStr(gfLon)+','
            +FloatToStr(gfLat)+','
            +FloatToStr(gfAlt)+','
            +FloatToStr(gfHdg)+','
            +'0,0);';
(*
    sJS := sJS
            // 获取实体ID为1的实体对象'
            +#13'var entity = '+sFull+'.entities.getById("1");'

            +#13'if (entity) {'
                // 获取目标实体的位置
                +#13'var targetPosition = entity.position.getValue(Cesium.JulianDate.now());'

                // 设置摄像机相对于目标实体的位置
                +#13'var cameraOffset = new Cesium.Cartesian3(-2000, 0, 6000);'

                // 计算摄像机的位置
                +#13'var cameraPosition = Cesium.Cartesian3.add(targetPosition, cameraOffset, new Cesium.Cartesian3());'

                // 设置摄像机的朝向，使其始终朝向目标实体
                +#13'var cameraDirection = Cesium.Cartesian3.subtract(targetPosition, cameraPosition, new Cesium.Cartesian3());'
                +#13'Cesium.Cartesian3.normalize(cameraDirection, cameraDirection);'

                // 设置摄像机的上方向
                +#13'var up = new Cesium.Cartesian3(0, 0, 1); '

                // 创建摄像机视图'
                +#13''+sFull+'.camera.setView({'
                    +#13'destination: cameraPosition,'
                    +#13'orientation: {'
                        +#13'direction: cameraDirection,'
                        +#13'up: up'
                    +#13'}'
                +#13'});'
            +#13'} else {'
                +#13'console.error("Entity with ID 1 not found");'
            +#13'};';
*)

    //
    dwRunJS(sJS,self);

end;

end.
