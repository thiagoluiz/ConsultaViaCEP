unit uEnderecoWebViacepRepository;

interface

uses
  System.Net.HttpClient, System.SysUtils, System.Net.HttpClientComponent,
  uIEnderecoWebViacepRepository, uEnderecoRequest, uFormatoRetornoArquivoEnum,
  uFormatStrategyFactory, uIFormatoStrategy,
  System.JSON, Xml.XMLIntf;

type
  TEnderecoWebViacepRepository = class(TInterfacedObject, IEnderecoWebViacepRepository)
    function BuscaJsonPorCEP(const psCEP: string): TJSONArray;
    function BuscaXmlPorCEP(const psCEP: string): IXMLDocument;

    function BuscaJsonPorEnderecoCompleto(const pRequest: TEnderecoRequest): TJSONArray;
    function BuscaXmlPorEnderecoCompleto(const pRequest: TEnderecoRequest): IXMLDocument;
  end;

implementation

const
  URL_VIACEP = 'https://viacep.com.br';

{ TEnderecoRepository }

function TEnderecoWebViacepRepository.BuscaJsonPorCEP(const psCEP: string): TJSONArray;
var
  HttpClient: TNetHTTPClient;
  ResponseStr: string;
  Url: string;
  FormatStrategy: IFormatoStrategy<TJSONArray>;
begin
  Url := Format(URL_VIACEP + '/ws/%s/json', [psCEP]);

  HttpClient := TNetHTTPClient.Create(nil);
  try
    ResponseStr := HttpClient.Get(Url).ContentAsString;
    FormatStrategy := TFormatStrategyFactory.CreateJsonStrategy(fraJSON);
    Result := FormatStrategy.Parse(ResponseStr);
  finally
    HttpClient.Free;
  end;
end;

function TEnderecoWebViacepRepository.BuscaXmlPorCEP(const psCEP: string): IXMLDocument;
var
  HttpClient: TNetHTTPClient;
  ResponseStr: string;
  Url: string;
  FormatStrategy: IFormatoStrategy<IXMLDocument>;
begin
  Url := Format(URL_VIACEP + '/ws/%s/xml', [psCEP]);

  HttpClient := TNetHTTPClient.Create(nil);
  try
    ResponseStr := HttpClient.Get(Url).ContentAsString;
    FormatStrategy := TFormatStrategyFactory.CreateXmlStrategy(fraXML);
    Result := FormatStrategy.Parse(ResponseStr);
  finally
    HttpClient.Free;
  end;
end;

function TEnderecoWebViacepRepository.BuscaJsonPorEnderecoCompleto(const pRequest: TEnderecoRequest): TJSONArray;
var
  HttpClient: TNetHTTPClient;
  ResponseStr: string;
  Url: string;
  FormatStrategy: IFormatoStrategy<TJSONArray>;
begin
  Url := Format(URL_VIACEP + '/ws/%s/%s/%s/json',
    [pRequest.psEstado, pRequest.psCidade, pRequest.psLogradouro]);

  HttpClient := TNetHTTPClient.Create(nil);
  try
    ResponseStr := HttpClient.Get(Url).ContentAsString(TEncoding.UTF8);
    FormatStrategy := TFormatStrategyFactory.CreateJsonStrategy(fraJSON);
    Result := FormatStrategy.Parse(ResponseStr);
  finally
    HttpClient.Free;
  end;
end;

function TEnderecoWebViacepRepository.BuscaXmlPorEnderecoCompleto(const pRequest: TEnderecoRequest): IXMLDocument;
var
  HttpClient: TNetHTTPClient;
  ResponseStr: string;
  Url: string;
  FormatStrategy: IFormatoStrategy<IXMLDocument>;
begin
  Url := Format(URL_VIACEP + '/ws/%s/%s/%s/xml',
    [pRequest.psEstado, pRequest.psCidade, pRequest.psLogradouro]);

  HttpClient := TNetHTTPClient.Create(nil);
  try
    try
      ResponseStr := HttpClient.Get(Url).ContentAsString;
    except
      on E: ENetHTTPClientException do
        raise Exception.CreateFmt('Erro ao conectar ao ViaCEP: %s', [E.Message]);
      on E: Exception do
        raise Exception.CreateFmt('Erro inesperado ao acessar o ViaCEP: %s', [E.Message]);
      on E : Exception do
        raise Exception.CreateFmt('Erro inesperado ao acessar o ViaCEP: %s', [E.Message]);
    end;

    FormatStrategy := TFormatStrategyFactory.CreateXmlStrategy(fraXML);
    Result := FormatStrategy.Parse(ResponseStr);
  finally
    HttpClient.Free;
  end;
end;

end.

