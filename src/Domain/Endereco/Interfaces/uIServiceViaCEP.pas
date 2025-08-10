unit uIServiceViaCEP;

interface

uses
  uEndereco, uEnderecoRequest, System.JSON, Xml.XMLIntf, System.Rtti;
type

  IServiceViaCEP = Interface
    function Consultar(const ARequest: TEnderecoRequest): TValue;
    function ConsultarJson(const ARequest: TEnderecoRequest): TJSONArray;
    function ConsultarXml(const ARequest: TEnderecoRequest): IXMLDocument;
  End;

implementation

end.
