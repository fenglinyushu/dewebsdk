unit unit_Pay;

interface

uses
    //deweb基础函数
    dwBase,
    //
    dwCrudPanel,

    //
    Math,
    ComObj,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask,
    Vcl.Samples.Spin, Vcl.ComCtrls, Vcl.Grids, Data.DB, Data.Win.ADODB, Vcl.ExtCtrls, Vcl.Buttons,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TForm_Pay = class(TForm)
    Pn1: TPanel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    qcConfig    : String;
    gsRights    : String;

  end;


implementation

uses
    Unit1;


{$R *.dfm}




procedure TForm_Pay.FormShow(Sender: TObject);
begin

    //创建quickcrud
    cpInit(Pn1,TForm1(Self.Owner).FDConnection1,False,'');


end;

end.
