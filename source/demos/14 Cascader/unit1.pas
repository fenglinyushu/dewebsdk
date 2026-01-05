unit unit1;

interface

uses
    //
    dwBase,
    //
    SynCommons,

    //
    Math,Variants,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    DateUtils,SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.Imaging.pngimage,
    Data.DB,
    Data.Win.ADODB, Vcl.DBGrids, Vcl.Samples.Spin, Vcl.Samples.Calendar, Vcl.Buttons,
    FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
    FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
    FireDAC.Comp.Client, Vcl.WinXCtrls;

type
  TForm1 = class(TForm)
    CB_Prov: TComboBox;
    CB_City: TComboBox;
    CB_Dist: TComboBox;
    B_Set: TButton;
    B_Get: TButton;
    L_Prov: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure CB_ProvChange(Sender: TObject);
    procedure CB_CityChange(Sender: TObject);
    procedure B_SetClick(Sender: TObject);
    procedure B_GetClick(Sender: TObject);
  private
    { Private declarations }
  public
    gsMainDir   : String;
    goConnection    : TADOConnection;

    //
    gjoData     : variant;  //总JSON数据
    giProv      : Integer;  //省序号
    giCity      : Integer;  //城市序号
    giDist      : Integer;  //县区序号

    //
    function SetData(AProv,ACity,ADist:String):Integer;

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}



procedure TForm1.B_GetClick(Sender: TObject);
begin
    //显示所选的省/市/区名称
    dwMessage(CB_Prov.Text+' / '+CB_City.Text+' / '+CB_Dist.Text,'success',self);
end;

procedure TForm1.B_SetClick(Sender: TObject);
begin
    //设置当前选项
    SetData('湖北','襄阳市','襄城区');

    //以下是单独选市的方法
    //SetData('陕西','西安市','');

end;

//省 combobox变化时事件
procedure TForm1.CB_ProvChange(Sender: TObject);
var
    joProv      : Variant;
    joCity      : Variant;
    iChild      : Integer;
begin
    //先清空 市 和 区 的可选项
    CB_City.Items.Clear;
    CB_Dist.Items.Clear;

    //取得当前 省 的序号
    giProv  := CB_Prov.ItemIndex;

    //如果不为空，则 根据当前 省 的序号，更新 市 ComboBox的可选项
    if giProv > 0 then begin
        joProv  := gjoData.children._(giProv-1);
        //
        CB_City.Items.Add('');
        for iChild := 0 to  joProv.children._Count - 1 do begin
            joCity  := joProv.children._(iChild);
            //
            CB_City.Items.Add(joCity.label);
        end;
    end;
end;

//市 ComboBox 变化时的事件
procedure TForm1.CB_CityChange(Sender: TObject);
var
    joProv      : Variant;
    joCity      : Variant;
    joDist      : Variant;
    iChild      : Integer;
begin
    // 先清空 区 的可选项
    CB_Dist.Items.Clear;

    //取得当前 市 的序号
    giCity  := CB_City.ItemIndex;

    //如果不为空，则 根据当前 省/市 的序号，更新 区 ComboBox的可选项
    if giCity > 0 then begin
        joProv  := gjoData.children._(giProv-1);
        joCity  := joProv.children._(giCity-1);
        //
        CB_Dist.Items.Add('');
        for iChild := 0 to  joCity.children._Count - 1 do begin
            joDist  := joCity.children._(iChild);
            //
            CB_Dist.Items.Add(joDist.label);
        end;
    end;
end;

function TForm1.SetData(AProv, ACity, ADist: String): Integer;
begin
    Result  := 0;

    //设置 省
    CB_Prov.ItemIndex   := CB_Prov.Items.IndexOf(AProv);
    giProv  := CB_Prov.ItemIndex;
    CB_Prov.OnChange(CB_Prov);

    //设置 市
    CB_City.ItemIndex   := CB_City.Items.IndexOf(ACity);
    giCity  := CB_City.ItemIndex;
    CB_City.OnChange(CB_City);

    //设置 区
    CB_Dist.ItemIndex   := CB_Dist.Items.IndexOf(ADist);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
    iChild  : Integer;
    joProv  : Variant;
begin
    //默认值
    giProv  := -1;
    giCity  := -1;
    giDist  := -1;

    //载入数据
    dwLoadFromJSON(gjoData,gsMainDir+'media/json/china.json');

    //异常处理
    if gjoData = unassigned then begin
        gjoData := _json('{"children":[]}');
    end;

    //先载入省数据
    CB_Prov.Items.Clear;
    CB_Prov.Items.Add('');
    for iChild := 0 to  gjoData.children._Count - 1 do begin
        joProv  := gjoData.children._(iChild);
        //
        CB_Prov.Items.Add(joProv.label);
    end;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    dwSetPCMode(Self);
end;

end.
