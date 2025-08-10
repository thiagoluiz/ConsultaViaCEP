unit uConsultaViaCepHandler;

interface

uses
  uEnderecoRequest, uIServiceViaCEP, System.Rtti;

type
  TConsultaViaCepHandler = class
  private
    FService: IServiceViaCEP;
  public
    function Handle(ARequest: TEnderecoRequest) : TValue;
    constructor Create(const AService: IServiceViaCep);
  end;

implementation

{ TConsultaViaCepHandler }

constructor TConsultaViaCepHandler.Create(const AService: IServiceViaCep);
begin
  FService := AService;
end;

function TConsultaViaCepHandler.Handle(ARequest: TEnderecoRequest): TValue;
begin
   Result := FService.Consultar(ARequest);
end;

end.
