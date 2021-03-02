unit unit1;

interface

uses
     //
     dwBase,

     //
     CloneComponents,

     //
     Math,
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
     Vcl.Imaging.pngimage, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
     FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait, Data.DB,
     FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
     FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TForm1 = class(TForm)
    Panel_All: TPanel;
    Panel_00_Banner: TPanel;
    Panel_00_Center: TPanel;
    Image_logo: TImage;
    Label_FAQs: TLabel;
    Label_Download: TLabel;
    Label_ContactUs: TLabel;
    Label_gitee: TLabel;
    Label_blog: TLabel;
    Label3: TLabel;
    Label10: TLabel;
    StaticText_Home: TStaticText;
    Forum1: TStaticText;
    Forum2: TStaticText;
    Forum3: TStaticText;
    Forum4: TStaticText;
    Forum5: TStaticText;
    Forum6: TStaticText;
    Forum7: TStaticText;
    Button_Login: TButton;
    Panel_01_Content: TPanel;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel_01_Right: TPanel;
    Panel_01_Center: TPanel;
    Button_NewThread: TButton;
    Panel_ForumName: TPanel;
    Panel_Stat: TPanel;
    Label_ForumName: TLabel;
    Label_Creator: TLabel;
    Panel_StatThreads: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Panel2: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    Panel3: TPanel;
    Label14: TLabel;
    Label15: TLabel;
    Panel_Line0: TPanel;
    Panel_Thread: TPanel;
    Panel_LineH: TPanel;
    Image_Poster: TImage;
    Panel_T_Client: TPanel;
    Panel_T_C_Top: TPanel;
    Panel_T_C_Client: TPanel;
    Label_Goods: TLabel;
    Panel_Search: TPanel;
    Panel5: TPanel;
    Edit_Search: TEdit;
    Button_Search: TButton;
    StaticText_Forum: TStaticText;
    StaticText_Thread: TStaticText;
    StaticText_UperInfo: TStaticText;
    Image_Good: TImage;
    Image_Msg: TImage;
    Label_Msgs: TLabel;
    Image_View: TImage;
    Label_Views: TLabel;
    StaticText_Replyer: TStaticText;
    FDQuery: TFDQuery;
    Panel_Pages: TPanel;
    Edit_PageNo: TEdit;
    Button_Next: TButton;
    Button_First: TButton;
    Button_Prev: TButton;
    Button_Last: TButton;
    Button_Goto: TButton;
    Panel4: TPanel;
    FDConnection: TFDConnection;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Button_FirstClick(Sender: TObject);
    procedure Button_PrevClick(Sender: TObject);
    procedure Button_NextClick(Sender: TObject);
    procedure Button_LastClick(Sender: TObject);
    procedure Button_GotoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button_SearchClick(Sender: TObject);
    procedure Button_LoginClick(Sender: TObject);
  private
    { Private declarations }
  public
     giPageNo : Integer;
     giForumNo : Integer;
     gsKeyword : string;
     giMaxPage : Integer;
     procedure UpdateThreads(APageID,AForumID,AUserID:Integer;AKeyword:String);
     function  bbsTimeToStr(ATime:Double):String;
  end;

var
     Form1: TForm1;

implementation

{$R *.dfm}

function TForm1.bbsTimeToStr(ATime: Double): String;   //日期转字符串
var
     fDelta    : Double;
     iSecs     : Integer;
begin
     fDelta    := Now - ATime;
     iSecs     := Round(fDelta * 24*3600);
     //
     if iSecs < 60 then begin
          Result    := IntToStr(iSecs)+'秒前';
     end else if iSecs < 3600 then begin
          Result    := IntToStr(iSecs div 60)+'分钟前';
     end else if fDelta < 30 then begin
          Result    := IntToStr(Round(fDelta))+'天前';
     end else begin
          Result    := FormatDateTime('YYYY-MM-DD hh:mm:ss',ATime);
     end;
end;

procedure TForm1.Button_FirstClick(Sender: TObject);
begin
     giPageNo  := 0;
     UpdateThreads(giPageNo,giForumNo,0,gsKeyword);

end;

procedure TForm1.Button_GotoClick(Sender: TObject);
begin
     giPageNo  := StrToIntDef(Edit_PageNo.Text,giPageNo+1);
     giPageNo  := giPageNo-1;
     UpdateThreads(giPageNo,giForumNo,0,gsKeyword);

end;

procedure TForm1.Button_LastClick(Sender: TObject);
begin
     giPageNo  := giMaxPage;
     UpdateThreads(giPageNo,giForumNo,0,gsKeyword);

end;

procedure TForm1.Button_LoginClick(Sender: TObject);
begin
     dwOpenUrl(self,'/bbs_login.dw','_self');
end;

procedure TForm1.Button_NextClick(Sender: TObject);
begin
     giPageNo  := Min(giMaxPage,giPageNo+1);
     UpdateThreads(giPageNo,giForumNo,0,gsKeyword);
end;

procedure TForm1.Button_PrevClick(Sender: TObject);
begin
     giPageNo  := Max(0,giPageNo-1);
     UpdateThreads(giPageNo,giForumNo,0,gsKeyword);
end;

procedure TForm1.Button_SearchClick(Sender: TObject);
begin
     gsKeyword := Edit_Search.Text;

     //
     giPageNo  := 0;
     UpdateThreads(giPageNo,giForumNo,0,gsKeyword);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
     I         : Integer;
     oPanel    : TPanel;
begin
     //默认为第1页,所有论坛，无关键字
     giPageNo  := 0;
     giForumNo := 0;
     gsKeyword := '';

     //动态生成各主题
     for I := 0 to 19 do begin
          oPanel    := TPanel(CloneComponent(Panel_Thread));
          oPanel.Visible := True;
          oPanel.Top     := 9999;
     end;
     //置底分页控制
     Panel_Pages.Top     := 99999;


end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     //
     Width     := X-24;
end;

procedure TForm1.FormShow(Sender: TObject);
var
     sParams   : string;
begin
     //?forum=1

     //
     sParams   := dwGetProp(Self,'params');

     //
     if Pos('forum=',sParams)>0 then begin
          Delete(sParams,1,6);
          giForumNo := StrToIntDef(sParams,0);
     end;

     //
     UpdateThreads(giPageNo,giForumNo,0,gsKeyword);
end;

procedure TForm1.UpdateThreads(APageID, AForumID, AUserID: Integer; AKeyword: String);
var
     iItem     : Integer;
     iCount    : Integer;
     sSQL      : String;
begin
     try
          //<求总页数
          //打开数据表
          sSQL := 'SELECT count(*)'
                    +' FROM bbs_thread a LEFT JOIN bbs_user b ON a.uid=b.uid LEFT JOIN bbs_user c ON a.lastuid=c.uid LEFT JOIN bbs_forum d ON a.fid=d.fid';
          if (AUserID>0) or (AForumID>0) or (AUserID>0) or (AKeyword<>'') then begin
               sSQL := sSQL + ' WHERE True';
          end;

          if (AUserID>0) then begin
               sSQL := sSQL + ' AND a.uid='+IntToStr(AUserID);
          end;
          if (AForumID > 0) then begin
               sSQL := sSQL + ' AND a.fid='+IntToStr(AForumID);
          end;
          if AKeyword <> '' then begin
               sSQL := sSQL + ' AND ((a.subject LIKE "%'+AKeyword+'%") or (b.username LIKE "%'+AKeyword+'%"))';
          end;

          FDQuery.Close;
          FDQuery.SQL.Text    := sSQL;
          FDQuery.Open;
          iCount    := FDQuery.Fields[0].AsInteger;
          giMaxPage := (iCount-1) div 20;
          //>



          //打开数据表
          sSQL := 'SELECT '
                    +'a.last_date,'     //最后回复时间
                    +'a.tid,'           //thread id
                    +'a.subject,'       //主题
                    +'a.posts,'         //回复数
                    +'a.views,'         //浏览数
                    +'a.likes,'         //喜欢数
                    +'a.lastpid,'       //最后回复贴ID
                    +'a.uid,'           //题主？
                    +'a.fid,'           //
                    +'a.lastuid,'       //最后回复者
                    +'a.create_date'    //提问时间
                    +',b.username'      //用户名
                    +',c.username lastname'  //最后回复者名称
                    +',d.name forumname'
                    +' FROM bbs_thread a LEFT JOIN bbs_user b ON a.uid=b.uid LEFT JOIN bbs_user c ON a.lastuid=c.uid LEFT JOIN bbs_forum d ON a.fid=d.fid';
          if (AUserID>0) or (AForumID>0) or (AUserID>0) or (AKeyword<>'') then begin
               sSQL := sSQL + ' WHERE True';
          end;


          if (AUserID>0) then begin
               sSQL := sSQL + ' AND a.uid='+IntToStr(AUserID);
          end;
          if (AForumID > 0) then begin
               sSQL := sSQL + ' AND a.fid='+IntToStr(AForumID);
          end;
          if AKeyword <> '' then begin
               sSQL := sSQL + ' AND ((a.subject LIKE "%'+AKeyword+'%") or (b.username LIKE "%'+AKeyword+'%"))';
          end;
          //
          sSQL := sSQL +' ORDER BY a.last_date DESC '     //以最后回复时间倒序
                    +' LIMIT 20 OFFSET '+IntToStr(APageID*20) //序号
                    ;

          FDQuery.Close;
          FDQuery.SQL.Text    := sSQL;
          FDQuery.Open;


          //许用“下一页”
          Button_Next.Enabled := True;
          Button_Last.Enabled := True;

          //更新显示
          for iItem := 0 to 19 do begin
               if FDQuery.Eof then begin
                    //头像
                    with TImage(Self.FindComponent('Image_Poster'+IntToStr(iItem+1))) do begin
                         Visible   := False;
                    end;

                    //主题
                    with TStaticText(Self.FindComponent('StaticText_Thread'+IntToStr(iItem+1))) do begin
                         Visible   := False;
                    end;

                    //论坛(Forum)
                    with TStaticText(Self.FindComponent('StaticText_Forum'+IntToStr(iItem+1))) do begin
                         Visible   := False;
                    end;

                    //题主
                    with TStaticText(Self.FindComponent('StaticText_UperInfo'+IntToStr(iItem+1))) do begin
                         Visible   := False;
                    end;

                    //回复/阅读
                    //TStaticText(Self.FindComponent('StaticText_ReplyRead'+IntToStr(iItem+1))).Caption := '';

                    //提问
                    with TStaticText(Self.FindComponent('StaticText_Replyer'+IntToStr(iItem+1))) do begin
                         Visible   := False;
                    end;

                    //
                    with TImage(FindComponent('Image_View'+IntToStr(iItem+1))) do begin
                         Visible   := False;
                    end;
                    with TImage(FindComponent('Image_Msg'+IntToStr(iItem+1))) do begin
                         Visible   := False;
                    end;
                    with TImage(FindComponent('Image_Good'+IntToStr(iItem+1))) do begin
                         Visible   := False;
                    end;
                    with TLabel(FindComponent('Label_Views'+IntToStr(iItem+1))) do begin
                         Visible   := False;
                    end;
                    with TLabel(FindComponent('Label_Msgs'+IntToStr(iItem+1))) do begin
                         Visible   := False;
                    end;
                    with TLabel(FindComponent('Label_Goods'+IntToStr(iItem+1))) do begin
                         Visible   := False;
                    end;

                    //最后回复时间
                    //TLabel(Self.FindComponent('StaticText_LastPostTime'+IntToStr(iItem+1))).Caption := '';

                    //禁用“下一页”
                    Button_Next.Enabled := False;
                    Button_Last.Enabled := False;
               end else begin
                    //头像
                    with TImage(Self.FindComponent('Image_Poster'+IntToStr(iItem+1))) do begin
                         Visible   := True;
                    end;

                    //论坛(Forum)
                    with TStaticText(Self.FindComponent('StaticText_Forum'+IntToStr(iItem+1))) do begin
                         Visible   := True;
                         Caption   := ' ['+(Trim(FDQuery.FieldByName('forumname').AsString))+'] ';
                         Hint      := '{"href":"/bbs.dw?'
                                   +'forum='+FDQuery.FieldByName('fid').AsString
                                   +'"}';
                         AutoSize  := False;
                         AutoSize  := True;
                    end;

                    //主题
                    with TStaticText(Self.FindComponent('StaticText_Thread'+IntToStr(iItem+1))) do begin
                         Visible   := True;
                         Caption   := dwGetText((Trim(FDQuery.FieldByName('subject').AsString)),80);
                         Hint      := '{"href":"/bbs_thread.dw?'
                                   +'tid='+FDQuery.FieldByName('tid').AsString
                                   //+'&&uid='+FDQuery.FieldByName('uid').AsString
                                   //+'&&create_date='+FDQuery.FieldByName('create_date').AsString
                                   //+'&&subject='+dwEscape((FDQuery.FieldByName('subject').AsString))
                                   //+'&&uper='+dwEscape((FDQuery.FieldByName('username').AsString))
                                   +'"}';
                    end;

                    //题主+时间
                    with TStaticText(Self.FindComponent('StaticText_UperInfo'+IntToStr(iItem+1))) do begin
                         Visible   := True;
                         Caption := (FDQuery.FieldByName('username').AsString)+' '+bbsTimeToStr(dwPHPToDate(FDQuery.FieldByName('create_date').AsInteger))+'   ';
                         Hint      := '{"href":"/bbs_user.dw?user='+FDQuery.FieldByName('uid').AsString+'"}';
                    end;


                    //回复
                    with TStaticText(Self.FindComponent('StaticText_Replyer'+IntToStr(iItem+1))) do begin
                         Visible   := True;
                         Caption   := '  ← 　'+(FDQuery.FieldByName('lastname').AsString)+' '+bbsTimeToStr(dwPHPToDate(FDQuery.FieldByName('last_date').AsInteger))+'   ';
                         Hint      := '{"href":"/dfw_user.dw?user='+FDQuery.FieldByName('lastuid').AsString+'"}';
                         Left      := 999;
                    end;

                    //
                    with TImage(FindComponent('Image_View'+IntToStr(iItem+1))) do begin
                         Visible   := True;
                         Left      := 9000;
                    end;
                    with TLabel(FindComponent('Label_Views'+IntToStr(iItem+1))) do begin
                         Visible   := True;
                         Caption   := FDQuery.FieldByName('views').AsString+' ';
                         Left      := 9100;
                    end;
                    with TImage(FindComponent('Image_Msg'+IntToStr(iItem+1))) do begin
                         Visible   := True;
                         Left      := 9200;
                    end;
                    with TLabel(FindComponent('Label_Msgs'+IntToStr(iItem+1))) do begin
                         Visible   := True;
                         Caption   := FDQuery.FieldByName('posts').AsString+' ';
                         Left      := 9300;
                    end;
                    with TImage(FindComponent('Image_Good'+IntToStr(iItem+1))) do begin
                         Visible   := True;
                         Left      := 9400;
                    end;
                    with TLabel(FindComponent('Label_Goods'+IntToStr(iItem+1))) do begin
                         Visible   := True;
                         Caption   := FDQuery.FieldByName('likes').AsString+' ';
                         Left      := 9500;
                    end;


                    //
                    FDQuery.Next;
               end;
          end;

          //
          Edit_PageNo.Text    := IntToSTr(APageID+1);
     except
     end;
end;

end.
