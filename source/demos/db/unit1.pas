unit unit1;

interface

uses
     //
     dwBase,

     
     //

     //
     Math,
     Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
     Dialogs, StdCtrls, jpeg, ExtCtrls, DB,ADODB, Vcl.Grids, Vcl.DBGrids,
  Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    Label_Demo: TLabel;
    Panel_Logo: TPanel;
    Image1: TImage;
    Label6: TLabel;
    ADOQuery: TADOQuery;
    Panel_Info: TPanel;
    Edit_Item0: TEdit;
    Edit_Item1: TEdit;
    Edit_Item2: TEdit;
    Edit_Item3: TEdit;
    Panel_All: TPanel;
    Panel_StringGrid: TPanel;
    SG: TStringGrid;
    Panel3: TPanel;
    Button_NextPage: TButton;
    Button_PrevPage: TButton;
    Edit_Page: TEdit;
    Button_Go: TButton;
    Edit_Keyword: TEdit;
    Button_Search: TButton;
    Button_Append: TButton;
    Button_Delete: TButton;
    Button_Edit: TButton;
    Button_Reset: TButton;
    Edit_Item4: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure SGClick(Sender: TObject);
    procedure Button_AppendClick(Sender: TObject);
    procedure FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure Button_DeleteClick(Sender: TObject);
    procedure Button_EditClick(Sender: TObject);
    procedure Button_SearchClick(Sender: TObject);
    procedure Edit_KeywordChange(Sender: TObject);
    procedure Edit_Item0Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button_NextPageClick(Sender: TObject);
    procedure Button_PrevPageClick(Sender: TObject);
    procedure Button_GoClick(Sender: TObject);
    procedure Button_ResetClick(Sender: TObject);
  private
  public
          giPage : Integer;
          giPageCount : Integer;
          procedure UpdateData(APage:Integer;AKeyword:String);
  end;

var
     Form1     : TForm1;
     gbPreGet  : Boolean = False;

procedure ProcessMessageDlg(AResult:String);

implementation


{$R *.dfm}

procedure ProcessMessageDlg(AResult:String);
begin
end;

function _GetADOConnection:TADOConnection;
type
     PdwGetConn   = function ():TADOConnection;StdCall;
var
     iDll      : Integer;
     //
     fGetConn  : PdwGetConn;
begin
     Result    := nil;
     //得到ADOConnection
     if FileExists('dwADOConnection.dll') then begin
          iDll      := LoadLibrary('dwADOConnection.dll');
          fGetConn  := GetProcAddress(iDll,'dwGetConnection');

          Result    := fGetConn;
     end;

end;


procedure TForm1.Button_GoClick(Sender: TObject);
var
     sPage     : String;
     iPage     : Integer;
begin
     //得到当前页字符串
     sPage     := Edit_Page.Text;
     //删除可能的后面/及以后
     if Pos('/',sPage)>0 then begin
          sPage     := Copy(sPage,1,Pos('/',sPage)-1);
     end;
     //得到页码
     iPage     := StrToIntDef(sPage,-2);
     //如果当前页码正常，则设置页码
     if iPage <> -2 then begin
          giPage    := Min(giPageCount,Max(1,iPage));
     end;
     //更新数据
     UpdateData(giPage,Edit_Keyword.Text);
end;

procedure TForm1.Button_NextPageClick(Sender: TObject);
begin
     //上一页
     giPage    := Min(giPageCount,giPage + 1);
     UpdateData(giPage,Edit_Keyword.Text);
end;

procedure TForm1.Button_PrevPageClick(Sender: TObject);
begin
     //下一页
     giPage    := Max(1,giPage - 1);
     UpdateData(giPage,Edit_Keyword.Text);
end;

procedure TForm1.Button_ResetClick(Sender: TObject);
begin
     //
     dwMessageDlg('确定要将数据库重置到初始状态吗？','DeWeb DB','确定','取消','ResetDB',Self);
end;

procedure TForm1.Button_AppendClick(Sender: TObject);
begin
     if Trim(Edit_Item0.Text)='' then begin
          dwShowMessage('姓名不能为空！',self);
     end else begin
          dwMessageDlg('确定要将当前数据添加到数据表中吗？','DeWeb Demo','确定','取消','AppendDlg',Self);
     end;
end;

procedure TForm1.Button_DeleteClick(Sender: TObject);
begin
     if Trim(SG.Cells[0,SG.Row])='' then begin
          Exit;
     end;
     dwMessageDlg('确定要删除当前联系人 “'+SG.Cells[0,SG.Row]+'” 中吗？','DeWeb Demo','确定','取消','DeleteDlg',Self);
end;

procedure TForm1.Button_EditClick(Sender: TObject);
begin
     if Trim(Edit_Item0.Text)='' then begin
          dwShowMessage('姓名不能为空！',self);
          Exit;
     end;
     dwMessageDlg('确定要将当前编辑框内的数据保存到数据表中吗？','DeWeb Demo','确定','取消','EditDlg',Self);

end;

procedure TForm1.Button_SearchClick(Sender: TObject);
begin
     UpdateData(1,Edit_Keyword.Text);
end;

procedure TForm1.Edit_Item0Change(Sender: TObject);
begin
     //
end;

procedure TForm1.Edit_KeywordChange(Sender: TObject);
begin
     //
     Button_Search.OnClick(Self);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
     I    : Integer;
begin

     //
     Top  := 0;
     //
     SG.Cells[0,0]   := '姓名[center]';
     SG.Cells[1,0]   := '性别[center]';
     SG.Cells[2,0]   := '籍贯[center]';
     SG.Cells[3,0]   := '年龄[right]';
     SG.Cells[4,0]   := '地址';
     //
     SG.ColWidths[0]     := 100;
     SG.ColWidths[1]     := 100;
     SG.ColWidths[2]     := 100;
     SG.ColWidths[3]     := 100;
     SG.ColWidths[4]     := 597;
     //
     Edit_Item0.Width    := SG.ColWidths[0];
     Edit_Item1.Width    := SG.ColWidths[1];
     Edit_Item2.Width    := SG.ColWidths[2];
     Edit_Item3.Width    := SG.ColWidths[3];
     Edit_Item4.Width    := SG.ColWidths[4];
     //
     giPage    := 1;

end;

procedure TForm1.FormShow(Sender: TObject);
begin
     //
     UpdateData(giPage,'');

end;

procedure TForm1.FormStartDock(Sender: TObject;
  var DragObject: TDragDockObject);
var
     sMethod   : string;
     sValue    : string;
     iRow      : Integer;
     iRowOld   : Integer;
begin
     //
     sMethod   := dwGetProp(Self,'interactionmethod');
     sValue    := dwGetProp(Self,'interactionvalue');

     //
     if sMethod = 'ResetDB' then begin
          //重置数据库，以防止用户在多次修改后，数据不完整
          if sValue = '1' then begin
               //清空数据
               ADOQuery.Close;
               ADOQuery.SQL.Text   := 'DELETE FROM Member';
               ADOQuery.ExecSQL;
               //
               ADOQuery.Close;
               ADOQuery.SQL.Text   := 'INSERT INTO Member SELECT * FROM Member_Bak';
               ADOQuery.ExecSQL;
               //
               giPage    := 1;
               Edit_Keyword.Text   := '';
               UpdateData(giPage,'');
          end;
     end else if sMethod = 'AppendDlg' then begin
          //增加记录
          if sValue = '1' then begin
               //
               ADOQuery.Append;
               ADOQuery.FieldByName('item0').AsString := Edit_Item0.Text;
               ADOQuery.FieldByName('item1').AsString := dwIIF(Edit_Item1.Text='男','TRUE','FALSE');
               ADOQuery.FieldByName('item2').AsString := Edit_Item2.Text;
               ADOQuery.FieldByName('item3').AsString := Edit_Item3.Text;
               ADOQuery.FieldByName('item4').AsString := Edit_Item4.Text;
               ADOQuery.Post;
               //
               Edit_Keyword.Text   := '';
               UpdateData(-1,Edit_Keyword.Text);
               //
               dwShowMessage('Append Success',Self);
          end else begin
               dwShowMessage('Cancel',Self);
          end;
     end else if sMethod = 'DeleteDlg' then begin
          //删除记录
          if sValue = '1' then begin
               iRowOld   := SG.Row;
               ADOQuery.Delete;
               //
               UpdateData(giPage,Edit_Keyword.Text);
          end;
     end else if sMethod = 'EditDlg' then begin
          //保存编辑记录
          if sValue = '1' then begin
               //保存到数据表
               ADOQuery.Edit;
               ADOQuery.FieldByName('item0').AsString := Edit_Item0.Text;
               ADOQuery.FieldByName('item1').AsString := dwIIF(Edit_Item1.Text='男','TRUE','FALSE');
               ADOQuery.FieldByName('item2').AsString := Edit_Item2.Text;
               ADOQuery.FieldByName('item3').AsString := Edit_Item3.Text;
               ADOQuery.FieldByName('item4').AsString := Edit_Item4.Text;
               ADOQuery.Post;

               //更新显示
               iRow := SG.Row;
               SG.Cells[0,iRow]     := ADOQuery.FieldByName('item0').AsString;
               SG.Cells[1,iRow]     := dwIIF(ADOQuery.FieldByName('item1').AsBoolean,'男','女');
               SG.Cells[2,iRow]     := ADOQuery.FieldByName('item2').AsString;
               SG.Cells[3,iRow]     := ADOQuery.FieldByName('item3').AsString;
               SG.Cells[4,iRow]     := ADOQuery.FieldByName('item4').AsString;
          end;
     end;

     //清空标识和返回值，以避免出错
     dwSetProp(Self,'interactionmethod','');
     dwSetProp(Self,'interactionvalue','');
end;

procedure TForm1.SGClick(Sender: TObject);
var
     iRow      : Integer;
begin
     iRow      := SG.Row;
     if iRow < SG.RowCount then begin
          Edit_Item0.Text     := SG.Cells[0,iRow];
          Edit_Item1.Text     := SG.Cells[1,iRow];
          Edit_Item2.Text     := SG.Cells[2,iRow];
          Edit_Item3.Text     := SG.Cells[3,iRow];
          Edit_Item4.Text     := SG.Cells[4,iRow];
          //
          ADOQuery.RecNo     := Min(ADOQuery.RecordCount,iRow);
     end else begin
          Edit_Item0.Text     := '';
          Edit_Item1.Text     := '';
          Edit_Item2.Text     := '';
          Edit_Item3.Text     := '';
          Edit_Item4.Text     := '';
     end;
end;

procedure TForm1.UpdateData(APage: Integer; AKeyword: String);
var
     iRow,iCol : Integer;     //行列循环变量
     sLike     : string;      //查询字符串
begin
     //组合生成查询字符串
     sLike     := '';
     if AKeyword <>'' then begin
          if AKeyword = '男' then begin
               sLike     := ' WHERE (Item0 LIKE "%' + AKeyword +'%" OR Item1=True';
               for iRow := 2 to 4 do begin
                    sLike     := sLike  +' OR Item'+IntToStr(iRow)+' LIKE "%' + AKeyword +'%"';
               end;
               sLike     := sLike+') ';
          end else if AKeyword = '女' then begin
               sLike     := ' WHERE (Item0 LIKE "%' + AKeyword +'%" OR Item1=False';
               for iRow := 2 to 4 do begin
                    sLike     := sLike  +' OR Item'+IntToStr(iRow)+' LIKE "%' + AKeyword +'%"';
               end;
               sLike     := sLike+') ';
          end else begin
               sLike     := ' WHERE (Item0 LIKE "%' + AKeyword +'%"';
               for iRow := 1 to 4 do begin
                    sLike     := sLike  +' OR Item'+IntToStr(iRow)+' LIKE "%' + AKeyword +'%"';
               end;
               sLike     := sLike+') ';
          end;
     end;

     //更新总页数
     ADOQuery.Close;
     ADOQuery.SQL.Text   := 'SELECT Count(id) FROM member'+sLike;
     ADOQuery.Open;
     giPageCount    := Ceil(ADOQuery.Fields[0].AsInteger/10);

     //处理最末页(-1表示最末页)
     if APage = -1 then begin
          APage     := giPageCount;
     end;


     //显示当前页码
     Edit_Page.Text := IntToStr(APage)+'/'+IntToStr(giPageCount);

     //分页查询
     ADOQuery.Close;
     if APage = 1 then begin
          ADOQuery.SQL.Text   := 'SELECT TOP 10 * FROM member'+sLike+' ORDER BY id';
     end else begin
          if sLike = '' then begin
               ADOQuery.SQL.Text   := 'SELECT Top 10 * FROM member WHERE id NOT IN (SELECT TOP '+IntToStr((APage-1)*10)+' id FROM member ORDER BY id) ORDER BY id';
          end else begin
               ADOQuery.SQL.Text   := 'SELECT Top 10 * FROM member '+sLike+' AND id NOT IN (SELECT TOP '+IntToStr((APage-1)*10)+' id FROM member '+sLike+' ORDER BY id) ORDER BY id';
          end;
     end;
     ADOQuery.Open;

     //清空数据记录(主要防止数据记录未写满页面显示错误)
     for iRow := 1 to SG.RowCount-1 do begin
          for iCol := 0 to SG.ColCount-1 do begin
               SG.Cells[iCol,iRow]    := '';
          end;
     end;

     //显示数据记录
     if not ADOQuery.IsEmpty then begin
          for iRow := 1 to SG.RowCount-1 do begin
               SG.Cells[0,iRow]    := ADOQuery.FieldByName('Item0').AsString;
               SG.Cells[1,iRow]    := dwIIF(ADOQuery.FieldByName('item1').AsBoolean,'男','女');
               SG.Cells[2,iRow]    := ADOQuery.FieldByName('item2').AsString;
               SG.Cells[3,iRow]    := ADOQuery.FieldByName('item3').AsString;
               SG.Cells[4,iRow]    := ADOQuery.FieldByName('item4').AsString;
               //
               ADOQuery.Next;
               //如果已达末尾，则退出
               if ADOQuery.Eof then begin
                    break;
               end;
          end;
     end;

     //
     Edit_Item0.Text     := '';
     Edit_Item1.Text     := '';
     Edit_Item2.Text     := '';
     Edit_Item3.Text     := '';
     Edit_Item4.Text     := '';

end;

end.
