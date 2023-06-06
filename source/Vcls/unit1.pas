unit unit1;

interface

uses
     dwBase,

  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, ExtCtrls, StdCtrls, ComCtrls, Spin, jpeg,
  Grids;

type
  TForm1 = class(TForm)
    Label_Title: TLabel;
    Img: TImage;
    Panel_Line: TPanel;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button10: TButton;
    Button11: TButton;
    Label5: TLabel;
    Button12: TButton;
    Button13: TButton;
    Label6: TLabel;
    Button14: TButton;
    Button15: TButton;
    Edit1: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    Button19: TButton;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    TabSheet10: TTabSheet;
    TabSheet11: TTabSheet;
    TabSheet12: TTabSheet;
    TabSheet13: TTabSheet;
    TabSheet14: TTabSheet;
    TabSheet15: TTabSheet;
    TabSheet16: TTabSheet;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Button20: TButton;
    Button21: TButton;
    Button22: TButton;
    Button23: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    Label19: TLabel;
    CheckBox7: TCheckBox;
    Button24: TButton;
    Label20: TLabel;
    CheckBox8: TCheckBox;
    Label21: TLabel;
    Label24: TLabel;
    Label26: TLabel;
    Button35: TButton;
    Button39: TButton;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label35: TLabel;
    Label37: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Label22: TLabel;
    Label23: TLabel;
    Label25: TLabel;
    Button25: TButton;
    Button26: TButton;
    Button27: TButton;
    Button28: TButton;
    Label33: TLabel;
    Label34: TLabel;
    Label36: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Button29: TButton;
    Button30: TButton;
    Button31: TButton;
    Button32: TButton;
    Button33: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton8: TRadioButton;
    Label42: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Button34: TButton;
    Button36: TButton;
    Button37: TButton;
    Button38: TButton;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    SpinEdit5: TSpinEdit;
    Label43: TLabel;
    SpinEdit6: TSpinEdit;
    Button40: TButton;
    Label48: TLabel;
    SpinEdit7: TSpinEdit;
    Label49: TLabel;
    Edit8: TEdit;
    Label50: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Button41: TButton;
    Button42: TButton;
    Button43: TButton;
    Button44: TButton;
    Label57: TLabel;
    ComboBox1: TComboBox;
    ComboBox3: TComboBox;
    ComboBox2: TComboBox;
    ComboBox5: TComboBox;
    ComboBox4: TComboBox;
    ComboBox6: TComboBox;
    MonthCalendar1: TMonthCalendar;
    Label51: TLabel;
    Label56: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label62: TLabel;
    Button45: TButton;
    Button46: TButton;
    Button47: TButton;
    Button48: TButton;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    DateTimePicker3: TDateTimePicker;
    DateTimePicker4: TDateTimePicker;
    DateTimePicker5: TDateTimePicker;
    DateTimePicker6: TDateTimePicker;
    DateTimePicker7: TDateTimePicker;
    DateTimePicker8: TDateTimePicker;
    Image1: TImage;
    Image2: TImage;
    Image4: TImage;
    Image3: TImage;
    Label61: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Button49: TButton;
    Button50: TButton;
    Button51: TButton;
    Button52: TButton;
    Button53: TButton;
    Button54: TButton;
    Button55: TButton;
    ListBox1: TListBox;
    Button56: TButton;
    Button57: TButton;
    SpinEdit8: TSpinEdit;
    Button58: TButton;
    Button59: TButton;
    Button60: TButton;
    Button61: TButton;
    Button62: TButton;
    Button63: TButton;
    Memo1: TMemo;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    Button64: TButton;
    Button65: TButton;
    Button66: TButton;
    Button67: TButton;
    Button68: TButton;
    Button69: TButton;
    PageControl1: TPageControl;
    TabSheet17: TTabSheet;
    TabSheet18: TTabSheet;
    TabSheet19: TTabSheet;
    PageControl3: TPageControl;
    TabSheet22: TTabSheet;
    TabSheet23: TTabSheet;
    Button70: TButton;
    Button71: TButton;
    Button72: TButton;
    Button73: TButton;
    Button74: TButton;
    Button75: TButton;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    Button76: TButton;
    Button77: TButton;
    Button78: TButton;
    Button79: TButton;
    Button80: TButton;
    Button81: TButton;
    CheckBox13: TCheckBox;
    Button82: TButton;
    Button83: TButton;
    Button84: TButton;
    Button85: TButton;
    Button86: TButton;
    Button87: TButton;
    StringGrid1: TStringGrid;
    TreeView1: TTreeView;
    Button88: TButton;
    CheckBox14: TCheckBox;
    procedure Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure CheckBox8Click(Sender: TObject);
    procedure Button35Click(Sender: TObject);
    procedure Button39Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure Button27Click(Sender: TObject);
    procedure Button28Click(Sender: TObject);
    procedure Button32Click(Sender: TObject);
    procedure Button31Click(Sender: TObject);
    procedure Button29Click(Sender: TObject);
    procedure Button33Click(Sender: TObject);
    procedure RadioButton8Click(Sender: TObject);
    procedure Button30Click(Sender: TObject);
    procedure Button34Click(Sender: TObject);
    procedure Button36Click(Sender: TObject);
    procedure Button37Click(Sender: TObject);
    procedure Button38Click(Sender: TObject);
    procedure Button40Click(Sender: TObject);
    procedure SpinEdit7Change(Sender: TObject);
    procedure Edit8Change(Sender: TObject);
    procedure ComboBox6Change(Sender: TObject);
    procedure Button41Click(Sender: TObject);
    procedure Button42Click(Sender: TObject);
    procedure Button43Click(Sender: TObject);
    procedure Button44Click(Sender: TObject);
    procedure Button45Click(Sender: TObject);
    procedure Button46Click(Sender: TObject);
    procedure Button47Click(Sender: TObject);
    procedure DateTimePicker8Change(Sender: TObject);
    procedure Button48Click(Sender: TObject);
    procedure Button49Click(Sender: TObject);
    procedure Button52Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Button50Click(Sender: TObject);
    procedure Button51Click(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Button53Click(Sender: TObject);
    procedure Button54Click(Sender: TObject);
    procedure Button55Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Button56Click(Sender: TObject);
    procedure Button57Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure Button58Click(Sender: TObject);
    procedure Button59Click(Sender: TObject);
    procedure Button61Click(Sender: TObject);
    procedure Button60Click(Sender: TObject);
    procedure Button62Click(Sender: TObject);
    procedure Button63Click(Sender: TObject);
    procedure Button64Click(Sender: TObject);
    procedure Button65Click(Sender: TObject);
    procedure Button66Click(Sender: TObject);
    procedure Button67Click(Sender: TObject);
    procedure Button68Click(Sender: TObject);
    procedure Button69Click(Sender: TObject);
    procedure MonthCalendar1Click(Sender: TObject);
    procedure Button70Click(Sender: TObject);
    procedure Button71Click(Sender: TObject);
    procedure Button73Click(Sender: TObject);
    procedure Button72Click(Sender: TObject);
    procedure Button74Click(Sender: TObject);
    procedure Button75Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure Button76Click(Sender: TObject);
    procedure Button77Click(Sender: TObject);
    procedure Button79Click(Sender: TObject);
    procedure Button78Click(Sender: TObject);
    procedure Button80Click(Sender: TObject);
    procedure Button81Click(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure Button82Click(Sender: TObject);
    procedure Button83Click(Sender: TObject);
    procedure Button85Click(Sender: TObject);
    procedure Button84Click(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button11Click(Sender: TObject);
begin
     Button10.Left  := Button10.Left+5;
     Button10.Top   := Button10.Top+5;
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
     Button12.Width      := Button12.Width+5;
     Button12.Height     := Button12.Height+5;

end;

procedure TForm1.Button15Click(Sender: TObject);
begin
     Button14.Caption    := 'Btn按钮-'+IntToStr(GetTickCount Mod 10000);
end;

procedure TForm1.Button16Click(Sender: TObject);
begin
     Edit3.Enabled  := not Edit3.Enabled;
end;

procedure TForm1.Button17Click(Sender: TObject);
begin
     Edit4.Left  := Edit4.Left+5;
     Edit4.Top   := Edit4.Top+5;

end;

procedure TForm1.Button18Click(Sender: TObject);
begin
     Edit5.Width      := Edit5.Width+5;
     Edit5.Height     := Edit5.Height+5;

end;

procedure TForm1.Button19Click(Sender: TObject);
begin
     Edit6.Text     := 'Edit编-'+IntToStr(GetTickCount Mod 1000);
end;

procedure TForm1.Button20Click(Sender: TObject);
begin
     CheckBox6.Checked   := not CheckBox6.Checked;
end;

procedure TForm1.Button21Click(Sender: TObject);
begin
     with CheckBox5 do begin
          Width     := Width + 5;
          Height    := Height +5;
     end;

end;

procedure TForm1.Button22Click(Sender: TObject);
begin
     with CheckBox4 do begin
          Left := Left + 5;
          Top  := Top +5;
     end;
end;

procedure TForm1.Button23Click(Sender: TObject);
begin
     CheckBox3.Enabled   := not CheckBox3.Enabled;
end;

procedure TForm1.Button24Click(Sender: TObject);
begin
     CheckBox7.Caption   := 'Chk选项-'+IntToStr(GetTickCount Mod 1000);
end;

procedure TForm1.Button25Click(Sender: TObject);
begin
     Panel4.Visible := not Panel4.Visible;
end;

procedure TForm1.Button26Click(Sender: TObject);
begin
     with Panel4 do begin
          Visible   := True;
          Left := Left + 5;
          Top  := Top +5;
     end;

end;

procedure TForm1.Button27Click(Sender: TObject);
begin
     with Panel4 do begin
          Visible   := True;
          Width     := Width + 5;
          Height    := Height +5;
     end;

end;

procedure TForm1.Button28Click(Sender: TObject);
begin
     Panel4.Enabled := not Panel4.Enabled;
end;

procedure TForm1.Button29Click(Sender: TObject);
begin
     RadioButton6.Checked   := not RadioButton6.Checked;

end;

procedure TForm1.Button30Click(Sender: TObject);
begin
     with RadioButton5 do begin
          Width     := Width + 5;
          Height    := Height +5;
     end;

end;

procedure TForm1.Button31Click(Sender: TObject);
begin
     with RadioButton4 do begin
          Left := Left + 5;
          Top  := Top +5;
     end;

end;

procedure TForm1.Button32Click(Sender: TObject);
begin
     RadioButton3.Enabled   := not RadioButton3.Enabled;

end;

procedure TForm1.Button33Click(Sender: TObject);
begin
     RadioButton7.Caption   := 'Rio单-'+IntToStr(GetTickCount Mod 1000);

end;

procedure TForm1.Button34Click(Sender: TObject);
begin
     SpinEdit2.Enabled   := not SpinEdit2.Enabled;
end;

procedure TForm1.Button35Click(Sender: TObject);
begin
     with Label35 do begin
          Left := Left + 5;
          Top  := Top +5;
     end;

end;

procedure TForm1.Button36Click(Sender: TObject);
begin
     with SpinEdit3 do begin
          Left := Left + 5;
          Top  := Top +5;
     end;

end;

procedure TForm1.Button37Click(Sender: TObject);
begin
     with SpinEdit4 do begin
          Width     := Width + 5;
          Height    := Height +5;
     end;

end;

procedure TForm1.Button38Click(Sender: TObject);
begin
     SpinEdit5.Value     := SpinEdit5.Value+1;
end;

procedure TForm1.Button39Click(Sender: TObject);
begin
     Label37.Caption   := 'Lbl中-'+IntToStr(GetTickCount Mod 1000);

end;

procedure TForm1.Button40Click(Sender: TObject);
begin
     SpinEdit6.MinValue  := -15;
     SpinEdit6.MaxValue  := 15;
end;

procedure TForm1.Button41Click(Sender: TObject);
begin
     ComboBox2.Enabled   := Not ComboBox2.Enabled;
end;

procedure TForm1.Button42Click(Sender: TObject);
begin
     with ComboBox3 do begin
          Left := Left + 5;
          Top  := Top +5;
     end;

end;

procedure TForm1.Button43Click(Sender: TObject);
begin
     with ComboBox4 do begin
          Width     := Width + 5;
          Height    := Height +5;
     end;

end;

procedure TForm1.Button44Click(Sender: TObject);
begin
     ComboBox5.Text := 'AAA中英123@';
end;

procedure TForm1.Button45Click(Sender: TObject);
begin
     DateTimePicker3.Enabled  := not DateTimePicker3.Enabled;
end;

procedure TForm1.Button46Click(Sender: TObject);
begin
      with DateTimePicker4 do begin
          Left := Left + 5;
          Top  := Top +5;
     end;

end;

procedure TForm1.Button47Click(Sender: TObject);
begin
     with DateTimePicker5 do begin
          Width     := Width + 5;
          Height    := Height +5;
     end;

end;

procedure TForm1.Button48Click(Sender: TObject);
begin
     DateTimePicker6.Date     := DateTimePicker6.Date+1;
     DateTimePicker7.Time     := DateTimePicker7.Time+0.0151;
end;

procedure TForm1.Button49Click(Sender: TObject);
begin
     Image3.Visible := not Image3.Visible;
end;

procedure TForm1.Button50Click(Sender: TObject);
begin
      with Image3 do begin
          Left := Left + 5;
          Top  := Top +5;
     end;

end;

procedure TForm1.Button51Click(Sender: TObject);
begin
     with Image3 do begin
          Width     := Width + 5;
          Height    := Height +5;
     end;

end;

procedure TForm1.Button52Click(Sender: TObject);
begin
     ListBox1.Visible := not ListBox1.Visible;

end;

procedure TForm1.Button53Click(Sender: TObject);
begin
     with ListBox1 do begin
          Left := Left + 5;
          Top  := Top +5;
     end;

end;

procedure TForm1.Button54Click(Sender: TObject);
begin
     with ListBox1 do begin
          Width     := Width + 5;
          Height    := Height +5;
     end;

end;

procedure TForm1.Button55Click(Sender: TObject);
begin
     ListBox1.Enabled := not ListBox1.Enabled;

end;

procedure TForm1.Button56Click(Sender: TObject);
var
     sValue    : string;
     I         : Integer;
begin
     sValue    := '';
     for I := 0 to ListBox1.Items.Count-1 do begin
          if ListBox1.Selected[I] then begin
               sValue    := sValue+ListBox1.Items[I]+', ';
          end;
     end;
     dwShowMessage('Selected:'+sValue,Self);
end;

procedure TForm1.Button57Click(Sender: TObject);
begin
     ListBox1.Selected[SpinEdit8.Value] := True;
end;

procedure TForm1.Button58Click(Sender: TObject);
begin
     Memo1.Visible  := not Memo1.Visible;
end;

procedure TForm1.Button59Click(Sender: TObject);
begin
     Memo1.Enabled     := not Memo1.Enabled;
end;

procedure TForm1.Button60Click(Sender: TObject);
begin
     with Memo1 do begin
          Width     := Width + 5;
          Height    := Height +5;
     end;

end;

procedure TForm1.Button61Click(Sender: TObject);
begin
     with Memo1 do begin
          Left := Left + 5;
          Top  := Top +5;
     end;

end;

procedure TForm1.Button62Click(Sender: TObject);
begin
     dwShowMessage(Memo1.Text,Self);

end;

procedure TForm1.Button63Click(Sender: TObject);
begin
     Memo1.Text     := Memo1.Text + #13#10' --- New';
end;

procedure TForm1.Button64Click(Sender: TObject);
begin
     MonthCalendar1.Visible   := not MonthCalendar1.Visible;
end;

procedure TForm1.Button65Click(Sender: TObject);
begin
     MonthCalendar1.Enabled   := not MonthCalendar1.Enabled;
end;

procedure TForm1.Button66Click(Sender: TObject);
begin
     with MonthCalendar1 do begin
          Left := Left + 5;
          Top  := Top +5;
     end;
end;

procedure TForm1.Button67Click(Sender: TObject);
begin
     with MonthCalendar1 do begin
          Width     := Width + 5;
          Height    := Height +5;
     end;

end;

procedure TForm1.Button68Click(Sender: TObject);
begin
     dwShowMessage('Current : '+FormatDateTime('yyyy-MM-dd',MonthCalendar1.Date),Self);
end;

procedure TForm1.Button69Click(Sender: TObject);
begin
     MonthCalendar1.Date := MonthCalendar1.Date + 1;
end;

procedure TForm1.Button70Click(Sender: TObject);
begin
     PageControl1.Visible     := not PageControl1.Visible;
end;

procedure TForm1.Button71Click(Sender: TObject);
begin
     PageControl1.Enabled     := not PageControl1.Enabled;

end;

procedure TForm1.Button72Click(Sender: TObject);
begin
     with PageControl1 do begin
          Width     := Width + 5;
          Height    := Height +5;
     end;

end;

procedure TForm1.Button73Click(Sender: TObject);
begin
     with PageControl1 do begin
          Left := Left + 5;
          Top  := Top +5;
     end;

end;

procedure TForm1.Button74Click(Sender: TObject);
begin
     dwShowMessage('Current ActivePage :'+IntToStr(PageControl1.ActivePageIndex),Self);

end;

procedure TForm1.Button75Click(Sender: TObject);
begin
     if PageControl1.ActivePageIndex = PageControl1.PageCount-1 then begin
          PageControl1.ActivePageIndex  := 0;
     end else begin
          PageControl1.ActivePageIndex  := PageControl1.ActivePageIndex + 1;
     end;
     PageControl1.OnChange(Self);
end;

procedure TForm1.Button76Click(Sender: TObject);
begin
     StringGrid1.Visible := not StringGrid1.Visible;
end;

procedure TForm1.Button77Click(Sender: TObject);
begin
     StringGrid1.Enabled := not StringGrid1.Enabled;

end;

procedure TForm1.Button78Click(Sender: TObject);
begin
     with StringGrid1 do begin
          Width     := Width + 5;
          Height    := Height +5;
     end;

end;

procedure TForm1.Button79Click(Sender: TObject);
begin
     with StringGrid1 do begin
          Left := Left + 5;
          Top  := Top +5;
     end;

end;

procedure TForm1.Button80Click(Sender: TObject);
begin
     dwShowMessage(StringGrid1.Cells[1,1],Self);

end;

procedure TForm1.Button81Click(Sender: TObject);
begin
     StringGrid1.Cells[2,2]   := '中文'+IntToStr(GetTickCount mod 1000);
end;

procedure TForm1.Button82Click(Sender: TObject);
begin
     TreeView1.Visible   := not TreeView1.Visible;
end;

procedure TForm1.Button83Click(Sender: TObject);
begin
     TreeView1.Enabled   := not TreeView1.Enabled;

end;

procedure TForm1.Button84Click(Sender: TObject);
begin
     with TreeView1 do begin
          Width     := Width + 5;
          Height    := Height +5;
     end;

end;

procedure TForm1.Button85Click(Sender: TObject);
begin
     with TreeView1 do begin
          Left := Left + 5;
          Top  := Top +5;
     end;

end;

procedure TForm1.Button9Click(Sender: TObject);
begin
     Button8.Enabled     := not Button8.Enabled;
end;

procedure TForm1.CheckBox8Click(Sender: TObject);
begin
     if CheckBox8.Checked then begin
          dwShowMessage('Checked!',Self);
     end else begin
          dwShowMessage('unChecked!',Self);
     end;

end;

procedure TForm1.Click(Sender: TObject);
begin
     dwShowMessage('You Click a button!',Self);
end;

procedure TForm1.ComboBox6Change(Sender: TObject);
begin
     dwShowMessage('ComboBox Change:'+TComboBox(Sender).Text,Self);

end;

procedure TForm1.DateTimePicker8Change(Sender: TObject);
begin
     dwShowMessage('DateTimePicker OnChange',Self);

end;

procedure TForm1.Edit8Change(Sender: TObject);
begin
     dwShowMessage('Edit OnChange:'+TEdit(Sender).Text,Self);

end;

procedure TForm1.FormCreate(Sender: TObject);
var
     iC,iR     : Integer;
begin
     Top  := 20;
     PageControl.ActivePageIndex   := 0;
     //
     dwSetHeight(self,4000);
     //
     for iR := 0 to StringGrid1.RowCount-1 do begin
          for iC := 0 to StringGrid1.ColCount-1 do begin
               StringGrid1.Cells[iC,iR] := Format('位%d,%d',[iR,iC]);
          end;
     end;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     //
end;

procedure TForm1.Image3Click(Sender: TObject);
begin
     dwShowMessage('Image OnClick!',Self);
end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
     if CheckBox14.Checked then begin
          dwShowMessage('ListBox Clicked!',Self);
     end;
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin
     if CheckBOx9.Checked then begin
          dwShowMessage('Memo OnChange',Self);
     end;

end;

procedure TForm1.MonthCalendar1Click(Sender: TObject);
begin
     if CheckBOx10.Checked then begin
          dwShowMessage('OnClick : '+FormatDateTime('yyyy-MM-dd',MonthCalendar1.Date),Self);
     end;

end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin

     //
     if CheckBox11.Checked then begin
          dwShowMessage('PageControl Changed!',Self);
     end;
end;

procedure TForm1.RadioButton8Click(Sender: TObject);
begin
     //
     if RadioButton8.Checked then begin
          dwShowMessage('radio Checked!',Self);
     end else begin
          dwShowMessage('radio unChecked!',Self);
     end;
end;

procedure TForm1.SpinEdit7Change(Sender: TObject);
begin
     dwShowMessage('SpinEdit OnChange',Self);

end;

procedure TForm1.StringGrid1Click(Sender: TObject);
begin
     if CheckBox12.Checked then begin
          dwShowMessage('StringGrid Row : '+IntToStr(StringGrid1.Row),Self);
     end;

end;

procedure TForm1.TreeView1Click(Sender: TObject);
begin
     if CheckBox13.Checked then begin
          if TreeView1.Selected <> nil then begin
               dwShowMessage('TreeVIew OnClick at '+TreeView1.Selected.Text,Self);
          end else begin
               dwShowMessage('TreeVIew OnClick',Self);
          end;
     end;

end;

procedure TForm1.PageControlChange(Sender: TObject);
begin
     Label_Title.Caption := 'DeWeb : Delphi-Web --- '+PageControl.ActivePage.Caption;
end;

procedure TForm1.FormShow(Sender: TObject);
var
     sParams   : string;
     iTab      : Integer;
begin
     sParams   := LowerCase(trim(dwGetProp(Self,'params')));
     if sParams <> '' then begin
          for iTab := 0 to PageControl.PageCount-1 do begin
               if LowerCase(PageControl.Pages[iTab].Caption) = sParams then begin
                    PageControl.ActivePageIndex   := iTab;
                    break;
               end;
          end;
     end;

end;

end.
