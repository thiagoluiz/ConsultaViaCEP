unit uEnderecoResponse;

interface

type
  TEnderecoResponse = class
  private
    FLogradouro: string;
    FCEP: string;
    FCidade: string;
    FEstado: string;
    FBairro: string;
    FComplemento: string;
    procedure SetCEP(const Value: string);
    procedure SetCidade(const Value: string);
    procedure SetEstado(const Value: string);
    procedure SetLogradouro(const Value: string);
    procedure SetBairro(const Value: string);
    procedure SetComplemento(const Value: string);
  public
    property CEP: string read FCEP write SetCEP;
    property Logradouro : string read FLogradouro write SetLogradouro;
    property Complemento : string read FComplemento write SetComplemento;
    property Bairro : string read FBairro write SetBairro;
    property Cidade : string read FCidade write SetCidade;
    property Estado : string read FEstado write SetEstado;
  end;

implementation

{ TEnderecoResponse }

procedure TEnderecoResponse.SetBairro(const Value: string);
begin
  FBairro := Value;
end;

procedure TEnderecoResponse.SetCEP(const Value: string);
begin
  FCEP := Value;
end;

procedure TEnderecoResponse.SetCidade(const Value: string);
begin
  FCidade := Value;
end;

procedure TEnderecoResponse.SetComplemento(const Value: string);
begin
  FComplemento := Value;
end;

procedure TEnderecoResponse.SetEstado(const Value: string);
begin
  FEstado := Value;
end;

procedure TEnderecoResponse.SetLogradouro(const Value: string);
begin
  FLogradouro := Value;
end;

end.
