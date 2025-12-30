unit DBConfig;

interface

uses
    dwVars,
    dwBase,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client;

type
  TForm_DBConfig = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    ComboBox_DriverID: TComboBox;
    Panel2: TPanel;
    Label2: TLabel;
    Edit_DataBase: TEdit;
    Panel3: TPanel;
    Label3: TLabel;
    Edit_User_Name: TEdit;
    Panel4: TPanel;
    Label4: TLabel;
    Edit_Password: TEdit;
    Panel5: TPanel;
    Label5: TLabel;
    Edit_Server: TEdit;
    Panel6: TPanel;
    Button_Test: TButton;
    Button_OK: TButton;
    Button_Cancel: TButton;
    procedure Button_TestClick(Sender: TObject);
    procedure Button_CancelClick(Sender: TObject);
    procedure Button_OKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
    Form_DBConfig: TForm_DBConfig;

implementation

{$R *.dfm}

uses
    dwDM, main;

procedure TForm_DBConfig.Button_CancelClick(Sender: TObject);
begin
    Close;
end;

procedure TForm_DBConfig.Button_OKClick(Sender: TObject);
var
    sConfig : string;
    I       : Integer;
begin
{
    //
    with DM.FDConnection0 do begin
        try
            Close;
            sConfig := Format('DriverID=%s;'
                    +'Server=%s;'
                    +'Database=%s;'
                    +'User_Name=%s;'
                    +'Password=%s;',
                    [ComboBox_DriverID.Text,
                    Edit_Server.Text,
                    Edit_DataBase.Text,
                    Edit_User_Name.Text,
                    Edit_Password.Text]);
            ConnectionString := sConfig;
            Connected   := True;
        except
        end;
        if Connected then begin
            //保存到config.json
            dwLoadFromJson(gjoConfig, gsMainDir+'config.json');
            gjoConfig.connectionstring  := sConfig;
            dwSaveTOJson(gjoConfig,gsMainDir+'config.json',False);
            //更新其他连接
            for I := 1 to 4 do begin
                with TFDConnection(DM.FindComponent('FDConnection'+IntToStr(I))) do begin
                    Close;
                    ConnectionString := sConfig;
                    Connected   := True;
                end;
            end;

            //
            ShowMessage('Config Success and Saved!Please Restart DeWebServer');
            Close;
        end else begin
            ShowMessage('False');
        end;
    end;
}
end;

procedure TForm_DBConfig.Button_TestClick(Sender: TObject);
begin
{    //
    with DM.FDConnection0 do begin
        try
            Close;
            ConnectionString := Format('DriverID=%s;'
                    +'Server=%s;'
                    +'Database=%s;'
                    +'User_Name=%s;'
                    +'Password=%s;',
                    [ComboBox_DriverID.Text,
                    Edit_Server.Text,
                    Edit_DataBase.Text,
                    Edit_User_Name.Text,
                    Edit_Password.Text]);
            Connected   := True;
        except
        end;
        if Connected then begin
            ShowMessage('Success');
        end else begin
            ShowMessage('False');
        end;
    end;
}
end;

procedure TForm_DBConfig.FormShow(Sender: TObject);
var
    sConnect    : string;
    sDriverID   : string;
    sServer     : string;
    sDataBase   : string;
    sUser_Name  : String;
    sPassword   : String;
    //
    iPos        : Integer;
begin
{
    //
    sConnect    := DM.FDConnection0.ConnectionString+';';
    sDriverId   := '';
    iPos    := Pos(LowerCase('DriverID='),LowerCase(sConnect));
    if iPos > 0 then begin
        Delete(sConnect,1,iPos+Length('DriverID=')-1);
        sDriverID   := Copy(sConnect,1,Pos(';',sConnect)-1);
    end;
    ComboBox_DriverID.Text  := sDriverID;

    //
    sConnect    := DM.FDConnection0.ConnectionString+';';
    sServer     := '';
    iPos    := Pos(LowerCase('Server='),LowerCase(sConnect));
    if iPos > 0 then begin
        Delete(sConnect,1,iPos+Length('Server=')-1);
        sServer   := Copy(sConnect,1,Pos(';',sConnect)-1);
    end;
    Edit_Server.Text  := sServer;

    //
    sConnect    := DM.FDConnection0.ConnectionString+';';
    sUser_Name     := '';
    iPos    := Pos(LowerCase('User_Name='),LowerCase(sConnect));
    if iPos > 0 then begin
        Delete(sConnect,1,iPos+Length('User_Name=')-1);
        sUser_Name   := Copy(sConnect,1,Pos(';',sConnect)-1);
    end;
    Edit_User_Name.Text  := sUser_Name;

    //
    sConnect    := DM.FDConnection0.ConnectionString+';';
    sPassword     := '';
    iPos    := Pos(LowerCase('Password='),LowerCase(sConnect));
    if iPos > 0 then begin
        Delete(sConnect,1,iPos+Length('Password=')-1);
        sPassword   := Copy(sConnect,1,Pos(';',sConnect)-1);
    end;
    Edit_Password.Text  := sPassword;

    //
    sConnect    := DM.FDConnection0.ConnectionString+';';
    sDataBase     := '';
    iPos    := Pos(LowerCase('DataBase='),LowerCase(sConnect));
    if iPos > 0 then begin
        Delete(sConnect,1,iPos+Length('DataBase=')-1);
        sDataBase   := Copy(sConnect,1,Pos(';',sConnect)-1);
    end;
    Edit_DataBase.Text  := sDataBase;
}
end;

end.
