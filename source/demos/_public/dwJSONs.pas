unit dwJSONs;

interface

uses
  System.JSON, System.SysUtils, System.StrUtils;

function dwJSONToJSObject(const JSONStr: string): string;
function _ProcessJSONObject(JSONObject: TJSONObject): string;
function _ProcessJSONArray(JSONArray: TJSONArray): string;


implementation


  // 递归函数处理嵌套的 JSON 对象
  function _ProcessJSONObject(JSONObject: TJSONObject): string;
  var
    Pair: TJSONPair;
    i: Integer;
    Key: string;
  begin
    Result := '{';

    for i := 0 to JSONObject.Count - 1 do
    begin
      Pair := JSONObject.Pairs[i];
      Key := Pair.JsonString.Value;

      // 处理键名，使用单引号替换双引号
      if (not ContainsText(Key, ' ')) and (Key[1] in ['a'..'z', 'A'..'Z', '_']) then
        Result := Result + '''' + Key + ''': '
      else
        Result := Result + '''' + Key + ''': ';

      // 判断值的类型，若为对象，则递归处理
      if Pair.JsonValue is TJSONObject then begin
        Result := Result + _ProcessJSONObject(Pair.JsonValue as TJSONObject)
      end else if Pair.JsonValue is TJSONArray then begin
        Result := Result + _ProcessJSONArray(Pair.JsonValue as TJSONArray)
      end else if Pair.JsonValue is TJSONArray then begin
        Result := Result + _ProcessJSONArray(Pair.JsonValue as TJSONArray)
      end else if Pair.JsonValue is TJSONNumber then begin
        Result := Result + Pair.JsonValue.Value
      end else if Pair.JsonValue is TJSONBool then begin
        Result := Result + Pair.JsonValue.Value
      end else begin
        Result := Result + '''' + Pair.JsonValue.Value + ''''; // 使用单引号包围字符串值
      end;
      // 处理逗号分隔
      if i < JSONObject.Count - 1 then
        Result := Result + ', ';
    end;

    Result := Result + '}';
  end;

  // 处理 JSON 数组
  function _ProcessJSONArray(JSONArray: TJSONArray): string;
  var
    i: Integer;
    Value: string;
  begin
    Result := '[';

    for i := 0 to JSONArray.Count - 1 do
    begin
      // 判断数组元素类型，若为对象，则递归处理
      if JSONArray.Items[i] is TJSONObject then begin
        Value := _ProcessJSONObject(JSONArray.Items[i] as TJSONObject)
      end else if JSONArray.Items[i] is TJSONArray then begin
        Value := _ProcessJSONArray(JSONArray.Items[i] as TJSONArray)
      end else if JSONArray.Items[i] is TJSONNumber then begin
        Result := Result + JSONArray.Items[i].Value;
      end else if JSONArray.Items[i] is TJSONBool then begin
        Result := Result + JSONArray.Items[i].Value;
      end else begin
        Value := '''' + JSONArray.Items[i].Value + ''''; // 使用单引号包围值
      end;

      Result := Result + Value;

      // 处理逗号分隔
      if i < JSONArray.Count - 1 then
        Result := Result + ', ';
    end;

    Result := Result + ']';
  end;

function dwJSONToJSObject(const JSONStr: string): string;

var
  JSONValue: TJSONValue;
begin
  JSONValue := TJSONObject.ParseJSONValue(JSONStr);
  try
    if JSONValue is TJSONObject then
    begin
      // 调用递归处理函数
      Result := _ProcessJSONObject(JSONValue as TJSONObject);
    end
    else
      Result := '{}'; // 如果不是有效的 JSON 对象，返回空对象
  finally
    JSONValue.Free;
  end;
end;

//var
//  JSONStr: string;
//begin
//  JSONStr := '{"name": "John", "age": 30, "address": {"street": "123 Main St", "city": "New York"}, "phones": ["123-456-7890", "987-654-3210"]}';
//  Writeln(JSONToJavaScriptObject(JSONStr));
//end.


end.
