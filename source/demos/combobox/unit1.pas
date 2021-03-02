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
    Panel2: TPanel;
    Button_Position: TButton;
    Button_Size: TButton;
    Button_Visible: TButton;
    Panel_All: TPanel;
    Panel_StringGrid: TPanel;
    Panel1: TPanel;
    Button_Get: TButton;
    Button_Set: TButton;
    Button_Clear: TButton;
    Button_SetCells: TButton;
    Button_GetRow: TButton;
    Button_SetRow: TButton;
    ComboBox1: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure Button_PositionClick(Sender: TObject);
    procedure Button_SizeClick(Sender: TObject);
    procedure Button_VisibleClick(Sender: TObject);
    procedure Button_EnabledClick(Sender: TObject);
    procedure Button_GetClick(Sender: TObject);
    procedure Button_ClearClick(Sender: TObject);
    procedure Button_SetCellsClick(Sender: TObject);
    procedure Button_SetRowClick(Sender: TObject);
    procedure Button_GetRowClick(Sender: TObject);
    procedure Button_SetClick(Sender: TObject);
  private
  public

  end;

var
     Form1     : TForm1;


implementation


{$R *.dfm}




procedure TForm1.Button_ClearClick(Sender: TObject);
begin
     ComboBox1.Items.Clear;
end;

procedure TForm1.Button_EnabledClick(Sender: TObject);
begin
     with ComboBox1 do begin
          Enabled   := not Enabled;
     end;

end;

procedure TForm1.Button_GetClick(Sender: TObject);
begin
     dwShowMessage(ComboBox1.Items[1],self);
end;

procedure TForm1.Button_GetRowClick(Sender: TObject);
var
     I    : Integer;
     iRes : Integer;
begin
     //
     iRes := -1;
     for I:=0 to ComboBox1.Items.Count-1 do begin
          if ComboBox1.Items[I] = ComboBox1.Text then begin
               iRes := I;
               break;
          end;
     end;
     //
     ComboBox1.ItemIndex := iRes;

     //
     dwShowMessage('ItemIndex : '+IntToStr(ComboBox1.ItemIndex),self);
end;

procedure TForm1.Button_PositionClick(Sender: TObject);
begin
     With ComboBox1 do begin
          Left := Left + 5;
          Top  := Top + 5;
     end;
end;

procedure TForm1.Button_SetCellsClick(Sender: TObject);
begin
     with ComboBox1.Items do begin
          Clear;
          Add('姓名');
          Add('性别');
          Add('民族');
          Add('籍贯');
     end;

end;

procedure TForm1.Button_SetClick(Sender: TObject);
begin
     ComboBox1.Items.Add(IntToStr(GetTickCount));
end;

procedure TForm1.Button_SetRowClick(Sender: TObject);
begin
     if ComboBox1.Items.Count>1 then begin
          ComboBox1.ItemIndex := 1;
          ComboBox1.Text := ComboBox1.Items[ComboBox1.ItemIndex];
     end;
end;

procedure TForm1.Button_SizeClick(Sender: TObject);
begin
     With ComboBox1 do begin
          Width     := Width + 5;
          Height    := Height + 5;
     end;

end;

procedure TForm1.Button_VisibleClick(Sender: TObject);
begin
     with ComboBox1 do begin
          Visible   := not Visible;
     end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
     iR,iC     : Integer;
begin

     //
     Top  := 0;
     //

     with ComboBox1.Items do begin
          Clear;
          Add('姓名');
          Add('性别');
          Add('民族');
          Add('籍贯');
     end;


     //
     dwSetHeight(Self,1200);
end;


end.
