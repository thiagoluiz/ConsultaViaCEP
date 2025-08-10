unit uIEnderecoBDRepository;

interface

uses
  Firedac.Comp.Client, uEnderecoRequest;

type
  IEnderecoBDRepository = interface
    procedure InserirDadosCEP(pTableTemp : TFDMemTable);
    procedure CarregarDadosCEP(const pEnderecoRequest : TEnderecoRequest);
    function  ExisteCEPCadastrado(psCEP : string) : boolean;
    function  ExisteEnderecoCadastrado(psCidade, psEstado, psLogradouro : string) : boolean;

  end;

implementation

end.
