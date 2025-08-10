unit uServiceViaCEP;

interface

uses
  uIServiceViaCEP, uIEnderecoWebViacepRepository, uEnderecoRequest,
  uTipoConsultaEnum, System.JSON, Xml.XMLIntf, uFormatoRetornoArquivoEnum,
  System.Rtti;

type
  TServiceViaCep = class(TInterfacedObject, IServiceViaCep)
  private
    FRepository: IEnderecoWebViacepRepository;
  public
    constructor Create(const ARepository: IEnderecoWebViacepRepository);

    function Consultar(const ARequest: TEnderecoRequest): TValue;
    function ConsultarJson(const ARequest: TEnderecoRequest): TJSONArray;
    function ConsultarXml(const ARequest: TEnderecoRequest): IXMLDocument;
  end;

implementation

uses
  System.SysUtils;

{ TServiceViaCep }

constructor TServiceViaCep.Create(const ARepository: IEnderecoWebViacepRepository);
begin
  if not Assigned(ARepository) then
    raise Exception.Create('Parâmetro ARepository não pode ser nil.');

  FRepository := ARepository;
end;

function TServiceViaCep.Consultar(const ARequest: TEnderecoRequest): TValue;
begin
  case ARequest.peFormato of
    fraJSON:
      Result := TValue.From<TJSONArray>(ConsultarJson(ARequest));
    fraXML:
      Result := TValue.From<IXMLDocument>(ConsultarXml(ARequest));
  else
    raise Exception.Create('Formato de retorno não suportado.');
  end;
end;


function TServiceViaCep.ConsultarJson(const ARequest: TEnderecoRequest): TJSONArray;
begin
  if ARequest.peTipoConsulta = tcPorCep then
    Result := FRepository.BuscaJsonPorCEP(ARequest.psCEP)
  else
    Result := FRepository.BuscaJsonPorEnderecoCompleto(ARequest);
end;

function TServiceViaCep.ConsultarXml(const ARequest: TEnderecoRequest): IXMLDocument;
begin
  if ARequest.peTipoConsulta = tcPorCep then
    Result := FRepository.BuscaXmlPorCEP(ARequest.psCEP)
  else
    Result := FRepository.BuscaXmlPorEnderecoCompleto(ARequest);
end;

end.

