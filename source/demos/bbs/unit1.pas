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

function TForm1.bbsTimeToStr(ATime: Double): String;   //����ת�ַ���
var
     fDelta    : Double;
     iSecs     : Integer;
begin
     fDelta    := Now - ATime;
     iSecs     := Round(fDelta * 24*3600);
     //
     if iSecs < 60 then begin
          Result    := IntToStr(iSecs)+'��ǰ';
     end else if iSecs < 3600 then begin
          Result    := IntToStr(iSecs div 60)+'����ǰ';
     end else if fDelta < 30 then begin
          Result    := IntToStr(Round(fDelta))+'��ǰ';
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
     //Ĭ��Ϊ��1ҳ,������̳���޹ؼ���
     giPageNo  := 0;
     giForumNo := 0;
     gsKeyword := '';

     //��̬���ɸ�����
     for I := 0 to 19 do begin
          oPanel    := TPanel(CloneComponent(Panel_Thread));
          oPanel.Visible := True;
          oPanel.Top     := 9999;
     end;
     //�õ׷�ҳ����
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
          //<����ҳ��
          //�����ݱ�
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



          //�����ݱ�
          sSQL := 'SELECT '
                    +'a.last_date,'     //���ظ�ʱ��
                    +'a.tid,'           //thread id
                    +'a.subject,'       //����
                    +'a.posts,'         //�ظ���
                    +'a.views,'         //�����
                    +'a.likes,'         //ϲ����
                    +'a.lastpid,'       //���ظ���ID
                    +'a.uid,'           //������
                    +'a.fid,'           //
                    +'a.lastuid,'       //���ظ���
                    +'a.create_date'    //����ʱ��
                    +',b.username'      //�û���
                    +',c.username lastname'  //���ظ�������
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
          sSQL := sSQL +' ORDER BY a.last_date DESC '     //�����ظ�ʱ�䵹��
                    +' LIMIT 20 OFFSET '+IntToStr(APageID*20) //���
                    ;

          FDQuery.Close;
          FDQuery.SQL.Text    := sSQL;
          FDQuery.Open;


          //���á���һҳ��
          Button_Next.Enabled := True;
          Button_Last.Enabled := True;

          //������ʾ
          for iItem := 0 to 19 do begin
               if FDQuery.Eof then begin
                    //ͷ��
                    with TImage(Self.FindComponent('Image_Poster'+IntToStr(iItem+1))) do begin
                         Visible   := False;
                    end;

                    //����
                    with TStaticText(Self.FindComponent('StaticText_Thread'+IntToStr(iItem+1))) do begin
                         Visible   := False;
                    end;

                    //��̳(Forum)
                    with TStaticText(Self.FindComponent('StaticText_Forum'+IntToStr(iItem+1))) do begin
                         Visible   := False;
                    end;

                    //����
                    with TStaticText(Self.FindComponent('StaticText_UperInfo'+IntToStr(iItem+1))) do begin
                         Visible   := False;
                    end;

                    //�ظ�/�Ķ�
                    //TStaticText(Self.FindComponent('StaticText_ReplyRead'+IntToStr(iItem+1))).Caption := '';

                    //����
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

                    //���ظ�ʱ��
                    //TLabel(Self.FindComponent('StaticText_LastPostTime'+IntToStr(iItem+1))).Caption := '';

                    //���á���һҳ��
                    Button_Next.Enabled := False;
                    Button_Last.Enabled := False;
               end else begin
                    //ͷ��
                    with TImage(Self.FindComponent('Image_Poster'+IntToStr(iItem+1))) do begin
                         Visible   := True;
                    end;

                    //��̳(Forum)
                    with TStaticText(Self.FindComponent('StaticText_Forum'+IntToStr(iItem+1))) do begin
                         Visible   := True;
                         Caption   := ' ['+(Trim(FDQuery.FieldByName('forumname').AsString))+'] ';
                         Hint      := '{"href":"/bbs.dw?'
                                   +'forum='+FDQuery.FieldByName('fid').AsString
                                   +'"}';
                         AutoSize  := False;
                         AutoSize  := True;
                    end;

                    //����
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

                    //����+ʱ��
                    with TStaticText(Self.FindComponent('StaticText_UperInfo'+IntToStr(iItem+1))) do begin
                         Visible   := True;
                         Caption := (FDQuery.FieldByName('username').AsString)+' '+bbsTimeToStr(dwPHPToDate(FDQuery.FieldByName('create_date').AsInteger))+'   ';
                         Hint      := '{"href":"/bbs_user.dw?user='+FDQuery.FieldByName('uid').AsString+'"}';
                    end;


                    //�ظ�
                    with TStaticText(Self.FindComponent('StaticText_Replyer'+IntToStr(iItem+1))) do begin
                         Visible   := True;
                         Caption   := '  �� ��'+(FDQuery.FieldByName('lastname').AsString)+' '+bbsTimeToStr(dwPHPToDate(FDQuery.FieldByName('last_date').AsInteger))+'   ';
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
