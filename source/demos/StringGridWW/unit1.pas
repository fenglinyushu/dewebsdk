unit unit1;
interface
uses
    dwBase,
    dwSGWWUnit,

    //
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Data.DB,
    Data.Win.ADODB, Vcl.Menus, Vcl.Grids, Vcl.DBGrids, Vcl.Samples.Spin, Vcl.Imaging.pngimage;
type
  TForm1 = class(TForm)
    SG: TStringGrid;
    Panel1: TPanel;
    Button_Set: TButton;
    SpinEdit_ColSet: TSpinEdit;
    SpinEdit_RowSet: TSpinEdit;
    Edit_Set: TEdit;
    Panel2: TPanel;
    Button_Get: TButton;
    SpinEdit_ColGet: TSpinEdit;
    SpinEdit_RowGet: TSpinEdit;
    Edit_Get: TEdit;
    Panel3: TPanel;
    Label_Event: TLabel;
    Label2: TLabel;
    Button_SaveToFile: TButton;
    Button_LoadFromFile: TButton;
    B_ToExcel: TButton;
    B_Download: TButton;
    Button1: TButton;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure SGGetEditMask(Sender: TObject; ACol, ARow: Integer; var Value: string);
    procedure Button_SetClick(Sender: TObject);
    procedure Button_GetClick(Sender: TObject);
    procedure Button_SaveToFileClick(Sender: TObject);
    procedure Button_LoadFromFileClick(Sender: TObject);
    procedure B_ToExcelClick(Sender: TObject);
    procedure B_DownloadClick(Sender: TObject);
    procedure SGDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
        gsExcel : string;
  end;
var
     Form1             : TForm1;

implementation

{$R *.dfm}
procedure TForm1.Button1Click(Sender: TObject);
begin
    {
        可以通过类似以上的代码改变字体颜色
        其中
        sg__c25
        在实际应用中
        sg为表格名称， 一般应采用类似以下方式取得
        dwFullName(StringGrid1);
        然后是2个下划线， 为固定分隔符
        c表示cells简写
        25为单元格序号， 左上角为0，从左到右，从上到下排列
        颜色值需要用web的颜色格式
    }
    dwRunJS('document.getElementById("sg__c25").children[0].style.color = "#ff0000";',self);
end;

procedure TForm1.Button_GetClick(Sender: TObject);
begin
    Edit_Get.Text   := dwsgGetCell(SG,SpinEdit_ColGet.Value,SpinEdit_RowGet.Value,0);

end;

procedure TForm1.Button_LoadFromFileClick(Sender: TObject);
begin
    dwsgLoadFromFile(SG,'sg1.json');
    DockSite    := True;
end;

procedure TForm1.Button_SaveToFileClick(Sender: TObject);
begin
    dwsgSaveToFile(SG,'sg.json');
end;

procedure TForm1.Button_SetClick(Sender: TObject);
begin
    dwsgSetCell(SG,SpinEdit_ColSet.Value,SpinEdit_RowSet.Value,0,Edit_Set.Text);

end;

procedure TForm1.B_DownloadClick(Sender: TObject);
begin
    dwOpenURL(self,'/media/temp/'+gsExcel,'_blank');
end;

procedure TForm1.B_ToExcelClick(Sender: TObject);
begin
    //
    gsExcel := FormatDateTime('YYYYMMDD_hhmmss_zzz_',Now)+IntToStr(Random(1000))+'.xls';
    //
    dwsgSaveToExcel(SG,
            ExtractFilePath(Application.ExeName)+'media\temp\'+gsExcel,
            ExtractFilePath(Application.ExeName));
    //
    B_Download.Enabled  := True;
    //
    dwMessage('Export to Excel Success!','success',self);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
    I       : Integer;
    iRow    : Integer;
    iTop    : Integer;
    oLabel  : TLabel;
begin

    //
    with SG do begin
        //设置对齐
        Cells[0,0]  := '{"align":[0,0],"data":"左上"}';
        Cells[0,1]  := '{"align":[0,1],"data":"左中"}';
        Cells[0,2]  := '{"align":[0,2],"data":"左下"}';
        Cells[1,0]  := '{"align":[1,0],"data":"中上"}';
        Cells[1,1]  := '{"align":[1,1],"data":"中中"}';
        Cells[1,2]  := '{"align":[1,2],"data":"中下"}';
        Cells[2,0]  := '{"align":[2,0],"data":"右上"}';
        Cells[2,1]  := '{"align":[2,1],"data":"右中"}';
        Cells[2,2]  := '{"align":[2,2],"data":"右下"}';

        //合并单元格
        Cells[3,0]  := '{"expand":[2,2],"data":"合并单元格"}';

        //列宽
        Cells[6,0]      := '{"data":"列宽"}';
        ColWidths[6]    := 120;

        //行高
        Cells[0,3]      := '{"data":"行高"}';
        RowHeights[3]   := 90;

        //背景色
        Cells[1,3]      := '{"data":"背景","bkcolor":"#0f0"}';

        //字体
        Cells[2,3]      := '{"data":"字体","fontname":"仿宋"}';
        Cells[3,3]      := '{"data":"字号","fontsize":31}';
        Cells[4,3]      := '{"data":"字色","fontcolor":"#00f"}';
        Cells[5,3]      := '{"data":"样式","fontstyle":"1111"}';

        //换行
        Cells[6,2]      := '{"data":"主动<br/>换行"}';
        Cells[6,3]      := '{"data":"这个一个长句子需要换行显示"}';
        Cells[6,4]      := '{"align":[0,0],"data":"左上显示需要换行显示"}';
        //多种颜色组合的字符串
        Cells[6,5]      := '{"align":[0,0],"data":"'
                +'<span style=''color:#f00''>红</span>'
                +'<span style=''color:#0f0''>绿</span>'
                +'<span style=''color:#00f''>蓝</span>'
                +'<b>粗</b>'
                +'<i>斜</i>'
                +'<span style=''font-size:20px''>大</span>'
                +'<span style=''font-size:5px''>小</span>'
                +'"}';

        //
        RowHeights[4]   := 40;
        //编辑框
        Cells[0,4]      := '{"data":"编辑框->","bkcolor":"#eee"}';
        Cells[1,4]      := '{"type":"edit","data":"","placeholder":"请输入","bkcolor":"#eee"}';

        //数字框
        Cells[2,4]      := '{"data":"数字框->","bkcolor":"#eee"}';
        Cells[3,4]      := '{"type":"spin","data":"48","bkcolor":"#eee"}';

        //下拉框
        Cells[4,4]      := '{"data":"下拉框->","bkcolor":"#eee"}';
        Cells[5,4]      := '{"type":"combo","data":"西风","list":["西风","襄阳","华盛顿","纽约"]}';


        //
        RowHeights[5]   := 40;
        //图片
        Cells[0,5]      := '{"data":"图片框->"}';
        Cells[1,5]      := '{"type":"image","data":"media/images/deweb10.png"}';

        //Check框
        Cells[2,5]      := '{"data":"选中框->","bkcolor":"#eee"}';
        Cells[3,5]      := '{"type":"check","data":"true"}';

        //以下为DEMO----------
        Cells[0,6]  := '{"align":[1,1],"data":"管理学院程序员信息","fontcolor":"#000","fontname":"楷体","fontsize":26,"fontstyle":"1000","expand":[6,0],"dwstyle":"border:0;"}';

        //第7行
        RowHeights[7]   := 40;
        //
        Cells[0,7]      := '{"data":"姓名","bkcolor":"#f0f0f0"}';
        Cells[1,7]      := '{"type":"edit","data":"李小宁"}';

        //
        Cells[2,7]      := '{"data":"性别(男)","bkcolor":"#f0f0f0"}';
        Cells[3,7]      := '{"type":"check","data":"false"}';

        //
        Cells[4,7]      := '{"data":"民族","bkcolor":"#f0f0f0"}';
        Cells[5,7]      := '{"type":"combo","data":"汉族","list":["汉族","苗族","维族","壮族"]}';

        //图片
        Cells[6,7]      := '{"type":"image","data":"media/images/mn/zj.png","expand":[0,3]}';

        //第8行
        RowHeights[8]   := RowHeights[7];
        //
        Cells[0,8]      := '{"data":"身高","bkcolor":"#f0f0f0"}';
        Cells[1,8]      := '{"type":"spin","data":"176"}';

        //
        Cells[2,8]      := '{"data":"出生年月","bkcolor":"#f0f0f0"}';
        Cells[3,8]      := '{"type":"edit","data":"2000-02-14"}';

        //
        Cells[4,8]      := '{"data":"政治面貌","bkcolor":"#f0f0f0"}';
        Cells[5,8]      := '{"type":"combo","data":"党员","list":["党员","团员","民主党派","群众"]}';

        //第9行
        RowHeights[9]   := RowHeights[7];

        //
        Cells[0,9]      := '{"data":"学制","bkcolor":"#f0f0f0"}';
        Cells[1,9]      := '{"type":"spin","data":"4"}';

        //
        Cells[2,9]      := '{"data":"学历","bkcolor":"#f0f0f0"}';
        Cells[3,9]      := '{"type":"combo","data":"本科","list":["专科","本科","硕士","博士"]}';

        //
        Cells[4,9]      := '{"data":"毕业时间","bkcolor":"#f0f0f0"}';
        Cells[5,9]      := '{"type":"edit","data":"2021年6月"}';

        //第10行
        RowHeights[10]   := RowHeights[7];

        //
        Cells[0,10]     := '{"data":"专业","bkcolor":"#f0f0f0"}';
        Cells[1,10]     := '{"type":"edit","data":"程序设计","expand":[1,0]}';

        //
        Cells[3,10]     := '{"data":"毕业院校","bkcolor":"#f0f0f0"}';
        Cells[4,10]     := '{"type":"edit","data":"西安电子科技大学","expand":[1,0]}';

        //第11行
        RowHeights[11]   := RowHeights[7];
        Cells[0,11]     := '{"data":"技能特长或爱好","fontstyle":"1000","expand":[6,0]}';

        //第12行
        RowHeights[12]   := RowHeights[7];
        Cells[0,12]     := '{"data":"获奖情况","bkcolor":"#f0f0f0","expand":[1,0]}';
        Cells[2,12]     := '{"type":"edit","data":"C程序设计3级","expand":[4,0]}';

        //第13行
        RowHeights[13]   := RowHeights[7];
        Cells[0,13]     := '{"data":"特长爱好","bkcolor":"#f0f0f0","expand":[1,0]}';
        Cells[2,13]     := '{"type":"edit","data":"羽毛球、足球、音乐","expand":[4,0]}';

        //第14行
        RowHeights[14]   := RowHeights[7]*5;
        Cells[0,14]     := '{"data":"简历","bkcolor":"#f0f0f0","expand":[1,0]}';
        Cells[2,14]     := '{"type":"memo","data":"DeWeb是一个可以直接将Delphi程序快速转换为网页应用的工具！使用DeWeb, 开发者不需要学习HTML/CSS、JavaScript、Java、PHP、ASP、C#等新知识，用Delphi搞定一切。","expand":[4,0]}';

        Cells[0,1]      := '{"type":"edit","data":"","placeholder":"请输入工作内容","bkcolor":"#eee"}';
        Cells[0,2]      := '{"type":"spin","data":"0","bkcolor":"#eee"}';
        Cells[0,3]      := '{"type":"check","data":"false"}';
    end;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    dwSetPCMode(Self);
end;
procedure TForm1.SGDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
    //
    Label_Event.Caption := Format('当前点击!行：%d,列：%d',[Y,X]);

end;

procedure TForm1.SGGetEditMask(Sender: TObject; ACol, ARow: Integer; var Value: string);
begin
    //
    Label_Event.Caption := Format('当前行：%d,列：%d, 值：%s',[ARow,ACol,dwsgGetCell(SG,ACol,ARow,0)]);
end;

end.
