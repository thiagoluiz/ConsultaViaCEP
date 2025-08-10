unit uViacepCadastroController;

interface

uses
  SysUtils, uIViacepCadastroController, uspConsultaViaCEP,
  uFormatoRetornoArquivoEnum, uEnderecoRequest, uDmMaster,
  System.JSON, Xml.XMLIntf, Firedac.Comp.Client, System.Rtti,
  uIEnderecoBDRepository, Spring.Container.Common, Winapi.Windows,
  Spring.Container, Spring.Services, Vcl.Dialogs, Consts;

type
  TViaCEPCadastroController = class(TInterfacedObject, IViacepCadastroController)
  private
    FEnderecoBDRepository : IEnderecoBDRepository;

    procedure ValidarCampos(poEnderecoRequest : TEnderecoRequest);
    procedure ValidaPreenchimentoCEP(poEnderecoRequest : TEnderecoRequest);
    procedure ValidaPreenchimentoEnderecoCompleto(poEnderecoRequest : TEnderecoRequest);
    procedure ConfigurarComponenteConsulta(const pEnderecoRequest: TEnderecoRequest; const pViacepComponent : TspViaCepComponent);
    procedure CarregarNoMemTable(const Objeto: TValue; const AMemTable: TFDMemTable);
    procedure ConsultarCEP(const pEnderecoRequest : TEnderecoRequest);
    procedure ValidarCEPExiste(pMemTable : TFDMemTable);
    procedure ValidarEnderecoExiste(pMemTable: TFDMemTable);
    function  ValidarEnderecoCadastradoNaBase(psEstado, psCidade, psLogradouro: string) : boolean;
  end;

implementation

uses
  uTipoConsultaEnum, uResponseStrategyFactory, UIResponseStrategy,
  uFuncoesGerais, Data.DB;

{ TViaCEPCadastroController }


procedure TViaCEPCadastroController.CarregarNoMemTable(const Objeto: TValue; const AMemTable: TFDMemTable);
var
  JsonStrategy: IResponseStrategy<TJSONArray>;
  XmlStrategy:  IResponseStrategy<IXMLDocument>;
  JsonArray: TJSONArray;
  XmlDoc: IXMLDocument;
begin
  if Objeto.IsType<TJSONArray> then
  begin
    JsonStrategy := TResponseStrategyFactory.CreateJsonStrategy;
    JsonArray := JsonStrategy.Parse(Objeto);
    CarregarJSONNoMemTable(JsonArray, AMemTable);
  end
  else
  begin
    XmlStrategy := TResponseStrategyFactory.CreateXmlStrategy;
    XmlDoc := XmlStrategy.Parse(Objeto);
    CarregarXMLNoMemTable(XmlDoc.XML.Text, AMemTable);
  end;
end;

procedure TViaCEPCadastroController.ConfigurarComponenteConsulta(
  const pEnderecoRequest: TEnderecoRequest;
  const pViacepComponent: TspViaCepComponent);
begin
  pViacepComponent.ConsultarPorEnderecoCompleto := pEnderecoRequest.peTipoConsulta = tcPorEnderecoCompleto;
  pViacepComponent.CEP := pEnderecoRequest.psCEP;
  pViacepComponent.FormatoRetorno := pEnderecoRequest.peFormato;

  if pViacepComponent.ConsultarPorEnderecoCompleto then
  begin
    pViacepComponent.Logradouro := pEnderecoRequest.psLogradouro;
    pViacepComponent.Estado     := pEnderecoRequest.psEstado;
    pViacepComponent.Cidade     := pEnderecoRequest.psCidade;
  end;
end;

procedure TViaCEPCadastroController.ConsultarCEP(const pEnderecoRequest : TEnderecoRequest);
var
  RetornoConsulta : TValue;
  sCEP : string;
begin
  FEnderecoBDRepository := ServiceLocator.GetService<IEnderecoBDRepository>;
  if (ValidarEnderecoCadastradoNaBase(pEnderecoRequest.psEstado, pEnderecoRequest.psCidade, pEnderecoRequest.psLogradouro)) then
    if (MessageDlg('Deseja que seja exibido o endereço cadastrado na base?', TMsgDlgType.mtConfirmation,[TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],0) = idYes) then
    begin
      FEnderecoBDRepository.CarregarDadosCEP(pEnderecoRequest);
      Exit;
    end;

  RetornoConsulta := DmMaster.spViaCEP.Buscar;
  CarregarNoMemTable(RetornoConsulta, dmMaster.FDMemTablePrincipal);

  case pEnderecoRequest.peTipoConsulta of
    tcPorCep: ValidarCEPExiste(dmMaster.FDMemTablePrincipal);
    tcPorEnderecoCompleto : ValidarEnderecoExiste(dmMaster.FDMemTablePrincipal);
  end;

  dmMaster.FDMemTablePrincipal.First;
  While not (dmMaster.FDMemTablePrincipal.Eof) do
  begin
    sCEP := dmMaster.FDMemTablePrincipal.FieldByName('CEP').AsString;

    if not FEnderecoBDRepository.ExisteCEPCadastrado(sCEP) then
      FEnderecoBDRepository.InserirDadosCEP(dmMaster.FDMemTablePrincipal);

    dmMaster.FDMemTablePrincipal.Next;
  end;

  FEnderecoBDRepository.CarregarDadosCEP(pEnderecoRequest);
end;


procedure TViaCEPCadastroController.ValidaPreenchimentoCEP(poEnderecoRequest : TEnderecoRequest);
begin
  if (SomenteNumeros(poEnderecoRequest.psCEP) = EmptyStr) then
    raise Exception.Create('Informe o CEP');

end;

procedure TViaCEPCadastroController.ValidaPreenchimentoEnderecoCompleto(poEnderecoRequest : TEnderecoRequest);
begin
  if (poEnderecoRequest.psLogradouro = EmptyStr) then
    raise Exception.Create('Informe o Logradouro');

  if (poEnderecoRequest.psEstado = EmptyStr) then
    raise Exception.Create('Informe o Estado');

  if (poEnderecoRequest.psCidade = EmptyStr) then
    raise Exception.Create('Informe a Cidade');

  if CampoTemMenosDeTresCaracteres(poEnderecoRequest.psLogradouro) then
    raise Exception.Create('Informe corretamente o Logradouro, deve conter pelo menos 3 caracteres');

  if CampoTemMenosDeTresCaracteres(poEnderecoRequest.psCidade) then
    raise Exception.Create('Informe corretamente a Cidade, deve conter pelo menos 3 caracteres');
end;

procedure TViaCEPCadastroController.ValidarCampos(poEnderecoRequest : TEnderecoRequest);
begin
  case poEnderecoRequest.peTipoConsulta of
    tcPorCep: ValidaPreenchimentoCEP(poEnderecoRequest);
    tcPorEnderecoCompleto: ValidaPreenchimentoEnderecoCompleto(poEnderecoRequest);
  end;

end;

procedure TViaCEPCadastroController.ValidarCEPExiste(pMemTable: TFDMemTable);
begin
   if not (pMemTable.FindField('Erro') = nil) then
    raise Exception.Create('O CEP Informado não foi encontrado');
end;

procedure TViaCEPCadastroController.ValidarEnderecoExiste(pMemTable: TFDMemTable);
begin
   if (pMemTable.IsEmpty) or not (pMemTable.FindField('enderecos') = nil) then
    raise Exception.Create('O Endereco Informado não foi encontrado');
end;

function TViaCEPCadastroController.ValidarEnderecoCadastradoNaBase(psEstado, psCidade, psLogradouro: string) : boolean;
begin
  result :=  FEnderecoBDRepository.ExisteEnderecoCadastrado(psCidade, psEstado, psLogradouro);
end;

end.
