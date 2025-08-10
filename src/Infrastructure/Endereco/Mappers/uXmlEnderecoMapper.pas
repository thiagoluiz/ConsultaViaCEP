unit uXmlEnderecoMapper;

interface

uses
  Xml.XMLIntf, uEndereco, uIEnderecoMapper;

type
  TXmlEnderecoMapper = class(TInterfacedObject, IEnderecoMapper<IXMLDocument>)
  public
    function MapToEndereco(AContent: IXMLDocument): TEndereco;
  end;

implementation

function TXmlEnderecoMapper.MapToEndereco(AContent: IXMLDocument): TEndereco;
begin
  Result := TEndereco.Create;
  Result.Cep         := AContent.DocumentElement.ChildNodes['cep'].Text;
  Result.Logradouro  := AContent.DocumentElement.ChildNodes['logradouro'].Text;
  Result.Complemento := AContent.DocumentElement.ChildNodes['complemento'].Text;
  Result.Bairro      := AContent.DocumentElement.ChildNodes['bairro'].Text;
  Result.Localidade  := AContent.DocumentElement.ChildNodes['localidade'].Text;
  Result.UF          := AContent.DocumentElement.ChildNodes['uf'].Text;
end;

end.


end.
