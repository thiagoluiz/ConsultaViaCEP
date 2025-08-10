unit uRequestStrategyFactory;

interface

uses
  uEnderecoRequest, uIRequestStrategy, uRequestStrategyPorCep,
  uRequestStrategyPorEndereco, uTipoConsultaEnum;

type
  TRequestStrategyFactory = class
  public
    class function CreateStrategy(ARequest: TTipoConsultaEnum): IRequestStrategy;
  end;

implementation

{ TRequestStrategyFactory }

class function TRequestStrategyFactory.CreateStrategy(
  ARequest: TTipoConsultaEnum): IRequestStrategy;
begin
  if ARequest = tcPorCep then
    Result := TRequestStrategyPorCEP.Create
  else
    Result := TRequestStrategyPorEndereco.Create;
end;

end.
