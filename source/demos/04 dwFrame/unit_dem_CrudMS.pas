unit unit_dem_CrudMS;

interface

uses
    dwBase,

    //
    dwCrudPanel,

    //
    Syncommons,

    //
    DateUtils,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
    FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
    FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
    FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
    FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Phys.MSAccDef, FireDAC.Phys.MSSQLDef,
    FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL, FireDAC.Phys.MSSQL,
    FireDAC.Phys.ODBCBase, FireDAC.Phys.MSAcc, Data.DB, FireDAC.Comp.DataSet,
    FireDAC.Comp.Client, Vcl.Grids;

type
  TForm_dem_CrudMS = class(TForm)
    Pn1: TPanel;
    PnB: TPanel;
    PnP: TPanel;
    SlR: TSplitter;
    PnPT: TPanel;
    LaT1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Pn1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
  private
    { Private declarations }
  public
        //权限数据字符串 '["单选题库",1,1,1,1,1,1,1,1,1,1,1,1,1,1]'
        //一般可转换为JSON数组的字符串,0元素为字符串型,模块名称;1元素为可见;2元素为可用; 3~7个元素为:增/删/改/查/导出,1为可用,0为禁用; 后面的为自定义权限
        gsRights : String;
  end;

var
     Form_dem_CrudMS             : TForm_dem_CrudMS;


implementation

uses
    unit1;


{$R *.dfm}

procedure TForm_dem_CrudMS.FormShow(Sender: TObject);
var
    joConfig    : Variant;
    joField     : Variant;
    joRight     : variant;
    iItem       : Integer;
    bOnlySelf   : Boolean;
    sUserId     : String;
begin
    //取得当前用户id
    sUserId := IntToStr(TForm1(self.Owner).gjoUserInfo.id);

    //【出货统计】可以看到人包括:
    //1 权限中可以"查看全部"的人
    //2 当前合同的创建者
    //3 当前合同的生产主管
    //4 当前合同的跟单业务


    //是否看本人数据
    bOnlySelf   := False;

    //限制仅看本人
    joRight     := _json(gsRights);
    if joRight <> unassigned then begin
        if joRight._Count > 9 then begin
            if joRight._(9) = 0 then begin  //查看全部选项
                joConfig        := cpGetConfig(Pn1);
                joConfig.where  :=
                        '(cUserId = '+sUserId+')'               //2 当前出货合同的创建者
                        +' or (cProductionSupervisorId = '+sUserId+')'  //3 当前出货合同的生产主管
                        +' or (cFollowId = '+sUserId+')';               //4 当前出货合同的跟单业务
                //返回写Pn1.Hint
                Pn1.Hint        := joConfig;
                //
                bOnlyself       := True;
            end;
        end;
    end;

    //根据权限判断
    joConfig    := _json(Pn1.Hint);

    //合同 CRUD
    cpInit(Pn1,TForm1(self.Owner).FDConnection1,false,gsRights);
    cpSetOneLine(Pn1);

    //合同中的产品 CRUD
    cpInit(PnP,TForm1(self.Owner).FDConnection1,false,'');
    cpSetOneLine(PnP);

    //
    PnPT.Top    := 0;


end;

procedure TForm_dem_CrudMS.Pn1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
    oFDQuery    : TFDQuery;
    oFDTemp     : TFDQuery;
    iUserId     : Integer;
    iMax        : Integer;
    sSQL        : string;
begin
    iUserId     := dwGetInt(TForm1(self.Owner).gjoUserInfo,'id');
    //
    case X of

        //新增合同后自动生成PI号: HF+业务员编号+年份比如2025年为25+递增的数字，从数据库检索最大的号码+1
        cpAppendPostAfter : begin
            //取得临时FDQuery, 以取得当前年最大数  HF000126003
            oFDTemp     := cpGetFDQueryTemp(Pn1);
            oFDTemp.Open('SELECT Max(SUBSTRING(cPI_NO, 9, 3)) FROM eContract'
                    +' WHERE SUBSTRING(cPI_NO, 1, 8)=''HF'+Format('%.4d%.2d',[iUserId,YearOf(Now) mod 100])+'''');
            if oFDTemp.IsEmpty then begin
                iMax    := 1;
            end else begin
                iMax    := 1 + StrToIntDef(oFDTemp.Fields[0].AsString,0);
            end;

            //取得FDQuery
            oFDQuery    := cpGetFDQuery(Pn1);
            //
            oFDQuery.Edit;
            //自动保存为当前用户id
            oFDQuery.FieldByName('cUserId').AsInteger   := TForm1(self.Owner).gjoUserInfo.id;
            //自动生成pi号
            oFDQuery.FieldByName('cPI_NO').AsString     := 'HF'
                    +Format('%.4d',[iUserId])
                    +Format('%.2d',[YearOf(Now) mod 100])
                    +Format('%.3d',[iMax]);
            oFDQuery.Post;
        end;

    end;
end;

end.
