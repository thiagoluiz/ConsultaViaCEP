unit uContainer;

interface

uses
  Spring.Container,
  uIServiceViaCep,
  uServiceViaCep,
  uIEnderecoWebViacepRepository,
  uEnderecoWebViaCEPRepository,
  uiViacepCadastroController,
  uViacepCadastroController,
  uiEnderecoBDRepository,
  uEnderecoBDRepository;

procedure RegisterDependencies;

implementation

procedure RegisterDependencies;
begin
  GlobalContainer.RegisterType<IEnderecoWebViacepRepository, TEnderecoWebViacepRepository>;
  GlobalContainer.RegisterType<IEnderecoBDRepository, TEnderecoBDRepository>;
  GlobalContainer.RegisterType<IServiceViaCep, TServiceViaCep>;
  GlobalContainer.RegisterType<IViacepCadastroController, TViaCEPCadastroController>;
  GlobalContainer.Build;
end;

end.

