unit unit1;

interface

uses
  dwBase,
  System.Rtti,
  CloneComponents,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Grids, Vcl.ComCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  Vcl.WinXPanels, Vcl.Menus, Data.DB, MemDS, DBAccess, Uni, UniProvider, MySQLUniProvider;
type
    TForm1 = class(TForm)
    PMTitle: TPanel;
    LTitle: TLabel;
    UniQuery1: TUniQuery;
    Label1: TLabel;
    MySQLUniProvider1: TMySQLUniProvider;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Panel2: TPanel;
    Button3: TButton;
    Edit2: TEdit;
    Panel3: TPanel;
    Button4: TButton;
    Edit3: TEdit;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;
implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
    UniQuery1.Prior;
    Edit1.Text  := UniQuery1.FieldByName('ti_cn').AsString;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    UniQuery1.Next;
    Edit1.Text  := UniQuery1.FieldByName('ti_cn').AsString;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
    Edit2.Text := dwGetPublicVar('Form_Unidac','gsMyVar').AsString;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
    dwSetPublicVar('Form_Unidac','gsMyVar',Edit3.Text);
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    dwSetMobileMode(Self,400,900);
    //
    Button1.Width   := Width div 2;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    UniQuery1.Connection    := TUniConnection(dwGetPublicComponent('Form_Unidac','UniConnection1'));
    uniquery1.SQL.Text  := 'SELECT * FROM LiveSport';
    UniQuery1.Open;
    Edit1.Text  := UniQuery1.FieldByName('ti_cn').AsString;
end;

end.
