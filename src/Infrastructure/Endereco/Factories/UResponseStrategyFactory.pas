unit UResponseStrategyFactory;

interface

uses
  System.JSON, Xml.XMLIntf, uIResponseStrategy, uFormatoRetornoArquivoEnum;

type
  TResponseStrategyFactory = class
  public
    class function CreateJsonStrategy: IResponseStrategy<TJSONArray>;
    class function CreateXmlStrategy:  IResponseStrategy<IXMLDocument>;
  end;

implementation

uses
  uResponseJSONStrategy, UIResponseXMLStrategy;

{ TResponseStrategyFactory }



{ TResponseStrategyFactory }

class function TResponseStrategyFactory.CreateJsonStrategy: IResponseStrategy<TJSONArray>;
begin
  Result := TJSONResponseStrategy.Create;
end;

class function TResponseStrategyFactory.CreateXmlStrategy: IResponseStrategy<IXMLDocument>;
begin
  Result := TResponseXMLStrategy.Create;
end;

end.
