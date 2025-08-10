unit uIEnderecoWebViacepRepository;

interface

uses
  uEndereco, uEnderecoRequest, uFormatoRetornoArquivoEnum, System.JSON,
  Xml.XMLIntf;

Type
  IEnderecoWebViacepRepository = interface
    function BuscaJsonPorCEP(const psCEP: string): TJSONArray;
    function BuscaXmlPorCEP(const psCEP: string): IXMLDocument;

    function BuscaJsonPorEnderecoCompleto(const pRequest: TEnderecoRequest): TJSONArray;
    function BuscaXmlPorEnderecoCompleto(const pRequest: TEnderecoRequest): IXMLDocument;
  end;

implementation

end.
