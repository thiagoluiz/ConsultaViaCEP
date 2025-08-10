unit uRequestStrategyPorEndereco;

interface

uses
 SysUtils, uEnderecoRequest, uIRequestStrategy;

type
  TRequestStrategyPorEndereco = class(TInterfacedObject, IRequestStrategy)
  public
    function BuildUrl(ARequest: TEnderecoRequest): string;
  end;

implementation

{ TRequestStrategyByAddress }

function TRequestStrategyPorEndereco.BuildUrl(ARequest: TEnderecoRequest): string;
begin
//  Result := Format('https://viacep.com.br/ws/%s/%s/%s/%s',
//    [ARequest.psEndereco, ARequest. peFormato]);
end;

end.
