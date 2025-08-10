unit uEnderecoMapperFactory;

interface

uses
  uFormatoRetornoArquivoEnum, uIEnderecoMapper, uJsonEnderecoMapper,
  uXmlEnderecoMapper, System.JSON, Xml.XMLIntf, System.SysUtils;

type
  TEnderecoMapperFactory = class
  public
    class function CreateJsonMapper: IEnderecoMapper<TJSONArray>;
    class function CreateXmlMapper: IEnderecoMapper<IXMLDocument>;
  end;

implementation

uses
  System.Rtti, System.TypInfo;

class function TEnderecoMapperFactory.CreateJsonMapper: IEnderecoMapper<TJSONArray>;
begin
  Result := TJsonEnderecoMapper.Create;
end;

class function TEnderecoMapperFactory.CreateXmlMapper: IEnderecoMapper<IXMLDocument>;
begin
  Result := TXmlEnderecoMapper.Create;
end;

end.
