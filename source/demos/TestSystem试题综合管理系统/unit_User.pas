unit unit_User;

interface

uses
    //deweb基础函数
    dwBase,

    //
    dwQuickCrud,

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
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
        //当前用户使用本模块的权限，格式是JSON的数组字符串，
        //形如            [1,1,1,1,1,1,0,1,0,1],
        //各元素分别表示：显示/运行/增/删/改/查/打印/预留1/预留2/预留3
		gsRights : string;
        qcConfig : String;
  end;


implementation

uses
    Unit1;

{$R *.dfm}


procedure TForm_User.FormShow(Sender: TObject);
begin
    //
    qcConfig    := StyleName;
    dwCrud(self,TForm1(self.Owner).FDConnection1,False,'');
end;

end.
