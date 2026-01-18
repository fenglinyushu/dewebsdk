unit unit1;

interface

uses
  dwBase,
  System.Rtti,
  CloneComponents,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Grids, Vcl.ComCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  Vcl.WinXPanels, Vcl.Menus;
type
    TForm1 = class(TForm)
    Panel1: TPanel;
    PDemo: TPanel;
    LDemo: TLabel;
    PMTitle: TPanel;
    LTitle: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Panel1EndDock(Sender, Target: TObject; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
  public
    giMax   : Integer;  //底部显示的最大序号，1开始
  end;

var
    Form1: TForm1;
implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
    iItem       : Integer;
begin
    for iItem := 1 to 30 do begin
        with TPanel(CloneComponent(PDemo)) do begin
            Top := (iItem-1)*100 + 10;
        end;
        TLabel(FindComponent('LDemo'+IntToStr(iItem))).Caption  := IntToStr(iItem);
    end;
    PDemo.Destroy;
    //
    giMax   := 30;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    dwSetMobileMode(Self,400,900);
end;

procedure TForm1.Panel1EndDock(Sender, Target: TObject; X, Y: Integer);
var
    iItem       : Integer;
    iTop        : Integer;
    oPanels     : array[0..29] of TPanel;
    oLabel      : TLabel;
    sFull       : String;
begin
    //
    //dwRunJS('console.log("---------------'+InttoStr(X)+'---------------");',self);
    LTitle.Caption  := Format('X=%d,Y=%d',[X,Y]);

    //
    sFull   := dwFullName(Panel1);

    //
    //if X > (30 * 100 - Panel1.Height)  - 150 then begin
    if (Y=9) then begin
        //----------
        //如果向下滚动时接近底部，则挪动上面的不可见panel到当前底部的下面
        // (giMax * 100 - Height) 应该是底部， giMax * 100 = 20个 * 每个高度 100
        // 再-100 用于上面的“接近”， 而不是到达底部时才挪动
        //处理办法：
        // 1 先从上至下依次找到30个panel
        // 2 将前10个下移20个单元，并更新其中显示
        // 3 将21-30个上移10个单元
        // 4 更新scroll位置（减去10个单元高），以显示当前
        //----------

        // 1 先从上至下依次找到30个panel
        for iItem := 0 to 29 do begin
            oPanels[iItem]  := TPanel(Panel1.ControlAtPos(Point(100,iItem*100 + 50),True,True));
        end;

        // 2 将前10个下移20个单元，并更新其中显示
        for iItem := 0 to 9 do begin
            oPanels[iItem].Top  := oPanels[iItem].Top + 20*100;
            oLabel          := TLabel(oPanels[iItem].Controls[0]);
            oLabel.Caption  := IntToStr(StrToInt(oLabel.Caption)+30);
        end;

        // 3 将21-30个上移10个单元
        for iItem := 10 to 29 do begin
            oPanels[iItem].Top  := oPanels[iItem].Top - 10*100;
        end;

        // 4 更新scroll位置（减去10个单元高），以显示当前
        dwRunJS('let e = document.getElementById("'+sFull+'");'
                //+'console.log(e.scrollTop);'
                +'e.scrollTop -= 1000;'
                //+'console.log(e.scrollTop);'
                //+'console.log("Inc : '+InttoStr(giMax)+'");'
                ,self);
    //end else if X < 100  then begin
    end else if Y=0  then begin
        //----------
        //如果向上滚动时接近顶部，则挪动上面的不可见panel到当前底部的下面
        //处理办法：
        // 1 先从上至下依次找到30个panel
        // 2 将最下面10个上移20个单元，并更新其中显示
        // 3 将0-19个下移10个单元
        // 4 更新scroll位置（加上10个单元高），以显示当前
        //----------

        // 1 先从上至下依次找到30个panel
        for iItem := 0 to 29 do begin
            oPanels[iItem]  := TPanel(Panel1.ControlAtPos(Point(100,iItem*100 + 50),True,True));
        end;

        // 2 将最下面10个（20-29）上移20个单元，并更新其中显示
        for iItem := 20 to 29 do begin
            oPanels[iItem].Top  := oPanels[iItem].Top - 20*100;
            oLabel          := TLabel(oPanels[iItem].Controls[0]);
            oLabel.Caption  := IntToStr(StrToInt(oLabel.Caption)-30);
        end;

        // 3 将0-19个下移10个单元
        for iItem := 0 to 19 do begin
            oPanels[iItem].Top  := oPanels[iItem].Top + 10*100;
        end;

        // 4 更新scroll位置（加上10个单元高），以显示当前
        dwRunJS('let e = document.getElementById("'+sFull+'");'
                //+'console.log(e.scrollTop);'
                +'e.scrollTop += 1000;'
                //+'console.log(e.scrollTop);'
                //+'console.log("Dec : '+InttoStr(giMax)+'");'
                ,self);
    end;
end;

end.
