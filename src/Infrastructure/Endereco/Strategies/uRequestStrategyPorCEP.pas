unit uRequestStrategyPorCEP;

interface

uses  SysUtils ,uEnderecoRequest, UIRequestStrategy;

type
  TRequestStrategyPorCep = class(TInterfacedObject, IRequestStrategy)
  public
    function BuildUrl(ARequest: TEnderecoRequest): string;
  end;

implementation

{ TRequestStrategyByCep }

function TRequestStrategyPorCep.BuildUrl(ARequest: TEnderecoRequest): string;
begin
//  Result := Format('https://viacep.com.br/ws/%s/%s', [ARequest.psCEP, ARequest.peFormato]);
end;

end.
