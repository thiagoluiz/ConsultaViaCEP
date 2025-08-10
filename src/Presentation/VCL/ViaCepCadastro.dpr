program ViaCepCadastro;

uses
  Vcl.Forms,
  ufrmPrincipal in 'ufrmPrincipal.pas' {frmPrincipal},
  Vcl.Themes,
  Vcl.Styles,
  uEnderecoResponse in '..\..\Application\Endereco\Responses\uEnderecoResponse.pas',
  uContainer in '..\..\Ioc\uContainer.pas',
  uIEnderecoMapper in '..\..\Domain\Endereco\Interfaces\uIEnderecoMapper.pas',
  uConverteObjeto in '..\..\Utils\uConverteObjeto.pas',
  uJsonEnderecoMapper in '..\..\Infrastructure\Endereco\Mappers\uJsonEnderecoMapper.pas',
  uXmlEnderecoMapper in '..\..\Infrastructure\Endereco\Mappers\uXmlEnderecoMapper.pas',
  uFuncoesGerais in '..\..\Utils\uFuncoesGerais.pas',
  udmMaster in 'udmMaster.pas' {dmMaster: TDataModule},
  uViacepCadastroController in 'uViacepCadastroController.pas',
  uIViacepCadastroController in 'uIViacepCadastroController.pas',
  UIResponseStrategy in '..\..\Infrastructure\Endereco\Strategies\UIResponseStrategy.pas',
  UResponseJSONStrategy in '..\..\Infrastructure\Endereco\Strategies\UResponseJSONStrategy.pas',
  UIResponseXMLStrategy in '..\..\Infrastructure\Endereco\Strategies\UIResponseXMLStrategy.pas',
  UResponseStrategyFactory in '..\..\Infrastructure\Endereco\Factories\UResponseStrategyFactory.pas',
  uIEnderecoBDRepository in '..\..\Domain\Endereco\Interfaces\Repositories\uIEnderecoBDRepository.pas',
  UEnderecoBDRepository in '..\..\Infrastructure\Endereco\Repository\UEnderecoBDRepository.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Silver');
  RegisterDependencies;
  Application.CreateForm(TdmMaster, dmMaster);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
