unit unit_sys_Message;

interface

uses

    //
    dwBase,

    //
    dwCrudPanel,

    //
    SynCommons{用于解析JSON},

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Phys.ODBCDef,
  FireDAC.Phys.MSAccDef, FireDAC.Phys.MSAcc, FireDAC.Phys, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Imaging.pngimage, Vcl.Grids;

type
  TForm_sys_Message = class(TForm)
    FDQuery1: TFDQuery;
    Pn1: TPanel;
    BtAll: TButton;
    procedure FormShow(Sender: TObject);
    procedure Pn1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BtAllClick(Sender: TObject);
  private
  public
		gsRights : string;	//当前用户使用本模块的权限，格式是JSON的数组字符串，形如[1,1,1,1,1,1,0,1,0,1],各元素分别表示：显示/运行/增/删/改/查/打印/预留1/预留2/预留3
        procedure UpdateView;
  end;


implementation

uses
    Unit1;

{$R *.dfm}

procedure TForm_sys_Message.BtAllClick(Sender: TObject);
var
    oFDQuery    : TFDQuery;
begin
    oFDQuery    := cpGetFDQuery(Pn1);
    //
    oFDQuery.First;
    while not oFDQuery.Eof do begin
        oFDQuery.Edit;
        oFDQuery.FieldByName('mStatus').AsString    := '已阅';
        oFDQuery.Post;
        //
        oFDQuery.Next;
    end;
    //
    cpUpdate(Pn1);

    //更新form1中的消息徽章标识
    TForm1(self.Owner).UpdateMessage;
end;

procedure TForm_sys_Message.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    UpdateView;
end;

procedure TForm_sys_Message.FormShow(Sender: TObject);
var
    joConfig    : Variant;
begin
    //只显示本身需要的消息
    joConfig    := cpGetConfig(Pn1);
    joConfig.where := 'mTargetId='+IntToStr(TForm1(self.Owner).gjoUserInfo.id);
    Pn1.Hint    := joConfig;

    //
    cpInit(Pn1,TForm1(self.Owner).FDConnection1,false,gsRights);

    //插入自定义按钮
    cpAddInButtons(Pn1,BtAll);
    BtAll.Left      := 999;
end;

procedure TForm_sys_Message.Pn1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
    oSGD        : TStringGrid;
    oFDQuery    : TFDQuery;
    iRow        : Integer;
begin
    //
    case X of
        cpUpdateAfter, cpInited : begin
            UpdateView;
        end;
        cpDeleteAfter : begin

            //更新form1中的消息徽章标识
            TForm1(self.Owner).UpdateMessage;
        end;
    else
        //处理点击"标志已阅"按钮事件
        if X > 1000 then begin
            //取得行号和按钮index
            iRow    := Y mod 1000;
            //iBtnId  := Y div 1000;

            //取得经费报销表的FDQuery, 并更新表
            oFDQuery    := cpGetFDQuery(Pn1);
            oFDQuery.RecNo  := iRow;
            oFDQuery.Edit;
            oFDQuery.FieldByName('mStatus').AsString    := '已阅';
            oFDQuery.Post;

            //自动选中当前行
            oSGD        := cpGetStringGrid(Pn1);
            oSGD.Row    := iRow;

            //更新当前表的显示
            cpUpdate(Pn1);

            //更新form1中的消息徽章标识
            TForm1(self.Owner).UpdateMessage;

            //弹出成功框
            dwMessage('已阅! "'+oFDQuery.FieldByName('mData').AsString+']','success',self);
        end;
    end;
end;

procedure TForm_sys_Message.UpdateView;
var
    iRow        : Integer;
    oSGD        : TStringGrid;
begin
    //取得表格
    oSGD    := cpGetStringGrid(Pn1);
    //依次更新显示
    for iRow := 1 to oSGD.RowCount - 1 do begin
        if oSGD.Cells[1,iRow] = '' then begin
            break;
        end;
        if oSGD.Cells[7,iRow] = '待阅' then begin
            cpSetCellButtonVisible(Pn1,9,iRow,0,True);
        end else begin
            cpSetCellButtonVisible(Pn1,9,iRow,0,False);
        end;
    end;

end;

end.
