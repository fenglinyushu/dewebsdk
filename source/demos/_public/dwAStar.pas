unit dwAStar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TDWPoint = record
    X: Integer;
    Y: Integer;
  end;
  TDWArea = array[0..14] of array[0..16] of Word;

function AStar(AArea: TDWArea;  AStart, AEnd: TDWPoint): Boolean;

implementation

type
    TNode = class
    private
        Fx: Integer;
        Fy: Integer;
        Fg: Double;
        Fh: Double;
        Fparent: TNode;
    public
        constructor Create(x, y: Integer);
        property x: Integer read Fx write Fx;
        property y: Integer read Fy write Fy;
        property g: Double read Fg write Fg;
        property h: Double read Fh write Fh;
        property parent: TNode read Fparent write Fparent;
    end;

{ TNode }

constructor TNode.Create(x, y: Integer);
begin
  Fx := x;
  Fy := y;
  Fg := 0;
  Fh := 0;
  Fparent := nil;
end;

function Heuristic(node, goal: TNode): Double;
begin
    // 使用曼哈顿距离作为启发式函数
    Result := Abs(node.x - goal.x) + Abs(node.y - goal.y);
end;

function IsValid(AArea: TDWArea; x, y: Integer): Boolean;
begin
    // 判断坐标是否在区域范围内且对应位置可通行（这里假设非0值表示不可通行）
    Result := (x >= 0) and (x <= 14) and (y >= 0) and (y <= 16) and (AArea[x][y] = 0);
end;

function Cost(AArea: TDWArea; x, y: Integer): Double;
begin
    // 假设移动到相邻可通行格子的代价都是1，可根据实际情况修改
    if IsValid(AArea, x, y) then
        Result := 1
    else
        Result := 99999;
end;


function AStar(AArea: TDWArea;  AStart, AEnd: TDWPoint): Boolean;
var
    openList    : TList;
    closedList  : TList;
    currentNode : TNode;
    neighbor    : TNode;
    start, goal : TNode;
    tentative_g : Double;
    dx, dy      : Integer;
    i           : Integer;
begin
    openList    := TList.Create();
    closedList  := TList.Create();

    start       := TNode.Create(AStart.X, AStart.Y);
    goal        := TNode.Create(AEnd.X, AEnd.Y);

    start.g     := 0;
    start.h     := Heuristic(start, goal);
    openList.Add(start);

    while openList.Count > 0 do begin
        // 找到openList中f值最小的节点
        currentNode := TNode(openList[0]);
        for i := 1 to openList.Count - 1 do begin
            if TNode(openList[i]).g + TNode(openList[i]).h < currentNode.g + currentNode.h then begin
                currentNode := TNode(openList[i]);
            end;
        end;

        if (currentNode.x = goal.x) and (currentNode.y = goal.y) then begin
            // 到达目标，释放列表内存并返回True
            openList.Free();
            closedList.Free();
            Result := True;
            Exit;
        end;

        openList.Remove(currentNode);
        closedList.Add(currentNode);

        // 遍历当前节点的邻居
        for dx := -1 to 1 do begin
            for dy := -1 to 1 do begin
                if (dx <> 0) or (dy <> 0) then begin
                    if IsValid(AArea, currentNode.x + dx, currentNode.y + dy) then begin
                        neighbor := TNode.Create(currentNode.x + dx, currentNode.y + dy);
                        tentative_g := currentNode.g + Cost(AArea, currentNode.x + dx, currentNode.y + dy);

                        if openList.IndexOf(neighbor) < 0 then begin
                            neighbor.g := tentative_g;
                            neighbor.h := Heuristic(neighbor, goal);
                            neighbor.parent := currentNode;
                            openList.Add(neighbor);
                        end else if tentative_g < neighbor.g then begin
                            neighbor.g := tentative_g;
                            neighbor.parent := currentNode;
                        end
                    end;
                end;
            end;
        end;
    end;

    // 如果没有找到路径，释放列表内存并返回False
    openList.Free();
    closedList.Free();
    Result := False;
end;


end.
