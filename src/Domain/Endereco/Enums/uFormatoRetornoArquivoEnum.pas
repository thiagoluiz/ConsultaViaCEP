unit uFormatoRetornoArquivoEnum;

interface

type
  TFormatoRetornoArquivoEnum = (fraJSON, fraXML);

  function ToStringFormato(const Formato: TFormatoRetornoArquivoEnum): string;
  function FromStringFormato(const Value: string): TFormatoRetornoArquivoEnum;

implementation

uses
  System.SysUtils;

function ToStringFormato(const Formato: TFormatoRetornoArquivoEnum): string;
begin
  case Formato of
    fraJSON: Result := 'json';
    fraXML: Result := 'xml';
  end;
end;

function FromStringFormato(const Value: string): TFormatoRetornoArquivoEnum;
begin
  if SameText(Value, 'json') then
    Result := fraJSON
  else if SameText(Value, 'xml') then
    Result := fraXML
end;

end.
