unit uXMLFormatoStrategy;

interface

uses
  Xml.XMLDoc, Xml.XMLIntf, uEndereco, uIFormatoStrategy;

type
   TXmlFormatoStrategy = class(TInterfacedObject, IFormatoStrategy<IXMLDocument>)
  public
    function Parse(const AContent: string):  IXMLDocument;
  end;

implementation

{ TXmlFormatStrategy }

function TXmlFormatoStrategy.Parse(const AContent: string):  IXMLDocument;
var
  XMLDoc: IXMLDocument;
begin
  Result := TXMLDocument.Create(nil);
  Result.LoadFromXML(AContent);
  Result.Active := True;
end;

end.
