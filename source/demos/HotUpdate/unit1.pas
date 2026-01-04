unit unit1;

interface

uses
    //
    dwBase,


    //
    Math,
    Graphics,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.Buttons;

type
  TForm1 = class(TForm)
    Button_Update: TButton;
    Label1: TLabel;
    Button_Unlock: TButton;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Button_RestartClick(Sender: TObject);
    procedure Button_UpdateClick(Sender: TObject);
    procedure FormEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure Button_UnlockClick(Sender: TObject);
    procedure FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
  private
    { Private declarations }
  public
    gsMainDir   : String;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.Button_UnlockClick(Sender: TObject);
begin
    dwInputQuery('请输入解锁密码','解锁','','确定','取消','query_unlock',self);
end;

procedure TForm1.Button_RestartClick(Sender: TObject);
var
    sJS     : string;
begin
    sJS     := 'var el = document.documentElement;'
            +'var rfs = el.requestFullScreen || el.webkitRequestFullScreen || el.mozRequestFullScreen || el.msRequestFullscreen;'
            +'if(typeof rfs != "undefined" && rfs) {'
            +'    rfs.call(el);'
            +'};';
    dwRunJS(sJS,self);
end;

procedure TForm1.Button_UpdateClick(Sender: TObject);
begin
    dwUpload(self,'.dll','apps');
end;

procedure TForm1.FormEndDock(Sender, Target: TObject; X, Y: Integer);
var
    sName   : string;   //上传完成自动保存的名称
    sSource : string;   //原始名称
    sPure   : string;   //原始名称,不带后缀
    iFile   : Integer;
    bMoved  : Boolean;
begin
    //取得上传的相关信息
    sName   := dwGetProp(self,'__upload');          //上传完成自动保存的名称
    sSource := dwGetProp(self,'__uploadsource');    //原始名称
    sPure   := ChangeFileExt(sSource,'');           //原始名称,不带后缀

    //先尝试删除所有热更新文件
    DeleteFile(gsMainDir+'apps\'+sSource);
    for iFile := 1 to 9 do begin
        DeleteFile(gsMainDir+'apps\'+sPure+'__'+IntToStr(iFile)+'.dll');
    end;

    //找到一个热更新文件名，并移动当前文件到apps目录
    bMoved  := False;
    if FileExists(gsMainDir+'apps\'+sSource) then begin
        //依次查找复制
        for iFile := 1 to 9 do begin
            if not FileExists(gsMainDir+'apps\'+sPure+'__'+IntToStr(iFile)+'.dll') then begin
                bMoved  := MoveFile(PChar(gsMainDir+'apps\'+sName),PChar(gsMainDir+'apps\'+sPure+'__'+IntToStr(iFile)+'.dll'));
                break;
            end;
        end;
    end else begin
        bMoved  := MoveFile(PChar(gsMainDir+'apps\'+sName),PChar(gsMainDir+'apps\'+sSource));
    end;

    //如果移动成功，则提示成功
    if bMoved then begin
        dwShowMessage('Update Success!',self);
    end else begin
        DeleteFile(gsMainDir+'apps\'+sName);
        dwShowMessage('Update False!',self);
    end;

    //关闭进度条
    dwRunJS('this.dwloading=false',self);
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    dwSetMobileMode(self,360,720);
end;

procedure TForm1.FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
var
    sMethod : string;
    sValue  : string;
begin
    //触发的事件标志
    sMethod := dwGetProp(Self,'interactionmethod');

    //得到返回的结果，为输入的内容。
    sValue  := dwGetProp(Self,'interactionvalue');

    //根据触发标志进行判断
    if sMethod = 'query_unlock' then begin
        //当前为输入解锁密码的结果

        //!!!!注意，这里1234改成你的密码================================================================
        if sValue = '1234' then begin
            Button_Unlock.Visible   := False;
            Button_Update.Enabled   := True;
        end;
    end else if sMethod = '__upload_start' then begin
        //当前为开始上传

        //显示进度条
        dwRunJS('this.dwloading=true',self);
    end;

end;

end.
