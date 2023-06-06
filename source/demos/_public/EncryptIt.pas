unit EncryptIt;

interface
USES
    Classes,SysUtils;
const
     C1 = 52845;
     C2 = 22719;

function  EncryptStr(const S: String; Key: Word): String;
function  DecryptStr(const S: String; Key: Word): String;
Function  EncryptKey (Src:String; Key:String):string;
Function  DecryptKey (Src:String; Key:String):string;
procedure EncryptFile(INFName, OutFName : String; Key : Word);
procedure DecryptFile(INFName, OutFName : String; Key : Word);

implementation

function EncryptStr(const S: String; Key: Word): String;
var
   I: Integer;
begin
  Result := S;
  for I := 1 to Length(S) do
      begin
           Result[I] := char(byte(S[I]) xor (Key shr 8));
           Key := (byte(Result[I]) + Key) * C1 + C2;
      end;
  end;

function DecryptStr(const S: String; Key: Word): String;
var
   I: Integer;
begin
  Result := S;
  for I := 1 to Length(S) do
      begin
           Result[I] := char(byte(S[I]) xor (Key shr 8));
           Key := (byte(S[I]) + Key) * C1 + C2;
      end;
  end;


procedure EncryptFile(INFName, OutFName : String; Key : Word);
VAR
   MS, SS : TMemoryStream;
   X : Integer;
   C : Byte;
begin
MS := TMemoryStream.Create;
SS := TMemoryStream.Create;
    TRY
       MS.LoadFromFile(INFName);
       MS.Position := 0;
       FOR X := 0 TO MS.Size - 1 DO
             begin
                  MS.Read(C, 1);
                  C := (C xor (Key shr 8));
                  Key := (C + Key) * C1 + C2;
                  SS.Write(C,1);
             end;
       SS.SaveToFile(OutFName);
    FINALLY
           SS.Free;
           MS.Free;
    end;
end;

procedure DecryptFile(INFName, OutFName : String; Key : Word);
VAR
   MS, SS : TMemoryStream;
   X : Integer;
   C, O : Byte;
begin
MS := TMemoryStream.Create;
SS := TMemoryStream.Create;
    TRY
       MS.LoadFromFile(INFName);
       MS.Position := 0;
       FOR X := 0 TO MS.Size - 1 DO
             begin
                  MS.Read(C, 1);
                  O := C;
                  C := (C xor (Key shr 8));
                  Key := (O + Key) * C1 + C2;
                  SS.Write(C,1);
             end;
       SS.SaveToFile(OutFName);
    FINALLY
           SS.Free;
           MS.Free;
    end;
end;
Function EncryptKey (Src:String; Key:String):string;
var
     KeyLen :Integer;
     KeyPos :Integer;
     offset :Integer;
     dest :string;
     SrcPos :Integer;
     SrcAsc :Integer;
     Range :Integer;

begin
     KeyLen:=Length(Key);
     if KeyLen = 0 then key:='Think Space';
     KeyPos:=0;
     Range:=256;

     Randomize;
     offset:=Random(Range);
     dest:=format('%1.2x',[offset]);
     for SrcPos := 1 to Length(Src) do begin
          SrcAsc:=(Ord(Src[SrcPos]) + offset) MOD 255;
          if KeyPos < KeyLen then KeyPos:= KeyPos + 1 else KeyPos:=1;
          SrcAsc:= SrcAsc xor Ord(Key[KeyPos]);
          dest:=dest + format('%1.2x',[SrcAsc]);
          offset:=SrcAsc;
     end;
     Result:=Dest;
end;

//解密函数
function DecryptKey (Src:String; Key:String):string;
var
     KeyLen :Integer;
     KeyPos :Integer;
     offset :Integer;
     dest :string;
     SrcPos :Integer;
     SrcAsc :Integer;
     TmpSrcAsc :Integer;
begin
     try
          KeyLen:=Length(Key);
          if KeyLen = 0 then key:='Think Space';
          KeyPos:=0;
          offset:=StrToInt('$'+ copy(src,1,2));
          SrcPos:=3;
          repeat
               SrcAsc:=StrToInt('$'+ copy(src,SrcPos,2));
               if KeyPos < KeyLen Then KeyPos := KeyPos + 1 else KeyPos := 1;
               TmpSrcAsc := SrcAsc xor Ord(Key[KeyPos]);
               if TmpSrcAsc <= offset then
                    TmpSrcAsc := 255 + TmpSrcAsc - offset
               else
                    TmpSrcAsc := TmpSrcAsc - offset;
               dest := dest + chr(TmpSrcAsc);
               offset:=srcAsc;
               SrcPos:=SrcPos + 2;
          until SrcPos >= Length(Src);
               Result:=Dest;
     except
          Result    := 'ias@njw#oriu$we_em1!83~4r`mskjhr?';
     end;
end;


end.
