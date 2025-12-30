unit unit_sys_User;

interface

uses
    //deweb基础函数
    dwBase,

    //deweb快速增删改查单元
    //dwQuickCrud,
    dwCrudPanel,

    //基础单元
    dwfBase,

    //
    SynCommons,

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask,
    Vcl.Samples.Spin, Vcl.ComCtrls, Vcl.Grids, Data.DB, Data.Win.ADODB, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TForm_sys_User = class(TForm)
    Pn1: TPanel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
        gsRight : string;
  end;


implementation

uses
    Unit1;

{$R *.dfm}



procedure TForm_sys_User.FormShow(Sender: TObject);
begin
    //UpdateView;
    cpInit(Pn1,TForm1(Self.Owner).FDConnection1,TForm1(self.Owner).gbMobile,'');
end;






end.
