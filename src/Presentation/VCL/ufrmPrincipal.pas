unit ufrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Vcl.DBCtrls,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Mask, Data.DB, Spring.Container.Common,
  Spring.Container, uspConsultaViaCEP, uContainer, uIServiceViaCep,
  uFormatoRetornoArquivoEnum, System.JSON, Xml.XMLIntf, uIEnderecoMapper,
  uConverteObjeto, uEndereco, uFuncoesGerais, uTipoConsultaEnum, Vcl.Grids,
  Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.RTTI, Spring.Services, uEnderecoRequest, uiViacepCadastroController,
  FireDAC.Stan.StorageXML, FireDAC.Stan.StorageJSON, REST.Response.Adapter,
  uIEnderecoBDRepository;

type
  TfrmPrincipal = class(TForm)
    statusBarPrincipal: TStatusBar;
    pnlDadosEndereco: TPanel;
    dbNavEnderecos: TDBNavigator;
    gbDadosPesquisa: TGroupBox;
    edtLogradouro: TEdit;
    lblLogradouro: TLabel;
    edtCidade: TEdit;
    lblLocalidade: TLabel;
    lblUF: TLabel;
    edtUF: TEdit;
    mskedtCEP: TMaskEdit;
    lblCEP: TLabel;
    rgConsultaPor: TRadioGroup;
    rgResultadoConsulta: TRadioGroup;
    btnConsultar: TBitBtn;
    gbConsultasRealizadas: TGroupBox;
    DBGrid1: TDBGrid;
    dsPrincipal: TDataSource;
    FDStanStorageJSONLink: TFDStanStorageJSONLink;
    FDStanStorageXMLLink: TFDStanStorageXMLLink;
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure btnConsultarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FViaCepCadastroController : IViaCepCadastroController;
    function ObterEnderecoInformado: TEnderecoRequest;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses udmMaster;

procedure TfrmPrincipal.btnConsultarClick(Sender: TObject);
var
  EnderecoInformado: TEnderecoRequest;
begin
  EnderecoInformado := ObterEnderecoInformado;
  try
    FViaCepCadastroController.ValidarCampos(EnderecoInformado);
    FViaCepCadastroController.ConfigurarComponenteConsulta(EnderecoInformado, DmMaster.spViaCEP);
    FViaCepCadastroController.ConsultarCEP(EnderecoInformado);
  finally
    EnderecoInformado.Free;
  end;
end;

procedure TfrmPrincipal.EditKeyPress(Sender: TObject; var Key: Char);
begin
  TrocaTabPorEnter(Key);
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  FViaCepCadastroController := ServiceLocator.GetService<IViacepCadastroController>;
  DmMaster.spViaCEP.InjectService(GlobalContainer.Resolve<IServiceViaCep>);
  dmMaster.qryPrincipal.Open;
end;

function TfrmPrincipal.ObterEnderecoInformado: TEnderecoRequest;
begin
  Result := TEnderecoRequest.Create;
  Result.psCEP         := mskedtCEP.Text;
  Result.psEstado      := edtUF.Text;
  Result.psCidade      := edtCidade.Text;
  Result.psLogradouro  := edtLogradouro.Text;
  Result.peTipoConsulta := TTipoConsultaEnum(rgConsultaPor.ItemIndex);
  Result.peFormato := TFormatoRetornoArquivoEnum(rgResultadoConsulta.ItemIndex);
end;


end.
