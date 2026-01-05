unit unit1;

interface

uses
    //
    dwBase,
    dwSGUnit,

    //
    CloneComponents,
    SynCommons,

    //
    Math,
    Graphics,strutils,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.Buttons,  Vcl.ComCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.MySQLDef,
  FireDAC.Phys.MySQL, Data.DB, FireDAC.Comp.Client;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
  private
    { Private declarations }
  public
    gsMainDir   : String;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


end.
