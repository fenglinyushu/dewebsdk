unit unit1;

interface

uses
  dwBase,
  //
  dwCrudPanel,

  //
  System.Rtti,
  CloneComponents,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Grids, Vcl.ComCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  Vcl.WinXPanels, Vcl.Menus, Data.DB,  FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.MSAccDef, FireDAC.Phys.ODBCBase,
  FireDAC.Phys.MSAcc, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet;
type
    TForm1 = class(TForm)
    PMaster: TPanel;
    FDConnection1: TFDConnection;
    FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink;
    PBanner: TPanel;
    Label2: TLabel;
    Im: TImage;
    PClient: TPanel;
    Memo1: TMemo;
    Button1: TButton;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure PMasterDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure Button1Click(Sender: TObject);
  private
  public

    //浏览器历史控制单元
    gjoHistory  : Variant;
  end;

var
  Form1: TForm1;
implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
    cpSetControlEnabled(PMaster,'edit',false);
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    //设置当前为电脑模式
    dwSetPCMode(Self);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    //初始化CrudPanel
    cpInit(PMaster,FDConnection1,false,'');

end;

procedure TForm1.PMasterDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
    oFdQuery    : TFDQuery;
begin

    case X of
        //
        cpInited : begin
            Memo1.Lines.Add(Format('X=%d,Y=%d. %s',[X,Y,'cpInited']));
        end;
        cpPageNo  : begin
            Memo1.Lines.Add(Format('X=%d,Y=%d. %s',[X,Y,'cpPageNo']));
        end;
        cpMode  : begin
            Memo1.Lines.Add(Format('X=%d,Y=%d. %s',[X,Y,'cpMode']));
        end;

        //
        cpNew  : begin
            Memo1.Lines.Add(Format('X=%d,Y=%d. %s',[X,Y,'cpNew']));
        end;
        cpDelete  : begin
            Memo1.Lines.Add(Format('X=%d,Y=%d. %s',[X,Y,'cpDelete']));
        end;
        cpEdit  : begin
            Memo1.Lines.Add(Format('X=%d,Y=%d. %s',[X,Y,'cpEdit']));
        end;
        cpQuery : begin
            Memo1.Lines.Add(Format('X=%d,Y=%d. %s',[X,Y,'cpQuery']));
        end;
        cpReset : begin
            Memo1.Lines.Add(Format('X=%d,Y=%d. %s',[X,Y,'cpReset']));
        end;

        //通用事件
        cpDataScroll : begin
            Memo1.Lines.Add(Format('X=%d,Y=%d. %s',[X,Y,'cpDataScroll']));
        end;
        cpAppendBefore : begin
            Memo1.Lines.Add(Format('X=%d,Y=%d. %s',[X,Y,'cpAppendBefore']));
        end;
        cpAppendAfter : begin
            Memo1.Lines.Add(Format('X=%d,Y=%d. %s',[X,Y,'cpAppendAfter']));
        end;
        cpAppendPostBefore : begin
            Memo1.Lines.Add(Format('X=%d,Y=%d. %s',[X,Y,'cpAppendPostBefore']));
        end;
        cpAppendPostAfter : begin
            Memo1.Lines.Add(Format('X=%d,Y=%d. %s',[X,Y,'cpAppendPostAfter']));
        end;
        cpCancelBefore : begin
            Memo1.Lines.Add(Format('X=%d,Y=%d. %s',[X,Y,'cpCancelBefore']));
        end;
        cpCancelAfter : begin
            Memo1.Lines.Add(Format('X=%d,Y=%d. %s',[X,Y,'cpCancelAfter']));
        end;
        cpDeleteBefore : begin
            Memo1.Lines.Add(Format('X=%d,Y=%d. %s',[X,Y,'cpDeleteBefore']));
        end;
        cpDeleteAfter : begin
            Memo1.Lines.Add(Format('X=%d,Y=%d. %s',[X,Y,'cpDeleteAfter']));
        end;
    end;
end;

end.
