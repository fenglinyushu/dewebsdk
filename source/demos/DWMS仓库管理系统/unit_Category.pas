unit unit_Category;

interface

uses
    //deweb基础函数
    dwBase,

    //Crud panel
    dwCrudPanel,

    //
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
  TForm_Category = class(TForm)
    P_L: TPanel;
    TV: TTreeView;
    P0: TPanel;
    FDQuery1: TFDQuery;
    Panel1: TPanel;
    BRefresh: TButton;
    procedure FormShow(Sender: TObject);
    procedure BRefreshClick(Sender: TObject);
    procedure TVChange(Sender: TObject; Node: TTreeNode);
  private
    { Private declarations }
  public
    procedure CreateTreeView(FDQuery:TFDQuery;ATable,AID,ANo,AText:String;ATV:TTreeView);
  end;


implementation

uses
    Unit1;

{$R *.dfm}


procedure TForm_Category.BRefreshClick(Sender: TObject);
begin
    CreateTreeView(FDQuery1,'eCategory','cId','cNo','cName',TV);
end;

procedure TForm_Category.CreateTreeView(FDQuery: TFDQuery; ATable,AID,ANo,AText:String;ATV:TTreeView);
var
    sNo         : String;
    sCate0      : String;
    sCate1      : String;
    oTNParent   : TTreeNode;
begin
    try
        //
        FDQuery1.Disconnect();
        FDQuery1.Close;
        FDQuery1.Open('SELECT '+AID+','+ANo+','+AText+' FROM '+ATable+' ORDER By '+ANo);

        //添加根节点
        TV.Items.Clear;
        TV.Items.Add(nil,'所有').StateIndex  := 0;
        //
        while not FDQuery1.Eof do begin
            sNo := FDQuery1.FieldByName(ANo).AsString;
            //
            if Length(sNo) = 1 then begin
                oTNParent   := ATV.Items[0];
                ATV.Items.AddChild(oTNParent,FDQuery1.FieldByName(AText).AsString).StateIndex    := FDQuery1.FieldByName(AId).AsInteger;
            end else if Length(sNo) = 4 then begin
                sCate0  := UpperCase(sNo[1]);
                oTNParent   := ATV.Items[0].Item[Ord(sCate0[1])-Ord('A')];
                if oTNParent <> nil then begin
                    ATV.Items.AddChild(oTNParent,FDQuery1.FieldByName(AText).AsString).StateIndex    := FDQuery1.FieldByName(AId).AsInteger;
                end;
            end else if Length(sNo) = 7 then begin
                sCate0  := UpperCase(sNo[1]);
                sCate1  := Copy(sNo,2,3);
                if StrToIntDef(sCate1,-1)>0 then begin
                    oTNParent   := ATV.Items[0].Item[Ord(sCate0[1])-Ord('A')];
                    if oTNParent <> nil then begin
                        oTNParent   := oTNParent.Item[StrToInt(sCate1)-1];
                        if oTNParent <> nil then begin
                           ATV.Items.AddChild(oTNParent,FDQuery1.FieldByName(AText).AsString).StateIndex    := FDQuery1.FieldByName(AId).AsInteger;
                        end;
                    end;
                end;
            end;
            //
            FDQuery1.Next;
        end;
        //
        ATV.Items[0].Expand(True);
    except

    end;
end;

procedure TForm_Category.FormShow(Sender: TObject);
begin

    //创建Crud数据面板
    cpInit(P0,TForm1(Self.Owner).FDConnection1,False,'');
    cpSetOneLine(P0);

    //
    FDQuery1.Connection := TForm1(Self.Owner).FDConnection1;

    //
    CreateTreeView(FDQuery1,'eCategory','cId','cNo','cName',TV);
end;




procedure TForm_Category.TVChange(Sender: TObject; Node: TTreeNode);
var
    iID     : Integer;
    sNo     : string;
begin
    //
    if Node = nil then begin
        Exit;
    end;

    //
    iID := Node.StateIndex;

    if iID = 0 then begin
        //添加额外的where
        cpSetExtraWhere(P0,'');

        //刷新数据
        cpUpdate(P0,'');
    end else begin
        //查找当前树节点对应的cId
        FDQuery1.Disconnect();
        FDQuery1.Close;
        FDQuery1.Open('SELECT cNO FROM eCategory WHERE cid='+IntToStr(iID));
        sNo := FDQuery1.Fields[0].AsString;

        //添加额外的where
        cpSetExtraWhere(P0,'cNo like '''+sNo+'%''');

        //刷新数据
        cpUpdate(P0,'');
    end;
end;

end.
