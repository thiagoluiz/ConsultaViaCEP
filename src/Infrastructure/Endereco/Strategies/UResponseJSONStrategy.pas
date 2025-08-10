unit UResponseJSONStrategy;

interface

uses
  System.Rtti, System.JSON, System.SysUtils, uIFormatoStrategy,
  UIResponseStrategy;

type
  TJSONResponseStrategy = class(TInterfacedObject, IResponseStrategy<TJSONArray>)
  public
    function Parse(const AValue: TValue): TJSONArray;
  end;

implementation

{ TRespostaStrategy }

function TJSONResponseStrategy.Parse(const AValue: TValue): TJSONArray;
begin
  result := AValue.AsType<TJSONArray>;
end;

end.
