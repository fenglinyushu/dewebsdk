unit CloneComponents;

interface
uses
  Classes;

function CloneComponent(aSource: TComponent): TComponent;

implementation
uses
  SysUtils, Controls;
  
type
  TComponentReader = class(TReader)
  public
    Component: TComponent;
    procedure Read(aComponent: TComponent);
    procedure GetName(Reader: TReader; Component: TComponent; var Name: String);
  end;

procedure TComponentReader.Read(aComponent: TComponent);
begin
  Component := aComponent;
end;

procedure TComponentReader.GetName(Reader: TReader; Component: TComponent; var Name: String);
var
  I       : Integer;
  Tempname: String;
begin
  I := 0;
  Tempname := Name;
  //确保控件Name属性唯一
  while Component.Owner.FindComponent(Name) <> nil do
    begin
    Inc(I);
    Name := Format('%s%d', [Tempname, I]);
    end;
end;

function CloneComponent(aSource: TComponent): TComponent;
  procedure RegisterComponentClasses(aComponent: TComponent);
  var
    I : Integer;
  begin
  RegisterClass(TPersistentClass(aComponent.ClassType));
  if aComponent is TWinControl then
    begin
    for I := 0 to (TWinControl(aComponent).ControlCount-1) do
      begin
      RegisterComponentClasses(TWinControl(aComponent).Controls[I]);
      end;
    end;
  end;

var
  Stream  : TMemoryStream;
  Reader  : TComponentReader;
  Writer  : TWriter;
begin
  Stream := TMemoryStream.Create;
  try
    RegisterComponentClasses(aSource);

    Writer := TWriter.Create(Stream, 4096);
    try
      Writer.Root := aSource.Owner;
      Writer.WriteSignature;
      Writer.WriteComponent(aSource);
      Writer.WriteListEnd;
    finally
      Writer.Free;
    end;

    Stream.Position := 0;
    Reader := TComponentReader.Create(Stream, 4096);
    try
      with Reader do
        begin
        OnSetName := getName;     //生成唯一名称
        Component := nil;

        if aSource is TWinControl then
          begin
          ReadComponents(TWinControl(aSource).Owner, TWinControl(aSource).Parent, Read);
          end
        else
          begin
          ReadComponents(aSource.Owner, nil, Read);
          end;
        Result := Component;
        end;
    finally
      Reader.Free;
    end;
  finally
    Stream.Free;
  end;
end;

end.