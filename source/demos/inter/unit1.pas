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
  Vcl.Imaging.pngimage, Vcl.Menus;

type
  TForm1 = class(TForm)
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
    Button_Append: TButton;
    Button_Delete: TButton;
    Button_Edit: TButton;
    Edit_Item4: TEdit;
    Panel1: TPanel;
    Image2: TImage;
    Label1: TLabel;
    Button_Reset: TButton;
    Edit_Keyword: TEdit;
    Button_Search: TButton;
    MainMenu: TMainMenu;
    MenuItem2: TMenuItem;
    MenuItem1: TMenuItem;
    N2: TMenuItem;
    N4: TMenuItem;
    MenuItem3: TMenuItem;
    N1: TMenuItem;
    N3: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    Panel_MenuBack: TPanel;
    Panel4: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit4: TEdit;
    ComboBox1: TComboBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    Button19: TButton;
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
     //�õ�ADOConnection
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
     //�õ���ǰҳ�ַ���
     sPage     := Edit_Page.Text;
     //ɾ�����ܵĺ���/���Ժ�
     if Pos('/',sPage)>0 then begin
          sPage     := Copy(sPage,1,Pos('/',sPage)-1);
     end;
     //�õ�ҳ��
     iPage     := StrToIntDef(sPage,-2);
     //�����ǰҳ��������������ҳ��
     if iPage <> -2 then begin
          giPage    := Min(giPageCount,Max(1,iPage));
     end;
     //��������
     UpdateData(giPage,Edit_Keyword.Text);
end;

procedure TForm1.Button_NextPageClick(Sender: TObject);
begin
     //��һҳ
     giPage    := Min(giPageCount,giPage + 1);
     UpdateData(giPage,Edit_Keyword.Text);
end;

procedure TForm1.Button_PrevPageClick(Sender: TObject);
begin
     //��һҳ
     giPage    := Max(1,giPage - 1);
     UpdateData(giPage,Edit_Keyword.Text);
end;

procedure TForm1.Button_ResetClick(Sender: TObject);
begin
     //
     dwMessageDlg('ȷ��Ҫ�����ݿ����õ���ʼ״̬��','DeWeb DB','ȷ��','ȡ��','ResetDB',Self);
end;

procedure TForm1.Button_AppendClick(Sender: TObject);
begin
     if Trim(Edit_Item0.Text)='' then begin
          dwShowMessage('��������Ϊ�գ�',self);
     end else begin
          dwMessageDlg('ȷ��Ҫ����ǰ������ӵ����ݱ�����','DeWeb Demo','ȷ��','ȡ��','AppendDlg',Self);
     end;
end;

procedure TForm1.Button_DeleteClick(Sender: TObject);
begin
     if Trim(SG.Cells[0,SG.Row])='' then begin
          Exit;
     end;
     dwMessageDlg('ȷ��Ҫɾ����ǰ��ϵ�� ��'+SG.Cells[0,SG.Row]+'�� ����','DeWeb Demo','ȷ��','ȡ��','DeleteDlg',Self);
end;

procedure TForm1.Button_EditClick(Sender: TObject);
begin
     if Trim(Edit_Item0.Text)='' then begin
          dwShowMessage('��������Ϊ�գ�',self);
          Exit;
     end;
     dwMessageDlg('ȷ��Ҫ����ǰ�༭���ڵ����ݱ��浽���ݱ�����','DeWeb Demo','ȷ��','ȡ��','EditDlg',Self);

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
     dwSetCompLTWH(MainMenu,0,60,250,580);

     //
     Top  := 0;
     //
     SG.Cells[0,0]   := '����[center]';
     SG.Cells[1,0]   := '�Ա�[center]';
     SG.Cells[2,0]   := '����[center]';
     SG.Cells[3,0]   := '����[right]';
     SG.Cells[4,0]   := '��ַ';
     SG.Cells[5,0]   := '����';
     //
     SG.ColWidths[0]     := 80;
     SG.ColWidths[1]     := 80;
     SG.ColWidths[2]     := 80;
     SG.ColWidths[3]     := 80;
     SG.ColWidths[4]     := 300;
     SG.ColWidths[5]     := 120;
     //
     Edit_Item0.Width    := SG.ColWidths[0];
     Edit_Item1.Width    := SG.ColWidths[1];
     Edit_Item2.Width    := SG.ColWidths[2];
     Edit_Item3.Width    := SG.ColWidths[3];
     Edit_Item4.Width    := SG.ColWidths[4]+SG.ColWidths[5];
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
          //�������ݿ⣬�Է�ֹ�û��ڶ���޸ĺ����ݲ�����
          if sValue = '1' then begin
               //�������
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
          //���Ӽ�¼
          if sValue = '1' then begin
               //
               ADOQuery.Append;
               ADOQuery.FieldByName('item0').AsString := Edit_Item0.Text;
               ADOQuery.FieldByName('item1').AsString := dwIIF(Edit_Item1.Text='��','TRUE','FALSE');
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
          //ɾ����¼
          if sValue = '1' then begin
               iRowOld   := SG.Row;
               ADOQuery.Delete;
               //
               UpdateData(giPage,Edit_Keyword.Text);
          end;
     end else if sMethod = 'EditDlg' then begin
          //����༭��¼
          if sValue = '1' then begin
               //���浽���ݱ�
               ADOQuery.Edit;
               ADOQuery.FieldByName('item0').AsString := Edit_Item0.Text;
               ADOQuery.FieldByName('item1').AsString := dwIIF(Edit_Item1.Text='��','TRUE','FALSE');
               ADOQuery.FieldByName('item2').AsString := Edit_Item2.Text;
               ADOQuery.FieldByName('item3').AsString := Edit_Item3.Text;
               ADOQuery.FieldByName('item4').AsString := Edit_Item4.Text;
               ADOQuery.Post;

               //������ʾ
               iRow := SG.Row;
               SG.Cells[0,iRow]     := ADOQuery.FieldByName('item0').AsString;
               SG.Cells[1,iRow]     := dwIIF(ADOQuery.FieldByName('item1').AsBoolean,'��','Ů');
               SG.Cells[2,iRow]     := ADOQuery.FieldByName('item2').AsString;
               SG.Cells[3,iRow]     := ADOQuery.FieldByName('item3').AsString;
               SG.Cells[4,iRow]     := ADOQuery.FieldByName('item4').AsString;
          end;
     end;

     //��ձ�ʶ�ͷ���ֵ���Ա������
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
     iRow,iCol : Integer;     //����ѭ������
     sLike     : string;      //��ѯ�ַ���
begin
     //������ɲ�ѯ�ַ���
     sLike     := '';
     if AKeyword <>'' then begin
          if AKeyword = '��' then begin
               sLike     := ' WHERE (Item0 LIKE "%' + AKeyword +'%" OR Item1=True';
               for iRow := 2 to 4 do begin
                    sLike     := sLike  +' OR Item'+IntToStr(iRow)+' LIKE "%' + AKeyword +'%"';
               end;
               sLike     := sLike+') ';
          end else if AKeyword = 'Ů' then begin
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

     //������ҳ��
     ADOQuery.Close;
     ADOQuery.SQL.Text   := 'SELECT Count(id) FROM member'+sLike;
     ADOQuery.Open;
     giPageCount    := Ceil(ADOQuery.Fields[0].AsInteger/10);

     //������ĩҳ(-1��ʾ��ĩҳ)
     if APage = -1 then begin
          APage     := giPageCount;
     end;


     //��ʾ��ǰҳ��
     Edit_Page.Text := IntToStr(APage)+'/'+IntToStr(giPageCount);

     //��ҳ��ѯ
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

     //������ݼ�¼(��Ҫ��ֹ���ݼ�¼δд��ҳ����ʾ����)
     for iRow := 1 to SG.RowCount-1 do begin
          for iCol := 0 to SG.ColCount-1 do begin
               SG.Cells[iCol,iRow]    := '';
          end;
     end;

     //��ʾ���ݼ�¼
     if not ADOQuery.IsEmpty then begin
          for iRow := 1 to SG.RowCount-1 do begin
               SG.Cells[0,iRow]    := ADOQuery.FieldByName('Item0').AsString;
               SG.Cells[1,iRow]    := dwIIF(ADOQuery.FieldByName('item1').AsBoolean,'��','Ů');
               SG.Cells[2,iRow]    := ADOQuery.FieldByName('item2').AsString;
               SG.Cells[3,iRow]    := ADOQuery.FieldByName('item3').AsString;
               SG.Cells[4,iRow]    := ADOQuery.FieldByName('item4').AsString;
               //
               ADOQuery.Next;
               //����Ѵ�ĩβ�����˳�
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
