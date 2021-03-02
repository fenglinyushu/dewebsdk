unit unit1;

interface

uses
     //
     dwBase,

     //
     SynCommons,
     CloneComponents,
     ZAbstractRODataset, ZDataset,ZConnection,

     //
     Math,
     Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
     Dialogs, jpeg, ExtCtrls, StdCtrls, DB, Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    Panel_99_Foot: TPanel;
    Label14: TLabel;
    Label15: TLabel;
    Panel4: TPanel;
    Panel_All: TPanel;
    Panel_00: TPanel;
    Panel_0_Thread: TPanel;
    Panel_1_Pages: TPanel;
    Edit_PageNo: TEdit;
    Button_Next: TButton;
    Button_First: TButton;
    Button_Prev: TButton;
    Button_Last: TButton;
    Button_Goto: TButton;
    Panel1: TPanel;
    Panel_Info: TPanel;
    StaticText_Uper: TStaticText;
    StaticText_LastPost: TStaticText;
    StaticText_ReplyRead: TStaticText;
    StaticText_LastPostTime: TStaticText;
    Panel_00_Logo: TPanel;
    Panel_Line: TPanel;
    Panel_Inner0: TPanel;
    Edit_Search: TEdit;
    Panel_01_Menu: TPanel;
    Panel_line1: TPanel;
    Panel_Inner1: TPanel;
    Label_FAQs: TLabel;
    Label_Download: TLabel;
    Label_ContactUs: TLabel;
    Label_gitee: TLabel;
    Label_blog: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel_10_Content: TPanel;
    Panel_09_Titles: TPanel;
    Panel5: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Button_Login: TButton;
    Button_Upload: TButton;
    Panel_9_line: TPanel;
    StaticText_Subject: TStaticText;
    Label10: TLabel;
    Image_Picture: TImage;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Timer_GetCookie: TTimer;
    Label_UserNameLine: TLabel;
    Button_UserName: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button_NextClick(Sender: TObject);
    procedure Button_FirstClick(Sender: TObject);
    procedure Button_PrevClick(Sender: TObject);
    procedure Button_LastClick(Sender: TObject);
    procedure Button_GotoClick(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure Button_LoginClick(Sender: TObject);
    procedure Edit_SearchChange(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label11Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label18Click(Sender: TObject);
    procedure Label16Click(Sender: TObject);
    procedure Label13Click(Sender: TObject);
    procedure Label12Click(Sender: TObject);
    procedure Label17Click(Sender: TObject);
    procedure Timer_GetCookieTimer(Sender: TObject);
  private
    { Private declarations }
  public
     giPageNo : Integer;
     giForumNo : Integer;
     ZQuery : TZReadOnlyQuery;
     procedure UpdateThreads(APageID,AForumID,AUserID:Integer;AKeyword:String);

    { Public declarations }
  end;

var
     Form1  : TForm1;

const
     _WEBSITE  = '';//http://127.0.0.1/';

implementation

{$R *.dfm}



procedure TForm1.FormCreate(Sender: TObject);
type
     PdwGetConn   = function ():TZConnection;StdCall;
var
     iItem     : Integer;
     oPanel    : TPanel;
     iDll      : Integer;
     //
     fGetConn  : PdwGetConn;
begin
     //����TOP, �������༭ʱ�ĸ���
     Top  := 0;

     //
     ZQuery    := TZReadOnlyQuery.Create(self);

     //�õ�ZConnection
     if FileExists('dwZConnection.dll') then begin
          iDll      := LoadLibrary('dwZConnection.dll');
          fGetConn  := GetProcAddress(iDll,'dwGetConnection');

          ZQuery.Connection   := fGetConn;
     end;



     //Ĭ��Ϊ��1ҳ
     giPageNo  := 0;
     giForumNo := 0;

     //��̬����������
     for iItem := 0 to 19 do begin
          oPanel    := TPanel(CloneComponent(Panel_0_Thread));
          oPanel.Visible := True;
          oPanel.Top     := 9900+iItem;
     end;
     Panel_1_Pages.Top     := 9999;

     //
     Panel_00.Height          := Panel_0_Thread.Height*20 + Panel_1_Pages.Height;
     Panel_10_Content.Height  := Panel_00.Height;

     //
     Panel_All.Height    := Panel_00_Logo.Height +  Panel_01_Menu.Height
               + Panel_10_Content.Height +  Panel_99_Foot.Height
               +2*Panel_All.BorderWidth+50;
   

     //
     dwSetHeight(Self,Panel_All.Height);

     //
     UpdateThreads(giPageNo,giForumNo,0,'');


end;

procedure TForm1.UpdateThreads(APageID,AForumID,AUserID:Integer;AKeyword:String);
var
     iItem     : Integer;
     sSQL      : String;
begin
     try
          //�����ݱ�
          sSQL := 'SELECT '
                    +'a.last_date,'     //���ظ�ʱ��
                    +'a.tid,'           //thread id
                    +'a.subject,'       //����
                    +'a.posts,'         //�ظ���
                    +'a.views,'         //�����
                    +'a.lastpid,'       //���ظ���ID
                    +'a.uid,'           //������
                    +'a.lastuid,'       //���ظ���
                    +'a.create_date'    //����ʱ��
                    +',b.username'      //�û���
                    +',c.username lastname'  //���ظ�������
                    +' FROM bbs_thread a LEFT JOIN bbs_user b ON a.uid=b.uid LEFT JOIN bbs_user c ON a.lastuid=c.uid ';
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

          ZQuery.Close;
          ZQuery.SQL.Text    := sSQL;
          ZQuery.Open;


          //���á���һҳ��
          Button_Next.Enabled := True;
          Button_Last.Enabled := True;

          //������ʾ
          for iItem := 0 to 19 do begin
               if ZQuery.Eof then begin
                    //ͷ��
                    with TImage(Self.FindComponent('Image_Picture'+IntToStr(iItem+1))) do begin
                         Visible   := False;
                    end;

                    //����
                    with TStaticText(Self.FindComponent('StaticText_Subject'+IntToStr(iItem+1))) do begin
                         Caption   := '';
                         Hint      := '{"href":""}';
                    end;

                    //����
                    with TStaticText(Self.FindComponent('StaticText_Uper'+IntToStr(iItem+1))) do begin
                         Caption   := '';
                         Hint      := '{"href":""}';
                    end;

                    //�ظ�/�Ķ�
                    TStaticText(Self.FindComponent('StaticText_ReplyRead'+IntToStr(iItem+1))).Caption := '';

                    //����
                    with TStaticText(Self.FindComponent('StaticText_LastPost'+IntToStr(iItem+1))) do begin
                         Caption   := '';
                         Hint      := '{"href":""}';
                    end;

                    //���ظ�ʱ��
                    TLabel(Self.FindComponent('StaticText_LastPostTime'+IntToStr(iItem+1))).Caption := '';

                    //���á���һҳ��
                    Button_Next.Enabled := False;
                    Button_Last.Enabled := False;
               end else begin
                    //ͷ��
                    with TImage(Self.FindComponent('Image_Picture'+IntToStr(iItem+1))) do begin
                         Visible   := True;
                    end;

                    //����
                    with TStaticText(Self.FindComponent('StaticText_Subject'+IntToStr(iItem+1))) do begin
                         //Caption   := (Trim(ZQuery.FieldByName('subject').AsString));
                         Caption   := dwGetText((Trim(ZQuery.FieldByName('subject').AsString)),80);
                         Hint      := '{"href":"'+_WEBSITE+'dfw_thread.dw?'
                                   +'tid='+ZQuery.FieldByName('tid').AsString
                                   +'&&uid='+ZQuery.FieldByName('uid').AsString
                                   +'&&create_date='+ZQuery.FieldByName('create_date').AsString
                                   +'&&subject='+dwEscape((ZQuery.FieldByName('subject').AsString))
                                   +'&&uper='+dwEscape((ZQuery.FieldByName('username').AsString))
                                   +'"}';
                         //Width     := 484;
                         //Left      := 0;
                    end;

                    //����
                    with TStaticText(Self.FindComponent('StaticText_Uper'+IntToStr(iItem+1))) do begin
                         Caption := (ZQuery.FieldByName('username').AsString);
                         Hint      := '{"href":"'+_WEBSITE+'dfw_user.dw?uid='+ZQuery.FieldByName('uid').AsString+'"}';
                    end;

                    //�ظ�/�Ķ�
                    with TStaticText(Self.FindComponent('StaticText_ReplyRead'+IntToStr(iItem+1))) do begin
                         Caption := ZQuery.FieldByName('posts').AsString +'/'+ZQuery.FieldByName('views').AsString;
                         Hint := '';
                    end;

                    //����
                    with TStaticText(Self.FindComponent('StaticText_LastPost'+IntToStr(iItem+1))) do begin
                         Caption   := (ZQuery.FieldByName('lastname').AsString);
                         Hint      := '{"href":"'+_WEBSITE+'dfw_user.dw?uid='+ZQuery.FieldByName('lastuid').AsString+'"}';
                    end;

                    //���ظ�ʱ��
                    with TStaticText(Self.FindComponent('StaticText_LastPostTime'+IntToStr(iItem+1))) do begin
                         Caption   := FormatDateTime('yyyy-mm-dd',dwPHPToDate(ZQuery.FieldByName('last_date').AsInteger));
                         Hint      := '';
                    end;

                    //
                    ZQuery.Next;
               end;
          end;

          //
          Edit_PageNo.Text    := IntToSTr(APageID+1);
     except
     end;
end;

procedure TForm1.Button_NextClick(Sender: TObject);
begin
     Inc(giPageNo);
     UpdateThreads(giPageNo,giForumNo,0,Trim(Edit_Search.Text));
end;

procedure TForm1.Button_FirstClick(Sender: TObject);
begin
     giPageNo  := 0;
     UpdateThreads(giPageNo,giForumNo,0,Trim(Edit_Search.Text));

end;

procedure TForm1.Button_PrevClick(Sender: TObject);
begin
     giPageNo  := Max(0,giPageNo-1);
     UpdateThreads(giPageNo,giForumNo,0,Trim(Edit_Search.Text));

end;

procedure TForm1.Edit_SearchChange(Sender: TObject);
begin
     giPageNo  := 0;
     UpdateThreads(giPageNo,giForumNo,0,Trim(Edit_Search.Text));

end;

procedure TForm1.Button_LoginClick(Sender: TObject);
begin
     //
     if Button_Login.Caption = '��¼'  then begin
          dwOpenUrl(self,'/dfw_login.dw','_self');
          //dwOpenUrl(self,'https://graph.qq.com/oauth2.0/authorize?response_type=code&client_id=101559562&redirect_uri=http://delphibbs.com/qq_login-return.htm&scope=scope&display=display','_self');
     end;
end;

procedure TForm1.Button_LastClick(Sender: TObject);
begin
     //
end;

procedure TForm1.Button_GotoClick(Sender: TObject);
begin
     giPageNo  := StrToIntDef(Edit_PageNo.Text,giPageNo+1);
     giPageNo  := giPageNo-1;
     UpdateThreads(giPageNo,giForumNo,0,Trim(Edit_Search.Text));
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;  Shift: TShiftState; X, Y: Integer);
var
     iComp     : Integer;
     oPanel    : TPanel;
     bLarge    : Boolean;
begin
     {
          X,Y�ֱ��ʾ��ǰ�豸��Width/Height��
          Button : mbLeft : ��Ļ����, mbRight:��Ļ����
          Shift��ssShift, ssAlt, ssCtrl,ssLeft, ssRight,
          �ֱ��Ӧ0:δ֪/1:PC/2:Android/3:iPhone/4:Tablet
          ���⣬��������
          screenWidth����ͨ��dwGetProp(Self,'screenwidth')�õ���
          screenHeight����ͨ��dwGetProp(Self,'screenheight')�õ���
          innerWidth����ͨ��dwGetProp(Self,'innerwidth')�õ���
          innerHeight����ͨ��dwGetProp(Self,'innerheight')�õ���
          clientWidth����ͨ��dwGetProp(Self,'clientwidth')�õ���
          clientHeight����ͨ��dwGetProp(Self,'clientheight')�õ���
     }

     //�Ƿ�Ϊ������ʾ
     bLarge    := (X>700)and(Y>600);

     //���Ǵ���
     if bLarge then begin
          Width     := X-30;
     end else begin
          Width     := X;
     end;

     Panel_09_Titles.Visible     := bLarge;

     //
     {
     for iComp := 0 to Self.ComponentCount-1 do begin
          if Components[iComp].ClassType = TPanel then begin
               oPanel    := TPanel(Components[iComp]);
               if not oPanel.ParentBiDiMode then begin
                    dwRealignPanel(oPanel,bLarge);
               end else if Copy(oPanel.Name,1,10)='Panel_Info' then begin
                    dwRealignPanel(oPanel,True);
               end;
          end;
     end;
     }
     //
     Panel_00.Height          := Panel_0_Thread.Height*20 + Panel_1_Pages.Height;
     Panel_10_Content.Height  := Panel_00.Height;

     //
     Panel_All.Height    := Panel_00_Logo.Height +  Panel_01_Menu.Height
               + Panel_10_Content.Height +  Panel_99_Foot.Height
               +2*Panel_All.BorderWidth+50;
     //
     dwSetHeight(Self,Panel_All.Height);
end;

procedure TForm1.FormShow(Sender: TObject);
var
     sParams   : String;
     sName     : string;
     sSubject  : string;

     //
     iUid      : Integer;
     iPos      : Integer;
     iItem     : Integer;

     //
     oPanel    : TPanel;
     
begin

     //uid=294&&name=������ѧdelphi��

     //�õ�URL����
     sParams   := dwUnescape(dwGetProp(self,'params'));

     //�쳣���
     if sParams = '' then begin
          Exit;
     end;

     //�õ���������
     //tid
     iPos      := Pos('&&',sParams);
     iUid     := StrToIntDef(Copy(sParams,5,iPos-5),-1);
     Delete(sParams,1,iPos+1);
     //
     Delete(sParams,1,5);
     sName     := sParams;


end;

procedure TForm1.Label11Click(Sender: TObject);
begin
     giPageNo  := 0;
     giForumNo := 0;
     UpdateThreads(giPageNo,giForumNo,0,Trim(Edit_Search.Text));

end;

procedure TForm1.Label12Click(Sender: TObject);
begin
     giPageNo  := 0;
     giForumNo := 5;
     UpdateThreads(giPageNo,giForumNo,0,Trim(Edit_Search.Text));

end;

procedure TForm1.Label13Click(Sender: TObject);
begin
     giPageNo  := 0;
     giForumNo := 6;
     UpdateThreads(giPageNo,giForumNo,0,Trim(Edit_Search.Text));

end;

procedure TForm1.Label16Click(Sender: TObject);
begin
     giPageNo  := 0;
     giForumNo := 3;
     UpdateThreads(giPageNo,giForumNo,0,Trim(Edit_Search.Text));

end;

procedure TForm1.Label17Click(Sender: TObject);
begin
     giPageNo  := 0;
     giForumNo := 7;
     UpdateThreads(giPageNo,giForumNo,0,Trim(Edit_Search.Text));

end;

procedure TForm1.Label18Click(Sender: TObject);
begin
     giPageNo  := 0;
     giForumNo := 2;
     UpdateThreads(giPageNo,giForumNo,0,Trim(Edit_Search.Text));

end;

procedure TForm1.Label1Click(Sender: TObject);
begin
     giPageNo  := 0;
     giForumNo := 1;
     UpdateThreads(giPageNo,giForumNo,0,Trim(Edit_Search.Text));

end;

procedure TForm1.Label2Click(Sender: TObject);
begin
     giPageNo  := 0;
     giForumNo := 4;
     UpdateThreads(giPageNo,giForumNo,0,Trim(Edit_Search.Text));

end;

procedure TForm1.Timer_GetCookieTimer(Sender: TObject);
var
     sUser     : String;
begin
     //
     if Timer_GetCookie.Tag=0 then begin
          //Ԥ��ȡ
          dwPreGetCookie(self,'dfw_user','');
     end else if Timer_GetCookie.Tag < 30 then begin
          sUser     := dwGetCookie(self,'dfw_user');
          //
          if sUser <>'' then begin
               //��ʾ�û���
               Button_UserName.Caption       := sUser;
               Button_UserName.Visible       := True;
               Label_UserNameLine.Visible    := True;
               Button_UserName.Left          := 0;
               //ֹͣTimer
               Timer_GetCookie.DesignInfo        := 0;
          end;
     end else begin
          //ֹͣTimer
          Timer_GetCookie.DesignInfo   := 0;
     end;

     //
     Timer_GetCookie.Tag := Timer_GetCookie.Tag +1;

end;

end.
