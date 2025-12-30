unit unit_Document;

interface

uses
    //deweb基础函数
    dwBase,
    //
    dwCrudPanel,

    //
    Math,
    ComObj,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask,
    Vcl.Samples.Spin, Vcl.ComCtrls, Vcl.Grids, Data.DB, Data.Win.ADODB, Vcl.ExtCtrls, Vcl.Buttons,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TForm_Document = class(TForm)
    BUd: TButton;
    FDQuery1: TFDQuery;
    BPr: TButton;
    Pn1: TPanel;
    procedure FormShow(Sender: TObject);
    procedure BUdClick(Sender: TObject);
    procedure FormEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure BPrClick(Sender: TObject);
  private
    { Private declarations }
  public
    qcConfig    : String;
    gsRights    : String;

  end;


implementation

uses
    Unit1;


{$R *.dfm}




procedure TForm_Document.BPrClick(Sender: TObject);
var
    oFQ     : TFDQuery;
    sFile   : String;
    sExt    : String;
begin
    //取得数据库控件
    oFQ := cpGetFDQuery(Pn1);

    //得到文件
    sFile   := oFQ.FieldByName('dFileName').AsString+'.'+oFQ.FieldByName('dFileType').AsString;

    //得到扩展名
    sExt    := LowerCase(oFQ.FieldByName('dFileType').AsString);

    //如果文件存在，则在线预览
    if FileExists(ExtractFilePath(Application.ExeName)+'media\doc\dwframe\'+sFile) then begin
        if sExt ='pdf' then begin
            dwOpenUrl(self,'/pdf?file=/media/doc/dwframe/'+dwEscape(sFile),'_blank');
        end else if sExt = 'mp3' then begin
            dwOpenUrl(self,'/mp3?file=/media/doc/dwframe/'+dwEscape(sFile),'_blank');
        end else if sExt = 'mp4' then begin
            dwOpenUrl(self,'/mp4?file=/media/doc/dwframe/'+dwEscape(sFile),'_blank');
        end else if (sExt = 'doc') or (sExt = 'docx') or (sExt = 'xls') or(sExt = 'xlsx') or(sExt = 'ppt') or(sExt = 'pptx') then begin
            dwOpenUrl(self,'https://view.officeapps.live.com/op/view.aspx?src=https://delphibbs.com/media/doc/dwframe/'+dwEscape(sFile),'_blank');
        end else begin
            dwOpenUrl(self,'/media/doc/dwframe/'+(sFile),'_blank');
        end;
    end else begin
        dwMessage('文件不存在!','error',self);
    end;
end;

procedure TForm_Document.BUdClick(Sender: TObject);
begin
    dwUpload(
        Self,
        //文件类型
        '.doc,.docx.xls,.xlsx,.pdf,.ppt,.pptx,.txt,.jpg,.png,.gif,.mp4,.mp3',
        //目标目录
        'media/doc/dwframe'
    );
end;

procedure TForm_Document.FormEndDock(Sender, Target: TObject; X, Y: Integer);
var
    sFile       : string;
    sSource     : String;
    sExt        : string;
    sDir        : String;
begin
    //得到最终上传的文件名
    sFile   := dwGetProp(self,'__upload');
    sSource := dwGetProp(self,'__uploadsource');
    sExt    := LowerCase(ExtractFileExt(sFile));
    Delete(sExt,1,1);   //删除前面的.

    //复制文件到系统的文档目录
    //MoveFile(PWideChar(ExtractFilePath(Application.ExeName)+'upload\'+sFile),
    //    PWideChar(ExtractFilePath(Application.ExeName)+'media\doc\dwframe\'+sSource));

    sDir    := ExtractFilePath(Application.ExeName)+'media\doc\dwframe\';
    RenameFile(sDir+sFile,sDir+sSource);

    //插入数据表记录
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'INSERT INTO eDocument (dFileName,dFileType,dUserName,dMode,dDate) '
            +Format('VALUES(''%s'',''%s'',''%s'',''%s'',''%s'')',
            [
                ChangeFileExt(sSource,''),
                sExt,
                TForm1(self.Owner).gjoUserInfo.username,
                '私密',
                FormatDateTime('yyyy-MM-DD hh:mm:ss',Now)
            ]);
    FDQuery1.ExecSQL;

    //更新数据
    cpUpdate(Pn1,'');

    //
    dwMessage('上传完成！','success',self);
end;

procedure TForm_Document.FormShow(Sender: TObject);
begin

    //创建quickcrud
    cpInit(Pn1,TForm1(Self.Owner).FDConnection1,False,'');

    //将上传/预览按钮嵌入到quickcrud中的按钮组面板中
    cpAddInButtons(Pn1,BUd);
    cpAddInButtons(Pn1,BPr);

    //设置FDQuery1的连接，以用于上传完成后，插入数据
    FDQuery1.Connection := TForm1(Self.Owner).FDConnection1;

end;

end.
