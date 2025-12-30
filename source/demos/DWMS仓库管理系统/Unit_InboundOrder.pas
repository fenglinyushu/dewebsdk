unit Unit_InboundOrder;

interface

uses
     dwBase,
     dwDB,
     dwCrudPanel,
     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Phys.MSAccDef, FireDAC.Phys.MSSQLDef,
  FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL, FireDAC.Phys.MSSQL,
  FireDAC.Phys.ODBCBase, FireDAC.Phys.MSAcc, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Samples.Spin, Vcl.ComCtrls;

type
  TForm_InboundOrder = class(TForm)
    PMain: TPanel;
    FQ0: TFDQuery;
    PT0: TPanel;
    Panel3: TPanel;
    La1: TLabel;
    Panel4: TPanel;
    La2: TLabel;
    PT1: TPanel;
    Panel5: TPanel;
    La3: TLabel;
    CbS: TComboBox;
    Panel8: TPanel;
    La4: TLabel;
    CBW: TComboBox;
    EtNo: TEdit;
    dt1: TDateTimePicker;
    PB8: TPanel;
    Panel10: TPanel;
    La5: TLabel;
    CBP: TComboBox;
    Panel11: TPanel;
    La6: TLabel;
    CBC: TComboBox;
    PaFrame: TPanel;
    PaAdd: TPanel;
    PaGoods: TPanel;
    Panel1: TPanel;
    BuAOK: TButton;
    SEAQuantity: TSpinEdit;
    Label7: TLabel;
    Label8: TLabel;
    PnB: TPanel;
    BtSubmit: TButton;
    BtAdd: TButton;
    FQTemp: TFDQuery;
    FQGoods: TFDQuery;
    BtACancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure PMainDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure BtACancelClick(Sender: TObject);
    procedure BtAddClick(Sender: TObject);
    procedure BuAOKClick(Sender: TObject);
    procedure BtSubmitClick(Sender: TObject);
    procedure CbSChange(Sender: TObject);
    procedure CBWChange(Sender: TObject);
    procedure CBPChange(Sender: TObject);
    procedure CBCChange(Sender: TObject);
  private
    { Private declarations }
  public
    gsCanvasId  : string;
  end;

var
    Form_InboundOrder  : TForm_InboundOrder;


implementation

uses
    unit1;


{$R *.dfm}

procedure TForm_InboundOrder.BtSubmitClick(Sender: TObject);
var
    oFQMain     : TFDQuery;
    iOrderId    : Integer;
begin
    //编号不能为空
    if Trim(EtNo.Text) = '' then begin
        dwMessage('单据编号不能为空!','error',self);
        Exit;
    end;
    //供应商不能为空
    if Trim(CBS.Text) = '' then begin
        dwMessage('供应商不能为空!','error',self);
        Exit;
    end;
    //仓库不能为空
    if Trim(CBW.Text) = '' then begin
        dwMessage('仓库不能为空!','error',self);
        Exit;
    end;
    //操作人不能为空
    if Trim(CBP.Text) = '' then begin
        dwMessage('操作人不能为空!','error',self);
        Exit;
    end;
    //核单人不能为空
    if Trim(CBC.Text) = '' then begin
        dwMessage('核单人不能为空!','error',self);
        Exit;
    end;

    //
    oFQMain := cpGetFDQuery(PMain);

    //
    if oFQMain.IsEmpty then begin
        dwMessage('入库商品不能为空!','error',self);
        Exit;
    end;

    //将当前入库单数据(单条记录)写入 入库单数据表
    FQ0.Close;
    FQ0.SQL.Text := 'INSERT INTO eInboundOrder(iUserId,iNo,iDate,iSupplierId,iWareHouseId,iHandlerId,iVerifierId,iCanvasId)'
        +' OUTPUT inserted.iId'
        +' VALUES(%d,''%s'',%s,%d,%d,%d,%d,''%s'')';
    FQ0.SQL.Text   := Format(FQ0.SQL.Text,[
            Integer(TForm1(self.Owner).gjoUserInfo.id),
            EtNo.Text,
            QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now)),
            CBS.Tag,
            CBW.Tag,
            CBP.Tag,
            CBC.Tag,
            gsCanvasID
            ]);
    FQ0.Open;

    //取得订单 id
    iOrderId    := FQ0.Fields[0].AsInteger;

    //将入库单的商品详情写入 入库单 详情表
    FQ0.Close;
    FQ0.SQL.Text := 'INSERT INTO eInboundOrderdetail (dOrderID,dGoodsId,dQuantity,dPrice,dAmount)'
            +' SELECT :OrderId,tgid,tQuantity,tgInPrice,tAmount FROM eInboundOrdertemp WHERE tCanvasID='''+gsCanvasID+'''';
    FQ0.Params.ParamByName('OrderId').Value := iOrderId;
    FQ0.ExecSQL;

    //<将入库单的商品详情更新 库存表eGoods (如果仓库一致,则增加数量;如果不一致,则增加记录)
    FQTemp.Disconnect();
    FQTemp.close;
    FQTemp.Open('SELECT * FROM eInboundOrderTemp WHERE tCanvasID='''+gsCanvasID+'''');
    while not FQTemp.Eof do begin
        //
        FQGoods.Disconnect();
        FQGoods.close;
        FQGoods.Open('SELECT gid,gQuantity FROM eGoods '
            +' WHERE (gName='''+FQTemp.FieldByName('tgName').AsString+''') and (gCode='''+FQTemp.FieldByName('tgCode').AsString+''')'
            +' and (gWareId='+IntToStr(CBW.Tag)+') and (gSupplierId='+IntToStr(CBS.Tag)+')');
        //如果不存在id和仓库一致的情况,则增加一条记录
        if FQGoods.IsEmpty then begin
            FQGoods.Disconnect();
            FQGoods.close;
            FQGoods.SQL.Text    := 'INSERT INTO dbo.eGoods(gActive,gName,gCode,gCategoryid,gGrade,gBrand,'
                +'gSpecification,gPhoto,gUnit,gInPrice,gOutPrice,gQuantity,gAlertQuantity,'
                +'gDescription,gCreateTime,gUpdateTime,gSupplierId,gWareId)'
                +'VALUES (1,:Name,:Code,:Categoryid,:Grade,:Brand,'
                +':Spec,:Photo,:Unit,:InPrice,:OutPrice,:Quantity,:AlertQ,'
                +':Description,:CreateTime,:UpdateTime,:SupplierId,:WareId)';
            FQGoods.Params.ParamByName('Name').Value        := FQTemp.FieldByName('tgName').AsString;
            FQGoods.Params.ParamByName('Code').Value        := FQTemp.FieldByName('tgCode').AsString;
            FQGoods.Params.ParamByName('CategoryId').Value  := FQTemp.FieldByName('tgCategoryId').AsString;
            FQGoods.Params.ParamByName('Grade').Value       := FQTemp.FieldByName('tgGrade').AsString;
            FQGoods.Params.ParamByName('Brand').Value       := FQTemp.FieldByName('tgBrand').AsString;
            //
            FQGoods.Params.ParamByName('Spec').Value        := FQTemp.FieldByName('tgSpecification').AsString;
            FQGoods.Params.ParamByName('Photo').Value       := FQTemp.FieldByName('tgPhoto').AsString;
            FQGoods.Params.ParamByName('Unit').Value        := FQTemp.FieldByName('tgUnit').AsString;
            FQGoods.Params.ParamByName('InPrice').Value     := FQTemp.FieldByName('tgInPrice').AsFloat;
            FQGoods.Params.ParamByName('OutPrice').Value    := FQTemp.FieldByName('tgOutPrice').AsFloat;
            FQGoods.Params.ParamByName('Quantity').Value    := FQTemp.FieldByName('tQuantity').AsInteger;
            FQGoods.Params.ParamByName('AlertQ').Value      := FQTemp.FieldByName('tgAlertQuantity').AsInteger;
            //
            FQGoods.Params.ParamByName('Description').Value := FQTemp.FieldByName('tgDescription').AsString;
            FQGoods.Params.ParamByName('CreateTime').Value  := FQTemp.FieldByName('tgCreateTime').AsDateTime;
            FQGoods.Params.ParamByName('UpdateTime').Value  := Now;
            FQGoods.Params.ParamByName('SupplierId').Value  := CBS.Tag;
            FQGoods.Params.ParamByName('WareId').Value      := CBW.Tag;
            //
            FQGoods.ExecSQL;
        end else begin
            //如果存在id和仓库一致的情况,则直接增加数量
            FQGoods.Edit;
            FQGoods.FieldByName('gQuantity').AsInteger  := FQGoods.FieldByName('gQuantity').AsInteger + FQTemp.FieldByName('tQuantity').AsInteger;
            FQGoods.Post;
        end;

        //
        FQTemp.Next;
    end;
    //>


    //删除当前入库单内的数据记录
    FQ0.Close;
    FQ0.SQL.Text := 'DELETE FROM eInboundOrderTemp WHERE tCanvasID='''+gsCanvasID+'''';
    FQ0.ExecSQL;

    //刷新入库单面板
    cpUpdate(PMain,'');


    //
    dwMessage('*****     入库成功!     *****','success',self);

end;

procedure TForm_InboundOrder.BtACancelClick(Sender: TObject);
begin
    PaAdd.Visible   := False;
end;

procedure TForm_InboundOrder.BtAddClick(Sender: TObject);
begin
    PaAdd.Visible   := True;

end;

procedure TForm_InboundOrder.BuAOKClick(Sender: TObject);
var
    oFQAdd      : TFDQuery;

begin
    //取得数据查询组件
    oFQAdd      := cpGetFDQuery(PaGoods);

    //异常检测
    if SEAQuantity.Value <= 0 then begin
        dwMessage('入库数量不能为0!','error',self);
        Exit;
    end;
    if oFQAdd.IsEmpty then begin
        dwMessage('必须选择一种商品!','error',self);
        Exit;
    end;

    //添加当前商品到入库单中
    FQ0.Disconnect();
    FQ0.Close;
    FQ0.SQL.Text := 'INSERT INTO eInboundOrderTemp (tgId,tgName,tgCode,tgCategoryId,tgGrade,tgBrand,tgSpecification,'
            +'tgPhoto,tgUnit,tgInPrice,tgOutPrice,tgAlertQuantity,tgDescription,tgCreateTime,tQuantity,tAmount,tCanvasID,tAddDateTime)'
            +'VALUES (:Id,:Name,:Code,:CategoryId,:Grade,:Brand,:Spec,'
            +':Photo,:Unit,:InPrice,:OutPrice,:AlertQ,:Description,:CreateTime,:Quantity,:Amount,:CanvasID,:AddDateTime)';
    FQ0.Params.ParamByName('Id').Value          := oFQAdd.FieldByName('gId').AsInteger;
    FQ0.Params.ParamByName('Name').Value        := oFQAdd.FieldByName('gName').AsString;
    FQ0.Params.ParamByName('Code').Value        := oFQAdd.FieldByName('gCode').AsString;
    FQ0.Params.ParamByName('CategoryId').Value  := oFQAdd.FieldByName('gCategoryId').AsString;
    FQ0.Params.ParamByName('Grade').Value       := oFQAdd.FieldByName('gGrade').AsString;
    FQ0.Params.ParamByName('Brand').Value       := oFQAdd.FieldByName('gBrand').AsString;
    FQ0.Params.ParamByName('Spec').Value        := oFQAdd.FieldByName('gSpecification').AsString;
    FQ0.Params.ParamByName('Photo').Value       := oFQAdd.FieldByName('gPhoto').AsString;
    FQ0.Params.ParamByName('Unit').Value        := oFQAdd.FieldByName('gUnit').AsString;
    FQ0.Params.ParamByName('InPrice').Value     := oFQAdd.FieldByName('gInPrice').AsFloat;
    FQ0.Params.ParamByName('OutPrice').Value    := oFQAdd.FieldByName('gOutPrice').AsFloat;
    FQ0.Params.ParamByName('AlertQ').Value      := oFQAdd.FieldByName('gAlertQuantity').AsInteger;
    FQ0.Params.ParamByName('Description').Value := oFQAdd.FieldByName('gDescription').AsString;
    FQ0.Params.ParamByName('CreateTime').Value  := oFQAdd.FieldByName('gCreateTime').AsDateTime;
    FQ0.Params.ParamByName('Quantity').Value    := SEAQuantity.Value;
    FQ0.Params.ParamByName('Amount').Value      := oFQAdd.FieldByName('gInPrice').AsFloat*SEAQuantity.Value;
    FQ0.Params.ParamByName('CanvasID').Value    := gsCanvasId;
    FQ0.Params.ParamByName('AddDateTime').Value := Now; //写入一个添加时间, 用于定时清除过期的记录
    //
    FQ0.ExecSQL;


    //刷新入库单面板
    cpUpdate(PMain,'');

    //关闭添加商品面板
    SEAQuantity.Value   := 0;

    //
    dwMessage('-----     添加商品成功!     -----','success',self);

end;

procedure TForm_InboundOrder.CBCChange(Sender: TObject);
begin
    //说明:当选择时,自动设置其tag为对应的id

    //
    if Trim(CBC.Text) = '' then begin
        CBC.Tag     := -1;
    end else begin
        FQ0.Disconnect();
        FQ0.Close;
        FQ0.Open('SELECT uId FROM eUser WHERE uName='''+CBC.Text+'''');
        CBC.Tag := FQ0.Fields[0].AsInteger;
    end;

end;

procedure TForm_InboundOrder.CBPChange(Sender: TObject);
begin
    //说明:当选择时,自动设置其tag为对应的id

    //
    if Trim(CBP.Text) = '' then begin
        CBP.Tag     := -1;
    end else begin
        FQ0.Disconnect();
        FQ0.Close;
        FQ0.Open('SELECT uId FROM eUser WHERE uName='''+CBP.Text+'''');
        CBP.Tag := FQ0.Fields[0].AsInteger;
    end;

end;

procedure TForm_InboundOrder.CbSChange(Sender: TObject);
begin
    //说明:当选择时,自动设置其tag为对应的id

    //
    if Trim(CBS.Text) = '' then begin
        CBS.Tag     := -1;
    end else begin
        FQ0.Disconnect();
        FQ0.Close;
        FQ0.Open('SELECT sId FROM eSupplier WHERE sName='''+CBS.Text+'''');
        CBS.Tag := FQ0.Fields[0].AsInteger;
    end;
end;

procedure TForm_InboundOrder.CBWChange(Sender: TObject);
begin
    //说明:当选择时,自动设置其tag为对应的id

    //
    if Trim(CBW.Text) = '' then begin
        CBW.Tag     := -1;
    end else begin
        FQ0.Disconnect();
        FQ0.Close;
        FQ0.Open('SELECT wId FROM eWareHouse WHERE wName='''+CBW.Text+'''');
        CBW.Tag := FQ0.Fields[0].AsInteger;
    end;

end;

procedure TForm_InboundOrder.FormShow(Sender: TObject);
begin
    //设置查询组件连接
    FQ0.Connection      := TForm1(self.Owner).FDConnection1;
    FQTemp.Connection   := TForm1(self.Owner).FDConnection1;
    FQGoods.Connection  := TForm1(self.Owner).FDConnection1;

    //<先删除所有eInboundOrderTemp表中所有同canvasid的记录
    //取得canvasid（浏览器唯一值）
    gsCanvasID  := TForm1(self.Owner).gjoUserInfo.canvasid;
    //删除记录
    FQ0.Close;
    FQ0.SQL.Text := 'DELETE FROM eInboundOrderTemp WHERE tCanvasID='''+gsCanvasID+'''';
    FQ0.ExecSQL;
    //>


    //设置只显当前浏览器canvasid的记录
    PMain.Hint  := StringReplace(PMain.Hint,'''xxxxx''',''''+gsCanvasID+'''',[]);

    //初始化 入库单表面板
    cpInit(PMain,TForm1(self.Owner).FDConnection1,False,'');

    //初始化 待添加商品面板
    cpInit(PaGoods,TForm1(self.Owner).FDConnection1,False,'');

    //添加选项
    dwGetComboBoxItems(FQ0,'eSupplier','sName',true,CBS);
    dwGetComboBoxItems(FQ0,'eWareHouse','wName',true,CBW);
    dwGetComboBoxItems(FQ0,'eUser','uName',true,CBP);
    dwGetComboBoxItems(FQ0,'eUser','uName',true,CBC);

    //生成默认编号
    EtNo.Text   := 'RK'+FormatDateTime('YYYYMMDDhhmmsszzz',Now);

end;

procedure TForm_InboundOrder.PMainDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
begin
    if X>=1000 then begin
        // 列中按钮的自定义事件 OnDragOver中，X-1000为列序号，Y mod 1000为行序号，Y div 1000为按钮序号
        //dwMessage(Format('ButtonClick Col=%d,Row=%d,BtnId=%d',[X-1000,Y mod 1000,Y div 1000]),'success',self);
        //PaModal.Visible := True;
    end;

end;

end.
