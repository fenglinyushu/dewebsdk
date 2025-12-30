unit unit_User;

interface

uses
    //deweb基础函数
    dwBase,

    //deweb快速增删改查单元
    dwCrudPanel,

    //dwframe基础单元
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
  TForm_User = class(TForm)
    FQ1: TFDQuery;
    P_L: TPanel;
    TV: TTreeView;
    Pn1: TPanel;
    procedure FormShow(Sender: TObject);
    procedure TVChange(Sender: TObject; Node: TTreeNode);
    procedure Pn1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
  private
    { Private declarations }
  public
        gjoDept     : Variant;  //部门表的JSON
        giPID       : Integer;  //父节点ID
        function  GetNodedId(ANode:TTreeNode):String;
        procedure UpdateView;
  end;


implementation

uses
    Unit1;

{$R *.dfm}

function  TForm_User.GetNodedId(ANode:TTreeNode):String;
var
    iItem       : Integer;
    iIds        : array of Integer;
    joNode      : Variant;
begin
    //生成树的层次index序列
    SetLength(iIds,ANode.Level);
    while ANode.Level>0 do begin
        iIds[ANode.Level-1] := ANode.Index;
        ANode  := ANode.Parent;
    end;

    //取得对应的JSOn
    joNode  := gjoDept._(0);
    for iItem := 0 to High(iIds) do begin
        joNode  := joNode.children._(iIds[iItem]);
    end;

    //取得当前节点对应数据表记录的did
    Result  := joNode.id;
end;


procedure TForm_User.Pn1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
    FQ1         : TFDQuery;
    tnNode      : TTreeNode;
    sDID        : String;
begin
    if X = dwCrudpanel.cpAppendAfter then begin
        tnNode  := TV.Selected;
        if tnNode = nil then begin
            tnNode  := TV.Items[0];
        end;
        //
        sDID    := GetNodeDID(tnNode);

        //
        FQ1 := cpGetFDQuery(Pn1);
        FQ1.FieldByName('uDepartment').AsString := sDID;
    end;
end;

procedure TForm_User.UpdateView;
var
    iItem       : Integer;
    tnNode      : TTreeNode;
    sName       : String;
    sDId        : String;
    //
    joPair      : Variant;
    joValue     : Variant;
begin
    //将单位表eDepartment转化为JSON
    gjoDept     :=  cpDbToTreeListJson(FQ1,'eDepartment','dId','dName','',-1);

    //将JSON转换化表
    cpTreeListJsonToTV(gjoDept,TV);

    //全部展开
    TV.Items[0].Expand(True);

    //生成 单位did 与单位名称的键值对
    joPair  := _json('[]');
    for iItem := 0 to TV.Items.Count - 1 do begin

        //得到树节点
        tnNode  := TV.Items[iItem];

        //得到单位ID
        sDID    := '0'+IntToStr(tnNode.StateIndex);

        //生成多级单位名称，如: 总公司 ->  西安分公司 -> 研发部
        sName   := tnNode.Text;
        while tnNode.Level>1 do begin
            tnNode  := tnNode.Parent;
            sName   := tnNode.Text+' -> '+sName;
        end;

        //转换JSON
        joValue := _json('[]');
        joValue.Add(sName);
        joValue.Add(sDID);

        //添加到键值对数组
        joPair.Add(joValue);
    end;


end;

procedure TForm_User.FormShow(Sender: TObject);
begin
    //设置当前数据库连接
    FQ1.Connection := TForm1(Self.Owner).FDConnection1;
    UpdateView;

    //创建quickcrud
    cpInit(Pn1,TForm1(Self.Owner).FDConnection1,False,'');
end;



procedure TForm_User.TVChange(Sender: TObject; Node: TTreeNode);
var
    sdId        : String;
    sWhere      : String;
    tnNode      : TTreeNode;
begin
    //
    tnNode  := TV.Selected;

    if tnNode = nil then begin
        Exit;
    end;

    sdId    := GetNodeDID(tnNode);
    sWhere  := '(uDepartment like '''+sdId+'%'')';

    //增加一个额外的条件
    cpSetExtraWhere(Pn1,sWhere);

    //刷新数据
    cpUpdate(Pn1, '');
end;

end.
