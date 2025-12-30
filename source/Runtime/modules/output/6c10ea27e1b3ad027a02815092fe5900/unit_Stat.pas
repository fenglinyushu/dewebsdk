unit unit_Stat;

interface

uses
    //deweb基础函数
    dwBase,
    //deweb操作Access函数
    dwAccess,
    //
    dwSGUnit,

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask,
    Vcl.Samples.Spin, Vcl.ComCtrls, Vcl.Grids, Data.DB, Data.Win.ADODB, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client
  ;

type
  TForm_Stat = class(TForm)
    FDQuery1: TFDQuery;
    Memo1: TMemo;
    procedure FormShow(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
        procedure UpdateData(APage:Integer);
        procedure UpdateInfos;
  end;


implementation

uses
    Unit1;

{$R *.dfm}

procedure TForm_Stat.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
    sV0,sV1     : String;
    sJS         : String;
begin
    //
    Randomize;

    //Get value0 string
    sV0 := 'this.value0=['
        +'{ value: %d, name: ''Search Engine'' },'
        +'{ value: %d, name: ''Direct'' },'
        +'{ value: %d, name: ''Marketing'', selected: true }'
    +'];';
    sV0 := Format(sV0,[Random(1500),Random(1000),Random(1000)]);

    //Get value1 string
    sV1 := 'this.value1=['
        +'{ value: %d, name: ''Baidu'' },'
        +'{ value: %d, name: ''Direct'' },'
        +'{ value: %d, name: ''Email'' },'
        +'{ value: %d, name: ''Google'' },'
        +'{ value: %d, name: ''Union Ads'' },'
        +'{ value: %d, name: ''Bing'' },'
        +'{ value: %d, name: ''Video Ads'' },'
        +'{ value: %d, name: ''Others'' }'
    +'];';
    sV1 := Format(sV1,[Random(1500),Random(1000),Random(1000),Random(1000),Random(1000),Random(1000),Random(1000),Random(1000)]);

    //
    dwRunJS(sV0+sV1,self);

    dwEcharts(Memo1);
end;

procedure TForm_Stat.FormShow(Sender: TObject);
begin
	//
	FDQuery1.Connection	:= TForm1(self.owner).FDConnection1;

end;

procedure TForm_Stat.UpdateData(APage: Integer);
begin
end;

procedure TForm_Stat.UpdateInfos;
var
     I    : Integer;
const
     _SS  : array[0..9] of String=('新','年','快','乐','心','想','事','成','！','！！');
     _SS1 : array[0..9] of String=('一月','二月','三月','四月','五月','六月','七月','八月','九月','十月');
begin
{
     //
     Randomize;
     Series1.Clear;
     Series2.Clear;
     Series5.Clear;
     Series6.Clear;
     Series8.Clear;
     Series9.Clear;
     for I:= 0 to 9 do begin
          Series1.AddY(Random(100),_SS[I]);
          Series2.AddY(Random(110));
          Series5.AddY(Random(100));
          Series6.AddY(Random(100));
          Series8.AddY(Random(100),_SS1[I]);
          Series9.AddY(Random(100),_SS1[I]);
     end;
}
end;

end.
