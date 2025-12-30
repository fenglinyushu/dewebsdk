unit unit0;

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
  TForm_Item = class(TForm)
    FDQuery1: TFDQuery;
    Memo1: TMemo;
    procedure FormShow(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
  end;


implementation

uses
    Unit1;

{$R *.dfm}

procedure TForm_Item.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
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

procedure TForm_Item.FormShow(Sender: TObject);
begin
	//
	FDQuery1.Connection	:= TForm1(self.owner).FDConnection1;

end;


end.
