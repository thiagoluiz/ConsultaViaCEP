unit uConverteObjeto;

interface

uses
  System.JSON, Xml.XMLIntf, System.Rtti,
  uEndereco, uEnderecoMapperFactory, uIEnderecoMapper, uFormatoRetornoArquivoEnum;

  function ConverterParaEndereco(const Valor: TValue; Formato: TFormatoRetornoArquivoEnum): TEndereco;

implementation

uses
  System.SysUtils;

function ConverterParaEndereco(const Valor: TValue; Formato: TFormatoRetornoArquivoEnum): TEndereco;
var
  MapperJson: IEnderecoMapper<TJSONArray>;
  MapperXml: IEnderecoMapper<IXMLDocument>;
begin
  Result := nil;

  case Formato of
    fraJSON:
      begin
        if not Valor.IsType<TJSONArray> then
          raise Exception.Create('Valor não é um TJSONObject');

        MapperJson := TEnderecoMapperFactory.CreateJsonMapper;
        Result := MapperJson.MapToEndereco(Valor.AsType<TJSONArray>);
      end;

    fraXML:
      begin
        if not Valor.IsType<IXMLDocument> then
          raise Exception.Create('Valor não é um IXMLDocument');

        MapperXml := TEnderecoMapperFactory.CreateXmlMapper;
        Result := MapperXml.MapToEndereco(Valor.AsType<IXMLDocument>);
      end;

  else
    raise Exception.Create('Formato não suportado');
  end;
end;


end.
