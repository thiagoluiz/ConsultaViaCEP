unit uJsonEnderecoMapper;

interface

uses
  System.JSON, uEndereco, uIEnderecoMapper;

type
  TJsonEnderecoMapper = class(TInterfacedObject, IEnderecoMapper<TJSONArray>)
  public
    function MapToEndereco(AContent: TJSONArray): TEndereco;
  end;

implementation

function TJsonEnderecoMapper.MapToEndereco(AContent: TJSONArray): TEndereco;
begin
  Result := TEndereco.Create;
  Result.Cep         := AContent.GetValue<string>('cep');
  Result.Logradouro  := AContent.GetValue<string>('logradouro');
  Result.Complemento := AContent.GetValue<string>('complemento');
  Result.Bairro      := AContent.GetValue<string>('bairro');
  Result.Localidade  := AContent.GetValue<string>('localidade');
  Result.UF          := AContent.GetValue<string>('uf');
end;

end.

