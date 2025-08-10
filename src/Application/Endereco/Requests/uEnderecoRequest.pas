unit uEnderecoRequest;

interface

uses
  uFormatoRetornoArquivoEnum, uTipoConsultaEnum;

type
  TEnderecoRequest = class
  private
    FpsEstado: string;
    FpsCidade: string;
    FpsLogradouro: string;
    FpsCEP: string;
    FpeFormato: TFormatoRetornoArquivoEnum;
    FpeTipoConsulta: TTipoConsultaEnum;
    procedure SetpsEstado(const Value: string);
    procedure SetpsCidade(const Value: string);
    procedure SetpsLogradouro(const Value: string);
    procedure SetpsCEP(const Value: string);
    procedure SetpeFormato(const Value: TFormatoRetornoArquivoEnum);
    procedure SetpeTipoConsulta(const Value: TTipoConsultaEnum);
  public
    property psCEP : string read FpsCEP write SetpsCEP;
    property psEstado : string read FpsEstado write SetpsEstado;
    property psCidade : string read FpsCidade write SetpsCidade;
    property psLogradouro : string read FpsLogradouro write SetpsLogradouro;
    property peFormato : TFormatoRetornoArquivoEnum read FpeFormato write SetpeFormato;
    property peTipoConsulta : TTipoConsultaEnum read FpeTipoConsulta write SetpeTipoConsulta;
  End;


implementation

{ TEnderecoRequest }

procedure TEnderecoRequest.SetpeFormato(
  const Value: TFormatoRetornoArquivoEnum);
begin
  FpeFormato := Value;
end;

procedure TEnderecoRequest.SetpeTipoConsulta(const Value: TTipoConsultaEnum);
begin
  FpeTipoConsulta := Value;
end;

procedure TEnderecoRequest.SetpsCEP(const Value: string);
begin
  FpsCEP := Value;
end;

procedure TEnderecoRequest.SetpsCidade(const Value: string);
begin
  FpsCidade := Value;
end;

procedure TEnderecoRequest.SetpsLogradouro(const Value: string);
begin
  FpsLogradouro := Value;
end;

procedure TEnderecoRequest.SetpsEstado(const Value: string);
begin
  FpsEstado := Value;
end;

end.
