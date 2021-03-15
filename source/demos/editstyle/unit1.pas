unit unit1;

interface

uses
     //
     dwBase,

     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.MPlayer,
     Vcl.Menus, Vcl.Buttons, Vcl.Samples.Spin, Vcl.Imaging.jpeg,
     Vcl.Imaging.pngimage, VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.Series,
  VCLTee.TeeProcs, VCLTee.Chart, Vcl.WinXCtrls, Vcl.Grids;

type
  TForm1 = class(TForm)
    Edit2: TEdit;
    Edit1: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label1: TLabel;
    Panel1: TPanel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel2: TPanel;
    Edit6: TEdit;
    Edit7: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


end.
