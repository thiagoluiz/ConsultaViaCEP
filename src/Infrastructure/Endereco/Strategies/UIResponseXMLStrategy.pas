unit UIResponseXMLStrategy;

interface

uses
  System.Rtti, System.SysUtils, Xml.XMLIntf, Xml.XMLDoc, UIResponseStrategy;

type
  TResponseXMLStrategy = class(TInterfacedObject, IResponseStrategy<IXMLDocument>)
  public
    function Parse(const AValue: TValue): IXMLDocument;
  end;

implementation

{ TResponseXMLStrategy }

function TResponseXMLStrategy.Parse(const AValue: TValue): IXMLDocument;
begin
  result := AValue.AsType<IXMLDocument>;
end;

end.
