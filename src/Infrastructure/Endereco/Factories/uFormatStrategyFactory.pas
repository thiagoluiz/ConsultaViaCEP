unit uFormatStrategyFactory;

interface

uses
  uIFormatoStrategy,
  uJsonFormatoStrategy,
  uXmlFormatoStrategy,
  uFormatoRetornoArquivoEnum,
  System.JSON, Xml.XMLIntf, System.SysUtils;

type
  TFormatStrategyFactory = class
  public
    class function CreateJsonStrategy(Formato: TFormatoRetornoArquivoEnum): IFormatoStrategy<TJSONArray>;
    class function CreateXmlStrategy(Formato: TFormatoRetornoArquivoEnum): IFormatoStrategy<IXMLDocument>;
  end;

implementation

{ TFormatStrategyFactory }

class function TFormatStrategyFactory.CreateJsonStrategy(Formato: TFormatoRetornoArquivoEnum): IFormatoStrategy<TJSONArray>;
begin
  case Formato of
    fraJSON: Result := TJsonFormatoStrategy.Create;
  else
    raise Exception.Create('Formato não suportado para JSON.');
  end;
end;

class function TFormatStrategyFactory.CreateXmlStrategy(Formato: TFormatoRetornoArquivoEnum): IFormatoStrategy<IXMLDocument>;
begin
  case Formato of
    fraXML: Result := TXmlFormatoStrategy.Create;
  else
    raise Exception.Create('Formato não suportado para XML.');
  end;
end;

end.

