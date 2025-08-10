unit UEnderecoBDRepository;

interface

uses
  uIEnderecoBDRepository, uEnderecoRequest, Firedac.Comp.Client, SysUtils,
  uDmMaster;

type
  TEnderecoBDRepository = class(TInterfacedObject, IEnderecoBDRepository)
  private
    FDQuery : TFDQuery;

    procedure InserirDadosCEP(pTableTemp : TFDMemTable);
    procedure CarregarDadosCEP(const pEnderecoRequest : TEnderecoRequest);
    function  ExisteCEPCadastrado(psCEP : string) : boolean;
    function  ExisteEnderecoCadastrado(psCidade, psEstado, psLogradouro : string) : boolean;

  end;

implementation

{ TEnderecoBDRepository }

procedure TEnderecoBDRepository.CarregarDadosCEP(const pEnderecoRequest : TEnderecoRequest);
begin
  dmMaster.qryPrincipal.Close;
  dmMaster.qryPrincipal.SQL.Clear;
  dmMaster.qryPrincipal.SQL.Add('SELECT ED.CODIGO, ED.CEP, ED.LOGRADOURO, ED.COMPLEMENTO, ED.BAIRRO, ED.LOCALIDADE, ED.UF ');
  dmMaster.qryPrincipal.SQL.Add('FROM ENDERECO ED ');
  dmMaster.qryPrincipal.SQL.Add('ORDER BY CODIGO DESC');
  dmMaster.qryPrincipal.Open;
end;



function TEnderecoBDRepository.ExisteCEPCadastrado(psCEP : string): boolean;
begin
  dmMaster.qryPrincipal.Close;
  dmMaster.qryPrincipal.SQL.Clear;
  dmMaster.qryPrincipal.SQL.Add('SELECT 1 FROM ENDERECO ED WHERE CEP=:CEP');
  dmMaster.qryPrincipal.ParamByName('CEP').AsString := psCEP;
  dmMaster.qryPrincipal.Open;

  result := not dmMaster.qryPrincipal.IsEmpty;
end;

function TEnderecoBDRepository.ExisteEnderecoCadastrado(psCidade, psEstado,
  psLogradouro: string): boolean;
begin
  dmMaster.qryPrincipal.Close;
  dmMaster.qryPrincipal.SQL.Clear;
  dmMaster.qryPrincipal.SQL.Add('SELECT COUNT(*) AS CO FROM ENDERECO ED ');
  dmMaster.qryPrincipal.SQL.Add('WHERE UPPER(LOCALIDADE)=:LOCALIDADE');
  dmMaster.qryPrincipal.SQL.Add('AND UPPER(UF)=:UF');
  dmMaster.qryPrincipal.SQL.Add('AND UPPER(LOGRADOURO)=:LOGRADOURO');
  dmMaster.qryPrincipal.ParamByName('LOCALIDADE').AsString := psCidade;
  dmMaster.qryPrincipal.ParamByName('UF').AsString := psEstado;
  dmMaster.qryPrincipal.ParamByName('LOGRADOURO').AsString := psLogradouro;
  dmMaster.qryPrincipal.Open;

  result := dmMaster.qryPrincipal.FieldByName('CO').AsInteger > 0;
end;

procedure TEnderecoBDRepository.InserirDadosCEP(pTableTemp : TFDMemTable);
begin
  dmMaster.qryPrincipal.Close;
  dmMaster.qryPrincipal.SQL.Clear;
  dmMaster.qryPrincipal.SQL.Add('UPDATE OR INSERT INTO ENDERECO (CEP, LOGRADOURO, COMPLEMENTO, BAIRRO, LOCALIDADE, UF)');
  dmMaster.qryPrincipal.SQL.Add('VALUES (:CEP, :LOGRADOURO, :COMPLEMENTO, :BAIRRO, :LOCALIDADE, :UF)');
  dmMaster.qryPrincipal.SQL.Add('MATCHING (CEP);');
  dmMaster.qryPrincipal.ParamByName('CEP').AsString := pTableTemp.FieldByName('CEP').AsString;
  dmMaster.qryPrincipal.ParamByName('LOGRADOURO').AsString :=  pTableTemp.FieldByName('LOGRADOURO').AsString;
  dmMaster.qryPrincipal.ParamByName('COMPLEMENTO').AsString := pTableTemp.FieldByName('COMPLEMENTO').AsString;
  dmMaster.qryPrincipal.ParamByName('BAIRRO').AsString := pTableTemp.FieldByName('BAIRRO').AsString;
  dmMaster.qryPrincipal.ParamByName('LOCALIDADE').AsString := pTableTemp.FieldByName('LOCALIDADE').AsString;
  dmMaster.qryPrincipal.ParamByName('UF').AsString := pTableTemp.FieldByName('UF').AsString;
  dmMaster.qryPrincipal.Execute;
end;

end.
