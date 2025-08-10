unit uspConsultaViaCEP;

interface

uses
  System.Classes, System.SysUtils,
  uEndereco, uEnderecoResponse, uIServiceViaCEP, uFormatoRetornoArquivoEnum,
  System.JSON, Xml.XMLIntf, System.Rtti, uEnderecoMapperFactory, uIEnderecoMapper,
  uTipoConsultaEnum;

type
  TspViaCepComponent = class(TComponent)
  private
    FService: IServiceViaCep;
    FConsultarPorEnderecoCompleto: Boolean;
    FCEP: string;
    FFormatoRetorno: TFormatoRetornoArquivoEnum;
    FLogradouro: string;
    FCidade: string;
    FEstado: string;

    procedure SetConsultarPorEnderecoCompleto(const Value: Boolean);
    procedure SetCEP(const Value: string);
    procedure SetFormatoRetorno(const Value: TFormatoRetornoArquivoEnum);
    procedure SetCidade(const Value: string);
    procedure SetEstado(const Value: string);
    procedure SetLogradouro(const Value: string);
  public
    procedure InjectService(AService: IServiceViaCep);
    constructor Create(AOwner: TComponent; AService: IServiceViaCep); reintroduce;
    destructor Destroy; override;
    function Buscar : TValue;

  published
    property CEP: string read FCEP write SeTCEP;
    property Estado : string read FEstado write SetEstado;
    property Cidade : string read FCidade write SetCidade;
    property Logradouro : string read FLogradouro write SetLogradouro;

    property FormatoRetorno : TFormatoRetornoArquivoEnum read FFormatoRetorno write SetFormatoRetorno;
    property ConsultarPorEnderecoCompleto: Boolean read FConsultarPorEnderecoCompleto write SetConsultarPorEnderecoCompleto;
  end;

procedure Register;

implementation

uses
  uEnderecoRequest;

procedure Register;
begin
  RegisterComponents('ConsultasWEB', [TspViaCepComponent]);
end;

constructor TspViaCepComponent.Create(AOwner: TComponent; AService: IServiceViaCep);
begin
  inherited Create(AOwner);
  FService := AService;
end;

destructor TspViaCepComponent.Destroy;
begin
  inherited;
end;

procedure TspViaCepComponent.InjectService(AService: IServiceViaCep);
begin
  FService := AService;
end;

function TspViaCepComponent.Buscar : TValue;
var
  Request: TEnderecoRequest;
begin
  if not Assigned(FService) then
    raise Exception.Create('Serviço de consulta ViaCEP não foi injetado.');

  Request := TEnderecoRequest.Create;
  try
    if FConsultarPorEnderecoCompleto then
    begin
      Request.psEstado := FEstado;
      Request.psCidade := FCidade;
      Request.psLogradouro := FLogradouro;
      Request.peTipoConsulta := tcPorEnderecoCompleto;
    end
    else
    begin
      Request.psCEP := FCEP;
      Request.peTipoConsulta := tcPorCEP;
    end;

    Request.peFormato := FFormatoRetorno;
    Result := FService.Consultar(Request);

  finally
    Request.Free;
  end;
end;

procedure TspViaCepComponent.SetConsultarPorEnderecoCompleto(const Value: Boolean);
begin
  FConsultarPorEnderecoCompleto := Value;
end;

procedure TspViaCepComponent.SetEstado(const Value: string);
begin
  FEstado := Value;
end;

procedure TspViaCepComponent.SetCEP(const Value: string);
begin
  FCEP := Value;
end;

procedure TspViaCepComponent.SetCidade(const Value: string);
begin
  FCidade := Value;
end;

procedure TspViaCepComponent.SetFormatoRetorno(const Value: TFormatoRetornoArquivoEnum);
begin
  FFormatoRetorno := Value;
end;

procedure TspViaCepComponent.SetLogradouro(const Value: string);
begin
  FLogradouro := Value;
end;

end.

