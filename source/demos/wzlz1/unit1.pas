unit unit1;

interface

uses
     //
     dwBase,

     //
     JsonDataObjects,

     //
     Math,
     windows, sysutils,
     Vcl.Controls, Vcl.Forms, Data.DB, Data.Win.ADODB, Vcl.StdCtrls,
     Vcl.ExtCtrls, Vcl.Imaging.pngimage, System.Classes, Vcl.Buttons;

type
  TForm1 = class(TForm)
    ADOQuery: TADOQuery;
    Image_Logo: TImage;
    Panel_99_Buttons: TPanel;
    Panel_98_Line: TPanel;
    Panel1: TPanel;
    Label1: TLabel;
    ComboBox_Products: TComboBox;
    Panel2: TPanel;
    Label2: TLabel;
    Panel3: TPanel;
    Label3: TLabel;
    ComboBox_Users: TComboBox;
    Button_OK: TButton;
    Panel4: TPanel;
    Button_Cancel: TButton;
    Label_Detail: TLabel;
    ComboBox_Ware1: TComboBox;
    Label_Ware2: TLabel;
    ComboBox_Ware2: TComboBox;
    Edit_WareDetail: TEdit;
    Panel5: TPanel;
    Label6: TLabel;
    Edit_Memo: TEdit;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox_Ware1Change(Sender: TObject);
    procedure Button_OKClick(Sender: TObject);
    procedure Button_CancelClick(Sender: TObject);
  private
    { Private declarations }
  public
     gjoWareHouse : TJsonObject;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.Button_CancelClick(Sender: TObject);
begin
     //使用默认的标题和按钮
     dwShowMessage('已取消！',self);
end;

procedure TForm1.Button_OKClick(Sender: TObject);
var
     sProdID   : String;
     sProdName : string;
     sProdModl : string;
     sProdPic  : string;
     //
     dtData    : TDateTime;
     //
     joData    : TJsonObject;
begin
     //得到物品ID，置当前物品为状态为1
     ADOQuery.Close;
     ADOQuery.SQL.Text   := 'SELECT AName,Model,SeriesNO,ID,State,Picture FROM wzProducts WHERE State=0';
     ADOQuery.Open;
     //
     with ADOQuery do begin
          while not Eof do begin
               if ComboBox_Products.Text = Fields[0].AsString+'  '+Fields[1].AsString+'  '+Fields[2].AsString then begin
                    //得到物品ID
                    sProdID   := FieldByName('id').AsString;
                    sProdName := FieldByName('AName').AsString;
                    sProdModl := FieldByName('Model').AsString;
                    sProdPic  := FieldByName('Picture').AsString;
                    //设置当前物品为流转中
                    Edit;
                    //FieldByName('state').AsInteger     := 1;
                    Post;
                    //
                    break;
               end;
               //
               Next;
          end;
     end;
     //>

     //保存一个日期
     dtData    := Now;

     //
     joData    := TJsonObject.Create;
     joData.A['items']   := TJsonArray.Create;
     with joData.A['items'].AddObject do begin
          I['productid']      := StrToInt(sProdID);
          S['productname']    := sProdName;
          S['productmodel']   := sProdModl;
          S['productpicture'] := sProdPic;
          F['date']           := dtData;
          S['user']           := ComboBox_Users.Text;
          S['memo']           := Edit_Memo.Text;
     end;

     //<添加流转记录, productid,LastDate,lastuser,state,memo
     ADOQuery.Close;
     ADOQuery.SQL.Text   := 'INSERT INTO wzCirculations (productid,lastdate,lastuser,wzMemo,data,state) '
               +'VALUES('
               +''''+sProdID+''','
               +''''+FormatDateTime('yyyy-MM-dd HH:mm:ss',dtData)+''','
               +''''+ComboBox_Users.Text+''','
               +''''+Edit_Memo.Text+''','
               +''''+joData.ToString+''','
               +'1)';
     ADOQuery.ExecSQL;

     //
     joData.Destroy;

     //
     //dwRunJS('window.history.go(-1);',Self);
     dwOpenUrl(self,'/wzlz0.dw','_self');

     //此处可以自定义标题和按钮
     //dwShowMsg('物资已发出！'+ComboBox_Products.Text,'物资流转管理系统','确 定',self);
     //

end;

procedure TForm1.ComboBox_Ware1Change(Sender: TObject);
var
     I,J       : Integer;
begin
     for I := 0 to gjoWareHouse.A['items'].Count-1 do begin
          if gjoWareHouse.A['items'].O[I].S['name'] = ComboBox_Ware1.Text then begin

               if gjoWareHouse.A['items'].O[I].A['items'].Count = 0 then begin
                    ComboBox_Ware2.Visible   := False;
                    Label_Ware2.Visible      := False;
               end else begin

                    with ComboBox_Ware2 do begin
                         Visible             := True;
                         Left                := 120;
                         Label_Ware2.Visible := True;
                         Label_Ware2.Left    := 120;
                        //
                         Items.Clear;
                         for J := 0 to gjoWareHouse.A['items'].O[I].A['items'].Count-1 do begin
                              Items.Add(gjoWareHouse.A['items'].O[I].A['items'].S[J]);
                         end;
                         //
                         if Items.Count>0 then begin
                              Text   := Items[0];
                         end;
                    end;
               end;

               //
               break;
          end;
     end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
     I    : Integer;
begin
     //<接手人
     ADOQuery.Close;
     ADOQuery.SQL.Text   := 'SELECT UserName FROM wzUsers';
     ADOQuery.Open;
     //
     with ComboBox_Users do begin
          Items.Clear;
          while not ADOQuery.Eof do begin
               Items.Add(ADOQuery.Fields[0].AsString);
               //
               ADOQuery.Next;
          end;
          //
          if Items.Count>0 then begin
               Text   := Items[0];
          end;
     end;
     //>


     //<产品库
     ADOQuery.Close;
     ADOQuery.SQL.Text   := 'SELECT AName,Model,SeriesNO FROM wzProducts WHERE State=0';
     ADOQuery.Open;
     //
     with ComboBox_Products do begin
          Items.Clear;
          while not ADOQuery.Eof do begin
               Items.Add(ADOQuery.Fields[0].AsString+'  '+ADOQuery.Fields[1].AsString+'  '+ADOQuery.Fields[2].AsString);
               //
               ADOQuery.Next;
          end;
          //
          if Items.Count>0 then begin
               Text   := Items[0];
          end;
     end;
     //>

     //<存放位置
     ADOQuery.Close;
     ADOQuery.SQL.Text   := 'SELECT Value FROM wzOptions WHERE AName=''warehouse''';
     ADOQuery.Open;

     //
     gjoWareHouse   := TJsonObject(TJsonObject.Parse(ADOQuery.Fields[0].AsString));

     //
     with ComboBox_Ware1 do begin
          Items.Clear;
          for I := 0 to gjoWareHouse.A['items'].Count-1 do begin
               Items.Add(gjoWareHouse.A['items'].O[I].S['name']);
          end;
          //
          if Items.Count>0 then begin
               Text   := Items[0];
               ComboBox_Ware1.OnChange(self);
          end;
     end;
     //>

end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     Width     := Min(480,X);
     Height    := Y;
end;

end.
