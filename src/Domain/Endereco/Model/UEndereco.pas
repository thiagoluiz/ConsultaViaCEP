unit UEndereco;

interface

uses
  System.SysUtils;

type
  TEndereco = class
  private
    FCEP: string;
    FLogradouro: string;
    FComplemento: string;
    FBairro: string;
    FLocalidade: string;
    FUF: string;
  public
    property CEP: string read FCEP write FCEP;
    property Logradouro: string read FLogradouro write FLogradouro;
    property Complemento: string read FComplemento write FComplemento;
    property Bairro: string read FBairro write FBairro;
    property Localidade: string read FLocalidade write FLocalidade;
    property UF: string read FUF write FUF;

    function ToString: string; override;
  end;

implementation

{ TEndereco }

function TEndereco.ToString: string;
begin
  Result := Format('%s - %s - %s/%s', [FLogradouro, FBairro, FLocalidade, FUF]);
end;

end.
