unit unit1;

interface

uses
     //
     dwBase,

     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.Menus, Vcl.Imaging.jpeg;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.Button1Click(Sender: TObject);
begin
    Memo1.Text  := '''
        # 更新日志

        |  表头   | 表头  |
        |  ----  | ---- |
        | 单元格11  | 单元格12 |
        | 单元格21  | 单元格22 |

        ## 2025-03-26
        ### 服务端
        1. 新增支持在onshow时取得浏览器信息功能。通过dwGetProp(Self,'requestuseragent')，可以在onshow中判断是否为移动端访问；
        2. 增加了DWSGuardor夜间重启的功能, 可在夜间指定时间每5分钟重启一个DWS；

        ### 控件
        1. 为Panel__float增加了caption显示, 后续拟移植到所有panel；
        2. label处理了Wordwrap, 支持换行;否则显示不下时, 会显示3个点；

        ### 案例
        1. 完成了**dwDBCard**模块，可以通过json配置生成卡片式数据显示；
        2. 新增快速微信扫码支付单元dwWechatPay.pas，可以支持快速完成微码支付；
        3. 为quickcrud/dbcard/crudpanel等 (1) 增加了totalfirst设置，支持总记录数显示在左边 (2)采用了小图标, 以支持移动端（需要更新index.css并刷新缓存）；
        4. 解决了quickcrudstat中的一个bug, 好像是access需要有主键, 在配置中添加不可见的id字段即可；
        5. 解决crudpanel在子窗体模式下不能正常上传图片的bug；

        ## 2025-03-08

        - 服务端 DeWebServer
        （1）增加了对页面图标的支持
        可以在Form的Hint中类似设置{"icon":"media/ico/mm.ico"}完成
        如果图标是本地资料, 需要放到media目录下

        （2）采用反引号代替了dwOpenUrl函数中的双引号, 解决了参数中有双引号可能造成的bug
        （3）优化的加载速度
        （4）增加了UDP控制关闭
        （5）更新了DWsGuardor
        -- 关闭采用了udp
        -- 自动控制位置

        - 控件
                （1）增加了高德地图支持, 控件为 dwTShape__amap, 例程为 Amap高德地图
                （2）移除了DBChecked/DBMemo等DB控件
                （3）增加了canvas绘图例程和控件Shape__canvas

        - 例程
            （1）完善dwCrudPanel模块
                         - 解决了integer类似不能查询的bug, 顺便补全了其他不能查询字段
                         - CrudPanel中增加对按钮图标的支持
                 - 解决了datetime字段型查询报错的bug
                         - 修补了dwCrudPanel在pagecontrol可能显示不正常的一个bug(根据顺其自然网友的方法)
                （2）完善dwQuickCrud模块
                        - 消除了dwQuickCard中没有过滤条件时报错的bug
                        - 修补了dwQuickcrud单元在覆盖了原Form的onEndDock单元时, 可能造成的异常, 主要是增加了FindComponent为nil的提示
            （3）完成了微信登录、微信Native支付、微信Jsapi支付、微信扫码识别
            （4）解决了dwFrame的资料管理中上传事件中 QuickCrud单元会自动设置Form的OnEndDock, 影响了图片上传事件的bug

        ''';

    Memo1.ShowHint  := True;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    dwSetPCMode(Self);
end;

end.
