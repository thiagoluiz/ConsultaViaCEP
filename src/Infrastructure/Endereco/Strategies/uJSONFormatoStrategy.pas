unit uJSONFormatoStrategy;

interface

uses
  System.JSON, SysUtils, uIFormatoStrategy;

type
  TJsonFormatoStrategy = class(TInterfacedObject, IFormatoStrategy<TJSONArray>)
  public
    function Parse(const AContent: string): TJSONArray;
  end;

implementation

function TJsonFormatoStrategy.Parse(const AContent: string): TJSONArray;
var
  JsonValue: TJSONValue;
  JsonObject: TJSONObject;
begin
  Result := nil;
  JsonValue := TJSONObject.ParseJSONValue(AContent);

  if JsonValue = nil then
    raise Exception.Create('Erro ao fazer parse do JSON.');

  if JsonValue is TJSONArray then
  begin
    // Já é um array, retornamos diretamente
    Result := TJSONArray(JsonValue);
  end
  else if JsonValue is TJSONObject then
  begin
    // É um objeto único — vamos criar um array com esse objeto
    JsonObject := TJSONObject(JsonValue);
    Result := TJSONArray.Create;
    Result.AddElement(JsonObject);
  end
  else
  begin
    JsonValue.Free;
  end;

end;

end.

