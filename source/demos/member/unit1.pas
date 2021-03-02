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
    DataSource1: TDataSource;
    Timer1: TTimer;
    Panel_Logo: TPanel;
    Image1: TImage;
    Label6: TLabel;
    ADOQuery: TADOQuery;
    Panel1: TPanel;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Edit4: TEdit;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Panel_All: TPanel;
    Panel_StringGrid: TPanel;
    StringGrid1: TStringGrid;
    Panel3: TPanel;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Edit5: TEdit;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Edit_Keyword: TEdit;
    Button4: TButton;
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Edit_KeywordChange(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
  public

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


procedure TForm1.Button1Click(Sender: TObject);
begin
     if Trim(Edit1.Text)='' then begin
          dwShowMessage('��������Ϊ�գ�',self);
     end else begin
          dwMessageDlg('ȷ��Ҫ����ǰ������ӵ����ݱ�����','DeWeb Demo','ȷ��','ȡ��','AppendDlg',Self);
     end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     if Trim(StringGrid1.Cells[0,StringGrid1.Row])='' then begin
          Exit;
     end;
     dwMessageDlg('ȷ��Ҫɾ����ǰ��ϵ�� ��'+StringGrid1.Cells[0,StringGrid1.Row]+'�� ����','DeWeb Demo','ȷ��','ȡ��','DeleteDlg',Self);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
     if Trim(Edit1.Text)='' then begin
          dwShowMessage('��������Ϊ�գ�',self);
          Exit;
     end;
     dwMessageDlg('ȷ��Ҫ����ǰ�༭���ڵ����ݱ��浽���ݱ�����','DeWeb Demo','ȷ��','ȡ��','EditDlg',Self);

end;

procedure TForm1.Button4Click(Sender: TObject);
var
     I    : Integer;
begin
     if Trim(Edit_Keyword.Text) = '' then begin
          //
          ADOQuery.Close;
          ADOQuery.SQL.Text   := 'SELECT Item0,Item1,Item2,Item3 FROM Member0';
          ADOQuery.Open;
          //
          for I := 1 to StringGrid1.RowCount-1 do begin
               StringGrid1.Cells[0,I]   := '';
               StringGrid1.Cells[1,I]   := '';
               StringGrid1.Cells[2,I]   := '';
               StringGrid1.Cells[3,I]   := '';
          end;

          //
          if not ADOQuery.IsEmpty then begin
               //StringGrid1.RowCount    := ADOQuery.RecordCount + 1;
               for I := 1 to ADOQuery.RecordCount do begin
                    StringGrid1.Cells[0,I]   := ADOQuery.FieldByName('item0').AsString;
                    StringGrid1.Cells[1,I]   := ADOQuery.FieldByName('item1').AsString;
                    StringGrid1.Cells[2,I]   := ADOQuery.FieldByName('item2').AsString;
                    StringGrid1.Cells[3,I]   := ADOQuery.FieldByName('item3').AsString;
                    //
                    ADOQuery.Next;
               end;
          end;
     end else begin
          //
          ADOQuery.Close;
          ADOQuery.SQL.Text   := 'SELECT Item0,Item1,Item2,Item3 FROM Member0 WHERE Item0 Like "%'+Trim(Edit_Keyword.Text)+'%"';
          ADOQuery.Open;
          //
          for I := 1 to StringGrid1.RowCount-1 do begin
               StringGrid1.Cells[0,I]   := '';
               StringGrid1.Cells[1,I]   := '';
               StringGrid1.Cells[2,I]   := '';
               StringGrid1.Cells[3,I]   := '';
          end;

          //
          if not ADOQuery.IsEmpty then begin
               //StringGrid1.RowCount    := ADOQuery.RecordCount + 1;
               for I := 1 to ADOQuery.RecordCount do begin
                    StringGrid1.Cells[0,I]   := ADOQuery.FieldByName('item0').AsString;
                    StringGrid1.Cells[1,I]   := ADOQuery.FieldByName('item1').AsString;
                    StringGrid1.Cells[2,I]   := ADOQuery.FieldByName('item2').AsString;
                    StringGrid1.Cells[3,I]   := ADOQuery.FieldByName('item3').AsString;
                    //
                    ADOQuery.Next;
               end;
          end;
     end;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
     //
end;

procedure TForm1.Edit_KeywordChange(Sender: TObject);
begin
     //
     Button4.OnClick(Self);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
     I    : Integer;
begin

     //
     Top  := 0;
     //
     ADOQuery.Connection := _GetADOConnection;
     ADOQuery.SQL.Text   := 'SELECT Item0,Item1,Item2,Item3 FROM Member0';
     ADOQuery.Open;
     //
     StringGrid1.Cells[0,0]   := '����';
     StringGrid1.Cells[1,0]   := '�Ա�';
     StringGrid1.Cells[2,0]   := '����';
     StringGrid1.Cells[3,0]   := '����';

     //
     if not ADOQuery.IsEmpty then begin
          StringGrid1.RowCount    := 9 + 1;
          for I := 1 to 9 do begin
               StringGrid1.Cells[0,I]   := ADOQuery.FieldByName('item0').AsString;
               StringGrid1.Cells[1,I]   := ADOQuery.FieldByName('item1').AsString;
               StringGrid1.Cells[2,I]   := ADOQuery.FieldByName('item2').AsString;
               StringGrid1.Cells[3,I]   := ADOQuery.FieldByName('item3').AsString;
               //
               ADOQuery.Next;
          end;
     end;
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
     if sMethod = 'AppendDlg' then begin
          //���Ӽ�¼
          if sValue = '1' then begin
               //
               ADOQuery.Append;
               ADOQuery.FieldByName('item0').AsString := Edit1.Text;
               ADOQuery.FieldByName('item1').AsString := Edit2.Text;
               ADOQuery.FieldByName('item2').AsString := Edit3.Text;
               ADOQuery.FieldByName('item3').AsString := Edit4.Text;
               ADOQuery.Post;
               //
               StringGrid1.RowCount     := StringGrid1.RowCount + 1;
               iRow := StringGrid1.RowCount - 1;
               StringGrid1.Cells[0,iRow]     := ADOQuery.FieldByName('item0').AsString;
               StringGrid1.Cells[1,iRow]     := ADOQuery.FieldByName('item1').AsString;
               StringGrid1.Cells[2,iRow]     := ADOQuery.FieldByName('item2').AsString;
               StringGrid1.Cells[3,iRow]     := ADOQuery.FieldByName('item3').AsString;
               //
               dwShowMessage('OK',Self);
          end else begin
               dwShowMessage('Cancel',Self);
          end;
     end else if sMethod = 'DeleteDlg' then begin
          //ɾ����¼
          if sValue = '1' then begin
               iRowOld   := StringGrid1.Row;
               ADOQuery.Delete;
               //
               StringGrid1.RowCount    := ADOQuery.RecordCount + 1;
               ADOQuery.First;
               for iRow := 1 to ADOQuery.RecordCount do begin
                    StringGrid1.Cells[0,iRow]     := ADOQuery.FieldByName('item0').AsString;
                    StringGrid1.Cells[1,iRow]     := ADOQuery.FieldByName('item1').AsString;
                    StringGrid1.Cells[2,iRow]     := ADOQuery.FieldByName('item2').AsString;
                    StringGrid1.Cells[3,iRow]     := ADOQuery.FieldByName('item3').AsString;
                    //
                    ADOQuery.Next;
               end;
               //
               if iRowOld >= StringGrid1.RowCount then begin
                    iRowOld := StringGrid1.RowCount - 1;
               end;
               Edit1.Text     := StringGrid1.Cells[0,iRowOld];
               Edit2.Text     := StringGrid1.Cells[1,iRowOld];
               Edit3.Text     := StringGrid1.Cells[2,iRowOld];
               Edit4.Text     := StringGrid1.Cells[3,iRowOld];
          end;
     end else if sMethod = 'EditDlg' then begin
          //����༭��¼
          if sValue = '1' then begin
               //���浽���ݱ�
               ADOQuery.Edit;
               ADOQuery.FieldByName('item0').AsString := Edit1.Text;
               ADOQuery.FieldByName('item1').AsString := Edit2.Text;
               ADOQuery.FieldByName('item2').AsString := Edit3.Text;
               ADOQuery.FieldByName('item3').AsString := Edit4.Text;
               ADOQuery.Post;

               //������ʾ
               iRow := StringGrid1.Row;
               StringGrid1.Cells[0,iRow]     := ADOQuery.FieldByName('item0').AsString;
               StringGrid1.Cells[1,iRow]     := ADOQuery.FieldByName('item1').AsString;
               StringGrid1.Cells[2,iRow]     := ADOQuery.FieldByName('item2').AsString;
               StringGrid1.Cells[3,iRow]     := ADOQuery.FieldByName('item3').AsString;
          end;
     end;

     //��ձ�ʶ�ͷ���ֵ���Ա������
     dwSetProp(Self,'interactionmethod','');
     dwSetProp(Self,'interactionvalue','');
end;

procedure TForm1.StringGrid1Click(Sender: TObject);
var
     iRow      : Integer;
begin
     iRow      := StringGrid1.Row;
     if iRow < StringGrid1.RowCount then begin
          Edit1.Text     := StringGrid1.Cells[0,iRow];
          Edit2.Text     := StringGrid1.Cells[1,iRow];
          Edit3.Text     := StringGrid1.Cells[2,iRow];
          Edit4.Text     := StringGrid1.Cells[3,iRow];
          //
          ADOQuery.RecNo     := Min(ADOQuery.RecordCount,iRow);
     end else begin
          Edit1.Text     := '';
          Edit2.Text     := '';
          Edit3.Text     := '';
          Edit4.Text     := '';
     end;
end;

end.
