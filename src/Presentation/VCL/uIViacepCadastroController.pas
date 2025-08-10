unit uIViacepCadastroController;

interface

uses
  uEnderecoRequest, uspConsultaViaCEP, System.JSON, Firedac.Comp.Client,
  System.RTTI;

type
  IViacepCadastroController = interface
    procedure ValidarCampos(poEndereco : TEnderecoRequest);
    procedure ConfigurarComponenteConsulta(const pEnderecoRequest: TEnderecoRequest; const pViacepComponent : TspViaCepComponent);
    procedure ConsultarCEP(const pEnderecoRequest : TEnderecoRequest);
    procedure CarregarNoMemTable(const Objeto: TValue; const AMemTable: TFDMemTable);
  end;

implementation

end.
